Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752482Ab2JDSXc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 14:23:32 -0400
Received: from casper.infradead.org ([85.118.1.10]:39675 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751650Ab2JDSI7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 14:08:59 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 17/42] perf lock: Don't use globals where not needed to
Date: Thu,  4 Oct 2012 15:08:17 -0300
Message-Id: <1349374122-27806-18-git-send-email-acme@infradead.org>
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
Link: http://lkml.kernel.org/n/tip-fx8sqc6r9u0i1u97ruy5ytjv@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-lock.c |   90 +++++++++++++++++++-------------------------
 1 files changed, 39 insertions(+), 51 deletions(-)

diff --git a/tools/perf/builtin-lock.c b/tools/perf/builtin-lock.c
index 7d6e099..6f5f328 100644
--- a/tools/perf/builtin-lock.c
+++ b/tools/perf/builtin-lock.c
@@ -823,12 +823,6 @@ static int process_sample_event(struct perf_tool *tool __maybe_unused,
 	return 0;
 }
 
-static struct perf_tool eops = {
-	.sample			= process_sample_event,
-	.comm			= perf_event__process_comm,
-	.ordered_samples	= true,
-};
-
 static const struct perf_evsel_str_handler lock_tracepoints[] = {
 	{ "lock:lock_acquire",	 perf_evsel__process_lock_acquire,   }, /* CONFIG_LOCKDEP */
 	{ "lock:lock_acquired",	 perf_evsel__process_lock_acquired,  }, /* CONFIG_LOCKDEP, CONFIG_LOCK_STAT */
@@ -838,6 +832,11 @@ static const struct perf_evsel_str_handler lock_tracepoints[] = {
 
 static int read_events(void)
 {
+	struct perf_tool eops = {
+		.sample		 = process_sample_event,
+		.comm		 = perf_event__process_comm,
+		.ordered_samples = true,
+	};
 	session = perf_session__new(input_name, O_RDONLY, 0, false, &eops);
 	if (!session) {
 		pr_err("Initializing perf session failed\n");
@@ -878,53 +877,11 @@ static int __cmd_report(void)
 	return 0;
 }
 
-static const char * const report_usage[] = {
-	"perf lock report [<options>]",
-	NULL
-};
-
-static const struct option report_options[] = {
-	OPT_STRING('k', "key", &sort_key, "acquired",
-		    "key for sorting (acquired / contended / wait_total / wait_max / wait_min)"),
-	/* TODO: type */
-	OPT_END()
-};
-
-static const char * const info_usage[] = {
-	"perf lock info [<options>]",
-	NULL
-};
-
-static const struct option info_options[] = {
-	OPT_BOOLEAN('t', "threads", &info_threads,
-		    "dump thread list in perf.data"),
-	OPT_BOOLEAN('m', "map", &info_map,
-		    "map of lock instances (address:name table)"),
-	OPT_END()
-};
-
-static const char * const lock_usage[] = {
-	"perf lock [<options>] {record|report|script|info}",
-	NULL
-};
-
-static const struct option lock_options[] = {
-	OPT_STRING('i', "input", &input_name, "file", "input file name"),
-	OPT_INCR('v', "verbose", &verbose, "be more verbose (show symbol address, etc)"),
-	OPT_BOOLEAN('D', "dump-raw-trace", &dump_trace, "dump raw trace in ASCII"),
-	OPT_END()
-};
-
-static const char *record_args[] = {
-	"record",
-	"-R",
-	"-f",
-	"-m", "1024",
-	"-c", "1",
-};
-
 static int __cmd_record(int argc, const char **argv)
 {
+	const char *record_args[] = {
+		"record", "-R", "-f", "-m", "1024", "-c", "1",
+	};
 	unsigned int rec_argc, i, j;
 	const char **rec_argv;
 
@@ -963,6 +920,37 @@ static int __cmd_record(int argc, const char **argv)
 
 int cmd_lock(int argc, const char **argv, const char *prefix __maybe_unused)
 {
+	const struct option info_options[] = {
+	OPT_BOOLEAN('t', "threads", &info_threads,
+		    "dump thread list in perf.data"),
+	OPT_BOOLEAN('m', "map", &info_map,
+		    "map of lock instances (address:name table)"),
+	OPT_END()
+	};
+	const struct option lock_options[] = {
+	OPT_STRING('i', "input", &input_name, "file", "input file name"),
+	OPT_INCR('v', "verbose", &verbose, "be more verbose (show symbol address, etc)"),
+	OPT_BOOLEAN('D', "dump-raw-trace", &dump_trace, "dump raw trace in ASCII"),
+	OPT_END()
+	};
+	const struct option report_options[] = {
+	OPT_STRING('k', "key", &sort_key, "acquired",
+		    "key for sorting (acquired / contended / wait_total / wait_max / wait_min)"),
+	/* TODO: type */
+	OPT_END()
+	};
+	const char * const info_usage[] = {
+		"perf lock info [<options>]",
+		NULL
+	};
+	const char * const lock_usage[] = {
+		"perf lock [<options>] {record|report|script|info}",
+		NULL
+	};
+	const char * const report_usage[] = {
+		"perf lock report [<options>]",
+		NULL
+	};
 	unsigned int i;
 	int rc = 0;
 
-- 
1.7.1

