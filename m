Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756145Ab1DZOA4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 10:00:56 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56432 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755705Ab1DZOAy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 10:00:54 -0400
Date: Tue, 26 Apr 2011 16:00:23 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Arun Sharma <asharma@fb.com>
Cc: arun@sharma-home.net, Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>, Lin Ming <ming.m.lin@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, eranian@gmail.com,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] perf events: Add stalled cycles generic event -
 PERF_COUNT_HW_STALLED_CYCLES
Message-ID: <20110426140023.GA21083@elte.hu>
References: <BANLkTikNWgzKefWxp6UUqQ-XdBvgG+QSNQ@mail.gmail.com>
 <20110422092322.GA1948@elte.hu>
 <BANLkTi=G7-v3ysxK2wY_3f8TecbD6ZjKog@mail.gmail.com>
 <20110422105211.GB1948@elte.hu>
 <20110422165007.GA18401@vps.sharma-home.net>
 <20110422203022.GA20573@elte.hu>
 <20110423201409.GA20072@elte.hu>
 <20110424061645.GA12013@radium.snc4.facebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110424061645.GA12013@radium.snc4.facebook.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arun Sharma <asharma@fb.com> wrote:

> On Sat, Apr 23, 2011 at 10:14:09PM +0200, Ingo Molnar wrote:
> > 
> > The new PERF_COUNT_HW_STALLED_CYCLES event tries to approximate
> > cycles the CPU does nothing useful, because it is stalled on a
> > cache-miss or some other condition.
> 
> Conceptually looks fine. I'd prefer a more precise name such as:
> PERF_COUNT_EXECUTION_STALLED_CYCLES (to differentiate from frontend or
> retirement stalls).

How about this naming convention:

  PERF_COUNT_HW_STALLED_CYCLES                              # execution
  PERF_COUNT_HW_STALLED_CYCLES_FRONTEND                     # frontend
  PERF_COUNT_HW_STALLED_CYCLES_ICACHE_MISS                  # icache

So STALLED_CYCLES would be the most general metric, the one that shows the real 
impact to the application. The other events would then help disambiguate this 
metric some more.

Below is the updated patch - this version makes the backend stalls event 
properly per model. (with the Nehalem table filled in.)

What do you think?

Thanks,

	Ingo

--------------------->
Subject: perf events: Add stalled cycles generic event - PERF_COUNT_HW_STALLED_CYCLES
From: Ingo Molnar <mingo@elte.hu>
Date: Sun Apr 24 08:18:31 CEST 2011

The new PERF_COUNT_HW_STALLED_CYCLES event tries to approximate
cycles the CPU does nothing useful, because it is stalled on a
cache-miss or some other condition.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/perf_event_intel.c |   42 +++++++++++++++++++++++++--------
 include/linux/perf_event.h             |    1 
 tools/perf/util/parse-events.c         |    1 
 tools/perf/util/python.c               |    1 
 4 files changed, 36 insertions(+), 9 deletions(-)

Index: linux/arch/x86/kernel/cpu/perf_event_intel.c
===================================================================
--- linux.orig/arch/x86/kernel/cpu/perf_event_intel.c
+++ linux/arch/x86/kernel/cpu/perf_event_intel.c
@@ -36,6 +36,23 @@ static const u64 intel_perfmon_event_map
   [PERF_COUNT_HW_BUS_CYCLES]		= 0x013c,
 };
 
+/*
+ * Other generic events, Nehalem:
+ */
+static const u64 intel_nhm_event_map[] =
+{
+  /* Arch-perfmon events: */
+  [PERF_COUNT_HW_CPU_CYCLES]		= 0x003c,
+  [PERF_COUNT_HW_INSTRUCTIONS]		= 0x00c0,
+  [PERF_COUNT_HW_CACHE_REFERENCES]	= 0x4f2e,
+  [PERF_COUNT_HW_CACHE_MISSES]		= 0x412e,
+  [PERF_COUNT_HW_BRANCH_INSTRUCTIONS]	= 0x00c4,
+  [PERF_COUNT_HW_BRANCH_MISSES]		= 0x00c5,
+  [PERF_COUNT_HW_BUS_CYCLES]		= 0x013c,
+
+  [PERF_COUNT_HW_STALLED_CYCLES]	= 0xffa2, /* 0xff: All reasons, 0xa2: Resource stalls */
+};
+
 static struct event_constraint intel_core_event_constraints[] =
 {
 	INTEL_EVENT_CONSTRAINT(0x11, 0x2), /* FP_ASSIST */
@@ -150,6 +167,12 @@ static u64 intel_pmu_event_map(int hw_ev
 	return intel_perfmon_event_map[hw_event];
 }
 
+static u64 intel_pmu_nhm_event_map(int hw_event)
+{
+	return intel_nhm_event_map[hw_event];
+}
+
+
 static __initconst const u64 snb_hw_cache_event_ids
 				[PERF_COUNT_HW_CACHE_MAX]
 				[PERF_COUNT_HW_CACHE_OP_MAX]
@@ -1400,18 +1423,19 @@ static __init int intel_pmu_init(void)
 	case 26: /* 45 nm nehalem, "Bloomfield" */
 	case 30: /* 45 nm nehalem, "Lynnfield" */
 	case 46: /* 45 nm nehalem-ex, "Beckton" */
-		memcpy(hw_cache_event_ids, nehalem_hw_cache_event_ids,
-		       sizeof(hw_cache_event_ids));
-		memcpy(hw_cache_extra_regs, nehalem_hw_cache_extra_regs,
-		       sizeof(hw_cache_extra_regs));
+		memcpy(hw_cache_event_ids, nehalem_hw_cache_event_ids, sizeof(hw_cache_event_ids));
+		memcpy(hw_cache_extra_regs, nehalem_hw_cache_extra_regs, sizeof(hw_cache_extra_regs));
 
 		intel_pmu_lbr_init_nhm();
 
-		x86_pmu.event_constraints = intel_nehalem_event_constraints;
-		x86_pmu.pebs_constraints = intel_nehalem_pebs_event_constraints;
-		x86_pmu.percore_constraints = intel_nehalem_percore_constraints;
-		x86_pmu.enable_all = intel_pmu_nhm_enable_all;
-		x86_pmu.extra_regs = intel_nehalem_extra_regs;
+		x86_pmu.event_constraints	= intel_nehalem_event_constraints;
+		x86_pmu.pebs_constraints	= intel_nehalem_pebs_event_constraints;
+		x86_pmu.percore_constraints	= intel_nehalem_percore_constraints;
+		x86_pmu.enable_all		= intel_pmu_nhm_enable_all;
+		x86_pmu.extra_regs		= intel_nehalem_extra_regs;
+		x86_pmu.event_map		= intel_pmu_nhm_event_map;
+		x86_pmu.max_events		= ARRAY_SIZE(intel_perfmon_event_map),
+
 		pr_cont("Nehalem events, ");
 		break;
 
Index: linux/include/linux/perf_event.h
===================================================================
--- linux.orig/include/linux/perf_event.h
+++ linux/include/linux/perf_event.h
@@ -52,6 +52,7 @@ enum perf_hw_id {
 	PERF_COUNT_HW_BRANCH_INSTRUCTIONS	= 4,
 	PERF_COUNT_HW_BRANCH_MISSES		= 5,
 	PERF_COUNT_HW_BUS_CYCLES		= 6,
+	PERF_COUNT_HW_STALLED_CYCLES		= 7,
 
 	PERF_COUNT_HW_MAX,			/* non-ABI */
 };
Index: linux/tools/perf/util/parse-events.c
===================================================================
--- linux.orig/tools/perf/util/parse-events.c
+++ linux/tools/perf/util/parse-events.c
@@ -38,6 +38,7 @@ static struct event_symbol event_symbols
   { CHW(BRANCH_INSTRUCTIONS),	"branch-instructions",	"branches"	},
   { CHW(BRANCH_MISSES),		"branch-misses",	""		},
   { CHW(BUS_CYCLES),		"bus-cycles",		""		},
+  { CHW(STALLED_CYCLES),	"stalled-cycles",	""		},
 
   { CSW(CPU_CLOCK),		"cpu-clock",		""		},
   { CSW(TASK_CLOCK),		"task-clock",		""		},
Index: linux/tools/perf/util/python.c
===================================================================
--- linux.orig/tools/perf/util/python.c
+++ linux/tools/perf/util/python.c
@@ -798,6 +798,7 @@ static struct {
 	{ "COUNT_HW_BRANCH_INSTRUCTIONS", PERF_COUNT_HW_BRANCH_INSTRUCTIONS },
 	{ "COUNT_HW_BRANCH_MISSES",	  PERF_COUNT_HW_BRANCH_MISSES },
 	{ "COUNT_HW_BUS_CYCLES",	  PERF_COUNT_HW_BUS_CYCLES },
+	{ "COUNT_HW_STALLED_CYCLES",	  PERF_COUNT_HW_STALLED_CYCLES },
 	{ "COUNT_HW_CACHE_L1D",		  PERF_COUNT_HW_CACHE_L1D },
 	{ "COUNT_HW_CACHE_L1I",		  PERF_COUNT_HW_CACHE_L1I },
 	{ "COUNT_HW_CACHE_LL",	  	  PERF_COUNT_HW_CACHE_LL },
