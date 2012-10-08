Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932074Ab2JHWdf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 18:33:35 -0400
Received: from casper.infradead.org ([85.118.1.10]:41390 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755336Ab2JHWdb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 18:33:31 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 03/25] perf trace: Add support for tracing workload given by command line
Date: Mon,  8 Oct 2012 19:32:28 -0300
Message-Id: <1349735570-19339-4-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1349735570-19339-1-git-send-email-acme@infradead.org>
References: <1349735570-19339-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Now perf trace is able to trace specified workload by forking it like
perf record does.  And also finish the tracing if the workload quits or
gets SIGINT.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1349413336-26936-5-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-trace.c |   43 ++++++++++++++++++++++++++++++++++++-------
 1 file changed, 36 insertions(+), 7 deletions(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index da1183f..4e9320b 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -52,6 +52,13 @@ struct trace {
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
@@ -189,11 +196,12 @@ static int trace__sys_exit(struct trace *trace, struct perf_evsel *evsel,
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
@@ -214,6 +222,17 @@ static int trace__run(struct trace *trace)
 
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
@@ -227,6 +246,10 @@ static int trace__run(struct trace *trace)
 	}
 
 	perf_evlist__enable(evlist);
+
+	if (forks)
+		perf_evlist__start_workload(evlist);
+
 again:
 	before = nr_events;
 
@@ -272,8 +295,15 @@ again:
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
 
@@ -286,7 +316,8 @@ out:
 int cmd_trace(int argc, const char **argv, const char *prefix __maybe_unused)
 {
 	const char * const trace_usage[] = {
-		"perf trace [<options>]",
+		"perf trace [<options>] [<command>]",
+		"perf trace [<options>] -- <command> [<options>]",
 		NULL
 	};
 	struct trace trace = {
@@ -326,8 +357,6 @@ int cmd_trace(int argc, const char **argv, const char *prefix __maybe_unused)
 	char bf[BUFSIZ];
 
 	argc = parse_options(argc, argv, trace_options, trace_usage, 0);
-	if (argc)
-		usage_with_options(trace_usage, trace_options);
 
 	err = perf_target__validate(&trace.opts.target);
 	if (err) {
@@ -343,8 +372,8 @@ int cmd_trace(int argc, const char **argv, const char *prefix __maybe_unused)
 		return err;
 	}
 
-	if (perf_target__none(&trace.opts.target))
+	if (!argc && perf_target__none(&trace.opts.target))
 		trace.opts.target.system_wide = true;
 
-	return trace__run(&trace);
+	return trace__run(&trace, argc, argv);
 }
-- 
1.7.9.2.358.g22243

