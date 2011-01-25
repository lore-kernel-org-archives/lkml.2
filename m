Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753437Ab1AYRWS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 12:22:18 -0500
Received: from casper.infradead.org ([85.118.1.10]:46986 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753045Ab1AYRWJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 12:22:09 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 10/29] perf evlist: Move the mmap array from perf_evsel
Date: Tue, 25 Jan 2011 15:21:33 -0200
Message-Id: <1295976112-2796-11-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1295976112-2796-1-git-send-email-acme@infradead.org>
References: <1295976112-2796-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Adopting the new model used in 'perf record', where we don't have a map
per thread per cpu, instead we have an mmap per cpu, established on the
first fd for that cpu and ask the kernel using the
PERF_EVENT_IOC_SET_OUTPUT ioctl to send events for the other fds on that
cpu for the one with the mmap.

The methods moved from perf_evsel to perf_evlist, but for easing review
they were modified in place, in evsel.c, the next patch will move the
migrated methods to evlist.c.

With this 'perf top' now uses the same mmap model used by 'perf record'
and the next patches will make 'perf record' use these new routines,
establishing a common codebase for both tools.

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
 tools/perf/builtin-top.c |   56 ++++++++--------
 tools/perf/util/evlist.c |   27 ++++++++
 tools/perf/util/evlist.h |    9 +++
 tools/perf/util/evsel.c  |  160 ++++++++++++++++++++++++++++++++++------------
 tools/perf/util/evsel.h  |   26 ++++++--
 5 files changed, 201 insertions(+), 77 deletions(-)

diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 7d723ad..df85c1f 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -78,7 +78,7 @@ static struct cpu_map		*cpus;
 static int			realtime_prio			=      0;
 static bool			group				=  false;
 static unsigned int		page_size;
-static unsigned int		mmap_pages			=     16;
+static unsigned int		mmap_pages			=    128;
 static int			freq				=   1000; /* 1 KHz */
 
 static int			delay_secs			=      2;
@@ -991,8 +991,7 @@ static int symbol_filter(struct map *map, struct symbol *sym)
 
 static void event__process_sample(const event_t *self,
 				  struct sample_data *sample,
-				  struct perf_session *session,
-				  struct perf_evsel *evsel)
+				  struct perf_session *session)
 {
 	u64 ip = self->ip.ip;
 	struct sym_entry *syme;
@@ -1085,8 +1084,12 @@ static void event__process_sample(const event_t *self,
 
 	syme = symbol__priv(al.sym);
 	if (!syme->skip) {
-		syme->count[evsel->idx]++;
+		struct perf_evsel *evsel;
+
 		syme->origin = origin;
+		evsel = perf_evlist__id2evsel(evsel_list, sample->id);
+		assert(evsel != NULL);
+		syme->count[evsel->idx]++;
 		record_precise_ip(syme, evsel->idx, ip);
 		pthread_mutex_lock(&active_symbols_lock);
 		if (list_empty(&syme->node) || !syme->node.next)
@@ -1095,11 +1098,9 @@ static void event__process_sample(const event_t *self,
 	}
 }
 
-static void perf_session__mmap_read_counter(struct perf_session *self,
-					    struct perf_evsel *evsel,
-					    int cpu, int thread_idx)
+static void perf_session__mmap_read_cpu(struct perf_session *self, int cpu)
 {
-	struct perf_mmap *md = xyarray__entry(evsel->mmap, cpu, thread_idx);
+	struct perf_mmap *md = &evsel_list->mmap[cpu];
 	unsigned int head = perf_mmap__read_head(md);
 	unsigned int old = md->prev;
 	unsigned char *data = md->base + page_size;
@@ -1153,7 +1154,7 @@ static void perf_session__mmap_read_counter(struct perf_session *self,
 
 		event__parse_sample(event, self, &sample);
 		if (event->header.type == PERF_RECORD_SAMPLE)
-			event__process_sample(event, &sample, self, evsel);
+			event__process_sample(event, &sample, self);
 		else
 			event__process(event, &sample, self);
 		old += size;
@@ -1164,19 +1165,10 @@ static void perf_session__mmap_read_counter(struct perf_session *self,
 
 static void perf_session__mmap_read(struct perf_session *self)
 {
-	struct perf_evsel *counter;
-	int i, thread_index;
-
-	for (i = 0; i < cpus->nr; i++) {
-		list_for_each_entry(counter, &evsel_list->entries, node) {
-			for (thread_index = 0;
-				thread_index < threads->nr;
-				thread_index++) {
-				perf_session__mmap_read_counter(self,
-					counter, i, thread_index);
-			}
-		}
-	}
+	int i;
+
+	for (i = 0; i < cpus->nr; i++)
+		perf_session__mmap_read_cpu(self, i);
 }
 
 static void start_counters(struct perf_evlist *evlist)
@@ -1194,6 +1186,11 @@ static void start_counters(struct perf_evlist *evlist)
 			attr->sample_freq = freq;
 		}
 
+		if (evlist->nr_entries > 1) {
+			attr->sample_type |= PERF_SAMPLE_ID;
+			attr->read_format |= PERF_FORMAT_ID;
+		}
+
 		attr->mmap = 1;
 try_again:
 		if (perf_evsel__open(counter, cpus, threads, group, inherit) < 0) {
@@ -1225,15 +1222,16 @@ try_again:
 			die("No CONFIG_PERF_EVENTS=y kernel support configured?\n");
 			exit(-1);
 		}
-
-		if (perf_evsel__mmap(counter, cpus, threads, mmap_pages, evlist) < 0)
-			die("failed to mmap with %d (%s)\n", errno, strerror(errno));
 	}
+
+	if (perf_evlist__mmap(evlist, cpus, threads, mmap_pages, true) < 0)
+		die("failed to mmap with %d (%s)\n", errno, strerror(errno));
 }
 
 static int __cmd_top(void)
 {
 	pthread_t thread;
+	struct perf_evsel *first;
 	int ret;
 	/*
 	 * FIXME: perf_session__new should allow passing a O_MMAP, so that all this
@@ -1249,6 +1247,8 @@ static int __cmd_top(void)
 		event__synthesize_threads(event__process, session);
 
 	start_counters(evsel_list);
+	first = list_entry(evsel_list->entries.next, struct perf_evsel, node);
+	perf_session__set_sample_type(session, first->attr.sample_type);
 
 	/* Wait for a minimal set of events before starting the snapshot */
 	poll(evsel_list->pollfd, evsel_list->nr_fds, 100);
@@ -1394,8 +1394,7 @@ int cmd_top(int argc, const char **argv, const char *prefix __used)
 		usage_with_options(top_usage, options);
 
 	list_for_each_entry(pos, &evsel_list->entries, node) {
-		if (perf_evsel__alloc_mmap(pos, cpus->nr, threads->nr) < 0 ||
-		    perf_evsel__alloc_fd(pos, cpus->nr, threads->nr) < 0)
+		if (perf_evsel__alloc_fd(pos, cpus->nr, threads->nr) < 0)
 			goto out_free_fd;
 		/*
 		 * Fill in the ones not specifically initialized via -c:
@@ -1406,7 +1405,8 @@ int cmd_top(int argc, const char **argv, const char *prefix __used)
 		pos->attr.sample_period = default_interval;
 	}
 
-	if (perf_evlist__alloc_pollfd(evsel_list, cpus->nr, threads->nr) < 0)
+	if (perf_evlist__alloc_pollfd(evsel_list, cpus->nr, threads->nr) < 0 ||
+	    perf_evlist__alloc_mmap(evsel_list, cpus->nr) < 0)
 		goto out_free_fd;
 
 	sym_evsel = list_entry(evsel_list->entries.next, struct perf_evsel, node);
diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 6d41292..deb82a4 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -3,11 +3,18 @@
 #include "evsel.h"
 #include "util.h"
 
+#include <linux/bitops.h>
+#include <linux/hash.h>
+
 struct perf_evlist *perf_evlist__new(void)
 {
 	struct perf_evlist *evlist = zalloc(sizeof(*evlist));
 
 	if (evlist != NULL) {
+		int i;
+
+		for (i = 0; i < PERF_EVLIST__HLIST_SIZE; ++i)
+			INIT_HLIST_HEAD(&evlist->heads[i]);
 		INIT_LIST_HEAD(&evlist->entries);
 	}
 
@@ -29,6 +36,7 @@ static void perf_evlist__purge(struct perf_evlist *evlist)
 void perf_evlist__delete(struct perf_evlist *evlist)
 {
 	perf_evlist__purge(evlist);
+	free(evlist->mmap);
 	free(evlist->pollfd);
 	free(evlist);
 }
@@ -68,3 +76,22 @@ void perf_evlist__add_pollfd(struct perf_evlist *evlist, int fd)
 	evlist->pollfd[evlist->nr_fds].events = POLLIN;
 	evlist->nr_fds++;
 }
+
+struct perf_evsel *perf_evlist__id2evsel(struct perf_evlist *evlist, u64 id)
+{
+	struct hlist_head *head;
+	struct hlist_node *pos;
+	struct perf_sample_id *sid;
+	int hash;
+
+	if (evlist->nr_entries == 1)
+		return list_entry(evlist->entries.next, struct perf_evsel, node);
+
+	hash = hash_64(id, PERF_EVLIST__HLIST_BITS);
+	head = &evlist->heads[hash];
+
+	hlist_for_each_entry(sid, pos, head, node)
+		if (sid->id == id)
+			return sid->evsel;
+	return NULL;
+}
diff --git a/tools/perf/util/evlist.h b/tools/perf/util/evlist.h
index 16bbfcb..dbfcc79 100644
--- a/tools/perf/util/evlist.h
+++ b/tools/perf/util/evlist.h
@@ -2,13 +2,20 @@
 #define __PERF_EVLIST_H 1
 
 #include <linux/list.h>
+#include "../perf.h"
 
 struct pollfd;
 
+#define PERF_EVLIST__HLIST_BITS 8
+#define PERF_EVLIST__HLIST_SIZE (1 << PERF_EVLIST__HLIST_BITS)
+
 struct perf_evlist {
 	struct list_head entries;
+	struct hlist_head heads[PERF_EVLIST__HLIST_SIZE];
 	int		 nr_entries;
 	int		 nr_fds;
+	int		 mmap_len;
+	struct perf_mmap *mmap;
 	struct pollfd	 *pollfd;
 };
 
@@ -23,4 +30,6 @@ int perf_evlist__add_default(struct perf_evlist *evlist);
 int perf_evlist__alloc_pollfd(struct perf_evlist *evlist, int ncpus, int nthreads);
 void perf_evlist__add_pollfd(struct perf_evlist *evlist, int fd);
 
+struct perf_evsel *perf_evlist__id2evsel(struct perf_evlist *evlist, u64 id);
+
 #endif /* __PERF_EVLIST_H */
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index f500695..ee49035 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -8,7 +8,11 @@
 #include <unistd.h>
 #include <sys/mman.h>
 
+#include <linux/bitops.h>
+#include <linux/hash.h>
+
 #define FD(e, x, y) (*(int *)xyarray__entry(e->fd, x, y))
+#define SID(e, x, y) xyarray__entry(e->id, x, y)
 
 struct perf_evsel *perf_evsel__new(struct perf_event_attr *attr, int idx)
 {
@@ -29,6 +33,12 @@ int perf_evsel__alloc_fd(struct perf_evsel *evsel, int ncpus, int nthreads)
 	return evsel->fd != NULL ? 0 : -ENOMEM;
 }
 
+int perf_evsel__alloc_id(struct perf_evsel *evsel, int ncpus, int nthreads)
+{
+	evsel->id = xyarray__new(ncpus, nthreads, sizeof(struct perf_sample_id));
+	return evsel->id != NULL ? 0 : -ENOMEM;
+}
+
 int perf_evsel__alloc_counts(struct perf_evsel *evsel, int ncpus)
 {
 	evsel->counts = zalloc((sizeof(*evsel->counts) +
@@ -42,6 +52,12 @@ void perf_evsel__free_fd(struct perf_evsel *evsel)
 	evsel->fd = NULL;
 }
 
+void perf_evsel__free_id(struct perf_evsel *evsel)
+{
+	xyarray__delete(evsel->id);
+	evsel->id = NULL;
+}
+
 void perf_evsel__close_fd(struct perf_evsel *evsel, int ncpus, int nthreads)
 {
 	int cpu, thread;
@@ -53,32 +69,29 @@ void perf_evsel__close_fd(struct perf_evsel *evsel, int ncpus, int nthreads)
 		}
 }
 
-void perf_evsel__munmap(struct perf_evsel *evsel, int ncpus, int nthreads)
+void perf_evlist__munmap(struct perf_evlist *evlist, int ncpus)
 {
-	struct perf_mmap *mm;
-	int cpu, thread;
+	int cpu;
 
-	for (cpu = 0; cpu < ncpus; cpu++)
-		for (thread = 0; thread < nthreads; ++thread) {
-			mm = xyarray__entry(evsel->mmap, cpu, thread);
-			if (mm->base != NULL) {
-				munmap(mm->base, evsel->mmap_len);
-				mm->base = NULL;
-			}
+	for (cpu = 0; cpu < ncpus; cpu++) {
+		if (evlist->mmap[cpu].base != NULL) {
+			munmap(evlist->mmap[cpu].base, evlist->mmap_len);
+			evlist->mmap[cpu].base = NULL;
 		}
+	}
 }
 
-int perf_evsel__alloc_mmap(struct perf_evsel *evsel, int ncpus, int nthreads)
+int perf_evlist__alloc_mmap(struct perf_evlist *evlist, int ncpus)
 {
-	evsel->mmap = xyarray__new(ncpus, nthreads, sizeof(struct perf_mmap));
-	return evsel->mmap != NULL ? 0 : -ENOMEM;
+	evlist->mmap = zalloc(ncpus * sizeof(struct perf_mmap));
+	return evlist->mmap != NULL ? 0 : -ENOMEM;
 }
 
 void perf_evsel__delete(struct perf_evsel *evsel)
 {
 	assert(list_empty(&evsel->node));
 	xyarray__delete(evsel->fd);
-	xyarray__delete(evsel->mmap);
+	xyarray__delete(evsel->id);
 	free(evsel);
 }
 
@@ -235,47 +248,110 @@ int perf_evsel__open_per_thread(struct perf_evsel *evsel,
 	return __perf_evsel__open(evsel, &empty_cpu_map.map, threads, group, inherit);
 }
 
-int perf_evsel__mmap(struct perf_evsel *evsel, struct cpu_map *cpus,
-		     struct thread_map *threads, int pages,
-		     struct perf_evlist *evlist)
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
 {
 	unsigned int page_size = sysconf(_SC_PAGE_SIZE);
 	int mask = pages * page_size - 1, cpu;
-	struct perf_mmap *mm;
-	int thread;
+	struct perf_evsel *first_evsel, *evsel;
+	int thread, prot = PROT_READ | (overwrite ? 0 : PROT_WRITE);
 
-	if (evsel->mmap == NULL &&
-	    perf_evsel__alloc_mmap(evsel, cpus->nr, threads->nr) < 0)
+	if (evlist->mmap == NULL &&
+	    perf_evlist__alloc_mmap(evlist, cpus->nr) < 0)
 		return -ENOMEM;
 
-	evsel->mmap_len = (pages + 1) * page_size;
+	if (evlist->pollfd == NULL &&
+	    perf_evlist__alloc_pollfd(evlist, cpus->nr, threads->nr) < 0)
+		return -ENOMEM;
 
-	for (cpu = 0; cpu < cpus->nr; cpu++) {
-		for (thread = 0; thread < threads->nr; thread++) {
-			mm = xyarray__entry(evsel->mmap, cpu, thread);
-			mm->prev = 0;
-			mm->mask = mask;
-			mm->base = mmap(NULL, evsel->mmap_len, PROT_READ,
-					MAP_SHARED, FD(evsel, cpu, thread), 0);
-			if (mm->base == MAP_FAILED)
-				goto out_unmap;
-
-			if (evlist != NULL)
-				 perf_evlist__add_pollfd(evlist, FD(evsel, cpu, thread));
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
 		}
 	}
 
 	return 0;
 
 out_unmap:
-	do {
-		while (--thread >= 0) {
-			mm = xyarray__entry(evsel->mmap, cpu, thread);
-			munmap(mm->base, evsel->mmap_len);
-			mm->base = NULL;
+	for (cpu = 0; cpu < cpus->nr; cpu++) {
+		if (evlist->mmap[cpu].base != NULL) {
+			munmap(evlist->mmap[cpu].base, evlist->mmap_len);
+			evlist->mmap[cpu].base = NULL;
 		}
-		thread = threads->nr;
-	} while (--cpu >= 0);
-
+	}
 	return -1;
 }
diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index c8fbef2..667ee4e 100644
--- a/tools/perf/util/evsel.h
+++ b/tools/perf/util/evsel.h
@@ -24,14 +24,25 @@ struct perf_counts {
 	struct perf_counts_values cpu[];
 };
 
+struct perf_evsel;
+
+/*
+ * Per fd, to map back from PERF_SAMPLE_ID to evsel, only used when there are
+ * more than one entry in the evlist.
+ */
+struct perf_sample_id {
+	struct hlist_node 	node;
+	u64		 	id;
+	struct perf_evsel	*evsel;
+};
+
 struct perf_evsel {
 	struct list_head	node;
 	struct perf_event_attr	attr;
 	char			*filter;
 	struct xyarray		*fd;
-	struct xyarray		*mmap;
+	struct xyarray		*id;
 	struct perf_counts	*counts;
-	size_t			mmap_len;
 	int			idx;
 	void			*priv;
 };
@@ -44,9 +55,11 @@ struct perf_evsel *perf_evsel__new(struct perf_event_attr *attr, int idx);
 void perf_evsel__delete(struct perf_evsel *evsel);
 
 int perf_evsel__alloc_fd(struct perf_evsel *evsel, int ncpus, int nthreads);
+int perf_evsel__alloc_id(struct perf_evsel *evsel, int ncpus, int nthreads);
 int perf_evsel__alloc_counts(struct perf_evsel *evsel, int ncpus);
-int perf_evsel__alloc_mmap(struct perf_evsel *evsel, int ncpus, int nthreads);
+int perf_evlist__alloc_mmap(struct perf_evlist *evlist, int ncpus);
 void perf_evsel__free_fd(struct perf_evsel *evsel);
+void perf_evsel__free_id(struct perf_evsel *evsel);
 void perf_evsel__close_fd(struct perf_evsel *evsel, int ncpus, int nthreads);
 
 int perf_evsel__open_per_cpu(struct perf_evsel *evsel,
@@ -55,10 +68,9 @@ int perf_evsel__open_per_thread(struct perf_evsel *evsel,
 				struct thread_map *threads, bool group, bool inherit);
 int perf_evsel__open(struct perf_evsel *evsel, struct cpu_map *cpus,
 		     struct thread_map *threads, bool group, bool inherit);
-int perf_evsel__mmap(struct perf_evsel *evsel, struct cpu_map *cpus,
-		     struct thread_map *threads, int pages,
-		     struct perf_evlist *evlist);
-void perf_evsel__munmap(struct perf_evsel *evsel, int ncpus, int nthreads);
+int perf_evlist__mmap(struct perf_evlist *evlist, struct cpu_map *cpus,
+		      struct thread_map *threads, int pages, bool overwrite);
+void perf_evlist__munmap(struct perf_evlist *evlist, int ncpus);
 
 #define perf_evsel__match(evsel, t, c)		\
 	(evsel->attr.type == PERF_TYPE_##t &&	\
-- 
1.6.2.5

