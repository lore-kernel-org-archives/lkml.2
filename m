Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751954Ab2AZNdw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 08:33:52 -0500
Received: from terminus.zytor.com ([198.137.202.10]:35972 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751868Ab2AZNdu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 08:33:50 -0500
Date: Thu, 26 Jan 2012 05:33:21 -0800
From: tip-bot for Jan Beulich <jbeulich@suse.com>
Message-ID: <tip-be3de80dc2e671d9ee15e69fe9cd84d2b71e2225@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, jbeulich@suse.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        a.p.zijlstra@chello.nl, jbeulich@suse.com, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <4F16D743020000780006D735@nat28.tlf.novell.com>
References: <4F16D743020000780006D735@nat28.tlf.novell.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf bench: Also allow measuring memset()
Git-Commit-ID: be3de80dc2e671d9ee15e69fe9cd84d2b71e2225
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 26 Jan 2012 05:33:27 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  be3de80dc2e671d9ee15e69fe9cd84d2b71e2225
Gitweb:     http://git.kernel.org/tip/be3de80dc2e671d9ee15e69fe9cd84d2b71e2225
Author:     Jan Beulich <jbeulich@suse.com>
AuthorDate: Tue, 24 Jan 2012 10:03:22 -0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 24 Jan 2012 20:25:32 -0200

perf bench: Also allow measuring memset()

This simply clones the respective memcpy() implementation.

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/4F16D743020000780006D735@nat28.tlf.novell.com
Signed-off-by: Jan Beulich <jbeulich@suse.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile                             |    4 +-
 tools/perf/bench/bench.h                        |    1 +
 tools/perf/bench/mem-memset-arch.h              |   12 ++++
 tools/perf/bench/mem-memset-x86-64-asm-def.h    |   12 ++++
 tools/perf/bench/mem-memset-x86-64-asm.S        |    6 ++
 tools/perf/bench/{mem-memcpy.c => mem-memset.c} |   78 +++++++++++------------
 tools/perf/builtin-bench.c                      |    3 +
 tools/perf/util/include/asm/dwarf2.h            |    4 +-
 8 files changed, 76 insertions(+), 44 deletions(-)

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
diff --git a/tools/perf/bench/mem-memcpy.c b/tools/perf/bench/mem-memset.c
similarity index 76%
copy from tools/perf/bench/mem-memcpy.c
copy to tools/perf/bench/mem-memset.c
index db82021..9c0c6f0 100644
--- a/tools/perf/bench/mem-memcpy.c
+++ b/tools/perf/bench/mem-memset.c
@@ -1,9 +1,9 @@
 /*
- * mem-memcpy.c
+ * mem-memset.c
  *
- * memcpy: Simple memory copy in various ways
+ * memset: Simple memory set in various ways
  *
- * Written by Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
+ * Trivial clone of mem-memcpy.c.
  */
 #include <ctype.h>
 
@@ -12,7 +12,7 @@
 #include "../util/parse-options.h"
 #include "../util/header.h"
 #include "bench.h"
-#include "mem-memcpy-arch.h"
+#include "mem-memset-arch.h"
 
 #include <stdio.h>
 #include <stdlib.h>
@@ -38,29 +38,29 @@ static const struct option options[] = {
 	OPT_BOOLEAN('c', "clock", &use_clock,
 		    "Use CPU clock for measuring"),
 	OPT_BOOLEAN('o', "only-prefault", &only_prefault,
-		    "Show only the result with page faults before memcpy()"),
+		    "Show only the result with page faults before memset()"),
 	OPT_BOOLEAN('n', "no-prefault", &no_prefault,
-		    "Show only the result without page faults before memcpy()"),
+		    "Show only the result without page faults before memset()"),
 	OPT_END()
 };
 
-typedef void *(*memcpy_t)(void *, const void *, size_t);
+typedef void *(*memset_t)(void *, int, size_t);
 
 struct routine {
 	const char *name;
 	const char *desc;
-	memcpy_t fn;
+	memset_t fn;
 };
 
-struct routine routines[] = {
+static const struct routine routines[] = {
 	{ "default",
-	  "Default memcpy() provided by glibc",
-	  memcpy },
+	  "Default memset() provided by glibc",
+	  memset },
 #ifdef ARCH_X86_64
 
-#define MEMCPY_FN(fn, name, desc) { name, desc, fn },
-#include "mem-memcpy-x86-64-asm-def.h"
-#undef MEMCPY_FN
+#define MEMSET_FN(fn, name, desc) { name, desc, fn },
+#include "mem-memset-x86-64-asm-def.h"
+#undef MEMSET_FN
 
 #endif
 
@@ -69,8 +69,8 @@ struct routine routines[] = {
 	  NULL   }
 };
 
-static const char * const bench_mem_memcpy_usage[] = {
-	"perf bench mem memcpy <options>",
+static const char * const bench_mem_memset_usage[] = {
+	"perf bench mem memset <options>",
 	NULL
 };
 
@@ -106,53 +106,47 @@ static double timeval2double(struct timeval *ts)
 		(double)ts->tv_usec / (double)1000000;
 }
 
-static void alloc_mem(void **dst, void **src, size_t length)
+static void alloc_mem(void **dst, size_t length)
 {
 	*dst = zalloc(length);
 	if (!dst)
 		die("memory allocation failed - maybe length is too large?\n");
-
-	*src = zalloc(length);
-	if (!src)
-		die("memory allocation failed - maybe length is too large?\n");
 }
 
-static u64 do_memcpy_clock(memcpy_t fn, size_t len, bool prefault)
+static u64 do_memset_clock(memset_t fn, size_t len, bool prefault)
 {
 	u64 clock_start = 0ULL, clock_end = 0ULL;
-	void *src = NULL, *dst = NULL;
+	void *dst = NULL;
 
-	alloc_mem(&src, &dst, len);
+	alloc_mem(&dst, len);
 
 	if (prefault)
-		fn(dst, src, len);
+		fn(dst, -1, len);
 
 	clock_start = get_clock();
-	fn(dst, src, len);
+	fn(dst, 0, len);
 	clock_end = get_clock();
 
-	free(src);
 	free(dst);
 	return clock_end - clock_start;
 }
 
-static double do_memcpy_gettimeofday(memcpy_t fn, size_t len, bool prefault)
+static double do_memset_gettimeofday(memset_t fn, size_t len, bool prefault)
 {
 	struct timeval tv_start, tv_end, tv_diff;
-	void *src = NULL, *dst = NULL;
+	void *dst = NULL;
 
-	alloc_mem(&src, &dst, len);
+	alloc_mem(&dst, len);
 
 	if (prefault)
-		fn(dst, src, len);
+		fn(dst, -1, len);
 
 	BUG_ON(gettimeofday(&tv_start, NULL));
-	fn(dst, src, len);
+	fn(dst, 0, len);
 	BUG_ON(gettimeofday(&tv_end, NULL));
 
 	timersub(&tv_end, &tv_start, &tv_diff);
 
-	free(src);
 	free(dst);
 	return (double)((double)len / timeval2double(&tv_diff));
 }
@@ -170,7 +164,7 @@ static double do_memcpy_gettimeofday(memcpy_t fn, size_t len, bool prefault)
 			printf(" %14lf GB/Sec", x / K / K / K); \
 	} while (0)
 
-int bench_mem_memcpy(int argc, const char **argv,
+int bench_mem_memset(int argc, const char **argv,
 		     const char *prefix __used)
 {
 	int i;
@@ -179,7 +173,7 @@ int bench_mem_memcpy(int argc, const char **argv,
 	u64 result_clock[2];
 
 	argc = parse_options(argc, argv, options,
-			     bench_mem_memcpy_usage, 0);
+			     bench_mem_memset_usage, 0);
 
 	if (use_clock)
 		init_clock();
@@ -219,25 +213,25 @@ int bench_mem_memcpy(int argc, const char **argv,
 		/* show both of results */
 		if (use_clock) {
 			result_clock[0] =
-				do_memcpy_clock(routines[i].fn, len, false);
+				do_memset_clock(routines[i].fn, len, false);
 			result_clock[1] =
-				do_memcpy_clock(routines[i].fn, len, true);
+				do_memset_clock(routines[i].fn, len, true);
 		} else {
 			result_bps[0] =
-				do_memcpy_gettimeofday(routines[i].fn,
+				do_memset_gettimeofday(routines[i].fn,
 						len, false);
 			result_bps[1] =
-				do_memcpy_gettimeofday(routines[i].fn,
+				do_memset_gettimeofday(routines[i].fn,
 						len, true);
 		}
 	} else {
 		if (use_clock) {
 			result_clock[pf] =
-				do_memcpy_clock(routines[i].fn,
+				do_memset_clock(routines[i].fn,
 						len, only_prefault);
 		} else {
 			result_bps[pf] =
-				do_memcpy_gettimeofday(routines[i].fn,
+				do_memset_gettimeofday(routines[i].fn,
 						len, only_prefault);
 		}
 	}
@@ -249,7 +243,7 @@ int bench_mem_memcpy(int argc, const char **argv,
 				printf(" %14lf Clock/Byte\n",
 					(double)result_clock[0]
 					/ (double)len);
-				printf(" %14lf Clock/Byte (with prefault)\n",
+				printf(" %14lf Clock/Byte (with prefault)\n ",
 					(double)result_clock[1]
 					/ (double)len);
 			} else {
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
 
