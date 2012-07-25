Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756528Ab2GYLNr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 07:13:47 -0400
Received: from natasha.panasas.com ([67.152.220.90]:34079 "EHLO
	natasha.panasas.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755502Ab2GYLNp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 07:13:45 -0400
Message-ID: <500FD32F.2010809@panasas.com>
Date: Wed, 25 Jul 2012 14:06:23 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111113 Thunderbird/8.0
MIME-Version: 1.0
To: Kent Overstreet <koverstreet@google.com>
CC: <linux-bcache@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <dm-devel@redhat.com>, <tj@kernel.org>, <axboe@kernel.dk>,
        <agk@redhat.com>, <neilb@suse.de>, <drbd-dev@lists.linbit.com>,
        <vgoyal@redhat.com>, <mpatocka@redhat.com>, <sage@newdream.net>,
        <yehuda@hq.newdream.net>
Subject: Re: [PATCH v4 01/12] block: Generalized bio pool freeing
References: <1343160689-12378-1-git-send-email-koverstreet@google.com> <1343160689-12378-2-git-send-email-koverstreet@google.com>
In-Reply-To: <1343160689-12378-2-git-send-email-koverstreet@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/24/2012 11:11 PM, Kent Overstreet wrote:

> With the old code, when you allocate a bio from a bio pool you have to
> implement your own destructor that knows how to find the bio pool the
> bio was originally allocated from.
> 
> This adds a new field to struct bio (bi_pool) and changes
> bio_alloc_bioset() to use it. This makes various bio destructors
> unnecessary, so they're then deleted.
> 
> Signed-off-by: Kent Overstreet <koverstreet@google.com>

<snip>

> diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
> index fd47950..be65582 100644
> --- a/drivers/target/target_core_iblock.c
> +++ b/drivers/target/target_core_iblock.c
> @@ -447,14 +447,6 @@ static void iblock_complete_cmd(struct se_cmd *cmd)
>  	kfree(ibr);
>  }
>  
> -static void iblock_bio_destructor(struct bio *bio)
> -{
> -	struct se_cmd *cmd = bio->bi_private;
> -	struct iblock_dev *ib_dev = cmd->se_dev->dev_ptr;
> -
> -	bio_free(bio, ib_dev->ibd_bio_set);
> -}
> -
>  static struct bio *
>  iblock_get_bio(struct se_cmd *cmd, sector_t lba, u32 sg_num)
>  {
> @@ -475,8 +467,15 @@ iblock_get_bio(struct se_cmd *cmd, sector_t lba, u32 sg_num)
>  	}
>  
>  	bio->bi_bdev = ib_dev->ibd_bd;
> +<<<<<<< HEAD
>  	bio->bi_private = cmd;
>  	bio->bi_destructor = iblock_bio_destructor;
> +||||||| merged common ancestors
> +	bio->bi_private = task;
> +	bio->bi_destructor = iblock_bio_destructor;
> +=======
> +	bio->bi_private = task;
> +>>>>>>> block: Generalized bio pool freeing
>  	bio->bi_end_io = &iblock_bio_done;
>  	bio->bi_sector = lba;
>  	return bio;


You left out a rebase merge conflict. Did you allmodconfig compile
these patches?

Boaz

> diff --git a/fs/bio.c b/fs/bio.c
> index 73922ab..1c6c8b7 100644
> --- a/fs/bio.c
> +++ b/fs/bio.c
> @@ -271,10 +271,6 @@ EXPORT_SYMBOL(bio_init);
>   *   bio_alloc_bioset will try its own mempool to satisfy the allocation.
>   *   If %__GFP_WAIT is set then we will block on the internal pool waiting
>   *   for a &struct bio to become free.
> - *
> - *   Note that the caller must set ->bi_destructor on successful return
> - *   of a bio, to do the appropriate freeing of the bio once the reference
> - *   count drops to zero.
>   **/
>  struct bio *bio_alloc_bioset(gfp_t gfp_mask, int nr_iovecs, struct bio_set *bs)
>  {
> @@ -289,6 +285,7 @@ struct bio *bio_alloc_bioset(gfp_t gfp_mask, int nr_iovecs, struct bio_set *bs)
>  	bio = p + bs->front_pad;
>  
>  	bio_init(bio);
> +	bio->bi_pool = bs;
>  
>  	if (unlikely(!nr_iovecs))
>  		goto out_set;
> @@ -315,11 +312,6 @@ err_free:
>  }
>  EXPORT_SYMBOL(bio_alloc_bioset);
>  
> -static void bio_fs_destructor(struct bio *bio)
> -{
> -	bio_free(bio, fs_bio_set);
> -}
> -
>  /**
>   *	bio_alloc - allocate a new bio, memory pool backed
>   *	@gfp_mask: allocation mask to use
> @@ -341,12 +333,7 @@ static void bio_fs_destructor(struct bio *bio)
>   */
>  struct bio *bio_alloc(gfp_t gfp_mask, unsigned int nr_iovecs)
>  {
> -	struct bio *bio = bio_alloc_bioset(gfp_mask, nr_iovecs, fs_bio_set);
> -
> -	if (bio)
> -		bio->bi_destructor = bio_fs_destructor;
> -
> -	return bio;
> +	return bio_alloc_bioset(gfp_mask, nr_iovecs, fs_bio_set);
>  }
>  EXPORT_SYMBOL(bio_alloc);
>  
> @@ -422,7 +409,11 @@ void bio_put(struct bio *bio)
>  	if (atomic_dec_and_test(&bio->bi_cnt)) {
>  		bio_disassociate_task(bio);
>  		bio->bi_next = NULL;
> -		bio->bi_destructor(bio);
> +
> +		if (bio->bi_pool)
> +			bio_free(bio, bio->bi_pool);
> +		else
> +			bio->bi_destructor(bio);
>  	}
>  }
>  EXPORT_SYMBOL(bio_put);
> @@ -473,12 +464,11 @@ EXPORT_SYMBOL(__bio_clone);
>   */
>  struct bio *bio_clone(struct bio *bio, gfp_t gfp_mask)
>  {
> -	struct bio *b = bio_alloc_bioset(gfp_mask, bio->bi_max_vecs, fs_bio_set);
> +	struct bio *b = bio_alloc(gfp_mask, bio->bi_max_vecs);
>  
>  	if (!b)
>  		return NULL;
>  
> -	b->bi_destructor = bio_fs_destructor;
>  	__bio_clone(b, bio);
>  
>  	if (bio_integrity(bio)) {
> diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
> index 0edb65d..293547e 100644
> --- a/include/linux/blk_types.h
> +++ b/include/linux/blk_types.h
> @@ -80,6 +80,9 @@ struct bio {
>  	struct bio_integrity_payload *bi_integrity;  /* data integrity */
>  #endif
>  
> +	/* If bi_pool is non NULL, bi_destructor is not called */
> +	struct bio_set		*bi_pool;
> +
>  	bio_destructor_t	*bi_destructor;	/* destructor */
>  
>  	/*


