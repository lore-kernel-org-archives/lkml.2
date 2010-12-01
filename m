Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753101Ab0LAJMo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 04:12:44 -0500
Received: from hera.kernel.org ([140.211.167.34]:54181 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751025Ab0LAJMj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 04:12:39 -0500
Date: Wed, 1 Dec 2010 09:12:16 GMT
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@redhat.com, peterz@infradead.org, fweisbec@gmail.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, fweisbec@gmail.com, peterz@infradead.org,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20101130163820.213687773@linutronix.de>
References: <20101130163820.213687773@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf session: Use sensible mmap size
Message-ID: <tip-55b44629f599a2305265ae9c77f9d9bcfd6ddc17@git.kernel.org>
Git-Commit-ID: 55b44629f599a2305265ae9c77f9d9bcfd6ddc17
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 01 Dec 2010 09:12:16 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  55b44629f599a2305265ae9c77f9d9bcfd6ddc17
Gitweb:     http://git.kernel.org/tip/55b44629f599a2305265ae9c77f9d9bcfd6ddc17
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Tue, 30 Nov 2010 17:49:46 +0000
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 30 Nov 2010 19:59:34 -0200

perf session: Use sensible mmap size

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
 
