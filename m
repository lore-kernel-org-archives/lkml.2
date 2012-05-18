Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965366Ab2ERRHs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 13:07:48 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45043 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758139Ab2ERRHP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 13:07:15 -0400
Date: Fri, 18 May 2012 10:07:10 -0700
From: Tejun Heo <tj@kernel.org>
To: koverstreet@google.com
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, axboe@kernel.dk,
        agk@redhat.com, neilb@suse.de
Subject: Re: [PATCH 10/13] block: Rework bio splitting
Message-ID: <20120518170710.GJ19388@google.com>
References: <cover.1337308722.git.koverstreet@google.com>
 <ac4c1cbd10934fdc3a4af74d4cb5ec370f9139d5.1337308722.git.koverstreet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ac4c1cbd10934fdc3a4af74d4cb5ec370f9139d5.1337308722.git.koverstreet@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, May 17, 2012 at 10:59:57PM -0400, koverstreet@google.com wrote:
> From: Kent Overstreet <koverstreet@google.com>
> 
> Break out bio_split() and bio_pair_split(), and get rid of the
> limitations of bio_split()

Again, what are those limitations being removed and why and at what
cost?

> diff --git a/fs/bio.c b/fs/bio.c
> index 3332800..781a8cf 100644
> --- a/fs/bio.c
> +++ b/fs/bio.c
> @@ -35,7 +35,7 @@
>   */
>  #define BIO_INLINE_VECS		4
>  
> -static mempool_t *bio_split_pool __read_mostly;
> +static struct bio_set *bio_split_pool __read_mostly;
>  
>  /*
>   * if you change this list, also change bvec_alloc or things will
> @@ -1464,84 +1464,124 @@ void bio_endio(struct bio *bio, int error)
>  }
>  EXPORT_SYMBOL(bio_endio);
>  

Please add /** comment documenting the function.

> -void bio_pair_release(struct bio_pair *bp)
> +struct bio *bio_split(struct bio *bio, int sectors,
> +		      gfp_t gfp, struct bio_set *bs)
>  {
> -	if (atomic_dec_and_test(&bp->cnt)) {
> -		struct bio *master = bp->bio1.bi_private;
> +	unsigned idx, vcnt = 0, nbytes = sectors << 9;
> +	struct bio_vec *bv;
> +	struct bio *ret = NULL;

Maybe naming it @split is better?

> +
> +	BUG_ON(sectors <= 0);
> +
> +	if (current->bio_list)
> +		gfp &= ~__GFP_WAIT;

Please explain what this means.

> +	if (nbytes >= bio->bi_size)
> +		return bio;
> +
> +	trace_block_split(bdev_get_queue(bio->bi_bdev), bio,
> +				bio->bi_sector + sectors);
> +
> +	bio_for_each_segment(bv, bio, idx) {
> +		vcnt = idx - bio->bi_idx;
> +
> +		if (!nbytes) {
> +			ret = bio_alloc_bioset(gfp, 0, bs);
> +			if (!ret)
> +				return NULL;
> +
> +			ret->bi_io_vec = bio_iovec(bio);
> +			ret->bi_flags |= 1 << BIO_CLONED;
> +			break;
> +		} else if (nbytes < bv->bv_len) {
> +			ret = bio_alloc_bioset(gfp, ++vcnt, bs);
> +			if (!ret)
> +				return NULL;
> +
> +			memcpy(ret->bi_io_vec, bio_iovec(bio),
> +			       sizeof(struct bio_vec) * vcnt);
> +
> +			ret->bi_io_vec[vcnt - 1].bv_len = nbytes;
> +			bv->bv_offset	+= nbytes;
> +			bv->bv_len	-= nbytes;

Please don't indent assignments.

> +			break;
> +		}
> +
> +		nbytes -= bv->bv_len;
> +	}

I find the code a bit confusing.  Wouldn't it be better to structure
it as

	bio_for_each_segment() {
		find splitting point;
	}

	Do all of the splitting.

> +	ret->bi_bdev	= bio->bi_bdev;
> +	ret->bi_sector	= bio->bi_sector;
> +	ret->bi_size	= sectors << 9;
> +	ret->bi_rw	= bio->bi_rw;
> +	ret->bi_vcnt	= vcnt;
> +	ret->bi_max_vecs = vcnt;
> +	ret->bi_end_io	= bio->bi_end_io;
> +	ret->bi_private	= bio->bi_private;
>  
> -		bio_endio(master, bp->error);
> -		mempool_free(bp, bp->bio2.bi_private);
> +	bio->bi_sector	+= sectors;
> +	bio->bi_size	-= sectors << 9;
> +	bio->bi_idx	 = idx;

I personally would prefer not having indentations here either.

> +	if (bio_integrity(bio)) {
> +		bio_integrity_clone(ret, bio, gfp, bs);
> +		bio_integrity_trim(ret, 0, bio_sectors(ret));
> +		bio_integrity_trim(bio, bio_sectors(ret), bio_sectors(bio));
>  	}
> +
> +	return ret;
>  }
> -EXPORT_SYMBOL(bio_pair_release);
> +EXPORT_SYMBOL_GPL(bio_split);

/** comment would be nice.

> -static void bio_pair_end_1(struct bio *bi, int err)
> +void bio_pair_release(struct bio_pair *bp)
>  {
> -	struct bio_pair *bp = container_of(bi, struct bio_pair, bio1);
> -
> -	if (err)
> -		bp->error = err;
> +	if (atomic_dec_and_test(&bp->cnt)) {
> +		bp->orig->bi_end_io = bp->bi_end_io;
> +		bp->orig->bi_private = bp->bi_private;

So, before, split wouldn't override orig->bi_private.  Now, it does so
while the bio is in flight.  I don't know.  If the only benefit of
temporary override is avoiding have a separate end_io call, I think
not doing so is better.  Also, behavior changes as subtle as this
*must* be noted in the patch description.

> -	bio_pair_release(bp);
> +		bio_endio(bp->orig, 0);
> +		bio_put(&bp->split);
> +	}
>  }
> +EXPORT_SYMBOL(bio_pair_release);

And it would be super-nice if you can add /** comment here too.

> -/*
> - * split a bio - only worry about a bio with a single page in its iovec
> - */
> -struct bio_pair *bio_split(struct bio *bi, int first_sectors)
> +struct bio_pair *bio_pair_split(struct bio *bio, int first_sectors)
>  {
> -	struct bio_pair *bp = mempool_alloc(bio_split_pool, GFP_NOIO);
> -
> -	if (!bp)
> -		return bp;
> +	struct bio_pair *bp;
> +	struct bio *split = bio_split(bio, first_sectors,
> +				      GFP_NOIO, bio_split_pool);

I know fs/bio.c isn't a bastion of good style but let's try improve it
bit by bit.  It's generally considered a bad style to put a statement
which may fail in local var declaration.  IOW, please do,

	struct bio *split;

	split = bio_split();
	if (!split)
		return NULL;

> @@ -1694,8 +1734,7 @@ static int __init init_bio(void)
>  	if (bioset_integrity_create(fs_bio_set, BIO_POOL_SIZE))
>  		panic("bio: can't create integrity pool\n");
>  
> -	bio_split_pool = mempool_create_kmalloc_pool(BIO_SPLIT_ENTRIES,
> -						     sizeof(struct bio_pair));
> +	bio_split_pool = bioset_create(BIO_POOL_SIZE, offsetof(struct bio_pair, split));
>  	if (!bio_split_pool)
>  		panic("bio: can't create split pool\n");

BIO_SPLIT_ENTRIES is probably something dependent on how splits can
stack, so I don't think we want to change that to BIO_POOL_SIZE.

Thanks.

-- 
tejun
