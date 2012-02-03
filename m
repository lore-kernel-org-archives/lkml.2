Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755990Ab2BCXnW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 18:43:22 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:48905 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754022Ab2BCXnU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 18:43:20 -0500
From: "Luis R. Rodriguez" <mcgrof@frijolero.org>
To: mcgrof@frijolero.org
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        kernel-team@lists.ubuntu.com, hauke@hauke-m.de
Subject: [PATCH] compat: add compat kernel checker and downloader
Date: Fri,  3 Feb 2012 15:43:14 -0800
Message-Id: <1328312594-31934-1-git-send-email-mcgrof@frijolero.org>
X-Mailer: git-send-email 1.7.4.15.g7811d
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds get-compat-kernels, a utility that is intended
to be Linux distribution agnostic that downloads and installs
all kernel headers for all supported kernel releases of compat.
You also have the option of specifying you want to also install
the actual kernel image (get-compat-kernels -i).

We start off by adding support for Ubuntu on x86_64 as that
is what a few of us maintaining compat and compat-wireless run.
Just for kernel headers (default run of get-compat-kernels),
you'll need currently 205 M of hard drive space.

Once done with running get-compat-kernels, you can then
start running ckmake to verify your compat kernel changes
won't bust compilation against any known supported kernel.

I'd like to start requiring runs against this script for
patch submissions. Eventually we can try to add the same
runs against compat-wireless so we can verify integrity
against compilation for different kernel versions.

Support for different Linux distributios is welcomed.

Debug log goes out to ckmake.log

Example output:

mcgrof@tux ~/compat (git::master)$ ckmake
Trying kernel                  3.3.0-030300rc2-generic  [OK]
Trying kernel                     3.2.2-030202-generic  [OK]
Trying kernel                    3.1.10-030110-generic  [OK]
Trying kernel                    3.0.18-030018-generic  [OK]
Trying kernel                  2.6.39-02063904-generic  [OK]
Trying kernel                         2.6.38-8-generic  [OK]
Trying kernel                        2.6.38-13-generic  [OK]
Trying kernel                        2.6.38-12-generic  [OK]
Trying kernel                        2.6.38-11-generic  [OK]
Trying kernel                        2.6.38-10-generic  [OK]
Trying kernel                  2.6.38-02063808-generic  [OK]
Trying kernel                  2.6.37-02063706-generic  [OK]
Trying kernel                  2.6.36-02063604-generic  [OK]
Trying kernel                  2.6.35-02063512-generic  [OK]
Trying kernel                  2.6.34-02063410-generic  [OK]
Trying kernel                  2.6.33-02063305-generic  [OK]
Trying kernel                  2.6.32-02063255-generic  [OK]
Trying kernel                        2.6.31-22-generic  [OK]
Trying kernel                  2.6.31-02063113-generic  [OK]
Trying kernel                  2.6.30-02063010-generic  [OK]
Trying kernel                  2.6.29-02062906-generic  [OK]
Trying kernel                  2.6.28-02062810-generic  [OK]
Trying kernel                    2.6.27-020627-generic  [OK]
Trying kernel                    2.6.26-020626-generic  [OK]
Trying kernel                    2.6.25-020625-generic  [OK]
Trying kernel                    2.6.24-020624-generic  [OK]

Cc: kernel-team@lists.ubuntu.com
Signed-off-by: Luis R. Rodriguez <mcgrof@frijolero.org>
---
 .gitignore             |    1 +
 bin/ckmake             |   65 ++++++++++++++++++++
 bin/get-compat-kernels |  154 ++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 220 insertions(+), 0 deletions(-)
 create mode 100755 bin/ckmake
 create mode 100755 bin/get-compat-kernels

diff --git a/.gitignore b/.gitignore
index 0f4ebc6..e27f6c2 100644
--- a/.gitignore
+++ b/.gitignore
@@ -2,3 +2,4 @@
 Module.symvers
 module.order
 .pc
+ckmake.log
diff --git a/bin/ckmake b/bin/ckmake
new file mode 100755
index 0000000..4d45fb9
--- /dev/null
+++ b/bin/ckmake
@@ -0,0 +1,65 @@
+#!/bin/bash
+#
+# Copyright (C) 2012, Luis R. Rodriguez <mcgrof@frijolero.org>
+# Copyright (C) 2012, Hauke Mehrtens <hauke@hauke-m.de>
+#
+# This program is free software; you can redistribute it and/or modify
+# it under the terms of the GNU General Public License version 2 as
+# published by the Free Software Foundation.
+#
+# You can use this to compile a module accross all installed kernels
+# found. This relies on distribution specific kernels, but can handle
+# your own custom list of target kernels. Log is setnt to LOG variable.
+
+# Pretty colors
+GREEN="\033[01;32m"
+YELLOW="\033[01;33m"
+NORMAL="\033[00m"
+BLUE="\033[34m"
+RED="\033[31m"
+PURPLE="\033[35m"
+CYAN="\033[36m"
+UNDERLINE="\033[02m"
+
+#export KCFLAGS="-Wno-unused-but-set-variable"
+KERNEL_DIR="/lib/modules"
+KLIBS=""
+LOG="ckmake.log"
+
+LSB_RED_ID=$(/usr/bin/lsb_release -i -s)
+case $LSB_RED_ID in
+"Ubuntu")
+	for i in $(find /lib/modules/ -type d -name \*generic\* | sort -n -r); do
+		KLIBS="$KLIBS $i"
+	done
+	;;
+*)
+	echo -e "Unsupported distribution"
+	exit
+	;;
+esac
+
+nice make clean 2>&1 > $LOG
+
+for i in $KLIBS; do
+	KERNEL=$(basename $i)
+	DIR=${i}/build/
+	echo -e "--------------------------------------------" >> $LOG
+
+	if [[ ! -d $DIR ]]; then
+		continue
+	fi
+
+	echo -en "Trying kernel ${BLUE}" | tee -a $LOG
+	printf "%40s\t" "${KERNEL}" | tee -a $LOG
+	echo -en "${NORMAL}" | tee -a $LOG
+
+	ionice -c 3 nice -n 20 make KLIB=$DIR KLIB_BUILD=$DIR -j6 -Wunused-but-set-variable &>> $LOG
+	if [[ $? -eq 0 ]]; then
+		echo -e "${GREEN}[OK]${NORMAL}" | tee -a $LOG
+	else
+		echo -e "${RED}[FAILED]${NORMAL}" | tee -a $LOG
+	fi
+
+	nice make clean KLIB=$DIR KLIB_BUILD=$DIR 2>&1 >> $LOG
+done
diff --git a/bin/get-compat-kernels b/bin/get-compat-kernels
new file mode 100755
index 0000000..07ac17b
--- /dev/null
+++ b/bin/get-compat-kernels
@@ -0,0 +1,154 @@
+#!/bin/bash
+#
+# Copyright (C) 2012, Luis R. Rodriguez <mcgrof@frijolero.org>
+#
+# This program is free software; you can redistribute it and/or modify
+# it under the terms of the GNU General Public License version 2 as
+# published by the Free Software Foundation.
+#
+# You can use this script to install all mainline kernels used
+# to test compile the Linux kernel compatibility module. You can
+# then use ckmake to cross compile against all supported kernels.
+
+function get_ubuntu_kernels() {
+	KERNELS=""
+
+	KPATH="http://kernel.ubuntu.com/~kernel-ppa/mainline/"
+
+	KERNELS="$KERNELS ${KPATH}/v2.6.24/linux-headers-2.6.24-020624_2.6.24-020624_all.deb"
+	KERNELS="$KERNELS ${KPATH}/v2.6.24/linux-headers-2.6.24-020624-generic_2.6.24-020624_amd64.deb"
+	KERNELS="$KERNELS ${KPATH}/v2.6.24/linux-image-2.6.24-020624-generic_2.6.24-020624_amd64.deb"
+
+	KERNELS="$KERNELS ${KPATH}/v2.6.25/linux-headers-2.6.25-020625_2.6.25-020625_all.deb"
+	KERNELS="$KERNELS ${KPATH}/v2.6.25/linux-headers-2.6.25-020625-generic_2.6.25-020625_amd64.deb"
+	KERNELS="$KERNELS ${KPATH}/v2.6.25/linux-image-2.6.25-020625-generic_2.6.25-020625_amd64.deb"
+
+	KERNELS="$KERNELS ${KPATH}/v2.6.26/linux-headers-2.6.26-020626_2.6.26-020626_all.deb"
+	KERNELS="$KERNELS ${KPATH}/v2.6.26/linux-headers-2.6.26-020626-generic_2.6.26-020626_amd64.deb"
+	KERNELS="$KERNELS ${KPATH}/v2.6.26/linux-image-2.6.26-020626-generic_2.6.26-020626_amd64.deb"
+
+	KERNELS="$KERNELS ${KPATH}/v2.6.27/linux-headers-2.6.27-020627_2.6.27-020627_all.deb"
+	KERNELS="$KERNELS ${KPATH}/v2.6.27/linux-headers-2.6.27-020627-generic_2.6.27-020627_amd64.deb"
+	KERNELS="$KERNELS ${KPATH}/v2.6.27/linux-image-2.6.27-020627-generic_2.6.27-020627_amd64.deb"
+
+	KERNELS="$KERNELS ${KPATH}/v2.6.28.10/linux-headers-2.6.28-02062810_2.6.28-02062810_all.deb"
+	KERNELS="$KERNELS ${KPATH}/v2.6.28.10/linux-headers-2.6.28-02062810-generic_2.6.28-02062810_amd64.deb"
+	KERNELS="$KERNELS ${KPATH}/v2.6.28.10/linux-image-2.6.28-02062810-generic_2.6.28-02062810_amd64.deb"
+
+	KERNELS="$KERNELS ${KPATH}/v2.6.29.6/linux-headers-2.6.29-02062906_2.6.29-02062906_all.deb"
+	KERNELS="$KERNELS ${KPATH}/v2.6.29.6/linux-headers-2.6.29-02062906-generic_2.6.29-02062906_amd64.deb"
+	KERNELS="$KERNELS ${KPATH}/v2.6.29.6/linux-image-2.6.29-02062906-generic_2.6.29-02062906_amd64.deb"
+
+	KERNELS="$KERNELS ${KPATH}/v2.6.30.10/linux-headers-2.6.30-02063010_2.6.30-02063010_all.deb"
+	KERNELS="$KERNELS ${KPATH}/v2.6.30.10/linux-headers-2.6.30-02063010-generic_2.6.30-02063010_amd64.deb"
+	KERNELS="$KERNELS ${KPATH}/v2.6.30.10/linux-image-2.6.30-02063010-generic_2.6.30-02063010_amd64.deb"
+
+	KERNELS="$KERNELS ${KPATH}/v2.6.31.13-karmic/linux-headers-2.6.31-02063113_2.6.31-02063113_all.deb"
+	KERNELS="$KERNELS ${KPATH}/v2.6.31.13-karmic/linux-headers-2.6.31-02063113-generic_2.6.31-02063113_amd64.deb"
+	KERNELS="$KERNELS ${KPATH}/v2.6.31.13-karmic/linux-image-2.6.31-02063113-generic_2.6.31-02063113_amd64.deb"
+
+	KERNELS="$KERNELS ${KPATH}/v2.6.32.55-lucid/linux-headers-2.6.32-02063255_2.6.32-02063255.201201251735_all.deb"
+	KERNELS="$KERNELS ${KPATH}/v2.6.32.55-lucid/linux-headers-2.6.32-02063255-generic_2.6.32-02063255.201201251735_amd64.deb"
+	KERNELS="$KERNELS ${KPATH}/v2.6.32.55-lucid/linux-image-2.6.32-02063255-generic_2.6.32-02063255.201201251735_amd64.deb"
+
+	KERNELS="$KERNELS ${KPATH}/v2.6.33.5-lucid/linux-headers-2.6.33-02063305_2.6.33-02063305_all.deb"
+	KERNELS="$KERNELS ${KPATH}/v2.6.33.5-lucid/linux-headers-2.6.33-02063305-generic_2.6.33-02063305_amd64.deb"
+	KERNELS="$KERNELS ${KPATH}/v2.6.33.5-lucid/linux-image-2.6.33-02063305-generic_2.6.33-02063305_amd64.deb"
+
+	KERNELS="$KERNELS ${KPATH}/v2.6.34.10-maverick/linux-headers-2.6.34-02063410_2.6.34-02063410.201111101535_all.deb"
+	KERNELS="$KERNELS ${KPATH}/v2.6.34.10-maverick/linux-headers-2.6.34-02063410-generic_2.6.34-02063410.201111101535_amd64.deb"
+	KERNELS="$KERNELS ${KPATH}/v2.6.34.10-maverick/linux-image-2.6.34-02063410-generic_2.6.34-02063410.201111101535_amd64.deb"
+
+	KERNELS="$KERNELS ${KPATH}/v2.6.35.13-maverick/linux-headers-2.6.35-02063512_2.6.35-02063512.201111232118_all.deb"
+	KERNELS="$KERNELS ${KPATH}/v2.6.35.13-maverick/linux-headers-2.6.35-02063512-generic_2.6.35-02063512.201111232118_amd64.deb"
+	KERNELS="$KERNELS ${KPATH}/v2.6.35.13-maverick/linux-image-2.6.35-02063512-generic_2.6.35-02063512.201111232118_amd64.deb"
+
+	KERNELS="$KERNELS ${KPATH}/v2.6.36.4-natty/linux-headers-2.6.36-02063604_2.6.36-02063604.201102180911_all.deb"
+	KERNELS="$KERNELS ${KPATH}/v2.6.36.4-natty/linux-headers-2.6.36-02063604-generic_2.6.36-02063604.201102180911_amd64.deb"
+	KERNELS="$KERNELS ${KPATH}/v2.6.36.4-natty/linux-image-2.6.36-02063604-generic_2.6.36-02063604.201102180911_amd64.deb"
+
+	KERNELS="$KERNELS ${KPATH}/v2.6.37.6-natty/linux-headers-2.6.37-02063706_2.6.37-02063706.201103281005_all.deb"
+	KERNELS="$KERNELS ${KPATH}/v2.6.37.6-natty/linux-headers-2.6.37-02063706-generic_2.6.37-02063706.201103281005_amd64.deb"
+	KERNELS="$KERNELS ${KPATH}/v2.6.37.6-natty/linux-image-2.6.37-02063706-generic_2.6.37-02063706.201103281005_amd64.deb"
+
+	KERNELS="$KERNELS ${KPATH}/v2.6.38.8-natty/linux-headers-2.6.38-02063808_2.6.38-02063808.201106040910_all.deb"
+	KERNELS="$KERNELS ${KPATH}/v2.6.38.8-natty/linux-headers-2.6.38-02063808-generic_2.6.38-02063808.201106040910_amd64.deb"
+	KERNELS="$KERNELS ${KPATH}/v2.6.38.8-natty/linux-image-2.6.38-02063808-generic_2.6.38-02063808.201106040910_amd64.deb"
+
+	KERNELS="$KERNELS ${KPATH}/v2.6.39.4-oneiric/linux-headers-2.6.39-02063904_2.6.39-02063904.201108040905_all.deb"
+	KERNELS="$KERNELS ${KPATH}/v2.6.39.4-oneiric/linux-headers-2.6.39-02063904-generic_2.6.39-02063904.201108040905_amd64.deb"
+	KERNELS="$KERNELS ${KPATH}/v2.6.39.4-oneiric/linux-image-2.6.39-02063904-generic_2.6.39-02063904.201108040905_amd64.deb"
+
+	KERNELS="$KERNELS ${KPATH}/v3.0.18-oneiric/linux-headers-3.0.18-030018_3.0.18-030018.201201252135_all.deb"
+	KERNELS="$KERNELS ${KPATH}/v3.0.18-oneiric/linux-headers-3.0.18-030018-generic_3.0.18-030018.201201252135_amd64.deb"
+	KERNELS="$KERNELS ${KPATH}/v3.0.18-oneiric/linux-image-3.0.18-030018-generic_3.0.18-030018.201201252135_amd64.deb"
+
+	KERNELS="$KERNELS ${KPATH}/v3.1.10-precise/linux-headers-3.1.10-030110_3.1.10-030110.201201181135_all.deb"
+	KERNELS="$KERNELS ${KPATH}/v3.1.10-precise/linux-headers-3.1.10-030110-generic_3.1.10-030110.201201181135_amd64.deb"
+	KERNELS="$KERNELS ${KPATH}/v3.1.10-precise/linux-image-3.1.10-030110-generic_3.1.10-030110.201201181135_amd64.deb"
+
+	KERNELS="$KERNELS ${KPATH}/v3.2.2-precise/linux-headers-3.2.2-030202_3.2.2-030202.201201252035_all.deb"
+	KERNELS="$KERNELS ${KPATH}/v3.2.2-precise/linux-headers-3.2.2-030202-generic_3.2.2-030202.201201252035_amd64.deb"
+	KERNELS="$KERNELS ${KPATH}/v3.2.2-precise/linux-image-3.2.2-030202-generic_3.2.2-030202.201201252035_amd64.deb"
+
+	KERNELS="$KERNELS ${KPATH}/v3.3-rc2-precise/linux-headers-3.3.0-030300rc2_3.3.0-030300rc2.201201311735_all.deb"
+	KERNELS="$KERNELS ${KPATH}/v3.3-rc2-precise/linux-headers-3.3.0-030300rc2-generic_3.3.0-030300rc2.201201311735_amd64.deb"
+	KERNELS="$KERNELS ${KPATH}/v3.3-rc2-precise/linux-image-3.3.0-030300rc2-generic_3.3.0-030300rc2.201201311735_amd64.deb"
+
+	for i in $KERNELS; do
+		FILE=$(basename $i)
+		PKG=$(echo $FILE | awk -F"_" '{print $1}')
+
+		echo "$i" | grep image 2>&1 > /dev/null
+		if [[ $? = 0 && $INSTALL_IMAGES != "y" ]]; then
+			continue
+		fi
+
+		if [[ ! -f $FILE ]]; then
+			wget -c $i
+		fi
+	done
+
+	# Let dpkg figure out dependency magic.
+	#
+	# XXX: I tried adding some magic to not install a package if
+	# if its already presently installed but then had to deal
+	# with the dependency mess. I welcome someone else to
+	# figure this out. Running this can come in handy once
+	# a new public kernel gets released.
+	sudo dpkg -i *.deb
+}
+
+function usage() {
+	echo -e "Usage: $0 [ -i ]"
+	echo -e ""
+	echo -e "If you specify [ -i ] you will also download all kernel images and install them"
+}
+
+INSTALL_IMAGES="n"
+
+if [[ $# -gt 1 ]]; then
+	usage
+	exit
+fi
+
+if [[ $# -eq 1 && $1 != "-i" ]]; then
+	usage
+	exit
+fi
+
+if [[ $# -eq 1 && $1 = "-i" ]]; then
+	INSTALL_IMAGES="y"
+fi
+
+
+LSB_RED_ID=$(/usr/bin/lsb_release -i -s)
+case $LSB_RED_ID in
+"Ubuntu")
+	get_ubuntu_kernels
+	;;
+*)
+	echo -e "Unsupported distribution"
+	exit
+	;;
+esac
-- 
1.7.4.15.g7811d

