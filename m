Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752946Ab2AXXK2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 18:10:28 -0500
Received: from merlin.infradead.org ([205.233.59.134]:59167 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751473Ab2AXXIP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 18:08:15 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Jan Beulich <jbeulich@suse.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 5/9] perf bench: Also allow measuring memset()
Date: Tue, 24 Jan 2012 21:07:57 -0200
Message-Id: <1327446481-5505-6-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.rc2.1.g69204
In-Reply-To: <1327446481-5505-1-git-send-email-acme@infradead.org>
References: <1327446481-5505-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Beulich <jbeulich@suse.com>

This simply clones the respective memcpy() implementation.

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/4F16D743020000780006D735@nat28.tlf.novell.com
Signed-off-by: Jan Beulich <jbeulich@suse.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile                          |    4 +-
 tools/perf/bench/bench.h                     |    1 +
 tools/perf/bench/mem-memset-arch.h           |   12 +
 tools/perf/bench/mem-memset-x86-64-asm-def.h |   12 +
 tools/perf/bench/mem-memset-x86-64-asm.S     |    6 +
 tools/perf/bench/mem-memset.c                |  291 ++++++++++++++++++++++++++
 tools/perf/builtin-bench.c                   |    3 +
 tools/perf/util/include/asm/dwarf2.h         |    4 +-
 8 files changed, 331 insertions(+), 2 deletions(-)
 create mode 100644 tools/perf/bench/mem-memset-arch.h
 create mode 100644 tools/perf/bench/mem-memset-x86-64-asm-def.h
 create mode 100644 tools/perf/bench/mem-memset-x86-64-asm.S
 create mode 100644 tools/perf/bench/mem-memset.c

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index ac86d67..599031a 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -61,7 +61,7 @@ ifeq ($(ARCH),x86_64)
 	ifeq (${IS_X86_64}, 1)
 		RAW_ARCH := x86_64
 		ARCH_CFLAGS := -DARCH_X86_64
-		ARCH_INCLUDE = ../../arch/x86/lib/memcpy_64.S
+		ARCH_INCLUDE = ../../arch/x86/lib/memcpy_64.S ../../arch/x86/lib/memset_64.S
 	endif
 endif
 
@@ -362,8 +362,10 @@ BUILTIN_OBJS += $(OUTPUT)bench/sched-messaging.o
 BUILTIN_OBJS += $(OUTPUT)bench/sched-pipe.o
 ifeq ($(RAW_ARCH),x86_64)
 BUILTIN_OBJS += $(OUTPUT)bench/mem-memcpy-x86-64-asm.o
+BUILTIN_OBJS += $(OUTPUT)bench/mem-memset-x86-64-asm.o
 endif
 BUILTIN_OBJS += $(OUTPUT)bench/mem-memcpy.o
+BUILTIN_OBJS += $(OUTPUT)bench/mem-memset.o
 
 BUILTIN_OBJS += $(OUTPUT)builtin-diff.o
 BUILTIN_OBJS += $(OUTPUT)builtin-evlist.o
diff --git a/tools/perf/bench/bench.h b/tools/perf/bench/bench.h
index f7781c6..a09bece 100644
--- a/tools/perf/bench/bench.h
+++ b/tools/perf/bench/bench.h
@@ -4,6 +4,7 @@
 extern int bench_sched_messaging(int argc, const char **argv, const char *prefix);
 extern int bench_sched_pipe(int argc, const char **argv, const char *prefix);
 extern int bench_mem_memcpy(int argc, const char **argv, const char *prefix __used);
+extern int bench_mem_memset(int argc, const char **argv, const char *prefix);
 
 #define BENCH_FORMAT_DEFAULT_STR	"default"
 #define BENCH_FORMAT_DEFAULT		0
diff --git a/tools/perf/bench/mem-memset-arch.h b/tools/perf/bench/mem-memset-arch.h
new file mode 100644
index 0000000..a040fa7
--- /dev/null
+++ b/tools/perf/bench/mem-memset-arch.h
@@ -0,0 +1,12 @@
+
+#ifdef ARCH_X86_64
+
+#define MEMSET_FN(fn, name, desc)		\
+	extern void *fn(void *, int, size_t);
+
+#include "mem-memset-x86-64-asm-def.h"
+
+#undef MEMSET_FN
+
+#endif
+
diff --git a/tools/perf/bench/mem-memset-x86-64-asm-def.h b/tools/perf/bench/mem-memset-x86-64-asm-def.h
new file mode 100644
index 0000000..a71dff9
--- /dev/null
+++ b/tools/perf/bench/mem-memset-x86-64-asm-def.h
@@ -0,0 +1,12 @@
+
+MEMSET_FN(__memset,
+	"x86-64-unrolled",
+	"unrolled memset() in arch/x86/lib/memset_64.S")
+
+MEMSET_FN(memset_c,
+	"x86-64-stosq",
+	"movsq-based memset() in arch/x86/lib/memset_64.S")
+
+MEMSET_FN(memset_c_e,
+	"x86-64-stosb",
+	"movsb-based memset() in arch/x86/lib/memset_64.S")
diff --git a/tools/perf/bench/mem-memset-x86-64-asm.S b/tools/perf/bench/mem-memset-x86-64-asm.S
new file mode 100644
index 0000000..cb92170
--- /dev/null
+++ b/tools/perf/bench/mem-memset-x86-64-asm.S
@@ -0,0 +1,6 @@
+#define memset MEMSET /* don't hide glibc's memset() */
+#define altinstr_replacement text
+#define globl p2align 4; .globl
+#define Lmemset_c globl memset_c; memset_c
+#define Lmemset_c_e globl memset_c_e; memset_c_e
+#include "../../../arch/x86/lib/memset_64.S"
diff --git a/tools/perf/bench/mem-memset.c b/tools/perf/bench/mem-memset.c
new file mode 100644
index 0000000..9c0c6f0
--- /dev/null
+++ b/tools/perf/bench/mem-memset.c
@@ -0,0 +1,291 @@
+/*
+ * mem-memset.c
+ *
+ * memset: Simple memory set in various ways
+ *
+ * Trivial clone of mem-memcpy.c.
+ */
+#include <ctype.h>
+
+#include "../perf.h"
+#include "../util/util.h"
+#include "../util/parse-options.h"
+#include "../util/header.h"
+#include "bench.h"
+#include "mem-memset-arch.h"
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/time.h>
+#include <errno.h>
+
+#define K 1024
+
+static const char	*length_str	= "1MB";
+static const char	*routine	= "default";
+static bool		use_clock;
+static int		clock_fd;
+static bool		only_prefault;
+static bool		no_prefault;
+
+static const struct option options[] = {
+	OPT_STRING('l', "length", &length_str, "1MB",
+		    "Specify length of memory to copy. "
+		    "available unit: B, MB, GB (upper and lower)"),
+	OPT_STRING('r', "routine", &routine, "default",
+		    "Specify routine to copy"),
+	OPT_BOOLEAN('c', "clock", &use_clock,
+		    "Use CPU clock for measuring"),
+	OPT_BOOLEAN('o', "only-prefault", &only_prefault,
+		    "Show only the result with page faults before memset()"),
+	OPT_BOOLEAN('n', "no-prefault", &no_prefault,
+		    "Show only the result without page faults before memset()"),
+	OPT_END()
+};
+
+typedef void *(*memset_t)(void *, int, size_t);
+
+struct routine {
+	const char *name;
+	const char *desc;
+	memset_t fn;
+};
+
+static const struct routine routines[] = {
+	{ "default",
+	  "Default memset() provided by glibc",
+	  memset },
+#ifdef ARCH_X86_64
+
+#define MEMSET_FN(fn, name, desc) { name, desc, fn },
+#include "mem-memset-x86-64-asm-def.h"
+#undef MEMSET_FN
+
+#endif
+
+	{ NULL,
+	  NULL,
+	  NULL   }
+};
+
+static const char * const bench_mem_memset_usage[] = {
+	"perf bench mem memset <options>",
+	NULL
+};
+
+static struct perf_event_attr clock_attr = {
+	.type		= PERF_TYPE_HARDWARE,
+	.config		= PERF_COUNT_HW_CPU_CYCLES
+};
+
+static void init_clock(void)
+{
+	clock_fd = sys_perf_event_open(&clock_attr, getpid(), -1, -1, 0);
+
+	if (clock_fd < 0 && errno == ENOSYS)
+		die("No CONFIG_PERF_EVENTS=y kernel support configured?\n");
+	else
+		BUG_ON(clock_fd < 0);
+}
+
+static u64 get_clock(void)
+{
+	int ret;
+	u64 clk;
+
+	ret = read(clock_fd, &clk, sizeof(u64));
+	BUG_ON(ret != sizeof(u64));
+
+	return clk;
+}
+
+static double timeval2double(struct timeval *ts)
+{
+	return (double)ts->tv_sec +
+		(double)ts->tv_usec / (double)1000000;
+}
+
+static void alloc_mem(void **dst, size_t length)
+{
+	*dst = zalloc(length);
+	if (!dst)
+		die("memory allocation failed - maybe length is too large?\n");
+}
+
+static u64 do_memset_clock(memset_t fn, size_t len, bool prefault)
+{
+	u64 clock_start = 0ULL, clock_end = 0ULL;
+	void *dst = NULL;
+
+	alloc_mem(&dst, len);
+
+	if (prefault)
+		fn(dst, -1, len);
+
+	clock_start = get_clock();
+	fn(dst, 0, len);
+	clock_end = get_clock();
+
+	free(dst);
+	return clock_end - clock_start;
+}
+
+static double do_memset_gettimeofday(memset_t fn, size_t len, bool prefault)
+{
+	struct timeval tv_start, tv_end, tv_diff;
+	void *dst = NULL;
+
+	alloc_mem(&dst, len);
+
+	if (prefault)
+		fn(dst, -1, len);
+
+	BUG_ON(gettimeofday(&tv_start, NULL));
+	fn(dst, 0, len);
+	BUG_ON(gettimeofday(&tv_end, NULL));
+
+	timersub(&tv_end, &tv_start, &tv_diff);
+
+	free(dst);
+	return (double)((double)len / timeval2double(&tv_diff));
+}
+
+#define pf (no_prefault ? 0 : 1)
+
+#define print_bps(x) do {					\
+		if (x < K)					\
+			printf(" %14lf B/Sec", x);		\
+		else if (x < K * K)				\
+			printf(" %14lfd KB/Sec", x / K);	\
+		else if (x < K * K * K)				\
+			printf(" %14lf MB/Sec", x / K / K);	\
+		else						\
+			printf(" %14lf GB/Sec", x / K / K / K); \
+	} while (0)
+
+int bench_mem_memset(int argc, const char **argv,
+		     const char *prefix __used)
+{
+	int i;
+	size_t len;
+	double result_bps[2];
+	u64 result_clock[2];
+
+	argc = parse_options(argc, argv, options,
+			     bench_mem_memset_usage, 0);
+
+	if (use_clock)
+		init_clock();
+
+	len = (size_t)perf_atoll((char *)length_str);
+
+	result_clock[0] = result_clock[1] = 0ULL;
+	result_bps[0] = result_bps[1] = 0.0;
+
+	if ((s64)len <= 0) {
+		fprintf(stderr, "Invalid length:%s\n", length_str);
+		return 1;
+	}
+
+	/* same to without specifying either of prefault and no-prefault */
+	if (only_prefault && no_prefault)
+		only_prefault = no_prefault = false;
+
+	for (i = 0; routines[i].name; i++) {
+		if (!strcmp(routines[i].name, routine))
+			break;
+	}
+	if (!routines[i].name) {
+		printf("Unknown routine:%s\n", routine);
+		printf("Available routines...\n");
+		for (i = 0; routines[i].name; i++) {
+			printf("\t%s ... %s\n",
+			       routines[i].name, routines[i].desc);
+		}
+		return 1;
+	}
+
+	if (bench_format == BENCH_FORMAT_DEFAULT)
+		printf("# Copying %s Bytes ...\n\n", length_str);
+
+	if (!only_prefault && !no_prefault) {
+		/* show both of results */
+		if (use_clock) {
+			result_clock[0] =
+				do_memset_clock(routines[i].fn, len, false);
+			result_clock[1] =
+				do_memset_clock(routines[i].fn, len, true);
+		} else {
+			result_bps[0] =
+				do_memset_gettimeofday(routines[i].fn,
+						len, false);
+			result_bps[1] =
+				do_memset_gettimeofday(routines[i].fn,
+						len, true);
+		}
+	} else {
+		if (use_clock) {
+			result_clock[pf] =
+				do_memset_clock(routines[i].fn,
+						len, only_prefault);
+		} else {
+			result_bps[pf] =
+				do_memset_gettimeofday(routines[i].fn,
+						len, only_prefault);
+		}
+	}
+
+	switch (bench_format) {
+	case BENCH_FORMAT_DEFAULT:
+		if (!only_prefault && !no_prefault) {
+			if (use_clock) {
+				printf(" %14lf Clock/Byte\n",
+					(double)result_clock[0]
+					/ (double)len);
+				printf(" %14lf Clock/Byte (with prefault)\n ",
+					(double)result_clock[1]
+					/ (double)len);
+			} else {
+				print_bps(result_bps[0]);
+				printf("\n");
+				print_bps(result_bps[1]);
+				printf(" (with prefault)\n");
+			}
+		} else {
+			if (use_clock) {
+				printf(" %14lf Clock/Byte",
+					(double)result_clock[pf]
+					/ (double)len);
+			} else
+				print_bps(result_bps[pf]);
+
+			printf("%s\n", only_prefault ? " (with prefault)" : "");
+		}
+		break;
+	case BENCH_FORMAT_SIMPLE:
+		if (!only_prefault && !no_prefault) {
+			if (use_clock) {
+				printf("%lf %lf\n",
+					(double)result_clock[0] / (double)len,
+					(double)result_clock[1] / (double)len);
+			} else {
+				printf("%lf %lf\n",
+					result_bps[0], result_bps[1]);
+			}
+		} else {
+			if (use_clock) {
+				printf("%lf\n", (double)result_clock[pf]
+					/ (double)len);
+			} else
+				printf("%lf\n", result_bps[pf]);
+		}
+		break;
+	default:
+		/* reaching this means there's some disaster: */
+		die("unknown format: %d\n", bench_format);
+		break;
+	}
+
+	return 0;
+}
diff --git a/tools/perf/builtin-bench.c b/tools/perf/builtin-bench.c
index fcb9626..b0e74ab 100644
--- a/tools/perf/builtin-bench.c
+++ b/tools/perf/builtin-bench.c
@@ -52,6 +52,9 @@ static struct bench_suite mem_suites[] = {
 	{ "memcpy",
 	  "Simple memory copy in various ways",
 	  bench_mem_memcpy },
+	{ "memset",
+	  "Simple memory set in various ways",
+	  bench_mem_memset },
 	suite_all,
 	{ NULL,
 	  NULL,
diff --git a/tools/perf/util/include/asm/dwarf2.h b/tools/perf/util/include/asm/dwarf2.h
index bb4198e..afe3819 100644
--- a/tools/perf/util/include/asm/dwarf2.h
+++ b/tools/perf/util/include/asm/dwarf2.h
@@ -2,10 +2,12 @@
 #ifndef PERF_DWARF2_H
 #define PERF_DWARF2_H
 
-/* dwarf2.h ... dummy header file for including arch/x86/lib/memcpy_64.S */
+/* dwarf2.h ... dummy header file for including arch/x86/lib/mem{cpy,set}_64.S */
 
 #define CFI_STARTPROC
 #define CFI_ENDPROC
+#define CFI_REMEMBER_STATE
+#define CFI_RESTORE_STATE
 
 #endif	/* PERF_DWARF2_H */
 
-- 
1.7.9.rc2.1.g69204

