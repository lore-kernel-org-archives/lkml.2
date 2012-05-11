Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760347Ab2EKGnf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 02:43:35 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57311 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757458Ab2EKGna (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 02:43:30 -0400
Date: Thu, 10 May 2012 23:42:57 -0700
From: tip-bot for Namhyung Kim <namhyung.kim@lge.com>
Message-ID: <tip-d67356e7f80f5c2ef487bedc11a91d5fe18c5a15@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        mingo@redhat.com, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, namhyung.kim@lge.com, namhyung@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, mingo@redhat.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de
In-Reply-To: <1336367344-28071-7-git-send-email-namhyung.kim@lge.com>
References: <1336367344-28071-7-git-send-email-namhyung.kim@lge.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf target: Consolidate target task/cpu checking
Git-Commit-ID: d67356e7f80f5c2ef487bedc11a91d5fe18c5a15
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 10 May 2012 23:43:04 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d67356e7f80f5c2ef487bedc11a91d5fe18c5a15
Gitweb:     http://git.kernel.org/tip/d67356e7f80f5c2ef487bedc11a91d5fe18c5a15
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Mon, 7 May 2012 14:09:03 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 7 May 2012 17:52:05 -0300

perf target: Consolidate target task/cpu checking

There are places that check whether target task/cpu is given or not and
some of them didn't check newly introduced uid or cpu list. Add and use
three of helper functions to treat them properly.

Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
Reviewed-by: David Ahern <dsahern@gmail.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1336367344-28071-7-git-send-email-namhyung.kim@lge.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-record.c |    4 +---
 tools/perf/builtin-stat.c   |   12 ++++++------
 tools/perf/builtin-top.c    |    2 +-
 tools/perf/util/evlist.c    |   10 ++++------
 tools/perf/util/evsel.c     |    8 ++++----
 tools/perf/util/target.h    |   15 +++++++++++++++
 6 files changed, 31 insertions(+), 20 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index c8bf6ea..42e2414 100644
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
index bb77232..d9ff246 100644
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
index 7ba0f03..e4ca827 100644
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
index 183b199..1201daf 100644
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
index bb785a0..21eaab2 100644
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
index 6fcd01c..127cff3 100644
--- a/tools/perf/util/target.h
+++ b/tools/perf/util/target.h
@@ -46,4 +46,19 @@ enum perf_target_errno perf_target__parse_uid(struct perf_target *target);
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
