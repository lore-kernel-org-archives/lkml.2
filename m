Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754379Ab2JEIlH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 04:41:07 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60807 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754334Ab2JEIlA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 04:41:00 -0400
Date: Fri, 5 Oct 2012 01:40:23 -0700
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-spa8e7nnohtn1z32q2l2ae2c@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf stat: Don't use globals where not needed to
Git-Commit-ID: b070a547fda009bdb840b90aab7274be9e41de4d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 05 Oct 2012 01:40:29 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b070a547fda009bdb840b90aab7274be9e41de4d
Gitweb:     http://git.kernel.org/tip/b070a547fda009bdb840b90aab7274be9e41de4d
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Mon, 1 Oct 2012 15:20:58 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 2 Oct 2012 18:36:29 -0300

perf stat: Don't use globals where not needed to

Some variables were global but used in just one function, so move it to
where it belongs.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-spa8e7nnohtn1z32q2l2ae2c@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-stat.c |  328 ++++++++++++++++++++++-----------------------
 1 files changed, 159 insertions(+), 169 deletions(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index e8cd4d8..93b9011 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -64,122 +64,12 @@
 #define CNTR_NOT_SUPPORTED	"<not supported>"
 #define CNTR_NOT_COUNTED	"<not counted>"
 
-static struct perf_event_attr default_attrs[] = {
-
-  { .type = PERF_TYPE_SOFTWARE, .config = PERF_COUNT_SW_TASK_CLOCK		},
-  { .type = PERF_TYPE_SOFTWARE, .config = PERF_COUNT_SW_CONTEXT_SWITCHES	},
-  { .type = PERF_TYPE_SOFTWARE, .config = PERF_COUNT_SW_CPU_MIGRATIONS		},
-  { .type = PERF_TYPE_SOFTWARE, .config = PERF_COUNT_SW_PAGE_FAULTS		},
-
-  { .type = PERF_TYPE_HARDWARE, .config = PERF_COUNT_HW_CPU_CYCLES		},
-  { .type = PERF_TYPE_HARDWARE, .config = PERF_COUNT_HW_STALLED_CYCLES_FRONTEND	},
-  { .type = PERF_TYPE_HARDWARE, .config = PERF_COUNT_HW_STALLED_CYCLES_BACKEND	},
-  { .type = PERF_TYPE_HARDWARE, .config = PERF_COUNT_HW_INSTRUCTIONS		},
-  { .type = PERF_TYPE_HARDWARE, .config = PERF_COUNT_HW_BRANCH_INSTRUCTIONS	},
-  { .type = PERF_TYPE_HARDWARE, .config = PERF_COUNT_HW_BRANCH_MISSES		},
-
-};
-
-/*
- * Detailed stats (-d), covering the L1 and last level data caches:
- */
-static struct perf_event_attr detailed_attrs[] = {
-
-  { .type = PERF_TYPE_HW_CACHE,
-    .config =
-	 PERF_COUNT_HW_CACHE_L1D		<<  0  |
-	(PERF_COUNT_HW_CACHE_OP_READ		<<  8) |
-	(PERF_COUNT_HW_CACHE_RESULT_ACCESS	<< 16)				},
-
-  { .type = PERF_TYPE_HW_CACHE,
-    .config =
-	 PERF_COUNT_HW_CACHE_L1D		<<  0  |
-	(PERF_COUNT_HW_CACHE_OP_READ		<<  8) |
-	(PERF_COUNT_HW_CACHE_RESULT_MISS	<< 16)				},
-
-  { .type = PERF_TYPE_HW_CACHE,
-    .config =
-	 PERF_COUNT_HW_CACHE_LL			<<  0  |
-	(PERF_COUNT_HW_CACHE_OP_READ		<<  8) |
-	(PERF_COUNT_HW_CACHE_RESULT_ACCESS	<< 16)				},
-
-  { .type = PERF_TYPE_HW_CACHE,
-    .config =
-	 PERF_COUNT_HW_CACHE_LL			<<  0  |
-	(PERF_COUNT_HW_CACHE_OP_READ		<<  8) |
-	(PERF_COUNT_HW_CACHE_RESULT_MISS	<< 16)				},
-};
-
-/*
- * Very detailed stats (-d -d), covering the instruction cache and the TLB caches:
- */
-static struct perf_event_attr very_detailed_attrs[] = {
-
-  { .type = PERF_TYPE_HW_CACHE,
-    .config =
-	 PERF_COUNT_HW_CACHE_L1I		<<  0  |
-	(PERF_COUNT_HW_CACHE_OP_READ		<<  8) |
-	(PERF_COUNT_HW_CACHE_RESULT_ACCESS	<< 16)				},
-
-  { .type = PERF_TYPE_HW_CACHE,
-    .config =
-	 PERF_COUNT_HW_CACHE_L1I		<<  0  |
-	(PERF_COUNT_HW_CACHE_OP_READ		<<  8) |
-	(PERF_COUNT_HW_CACHE_RESULT_MISS	<< 16)				},
-
-  { .type = PERF_TYPE_HW_CACHE,
-    .config =
-	 PERF_COUNT_HW_CACHE_DTLB		<<  0  |
-	(PERF_COUNT_HW_CACHE_OP_READ		<<  8) |
-	(PERF_COUNT_HW_CACHE_RESULT_ACCESS	<< 16)				},
-
-  { .type = PERF_TYPE_HW_CACHE,
-    .config =
-	 PERF_COUNT_HW_CACHE_DTLB		<<  0  |
-	(PERF_COUNT_HW_CACHE_OP_READ		<<  8) |
-	(PERF_COUNT_HW_CACHE_RESULT_MISS	<< 16)				},
-
-  { .type = PERF_TYPE_HW_CACHE,
-    .config =
-	 PERF_COUNT_HW_CACHE_ITLB		<<  0  |
-	(PERF_COUNT_HW_CACHE_OP_READ		<<  8) |
-	(PERF_COUNT_HW_CACHE_RESULT_ACCESS	<< 16)				},
-
-  { .type = PERF_TYPE_HW_CACHE,
-    .config =
-	 PERF_COUNT_HW_CACHE_ITLB		<<  0  |
-	(PERF_COUNT_HW_CACHE_OP_READ		<<  8) |
-	(PERF_COUNT_HW_CACHE_RESULT_MISS	<< 16)				},
-
-};
-
-/*
- * Very, very detailed stats (-d -d -d), adding prefetch events:
- */
-static struct perf_event_attr very_very_detailed_attrs[] = {
-
-  { .type = PERF_TYPE_HW_CACHE,
-    .config =
-	 PERF_COUNT_HW_CACHE_L1D		<<  0  |
-	(PERF_COUNT_HW_CACHE_OP_PREFETCH	<<  8) |
-	(PERF_COUNT_HW_CACHE_RESULT_ACCESS	<< 16)				},
-
-  { .type = PERF_TYPE_HW_CACHE,
-    .config =
-	 PERF_COUNT_HW_CACHE_L1D		<<  0  |
-	(PERF_COUNT_HW_CACHE_OP_PREFETCH	<<  8) |
-	(PERF_COUNT_HW_CACHE_RESULT_MISS	<< 16)				},
-};
-
-
-
 static struct perf_evlist	*evsel_list;
 
 static struct perf_target	target = {
 	.uid	= UINT_MAX,
 };
 
-static int			run_idx				=  0;
 static int			run_count			=  1;
 static bool			no_inherit			= false;
 static bool			scale				=  true;
@@ -187,15 +77,12 @@ static bool			no_aggr				= false;
 static pid_t			child_pid			= -1;
 static bool			null_run			=  false;
 static int			detailed_run			=  0;
-static bool			sync_run			=  false;
 static bool			big_num				=  true;
 static int			big_num_opt			=  -1;
 static const char		*csv_sep			= NULL;
 static bool			csv_output			= false;
 static bool			group				= false;
-static const char		*output_name			= NULL;
 static FILE			*output				= NULL;
-static int			output_fd;
 
 static volatile int done = 0;
 
@@ -1028,11 +915,6 @@ static void sig_atexit(void)
 	kill(getpid(), signr);
 }
 
-static const char * const stat_usage[] = {
-	"perf stat [<options>] [<command>]",
-	NULL
-};
-
 static int stat__set_big_num(const struct option *opt __maybe_unused,
 			     const char *s __maybe_unused, int unset)
 {
@@ -1040,62 +922,119 @@ static int stat__set_big_num(const struct option *opt __maybe_unused,
 	return 0;
 }
 
-static bool append_file;
-
-static const struct option options[] = {
-	OPT_CALLBACK('e', "event", &evsel_list, "event",
-		     "event selector. use 'perf list' to list available events",
-		     parse_events_option),
-	OPT_CALLBACK(0, "filter", &evsel_list, "filter",
-		     "event filter", parse_filter),
-	OPT_BOOLEAN('i', "no-inherit", &no_inherit,
-		    "child tasks do not inherit counters"),
-	OPT_STRING('p', "pid", &target.pid, "pid",
-		   "stat events on existing process id"),
-	OPT_STRING('t', "tid", &target.tid, "tid",
-		   "stat events on existing thread id"),
-	OPT_BOOLEAN('a', "all-cpus", &target.system_wide,
-		    "system-wide collection from all CPUs"),
-	OPT_BOOLEAN('g', "group", &group,
-		    "put the counters into a counter group"),
-	OPT_BOOLEAN('c', "scale", &scale,
-		    "scale/normalize counters"),
-	OPT_INCR('v', "verbose", &verbose,
-		    "be more verbose (show counter open errors, etc)"),
-	OPT_INTEGER('r', "repeat", &run_count,
-		    "repeat command and print average + stddev (max: 100)"),
-	OPT_BOOLEAN('n', "null", &null_run,
-		    "null run - dont start any counters"),
-	OPT_INCR('d', "detailed", &detailed_run,
-		    "detailed run - start a lot of events"),
-	OPT_BOOLEAN('S', "sync", &sync_run,
-		    "call sync() before starting a run"),
-	OPT_CALLBACK_NOOPT('B', "big-num", NULL, NULL, 
-			   "print large numbers with thousands\' separators",
-			   stat__set_big_num),
-	OPT_STRING('C', "cpu", &target.cpu_list, "cpu",
-		    "list of cpus to monitor in system-wide"),
-	OPT_BOOLEAN('A', "no-aggr", &no_aggr,
-		    "disable CPU count aggregation"),
-	OPT_STRING('x', "field-separator", &csv_sep, "separator",
-		   "print counts with custom separator"),
-	OPT_CALLBACK('G', "cgroup", &evsel_list, "name",
-		     "monitor event in cgroup name only",
-		     parse_cgroups),
-	OPT_STRING('o', "output", &output_name, "file",
-		    "output file name"),
-	OPT_BOOLEAN(0, "append", &append_file, "append to the output file"),
-	OPT_INTEGER(0, "log-fd", &output_fd,
-		    "log output to fd, instead of stderr"),
-	OPT_END()
-};
-
 /*
  * Add default attributes, if there were no attributes specified or
  * if -d/--detailed, -d -d or -d -d -d is used:
  */
 static int add_default_attributes(void)
 {
+	struct perf_event_attr default_attrs[] = {
+
+  { .type = PERF_TYPE_SOFTWARE, .config = PERF_COUNT_SW_TASK_CLOCK		},
+  { .type = PERF_TYPE_SOFTWARE, .config = PERF_COUNT_SW_CONTEXT_SWITCHES	},
+  { .type = PERF_TYPE_SOFTWARE, .config = PERF_COUNT_SW_CPU_MIGRATIONS		},
+  { .type = PERF_TYPE_SOFTWARE, .config = PERF_COUNT_SW_PAGE_FAULTS		},
+
+  { .type = PERF_TYPE_HARDWARE, .config = PERF_COUNT_HW_CPU_CYCLES		},
+  { .type = PERF_TYPE_HARDWARE, .config = PERF_COUNT_HW_STALLED_CYCLES_FRONTEND	},
+  { .type = PERF_TYPE_HARDWARE, .config = PERF_COUNT_HW_STALLED_CYCLES_BACKEND	},
+  { .type = PERF_TYPE_HARDWARE, .config = PERF_COUNT_HW_INSTRUCTIONS		},
+  { .type = PERF_TYPE_HARDWARE, .config = PERF_COUNT_HW_BRANCH_INSTRUCTIONS	},
+  { .type = PERF_TYPE_HARDWARE, .config = PERF_COUNT_HW_BRANCH_MISSES		},
+
+};
+
+/*
+ * Detailed stats (-d), covering the L1 and last level data caches:
+ */
+	struct perf_event_attr detailed_attrs[] = {
+
+  { .type = PERF_TYPE_HW_CACHE,
+    .config =
+	 PERF_COUNT_HW_CACHE_L1D		<<  0  |
+	(PERF_COUNT_HW_CACHE_OP_READ		<<  8) |
+	(PERF_COUNT_HW_CACHE_RESULT_ACCESS	<< 16)				},
+
+  { .type = PERF_TYPE_HW_CACHE,
+    .config =
+	 PERF_COUNT_HW_CACHE_L1D		<<  0  |
+	(PERF_COUNT_HW_CACHE_OP_READ		<<  8) |
+	(PERF_COUNT_HW_CACHE_RESULT_MISS	<< 16)				},
+
+  { .type = PERF_TYPE_HW_CACHE,
+    .config =
+	 PERF_COUNT_HW_CACHE_LL			<<  0  |
+	(PERF_COUNT_HW_CACHE_OP_READ		<<  8) |
+	(PERF_COUNT_HW_CACHE_RESULT_ACCESS	<< 16)				},
+
+  { .type = PERF_TYPE_HW_CACHE,
+    .config =
+	 PERF_COUNT_HW_CACHE_LL			<<  0  |
+	(PERF_COUNT_HW_CACHE_OP_READ		<<  8) |
+	(PERF_COUNT_HW_CACHE_RESULT_MISS	<< 16)				},
+};
+
+/*
+ * Very detailed stats (-d -d), covering the instruction cache and the TLB caches:
+ */
+	struct perf_event_attr very_detailed_attrs[] = {
+
+  { .type = PERF_TYPE_HW_CACHE,
+    .config =
+	 PERF_COUNT_HW_CACHE_L1I		<<  0  |
+	(PERF_COUNT_HW_CACHE_OP_READ		<<  8) |
+	(PERF_COUNT_HW_CACHE_RESULT_ACCESS	<< 16)				},
+
+  { .type = PERF_TYPE_HW_CACHE,
+    .config =
+	 PERF_COUNT_HW_CACHE_L1I		<<  0  |
+	(PERF_COUNT_HW_CACHE_OP_READ		<<  8) |
+	(PERF_COUNT_HW_CACHE_RESULT_MISS	<< 16)				},
+
+  { .type = PERF_TYPE_HW_CACHE,
+    .config =
+	 PERF_COUNT_HW_CACHE_DTLB		<<  0  |
+	(PERF_COUNT_HW_CACHE_OP_READ		<<  8) |
+	(PERF_COUNT_HW_CACHE_RESULT_ACCESS	<< 16)				},
+
+  { .type = PERF_TYPE_HW_CACHE,
+    .config =
+	 PERF_COUNT_HW_CACHE_DTLB		<<  0  |
+	(PERF_COUNT_HW_CACHE_OP_READ		<<  8) |
+	(PERF_COUNT_HW_CACHE_RESULT_MISS	<< 16)				},
+
+  { .type = PERF_TYPE_HW_CACHE,
+    .config =
+	 PERF_COUNT_HW_CACHE_ITLB		<<  0  |
+	(PERF_COUNT_HW_CACHE_OP_READ		<<  8) |
+	(PERF_COUNT_HW_CACHE_RESULT_ACCESS	<< 16)				},
+
+  { .type = PERF_TYPE_HW_CACHE,
+    .config =
+	 PERF_COUNT_HW_CACHE_ITLB		<<  0  |
+	(PERF_COUNT_HW_CACHE_OP_READ		<<  8) |
+	(PERF_COUNT_HW_CACHE_RESULT_MISS	<< 16)				},
+
+};
+
+/*
+ * Very, very detailed stats (-d -d -d), adding prefetch events:
+ */
+	struct perf_event_attr very_very_detailed_attrs[] = {
+
+  { .type = PERF_TYPE_HW_CACHE,
+    .config =
+	 PERF_COUNT_HW_CACHE_L1D		<<  0  |
+	(PERF_COUNT_HW_CACHE_OP_PREFETCH	<<  8) |
+	(PERF_COUNT_HW_CACHE_RESULT_ACCESS	<< 16)				},
+
+  { .type = PERF_TYPE_HW_CACHE,
+    .config =
+	 PERF_COUNT_HW_CACHE_L1D		<<  0  |
+	(PERF_COUNT_HW_CACHE_OP_PREFETCH	<<  8) |
+	(PERF_COUNT_HW_CACHE_RESULT_MISS	<< 16)				},
+};
+
 	/* Set attrs if no event is selected and !null_run: */
 	if (null_run)
 		return 0;
@@ -1130,8 +1069,59 @@ static int add_default_attributes(void)
 
 int cmd_stat(int argc, const char **argv, const char *prefix __maybe_unused)
 {
+	bool append_file = false,
+	     sync_run = false;
+	int output_fd = 0;
+	const char *output_name	= NULL;
+	const struct option options[] = {
+	OPT_CALLBACK('e', "event", &evsel_list, "event",
+		     "event selector. use 'perf list' to list available events",
+		     parse_events_option),
+	OPT_CALLBACK(0, "filter", &evsel_list, "filter",
+		     "event filter", parse_filter),
+	OPT_BOOLEAN('i', "no-inherit", &no_inherit,
+		    "child tasks do not inherit counters"),
+	OPT_STRING('p', "pid", &target.pid, "pid",
+		   "stat events on existing process id"),
+	OPT_STRING('t', "tid", &target.tid, "tid",
+		   "stat events on existing thread id"),
+	OPT_BOOLEAN('a', "all-cpus", &target.system_wide,
+		    "system-wide collection from all CPUs"),
+	OPT_BOOLEAN('g', "group", &group,
+		    "put the counters into a counter group"),
+	OPT_BOOLEAN('c', "scale", &scale, "scale/normalize counters"),
+	OPT_INCR('v', "verbose", &verbose,
+		    "be more verbose (show counter open errors, etc)"),
+	OPT_INTEGER('r', "repeat", &run_count,
+		    "repeat command and print average + stddev (max: 100)"),
+	OPT_BOOLEAN('n', "null", &null_run,
+		    "null run - dont start any counters"),
+	OPT_INCR('d', "detailed", &detailed_run,
+		    "detailed run - start a lot of events"),
+	OPT_BOOLEAN('S', "sync", &sync_run,
+		    "call sync() before starting a run"),
+	OPT_CALLBACK_NOOPT('B', "big-num", NULL, NULL, 
+			   "print large numbers with thousands\' separators",
+			   stat__set_big_num),
+	OPT_STRING('C', "cpu", &target.cpu_list, "cpu",
+		    "list of cpus to monitor in system-wide"),
+	OPT_BOOLEAN('A', "no-aggr", &no_aggr, "disable CPU count aggregation"),
+	OPT_STRING('x', "field-separator", &csv_sep, "separator",
+		   "print counts with custom separator"),
+	OPT_CALLBACK('G', "cgroup", &evsel_list, "name",
+		     "monitor event in cgroup name only", parse_cgroups),
+	OPT_STRING('o', "output", &output_name, "file", "output file name"),
+	OPT_BOOLEAN(0, "append", &append_file, "append to the output file"),
+	OPT_INTEGER(0, "log-fd", &output_fd,
+		    "log output to fd, instead of stderr"),
+	OPT_END()
+	};
+	const char * const stat_usage[] = {
+		"perf stat [<options>] [<command>]",
+		NULL
+	};
 	struct perf_evsel *pos;
-	int status = -ENOMEM;
+	int status = -ENOMEM, run_idx;
 	const char *mode;
 
 	setlocale(LC_ALL, "");
