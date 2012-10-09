Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756409Ab2JIRVk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 13:21:40 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60800 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750754Ab2JIRVe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 13:21:34 -0400
Date: Tue, 9 Oct 2012 10:21:15 -0700
From: tip-bot for Namhyung Kim <namhyung.kim@lge.com>
Message-ID: <tip-f15eb531d351163f1ea697c2dd8f15b66b01d289@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@kernel.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, tglx@linutronix.de, namhyung@kernel.org
In-Reply-To: <1349413336-26936-5-git-send-email-namhyung@kernel.org>
References: <1349413336-26936-5-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf trace:
  Add support for tracing workload given by command line
Git-Commit-ID: f15eb531d351163f1ea697c2dd8f15b66b01d289
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 09 Oct 2012 10:21:21 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f15eb531d351163f1ea697c2dd8f15b66b01d289
Gitweb:     http://git.kernel.org/tip/f15eb531d351163f1ea697c2dd8f15b66b01d289
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Fri, 5 Oct 2012 14:02:16 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 5 Oct 2012 12:51:27 -0300

perf trace: Add support for tracing workload given by command line

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
 1 files changed, 36 insertions(+), 7 deletions(-)

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
