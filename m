Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753288Ab1HBBVH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 21:21:07 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:59259 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752527Ab1HBBU6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 21:20:58 -0400
MIME-Version: 1.0
In-Reply-To: <x49d3go98ku.fsf@segfault.boston.devel.redhat.com>
References: <x49d3go98ku.fsf@segfault.boston.devel.redhat.com>
Date: Tue, 2 Aug 2011 09:20:57 +0800
X-Google-Sender-Auth: CoPJlLAJbKMZUyioyfQ1pkO2RuA
Message-ID: <CANejiEXK7NSJo-0vshyX6RSqmRbHmyxAw8_wFQEwvTXrEQF3fg@mail.gmail.com>
Subject: Re: [patch] blk-flush: fix flush policy calculation
From: Shaohua Li <shli@kernel.org>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernle.org>,
        Jens Axboe <jaxboe@fusionio.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/8/2 Jeff Moyer <jmoyer@redhat.com>:
> Hi,
>
> Reading through the code in blk-flush.c, it appears that there is an
> oversight in the policy returned from blk_flush_policy:
>
>        if (fflags & REQ_FLUSH) {
>                if (rq->cmd_flags & REQ_FLUSH)
>                        policy |= REQ_FSEQ_PREFLUSH;
>                if (blk_rq_sectors(rq))
>                        policy |= REQ_FSEQ_DATA;
>                if (!(fflags & REQ_FUA) && (rq->cmd_flags & REQ_FUA))
>                        policy |= REQ_FSEQ_POSTFLUSH;
>        }
>        return policy;
>
> This means that REQ_FSEQ_DATA can only be set if the queue flush_flags
> include FLUSH and/or FUA.  However, the short-circuit for not issuing
> flushes when the device doesn't need/support them depends on
> REQ_FSEQ_DATA being set while the other two bits are clear:
>
>        /*
>         * If there's data but flush is not necessary, the request can be
>         * processed directly without going through flush machinery.  Queue
>         * for normal execution.
>         */
>        if ((policy & REQ_FSEQ_DATA) &&
>            !(policy & (REQ_FSEQ_PREFLUSH | REQ_FSEQ_POSTFLUSH))) {
>                list_add_tail(&rq->queuelist, &q->queue_head);
>                return;
>        }
>
> Given the code as it stands, I don't think the body of this if statement
> will ever be executed.  I've attached a fix for this below.  It seems
> like this could be both a performance and a correctness issue, though
> I've not run into any problems I can directly attribute to this (perhaps
> due to file systems not issuing flushes when support is not advertised?).
>
> Comments are appreciated.
>
> Cheers,
> Jeff
>
> Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
>
> diff --git a/block/blk-flush.c b/block/blk-flush.c
> index bb21e4c..3a06118 100644
> --- a/block/blk-flush.c
> +++ b/block/blk-flush.c
> @@ -95,11 +95,11 @@ static unsigned int blk_flush_policy(unsigned int fflags, struct request *rq)
>  {
>        unsigned int policy = 0;
>
> +       if (blk_rq_sectors(rq))
> +               policy |= REQ_FSEQ_DATA;
>        if (fflags & REQ_FLUSH) {
>                if (rq->cmd_flags & REQ_FLUSH)
>                        policy |= REQ_FSEQ_PREFLUSH;
> -               if (blk_rq_sectors(rq))
> -                       policy |= REQ_FSEQ_DATA;
>                if (!(fflags & REQ_FUA) && (rq->cmd_flags & REQ_FUA))
>                        policy |= REQ_FSEQ_POSTFLUSH;
>        }
> --
__generic_make_request always handles this:
if ((bio->bi_rw & (REQ_FLUSH | REQ_FUA)) && !q->flush_flags) {
                        bio->bi_rw &= ~(REQ_FLUSH | REQ_FUA);
                        if (!nr_sectors) {
                                err = 0;
                                goto end_io;
                        }
                }

Thanks,
Shaohua
