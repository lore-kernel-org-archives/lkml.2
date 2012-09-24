Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753769Ab2IXKFU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 06:05:20 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:28846 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753579Ab2IXKFR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 06:05:17 -0400
X-IronPort-AV: E=Sophos;i="4.80,474,1344182400"; 
   d="scan'208";a="5907216"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 09/10] workqueue: remove flusher_overflow
Date: Mon, 24 Sep 2012 18:07:11 +0800
Message-Id: <1348481238-6138-10-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1348481238-6138-1-git-send-email-laijs@cn.fujitsu.com>
References: <1348481238-6138-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/24 18:05:28,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/24 18:05:28,
	Serialize complete at 2012/09/24 18:05:28
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We can detect whether a flusher is started by comparing its
flush_color VS wq->work_color.

We move all overflowed flusher to flusher_queue, and then we
start flush for them when there is freed color. we detect it
by the color of the last flusher of the flusher_queue.

This patch doesn't make any functional difference.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c |   39 +++++++++++++--------------------------
 1 files changed, 13 insertions(+), 26 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index f687893..d78fe08 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -252,7 +252,6 @@ struct workqueue_struct {
 	atomic_t		nr_cwqs_to_flush[WORK_NR_COLORS];
 	struct wq_flusher	*first_flusher;	/* F: first flusher */
 	struct list_head	flusher_queue;	/* F: flush waiters */
-	struct list_head	flusher_overflow; /* F: flush overflow list */
 
 	mayday_mask_t		mayday_mask;	/* cpus requesting rescue */
 	struct worker		*rescuer;	/* I: rescue worker */
@@ -2600,7 +2599,7 @@ void flush_workqueue(struct workqueue_struct *wq)
 		.flush_color = -1,
 		.done = COMPLETION_INITIALIZER_ONSTACK(this_flusher.done),
 	};
-	struct wq_flusher *next, *tmp;
+	struct wq_flusher *next, *tmp, *last;
 	int flush_color, next_color;
 
 	lock_map_acquire(&wq->lockdep_map);
@@ -2617,8 +2616,6 @@ void flush_workqueue(struct workqueue_struct *wq)
 
 	if (next_color != wq->flush_color) {
 		/* Color space is not full */
-		BUG_ON(!list_empty(&wq->flusher_overflow));
-
 		if (!wq->first_flusher) {
 			/* no flush in progress, become the first flusher */
 			BUG_ON(wq->flush_color != flush_color);
@@ -2642,11 +2639,11 @@ void flush_workqueue(struct workqueue_struct *wq)
 		}
 	} else {
 		/*
-		 * Oops, color space is full, wait on overflow queue.
+		 * Oops, color space is full, queue it without starting flush.
 		 * The next flush completion will start flush for us
-		 * with freed flush color and transfer us to flusher_queue.
+		 * with freed flush color.
 		 */
-		list_add_tail(&this_flusher.list, &wq->flusher_overflow);
+		list_add_tail(&this_flusher.list, &wq->flusher_queue);
 	}
 
 	mutex_unlock(&wq->flush_mutex);
@@ -2676,27 +2673,9 @@ void flush_workqueue(struct workqueue_struct *wq)
 		complete(&next->done);
 	}
 
-	BUG_ON(!list_empty(&wq->flusher_overflow) &&
-	       wq->flush_color != work_next_color(wq->work_color));
-
 	/* this flush_color is finished, advance by one */
 	wq->flush_color = work_next_color(wq->flush_color);
 
-	/* one color has been freed, handle overflow queue */
-	if (!list_empty(&wq->flusher_overflow)) {
-		BUG_ON(list_first_entry(&wq->flusher_overflow,
-					struct wq_flusher,
-					list)->flush_color
-		       != wq->work_color);
-		/*
-		 * start flush with the freed color and append
-		 * overflowed flushers to the flusher_queue.
-		 */
-		list_splice_tail_init(&wq->flusher_overflow,
-				      &wq->flusher_queue);
-		workqueue_start_flush(wq);
-	}
-
 	if (list_empty(&wq->flusher_queue)) {
 		BUG_ON(wq->flush_color != wq->work_color);
 		wq->first_flusher = NULL;
@@ -2710,8 +2689,17 @@ void flush_workqueue(struct workqueue_struct *wq)
 	BUG_ON(wq->flush_color == wq->work_color);
 	BUG_ON(wq->flush_color != next->flush_color);
 
+	last = list_entry(wq->flusher_queue.prev, struct wq_flusher, list);
 	list_del_init(&next->list);
 	wq->first_flusher = next;
+
+	/* if have unstarted flushers appended, start flush for them */
+	if (last->flush_color == wq->work_color)
+		workqueue_start_flush(wq);
+
+	BUG_ON(work_next_color(last->flush_color) != wq->work_color);
+
+	/* arm new first flusher */
 	wq_dec_flusher_ref(wq, wq->flush_color);
 
 out_unlock:
@@ -3221,7 +3209,6 @@ struct workqueue_struct *__alloc_workqueue_key(const char *fmt,
 	for (color = 0; color < WORK_NR_COLORS; color++)
 		atomic_set(&wq->nr_cwqs_to_flush[color], 0);
 	INIT_LIST_HEAD(&wq->flusher_queue);
-	INIT_LIST_HEAD(&wq->flusher_overflow);
 
 	lockdep_init_map(&wq->lockdep_map, lock_name, key, 0);
 	INIT_LIST_HEAD(&wq->list);
-- 
1.7.4.4

