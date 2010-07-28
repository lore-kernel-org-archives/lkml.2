Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755994Ab0G1S2J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 14:28:09 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:46693 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751987Ab0G1S2G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 14:28:06 -0400
Date: Wed, 28 Jul 2010 20:28:02 +0200
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
Subject: [PATCH 2/3] kbuild: allow assignment to {A,C}FLAGS_KERNEL on the
	command line
Message-ID: <20100728182802.GB29232@merkur.ravnborg.org>
References: <20100728182523.GA29198@merkur.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100728182523.GA29198@merkur.ravnborg.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 4236ab8d726868df7a28132023e6b31e1d82e5b3 Mon Sep 17 00:00:00 2001
From: Sam Ravnborg <sam@ravnborg.org>
Date: Wed, 28 Jul 2010 19:11:27 +0200
Subject: [PATCH 2/3] kbuild: allow assignment to {A,C}FLAGS_KERNEL on the command line

It is now possible to assign options to AS and CC
on the command line - which is only used for built-in code.

{A,C}FLAGS_KERNEL was used both in the top-level Makefile
in the arch makefiles, thus users had no way to specify
additional options to AS, CC without overriding
the original value.

Introduce a new set of variables KBUILD_{A,C}FLAGS_KERNEL
that is used by arch specific files and free up
{A,C}FLAGS_KERNEL so they can be assigned on
the command line.

All arch Makefiles that used the old variables has been updated.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Hirokazu Takata <takata@linux-m32r.org>
---
 Documentation/kbuild/kbuild.txt    |   10 ++++++++++
 Documentation/kbuild/makefiles.txt |    9 +++++++--
 Makefile                           |    4 ++++
 arch/ia64/Makefile                 |    4 ++--
 arch/m32r/Makefile                 |    2 +-
 scripts/Makefile.build             |    4 ++--
 6 files changed, 26 insertions(+), 7 deletions(-)

diff --git a/Documentation/kbuild/kbuild.txt b/Documentation/kbuild/kbuild.txt
index d9c6554..e903f20 100644
--- a/Documentation/kbuild/kbuild.txt
+++ b/Documentation/kbuild/kbuild.txt
@@ -28,10 +28,20 @@ AFLAGS_MODULE
 --------------------------------------------------
 Addtional module specific options to use for $(AS).
 
+AFLAGS_KERNEL
+--------------------------------------------------
+Addtional options for $(AS) when used for assembler
+code for code that is compiled as built-in.
+
 KCFLAGS
 --------------------------------------------------
 Additional options to the C compiler (for built-in and modules).
 
+CFLAGS_KERNEL
+--------------------------------------------------
+Addtional options for $(CC) when used to compile
+code that is compiled as built-in.
+
 CFLAGS_MODULE
 --------------------------------------------------
 Addtional module specific options to use for $(CC).
diff --git a/Documentation/kbuild/makefiles.txt b/Documentation/kbuild/makefiles.txt
index 802341a..5c878cc 100644
--- a/Documentation/kbuild/makefiles.txt
+++ b/Documentation/kbuild/makefiles.txt
@@ -923,9 +923,9 @@ When kbuild executes, the following steps are followed (roughly):
 	The first example utilises the trick that a config option expands
 	to 'y' when selected.
 
-    CFLAGS_KERNEL	$(CC) options specific for built-in
+    KBUILD_AFLAGS_KERNEL	$(AS) options specific for built-in
 
-	$(CFLAGS_KERNEL) contains extra C compiler flags used to compile
+	$(KBUILD_AFLAGS_KERNEL) contains extra C compiler flags used to compile
 	resident kernel code.
 
     KBUILD_AFLAGS_MODULE   Options for $(AS) when building modules
@@ -934,6 +934,11 @@ When kbuild executes, the following steps are followed (roughly):
 	are used for $(AS).
 	From commandline AFLAGS_MODULE shall be used (see kbuild.txt).
 
+    KBUILD_CFLAGS_KERNEL	$(CC) options specific for built-in
+
+	$(KBUILD_CFLAGS_KERNEL) contains extra C compiler flags used to compile
+	resident kernel code.
+
     KBUILD_CFLAGS_MODULE   Options for $(CC) when building modules
 
 	$(KBUILD_CFLAGS_MODULE) is used to add arch specific options that
diff --git a/Makefile b/Makefile
index 88447e7..2fb144e 100644
--- a/Makefile
+++ b/Makefile
@@ -353,6 +353,8 @@ KBUILD_CFLAGS   := -Wall -Wundef -Wstrict-prototypes -Wno-trigraphs \
 		   -Werror-implicit-function-declaration \
 		   -Wno-format-security \
 		   -fno-delete-null-pointer-checks
+KBUILD_AFLAGS_KERNEL :=
+KBUILD_CFLAGS_KERNEL :=
 KBUILD_AFLAGS   := -D__ASSEMBLY__
 KBUILD_AFLAGS_MODULE  := -DMODULE
 KBUILD_CFLAGS_MODULE  := -DMODULE
@@ -372,6 +374,7 @@ export KBUILD_CPPFLAGS NOSTDINC_FLAGS LINUXINCLUDE OBJCOPYFLAGS LDFLAGS
 export KBUILD_CFLAGS CFLAGS_KERNEL CFLAGS_MODULE CFLAGS_GCOV
 export KBUILD_AFLAGS AFLAGS_KERNEL AFLAGS_MODULE
 export KBUILD_AFLAGS_MODULE KBUILD_CFLAGS_MODULE KBUILD_LDFLAGS_MODULE
+export KBUILD_AFLAGS_KERNEL KBUILD_CFLAGS_KERNEL
 
 # When compiling out-of-tree modules, put MODVERDIR in the module
 # tree rather than in the kernel tree. The kernel tree might
@@ -1483,6 +1486,7 @@ cmd_crmodverdir = $(Q)mkdir -p $(MODVERDIR) \
                   $(if $(KBUILD_MODULES),; rm -f $(MODVERDIR)/*)
 
 a_flags = -Wp,-MD,$(depfile) $(KBUILD_AFLAGS) $(AFLAGS_KERNEL) \
+	  $(KBUILD_AFLAGS_KERNEL)                              \
 	  $(NOSTDINC_FLAGS) $(LINUXINCLUDE) $(KBUILD_CPPFLAGS) \
 	  $(modkern_aflags) $(EXTRA_AFLAGS) $(AFLAGS_$(basetarget).o)
 
diff --git a/arch/ia64/Makefile b/arch/ia64/Makefile
index 6a4807f..be7bfa1 100644
--- a/arch/ia64/Makefile
+++ b/arch/ia64/Makefile
@@ -23,12 +23,12 @@ CHECKFLAGS	+= -m64 -D__ia64=1 -D__ia64__=1 -D_LP64 -D__LP64__
 OBJCOPYFLAGS	:= --strip-all
 LDFLAGS_vmlinux	:= -static
 KBUILD_LDFLAGS_MODULE += -T $(srctree)/arch/ia64/module.lds
-AFLAGS_KERNEL	:= -mconstant-gp
+KBUILD_AFLAGS_KERNEL := -mconstant-gp
 EXTRA		:=
 
 cflags-y	:= -pipe $(EXTRA) -ffixed-r13 -mfixed-range=f12-f15,f32-f127 \
 		   -falign-functions=32 -frename-registers -fno-optimize-sibling-calls
-CFLAGS_KERNEL	:= -mconstant-gp
+KBUILD_CFLAGS_KERNEL := -mconstant-gp
 
 GAS_STATUS	= $(shell $(srctree)/arch/ia64/scripts/check-gas "$(CC)" "$(OBJDUMP)")
 KBUILD_CPPFLAGS += $(shell $(srctree)/arch/ia64/scripts/toolchain-flags "$(CC)" "$(OBJDUMP)" "$(READELF)")
diff --git a/arch/m32r/Makefile b/arch/m32r/Makefile
index 14a3c23..8ff5ba0 100644
--- a/arch/m32r/Makefile
+++ b/arch/m32r/Makefile
@@ -12,7 +12,7 @@ OBJCOPYFLAGS	:= -O binary -R .note -R .comment -S
 LDFLAGS_vmlinux	:=
 
 KBUILD_CFLAGS += -pipe -fno-schedule-insns
-CFLAGS_KERNEL += -mmodel=medium
+KBUILD_CFLAGS_KERNEL += -mmodel=medium
 KBUILD_CFLAGS_MODULE += -mmodel=large
 
 ifdef CONFIG_CHIP_VDEC2
diff --git a/scripts/Makefile.build b/scripts/Makefile.build
index 5e7c40e..a1a5cf9 100644
--- a/scripts/Makefile.build
+++ b/scripts/Makefile.build
@@ -118,7 +118,7 @@ endif
 modkern_cflags =                                          \
 	$(if $(part-of-module),                           \
 		$(KBUILD_CFLAGS_MODULE) $(CFLAGS_MODULE), \
-		$(CFLAGS_KERNEL))
+		$(KBUILD_CFLAGS_KERNEL) $(CFLAGS_KERNEL))
 quiet_modtag := $(empty)   $(empty)
 
 $(real-objs-m)        : part-of-module := y
@@ -251,7 +251,7 @@ $(obj)/%.lst: $(src)/%.c FORCE
 # Compile assembler sources (.S)
 # ---------------------------------------------------------------------------
 
-modkern_aflags := $(AFLAGS_KERNEL)
+modkern_aflags := $(KBUILD_AFLAGS_KERNEL) $(AFLAGS_KERNEL)
 
 $(real-objs-m)      : modkern_aflags := $(KBUILD_AFLAGS_MODULE) $(AFLAGS_MODULE)
 $(real-objs-m:.o=.s): modkern_aflags := $(KBUILD_AFLAGS_MODULE) $(AFLAGS_MODULE)
-- 
1.6.0.6

