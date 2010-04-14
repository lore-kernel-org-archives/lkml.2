Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753096Ab0DNFHn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 01:07:43 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:36254 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752786Ab0DNFHl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 01:07:41 -0400
From: "Ian Munsie" <imunsie@au1.ibm.com>
To: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Cc: benh@kernel.crashing.org, Masami Hiramatsu <mhiramat@redhat.com>,
       Ian Munsie <imunsie@au1.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH v2 1/2] perf: Move arch specific code into separate arch directory
Date: Wed, 14 Apr 2010 15:06:38 +1000
Message-Id: <1271221600-25533-2-git-send-email-imunsie@au.ibm.com>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <1271221600-25533-1-git-send-email-imunsie@au.ibm.com>
References: <1271221600-25533-1-git-send-email-imunsie@au.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Munsie <imunsie@au.ibm.com>

The perf userspace tool included some architecture specific code to map
registers from the DWARF register number into the names used by the regs
and stack access API.

This patch moves the architecture specific code out into a separate
arch/x86 directory along with the infrastructure required to use it.

Signed-off-by: Ian Munsie <imunsie@au.ibm.com>
---
Changes since v1: From Masami Hiramatsu's suggestion, I added a check in the
Makefile for if the arch specific Makefile defines PERF_HAVE_DWARF_REGS,
printing a message during build if it has not. This simplifies the code
removing the odd macro from the previous version and the need for an arch
specific arch_dwarf-regs.h. I have not entirely disabled DWARF support for
architectures that don't implement the register mappings, so that they can
still add a probe based on a line number (they will be missing the ability to
capture the value of a variable from a register).

 tools/perf/Makefile                   |   27 ++++++++++-
 tools/perf/arch/x86/Makefile          |    2 +
 tools/perf/arch/x86/util/dwarf-regs.c |   75 +++++++++++++++++++++++++++++++++
 tools/perf/util/include/dwarf-regs.h  |    6 +++
 tools/perf/util/probe-finder.c        |   56 +++----------------------
 5 files changed, 113 insertions(+), 53 deletions(-)
 create mode 100644 tools/perf/arch/x86/Makefile
 create mode 100644 tools/perf/arch/x86/util/dwarf-regs.c
 create mode 100644 tools/perf/util/include/dwarf-regs.h

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 57b3569..7f71daf 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -173,6 +173,20 @@ uname_R := $(shell sh -c 'uname -r 2>/dev/null || echo not')
 uname_P := $(shell sh -c 'uname -p 2>/dev/null || echo not')
 uname_V := $(shell sh -c 'uname -v 2>/dev/null || echo not')
 
+ARCH ?= $(shell echo $(uname_M) | sed -e s/i.86/i386/ -e s/sun4u/sparc64/ \
+				  -e s/arm.*/arm/ -e s/sa110/arm/ \
+				  -e s/s390x/s390/ -e s/parisc64/parisc/ \
+				  -e s/ppc.*/powerpc/ -e s/mips.*/mips/ \
+				  -e s/sh[234].*/sh/ )
+
+# Additional ARCH settings for x86
+ifeq ($(ARCH),i386)
+        ARCH := x86
+endif
+ifeq ($(ARCH),x86_64)
+        ARCH := x86
+endif
+
 # CFLAGS and LDFLAGS are for the users to override from the command line.
 
 #
@@ -285,7 +299,7 @@ endif
 # Those must not be GNU-specific; they are shared with perl/ which may
 # be built by a different compiler. (Note that this is an artifact now
 # but it still might be nice to keep that distinction.)
-BASIC_CFLAGS = -Iutil/include
+BASIC_CFLAGS = -Iutil/include -Iarch/$(ARCH)/include
 BASIC_LDFLAGS =
 
 # Guard against environment variables
@@ -367,6 +381,7 @@ LIB_H += util/include/asm/byteorder.h
 LIB_H += util/include/asm/swab.h
 LIB_H += util/include/asm/system.h
 LIB_H += util/include/asm/uaccess.h
+LIB_H += util/include/dwarf-regs.h
 LIB_H += perf.h
 LIB_H += util/cache.h
 LIB_H += util/callchain.h
@@ -485,6 +500,7 @@ PERFLIBS = $(LIB_FILE)
 
 -include config.mak.autogen
 -include config.mak
+-include arch/$(ARCH)/Makefile
 
 ifeq ($(uname_S),Darwin)
 	ifndef NO_FINK
@@ -525,8 +541,13 @@ ifndef NO_DWARF
 	BASIC_CFLAGS += -I/usr/include/elfutils -DDWARF_SUPPORT
 	EXTLIBS += -lelf -ldw
 	LIB_OBJS += $(OUTPUT)util/probe-finder.o
-endif
-endif
+ifneq ($(origin PERF_HAVE_DWARF_REGS), undefined)
+	BASIC_CFLAGS += -I/usr/include/elfutils -DPERF_HAVE_DWARF_REGS
+else
+	msg := $(warning DWARF register mappings have not been defined for architecture $(ARCH), DWARF support will be limited);
+endif # PERF_HAVE_DWARF_REGS
+endif # NO_DWARF
+endif # Dwarf support
 
 ifneq ($(shell sh -c "(echo '\#include <newt.h>'; echo 'int main(void) { newtInit(); newtCls(); return newtFinished(); }') | $(CC) -x c - $(ALL_CFLAGS) -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -lnewt -o $(BITBUCKET) $(ALL_LDFLAGS) $(EXTLIBS) "$(QUIET_STDERR)" && echo y"), y)
 	msg := $(warning newt not found, disables TUI support. Please install newt-devel or libnewt-dev);
diff --git a/tools/perf/arch/x86/Makefile b/tools/perf/arch/x86/Makefile
new file mode 100644
index 0000000..cbd7833
--- /dev/null
+++ b/tools/perf/arch/x86/Makefile
@@ -0,0 +1,2 @@
+PERF_HAVE_DWARF_REGS := 1
+LIB_OBJS += $(OUTPUT)arch/$(ARCH)/util/dwarf-regs.o
diff --git a/tools/perf/arch/x86/util/dwarf-regs.c b/tools/perf/arch/x86/util/dwarf-regs.c
new file mode 100644
index 0000000..a794d30
--- /dev/null
+++ b/tools/perf/arch/x86/util/dwarf-regs.c
@@ -0,0 +1,75 @@
+/*
+ * dwarf-regs.c : Mapping of DWARF debug register numbers into register names.
+ * Extracted from probe-finder.c
+ *
+ * Written by Masami Hiramatsu <mhiramat@redhat.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ *
+ */
+
+#include <libio.h>
+#include <dwarf-regs.h>
+
+/*
+ * Generic dwarf analysis helpers
+ */
+
+#define X86_32_MAX_REGS 8
+const char *x86_32_regs_table[X86_32_MAX_REGS] = {
+	"%ax",
+	"%cx",
+	"%dx",
+	"%bx",
+	"$stack",	/* Stack address instead of %sp */
+	"%bp",
+	"%si",
+	"%di",
+};
+
+#define X86_64_MAX_REGS 16
+const char *x86_64_regs_table[X86_64_MAX_REGS] = {
+	"%ax",
+	"%dx",
+	"%cx",
+	"%bx",
+	"%si",
+	"%di",
+	"%bp",
+	"%sp",
+	"%r8",
+	"%r9",
+	"%r10",
+	"%r11",
+	"%r12",
+	"%r13",
+	"%r14",
+	"%r15",
+};
+
+/* TODO: switching by dwarf address size */
+#ifdef __x86_64__
+#define ARCH_MAX_REGS X86_64_MAX_REGS
+#define arch_regs_table x86_64_regs_table
+#else
+#define ARCH_MAX_REGS X86_32_MAX_REGS
+#define arch_regs_table x86_32_regs_table
+#endif
+
+/* Return architecture dependent register string (for kprobe-tracer) */
+const char *get_arch_regstr(unsigned int n)
+{
+	return (n <= ARCH_MAX_REGS) ? arch_regs_table[n] : NULL;
+}
diff --git a/tools/perf/util/include/dwarf-regs.h b/tools/perf/util/include/dwarf-regs.h
new file mode 100644
index 0000000..7cfe6e2
--- /dev/null
+++ b/tools/perf/util/include/dwarf-regs.h
@@ -0,0 +1,6 @@
+#ifndef _PERF_DWARF_REGS_H_
+#define _PERF_DWARF_REGS_H_
+
+const char *get_arch_regstr(unsigned int n);
+
+#endif
diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index a851377..e6fbc81 100644
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -31,6 +31,7 @@
 #include <string.h>
 #include <stdarg.h>
 #include <ctype.h>
+#include <dwarf-regs.h>
 
 #include "string.h"
 #include "event.h"
@@ -38,57 +39,12 @@
 #include "util.h"
 #include "probe-finder.h"
 
-
-/*
- * Generic dwarf analysis helpers
- */
-
-#define X86_32_MAX_REGS 8
-const char *x86_32_regs_table[X86_32_MAX_REGS] = {
-	"%ax",
-	"%cx",
-	"%dx",
-	"%bx",
-	"$stack",	/* Stack address instead of %sp */
-	"%bp",
-	"%si",
-	"%di",
-};
-
-#define X86_64_MAX_REGS 16
-const char *x86_64_regs_table[X86_64_MAX_REGS] = {
-	"%ax",
-	"%dx",
-	"%cx",
-	"%bx",
-	"%si",
-	"%di",
-	"%bp",
-	"%sp",
-	"%r8",
-	"%r9",
-	"%r10",
-	"%r11",
-	"%r12",
-	"%r13",
-	"%r14",
-	"%r15",
-};
-
-/* TODO: switching by dwarf address size */
-#ifdef __x86_64__
-#define ARCH_MAX_REGS X86_64_MAX_REGS
-#define arch_regs_table x86_64_regs_table
-#else
-#define ARCH_MAX_REGS X86_32_MAX_REGS
-#define arch_regs_table x86_32_regs_table
-#endif
-
-/* Return architecture dependent register string (for kprobe-tracer) */
-static const char *get_arch_regstr(unsigned int n)
+#ifndef PERF_HAVE_DWARF_REGS
+const char *get_arch_regstr(unsigned int n __attribute__((unused)))
 {
-	return (n <= ARCH_MAX_REGS) ? arch_regs_table[n] : NULL;
+	return NULL;
 }
+#endif
 
 /*
  * Compare the tail of two strings.
@@ -397,7 +353,7 @@ static void convert_location(Dwarf_Op *op, struct probe_finder *pf)
 
 	regs = get_arch_regstr(regn);
 	if (!regs)
-		die("%u exceeds max register number.", regn);
+		die("Mapping for DWARF register number %u missing on this architecture.", regn);
 
 	tvar->value = xstrdup(regs);
 	if (ref) {
-- 
1.7.0

