Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754444Ab2JEIph (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 04:45:37 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60901 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752294Ab2JEIpd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 04:45:33 -0400
Date: Fri, 5 Oct 2012 01:45:07 -0700
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-fapdrw3h3hz713w8h5eww596@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf timechart: Don'
 t use globals where not needed to
Git-Commit-ID: 73bdc7159b0a83146fa8d1b8df7baf1cea992d4c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 05 Oct 2012 01:45:13 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  73bdc7159b0a83146fa8d1b8df7baf1cea992d4c
Gitweb:     http://git.kernel.org/tip/73bdc7159b0a83146fa8d1b8df7baf1cea992d4c
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Mon, 1 Oct 2012 15:20:58 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 2 Oct 2012 18:36:34 -0300

perf timechart: Don't use globals where not needed to

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
