Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753856Ab2DZFSc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 01:18:32 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:44699 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752215Ab2DZFQW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 01:16:22 -0400
X-AuditID: 9c93016f-b7cfcae00000449e-1c-4f98da22e720
From: Namhyung Kim <namhyung.kim@lge.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>, Namhyung Kim <namhyung@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>
Subject: [PATCH 02/13] perf stat: Convert to struct perf_target
Date: Thu, 26 Apr 2012 14:15:16 +0900
Message-Id: <1335417327-11796-3-git-send-email-namhyung.kim@lge.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1335417327-11796-1-git-send-email-namhyung.kim@lge.com>
References: <1335417327-11796-1-git-send-email-namhyung.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use struct perf_target as it is introduced by previous patch.
This is a preparation of further changes.

Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
---
 tools/perf/builtin-stat.c |   47 +++++++++++++++++++++------------------------
 1 file changed, 22 insertions(+), 25 deletions(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index dde9e17c018b..1ca767d906ef 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -175,22 +175,19 @@ static struct perf_event_attr very_very_detailed_attrs[] = {
 
 static struct perf_evlist	*evsel_list;
 
-static bool			system_wide			=  false;
-static int			run_idx				=  0;
+static struct perf_target	target;
 
+static int			run_idx				=  0;
 static int			run_count			=  1;
 static bool			no_inherit			= false;
 static bool			scale				=  true;
 static bool			no_aggr				= false;
-static const char		*target_pid;
-static const char		*target_tid;
 static pid_t			child_pid			= -1;
 static bool			null_run			=  false;
 static int			detailed_run			=  0;
 static bool			sync_run			=  false;
 static bool			big_num				=  true;
 static int			big_num_opt			=  -1;
-static const char		*cpu_list;
 static const char		*csv_sep			= NULL;
 static bool			csv_output			= false;
 static bool			group				= false;
@@ -293,10 +290,10 @@ static int create_perf_stat_counter(struct perf_evsel *evsel,
 
 	attr->inherit = !no_inherit;
 
-	if (system_wide)
+	if (target.system_wide)
 		return perf_evsel__open_per_cpu(evsel, evsel_list->cpus,
 						group, group_fd);
-	if (!target_pid && !target_tid && (!group || evsel == first)) {
+	if (!target.pid && !target.tid && (!group || evsel == first)) {
 		attr->disabled = 1;
 		attr->enable_on_exec = 1;
 	}
@@ -446,7 +443,7 @@ static int run_perf_stat(int argc __used, const char **argv)
 			exit(-1);
 		}
 
-		if (!target_tid && !target_pid && !system_wide)
+		if (!target.tid && !target.pid && !target.system_wide)
 			evsel_list->threads->map[0] = child_pid;
 
 		/*
@@ -476,7 +473,7 @@ static int run_perf_stat(int argc __used, const char **argv)
 				error("You may not have permission to collect %sstats.\n"
 				      "\t Consider tweaking"
 				      " /proc/sys/kernel/perf_event_paranoid or running as root.",
-				      system_wide ? "system-wide " : "");
+				      target.system_wide ? "system-wide " : "");
 			} else {
 				error("open_counter returned with %d (%s). "
 				      "/bin/dmesg may provide additional information.\n",
@@ -968,14 +965,14 @@ static void print_stat(int argc, const char **argv)
 	if (!csv_output) {
 		fprintf(output, "\n");
 		fprintf(output, " Performance counter stats for ");
-		if (!target_pid && !target_tid) {
+		if (!target.pid && !target.tid) {
 			fprintf(output, "\'%s", argv[0]);
 			for (i = 1; i < argc; i++)
 				fprintf(output, " %s", argv[i]);
-		} else if (target_pid)
-			fprintf(output, "process id \'%s", target_pid);
+		} else if (target.pid)
+			fprintf(output, "process id \'%s", target.pid);
 		else
-			fprintf(output, "thread id \'%s", target_tid);
+			fprintf(output, "thread id \'%s", target.tid);
 
 		fprintf(output, "\'");
 		if (run_count > 1)
@@ -1049,11 +1046,11 @@ static const struct option options[] = {
 		     "event filter", parse_filter),
 	OPT_BOOLEAN('i', "no-inherit", &no_inherit,
 		    "child tasks do not inherit counters"),
-	OPT_STRING('p', "pid", &target_pid, "pid",
+	OPT_STRING('p', "pid", &target.pid, "pid",
 		   "stat events on existing process id"),
-	OPT_STRING('t', "tid", &target_tid, "tid",
+	OPT_STRING('t', "tid", &target.tid, "tid",
 		   "stat events on existing thread id"),
-	OPT_BOOLEAN('a', "all-cpus", &system_wide,
+	OPT_BOOLEAN('a', "all-cpus", &target.system_wide,
 		    "system-wide collection from all CPUs"),
 	OPT_BOOLEAN('g', "group", &group,
 		    "put the counters into a counter group"),
@@ -1072,7 +1069,7 @@ static const struct option options[] = {
 	OPT_CALLBACK_NOOPT('B', "big-num", NULL, NULL, 
 			   "print large numbers with thousands\' separators",
 			   stat__set_big_num),
-	OPT_STRING('C', "cpu", &cpu_list, "cpu",
+	OPT_STRING('C', "cpu", &target.cpu_list, "cpu",
 		    "list of cpus to monitor in system-wide"),
 	OPT_BOOLEAN('A', "no-aggr", &no_aggr,
 		    "disable CPU count aggregation"),
@@ -1190,13 +1187,13 @@ int cmd_stat(int argc, const char **argv, const char *prefix __used)
 	} else if (big_num_opt == 0) /* User passed --no-big-num */
 		big_num = false;
 
-	if (!argc && !target_pid && !target_tid)
+	if (!argc && !target.pid && !target.tid)
 		usage_with_options(stat_usage, options);
 	if (run_count <= 0)
 		usage_with_options(stat_usage, options);
 
 	/* no_aggr, cgroup are for system-wide only */
-	if ((no_aggr || nr_cgroups) && !system_wide) {
+	if ((no_aggr || nr_cgroups) && !target.system_wide) {
 		fprintf(stderr, "both cgroup and no-aggregation "
 			"modes only available in system-wide mode\n");
 
@@ -1206,18 +1203,18 @@ int cmd_stat(int argc, const char **argv, const char *prefix __used)
 	if (add_default_attributes())
 		goto out;
 
-	if (target_pid)
-		target_tid = target_pid;
+	if (target.pid)
+		target.tid = target.pid;
 
-	evsel_list->threads = thread_map__new_str(target_pid,
-						  target_tid, UINT_MAX);
+	evsel_list->threads = thread_map__new_str(target.pid,
+						  target.tid, UINT_MAX);
 	if (evsel_list->threads == NULL) {
 		pr_err("Problems finding threads of monitor\n");
 		usage_with_options(stat_usage, options);
 	}
 
-	if (system_wide)
-		evsel_list->cpus = cpu_map__new(cpu_list);
+	if (target.system_wide)
+		evsel_list->cpus = cpu_map__new(target.cpu_list);
 	else
 		evsel_list->cpus = cpu_map__dummy_new();
 
-- 
1.7.10

