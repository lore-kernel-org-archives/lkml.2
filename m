Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966681Ab2EPJro (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 05:47:44 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:51193 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752879Ab2EPJrm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 05:47:42 -0400
X-AuditID: 9c930179-b7bb9ae000000ea5-49-4fb377bb027f
From: Namhyung Kim <namhyung.kim@lge.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>, Namhyung Kim <namhyung@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/3] perf target: Rename functions to avoid double negation
Date: Wed, 16 May 2012 18:45:47 +0900
Message-Id: <1337161549-9870-1-git-send-email-namhyung.kim@lge.com>
X-Mailer: git-send-email 1.7.10.1
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename perf_target__no_{cpu,task} to perf_target__has_{cpu,task}
because it's more intuitive and easy to parse (for human-being)
when used with negation. The names are came out with David Ahern.
It is intended to be a mechanical substitution without any
functional change.

The perf_target__none remains unchanged since I couldn't find a
right name and it is hardly used with negation.

Suggested-by: Ingo Molnar <mingo@kernel.org>
Suggested-by: David Ahern <dsahern@gmail.com>
Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
---
 tools/perf/builtin-stat.c |   14 +++++++-------
 tools/perf/builtin-top.c  |    2 +-
 tools/perf/util/evlist.c  |    2 +-
 tools/perf/util/evsel.c   |    2 +-
 tools/perf/util/target.h  |   10 +++++-----
 5 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index d0605689bad9..0f4b51ae4be7 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -292,10 +292,10 @@ static int create_perf_stat_counter(struct perf_evsel *evsel,
 
 	attr->inherit = !no_inherit;
 
-	if (!perf_target__no_cpu(&target))
+	if (perf_target__has_cpu(&target))
 		return perf_evsel__open_per_cpu(evsel, evsel_list->cpus,
 						group, group_fd);
-	if (perf_target__no_task(&target) && (!group || evsel == first)) {
+	if (!perf_target__has_task(&target) && (!group || evsel == first)) {
 		attr->disabled = 1;
 		attr->enable_on_exec = 1;
 	}
@@ -972,7 +972,7 @@ static void print_stat(int argc, const char **argv)
 	if (!csv_output) {
 		fprintf(output, "\n");
 		fprintf(output, " Performance counter stats for ");
-		if (perf_target__no_task(&target)) {
+		if (!perf_target__has_task(&target)) {
 			fprintf(output, "\'%s", argv[0]);
 			for (i = 1; i < argc; i++)
 				fprintf(output, " %s", argv[i]);
@@ -1194,13 +1194,13 @@ int cmd_stat(int argc, const char **argv, const char *prefix __used)
 	} else if (big_num_opt == 0) /* User passed --no-big-num */
 		big_num = false;
 
-	if (!argc && perf_target__no_task(&target))
+	if (!argc && !perf_target__has_task(&target))
 		usage_with_options(stat_usage, options);
 	if (run_count <= 0)
 		usage_with_options(stat_usage, options);
 
 	/* no_aggr, cgroup are for system-wide only */
-	if ((no_aggr || nr_cgroups) && perf_target__no_cpu(&target)) {
+	if ((no_aggr || nr_cgroups) && !perf_target__has_cpu(&target)) {
 		fprintf(stderr, "both cgroup and no-aggregation "
 			"modes only available in system-wide mode\n");
 
@@ -1213,9 +1213,9 @@ int cmd_stat(int argc, const char **argv, const char *prefix __used)
 	perf_target__validate(&target);
 
 	if (perf_evlist__create_maps(evsel_list, &target) < 0) {
-		if (!perf_target__no_task(&target))
+		if (perf_target__has_task(&target))
 			pr_err("Problems finding threads of monitor\n");
-		if (!perf_target__no_cpu(&target))
+		if (perf_target__has_cpu(&target))
 			perror("failed to parse CPUs map");
 
 		usage_with_options(stat_usage, options);
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 4eb6171e143b..553560a8b1be 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -1020,7 +1020,7 @@ static int __cmd_top(struct perf_top *top)
 	if (ret)
 		goto out_delete;
 
-	if (!perf_target__no_task(&top->target))
+	if (perf_target__has_task(&top->target))
 		perf_event__synthesize_thread_map(&top->tool, top->evlist->threads,
 						  perf_event__process,
 						  &top->session->host_machine);
diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 1201daf71719..80bef281eee0 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -609,7 +609,7 @@ int perf_evlist__create_maps(struct perf_evlist *evlist,
 	if (evlist->threads == NULL)
 		return -1;
 
-	if (!perf_target__no_cpu(target))
+	if (perf_target__has_cpu(target))
 		evlist->cpus = cpu_map__new(target->cpu_list);
 	else
 		evlist->cpus = cpu_map__dummy_new();
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 21eaab240396..d7a2b4b9801d 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -115,7 +115,7 @@ void perf_evsel__config(struct perf_evsel *evsel, struct perf_record_opts *opts,
 
 	if (!opts->sample_id_all_missing &&
 	    (opts->sample_time || !opts->no_inherit ||
-	     !perf_target__no_cpu(&opts->target)))
+	     perf_target__has_cpu(&opts->target)))
 		attr->sample_type	|= PERF_SAMPLE_TIME;
 
 	if (opts->raw_samples) {
diff --git a/tools/perf/util/target.h b/tools/perf/util/target.h
index 127cff3f8ced..c43f632955fa 100644
--- a/tools/perf/util/target.h
+++ b/tools/perf/util/target.h
@@ -46,19 +46,19 @@ enum perf_target_errno perf_target__parse_uid(struct perf_target *target);
 int perf_target__strerror(struct perf_target *target, int errnum, char *buf,
 			  size_t buflen);
 
-static inline bool perf_target__no_task(struct perf_target *target)
+static inline bool perf_target__has_task(struct perf_target *target)
 {
-	return !target->pid && !target->tid && !target->uid_str;
+	return target->tid || target->pid || target->uid_str;
 }
 
-static inline bool perf_target__no_cpu(struct perf_target *target)
+static inline bool perf_target__has_cpu(struct perf_target *target)
 {
-	return !target->system_wide && !target->cpu_list;
+	return target->system_wide || target->cpu_list;
 }
 
 static inline bool perf_target__none(struct perf_target *target)
 {
-	return perf_target__no_task(target) && perf_target__no_cpu(target);
+	return !perf_target__has_task(target) && !perf_target__has_cpu(target);
 }
 
 #endif /* _PERF_TARGET_H */
-- 
1.7.10.1

