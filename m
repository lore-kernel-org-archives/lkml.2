Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756590Ab2JLB16 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 21:27:58 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:53784 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754400Ab2JLB1s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 21:27:48 -0400
Date: Thu, 11 Oct 2012 18:28:39 -0700
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: acme@redhat.com, mingo@kernel.org, peterz@infradead.org,
        eranian@google.com, robert.richter@amd.com, asharma@fb.com
Cc: Anton Blanchard <anton@au1.ibm.com>, paulus@samba.org, mpjohn@us.ibm.com,
        linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: [RFC][PATCH] perf: Add a few generic stalled-cycles events
Message-ID: <20121012012839.GA15348@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.20 (2009-06-14)
x-cbid: 12101201-3534-0000-0000-00000DB9BCA5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>From 89cb6a25b9f714e55a379467a832ee015014ed11 Mon Sep 17 00:00:00 2001
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Date: Tue, 18 Sep 2012 10:59:01 -0700
Subject: [PATCH] perf: Add a few generic stalled-cycles events

The existing generic event 'stalled-cycles-backend' corresponds to
PM_CMPLU_STALL event in Power7. While this event is useful, detailed
performance analysis often requires us to find more specific reasons
for the stalled cycle. For instance, stalled cycles in Power7 can
occur due to, among others:

	- instruction fetch unit (IFU),
	- Load-store-unit (LSU),
	- Fixed point unit (FXU)
	- Branch unit (BRU)

While it is possible to use raw codes to monitor these events, it quickly
becomes cumbersome with performance analysis frequently requiring mapping
the raw event codes in reports to their symbolic names.

This patch is a proposal to try and generalize such perf events. Since
the code changes are quite simple, I bunched all the 4 events together.

I am not familiar with how readily these events would map to other
architectures. Here is some information on the events for Power7:

	stalled-cycles-fixed-point (PM_CMPLU_STALL_FXU)

		Following a completion stall, the last instruction to finish
		before completion resumes was from the Fixed Point Unit.

		Completion stall is any period when no groups completed and
		the completion table was not empty for that thread.

	stalled-cycles-load-store (PM_CMPLU_STALL_LSU)

		Following a completion stall, the last instruction to finish
		before completion resumes was from the Load-Store Unit.

	stalled-cycles-instruction-fetch (PM_CMPLU_STALL_IFU)

		Following a completion stall, the last instruction to finish
		before completion resumes was from the Instruction Fetch Unit.

	stalled-cycles-branch (PM_CMPLU_STALL_BRU)

		Following a completion stall, the last instruction to finish
		before completion resumes was from the Branch Unit.

Looking for feedback on this approach and if this can be further extended.
Power7 has 530 events[2] out of which a "CPI stack analysis"[1] uses about 26
events.


[1] CPI Stack analysis
	https://www.power.org/documentation/commonly-used-metrics-for-performance-analysis

[2] Power7 events:
	https://www.power.org/documentation/comprehensive-pmu-event-reference-power7/

Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
---
 arch/powerpc/perf/power7-pmu.c |    4 ++++
 include/linux/perf_event.h     |    4 ++++
 tools/perf/builtin-stat.c      |    4 ++++
 tools/perf/util/evsel.c        |    4 ++++
 tools/perf/util/parse-events.l |    4 ++++
 tools/perf/util/python.c       |    4 ++++
 6 files changed, 24 insertions(+), 0 deletions(-)

diff --git a/arch/powerpc/perf/power7-pmu.c b/arch/powerpc/perf/power7-pmu.c
index 1251e4d..813e7c7 100644
--- a/arch/powerpc/perf/power7-pmu.c
+++ b/arch/powerpc/perf/power7-pmu.c
@@ -304,6 +304,10 @@ static int power7_generic_events[] = {
 	[PERF_COUNT_HW_CACHE_MISSES] = 0x400f0,		/* LD_MISS_L1	*/
 	[PERF_COUNT_HW_BRANCH_INSTRUCTIONS] = 0x10068,	/* BRU_FIN	*/
 	[PERF_COUNT_HW_BRANCH_MISSES] = 0x400f6,	/* BR_MPRED	*/
+	[PERF_COUNT_HW_STALLED_CYCLES_FIXED_POINT] = 0x20014,/* CMPLU_STALL_FXU */
+	[PERF_COUNT_HW_STALLED_CYCLES_LOAD_STORE] = 0x20012,/* CMPLU_STALL_LSU */
+	[PERF_COUNT_HW_STALLED_CYCLES_INSTRUCTION_FETCH] = 0x4004c,/* CMPLU_STALL_IFU */
+	[PERF_COUNT_HW_STALLED_CYCLES_BRANCH] = 0x4004e,/* CMPLU_STALL_BRU */
 };
 
 #define C(x)	PERF_COUNT_HW_CACHE_##x
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index bdb4161..ff9f0a6 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -55,6 +55,10 @@ enum perf_hw_id {
 	PERF_COUNT_HW_STALLED_CYCLES_FRONTEND	= 7,
 	PERF_COUNT_HW_STALLED_CYCLES_BACKEND	= 8,
 	PERF_COUNT_HW_REF_CPU_CYCLES		= 9,
+	PERF_COUNT_HW_STALLED_CYCLES_FIXED_POINT = 10,
+	PERF_COUNT_HW_STALLED_CYCLES_LOAD_STORE	= 11,
+	PERF_COUNT_HW_STALLED_CYCLES_INSTRUCTION_FETCH = 12,
+	PERF_COUNT_HW_STALLED_CYCLES_BRANCH	= 13,
 
 	PERF_COUNT_HW_MAX,			/* non-ABI */
 };
diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 861f0ae..6275dbb 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -77,6 +77,10 @@ static struct perf_event_attr default_attrs[] = {
   { .type = PERF_TYPE_HARDWARE, .config = PERF_COUNT_HW_INSTRUCTIONS		},
   { .type = PERF_TYPE_HARDWARE, .config = PERF_COUNT_HW_BRANCH_INSTRUCTIONS	},
   { .type = PERF_TYPE_HARDWARE, .config = PERF_COUNT_HW_BRANCH_MISSES		},
+  { .type = PERF_TYPE_HARDWARE, .config = PERF_COUNT_HW_STALLED_CYCLES_FIXED_POINT },
+  { .type = PERF_TYPE_HARDWARE, .config = PERF_COUNT_HW_STALLED_CYCLES_LOAD_STORE },
+  { .type = PERF_TYPE_HARDWARE, .config = PERF_COUNT_HW_STALLED_CYCLES_INSTRUCTION_FETCH },
+  { .type = PERF_TYPE_HARDWARE, .config = PERF_COUNT_HW_STALLED_CYCLES_BRANCH },
 
 };
 
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 2eaae14..17e3190 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -77,6 +77,10 @@ static const char *perf_evsel__hw_names[PERF_COUNT_HW_MAX] = {
 	"stalled-cycles-frontend",
 	"stalled-cycles-backend",
 	"ref-cycles",
+	"stalled-cycles-fixed-point",
+	"stalled-cycles-load-store",
+	"stalled-cycles-instruction-fetch",
+	"stalled-cycles-branch",
 };
 
 static const char *__perf_evsel__hw_name(u64 config)
diff --git a/tools/perf/util/parse-events.l b/tools/perf/util/parse-events.l
index 384ca74..0c49c05 100644
--- a/tools/perf/util/parse-events.l
+++ b/tools/perf/util/parse-events.l
@@ -102,6 +102,10 @@ branch-instructions|branches			{ return sym(yyscanner, PERF_TYPE_HARDWARE, PERF_
 branch-misses					{ return sym(yyscanner, PERF_TYPE_HARDWARE, PERF_COUNT_HW_BRANCH_MISSES); }
 bus-cycles					{ return sym(yyscanner, PERF_TYPE_HARDWARE, PERF_COUNT_HW_BUS_CYCLES); }
 ref-cycles					{ return sym(yyscanner, PERF_TYPE_HARDWARE, PERF_COUNT_HW_REF_CPU_CYCLES); }
+stalled-cycles-fixed-point			{ return sym(yyscanner, PERF_TYPE_HARDWARE, PERF_COUNT_HW_STALLED_CYCLES_FIXED_POINT); }
+stalled-cycles-load-store			{ return sym(yyscanner, PERF_TYPE_HARDWARE, PERF_COUNT_HW_STALLED_CYCLES_LOAD_STORE); }
+stalled-cycles-instruction-fetch		{ return sym(yyscanner, PERF_TYPE_HARDWARE, PERF_COUNT_HW_STALLED_CYCLES_INSTRUCTION_FETCH); }
+stalled-cycles-branch				{ return sym(yyscanner, PERF_TYPE_HARDWARE, PERF_COUNT_HW_STALLED_CYCLES_BRANCH); }
 cpu-clock					{ return sym(yyscanner, PERF_TYPE_SOFTWARE, PERF_COUNT_SW_CPU_CLOCK); }
 task-clock					{ return sym(yyscanner, PERF_TYPE_SOFTWARE, PERF_COUNT_SW_TASK_CLOCK); }
 page-faults|faults				{ return sym(yyscanner, PERF_TYPE_SOFTWARE, PERF_COUNT_SW_PAGE_FAULTS); }
diff --git a/tools/perf/util/python.c b/tools/perf/util/python.c
index 0688bfb..c563b30 100644
--- a/tools/perf/util/python.c
+++ b/tools/perf/util/python.c
@@ -952,6 +952,10 @@ static struct {
 
 	{ "COUNT_HW_STALLED_CYCLES_FRONTEND",	  PERF_COUNT_HW_STALLED_CYCLES_FRONTEND },
 	{ "COUNT_HW_STALLED_CYCLES_BACKEND",	  PERF_COUNT_HW_STALLED_CYCLES_BACKEND },
+	{ "COUNT_HW_STALLED_CYCLES_FIXED_POINT",  PERF_COUNT_HW_STALLED_CYCLES_FIXED_POINT },
+	{ "COUNT_HW_STALLED_CYCLES_LOAD_STORE",  PERF_COUNT_HW_STALLED_CYCLES_LOAD_STORE },
+	{ "COUNT_HW_STALLED_CYCLES_INSTRUCTION_FETCH",  PERF_COUNT_HW_STALLED_CYCLES_INSTRUCTION_FETCH },
+	{ "COUNT_HW_STALLED_CYCLES_BRANCH",  PERF_COUNT_HW_STALLED_CYCLES_BRANCH },
 
 	{ "COUNT_SW_CPU_CLOCK",	       PERF_COUNT_SW_CPU_CLOCK },
 	{ "COUNT_SW_TASK_CLOCK",       PERF_COUNT_SW_TASK_CLOCK },
-- 
1.7.1

