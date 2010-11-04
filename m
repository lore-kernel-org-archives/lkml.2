Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752826Ab0KDPj2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 11:39:28 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:41973 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752788Ab0KDPjV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 11:39:21 -0400
From: Borislav Petkov <bp@amd64.org>
To: <acme@infradead.org>, <fweisbec@gmail.com>, <mingo@elte.hu>,
        <peterz@infradead.org>, <rostedt@goodmis.org>
Cc: <linux-kernel@vger.kernel.org>, Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 09/20] perf: Carve out mmap helpers for general use
Date: Thu,  4 Nov 2010 16:36:45 +0100
Message-Id: <1288885016-18295-10-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.3.1.50.g1e633
In-Reply-To: <1288885016-18295-1-git-send-email-bp@amd64.org>
References: <1288885016-18295-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Export the mmap_read* helpers into tools/lib/perf/mmap.[ch]

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 tools/Makefile              |    6 ++-
 tools/lib/perf/Makefile     |   35 ++++++++++++++
 tools/lib/perf/mmap.c       |   95 ++++++++++++++++++++++++++++++++++++++
 tools/lib/perf/mmap.h       |   15 ++++++
 tools/perf/Makefile         |    2 +-
 tools/perf/builtin-record.c |  107 ++++---------------------------------------
 tools/perf/builtin-top.c    |   28 ++---------
 7 files changed, 166 insertions(+), 122 deletions(-)
 create mode 100644 tools/lib/perf/Makefile
 create mode 100644 tools/lib/perf/mmap.c
 create mode 100644 tools/lib/perf/mmap.h

diff --git a/tools/Makefile b/tools/Makefile
index d3b1447..691f78b 100644
--- a/tools/Makefile
+++ b/tools/Makefile
@@ -34,7 +34,7 @@ export BASIC_CFLAGS
 PERF_TOP_DIR := $(CURDIR)
 export PERF_TOP_DIR
 
-perf: libparsevent lklib .FORCE
+perf: libparsevent lklib lkperflib .FORCE
 	$(QUIET_SUBDIR0)perf/ $(QUIET_SUBDIR1)
 
 libparsevent: .FORCE
@@ -43,9 +43,13 @@ libparsevent: .FORCE
 lklib: .FORCE
 	$(QUIET_SUBDIR0)lib/lk/ $(QUIET_SUBDIR1)
 
+lkperflib: .FORCE
+	$(QUIET_SUBDIR0)lib/perf/ $(QUIET_SUBDIR1)
+
 clean:
 	$(QUIET_SUBDIR0)lib/trace/ $(QUIET_SUBDIR1) clean
 	$(QUIET_SUBDIR0)lib/lk/ $(QUIET_SUBDIR1) clean
+	$(QUIET_SUBDIR0)lib/perf/ $(QUIET_SUBDIR1) clean
 	$(QUIET_SUBDIR0)perf/ $(QUIET_SUBDIR1) clean
 
 .PHONY: clean .FORCE
diff --git a/tools/lib/perf/Makefile b/tools/lib/perf/Makefile
new file mode 100644
index 0000000..9942d52
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
+LIBFILE = $(LIB_OUTPUT)lkperflib.a
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
index 0000000..b154ccc
--- /dev/null
+++ b/tools/lib/perf/mmap.c
@@ -0,0 +1,95 @@
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
+	unsigned int page_size;
+	unsigned char *data;
+	unsigned long size, samples = 0;
+	void *buf;
+	int diff;
+
+	page_size = sysconf(_SC_PAGE_SIZE);
+	data = md->base + page_size;
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
+
+	return samples;
+}
diff --git a/tools/lib/perf/mmap.h b/tools/lib/perf/mmap.h
new file mode 100644
index 0000000..b6622e5
--- /dev/null
+++ b/tools/lib/perf/mmap.h
@@ -0,0 +1,15 @@
+#ifndef __PERF_MMAP_H
+#define __PERF_MMAP_H
+
+struct mmap_data {
+	int			counter;
+	void			*base;
+	unsigned int		mask;
+	unsigned int		prev;
+};
+
+unsigned long mmap_read_head(struct mmap_data *md);
+unsigned long mmap_read_all(struct mmap_data *, int,
+			    void (*write_output)(void *, size_t));
+
+#endif /* __PERF_MMAP_H */
diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 49690b8..e8c1ada 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -328,7 +328,7 @@ export PERL_PATH
 
 LIB_FILE=$(OUTPUT)libperf.a
 
-EXTRA_LIB_FILES=$(LIB_OUTPUT)libparsevent.a $(LIB_OUTPUT)lklib.a
+EXTRA_LIB_FILES=$(LIB_OUTPUT)libparsevent.a $(LIB_OUTPUT)lklib.a $(LIB_OUTPUT)lkperflib.a
 
 LIB_H += ../../include/linux/perf_event.h
 LIB_H += ../../include/linux/rbtree.h
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 1fa7a06..99a71c5 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -6,22 +6,21 @@
  * later analysis via perf report.
  */
 #define _FILE_OFFSET_BITS 64
-
 #include "builtin.h"
-
 #include "perf.h"
 
 #include "util/build-id.h"
-#include <lk/util.h>
 #include "util/parse-options.h"
 #include "util/parse-events.h"
-
 #include "util/header.h"
 #include "util/event.h"
 #include "util/debug.h"
 #include "util/session.h"
 #include "util/symbol.h"
+
 #include <lk/cpumap.h>
+#include <lk/util.h>
+#include <perf/mmap.h>
 
 #include <unistd.h>
 #include <sched.h>
@@ -62,7 +61,7 @@ static bool			no_samples			=  false;
 static bool			sample_address			=  false;
 static bool			no_buildid			=  false;
 
-static long			samples				=      0;
+static unsigned long		samples				=      0;
 static u64			bytes_written			=      0;
 
 static struct pollfd		*event_array;
@@ -76,37 +75,8 @@ static off_t			post_processing_offset;
 static struct perf_session	*session;
 static const char		*cpu_list;
 
-struct mmap_data {
-	int			counter;
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
@@ -134,55 +104,6 @@ static int process_synthesized_event(event_t *event,
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
 
@@ -485,19 +406,6 @@ static struct perf_event_header finished_round_event = {
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
 	int i, counter;
@@ -734,10 +642,13 @@ static int __cmd_record(int argc, const char **argv)
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
index b5bc157..773676f 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -24,11 +24,8 @@
 #include "util/session.h"
 #include "util/symbol.h"
 #include "util/thread.h"
-#include <lk/util.h>
-#include <linux/rbtree.h>
 #include "util/parse-options.h"
 #include "util/parse-events.h"
-#include <lk/cpumap.h>
 
 #include "util/debug.h"
 
@@ -52,6 +49,11 @@
 #include <sys/uio.h>
 #include <sys/mman.h>
 
+#include <lk/util.h>
+#include <lk/cpumap.h>
+#include <perf/mmap.h>
+
+#include <linux/rbtree.h>
 #include <linux/unistd.h>
 #include <linux/types.h>
 
@@ -1082,24 +1084,6 @@ static void event__process_sample(const event_t *self,
 	}
 }
 
-struct mmap_data {
-	int			counter;
-	void			*base;
-	int			mask;
-	unsigned int		prev;
-};
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
 					    struct mmap_data *md)
 {
@@ -1117,7 +1101,7 @@ static void perf_session__mmap_read_counter(struct perf_session *self,
 	 * In either case, truncate and restart at head.
 	 */
 	diff = head - old;
-	if (diff > md->mask / 2 || diff < 0) {
+	if ((unsigned)diff > md->mask / 2 || diff < 0) {
 		fprintf(stderr, "WARNING: failed to keep up with mmap data.\n");
 
 		/*
-- 
1.7.3.1

