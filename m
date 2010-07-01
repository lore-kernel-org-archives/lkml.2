Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757416Ab0GAP66 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 11:58:58 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:47058 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756985Ab0GAPyG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 11:54:06 -0400
From: Borislav Petkov <bp@amd64.org>
To: <linux-kernel@vger.kernel.org>
Subject: [PATCH 05/21] perf: rewire generic library stuff, p1
Date: Thu,  1 Jul 2010 17:55:47 +0200
Message-Id: <1277999763-20357-6-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1277999763-20357-1-git-send-email-bp@amd64.org>
References: <1277999763-20357-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Carve out generic library stuff into tools/lib/lk/ and rewire it with
perf. Add a top-level Makefile which selects between targets depending
on the tool we want to build. Also, add a Makefile.lib for common
facilities used by all the Makefiles.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 tools/Makefile              |   58 ++++++++++++++++++++++
 tools/Makefile.lib          |   28 +++++++++++
 tools/lib/Makefile          |   38 ++++++++++++++
 tools/lib/lk/bitmap.c       |   21 ++++++++
 tools/lib/lk/cpumap.c       |  114 +++++++++++++++++++++++++++++++++++++++++++
 tools/lib/lk/cpumap.h       |    7 +++
 tools/lib/lk/hweight.c      |   31 ++++++++++++
 tools/perf/Makefile         |   41 ++--------------
 tools/perf/bench/bench.h    |    2 +
 tools/perf/builtin-record.c |    2 +-
 tools/perf/builtin-stat.c   |    2 +-
 tools/perf/builtin-top.c    |    2 +-
 tools/perf/util/bitmap.c    |   21 --------
 tools/perf/util/cache.h     |    1 +
 tools/perf/util/cpumap.c    |  114 -------------------------------------------
 tools/perf/util/cpumap.h    |    7 ---
 tools/perf/util/hweight.c   |   31 ------------
 17 files changed, 308 insertions(+), 212 deletions(-)
 create mode 100644 tools/Makefile
 create mode 100644 tools/Makefile.lib
 create mode 100644 tools/lib/Makefile
 create mode 100644 tools/lib/lk/bitmap.c
 create mode 100644 tools/lib/lk/cpumap.c
 create mode 100644 tools/lib/lk/cpumap.h
 create mode 100644 tools/lib/lk/hweight.c
 delete mode 100644 tools/perf/util/bitmap.c
 delete mode 100644 tools/perf/util/cpumap.c
 delete mode 100644 tools/perf/util/cpumap.h
 delete mode 100644 tools/perf/util/hweight.c

diff --git a/tools/Makefile b/tools/Makefile
new file mode 100644
index 0000000..e645761
--- /dev/null
+++ b/tools/Makefile
@@ -0,0 +1,58 @@
+# CFLAGS and LDFLAGS are for the users to override from the command line.
+#
+
+include Makefile.lib
+
+#
+# Include saner warnings here, which can catch bugs:
+#
+EXTRA_WARNINGS := -Wformat
+EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wformat-security
+EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wformat-y2k
+EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wshadow
+EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Winit-self
+EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wpacked
+EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wredundant-decls
+EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wstack-protector
+EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wstrict-aliasing=3
+EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wswitch-default
+EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wswitch-enum
+EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wno-system-headers
+EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wundef
+EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wvolatile-register-var
+EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wwrite-strings
+EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wbad-function-cast
+EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wmissing-declarations
+EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wmissing-prototypes
+EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wnested-externs
+EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wold-style-definition
+EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wstrict-prototypes
+EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wdeclaration-after-statement
+
+export EXTRA_WARNINGS
+
+ifeq ("$(origin DEBUG)", "command line")
+  PERF_DEBUG = $(DEBUG)
+endif
+ifndef PERF_DEBUG
+  CFLAGS_OPTIMIZE = -O6
+  export CFLAGS_OPTIMIZE
+endif
+
+#
+# lib includes for submake
+BASIC_CFLAGS = -I$(CURDIR)/lib -I$(CURDIR)/perf -I$(CURDIR)/perf/util/include
+
+export BASIC_CFLAGS
+
+perf: lib .FORCE
+	$(QUIET_SUBDIR0)perf/ $(QUIET_SUBDIR1)
+
+lib: .FORCE
+	$(QUIET_SUBDIR0)lib/ $(QUIET_SUBDIR1)
+
+clean:
+	$(QUIET_SUBDIR0)lib/ $(QUIET_SUBDIR1) clean
+	$(QUIET_SUBDIR0)perf/ $(QUIET_SUBDIR1) clean
+
+.PHONY: clean .FORCE
diff --git a/tools/Makefile.lib b/tools/Makefile.lib
new file mode 100644
index 0000000..aac6be9
--- /dev/null
+++ b/tools/Makefile.lib
@@ -0,0 +1,28 @@
+QUIET_SUBDIR0  = +$(MAKE) -C # space to separate -C and subdir
+QUIET_SUBDIR1  =
+
+ifneq ($(findstring $(MAKEFLAGS),w),w)
+PRINT_DIR = --no-print-directory
+else # "make -w"
+NO_SUBDIR = :
+endif
+
+ifneq ($(findstring $(MAKEFLAGS),s),s)
+ifndef V
+	QUIET_CC       = @echo '   ' CC $@;
+	QUIET_AR       = @echo '   ' AR $@;
+	QUIET_LINK     = @echo '   ' LINK $@;
+	QUIET_BUILT_IN = @echo '   ' BUILTIN $@;
+	QUIET_GEN      = @echo '   ' GEN $@;
+	QUIET_SUBDIR0  = +@subdir=
+	QUIET_SUBDIR1  = ;$(NO_SUBDIR) echo '   ' SUBDIR $$subdir; \
+			 $(MAKE) $(PRINT_DIR) -C $$subdir
+	export V
+	export QUIET_GEN
+	export QUIET_BUILT_IN
+endif
+endif
+
+ifeq ("$(origin O)", "command line")
+	OUTPUT := $(O)/
+endif
diff --git a/tools/lib/Makefile b/tools/lib/Makefile
new file mode 100644
index 0000000..48f8e21
--- /dev/null
+++ b/tools/lib/Makefile
@@ -0,0 +1,38 @@
+include ../Makefile.lib
+
+# Guard against environment variables
+LIB_H =
+LIB_OBJS =
+
+LIB_H += lk/cpumap.h
+
+LIB_OBJS += $(OUTPUT)lk/bitmap.o
+LIB_OBJS += $(OUTPUT)lk/cpumap.o
+LIB_OBJS += $(OUTPUT)lk/hweight.o
+
+LIBFILE = lklib.a
+
+RM = rm -f
+
+CFLAGS = -ggdb3 -Wall -Wextra -std=gnu99 -Werror $(CFLAGS_OPTIMIZE) -D_FORTIFY_SOURCE=2 $(EXTRA_WARNINGS) $(EXTRA_CFLAGS)
+EXTLIBS = -lpthread -lrt -lelf -lm
+ALL_CFLAGS = $(CFLAGS) $(BASIC_CFLAGS) -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64
+ALL_LDFLAGS = $(LDFLAGS)
+STRIP ?= strip
+
+$(LIBFILE): $(LIB_OBJS)
+	$(QUIET_AR)$(RM) $@ && $(AR) rcs $@ $(LIB_OBJS)
+
+$(LIB_OBJS): $(LIB_H)
+
+$(OUTPUT)%.o: %.c
+	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) $<
+$(OUTPUT)%.s: %.c
+	$(QUIET_CC)$(CC) -S $(ALL_CFLAGS) $<
+$(OUTPUT)%.o: %.S
+	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) $<
+
+clean:
+	$(RM) $(LIB_OBJS)
+
+.PHONY: clean
diff --git a/tools/lib/lk/bitmap.c b/tools/lib/lk/bitmap.c
new file mode 100644
index 0000000..5e230ac
--- /dev/null
+++ b/tools/lib/lk/bitmap.c
@@ -0,0 +1,21 @@
+/*
+ * From lib/bitmap.c
+ * Helper functions for bitmap.h.
+ *
+ * This source code is licensed under the GNU General Public License,
+ * Version 2.  See the file COPYING for more details.
+ */
+#include <linux/bitmap.h>
+
+int __bitmap_weight(const unsigned long *bitmap, int bits)
+{
+	int k, w = 0, lim = bits/BITS_PER_LONG;
+
+	for (k = 0; k < lim; k++)
+		w += hweight_long(bitmap[k]);
+
+	if (bits % BITS_PER_LONG)
+		w += hweight_long(bitmap[k] & BITMAP_LAST_WORD_MASK(bits));
+
+	return w;
+}
diff --git a/tools/lib/lk/cpumap.c b/tools/lib/lk/cpumap.c
new file mode 100644
index 0000000..71e376b
--- /dev/null
+++ b/tools/lib/lk/cpumap.c
@@ -0,0 +1,114 @@
+#include <util/util.h>
+#include <perf.h>
+#include "cpumap.h"
+#include <assert.h>
+#include <stdio.h>
+
+int cpumap[MAX_NR_CPUS];
+
+static int default_cpu_map(void)
+{
+	int nr_cpus, i;
+
+	nr_cpus = sysconf(_SC_NPROCESSORS_ONLN);
+	assert(nr_cpus <= MAX_NR_CPUS);
+	assert((int)nr_cpus >= 0);
+
+	for (i = 0; i < nr_cpus; ++i)
+		cpumap[i] = i;
+
+	return nr_cpus;
+}
+
+static int read_all_cpu_map(void)
+{
+	FILE *onlnf;
+	int nr_cpus = 0;
+	int n, cpu, prev;
+	char sep;
+
+	onlnf = fopen("/sys/devices/system/cpu/online", "r");
+	if (!onlnf)
+		return default_cpu_map();
+
+	sep = 0;
+	prev = -1;
+	for (;;) {
+		n = fscanf(onlnf, "%u%c", &cpu, &sep);
+		if (n <= 0)
+			break;
+		if (prev >= 0) {
+			assert(nr_cpus + cpu - prev - 1 < MAX_NR_CPUS);
+			while (++prev < cpu)
+				cpumap[nr_cpus++] = prev;
+		}
+		assert (nr_cpus < MAX_NR_CPUS);
+		cpumap[nr_cpus++] = cpu;
+		if (n == 2 && sep == '-')
+			prev = cpu;
+		else
+			prev = -1;
+		if (n == 1 || sep == '\n')
+			break;
+	}
+	fclose(onlnf);
+	if (nr_cpus > 0)
+		return nr_cpus;
+
+	return default_cpu_map();
+}
+
+int read_cpu_map(const char *cpu_list)
+{
+	unsigned long start_cpu, end_cpu = 0;
+	char *p = NULL;
+	int i, nr_cpus = 0;
+
+	if (!cpu_list)
+		return read_all_cpu_map();
+
+	if (!isdigit(*cpu_list))
+		goto invalid;
+
+	while (isdigit(*cpu_list)) {
+		p = NULL;
+		start_cpu = strtoul(cpu_list, &p, 0);
+		if (start_cpu >= INT_MAX
+		    || (*p != '\0' && *p != ',' && *p != '-'))
+			goto invalid;
+
+		if (*p == '-') {
+			cpu_list = ++p;
+			p = NULL;
+			end_cpu = strtoul(cpu_list, &p, 0);
+
+			if (end_cpu >= INT_MAX || (*p != '\0' && *p != ','))
+				goto invalid;
+
+			if (end_cpu < start_cpu)
+				goto invalid;
+		} else {
+			end_cpu = start_cpu;
+		}
+
+		for (; start_cpu <= end_cpu; start_cpu++) {
+			/* check for duplicates */
+			for (i = 0; i < nr_cpus; i++)
+				if (cpumap[i] == (int)start_cpu)
+					goto invalid;
+
+			assert(nr_cpus < MAX_NR_CPUS);
+			cpumap[nr_cpus++] = (int)start_cpu;
+		}
+		if (*p)
+			++p;
+
+		cpu_list = p;
+	}
+	if (nr_cpus > 0)
+		return nr_cpus;
+
+	return default_cpu_map();
+invalid:
+	return -1;
+}
diff --git a/tools/lib/lk/cpumap.h b/tools/lib/lk/cpumap.h
new file mode 100644
index 0000000..1d7bd56
--- /dev/null
+++ b/tools/lib/lk/cpumap.h
@@ -0,0 +1,7 @@
+#ifndef __LK_CPUMAP_H
+#define __LK_CPUMAP_H
+
+extern int read_cpu_map(const char *cpu_list);
+extern int cpumap[];
+
+#endif /* __LK_CPUMAP_H */
diff --git a/tools/lib/lk/hweight.c b/tools/lib/lk/hweight.c
new file mode 100644
index 0000000..5c1d0d0
--- /dev/null
+++ b/tools/lib/lk/hweight.c
@@ -0,0 +1,31 @@
+#include <linux/bitops.h>
+
+/**
+ * hweightN - returns the hamming weight of a N-bit word
+ * @x: the word to weigh
+ *
+ * The Hamming Weight of a number is the total number of bits set in it.
+ */
+
+unsigned int hweight32(unsigned int w)
+{
+	unsigned int res = w - ((w >> 1) & 0x55555555);
+	res = (res & 0x33333333) + ((res >> 2) & 0x33333333);
+	res = (res + (res >> 4)) & 0x0F0F0F0F;
+	res = res + (res >> 8);
+	return (res + (res >> 16)) & 0x000000FF;
+}
+
+unsigned long hweight64(__u64 w)
+{
+#if BITS_PER_LONG == 32
+	return hweight32((unsigned int)(w >> 32)) + hweight32((unsigned int)w);
+#elif BITS_PER_LONG == 64
+	__u64 res = w - ((w >> 1) & 0x5555555555555555ul);
+	res = (res & 0x3333333333333333ul) + ((res >> 2) & 0x3333333333333333ul);
+	res = (res + (res >> 4)) & 0x0F0F0F0F0F0F0F0Ful;
+	res = res + (res >> 8);
+	res = res + (res >> 16);
+	return (res + (res >> 32)) & 0x00000000000000FFul;
+#endif
+}
diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 6aa2fe3..df815d6 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -1,6 +1,4 @@
-ifeq ("$(origin O)", "command line")
-	OUTPUT := $(O)/
-endif
+include ../Makefile.lib
 
 # The default target of this Makefile is...
 all::
@@ -191,33 +189,6 @@ $(shell sh -c 'mkdir -p $(OUTPUT)arch/$(ARCH)/util/' 2> /dev/null)
 
 # CFLAGS and LDFLAGS are for the users to override from the command line.
 
-#
-# Include saner warnings here, which can catch bugs:
-#
-
-EXTRA_WARNINGS := -Wformat
-EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wformat-security
-EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wformat-y2k
-EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wshadow
-EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Winit-self
-EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wpacked
-EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wredundant-decls
-EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wstack-protector
-EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wstrict-aliasing=3
-EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wswitch-default
-EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wswitch-enum
-EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wno-system-headers
-EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wundef
-EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wvolatile-register-var
-EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wwrite-strings
-EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wbad-function-cast
-EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wmissing-declarations
-EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wmissing-prototypes
-EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wnested-externs
-EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wold-style-definition
-EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wstrict-prototypes
-EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wdeclaration-after-statement
-
 ifeq ("$(origin DEBUG)", "command line")
   PERF_DEBUG = $(DEBUG)
 endif
@@ -297,7 +268,7 @@ endif
 # Those must not be GNU-specific; they are shared with perl/ which may
 # be built by a different compiler. (Note that this is an artifact now
 # but it still might be nice to keep that distinction.)
-BASIC_CFLAGS = -Iutil/include -Iarch/$(ARCH)/include
+BASIC_CFLAGS += -Iutil/include -Iarch/$(ARCH)/include
 BASIC_LDFLAGS =
 
 # Guard against environment variables
@@ -413,7 +384,6 @@ LIB_H += util/trace-event.h
 LIB_H += util/probe-finder.h
 LIB_H += util/probe-event.h
 LIB_H += util/pstack.h
-LIB_H += util/cpumap.h
 
 LIB_OBJS += $(OUTPUT)util/abspath.o
 LIB_OBJS += $(OUTPUT)util/alias.o
@@ -430,8 +400,6 @@ LIB_OBJS += $(OUTPUT)util/parse-options.o
 LIB_OBJS += $(OUTPUT)util/parse-events.o
 LIB_OBJS += $(OUTPUT)util/path.o
 LIB_OBJS += $(OUTPUT)util/rbtree.o
-LIB_OBJS += $(OUTPUT)util/bitmap.o
-LIB_OBJS += $(OUTPUT)util/hweight.o
 LIB_OBJS += $(OUTPUT)util/run-command.o
 LIB_OBJS += $(OUTPUT)util/quote.o
 LIB_OBJS += $(OUTPUT)util/strbuf.o
@@ -460,7 +428,6 @@ LIB_OBJS += $(OUTPUT)util/sort.o
 LIB_OBJS += $(OUTPUT)util/hist.o
 LIB_OBJS += $(OUTPUT)util/probe-event.o
 LIB_OBJS += $(OUTPUT)util/util.o
-LIB_OBJS += $(OUTPUT)util/cpumap.o
 
 BUILTIN_OBJS += $(OUTPUT)builtin-annotate.o
 
@@ -490,7 +457,9 @@ BUILTIN_OBJS += $(OUTPUT)builtin-kvm.o
 BUILTIN_OBJS += $(OUTPUT)builtin-test.o
 BUILTIN_OBJS += $(OUTPUT)builtin-inject.o
 
-PERFLIBS = $(LIB_FILE)
+LKLIB = ../lib/lklib.a
+
+PERFLIBS = $(LIB_FILE) $(LKLIB)
 
 #
 # Platform specific tweaks
diff --git a/tools/perf/bench/bench.h b/tools/perf/bench/bench.h
index f7781c6..0c7ee07 100644
--- a/tools/perf/bench/bench.h
+++ b/tools/perf/bench/bench.h
@@ -1,6 +1,8 @@
 #ifndef BENCH_H
 #define BENCH_H
 
+#include <linux/compiler.h>
+
 extern int bench_sched_messaging(int argc, const char **argv, const char *prefix);
 extern int bench_sched_pipe(int argc, const char **argv, const char *prefix);
 extern int bench_mem_memcpy(int argc, const char **argv, const char *prefix __used);
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 86b1c3b..499dc75 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -21,7 +21,7 @@
 #include "util/debug.h"
 #include "util/session.h"
 #include "util/symbol.h"
-#include "util/cpumap.h"
+#include <lk/cpumap.h>
 
 #include <unistd.h>
 #include <sched.h>
diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index a6b4d44..4430d51 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -45,7 +45,7 @@
 #include "util/event.h"
 #include "util/debug.h"
 #include "util/header.h"
-#include "util/cpumap.h"
+#include <lk/cpumap.h>
 #include "util/thread.h"
 
 #include <sys/prctl.h>
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 1e8e92e..def254a 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -28,7 +28,7 @@
 #include <linux/rbtree.h>
 #include "util/parse-options.h"
 #include "util/parse-events.h"
-#include "util/cpumap.h"
+#include <lk/cpumap.h>
 
 #include "util/debug.h"
 
diff --git a/tools/perf/util/bitmap.c b/tools/perf/util/bitmap.c
deleted file mode 100644
index 5e230ac..0000000
--- a/tools/perf/util/bitmap.c
+++ /dev/null
@@ -1,21 +0,0 @@
-/*
- * From lib/bitmap.c
- * Helper functions for bitmap.h.
- *
- * This source code is licensed under the GNU General Public License,
- * Version 2.  See the file COPYING for more details.
- */
-#include <linux/bitmap.h>
-
-int __bitmap_weight(const unsigned long *bitmap, int bits)
-{
-	int k, w = 0, lim = bits/BITS_PER_LONG;
-
-	for (k = 0; k < lim; k++)
-		w += hweight_long(bitmap[k]);
-
-	if (bits % BITS_PER_LONG)
-		w += hweight_long(bitmap[k] & BITMAP_LAST_WORD_MASK(bits));
-
-	return w;
-}
diff --git a/tools/perf/util/cache.h b/tools/perf/util/cache.h
index 27e9ebe..0444fc2 100644
--- a/tools/perf/util/cache.h
+++ b/tools/perf/util/cache.h
@@ -5,6 +5,7 @@
 #include "util.h"
 #include "strbuf.h"
 #include "../perf.h"
+#include <linux/compiler.h>
 
 #define CMD_EXEC_PATH "--exec-path"
 #define CMD_PERF_DIR "--perf-dir="
diff --git a/tools/perf/util/cpumap.c b/tools/perf/util/cpumap.c
deleted file mode 100644
index 0f9b8d7..0000000
--- a/tools/perf/util/cpumap.c
+++ /dev/null
@@ -1,114 +0,0 @@
-#include "util.h"
-#include "../perf.h"
-#include "cpumap.h"
-#include <assert.h>
-#include <stdio.h>
-
-int cpumap[MAX_NR_CPUS];
-
-static int default_cpu_map(void)
-{
-	int nr_cpus, i;
-
-	nr_cpus = sysconf(_SC_NPROCESSORS_ONLN);
-	assert(nr_cpus <= MAX_NR_CPUS);
-	assert((int)nr_cpus >= 0);
-
-	for (i = 0; i < nr_cpus; ++i)
-		cpumap[i] = i;
-
-	return nr_cpus;
-}
-
-static int read_all_cpu_map(void)
-{
-	FILE *onlnf;
-	int nr_cpus = 0;
-	int n, cpu, prev;
-	char sep;
-
-	onlnf = fopen("/sys/devices/system/cpu/online", "r");
-	if (!onlnf)
-		return default_cpu_map();
-
-	sep = 0;
-	prev = -1;
-	for (;;) {
-		n = fscanf(onlnf, "%u%c", &cpu, &sep);
-		if (n <= 0)
-			break;
-		if (prev >= 0) {
-			assert(nr_cpus + cpu - prev - 1 < MAX_NR_CPUS);
-			while (++prev < cpu)
-				cpumap[nr_cpus++] = prev;
-		}
-		assert (nr_cpus < MAX_NR_CPUS);
-		cpumap[nr_cpus++] = cpu;
-		if (n == 2 && sep == '-')
-			prev = cpu;
-		else
-			prev = -1;
-		if (n == 1 || sep == '\n')
-			break;
-	}
-	fclose(onlnf);
-	if (nr_cpus > 0)
-		return nr_cpus;
-
-	return default_cpu_map();
-}
-
-int read_cpu_map(const char *cpu_list)
-{
-	unsigned long start_cpu, end_cpu = 0;
-	char *p = NULL;
-	int i, nr_cpus = 0;
-
-	if (!cpu_list)
-		return read_all_cpu_map();
-
-	if (!isdigit(*cpu_list))
-		goto invalid;
-
-	while (isdigit(*cpu_list)) {
-		p = NULL;
-		start_cpu = strtoul(cpu_list, &p, 0);
-		if (start_cpu >= INT_MAX
-		    || (*p != '\0' && *p != ',' && *p != '-'))
-			goto invalid;
-
-		if (*p == '-') {
-			cpu_list = ++p;
-			p = NULL;
-			end_cpu = strtoul(cpu_list, &p, 0);
-
-			if (end_cpu >= INT_MAX || (*p != '\0' && *p != ','))
-				goto invalid;
-
-			if (end_cpu < start_cpu)
-				goto invalid;
-		} else {
-			end_cpu = start_cpu;
-		}
-
-		for (; start_cpu <= end_cpu; start_cpu++) {
-			/* check for duplicates */
-			for (i = 0; i < nr_cpus; i++)
-				if (cpumap[i] == (int)start_cpu)
-					goto invalid;
-
-			assert(nr_cpus < MAX_NR_CPUS);
-			cpumap[nr_cpus++] = (int)start_cpu;
-		}
-		if (*p)
-			++p;
-
-		cpu_list = p;
-	}
-	if (nr_cpus > 0)
-		return nr_cpus;
-
-	return default_cpu_map();
-invalid:
-	return -1;
-}
diff --git a/tools/perf/util/cpumap.h b/tools/perf/util/cpumap.h
deleted file mode 100644
index 3e60f56..0000000
--- a/tools/perf/util/cpumap.h
+++ /dev/null
@@ -1,7 +0,0 @@
-#ifndef __PERF_CPUMAP_H
-#define __PERF_CPUMAP_H
-
-extern int read_cpu_map(const char *cpu_list);
-extern int cpumap[];
-
-#endif /* __PERF_CPUMAP_H */
diff --git a/tools/perf/util/hweight.c b/tools/perf/util/hweight.c
deleted file mode 100644
index 5c1d0d0..0000000
--- a/tools/perf/util/hweight.c
+++ /dev/null
@@ -1,31 +0,0 @@
-#include <linux/bitops.h>
-
-/**
- * hweightN - returns the hamming weight of a N-bit word
- * @x: the word to weigh
- *
- * The Hamming Weight of a number is the total number of bits set in it.
- */
-
-unsigned int hweight32(unsigned int w)
-{
-	unsigned int res = w - ((w >> 1) & 0x55555555);
-	res = (res & 0x33333333) + ((res >> 2) & 0x33333333);
-	res = (res + (res >> 4)) & 0x0F0F0F0F;
-	res = res + (res >> 8);
-	return (res + (res >> 16)) & 0x000000FF;
-}
-
-unsigned long hweight64(__u64 w)
-{
-#if BITS_PER_LONG == 32
-	return hweight32((unsigned int)(w >> 32)) + hweight32((unsigned int)w);
-#elif BITS_PER_LONG == 64
-	__u64 res = w - ((w >> 1) & 0x5555555555555555ul);
-	res = (res & 0x3333333333333333ul) + ((res >> 2) & 0x3333333333333333ul);
-	res = (res + (res >> 4)) & 0x0F0F0F0F0F0F0F0Ful;
-	res = res + (res >> 8);
-	res = res + (res >> 16);
-	return (res + (res >> 32)) & 0x00000000000000FFul;
-#endif
-}
-- 
1.7.1

