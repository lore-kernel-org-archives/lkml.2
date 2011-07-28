Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755449Ab1G1Pud (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 11:50:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18412 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753537Ab1G1Pu2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 11:50:28 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 06/40] UAPI: Differentiate userspace build and kernelspace
 build include path sets [ver #3]
To: torvalds@osdl.org
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
        David Howells <dhowells@redhat.com>
Date: Thu, 28 Jul 2011 16:50:21 +0100
Message-ID: <20110728155021.16618.17563.stgit@warthog.procyon.org.uk>
In-Reply-To: <20110728154920.16618.89358.stgit@warthog.procyon.org.uk>
References: <20110728154920.16618.89358.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Differentiate userspace build and kernelspace build (LINUXINCLUDE) include path
sets by adding a new make variable (USERINCLUDE) that has everything barring
the kernel-specific include paths, and then make LINUXINCLUDE simply preface
that with the kernel-specific include paths.

Then use USERINCLUDE in building the x86 boot code.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 Makefile                          |   12 ++++++++----
 arch/x86/boot/Makefile            |    4 ++--
 arch/x86/boot/mkcpustr.c          |    2 ++
 arch/x86/include/asm/cpufeature.h |    2 ++
 arch/x86/kernel/cpu/mkcapflags.pl |    5 ++++-
 5 files changed, 18 insertions(+), 7 deletions(-)

diff --git a/Makefile b/Makefile
index 68834a5..91598e4 100644
--- a/Makefile
+++ b/Makefile
@@ -355,16 +355,20 @@ AFLAGS_KERNEL	=
 CFLAGS_GCOV	= -fprofile-arcs -ftest-coverage
 
 
+# Use USERINCLUDE when you must reference the UAPI directories only.
+USERINCLUDE    := \
+		-I$(srctree)/arch/$(hdr-arch)/include/uapi \
+		-Iinclude/uapi \
+                   $(if $(KBUILD_SRC), -I$(srctree)/include) \
+                   -include include/generated/autoconf.h
+
 # Use LINUXINCLUDE when you must reference the include/ directory.
 # Needed to be compatible with the O= option
 LINUXINCLUDE    := \
 		-I$(srctree)/arch/$(hdr-arch)/include \
 		-Iarch/$(hdr-arch)/include/generated \
-		-I$(srctree)/arch/$(hdr-arch)/include/uapi \
 		-Iinclude \
-		-Iinclude/uapi \
-                   $(if $(KBUILD_SRC), -I$(srctree)/include) \
-                   -include include/generated/autoconf.h
+		$(USERINCLUDE)
 
 KBUILD_CPPFLAGS := -D__KERNEL__
 
diff --git a/arch/x86/boot/Makefile b/arch/x86/boot/Makefile
index 95365a8..86a85aa 100644
--- a/arch/x86/boot/Makefile
+++ b/arch/x86/boot/Makefile
@@ -37,7 +37,7 @@ setup-y		+= video-bios.o
 targets		+= $(setup-y)
 hostprogs-y	:= mkcpustr tools/build
 
-HOST_EXTRACFLAGS += $(LINUXINCLUDE)
+HOST_EXTRACFLAGS += $(USERINCLUDE)
 
 $(obj)/cpu.o: $(obj)/cpustr.h
 
@@ -51,7 +51,7 @@ $(obj)/cpustr.h: $(obj)/mkcpustr FORCE
 
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
index 4258aac..38ba7a6 100644
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
index dfea390..6c3c4f1 100644
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
 
 while (defined($line = <IN>)) {

