Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934126Ab0J2QBw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 12:01:52 -0400
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:61313 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934022Ab0J2QBr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 12:01:47 -0400
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, mitake@dcl.info.waseda.ac.jp,
        h.mitake@gmail.com, "Ma Ling:" <ling.ma@intel.com>,
        Zhao Yakui <yakui.zhao@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 2/2] perf bench: add x86-64 specific benchmarks to perf bench mem memcpy
Date: Sat, 30 Oct 2010 01:01:38 +0900
Message-Id: <1288368098-26121-2-git-send-email-mitake@dcl.info.waseda.ac.jp>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1288368098-26121-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
References: <1288368098-26121-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds new file: mem-memcpy-x86-64-asm.S
for x86-64 specific memcpy() benchmarking.
Added new benchmarks are,
 x86-64-rep:      memcpy() implemented with rep instruction
 x86-64-unrolled: unrolled memcpy()

Original idea of including the source files of kernel
for benchmarking is suggested by Ingo Molnar.
This is more effective than write-once programs for quantitative
evaluation of in-kernel, little and leaf functions called high frequently.
Because perf bench is in kernel source tree and executing it
on various hardwares, especially new model CPUs, is easy.

This way can also be used for other functions of kernel e.g. checksum functions.

Example of usage on Core i3 M330:

| % ./perf bench mem memcpy -l 500MB
| # Running mem/memcpy benchmark...
| # Copying 500MB Bytes from 0x7f911f94c010 to 0x7f913ed4d010 ...
|
|      578.732506 MB/Sec
| % ./perf bench mem memcpy -l 500MB -r x86-64-rep
| # Running mem/memcpy benchmark...
| # Copying 500MB Bytes from 0x7fb4b6fe4010 to 0x7fb4d63e5010 ...
|
|      738.184980 MB/Sec
| % ./perf bench mem memcpy -l 500MB -r x86-64-unrolled
| # Running mem/memcpy benchmark...
| # Copying 500MB Bytes from 0x7f6f2e668010 to 0x7f6f4da69010 ...
|
|      767.483269 MB/Sec

This shows clearly that unrolled memcpy() is efficient
than rep version and glibc's one :)

# checkpatch.pl warns about two externs in bench/mem-memcpy.c
# added by this patch. But I think it is no problem.

Signed-off-by: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: Ma Ling: <ling.ma@intel.com>
Cc: Zhao Yakui <yakui.zhao@intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: H. Peter Anvin <hpa@zytor.com>
---
 tools/perf/Makefile                      |    8 ++++++++
 tools/perf/bench/mem-memcpy-x86-64-asm.S |    4 ++++
 tools/perf/bench/mem-memcpy.c            |   14 ++++++++++++++
 3 files changed, 26 insertions(+), 0 deletions(-)
 create mode 100644 tools/perf/bench/mem-memcpy-x86-64-asm.S

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index d1db0f6..540020e 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -183,9 +183,12 @@ ARCH ?= $(shell echo $(uname_M) | sed -e s/i.86/i386/ -e s/sun4u/sparc64/ \
 # Additional ARCH settings for x86
 ifeq ($(ARCH),i386)
         ARCH := x86
+	ARCH_CFLAGS = -DARCH_X86_64
 endif
 ifeq ($(ARCH),x86_64)
         ARCH := x86
+	ARCH_CFLAGS = -DARCH_X86_64
+	ARCH_INCLUDE = ../../arch/x86/lib/memcpy_64.S
 endif
 
 # CFLAGS and LDFLAGS are for the users to override from the command line.
@@ -417,6 +420,7 @@ LIB_H += util/probe-finder.h
 LIB_H += util/probe-event.h
 LIB_H += util/pstack.h
 LIB_H += util/cpumap.h
+LIB_H += $(ARCH_INCLUDE)
 
 LIB_OBJS += $(OUTPUT)util/abspath.o
 LIB_OBJS += $(OUTPUT)util/alias.o
@@ -472,6 +476,9 @@ BUILTIN_OBJS += $(OUTPUT)builtin-bench.o
 # Benchmark modules
 BUILTIN_OBJS += $(OUTPUT)bench/sched-messaging.o
 BUILTIN_OBJS += $(OUTPUT)bench/sched-pipe.o
+ifeq ($(ARCH),x86)
+BUILTIN_OBJS += $(OUTPUT)bench/mem-memcpy-x86-64-asm.o
+endif
 BUILTIN_OBJS += $(OUTPUT)bench/mem-memcpy.o
 
 BUILTIN_OBJS += $(OUTPUT)builtin-diff.o
@@ -898,6 +905,7 @@ BASIC_CFLAGS += -DSHA1_HEADER='$(SHA1_HEADER_SQ)' \
 LIB_OBJS += $(COMPAT_OBJS)
 
 ALL_CFLAGS += $(BASIC_CFLAGS)
+ALL_CFLAGS += $(ARCH_CFLAGS)
 ALL_LDFLAGS += $(BASIC_LDFLAGS)
 
 export TAR INSTALL DESTDIR SHELL_PATH
diff --git a/tools/perf/bench/mem-memcpy-x86-64-asm.S b/tools/perf/bench/mem-memcpy-x86-64-asm.S
new file mode 100644
index 0000000..6246d94
--- /dev/null
+++ b/tools/perf/bench/mem-memcpy-x86-64-asm.S
@@ -0,0 +1,4 @@
+
+#define PERF_BENCH
+
+#include "../../../arch/x86/lib/memcpy_64.S"
diff --git a/tools/perf/bench/mem-memcpy.c b/tools/perf/bench/mem-memcpy.c
index 38dae74..ba73f39 100644
--- a/tools/perf/bench/mem-memcpy.c
+++ b/tools/perf/bench/mem-memcpy.c
@@ -19,6 +19,11 @@
 #include <sys/time.h>
 #include <errno.h>
 
+#ifdef ARCH_X86_64
+extern void *memcpy_x86_64_unrolled(void *to, const void *from, size_t len);
+extern void *memcpy_x86_64_rep(void *to, const void *from, size_t len);
+#endif
+
 #define K 1024
 
 static const char	*length_str	= "1MB";
@@ -47,6 +52,15 @@ struct routine routines[] = {
 	{ "default",
 	  "Default memcpy() provided by glibc",
 	  memcpy },
+#ifdef ARCH_X86_64
+	{ "x86-64-unrolled",
+	  "unrolled memcpy() in arch/x86/lib/memcpy_64.S",
+	  memcpy_x86_64_unrolled },
+	{ "x86-64-rep",
+	  "memcpy() implemented with rep instruction"
+	  " in arch/x86/lib/memcpy_64.S",
+	  memcpy_x86_64_rep },
+#endif
 	{ NULL,
 	  NULL,
 	  NULL   }
-- 
1.7.1.1

