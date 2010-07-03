Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754996Ab0GCKNX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jul 2010 06:13:23 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:59356 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754782Ab0GCKNW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jul 2010 06:13:22 -0400
Date: Sat, 3 Jul 2010 06:13:20 -0400
From: Christoph Hellwig <hch@infradead.org>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, knikanth@suse.de,
       jeremy@xensource.com, drzeus@drzeus.cx
Subject: Re: [PATCH 9/9] block: remove q->prepare_flush_fn completely
Message-ID: <20100703101320.GB22329@infradead.org>
References: <1278146740-8731-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1278146740-8731-10-git-send-email-fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1278146740-8731-10-git-send-email-fujita.tomonori@lab.ntt.co.jp>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not a comment on the patch itself, but some interesting observations
on the drivers ordered flags:

> diff --git a/drivers/block/loop.c b/drivers/block/loop.c
> index fedfdb7..d285a54 100644
> --- a/drivers/block/loop.c
> +++ b/drivers/block/loop.c
> @@ -831,7 +831,7 @@ static int loop_set_fd(struct loop_device *lo, fmode_t mode,
>  	lo->lo_queue->unplug_fn = loop_unplug;
>  
>  	if (!(lo_flags & LO_FLAGS_READ_ONLY) && file->f_op->fsync)
> -		blk_queue_ordered(lo->lo_queue, QUEUE_ORDERED_DRAIN, NULL);
> +		blk_queue_ordered(lo->lo_queue, QUEUE_ORDERED_DRAIN);

loop actually does flushes.  But implements them by itself because
it's bio based.  Seems like something is not so nice about the API
for implementing barriers with bio based drivers.

Also do we actually get the draining semantics right this way?  Unless
loop only supports one in-flight bio this seems to not be correct.

> diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
> index 495533e..76af65b 100644
> --- a/drivers/block/xen-blkfront.c
> +++ b/drivers/block/xen-blkfront.c
> @@ -373,8 +373,7 @@ static int xlvbd_barrier(struct blkfront_info *info)
>  	int err;
>  
>  	err = blk_queue_ordered(info->rq,
> -				info->feature_barrier ? QUEUE_ORDERED_DRAIN : QUEUE_ORDERED_NONE,
> -				NULL);
> +				info->feature_barrier ? QUEUE_ORDERED_DRAIN : QUEUE_ORDERED_NONE);

Something is really broken with the way Xen implements barriers.
It claims to only require drains, but then actually marks barrier
requests as such.  The qemu backend at least then does the pre and post
drains by itself.  While this gets the correct results for writes marked
as barriers, it can't properly implement empty barriers (aka cache
flushes) which are just as important.

> --- a/drivers/mmc/card/queue.c
> +++ b/drivers/mmc/card/queue.c
> @@ -128,7 +128,7 @@ int mmc_init_queue(struct mmc_queue *mq, struct mmc_card *card, spinlock_t *lock
>  	mq->req = NULL;
>  
>  	blk_queue_prep_rq(mq->queue, mmc_prep_request);
> -	blk_queue_ordered(mq->queue, QUEUE_ORDERED_DRAIN, NULL);
> +	blk_queue_ordered(mq->queue, QUEUE_ORDERED_DRAIN);

So MMC device never have volatile write caches?

