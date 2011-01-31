Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756423Ab1AaV35 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 16:29:57 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:33201 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756401Ab1AaV3y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 16:29:54 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 1/5] perf evlist: Move evlist methods to evlist.c
Date: Mon, 31 Jan 2011 19:29:18 -0200
Message-Id: <1296509362-28054-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1296509362-28054-1-git-send-email-acme@infradead.org>
References: <1296509362-28054-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

They were on evsel.c because they came from refactoring existing evsel
methods, so, to make reviewing the changes easier, I kept it there, now
its a plain move.

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
 tools/perf/util/evlist.c |  142 +++++++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/evlist.h |    7 ++
 tools/perf/util/evsel.c  |  144 +++-------------------------------------------
 tools/perf/util/evsel.h  |    4 -
 4 files changed, 158 insertions(+), 139 deletions(-)

diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 917fc18..dcd5932 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -1,11 +1,26 @@
+/*
+ * Copyright (C) 2011, Red Hat Inc, Arnaldo Carvalho de Melo <acme@redhat.com>
+ *
+ * Parts came from builtin-{top,stat,record}.c, see those files for further
+ * copyright notes.
+ *
+ * Released under the GPL v2. (and only v2, not any later version)
+ */
 #include <poll.h>
+#include "cpumap.h"
+#include "thread_map.h"
 #include "evlist.h"
 #include "evsel.h"
 #include "util.h"
 
+#include <sys/mman.h>
+
 #include <linux/bitops.h>
 #include <linux/hash.h>
 
+#define FD(e, x, y) (*(int *)xyarray__entry(e->fd, x, y))
+#define SID(e, x, y) xyarray__entry(e->id, x, y)
+
 void perf_evlist__init(struct perf_evlist *evlist)
 {
 	int i;
@@ -88,6 +103,30 @@ void perf_evlist__add_pollfd(struct perf_evlist *evlist, int fd)
 	evlist->nr_fds++;
 }
 
+static int perf_evlist__id_hash(struct perf_evlist *evlist, struct perf_evsel *evsel,
+			       int cpu, int thread, int fd)
+{
+	struct perf_sample_id *sid;
+	u64 read_data[4] = { 0, };
+	int hash, id_idx = 1; /* The first entry is the counter value */
+
+	if (!(evsel->attr.read_format & PERF_FORMAT_ID) ||
+	    read(fd, &read_data, sizeof(read_data)) == -1)
+		return -1;
+
+	if (evsel->attr.read_format & PERF_FORMAT_TOTAL_TIME_ENABLED)
+		++id_idx;
+	if (evsel->attr.read_format & PERF_FORMAT_TOTAL_TIME_RUNNING)
+		++id_idx;
+
+	sid = SID(evsel, cpu, thread);
+	sid->id = read_data[id_idx];
+	sid->evsel = evsel;
+	hash = hash_64(sid->id, PERF_EVLIST__HLIST_BITS);
+	hlist_add_head(&sid->node, &evlist->heads[hash]);
+	return 0;
+}
+
 struct perf_evsel *perf_evlist__id2evsel(struct perf_evlist *evlist, u64 id)
 {
 	struct hlist_head *head;
@@ -173,3 +212,106 @@ union perf_event *perf_evlist__read_on_cpu(struct perf_evlist *evlist, int cpu)
 
 	return event;
 }
+
+void perf_evlist__munmap(struct perf_evlist *evlist, int ncpus)
+{
+	int cpu;
+
+	for (cpu = 0; cpu < ncpus; cpu++) {
+		if (evlist->mmap[cpu].base != NULL) {
+			munmap(evlist->mmap[cpu].base, evlist->mmap_len);
+			evlist->mmap[cpu].base = NULL;
+		}
+	}
+}
+
+int perf_evlist__alloc_mmap(struct perf_evlist *evlist, int ncpus)
+{
+	evlist->mmap = zalloc(ncpus * sizeof(struct perf_mmap));
+	return evlist->mmap != NULL ? 0 : -ENOMEM;
+}
+
+static int __perf_evlist__mmap(struct perf_evlist *evlist, int cpu, int prot,
+			       int mask, int fd)
+{
+	evlist->mmap[cpu].prev = 0;
+	evlist->mmap[cpu].mask = mask;
+	evlist->mmap[cpu].base = mmap(NULL, evlist->mmap_len, prot,
+				      MAP_SHARED, fd, 0);
+	if (evlist->mmap[cpu].base == MAP_FAILED)
+		return -1;
+
+	perf_evlist__add_pollfd(evlist, fd);
+	return 0;
+}
+
+/** perf_evlist__mmap - Create per cpu maps to receive events
+ *
+ * @evlist - list of events
+ * @cpus - cpu map being monitored
+ * @threads - threads map being monitored
+ * @pages - map length in pages
+ * @overwrite - overwrite older events?
+ *
+ * If overwrite is false the user needs to signal event consuption using:
+ *
+ *	struct perf_mmap *m = &evlist->mmap[cpu];
+ *	unsigned int head = perf_mmap__read_head(m);
+ *
+ *	perf_mmap__write_tail(m, head)
+ */
+int perf_evlist__mmap(struct perf_evlist *evlist, struct cpu_map *cpus,
+		      struct thread_map *threads, int pages, bool overwrite)
+{
+	unsigned int page_size = sysconf(_SC_PAGE_SIZE);
+	int mask = pages * page_size - 1, cpu;
+	struct perf_evsel *first_evsel, *evsel;
+	int thread, prot = PROT_READ | (overwrite ? 0 : PROT_WRITE);
+
+	if (evlist->mmap == NULL &&
+	    perf_evlist__alloc_mmap(evlist, cpus->nr) < 0)
+		return -ENOMEM;
+
+	if (evlist->pollfd == NULL &&
+	    perf_evlist__alloc_pollfd(evlist, cpus->nr, threads->nr) < 0)
+		return -ENOMEM;
+
+	evlist->overwrite = overwrite;
+	evlist->mmap_len = (pages + 1) * page_size;
+	first_evsel = list_entry(evlist->entries.next, struct perf_evsel, node);
+
+	list_for_each_entry(evsel, &evlist->entries, node) {
+		if ((evsel->attr.read_format & PERF_FORMAT_ID) &&
+		    evsel->id == NULL &&
+		    perf_evsel__alloc_id(evsel, cpus->nr, threads->nr) < 0)
+			return -ENOMEM;
+
+		for (cpu = 0; cpu < cpus->nr; cpu++) {
+			for (thread = 0; thread < threads->nr; thread++) {
+				int fd = FD(evsel, cpu, thread);
+
+				if (evsel->idx || thread) {
+					if (ioctl(fd, PERF_EVENT_IOC_SET_OUTPUT,
+						  FD(first_evsel, cpu, 0)) != 0)
+						goto out_unmap;
+				} else if (__perf_evlist__mmap(evlist, cpu, prot, mask, fd) < 0)
+					goto out_unmap;
+
+				if ((evsel->attr.read_format & PERF_FORMAT_ID) &&
+				    perf_evlist__id_hash(evlist, evsel, cpu, thread, fd) < 0)
+					goto out_unmap;
+			}
+		}
+	}
+
+	return 0;
+
+out_unmap:
+	for (cpu = 0; cpu < cpus->nr; cpu++) {
+		if (evlist->mmap[cpu].base != NULL) {
+			munmap(evlist->mmap[cpu].base, evlist->mmap_len);
+			evlist->mmap[cpu].base = NULL;
+		}
+	}
+	return -1;
+}
diff --git a/tools/perf/util/evlist.h b/tools/perf/util/evlist.h
index 022ae40..85aca6e 100644
--- a/tools/perf/util/evlist.h
+++ b/tools/perf/util/evlist.h
@@ -6,6 +6,8 @@
 #include "event.h"
 
 struct pollfd;
+struct thread_map;
+struct cpu_map;
 
 #define PERF_EVLIST__HLIST_BITS 8
 #define PERF_EVLIST__HLIST_SIZE (1 << PERF_EVLIST__HLIST_BITS)
@@ -39,4 +41,9 @@ struct perf_evsel *perf_evlist__id2evsel(struct perf_evlist *evlist, u64 id);
 
 union perf_event *perf_evlist__read_on_cpu(struct perf_evlist *self, int cpu);
 
+int perf_evlist__alloc_mmap(struct perf_evlist *evlist, int ncpus);
+int perf_evlist__mmap(struct perf_evlist *evlist, struct cpu_map *cpus,
+		      struct thread_map *threads, int pages, bool overwrite);
+void perf_evlist__munmap(struct perf_evlist *evlist, int ncpus);
+
 #endif /* __PERF_EVLIST_H */
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index fddeb08..2720bc1 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -1,18 +1,19 @@
+/*
+ * Copyright (C) 2011, Red Hat Inc, Arnaldo Carvalho de Melo <acme@redhat.com>
+ *
+ * Parts came from builtin-{top,stat,record}.c, see those files for further
+ * copyright notes.
+ *
+ * Released under the GPL v2. (and only v2, not any later version)
+ */
+
 #include "evsel.h"
 #include "evlist.h"
-#include "../perf.h"
 #include "util.h"
 #include "cpumap.h"
 #include "thread_map.h"
 
-#include <unistd.h>
-#include <sys/mman.h>
-
-#include <linux/bitops.h>
-#include <linux/hash.h>
-
 #define FD(e, x, y) (*(int *)xyarray__entry(e->fd, x, y))
-#define SID(e, x, y) xyarray__entry(e->id, x, y)
 
 void perf_evsel__init(struct perf_evsel *evsel,
 		      struct perf_event_attr *attr, int idx)
@@ -74,24 +75,6 @@ void perf_evsel__close_fd(struct perf_evsel *evsel, int ncpus, int nthreads)
 		}
 }
 
-void perf_evlist__munmap(struct perf_evlist *evlist, int ncpus)
-{
-	int cpu;
-
-	for (cpu = 0; cpu < ncpus; cpu++) {
-		if (evlist->mmap[cpu].base != NULL) {
-			munmap(evlist->mmap[cpu].base, evlist->mmap_len);
-			evlist->mmap[cpu].base = NULL;
-		}
-	}
-}
-
-int perf_evlist__alloc_mmap(struct perf_evlist *evlist, int ncpus)
-{
-	evlist->mmap = zalloc(ncpus * sizeof(struct perf_mmap));
-	return evlist->mmap != NULL ? 0 : -ENOMEM;
-}
-
 void perf_evsel__exit(struct perf_evsel *evsel)
 {
 	assert(list_empty(&evsel->node));
@@ -258,115 +241,6 @@ int perf_evsel__open_per_thread(struct perf_evsel *evsel,
 	return __perf_evsel__open(evsel, &empty_cpu_map.map, threads, group, inherit);
 }
 
-static int __perf_evlist__mmap(struct perf_evlist *evlist, int cpu, int prot,
-			       int mask, int fd)
-{
-	evlist->mmap[cpu].prev = 0;
-	evlist->mmap[cpu].mask = mask;
-	evlist->mmap[cpu].base = mmap(NULL, evlist->mmap_len, prot,
-				      MAP_SHARED, fd, 0);
-	if (evlist->mmap[cpu].base == MAP_FAILED)
-		return -1;
-
-	perf_evlist__add_pollfd(evlist, fd);
-	return 0;
-}
-
-static int perf_evlist__id_hash(struct perf_evlist *evlist, struct perf_evsel *evsel,
-			       int cpu, int thread, int fd)
-{
-	struct perf_sample_id *sid;
-	u64 read_data[4] = { 0, };
-	int hash, id_idx = 1; /* The first entry is the counter value */
-
-	if (!(evsel->attr.read_format & PERF_FORMAT_ID) ||
-	    read(fd, &read_data, sizeof(read_data)) == -1)
-		return -1;
-
-	if (evsel->attr.read_format & PERF_FORMAT_TOTAL_TIME_ENABLED)
-		++id_idx;
-	if (evsel->attr.read_format & PERF_FORMAT_TOTAL_TIME_RUNNING)
-		++id_idx;
-
-	sid = SID(evsel, cpu, thread);
-	sid->id = read_data[id_idx];
-	sid->evsel = evsel;
-	hash = hash_64(sid->id, PERF_EVLIST__HLIST_BITS);
-	hlist_add_head(&sid->node, &evlist->heads[hash]);
-	return 0;
-}
-
-/** perf_evlist__mmap - Create per cpu maps to receive events
- *
- * @evlist - list of events
- * @cpus - cpu map being monitored
- * @threads - threads map being monitored
- * @pages - map length in pages
- * @overwrite - overwrite older events?
- *
- * If overwrite is false the user needs to signal event consuption using:
- *
- *	struct perf_mmap *m = &evlist->mmap[cpu];
- *	unsigned int head = perf_mmap__read_head(m);
- *
- *	perf_mmap__write_tail(m, head)
- */
-int perf_evlist__mmap(struct perf_evlist *evlist, struct cpu_map *cpus,
-		      struct thread_map *threads, int pages, bool overwrite)
-{
-	unsigned int page_size = sysconf(_SC_PAGE_SIZE);
-	int mask = pages * page_size - 1, cpu;
-	struct perf_evsel *first_evsel, *evsel;
-	int thread, prot = PROT_READ | (overwrite ? 0 : PROT_WRITE);
-
-	if (evlist->mmap == NULL &&
-	    perf_evlist__alloc_mmap(evlist, cpus->nr) < 0)
-		return -ENOMEM;
-
-	if (evlist->pollfd == NULL &&
-	    perf_evlist__alloc_pollfd(evlist, cpus->nr, threads->nr) < 0)
-		return -ENOMEM;
-
-	evlist->overwrite = overwrite;
-	evlist->mmap_len = (pages + 1) * page_size;
-	first_evsel = list_entry(evlist->entries.next, struct perf_evsel, node);
-
-	list_for_each_entry(evsel, &evlist->entries, node) {
-		if ((evsel->attr.read_format & PERF_FORMAT_ID) &&
-		    evsel->id == NULL &&
-		    perf_evsel__alloc_id(evsel, cpus->nr, threads->nr) < 0)
-			return -ENOMEM;
-
-		for (cpu = 0; cpu < cpus->nr; cpu++) {
-			for (thread = 0; thread < threads->nr; thread++) {
-				int fd = FD(evsel, cpu, thread);
-
-				if (evsel->idx || thread) {
-					if (ioctl(fd, PERF_EVENT_IOC_SET_OUTPUT,
-						  FD(first_evsel, cpu, 0)) != 0)
-						goto out_unmap;
-				} else if (__perf_evlist__mmap(evlist, cpu, prot, mask, fd) < 0)
-					goto out_unmap;
-
-				if ((evsel->attr.read_format & PERF_FORMAT_ID) &&
-				    perf_evlist__id_hash(evlist, evsel, cpu, thread, fd) < 0)
-					goto out_unmap;
-			}
-		}
-	}
-
-	return 0;
-
-out_unmap:
-	for (cpu = 0; cpu < cpus->nr; cpu++) {
-		if (evlist->mmap[cpu].base != NULL) {
-			munmap(evlist->mmap[cpu].base, evlist->mmap_len);
-			evlist->mmap[cpu].base = NULL;
-		}
-	}
-	return -1;
-}
-
 static int perf_event__parse_id_sample(const union perf_event *event, u64 type,
 				       struct perf_sample *sample)
 {
diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index 7962e75..eecdc3a 100644
--- a/tools/perf/util/evsel.h
+++ b/tools/perf/util/evsel.h
@@ -60,7 +60,6 @@ void perf_evsel__delete(struct perf_evsel *evsel);
 int perf_evsel__alloc_fd(struct perf_evsel *evsel, int ncpus, int nthreads);
 int perf_evsel__alloc_id(struct perf_evsel *evsel, int ncpus, int nthreads);
 int perf_evsel__alloc_counts(struct perf_evsel *evsel, int ncpus);
-int perf_evlist__alloc_mmap(struct perf_evlist *evlist, int ncpus);
 void perf_evsel__free_fd(struct perf_evsel *evsel);
 void perf_evsel__free_id(struct perf_evsel *evsel);
 void perf_evsel__close_fd(struct perf_evsel *evsel, int ncpus, int nthreads);
@@ -71,9 +70,6 @@ int perf_evsel__open_per_thread(struct perf_evsel *evsel,
 				struct thread_map *threads, bool group, bool inherit);
 int perf_evsel__open(struct perf_evsel *evsel, struct cpu_map *cpus,
 		     struct thread_map *threads, bool group, bool inherit);
-int perf_evlist__mmap(struct perf_evlist *evlist, struct cpu_map *cpus,
-		      struct thread_map *threads, int pages, bool overwrite);
-void perf_evlist__munmap(struct perf_evlist *evlist, int ncpus);
 
 #define perf_evsel__match(evsel, t, c)		\
 	(evsel->attr.type == PERF_TYPE_##t &&	\
-- 
1.6.2.5

