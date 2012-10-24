Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422725Ab2JXVvO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 17:51:14 -0400
Received: from casper.infradead.org ([85.118.1.10]:40980 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422692Ab2JXVvJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 17:51:09 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 09/12] perf trace: Add duration filter
Date: Wed, 24 Oct 2012 19:50:20 -0200
Message-Id: <1351115423-9025-10-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1351115423-9025-1-git-send-email-acme@infradead.org>
References: <1351115423-9025-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Example:

[acme@sandy linux]$ perf trace --duration 0.025 usleep 1
     2.221 ( 0.958 ms): 6724 execve(arg0: 140733557168278, arg1: 140733557178768, arg2: 16134304, arg3: 140733557167840, arg4: 7955998171588342573, arg5: 6723) = -2
     3.690 ( 1.443 ms): 6724 execve(arg0: 140733557168295, arg1: 140733557178768, arg2: 16134304, arg3: 140733557167840, arg4: 7955998171588342573, arg5: 6723) = 0
     3.979 ( 0.048 ms): 6724 open(filename: 208733843841, flags: 0, mode: 1                        ) = 3
     4.071 ( 0.075 ms): 6724 open(filename: 139744419925673, flags: 0, mode: 0                     ) = 3
     4.318 ( 0.056 ms): 6724 nanosleep(rqtp: 140734030404608, rmtp: 0                              ) = 0
[acme@sandy linux]$ perf trace --duration 0.100 usleep 1
     1.143 ( 1.021 ms): 6726 execve(arg0: 140736323962279, arg1: 140736323972752, arg2: 34926752, arg3: 140736323961824, arg4: 7955998171588342573, arg5: 6725) = 0
[acme@sandy linux]$

Cherry picked from tmp.perf/trace2 branch.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Link: http://lkml.kernel.org/n/tip-oslw2j2958we9qf0ctra4whd@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/perf-trace.txt |    3 +++
 tools/perf/builtin-trace.c              |   32 +++++++++++++++++++++++++++----
 2 files changed, 31 insertions(+), 4 deletions(-)

diff --git a/tools/perf/Documentation/perf-trace.txt b/tools/perf/Documentation/perf-trace.txt
index 3a2ae37..38d4b68 100644
--- a/tools/perf/Documentation/perf-trace.txt
+++ b/tools/perf/Documentation/perf-trace.txt
@@ -48,6 +48,9 @@ comma-separated list with no space: 0,1. Ranges of CPUs are specified with -: 0-
 In per-thread mode with inheritance mode on (default), Events are captured only when
 the thread executes on the designated CPUs. Default is to monitor all CPUs.
 
+--duration:
+	Show only events that had a duration greater than N.M ms.
+
 SEE ALSO
 --------
 linkperf:perf-record[1], linkperf:perf-script[1]
diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index ddb6e37..82ffa6c 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -100,8 +100,14 @@ struct trace {
 	struct machine		host;
 	u64			base_time;
 	bool			multiple_threads;
+	double			duration_filter;
 };
 
+static bool trace__filter_duration(struct trace *trace, double t)
+{
+	return t < (trace->duration_filter * NSEC_PER_MSEC);
+}
+
 static size_t trace__fprintf_tstamp(struct trace *trace, u64 tstamp, FILE *fp)
 {
 	double ts = (double)(tstamp - trace->base_time) / NSEC_PER_MSEC;
@@ -307,8 +313,10 @@ static int trace__sys_enter(struct trace *trace, struct perf_evsel *evsel,
 	printed += syscall__scnprintf_args(sc, msg + printed, 1024 - printed,  args);
 
 	if (!strcmp(sc->name, "exit_group") || !strcmp(sc->name, "exit")) {
-		trace__fprintf_entry_head(trace, thread, 1, sample->time, stdout);
-		printf("%-70s\n", ttrace->entry_str);
+		if (!trace->duration_filter) {
+			trace__fprintf_entry_head(trace, thread, 1, sample->time, stdout);
+			printf("%-70s\n", ttrace->entry_str);
+		}
 	} else
 		ttrace->entry_pending = true;
 
@@ -333,8 +341,12 @@ static int trace__sys_exit(struct trace *trace, struct perf_evsel *evsel,
 
 	ttrace->exit_time = sample->time;
 
-	if (ttrace->entry_time)
+	if (ttrace->entry_time) {
 		duration = sample->time - ttrace->entry_time;
+		if (trace__filter_duration(trace, duration))
+			goto out;
+	} else if (trace->duration_filter)
+		goto out;
 
 	trace__fprintf_entry_head(trace, thread, duration, sample->time, stdout);
 
@@ -358,7 +370,7 @@ static int trace__sys_exit(struct trace *trace, struct perf_evsel *evsel,
 		printf(") = %d", ret);
 
 	putchar('\n');
-
+out:
 	ttrace->entry_pending = false;
 
 	return 0;
@@ -495,6 +507,15 @@ out:
 	return err;
 }
 
+static int trace__set_duration(const struct option *opt, const char *str,
+			       int unset __maybe_unused)
+{
+	struct trace *trace = opt->value;
+
+	trace->duration_filter = atof(str);
+	return 0;
+}
+
 int cmd_trace(int argc, const char **argv, const char *prefix __maybe_unused)
 {
 	const char * const trace_usage[] = {
@@ -533,6 +554,9 @@ int cmd_trace(int argc, const char **argv, const char *prefix __maybe_unused)
 		     "number of mmap data pages"),
 	OPT_STRING(0, "uid", &trace.opts.target.uid_str, "user",
 		   "user to profile"),
+	OPT_CALLBACK(0, "duration", &trace, "float",
+		     "show only events with duration > N.M ms",
+		     trace__set_duration),
 	OPT_END()
 	};
 	int err;
-- 
1.7.9.2.358.g22243

