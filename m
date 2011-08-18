Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754141Ab1HRTGd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 15:06:33 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:47465 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754033Ab1HRTGa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 15:06:30 -0400
Date: Thu, 18 Aug 2011 20:06:29 +0100
To: richard@nod.at
Subject: Subject: [PATCH 45/91] um: merge Makefile-{i386,x86_64}
Cc: user-mode-linux-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
User-Agent: Heirloom mailx 12.5 7/5/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <E1Qu7vB-0007lA-KR@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/um/Makefile                        |   12 +++++++++++-
 arch/um/{Makefile-i386 => Makefile-x86} |   25 ++++++++++++++++++++++++-
 arch/um/Makefile-x86_64                 |   26 --------------------------
 3 files changed, 35 insertions(+), 28 deletions(-)
 rename arch/um/{Makefile-i386 => Makefile-x86} (70%)
 delete mode 100644 arch/um/Makefile-x86_64

diff --git a/arch/um/Makefile b/arch/um/Makefile
index bd0587e..7492ee5 100644
--- a/arch/um/Makefile
+++ b/arch/um/Makefile
@@ -20,8 +20,18 @@ core-y			+= $(ARCH_DIR)/kernel/		\
 
 MODE_INCLUDE	+= -I$(srctree)/$(ARCH_DIR)/include/shared/skas
 
+HEADER_ARCH 	:= $(SUBARCH)
+
+# Additional ARCH settings for x86
+ifeq ($(SUBARCH),i386)
+        HEADER_ARCH := x86
+endif
+ifeq ($(SUBARCH),x86_64)
+        HEADER_ARCH := x86
+endif
+
 include $(srctree)/$(ARCH_DIR)/Makefile-skas
-include $(srctree)/$(ARCH_DIR)/Makefile-$(SUBARCH)
+include $(srctree)/$(ARCH_DIR)/Makefile-$(HEADER_ARCH)
 
 SHARED_HEADERS	:= $(ARCH_DIR)/include/shared
 ARCH_INCLUDE	:= -I$(srctree)/$(SHARED_HEADERS)
diff --git a/arch/um/Makefile-i386 b/arch/um/Makefile-x86
similarity index 70%
rename from arch/um/Makefile-i386
rename to arch/um/Makefile-x86
index 57acfd6..68fbd1b 100644
--- a/arch/um/Makefile-i386
+++ b/arch/um/Makefile-x86
@@ -1,11 +1,11 @@
 core-y += arch/um/sys-x86/ arch/x86/crypto/
 
+ifeq ($(CONFIG_X86_32),y)
 START := 0x8048000
 
 LDFLAGS			+= -m elf_i386
 ELF_ARCH		:= i386
 ELF_FORMAT 		:= elf32-i386
-HEADER_ARCH		:= x86
 CHECKFLAGS	+= -D__i386__
 
 ifeq ("$(origin SUBARCH)", "command line")
@@ -36,3 +36,26 @@ KBUILD_CFLAGS += $(shell if [ $(call cc-version) -lt 0400 ] ; then \
 			else echo $(call cc-option,-funit-at-a-time); fi ;)
 
 KBUILD_CFLAGS += $(cflags-y)
+
+else
+
+START := 0x60000000
+
+KBUILD_CFLAGS += -fno-builtin -m64 
+
+CHECKFLAGS  += -m64 -D__x86_64__
+KBUILD_AFLAGS += -m64
+LDFLAGS += -m elf_x86_64
+KBUILD_CPPFLAGS += -m64
+
+ELF_ARCH := i386:x86-64
+ELF_FORMAT := elf64-x86-64
+
+# Not on all 64-bit distros /lib is a symlink to /lib64. PLD is an example.
+
+LINK-$(CONFIG_LD_SCRIPT_DYN) += -Wl,-rpath,/lib64
+LINK-y += -m64
+
+# Do unit-at-a-time unconditionally on x86_64, following the host
+KBUILD_CFLAGS += $(call cc-option,-funit-at-a-time)
+endif
diff --git a/arch/um/Makefile-x86_64 b/arch/um/Makefile-x86_64
deleted file mode 100644
index 92d8f8f..0000000
--- a/arch/um/Makefile-x86_64
+++ /dev/null
@@ -1,26 +0,0 @@
-# Copyright 2003 - 2004 Pathscale, Inc
-# Released under the GPL
-
-core-y += arch/um/sys-x86/ arch/x86/crypto/
-START := 0x60000000
-
-_extra_flags_ = -fno-builtin -m64
-
-KBUILD_CFLAGS += $(_extra_flags_)
-
-CHECKFLAGS  += -m64 -D__x86_64__
-KBUILD_AFLAGS += -m64
-LDFLAGS += -m elf_x86_64
-KBUILD_CPPFLAGS += -m64
-
-ELF_ARCH := i386:x86-64
-ELF_FORMAT := elf64-x86-64
-HEADER_ARCH := x86
-
-# Not on all 64-bit distros /lib is a symlink to /lib64. PLD is an example.
-
-LINK-$(CONFIG_LD_SCRIPT_DYN) += -Wl,-rpath,/lib64
-LINK-y += -m64
-
-# Do unit-at-a-time unconditionally on x86_64, following the host
-KBUILD_CFLAGS += $(call cc-option,-funit-at-a-time)
-- 
1.7.2.5


