Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756332Ab2JZGEj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 02:04:39 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:56819 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756296Ab2JZGEh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 02:04:37 -0400
X-AuditID: 9c930197-b7c4aae000004160-be-508a27f4eb14
From: Namhyung Kim <namhyung@kernel.org>
To: David Howells <dhowells@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>, mingo@kernel.org,
        tglx@linutronix.de, davem@davemloft.net, torvalds@linux-foundation.org,
        paulus@samba.org, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org
Subject: Re: [RFC][PATCH 0/5] tools, perf: Fix up for x86 UAPI disintegration
References: <20121024194619.GC17945@liondog.tnic>
	<20121019165558.23037.40181.stgit@warthog.procyon.org.uk>
	<20121024184337.GD13993@ghostprotocols.net>
	<8477.1351151840@warthog.procyon.org.uk>
	<87liet97jk.fsf@sejong.aot.lge.com>
Date: Fri, 26 Oct 2012 15:04:36 +0900
In-Reply-To: <87liet97jk.fsf@sejong.aot.lge.com> (Namhyung Kim's message of
	"Fri, 26 Oct 2012 13:33:19 +0900")
Message-ID: <878vat93bf.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This time, I tried on tip/master since it seemed that it contains
related patches already.

At first I got a conflict with davem's change:

--- a/tools/perf/perf.h
+++ b/tools/perf/perf.h
@@@ -57,7 -53,6 +53,10 @@@ void get_term_dimensions(struct winsiz
  #endif
  
  #ifdef __sparc__
++<<<<<<< HEAD
 +#include "../../arch/sparc/include/uapi/asm/unistd.h"
++=======
++>>>>>>> perf: Make perf build for x86 with UAPI disintegration applied
  #define rmb()         asm volatile("":::"memory")
  #define cpu_relax()   asm volatile("":::"memory")
  #define CPUINFO_PROC  "cpu"


After resolving it, I got a tons of error mostly about redeclaration of
enum contants.  I managed to build perf with below patch:


------------ 8< ------------------- 8< -----------------
diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index da040ff69b2b..7a73f37696b7 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -170,7 +170,11 @@ endif
 ### --- END CONFIGURATION SECTION ---
 
 ifeq ($(srctree),)
-srctree := $(shell pwd)
+srctree := $(shell cd ../../; pwd)
+endif
+
+ifeq ($(objtree),)
+objtree := $(shell cd ../../; pwd)
 endif
 
 BASIC_CFLAGS = \
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 618d41140abd..de882d5a4ab3 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -19,7 +19,6 @@
 #include "thread_map.h"
 #include "target.h"
 #include "../../../include/linux/hw_breakpoint.h"
-#include "../../../include/uapi/linux/perf_event.h"
 #include "perf_regs.h"
 
 #define FD(e, x, y) (*(int *)xyarray__entry(e->fd, x, y))
diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index 6f94d6dea00f..9ac02f655124 100644
--- a/tools/perf/util/evsel.h
+++ b/tools/perf/util/evsel.h
@@ -3,7 +3,7 @@
 
 #include <linux/list.h>
 #include <stdbool.h>
-#include "../../../include/uapi/linux/perf_event.h"
+#include <linux/perf_event.h>
 #include "types.h"
 #include "xyarray.h"
 #include "cgroup.h"
diff --git a/tools/perf/util/header.h b/tools/perf/util/header.h
index 879d215cdac9..3c24404c8523 100644
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
diff --git a/tools/perf/util/parse-events.h b/tools/perf/util/parse-events.h
index ac9a6aacf2f5..146684787adb 100644
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
index 39f3abac7744..8410897cc856 100644
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
index dd6426163ba6..1768581bb4a6 100644
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
------------ 8< ------------------- 8< -----------------

But it also failed to build like this:

    CC builtin-kvm.o
builtin-kvm.c:146:2: error: ‘DB_VECTOR’ undeclared here (not in a function)
builtin-kvm.c:146:2: error: ‘BP_VECTOR’ undeclared here (not in a function)
builtin-kvm.c:146:2: error: ‘UD_VECTOR’ undeclared here (not in a function)
builtin-kvm.c:146:2: error: ‘PF_VECTOR’ undeclared here (not in a function)
builtin-kvm.c:146:2: error: ‘NM_VECTOR’ undeclared here (not in a function)
builtin-kvm.c:146:2: error: ‘MC_VECTOR’ undeclared here (not in a function)
make: *** [builtin-kvm.o] Error 1


I can see that those are defined in arch/x86/include/asm/kvm.h.


Thanks,
Namhyung
