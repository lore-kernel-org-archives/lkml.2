Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758905Ab1CCVYT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 16:24:19 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:32788 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758699Ab1CCVYR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 16:24:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=csos1JCW1hNVOls7BzhORalMmvOeqdKl9CHEleyPmqMI2n/Ev/M3IZRgug8FCxDRE8
         9iJlFLj9oFYiphRd4+dEvOk0CM8ROaNA/TUtoLngciiIi1NT1s6IlvqCyH4v7/M7tXS8
         rpJ052WGzWvj8+601uaV4s49vmFlGMHsaP30U=
MIME-Version: 1.0
In-Reply-To: <1295659049-2688-6-git-send-email-jaxboe@fusionio.com>
References: <1295659049-2688-1-git-send-email-jaxboe@fusionio.com> <1295659049-2688-6-git-send-email-jaxboe@fusionio.com>
From: Mike Snitzer <snitzer@redhat.com>
Date: Thu, 3 Mar 2011 16:23:56 -0500
X-Google-Sender-Auth: 2yfir-9ZuP1-jojWwmnRZeBEcng
Message-ID: <AANLkTin8FoXX6oqUyW+scwhadyX-TfW16_oKjvngU9-m@mail.gmail.com>
Subject: Re: [PATCH 05/10] block: remove per-queue plugging
To: Jens Axboe <jaxboe@fusionio.com>
Cc: linux-kernel@vger.kernel.org, hch@infradead.org
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> diff --git a/block/blk-flush.c b/block/blk-flush.c
> index 54b123d..c0a07aa 100644
> --- a/block/blk-flush.c
> +++ b/block/blk-flush.c
> @@ -59,7 +59,6 @@ static struct request *blk_flush_complete_seq(struct request_queue *q,
>  static void blk_flush_complete_seq_end_io(struct request_queue *q,
>                                          unsigned seq, int error)
>  {
> -       bool was_empty = elv_queue_empty(q);
>        struct request *next_rq;
>
>        next_rq = blk_flush_complete_seq(q, seq, error);
> @@ -68,7 +67,7 @@ static void blk_flush_complete_seq_end_io(struct request_queue *q,
>         * Moving a request silently to empty queue_head may stall the
>         * queue.  Kick the queue in those cases.
>         */
> -       if (was_empty && next_rq)
> +       if (next_rq)
>                __blk_run_queue(q);
>  }
>
...
> diff --git a/block/elevator.c b/block/elevator.c
> index a9fe237..d5d17a4 100644
> --- a/block/elevator.c
> +++ b/block/elevator.c
> @@ -619,8 +619,6 @@ void elv_quiesce_end(struct request_queue *q)
...
> -int elv_queue_empty(struct request_queue *q)
> -{
> -       struct elevator_queue *e = q->elevator;
> -
> -       if (!list_empty(&q->queue_head))
> -               return 0;
> -
> -       if (e->ops->elevator_queue_empty_fn)
> -               return e->ops->elevator_queue_empty_fn(q);
> -
> -       return 1;
> -}
> -EXPORT_SYMBOL(elv_queue_empty);
> -

Your latest 'for-2.6.39/stack-unplug' rebase (commit 7703acb01e)
misses removing a call to elv_queue_empty() in
block/blk-flush.c:flush_data_end_io()

  CC      block/blk-flush.o
block/blk-flush.c: In function ‘flush_data_end_io’:
block/blk-flush.c:266: error: implicit declaration of function ‘elv_queue_empty’
