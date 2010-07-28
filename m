Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755886Ab0G1S1U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 14:27:20 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:37157 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754384Ab0G1S1Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 14:27:16 -0400
Date: Wed, 28 Jul 2010 20:27:15 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Michal Marek <mmarek@suse.cz>, linux-kbuild <linux-kbuild@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Denys Vlasenko <vda.linux@googlemail.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Chen Liqin <liqin.chen@sunplusct.com>,
        David Howells <dhowells@redhat.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Haavard Skinnemoen <hskinnemoen@atmel.com>,
        Hirokazu Takata <takata@linux-m32r.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Mike Frysinger <vapier@gentoo.org>, Ralf Baechle <ralf@linux-mips.org>,
        Tony Luck <tony.luck@intel.com>
Subject: [PATCH 1/3] kbuild: allow assignment to {A,C,LD}FLAGS_MODULE on
	the command line
Message-ID: <20100728182714.GA29232@merkur.ravnborg.org>
References: <20100728182523.GA29198@merkur.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100728182523.GA29198@merkur.ravnborg.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 40d7c77aeafa6b17503ffdcf58fa01411972b0d1 Mon Sep 17 00:00:00 2001
From: Sam Ravnborg <sam@ravnborg.org>
Date: Wed, 28 Jul 2010 17:33:09 +0200
Subject: [PATCH 1/3] kbuild: allow assignment to {A,C,LD}FLAGS_MODULE on the command line

It is now possible to assign options to AS, CC and LD
on the command line - which is only used when building modules.

{A,C,LD}FLAGS_MODULE was all used both in the top-level Makefile
in the arch makefiles, thus users had no way to specify
additional options to AS, CC, LD when building modules
without overriding the original value.

Introduce a new set of variables KBUILD_{A,C,LD}FLAGS_MODULE
that is used by arch specific files and free up
{A,C,LD}FLAGS_MODULE so they can be assigned on
the command line.

All arch Makefiles that used the old variables has been updated.

Note: Previously we had a MODFLAGS variable for both
AS and CC. But in favour of consistency this was dropped.
So in some cases arch Makefile has one assignmnet replaced by
two assignmnets.

Note2: MODFLAGS was not documented and is dropped
without any notice. I do not expect much/any breakage
from this.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: Mike Frysinger <vapier@gentoo.org>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Chen Liqin <liqin.chen@sunplusct.com>
---
 Documentation/kbuild/kbuild.txt    |   16 ++++++++++++++--
 Documentation/kbuild/makefiles.txt |   18 +++++++++++++++---
 Makefile                           |   13 ++++++++-----
 arch/avr32/Makefile                |    2 +-
 arch/blackfin/Makefile             |    4 ++--
 arch/ia64/Makefile                 |    2 +-
 arch/m32r/Makefile                 |    2 +-
 arch/m68k/Makefile                 |    2 +-
 arch/mips/Makefile                 |    6 ++++--
 arch/powerpc/Makefile              |    2 +-
 arch/s390/Makefile                 |    3 ++-
 arch/score/Makefile                |    3 ++-
 scripts/Makefile.build             |    9 ++++++---
 scripts/Makefile.modpost           |    7 ++++---
 14 files changed, 62 insertions(+), 27 deletions(-)

diff --git a/Documentation/kbuild/kbuild.txt b/Documentation/kbuild/kbuild.txt
index 634c625..d9c6554 100644
--- a/Documentation/kbuild/kbuild.txt
+++ b/Documentation/kbuild/kbuild.txt
@@ -22,11 +22,23 @@ building C files and assembler files.
 
 KAFLAGS
 --------------------------------------------------
-Additional options to the assembler.
+Additional options to the assembler (for built-in and modules).
+
+AFLAGS_MODULE
+--------------------------------------------------
+Addtional module specific options to use for $(AS).
 
 KCFLAGS
 --------------------------------------------------
-Additional options to the C compiler.
+Additional options to the C compiler (for built-in and modules).
+
+CFLAGS_MODULE
+--------------------------------------------------
+Addtional module specific options to use for $(CC).
+
+LDFLAGS_MODULE
+--------------------------------------------------
+Additional options used for $(LD) when linking modules.
 
 KBUILD_VERBOSE
 --------------------------------------------------
diff --git a/Documentation/kbuild/makefiles.txt b/Documentation/kbuild/makefiles.txt
index 71c602d..802341a 100644
--- a/Documentation/kbuild/makefiles.txt
+++ b/Documentation/kbuild/makefiles.txt
@@ -928,11 +928,23 @@ When kbuild executes, the following steps are followed (roughly):
 	$(CFLAGS_KERNEL) contains extra C compiler flags used to compile
 	resident kernel code.
 
-    CFLAGS_MODULE	$(CC) options specific for modules
+    KBUILD_AFLAGS_MODULE   Options for $(AS) when building modules
 
-	$(CFLAGS_MODULE) contains extra C compiler flags used to compile code
-	for loadable kernel modules.
+	$(KBUILD_AFLAGS_MODULE) is used to add arch specific options that
+	are used for $(AS).
+	From commandline AFLAGS_MODULE shall be used (see kbuild.txt).
 
+    KBUILD_CFLAGS_MODULE   Options for $(CC) when building modules
+
+	$(KBUILD_CFLAGS_MODULE) is used to add arch specific options that
+	are used for $(CC).
+	From commandline CFLAGS_MODULE shall be used (see kbuild.txt).
+
+    KBUILD_LDFLAGS_MODULE   Options for $(LD) when linking modules
+
+	$(KBUILD_LDFLAGS_MODULE) is used to add arch specific options
+	used when linking modules. This is often a linker script.
+	From commandline LDFLAGS_MODULE shall be used (see kbuild.txt).
 
 --- 6.2 Add prerequisites to archprepare:
 
diff --git a/Makefile b/Makefile
index a14c207..88447e7 100644
--- a/Makefile
+++ b/Makefile
@@ -332,10 +332,9 @@ CHECK		= sparse
 
 CHECKFLAGS     := -D__linux__ -Dlinux -D__STDC__ -Dunix -D__unix__ \
 		  -Wbitwise -Wno-return-void $(CF)
-MODFLAGS	= -DMODULE
-CFLAGS_MODULE   = $(MODFLAGS)
-AFLAGS_MODULE   = $(MODFLAGS)
-LDFLAGS_MODULE  = -T $(srctree)/scripts/module-common.lds
+CFLAGS_MODULE   =
+AFLAGS_MODULE   =
+LDFLAGS_MODULE  =
 CFLAGS_KERNEL	=
 AFLAGS_KERNEL	=
 CFLAGS_GCOV	= -fprofile-arcs -ftest-coverage
@@ -355,6 +354,9 @@ KBUILD_CFLAGS   := -Wall -Wundef -Wstrict-prototypes -Wno-trigraphs \
 		   -Wno-format-security \
 		   -fno-delete-null-pointer-checks
 KBUILD_AFLAGS   := -D__ASSEMBLY__
+KBUILD_AFLAGS_MODULE  := -DMODULE
+KBUILD_CFLAGS_MODULE  := -DMODULE
+KBUILD_LDFLAGS_MODULE := -T $(srctree)/scripts/module-common.lds
 
 # Read KERNELRELEASE from include/config/kernel.release (if it exists)
 KERNELRELEASE = $(shell cat include/config/kernel.release 2> /dev/null)
@@ -369,6 +371,7 @@ export HOSTCXX HOSTCXXFLAGS LDFLAGS_MODULE CHECK CHECKFLAGS
 export KBUILD_CPPFLAGS NOSTDINC_FLAGS LINUXINCLUDE OBJCOPYFLAGS LDFLAGS
 export KBUILD_CFLAGS CFLAGS_KERNEL CFLAGS_MODULE CFLAGS_GCOV
 export KBUILD_AFLAGS AFLAGS_KERNEL AFLAGS_MODULE
+export KBUILD_AFLAGS_MODULE KBUILD_CFLAGS_MODULE KBUILD_LDFLAGS_MODULE
 
 # When compiling out-of-tree modules, put MODVERDIR in the module
 # tree rather than in the kernel tree. The kernel tree might
@@ -607,7 +610,7 @@ endif
 # Use --build-id when available.
 LDFLAGS_BUILD_ID = $(patsubst -Wl$(comma)%,%,\
 			      $(call cc-ldoption, -Wl$(comma)--build-id,))
-LDFLAGS_MODULE += $(LDFLAGS_BUILD_ID)
+KBUILD_LDFLAGS_MODULE += $(LDFLAGS_BUILD_ID)
 LDFLAGS_vmlinux += $(LDFLAGS_BUILD_ID)
 
 ifeq ($(CONFIG_STRIP_ASM_SYMS),y)
diff --git a/arch/avr32/Makefile b/arch/avr32/Makefile
index ead8a75..22fb665 100644
--- a/arch/avr32/Makefile
+++ b/arch/avr32/Makefile
@@ -13,7 +13,7 @@ KBUILD_DEFCONFIG	:= atstk1002_defconfig
 
 KBUILD_CFLAGS	+= -pipe -fno-builtin -mno-pic
 KBUILD_AFLAGS	+= -mrelax -mno-pic
-CFLAGS_MODULE	+= -mno-relax
+KBUILD_CFLAGS_MODULE += -mno-relax
 LDFLAGS_vmlinux	+= --relax
 
 cpuflags-$(CONFIG_PLATFORM_AT32AP)	+= -march=ap
diff --git a/arch/blackfin/Makefile b/arch/blackfin/Makefile
index 5a97a31..9d5ffaf 100644
--- a/arch/blackfin/Makefile
+++ b/arch/blackfin/Makefile
@@ -18,8 +18,8 @@ ifeq ($(CONFIG_ROMKERNEL),y)
 KBUILD_CFLAGS           += -mlong-calls
 endif
 KBUILD_AFLAGS           += $(call cc-option,-mno-fdpic)
-CFLAGS_MODULE    += -mlong-calls
-LDFLAGS_MODULE   += -m elf32bfin
+KBUILD_CFLAGS_MODULE    += -mlong-calls
+KBUILD_LDFLAGS_MODULE   += -m elf32bfin
 KALLSYMS         += --symbol-prefix=_
 
 KBUILD_DEFCONFIG := BF537-STAMP_defconfig
diff --git a/arch/ia64/Makefile b/arch/ia64/Makefile
index 8ae0d26..6a4807f 100644
--- a/arch/ia64/Makefile
+++ b/arch/ia64/Makefile
@@ -22,7 +22,7 @@ CHECKFLAGS	+= -m64 -D__ia64=1 -D__ia64__=1 -D_LP64 -D__LP64__
 
 OBJCOPYFLAGS	:= --strip-all
 LDFLAGS_vmlinux	:= -static
-LDFLAGS_MODULE	+= -T $(srctree)/arch/ia64/module.lds
+KBUILD_LDFLAGS_MODULE += -T $(srctree)/arch/ia64/module.lds
 AFLAGS_KERNEL	:= -mconstant-gp
 EXTRA		:=
 
diff --git a/arch/m32r/Makefile b/arch/m32r/Makefile
index 469766b..14a3c23 100644
--- a/arch/m32r/Makefile
+++ b/arch/m32r/Makefile
@@ -13,7 +13,7 @@ LDFLAGS_vmlinux	:=
 
 KBUILD_CFLAGS += -pipe -fno-schedule-insns
 CFLAGS_KERNEL += -mmodel=medium
-CFLAGS_MODULE += -mmodel=large
+KBUILD_CFLAGS_MODULE += -mmodel=large
 
 ifdef CONFIG_CHIP_VDEC2
 cflags-$(CONFIG_ISA_M32R2)	+= -DNO_FPU -Wa,-bitinst
diff --git a/arch/m68k/Makefile b/arch/m68k/Makefile
index 570d85c..b06a7e3 100644
--- a/arch/m68k/Makefile
+++ b/arch/m68k/Makefile
@@ -18,7 +18,7 @@ KBUILD_DEFCONFIG := multi_defconfig
 # override top level makefile
 AS += -m68020
 LDFLAGS := -m m68kelf
-LDFLAGS_MODULE += -T $(srctree)/arch/m68k/kernel/module.lds
+KBUILD_LDFLAGS_MODULE += -T $(srctree)/arch/m68k/kernel/module.lds
 ifneq ($(SUBARCH),$(ARCH))
 	ifeq ($(CROSS_COMPILE),)
 		CROSS_COMPILE := $(call cc-cross-prefix, \
diff --git a/arch/mips/Makefile b/arch/mips/Makefile
index 0b9c01a..f7139b2 100644
--- a/arch/mips/Makefile
+++ b/arch/mips/Makefile
@@ -93,7 +93,8 @@ all-$(CONFIG_SYS_SUPPORTS_ZBOOT)+= vmlinuz
 cflags-y			+= -G 0 -mno-abicalls -fno-pic -pipe
 cflags-y			+= -msoft-float
 LDFLAGS_vmlinux			+= -G 0 -static -n -nostdlib
-MODFLAGS			+= -mlong-calls
+KBUILD_AFLAGS_MODULE		+= -mlong-calls
+KBUILD_CFLAGS_MODULE		+= -mlong-calls
 
 cflags-y += -ffreestanding
 
@@ -185,7 +186,8 @@ cflags-$(CONFIG_CPU_DADDI_WORKAROUNDS)	+= $(call cc-option,-mno-daddi,)
 
 ifdef CONFIG_CPU_SB1
 ifdef CONFIG_SB1_PASS_1_WORKAROUNDS
-MODFLAGS	+= -msb1-pass1-workarounds
+KBUILD_AFLAGS_MODULE += -msb1-pass1-workarounds
+KBUILD_CFLAGS_MODULE += -msb1-pass1-workarounds
 endif
 endif
 
diff --git a/arch/powerpc/Makefile b/arch/powerpc/Makefile
index 77cfe7a..5d42f5e 100644
--- a/arch/powerpc/Makefile
+++ b/arch/powerpc/Makefile
@@ -94,7 +94,7 @@ else
 endif
 endif
 
-LDFLAGS_MODULE	+= arch/powerpc/lib/crtsavres.o
+KBUILD_LDFLAGS_MODULE += arch/powerpc/lib/crtsavres.o
 
 ifeq ($(CONFIG_TUNE_CELL),y)
 	KBUILD_CFLAGS += $(call cc-option,-mtune=cell)
diff --git a/arch/s390/Makefile b/arch/s390/Makefile
index 30c5f01..0c9e6c6 100644
--- a/arch/s390/Makefile
+++ b/arch/s390/Makefile
@@ -24,7 +24,8 @@ CHECKFLAGS	+= -D__s390__ -msize-long
 else
 LD_BFD		:= elf64-s390
 LDFLAGS		:= -m elf64_s390
-MODFLAGS	+= -fpic -D__PIC__
+KBUILD_AFLAGS_MODULE += -fpic -D__PIC__
+KBUILD_CFLAGS_MODULE += -fpic -D__PIC__
 KBUILD_CFLAGS	+= -m64
 KBUILD_AFLAGS	+= -m64
 UTS_MACHINE	:= s390x
diff --git a/arch/score/Makefile b/arch/score/Makefile
index 68e0cd0..d77dc63 100644
--- a/arch/score/Makefile
+++ b/arch/score/Makefile
@@ -20,7 +20,8 @@ cflags-y += -G0 -pipe -mel -mnhwloop -D__SCOREEL__ \
 #
 KBUILD_AFLAGS += $(cflags-y)
 KBUILD_CFLAGS += $(cflags-y)
-MODFLAGS += -mlong-calls
+KBUILD_AFLAGS_MODULE += -mlong-calls
+KBUILD_CFLAGS_MODULE += -mlong-calls
 LDFLAGS += --oformat elf32-littlescore
 LDFLAGS_vmlinux	+= -G0 -static -nostdlib
 
diff --git a/scripts/Makefile.build b/scripts/Makefile.build
index 390aae4..5e7c40e 100644
--- a/scripts/Makefile.build
+++ b/scripts/Makefile.build
@@ -115,7 +115,10 @@ endif
 # ---------------------------------------------------------------------------
 
 # Default is built-in, unless we know otherwise
-modkern_cflags = $(if $(part-of-module), $(CFLAGS_MODULE), $(CFLAGS_KERNEL))
+modkern_cflags =                                          \
+	$(if $(part-of-module),                           \
+		$(KBUILD_CFLAGS_MODULE) $(CFLAGS_MODULE), \
+		$(CFLAGS_KERNEL))
 quiet_modtag := $(empty)   $(empty)
 
 $(real-objs-m)        : part-of-module := y
@@ -250,8 +253,8 @@ $(obj)/%.lst: $(src)/%.c FORCE
 
 modkern_aflags := $(AFLAGS_KERNEL)
 
-$(real-objs-m)      : modkern_aflags := $(AFLAGS_MODULE)
-$(real-objs-m:.o=.s): modkern_aflags := $(AFLAGS_MODULE)
+$(real-objs-m)      : modkern_aflags := $(KBUILD_AFLAGS_MODULE) $(AFLAGS_MODULE)
+$(real-objs-m:.o=.s): modkern_aflags := $(KBUILD_AFLAGS_MODULE) $(AFLAGS_MODULE)
 
 quiet_cmd_as_s_S = CPP $(quiet_modtag) $@
 cmd_as_s_S       = $(CPP) $(a_flags)   -o $@ $< 
diff --git a/scripts/Makefile.modpost b/scripts/Makefile.modpost
index 8f14c81..3e3f024 100644
--- a/scripts/Makefile.modpost
+++ b/scripts/Makefile.modpost
@@ -107,7 +107,7 @@ $(modules:.ko=.mod.c): __modpost ;
 modname = $(notdir $(@:.mod.o=))
 
 quiet_cmd_cc_o_c = CC      $@
-      cmd_cc_o_c = $(CC) $(c_flags) $(CFLAGS_MODULE)	\
+      cmd_cc_o_c = $(CC) $(c_flags) $(KBUILD_CFLAGS_MODULE) $(CFLAGS_MODULE) \
 		   -c -o $@ $<
 
 $(modules:.ko=.mod.o): %.mod.o: %.mod.c FORCE
@@ -117,8 +117,9 @@ targets += $(modules:.ko=.mod.o)
 
 # Step 6), final link of the modules
 quiet_cmd_ld_ko_o = LD [M]  $@
-      cmd_ld_ko_o = $(LD) -r $(LDFLAGS) $(LDFLAGS_MODULE) -o $@		\
-			  $(filter-out FORCE,$^)
+      cmd_ld_ko_o = $(LD) -r $(LDFLAGS)                                 \
+                             $(KBUILD_LDFLAGS_MODULE) $(LDFLAGS_MODULE) \
+                             -o $@ $(filter-out FORCE,$^)
 
 $(modules): %.ko :%.o %.mod.o FORCE
 	$(call if_changed,ld_ko_o)
-- 
1.6.0.6

