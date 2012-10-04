Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752698Ab2JDSJ3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 14:09:29 -0400
Received: from casper.infradead.org ([85.118.1.10]:39746 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751948Ab2JDSJ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 14:09:26 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 11/42] perf inject: Remove static variables
Date: Thu,  4 Oct 2012 15:08:11 -0300
Message-Id: <1349374122-27806-12-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1349374122-27806-1-git-send-email-acme@infradead.org>
References: <1349374122-27806-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

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
-- 
1.7.1

