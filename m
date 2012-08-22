Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933366Ab2HVVES (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 17:04:18 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:60681 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933330Ab2HVVEP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 17:04:15 -0400
Date: Wed, 22 Aug 2012 14:04:10 -0700
From: Tejun Heo <tj@kernel.org>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, vgoyal@redhat.com, mpatocka@redhat.com,
        bharrosh@panasas.com, Jens Axboe <axboe@kernel.dk>,
        NeilBrown <neilb@suse.de>, Lars Ellenberg <lars.ellenberg@linbit.com>,
        Peter Osterlund <petero2@telia.com>, Sage Weil <sage@inktank.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v6 11/13] block: Rework bio_pair_split()
Message-ID: <20120822210410.GL19212@google.com>
References: <1345655050-28199-1-git-send-email-koverstreet@google.com>
 <1345655050-28199-12-git-send-email-koverstreet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1345655050-28199-12-git-send-email-koverstreet@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Kent.

On Wed, Aug 22, 2012 at 10:04:08AM -0700, Kent Overstreet wrote:
> This changes bio_pair_split() to use the new bio_split() underneath,
> which gets rid of the single page bio limitation. The various callers
> are fixed up for the slightly different struct bio_pair, and to remove
> the unnecessary checks.

This changes an existing API both in its interface and behavior and
there's no detailed explanation on how it's changed and what are the
implications.

> diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
> index 1f5b483..63e5852 100644
> --- a/drivers/block/rbd.c
> +++ b/drivers/block/rbd.c
> @@ -751,14 +751,13 @@ static struct bio *bio_chain_clone(struct bio **old, struct bio **next,
>  
>  			/* split the bio. We'll release it either in the next
>  			   call, or it will have to be released outside */
> -			bp = bio_pair_split(old_chain,
> -					    (len - total) / SECTOR_SIZE);
> +			bp = bio_pair_split(old_chain, (len - total) / SECTOR_SIZE);

Probably belongs to the previous patch which renamed bio_split() to
bio_pair_split()?  Another thing is, is this renaming really
necessary?  If you did,

	* s/bio_split()/bio_pair_split().

	* introduce better and prettier bio_split() which has
          different semantics.

	* replace bio_pair_split() users with bio_split().

the renaming would have made sense, but you renamed an existing API,
intrudced a new one and then changed the renamed old API.  Doesn't
make too much sense to me.

> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index 0f31ec4..9fa07c7 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -1080,15 +1080,9 @@ static void make_request(struct mddev *mddev, struct bio * bio)
>  		     && (conf->geo.near_copies < conf->geo.raid_disks
>  			 || conf->prev.near_copies < conf->prev.raid_disks))) {
>  		struct bio_pair *bp;
> -		/* Sanity check -- queue functions should prevent this happening */
> -		if (bio->bi_vcnt != 1 ||
> -		    bio->bi_idx != 0)
> -			goto bad_map;
> -		/* This is a one page bio that upper layers
> -		 * refuse to split for us, so we need to split it.
> -		 */
> +
>  		bp = bio_pair_split(bio,
> -				    chunk_sects - (bio->bi_sector & (chunk_sects - 1)) );
> +				    chunk_sects - (bio->bi_sector & (chunk_sects - 1)));

I suppose this one too belongs to the previous rename patch?

> --- a/fs/bio-integrity.c
> +++ b/fs/bio-integrity.c
> @@ -681,50 +681,6 @@ void bio_integrity_trim(struct bio *bio, unsigned int offset,
>  EXPORT_SYMBOL(bio_integrity_trim);
>  
>  /**
> - * bio_integrity_split - Split integrity metadata
> - * @bio:	Protected bio
> - * @bp:		Resulting bio_pair
> - * @sectors:	Offset
> - *
> - * Description: Splits an integrity page into a bio_pair.
> - */
> -void bio_integrity_split(struct bio *bio, struct bio_pair *bp, int sectors)
> -{
> -	struct blk_integrity *bi;
> -	struct bio_integrity_payload *bip = bio->bi_integrity;
> -	unsigned int nr_sectors;
> -
> -	if (bio_integrity(bio) == 0)
> -		return;
> -
> -	bi = bdev_get_integrity(bio->bi_bdev);
> -	BUG_ON(bi == NULL);
> -	BUG_ON(bip->bip_vcnt != 1);
> -
> -	nr_sectors = bio_integrity_hw_sectors(bi, sectors);
> -
> -	bp->bio1.bi_integrity = &bp->bip1;
> -	bp->bio2.bi_integrity = &bp->bip2;
> -
> -	bp->iv1 = bip->bip_vec[0];
> -	bp->iv2 = bip->bip_vec[0];
> -
> -	bp->bip1.bip_vec[0] = bp->iv1;
> -	bp->bip2.bip_vec[0] = bp->iv2;
> -
> -	bp->iv1.bv_len = sectors * bi->tuple_size;
> -	bp->iv2.bv_offset += sectors * bi->tuple_size;
> -	bp->iv2.bv_len -= sectors * bi->tuple_size;
> -
> -	bp->bip1.bip_sector = bio->bi_integrity->bip_sector;
> -	bp->bip2.bip_sector = bio->bi_integrity->bip_sector + nr_sectors;
> -
> -	bp->bip1.bip_vcnt = bp->bip2.bip_vcnt = 1;
> -	bp->bip1.bip_idx = bp->bip2.bip_idx = 0;
> -}
> -EXPORT_SYMBOL(bio_integrity_split);

I complained about this in the last posting and in the previous patch.
Please respond.  Martin, are you okay with these integrity changes?

> -static void bio_pair_end_1(struct bio *bi, int err)
> +static void bio_pair_end(struct bio *bio, int error)
>  {
> -	struct bio_pair *bp = container_of(bi, struct bio_pair, bio1);
> +	struct bio_pair *bp = bio->bi_private;
>  
> -	if (err)
> -		bp->error = err;
> -
> -	bio_pair_release(bp);
> -}
> -
> -static void bio_pair_end_2(struct bio *bi, int err)
> -{
> -	struct bio_pair *bp = container_of(bi, struct bio_pair, bio2);
> -
> -	if (err)
> -		bp->error = err;
> +	if (error)
> +		clear_bit(BIO_UPTODATE, &bp->orig->bi_flags);
>  
>  	bio_pair_release(bp);
>  }

Why is losing error value okay here?

> @@ -1856,8 +1846,7 @@ static int __init init_bio(void)
>  	if (bioset_integrity_create(fs_bio_set, BIO_POOL_SIZE))
>  		panic("bio: can't create integrity pool\n");
>  
> -	bio_split_pool = mempool_create_kmalloc_pool(BIO_SPLIT_ENTRIES,
> -						     sizeof(struct bio_pair));
> +	bio_split_pool = bioset_create(BIO_POOL_SIZE, offsetof(struct bio_pair, split));
>  	if (!bio_split_pool)
>  		panic("bio: can't create split pool\n");

It would be nice to mention that using this from stacking drivers is
inherently broken.  This is something which has been broken before
this patch but still.  bio_split*() should always require separate
biosets.

> diff --git a/include/linux/bio.h b/include/linux/bio.h
> index 1c3bb47..3ad3540 100644
> --- a/include/linux/bio.h
> +++ b/include/linux/bio.h
> @@ -192,14 +192,13 @@ struct bio_integrity_payload {
>   *   in bio2.bi_private
>   */
>  struct bio_pair {
> -	struct bio			bio1, bio2;
> -	struct bio_vec			bv1, bv2;
> -#if defined(CONFIG_BLK_DEV_INTEGRITY)
> -	struct bio_integrity_payload	bip1, bip2;
> -	struct bio_vec			iv1, iv2;
> -#endif
> -	atomic_t			cnt;
> -	int				error;
> +	atomic_t		cnt;
> +
> +	bio_end_io_t		*bi_end_io;
> +	void			*bi_private;
> +
> +	struct bio		*orig;
> +	struct bio		split;
>  };

So, this is struct is allocated as frontpad, which is a pretty unusual
thing to do.  Please explain and emphasize that ->split should come
last.  Also, given that it's a pair split, it would be nice to somehow
indicate that ->split is the earlier half.  Before this change it was
pretty clear with ->bio1/2.

Thanks.

-- 
tejun
