Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756257Ab2ATUgw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 15:36:52 -0500
Received: from mga01.intel.com ([192.55.52.88]:23115 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756226Ab2ATUgs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 15:36:48 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="114538614"
From: Andi Kleen <andi@firstfloor.org>
To: acme@redhat.com
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH] perf tools: remove .. in perf includes/
Date: Fri, 20 Jan 2012 12:36:44 -0800
Message-Id: <1327091804-3984-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

The perf user space has a lot of includes with ugly .. chains. This also
makes it impossible to include any perf files from other code.

I think the original reason for this were some wrapper include files
for the kernel includes, and the explicit paths were needed to avoid
endless recursion. A better way to handle this is #include_next

- Add all the relevant directories as -I in the Makefile
- Remove (near) all the .. in include statements
- Remove unnecessary wrappers that do nothing
- Fix up some fallout

This makes the code more pleasant to read.

I did it all in one big patch to keep bisectability.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 tools/perf/Makefile                                |   10 +++-------
 tools/perf/arch/powerpc/util/header.c              |    2 +-
 tools/perf/arch/x86/util/header.c                  |    2 +-
 tools/perf/bench/bench.h                           |    2 ++
 tools/perf/bench/mem-memcpy-x86-64-asm.S           |    2 +-
 tools/perf/bench/mem-memcpy.c                      |    8 ++++----
 tools/perf/bench/sched-messaging.c                 |    8 ++++----
 tools/perf/bench/sched-pipe.c                      |    8 ++++----
 tools/perf/builtin-help.c                          |    1 +
 tools/perf/builtin-list.c                          |    1 +
 tools/perf/perf.h                                  |   17 ++++-------------
 tools/perf/scripts/perl/Perf-Trace-Util/Context.c  |    4 ++--
 tools/perf/scripts/perl/Perf-Trace-Util/Context.xs |    4 ++--
 .../perf/scripts/python/Perf-Trace-Util/Context.c  |    4 ++--
 tools/perf/util/alias.c                            |    1 +
 tools/perf/util/include/linux/const.h              |    1 -
 tools/perf/util/include/linux/poison.h             |    1 -
 tools/perf/util/include/linux/rbtree.h             |    1 -
 tools/perf/util/thread.c                           |    2 +-
 tools/perf/util/wrapper.c                          |    1 +
 20 files changed, 35 insertions(+), 45 deletions(-)
 delete mode 100644 tools/perf/util/include/linux/const.h
 delete mode 100644 tools/perf/util/include/linux/poison.h
 delete mode 100644 tools/perf/util/include/linux/rbtree.h

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index ac86d67..941159c 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -171,8 +171,9 @@ endif
 # Those must not be GNU-specific; they are shared with perl/ which may
 # be built by a different compiler. (Note that this is an artifact now
 # but it still might be nice to keep that distinction.)
-BASIC_CFLAGS = -Iutil/include -Iarch/$(ARCH)/include
-BASIC_LDFLAGS =
+BASIC_CFLAGS = -Iutil -Iutil/include -Iarch/$(ARCH)/include \
+               -Iinclude -I ../../include -I. -Iutil/ui
+BASIC_LDFLAGS = 
 
 # Guard against environment variables
 BUILTIN_OBJS =
@@ -223,22 +224,17 @@ export PERL_PATH
 LIB_FILE=$(OUTPUT)libperf.a
 
 LIB_H += ../../include/linux/perf_event.h
-LIB_H += ../../include/linux/rbtree.h
 LIB_H += ../../include/linux/list.h
-LIB_H += ../../include/linux/const.h
 LIB_H += ../../include/linux/hash.h
 LIB_H += ../../include/linux/stringify.h
 LIB_H += util/include/linux/bitmap.h
 LIB_H += util/include/linux/bitops.h
 LIB_H += util/include/linux/compiler.h
-LIB_H += util/include/linux/const.h
 LIB_H += util/include/linux/ctype.h
 LIB_H += util/include/linux/kernel.h
 LIB_H += util/include/linux/list.h
 LIB_H += util/include/linux/module.h
-LIB_H += util/include/linux/poison.h
 LIB_H += util/include/linux/prefetch.h
-LIB_H += util/include/linux/rbtree.h
 LIB_H += util/include/linux/string.h
 LIB_H += util/include/linux/types.h
 LIB_H += util/include/linux/linkage.h
diff --git a/tools/perf/arch/powerpc/util/header.c b/tools/perf/arch/powerpc/util/header.c
index eba80c2..f4b6e00 100644
--- a/tools/perf/arch/powerpc/util/header.c
+++ b/tools/perf/arch/powerpc/util/header.c
@@ -4,7 +4,7 @@
 #include <stdlib.h>
 #include <string.h>
 
-#include "../../util/header.h"
+#include "util/header.h"
 
 #define __stringify_1(x)        #x
 #define __stringify(x)          __stringify_1(x)
diff --git a/tools/perf/arch/x86/util/header.c b/tools/perf/arch/x86/util/header.c
index f940060..c7d221d 100644
--- a/tools/perf/arch/x86/util/header.c
+++ b/tools/perf/arch/x86/util/header.c
@@ -4,7 +4,7 @@
 #include <stdlib.h>
 #include <string.h>
 
-#include "../../util/header.h"
+#include "util/header.h"
 
 static inline void
 cpuid(unsigned int op, unsigned int *a, unsigned int *b, unsigned int *c,
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
diff --git a/tools/perf/bench/mem-memcpy-x86-64-asm.S b/tools/perf/bench/mem-memcpy-x86-64-asm.S
index a57b66e..1e55988 100644
--- a/tools/perf/bench/mem-memcpy-x86-64-asm.S
+++ b/tools/perf/bench/mem-memcpy-x86-64-asm.S
@@ -1,2 +1,2 @@
 
-#include "../../../arch/x86/lib/memcpy_64.S"
+#include "../../arch/x86/lib/memcpy_64.S"
diff --git a/tools/perf/bench/mem-memcpy.c b/tools/perf/bench/mem-memcpy.c
index db82021..da2e2e7 100644
--- a/tools/perf/bench/mem-memcpy.c
+++ b/tools/perf/bench/mem-memcpy.c
@@ -7,10 +7,10 @@
  */
 #include <ctype.h>
 
-#include "../perf.h"
-#include "../util/util.h"
-#include "../util/parse-options.h"
-#include "../util/header.h"
+#include "perf.h"
+#include "util/util.h"
+#include "util/parse-options.h"
+#include "util/header.h"
 #include "bench.h"
 #include "mem-memcpy-arch.h"
 
diff --git a/tools/perf/bench/sched-messaging.c b/tools/perf/bench/sched-messaging.c
index d1d1b30..50fdef3 100644
--- a/tools/perf/bench/sched-messaging.c
+++ b/tools/perf/bench/sched-messaging.c
@@ -9,10 +9,10 @@
  *
  */
 
-#include "../perf.h"
-#include "../util/util.h"
-#include "../util/parse-options.h"
-#include "../builtin.h"
+#include "perf.h"
+#include "util/util.h"
+#include "util/parse-options.h"
+#include "builtin.h"
 #include "bench.h"
 
 /* Test groups of 20 processes spraying to 20 receivers */
diff --git a/tools/perf/bench/sched-pipe.c b/tools/perf/bench/sched-pipe.c
index 0c7454f..036a79a 100644
--- a/tools/perf/bench/sched-pipe.c
+++ b/tools/perf/bench/sched-pipe.c
@@ -10,10 +10,10 @@
  *
  */
 
-#include "../perf.h"
-#include "../util/util.h"
-#include "../util/parse-options.h"
-#include "../builtin.h"
+#include "perf.h"
+#include "util/util.h"
+#include "util/parse-options.h"
+#include "builtin.h"
 #include "bench.h"
 
 #include <unistd.h>
diff --git a/tools/perf/builtin-help.c b/tools/perf/builtin-help.c
index 6d5a8a7..7d2cff6 100644
--- a/tools/perf/builtin-help.c
+++ b/tools/perf/builtin-help.c
@@ -3,6 +3,7 @@
  *
  * Builtin help command
  */
+#include <linux/compiler.h>
 #include "perf.h"
 #include "util/cache.h"
 #include "builtin.h"
diff --git a/tools/perf/builtin-list.c b/tools/perf/builtin-list.c
index 6313b6e..c6ae88a 100644
--- a/tools/perf/builtin-list.c
+++ b/tools/perf/builtin-list.c
@@ -7,6 +7,7 @@
  * Copyright (C) 2008-2009, Red Hat Inc, Ingo Molnar <mingo@redhat.com>
  * Copyright (C) 2011, Red Hat Inc, Arnaldo Carvalho de Melo <acme@redhat.com>
  */
+#include <linux/compiler.h>
 #include "builtin.h"
 
 #include "perf.h"
diff --git a/tools/perf/perf.h b/tools/perf/perf.h
index 64f8bee..95720f4 100644
--- a/tools/perf/perf.h
+++ b/tools/perf/perf.h
@@ -5,35 +5,32 @@ struct winsize;
 
 void get_term_dimensions(struct winsize *ws);
 
+#include "asm/unistd.h"
+
 #if defined(__i386__)
-#include "../../arch/x86/include/asm/unistd.h"
 #define rmb()		asm volatile("lock; addl $0,0(%%esp)" ::: "memory")
 #define cpu_relax()	asm volatile("rep; nop" ::: "memory");
 #define CPUINFO_PROC	"model name"
 #endif
 
 #if defined(__x86_64__)
-#include "../../arch/x86/include/asm/unistd.h"
 #define rmb()		asm volatile("lfence" ::: "memory")
 #define cpu_relax()	asm volatile("rep; nop" ::: "memory");
 #define CPUINFO_PROC	"model name"
 #endif
 
 #ifdef __powerpc__
-#include "../../arch/powerpc/include/asm/unistd.h"
 #define rmb()		asm volatile ("sync" ::: "memory")
 #define cpu_relax()	asm volatile ("" ::: "memory");
 #define CPUINFO_PROC	"cpu"
 #endif
 
 #ifdef __s390__
-#include "../../arch/s390/include/asm/unistd.h"
 #define rmb()		asm volatile("bcr 15,0" ::: "memory")
 #define cpu_relax()	asm volatile("" ::: "memory");
 #endif
 
 #ifdef __sh__
-#include "../../arch/sh/include/asm/unistd.h"
 #if defined(__SH4A__) || defined(__SH5__)
 # define rmb()		asm volatile("synco" ::: "memory")
 #else
@@ -44,35 +41,30 @@ void get_term_dimensions(struct winsize *ws);
 #endif
 
 #ifdef __hppa__
-#include "../../arch/parisc/include/asm/unistd.h"
 #define rmb()		asm volatile("" ::: "memory")
 #define cpu_relax()	asm volatile("" ::: "memory");
 #define CPUINFO_PROC	"cpu"
 #endif
 
 #ifdef __sparc__
-#include "../../arch/sparc/include/asm/unistd.h"
 #define rmb()		asm volatile("":::"memory")
 #define cpu_relax()	asm volatile("":::"memory")
 #define CPUINFO_PROC	"cpu"
 #endif
 
 #ifdef __alpha__
-#include "../../arch/alpha/include/asm/unistd.h"
 #define rmb()		asm volatile("mb" ::: "memory")
 #define cpu_relax()	asm volatile("" ::: "memory")
 #define CPUINFO_PROC	"cpu model"
 #endif
 
 #ifdef __ia64__
-#include "../../arch/ia64/include/asm/unistd.h"
 #define rmb()		asm volatile ("mf" ::: "memory")
 #define cpu_relax()	asm volatile ("hint @pause" ::: "memory")
 #define CPUINFO_PROC	"model name"
 #endif
 
 #ifdef __arm__
-#include "../../arch/arm/include/asm/unistd.h"
 /*
  * Use the __kuser_memory_barrier helper in the CPU helper page. See
  * arch/arm/kernel/entry-armv.S in the kernel source for details.
@@ -83,7 +75,6 @@ void get_term_dimensions(struct winsize *ws);
 #endif
 
 #ifdef __mips__
-#include "../../arch/mips/include/asm/unistd.h"
 #define rmb()		asm volatile(					\
 				".set	mips2\n\t"			\
 				"sync\n\t"				\
@@ -100,8 +91,8 @@ void get_term_dimensions(struct winsize *ws);
 #include <sys/types.h>
 #include <sys/syscall.h>
 
-#include "../../include/linux/perf_event.h"
-#include "util/types.h"
+#include "linux/perf_event.h"
+#include "types.h"
 #include <stdbool.h>
 
 struct perf_mmap {
diff --git a/tools/perf/scripts/perl/Perf-Trace-Util/Context.c b/tools/perf/scripts/perl/Perf-Trace-Util/Context.c
index 790ceba..260bcac 100644
--- a/tools/perf/scripts/perl/Perf-Trace-Util/Context.c
+++ b/tools/perf/scripts/perl/Perf-Trace-Util/Context.c
@@ -31,8 +31,8 @@
 #include "EXTERN.h"
 #include "perl.h"
 #include "XSUB.h"
-#include "../../../perf.h"
-#include "../../../util/trace-event.h"
+#include "perf.h"
+#include "util/trace-event.h"
 
 #ifndef PERL_UNUSED_VAR
 #  define PERL_UNUSED_VAR(var) if (0) var = var
diff --git a/tools/perf/scripts/perl/Perf-Trace-Util/Context.xs b/tools/perf/scripts/perl/Perf-Trace-Util/Context.xs
index c1e2ed1..846ed5a 100644
--- a/tools/perf/scripts/perl/Perf-Trace-Util/Context.xs
+++ b/tools/perf/scripts/perl/Perf-Trace-Util/Context.xs
@@ -22,8 +22,8 @@
 #include "EXTERN.h"
 #include "perl.h"
 #include "XSUB.h"
-#include "../../../perf.h"
-#include "../../../util/script-event.h"
+#include "perf.h"
+#include "script-event.h"
 
 MODULE = Perf::Trace::Context		PACKAGE = Perf::Trace::Context
 PROTOTYPES: ENABLE
diff --git a/tools/perf/scripts/python/Perf-Trace-Util/Context.c b/tools/perf/scripts/python/Perf-Trace-Util/Context.c
index 315067b..573c179 100644
--- a/tools/perf/scripts/python/Perf-Trace-Util/Context.c
+++ b/tools/perf/scripts/python/Perf-Trace-Util/Context.c
@@ -20,8 +20,8 @@
  */
 
 #include <Python.h>
-#include "../../../perf.h"
-#include "../../../util/trace-event.h"
+#include "perf.h"
+#include "util/trace-event.h"
 
 PyMODINIT_FUNC initperf_trace_context(void);
 
diff --git a/tools/perf/util/alias.c b/tools/perf/util/alias.c
index b8144e8..2dc6cce 100644
--- a/tools/perf/util/alias.c
+++ b/tools/perf/util/alias.c
@@ -1,3 +1,4 @@
+#include <linux/compiler.h>
 #include "cache.h"
 
 static const char *alias_key;
diff --git a/tools/perf/util/include/linux/const.h b/tools/perf/util/include/linux/const.h
deleted file mode 100644
index 1b476c9..0000000
--- a/tools/perf/util/include/linux/const.h
+++ /dev/null
@@ -1 +0,0 @@
-#include "../../../../include/linux/const.h"
diff --git a/tools/perf/util/include/linux/poison.h b/tools/perf/util/include/linux/poison.h
deleted file mode 100644
index fef6dbc..0000000
--- a/tools/perf/util/include/linux/poison.h
+++ /dev/null
@@ -1 +0,0 @@
-#include "../../../../include/linux/poison.h"
diff --git a/tools/perf/util/include/linux/rbtree.h b/tools/perf/util/include/linux/rbtree.h
deleted file mode 100644
index 7a243a1..0000000
--- a/tools/perf/util/include/linux/rbtree.h
+++ /dev/null
@@ -1 +0,0 @@
-#include "../../../../include/linux/rbtree.h"
diff --git a/tools/perf/util/thread.c b/tools/perf/util/thread.c
index fb4b7ea..11e217a 100644
--- a/tools/perf/util/thread.c
+++ b/tools/perf/util/thread.c
@@ -1,4 +1,4 @@
-#include "../perf.h"
+#include "perf.h"
 #include <stdlib.h>
 #include <stdio.h>
 #include <string.h>
diff --git a/tools/perf/util/wrapper.c b/tools/perf/util/wrapper.c
index 73e900e..e9901a7 100644
--- a/tools/perf/util/wrapper.c
+++ b/tools/perf/util/wrapper.c
@@ -1,6 +1,7 @@
 /*
  * Various trivial helper wrappers around standard functions
  */
+#include <linux/compiler.h>
 #include "cache.h"
 
 /*
-- 
1.7.7.5

