Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755293Ab2JHVrB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 17:47:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64834 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754149Ab2JHVpH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 17:45:07 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, axboe@kernel.dk
Cc: vgoyal@redhat.com, jmoyer@redhat.com, tj@kernel.org
Subject: [PATCH 5/8] cfq-iosched: Remove residual slice logic
Date: Mon,  8 Oct 2012 17:44:57 -0400
Message-Id: <1349732700-2694-6-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1349732700-2694-1-git-send-email-vgoyal@redhat.com>
References: <1349732700-2694-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CFQ has this logic of residual slice so that a queue does not lose its
allocated share due to preemption. When we move to vdisktime logic,
a queue will not lose its share even if it preempted. (It will get queued
back into service tree with smaller key and get selected to run again).

So scheduling algorithm will take care of making sure preempted queue
still gets the fair share. Hence remove the logic of residual slice.

Note, vdisktime patches for queues are ahead in the series. I am first
cleaning up the code.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 block/cfq-iosched.c |   53 +++++++++++++-------------------------------------
 1 files changed, 14 insertions(+), 39 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 7136ede..6930eed 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -128,7 +128,6 @@ struct cfq_queue {
 	/* time when first request from queue completed and slice started. */
 	unsigned long slice_start;
 	unsigned long slice_end;
-	long slice_resid;
 
 	/* pending priority requests */
 	int prio_pending;
@@ -1630,16 +1629,6 @@ static void cfq_service_tree_add(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 			rb_key += __cfqq->rb_key;
 		} else
 			rb_key += jiffies;
-		if (!cfq_class_idle(cfqq)) {
-			/*
-			 * Subtract any residual slice * value carried from
-			 * last service. A negative resid count indicates
-			 * slice overrun, and this should position
-			 * the next service time further away in the tree.
-			 */
-			rb_key -= cfqq->slice_resid;
-			cfqq->slice_resid = 0;
-		}
 	} else {
 		rb_key = -HZ;
 		__cfqq = cfq_rb_first(st);
@@ -2042,10 +2031,9 @@ static void __cfq_set_active_queue(struct cfq_data *cfqd,
  * current cfqq expired its slice (or was too idle), select new one
  */
 static void
-__cfq_slice_expired(struct cfq_data *cfqd, struct cfq_queue *cfqq,
-		    bool timed_out)
+__cfq_slice_expired(struct cfq_data *cfqd, struct cfq_queue *cfqq)
 {
-	cfq_log_cfqq(cfqd, cfqq, "slice expired t=%d", timed_out);
+	cfq_log_cfqq(cfqd, cfqq, "slice expired");
 
 	if (cfq_cfqq_wait_request(cfqq))
 		cfq_del_timer(cfqd, cfqq);
@@ -2062,17 +2050,6 @@ __cfq_slice_expired(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 	if (cfq_cfqq_coop(cfqq) && CFQQ_SEEKY(cfqq))
 		cfq_mark_cfqq_split_coop(cfqq);
 
-	/*
-	 * store what was left of this slice, if the queue idled/timed out
-	 */
-	if (timed_out) {
-		if (cfq_cfqq_slice_new(cfqq))
-			cfqq->slice_resid = cfq_scaled_cfqq_slice(cfqd, cfqq);
-		else
-			cfqq->slice_resid = cfqq->slice_end - jiffies;
-		cfq_log_cfqq(cfqd, cfqq, "resid=%ld", cfqq->slice_resid);
-	}
-
 	cfq_group_served(cfqd, cfqq->cfqg, cfqq);
 
 	if (cfq_cfqq_on_rr(cfqq) && RB_EMPTY_ROOT(&cfqq->sort_list))
@@ -2089,12 +2066,12 @@ __cfq_slice_expired(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 	}
 }
 
-static inline void cfq_slice_expired(struct cfq_data *cfqd, bool timed_out)
+static inline void cfq_slice_expired(struct cfq_data *cfqd)
 {
 	struct cfq_queue *cfqq = cfqd->active_queue;
 
 	if (cfqq)
-		__cfq_slice_expired(cfqd, cfqq, timed_out);
+		__cfq_slice_expired(cfqd, cfqq);
 }
 
 /*
@@ -2720,7 +2697,7 @@ check_group_idle:
 	}
 
 expire:
-	cfq_slice_expired(cfqd, 0);
+	cfq_slice_expired(cfqd);
 new_queue:
 	/*
 	 * Current queue expired. Check if we have to switch to a new
@@ -2746,7 +2723,7 @@ static int __cfq_forced_dispatch_cfqq(struct cfq_queue *cfqq)
 	BUG_ON(!list_empty(&cfqq->fifo));
 
 	/* By default cfqq is not expired if it is empty. Do it explicitly */
-	__cfq_slice_expired(cfqq->cfqd, cfqq, 0);
+	__cfq_slice_expired(cfqq->cfqd, cfqq);
 	return dispatched;
 }
 
@@ -2760,7 +2737,7 @@ static int cfq_forced_dispatch(struct cfq_data *cfqd)
 	int dispatched = 0;
 
 	/* Expire the timeslice of the current active queue first */
-	cfq_slice_expired(cfqd, 0);
+	cfq_slice_expired(cfqd);
 	while ((cfqq = cfq_get_next_queue_forced(cfqd)) != NULL) {
 		__cfq_set_active_queue(cfqd, cfqq);
 		dispatched += __cfq_forced_dispatch_cfqq(cfqq);
@@ -2941,7 +2918,7 @@ static int cfq_dispatch_requests(struct request_queue *q, int force)
 	    cfqq->slice_dispatch >= cfq_prio_to_maxrq(cfqd, cfqq)) ||
 	    cfq_class_idle(cfqq))) {
 		cfqq->slice_end = jiffies + 1;
-		cfq_slice_expired(cfqd, 0);
+		cfq_slice_expired(cfqd);
 	}
 
 	cfq_log_cfqq(cfqd, cfqq, "dispatched a request");
@@ -2972,7 +2949,7 @@ static void cfq_put_queue(struct cfq_queue *cfqq)
 	cfqg = cfqq->cfqg;
 
 	if (unlikely(cfqd->active_queue == cfqq)) {
-		__cfq_slice_expired(cfqd, cfqq, 0);
+		__cfq_slice_expired(cfqd, cfqq);
 		cfq_schedule_dispatch(cfqd);
 	}
 
@@ -3005,7 +2982,7 @@ static void cfq_put_cooperator(struct cfq_queue *cfqq)
 static void cfq_exit_cfqq(struct cfq_data *cfqd, struct cfq_queue *cfqq)
 {
 	if (unlikely(cfqq == cfqd->active_queue)) {
-		__cfq_slice_expired(cfqd, cfqq, 0);
+		__cfq_slice_expired(cfqd, cfqq);
 		cfq_schedule_dispatch(cfqd);
 	}
 
@@ -3440,7 +3417,7 @@ static void cfq_preempt_queue(struct cfq_data *cfqd, struct cfq_queue *cfqq)
 	enum wl_type_t old_type = cfqq_type(cfqd->active_queue);
 
 	cfq_log_cfqq(cfqd, cfqq, "preempt");
-	cfq_slice_expired(cfqd, 1);
+	cfq_slice_expired(cfqd);
 
 	/*
 	 * workload type is changed, don't save slice, otherwise preempt
@@ -3682,7 +3659,7 @@ static void cfq_completed_request(struct request_queue *q, struct request *rq)
 		 * - when there is a close cooperator
 		 */
 		if (cfq_slice_used(cfqq) || cfq_class_idle(cfqq))
-			cfq_slice_expired(cfqd, 1);
+			cfq_slice_expired(cfqd);
 		else if (sync && cfqq_empty &&
 			 !cfq_close_cooperator(cfqd, cfqq)) {
 			cfq_arm_slice_timer(cfqd);
@@ -3858,7 +3835,6 @@ static void cfq_idle_slice_timer(unsigned long data)
 	struct cfq_data *cfqd = (struct cfq_data *) data;
 	struct cfq_queue *cfqq;
 	unsigned long flags;
-	int timed_out = 1;
 
 	cfq_log(cfqd, "idle timer fired");
 
@@ -3866,7 +3842,6 @@ static void cfq_idle_slice_timer(unsigned long data)
 
 	cfqq = cfqd->active_queue;
 	if (cfqq) {
-		timed_out = 0;
 
 		/*
 		 * We saw a request before the queue expired, let it through
@@ -3899,7 +3874,7 @@ static void cfq_idle_slice_timer(unsigned long data)
 		cfq_clear_cfqq_deep(cfqq);
 	}
 expire:
-	cfq_slice_expired(cfqd, timed_out);
+	cfq_slice_expired(cfqd);
 out_kick:
 	cfq_schedule_dispatch(cfqd);
 out_cont:
@@ -3937,7 +3912,7 @@ static void cfq_exit_queue(struct elevator_queue *e)
 	spin_lock_irq(q->queue_lock);
 
 	if (cfqd->active_queue)
-		__cfq_slice_expired(cfqd, cfqd->active_queue, 0);
+		__cfq_slice_expired(cfqd, cfqd->active_queue);
 
 	cfq_put_async_queues(cfqd);
 
-- 
1.7.7.6

