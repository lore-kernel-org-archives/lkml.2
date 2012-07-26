Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751618Ab2GZNof (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 09:44:35 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:50881 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751024Ab2GZNod (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 09:44:33 -0400
From: Will Deacon <will.deacon@arm.com>
To: linux-kernel@vger.kernel.org
Cc: geert@linux-m68k.org, akpm@linux-foundation.org,
        Will Deacon <will.deacon@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        Avi Kivity <avi@redhat.com>
Subject: [PATCH] kbuild: kvm: make export of linux/kvm_para.h unconditional
Date: Thu, 26 Jul 2012 14:44:14 +0100
Message-Id: <1343310254-7493-1-git-send-email-will.deacon@arm.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The asm-generic version of kvm_para.h is always exported, confusing the
Kbuild wildcarding that tries to detect whether the source architecture
is exporting the header, since asm-* matches the generic version.

This patch unconditionally exports linux/kvm_para.h and fixes the few
remaining architectures without asm/kvm_para.h to use the generic
version. I also took the liberty of removing some dead lines from the
wildcarding which was searcing for asm-$(SRCARCH) directores under
$(srctree).

Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Avi Kivity <avi@redhat.com>
Tested-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Will Deacon <will.deacon@arm.com>
---

 arch/cris/include/asm/Kbuild   |    2 ++
 arch/m32r/include/asm/Kbuild   |    2 ++
 include/asm-generic/Kbuild.asm |   12 +++---------
 include/linux/Kbuild           |    8 +-------
 4 files changed, 8 insertions(+), 16 deletions(-)

diff --git a/arch/cris/include/asm/Kbuild b/arch/cris/include/asm/Kbuild
index 04d02a5..2fde49c 100644
--- a/arch/cris/include/asm/Kbuild
+++ b/arch/cris/include/asm/Kbuild
@@ -7,3 +7,5 @@ header-y += ethernet.h
 header-y += etraxgpio.h
 header-y += rs485.h
 header-y += sync_serial.h
+
+generic-y += kvm_para.h
diff --git a/arch/m32r/include/asm/Kbuild b/arch/m32r/include/asm/Kbuild
index c68e168..78c505e 100644
--- a/arch/m32r/include/asm/Kbuild
+++ b/arch/m32r/include/asm/Kbuild
@@ -1 +1,3 @@
 include include/asm-generic/Kbuild.asm
+
+generic-y += kvm_para.h
diff --git a/include/asm-generic/Kbuild.asm b/include/asm-generic/Kbuild.asm
index c5d2e5d..f180c99 100644
--- a/include/asm-generic/Kbuild.asm
+++ b/include/asm-generic/Kbuild.asm
@@ -1,15 +1,8 @@
-ifneq ($(wildcard $(srctree)/arch/$(SRCARCH)/include/asm/kvm.h \
-		  $(srctree)/include/asm-$(SRCARCH)/kvm.h),)
+ifneq ($(wildcard $(srctree)/arch/$(SRCARCH)/include/asm/kvm.h),)
 header-y  += kvm.h
 endif
 
-ifneq ($(wildcard $(srctree)/arch/$(SRCARCH)/include/asm/kvm_para.h \
-		  $(srctree)/include/asm-$(SRCARCH)/kvm_para.h),)
-header-y  += kvm_para.h
-endif
-
-ifneq ($(wildcard $(srctree)/arch/$(SRCARCH)/include/asm/a.out.h \
-		  $(srctree)/include/asm-$(SRCARCH)/a.out.h),)
+ifneq ($(wildcard $(srctree)/arch/$(SRCARCH)/include/asm/a.out.h),)
 header-y += a.out.h
 endif
 
@@ -21,6 +14,7 @@ header-y += fcntl.h
 header-y += ioctl.h
 header-y += ioctls.h
 header-y += ipcbuf.h
+header-y += kvm_para.h
 header-y += mman.h
 header-y += msgbuf.h
 header-y += param.h
diff --git a/include/linux/Kbuild b/include/linux/Kbuild
index 8760be3..048abc6 100644
--- a/include/linux/Kbuild
+++ b/include/linux/Kbuild
@@ -23,20 +23,13 @@ header-y += wimax/
 objhdr-y += version.h
 
 ifneq ($(wildcard $(srctree)/arch/$(SRCARCH)/include/asm/a.out.h \
-		  $(srctree)/include/asm-$(SRCARCH)/a.out.h \
 		  $(INSTALL_HDR_PATH)/include/asm-*/a.out.h),)
 header-y += a.out.h
 endif
 ifneq ($(wildcard $(srctree)/arch/$(SRCARCH)/include/asm/kvm.h \
-		  $(srctree)/include/asm-$(SRCARCH)/kvm.h \
 		  $(INSTALL_HDR_PATH)/include/asm-*/kvm.h),)
 header-y += kvm.h
 endif
-ifneq ($(wildcard $(srctree)/arch/$(SRCARCH)/include/asm/kvm_para.h \
-		  $(srctree)/include/asm-$(SRCARCH)/kvm_para.h \
-		  $(INSTALL_HDR_PATH)/include/asm-*/kvm_para.h),)
-header-y += kvm_para.h
-endif
 
 header-y += acct.h
 header-y += adb.h
@@ -229,6 +222,7 @@ header-y += kernel-page-flags.h
 header-y += kexec.h
 header-y += keyboard.h
 header-y += keyctl.h
+header-y += kvm_para.h
 header-y += l2tp.h
 header-y += limits.h
 header-y += llc.h
-- 
1.7.4.1

