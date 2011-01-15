Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753170Ab1AOPY2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jan 2011 10:24:28 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:34236 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752557Ab1AOPY0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jan 2011 10:24:26 -0500
Date: Sat, 15 Jan 2011 16:24:10 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] perf fixes
Message-ID: <20110115152410.GA12751@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest perf-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git perf-fixes-for-linus

 Thanks,

	Ingo

------------------>
Arnaldo Carvalho de Melo (3):
      perf evsel: Fix order of event list deletion
      perf top: Fix annotate segv
      Revert "perf tools: Emit clearer message for sys_perf_event_open ENOENT return"

Kirill Smelkov (1):
      perf record: Add "nodelay" mode, disabled by default

Lai Jiangshan (1):
      tracing: Remove syscall_exit_fields

Stephane Eranian (1):
      perf sched: Fix list of events, dropping unsupported ':r' modifier

Steven Rostedt (1):
      tracing: Only process module tracepoints once


 include/trace/events/module.h            |   10 +++++++++
 kernel/trace/trace_syscalls.c            |   33 ++++++++++-------------------
 tools/perf/Documentation/perf-record.txt |    3 ++
 tools/perf/builtin-record.c              |   12 ++++++++--
 tools/perf/builtin-sched.c               |   18 ++++++++--------
 tools/perf/builtin-stat.c                |    1 +
 tools/perf/builtin-top.c                 |    5 ++-
 tools/perf/perf.c                        |    2 -
 8 files changed, 47 insertions(+), 37 deletions(-)

diff --git a/include/trace/events/module.h b/include/trace/events/module.h
index c7bb2f0..c6bae36 100644
--- a/include/trace/events/module.h
+++ b/include/trace/events/module.h
@@ -1,5 +1,15 @@
+/*
+ * Because linux/module.h has tracepoints in the header, and ftrace.h
+ * eventually includes this file, define_trace.h includes linux/module.h
+ * But we do not want the module.h to override the TRACE_SYSTEM macro
+ * variable that define_trace.h is processing, so we only set it
+ * when module events are being processed, which would happen when
+ * CREATE_TRACE_POINTS is defined.
+ */
+#ifdef CREATE_TRACE_POINTS
 #undef TRACE_SYSTEM
 #define TRACE_SYSTEM module
+#endif
 
 #if !defined(_TRACE_MODULE_H) || defined(TRACE_HEADER_MULTI_READ)
 #define _TRACE_MODULE_H
diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index bac752f..b706529 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -23,9 +23,6 @@ static int syscall_exit_register(struct ftrace_event_call *event,
 static int syscall_enter_define_fields(struct ftrace_event_call *call);
 static int syscall_exit_define_fields(struct ftrace_event_call *call);
 
-/* All syscall exit events have the same fields */
-static LIST_HEAD(syscall_exit_fields);
-
 static struct list_head *
 syscall_get_enter_fields(struct ftrace_event_call *call)
 {
@@ -34,34 +31,28 @@ syscall_get_enter_fields(struct ftrace_event_call *call)
 	return &entry->enter_fields;
 }
 
-static struct list_head *
-syscall_get_exit_fields(struct ftrace_event_call *call)
-{
-	return &syscall_exit_fields;
-}
-
 struct trace_event_functions enter_syscall_print_funcs = {
-	.trace                  = print_syscall_enter,
+	.trace		= print_syscall_enter,
 };
 
 struct trace_event_functions exit_syscall_print_funcs = {
-	.trace                  = print_syscall_exit,
+	.trace		= print_syscall_exit,
 };
 
 struct ftrace_event_class event_class_syscall_enter = {
-	.system			= "syscalls",
-	.reg			= syscall_enter_register,
-	.define_fields		= syscall_enter_define_fields,
-	.get_fields		= syscall_get_enter_fields,
-	.raw_init		= init_syscall_trace,
+	.system		= "syscalls",
+	.reg		= syscall_enter_register,
+	.define_fields	= syscall_enter_define_fields,
+	.get_fields	= syscall_get_enter_fields,
+	.raw_init	= init_syscall_trace,
 };
 
 struct ftrace_event_class event_class_syscall_exit = {
-	.system			= "syscalls",
-	.reg			= syscall_exit_register,
-	.define_fields		= syscall_exit_define_fields,
-	.get_fields		= syscall_get_exit_fields,
-	.raw_init		= init_syscall_trace,
+	.system		= "syscalls",
+	.reg		= syscall_exit_register,
+	.define_fields	= syscall_exit_define_fields,
+	.fields		= LIST_HEAD_INIT(event_class_syscall_exit.fields),
+	.raw_init	= init_syscall_trace,
 };
 
 extern unsigned long __start_syscalls_metadata[];
diff --git a/tools/perf/Documentation/perf-record.txt b/tools/perf/Documentation/perf-record.txt
index 52462ae..e032716 100644
--- a/tools/perf/Documentation/perf-record.txt
+++ b/tools/perf/Documentation/perf-record.txt
@@ -61,6 +61,9 @@ OPTIONS
 -r::
 --realtime=::
 	Collect data with this RT SCHED_FIFO priority.
+-D::
+--no-delay::
+	Collect data without buffering.
 -A::
 --append::
 	Append to the output file to do incremental profiling.
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 7069bd3..df6064a 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -49,6 +49,7 @@ static int			pipe_output			=      0;
 static const char		*output_name			= "perf.data";
 static int			group				=      0;
 static int			realtime_prio			=      0;
+static bool			nodelay				=  false;
 static bool			raw_samples			=  false;
 static bool			sample_id_all_avail		=   true;
 static bool			system_wide			=  false;
@@ -307,6 +308,11 @@ static void create_counter(struct perf_evsel *evsel, int cpu)
 		attr->sample_type	|= PERF_SAMPLE_CPU;
 	}
 
+	if (nodelay) {
+		attr->watermark = 0;
+		attr->wakeup_events = 1;
+	}
+
 	attr->mmap		= track;
 	attr->comm		= track;
 	attr->inherit		= !no_inherit;
@@ -331,9 +337,6 @@ try_again:
 			else if (err ==  ENODEV && cpu_list) {
 				die("No such device - did you specify"
 					" an out-of-range profile CPU?\n");
-			} else if (err == ENOENT) {
-				die("%s event is not supported. ",
-				     event_name(evsel));
 			} else if (err == EINVAL && sample_id_all_avail) {
 				/*
 				 * Old kernel, no attr->sample_id_type_all field
@@ -480,6 +483,7 @@ static void atexit_header(void)
 			process_buildids();
 		perf_header__write(&session->header, output, true);
 		perf_session__delete(session);
+		perf_evsel_list__delete();
 		symbol__exit();
 	}
 }
@@ -845,6 +849,8 @@ const struct option record_options[] = {
 		    "record events on existing thread id"),
 	OPT_INTEGER('r', "realtime", &realtime_prio,
 		    "collect data with this RT SCHED_FIFO priority"),
+	OPT_BOOLEAN('D', "no-delay", &nodelay,
+		    "collect data without buffering"),
 	OPT_BOOLEAN('R', "raw-samples", &raw_samples,
 		    "collect raw sample records from all opened counters"),
 	OPT_BOOLEAN('a', "all-cpus", &system_wide,
diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index abd4b84..29e7ffd 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -1843,15 +1843,15 @@ static const char *record_args[] = {
 	"-f",
 	"-m", "1024",
 	"-c", "1",
-	"-e", "sched:sched_switch:r",
-	"-e", "sched:sched_stat_wait:r",
-	"-e", "sched:sched_stat_sleep:r",
-	"-e", "sched:sched_stat_iowait:r",
-	"-e", "sched:sched_stat_runtime:r",
-	"-e", "sched:sched_process_exit:r",
-	"-e", "sched:sched_process_fork:r",
-	"-e", "sched:sched_wakeup:r",
-	"-e", "sched:sched_migrate_task:r",
+	"-e", "sched:sched_switch",
+	"-e", "sched:sched_stat_wait",
+	"-e", "sched:sched_stat_sleep",
+	"-e", "sched:sched_stat_iowait",
+	"-e", "sched:sched_stat_runtime",
+	"-e", "sched:sched_process_exit",
+	"-e", "sched:sched_process_fork",
+	"-e", "sched:sched_wakeup",
+	"-e", "sched:sched_migrate_task",
 };
 
 static int __cmd_record(int argc, const char **argv)
diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index c385a63..0ff11d9 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -743,6 +743,7 @@ int cmd_stat(int argc, const char **argv, const char *prefix __used)
 out_free_fd:
 	list_for_each_entry(pos, &evsel_list, node)
 		perf_evsel__free_stat_priv(pos);
+	perf_evsel_list__delete();
 out:
 	thread_map__delete(threads);
 	threads = NULL;
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 6ce4042..05344c6 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -1247,8 +1247,6 @@ try_again:
 				die("Permission error - are you root?\n"
 					"\t Consider tweaking"
 					" /proc/sys/kernel/perf_event_paranoid.\n");
-			if (err == ENOENT)
-				die("%s event is not supported. ", event_name(evsel));
 			/*
 			 * If it's cycles then fall back to hrtimer
 			 * based cpu-clock-tick sw counter, which
@@ -1473,6 +1471,8 @@ int cmd_top(int argc, const char **argv, const char *prefix __used)
 		pos->attr.sample_period = default_interval;
 	}
 
+	sym_evsel = list_entry(evsel_list.next, struct perf_evsel, node);
+
 	symbol_conf.priv_size = (sizeof(struct sym_entry) +
 				 (nr_counters + 1) * sizeof(unsigned long));
 
@@ -1490,6 +1490,7 @@ int cmd_top(int argc, const char **argv, const char *prefix __used)
 out_free_fd:
 	list_for_each_entry(pos, &evsel_list, node)
 		perf_evsel__free_mmap(pos);
+	perf_evsel_list__delete();
 
 	return status;
 }
diff --git a/tools/perf/perf.c b/tools/perf/perf.c
index 5b1ecd6..595d0f4 100644
--- a/tools/perf/perf.c
+++ b/tools/perf/perf.c
@@ -286,8 +286,6 @@ static int run_builtin(struct cmd_struct *p, int argc, const char **argv)
 	status = p->fn(argc, argv, prefix);
 	exit_browser(status);
 
-	perf_evsel_list__delete();
-
 	if (status)
 		return status & 0xff;
 
