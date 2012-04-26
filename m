Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753637Ab2DZFRW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 01:17:22 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:44699 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752700Ab2DZFQ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 01:16:26 -0400
X-AuditID: 9c93016f-b7cfcae00000449e-39-4f98da2660ae
From: Namhyung Kim <namhyung.kim@lge.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>, Namhyung Kim <namhyung@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>
Subject: [PATCH 12/13] perf target: Consolidate target task/cpu checking
Date: Thu, 26 Apr 2012 14:15:26 +0900
Message-Id: <1335417327-11796-13-git-send-email-namhyung.kim@lge.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1335417327-11796-1-git-send-email-namhyung.kim@lge.com>
References: <1335417327-11796-1-git-send-email-namhyung.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are places that check whether target task/cpu is given or not
and some of them didn't check newly introduced uid or cpu list. Add
and use three of helper functions to treat them properly.

Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
---
 tools/perf/builtin-record.c |    4 +---
 tools/perf/builtin-stat.c   |   12 ++++++------
 tools/perf/builtin-top.c    |    2 +-
 tools/perf/util/evlist.c    |   10 ++++------
 tools/perf/util/evsel.c     |    8 ++++----
 tools/perf/util/target.h    |   15 +++++++++++++++
 6 files changed, 31 insertions(+), 20 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 8caa84034a51..9c0fa105e063 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -843,9 +843,7 @@ int cmd_record(int argc, const char **argv, const char *prefix __used)
 
 	argc = parse_options(argc, argv, record_options, record_usage,
 			    PARSE_OPT_STOP_AT_NON_OPTION);
-	if (!argc && !rec->opts.target.pid && !rec->opts.target.tid &&
-	    !rec->opts.target.system_wide && !rec->opts.target.cpu_list &&
-	    !rec->opts.target.uid_str)
+	if (!argc && perf_target__none(&rec->opts.target))
 		usage_with_options(record_usage, record_options);
 
 	if (rec->force && rec->append_file) {
diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index bb7723221c0d..d9ff24637eeb 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -290,10 +290,10 @@ static int create_perf_stat_counter(struct perf_evsel *evsel,
 
 	attr->inherit = !no_inherit;
 
-	if (target.system_wide)
+	if (!perf_target__no_cpu(&target))
 		return perf_evsel__open_per_cpu(evsel, evsel_list->cpus,
 						group, group_fd);
-	if (!target.pid && !target.tid && (!group || evsel == first)) {
+	if (perf_target__no_task(&target) && (!group || evsel == first)) {
 		attr->disabled = 1;
 		attr->enable_on_exec = 1;
 	}
@@ -443,7 +443,7 @@ static int run_perf_stat(int argc __used, const char **argv)
 			exit(-1);
 		}
 
-		if (!target.tid && !target.pid && !target.system_wide)
+		if (perf_target__none(&target))
 			evsel_list->threads->map[0] = child_pid;
 
 		/*
@@ -965,7 +965,7 @@ static void print_stat(int argc, const char **argv)
 	if (!csv_output) {
 		fprintf(output, "\n");
 		fprintf(output, " Performance counter stats for ");
-		if (!target.pid && !target.tid) {
+		if (perf_target__no_task(&target)) {
 			fprintf(output, "\'%s", argv[0]);
 			for (i = 1; i < argc; i++)
 				fprintf(output, " %s", argv[i]);
@@ -1187,13 +1187,13 @@ int cmd_stat(int argc, const char **argv, const char *prefix __used)
 	} else if (big_num_opt == 0) /* User passed --no-big-num */
 		big_num = false;
 
-	if (!argc && !target.pid && !target.tid)
+	if (!argc && perf_target__no_task(&target))
 		usage_with_options(stat_usage, options);
 	if (run_count <= 0)
 		usage_with_options(stat_usage, options);
 
 	/* no_aggr, cgroup are for system-wide only */
-	if ((no_aggr || nr_cgroups) && !target.system_wide) {
+	if ((no_aggr || nr_cgroups) && perf_target__no_cpu(&target)) {
 		fprintf(stderr, "both cgroup and no-aggregation "
 			"modes only available in system-wide mode\n");
 
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 6f584179ecc1..948eff6be59a 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -1016,7 +1016,7 @@ static int __cmd_top(struct perf_top *top)
 	if (ret)
 		goto out_delete;
 
-	if (top->target.tid || top->target.uid != UINT_MAX)
+	if (!perf_target__no_task(&top->target))
 		perf_event__synthesize_thread_map(&top->tool, top->evlist->threads,
 						  perf_event__process,
 						  &top->session->host_machine);
diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 183b199b0d09..1201daf71719 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -609,12 +609,10 @@ int perf_evlist__create_maps(struct perf_evlist *evlist,
 	if (evlist->threads == NULL)
 		return -1;
 
-	if (target->uid != UINT_MAX || target->tid)
-		evlist->cpus = cpu_map__dummy_new();
-	else if (!target->system_wide && target->cpu_list == NULL)
-		evlist->cpus = cpu_map__dummy_new();
-	else
+	if (!perf_target__no_cpu(target))
 		evlist->cpus = cpu_map__new(target->cpu_list);
+	else
+		evlist->cpus = cpu_map__dummy_new();
 
 	if (evlist->cpus == NULL)
 		goto out_delete_threads;
@@ -831,7 +829,7 @@ int perf_evlist__prepare_workload(struct perf_evlist *evlist,
 		exit(-1);
 	}
 
-	if (!opts->target.system_wide && !opts->target.tid && !opts->target.pid)
+	if (perf_target__none(&opts->target))
 		evlist->threads->map[0] = evlist->workload.pid;
 
 	close(child_ready_pipe[1]);
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index bb785a098ced..21eaab240396 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -114,8 +114,8 @@ void perf_evsel__config(struct perf_evsel *evsel, struct perf_record_opts *opts,
 		attr->sample_type	|= PERF_SAMPLE_PERIOD;
 
 	if (!opts->sample_id_all_missing &&
-	    (opts->sample_time || opts->target.system_wide ||
-	     !opts->no_inherit || opts->target.cpu_list))
+	    (opts->sample_time || !opts->no_inherit ||
+	     !perf_target__no_cpu(&opts->target)))
 		attr->sample_type	|= PERF_SAMPLE_TIME;
 
 	if (opts->raw_samples) {
@@ -136,8 +136,8 @@ void perf_evsel__config(struct perf_evsel *evsel, struct perf_record_opts *opts,
 	attr->mmap = track;
 	attr->comm = track;
 
-	if (!opts->target.pid && !opts->target.tid &&
-	    !opts->target.system_wide && (!opts->group || evsel == first)) {
+	if (perf_target__none(&opts->target) &&
+	    (!opts->group || evsel == first)) {
 		attr->disabled = 1;
 		attr->enable_on_exec = 1;
 	}
diff --git a/tools/perf/util/target.h b/tools/perf/util/target.h
index fff28c18f401..c9d7ee587fe2 100644
--- a/tools/perf/util/target.h
+++ b/tools/perf/util/target.h
@@ -40,4 +40,19 @@ enum perf_target_errno perf_target__parse_uid(struct perf_target *target);
 int perf_target__strerror(struct perf_target *target, int errnum, char *buf,
 			  size_t buflen);
 
+static inline bool perf_target__no_task(struct perf_target *target)
+{
+	return !target->pid && !target->tid && !target->uid_str;
+}
+
+static inline bool perf_target__no_cpu(struct perf_target *target)
+{
+	return !target->system_wide && !target->cpu_list;
+}
+
+static inline bool perf_target__none(struct perf_target *target)
+{
+	return perf_target__no_task(target) && perf_target__no_cpu(target);
+}
+
 #endif /* _PERF_TARGET_H */
-- 
1.7.10

