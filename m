Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756619Ab0K3ULH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 15:11:07 -0500
Received: from casper.infradead.org ([85.118.1.10]:33352 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752166Ab0K3ULF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 15:11:05 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 02/11] perf session: Fix list sort algorithm
Date: Tue, 30 Nov 2010 18:10:47 -0200
Message-Id: <1291147856-17459-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1291147856-17459-1-git-send-email-acme@infradead.org>
References: <1291147856-17459-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

The homebrewn sort algorithm fails to sort in time order. One of the problem
spots is that it fails to deal with equal timestamps correctly.

My first gut reaction was to replace the fancy list with an rbtree, but the
performance is 3 times worse.

Rewrite it so it works.

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <20101130163819.908482530@linutronix.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/session.c |  113 +++++++++++++++++++--------------------------
 tools/perf/util/session.h |    4 +-
 2 files changed, 49 insertions(+), 68 deletions(-)

diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 3ae6955..daca557 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -104,7 +104,7 @@ struct perf_session *perf_session__new(const char *filename, int mode, bool forc
 	self->mmap_window = 32;
 	self->machines = RB_ROOT;
 	self->repipe = repipe;
-	INIT_LIST_HEAD(&self->ordered_samples.samples_head);
+	INIT_LIST_HEAD(&self->ordered_samples.samples);
 	machine__init(&self->host_machine, "", HOST_KERNEL_ID);
 
 	if (mode == O_RDONLY) {
@@ -393,27 +393,33 @@ struct sample_queue {
 static void flush_sample_queue(struct perf_session *s,
 			       struct perf_event_ops *ops)
 {
-	struct list_head *head = &s->ordered_samples.samples_head;
-	u64 limit = s->ordered_samples.next_flush;
+	struct ordered_samples *os = &s->ordered_samples;
+	struct list_head *head = &os->samples;
 	struct sample_queue *tmp, *iter;
+	u64 limit = os->next_flush;
+	u64 last_ts = os->last_sample ? os->last_sample->timestamp : 0ULL;
 
 	if (!ops->ordered_samples || !limit)
 		return;
 
 	list_for_each_entry_safe(iter, tmp, head, list) {
 		if (iter->timestamp > limit)
-			return;
-
-		if (iter == s->ordered_samples.last_inserted)
-			s->ordered_samples.last_inserted = NULL;
+			break;
 
 		ops->sample((event_t *)iter->event, s);
 
-		s->ordered_samples.last_flush = iter->timestamp;
+		os->last_flush = iter->timestamp;
 		list_del(&iter->list);
 		free(iter->event);
 		free(iter);
 	}
+
+	if (list_empty(head)) {
+		os->last_sample = NULL;
+	} else if (last_ts <= limit) {
+		os->last_sample =
+			list_entry(head->prev, struct sample_queue, list);
+	}
 }
 
 /*
@@ -465,71 +471,50 @@ static int process_finished_round(event_t *event __used,
 	return 0;
 }
 
-static void __queue_sample_end(struct sample_queue *new, struct list_head *head)
-{
-	struct sample_queue *iter;
-
-	list_for_each_entry_reverse(iter, head, list) {
-		if (iter->timestamp < new->timestamp) {
-			list_add(&new->list, &iter->list);
-			return;
-		}
-	}
-
-	list_add(&new->list, head);
-}
-
-static void __queue_sample_before(struct sample_queue *new,
-				  struct sample_queue *iter,
-				  struct list_head *head)
-{
-	list_for_each_entry_continue_reverse(iter, head, list) {
-		if (iter->timestamp < new->timestamp) {
-			list_add(&new->list, &iter->list);
-			return;
-		}
-	}
-
-	list_add(&new->list, head);
-}
-
-static void __queue_sample_after(struct sample_queue *new,
-				 struct sample_queue *iter,
-				 struct list_head *head)
-{
-	list_for_each_entry_continue(iter, head, list) {
-		if (iter->timestamp > new->timestamp) {
-			list_add_tail(&new->list, &iter->list);
-			return;
-		}
-	}
-	list_add_tail(&new->list, head);
-}
-
 /* The queue is ordered by time */
 static void __queue_sample_event(struct sample_queue *new,
 				 struct perf_session *s)
 {
-	struct sample_queue *last_inserted = s->ordered_samples.last_inserted;
-	struct list_head *head = &s->ordered_samples.samples_head;
+	struct ordered_samples *os = &s->ordered_samples;
+	struct sample_queue *sample = os->last_sample;
+	u64 timestamp = new->timestamp;
+	struct list_head *p;
 
+	os->last_sample = new;
 
-	if (!last_inserted) {
-		__queue_sample_end(new, head);
+	if (!sample) {
+		list_add(&new->list, &os->samples);
+		os->max_timestamp = timestamp;
 		return;
 	}
 
 	/*
-	 * Most of the time the current event has a timestamp
-	 * very close to the last event inserted, unless we just switched
-	 * to another event buffer. Having a sorting based on a list and
-	 * on the last inserted event that is close to the current one is
-	 * probably more efficient than an rbtree based sorting.
+	 * last_sample might point to some random place in the list as it's
+	 * the last queued event. We expect that the new event is close to
+	 * this.
 	 */
-	if (last_inserted->timestamp >= new->timestamp)
-		__queue_sample_before(new, last_inserted, head);
-	else
-		__queue_sample_after(new, last_inserted, head);
+	if (sample->timestamp <= timestamp) {
+		while (sample->timestamp <= timestamp) {
+			p = sample->list.next;
+			if (p == &os->samples) {
+				list_add_tail(&new->list, &os->samples);
+				os->max_timestamp = timestamp;
+				return;
+			}
+			sample = list_entry(p, struct sample_queue, list);
+		}
+		list_add_tail(&new->list, &sample->list);
+	} else {
+		while (sample->timestamp > timestamp) {
+			p = sample->list.prev;
+			if (p == &os->samples) {
+				list_add(&new->list, &os->samples);
+				return;
+			}
+			sample = list_entry(p, struct sample_queue, list);
+		}
+		list_add(&new->list, &sample->list);
+	}
 }
 
 static int queue_sample_event(event_t *event, struct sample_data *data,
@@ -559,10 +544,6 @@ static int queue_sample_event(event_t *event, struct sample_data *data,
 	memcpy(new->event, event, event->header.size);
 
 	__queue_sample_event(new, s);
-	s->ordered_samples.last_inserted = new;
-
-	if (new->timestamp > s->ordered_samples.max_timestamp)
-		s->ordered_samples.max_timestamp = new->timestamp;
 
 	return 0;
 }
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index 9fa0fc2..a00f32e 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -17,8 +17,8 @@ struct ordered_samples {
 	u64			last_flush;
 	u64			next_flush;
 	u64			max_timestamp;
-	struct list_head	samples_head;
-	struct sample_queue	*last_inserted;
+	struct list_head	samples;
+	struct sample_queue	*last_sample;
 };
 
 struct perf_session {
-- 
1.6.2.5

