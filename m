Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757273Ab1DLU1h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 16:27:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55586 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757254Ab1DLU1f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 16:27:35 -0400
Subject: Re: Strange block/scsi/workqueue issue
From: Steven Whitehouse <swhiteho@redhat.com>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
        Jens Axboe <jaxboe@fusionio.com>
In-Reply-To: <1302638216.2604.35.camel@mulgrave.site>
References: <1302533763.2596.23.camel@dolmen>
	 <20110411171803.GG9673@mtj.dyndns.org>
	 <1302569276.2558.9.camel@mulgrave.site>
	 <20110412025145.GJ9673@mtj.dyndns.org>
	 <1302583757.2558.21.camel@mulgrave.site>
	 <1302584571.2558.24.camel@mulgrave.site>  <1302597737.2661.5.camel@dolmen>
	 <1302615745.2604.6.camel@mulgrave.site>  <1302617212.2661.14.camel@dolmen>
	 <1302621261.2604.18.camel@mulgrave.site>  <1302624266.2661.21.camel@dolmen>
	 <1302625621.2604.24.camel@mulgrave.site>  <1302627097.2661.25.camel@dolmen>
	 <1302630090.2604.30.camel@mulgrave.site>  <1302633208.2661.29.camel@dolmen>
	 <1302638216.2604.35.camel@mulgrave.site>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat UK Ltd
Date: Tue, 12 Apr 2011 21:30:26 +0100
Message-ID: <1302640226.2661.34.camel@dolmen>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, 2011-04-12 at 14:56 -0500, James Bottomley wrote:
> On Tue, 2011-04-12 at 19:33 +0100, Steven Whitehouse wrote:
> > Hi,
> > 
> > On Tue, 2011-04-12 at 12:41 -0500, James Bottomley wrote:
> > > On Tue, 2011-04-12 at 17:51 +0100, Steven Whitehouse wrote:
> > > > Still not quite there, but looking more hopeful now,
> > > 
> > > Not sure I share your optimism; but this one
> > > 
> > Neither do I any more :-) Looks like we are back in blk_peek_request()
> > again. 
> [...]
> >                 if (!q->elevator->ops || !q->elevator->ops->elevator_dispatch_fn
> > (q, 0))
> >     6d62:       49 8b 44 24 18          mov    0x18(%r12),%rax
> >     6d67:       48 8b 00                mov    (%rax),%rax
> >     6d6a:       48 85 c0                test   %rax,%rax
> >     6d6d:       74 0c                   je     6d7b <blk_peek_request+0x11b>
> >     6d6f:       31 f6                   xor    %esi,%esi
> >     6d71:       4c 89 e7                mov    %r12,%rdi                                <----- here
> >     6d74:       ff 50 28                callq  *0x28(%rax)
> >     6d77:       85 c0                   test   %eax,%eax
> >     6d79:       75 da                   jne    6d55 <blk_peek_request+0xf5>
> >     6d7b:       45 31 ed                xor    %r13d,%r13d
> 
> Hmm, wrong signal for no elevator then.  How about this?
> 
> James
> 
That seems to do the trick... the box has been booted for several
minutes now and no sign of anything untoward so far :-)

Below is the cumulative patch which I now have applied to the kernel.
Many thanks for all your help in debugging this, its greatly
appreciated :-)

Steve.

diff --git a/block/blk-core.c b/block/blk-core.c
index 90f22cc..7f15eb7 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -219,6 +219,7 @@ static void blk_delay_work(struct work_struct *work)
 	spin_lock_irq(q->queue_lock);
 	__blk_run_queue(q, false);
 	spin_unlock_irq(q->queue_lock);
+	blk_put_queue(q);
 }
 
 /**
@@ -233,7 +234,8 @@ static void blk_delay_work(struct work_struct *work)
  */
 void blk_delay_queue(struct request_queue *q, unsigned long msecs)
 {
-	schedule_delayed_work(&q->delay_work, msecs_to_jiffies(msecs));
+	if (!blk_get_queue(q))
+		schedule_delayed_work(&q->delay_work, msecs_to_jiffies(msecs));
 }
 EXPORT_SYMBOL(blk_delay_queue);
 
@@ -271,7 +273,8 @@ EXPORT_SYMBOL(blk_start_queue);
  **/
 void blk_stop_queue(struct request_queue *q)
 {
-	__cancel_delayed_work(&q->delay_work);
+	if (__cancel_delayed_work(&q->delay_work))
+		blk_put_queue(q);
 	queue_flag_set(QUEUE_FLAG_STOPPED, q);
 }
 EXPORT_SYMBOL(blk_stop_queue);
@@ -297,7 +300,8 @@ EXPORT_SYMBOL(blk_stop_queue);
 void blk_sync_queue(struct request_queue *q)
 {
 	del_timer_sync(&q->timeout);
-	cancel_delayed_work_sync(&q->delay_work);
+	if (__cancel_delayed_work(&q->delay_work))
+		blk_put_queue(q);
 	queue_sync_plugs(q);
 }
 EXPORT_SYMBOL(blk_sync_queue);
@@ -324,7 +328,7 @@ void __blk_run_queue(struct request_queue *q, bool force_kblockd)
 	if (!force_kblockd && !queue_flag_test_and_set(QUEUE_FLAG_REENTER, q)) {
 		q->request_fn(q);
 		queue_flag_clear(QUEUE_FLAG_REENTER, q);
-	} else
+	} else if (!blk_get_queue(q))
 		queue_delayed_work(kblockd_workqueue, &q->delay_work, 0);
 }
 EXPORT_SYMBOL(__blk_run_queue);
diff --git a/block/blk.h b/block/blk.h
index 6126346..4df474d 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -62,7 +62,8 @@ static inline struct request *__elv_next_request(struct request_queue *q)
 			return rq;
 		}
 
-		if (!q->elevator->ops->elevator_dispatch_fn(q, 0))
+		if (test_bit(QUEUE_FLAG_DEAD, &q->queue_flags) ||
+		    !q->elevator->ops->elevator_dispatch_fn(q, 0))
 			return NULL;
 	}
 }
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index e44ff64..2e85668 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -323,7 +323,6 @@ static void scsi_device_dev_release_usercontext(struct work_struct *work)
 	}
 
 	if (sdev->request_queue) {
-		sdev->request_queue->queuedata = NULL;
 		/* user context needed to free queue */
 		scsi_free_queue(sdev->request_queue);
 		/* temporary expedient, try to catch use of queue lock
@@ -937,6 +936,7 @@ void __scsi_remove_device(struct scsi_device *sdev)
 	if (sdev->host->hostt->slave_destroy)
 		sdev->host->hostt->slave_destroy(sdev);
 	transport_destroy_device(dev);
+	sdev->request_queue->queuedata = NULL;
 	put_device(dev);
 }
 


