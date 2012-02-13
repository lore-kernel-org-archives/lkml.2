Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756251Ab2BMHM3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 02:12:29 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:49008 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751244Ab2BMHLe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 02:11:34 -0500
X-AuditID: 9c930197-b7cdbae000001518-71-4f38b7a23d25
From: Namhyung Kim <namhyung.kim@lge.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Namhyung Kim <namhyung@gmail.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 05/11] perf tools: Make perf_evlist__create_maps() take struct perf_maps_opts
Date: Mon, 13 Feb 2012 16:27:37 +0900
Message-Id: <1329118064-9412-6-git-send-email-namhyung.kim@lge.com>
X-Mailer: git-send-email 1.7.9
In-Reply-To: <1329118064-9412-1-git-send-email-namhyung.kim@lge.com>
References: <1329118064-9412-1-git-send-email-namhyung.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now we have all information that needed to create cpu/thread maps
in struct perf_maps_opts, it'd be better using it as an argument.

Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
---
 tools/perf/builtin-record.c |    4 +---
 tools/perf/builtin-test.c   |    5 ++---
 tools/perf/builtin-top.c    |    4 +---
 tools/perf/util/evlist.c    |   12 +++++++-----
 tools/perf/util/evlist.h    |    4 ++--
 5 files changed, 13 insertions(+), 16 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 9e209e3279e4..a8abee03a62d 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -789,9 +789,7 @@ int cmd_record(int argc, const char **argv, const char *prefix __used)
 	if (rec->opts.maps.uid_str && rec->opts.maps.uid == UINT_MAX - 1)
 		goto out_free_fd;
 
-	if (perf_evlist__create_maps(evsel_list, rec->opts.maps.target_pid,
-				     rec->opts.maps.target_tid, rec->opts.maps.uid,
-				     rec->opts.maps.cpu_list) < 0)
+	if (perf_evlist__create_maps(evsel_list, &rec->opts.maps) < 0)
 		usage_with_options(record_usage, record_options);
 
 	list_for_each_entry(pos, &evsel_list->entries, node) {
diff --git a/tools/perf/builtin-test.c b/tools/perf/builtin-test.c
index da3c1c3f8524..91a6eba000f2 100644
--- a/tools/perf/builtin-test.c
+++ b/tools/perf/builtin-test.c
@@ -1013,6 +1013,7 @@ static int test__PERF_RECORD(void)
 		.maps = {
 			.target_pid = -1,
 			.target_tid = -1,
+			.uid	    = UINT_MAX,
 		},
 		.no_delay   = true,
 		.freq	    = 10,
@@ -1057,9 +1058,7 @@ static int test__PERF_RECORD(void)
 	 * perf_evlist__prepare_workload we'll fill in the only thread
 	 * we're monitoring, the one forked there.
 	 */
-	err = perf_evlist__create_maps(evlist, opts.maps.target_pid,
-				       opts.maps.target_tid, UINT_MAX,
-				       opts.maps.cpu_list);
+	err = perf_evlist__create_maps(evlist, &opts.maps);
 	if (err < 0) {
 		pr_debug("Not enough memory to create thread/cpu maps\n");
 		goto out_delete_evlist;
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 9e9a8de78899..5bba7ad92fc6 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -1213,9 +1213,7 @@ int cmd_top(int argc, const char **argv, const char *prefix __used)
 	if (top.maps.uid_str != NULL && top.maps.uid == UINT_MAX - 1)
 		goto out_delete_evlist;
 
-	if (perf_evlist__create_maps(top.evlist, top.maps.target_pid,
-				     top.maps.target_tid, top.maps.uid,
-				     top.maps.cpu_list) < 0)
+	if (perf_evlist__create_maps(top.evlist, &top.maps) < 0)
 		usage_with_options(top_usage, options);
 
 	if (!top.evlist->nr_entries &&
diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index d7c3a2d5771c..3d763c95fd62 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -593,18 +593,20 @@ int perf_evlist__mmap(struct perf_evlist *evlist, unsigned int pages,
 	return perf_evlist__mmap_per_cpu(evlist, prot, mask);
 }
 
-int perf_evlist__create_maps(struct perf_evlist *evlist, pid_t target_pid,
-			     pid_t target_tid, uid_t uid, const char *cpu_list)
+int perf_evlist__create_maps(struct perf_evlist *evlist,
+			     struct perf_maps_opts *maps)
 {
-	evlist->threads = thread_map__new(target_pid, target_tid, uid);
+	evlist->threads = thread_map__new(maps->target_pid, maps->target_tid,
+					  maps->uid);
 
 	if (evlist->threads == NULL)
 		return -1;
 
-	if (uid != UINT_MAX || (cpu_list == NULL && target_tid != -1))
+	if (maps->uid != UINT_MAX ||
+	    (maps->cpu_list == NULL && maps->target_tid != -1))
 		evlist->cpus = cpu_map__dummy_new();
 	else
-		evlist->cpus = cpu_map__new(cpu_list);
+		evlist->cpus = cpu_map__new(maps->cpu_list);
 
 	if (evlist->cpus == NULL)
 		goto out_delete_threads;
diff --git a/tools/perf/util/evlist.h b/tools/perf/util/evlist.h
index 1b4282be8fe7..7e99ac513893 100644
--- a/tools/perf/util/evlist.h
+++ b/tools/perf/util/evlist.h
@@ -106,8 +106,8 @@ static inline void perf_evlist__set_maps(struct perf_evlist *evlist,
 	evlist->threads	= threads;
 }
 
-int perf_evlist__create_maps(struct perf_evlist *evlist, pid_t target_pid,
-			     pid_t tid, uid_t uid, const char *cpu_list);
+int perf_evlist__create_maps(struct perf_evlist *evlist,
+			     struct perf_maps_opts *maps);
 void perf_evlist__delete_maps(struct perf_evlist *evlist);
 int perf_evlist__set_filters(struct perf_evlist *evlist);
 
-- 
1.7.9

