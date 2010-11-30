Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756698Ab0K3ULL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 15:11:11 -0500
Received: from casper.infradead.org ([85.118.1.10]:33378 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756616Ab0K3ULK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 15:11:10 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 07/11] perf session: Use sensible mmap size
Date: Tue, 30 Nov 2010 18:10:52 -0200
Message-Id: <1291147856-17459-8-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1291147856-17459-1-git-send-email-acme@infradead.org>
References: <1291147856-17459-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

On 64bit we can map the whole file in one go, on 32bit we can at least map
32MB and not map/unmap tiny chunks of the file.

Base the progress bar on 1/16 of the data size.

Preparatory patch to get rid of the malloc/memcpy/free of trace data.

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <20101130163820.213687773@linutronix.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/session.c |   41 +++++++++++++++++++++++++++++------------
 1 files changed, 29 insertions(+), 12 deletions(-)

diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 9c806ab..752577f 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -101,7 +101,15 @@ struct perf_session *perf_session__new(const char *filename, int mode, bool forc
 	INIT_LIST_HEAD(&self->dead_threads);
 	self->hists_tree = RB_ROOT;
 	self->last_match = NULL;
-	self->mmap_window = 32;
+	/*
+	 * On 64bit we can mmap the data file in one go. No need for tiny mmap
+	 * slices. On 32bit we use 32MB.
+	 */
+#if BITS_PER_LONG == 64
+	self->mmap_window = ULLONG_MAX;
+#else
+	self->mmap_window = 32 * 1024 * 1024ULL;
+#endif
 	self->machines = RB_ROOT;
 	self->repipe = repipe;
 	INIT_LIST_HEAD(&self->ordered_samples.samples);
@@ -738,18 +746,14 @@ int __perf_session__process_events(struct perf_session *session,
 				   u64 data_offset, u64 data_size,
 				   u64 file_size, struct perf_event_ops *ops)
 {
-	u64 head, page_offset, file_offset, file_pos;
+	u64 head, page_offset, file_offset, file_pos, progress_next;
 	int err, mmap_prot, mmap_flags;
 	struct ui_progress *progress;
-	size_t	page_size;
+	size_t	page_size, mmap_size;
 	event_t *event;
 	uint32_t size;
 	char *buf;
 
-	progress = ui_progress__new("Processing events...", session->size);
-	if (progress == NULL)
-		return -1;
-
 	perf_event_ops__fill_defaults(ops);
 
 	page_size = sysconf(_SC_PAGESIZE);
@@ -761,6 +765,15 @@ int __perf_session__process_events(struct perf_session *session,
 	if (data_offset + data_size < file_size)
 		file_size = data_offset + data_size;
 
+	progress_next = file_size / 16;
+	progress = ui_progress__new("Processing events...", file_size);
+	if (progress == NULL)
+		return -1;
+
+	mmap_size = session->mmap_window;
+	if (mmap_size > file_size)
+		mmap_size = file_size;
+
 	mmap_prot  = PROT_READ;
 	mmap_flags = MAP_SHARED;
 
@@ -769,15 +782,14 @@ int __perf_session__process_events(struct perf_session *session,
 		mmap_flags = MAP_PRIVATE;
 	}
 remap:
-	buf = mmap(NULL, page_size * session->mmap_window, mmap_prot,
-		   mmap_flags, session->fd, file_offset);
+	buf = mmap(NULL, mmap_size, mmap_prot, mmap_flags, session->fd,
+		   file_offset);
 	if (buf == MAP_FAILED) {
 		pr_err("failed to mmap file\n");
 		err = -errno;
 		goto out_err;
 	}
 	file_pos = file_offset + head;
-	ui_progress__update(progress, file_offset);
 
 more:
 	event = (event_t *)(buf + head);
@@ -788,10 +800,10 @@ more:
 	if (size == 0)
 		size = 8;
 
-	if (head + event->header.size >= page_size * session->mmap_window) {
+	if (head + event->header.size >= mmap_size) {
 		int munmap_ret;
 
-		munmap_ret = munmap(buf, page_size * session->mmap_window);
+		munmap_ret = munmap(buf, mmap_size);
 		assert(munmap_ret == 0);
 
 		page_offset = page_size * (head / page_size);
@@ -823,6 +835,11 @@ more:
 	head += size;
 	file_pos += size;
 
+	if (file_pos >= progress_next) {
+		progress_next += file_size / 16;
+		ui_progress__update(progress, file_pos);
+	}
+
 	if (file_pos < file_size)
 		goto more;
 
-- 
1.6.2.5

