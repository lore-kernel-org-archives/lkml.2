Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752775Ab2DZFQ0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 01:16:26 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:50162 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752402Ab2DZFQX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 01:16:23 -0400
X-AuditID: 9c93016f-b7cfcae00000449e-23-4f98da239fb5
From: Namhyung Kim <namhyung.kim@lge.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>, Namhyung Kim <namhyung@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>
Subject: [PATCH 05/13] perf tools: Make perf_evlist__create_maps() take struct perf_target
Date: Thu, 26 Apr 2012 14:15:19 +0900
Message-Id: <1335417327-11796-6-git-send-email-namhyung.kim@lge.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1335417327-11796-1-git-send-email-namhyung.kim@lge.com>
References: <1335417327-11796-1-git-send-email-namhyung.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now we have all information that needed to create cpu/thread maps
in struct perf_target, it'd be better using it as an argument.

Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
---
 tools/perf/builtin-record.c |    4 +---
 tools/perf/builtin-test.c   |    7 ++++---
 tools/perf/builtin-top.c    |    4 +---
 tools/perf/util/evlist.c    |   12 +++++++-----
 tools/perf/util/evlist.h    |    4 ++--
 5 files changed, 15 insertions(+), 16 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 3596ccab6d3b..d16590942cec 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -891,9 +891,7 @@ int cmd_record(int argc, const char **argv, const char *prefix __used)
 	    rec->opts.target.uid == UINT_MAX - 1)
 		goto out_free_fd;
 
-	if (perf_evlist__create_maps(evsel_list, rec->opts.target.pid,
-				     rec->opts.target.tid, rec->opts.target.uid,
-				     rec->opts.target.cpu_list) < 0)
+	if (perf_evlist__create_maps(evsel_list, &rec->opts.target) < 0)
 		usage_with_options(record_usage, record_options);
 
 	list_for_each_entry(pos, &evsel_list->entries, node) {
diff --git a/tools/perf/builtin-test.c b/tools/perf/builtin-test.c
index e9b256920da0..a281284ee2f5 100644
--- a/tools/perf/builtin-test.c
+++ b/tools/perf/builtin-test.c
@@ -1165,6 +1165,9 @@ realloc:
 static int test__PERF_RECORD(void)
 {
 	struct perf_record_opts opts = {
+		.target = {
+			.uid = UINT_MAX,
+		},
 		.no_delay   = true,
 		.freq	    = 10,
 		.mmap_pages = 256,
@@ -1207,9 +1210,7 @@ static int test__PERF_RECORD(void)
 	 * perf_evlist__prepare_workload we'll fill in the only thread
 	 * we're monitoring, the one forked there.
 	 */
-	err = perf_evlist__create_maps(evlist, opts.target.pid,
-				       opts.target.tid, UINT_MAX,
-				       opts.target.cpu_list);
+	err = perf_evlist__create_maps(evlist, &opts.target);
 	if (err < 0) {
 		pr_debug("Not enough memory to create thread/cpu maps\n");
 		goto out_delete_evlist;
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 4f47952eddbd..2a0ec09b9b77 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -1258,9 +1258,7 @@ int cmd_top(int argc, const char **argv, const char *prefix __used)
 	if (top.target.uid_str != NULL && top.target.uid == UINT_MAX - 1)
 		goto out_delete_evlist;
 
-	if (perf_evlist__create_maps(top.evlist, top.target.pid,
-				     top.target.tid, top.target.uid,
-				     top.target.cpu_list) < 0)
+	if (perf_evlist__create_maps(top.evlist, &top.target) < 0)
 		usage_with_options(top_usage, options);
 
 	if (!top.evlist->nr_entries &&
diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 7080901a2717..a43e2c56d1c6 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -599,18 +599,20 @@ int perf_evlist__mmap(struct perf_evlist *evlist, unsigned int pages,
 	return perf_evlist__mmap_per_cpu(evlist, prot, mask);
 }
 
-int perf_evlist__create_maps(struct perf_evlist *evlist, const char *target_pid,
-			     const char *target_tid, uid_t uid, const char *cpu_list)
+int perf_evlist__create_maps(struct perf_evlist *evlist,
+			     struct perf_target *target)
 {
-	evlist->threads = thread_map__new_str(target_pid, target_tid, uid);
+	evlist->threads = thread_map__new_str(target->pid, target->tid,
+					      target->uid);
 
 	if (evlist->threads == NULL)
 		return -1;
 
-	if (uid != UINT_MAX || (cpu_list == NULL && target_tid))
+	if (target->uid != UINT_MAX ||
+	    (target->cpu_list == NULL && target->tid))
 		evlist->cpus = cpu_map__dummy_new();
 	else
-		evlist->cpus = cpu_map__new(cpu_list);
+		evlist->cpus = cpu_map__new(target->cpu_list);
 
 	if (evlist->cpus == NULL)
 		goto out_delete_threads;
diff --git a/tools/perf/util/evlist.h b/tools/perf/util/evlist.h
index 21f1c9e57f13..58abb63ac13a 100644
--- a/tools/perf/util/evlist.h
+++ b/tools/perf/util/evlist.h
@@ -106,8 +106,8 @@ static inline void perf_evlist__set_maps(struct perf_evlist *evlist,
 	evlist->threads	= threads;
 }
 
-int perf_evlist__create_maps(struct perf_evlist *evlist, const char *target_pid,
-			     const char *tid, uid_t uid, const char *cpu_list);
+int perf_evlist__create_maps(struct perf_evlist *evlist,
+			     struct perf_target *target);
 void perf_evlist__delete_maps(struct perf_evlist *evlist);
 int perf_evlist__set_filters(struct perf_evlist *evlist);
 
-- 
1.7.10

