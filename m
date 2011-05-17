Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932135Ab1EQRhz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 13:37:55 -0400
Received: from outmail013.snc4.facebook.com ([66.220.144.145]:62403 "EHLO
	mx-out.facebook.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755409Ab1EQRhu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 13:37:50 -0400
From: Arun Sharma <asharma@fb.com>
To: Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Arun Sharma <asharma@fb.com>
Subject: [PATCH 5/6] kbuild: Append RPM release to $KERNELRELEASE
Date: Tue, 17 May 2011 10:36:18 -0700
Message-Id: <1305653779-3445-5-git-send-email-asharma@fb.com>
X-Mailer: git-send-email 1.7.4
In-Reply-To: <1305653779-3445-1-git-send-email-asharma@fb.com>
References: <1305653779-3445-1-git-send-email-asharma@fb.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide the same consistency as distributor kernels.
uname -r matches RPM name (includes the release)

Glossary:

KERNELRELEASE = what users see
___KERNELRELEASE = KERNELRELEASE without RPM release
__KERNELRELEASE = ___KERNELRELEASE with s/-/_/g

Signed-off-by: Arun Sharma <asharma@fb.com>
---
 Makefile                 |    9 ++++++---
 scripts/package/Makefile |    2 +-
 scripts/package/mkspec   |    2 +-
 3 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/Makefile b/Makefile
index 28820f7..90d45f4 100644
--- a/Makefile
+++ b/Makefile
@@ -367,11 +367,14 @@ KBUILD_AFLAGS_MODULE  := -DMODULE
 KBUILD_CFLAGS_MODULE  := -DMODULE
 KBUILD_LDFLAGS_MODULE := -T $(srctree)/scripts/module-common.lds
 
-# Read KERNELRELEASE from include/config/kernel.release (if it exists)
-KERNELRELEASE = $(shell cat include/config/kernel.release 2> /dev/null)
+# Read ___KERNELRELEASE from include/config/kernel.release (if it exists)
+___KERNELRELEASE = $(shell cat include/config/kernel.release 2> /dev/null)
+# Append the release version only once. 
+# Note: .version could change during the build.
+KERNELRELEASE ?= $(___KERNELRELEASE)-$(shell /bin/sh scripts/mkversion)
 KERNELVERSION = $(VERSION).$(PATCHLEVEL).$(SUBLEVEL)$(EXTRAVERSION)
 
-export VERSION PATCHLEVEL SUBLEVEL KERNELRELEASE KERNELVERSION
+export VERSION PATCHLEVEL SUBLEVEL KERNELRELEASE KERNELVERSION ___KERNELRELEASE
 export ARCH SRCARCH CONFIG_SHELL HOSTCC HOSTCFLAGS CROSS_COMPILE AS LD CC
 export CPP AR NM STRIP OBJCOPY OBJDUMP
 export MAKE AWK GENKSYMS INSTALLKERNEL PERL UTS_MACHINE
diff --git a/scripts/package/Makefile b/scripts/package/Makefile
index 1b7eaea..0ec687b 100644
--- a/scripts/package/Makefile
+++ b/scripts/package/Makefile
@@ -26,7 +26,7 @@ RPM := $(shell if [ -x "/usr/bin/rpmbuild" ]; then echo rpmbuild; \
 	           else echo rpm; fi)
 
 # Remove hyphens since they have special meaning in RPM filenames
-KERNELPATH := kernel-$(subst -,_,$(KERNELRELEASE))
+KERNELPATH := kernel-$(subst -,_,$(___KERNELRELEASE))
 MKSPEC     := $(srctree)/scripts/package/mkspec
 PREV       := set -e; cd ..;
 
diff --git a/scripts/package/mkspec b/scripts/package/mkspec
index bf215c5..9a8c2fa 100755
--- a/scripts/package/mkspec
+++ b/scripts/package/mkspec
@@ -22,7 +22,7 @@ if [ "`grep CONFIG_DRM=y .config | cut -f2 -d\=`" = "y" ]; then
 fi
 
 PROVIDES="$PROVIDES kernel-$KERNELRELEASE"
-__KERNELRELEASE=`echo $KERNELRELEASE | sed -e "s/-/_/g"`
+__KERNELRELEASE=`echo $___KERNELRELEASE | sed -e "s/-/_/g"`
 
 echo "Name: kernel"
 echo "Summary: The Linux Kernel"
-- 
1.7.4

