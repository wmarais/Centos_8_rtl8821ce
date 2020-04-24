#!/bin/bash

if [[ $EUID -ne 0 ]]; then
  echo "You must run this with superuser priviliges.  Try \"sudo ./dkms-install.sh\"" 2>&1
  exit 1
else
  echo "About to run dkms install steps..."
fi

DRV_NAME=rtl8821ce
DRV_VERSION=v5.5.2_34066.20200325

cp -r . /usr/src/${DRV_NAME}-${DRV_VERSION}

dkms add -m ${DRV_NAME} -v ${DRV_VERSION}
dkms build -m ${DRV_NAME} -v ${DRV_VERSION}
if [ $# -eq 2 ]; then
  /usr/src/kernels/4.18.0-147.8.1.el8_1.x86_64/scripts/sign-file sha256 $1 $2 ${DRV_NAME}
fi
dkms install -m ${DRV_NAME} -v ${DRV_VERSION}
RESULT=$?

echo "Finished running dkms install steps."

exit $RESULT
