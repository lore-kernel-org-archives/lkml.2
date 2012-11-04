Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752529Ab2KDHcy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2012 02:32:54 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:58494 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752128Ab2KDHcv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2012 02:32:51 -0500
From: Adam Lee <adam8157@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Michal Marek <mmarek@suse.cz> (maintainer:KERNEL BUILD + fi...),
        linux-kbuild@vger.kernel.org (open list:KERNEL BUILD + fi...)
Subject: [PATCH] kconfig: fix the failure of `make rpm-pkg` after localversion file changed
Date: Sun,  4 Nov 2012 15:32:41 +0800
Message-Id: <1352014361-21159-1-git-send-email-adam8157@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

`make rpm-pkg` and `make binrpm-pkg` will write $KERNELRELEASE into rpm
spec files which don't depend on localversion file now. So, the
unchanged spec files will cause failure after localversion file changed.

I added the localversion file into the dependencies of spec files.
Because that file is not necessary, I made it a empty target, so its
last-modification time will be checked by Make only when it exists.

Signed-off-by: Adam Lee <adam8157@gmail.com>
---
 scripts/package/Makefile |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/scripts/package/Makefile b/scripts/package/Makefile
index 87bf080..a7c1f59 100644
--- a/scripts/package/Makefile
+++ b/scripts/package/Makefile
@@ -30,9 +30,12 @@ KERNELPATH := kernel-$(subst -,_,$(KERNELRELEASE))
 MKSPEC     := $(srctree)/scripts/package/mkspec
 PREV       := set -e; cd -P ..;
 
+# localversion, its last-modification time will be checked only when it exists
+localversion:
+
 # rpm-pkg
 # ---------------------------------------------------------------------------
-$(objtree)/kernel.spec: $(MKSPEC) $(srctree)/Makefile
+$(objtree)/kernel.spec: $(MKSPEC) $(srctree)/Makefile localversion
 	$(CONFIG_SHELL) $(MKSPEC) > $@
 
 rpm-pkg rpm: $(objtree)/kernel.spec FORCE
@@ -60,7 +63,7 @@ clean-files := $(objtree)/kernel.spec
 
 # binrpm-pkg
 # ---------------------------------------------------------------------------
-$(objtree)/binkernel.spec: $(MKSPEC) $(srctree)/Makefile
+$(objtree)/binkernel.spec: $(MKSPEC) $(srctree)/Makefile localversion
 	$(CONFIG_SHELL) $(MKSPEC) prebuilt > $@
 
 binrpm-pkg: $(objtree)/binkernel.spec FORCE
-- 
1.7.10.4

