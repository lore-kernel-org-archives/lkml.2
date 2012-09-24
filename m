Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753950Ab2IXKGW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 06:06:22 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:28846 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753384Ab2IXKFP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 06:05:15 -0400
X-IronPort-AV: E=Sophos;i="4.80,474,1344182400"; 
   d="scan'208";a="5907213"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 06/10] workqueue: start all flusher at the same time
Date: Mon, 24 Sep 2012 18:07:08 +0800
Message-Id: <1348481238-6138-7-git-send-email-laijs@cn.fujitsu.com>
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

Start all flusher at the same time(except the overflowed flushers).

Since we have nr_cwqs_to_flush array for each color, any flush
color can start the same time, every color don't interfere
each other. The progress of flushing for any color is the same
as the old code.

A little different is that: the later color can't finished
until the previous color finished. So the top flusher of
previous color always hold a reference of the later color.
These is done by flush_workqueue_prep_cwqs() get a ref of
the just starting flush color, and it does not release it,
this ref's owner is assigned to the first flusher.
(so wq_dec_flusher_ref() is removed out from flush_workqueue_prep_cwqs()).

When the first flusher finished its flushing, it will release the ref
of the next color, and then the next color can finish.

All flush color can start and the same time, cwq_dec_nr_in_flight() must
decrease ref of any color, so cwq_dec_nr_in_flight() can't use cwq->flush_color,
it must use "cwq->work_color == color" to detect the @color is started to flush.
cwq->work_color is not used any more, remove it.

For any flush color, flush_workqueue_prep_cwqs() is called only one time.
(old code may call twice) it saves a big loop(when we have many CPUs)
and avoid to touch all gcwq again.

Wake-up-and-cascade phase become simpler and return quickly.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c |   46 ++++++++++++++++++----------------------------
 1 files changed, 18 insertions(+), 28 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index e5ba08c..803a22c 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -196,7 +196,6 @@ struct cpu_workqueue_struct {
 	struct worker_pool	*pool;		/* I: the associated pool */
 	struct workqueue_struct *wq;		/* I: the owning workqueue */
 	int			work_color;	/* L: current color */
-	int			flush_color;	/* L: flushing color */
 	int			nr_in_flight[WORK_NR_COLORS];
 						/* L: nr of in_flight works */
 	int			nr_active;	/* L: nr of active works */
@@ -1031,17 +1030,15 @@ static void cwq_dec_nr_in_flight(struct cpu_workqueue_struct *cwq, int color)
 			cwq_activate_first_delayed(cwq);
 	}
 
-	/* is flush in progress and are we at the flushing tip? */
-	if (likely(cwq->flush_color != color))
+	/* is flush in progress? */
+	if (likely(cwq->work_color == color))
 		return;
 
 	/* are there still in-flight works? */
 	if (cwq->nr_in_flight[color])
 		return;
 
-	/* this cwq is done, clear flush_color */
-	cwq->flush_color = -1;
-
+	/* this cwq is done, release the flusher ref of the color */
 	wq_dec_flusher_ref(cwq->wq, color);
 }
 
@@ -2541,13 +2538,6 @@ static void insert_wq_barrier(struct cpu_workqueue_struct *cwq,
  *
  * Prepare cwqs for workqueue flushing.
  *
- * If @flush_color is non-negative, flush_color on all cwqs should be
- * -1.  If no cwq has in-flight commands at the specified color, all
- * cwq->flush_color's stay at -1 and %false is returned.  If any cwq
- * has in flight commands, its cwq->flush_color is set to
- * @flush_color, @wq->nr_cwqs_to_flush[flush_color] is updated accordingly,
- * cwq wakeup logic is armed and %true is returned.
- *
  * The caller should have initialized @wq->first_flusher prior to
  * calling this function with non-negative @flush_color.  If
  * @flush_color is negative, no flush color update is done and %false
@@ -2572,6 +2562,7 @@ static bool flush_workqueue_prep_cwqs(struct workqueue_struct *wq,
 
 	if (flush_color >= 0) {
 		BUG_ON(atomic_read(&wq->nr_cwqs_to_flush[flush_color]));
+		/* this ref is held by first flusher */
 		atomic_set(&wq->nr_cwqs_to_flush[flush_color], 1);
 	}
 
@@ -2582,10 +2573,7 @@ static bool flush_workqueue_prep_cwqs(struct workqueue_struct *wq,
 		spin_lock_irq(&gcwq->lock);
 
 		if (flush_color >= 0) {
-			BUG_ON(cwq->flush_color != -1);
-
 			if (cwq->nr_in_flight[flush_color]) {
-				cwq->flush_color = flush_color;
 				atomic_inc(&wq->nr_cwqs_to_flush[flush_color]);
 				wait = true;
 			}
@@ -2599,9 +2587,6 @@ static bool flush_workqueue_prep_cwqs(struct workqueue_struct *wq,
 		spin_unlock_irq(&gcwq->lock);
 	}
 
-	if (flush_color >= 0)
-		wq_dec_flusher_ref(wq, flush_color);
-
 	return wait;
 }
 
@@ -2623,7 +2608,7 @@ void flush_workqueue(struct workqueue_struct *wq)
 		.done = COMPLETION_INITIALIZER_ONSTACK(this_flusher.done),
 	};
 	struct wq_flusher *next, *tmp;
-	int next_color;
+	int flush_color, next_color;
 
 	lock_map_acquire(&wq->lockdep_map);
 	lock_map_release(&wq->lockdep_map);
@@ -2633,6 +2618,7 @@ void flush_workqueue(struct workqueue_struct *wq)
 	/*
 	 * Start-to-wait phase
 	 */
+	flush_color = wq->work_color;
 	next_color = work_next_color(wq->work_color);
 
 	if (next_color != wq->flush_color) {
@@ -2642,27 +2628,31 @@ void flush_workqueue(struct workqueue_struct *wq)
 		 * by one.
 		 */
 		BUG_ON(!list_empty(&wq->flusher_overflow));
-		this_flusher.flush_color = wq->work_color;
+		this_flusher.flush_color = flush_color;
 		wq->work_color = next_color;
 
 		if (!wq->first_flusher) {
 			/* no flush in progress, become the first flusher */
-			BUG_ON(wq->flush_color != this_flusher.flush_color);
+			BUG_ON(wq->flush_color != flush_color);
 
 			wq->first_flusher = &this_flusher;
 
-			if (!flush_workqueue_prep_cwqs(wq, wq->flush_color,
+			if (!flush_workqueue_prep_cwqs(wq, flush_color,
 						       wq->work_color)) {
 				/* nothing to flush, done */
+				wq_dec_flusher_ref(wq, flush_color);
 				wq->flush_color = next_color;
 				wq->first_flusher = NULL;
 				goto out_unlock;
 			}
+
+			wq_dec_flusher_ref(wq, flush_color);
 		} else {
 			/* wait in queue */
 			BUG_ON(wq->flush_color == this_flusher.flush_color);
 			list_add_tail(&this_flusher.list, &wq->flusher_queue);
-			flush_workqueue_prep_cwqs(wq, -1, wq->work_color);
+			flush_workqueue_prep_cwqs(wq, flush_color,
+						  wq->work_color);
 		}
 	} else {
 		/*
@@ -2717,11 +2707,12 @@ void flush_workqueue(struct workqueue_struct *wq)
 		list_for_each_entry(tmp, &wq->flusher_overflow, list)
 			tmp->flush_color = wq->work_color;
 
+		flush_color = wq->work_color;
 		wq->work_color = work_next_color(wq->work_color);
 
 		list_splice_tail_init(&wq->flusher_overflow,
 				      &wq->flusher_queue);
-		flush_workqueue_prep_cwqs(wq, -1, wq->work_color);
+		flush_workqueue_prep_cwqs(wq, flush_color, wq->work_color);
 	}
 
 	if (list_empty(&wq->flusher_queue)) {
@@ -2732,14 +2723,14 @@ void flush_workqueue(struct workqueue_struct *wq)
 
 	/*
 	 * Need to flush more colors.  Make the next flusher
-	 * the new first flusher and arm cwqs.
+	 * the new first flusher and arm it.
 	 */
 	BUG_ON(wq->flush_color == wq->work_color);
 	BUG_ON(wq->flush_color != next->flush_color);
 
 	list_del_init(&next->list);
 	wq->first_flusher = next;
-	flush_workqueue_prep_cwqs(wq, wq->flush_color, -1);
+	wq_dec_flusher_ref(wq, wq->flush_color);
 
 out_unlock:
 	mutex_unlock(&wq->flush_mutex);
@@ -3264,7 +3255,6 @@ struct workqueue_struct *__alloc_workqueue_key(const char *fmt,
 		BUG_ON((unsigned long)cwq & WORK_STRUCT_FLAG_MASK);
 		cwq->pool = &gcwq->pools[pool_idx];
 		cwq->wq = wq;
-		cwq->flush_color = -1;
 		cwq->max_active = max_active;
 		INIT_LIST_HEAD(&cwq->delayed_works);
 	}
-- 
1.7.4.4

