Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752703Ab1DLFCz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 01:02:55 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:51095 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751078Ab1DLFCy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 01:02:54 -0400
Subject: Re: Strange block/scsi/workqueue issue
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Tejun Heo <tj@kernel.org>
Cc: Steven Whitehouse <swhiteho@redhat.com>, linux-kernel@vger.kernel.org,
        Jens Axboe <jaxboe@fusionio.com>
In-Reply-To: <1302583757.2558.21.camel@mulgrave.site>
References: <1302533763.2596.23.camel@dolmen>
	 <20110411171803.GG9673@mtj.dyndns.org>
	 <1302569276.2558.9.camel@mulgrave.site>
	 <20110412025145.GJ9673@mtj.dyndns.org>
	 <1302583757.2558.21.camel@mulgrave.site>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 12 Apr 2011 00:02:51 -0500
Message-ID: <1302584571.2558.24.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-04-11 at 23:49 -0500, James Bottomley wrote:
> The entangled deadlock seems to have been introduced by commit
> 3cca6dc1c81e2407928dc4c6105252146fd3924f prior to that, there was no
> synchronous cancel in the destroy path.
> 
> A fix might be to shunt more stuff off to workqueues, but that's
> producing a more complex system which would be prone to entanglements
> that would be even harder to spot.
> 
> Perhaps a better solution is just not to use sync cancellations in
> block?  As long as the work in the queue holds a queue ref, they can be
> done asynchronously.

So this is a possible implementation, does this fix the problem?
(compile tested only).

James

---

diff --git a/block/blk-core.c b/block/blk-core.c
index 90f22cc..f600f88 100644
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


