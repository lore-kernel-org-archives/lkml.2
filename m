Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754149Ab1AUPIE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 10:08:04 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:58506 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753804Ab1AUPIA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 10:08:00 -0500
From: Borislav Petkov <bp@amd64.org>
To: <peterz@infradead.org>, <mingo@elte.hu>
Cc: <tony.luck@intel.com>, <acme@infradead.org>, <rostedt@goodmis.org>,
        <fweisbec@gmail.com>, <linux-edac@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 08/12] perf: Carve out mmap helpers for general use
Date: Fri, 21 Jan 2011 16:09:31 +0100
Message-Id: <1295622575-18607-9-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.4.rc2
In-Reply-To: <1295622575-18607-1-git-send-email-bp@amd64.org>
References: <1295622575-18607-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Export the mmap_read* helpers into tools/lib/perf/mmap.[ch]

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 tools/Makefile              |    8 +++-
 tools/lib/perf/Makefile     |   35 +++++++++++++++
 tools/lib/perf/mmap.c       |   91 ++++++++++++++++++++++++++++++++++++++
 tools/lib/perf/mmap.h       |   13 +++++
 tools/perf/Makefile         |    2 +-
 tools/perf/builtin-record.c |  103 ++++---------------------------------------
 tools/perf/builtin-top.c    |   25 ++--------
 7 files changed, 160 insertions(+), 117 deletions(-)
 create mode 100644 tools/lib/perf/Makefile
 create mode 100644 tools/lib/perf/mmap.c
 create mode 100644 tools/lib/perf/mmap.h

diff --git a/tools/Makefile b/tools/Makefile
index 779b141..71dce04 100644
--- a/tools/Makefile
+++ b/tools/Makefile
@@ -3,14 +3,14 @@ include scripts/Makefile.lib
 PERF_TOP_DIR := $(CURDIR)
 export PERF_TOP_DIR
 
-BASIC_CFLAGS = -I$(CURDIR)/lib
+BASIC_CFLAGS = -I$(CURDIR)/lib -I$(CURDIR)/perf
 
 # temporary for lib/trace/
 BASIC_CFLAGS += -I$(CURDIR)/perf/util/include
 
 export BASIC_CFLAGS
 
-perf: libtrace liblk .FORCE
+perf: libtrace liblk liblkperf .FORCE
 	$(QUIET_SUBDIR0)perf/ $(QUIET_SUBDIR1)
 
 libtrace: .FORCE
@@ -19,9 +19,13 @@ libtrace: .FORCE
 liblk: .FORCE
 	$(QUIET_SUBDIR0)lib/lk/ $(QUIET_SUBDIR1)
 
+liblkperf:
+	$(QUIET_SUBDIR0)lib/perf/ $(QUIET_SUBDIR1)
+
 clean:
 	$(QUIET_SUBDIR0)lib/trace/ $(QUIET_SUBDIR1) clean
 	$(QUIET_SUBDIR0)lib/lk/ $(QUIET_SUBDIR1) clean
+	$(QUIET_SUBDIR0)lib/perf/ $(QUIET_SUBDIR1) clean
 	$(QUIET_SUBDIR0)perf/ $(QUIET_SUBDIR1) clean
 
 
diff --git a/tools/lib/perf/Makefile b/tools/lib/perf/Makefile
new file mode 100644
index 0000000..2ae7e8d
--- /dev/null
+++ b/tools/lib/perf/Makefile
@@ -0,0 +1,35 @@
+include ../../scripts/Makefile.lib
+
+# guard against environment variables
+LIB_H=
+LIB_OBJS=
+
+LIB_H += mmap.h
+
+LIB_OBJS += mmap.o
+
+LIBFILE = $(LIB_OUTPUT)liblkperf.a
+
+CFLAGS = -ggdb3 -Wall -Wextra -std=gnu99 -Werror $(CFLAGS_OPTIMIZE) -D_FORTIFY_SOURCE=2 $(EXTRA_WARNINGS) $(EXTRA_CFLAGS)
+EXTLIBS = -lpthread -lrt -lelf -lm
+ALL_CFLAGS = $(CFLAGS) $(BASIC_CFLAGS) -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64
+ALL_LDFLAGS = $(LDFLAGS)
+
+RM = rm -f
+
+$(LIBFILE): $(LIB_OBJS)
+	$(QUIET_AR)$(RM) $@ && $(AR) rcs $@ $(LIB_OBJS)
+
+$(LIB_OBJS): $(LIB_H)
+
+%.o: %.c
+	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) $<
+%.s: %.c
+	$(QUIET_CC)$(CC) -S $(ALL_CFLAGS) $<
+%.o: %.S
+	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) $<
+
+clean:
+	$(RM) $(LIB_OBJS) $(LIBFILE)
+
+.PHONY: clean
diff --git a/tools/lib/perf/mmap.c b/tools/lib/perf/mmap.c
new file mode 100644
index 0000000..250148d
--- /dev/null
+++ b/tools/lib/perf/mmap.c
@@ -0,0 +1,91 @@
+#include <stdio.h>
+#include <perf.h>
+#include "mmap.h"
+
+unsigned long mmap_read_head(struct mmap_data *md)
+{
+	struct perf_event_mmap_page *pc = md->base;
+	long head;
+
+	head = pc->data_head;
+	rmb();
+
+	return head;
+}
+
+static void mmap_write_tail(struct mmap_data *md, unsigned long tail)
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
+static unsigned long mmap_read(struct mmap_data *md,
+			       void (*write_output)(void *, size_t))
+{
+	unsigned int head = mmap_read_head(md);
+	unsigned int old = md->prev;
+	unsigned int page_size = sysconf(_SC_PAGE_SIZE);
+	unsigned char *data = md->base + page_size;
+	unsigned long size, samples = 0;
+	void *buf;
+	int diff;
+
+	/*
+	 * If we're further behind than half the buffer, there's a chance
+	 * the writer will bite our tail and mess up the samples under us.
+	 *
+	 * If we somehow ended up ahead of the head, we got messed up.
+	 *
+	 * In either case, truncate and restart at head.
+	 */
+	diff = head - old;
+	if (diff < 0) {
+		fprintf(stderr, "WARNING: failed to keep up with mmap data\n");
+		/*
+		 * head points to a known good entry, start there.
+		 */
+		old = head;
+	}
+
+	if (old != head)
+		samples++;
+
+	size = head - old;
+
+	if ((old & md->mask) + size != (head & md->mask)) {
+		buf = &data[old & md->mask];
+		size = md->mask + 1 - (old & md->mask);
+		old += size;
+
+		write_output(buf, size);
+	}
+
+	buf = &data[old & md->mask];
+	size = head - old;
+	old += size;
+
+	write_output(buf, size);
+
+	md->prev = old;
+	mmap_write_tail(md, old);
+
+	return samples;
+}
+
+unsigned long mmap_read_all(struct mmap_data *mmap_array, int nr_cpus,
+			    void (*write_output)(void *, size_t))
+{
+	int i;
+	unsigned long samples = 0;
+
+	for (i = 0; i < nr_cpus; i++) {
+		if (mmap_array[i].base)
+			samples += mmap_read(&mmap_array[i], write_output);
+	}
+	return samples;
+}
diff --git a/tools/lib/perf/mmap.h b/tools/lib/perf/mmap.h
new file mode 100644
index 0000000..e2f30ef
--- /dev/null
+++ b/tools/lib/perf/mmap.h
@@ -0,0 +1,13 @@
+#ifndef __PERF_MMAP_H
+#define __PERF_MMAP_H
+
+struct mmap_data {
+	void			*base;
+	unsigned int		mask;
+	unsigned int		prev;
+};
+
+unsigned long mmap_read_head(struct mmap_data *);
+unsigned long mmap_read_all(struct mmap_data *, int,
+			    void (*write_output)(void *, size_t));
+#endif /* __PERF_MMAP_H */
diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index b27c1fe..bab175d 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -326,7 +326,7 @@ export PERL_PATH
 
 LIB_FILE=$(OUTPUT)libperf.a
 
-EXTRA_LIBS=$(LIB_OUTPUT)libtrace.a $(LIB_OUTPUT)liblk.a
+EXTRA_LIBS=$(LIB_OUTPUT)libtrace.a $(LIB_OUTPUT)liblk.a $(LIB_OUTPUT)liblkperf.a
 
 LIB_H += ../../include/linux/perf_event.h
 LIB_H += ../../include/linux/rbtree.h
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index d19b25b..17d7217 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -12,7 +12,6 @@
 #include "perf.h"
 
 #include "util/build-id.h"
-#include <lk/util.h>
 #include "util/parse-options.h"
 #include "util/parse-events.h"
 
@@ -24,6 +23,9 @@
 #include "util/symbol.h"
 #include "util/cpumap.h"
 
+#include <lk/util.h>
+#include <perf/mmap.h>
+
 #include <unistd.h>
 #include <sched.h>
 #include <sys/mman.h>
@@ -66,7 +68,7 @@ static bool			sample_time			=  false;
 static bool			no_buildid			=  false;
 static bool			no_buildid_cache		=  false;
 
-static long			samples				=      0;
+static unsigned long		samples				=      0;
 static u64			bytes_written			=      0;
 
 static struct pollfd		*event_array;
@@ -80,36 +82,8 @@ static off_t			post_processing_offset;
 static struct perf_session	*session;
 static const char		*cpu_list;
 
-struct mmap_data {
-	void			*base;
-	unsigned int		mask;
-	unsigned int		prev;
-};
-
 static struct mmap_data		mmap_array[MAX_NR_CPUS];
 
-static unsigned long mmap_read_head(struct mmap_data *md)
-{
-	struct perf_event_mmap_page *pc = md->base;
-	long head;
-
-	head = pc->data_head;
-	rmb();
-
-	return head;
-}
-
-static void mmap_write_tail(struct mmap_data *md, unsigned long tail)
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
 static void advance_output(size_t size)
 {
 	bytes_written += size;
@@ -138,55 +112,6 @@ static int process_synthesized_event(event_t *event,
 	return 0;
 }
 
-static void mmap_read(struct mmap_data *md)
-{
-	unsigned int head = mmap_read_head(md);
-	unsigned int old = md->prev;
-	unsigned char *data = md->base + page_size;
-	unsigned long size;
-	void *buf;
-	int diff;
-
-	/*
-	 * If we're further behind than half the buffer, there's a chance
-	 * the writer will bite our tail and mess up the samples under us.
-	 *
-	 * If we somehow ended up ahead of the head, we got messed up.
-	 *
-	 * In either case, truncate and restart at head.
-	 */
-	diff = head - old;
-	if (diff < 0) {
-		fprintf(stderr, "WARNING: failed to keep up with mmap data\n");
-		/*
-		 * head points to a known good entry, start there.
-		 */
-		old = head;
-	}
-
-	if (old != head)
-		samples++;
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
-	mmap_write_tail(md, old);
-}
-
 static volatile int done = 0;
 static volatile int signr = -1;
 
@@ -522,19 +447,6 @@ static struct perf_event_header finished_round_event = {
 	.type = PERF_RECORD_FINISHED_ROUND,
 };
 
-static void mmap_read_all(void)
-{
-	int i;
-
-	for (i = 0; i < nr_cpu; i++) {
-		if (mmap_array[i].base)
-			mmap_read(&mmap_array[i]);
-	}
-
-	if (perf_header__has_feat(&session->header, HEADER_TRACE_INFO))
-		write_output(&finished_round_event, sizeof(finished_round_event));
-}
-
 static int __cmd_record(int argc, const char **argv)
 {
 	int i;
@@ -774,10 +686,13 @@ static int __cmd_record(int argc, const char **argv)
 		close(go_pipe[1]);
 
 	for (;;) {
-		int hits = samples;
+		unsigned long hits = samples;
 		int thread;
 
-		mmap_read_all();
+		samples = mmap_read_all(mmap_array, nr_cpu, write_output);
+
+		if (perf_header__has_feat(&session->header, HEADER_TRACE_INFO))
+			write_output(&finished_round_event, sizeof(finished_round_event));
 
 		if (hits == samples) {
 			if (done)
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index e9ed062..703899b 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -25,8 +25,6 @@
 #include "util/session.h"
 #include "util/symbol.h"
 #include "util/thread.h"
-#include <lk/util.h>
-#include <linux/rbtree.h>
 #include "util/parse-options.h"
 #include "util/parse-events.h"
 #include "util/cpumap.h"
@@ -34,6 +32,10 @@
 
 #include "util/debug.h"
 
+#include <linux/rbtree.h>
+#include <lk/util.h>
+#include <perf/mmap.h>
+
 #include <assert.h>
 #include <fcntl.h>
 
@@ -1091,12 +1093,6 @@ static void event__process_sample(const event_t *self,
 	}
 }
 
-struct mmap_data {
-	void			*base;
-	int			mask;
-	unsigned int		prev;
-};
-
 static int perf_evsel__alloc_mmap_per_thread(struct perf_evsel *evsel,
 					     int ncpus, int nthreads)
 {
@@ -1110,17 +1106,6 @@ static void perf_evsel__free_mmap(struct perf_evsel *evsel)
 	evsel->priv = NULL;
 }
 
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
@@ -1142,7 +1127,7 @@ static void perf_session__mmap_read_counter(struct perf_session *self,
 	 * In either case, truncate and restart at head.
 	 */
 	diff = head - old;
-	if (diff > md->mask / 2 || diff < 0) {
+	if ((unsigned int)diff > md->mask / 2 || diff < 0) {
 		fprintf(stderr, "WARNING: failed to keep up with mmap data.\n");
 
 		/*
-- 
1.7.4.rc2

