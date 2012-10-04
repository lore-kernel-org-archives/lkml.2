Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754385Ab2JDST3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 14:19:29 -0400
Received: from casper.infradead.org ([85.118.1.10]:39779 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752650Ab2JDSJ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 14:09:29 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 18/42] perf timechart: Don't use globals where not needed to
Date: Thu,  4 Oct 2012 15:08:18 -0300
Message-Id: <1349374122-27806-19-git-send-email-acme@infradead.org>
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
Link: http://lkml.kernel.org/n/tip-fapdrw3h3hz713w8h5eww596@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-timechart.c |  100 ++++++++++++++++-----------------------
 1 files changed, 41 insertions(+), 59 deletions(-)

diff --git a/tools/perf/builtin-timechart.c b/tools/perf/builtin-timechart.c
index b1a8a3b..f251b61 100644
--- a/tools/perf/builtin-timechart.c
+++ b/tools/perf/builtin-timechart.c
@@ -38,9 +38,6 @@
 #define PWR_EVENT_EXIT -1
 
 
-static const char	*input_name;
-static const char	*output_name = "output.svg";
-
 static unsigned int	numcpus;
 static u64		min_freq;	/* Lowest CPU frequency seen */
 static u64		max_freq;	/* Highest CPU frequency seen */
@@ -968,16 +965,15 @@ static void write_svg_file(const char *filename)
 	svg_close();
 }
 
-static struct perf_tool perf_timechart = {
-	.comm			= process_comm_event,
-	.fork			= process_fork_event,
-	.exit			= process_exit_event,
-	.sample			= process_sample_event,
-	.ordered_samples	= true,
-};
-
-static int __cmd_timechart(void)
+static int __cmd_timechart(const char *input_name, const char *output_name)
 {
+	struct perf_tool perf_timechart = {
+		.comm		 = process_comm_event,
+		.fork		 = process_fork_event,
+		.exit		 = process_exit_event,
+		.sample		 = process_sample_event,
+		.ordered_samples = true,
+	};
 	struct perf_session *session = perf_session__new(input_name, O_RDONLY,
 							 0, false, &perf_timechart);
 	int ret = -EINVAL;
@@ -1005,40 +1001,25 @@ out_delete:
 	return ret;
 }
 
-static const char * const timechart_usage[] = {
-	"perf timechart [<options>] {record}",
-	NULL
-};
-
-#ifdef SUPPORT_OLD_POWER_EVENTS
-static const char * const record_old_args[] = {
-	"record",
-	"-a",
-	"-R",
-	"-f",
-	"-c", "1",
-	"-e", "power:power_start",
-	"-e", "power:power_end",
-	"-e", "power:power_frequency",
-	"-e", "sched:sched_wakeup",
-	"-e", "sched:sched_switch",
-};
-#endif
-
-static const char * const record_new_args[] = {
-	"record",
-	"-a",
-	"-R",
-	"-f",
-	"-c", "1",
-	"-e", "power:cpu_frequency",
-	"-e", "power:cpu_idle",
-	"-e", "sched:sched_wakeup",
-	"-e", "sched:sched_switch",
-};
-
 static int __cmd_record(int argc, const char **argv)
 {
+#ifdef SUPPORT_OLD_POWER_EVENTS
+	const char * const record_old_args[] = {
+		"record", "-a", "-R", "-f", "-c", "1",
+		"-e", "power:power_start",
+		"-e", "power:power_end",
+		"-e", "power:power_frequency",
+		"-e", "sched:sched_wakeup",
+		"-e", "sched:sched_switch",
+	};
+#endif
+	const char * const record_new_args[] = {
+		"record", "-a", "-R", "-f", "-c", "1",
+		"-e", "power:cpu_frequency",
+		"-e", "power:cpu_idle",
+		"-e", "sched:sched_wakeup",
+		"-e", "sched:sched_switch",
+	};
 	unsigned int rec_argc, i, j;
 	const char **rec_argv;
 	const char * const *record_args = record_new_args;
@@ -1077,27 +1058,28 @@ parse_process(const struct option *opt __maybe_unused, const char *arg,
 	return 0;
 }
 
-static const struct option options[] = {
-	OPT_STRING('i', "input", &input_name, "file",
-		    "input file name"),
-	OPT_STRING('o', "output", &output_name, "file",
-		    "output file name"),
-	OPT_INTEGER('w', "width", &svg_page_width,
-		    "page width"),
-	OPT_BOOLEAN('P', "power-only", &power_only,
-		    "output power data only"),
+int cmd_timechart(int argc, const char **argv,
+		  const char *prefix __maybe_unused)
+{
+	const char *input_name;
+	const char *output_name = "output.svg";
+	const struct option options[] = {
+	OPT_STRING('i', "input", &input_name, "file", "input file name"),
+	OPT_STRING('o', "output", &output_name, "file", "output file name"),
+	OPT_INTEGER('w', "width", &svg_page_width, "page width"),
+	OPT_BOOLEAN('P', "power-only", &power_only, "output power data only"),
 	OPT_CALLBACK('p', "process", NULL, "process",
 		      "process selector. Pass a pid or process name.",
 		       parse_process),
 	OPT_STRING(0, "symfs", &symbol_conf.symfs, "directory",
 		    "Look for files with symbols relative to this directory"),
 	OPT_END()
-};
-
+	};
+	const char * const timechart_usage[] = {
+		"perf timechart [<options>] {record}",
+		NULL
+	};
 
-int cmd_timechart(int argc, const char **argv,
-		  const char *prefix __maybe_unused)
-{
 	argc = parse_options(argc, argv, options, timechart_usage,
 			PARSE_OPT_STOP_AT_NON_OPTION);
 
@@ -1110,5 +1092,5 @@ int cmd_timechart(int argc, const char **argv,
 
 	setup_pager();
 
-	return __cmd_timechart();
+	return __cmd_timechart(input_name, output_name);
 }
-- 
1.7.1

