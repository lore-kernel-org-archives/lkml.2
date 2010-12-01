Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752273Ab0LAJLa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 04:11:30 -0500
Received: from hera.kernel.org ([140.211.167.34]:54091 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751642Ab0LAJLZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 04:11:25 -0500
Date: Wed, 1 Dec 2010 09:10:35 GMT
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@redhat.com, peterz@infradead.org, fweisbec@gmail.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, fweisbec@gmail.com, peterz@infradead.org,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20101130163819.908482530@linutronix.de>
References: <20101130163819.908482530@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf session: Fix list sort algorithm
Message-ID: <tip-a1225decc43849a73f7e4c333c3fdbbb8a9c1e65@git.kernel.org>
Git-Commit-ID: a1225decc43849a73f7e4c333c3fdbbb8a9c1e65
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 01 Dec 2010 09:10:35 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a1225decc43849a73f7e4c333c3fdbbb8a9c1e65
Gitweb:     http://git.kernel.org/tip/a1225decc43849a73f7e4c333c3fdbbb8a9c1e65
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Tue, 30 Nov 2010 17:49:33 +0000
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 30 Nov 2010 19:52:36 -0200

perf session: Fix list sort algorithm

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
