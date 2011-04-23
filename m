Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755748Ab1DWUOp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Apr 2011 16:14:45 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:40269 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755343Ab1DWUOn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Apr 2011 16:14:43 -0400
Date: Sat, 23 Apr 2011 22:14:09 +0200
From: Ingo Molnar <mingo@elte.hu>
To: arun@sharma-home.net
Cc: Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>, Lin Ming <ming.m.lin@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, eranian@gmail.com,
        Arun Sharma <asharma@fb.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] perf events: Add stalled cycles generic event -
 PERF_COUNT_HW_STALLED_CYCLES
Message-ID: <20110423201409.GA20072@elte.hu>
References: <BANLkTikNWgzKefWxp6UUqQ-XdBvgG+QSNQ@mail.gmail.com>
 <20110422092322.GA1948@elte.hu>
 <BANLkTi=G7-v3ysxK2wY_3f8TecbD6ZjKog@mail.gmail.com>
 <20110422105211.GB1948@elte.hu>
 <20110422165007.GA18401@vps.sharma-home.net>
 <20110422203022.GA20573@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110422203022.GA20573@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> > [...] If there is an expensive load, you'll see that the load instruction 
> > takes many cycles and you can infer that it's a cache miss.
> > 
> > Questions app developers typically ask me:
> > 
> > * If I fix all my top 5 L3 misses how much faster will my app go?
> 
> This has come up: we could add a 'stalled/idle-cycles' generic event - i.e. 
> cycles spent without performing useful work in the pipelines. (Resource-stall 
> events on Intel CPUs.)

How about something like the patch below?

	Ingo
---
Subject: perf events: Add stalled cycles generic event - PERF_COUNT_HW_STALLED_CYCLES
From: Ingo Molnar <mingo@elte.hu>

The new PERF_COUNT_HW_STALLED_CYCLES event tries to approximate
cycles the CPU does nothing useful, because it is stalled on a
cache-miss or some other condition.

Note: this is still a incomplete and will work on Intel Nehalem
      CPUs for now, the intel_perfmon_event_map[] needs to be
      properly split between the major models.

Also update 'perf stat' to print:

           611,527 cycles
           400,553 instructions             # ( 0.7 instructions per cycle )
            77,809 stalled-cycles           # ( 12.7% of all cycles )

        0.000610987  seconds time elapsed

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/perf_event_intel.c |    2 ++
 include/linux/perf_event.h             |    1 +
 tools/perf/builtin-stat.c              |   11 +++++++++--
 tools/perf/util/parse-events.c         |    1 +
 tools/perf/util/python.c               |    1 +
 5 files changed, 14 insertions(+), 2 deletions(-)

Index: linux/arch/x86/kernel/cpu/perf_event_intel.c
===================================================================
--- linux.orig/arch/x86/kernel/cpu/perf_event_intel.c
+++ linux/arch/x86/kernel/cpu/perf_event_intel.c
@@ -34,6 +34,8 @@ static const u64 intel_perfmon_event_map
   [PERF_COUNT_HW_BRANCH_INSTRUCTIONS]	= 0x00c4,
   [PERF_COUNT_HW_BRANCH_MISSES]		= 0x00c5,
   [PERF_COUNT_HW_BUS_CYCLES]		= 0x013c,
+  [PERF_COUNT_HW_STALLED_CYCLES]	= 0xffa2, /* 0xff: All reasons, 0xa2: Resource stalls */
+
 };
 
 static struct event_constraint intel_core_event_constraints[] =
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
Index: linux/tools/perf/builtin-stat.c
===================================================================
--- linux.orig/tools/perf/builtin-stat.c
+++ linux/tools/perf/builtin-stat.c
@@ -442,7 +442,7 @@ static void abs_printout(int cpu, struct
 		if (total)
 			ratio = avg / total;
 
-		fprintf(stderr, " # %10.3f IPC  ", ratio);
+		fprintf(stderr, " # ( %3.1f instructions per cycle )", ratio);
 	} else if (perf_evsel__match(evsel, HARDWARE, HW_BRANCH_MISSES) &&
 			runtime_branches_stats[cpu].n != 0) {
 		total = avg_stats(&runtime_branches_stats[cpu]);
@@ -450,7 +450,7 @@ static void abs_printout(int cpu, struct
 		if (total)
 			ratio = avg * 100 / total;
 
-		fprintf(stderr, " # %10.3f %%    ", ratio);
+		fprintf(stderr, " # %10.3f %%", ratio);
 
 	} else if (runtime_nsecs_stats[cpu].n != 0) {
 		total = avg_stats(&runtime_nsecs_stats[cpu]);
@@ -459,6 +459,13 @@ static void abs_printout(int cpu, struct
 			ratio = 1000.0 * avg / total;
 
 		fprintf(stderr, " # %10.3f M/sec", ratio);
+	} else if (perf_evsel__match(evsel, HARDWARE, HW_STALLED_CYCLES)) {
+		total = avg_stats(&runtime_cycles_stats[cpu]);
+
+		if (total)
+			ratio = avg / total * 100.0;
+
+		fprintf(stderr, " # (%5.1f%% of all cycles )", ratio);
 	}
 }
 
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
