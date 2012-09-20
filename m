Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754440Ab2ITXpu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 19:45:50 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37282 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753366Ab2ITXpt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 19:45:49 -0400
Date: Thu, 20 Sep 2012 16:45:44 -0700
From: Tejun Heo <tj@kernel.org>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, axboe@kernel.dk, neilb@suse.de
Subject: Re: [PATCH v2 07/26] block: Don't use bi_idx in bio_split() or
 require it to be 0
Message-ID: <20120920234544.GN7264@google.com>
References: <1347322957-25260-1-git-send-email-koverstreet@google.com>
 <1347322957-25260-8-git-send-email-koverstreet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347322957-25260-8-git-send-email-koverstreet@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 10, 2012 at 05:22:18PM -0700, Kent Overstreet wrote:
> Prep work for immutable bio_vecs/efficient bio splitting: they require
> auditing and removing most uses of bi_idx.
> 
> So here we convert bio_split() to respect the current value of bi_idx
> and use the bio_iovec() macro, instead of assuming bi_idx will be 0.

I find the description a bit cryptic.

> Signed-off-by: Kent Overstreet <koverstreet@google.com>
> CC: Jens Axboe <axboe@kernel.dk>
> ---
>  drivers/block/drbd/drbd_req.c | 6 +++---
>  drivers/md/raid0.c            | 3 +--
>  drivers/md/raid10.c           | 3 +--
>  fs/bio-integrity.c            | 4 ++--
>  fs/bio.c                      | 7 +++----
>  5 files changed, 10 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/block/drbd/drbd_req.c b/drivers/block/drbd/drbd_req.c
> index af69a96..57eb253 100644
> --- a/drivers/block/drbd/drbd_req.c
> +++ b/drivers/block/drbd/drbd_req.c
> @@ -1155,11 +1155,11 @@ void drbd_make_request(struct request_queue *q, struct bio *bio)
>  
>  	/* can this bio be split generically?
>  	 * Maybe add our own split-arbitrary-bios function. */
> -	if (bio->bi_vcnt != 1 || bio->bi_idx != 0 || bio->bi_size > DRBD_MAX_BIO_SIZE) {
> +	if (bio_segments(bio) != 1 || bio->bi_size > DRBD_MAX_BIO_SIZE) {
>  		/* rather error out here than BUG in bio_split */
>  		dev_err(DEV, "bio would need to, but cannot, be split: "
> -		    "(vcnt=%u,idx=%u,size=%u,sector=%llu)\n",
> -		    bio->bi_vcnt, bio->bi_idx, bio->bi_size,
> +		    "(segments=%u,size=%u,sector=%llu)\n",
> +		    bio_segments(bio), bio->bi_size,
>  		    (unsigned long long)bio->bi_sector);
>  		bio_endio(bio, -EINVAL);
>  	} else {
> diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
> index 387cb89..0587450 100644
> --- a/drivers/md/raid0.c
> +++ b/drivers/md/raid0.c
> @@ -509,8 +509,7 @@ static void raid0_make_request(struct mddev *mddev, struct bio *bio)
>  		sector_t sector = bio->bi_sector;
>  		struct bio_pair *bp;
>  		/* Sanity check -- queue functions should prevent this happening */
> -		if (bio->bi_vcnt != 1 ||
> -		    bio->bi_idx != 0)
> +		if (bio_segments(bio) != 1)
>  			goto bad_map;
>  		/* This is a one page bio that upper layers
>  		 * refuse to split for us, so we need to split it.
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index 9715aaf..bbd08f5 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -1081,8 +1081,7 @@ static void make_request(struct mddev *mddev, struct bio * bio)
>  			 || conf->prev.near_copies < conf->prev.raid_disks))) {
>  		struct bio_pair *bp;
>  		/* Sanity check -- queue functions should prevent this happening */
> -		if (bio->bi_vcnt != 1 ||
> -		    bio->bi_idx != 0)
> +		if (bio_segments(bio) != 1)
>  			goto bad_map;
>  		/* This is a one page bio that upper layers
>  		 * refuse to split for us, so we need to split it.

And wonder how the description applies to the above.

> --- a/fs/bio.c
> +++ b/fs/bio.c
> @@ -1616,8 +1616,7 @@ struct bio_pair *bio_split(struct bio *bi, int first_sectors)
>  	trace_block_split(bdev_get_queue(bi->bi_bdev), bi,
>  				bi->bi_sector + first_sectors);
>  
> -	BUG_ON(bi->bi_vcnt != 1);
> -	BUG_ON(bi->bi_idx != 0);
> +	BUG_ON(bio_segments(bi) != 1);
>  	atomic_set(&bp->cnt, 3);
>  	bp->error = 0;
>  	bp->bio1 = *bi;
> @@ -1626,8 +1625,8 @@ struct bio_pair *bio_split(struct bio *bi, int first_sectors)
>  	bp->bio2.bi_size -= first_sectors << 9;
>  	bp->bio1.bi_size = first_sectors << 9;
>  
> -	bp->bv1 = bi->bi_io_vec[0];
> -	bp->bv2 = bi->bi_io_vec[0];
> +	bp->bv1 = *bio_iovec(bi);
> +	bp->bv2 = *bio_iovec(bi);

This conflicts with a recent commit from Martin.  You probably wanna
rebase.

Thanks.

-- 
tejun
