Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754963Ab0GZUmH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 16:42:07 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:50676 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751847Ab0GZUmD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 16:42:03 -0400
Date: Mon, 26 Jul 2010 22:42:02 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Michal Marek <mmarek@suse.cz>, linux-kbuild <linux-kbuild@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Denys Vlasenko <vda.linux@googlemail.com>
Cc: Ralf Baechle <ralf@linux-mips.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Chen Liqin <liqin.chen@sunplusct.com>
Subject: [PATCH 1/3] kbuild: allow user to assign {A,C}FLAGS_MODULE
Message-ID: <20100726204202.GA18853@merkur.ravnborg.org>
References: <20100726203814.GA18828@merkur.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100726203814.GA18828@merkur.ravnborg.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 7ae2b4f270b0a6273072d73bbfeaa96815cc24af Mon Sep 17 00:00:00 2001
From: Sam Ravnborg <sam@ravnborg.org>
Date: Mon, 26 Jul 2010 21:03:08 +0200
Subject: [PATCH 1/3] kbuild: allow user to assign {A,C}FLAGS_MODULE

Do not use {A,C}FLAGS_MODULE in the top-level Makefile.
So if user assign a value to one of these variables we the
original value is not lost.

Use a kbuild internal variable that archs can use.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Chen Liqin <liqin.chen@sunplusct.com>
---
 Makefile               |    8 ++++----
 arch/mips/Makefile     |    4 ++--
 arch/s390/Makefile     |    2 +-
 arch/score/Makefile    |    2 +-
 scripts/Makefile.build |    9 ++++++---
 5 files changed, 14 insertions(+), 11 deletions(-)

diff --git a/Makefile b/Makefile
index a14c207..5e72848 100644
--- a/Makefile
+++ b/Makefile
@@ -332,9 +332,8 @@ CHECK		= sparse
 
 CHECKFLAGS     := -D__linux__ -Dlinux -D__STDC__ -Dunix -D__unix__ \
 		  -Wbitwise -Wno-return-void $(CF)
-MODFLAGS	= -DMODULE
-CFLAGS_MODULE   = $(MODFLAGS)
-AFLAGS_MODULE   = $(MODFLAGS)
+CFLAGS_MODULE   =
+AFLAGS_MODULE   =
 LDFLAGS_MODULE  = -T $(srctree)/scripts/module-common.lds
 CFLAGS_KERNEL	=
 AFLAGS_KERNEL	=
@@ -355,6 +354,7 @@ KBUILD_CFLAGS   := -Wall -Wundef -Wstrict-prototypes -Wno-trigraphs \
 		   -Wno-format-security \
 		   -fno-delete-null-pointer-checks
 KBUILD_AFLAGS   := -D__ASSEMBLY__
+KBUILD_MODFLAGS := -DMODULE
 
 # Read KERNELRELEASE from include/config/kernel.release (if it exists)
 KERNELRELEASE = $(shell cat include/config/kernel.release 2> /dev/null)
@@ -368,7 +368,7 @@ export HOSTCXX HOSTCXXFLAGS LDFLAGS_MODULE CHECK CHECKFLAGS
 
 export KBUILD_CPPFLAGS NOSTDINC_FLAGS LINUXINCLUDE OBJCOPYFLAGS LDFLAGS
 export KBUILD_CFLAGS CFLAGS_KERNEL CFLAGS_MODULE CFLAGS_GCOV
-export KBUILD_AFLAGS AFLAGS_KERNEL AFLAGS_MODULE
+export KBUILD_AFLAGS AFLAGS_KERNEL AFLAGS_MODULE KBUILD_MODFLAGS
 
 # When compiling out-of-tree modules, put MODVERDIR in the module
 # tree rather than in the kernel tree. The kernel tree might
diff --git a/arch/mips/Makefile b/arch/mips/Makefile
index 0b9c01a..2d77a2d 100644
--- a/arch/mips/Makefile
+++ b/arch/mips/Makefile
@@ -93,7 +93,7 @@ all-$(CONFIG_SYS_SUPPORTS_ZBOOT)+= vmlinuz
 cflags-y			+= -G 0 -mno-abicalls -fno-pic -pipe
 cflags-y			+= -msoft-float
 LDFLAGS_vmlinux			+= -G 0 -static -n -nostdlib
-MODFLAGS			+= -mlong-calls
+KBUILD_MODFLAGS			+= -mlong-calls
 
 cflags-y += -ffreestanding
 
@@ -185,7 +185,7 @@ cflags-$(CONFIG_CPU_DADDI_WORKAROUNDS)	+= $(call cc-option,-mno-daddi,)
 
 ifdef CONFIG_CPU_SB1
 ifdef CONFIG_SB1_PASS_1_WORKAROUNDS
-MODFLAGS	+= -msb1-pass1-workarounds
+KBUILD_MODFLAGS	+= -msb1-pass1-workarounds
 endif
 endif
 
diff --git a/arch/s390/Makefile b/arch/s390/Makefile
index 30c5f01..16a3ef9 100644
--- a/arch/s390/Makefile
+++ b/arch/s390/Makefile
@@ -24,7 +24,7 @@ CHECKFLAGS	+= -D__s390__ -msize-long
 else
 LD_BFD		:= elf64-s390
 LDFLAGS		:= -m elf64_s390
-MODFLAGS	+= -fpic -D__PIC__
+KBUILD_MODFLAGS	+= -fpic -D__PIC__
 KBUILD_CFLAGS	+= -m64
 KBUILD_AFLAGS	+= -m64
 UTS_MACHINE	:= s390x
diff --git a/arch/score/Makefile b/arch/score/Makefile
index 68e0cd0..c667f1d 100644
--- a/arch/score/Makefile
+++ b/arch/score/Makefile
@@ -20,7 +20,7 @@ cflags-y += -G0 -pipe -mel -mnhwloop -D__SCOREEL__ \
 #
 KBUILD_AFLAGS += $(cflags-y)
 KBUILD_CFLAGS += $(cflags-y)
-MODFLAGS += -mlong-calls
+KBUILD_MODFLAGS += -mlong-calls
 LDFLAGS += --oformat elf32-littlescore
 LDFLAGS_vmlinux	+= -G0 -static -nostdlib
 
diff --git a/scripts/Makefile.build b/scripts/Makefile.build
index 390aae4..2818802 100644
--- a/scripts/Makefile.build
+++ b/scripts/Makefile.build
@@ -115,7 +115,10 @@ endif
 # ---------------------------------------------------------------------------
 
 # Default is built-in, unless we know otherwise
-modkern_cflags = $(if $(part-of-module), $(CFLAGS_MODULE), $(CFLAGS_KERNEL))
+modkern_cflags =                                     \
+	$(if $(part-of-module),                      \
+		$(KBUILD_MODFLAGS) $(CFLAGS_MODULE), \
+		$(CFLAGS_KERNEL))
 quiet_modtag := $(empty)   $(empty)
 
 $(real-objs-m)        : part-of-module := y
@@ -250,8 +253,8 @@ $(obj)/%.lst: $(src)/%.c FORCE
 
 modkern_aflags := $(AFLAGS_KERNEL)
 
-$(real-objs-m)      : modkern_aflags := $(AFLAGS_MODULE)
-$(real-objs-m:.o=.s): modkern_aflags := $(AFLAGS_MODULE)
+$(real-objs-m)      : modkern_aflags := $(KBUILD_MODFLAGS) $(AFLAGS_MODULE)
+$(real-objs-m:.o=.s): modkern_aflags := $(KBUILD_MODFLAGS) $(AFLAGS_MODULE)
 
 quiet_cmd_as_s_S = CPP $(quiet_modtag) $@
 cmd_as_s_S       = $(CPP) $(a_flags)   -o $@ $< 
-- 
1.6.0.6

