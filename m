Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755231Ab2FGFfP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 01:35:15 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:60271 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751731Ab2FGFfN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 01:35:13 -0400
MIME-Version: 1.0
Date: Wed, 6 Jun 2012 22:35:12 -0700
Message-ID: <CAFR8ueeUH-O8+jeZu2Aeyu4ZDHv255a2qqnt0_Af79oY2JGzTw@mail.gmail.com>
Subject: [PATCH] blk-exec-assign-endio-before-queue-dead-check
From: Muthu Kumar <muthu.lkml@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, James.Bottomley@hansenpartnership.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 6, 2012 at 7:40 PM, Tejun Heo <tj@kernel.org> wrote:
> On Wed, Jun 06, 2012 at 02:24:35PM -0700, Muthu Kumar wrote:
>> How about this change?
>>
>> diff --git a/block/blk-exec.c b/block/blk-exec.c
>> index fb2cbd5..6bf5c0b 100644
>> --- a/block/blk-exec.c
>> +++ b/block/blk-exec.c
>> @@ -56,8 +56,10 @@ void blk_execute_rq_nowait(struct request_queue *q, struct ge
>>         if (unlikely(blk_queue_dead(q))) {
>>                 spin_unlock_irq(q->queue_lock);
>>                 rq->errors = -ENXIO;
>> -               if (rq->end_io)
>> -                       rq->end_io(rq, rq->errors);
>> +                if (done)
>> +                    done(rq, rq->errors);
>> +                else if (rq->end_io)    //XXX Not sure if this check and end_io
>> +                    rq->end_io(rq, rq->errors);
>>                 return;
>>         }
>>
>> Only one driver - sx8.c, doesn't set done() function and every one
>> else expects done() to be called with error.
>
> Looks like the bug there is rq->rq_disk and rq->end_io assignments
> happening after the queue_dead check.  Just move the two lines before
> queue_head check?
>
> Thanks.

Thought about that. But the problem is, original rq->end_io is not
saved before the new assignment. But exploring further, I guess its ok
in this use case.

One more thing to consider is, the completion function is called from
the same calling context here. As far as my check, it looks ok. Let me
know if you think otherwise.

Anyway, patch attached (as well as inline).

Regards,
Muthu

-----------------------
blk-exec.c: In blk_execute_rq_nowait(), assign rq->endio,rq_disk
before queue dead check.

Signed-off-by: Muthukumar Ratty <muthur@gmail.com>
CC: Tejun Heo <tj@kernel.org>
CC: Jens Axboe <axboe@kernel.dk>
CC: James Bottomley <James.Bottomley@hansenpartnership.com>

-----------------------
diff --git a/block/blk-exec.c b/block/blk-exec.c
index fb2cbd5..f8b00c7 100644
--- a/block/blk-exec.c
+++ b/block/blk-exec.c
@@ -53,6 +53,9 @@ void blk_execute_rq_nowait(struct request_queue *q, struct gen
        WARN_ON(irqs_disabled());
        spin_lock_irq(q->queue_lock);

+       rq->rq_disk = bd_disk;
+       rq->end_io = done;
+
        if (unlikely(blk_queue_dead(q))) {
                spin_unlock_irq(q->queue_lock);
                rq->errors = -ENXIO;
@@ -61,8 +64,6 @@ void blk_execute_rq_nowait(struct request_queue *q, struct gen
                return;
        }

-       rq->rq_disk = bd_disk;
-       rq->end_io = done;
        __elv_add_request(q, rq, where);
        __blk_run_queue(q);
        /* the queue is stopped so it won't be run */

-------------------------------------------------



>
> --
> tejun













>
> Thanks.
>
> --
> tejun
