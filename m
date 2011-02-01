Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754189Ab1BAJT2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 04:19:28 -0500
Received: from hera.kernel.org ([140.211.167.34]:45408 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752808Ab1BAJTY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 04:19:24 -0500
Date: Tue, 1 Feb 2011 09:18:50 GMT
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@redhat.com, tzanussi@gmail.com,
        peterz@infradead.org, efault@gmx.de, fweisbec@gmail.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, tzanussi@gmail.com,
        efault@gmx.de, peterz@infradead.org, fweisbec@gmail.com,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf evlist: Move evlist methods to evlist.c
Message-ID: <tip-f8a9530939ed87b9a1b1a038b90e355098b679a2@git.kernel.org>
Git-Commit-ID: f8a9530939ed87b9a1b1a038b90e355098b679a2
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 01 Feb 2011 09:18:52 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f8a9530939ed87b9a1b1a038b90e355098b679a2
Gitweb:     http://git.kernel.org/tip/f8a9530939ed87b9a1b1a038b90e355098b679a2
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Sun, 30 Jan 2011 10:46:46 -0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Sun, 30 Jan 2011 11:41:13 -0200

perf evlist: Move evlist methods to evlist.c

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
