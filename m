Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752490Ab1G3XEH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jul 2011 19:04:07 -0400
Received: from casper.infradead.org ([85.118.1.10]:60241 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751370Ab1G3XED (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jul 2011 19:04:03 -0400
Subject: [PATCH 5/5] um: Fix SUBARCH=x86 build
From: David Woodhouse <dwmw2@infradead.org>
To: Arnaud Lacombe <lacombar@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org,
        user-mode-linux-devel@lists.sourceforge.net
Date: Sun, 31 Jul 2011 00:04:00 +0100
In-Reply-To: <1312066693.22074.50.camel@i7.infradead.org>
References: <1312066693.22074.50.camel@i7.infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.2 (3.0.2-3.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1312067041.22074.56.camel@i7.infradead.org>
Mime-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes the build for 'ARCH=um SUBARCH=x86', by introducing a new
USERARCH variable which is set to either i386 or x86_64 according to the
configuration option CONFIG_64BIT.

If we want to support x32 later, that could quite happily be a config
option too. We have a stated goal of moving even the top-level ARCH=
setting to a configuration option, and moving away from the hard-coded
variable overrides on the command line.

Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
---
 arch/um/Kconfig.x86            |    4 ++--
 arch/um/Makefile               |   25 ++++++++++++++++++-------
 arch/um/os-Linux/Makefile      |    2 +-
 arch/um/scripts/Makefile.rules |    4 ++--
 4 files changed, 23 insertions(+), 12 deletions(-)

diff --git a/arch/um/Kconfig.x86 b/arch/um/Kconfig.x86
index d31ecf3..576b732 100644
--- a/arch/um/Kconfig.x86
+++ b/arch/um/Kconfig.x86
@@ -19,8 +19,8 @@ config UML_X86
 	select GENERIC_FIND_FIRST_BIT
 
 config 64BIT
-	bool
-	default SUBARCH = "x86_64"
+	bool "64-bit kernel" if SUBARCH = "x86"
+	default SUBARCH != "i386"
 
 config X86_32
 	def_bool !64BIT
diff --git a/arch/um/Makefile b/arch/um/Makefile
index 2a54640..44f89c9 100644
--- a/arch/um/Makefile
+++ b/arch/um/Makefile
@@ -12,6 +12,17 @@ OS := $(shell uname -s)
 # features.
 SHELL := /bin/bash
 
+# The i386/x86_64 merge hasn't really happened in um-land yet. Fake it.
+ifeq ($(SUBARCH),x86)
+ifeq ($(CONFIG_64BIT),y)
+USERARCH := x86_64
+else
+USERARCH := i386
+endif
+else
+USERARCH := $(SUBARCH)
+endif
+
 filechk_gen_header = $<
 
 core-y			+= $(ARCH_DIR)/kernel/		\
@@ -24,11 +35,11 @@ include $(srctree)/$(ARCH_DIR)/Makefile-skas
 
 SHARED_HEADERS	:= $(ARCH_DIR)/include/shared
 ARCH_INCLUDE	:= -I$(srctree)/$(SHARED_HEADERS)
-ARCH_INCLUDE	+= -I$(srctree)/$(ARCH_DIR)/sys-$(SUBARCH)/shared
+ARCH_INCLUDE	+= -I$(srctree)/$(ARCH_DIR)/sys-$(USERARCH)/shared
 ifneq ($(KBUILD_SRC),)
 ARCH_INCLUDE	+= -I$(SHARED_HEADERS)
 endif
-KBUILD_CPPFLAGS += -I$(srctree)/$(ARCH_DIR)/sys-$(SUBARCH)
+KBUILD_CPPFLAGS += -I$(srctree)/$(ARCH_DIR)/sys-$(USERARCH)
 
 # -Dvmap=kernel_vmap prevents anything from referencing the libpcap.o symbol so
 # named - it's a common symbol in libpcap, so we get a binary which crashes.
@@ -49,7 +60,7 @@ USER_CFLAGS = $(patsubst $(KERNEL_DEFINES),,$(patsubst -D__KERNEL__,,\
 	$(patsubst -I%,,$(KBUILD_CFLAGS)))) $(ARCH_INCLUDE) $(MODE_INCLUDE) \
 	$(filter -I%,$(CFLAGS)) -D_FILE_OFFSET_BITS=64
 
-include $(srctree)/$(ARCH_DIR)/Makefile-$(SUBARCH)
+include $(srctree)/$(ARCH_DIR)/Makefile-$(USERARCH)
 
 #This will adjust *FLAGS accordingly to the platform.
 include $(srctree)/$(ARCH_DIR)/Makefile-os-$(OS)
@@ -128,8 +139,8 @@ archclean:
 
 # Generated files
 
-$(ARCH_DIR)/sys-$(SUBARCH)/user-offsets.s: FORCE
-	$(Q)$(MAKE) $(build)=$(ARCH_DIR)/sys-$(SUBARCH) $@
+$(ARCH_DIR)/sys-$(USERARCH)/user-offsets.s: FORCE
+	$(Q)$(MAKE) $(build)=$(ARCH_DIR)/sys-$(USERARCH) $@
 
 define filechk_gen-asm-offsets
         (set -e; \
@@ -144,11 +155,11 @@ define filechk_gen-asm-offsets
          echo ""; )
 endef
 
-$(SHARED_HEADERS)/user_constants.h: $(ARCH_DIR)/sys-$(SUBARCH)/user-offsets.s
+$(SHARED_HEADERS)/user_constants.h: $(ARCH_DIR)/sys-$(USERARCH)/user-offsets.s
 	$(call filechk,gen-asm-offsets)
 
 $(SHARED_HEADERS)/kern_constants.h:
 	$(Q)mkdir -p $(dir $@)
 	$(Q)echo '#include "../../../../include/generated/asm-offsets.h"' >$@
 
-export SUBARCH USER_CFLAGS CFLAGS_NO_HARDENING OS HEADER_ARCH DEV_NULL_PATH
+export SUBARCH USERARCH USER_CFLAGS CFLAGS_NO_HARDENING OS HEADER_ARCH DEV_NULL_PATH
diff --git a/arch/um/os-Linux/Makefile b/arch/um/os-Linux/Makefile
index 78658a7..a10a078 100644
--- a/arch/um/os-Linux/Makefile
+++ b/arch/um/os-Linux/Makefile
@@ -5,7 +5,7 @@
 
 obj-y = aio.o execvp.o file.o helper.o irq.o main.o mem.o process.o \
 	registers.o sigio.o signal.o start_up.o time.o tty.o uaccess.o \
-	umid.o tls.o user_syms.o util.o drivers/ sys-$(SUBARCH)/ skas/
+	umid.o tls.o user_syms.o util.o drivers/ sys-$(USERARCH)/ skas/
 
 obj-$(CONFIG_ARCH_REUSE_HOST_VSYSCALL_AREA) += elf_aux.o
 
diff --git a/arch/um/scripts/Makefile.rules b/arch/um/scripts/Makefile.rules
index 61107b6..9af0cd5 100644
--- a/arch/um/scripts/Makefile.rules
+++ b/arch/um/scripts/Makefile.rules
@@ -10,7 +10,7 @@ USER_OBJS := $(foreach file,$(USER_OBJS),$(obj)/$(file))
 $(USER_OBJS:.o=.%): \
 	c_flags = -Wp,-MD,$(depfile) $(USER_CFLAGS) $(CFLAGS_$(basetarget).o)
 $(USER_OBJS) : CHECKFLAGS := -D__linux__ -Dlinux -D__STDC__ \
-	-Dunix -D__unix__ -D__$(SUBARCH)__ $(CF)
+	-Dunix -D__unix__ -D__$(USERARCH)__ $(CF)
 
 # These are like USER_OBJS but filter USER_CFLAGS through unprofile instead of
 # using it directly.
@@ -19,7 +19,7 @@ UNPROFILE_OBJS := $(foreach file,$(UNPROFILE_OBJS),$(obj)/$(file))
 $(UNPROFILE_OBJS:.o=.%): \
 	c_flags = -Wp,-MD,$(depfile) $(call unprofile,$(USER_CFLAGS)) $(CFLAGS_$(basetarget).o)
 $(UNPROFILE_OBJS) : CHECKFLAGS := -D__linux__ -Dlinux -D__STDC__ \
-	-Dunix -D__unix__ -D__$(SUBARCH)__ $(CF)
+	-Dunix -D__unix__ -D__$(USERARCH)__ $(CF)
 
 # The stubs can't try to call mcount or update basic block data
 define unprofile
-- 
1.7.6



