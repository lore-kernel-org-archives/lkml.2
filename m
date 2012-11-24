Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932399Ab2KXAVD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 19:21:03 -0500
Received: from merlin.infradead.org ([205.233.59.134]:44248 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932337Ab2KXAVB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 19:21:01 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>
Subject: [PATCH 6/8] perf: Make perf build for x86 with UAPI disintegration applied
Date: Fri, 23 Nov 2012 21:20:51 -0300
Message-Id: <1353716453-9693-7-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1353716453-9693-1-git-send-email-acme@infradead.org>
References: <1353716453-9693-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Howells <dhowells@redhat.com>

Make perf build for x86 once the UAPI disintegration patches for that arch
have been applied by adding the appropriate -I flags - in the right order -
and then converting some #includes that use ../.. notation to find main kernel
headerfiles to use <asm/foo.h> and <linux/foo.h> instead.

Note that -Iarch/foo/include/uapi is present _before_ -Iarch/foo/include.
This makes sure we get the userspace version of the pt_regs struct.  Ideally,
we wouldn't have the latter -I flag at all, but unfortunately we want
asm/svm.h and asm/vmx.h in builtin-kvm.c and these aren't part of the UAPI -
at least not for x86.  I wonder if the bits outside of the __KERNEL__ guards
*should* be transferred there.

I note also that perf seems to do its dependency handling manually by listing
all the header files it might want to use in LIB_H in the Makefile.  Can this
be changed to use -MD?

Note that to do make this work, we need to export and UAPI disintegrate
linux/hw_breakpoint.h, which I think should've been exported previously so that
perf can access the bits.  We have to do this in the same patch to maintain
bisectability.

Signed-off-by: David Howells <dhowells@redhat.com>
---
 include/linux/hw_breakpoint.h           |   31 +------------------------------
 include/uapi/linux/Kbuild               |    1 +
 include/uapi/linux/hw_breakpoint.h      |   30 ++++++++++++++++++++++++++++++
 tools/perf/Makefile                     |   29 ++++++++++++++++++++++++++++-
 tools/perf/arch/x86/include/perf_regs.h |    2 +-
 tools/perf/builtin-kvm.c                |    6 +++---
 tools/perf/builtin-test.c               |    2 +-
 tools/perf/perf.h                       |   16 +++-------------
 tools/perf/util/evsel.c                 |    4 ++--
 tools/perf/util/evsel.h                 |    3 ++-
 tools/perf/util/header.h                |    2 +-
 tools/perf/util/parse-events-test.c     |    2 +-
 tools/perf/util/parse-events.c          |    2 +-
 tools/perf/util/parse-events.h          |    2 +-
 tools/perf/util/pmu.h                   |    2 +-
 tools/perf/util/session.h               |    2 +-
 16 files changed, 78 insertions(+), 58 deletions(-)
 create mode 100644 include/uapi/linux/hw_breakpoint.h

diff --git a/include/linux/hw_breakpoint.h b/include/linux/hw_breakpoint.h
index 6ae9c63..0464c85 100644
--- a/include/linux/hw_breakpoint.h
+++ b/include/linux/hw_breakpoint.h
@@ -1,35 +1,8 @@
 #ifndef _LINUX_HW_BREAKPOINT_H
 #define _LINUX_HW_BREAKPOINT_H
 
-enum {
-	HW_BREAKPOINT_LEN_1 = 1,
-	HW_BREAKPOINT_LEN_2 = 2,
-	HW_BREAKPOINT_LEN_4 = 4,
-	HW_BREAKPOINT_LEN_8 = 8,
-};
-
-enum {
-	HW_BREAKPOINT_EMPTY	= 0,
-	HW_BREAKPOINT_R		= 1,
-	HW_BREAKPOINT_W		= 2,
-	HW_BREAKPOINT_RW	= HW_BREAKPOINT_R | HW_BREAKPOINT_W,
-	HW_BREAKPOINT_X		= 4,
-	HW_BREAKPOINT_INVALID   = HW_BREAKPOINT_RW | HW_BREAKPOINT_X,
-};
-
-enum bp_type_idx {
-	TYPE_INST 	= 0,
-#ifdef CONFIG_HAVE_MIXED_BREAKPOINTS_REGS
-	TYPE_DATA	= 0,
-#else
-	TYPE_DATA	= 1,
-#endif
-	TYPE_MAX
-};
-
-#ifdef __KERNEL__
-
 #include <linux/perf_event.h>
+#include <uapi/linux/hw_breakpoint.h>
 
 #ifdef CONFIG_HAVE_HW_BREAKPOINT
 
@@ -151,6 +124,4 @@ static inline struct arch_hw_breakpoint *counter_arch_bp(struct perf_event *bp)
 }
 
 #endif /* CONFIG_HAVE_HW_BREAKPOINT */
-#endif /* __KERNEL__ */
-
 #endif /* _LINUX_HW_BREAKPOINT_H */
diff --git a/include/uapi/linux/Kbuild b/include/uapi/linux/Kbuild
index e194387..19e765f 100644
--- a/include/uapi/linux/Kbuild
+++ b/include/uapi/linux/Kbuild
@@ -415,3 +415,4 @@ header-y += wireless.h
 header-y += x25.h
 header-y += xattr.h
 header-y += xfrm.h
+header-y += hw_breakpoint.h
diff --git a/include/uapi/linux/hw_breakpoint.h b/include/uapi/linux/hw_breakpoint.h
new file mode 100644
index 0000000..b04000a
--- /dev/null
+++ b/include/uapi/linux/hw_breakpoint.h
@@ -0,0 +1,30 @@
+#ifndef _UAPI_LINUX_HW_BREAKPOINT_H
+#define _UAPI_LINUX_HW_BREAKPOINT_H
+
+enum {
+	HW_BREAKPOINT_LEN_1 = 1,
+	HW_BREAKPOINT_LEN_2 = 2,
+	HW_BREAKPOINT_LEN_4 = 4,
+	HW_BREAKPOINT_LEN_8 = 8,
+};
+
+enum {
+	HW_BREAKPOINT_EMPTY	= 0,
+	HW_BREAKPOINT_R		= 1,
+	HW_BREAKPOINT_W		= 2,
+	HW_BREAKPOINT_RW	= HW_BREAKPOINT_R | HW_BREAKPOINT_W,
+	HW_BREAKPOINT_X		= 4,
+	HW_BREAKPOINT_INVALID   = HW_BREAKPOINT_RW | HW_BREAKPOINT_X,
+};
+
+enum bp_type_idx {
+	TYPE_INST 	= 0,
+#ifdef CONFIG_HAVE_MIXED_BREAKPOINTS_REGS
+	TYPE_DATA	= 0,
+#else
+	TYPE_DATA	= 1,
+#endif
+	TYPE_MAX
+};
+
+#endif /* _UAPI_LINUX_HW_BREAKPOINT_H */
diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 00deed4d..0a619af 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -169,7 +169,34 @@ endif
 
 ### --- END CONFIGURATION SECTION ---
 
-BASIC_CFLAGS = -Iutil/include -Iarch/$(ARCH)/include -I$(OUTPUT)util -I$(TRACE_EVENT_DIR) -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -D_GNU_SOURCE
+ifeq ($(srctree),)
+srctree := $(patsubst %/,%,$(dir $(shell pwd)))
+srctree := $(patsubst %/,%,$(dir $(srctree)))
+#$(info Determined 'srctree' to be $(srctree))
+endif
+
+ifneq ($(objtree),)
+#$(info Determined 'objtree' to be $(objtree))
+endif
+
+ifneq ($(OUTPUT),)
+#$(info Determined 'OUTPUT' to be $(OUTPUT))
+endif
+
+BASIC_CFLAGS = \
+	-Iutil/include \
+	-Iarch/$(ARCH)/include \
+	$(if $(objtree),-I$(objtree)/arch/$(ARCH)/include/generated/uapi) \
+	-I$(srctree)/arch/$(ARCH)/include/uapi \
+	-I$(srctree)/arch/$(ARCH)/include \
+	$(if $(objtree),-I$(objtree)/include/generated/uapi) \
+	-I$(srctree)/include/uapi \
+	-I$(srctree)/include \
+	-I$(OUTPUT)util \
+	-Iutil \
+	-I. \
+	-I$(TRACE_EVENT_DIR) \
+	-D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -D_GNU_SOURCE
 BASIC_LDFLAGS =
 
 # Guard against environment variables
diff --git a/tools/perf/arch/x86/include/perf_regs.h b/tools/perf/arch/x86/include/perf_regs.h
index 46fc9f1..7fcdcdb 100644
--- a/tools/perf/arch/x86/include/perf_regs.h
+++ b/tools/perf/arch/x86/include/perf_regs.h
@@ -3,7 +3,7 @@
 
 #include <stdlib.h>
 #include "../../util/types.h"
-#include "../../../../../arch/x86/include/asm/perf_regs.h"
+#include <asm/perf_regs.h>
 
 #ifndef ARCH_X86_64
 #define PERF_REGS_MASK ((1ULL << PERF_REG_X86_32_MAX) - 1)
diff --git a/tools/perf/builtin-kvm.c b/tools/perf/builtin-kvm.c
index 260abc5..e013bdb 100644
--- a/tools/perf/builtin-kvm.c
+++ b/tools/perf/builtin-kvm.c
@@ -22,9 +22,9 @@
 #include <pthread.h>
 #include <math.h>
 
-#include "../../arch/x86/include/asm/svm.h"
-#include "../../arch/x86/include/asm/vmx.h"
-#include "../../arch/x86/include/asm/kvm.h"
+#include <asm/svm.h>
+#include <asm/vmx.h>
+#include <asm/kvm.h>
 
 struct event_key {
 	#define INVALID_KEY     (~0ULL)
diff --git a/tools/perf/builtin-test.c b/tools/perf/builtin-test.c
index 484f26c..5acd6e8 100644
--- a/tools/perf/builtin-test.c
+++ b/tools/perf/builtin-test.c
@@ -15,7 +15,7 @@
 #include "util/thread_map.h"
 #include "util/pmu.h"
 #include "event-parse.h"
-#include "../../include/linux/hw_breakpoint.h"
+#include <linux/hw_breakpoint.h>
 
 #include <sys/mman.h>
 
diff --git a/tools/perf/perf.h b/tools/perf/perf.h
index e2ba8f0..238f923 100644
--- a/tools/perf/perf.h
+++ b/tools/perf/perf.h
@@ -5,8 +5,9 @@ struct winsize;
 
 void get_term_dimensions(struct winsize *ws);
 
+#include <asm/unistd.h>
+
 #if defined(__i386__)
-#include "../../arch/x86/include/asm/unistd.h"
 #define rmb()		asm volatile("lock; addl $0,0(%%esp)" ::: "memory")
 #define cpu_relax()	asm volatile("rep; nop" ::: "memory");
 #define CPUINFO_PROC	"model name"
@@ -16,7 +17,6 @@ void get_term_dimensions(struct winsize *ws);
 #endif
 
 #if defined(__x86_64__)
-#include "../../arch/x86/include/asm/unistd.h"
 #define rmb()		asm volatile("lfence" ::: "memory")
 #define cpu_relax()	asm volatile("rep; nop" ::: "memory");
 #define CPUINFO_PROC	"model name"
@@ -26,20 +26,17 @@ void get_term_dimensions(struct winsize *ws);
 #endif
 
 #ifdef __powerpc__
-#include "../../arch/powerpc/include/uapi/asm/unistd.h"
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
@@ -50,35 +47,30 @@ void get_term_dimensions(struct winsize *ws);
 #endif
 
 #ifdef __hppa__
-#include "../../arch/parisc/include/asm/unistd.h"
 #define rmb()		asm volatile("" ::: "memory")
 #define cpu_relax()	asm volatile("" ::: "memory");
 #define CPUINFO_PROC	"cpu"
 #endif
 
 #ifdef __sparc__
-#include "../../arch/sparc/include/uapi/asm/unistd.h"
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
@@ -89,13 +81,11 @@ void get_term_dimensions(struct winsize *ws);
 #endif
 
 #ifdef __aarch64__
-#include "../../arch/arm64/include/asm/unistd.h"
 #define rmb()		asm volatile("dmb ld" ::: "memory")
 #define cpu_relax()	asm volatile("yield" ::: "memory")
 #endif
 
 #ifdef __mips__
-#include "../../arch/mips/include/asm/unistd.h"
 #define rmb()		asm volatile(					\
 				".set	mips2\n\t"			\
 				"sync\n\t"				\
@@ -112,7 +102,7 @@ void get_term_dimensions(struct winsize *ws);
 #include <sys/types.h>
 #include <sys/syscall.h>
 
-#include "../../include/uapi/linux/perf_event.h"
+#include <linux/perf_event.h>
 #include "util/types.h"
 #include <stdbool.h>
 
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 618d411..d144d46 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -18,8 +18,8 @@
 #include "cpumap.h"
 #include "thread_map.h"
 #include "target.h"
-#include "../../../include/linux/hw_breakpoint.h"
-#include "../../../include/uapi/linux/perf_event.h"
+#include <linux/hw_breakpoint.h>
+#include <linux/perf_event.h>
 #include "perf_regs.h"
 
 #define FD(e, x, y) (*(int *)xyarray__entry(e->fd, x, y))
diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index 6f94d6d..d99b476 100644
--- a/tools/perf/util/evsel.h
+++ b/tools/perf/util/evsel.h
@@ -3,7 +3,8 @@
 
 #include <linux/list.h>
 #include <stdbool.h>
-#include "../../../include/uapi/linux/perf_event.h"
+#include <stddef.h>
+#include <linux/perf_event.h>
 #include "types.h"
 #include "xyarray.h"
 #include "cgroup.h"
diff --git a/tools/perf/util/header.h b/tools/perf/util/header.h
index 879d215..9bc0078 100644
--- a/tools/perf/util/header.h
+++ b/tools/perf/util/header.h
@@ -1,7 +1,7 @@
 #ifndef __PERF_HEADER_H
 #define __PERF_HEADER_H
 
-#include "../../../include/uapi/linux/perf_event.h"
+#include <linux/perf_event.h>
 #include <sys/types.h>
 #include <stdbool.h>
 #include "types.h"
diff --git a/tools/perf/util/parse-events-test.c b/tools/perf/util/parse-events-test.c
index 516ecd9..6ef213b 100644
--- a/tools/perf/util/parse-events-test.c
+++ b/tools/perf/util/parse-events-test.c
@@ -3,7 +3,7 @@
 #include "evsel.h"
 #include "evlist.h"
 #include "sysfs.h"
-#include "../../../include/linux/hw_breakpoint.h"
+#include <linux/hw_breakpoint.h>
 
 #define TEST_ASSERT_VAL(text, cond) \
 do { \
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 75c7b0f..6b6d03e 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -1,4 +1,4 @@
-#include "../../../include/linux/hw_breakpoint.h"
+#include <linux/hw_breakpoint.h>
 #include "util.h"
 #include "../perf.h"
 #include "evlist.h"
diff --git a/tools/perf/util/parse-events.h b/tools/perf/util/parse-events.h
index 839230c..2820c40 100644
--- a/tools/perf/util/parse-events.h
+++ b/tools/perf/util/parse-events.h
@@ -7,7 +7,7 @@
 #include <linux/list.h>
 #include <stdbool.h>
 #include "types.h"
-#include "../../../include/uapi/linux/perf_event.h"
+#include <linux/perf_event.h>
 #include "types.h"
 
 struct list_head;
diff --git a/tools/perf/util/pmu.h b/tools/perf/util/pmu.h
index 39f3aba..fdeb8ac 100644
--- a/tools/perf/util/pmu.h
+++ b/tools/perf/util/pmu.h
@@ -2,7 +2,7 @@
 #define __PMU_H
 
 #include <linux/bitops.h>
-#include "../../../include/uapi/linux/perf_event.h"
+#include <linux/perf_event.h>
 
 enum {
 	PERF_PMU_FORMAT_VALUE_CONFIG,
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index dd64261..0eae00a 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -7,7 +7,7 @@
 #include "symbol.h"
 #include "thread.h"
 #include <linux/rbtree.h>
-#include "../../../include/uapi/linux/perf_event.h"
+#include <linux/perf_event.h>
 
 struct sample_queue;
 struct ip_callchain;
-- 
1.7.9.2.358.g22243

