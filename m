Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754142Ab1DRJ0z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 05:26:55 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:45869 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754025Ab1DRJ0t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 05:26:49 -0400
Date: Mon, 18 Apr 2011 05:26:47 -0400
From: Christoph Hellwig <hch@infradead.org>
To: jaxboe@fusionio.com
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH] block: add blk_run_queue_async
Message-ID: <20110418092647.GB3837@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of overloading __blk_run_queue to force an offload to kblockd
add a new blk_run_queue_async helper to do it explicitly.  I've kept
the blk_queue_stopped check for now, but I suspect it's not needed
as the check we do when the workqueue items runs should be enough.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/block/blk-core.c
===================================================================
--- linux-2.6.orig/block/blk-core.c	2011-04-18 10:48:11.010100413 +0200
+++ linux-2.6/block/blk-core.c	2011-04-18 10:57:56.340262741 +0200
@@ -204,7 +204,7 @@ static void blk_delay_work(struct work_s
 
 	q = container_of(work, struct request_queue, delay_work.work);
 	spin_lock_irq(q->queue_lock);
-	__blk_run_queue(q, false);
+	__blk_run_queue(q);
 	spin_unlock_irq(q->queue_lock);
 }
 
@@ -238,7 +238,7 @@ void blk_start_queue(struct request_queu
 	WARN_ON(!irqs_disabled());
 
 	queue_flag_clear(QUEUE_FLAG_STOPPED, q);
-	__blk_run_queue(q, false);
+	__blk_run_queue(q);
 }
 EXPORT_SYMBOL(blk_start_queue);
 
@@ -295,11 +295,9 @@ EXPORT_SYMBOL(blk_sync_queue);
  *
  * Description:
  *    See @blk_run_queue. This variant must be called with the queue lock
- *    held and interrupts disabled. If force_kblockd is true, then it is
- *    safe to call this without holding the queue lock.
- *
+ *    held and interrupts disabled.
  */
-void __blk_run_queue(struct request_queue *q, bool force_kblockd)
+void __blk_run_queue(struct request_queue *q)
 {
 	if (unlikely(blk_queue_stopped(q)))
 		return;
@@ -308,7 +306,7 @@ void __blk_run_queue(struct request_queu
 	 * Only recurse once to avoid overrunning the stack, let the unplug
 	 * handling reinvoke the handler shortly if we already got there.
 	 */
-	if (!force_kblockd && !queue_flag_test_and_set(QUEUE_FLAG_REENTER, q)) {
+	if (!queue_flag_test_and_set(QUEUE_FLAG_REENTER, q)) {
 		q->request_fn(q);
 		queue_flag_clear(QUEUE_FLAG_REENTER, q);
 	} else
@@ -317,6 +315,20 @@ void __blk_run_queue(struct request_queu
 EXPORT_SYMBOL(__blk_run_queue);
 
 /**
+ * blk_run_queue_async - run a single device queue in workqueue context
+ * @q:	The queue to run
+ *
+ * Description:
+ *    Tells kblockd to perform the equivalent of @blk_run_queue on behalf
+ *    of us.
+ */
+void blk_run_queue_async(struct request_queue *q)
+{
+	if (likely(!blk_queue_stopped(q)))
+		queue_delayed_work(kblockd_workqueue, &q->delay_work, 0);
+}
+
+/**
  * blk_run_queue - run a single device queue
  * @q: The queue to run
  *
@@ -329,7 +341,7 @@ void blk_run_queue(struct request_queue
 	unsigned long flags;
 
 	spin_lock_irqsave(q->queue_lock, flags);
-	__blk_run_queue(q, false);
+	__blk_run_queue(q);
 	spin_unlock_irqrestore(q->queue_lock, flags);
 }
 EXPORT_SYMBOL(blk_run_queue);
@@ -978,7 +990,7 @@ void blk_insert_request(struct request_q
 		blk_queue_end_tag(q, rq);
 
 	add_acct_request(q, rq, where);
-	__blk_run_queue(q, false);
+	__blk_run_queue(q);
 	spin_unlock_irqrestore(q->queue_lock, flags);
 }
 EXPORT_SYMBOL(blk_insert_request);
@@ -1322,7 +1334,7 @@ get_rq:
 	} else {
 		spin_lock_irq(q->queue_lock);
 		add_acct_request(q, req, where);
-		__blk_run_queue(q, false);
+		__blk_run_queue(q);
 out_unlock:
 		spin_unlock_irq(q->queue_lock);
 	}
@@ -2683,9 +2695,9 @@ static void queue_unplugged(struct reque
 	 */
 	if (from_schedule) {
 		spin_unlock(q->queue_lock);
-		__blk_run_queue(q, true);
+		blk_run_queue_async(q);
 	} else {
-		__blk_run_queue(q, false);
+		__blk_run_queue(q);
 		spin_unlock(q->queue_lock);
 	}
 
Index: linux-2.6/block/blk-exec.c
===================================================================
--- linux-2.6.orig/block/blk-exec.c	2011-04-18 10:48:11.033433621 +0200
+++ linux-2.6/block/blk-exec.c	2011-04-18 10:50:12.346109746 +0200
@@ -55,7 +55,7 @@ void blk_execute_rq_nowait(struct reques
 	WARN_ON(irqs_disabled());
 	spin_lock_irq(q->queue_lock);
 	__elv_add_request(q, rq, where);
-	__blk_run_queue(q, false);
+	__blk_run_queue(q);
 	/* the queue is stopped so it won't be plugged+unplugged */
 	if (rq->cmd_type == REQ_TYPE_PM_RESUME)
 		q->request_fn(q);
Index: linux-2.6/block/blk-flush.c
===================================================================
--- linux-2.6.orig/block/blk-flush.c	2011-04-18 10:48:11.056766826 +0200
+++ linux-2.6/block/blk-flush.c	2011-04-18 10:57:45.336989017 +0200
@@ -218,7 +218,7 @@ static void flush_end_io(struct request
 	 * request_fn may confuse the driver.  Always use kblockd.
 	 */
 	if (queued)
-		__blk_run_queue(q, true);
+		blk_run_queue_async(q);
 }
 
 /**
@@ -274,7 +274,7 @@ static void flush_data_end_io(struct req
 	 * the comment in flush_end_io().
 	 */
 	if (blk_flush_complete_seq(rq, REQ_FSEQ_DATA, error))
-		__blk_run_queue(q, true);
+		blk_run_queue_async(q);
 }
 
 /**
Index: linux-2.6/block/cfq-iosched.c
===================================================================
--- linux-2.6.orig/block/cfq-iosched.c	2011-04-18 10:48:11.080100033 +0200
+++ linux-2.6/block/cfq-iosched.c	2011-04-18 10:51:08.599138332 +0200
@@ -3368,7 +3368,7 @@ cfq_rq_enqueued(struct cfq_data *cfqd, s
 			    cfqd->busy_queues > 1) {
 				cfq_del_timer(cfqd, cfqq);
 				cfq_clear_cfqq_wait_request(cfqq);
-				__blk_run_queue(cfqd->queue, false);
+				__blk_run_queue(cfqd->queue);
 			} else {
 				cfq_blkiocg_update_idle_time_stats(
 						&cfqq->cfqg->blkg);
@@ -3383,7 +3383,7 @@ cfq_rq_enqueued(struct cfq_data *cfqd, s
 		 * this new queue is RT and the current one is BE
 		 */
 		cfq_preempt_queue(cfqd, cfqq);
-		__blk_run_queue(cfqd->queue, false);
+		__blk_run_queue(cfqd->queue);
 	}
 }
 
@@ -3743,7 +3743,7 @@ static void cfq_kick_queue(struct work_s
 	struct request_queue *q = cfqd->queue;
 
 	spin_lock_irq(q->queue_lock);
-	__blk_run_queue(cfqd->queue, false);
+	__blk_run_queue(cfqd->queue);
 	spin_unlock_irq(q->queue_lock);
 }
 
Index: linux-2.6/block/elevator.c
===================================================================
--- linux-2.6.orig/block/elevator.c	2011-04-18 10:48:11.103433241 +0200
+++ linux-2.6/block/elevator.c	2011-04-18 10:51:24.849050298 +0200
@@ -642,7 +642,7 @@ void elv_quiesce_start(struct request_qu
 	 */
 	elv_drain_elevator(q);
 	while (q->rq.elvpriv) {
-		__blk_run_queue(q, false);
+		__blk_run_queue(q);
 		spin_unlock_irq(q->queue_lock);
 		msleep(10);
 		spin_lock_irq(q->queue_lock);
@@ -695,7 +695,7 @@ void __elv_add_request(struct request_qu
 		 *   with anything.  There's no point in delaying queue
 		 *   processing.
 		 */
-		__blk_run_queue(q, false);
+		__blk_run_queue(q);
 		break;
 
 	case ELEVATOR_INSERT_SORT_MERGE:
Index: linux-2.6/drivers/scsi/scsi_lib.c
===================================================================
--- linux-2.6.orig/drivers/scsi/scsi_lib.c	2011-04-18 10:48:11.126766448 +0200
+++ linux-2.6/drivers/scsi/scsi_lib.c	2011-04-18 10:51:31.449014543 +0200
@@ -443,7 +443,7 @@ static void scsi_run_queue(struct reques
 					&sdev->request_queue->queue_flags);
 		if (flagset)
 			queue_flag_set(QUEUE_FLAG_REENTER, sdev->request_queue);
-		__blk_run_queue(sdev->request_queue, false);
+		__blk_run_queue(sdev->request_queue);
 		if (flagset)
 			queue_flag_clear(QUEUE_FLAG_REENTER, sdev->request_queue);
 		spin_unlock(sdev->request_queue->queue_lock);
Index: linux-2.6/drivers/scsi/scsi_transport_fc.c
===================================================================
--- linux-2.6.orig/drivers/scsi/scsi_transport_fc.c	2011-04-18 10:48:11.150099654 +0200
+++ linux-2.6/drivers/scsi/scsi_transport_fc.c	2011-04-18 10:53:09.508483308 +0200
@@ -3829,7 +3829,7 @@ fc_bsg_goose_queue(struct fc_rport *rpor
 		  !test_bit(QUEUE_FLAG_REENTER, &rport->rqst_q->queue_flags);
 	if (flagset)
 		queue_flag_set(QUEUE_FLAG_REENTER, rport->rqst_q);
-	__blk_run_queue(rport->rqst_q, false);
+	__blk_run_queue(rport->rqst_q);
 	if (flagset)
 		queue_flag_clear(QUEUE_FLAG_REENTER, rport->rqst_q);
 	spin_unlock_irqrestore(rport->rqst_q->queue_lock, flags);
Index: linux-2.6/block/blk.h
===================================================================
--- linux-2.6.orig/block/blk.h	2011-04-18 10:53:39.001656864 +0200
+++ linux-2.6/block/blk.h	2011-04-18 11:00:28.066107438 +0200
@@ -22,6 +22,7 @@ void blk_rq_timed_out_timer(unsigned lon
 void blk_delete_timer(struct request *);
 void blk_add_timer(struct request *);
 void __generic_unplug_device(struct request_queue *);
+void blk_run_queue_async(struct request_queue *q);
 
 /*
  * Internal atomic flags for request handling
Index: linux-2.6/include/linux/blkdev.h
===================================================================
--- linux-2.6.orig/include/linux/blkdev.h	2011-04-18 10:48:11.170099546 +0200
+++ linux-2.6/include/linux/blkdev.h	2011-04-18 10:58:41.003354113 +0200
@@ -697,7 +697,7 @@ extern void blk_start_queue(struct reque
 extern void blk_stop_queue(struct request_queue *q);
 extern void blk_sync_queue(struct request_queue *q);
 extern void __blk_stop_queue(struct request_queue *q);
-extern void __blk_run_queue(struct request_queue *q, bool force_kblockd);
+extern void __blk_run_queue(struct request_queue *q);
 extern void blk_run_queue(struct request_queue *);
 extern int blk_rq_map_user(struct request_queue *, struct request *,
 			   struct rq_map_data *, void __user *, unsigned long,
