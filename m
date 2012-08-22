Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932564Ab2HVOhX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 10:37:23 -0400
Received: from mail-pb0-f66.google.com ([209.85.160.66]:42350 "EHLO
	mail-pb0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756491Ab2HVOhU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 10:37:20 -0400
Message-ID: <5034EE98.3070406@gmail.com>
Date: Wed, 22 Aug 2012 22:37:12 +0800
From: chenggang qin <chenggang.qin@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, mingo@redhat.com, acme@ghostprotocols.net,
        namhyung.kim@lge.com, a.p.zijlstra@chello.nl, paulus@samba.org,
        dsahern@gmail.com, nelhage@nelhage.com
Subject: [PATCH]Perf top:  Add ability to detect new threads dynamically during
 'perf top -p 'pid'' is running
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chenggang Qin <chenggang.qin@gmail.com>

While we use "perf top -p 'pid'" to monitor the symbols of specified
processes, some new threads would be created by the monitored processes 
during "perf top" is running. In current version, these new threads and
their symbols cannot be shown.
This patch add ability to show these new threads.

Signed-off-by: Chenggang Qin <chenggang.qcg@taobao.com>

---
 tools/perf/builtin-top.c |   86 ++++++++++++++++++++++++++++++++++++++++++++--
 tools/perf/util/evlist.c |    2 ++
 2 files changed, 85 insertions(+), 3 deletions(-)

diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 68cd61e..54c9cc1 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -882,7 +882,7 @@ static void perf_top__mmap_read(struct perf_top *top)
 		perf_top__mmap_read_idx(top, i);
 }
 
-static void perf_top__start_counters(struct perf_top *top)
+static int perf_top__start_counters(struct perf_top *top)
 {
 	struct perf_evsel *counter, *first;
 	struct perf_evlist *evlist = top->evlist;
@@ -929,6 +929,10 @@ try_again:
 				     group_fd) < 0) {
 			int err = errno;
 
+			if (err == ESRCH) {
+				return err;
+			}
+
 			if (err == EPERM || err == EACCES) {
 				ui__error_paranoid();
 				goto out_err;
@@ -994,7 +998,7 @@ try_again:
 		goto out_err;
 	}
 
-	return;
+	return 0;
 
 out_err:
 	exit_browser(0);
@@ -1018,6 +1022,77 @@ static int perf_top__setup_sample_type(struct perf_top *top)
 	return 0;
 }
 
+static int thread_map_cmp(struct thread_map *threads_a,
+			  struct thread_map *threads_b)
+{
+	int i, j;
+
+	if (threads_a->nr != threads_b->nr) {
+		return 1;
+	} else {
+		for (i = 0; i < threads_b->nr; i++) {
+			for (j = 0; j < threads_a->nr; j++)
+				if (threads_b->map[i] == threads_a->map[j])
+					break;
+
+			if (j == threads_a->nr)
+				return 1;
+		}
+
+		return 0;
+	}
+}
+
+static void check_new_threads(struct perf_top *top)
+{
+	struct thread_map *new_thread_map;
+	struct perf_evsel *counter;
+	struct perf_evlist *evlist = top->evlist;
+
+retry:
+	new_thread_map = thread_map__new_str(top->target.pid, top->target.tid,
+					     top->target.uid);
+	if (!new_thread_map)
+		return;
+
+	if (thread_map_cmp(top->evlist->threads, new_thread_map) == 0) {
+		free(new_thread_map);
+		return;
+	} else {
+		list_for_each_entry(counter, &evlist->entries, node) {
+			perf_evsel__close(counter, top->evlist->cpus->nr,
+					  top->evlist->threads->nr);
+		}
+
+		if (top->evlist->mmap)
+			perf_evlist__munmap(top->evlist);
+
+		if (top->evlist->pollfd) {
+			free(top->evlist->pollfd);
+			top->evlist->pollfd = NULL;
+		}
+
+		top->evlist->nr_fds = 0;
+
+		thread_map__delete(top->evlist->threads);
+		top->evlist->threads = new_thread_map;
+
+		if (perf_top__start_counters(top) == ESRCH) {
+			while (thread_map_cmp(top->evlist->threads,
+					      new_thread_map) == 0) {
+				new_thread_map = thread_map__new_str(top->target.pid,
+								     top->target.tid,
+								     top->target.uid);
+				if (!new_thread_map)
+					return;
+			}
+			goto retry;
+		}
+
+		return;
+	}
+}
+
 static int __cmd_top(struct perf_top *top)
 {
 	pthread_t thread;
@@ -1067,7 +1142,12 @@ static int __cmd_top(struct perf_top *top)
 	}
 
 	while (1) {
-		u64 hits = top->samples;
+		u64 hits;
+
+		if (perf_target__has_task(&top->target))
+			check_new_threads(top);
+
+		hits = top->samples;
 
 		perf_top__mmap_read(top);
 
diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 9b38681..293eca7 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -452,6 +452,8 @@ void perf_evlist__munmap(struct perf_evlist *evlist)
 
 	free(evlist->mmap);
 	evlist->mmap = NULL;
+
+	evlist->nr_mmaps = 0;
 }
 
 static int perf_evlist__alloc_mmap(struct perf_evlist *evlist)
-- 
1.7.9.7

