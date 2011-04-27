Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759535Ab1D0QCf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 12:02:35 -0400
Received: from hera.kernel.org ([140.211.167.34]:59548 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759310Ab1D0QCe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 12:02:34 -0400
Date: Wed, 27 Apr 2011 16:02:14 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
Message-ID: <tip-pbpl2l4mn797s69bclfpwkwn@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
        mingo@redhat.com, a.p.zijlstra@chello.nl, fweisbec@gmail.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
        linux-kernel@vger.kernel.org, fweisbec@gmail.com,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/stat] perf stat: Add stalled cycles to the default output
Git-Commit-ID: 1fc570ad89e55dc32dfa4dda1311948b38f26524
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 27 Apr 2011 16:02:15 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1fc570ad89e55dc32dfa4dda1311948b38f26524
Gitweb:     http://git.kernel.org/tip/1fc570ad89e55dc32dfa4dda1311948b38f26524
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Wed, 27 Apr 2011 05:20:22 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 26 Apr 2011 20:04:57 +0200

perf stat: Add stalled cycles to the default output

The new default output looks like this:

 Performance counter stats for './loop_1b_instructions':

        236.010686 task-clock               #    0.996 CPUs utilized
                 0 context-switches         #    0.000 M/sec
                 0 CPU-migrations           #    0.000 M/sec
                99 page-faults              #    0.000 M/sec
       756,487,646 cycles                   #    3.205 GHz
       354,938,996 stalled-cycles           #   46.92% of all cycles are idle
     1,001,403,797 instructions             #    1.32  insns per cycle
                                            #    0.35  stalled cycles per insn
       100,279,773 branches                 #  424.895 M/sec
            12,646 branch-misses            #    0.013 % of all branches

        0.236902540  seconds time elapsed

We dropped cache-refs and cache-misses and added stalled-cycles - this is a
more generic "how well utilized is the CPU" metric.

If the stalled-cycles ratio is too high then more specific measurements can be
taken to figure out the source of the inefficiency.

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Link: http://lkml.kernel.org/n/tip-pbpl2l4mn797s69bclfpwkwn@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/builtin-stat.c      |    5 ++---
 tools/perf/util/parse-events.c |   11 ++++++-----
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index e881c20..924d18c 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -65,11 +65,10 @@ static struct perf_event_attr default_attrs[] = {
   { .type = PERF_TYPE_SOFTWARE, .config = PERF_COUNT_SW_PAGE_FAULTS		},
 
   { .type = PERF_TYPE_HARDWARE, .config = PERF_COUNT_HW_CPU_CYCLES		},
+  { .type = PERF_TYPE_HARDWARE, .config = PERF_COUNT_HW_STALLED_CYCLES		},
   { .type = PERF_TYPE_HARDWARE, .config = PERF_COUNT_HW_INSTRUCTIONS		},
   { .type = PERF_TYPE_HARDWARE, .config = PERF_COUNT_HW_BRANCH_INSTRUCTIONS	},
   { .type = PERF_TYPE_HARDWARE, .config = PERF_COUNT_HW_BRANCH_MISSES		},
-  { .type = PERF_TYPE_HARDWARE, .config = PERF_COUNT_HW_CACHE_REFERENCES	},
-  { .type = PERF_TYPE_HARDWARE, .config = PERF_COUNT_HW_CACHE_MISSES		},
 
 };
 
@@ -468,7 +467,7 @@ static void abs_printout(int cpu, struct perf_evsel *evsel, double avg)
 		if (total)
 			ratio = avg * 100 / total;
 
-		fprintf(stderr, " # %8.3f %% of all branches", ratio);
+		fprintf(stderr, " #   %5.2f  %% of all branches      ", ratio);
 
 	} else if (perf_evsel__match(evsel, HARDWARE, HW_CACHE_MISSES) &&
 			runtime_cacherefs_stats[cpu].n != 0) {
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index b5bfef1..bbbb735 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -32,13 +32,13 @@ char debugfs_path[MAXPATHLEN];
 
 static struct event_symbol event_symbols[] = {
   { CHW(CPU_CYCLES),		"cpu-cycles",		"cycles"	},
+  { CHW(STALLED_CYCLES),	"stalled-cycles",	"idle-cycles"	},
   { CHW(INSTRUCTIONS),		"instructions",		""		},
   { CHW(CACHE_REFERENCES),	"cache-references",	""		},
   { CHW(CACHE_MISSES),		"cache-misses",		""		},
   { CHW(BRANCH_INSTRUCTIONS),	"branch-instructions",	"branches"	},
   { CHW(BRANCH_MISSES),		"branch-misses",	""		},
   { CHW(BUS_CYCLES),		"bus-cycles",		""		},
-  { CHW(STALLED_CYCLES),	"stalled-cycles",	""		},
 
   { CSW(CPU_CLOCK),		"cpu-clock",		""		},
   { CSW(TASK_CLOCK),		"task-clock",		""		},
@@ -54,9 +54,9 @@ static struct event_symbol event_symbols[] = {
 #define __PERF_EVENT_FIELD(config, name) \
 	((config & PERF_EVENT_##name##_MASK) >> PERF_EVENT_##name##_SHIFT)
 
-#define PERF_EVENT_RAW(config)	__PERF_EVENT_FIELD(config, RAW)
+#define PERF_EVENT_RAW(config)		__PERF_EVENT_FIELD(config, RAW)
 #define PERF_EVENT_CONFIG(config)	__PERF_EVENT_FIELD(config, CONFIG)
-#define PERF_EVENT_TYPE(config)	__PERF_EVENT_FIELD(config, TYPE)
+#define PERF_EVENT_TYPE(config)		__PERF_EVENT_FIELD(config, TYPE)
 #define PERF_EVENT_ID(config)		__PERF_EVENT_FIELD(config, EVENT)
 
 static const char *hw_event_names[] = {
@@ -67,6 +67,7 @@ static const char *hw_event_names[] = {
 	"branches",
 	"branch-misses",
 	"bus-cycles",
+	"stalled-cycles",
 };
 
 static const char *sw_event_names[] = {
@@ -308,7 +309,7 @@ const char *__event_name(int type, u64 config)
 
 	switch (type) {
 	case PERF_TYPE_HARDWARE:
-		if (config < PERF_COUNT_HW_MAX)
+		if (config < PERF_COUNT_HW_MAX && hw_event_names[config])
 			return hw_event_names[config];
 		return "unknown-hardware";
 
@@ -334,7 +335,7 @@ const char *__event_name(int type, u64 config)
 	}
 
 	case PERF_TYPE_SOFTWARE:
-		if (config < PERF_COUNT_SW_MAX)
+		if (config < PERF_COUNT_SW_MAX && sw_event_names[config])
 			return sw_event_names[config];
 		return "unknown-software";
 
