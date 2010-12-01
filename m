Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753376Ab0LAJNF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 04:13:05 -0500
Received: from hera.kernel.org ([140.211.167.34]:54221 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753335Ab0LAJNA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 04:13:00 -0500
Date: Wed, 1 Dec 2010 09:12:34 GMT
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@redhat.com, peterz@infradead.org, fweisbec@gmail.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, fweisbec@gmail.com, peterz@infradead.org,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20101130163820.278787719@linutronix.de>
References: <20101130163820.278787719@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf session: Keep file mmaped instead of malloc/memcpy
Message-ID: <tip-fe17420784a6d3602e98f798731369fa05936cbe@git.kernel.org>
Git-Commit-ID: fe17420784a6d3602e98f798731369fa05936cbe
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 01 Dec 2010 09:12:34 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fe17420784a6d3602e98f798731369fa05936cbe
Gitweb:     http://git.kernel.org/tip/fe17420784a6d3602e98f798731369fa05936cbe
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Tue, 30 Nov 2010 17:49:49 +0000
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 30 Nov 2010 20:01:08 -0200

perf session: Keep file mmaped instead of malloc/memcpy

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
