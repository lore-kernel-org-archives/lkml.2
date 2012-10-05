Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752433Ab2JEG5i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 02:57:38 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:64568 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752332Ab2JEG5f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 02:57:35 -0400
X-AuditID: 9c930179-b7bf9ae000000e4c-d8-506e6c11c04f
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH 5/5] perf trace: Add support for tracing workload given by command line
Date: Fri,  5 Oct 2012 14:02:16 +0900
Message-Id: <1349413336-26936-5-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <1349413336-26936-1-git-send-email-namhyung@kernel.org>
References: <1349413336-26936-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Now perf trace is able to trace specified workload by forking it like
perf record does.  And also finish the tracing if the workload quits
or gets SIGINT.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/builtin-trace.c | 43 ++++++++++++++++++++++++++++++++++++-------
 1 file changed, 36 insertions(+), 7 deletions(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 8daac2eef5af..e9e0eae8eabb 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -53,6 +53,13 @@ struct trace {
 	struct perf_record_opts opts;
 };
 
+static bool done = false;
+
+static void sig_handler(int sig __maybe_unused)
+{
+	done = true;
+}
+
 static int trace__read_syscall_info(struct trace *trace, int id)
 {
 	char tp_name[128];
@@ -190,11 +197,12 @@ static int trace__sys_exit(struct trace *trace, struct perf_evsel *evsel,
 	return 0;
 }
 
-static int trace__run(struct trace *trace)
+static int trace__run(struct trace *trace, int argc, const char **argv)
 {
 	struct perf_evlist *evlist = perf_evlist__new(NULL, NULL);
 	struct perf_evsel *evsel;
 	int err = -1, i, nr_events = 0, before;
+	const bool forks = argc > 0;
 
 	if (evlist == NULL) {
 		printf("Not enough memory to run!\n");
@@ -215,6 +223,17 @@ static int trace__run(struct trace *trace)
 
 	perf_evlist__config_attrs(evlist, &trace->opts);
 
+	signal(SIGCHLD, sig_handler);
+	signal(SIGINT, sig_handler);
+
+	if (forks) {
+		err = perf_evlist__prepare_workload(evlist, &trace->opts, argv);
+		if (err < 0) {
+			printf("Couldn't run the workload!\n");
+			goto out_delete_evlist;
+		}
+	}
+
 	err = perf_evlist__open(evlist);
 	if (err < 0) {
 		printf("Couldn't create the events: %s\n", strerror(errno));
@@ -228,6 +247,10 @@ static int trace__run(struct trace *trace)
 	}
 
 	perf_evlist__enable(evlist);
+
+	if (forks)
+		perf_evlist__start_workload(evlist);
+
 again:
 	before = nr_events;
 
@@ -273,8 +296,15 @@ again:
 		}
 	}
 
-	if (nr_events == before)
+	if (nr_events == before) {
+		if (done)
+			goto out_delete_evlist;
+
 		poll(evlist->pollfd, evlist->nr_fds, -1);
+	}
+
+	if (done)
+		perf_evlist__disable(evlist);
 
 	goto again;
 
@@ -287,7 +317,8 @@ out:
 int cmd_trace(int argc, const char **argv, const char *prefix __maybe_unused)
 {
 	const char * const trace_usage[] = {
-		"perf trace [<options>]",
+		"perf trace [<options>] [<command>]",
+		"perf trace [<options>] -- <command> [<options>]",
 		NULL
 	};
 	struct trace trace = {
@@ -327,8 +358,6 @@ int cmd_trace(int argc, const char **argv, const char *prefix __maybe_unused)
 	char bf[BUFSIZ];
 
 	argc = parse_options(argc, argv, trace_options, trace_usage, 0);
-	if (argc)
-		usage_with_options(trace_usage, trace_options);
 
 	err = perf_target__validate(&trace.opts.target);
 	if (err) {
@@ -344,10 +373,10 @@ int cmd_trace(int argc, const char **argv, const char *prefix __maybe_unused)
 		return err;
 	}
 
-	if (perf_target__none(&trace.opts.target))
+	if (!argc && perf_target__none(&trace.opts.target))
 		trace.opts.target.system_wide = true;
 
 	setup_pager();
 
-	return trace__run(&trace);
+	return trace__run(&trace, argc, argv);
 }
-- 
1.7.11.4

