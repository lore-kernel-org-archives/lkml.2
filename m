Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756815Ab1D2MrG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 08:47:06 -0400
Received: from hera.kernel.org ([140.211.167.34]:60587 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752037Ab1D2MrC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 08:47:02 -0400
Date: Fri, 29 Apr 2011 12:46:47 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
Message-ID: <tip-7y40wib8n002io7hjpn1dsrm@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
        mingo@redhat.com, a.p.zijlstra@chello.nl, fweisbec@gmail.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
        linux-kernel@vger.kernel.org, fweisbec@gmail.com,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/stat] perf tools: Add front-end and back-end stalled cycles support
Git-Commit-ID: 129c04cb8ce2e4bf3f17223f58ef16aa8a2cb3b8
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 29 Apr 2011 12:46:48 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  129c04cb8ce2e4bf3f17223f58ef16aa8a2cb3b8
Gitweb:     http://git.kernel.org/tip/129c04cb8ce2e4bf3f17223f58ef16aa8a2cb3b8
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Fri, 29 Apr 2011 14:41:28 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 29 Apr 2011 14:35:49 +0200

perf tools: Add front-end and back-end stalled cycles support

Update perf tooling to deal with front-end and back-end stalled cycles events.

Add both the default 'perf stat' output.

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Link: http://lkml.kernel.org/n/tip-7y40wib8n002io7hjpn1dsrm@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/builtin-stat.c      |   10 ++++++----
 tools/perf/util/parse-events.c |   37 +++++++++++++++++++------------------
 tools/perf/util/python.c       |    4 +++-
 3 files changed, 28 insertions(+), 23 deletions(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index da77077..6a4a8a3 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -66,7 +66,8 @@ static struct perf_event_attr default_attrs[] = {
   { .type = PERF_TYPE_SOFTWARE, .config = PERF_COUNT_SW_PAGE_FAULTS		},
 
   { .type = PERF_TYPE_HARDWARE, .config = PERF_COUNT_HW_CPU_CYCLES		},
-  { .type = PERF_TYPE_HARDWARE, .config = PERF_COUNT_HW_STALLED_CYCLES		},
+  { .type = PERF_TYPE_HARDWARE, .config = PERF_COUNT_HW_STALLED_CYCLES_FRONTEND	},
+  { .type = PERF_TYPE_HARDWARE, .config = PERF_COUNT_HW_STALLED_CYCLES_BACKEND	},
   { .type = PERF_TYPE_HARDWARE, .config = PERF_COUNT_HW_INSTRUCTIONS		},
   { .type = PERF_TYPE_HARDWARE, .config = PERF_COUNT_HW_BRANCH_INSTRUCTIONS	},
   { .type = PERF_TYPE_HARDWARE, .config = PERF_COUNT_HW_BRANCH_MISSES		},
@@ -84,7 +85,8 @@ static struct perf_event_attr detailed_attrs[] = {
   { .type = PERF_TYPE_SOFTWARE, .config = PERF_COUNT_SW_PAGE_FAULTS		},
 
   { .type = PERF_TYPE_HARDWARE, .config = PERF_COUNT_HW_CPU_CYCLES		},
-  { .type = PERF_TYPE_HARDWARE, .config = PERF_COUNT_HW_STALLED_CYCLES		},
+  { .type = PERF_TYPE_HARDWARE, .config = PERF_COUNT_HW_STALLED_CYCLES_FRONTEND	},
+  { .type = PERF_TYPE_HARDWARE, .config = PERF_COUNT_HW_STALLED_CYCLES_BACKEND	},
   { .type = PERF_TYPE_HARDWARE, .config = PERF_COUNT_HW_INSTRUCTIONS		},
   { .type = PERF_TYPE_HARDWARE, .config = PERF_COUNT_HW_BRANCH_INSTRUCTIONS	},
   { .type = PERF_TYPE_HARDWARE, .config = PERF_COUNT_HW_BRANCH_MISSES		},
@@ -249,7 +251,7 @@ static void update_shadow_stats(struct perf_evsel *counter, u64 *count)
 		update_stats(&runtime_nsecs_stats[0], count[0]);
 	else if (perf_evsel__match(counter, HARDWARE, HW_CPU_CYCLES))
 		update_stats(&runtime_cycles_stats[0], count[0]);
-	else if (perf_evsel__match(counter, HARDWARE, HW_STALLED_CYCLES))
+	else if (perf_evsel__match(counter, HARDWARE, HW_STALLED_CYCLES_BACKEND))
 		update_stats(&runtime_stalled_cycles_stats[0], count[0]);
 	else if (perf_evsel__match(counter, HARDWARE, HW_BRANCH_INSTRUCTIONS))
 		update_stats(&runtime_branches_stats[0], count[0]);
@@ -607,7 +609,7 @@ static void abs_printout(int cpu, struct perf_evsel *evsel, double avg)
 
 		fprintf(stderr, " # %8.3f %% of all cache refs    ", ratio);
 
-	} else if (perf_evsel__match(evsel, HARDWARE, HW_STALLED_CYCLES)) {
+	} else if (perf_evsel__match(evsel, HARDWARE, HW_STALLED_CYCLES_BACKEND)) {
 		print_stalled_cycles(cpu, evsel, avg);
 	} else if (perf_evsel__match(evsel, HARDWARE, HW_CPU_CYCLES)) {
 		total = avg_stats(&runtime_nsecs_stats[cpu]);
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index bbbb735..04d2f0a 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -31,24 +31,25 @@ char debugfs_path[MAXPATHLEN];
 #define CSW(x) .type = PERF_TYPE_SOFTWARE, .config = PERF_COUNT_SW_##x
 
 static struct event_symbol event_symbols[] = {
-  { CHW(CPU_CYCLES),		"cpu-cycles",		"cycles"	},
-  { CHW(STALLED_CYCLES),	"stalled-cycles",	"idle-cycles"	},
-  { CHW(INSTRUCTIONS),		"instructions",		""		},
-  { CHW(CACHE_REFERENCES),	"cache-references",	""		},
-  { CHW(CACHE_MISSES),		"cache-misses",		""		},
-  { CHW(BRANCH_INSTRUCTIONS),	"branch-instructions",	"branches"	},
-  { CHW(BRANCH_MISSES),		"branch-misses",	""		},
-  { CHW(BUS_CYCLES),		"bus-cycles",		""		},
-
-  { CSW(CPU_CLOCK),		"cpu-clock",		""		},
-  { CSW(TASK_CLOCK),		"task-clock",		""		},
-  { CSW(PAGE_FAULTS),		"page-faults",		"faults"	},
-  { CSW(PAGE_FAULTS_MIN),	"minor-faults",		""		},
-  { CSW(PAGE_FAULTS_MAJ),	"major-faults",		""		},
-  { CSW(CONTEXT_SWITCHES),	"context-switches",	"cs"		},
-  { CSW(CPU_MIGRATIONS),	"cpu-migrations",	"migrations"	},
-  { CSW(ALIGNMENT_FAULTS),	"alignment-faults",	""		},
-  { CSW(EMULATION_FAULTS),	"emulation-faults",	""		},
+  { CHW(CPU_CYCLES),			"cpu-cycles",			"cycles"		},
+  { CHW(STALLED_CYCLES_FRONTEND),	"stalled-cycles-frontend",	"idle-cycles-frontend"	},
+  { CHW(STALLED_CYCLES_BACKEND),	"stalled-cycles-backend",	"idle-cycles-backend"	},
+  { CHW(INSTRUCTIONS),			"instructions",			""			},
+  { CHW(CACHE_REFERENCES),		"cache-references",		""			},
+  { CHW(CACHE_MISSES),			"cache-misses",			""			},
+  { CHW(BRANCH_INSTRUCTIONS),		"branch-instructions",		"branches"		},
+  { CHW(BRANCH_MISSES),			"branch-misses",		""			},
+  { CHW(BUS_CYCLES),			"bus-cycles",			""			},
+
+  { CSW(CPU_CLOCK),			"cpu-clock",			""			},
+  { CSW(TASK_CLOCK),			"task-clock",			""			},
+  { CSW(PAGE_FAULTS),			"page-faults",			"faults"		},
+  { CSW(PAGE_FAULTS_MIN),		"minor-faults",			""			},
+  { CSW(PAGE_FAULTS_MAJ),		"major-faults",			""			},
+  { CSW(CONTEXT_SWITCHES),		"context-switches",		"cs"			},
+  { CSW(CPU_MIGRATIONS),		"cpu-migrations",		"migrations"		},
+  { CSW(ALIGNMENT_FAULTS),		"alignment-faults",		""			},
+  { CSW(EMULATION_FAULTS),		"emulation-faults",		""			},
 };
 
 #define __PERF_EVENT_FIELD(config, name) \
diff --git a/tools/perf/util/python.c b/tools/perf/util/python.c
index 406f613..8b0eff8 100644
--- a/tools/perf/util/python.c
+++ b/tools/perf/util/python.c
@@ -798,7 +798,6 @@ static struct {
 	{ "COUNT_HW_BRANCH_INSTRUCTIONS", PERF_COUNT_HW_BRANCH_INSTRUCTIONS },
 	{ "COUNT_HW_BRANCH_MISSES",	  PERF_COUNT_HW_BRANCH_MISSES },
 	{ "COUNT_HW_BUS_CYCLES",	  PERF_COUNT_HW_BUS_CYCLES },
-	{ "COUNT_HW_STALLED_CYCLES",	  PERF_COUNT_HW_STALLED_CYCLES },
 	{ "COUNT_HW_CACHE_L1D",		  PERF_COUNT_HW_CACHE_L1D },
 	{ "COUNT_HW_CACHE_L1I",		  PERF_COUNT_HW_CACHE_L1I },
 	{ "COUNT_HW_CACHE_LL",	  	  PERF_COUNT_HW_CACHE_LL },
@@ -811,6 +810,9 @@ static struct {
 	{ "COUNT_HW_CACHE_RESULT_ACCESS", PERF_COUNT_HW_CACHE_RESULT_ACCESS },
 	{ "COUNT_HW_CACHE_RESULT_MISS",   PERF_COUNT_HW_CACHE_RESULT_MISS },
 
+	{ "COUNT_HW_STALLED_CYCLES_FRONTEND",	  PERF_COUNT_HW_STALLED_CYCLES_FRONTEND },
+	{ "COUNT_HW_STALLED_CYCLES_BACKEND",	  PERF_COUNT_HW_STALLED_CYCLES_BACKEND },
+
 	{ "COUNT_SW_CPU_CLOCK",	       PERF_COUNT_SW_CPU_CLOCK },
 	{ "COUNT_SW_TASK_CLOCK",       PERF_COUNT_SW_TASK_CLOCK },
 	{ "COUNT_SW_PAGE_FAULTS",      PERF_COUNT_SW_PAGE_FAULTS },
