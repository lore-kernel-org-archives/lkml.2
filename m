Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753597Ab1AOPlX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jan 2011 10:41:23 -0500
Received: from canuck.infradead.org ([134.117.69.58]:52722 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753312Ab1AOPlU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jan 2011 10:41:20 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 07/16] perf evsel: Introduce mmap support
Date: Sat, 15 Jan 2011 13:40:36 -0200
Message-Id: <1295106045-31192-8-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1295106045-31192-1-git-send-email-acme@infradead.org>
References: <1295106045-31192-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Out of the code in 'perf top'. Record is next in line.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-top.c |   71 +++------------------------------------------
 tools/perf/perf.h        |   14 +++++++++
 tools/perf/util/evlist.c |    8 +++++
 tools/perf/util/evlist.h |    1 +
 tools/perf/util/evsel.c  |   71 ++++++++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/evsel.h  |    8 +++++
 6 files changed, 107 insertions(+), 66 deletions(-)

diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 73d88a8..be7a739 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -1094,43 +1094,12 @@ static void event__process_sample(const event_t *self,
 	}
 }
 
-struct mmap_data {
-	void			*base;
-	int			mask;
-	unsigned int		prev;
-};
-
-static int perf_evsel__alloc_mmap_per_thread(struct perf_evsel *evsel,
-					     int ncpus, int nthreads)
-{
-	evsel->priv = xyarray__new(ncpus, nthreads, sizeof(struct mmap_data));
-	return evsel->priv != NULL ? 0 : -ENOMEM;
-}
-
-static void perf_evsel__free_mmap(struct perf_evsel *evsel)
-{
-	xyarray__delete(evsel->priv);
-	evsel->priv = NULL;
-}
-
-static unsigned int mmap_read_head(struct mmap_data *md)
-{
-	struct perf_event_mmap_page *pc = md->base;
-	int head;
-
-	head = pc->data_head;
-	rmb();
-
-	return head;
-}
-
 static void perf_session__mmap_read_counter(struct perf_session *self,
 					    struct perf_evsel *evsel,
 					    int cpu, int thread_idx)
 {
-	struct xyarray *mmap_array = evsel->priv;
-	struct mmap_data *md = xyarray__entry(mmap_array, cpu, thread_idx);
-	unsigned int head = mmap_read_head(md);
+	struct perf_mmap *md = xyarray__entry(evsel->mmap, cpu, thread_idx);
+	unsigned int head = perf_mmap__read_head(md);
 	unsigned int old = md->prev;
 	unsigned char *data = md->base + page_size;
 	struct sample_data sample;
@@ -1209,35 +1178,9 @@ static void perf_session__mmap_read(struct perf_session *self)
 	}
 }
 
-static void start_counter(int i, struct perf_evlist *evlist,
-			  struct perf_evsel *evsel)
-{
-	struct xyarray *mmap_array = evsel->priv;
-	struct mmap_data *mm;
-	int thread_index;
-
-	for (thread_index = 0; thread_index < threads->nr; thread_index++) {
-		assert(FD(evsel, i, thread_index) >= 0);
-		fcntl(FD(evsel, i, thread_index), F_SETFL, O_NONBLOCK);
-
-		evlist->pollfd[evlist->nr_fds].fd = FD(evsel, i, thread_index);
-		evlist->pollfd[evlist->nr_fds].events = POLLIN;
-		evlist->nr_fds++;
-
-		mm = xyarray__entry(mmap_array, i, thread_index);
-		mm->prev = 0;
-		mm->mask = mmap_pages*page_size - 1;
-		mm->base = mmap(NULL, (mmap_pages+1)*page_size,
-				PROT_READ, MAP_SHARED, FD(evsel, i, thread_index), 0);
-		if (mm->base == MAP_FAILED)
-			die("failed to mmap with %d (%s)\n", errno, strerror(errno));
-	}
-}
-
 static void start_counters(struct perf_evlist *evlist)
 {
 	struct perf_evsel *counter;
-	int i;
 
 	list_for_each_entry(counter, &evlist->entries, node) {
 		struct perf_event_attr *attr = &counter->attr;
@@ -1281,11 +1224,9 @@ try_again:
 			die("No CONFIG_PERF_EVENTS=y kernel support configured?\n");
 			exit(-1);
 		}
-	}
 
-	for (i = 0; i < cpus->nr; i++) {
-		list_for_each_entry(counter, &evlist->entries, node)
-			start_counter(i, evsel_list, counter);
+		if (perf_evsel__mmap(counter, cpus, threads, mmap_pages, evlist) < 0)
+			die("failed to mmap with %d (%s)\n", errno, strerror(errno));
 	}
 }
 
@@ -1452,7 +1393,7 @@ int cmd_top(int argc, const char **argv, const char *prefix __used)
 		usage_with_options(top_usage, options);
 
 	list_for_each_entry(pos, &evsel_list->entries, node) {
-		if (perf_evsel__alloc_mmap_per_thread(pos, cpus->nr, threads->nr) < 0 ||
+		if (perf_evsel__alloc_mmap(pos, cpus->nr, threads->nr) < 0 ||
 		    perf_evsel__alloc_fd(pos, cpus->nr, threads->nr) < 0)
 			goto out_free_fd;
 		/*
@@ -1484,8 +1425,6 @@ int cmd_top(int argc, const char **argv, const char *prefix __used)
 
 	status = __cmd_top();
 out_free_fd:
-	list_for_each_entry(pos, &evsel_list->entries, node)
-		perf_evsel__free_mmap(pos);
 	perf_evlist__delete(evsel_list);
 
 	return status;
diff --git a/tools/perf/perf.h b/tools/perf/perf.h
index 95aaf56..5fb5e1f 100644
--- a/tools/perf/perf.h
+++ b/tools/perf/perf.h
@@ -94,6 +94,20 @@ void get_term_dimensions(struct winsize *ws);
 #include "util/types.h"
 #include <stdbool.h>
 
+struct perf_mmap {
+	void			*base;
+	int			mask;
+	unsigned int		prev;
+};
+
+static inline unsigned int perf_mmap__read_head(struct perf_mmap *mm)
+{
+	struct perf_event_mmap_page *pc = mm->base;
+	int head = pc->data_head;
+	rmb();
+	return head;
+}
+
 /*
  * prctl(PR_TASK_PERF_EVENTS_DISABLE) will (cheaply) disable all
  * counters in the current task.
diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 2abf949..6d41292 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -60,3 +60,11 @@ int perf_evlist__alloc_pollfd(struct perf_evlist *evlist, int ncpus, int nthread
 	evlist->pollfd = malloc(sizeof(struct pollfd) * nfds);
 	return evlist->pollfd != NULL ? 0 : -ENOMEM;
 }
+
+void perf_evlist__add_pollfd(struct perf_evlist *evlist, int fd)
+{
+	fcntl(fd, F_SETFL, O_NONBLOCK);
+	evlist->pollfd[evlist->nr_fds].fd = fd;
+	evlist->pollfd[evlist->nr_fds].events = POLLIN;
+	evlist->nr_fds++;
+}
diff --git a/tools/perf/util/evlist.h b/tools/perf/util/evlist.h
index a7d7e12..16bbfcb 100644
--- a/tools/perf/util/evlist.h
+++ b/tools/perf/util/evlist.h
@@ -21,5 +21,6 @@ void perf_evlist__add(struct perf_evlist *evlist, struct perf_evsel *entry);
 int perf_evlist__add_default(struct perf_evlist *evlist);
 
 int perf_evlist__alloc_pollfd(struct perf_evlist *evlist, int ncpus, int nthreads);
+void perf_evlist__add_pollfd(struct perf_evlist *evlist, int fd);
 
 #endif /* __PERF_EVLIST_H */
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 82a0053..f500695 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -1,9 +1,13 @@
 #include "evsel.h"
+#include "evlist.h"
 #include "../perf.h"
 #include "util.h"
 #include "cpumap.h"
 #include "thread.h"
 
+#include <unistd.h>
+#include <sys/mman.h>
+
 #define FD(e, x, y) (*(int *)xyarray__entry(e->fd, x, y))
 
 struct perf_evsel *perf_evsel__new(struct perf_event_attr *attr, int idx)
@@ -49,10 +53,32 @@ void perf_evsel__close_fd(struct perf_evsel *evsel, int ncpus, int nthreads)
 		}
 }
 
+void perf_evsel__munmap(struct perf_evsel *evsel, int ncpus, int nthreads)
+{
+	struct perf_mmap *mm;
+	int cpu, thread;
+
+	for (cpu = 0; cpu < ncpus; cpu++)
+		for (thread = 0; thread < nthreads; ++thread) {
+			mm = xyarray__entry(evsel->mmap, cpu, thread);
+			if (mm->base != NULL) {
+				munmap(mm->base, evsel->mmap_len);
+				mm->base = NULL;
+			}
+		}
+}
+
+int perf_evsel__alloc_mmap(struct perf_evsel *evsel, int ncpus, int nthreads)
+{
+	evsel->mmap = xyarray__new(ncpus, nthreads, sizeof(struct perf_mmap));
+	return evsel->mmap != NULL ? 0 : -ENOMEM;
+}
+
 void perf_evsel__delete(struct perf_evsel *evsel)
 {
 	assert(list_empty(&evsel->node));
 	xyarray__delete(evsel->fd);
+	xyarray__delete(evsel->mmap);
 	free(evsel);
 }
 
@@ -208,3 +234,48 @@ int perf_evsel__open_per_thread(struct perf_evsel *evsel,
 {
 	return __perf_evsel__open(evsel, &empty_cpu_map.map, threads, group, inherit);
 }
+
+int perf_evsel__mmap(struct perf_evsel *evsel, struct cpu_map *cpus,
+		     struct thread_map *threads, int pages,
+		     struct perf_evlist *evlist)
+{
+	unsigned int page_size = sysconf(_SC_PAGE_SIZE);
+	int mask = pages * page_size - 1, cpu;
+	struct perf_mmap *mm;
+	int thread;
+
+	if (evsel->mmap == NULL &&
+	    perf_evsel__alloc_mmap(evsel, cpus->nr, threads->nr) < 0)
+		return -ENOMEM;
+
+	evsel->mmap_len = (pages + 1) * page_size;
+
+	for (cpu = 0; cpu < cpus->nr; cpu++) {
+		for (thread = 0; thread < threads->nr; thread++) {
+			mm = xyarray__entry(evsel->mmap, cpu, thread);
+			mm->prev = 0;
+			mm->mask = mask;
+			mm->base = mmap(NULL, evsel->mmap_len, PROT_READ,
+					MAP_SHARED, FD(evsel, cpu, thread), 0);
+			if (mm->base == MAP_FAILED)
+				goto out_unmap;
+
+			if (evlist != NULL)
+				 perf_evlist__add_pollfd(evlist, FD(evsel, cpu, thread));
+		}
+	}
+
+	return 0;
+
+out_unmap:
+	do {
+		while (--thread >= 0) {
+			mm = xyarray__entry(evsel->mmap, cpu, thread);
+			munmap(mm->base, evsel->mmap_len);
+			mm->base = NULL;
+		}
+		thread = threads->nr;
+	} while (--cpu >= 0);
+
+	return -1;
+}
diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index 1594696..c8fbef2 100644
--- a/tools/perf/util/evsel.h
+++ b/tools/perf/util/evsel.h
@@ -29,19 +29,23 @@ struct perf_evsel {
 	struct perf_event_attr	attr;
 	char			*filter;
 	struct xyarray		*fd;
+	struct xyarray		*mmap;
 	struct perf_counts	*counts;
+	size_t			mmap_len;
 	int			idx;
 	void			*priv;
 };
 
 struct cpu_map;
 struct thread_map;
+struct perf_evlist;
 
 struct perf_evsel *perf_evsel__new(struct perf_event_attr *attr, int idx);
 void perf_evsel__delete(struct perf_evsel *evsel);
 
 int perf_evsel__alloc_fd(struct perf_evsel *evsel, int ncpus, int nthreads);
 int perf_evsel__alloc_counts(struct perf_evsel *evsel, int ncpus);
+int perf_evsel__alloc_mmap(struct perf_evsel *evsel, int ncpus, int nthreads);
 void perf_evsel__free_fd(struct perf_evsel *evsel);
 void perf_evsel__close_fd(struct perf_evsel *evsel, int ncpus, int nthreads);
 
@@ -51,6 +55,10 @@ int perf_evsel__open_per_thread(struct perf_evsel *evsel,
 				struct thread_map *threads, bool group, bool inherit);
 int perf_evsel__open(struct perf_evsel *evsel, struct cpu_map *cpus,
 		     struct thread_map *threads, bool group, bool inherit);
+int perf_evsel__mmap(struct perf_evsel *evsel, struct cpu_map *cpus,
+		     struct thread_map *threads, int pages,
+		     struct perf_evlist *evlist);
+void perf_evsel__munmap(struct perf_evsel *evsel, int ncpus, int nthreads);
 
 #define perf_evsel__match(evsel, t, c)		\
 	(evsel->attr.type == PERF_TYPE_##t &&	\
-- 
1.6.2.5

