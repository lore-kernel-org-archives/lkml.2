Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754781Ab1AVBR6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 20:17:58 -0500
Received: from hera.kernel.org ([140.211.167.34]:45825 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754697Ab1AVBRz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 20:17:55 -0500
From: Jens Axboe <jaxboe@fusionio.com>
To: jaxboe@fusionio.com, linux-kernel@vger.kernel.org
Cc: hch@infradead.org
Subject: [PATCH 01/10] block: add API for delaying work/request_fn a little bit
Date: Sat, 22 Jan 2011 01:17:20 +0000
Message-Id: <1295659049-2688-2-git-send-email-jaxboe@fusionio.com>
X-Mailer: git-send-email 1.7.3.5
In-Reply-To: <1295659049-2688-1-git-send-email-jaxboe@fusionio.com>
References: <1295659049-2688-1-git-send-email-jaxboe@fusionio.com>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 22 Jan 2011 01:17:32 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently we use plugging for that, but as plugging is going away,
we need an alternative mechanism.

Signed-off-by: Jens Axboe <jaxboe@fusionio.com>
---
 block/blk-core.c       |   29 +++++++++++++++++++++++++++++
 include/linux/blkdev.h |    6 ++++++
 2 files changed, 35 insertions(+), 0 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 2f4002f..960f12c 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -207,6 +207,32 @@ void blk_dump_rq_flags(struct request *rq, char *msg)
 }
 EXPORT_SYMBOL(blk_dump_rq_flags);
 
+static void blk_delay_work(struct work_struct *work)
+{
+	struct request_queue *q;
+
+	q = container_of(work, struct request_queue, delay_work.work);
+	spin_lock_irq(q->queue_lock);
+	q->request_fn(q);
+	spin_unlock_irq(q->queue_lock);
+}
+
+/**
+ * blk_delay_queue - restart queueing after defined interval
+ * @q:		The &struct request_queue in question
+ * @msecs:	Delay in msecs
+ *
+ * Description:
+ *   Sometimes queueing needs to be postponed for a little while, to allow
+ *   resources to come back. This function will make sure that queueing is
+ *   restarted around the specified time.
+ */
+void blk_delay_queue(struct request_queue *q, unsigned long msecs)
+{
+	schedule_delayed_work(&q->delay_work, msecs_to_jiffies(msecs));
+}
+EXPORT_SYMBOL(blk_delay_queue);
+
 /*
  * "plug" the device if there are no outstanding requests: this will
  * force the transfer to start only after we have put all the requests
@@ -373,6 +399,7 @@ EXPORT_SYMBOL(blk_start_queue);
 void blk_stop_queue(struct request_queue *q)
 {
 	blk_remove_plug(q);
+	cancel_delayed_work(&q->delay_work);
 	queue_flag_set(QUEUE_FLAG_STOPPED, q);
 }
 EXPORT_SYMBOL(blk_stop_queue);
@@ -397,6 +424,7 @@ void blk_sync_queue(struct request_queue *q)
 	del_timer_sync(&q->timeout);
 	cancel_work_sync(&q->unplug_work);
 	throtl_shutdown_timer_wq(q);
+	cancel_delayed_work_sync(&q->delay_work);
 }
 EXPORT_SYMBOL(blk_sync_queue);
 
@@ -542,6 +570,7 @@ struct request_queue *blk_alloc_queue_node(gfp_t gfp_mask, int node_id)
 	INIT_LIST_HEAD(&q->timeout_list);
 	INIT_LIST_HEAD(&q->pending_flushes);
 	INIT_WORK(&q->unplug_work, blk_unplug_work);
+	INIT_DELAYED_WORK(&q->delay_work, blk_delay_work);
 
 	kobject_init(&q->kobj, &blk_queue_ktype);
 
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 4d18ff3..b4812f9 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -294,6 +294,11 @@ struct request_queue
 	unsigned long		unplug_delay;	/* After this many jiffies */
 	struct work_struct	unplug_work;
 
+	/*
+	 * Delayed queue handling
+	 */
+	struct delayed_work	delay_work;
+
 	struct backing_dev_info	backing_dev_info;
 
 	/*
@@ -670,6 +675,7 @@ extern int blk_insert_cloned_request(struct request_queue *q,
 extern void blk_plug_device(struct request_queue *);
 extern void blk_plug_device_unlocked(struct request_queue *);
 extern int blk_remove_plug(struct request_queue *);
+extern void blk_delay_queue(struct request_queue *, unsigned long);
 extern void blk_recount_segments(struct request_queue *, struct bio *);
 extern int scsi_cmd_ioctl(struct request_queue *, struct gendisk *, fmode_t,
 			  unsigned int, void __user *);
-- 
1.7.3.2.146.gca209

