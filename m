Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752006Ab0KYHFL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 02:05:11 -0500
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:52033 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751374Ab0KYHFJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 02:05:09 -0500
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, mitake@dcl.info.waseda.ac.jp,
        h.mitake@gmail.com, Miao Xie <miaox@cn.fujitsu.com>,
        Ma Ling <ling.ma@intel.com>, Zhao Yakui <yakui.zhao@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Andi Kleen <andi@firstfloor.org>
Subject: [PATCH v2 2/2] perf bench: port arch/x86/lib/memcpy_64.S to perf bench mem memcpy
Date: Thu, 25 Nov 2010 16:04:53 +0900
Message-Id: <1290668693-27068-2-git-send-email-mitake@dcl.info.waseda.ac.jp>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <4CEE0A66.6000409@dcl.info.waseda.ac.jp>
References: <4CEE0A66.6000409@dcl.info.waseda.ac.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch ports arch/x86/lib/memcpy_64.S to perf bench mem memcpy
for benchmarking memcpy() in userland with tricky and dirty way.

util/include/asm/cpufeature.h, util/include/asm/dwarf2.h, and
util/include/linux/linkage.h are dummy (but do a little work) for
including memcpy_64.S without modification to it (e.g. defining ENTRY()).

This makes checkpatch.pl angry like this:
\#177: FILE: tools/perf/util/include/linux/linkage.h:7:
+#define ENTRY(name)                            \
+       .globl name;                            \
+       name:

WARNING: labels should not be indented
\#179: FILE: tools/perf/util/include/linux/linkage.h:9:
+       name:

because checkpatch.pl treat this file as the file written in C.
But I think this can be forgived because original include/linux/linkage.h
is doing the similar thing.

Signed-off-by: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: Miao Xie <miaox@cn.fujitsu.com>
Cc: Ma Ling <ling.ma@intel.com>
Cc: Zhao Yakui <yakui.zhao@intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Andi Kleen <andi@firstfloor.org>
---
 tools/perf/Makefile                          |   11 +++++++++++
 tools/perf/bench/mem-memcpy-arch.h           |   12 ++++++++++++
 tools/perf/bench/mem-memcpy-x86-64-asm-def.h |    4 ++++
 tools/perf/bench/mem-memcpy-x86-64-asm.S     |    2 ++
 tools/perf/util/include/asm/cpufeature.h     |    9 +++++++++
 tools/perf/util/include/asm/dwarf2.h         |   11 +++++++++++
 tools/perf/util/include/linux/linkage.h      |   13 +++++++++++++
 7 files changed, 62 insertions(+), 0 deletions(-)
 create mode 100644 tools/perf/bench/mem-memcpy-arch.h
 create mode 100644 tools/perf/bench/mem-memcpy-x86-64-asm-def.h
 create mode 100644 tools/perf/bench/mem-memcpy-x86-64-asm.S
 create mode 100644 tools/perf/util/include/asm/cpufeature.h
 create mode 100644 tools/perf/util/include/asm/dwarf2.h
 create mode 100644 tools/perf/util/include/linux/linkage.h

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 2d414b3..b3e6bc6 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -185,7 +185,10 @@ ifeq ($(ARCH),i386)
         ARCH := x86
 endif
 ifeq ($(ARCH),x86_64)
+	RAW_ARCH := x86_64
         ARCH := x86
+	ARCH_CFLAGS := -DARCH_X86_64
+	ARCH_INCLUDE = ../../arch/x86/lib/memcpy_64.S
 endif
 
 # CFLAGS and LDFLAGS are for the users to override from the command line.
@@ -375,6 +378,7 @@ LIB_H += util/include/linux/prefetch.h
 LIB_H += util/include/linux/rbtree.h
 LIB_H += util/include/linux/string.h
 LIB_H += util/include/linux/types.h
+LIB_H += util/include/linux/linkage.h
 LIB_H += util/include/asm/asm-offsets.h
 LIB_H += util/include/asm/bug.h
 LIB_H += util/include/asm/byteorder.h
@@ -383,6 +387,8 @@ LIB_H += util/include/asm/swab.h
 LIB_H += util/include/asm/system.h
 LIB_H += util/include/asm/uaccess.h
 LIB_H += util/include/dwarf-regs.h
+LIB_H += util/include/asm/dwarf2.h
+LIB_H += util/include/asm/cpufeature.h
 LIB_H += perf.h
 LIB_H += util/cache.h
 LIB_H += util/callchain.h
@@ -417,6 +423,7 @@ LIB_H += util/probe-finder.h
 LIB_H += util/probe-event.h
 LIB_H += util/pstack.h
 LIB_H += util/cpumap.h
+LIB_H += $(ARCH_INCLUDE)
 
 LIB_OBJS += $(OUTPUT)util/abspath.o
 LIB_OBJS += $(OUTPUT)util/alias.o
@@ -472,6 +479,9 @@ BUILTIN_OBJS += $(OUTPUT)builtin-bench.o
 # Benchmark modules
 BUILTIN_OBJS += $(OUTPUT)bench/sched-messaging.o
 BUILTIN_OBJS += $(OUTPUT)bench/sched-pipe.o
+ifeq ($(RAW_ARCH),x86_64)
+BUILTIN_OBJS += $(OUTPUT)bench/mem-memcpy-x86-64-asm.o
+endif
 BUILTIN_OBJS += $(OUTPUT)bench/mem-memcpy.o
 
 BUILTIN_OBJS += $(OUTPUT)builtin-diff.o
@@ -909,6 +919,7 @@ BASIC_CFLAGS += -DSHA1_HEADER='$(SHA1_HEADER_SQ)' \
 LIB_OBJS += $(COMPAT_OBJS)
 
 ALL_CFLAGS += $(BASIC_CFLAGS)
+ALL_CFLAGS += $(ARCH_CFLAGS)
 ALL_LDFLAGS += $(BASIC_LDFLAGS)
 
 export TAR INSTALL DESTDIR SHELL_PATH
diff --git a/tools/perf/bench/mem-memcpy-arch.h b/tools/perf/bench/mem-memcpy-arch.h
new file mode 100644
index 0000000..a72e36c
--- /dev/null
+++ b/tools/perf/bench/mem-memcpy-arch.h
@@ -0,0 +1,12 @@
+
+#ifdef ARCH_X86_64
+
+#define MEMCPY_FN(fn, name, desc)		\
+	extern void *fn(void *, const void *, size_t);
+
+#include "mem-memcpy-x86-64-asm-def.h"
+
+#undef MEMCPY_FN
+
+#endif
+
diff --git a/tools/perf/bench/mem-memcpy-x86-64-asm-def.h b/tools/perf/bench/mem-memcpy-x86-64-asm-def.h
new file mode 100644
index 0000000..d588b87
--- /dev/null
+++ b/tools/perf/bench/mem-memcpy-x86-64-asm-def.h
@@ -0,0 +1,4 @@
+
+MEMCPY_FN(__memcpy,
+	"x86-64-unrolled",
+	"unrolled memcpy() in arch/x86/lib/memcpy_64.S")
diff --git a/tools/perf/bench/mem-memcpy-x86-64-asm.S b/tools/perf/bench/mem-memcpy-x86-64-asm.S
new file mode 100644
index 0000000..a57b66e
--- /dev/null
+++ b/tools/perf/bench/mem-memcpy-x86-64-asm.S
@@ -0,0 +1,2 @@
+
+#include "../../../arch/x86/lib/memcpy_64.S"
diff --git a/tools/perf/util/include/asm/cpufeature.h b/tools/perf/util/include/asm/cpufeature.h
new file mode 100644
index 0000000..acffd5e
--- /dev/null
+++ b/tools/perf/util/include/asm/cpufeature.h
@@ -0,0 +1,9 @@
+
+#ifndef PERF_CPUFEATURE_H
+#define PERF_CPUFEATURE_H
+
+/* cpufeature.h ... dummy header file for including arch/x86/lib/memcpy_64.S */
+
+#define X86_FEATURE_REP_GOOD 0
+
+#endif	/* PERF_CPUFEATURE_H */
diff --git a/tools/perf/util/include/asm/dwarf2.h b/tools/perf/util/include/asm/dwarf2.h
new file mode 100644
index 0000000..bb4198e
--- /dev/null
+++ b/tools/perf/util/include/asm/dwarf2.h
@@ -0,0 +1,11 @@
+
+#ifndef PERF_DWARF2_H
+#define PERF_DWARF2_H
+
+/* dwarf2.h ... dummy header file for including arch/x86/lib/memcpy_64.S */
+
+#define CFI_STARTPROC
+#define CFI_ENDPROC
+
+#endif	/* PERF_DWARF2_H */
+
diff --git a/tools/perf/util/include/linux/linkage.h b/tools/perf/util/include/linux/linkage.h
new file mode 100644
index 0000000..06387cf
--- /dev/null
+++ b/tools/perf/util/include/linux/linkage.h
@@ -0,0 +1,13 @@
+
+#ifndef PERF_LINUX_LINKAGE_H_
+#define PERF_LINUX_LINKAGE_H_
+
+/* linkage.h ... for including arch/x86/lib/memcpy_64.S */
+
+#define ENTRY(name)				\
+	.globl name;				\
+	name:
+
+#define ENDPROC(name)
+
+#endif	/* PERF_LINUX_LINKAGE_H_ */
-- 
1.6.5.2

