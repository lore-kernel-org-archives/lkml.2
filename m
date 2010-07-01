Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932133Ab0GAP4M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 11:56:12 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:47058 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757082Ab0GAPyI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 11:54:08 -0400
From: Borislav Petkov <bp@amd64.org>
To: <linux-kernel@vger.kernel.org>
Subject: [PATCH 17/21] perf: Carve out mmap helpers for general use
Date: Thu,  1 Jul 2010 17:55:59 +0200
Message-Id: <1277999763-20357-18-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1277999763-20357-1-git-send-email-bp@amd64.org>
References: <1277999763-20357-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Export the mmap_read* helpers into tools/lib/perf/mmap.[ch]

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 tools/lib/Makefile          |    2 +
 tools/lib/perf/mmap.c       |   97 +++++++++++++++++++++++++++++++++++++
 tools/lib/perf/mmap.h       |   15 ++++++
 tools/perf/builtin-record.c |  113 +++++--------------------------------------
 tools/perf/builtin-top.c    |   21 +-------
 5 files changed, 129 insertions(+), 119 deletions(-)
 create mode 100644 tools/lib/perf/mmap.c
 create mode 100644 tools/lib/perf/mmap.h

diff --git a/tools/lib/Makefile b/tools/lib/Makefile
index 780c4fc..6f7102b 100644
--- a/tools/lib/Makefile
+++ b/tools/lib/Makefile
@@ -13,6 +13,7 @@ LIB_H += lk/strbuf.h
 LIB_H += lk/color.h
 LIB_H += lk/debug.h
 LIB_H += lk/strlist.h
+LIB_H += perf/mmap.h
 LIB_H += perf/parse-events.h
 LIB_H += perf/header.h
 LIB_H += perf/symbol.h
@@ -40,6 +41,7 @@ LIB_OBJS += $(OUTPUT)lk/debug.o
 LIB_OBJS += $(OUTPUT)lk/string.o
 LIB_OBJS += $(OUTPUT)lk/rbtree.o
 LIB_OBJS += $(OUTPUT)lk/strlist.o
+LIB_OBJS += $(OUTPUT)perf/mmap.o
 LIB_OBJS += $(OUTPUT)perf/parse-events.o
 LIB_OBJS += $(OUTPUT)perf/header.o
 LIB_OBJS += $(OUTPUT)perf/symbol.o
diff --git a/tools/lib/perf/mmap.c b/tools/lib/perf/mmap.c
new file mode 100644
index 0000000..02befbd
--- /dev/null
+++ b/tools/lib/perf/mmap.c
@@ -0,0 +1,97 @@
+#include <perf.h>
+#include <lk/util.h>
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
+		warning("failed to keep up with mmap data\n");
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
+
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
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 241c334..cb33e71 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -8,19 +8,19 @@
 #define _FILE_OFFSET_BITS 64
 
 #include "builtin.h"
-
 #include "perf.h"
 
 #include <lk/util.h>
-#include <lk/cpumap.h>
 #include <lk/debug.h>
+#include <lk/cpumap.h>
 #include <perf/misc.h>
-#include <perf/parse-events.h>
-#include <perf/build-id.h>
-#include <perf/header.h>
+#include <perf/mmap.h>
 #include <perf/event.h>
-#include <perf/session.h>
+#include <perf/header.h>
 #include <perf/symbol.h>
+#include <perf/session.h>
+#include <perf/build-id.h>
+#include <perf/parse-events.h>
 
 #include "util/parse-options.h"
 
@@ -63,7 +63,7 @@ static bool			no_samples			=  false;
 static bool			sample_address			=  false;
 static bool			no_buildid			=  false;
 
-static long			samples				=      0;
+static unsigned long		samples				=      0;
 static u64			bytes_written			=      0;
 
 static struct pollfd		*event_array;
@@ -77,37 +77,8 @@ static off_t			post_processing_offset;
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
@@ -135,55 +106,6 @@ static int process_synthesized_event(event_t *event,
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
 
@@ -493,19 +415,6 @@ static struct perf_event_header finished_round_event = {
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
@@ -739,10 +648,14 @@ static int __cmd_record(int argc, const char **argv)
 		close(go_pipe[1]);
 
 	for (;;) {
-		int hits = samples;
+		unsigned long hits = samples;
 		int thread;
 
-		mmap_read_all();
+		samples = mmap_read_all(mmap_array, nr_cpu, write_output);
+
+		if (perf_header__has_feat(&session->header, HEADER_TRACE_INFO))
+			write_output(&finished_round_event,
+				     sizeof(finished_round_event));
 
 		if (hits == samples) {
 			if (done)
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 866ba3d..1522ca0 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -28,6 +28,7 @@
 #include <linux/rbtree.h>
 #include "util/parse-options.h"
 #include <perf/parse-events.h>
+#include <perf/mmap.h>
 #include <lk/cpumap.h>
 
 #include <lk/debug.h>
@@ -1102,24 +1103,6 @@ static int event__process(event_t *event, struct perf_session *session)
 	return 0;
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
@@ -1137,7 +1120,7 @@ static void perf_session__mmap_read_counter(struct perf_session *self,
 	 * In either case, truncate and restart at head.
 	 */
 	diff = head - old;
-	if (diff > md->mask / 2 || diff < 0) {
+	if ((unsigned)diff > md->mask / 2 || diff < 0) {
 		fprintf(stderr, "WARNING: failed to keep up with mmap data.\n");
 
 		/*
-- 
1.7.1

