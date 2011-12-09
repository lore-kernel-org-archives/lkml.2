Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753084Ab1LIRbF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 12:31:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:19077 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752972Ab1LIRbB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 12:31:01 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 3/4] perf, tool: Introducing perf_mmap object
Date: Fri,  9 Dec 2011 18:30:37 +0100
Message-Id: <1323451838-23081-4-git-send-email-jolsa@redhat.com>
In-Reply-To: <1323451838-23081-1-git-send-email-jolsa@redhat.com>
References: <1323451838-23081-1-git-send-email-jolsa@redhat.com>
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
 tools/perf/Makefile         |    3 +
 tools/perf/builtin-record.c |   63 +++++---------------
 tools/perf/perf.h           |   26 --------
 tools/perf/util/evlist.c    |   88 +++------------------------
 tools/perf/util/mmap.c      |  140 +++++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/mmap.h      |   49 +++++++++++++++
 tools/perf/util/setup.py    |    2 +-
 7 files changed, 216 insertions(+), 155 deletions(-)
 create mode 100644 tools/perf/util/mmap.c
 create mode 100644 tools/perf/util/mmap.h

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index ac86d67..1e63246 100644
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
@@ -338,6 +339,7 @@ LIB_OBJS += $(OUTPUT)util/debug.o
 LIB_OBJS += $(OUTPUT)util/map.o
 LIB_OBJS += $(OUTPUT)util/pstack.o
 LIB_OBJS += $(OUTPUT)util/session.o
+LIB_OBJS += $(OUTPUT)util/mmap.o
 LIB_OBJS += $(OUTPUT)util/thread.o
 LIB_OBJS += $(OUTPUT)util/thread_map.o
 LIB_OBJS += $(OUTPUT)util/trace-event-parse.o
@@ -400,6 +402,7 @@ PYRF_OBJS += $(OUTPUT)util/python.o
 PYRF_OBJS += $(OUTPUT)util/thread_map.o
 PYRF_OBJS += $(OUTPUT)util/util.o
 PYRF_OBJS += $(OUTPUT)util/xyarray.o
+PYRF_OBJS += $(OUTPUT)util/mmap.o
 
 #
 # Platform specific tweaks
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 766fa0a..b58f94d 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -26,6 +26,7 @@
 #include "util/symbol.h"
 #include "util/cpumap.h"
 #include "util/thread_map.h"
+#include "util/mmap.h"
 
 #include <unistd.h>
 #include <sched.h>
@@ -45,7 +46,6 @@ struct perf_record {
 	struct perf_session	*session;
 	const char		*progname;
 	int			output;
-	unsigned int		page_size;
 	int			realtime_prio;
 	enum write_mode_t	write_mode;
 	bool			no_buildid;
@@ -53,7 +53,6 @@ struct perf_record {
 	bool			force;
 	bool			file_new;
 	bool			append_file;
-	long			samples;
 	off_t			post_processing_offset;
 };
 
@@ -87,40 +86,6 @@ static int process_synthesized_event(struct perf_tool *tool,
 	return 0;
 }
 
-static void perf_record__mmap_read(struct perf_record *rec,
-				   struct perf_mmap *md)
-{
-	unsigned int head = perf_mmap__read_head(md);
-	unsigned int old = md->prev;
-	unsigned char *data = md->base + rec->page_size;
-	unsigned long size;
-	void *buf;
-
-	if (old == head)
-		return;
-
-	rec->samples++;
-
-	size = head - old;
-
-	if ((old & md->mask) + size != (head & md->mask)) {
-		buf = &data[old & md->mask];
-		size = md->mask + 1 - (old & md->mask);
-		old += size;
-
-		write_output(rec, buf, size);
-	}
-
-	buf = &data[old & md->mask];
-	size = head - old;
-	old += size;
-
-	write_output(rec, buf, size);
-
-	md->prev = old;
-	perf_mmap__write_tail(md, old);
-}
-
 static volatile int done = 0;
 static volatile int signr = -1;
 static volatile int child_finished = 0;
@@ -358,17 +323,25 @@ static struct perf_event_header finished_round_event = {
 	.type = PERF_RECORD_FINISHED_ROUND,
 };
 
-static void perf_record__mmap_read_all(struct perf_record *rec)
+static void mmap_read(struct perf_mmap *m __used, void *buf, unsigned long size,
+		      void *user)
+{
+	write_output(user, buf, size);
+}
+
+static int perf_record__mmap_read_all(struct perf_record *rec)
 {
-	int i;
+	int i, ret = 0;
 
 	for (i = 0; i < rec->evlist->nr_mmaps; i++) {
-		if (rec->evlist->mmap[i].base)
-			perf_record__mmap_read(rec, &rec->evlist->mmap[i]);
+		struct perf_mmap *pm = &rec->evlist->mmap[i];
+		ret += perf_mmap__process(pm, mmap_read, rec);
 	}
 
-	if (perf_header__has_feat(&rec->session->header, HEADER_TRACE_INFO))
+	if (ret && perf_header__has_feat(&rec->session->header, HEADER_TRACE_INFO))
 		write_output(rec, &finished_round_event, sizeof(finished_round_event));
+
+	return ret;
 }
 
 static int __cmd_record(struct perf_record *rec, int argc, const char **argv)
@@ -387,8 +360,6 @@ static int __cmd_record(struct perf_record *rec, int argc, const char **argv)
 
 	rec->progname = argv[0];
 
-	rec->page_size = sysconf(_SC_PAGE_SIZE);
-
 	on_exit(perf_record__sig_exit, rec);
 	signal(SIGCHLD, sig_handler);
 	signal(SIGINT, sig_handler);
@@ -583,11 +554,7 @@ static int __cmd_record(struct perf_record *rec, int argc, const char **argv)
 		perf_evlist__start_workload(evsel_list);
 
 	for (;;) {
-		int hits = rec->samples;
-
-		perf_record__mmap_read_all(rec);
-
-		if (hits == rec->samples) {
+		if (!perf_record__mmap_read_all(rec)) {
 			if (done)
 				break;
 			err = poll(evsel_list->pollfd, evsel_list->nr_fds, -1);
diff --git a/tools/perf/perf.h b/tools/perf/perf.h
index ea804f5..dd8b35c 100644
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
index 56f1d34..b27ed53 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -13,6 +13,7 @@
 #include "thread_map.h"
 #include "evlist.h"
 #include "evsel.h"
+#include "mmap.h"
 #include <unistd.h>
 
 #include "parse-events.h"
@@ -351,69 +352,8 @@ struct perf_evsel *perf_evlist__id2evsel(struct perf_evlist *evlist, u64 id)
 
 union perf_event *perf_evlist__mmap_read(struct perf_evlist *evlist, int idx)
 {
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
+	struct perf_mmap *m = &evlist->mmap[idx];
+	return perf_mmap__read(m, &evlist->event_copy);
 }
 
 static void __perf_evlist__munmap(struct perf_evlist *evlist)
@@ -421,10 +361,9 @@ static void __perf_evlist__munmap(struct perf_evlist *evlist)
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
 }
 
@@ -446,22 +385,11 @@ static int perf_evlist__alloc_mmap(struct perf_evlist *evlist)
 
 static int __perf_evlist__mmap(struct perf_evlist *evlist, int idx, int fd)
 {
-	unsigned int page_size = sysconf(_SC_PAGE_SIZE);
-	int mask, len, prot;
-	void *base;
+	struct perf_mmap *m = &evlist->mmap[idx];
 
-	mask = evlist->pages * page_size - 1;
-	len  = (evlist->pages + 1) * page_size;
-	prot = PROT_READ | (evlist->overwrite ? 0 : PROT_WRITE);
-
-	base = mmap(NULL, len, prot, MAP_SHARED, fd, 0);
-	if (base == MAP_FAILED)
+	if (perf_mmap__open(m, fd, evlist->overwrite, evlist->pages))
 		return -1;
 
-	evlist->mmap[idx].prev = 0;
-	evlist->mmap[idx].mask = mask;
-	evlist->mmap[idx].base = base;
-
 	perf_evlist__add_pollfd(evlist, fd);
 	return 0;
 }
diff --git a/tools/perf/util/mmap.c b/tools/perf/util/mmap.c
new file mode 100644
index 0000000..4d129a9
--- /dev/null
+++ b/tools/perf/util/mmap.c
@@ -0,0 +1,140 @@
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
+	m->page_size = page_size;
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
+int perf_mmap__process(struct perf_mmap *md, perf_mmap_process_t process,
+		       void *user)
+{
+	unsigned int head, old;
+	unsigned char *data = md->base + md->page_size;
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
+		process(md, buf, size, user);
+	}
+
+	buf = &data[old & md->mask];
+	size = head - old;
+	old += size;
+
+	process(md, buf, size, user);
+
+	md->prev = old;
+	perf_mmap__write_tail(md, old);
+	return 1;
+}
+
+union perf_event *perf_mmap__read(struct perf_mmap *md,
+				  union perf_event *event_copy)
+{
+	unsigned int head, old;
+	unsigned char *data = md->base + md->page_size;
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
+			void *dst = event_copy;
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
+			event = event_copy;
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
index 0000000..8b00b5e
--- /dev/null
+++ b/tools/perf/util/mmap.h
@@ -0,0 +1,49 @@
+#ifndef __PERF_MMAP_H
+#define __PERF_MMAP_H
+
+#include <sys/mman.h>
+#include "event.h"
+#include "../perf.h"
+
+struct perf_mmap {
+	void  *base;
+	u_int  prev;
+	bool   owrt;
+	int    page_size;
+	int    fd;
+	int    mask;
+	int    len;
+};
+
+typedef void (*perf_mmap_process_t)(struct perf_mmap *m,
+				    void *buf, unsigned long size,
+				    void *user);
+
+int perf_mmap__open(struct perf_mmap *m, int fd, bool overwrite, int pages);
+int perf_mmap__close(struct perf_mmap *m);
+int perf_mmap__process(struct perf_mmap *m, perf_mmap_process_t process,
+		       void *user);
+union perf_event *perf_mmap__read(struct perf_mmap *md,
+				  union perf_event *event_copy);
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
diff --git a/tools/perf/util/setup.py b/tools/perf/util/setup.py
index 36d4c56..f7f7b12 100644
--- a/tools/perf/util/setup.py
+++ b/tools/perf/util/setup.py
@@ -28,7 +28,7 @@ perf = Extension('perf',
 		  sources = ['util/python.c', 'util/ctype.c', 'util/evlist.c',
 			     'util/evsel.c', 'util/cpumap.c', 'util/thread_map.c',
 			     'util/util.c', 'util/xyarray.c', 'util/cgroup.c',
-			     'util/debugfs.c'],
+			     'util/debugfs.c', 'util/mmap.c' ],
 		  include_dirs = ['util/include'],
 		  extra_compile_args = cflags,
                  )
-- 
1.7.4

