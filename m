Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756913Ab2FFVYh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 17:24:37 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:58808 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752170Ab2FFVYg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 17:24:36 -0400
MIME-Version: 1.0
Date: Wed, 6 Jun 2012 14:24:35 -0700
Message-ID: <CAFR8uefaH_MzjfkPTY1+D5yav8cawtOS7NKyexzRG318Bris1w@mail.gmail.com>
Subject: RFC:blk-exec-call-completion-if-queue-dead [was Q:
 blk_execute_rq_nowait() doesn't call completion in case of dead queue
From: Muthu Kumar <muthu.lkml@gmail.com>
To: Jens Axboe <axboe@kernel.dk>, tj@kernel.org,
        James.Bottomley@hansenpartnership.com
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

How about this change?

diff --git a/block/blk-exec.c b/block/blk-exec.c
index fb2cbd5..6bf5c0b 100644
--- a/block/blk-exec.c
+++ b/block/blk-exec.c
@@ -56,8 +56,10 @@ void blk_execute_rq_nowait(struct request_queue *q, struct ge
        if (unlikely(blk_queue_dead(q))) {
                spin_unlock_irq(q->queue_lock);
                rq->errors = -ENXIO;
-               if (rq->end_io)
-                       rq->end_io(rq, rq->errors);
+                if (done)
+                    done(rq, rq->errors);
+                else if (rq->end_io)    //XXX Not sure if this check and end_io
+                    rq->end_io(rq, rq->errors);
                return;
        }

Only one driver - sx8.c, doesn't set done() function and every one
else expects done() to be called with error.

Regards,
Muthu


On Wed, Jun 6, 2012 at 11:59 AM, Muthu Kumar <muthu.lkml@gmail.com> wrote:
> Jens, Tejun et al,
> blk_execute_rq() calls blk_execute_rq_nowait() with blk_end_sync_rq()
> as the completion (done) routine. And then waits for the completion().
>
>
>        rq->end_io_data = &wait;
>        blk_execute_rq_nowait(q, bd_disk, rq, at_head, blk_end_sync_rq);
>        ...
>        ...
>        wait_for_completion(&wait)
>
> But in blk_execute_rq_nowait() if the queue is dead, completion
> routine is not called. Shouldn't we have to call the above completion
> (done()) to wake up the wait_for_completion()?
>
>
>        if (unlikely(blk_queue_dead(q))) {
>                spin_unlock_irq(q->queue_lock);
>                rq->errors = -ENXIO;
>                if (rq->end_io)
>                        rq->end_io(rq, rq->errors);
>                return;
>       }
>
> Thanks.
>
> Regards,
> Muthu
