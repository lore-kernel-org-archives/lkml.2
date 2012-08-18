Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753691Ab2HRL46 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2012 07:56:58 -0400
Received: from relay02ant.iops.be ([212.53.4.35]:41934 "EHLO
	relay02ant.iops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751830Ab2HRL44 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2012 07:56:56 -0400
Message-ID: <502F8300.2060307@acm.org>
Date: Sat, 18 Aug 2012 11:56:48 +0000
From: Bart Van Assche <bvanassche@acm.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: Chanho Min <chanho0207@gmail.com>
CC: James Bottomley <James.Bottomley@hansenpartnership.com>,
        Mike Christie <michaelc@cs.wisc.edu>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH RESEND] remove the queue unlock in scsi_requset_fn
References: <CAOAMb1Dd5_KWQme+EzXdpnABk=A50+vXuLMoS+r5et6=o0605g@mail.gmail.com> <CAOAMb1Dp=E6fjMhdh6ze6Hq48qUixTpsqHZf3z742AUAqhU5Ug@mail.gmail.com> <1344946071.3117.26.camel@dabdike.int.hansenpartnership.com> <CAOAMb1COJbAF=ys7ZcpTuJNP6QzbQzuqz7gS4qPqSc1rfbnHTw@mail.gmail.com> <502CA6C3.4040903@acm.org>
In-Reply-To: <502CA6C3.4040903@acm.org>
X-Enigmail-Version: 1.5a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/16/12 07:52, Bart Van Assche wrote:
> On 08/16/12 01:35, Chanho Min wrote:
>>> functions will occur in line.  I also don't see why the sdev reference
>>> couldn't drop to zero here.
>> scsi_request_fn is called under the lock of request_queue->queue_lock.
>> If we drop the sdev reference to zero here,
>> scsi_device_dev_release_usercontext is
>> invoked and make request_queue to NULL. When caller of scsi_request_fn try to
>> unlock request_queue->queue_lock, the oops is occurred.
> 
> Whether or not your patch is applied, if the put_device() call in
> scsi_request_fn() decreases the sdev reference count to zero, the
> scsi_request_fn() caller will still try to unlock the queue lock after
> scsi_request_fn() finished and hence will trigger a use-after-free. I'm
> afraid the only real solution is to modify the SCSI and/or block layers
> such that scsi_remove_device() can't finish while scsi_request_fn() is
> in progress. And once that is guaranteed the get_device() / put_device()
> pair can be left out from scsi_request_fn().

(replying to my own e-mail)

How about the patch below ?

[PATCH] Fix device removal race

If the put_device() call in scsi_request_fn() drops the sdev refcount
to zero then the spin_lock_irq() call after the put_device() call
triggers a use-after-free. Avoid that by making sure that blk_cleanup_queue()
can only finish after all active scsi_request_fn() calls have returned.
---
 block/blk-core.c        |    1 +
 drivers/scsi/scsi_lib.c |   10 ++--------
 include/linux/blkdev.h  |    5 +++++
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 4b4dbdf..0e4da3b 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -388,6 +388,7 @@ void blk_drain_queue(struct request_queue *q, bool drain_all)
 			__blk_run_queue(q);
 
 		drain |= q->nr_rqs_elvpriv;
+		drain |= q->request_fn_active;
 
 		/*
 		 * Unfortunately, requests are queued at and tracked from
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index ffd7773..10bb348 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1514,9 +1514,7 @@ static void scsi_request_fn(struct request_queue *q)
 	struct scsi_cmnd *cmd;
 	struct request *req;
 
-	if(!get_device(&sdev->sdev_gendev))
-		/* We must be tearing the block queue down already */
-		return;
+	q->request_fn_active++;
 
 	/*
 	 * To start with, we keep looping until the queue is empty, or until
@@ -1626,11 +1624,7 @@ out_delay:
 	if (sdev->device_busy == 0)
 		blk_delay_queue(q, SCSI_QUEUE_DELAY);
 out:
-	/* must be careful here...if we trigger the ->remove() function
-	 * we cannot be holding the q lock */
-	spin_unlock_irq(q->queue_lock);
-	put_device(&sdev->sdev_gendev);
-	spin_lock_irq(q->queue_lock);
+	q->request_fn_active--;
 }
 
 u64 scsi_calculate_bounce_limit(struct Scsi_Host *shost)
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 4e72a9d..11c1987 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -377,6 +377,11 @@ struct request_queue {
 
 	unsigned int		nr_sorted;
 	unsigned int		in_flight[2];
+	/*
+	 * Number of active request_fn() calls for those request_fn()
+	 * implementations that unlock the queue_lock, e.g. scsi_request_fn().
+	 */
+	unsigned int		request_fn_active;
 
 	unsigned int		rq_timeout;
 	struct timer_list	timeout;
-- 
1.7.7


