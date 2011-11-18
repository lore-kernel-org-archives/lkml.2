Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757999Ab1KRNr2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 08:47:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:14680 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757205Ab1KRNrM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 08:47:12 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 3/5] perf tool: Introducing perf_mmap object
Date: Fri, 18 Nov 2011 14:46:43 +0100
Message-Id: <1321624005-6889-4-git-send-email-jolsa@redhat.com>
In-Reply-To: <1321624005-6889-1-git-send-email-jolsa@redhat.com>
References: <1321624005-6889-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding perf_mmap object to handle event memory maps.

All the memory map related functions originally scatered through
the whole code arenow place in perf_mmap object.

To map and unmap perf_mmap:
	perf_mmap__open
	perf_mmap__close

For reading events via callback:
	perf_mmap__process

For reading events directly:
	perf_mmap__read

following helpers were moved in from perf.h:
	perf_mmap__read_head
	perf_mmap__write_tail

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/Makefile         |    2 +
 tools/perf/builtin-record.c |   57 ++++-------------
 tools/perf/builtin-test.c   |    6 ++-
 tools/perf/builtin-top.c    |   19 ++++--
 tools/perf/perf.h           |   26 --------
 tools/perf/util/evlist.c    |  117 +++++++-----------------------------
 tools/perf/util/evlist.h    |    2 +-
 tools/perf/util/mmap.c      |  138 +++++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/mmap.h      |   45 ++++++++++++++
 9 files changed, 239 insertions(+), 173 deletions(-)
 create mode 100644 tools/perf/util/mmap.c
 create mode 100644 tools/perf/util/mmap.h

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index b98e307..0158b66 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -274,6 +274,7 @@ LIB_H += util/xyarray.h
 LIB_H += util/header.h
 LIB_H += util/help.h
 LIB_H += util/session.h
+LIB_H += util/mmap.h
 LIB_H += util/strbuf.h
 LIB_H += util/strlist.h
 LIB_H += util/strfilter.h
@@ -337,6 +338,7 @@ LIB_OBJS += $(OUTPUT)util/debug.o
 LIB_OBJS += $(OUTPUT)util/map.o
 LIB_OBJS += $(OUTPUT)util/pstack.o
 LIB_OBJS += $(OUTPUT)util/session.o
+LIB_OBJS += $(OUTPUT)util/mmap.o
 LIB_OBJS += $(OUTPUT)util/thread.o
 LIB_OBJS += $(OUTPUT)util/thread_map.o
 LIB_OBJS += $(OUTPUT)util/trace-event-parse.o
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 1132e70..89b3dc2 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -25,6 +25,7 @@
 #include "util/symbol.h"
 #include "util/cpumap.h"
 #include "util/thread_map.h"
+#include "util/mmap.h"
 
 #include <unistd.h>
 #include <sched.h>
@@ -65,7 +66,6 @@ static bool			no_buildid			=  false;
 static bool			no_buildid_cache		=  false;
 static struct perf_evlist	*evsel_list;
 
-static long			samples				=      0;
 static u64			bytes_written			=      0;
 
 static int			file_new			=      1;
@@ -103,39 +103,6 @@ static int process_synthesized_event(union perf_event *event,
 	return 0;
 }
 
-static void mmap_read(struct perf_mmap *md)
-{
-	unsigned int head = perf_mmap__read_head(md);
-	unsigned int old = md->prev;
-	unsigned char *data = md->base + page_size;
-	unsigned long size;
-	void *buf;
-
-	if (old == head)
-		return;
-
-	samples++;
-
-	size = head - old;
-
-	if ((old & md->mask) + size != (head & md->mask)) {
-		buf = &data[old & md->mask];
-		size = md->mask + 1 - (old & md->mask);
-		old += size;
-
-		write_output(buf, size);
-	}
-
-	buf = &data[old & md->mask];
-	size = head - old;
-	old += size;
-
-	write_output(buf, size);
-
-	md->prev = old;
-	perf_mmap__write_tail(md, old);
-}
-
 static volatile int done = 0;
 static volatile int signr = -1;
 static volatile int child_finished = 0;
@@ -442,17 +409,25 @@ static struct perf_event_header finished_round_event = {
 	.type = PERF_RECORD_FINISHED_ROUND,
 };
 
-static void mmap_read_all(void)
+static void mmap_read(struct perf_mmap *m __used, void *buf, unsigned long size)
+{
+	write_output(buf, size);
+}
+
+static int mmap_read_all(void)
 {
-	int i;
+	int i, ret = 0;
 
 	for (i = 0; i < evsel_list->nr_mmaps; i++) {
-		if (evsel_list->mmap[i].base)
-			mmap_read(&evsel_list->mmap[i]);
+		struct perf_mmap *m = &evsel_list->mmap[i];
+		if (m->base)
+			ret += perf_mmap__process(m, mmap_read);
 	}
 
 	if (perf_header__has_feat(&session->header, HEADER_TRACE_INFO))
 		write_output(&finished_round_event, sizeof(finished_round_event));
+
+	return ret;
 }
 
 static int __cmd_record(int argc, const char **argv)
@@ -712,11 +687,7 @@ static int __cmd_record(int argc, const char **argv)
 		close(go_pipe[1]);
 
 	for (;;) {
-		int hits = samples;
-
-		mmap_read_all();
-
-		if (hits == samples) {
+		if (!mmap_read_all()) {
 			if (done)
 				break;
 			err = poll(evsel_list->pollfd, evsel_list->nr_fds, -1);
diff --git a/tools/perf/builtin-test.c b/tools/perf/builtin-test.c
index 831d1ba..feb3218 100644
--- a/tools/perf/builtin-test.c
+++ b/tools/perf/builtin-test.c
@@ -12,6 +12,7 @@
 #include "util/parse-events.h"
 #include "util/symbol.h"
 #include "util/thread_map.h"
+#include "util/mmap.h"
 #include "../../include/linux/hw_breakpoint.h"
 
 static long page_size;
@@ -476,6 +477,7 @@ static int test__basic_mmap(void)
 		     expected_nr_events[nsyscalls], i, j;
 	struct perf_evsel *evsels[nsyscalls], *evsel;
 	int sample_size = __perf_evsel__sample_size(attr.sample_type);
+	struct perf_mmap *md;
 
 	for (i = 0; i < nsyscalls; ++i) {
 		char name[64];
@@ -551,7 +553,9 @@ static int test__basic_mmap(void)
 			++foo;
 		}
 
-	while ((event = perf_evlist__mmap_read(evlist, 0)) != NULL) {
+	md = &evlist->mmap[0];
+
+	while ((event = perf_mmap__read(md)) != NULL) {
 		struct perf_sample sample;
 
 		if (event->header.type != PERF_RECORD_SAMPLE) {
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 8e02027..032f70d 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -38,6 +38,7 @@
 #include "util/cpumap.h"
 #include "util/xyarray.h"
 #include "util/sort.h"
+#include "util/mmap.h"
 
 #include "util/debug.h"
 
@@ -804,14 +805,16 @@ static void perf_event__process_sample(const union perf_event *event,
 	return;
 }
 
-static void perf_session__mmap_read_idx(struct perf_session *self, int idx)
+static void session_mmap_read(struct perf_session *self,
+			      struct perf_mmap *md)
 {
-	struct perf_sample sample;
-	struct perf_evsel *evsel;
 	union perf_event *event;
-	int ret;
 
-	while ((event = perf_evlist__mmap_read(top.evlist, idx)) != NULL) {
+	while ((event = perf_mmap__read(md)) != NULL) {
+		struct perf_sample sample;
+		struct perf_evsel *evsel;
+		int ret;
+
 		ret = perf_session__parse_sample(self, event, &sample);
 		if (ret) {
 			pr_err("Can't parse sample, err = %d\n", ret);
@@ -835,8 +838,10 @@ static void perf_session__mmap_read(struct perf_session *self)
 {
 	int i;
 
-	for (i = 0; i < top.evlist->nr_mmaps; i++)
-		perf_session__mmap_read_idx(self, i);
+	for (i = 0; i < top.evlist->nr_mmaps; i++) {
+		struct perf_mmap *md = &top.evlist->mmap[i];
+		session_mmap_read(self, md);
+	}
 }
 
 static void start_counters(struct perf_evlist *evlist)
diff --git a/tools/perf/perf.h b/tools/perf/perf.h
index 914c895..d79efbb 100644
--- a/tools/perf/perf.h
+++ b/tools/perf/perf.h
@@ -104,32 +104,6 @@ void get_term_dimensions(struct winsize *ws);
 #include "util/types.h"
 #include <stdbool.h>
 
-struct perf_mmap {
-	void			*base;
-	int			mask;
-	unsigned int		prev;
-};
-
-static inline unsigned int perf_mmap__read_head(struct perf_mmap *mm)
-{
-	struct perf_event_mmap_page *pc = mm->base;
-	int head = pc->data_head;
-	rmb();
-	return head;
-}
-
-static inline void perf_mmap__write_tail(struct perf_mmap *md,
-					 unsigned long tail)
-{
-	struct perf_event_mmap_page *pc = md->base;
-
-	/*
-	 * ensure all reads are done before we write the tail out.
-	 */
-	/* mb(); */
-	pc->data_tail = tail;
-}
-
 /*
  * prctl(PR_TASK_PERF_EVENTS_DISABLE) will (cheaply) disable all
  * counters in the current task.
diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 0f715d0..2237833 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -12,6 +12,7 @@
 #include "evlist.h"
 #include "evsel.h"
 #include "util.h"
+#include "mmap.h"
 
 #include <sys/mman.h>
 
@@ -200,82 +201,14 @@ struct perf_evsel *perf_evlist__id2evsel(struct perf_evlist *evlist, u64 id)
 	return NULL;
 }
 
-union perf_event *perf_evlist__mmap_read(struct perf_evlist *evlist, int idx)
-{
-	/* XXX Move this to perf.c, making it generally available */
-	unsigned int page_size = sysconf(_SC_PAGE_SIZE);
-	struct perf_mmap *md = &evlist->mmap[idx];
-	unsigned int head = perf_mmap__read_head(md);
-	unsigned int old = md->prev;
-	unsigned char *data = md->base + page_size;
-	union perf_event *event = NULL;
-
-	if (evlist->overwrite) {
-		/*
-		 * If we're further behind than half the buffer, there's a chance
-		 * the writer will bite our tail and mess up the samples under us.
-		 *
-		 * If we somehow ended up ahead of the head, we got messed up.
-		 *
-		 * In either case, truncate and restart at head.
-		 */
-		int diff = head - old;
-		if (diff > md->mask / 2 || diff < 0) {
-			fprintf(stderr, "WARNING: failed to keep up with mmap data.\n");
-
-			/*
-			 * head points to a known good entry, start there.
-			 */
-			old = head;
-		}
-	}
-
-	if (old != head) {
-		size_t size;
-
-		event = (union perf_event *)&data[old & md->mask];
-		size = event->header.size;
-
-		/*
-		 * Event straddles the mmap boundary -- header should always
-		 * be inside due to u64 alignment of output.
-		 */
-		if ((old & md->mask) + size != ((old + size) & md->mask)) {
-			unsigned int offset = old;
-			unsigned int len = min(sizeof(*event), size), cpy;
-			void *dst = &evlist->event_copy;
-
-			do {
-				cpy = min(md->mask + 1 - (offset & md->mask), len);
-				memcpy(dst, &data[offset & md->mask], cpy);
-				offset += cpy;
-				dst += cpy;
-				len -= cpy;
-			} while (len);
-
-			event = &evlist->event_copy;
-		}
-
-		old += size;
-	}
-
-	md->prev = old;
-
-	if (!evlist->overwrite)
-		perf_mmap__write_tail(md, old);
-
-	return event;
-}
-
 void perf_evlist__munmap(struct perf_evlist *evlist)
 {
 	int i;
 
 	for (i = 0; i < evlist->nr_mmaps; i++) {
-		if (evlist->mmap[i].base != NULL) {
-			munmap(evlist->mmap[i].base, evlist->mmap_len);
-			evlist->mmap[i].base = NULL;
-		}
+		struct perf_mmap *m = &evlist->mmap[i];
+		if (m->base != NULL)
+			perf_mmap__close(m);
 	}
 
 	free(evlist->mmap);
@@ -292,20 +225,18 @@ int perf_evlist__alloc_mmap(struct perf_evlist *evlist)
 }
 
 static int __perf_evlist__mmap(struct perf_evlist *evlist,
-			       int idx, int prot, int mask, int fd)
+			       int idx, int fd)
 {
-	evlist->mmap[idx].prev = 0;
-	evlist->mmap[idx].mask = mask;
-	evlist->mmap[idx].base = mmap(NULL, evlist->mmap_len, prot,
-				      MAP_SHARED, fd, 0);
-	if (evlist->mmap[idx].base == MAP_FAILED)
+	struct perf_mmap *m = &evlist->mmap[idx];
+
+	if (perf_mmap__open(m, fd, evlist->overwrite, evlist->pages))
 		return -1;
 
 	perf_evlist__add_pollfd(evlist, fd);
 	return 0;
 }
 
-static int perf_evlist__mmap_per_cpu(struct perf_evlist *evlist, int prot, int mask)
+static int perf_evlist__mmap_per_cpu(struct perf_evlist *evlist)
 {
 	struct perf_evsel *evsel;
 	int cpu, thread;
@@ -320,7 +251,7 @@ static int perf_evlist__mmap_per_cpu(struct perf_evlist *evlist, int prot, int m
 				if (output == -1) {
 					output = fd;
 					if (__perf_evlist__mmap(evlist, cpu,
-								prot, mask, output) < 0)
+								output) < 0)
 						goto out_unmap;
 				} else {
 					if (ioctl(fd, PERF_EVENT_IOC_SET_OUTPUT, output) != 0)
@@ -334,15 +265,14 @@ static int perf_evlist__mmap_per_cpu(struct perf_evlist *evlist, int prot, int m
 
 out_unmap:
 	for (cpu = 0; cpu < evlist->cpus->nr; cpu++) {
-		if (evlist->mmap[cpu].base != NULL) {
-			munmap(evlist->mmap[cpu].base, evlist->mmap_len);
-			evlist->mmap[cpu].base = NULL;
-		}
+		struct perf_mmap *m = &evlist->mmap[cpu];
+		if (m->base != NULL)
+			perf_mmap__close(m);
 	}
 	return -1;
 }
 
-static int perf_evlist__mmap_per_thread(struct perf_evlist *evlist, int prot, int mask)
+static int perf_evlist__mmap_per_thread(struct perf_evlist *evlist)
 {
 	struct perf_evsel *evsel;
 	int thread;
@@ -356,7 +286,7 @@ static int perf_evlist__mmap_per_thread(struct perf_evlist *evlist, int prot, in
 			if (output == -1) {
 				output = fd;
 				if (__perf_evlist__mmap(evlist, thread,
-							prot, mask, output) < 0)
+							output) < 0)
 					goto out_unmap;
 			} else {
 				if (ioctl(fd, PERF_EVENT_IOC_SET_OUTPUT, output) != 0)
@@ -369,10 +299,9 @@ static int perf_evlist__mmap_per_thread(struct perf_evlist *evlist, int prot, in
 
 out_unmap:
 	for (thread = 0; thread < evlist->threads->nr; thread++) {
-		if (evlist->mmap[thread].base != NULL) {
-			munmap(evlist->mmap[thread].base, evlist->mmap_len);
-			evlist->mmap[thread].base = NULL;
-		}
+		struct perf_mmap *m = &evlist->mmap[thread];
+		if (m->base != NULL)
+			perf_mmap__close(m);
 	}
 	return -1;
 }
@@ -421,10 +350,8 @@ static int perf_evlist__init_ids(struct perf_evlist *evlist)
  */
 int perf_evlist__mmap(struct perf_evlist *evlist, int pages, bool overwrite)
 {
-	unsigned int page_size = sysconf(_SC_PAGE_SIZE);
-	int mask = pages * page_size - 1, ret;
 	const struct cpu_map *cpus = evlist->cpus;
-	int prot = PROT_READ | (overwrite ? 0 : PROT_WRITE);
+	int ret;
 
 	if (evlist->mmap == NULL && perf_evlist__alloc_mmap(evlist) < 0)
 		return -ENOMEM;
@@ -433,16 +360,16 @@ int perf_evlist__mmap(struct perf_evlist *evlist, int pages, bool overwrite)
 		return -ENOMEM;
 
 	evlist->overwrite = overwrite;
-	evlist->mmap_len = (pages + 1) * page_size;
+	evlist->pages = pages;
 
 	ret = perf_evlist__init_ids(evlist);
 	if (ret)
 		return ret;
 
 	if (cpus->map[0] == -1)
-		return perf_evlist__mmap_per_thread(evlist, prot, mask);
+		return perf_evlist__mmap_per_thread(evlist);
 
-	return perf_evlist__mmap_per_cpu(evlist, prot, mask);
+	return perf_evlist__mmap_per_cpu(evlist);
 }
 
 int perf_evlist__create_maps(struct perf_evlist *evlist, pid_t target_pid,
diff --git a/tools/perf/util/evlist.h b/tools/perf/util/evlist.h
index 1779ffe..3784273 100644
--- a/tools/perf/util/evlist.h
+++ b/tools/perf/util/evlist.h
@@ -18,7 +18,7 @@ struct perf_evlist {
 	int		 nr_entries;
 	int		 nr_fds;
 	int		 nr_mmaps;
-	int		 mmap_len;
+	int		 pages;
 	bool		 overwrite;
 	union perf_event event_copy;
 	struct perf_mmap *mmap;
diff --git a/tools/perf/util/mmap.c b/tools/perf/util/mmap.c
new file mode 100644
index 0000000..45e62a2
--- /dev/null
+++ b/tools/perf/util/mmap.c
@@ -0,0 +1,138 @@
+#include <string.h>
+#include <stdio.h>
+#include "mmap.h"
+
+int perf_mmap__open(struct perf_mmap *m, int fd, bool overwrite, int pages)
+{
+	unsigned int page_size = sysconf(_SC_PAGE_SIZE);
+	int mask, len, prot;
+	void *base;
+
+	mask = pages * page_size - 1;
+	len  = (pages + 1) * page_size;
+	prot = PROT_READ | (overwrite ? 0 : PROT_WRITE);
+
+	base = mmap(NULL, len, prot, MAP_SHARED, fd, 0);
+	if (base == MAP_FAILED)
+		return -1;
+
+	memset(m, 0, sizeof(*m));
+	m->mask = mask;
+	m->len  = len;
+	m->base = base;
+	m->fd   = fd;
+	m->owrt = overwrite;
+	return 0;
+}
+
+int perf_mmap__close(struct perf_mmap *m)
+{
+	int ret = munmap(m->base, m->len);
+
+	memset(m, 0x0, sizeof(*m));
+	return ret;
+}
+
+int perf_mmap__process(struct perf_mmap *md, perf_mmap_process_t process)
+{
+	unsigned int head, old, page_size = sysconf(_SC_PAGE_SIZE);
+	unsigned char *data = md->base + page_size;
+	unsigned long size;
+	void *buf;
+
+	head = perf_mmap__read_head(md);
+	old  = md->prev;
+
+	if (old == head)
+		return 0;
+
+	size = head - old;
+
+	if ((old & md->mask) + size != (head & md->mask)) {
+		buf = &data[old & md->mask];
+		size = md->mask + 1 - (old & md->mask);
+		old += size;
+
+		process(md, buf, size);
+	}
+
+	buf = &data[old & md->mask];
+	size = head - old;
+	old += size;
+
+	process(md, buf, size);
+
+	md->prev = old;
+	perf_mmap__write_tail(md, old);
+	return 1;
+}
+
+union perf_event *perf_mmap__read(struct perf_mmap *md)
+{
+	unsigned int head, old, page_size = sysconf(_SC_PAGE_SIZE);
+	unsigned char *data = md->base + page_size;
+	union perf_event *event = NULL;
+
+	head = perf_mmap__read_head(md);
+	old = md->prev;
+
+	if (md->owrt) {
+		/*
+		 * If we're further behind than half the buffer, there's
+		 * a chance the writer will bite our tail and mess up the
+		 * samples under us.
+		 *
+		 * If we somehow ended up ahead of the head, we got messed up.
+		 *
+		 * In either case, truncate and restart at head.
+		 */
+		int diff = head - old;
+		if (diff > md->mask / 2 || diff < 0) {
+			fprintf(stderr, "WARNING: failed to keep up "
+					"with mmap data.\n");
+
+			/*
+			 * head points to a known good entry, start there.
+			 */
+			old = head;
+		}
+	}
+
+	if (old != head) {
+		size_t size;
+
+		event = (union perf_event *)&data[old & md->mask];
+		size = event->header.size;
+
+		/*
+		 * Event straddles the mmap boundary -- header should always
+		 * be inside due to u64 alignment of output.
+		 */
+		if ((old & md->mask) + size != ((old + size) & md->mask)) {
+			unsigned int offset = old;
+			unsigned int len = min(sizeof(*event), size), cpy;
+			static union perf_event event_copy;
+			void *dst = &event_copy;
+
+			do {
+				cpy = min(md->mask + 1 - (offset & md->mask),
+					  len);
+				memcpy(dst, &data[offset & md->mask], cpy);
+				offset += cpy;
+				dst += cpy;
+				len -= cpy;
+			} while (len);
+
+			event = &event_copy;
+		}
+
+		old += size;
+	}
+
+	md->prev = old;
+
+	if (!md->owrt)
+		perf_mmap__write_tail(md, old);
+
+	return event;
+}
diff --git a/tools/perf/util/mmap.h b/tools/perf/util/mmap.h
new file mode 100644
index 0000000..24cf88f
--- /dev/null
+++ b/tools/perf/util/mmap.h
@@ -0,0 +1,45 @@
+#ifndef __PERF_MMAP_H
+#define __PERF_MMAP_H
+
+#include <sys/mman.h>
+#include "event.h"
+#include "../perf.h"
+
+struct perf_mmap {
+	void  *base;
+	int   mask;
+	u_int prev;
+	int   len;
+	int   fd;
+	bool  owrt;
+};
+
+typedef void (*perf_mmap_process_t)(struct perf_mmap *m,
+				    void *buf, unsigned long size);
+
+int perf_mmap__open(struct perf_mmap *m, int fd, bool overwrite, int pages);
+int perf_mmap__close(struct perf_mmap *m);
+int perf_mmap__process(struct perf_mmap *m, perf_mmap_process_t process);
+union perf_event *perf_mmap__read(struct perf_mmap *md);
+
+static inline unsigned int perf_mmap__read_head(struct perf_mmap *mm)
+{
+	struct perf_event_mmap_page *pc = mm->base;
+	int head = pc->data_head;
+	rmb();
+	return head;
+}
+
+static inline void perf_mmap__write_tail(struct perf_mmap *md,
+					 unsigned long tail)
+{
+	struct perf_event_mmap_page *pc = md->base;
+
+	/*
+	 * ensure all reads are done before we write the tail out.
+	 */
+	/* mb(); */
+	pc->data_tail = tail;
+}
+
+#endif /* __PERF_MMAP_H */
-- 
1.7.4

