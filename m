Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754899Ab1DTND0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 09:03:26 -0400
Received: from mx1.fusionio.com ([64.244.102.30]:46536 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752691Ab1DTNDY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 09:03:24 -0400
X-ASG-Debug-ID: 1303304603-03d6a55d38e4e70001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4DAED99B.1020601@fusionio.com>
Date: Wed, 20 Apr 2011 15:03:23 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Michal Hocko <mhocko@suse.cz>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.39-rc4 BUG: unable to handle kernel NULL pointer dereference
 at  0000000c IP: cfq_insert_request+0x1d/0x3f5
References: <20110420125824.GA3507@tiehlicka.suse.cz>
X-ASG-Orig-Subj: Re: 2.6.39-rc4 BUG: unable to handle kernel NULL pointer dereference
 at  0000000c IP: cfq_insert_request+0x1d/0x3f5
In-Reply-To: <20110420125824.GA3507@tiehlicka.suse.cz>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1303304603
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.20
X-Barracuda-Spam-Status: No, SCORE=0.20 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=PR0N_SUBJECT
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.61407
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
	0.20 PR0N_SUBJECT           Subject has letters around special characters (pr0n)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-04-20 14:58, Michal Hocko wrote:
> Hi,
> I am not able to boot with the current git tree
> (2.6.39-rc4-00089-g2f666bc). 2.6.39-rc3 boots just fine.
> 
> The backtrace [1] looks really messy.
> 
> I have seen a similar backtrace at https://lkml.org/lkml/2011/3/25/169
> and tried the patch from https://lkml.org/lkml/2011/3/25/173 but it
> didn't help. The backtrace looks similar (much smaller) but the machine
> ends up dead as well with unbalanced preempt counter[2].
> 
> The config is attached.
> 
> Is this a known problem?

Not sure, can you please try with the attached patch applied as well?

diff --git a/block/blk-core.c b/block/blk-core.c
index 5fa3dd2..a2e58ee 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -292,7 +292,6 @@ EXPORT_SYMBOL(blk_sync_queue);
 /**
  * __blk_run_queue - run a single device queue
  * @q:	The queue to run
- * @force_kblockd: Don't run @q->request_fn directly.  Use kblockd.
  *
  * Description:
  *    See @blk_run_queue. This variant must be called with the queue lock
@@ -303,15 +302,7 @@ void __blk_run_queue(struct request_queue *q)
 	if (unlikely(blk_queue_stopped(q)))
 		return;
 
-	/*
-	 * Only recurse once to avoid overrunning the stack, let the unplug
-	 * handling reinvoke the handler shortly if we already got there.
-	 */
-	if (!queue_flag_test_and_set(QUEUE_FLAG_REENTER, q)) {
-		q->request_fn(q);
-		queue_flag_clear(QUEUE_FLAG_REENTER, q);
-	} else
-		queue_delayed_work(kblockd_workqueue, &q->delay_work, 0);
+	q->request_fn(q);
 }
 EXPORT_SYMBOL(__blk_run_queue);
 
@@ -328,6 +319,7 @@ void blk_run_queue_async(struct request_queue *q)
 	if (likely(!blk_queue_stopped(q)))
 		queue_delayed_work(kblockd_workqueue, &q->delay_work, 0);
 }
+EXPORT_SYMBOL(blk_run_queue_async);
 
 /**
  * blk_run_queue - run a single device queue
@@ -2787,7 +2779,6 @@ void blk_flush_plug_list(struct blk_plug *plug, bool from_schedule)
 
 	local_irq_restore(flags);
 }
-EXPORT_SYMBOL(blk_flush_plug_list);
 
 void blk_finish_plug(struct blk_plug *plug)
 {
diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index 6d73512..bd23631 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -66,14 +66,14 @@ queue_requests_store(struct request_queue *q, const char *page, size_t count)
 
 	if (rl->count[BLK_RW_SYNC] >= q->nr_requests) {
 		blk_set_queue_full(q, BLK_RW_SYNC);
-	} else if (rl->count[BLK_RW_SYNC]+1 <= q->nr_requests) {
+	} else {
 		blk_clear_queue_full(q, BLK_RW_SYNC);
 		wake_up(&rl->wait[BLK_RW_SYNC]);
 	}
 
 	if (rl->count[BLK_RW_ASYNC] >= q->nr_requests) {
 		blk_set_queue_full(q, BLK_RW_ASYNC);
-	} else if (rl->count[BLK_RW_ASYNC]+1 <= q->nr_requests) {
+	} else {
 		blk_clear_queue_full(q, BLK_RW_ASYNC);
 		wake_up(&rl->wait[BLK_RW_ASYNC]);
 	}
@@ -508,8 +508,10 @@ int blk_register_queue(struct gendisk *disk)
 		return ret;
 
 	ret = kobject_add(&q->kobj, kobject_get(&dev->kobj), "%s", "queue");
-	if (ret < 0)
+	if (ret < 0) {
+		blk_trace_remove_sysfs(dev);
 		return ret;
+	}
 
 	kobject_uevent(&q->kobj, KOBJ_ADD);
 
diff --git a/block/blk.h b/block/blk.h
index c9df8fc..6126346 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -22,7 +22,6 @@ void blk_rq_timed_out_timer(unsigned long data);
 void blk_delete_timer(struct request *);
 void blk_add_timer(struct request *);
 void __generic_unplug_device(struct request_queue *);
-void blk_run_queue_async(struct request_queue *q);
 
 /*
  * Internal atomic flags for request handling
diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 46b0a1d..5b52011 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -2582,28 +2582,20 @@ static void cfq_put_queue(struct cfq_queue *cfqq)
 }
 
 /*
- * Must always be called with the rcu_read_lock() held
+ * Call func for each cic attached to this ioc.
  */
 static void
-__call_for_each_cic(struct io_context *ioc,
-		    void (*func)(struct io_context *, struct cfq_io_context *))
+call_for_each_cic(struct io_context *ioc,
+		  void (*func)(struct io_context *, struct cfq_io_context *))
 {
 	struct cfq_io_context *cic;
 	struct hlist_node *n;
 
+	rcu_read_lock();
+
 	hlist_for_each_entry_rcu(cic, n, &ioc->cic_list, cic_list)
 		func(ioc, cic);
-}
 
-/*
- * Call func for each cic attached to this ioc.
- */
-static void
-call_for_each_cic(struct io_context *ioc,
-		  void (*func)(struct io_context *, struct cfq_io_context *))
-{
-	rcu_read_lock();
-	__call_for_each_cic(ioc, func);
 	rcu_read_unlock();
 }
 
@@ -2664,7 +2656,7 @@ static void cfq_free_io_context(struct io_context *ioc)
 	 * should be ok to iterate over the known list, we will see all cic's
 	 * since no new ones are added.
 	 */
-	__call_for_each_cic(ioc, cic_free_func);
+	call_for_each_cic(ioc, cic_free_func);
 }
 
 static void cfq_put_cooperator(struct cfq_queue *cfqq)
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index ab55c2f..e9901b8 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -411,8 +411,6 @@ static void scsi_run_queue(struct request_queue *q)
 	list_splice_init(&shost->starved_list, &starved_list);
 
 	while (!list_empty(&starved_list)) {
-		int flagset;
-
 		/*
 		 * As long as shost is accepting commands and we have
 		 * starved queues, call blk_run_queue. scsi_request_fn
@@ -435,20 +433,7 @@ static void scsi_run_queue(struct request_queue *q)
 			continue;
 		}
 
-		spin_unlock(shost->host_lock);
-
-		spin_lock(sdev->request_queue->queue_lock);
-		flagset = test_bit(QUEUE_FLAG_REENTER, &q->queue_flags) &&
-				!test_bit(QUEUE_FLAG_REENTER,
-					&sdev->request_queue->queue_flags);
-		if (flagset)
-			queue_flag_set(QUEUE_FLAG_REENTER, sdev->request_queue);
-		__blk_run_queue(sdev->request_queue);
-		if (flagset)
-			queue_flag_clear(QUEUE_FLAG_REENTER, sdev->request_queue);
-		spin_unlock(sdev->request_queue->queue_lock);
-
-		spin_lock(shost->host_lock);
+		blk_run_queue_async(sdev->request_queue);
 	}
 	/* put any unprocessed entries back */
 	list_splice(&starved_list, &shost->starved_list);
diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index 28c3350..815069d 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -3816,28 +3816,17 @@ fail_host_msg:
 static void
 fc_bsg_goose_queue(struct fc_rport *rport)
 {
-	int flagset;
-	unsigned long flags;
-
 	if (!rport->rqst_q)
 		return;
 
+	/*
+	 * This get/put dance makes no sense
+	 */
 	get_device(&rport->dev);
-
-	spin_lock_irqsave(rport->rqst_q->queue_lock, flags);
-	flagset = test_bit(QUEUE_FLAG_REENTER, &rport->rqst_q->queue_flags) &&
-		  !test_bit(QUEUE_FLAG_REENTER, &rport->rqst_q->queue_flags);
-	if (flagset)
-		queue_flag_set(QUEUE_FLAG_REENTER, rport->rqst_q);
-	__blk_run_queue(rport->rqst_q);
-	if (flagset)
-		queue_flag_clear(QUEUE_FLAG_REENTER, rport->rqst_q);
-	spin_unlock_irqrestore(rport->rqst_q->queue_lock, flags);
-
+	blk_run_queue_async(rport->rqst_q);
 	put_device(&rport->dev);
 }
 
-
 /**
  * fc_bsg_rport_dispatch - process rport bsg requests and dispatch to LLDD
  * @q:		rport request queue
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index cbbfd98..2ad95fa 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -388,20 +388,19 @@ struct request_queue
 #define	QUEUE_FLAG_SYNCFULL	3	/* read queue has been filled */
 #define QUEUE_FLAG_ASYNCFULL	4	/* write queue has been filled */
 #define QUEUE_FLAG_DEAD		5	/* queue being torn down */
-#define QUEUE_FLAG_REENTER	6	/* Re-entrancy avoidance */
-#define QUEUE_FLAG_ELVSWITCH	7	/* don't use elevator, just do FIFO */
-#define QUEUE_FLAG_BIDI		8	/* queue supports bidi requests */
-#define QUEUE_FLAG_NOMERGES     9	/* disable merge attempts */
-#define QUEUE_FLAG_SAME_COMP   10	/* force complete on same CPU */
-#define QUEUE_FLAG_FAIL_IO     11	/* fake timeout */
-#define QUEUE_FLAG_STACKABLE   12	/* supports request stacking */
-#define QUEUE_FLAG_NONROT      13	/* non-rotational device (SSD) */
+#define QUEUE_FLAG_ELVSWITCH	6	/* don't use elevator, just do FIFO */
+#define QUEUE_FLAG_BIDI		7	/* queue supports bidi requests */
+#define QUEUE_FLAG_NOMERGES     8	/* disable merge attempts */
+#define QUEUE_FLAG_SAME_COMP	9	/* force complete on same CPU */
+#define QUEUE_FLAG_FAIL_IO     10	/* fake timeout */
+#define QUEUE_FLAG_STACKABLE   11	/* supports request stacking */
+#define QUEUE_FLAG_NONROT      12	/* non-rotational device (SSD) */
 #define QUEUE_FLAG_VIRT        QUEUE_FLAG_NONROT /* paravirt device */
-#define QUEUE_FLAG_IO_STAT     15	/* do IO stats */
-#define QUEUE_FLAG_DISCARD     16	/* supports DISCARD */
-#define QUEUE_FLAG_NOXMERGES   17	/* No extended merges */
-#define QUEUE_FLAG_ADD_RANDOM  18	/* Contributes to random pool */
-#define QUEUE_FLAG_SECDISCARD  19	/* supports SECDISCARD */
+#define QUEUE_FLAG_IO_STAT     13	/* do IO stats */
+#define QUEUE_FLAG_DISCARD     14	/* supports DISCARD */
+#define QUEUE_FLAG_NOXMERGES   15	/* No extended merges */
+#define QUEUE_FLAG_ADD_RANDOM  16	/* Contributes to random pool */
+#define QUEUE_FLAG_SECDISCARD  17	/* supports SECDISCARD */
 
 #define QUEUE_FLAG_DEFAULT	((1 << QUEUE_FLAG_IO_STAT) |		\
 				 (1 << QUEUE_FLAG_STACKABLE)	|	\
@@ -699,6 +698,7 @@ extern void blk_sync_queue(struct request_queue *q);
 extern void __blk_stop_queue(struct request_queue *q);
 extern void __blk_run_queue(struct request_queue *q);
 extern void blk_run_queue(struct request_queue *);
+extern void blk_run_queue_async(struct request_queue *q);
 extern int blk_rq_map_user(struct request_queue *, struct request *,
 			   struct rq_map_data *, void __user *, unsigned long,
 			   gfp_t);

-- 
Jens Axboe

