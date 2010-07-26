Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755021Ab0GZUog (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 16:44:36 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:59385 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752458Ab0GZUof (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 16:44:35 -0400
Date: Mon, 26 Jul 2010 22:44:32 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Michal Marek <mmarek@suse.cz>, linux-kbuild <linux-kbuild@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Cc: Mike Frysinger <vapier@gentoo.org>, Tony Luck <tony.luck@intel.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [PATCH 3/3] kbuild: allow user to assign LDFLAGS_MODULE
Message-ID: <20100726204432.GC18853@merkur.ravnborg.org>
References: <20100726203814.GA18828@merkur.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100726203814.GA18828@merkur.ravnborg.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From ce765a28adeb8878413a49ce62f442022d6a5b6a Mon Sep 17 00:00:00 2001
From: Sam Ravnborg <sam@ravnborg.org>
Date: Mon, 26 Jul 2010 22:20:12 +0200
Subject: [PATCH 3/3] kbuild: allow user to assign LDFLAGS_MODULE

Do not use LDFLAGS_MODULE in the top-level Makefile.
So if user assign a value to LDFALGS_MODULE the
original value is not lost.

Use a kbuild internal variable that archs can use,
and update all archs that used LDFALGS_MODULE.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Mike Frysinger <vapier@gentoo.org>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---
 Makefile                 |    8 +++++---
 arch/blackfin/Makefile   |    2 +-
 arch/ia64/Makefile       |    2 +-
 arch/m68k/Makefile       |    2 +-
 arch/powerpc/Makefile    |    2 +-
 scripts/Makefile.modpost |    5 +++--
 6 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/Makefile b/Makefile
index 5e72848..08d3bf0 100644
--- a/Makefile
+++ b/Makefile
@@ -334,7 +334,7 @@ CHECKFLAGS     := -D__linux__ -Dlinux -D__STDC__ -Dunix -D__unix__ \
 		  -Wbitwise -Wno-return-void $(CF)
 CFLAGS_MODULE   =
 AFLAGS_MODULE   =
-LDFLAGS_MODULE  = -T $(srctree)/scripts/module-common.lds
+LDFLAGS_MODULE  =
 CFLAGS_KERNEL	=
 AFLAGS_KERNEL	=
 CFLAGS_GCOV	= -fprofile-arcs -ftest-coverage
@@ -355,6 +355,7 @@ KBUILD_CFLAGS   := -Wall -Wundef -Wstrict-prototypes -Wno-trigraphs \
 		   -fno-delete-null-pointer-checks
 KBUILD_AFLAGS   := -D__ASSEMBLY__
 KBUILD_MODFLAGS := -DMODULE
+KBUILD_LDMODFLAGS := -T $(srctree)/scripts/module-common.lds
 
 # Read KERNELRELEASE from include/config/kernel.release (if it exists)
 KERNELRELEASE = $(shell cat include/config/kernel.release 2> /dev/null)
@@ -368,7 +369,8 @@ export HOSTCXX HOSTCXXFLAGS LDFLAGS_MODULE CHECK CHECKFLAGS
 
 export KBUILD_CPPFLAGS NOSTDINC_FLAGS LINUXINCLUDE OBJCOPYFLAGS LDFLAGS
 export KBUILD_CFLAGS CFLAGS_KERNEL CFLAGS_MODULE CFLAGS_GCOV
-export KBUILD_AFLAGS AFLAGS_KERNEL AFLAGS_MODULE KBUILD_MODFLAGS
+export KBUILD_AFLAGS AFLAGS_KERNEL AFLAGS_MODULE
+export KBUILD_MODFLAGS KBUILD_LDMODFLAGS
 
 # When compiling out-of-tree modules, put MODVERDIR in the module
 # tree rather than in the kernel tree. The kernel tree might
@@ -607,7 +609,7 @@ endif
 # Use --build-id when available.
 LDFLAGS_BUILD_ID = $(patsubst -Wl$(comma)%,%,\
 			      $(call cc-ldoption, -Wl$(comma)--build-id,))
-LDFLAGS_MODULE += $(LDFLAGS_BUILD_ID)
+KBUILD_LDMODFLAGS += $(LDFLAGS_BUILD_ID)
 LDFLAGS_vmlinux += $(LDFLAGS_BUILD_ID)
 
 ifeq ($(CONFIG_STRIP_ASM_SYMS),y)
diff --git a/arch/blackfin/Makefile b/arch/blackfin/Makefile
index 5a97a31..df1e1df 100644
--- a/arch/blackfin/Makefile
+++ b/arch/blackfin/Makefile
@@ -19,7 +19,7 @@ KBUILD_CFLAGS           += -mlong-calls
 endif
 KBUILD_AFLAGS           += $(call cc-option,-mno-fdpic)
 CFLAGS_MODULE    += -mlong-calls
-LDFLAGS_MODULE   += -m elf32bfin
+KBUILD_LDMODFLAGS += -m elf32bfin
 KALLSYMS         += --symbol-prefix=_
 
 KBUILD_DEFCONFIG := BF537-STAMP_defconfig
diff --git a/arch/ia64/Makefile b/arch/ia64/Makefile
index 8ae0d26..072d4f0 100644
--- a/arch/ia64/Makefile
+++ b/arch/ia64/Makefile
@@ -22,7 +22,7 @@ CHECKFLAGS	+= -m64 -D__ia64=1 -D__ia64__=1 -D_LP64 -D__LP64__
 
 OBJCOPYFLAGS	:= --strip-all
 LDFLAGS_vmlinux	:= -static
-LDFLAGS_MODULE	+= -T $(srctree)/arch/ia64/module.lds
+KBUILD_LDMODFLAGS += -T $(srctree)/arch/ia64/module.lds
 AFLAGS_KERNEL	:= -mconstant-gp
 EXTRA		:=
 
diff --git a/arch/m68k/Makefile b/arch/m68k/Makefile
index 570d85c..58187f2 100644
--- a/arch/m68k/Makefile
+++ b/arch/m68k/Makefile
@@ -18,7 +18,7 @@ KBUILD_DEFCONFIG := multi_defconfig
 # override top level makefile
 AS += -m68020
 LDFLAGS := -m m68kelf
-LDFLAGS_MODULE += -T $(srctree)/arch/m68k/kernel/module.lds
+KBUILD_LDMODFLAGS += -T $(srctree)/arch/m68k/kernel/module.lds
 ifneq ($(SUBARCH),$(ARCH))
 	ifeq ($(CROSS_COMPILE),)
 		CROSS_COMPILE := $(call cc-cross-prefix, \
diff --git a/arch/powerpc/Makefile b/arch/powerpc/Makefile
index 77cfe7a..a01448b 100644
--- a/arch/powerpc/Makefile
+++ b/arch/powerpc/Makefile
@@ -94,7 +94,7 @@ else
 endif
 endif
 
-LDFLAGS_MODULE	+= arch/powerpc/lib/crtsavres.o
+KBUILD_LDMODFLAGS += arch/powerpc/lib/crtsavres.o
 
 ifeq ($(CONFIG_TUNE_CELL),y)
 	KBUILD_CFLAGS += $(call cc-option,-mtune=cell)
diff --git a/scripts/Makefile.modpost b/scripts/Makefile.modpost
index 8f14c81..1948f7a 100644
--- a/scripts/Makefile.modpost
+++ b/scripts/Makefile.modpost
@@ -117,8 +117,9 @@ targets += $(modules:.ko=.mod.o)
 
 # Step 6), final link of the modules
 quiet_cmd_ld_ko_o = LD [M]  $@
-      cmd_ld_ko_o = $(LD) -r $(LDFLAGS) $(LDFLAGS_MODULE) -o $@		\
-			  $(filter-out FORCE,$^)
+      cmd_ld_ko_o = $(LD) -r $(LDFLAGS)                             \
+                             $(KBUILD_LDMODFLAGS) $(LDFLAGS_MODULE) \
+                             -o $@ $(filter-out FORCE,$^)
 
 $(modules): %.ko :%.o %.mod.o FORCE
 	$(call if_changed,ld_ko_o)
-- 
1.6.0.6

