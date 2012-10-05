Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754249Ab2JEIiu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 04:38:50 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60755 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752604Ab2JEIir (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 04:38:47 -0400
Date: Fri, 5 Oct 2012 01:38:28 -0700
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-z2b3matvawihtenmez9hkcja@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf inject: Remove static variables
Git-Commit-ID: 5ded57ac1bdb99b716c1da96eb8b5d387f5eb676
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 05 Oct 2012 01:38:34 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5ded57ac1bdb99b716c1da96eb8b5d387f5eb676
Gitweb:     http://git.kernel.org/tip/5ded57ac1bdb99b716c1da96eb8b5d387f5eb676
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Sun, 30 Sep 2012 19:54:10 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 2 Oct 2012 18:36:27 -0300

perf inject: Remove static variables

We want to reduce the impact that each of the builtins has on perf as a
whole, so use the superclassing of perf_tool mechanizm to move its
config knobs to the stack, so that only if we use that tool, its impact
will be felt.

In this case is more about consistency, as the impact of this tool is
minimal.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-z2b3matvawihtenmez9hkcja@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-inject.c |   72 ++++++++++++++++++++++--------------------
 1 files changed, 38 insertions(+), 34 deletions(-)

diff --git a/tools/perf/builtin-inject.c b/tools/perf/builtin-inject.c
index e249f24..3c9ab55 100644
--- a/tools/perf/builtin-inject.c
+++ b/tools/perf/builtin-inject.c
@@ -14,7 +14,10 @@
 
 #include "util/parse-options.h"
 
-static bool		inject_build_ids;
+struct perf_inject {
+	struct perf_tool tool;
+	bool		 build_ids;
+};
 
 static int perf_event__repipe_synth(struct perf_tool *tool __maybe_unused,
 				    union perf_event *event,
@@ -207,22 +210,6 @@ repipe:
 	return 0;
 }
 
-struct perf_tool perf_inject = {
-	.sample		= perf_event__repipe_sample,
-	.mmap		= perf_event__repipe,
-	.comm		= perf_event__repipe,
-	.fork		= perf_event__repipe,
-	.exit		= perf_event__repipe,
-	.lost		= perf_event__repipe,
-	.read		= perf_event__repipe_sample,
-	.throttle	= perf_event__repipe,
-	.unthrottle	= perf_event__repipe,
-	.attr		= perf_event__repipe_attr,
-	.event_type	= perf_event__repipe_event_type_synth,
-	.tracing_data	= perf_event__repipe_tracing_data_synth,
-	.build_id	= perf_event__repipe_op2_synth,
-};
-
 extern volatile int session_done;
 
 static void sig_handler(int sig __maybe_unused)
@@ -230,25 +217,25 @@ static void sig_handler(int sig __maybe_unused)
 	session_done = 1;
 }
 
-static int __cmd_inject(void)
+static int __cmd_inject(struct perf_inject *inject)
 {
 	struct perf_session *session;
 	int ret = -EINVAL;
 
 	signal(SIGINT, sig_handler);
 
-	if (inject_build_ids) {
-		perf_inject.sample	 = perf_event__inject_buildid;
-		perf_inject.mmap	 = perf_event__repipe_mmap;
-		perf_inject.fork	 = perf_event__repipe_task;
-		perf_inject.tracing_data = perf_event__repipe_tracing_data;
+	if (inject->build_ids) {
+		inject->tool.sample	  = perf_event__inject_buildid;
+		inject->tool.mmap	  = perf_event__repipe_mmap;
+		inject->tool.fork	  = perf_event__repipe_task;
+		inject->tool.tracing_data = perf_event__repipe_tracing_data;
 	}
 
-	session = perf_session__new("-", O_RDONLY, false, true, &perf_inject);
+	session = perf_session__new("-", O_RDONLY, false, true, &inject->tool);
 	if (session == NULL)
 		return -ENOMEM;
 
-	ret = perf_session__process_events(session, &perf_inject);
+	ret = perf_session__process_events(session, &inject->tool);
 
 	perf_session__delete(session);
 
@@ -260,16 +247,33 @@ static const char * const report_usage[] = {
 	NULL
 };
 
-static const struct option options[] = {
-	OPT_BOOLEAN('b', "build-ids", &inject_build_ids,
-		    "Inject build-ids into the output stream"),
-	OPT_INCR('v', "verbose", &verbose,
-		 "be more verbose (show build ids, etc)"),
-	OPT_END()
-};
-
 int cmd_inject(int argc, const char **argv, const char *prefix __maybe_unused)
 {
+	struct perf_inject inject = {
+		.tool = {
+			.sample		= perf_event__repipe_sample,
+			.mmap		= perf_event__repipe,
+			.comm		= perf_event__repipe,
+			.fork		= perf_event__repipe,
+			.exit		= perf_event__repipe,
+			.lost		= perf_event__repipe,
+			.read		= perf_event__repipe_sample,
+			.throttle	= perf_event__repipe,
+			.unthrottle	= perf_event__repipe,
+			.attr		= perf_event__repipe_attr,
+			.event_type	= perf_event__repipe_event_type_synth,
+			.tracing_data	= perf_event__repipe_tracing_data_synth,
+			.build_id	= perf_event__repipe_op2_synth,
+		},
+	};
+	const struct option options[] = {
+		OPT_BOOLEAN('b', "build-ids", &inject.build_ids,
+			    "Inject build-ids into the output stream"),
+		OPT_INCR('v', "verbose", &verbose,
+			 "be more verbose (show build ids, etc)"),
+		OPT_END()
+	};
+
 	argc = parse_options(argc, argv, options, report_usage, 0);
 
 	/*
@@ -281,5 +285,5 @@ int cmd_inject(int argc, const char **argv, const char *prefix __maybe_unused)
 	if (symbol__init() < 0)
 		return -1;
 
-	return __cmd_inject();
+	return __cmd_inject(&inject);
 }
