Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756648Ab2EBT0R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 15:26:17 -0400
Received: from merlin.infradead.org ([205.233.59.134]:47294 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756388Ab2EBTZP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 15:25:15 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 08/15] perf evlist: Make create_maps() take struct perf_target
Date: Wed,  2 May 2012 16:24:55 -0300
Message-Id: <1335986702-9408-9-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1335986702-9408-1-git-send-email-acme@infradead.org>
References: <1335986702-9408-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Now we have all information that needed to create cpu/thread maps in
struct perf_target, it'd be better using it as an argument.

Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
Reviewed-by: David Ahern <dsahern@gmail.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1335417327-11796-6-git-send-email-namhyung.kim@lge.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-record.c |    4 +---
 tools/perf/builtin-test.c   |    7 ++++---
 tools/perf/builtin-top.c    |    4 +---
 tools/perf/util/evlist.c    |   12 +++++++-----
 tools/perf/util/evlist.h    |    4 ++--
 5 files changed, 15 insertions(+), 16 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 3596cca..d165909 100644
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
index 27882d8..9d9abbb 100644
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
index 4f47952..2a0ec09 100644
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
index 7080901..a43e2c5 100644
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
index 21f1c9e..58abb63 100644
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
1.7.9.2.358.g22243

