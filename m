Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754456Ab2EEIUF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2012 04:20:05 -0400
Received: from smtp.snhosting.dk ([87.238.248.203]:49731 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753558Ab2EEISt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2012 04:18:49 -0400
From: Sam Ravnborg <sam@ravnborg.org>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kbuild <linux-kbuild@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH 5/8] kbuild: move definitions from top-level Makefile to scripts/Kbuild.config
Date: Sat,  5 May 2012 10:18:43 +0200
Message-Id: <1336205926-13946-5-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <20120505080640.GA13773@merkur.ravnborg.org>
References: <20120505080640.GA13773@merkur.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move some of the trivial definitions to a dedicated Kbuild.config file.
This brings down the noise level in the top-level Makefile.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 Makefile              |   68 ++----------------------------------------------
 scripts/Kbuild.config |   68 +++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 71 insertions(+), 65 deletions(-)
 create mode 100644 scripts/Kbuild.config

diff --git a/Makefile b/Makefile
index 41bc36e..aee40e2 100644
--- a/Makefile
+++ b/Makefile
@@ -243,11 +243,6 @@ CONFIG_SHELL := $(shell if [ -x "$$BASH" ]; then echo $$BASH; \
 	  else if [ -x /bin/bash ]; then echo /bin/bash; \
 	  else echo sh; fi ; fi)
 
-HOSTCC       = gcc
-HOSTCXX      = g++
-HOSTCFLAGS   = -Wall -Wmissing-prototypes -Wstrict-prototypes -O2 -fomit-frame-pointer
-HOSTCXXFLAGS = -O2
-
 # Decide whether to build built-in, modular, or both.
 # Normally, just do built-in.
 
@@ -323,74 +318,17 @@ export quiet Q KBUILD_VERBOSE
 MAKEFLAGS += --include-dir=$(srctree)
 
 # We need some generic definitions (do not try to remake the file).
+$(srctree)/scripts/Kbuild.config: ;
 $(srctree)/scripts/Kbuild.include: ;
+include $(srctree)/scripts/Kbuild.config
 include $(srctree)/scripts/Kbuild.include
 
-# Make variables (CC, etc...)
-
-AS		= $(CROSS_COMPILE)as
-LD		= $(CROSS_COMPILE)ld
-CC		= $(CROSS_COMPILE)gcc
-CPP		= $(CC) -E
-AR		= $(CROSS_COMPILE)ar
-NM		= $(CROSS_COMPILE)nm
-STRIP		= $(CROSS_COMPILE)strip
-OBJCOPY		= $(CROSS_COMPILE)objcopy
-OBJDUMP		= $(CROSS_COMPILE)objdump
-AWK		= awk
-GENKSYMS	= scripts/genksyms/genksyms
-INSTALLKERNEL  := installkernel
-DEPMOD		= /sbin/depmod
-PERL		= perl
-CHECK		= sparse
-
-CHECKFLAGS     := -D__linux__ -Dlinux -D__STDC__ -Dunix -D__unix__ \
-		  -Wbitwise -Wno-return-void $(CF)
-CFLAGS_MODULE   =
-AFLAGS_MODULE   =
-LDFLAGS_MODULE  =
-CFLAGS_KERNEL	=
-AFLAGS_KERNEL	=
-CFLAGS_GCOV	= -fprofile-arcs -ftest-coverage
-
-
-# Use LINUXINCLUDE when you must reference the include/ directory.
-# Needed to be compatible with the O= option
-LINUXINCLUDE    := -I$(srctree)/arch/$(hdr-arch)/include \
-                   -Iarch/$(hdr-arch)/include/generated -Iinclude \
-                   $(if $(KBUILD_SRC), -I$(srctree)/include) \
-                   -include $(srctree)/include/linux/kconfig.h
-
-KBUILD_CPPFLAGS := -D__KERNEL__
-
-KBUILD_CFLAGS   := -Wall -Wundef -Wstrict-prototypes -Wno-trigraphs \
-		   -fno-strict-aliasing -fno-common \
-		   -Werror-implicit-function-declaration \
-		   -Wno-format-security \
-		   -fno-delete-null-pointer-checks
-KBUILD_AFLAGS_KERNEL :=
-KBUILD_CFLAGS_KERNEL :=
-KBUILD_AFLAGS   := -D__ASSEMBLY__
-KBUILD_AFLAGS_MODULE  := -DMODULE
-KBUILD_CFLAGS_MODULE  := -DMODULE
-KBUILD_LDFLAGS_MODULE := -T $(srctree)/scripts/module-common.lds
-
 # Read KERNELRELEASE from include/config/kernel.release (if it exists)
 KERNELRELEASE = $(shell cat include/config/kernel.release 2> /dev/null)
 KERNELVERSION = $(VERSION)$(if $(PATCHLEVEL),.$(PATCHLEVEL)$(if $(SUBLEVEL),.$(SUBLEVEL)))$(EXTRAVERSION)
 
 export VERSION PATCHLEVEL SUBLEVEL KERNELRELEASE KERNELVERSION
-export ARCH SRCARCH CONFIG_SHELL HOSTCC HOSTCFLAGS CROSS_COMPILE AS LD CC
-export CPP AR NM STRIP OBJCOPY OBJDUMP
-export MAKE AWK GENKSYMS INSTALLKERNEL PERL UTS_MACHINE
-export HOSTCXX HOSTCXXFLAGS LDFLAGS_MODULE CHECK CHECKFLAGS
-
-export KBUILD_CPPFLAGS NOSTDINC_FLAGS LINUXINCLUDE OBJCOPYFLAGS LDFLAGS
-export KBUILD_CFLAGS CFLAGS_KERNEL CFLAGS_MODULE CFLAGS_GCOV
-export KBUILD_AFLAGS AFLAGS_KERNEL AFLAGS_MODULE
-export KBUILD_AFLAGS_MODULE KBUILD_CFLAGS_MODULE KBUILD_LDFLAGS_MODULE
-export KBUILD_AFLAGS_KERNEL KBUILD_CFLAGS_KERNEL
-export KBUILD_ARFLAGS
+export CROSS_COMPILE ARCH SRCARCH CONFIG_SHELL UTS_MACHINE
 
 # When compiling out-of-tree modules, put MODVERDIR in the module
 # tree rather than in the kernel tree. The kernel tree might
diff --git a/scripts/Kbuild.config b/scripts/Kbuild.config
new file mode 100644
index 0000000..15d5b1e
--- /dev/null
+++ b/scripts/Kbuild.config
@@ -0,0 +1,68 @@
+# Build on the host
+export HOSTCC       := gcc
+export HOSTCXX      := g++
+export HOSTCFLAGS   := -Wall -Wmissing-prototypes -Wstrict-prototypes
+       HOSTCFLAGS   += -O2 -fomit-frame-pointer
+export HOSTCXXFLAGS := -O2
+
+# Tools to build for the target
+export AS       := $(CROSS_COMPILE)as
+export LD       := $(CROSS_COMPILE)ld
+export CC       := $(CROSS_COMPILE)gcc
+export CPP      := $(CC) -E
+export AR       := $(CROSS_COMPILE)ar
+export NM       := $(CROSS_COMPILE)nm
+export STRIP    := $(CROSS_COMPILE)strip
+export OBJCOPY  := $(CROSS_COMPILE)objcopy
+export OBJDUMP  := $(CROSS_COMPILE)objdump
+
+# Diverse tools
+export AWK      := awk
+export CHECK    := sparse
+export DEPMOD   := /sbin/depmod
+export GENKSYMS := scripts/genksyms/genksyms
+export KALLSYMS := scripts/kallsyms
+export MAKE
+export PERL     := perl
+
+# Tools for kernel installation
+export INSTALLKERNEL := installkernel
+
+# Options for various tools
+export CHECKFLAGS     := -D__linux__ -Dlinux -D__STDC__
+       CHECKFLAGS     += -Dunix -D__unix__
+       CHECKFLAGS     += -Wbitwise -Wno-return-void $(CF)
+export CFLAGS_MODULE  :=
+export AFLAGS_MODULE  :=
+export LDFLAGS_MODULE :=
+export CFLAGS_KERNEL  :=
+export AFLAGS_KERNEL  :=
+export CFLAGS_GCOV    := -fprofile-arcs -ftest-coverage
+
+# Use LINUXINCLUDE when you must reference the include/ directory.
+# Needed to be compatible with the O= option
+export LINUXINCLUDE := -I$(srctree)/arch/$(hdr-arch)/include
+       LINUXINCLUDE += -Iarch/$(hdr-arch)/include/generated -Iinclude
+       LINUXINCLUDE += $(if $(KBUILD_SRC), -I$(srctree)/include)
+       LINUXINCLUDE += -include $(srctree)/include/linux/kconfig.h
+
+export KBUILD_CPPFLAGS := -D__KERNEL__
+export KBUILD_AFLAGS   := -D__ASSEMBLY__
+export KBUILD_CFLAGS   := -Wall -Wundef -Wstrict-prototypes -Wno-trigraphs
+       KBUILD_CFLAGS   += -fno-strict-aliasing -fno-common
+       KBUILD_CFLAGS   += -Werror-implicit-function-declaration
+       KBUILD_CFLAGS   += -Wno-format-security
+       KBUILD_CFLAGS   += -fno-delete-null-pointer-checks
+
+export KBUILD_AFLAGS_KERNEL  :=
+export KBUILD_CFLAGS_KERNEL  :=
+
+export KBUILD_AFLAGS_MODULE  := -DMODULE
+export KBUILD_CFLAGS_MODULE  := -DMODULE
+export KBUILD_LDFLAGS_MODULE := -T $(srctree)/scripts/module-common.lds
+
+ifdef CONFIG_CC_OPTIMIZE_FOR_SIZE
+KBUILD_CFLAGS += -Os
+else
+KBUILD_CFLAGS += -O2
+endif
-- 
1.6.0.6

