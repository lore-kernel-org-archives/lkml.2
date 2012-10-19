Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030511Ab2JSQ4f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 12:56:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54317 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030439Ab2JSQ4d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 12:56:33 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 3/5] perf: Make perf build for x86 with UAPI disintegration
 applied
To: mingo@kernel.org, tglx@linutronix.de, acme@ghostprotocols.net
Cc: dhowells@redhat.com, davem@davemloft.net, torvalds@linux-foundation.org,
        paulus@samba.org, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org
Date: Fri, 19 Oct 2012 17:56:24 +0100
Message-ID: <20121019165624.23037.1780.stgit@warthog.procyon.org.uk>
In-Reply-To: <20121019165558.23037.40181.stgit@warthog.procyon.org.uk>
References: <20121019165558.23037.40181.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make perf build for x86 once the UAPI disintegration patches for that arch
have been applied by adding the appropriate -I flags - in the right order -
and then converting some #includes that use ../.. notation to find main kernel
headerfiles to use <asm/foo.h> and <linux/foo.h> instead.

Note that -Iarch/foo/include/uapi is present _before_ -Iarch/foo/include.
This makes sure we get the userspace version of the pt_regs struct.  Ideally,
we wouldn't have the latter -I flag at all, but unfortunately we want
asm/svm.h and asm/vmx.h in buildin-kvm.c and these aren't part of the UAPI -
at least not for x86.  I wonder if the bits outside of the __KERNEL__ guards
*should* be transferred there.

I note also that perf seems to do its dependency handling manually by listing
all the header files it might want to use in LIB_H in the Makefile.  Can this
be changed to use -MD?

Signed-off-by: David Howells <dhowells@redhat.com>
---

 tools/perf/Makefile      |   16 +++++++++++++++-
 tools/perf/builtin-kvm.c |    6 +++---
 tools/perf/perf.h        |   16 +++-------------
 3 files changed, 21 insertions(+), 17 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index f7c968a..9024a42 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -169,7 +169,21 @@ endif
 
 ### --- END CONFIGURATION SECTION ---
 
-BASIC_CFLAGS = -Iutil/include -Iarch/$(ARCH)/include -I$(OUTPUT)util -I$(TRACE_EVENT_DIR) -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -D_GNU_SOURCE
+ifeq ($(srctree),)
+srctree := $(shell pwd)
+endif
+
+BASIC_CFLAGS = \
+	-Iutil/include \
+	-Iarch/$(ARCH)/include \
+	-I$(objtree)/arch/$(ARCH)/include/generated/uapi \
+	-I$(srctree)/arch/$(ARCH)/include/uapi \
+	-I$(srctree)/arch/$(ARCH)/include \
+	-I$(objtree)/include/generated/uapi \
+	-I$(srctree)/include/uapi \
+	-I$(OUTPUT)util \
+	-I$(TRACE_EVENT_DIR) \
+	-D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -D_GNU_SOURCE
 BASIC_LDFLAGS =
 
 # Guard against environment variables
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
diff --git a/tools/perf/perf.h b/tools/perf/perf.h
index 2762877..238f923 100644
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
@@ -50,35 +47,30 @@ void get_term_dimensions(struct winsize *ws);
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
 

