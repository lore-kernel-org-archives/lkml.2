Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754237Ab2EUHhz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 03:37:55 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37659 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751823Ab2EUHhw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 03:37:52 -0400
Date: Mon, 21 May 2012 00:37:28 -0700
From: tip-bot for Namhyung Kim <namhyung.kim@lge.com>
Message-ID: <tip-aa22dd4990e38700b1855555aa0def5215859abb@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        mingo@redhat.com, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, namhyung.kim@lge.com, namhyung@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, mingo@redhat.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de
In-Reply-To: <1337161549-9870-1-git-send-email-namhyung.kim@lge.com>
References: <1337161549-9870-1-git-send-email-namhyung.kim@lge.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf target:
  Rename functions to avoid double negation
Git-Commit-ID: aa22dd4990e38700b1855555aa0def5215859abb
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 21 May 2012 00:37:35 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  aa22dd4990e38700b1855555aa0def5215859abb
Gitweb:     http://git.kernel.org/tip/aa22dd4990e38700b1855555aa0def5215859abb
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Wed, 16 May 2012 18:45:47 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 16 May 2012 12:09:34 -0300

perf target: Rename functions to avoid double negation

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
