Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756677Ab0K3ULJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 15:11:09 -0500
Received: from canuck.infradead.org ([134.117.69.58]:44477 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756616Ab0K3ULH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 15:11:07 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 04/11] perf session: Cleanup __perf_session__process_events()
Date: Tue, 30 Nov 2010 18:10:49 -0200
Message-Id: <1291147856-17459-5-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1291147856-17459-1-git-send-email-acme@infradead.org>
References: <1291147856-17459-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

Replace the pseudo C++ self argument with session and give the mmap related
variables a sensible name. shift is a complete misnomer - it took me several
rounds of cursing to figure out that it's not a shift value.

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <20101130163820.029687218@linutronix.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/session.c |   77 +++++++++++++++++++++-----------------------
 1 files changed, 37 insertions(+), 40 deletions(-)

diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 525bcf6..2fdbccf 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -567,13 +567,13 @@ static int perf_session__process_sample(event_t *event, struct perf_session *s,
 static int perf_session__process_event(struct perf_session *self,
 				       event_t *event,
 				       struct perf_event_ops *ops,
-				       u64 offset, u64 head)
+				       u64 file_offset)
 {
 	trace_event(event);
 
 	if (event->header.type < PERF_RECORD_HEADER_MAX) {
 		dump_printf("%#Lx [%#x]: PERF_RECORD_%s",
-			    offset + head, event->header.size,
+			    file_offset, event->header.size,
 			    event__name[event->header.type]);
 		hists__inc_nr_events(&self->hists, event->header.type);
 	}
@@ -606,7 +606,7 @@ static int perf_session__process_event(struct perf_session *self,
 		return ops->event_type(event, self);
 	case PERF_RECORD_HEADER_TRACING_DATA:
 		/* setup for reading amidst mmap */
-		lseek(self->fd, offset + head, SEEK_SET);
+		lseek(self->fd, file_offset, SEEK_SET);
 		return ops->tracing_data(event, self);
 	case PERF_RECORD_HEADER_BUILD_ID:
 		return ops->build_id(event, self);
@@ -705,8 +705,7 @@ more:
 	}
 
 	if (size == 0 ||
-	    (skip = perf_session__process_event(self, &event, ops,
-						0, head)) < 0) {
+	    (skip = perf_session__process_event(self, &event, ops, head)) < 0) {
 		dump_printf("%#Lx [%#x]: skipping unknown header type: %d\n",
 			    head, event.header.size, event.header.type);
 		/*
@@ -735,19 +734,19 @@ out_err:
 	return err;
 }
 
-int __perf_session__process_events(struct perf_session *self,
+int __perf_session__process_events(struct perf_session *session,
 				   u64 data_offset, u64 data_size,
 				   u64 file_size, struct perf_event_ops *ops)
 {
+	u64 head, page_offset, file_offset;
 	int err, mmap_prot, mmap_flags;
-	u64 head, shift;
-	u64 offset = 0;
+	struct ui_progress *progress;
 	size_t	page_size;
 	event_t *event;
 	uint32_t size;
 	char *buf;
-	struct ui_progress *progress = ui_progress__new("Processing events...",
-							self->size);
+
+	progress = ui_progress__new("Processing events...", session->size);
 	if (progress == NULL)
 		return -1;
 
@@ -755,21 +754,20 @@ int __perf_session__process_events(struct perf_session *self,
 
 	page_size = sysconf(_SC_PAGESIZE);
 
-	head = data_offset;
-	shift = page_size * (head / page_size);
-	offset += shift;
-	head -= shift;
+	page_offset = page_size * (data_offset / page_size);
+	file_offset = page_offset;
+	head = data_offset - page_offset;
 
 	mmap_prot  = PROT_READ;
 	mmap_flags = MAP_SHARED;
 
-	if (self->header.needs_swap) {
+	if (session->header.needs_swap) {
 		mmap_prot  |= PROT_WRITE;
 		mmap_flags = MAP_PRIVATE;
 	}
 remap:
-	buf = mmap(NULL, page_size * self->mmap_window, mmap_prot,
-		   mmap_flags, self->fd, offset);
+	buf = mmap(NULL, page_size * session->mmap_window, mmap_prot,
+		   mmap_flags, session->fd, file_offset);
 	if (buf == MAP_FAILED) {
 		pr_err("failed to mmap file\n");
 		err = -errno;
@@ -778,36 +776,35 @@ remap:
 
 more:
 	event = (event_t *)(buf + head);
-	ui_progress__update(progress, offset);
+	ui_progress__update(progress, file_offset);
 
-	if (self->header.needs_swap)
+	if (session->header.needs_swap)
 		perf_event_header__bswap(&event->header);
 	size = event->header.size;
 	if (size == 0)
 		size = 8;
 
-	if (head + event->header.size >= page_size * self->mmap_window) {
+	if (head + event->header.size >= page_size * session->mmap_window) {
 		int munmap_ret;
 
-		shift = page_size * (head / page_size);
-
-		munmap_ret = munmap(buf, page_size * self->mmap_window);
+		munmap_ret = munmap(buf, page_size * session->mmap_window);
 		assert(munmap_ret == 0);
 
-		offset += shift;
-		head -= shift;
+		page_offset = page_size * (head / page_size);
+		file_offset += page_offset;
+		head -= page_offset;
 		goto remap;
 	}
 
 	size = event->header.size;
 
 	dump_printf("\n%#Lx [%#x]: event: %d\n",
-		    offset + head, event->header.size, event->header.type);
+		    file_offset + head, event->header.size, event->header.type);
 
-	if (size == 0 ||
-	    perf_session__process_event(self, event, ops, offset, head) < 0) {
+	if (size == 0 || perf_session__process_event(session, event, ops,
+						     file_offset + head) < 0) {
 		dump_printf("%#Lx [%#x]: skipping unknown header type: %d\n",
-			    offset + head, event->header.size,
+			    file_offset + head, event->header.size,
 			    event->header.type);
 		/*
 		 * assume we lost track of the stream, check alignment, and
@@ -821,36 +818,36 @@ more:
 
 	head += size;
 
-	if (offset + head >= data_offset + data_size)
+	if (file_offset + head >= data_offset + data_size)
 		goto done;
 
-	if (offset + head < file_size)
+	if (file_offset + head < file_size)
 		goto more;
 done:
 	err = 0;
 	/* do the final flush for ordered samples */
-	self->ordered_samples.next_flush = ULLONG_MAX;
-	flush_sample_queue(self, ops);
+	session->ordered_samples.next_flush = ULLONG_MAX;
+	flush_sample_queue(session, ops);
 out_err:
 	ui_progress__delete(progress);
 
 	if (ops->lost == event__process_lost &&
-	    self->hists.stats.total_lost != 0) {
+	    session->hists.stats.total_lost != 0) {
 		ui__warning("Processed %Lu events and LOST %Lu!\n\n"
 			    "Check IO/CPU overload!\n\n",
-			    self->hists.stats.total_period,
-			    self->hists.stats.total_lost);
+			    session->hists.stats.total_period,
+			    session->hists.stats.total_lost);
 	}
-	
-	if (self->hists.stats.nr_unknown_events != 0) {
+
+	if (session->hists.stats.nr_unknown_events != 0) {
 		ui__warning("Found %u unknown events!\n\n"
 			    "Is this an older tool processing a perf.data "
 			    "file generated by a more recent tool?\n\n"
 			    "If that is not the case, consider "
 			    "reporting to linux-kernel@vger.kernel.org.\n\n",
-			    self->hists.stats.nr_unknown_events);
+			    session->hists.stats.nr_unknown_events);
 	}
-		
+
 	return err;
 }
 
-- 
1.6.2.5

