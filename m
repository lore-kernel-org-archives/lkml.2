Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756713Ab0K3ULN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 15:11:13 -0500
Received: from canuck.infradead.org ([134.117.69.58]:44512 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756684Ab0K3ULL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 15:11:11 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 08/11] perf session: Keep file mmaped instead of malloc/memcpy
Date: Tue, 30 Nov 2010 18:10:53 -0200
Message-Id: <1291147856-17459-9-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1291147856-17459-1-git-send-email-acme@infradead.org>
References: <1291147856-17459-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

Profiling perf with perf revealed that a large part of the processing time is
spent in malloc/memcpy/free in the sample ordering code. That code copies the
data from the mmap into malloc'ed memory. That's silly. We can keep the mmap
and just store the pointer in the queuing data structure. For 64 bit this is
not a problem as we map the whole file anyway. On 32bit we keep 8 maps around
and unmap the oldest before mmaping the next chunk of the file.

Performance gain: 2.95s -> 1.23s (Faktor 2.4)

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <20101130163820.278787719@linutronix.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/session.c |   27 +++++++++++----------------
 1 files changed, 11 insertions(+), 16 deletions(-)

diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 752577f..c989583 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -418,7 +418,6 @@ static void flush_sample_queue(struct perf_session *s,
 
 		os->last_flush = iter->timestamp;
 		list_del(&iter->list);
-		free(iter->event);
 		free(iter);
 	}
 
@@ -531,7 +530,6 @@ static int queue_sample_event(event_t *event, struct sample_data *data,
 	u64 timestamp = data->time;
 	struct sample_queue *new;
 
-
 	if (timestamp < s->ordered_samples.last_flush) {
 		printf("Warning: Timestamp below last timeslice flush\n");
 		return -EINVAL;
@@ -542,14 +540,7 @@ static int queue_sample_event(event_t *event, struct sample_data *data,
 		return -ENOMEM;
 
 	new->timestamp = timestamp;
-
-	new->event = malloc(event->header.size);
-	if (!new->event) {
-		free(new);
-		return -ENOMEM;
-	}
-
-	memcpy(new->event, event, event->header.size);
+	new->event = event;
 
 	__queue_sample_event(new, s);
 
@@ -747,12 +738,12 @@ int __perf_session__process_events(struct perf_session *session,
 				   u64 file_size, struct perf_event_ops *ops)
 {
 	u64 head, page_offset, file_offset, file_pos, progress_next;
-	int err, mmap_prot, mmap_flags;
+	int err, mmap_prot, mmap_flags, map_idx = 0;
 	struct ui_progress *progress;
 	size_t	page_size, mmap_size;
+	char *buf, *mmaps[8];
 	event_t *event;
 	uint32_t size;
-	char *buf;
 
 	perf_event_ops__fill_defaults(ops);
 
@@ -774,6 +765,8 @@ int __perf_session__process_events(struct perf_session *session,
 	if (mmap_size > file_size)
 		mmap_size = file_size;
 
+	memset(mmaps, 0, sizeof(mmaps));
+
 	mmap_prot  = PROT_READ;
 	mmap_flags = MAP_SHARED;
 
@@ -789,6 +782,8 @@ remap:
 		err = -errno;
 		goto out_err;
 	}
+	mmaps[map_idx] = buf;
+	map_idx = (map_idx + 1) & (ARRAY_SIZE(mmaps) - 1);
 	file_pos = file_offset + head;
 
 more:
@@ -801,10 +796,10 @@ more:
 		size = 8;
 
 	if (head + event->header.size >= mmap_size) {
-		int munmap_ret;
-
-		munmap_ret = munmap(buf, mmap_size);
-		assert(munmap_ret == 0);
+		if (mmaps[map_idx]) {
+			munmap(mmaps[map_idx], mmap_size);
+			mmaps[map_idx] = NULL;
+		}
 
 		page_offset = page_size * (head / page_size);
 		file_offset += page_offset;
-- 
1.6.2.5

