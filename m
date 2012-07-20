Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753539Ab2GTV55 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 17:57:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44403 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752234Ab2GTV5u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 17:57:50 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 05/13] UAPI: Partition the header include path sets and add
 uapi/ header directories
To: linux-arch@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, arnd@arndb.de, tglx@linutronix.de,
        mingo@kernel.org, davej@redhat.com
Date: Fri, 20 Jul 2012 22:57:38 +0100
Message-ID: <20120720215738.14854.55273.stgit@warthog.procyon.org.uk>
In-Reply-To: <20120720215636.14854.41208.stgit@warthog.procyon.org.uk>
References: <20120720215636.14854.41208.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Partition the header include path flags into two sets, one for kernelspace
builds and one for userspace builds.

Add the following directories to build after the ordinary include directories
so that #include will pick up the UAPI header directly if the kernel header
has been moved there.

The userspace set (represented by the USERINCLUDE make variable) contains:

	-I $(srctree)/arch/$(hdr-arch)/include/uapi
	-I arch/$(hdr-arch)/include/generated/uapi
	-I $(srctree)/include/uapi
	-I include/generated/uapi
	-include $(srctree)/include/linux/kconfig.h

and the kernelspace set (represented by the LINUXINCLUDE make variable)
contains:

	-I $(srctree)/arch/$(hdr-arch)/include
	-I arch/$(hdr-arch)/include/generated
	-I $(srctree)/include
	-I include		--- if not building in the source tree

plus everything in the USERINCLUDE set.

Then use USERINCLUDE in building the x86 boot code.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 Makefile                          |   18 ++++++++++++++----
 arch/cris/Makefile                |    4 +++-
 arch/x86/boot/Makefile            |    4 ++--
 arch/x86/boot/mkcpustr.c          |    2 ++
 arch/x86/include/asm/cpufeature.h |    2 ++
 arch/x86/kernel/cpu/mkcapflags.pl |    5 ++++-
 6 files changed, 27 insertions(+), 8 deletions(-)

diff --git a/Makefile b/Makefile
index aa8e315..d6f09dd 100644
--- a/Makefile
+++ b/Makefile
@@ -350,12 +350,22 @@ AFLAGS_KERNEL	=
 CFLAGS_GCOV	= -fprofile-arcs -ftest-coverage
 
 
+# Use USERINCLUDE when you must reference the UAPI directories only.
+USERINCLUDE    := \
+		-I$(srctree)/arch/$(hdr-arch)/include/uapi \
+		-Iarch/$(hdr-arch)/include/generated/uapi \
+		-Iinclude/uapi \
+		-Iinclude/generated/uapi \
+                -include $(srctree)/include/linux/kconfig.h
+
 # Use LINUXINCLUDE when you must reference the include/ directory.
 # Needed to be compatible with the O= option
-LINUXINCLUDE    := -I$(srctree)/arch/$(hdr-arch)/include \
-                   -Iarch/$(hdr-arch)/include/generated -Iinclude \
-                   $(if $(KBUILD_SRC), -I$(srctree)/include) \
-                   -include $(srctree)/include/linux/kconfig.h
+LINUXINCLUDE    := \
+		-I$(srctree)/arch/$(hdr-arch)/include \
+		-Iarch/$(hdr-arch)/include/generated \
+		$(if $(KBUILD_SRC), -I$(srctree)/include) \
+		-Iinclude \
+		$(USERINCLUDE)
 
 KBUILD_CPPFLAGS := -D__KERNEL__
 
diff --git a/arch/cris/Makefile b/arch/cris/Makefile
index 29c2ceb..39dc7d0 100644
--- a/arch/cris/Makefile
+++ b/arch/cris/Makefile
@@ -23,7 +23,9 @@ mach-$(CONFIG_ETRAXFS) := fs
 
 ifneq ($(arch-y),)
 SARCH := arch-$(arch-y)
-inc := -Iarch/cris/include/$(SARCH)
+inc := -Iarch/cris/include/uapi/$(SARCH)
+inc += -Iarch/cris/include/$(SARCH)
+inc += -Iarch/cris/include/uapi/$(SARCH)/arch
 inc += -Iarch/cris/include/$(SARCH)/arch
 else
 SARCH :=
diff --git a/arch/x86/boot/Makefile b/arch/x86/boot/Makefile
index 5a747dd..33607c8 100644
--- a/arch/x86/boot/Makefile
+++ b/arch/x86/boot/Makefile
@@ -37,7 +37,7 @@ setup-y		+= video-bios.o
 targets		+= $(setup-y)
 hostprogs-y	:= mkcpustr tools/build
 
-HOST_EXTRACFLAGS += -I$(srctree)/tools/include $(LINUXINCLUDE) \
+HOST_EXTRACFLAGS += -I$(srctree)/tools/include $(USERINCLUDE) \
 	            -D__EXPORTED_HEADERS__
 
 $(obj)/cpu.o: $(obj)/cpustr.h
@@ -52,7 +52,7 @@ $(obj)/cpustr.h: $(obj)/mkcpustr FORCE
 
 # How to compile the 16-bit code.  Note we always compile for -march=i386,
 # that way we can complain to the user if the CPU is insufficient.
-KBUILD_CFLAGS	:= $(LINUXINCLUDE) -g -Os -D_SETUP -D__KERNEL__ \
+KBUILD_CFLAGS	:= $(USERINCLUDE) -g -Os -D_SETUP -D__KERNEL__ \
 		   -DDISABLE_BRANCH_PROFILING \
 		   -Wall -Wstrict-prototypes \
 		   -march=i386 -mregparm=3 \
diff --git a/arch/x86/boot/mkcpustr.c b/arch/x86/boot/mkcpustr.c
index 919257f..4579eff 100644
--- a/arch/x86/boot/mkcpustr.c
+++ b/arch/x86/boot/mkcpustr.c
@@ -15,6 +15,8 @@
 
 #include <stdio.h>
 
+#include "../include/asm/required-features.h"
+#include "../include/asm/cpufeature.h"
 #include "../kernel/cpu/capflags.c"
 
 int main(void)
diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index f91e80f..c89c55d 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -4,7 +4,9 @@
 #ifndef _ASM_X86_CPUFEATURE_H
 #define _ASM_X86_CPUFEATURE_H
 
+#ifndef _ASM_X86_REQUIRED_FEATURES_H
 #include <asm/required-features.h>
+#endif
 
 #define NCAPINTS	10	/* N 32-bit words worth of info */
 
diff --git a/arch/x86/kernel/cpu/mkcapflags.pl b/arch/x86/kernel/cpu/mkcapflags.pl
index c7b3fe2..091972e 100644
--- a/arch/x86/kernel/cpu/mkcapflags.pl
+++ b/arch/x86/kernel/cpu/mkcapflags.pl
@@ -8,7 +8,10 @@
 open(IN, "< $in\0")   or die "$0: cannot open: $in: $!\n";
 open(OUT, "> $out\0") or die "$0: cannot create: $out: $!\n";
 
-print OUT "#include <asm/cpufeature.h>\n\n";
+print OUT "#ifndef _ASM_X86_CPUFEATURE_H\n";
+print OUT "#include <asm/cpufeature.h>\n";
+print OUT "#endif\n";
+print OUT "\n";
 print OUT "const char * const x86_cap_flags[NCAPINTS*32] = {\n";
 
 %features = ();

