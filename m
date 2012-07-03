Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756452Ab2GCCt2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 22:49:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52317 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755743Ab2GCCt0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 22:49:26 -0400
Date: Mon, 2 Jul 2012 22:49:10 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, axboe@kernel.dk, snitzer@redhat.com,
        martin.petersen@oracle.com, david@fromorbit.com, xfs@oss.sgi.com,
        dm-devel@redhat.com, hch@lst.de
Subject: Re: [dm-devel] [PATCH v2 2/3] block: reorganize rounding of
 max_discard_sectors
Message-ID: <20120703024910.GC3586@redhat.com>
References: <1341235225-27551-1-git-send-email-pbonzini@redhat.com>
 <1341235225-27551-3-git-send-email-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1341235225-27551-3-git-send-email-pbonzini@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 02, 2012 at 03:20:24PM +0200, Paolo Bonzini wrote:
> Mostly a preparation for the next patch.
> 
> In principle this fixes an infinite loop if max_discard_sectors < granularity,
> but that really shouldn't happen.
> 
> Cc: Jens Axboe <axboe@kernel.dk>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  block/blk-lib.c |    9 +++++----
>  1 files changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/block/blk-lib.c b/block/blk-lib.c
> index 2b461b4..16b06f6 100644
> --- a/block/blk-lib.c
> +++ b/block/blk-lib.c
> @@ -44,6 +44,7 @@ int blkdev_issue_discard(struct block_device *bdev, sector_t sector,
>  	struct request_queue *q = bdev_get_queue(bdev);
>  	int type = REQ_WRITE | REQ_DISCARD;
>  	unsigned int max_discard_sectors;
> +	unsigned int granularity;
>  	struct bio_batch bb;
>  	struct bio *bio;
>  	int ret = 0;
> @@ -54,18 +55,18 @@ int blkdev_issue_discard(struct block_device *bdev, sector_t sector,
>  	if (!blk_queue_discard(q))
>  		return -EOPNOTSUPP;
>  
> +	/* Zero-sector (unknown) and one-sector granularities are the same.  */
> +	granularity = max(q->limits.discard_granularity >> 9, 1U);
> +
>  	/*
>  	 * Ensure that max_discard_sectors is of the proper
>  	 * granularity
>  	 */
>  	max_discard_sectors = min(q->limits.max_discard_sectors, UINT_MAX >> 9);
> +	max_discard_sectors = round_down(max_discard_sectors, granularity);
>  	if (unlikely(!max_discard_sectors)) {
>  		/* Avoid infinite loop below. Being cautious never hurts. */
>  		return -EOPNOTSUPP;
> -	} else if (q->limits.discard_granularity) {
> -		unsigned int disc_sects = q->limits.discard_granularity >> 9;
> -
> -		max_discard_sectors &= ~(disc_sects - 1);

This is kind of odd. If discard_granularity is zero, we assume that
discards are supported and granularity is 1. But if max_discard_sectors
is zero, we assume discards are disabled. Not sure if we should treat
max_discard_sectors and discard_granularity in same way or not.

Thanks
Vivek
