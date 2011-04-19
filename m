Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754811Ab1DSLQH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 07:16:07 -0400
Received: from mx1.fusionio.com ([64.244.102.30]:34598 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754363Ab1DSLQF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 07:16:05 -0400
X-ASG-Debug-ID: 1303211763-03d6a5652cd8a80001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4DAD6EF2.5070405@fusionio.com>
Date: Tue, 19 Apr 2011 13:16:02 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Bart Van Assche <bvanassche@acm.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>, Neil Brown <neilb@suse.de>
Subject: Re: [Bug #32982] Kernel locks up a few minutes after boot
References: <OlQwC5HnRsN.A.ULB.OGuqNB@chimera> <_H4l51C1wXN.A.yDC.yGuqNB@chimera> <BANLkTimeaHwBiZoz=isCM=qtBxoxaBqDUw@mail.gmail.com> <BANLkTi=1jO73DXDTD50bVpU82qphVKmRCw@mail.gmail.com> <4DAC2429.5000105@fusionio.com> <BANLkTinCWWYqnksxevho9TN3u6ZC_Rjzwg@mail.gmail.com> <4DAC82E6.3020809@fusionio.com> <BANLkTimaekpwmK+z=ePE+XSP6GUteidwfw@mail.gmail.com> <4DAD5156.2050300@fusionio.com>
X-ASG-Orig-Subj: Re: [Bug #32982] Kernel locks up a few minutes after boot
In-Reply-To: <4DAD5156.2050300@fusionio.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1303211763
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.61303
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-04-19 11:09, Jens Axboe wrote:
> On 2011-04-18 20:32, Bart Van Assche wrote:
>> On Mon, Apr 18, 2011 at 8:28 PM, Jens Axboe <jaxboe@fusionio.com> wrote:
>>> On 2011-04-18 20:21, Bart Van Assche wrote:
>>>> a performance regression in the block layer not related to the md
>>>> issue. If I run a small block IOPS test on a block device created by
>>>> ib_srp (NOOP scheduler) I see about 11% less IOPS than with 2.6.38.3
>>>> (155.000 IOPS with 2.6.38.3 and 140.000 IOPS with 2.6.39-rc3+).
>>>
>>> That's not good. What's the test case?
>>
>> Nothing more than a fio IOPS test:
>>
>> fio --bs=512 --ioengine=libaio --buffered=0 --rw=read --thread
>> --iodepth=64 --numjobs=2 --loops=10000 --group_reporting --size=1G
>>     --gtod_reduce=1 --name=iops-test --filename=/dev/${dev} --invalidate=1
> 
> Bart, can you try the below:

Here's a more complete variant. James, lets get rid of this REENTER
crap. It's completely bogus and triggers falsely for a variety of
reasons. The below will work, but there may be room for improvement on
the SCSI side.

diff --git a/block/blk-core.c b/block/blk-core.c
index 5fa3dd2..4e49665 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -303,15 +303,7 @@ void __blk_run_queue(struct request_queue *q)
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
 
@@ -328,6 +320,7 @@ void blk_run_queue_async(struct request_queue *q)
 	if (likely(!blk_queue_stopped(q)))
 		queue_delayed_work(kblockd_workqueue, &q->delay_work, 0);
 }
+EXPORT_SYMBOL(blk_run_queue_async);
 
 /**
  * blk_run_queue - run a single device queue
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

