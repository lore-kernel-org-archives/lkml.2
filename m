Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761329Ab2FHPho (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 11:37:44 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:58906 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757781Ab2FHPhm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 11:37:42 -0400
MIME-Version: 1.0
In-Reply-To: <CAFR8ueeU0z69zAHxJULohZoJ3ONX-ku2mzmUiUatQ=n-V4Eq+w@mail.gmail.com>
References: <CAFR8ueeU0z69zAHxJULohZoJ3ONX-ku2mzmUiUatQ=n-V4Eq+w@mail.gmail.com>
Date: Fri, 8 Jun 2012 08:37:41 -0700
Message-ID: <CAFR8uedpGWgOzvGkFAhjMdEM__RdPQSvYYX99pEmPgoXaB0UAA@mail.gmail.com>
Subject: Re: [PATCH] block: In blk_execute_rq_nowait, init rq->end_io before
 checking for dead queue.
From: Muthu Kumar <muthu.lkml@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, James.Bottomley@hansenpartnership.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun, Jens,
This is a real problem, right? Should we fix it differently?

Regards,
Muthu

On Wed, Jun 6, 2012 at 11:27 PM, Muthu Kumar <muthu.lkml@gmail.com> wrote:
> On Wed, Jun 6, 2012 at 11:16 PM, Tejun Heo <tj@kernel.org> wrote:
>> Sorry to be nit-picky but Jens would appreciate proper subject and it
>> would also be nice to mention the locking change (or even separate
>> that into a separate patch).
>
> No problem. Changed the subject and also added the info about queue
> lock in the description. Please check.
>
> -----------------------
> blk-exec.c: In blk_execute_rq_nowait(), if the queue is dead, call to
> done() routine is not made. That will result in blk_execute_rq() stuck
> in wait_for_completion(). Avoid this by initializing rq->end_io to
> done() routine before we check for dead queue.
>
> Also, in case of dead queue, call the completion routine with queue->lock held.
>
>
> Signed-off-by: Muthukumar Ratty <muthur@gmail.com>
> CC: Tejun Heo <tj@kernel.org>
> CC: Jens Axboe <axboe@kernel.dk>
> CC: James Bottomley <James.Bottomley@hansenpartnership.com>
>
> -----------------------
>
> diff --git a/block/blk-exec.c b/block/blk-exec.c
> index fb2cbd5..284bf56 100644
> --- a/block/blk-exec.c
> +++ b/block/blk-exec.c
> @@ -53,16 +53,17 @@ void blk_execute_rq_nowait(struct request_queue
> *q, struct gendisk *bd_disk,
>        WARN_ON(irqs_disabled());
>        spin_lock_irq(q->queue_lock);
>
> +       rq->rq_disk = bd_disk;
> +       rq->end_io = done;
> +
>        if (unlikely(blk_queue_dead(q))) {
> -               spin_unlock_irq(q->queue_lock);
>                rq->errors = -ENXIO;
>                if (rq->end_io)
>                        rq->end_io(rq, rq->errors);
> +               spin_unlock_irq(q->queue_lock);
>                return;
>        }
>
> -       rq->rq_disk = bd_disk;
> -       rq->end_io = done;
>        __elv_add_request(q, rq, where);
>        __blk_run_queue(q);
>        /* the queue is stopped so it won't be run */
>
>
> ------------------------------------
>
>
>
>
>
>
>
>>
>> Thanks.
>>
>> --
>> tejun
