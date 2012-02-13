Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756194Ab2BMHMV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 02:12:21 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:49008 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755118Ab2BMHLf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 02:11:35 -0500
X-AuditID: 9c930197-b7cdbae000001518-83-4f38b7a3ac7f
From: Namhyung Kim <namhyung.kim@lge.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Namhyung Kim <namhyung@gmail.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 08/11] perf tools: Consolidate target task/cpu checking
Date: Mon, 13 Feb 2012 16:27:40 +0900
Message-Id: <1329118064-9412-9-git-send-email-namhyung.kim@lge.com>
X-Mailer: git-send-email 1.7.9
In-Reply-To: <1329118064-9412-1-git-send-email-namhyung.kim@lge.com>
References: <1329118064-9412-1-git-send-email-namhyung.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are places that check whether target task/cpu is given or not
and some of them didn't check newly introduced uid or cpu list. Add
and use three of helper functions to treat them properly.

Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
---
 tools/perf/builtin-record.c |    5 +----
 tools/perf/builtin-stat.c   |   11 +++++------
 tools/perf/util/evlist.c    |    7 +++----
 tools/perf/util/evsel.c     |    3 +--
 tools/perf/util/usage.c     |   16 ++++++++++++++++
 tools/perf/util/util.h      |    3 +++
 6 files changed, 29 insertions(+), 16 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index a8abee03a62d..fbf71edd31ba 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -740,10 +740,7 @@ int cmd_record(int argc, const char **argv, const char *prefix __used)
 
 	argc = parse_options(argc, argv, record_options, record_usage,
 			    PARSE_OPT_STOP_AT_NON_OPTION);
-	if (!argc && rec->opts.maps.target_pid == -1 &&
-	    rec->opts.maps.target_tid == -1 &&
-	    !rec->opts.maps.system_wide && !rec->opts.maps.cpu_list &&
-	    !rec->opts.maps.uid_str)
+	if (!argc && no_target_maps(&rec->opts.maps))
 		usage_with_options(record_usage, record_options);
 
 	if (rec->force && rec->append_file) {
diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index f1f4e8f60a3e..d080254a2d0c 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -296,7 +296,7 @@ static int create_perf_stat_counter(struct perf_evsel *evsel,
 	if (maps.system_wide)
 		return perf_evsel__open_per_cpu(evsel, evsel_list->cpus,
 						group, group_fd);
-	if (maps.target_pid == -1 && maps.target_tid == -1) {
+	if (no_target_task(&maps)) {
 		attr->disabled = 1;
 		attr->enable_on_exec = 1;
 	}
@@ -446,8 +446,7 @@ static int run_perf_stat(int argc __used, const char **argv)
 			exit(-1);
 		}
 
-		if (maps.target_tid == -1 && maps.target_pid == -1 &&
-		    !maps.system_wide)
+		if (no_target_maps(&maps))
 			evsel_list->threads->map[0] = child_pid;
 
 		/*
@@ -969,7 +968,7 @@ static void print_stat(int argc, const char **argv)
 	if (!csv_output) {
 		fprintf(output, "\n");
 		fprintf(output, " Performance counter stats for ");
-		if(maps.target_pid == -1 && maps.target_tid == -1) {
+		if (no_target_task(&maps)) {
 			fprintf(output, "\'%s", argv[0]);
 			for (i = 1; i < argc; i++)
 				fprintf(output, " %s", argv[i]);
@@ -1191,13 +1190,13 @@ int cmd_stat(int argc, const char **argv, const char *prefix __used)
 	} else if (big_num_opt == 0) /* User passed --no-big-num */
 		big_num = false;
 
-	if (!argc && maps.target_pid == -1 && maps.target_tid == -1)
+	if (!argc && no_target_task(&maps))
 		usage_with_options(stat_usage, options);
 	if (run_count <= 0)
 		usage_with_options(stat_usage, options);
 
 	/* no_aggr, cgroup are for system-wide only */
-	if ((no_aggr || nr_cgroups) && !maps.system_wide) {
+	if ((no_aggr || nr_cgroups) && !no_target_cpu(&maps)) {
 		fprintf(stderr, "both cgroup and no-aggregation "
 			"modes only available in system-wide mode\n");
 
diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index b444f311897c..aa0418034d82 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -602,9 +602,9 @@ int perf_evlist__create_maps(struct perf_evlist *evlist,
 	if (evlist->threads == NULL)
 		return -1;
 
-	if (maps->uid != UINT_MAX || maps->target_tid != -1)
+	if (!no_target_task(maps))
 		evlist->cpus = cpu_map__dummy_new();
-	else if (!maps->system_wide && maps->cpu_list == NULL)
+	else if (no_target_cpu(maps))
 		evlist->cpus = cpu_map__dummy_new();
 	else
 		evlist->cpus = cpu_map__new(maps->cpu_list);
@@ -823,8 +823,7 @@ int perf_evlist__prepare_workload(struct perf_evlist *evlist,
 		exit(-1);
 	}
 
-	if (!opts->maps.system_wide && opts->maps.target_tid == -1 &&
-	    opts->maps.target_pid == -1)
+	if (no_target_maps(&opts->maps))
 		evlist->threads->map[0] = evlist->workload.pid;
 
 	close(child_ready_pipe[1]);
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 6a4e97d5f6d5..e7ddf27f240b 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -130,8 +130,7 @@ void perf_evsel__config(struct perf_evsel *evsel, struct perf_record_opts *opts)
 	attr->mmap = track;
 	attr->comm = track;
 
-	if (opts->maps.target_pid == -1 && opts->maps.target_tid == -1 &&
-	    !opts->maps.system_wide) {
+	if (no_target_maps(&opts->maps)) {
 		attr->disabled = 1;
 		attr->enable_on_exec = 1;
 	}
diff --git a/tools/perf/util/usage.c b/tools/perf/util/usage.c
index 08423c037a7e..d7e77fde966d 100644
--- a/tools/perf/util/usage.c
+++ b/tools/perf/util/usage.c
@@ -147,3 +147,19 @@ void check_target_maps(struct perf_maps_opts *maps)
 		maps->system_wide = false;
 	}
 }
+
+bool no_target_task(struct perf_maps_opts *maps)
+{
+	return maps->target_pid == -1 && maps->target_tid == -1 &&
+		maps->uid_str == NULL;
+}
+
+bool no_target_cpu(struct perf_maps_opts *maps)
+{
+	return !maps->system_wide && maps->cpu_list == NULL;
+}
+
+bool no_target_maps(struct perf_maps_opts *maps)
+{
+	return no_target_task(maps) && no_target_cpu(maps);
+}
diff --git a/tools/perf/util/util.h b/tools/perf/util/util.h
index 2573985f8408..e1343eea14eb 100644
--- a/tools/perf/util/util.h
+++ b/tools/perf/util/util.h
@@ -248,6 +248,9 @@ void event_attr_init(struct perf_event_attr *attr);
 
 uid_t parse_target_uid(const char *str);
 void check_target_maps(struct perf_maps_opts *maps);
+bool no_target_task(struct perf_maps_opts *maps);
+bool no_target_cpu(struct perf_maps_opts *maps);
+bool no_target_maps(struct perf_maps_opts *maps);
 
 #define _STR(x) #x
 #define STR(x) _STR(x)
-- 
1.7.9

