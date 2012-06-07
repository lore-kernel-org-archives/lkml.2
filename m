Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759505Ab2FGCkb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 22:40:31 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:46182 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754789Ab2FGCka (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 22:40:30 -0400
Date: Thu, 7 Jun 2012 11:40:22 +0900
From: Tejun Heo <tj@kernel.org>
To: Muthu Kumar <muthu.lkml@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, James.Bottomley@hansenpartnership.com,
        linux-kernel@vger.kernel.org
Subject: Re: RFC:blk-exec-call-completion-if-queue-dead [was Q:
 blk_execute_rq_nowait() doesn't call completion in case of dead queue
Message-ID: <20120607024022.GI21357@google.com>
References: <CAFR8uefaH_MzjfkPTY1+D5yav8cawtOS7NKyexzRG318Bris1w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFR8uefaH_MzjfkPTY1+D5yav8cawtOS7NKyexzRG318Bris1w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 06, 2012 at 02:24:35PM -0700, Muthu Kumar wrote:
> How about this change?
> 
> diff --git a/block/blk-exec.c b/block/blk-exec.c
> index fb2cbd5..6bf5c0b 100644
> --- a/block/blk-exec.c
> +++ b/block/blk-exec.c
> @@ -56,8 +56,10 @@ void blk_execute_rq_nowait(struct request_queue *q, struct ge
>         if (unlikely(blk_queue_dead(q))) {
>                 spin_unlock_irq(q->queue_lock);
>                 rq->errors = -ENXIO;
> -               if (rq->end_io)
> -                       rq->end_io(rq, rq->errors);
> +                if (done)
> +                    done(rq, rq->errors);
> +                else if (rq->end_io)    //XXX Not sure if this check and end_io
> +                    rq->end_io(rq, rq->errors);
>                 return;
>         }
> 
> Only one driver - sx8.c, doesn't set done() function and every one
> else expects done() to be called with error.

Looks like the bug there is rq->rq_disk and rq->end_io assignments
happening after the queue_dead check.  Just move the two lines before
queue_head check?

Thanks.

-- 
tejun
