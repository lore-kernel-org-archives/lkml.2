Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756527Ab1DVR7M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 13:59:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43278 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756423Ab1DVR7H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 13:59:07 -0400
Date: Fri, 22 Apr 2011 13:59:00 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] cfq-iosched: Get rid of cfqd->unplug_work and use
 blk_run_queue_async()
Message-ID: <20110422175900.GD8255@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jens,

As hinted by Christoph, will this be a good little cleanup. I have one
concern though. Now it might happen that cfq schedules work and then exits
without cleaning up the scheduled work. AFAIK, that should not create problem
as long as queue is around. If queue is exiting, it should cancel all the
pending work on kblockd. So I am hoping it is not an issue.

I have done basic boot testing and IO scheduler switching.

 
CFQ needs to kick the queue asynchronously in some situations like upon
expiry of idle timer. CFQ was using its own work structure to queue on
kblockd workqueue to achieve this. Now blk_run_queue_async() does it
by putting delay_work on kblockd workqueue. Use that instead of queuing
your own work.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com> 
---
 block/cfq-iosched.c |   23 ++++-------------------
 1 file changed, 4 insertions(+), 19 deletions(-)

Index: linux-2.6/block/cfq-iosched.c
===================================================================
--- linux-2.6.orig/block/cfq-iosched.c	2011-04-21 11:17:01.000000000 -0400
+++ linux-2.6/block/cfq-iosched.c	2011-04-22 13:31:08.411895257 -0400
@@ -262,7 +262,6 @@ struct cfq_data {
 	 * idle window management
 	 */
 	struct timer_list idle_slice_timer;
-	struct work_struct unplug_work;
 
 	struct cfq_queue *active_queue;
 	struct cfq_io_context *active_cic;
@@ -498,7 +497,7 @@ static inline void cfq_schedule_dispatch
 {
 	if (cfqd->busy_queues) {
 		cfq_log(cfqd, "schedule dispatch");
-		kblockd_schedule_work(cfqd->queue, &cfqd->unplug_work);
+		blk_run_queue_async(cfqd->queue);
 	}
 }
 
@@ -3728,17 +3727,6 @@ queue_fail:
 	return 1;
 }
 
-static void cfq_kick_queue(struct work_struct *work)
-{
-	struct cfq_data *cfqd =
-		container_of(work, struct cfq_data, unplug_work);
-	struct request_queue *q = cfqd->queue;
-
-	spin_lock_irq(q->queue_lock);
-	__blk_run_queue(cfqd->queue);
-	spin_unlock_irq(q->queue_lock);
-}
-
 /*
  * Timer running if the active_queue is currently idling inside its time slice
  */
@@ -3795,10 +3783,9 @@ out_cont:
 	spin_unlock_irqrestore(cfqd->queue->queue_lock, flags);
 }
 
-static void cfq_shutdown_timer_wq(struct cfq_data *cfqd)
+static void cfq_shutdown_timer(struct cfq_data *cfqd)
 {
 	del_timer_sync(&cfqd->idle_slice_timer);
-	cancel_work_sync(&cfqd->unplug_work);
 }
 
 static void cfq_put_async_queues(struct cfq_data *cfqd)
@@ -3826,7 +3813,7 @@ static void cfq_exit_queue(struct elevat
 	struct cfq_data *cfqd = e->elevator_data;
 	struct request_queue *q = cfqd->queue;
 
-	cfq_shutdown_timer_wq(cfqd);
+	cfq_shutdown_timer(cfqd);
 
 	spin_lock_irq(q->queue_lock);
 
@@ -3847,7 +3834,7 @@ static void cfq_exit_queue(struct elevat
 
 	spin_unlock_irq(q->queue_lock);
 
-	cfq_shutdown_timer_wq(cfqd);
+	cfq_shutdown_timer(cfqd);
 
 	spin_lock(&cic_index_lock);
 	ida_remove(&cic_index_ida, cfqd->cic_index);
@@ -3944,8 +3931,6 @@ static void *cfq_init_queue(struct reque
 	cfqd->idle_slice_timer.function = cfq_idle_slice_timer;
 	cfqd->idle_slice_timer.data = (unsigned long) cfqd;
 
-	INIT_WORK(&cfqd->unplug_work, cfq_kick_queue);
-
 	cfqd->cfq_quantum = cfq_quantum;
 	cfqd->cfq_fifo_expire[0] = cfq_fifo_expire[0];
 	cfqd->cfq_fifo_expire[1] = cfq_fifo_expire[1];
