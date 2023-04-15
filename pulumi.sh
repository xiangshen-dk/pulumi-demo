#!/bin/bash

# exit if a command returns a non-zero exit code and also print the commands and their args as they are executed.
set -e -x

# Download and install required tools.
# pulumi
curl -L https://get.pulumi.com/ | bash
export PATH=$PATH:$HOME/.pulumi/bin

# Restore npm dependencies for our infra app.
yarn install

# Login into pulumi using a GCS bucket as backend.
# Set the PULUMI_ACCESS_TOKEN environment variable if use Pulumi Cloud.
pulumi login gs://pulumi-$PROJECT_ID

# Select the appropriate stack.
pulumi stack select $STACK

case $BUILD_TYPE in
  PullRequest)
      pulumi preview
    ;;
  *)
      pulumi up --yes
    ;;
esac
