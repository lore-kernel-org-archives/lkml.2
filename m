Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757760Ab2ETCRz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2012 22:17:55 -0400
Received: from merlin.infradead.org ([205.233.59.134]:37797 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756654Ab2ETCQx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2012 22:16:53 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Ingo Molnar <mingo@redhat.com>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 1/6] perf target: Rename functions to avoid double negation
Date: Sat, 19 May 2012 23:16:31 -0300
Message-Id: <1337480196-761-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1337480196-761-1-git-send-email-acme@infradead.org>
References: <1337480196-761-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Rename perf_target__no_{cpu,task} to perf_target__has_{cpu,task} because
it's more intuitive and easy to parse (for human beings) when used with
negation.

The names are came out from David Ahern.  It is intended to be a
mechanical substitution without any functional change.

The perf_target__none remains unchanged since I couldn't find a right
name and it is hardly used with negation.

Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
Suggested-by: David Ahern <dsahern@gmail.com>
Suggested-by: Ingo Molnar <mingo@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1337161549-9870-1-git-send-email-namhyung.kim@lge.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-stat.c |   14 +++++++-------
 tools/perf/builtin-top.c  |    2 +-
 tools/perf/util/evlist.c  |    2 +-
 tools/perf/util/evsel.c   |    2 +-
 tools/perf/util/target.h  |   10 +++++-----
 5 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index d060568..0f4b51a 100644
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
index 4eb6171..553560a 100644
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
index 1201daf..80bef28 100644
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
index 21eaab2..d7a2b4b 100644
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
index 127cff3..c43f632 100644
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
1.7.9.2.358.g22243

