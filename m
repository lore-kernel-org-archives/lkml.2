Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758435Ab2I1QXt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 12:23:49 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:48919 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757572Ab2I1QXr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 12:23:47 -0400
Date: Fri, 28 Sep 2012 09:23:43 -0700
From: Kent Overstreet <koverstreet@google.com>
To: NeilBrown <neilb@suse.de>
Cc: Jens Axboe <axboe@kernel.dk>, Shaohua Li <shli@fusionio.com>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] block: makes bio_split support bio without data
Message-ID: <20120928162343.GF22647@google.com>
References: <20120924145639.3b65fd8b@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120924145639.3b65fd8b@notabene.brown>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 24, 2012 at 02:56:39PM +1000, NeilBrown wrote:
> 
> Hi Jens,
>  this patch has been sitting in my -next tree for a little while and I was
>  hoping for it to go in for the next merge window.
>  It simply allows bio_split() to be used on bios without a payload, such as
>  'discard'.

Thing is, at some point in the stack a discard bio is going to have data
- see blk_add_rquest_payload(), and it used to be the single page was
added to discard bios above generic_make_request(), in
blkdev_issue_discard() or whatever it's called.

So while I'm sure your code works, it's just a fragile way of doing it.

There's also other types of bios where bi_size has nothing to do with
the amount of data in the bi_io_vec - actually I think this is a new
thing, since Martin Petersen just added REQ_WRITE_SAME and I don't think
there were any other instances besides REQ_DISCARD before.

So my preference would be defining a mask (REQ_DISCARD|REQ_WRITE_SAME),
and if bio->bi_rw & that mask is true, just duplicate the bvec or
whatever.

That way it's much more explicit and less likely to trip someone else
up later.

(I've actually got a patch in my tree that does just that, but it's
special cased in bio_advance() which makes things work out really
nicely).

>  Are you happy with it going in though my 'md' tree, or would you rather take
>  it though your 'block' tree?
> 
> Thanks,
> NeilBrown
> 
> 
> From: Shaohua Li <shli@fusionio.com>
> Date: Thu, 20 Sep 2012 09:36:03 +1000
> Subject: [PATCH] block: makes bio_split support bio without data
> 
> discard bio hasn't data attached. We hit a BUG_ON with such bio. This makes
> bio_split works for such bio.
> 
> Signed-off-by: Shaohua Li <shli@fusionio.com>
> Signed-off-by: NeilBrown <neilb@suse.de>
> 
> diff --git a/fs/bio.c b/fs/bio.c
> index 71072ab..dbb7a6c 100644
> --- a/fs/bio.c
> +++ b/fs/bio.c
> @@ -1501,7 +1501,7 @@ struct bio_pair *bio_split(struct bio *bi, int first_sectors)
>  	trace_block_split(bdev_get_queue(bi->bi_bdev), bi,
>  				bi->bi_sector + first_sectors);
>  
> -	BUG_ON(bi->bi_vcnt != 1);
> +	BUG_ON(bi->bi_vcnt != 1 && bi->bi_vcnt != 0);
>  	BUG_ON(bi->bi_idx != 0);
>  	atomic_set(&bp->cnt, 3);
>  	bp->error = 0;
> @@ -1511,17 +1511,19 @@ struct bio_pair *bio_split(struct bio *bi, int first_sectors)
>  	bp->bio2.bi_size -= first_sectors << 9;
>  	bp->bio1.bi_size = first_sectors << 9;
>  
> -	bp->bv1 = bi->bi_io_vec[0];
> -	bp->bv2 = bi->bi_io_vec[0];
> -	bp->bv2.bv_offset += first_sectors << 9;
> -	bp->bv2.bv_len -= first_sectors << 9;
> -	bp->bv1.bv_len = first_sectors << 9;
> +	if (bi->bi_vcnt != 0) {
> +		bp->bv1 = bi->bi_io_vec[0];
> +		bp->bv2 = bi->bi_io_vec[0];
> +		bp->bv2.bv_offset += first_sectors << 9;
> +		bp->bv2.bv_len -= first_sectors << 9;
> +		bp->bv1.bv_len = first_sectors << 9;
>  
> -	bp->bio1.bi_io_vec = &bp->bv1;
> -	bp->bio2.bi_io_vec = &bp->bv2;
> +		bp->bio1.bi_io_vec = &bp->bv1;
> +		bp->bio2.bi_io_vec = &bp->bv2;
>  
> -	bp->bio1.bi_max_vecs = 1;
> -	bp->bio2.bi_max_vecs = 1;
> +		bp->bio1.bi_max_vecs = 1;
> +		bp->bio2.bi_max_vecs = 1;
> +	}
>  
>  	bp->bio1.bi_end_io = bio_pair_end_1;
>  	bp->bio2.bi_end_io = bio_pair_end_2;


