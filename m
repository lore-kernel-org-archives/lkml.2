Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933293Ab2HVUfk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 16:35:40 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:63200 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751508Ab2HVUff (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 16:35:35 -0400
Date: Wed, 22 Aug 2012 13:30:03 -0700
From: Tejun Heo <tj@kernel.org>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, vgoyal@redhat.com, mpatocka@redhat.com,
        bharrosh@panasas.com, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH v6 07/13] block: Avoid deadlocks with bio allocation by
 stacking drivers
Message-ID: <20120822203003.GJ19212@google.com>
References: <1345655050-28199-1-git-send-email-koverstreet@google.com>
 <1345655050-28199-8-git-send-email-koverstreet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1345655050-28199-8-git-send-email-koverstreet@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Kent.

On Wed, Aug 22, 2012 at 10:04:04AM -0700, Kent Overstreet wrote:
> Previously, if we ever try to allocate more than once from the same bio
> set while running under generic_make_request(), we risk deadlock.
> 
> This would happen if e.g. a bio ever needed to be split more than once,
> and it's difficult to handle correctly in the drivers - so in practice
> it's not.
> 
> This patch fixes this issue by allocating a rescuer workqueue for each
> bio_set, and punting queued bios to said rescuer when necessary:

This description needs to be several times more descriptive than it
currently is.  The deadlock issue at hand is very unobvious.  Please
explain it so that someone who isn't familiar with the problem can
understand it by reading it.

Also, please describe how the patch was tested.

> @@ -306,16 +324,39 @@ struct bio *bio_alloc_bioset(gfp_t gfp_mask, int nr_iovecs, struct bio_set *bs)
>  		p = kmalloc(sizeof(struct bio) +
>  			    nr_iovecs * sizeof(struct bio_vec),
>  			    gfp_mask);
> +
>  		front_pad = 0;
>  		inline_vecs = nr_iovecs;
>  	} else {
> -		p = mempool_alloc(bs->bio_pool, gfp_mask);
> +		/*
> +		 * If we're running under generic_make_request()
> +		 * (current->bio_list != NULL), we risk deadlock if we sleep on
> +		 * allocation and there's already bios on current->bio_list that
> +		 * were allocated from the same bio_set; they won't be submitted
> +		 * (and thus freed) as long as we're blocked here.
> +		 *
> +		 * To deal with this, we first try the allocation without using
> +		 * the mempool; if that fails, we punt all the bios on
> +		 * current->bio_list to a different thread and then retry the
> +		 * allocation with the original gfp mask.
> +		 */

Ditto here.

> +		if (current->bio_list &&
> +		    !bio_list_empty(current->bio_list) &&
> +		    (gfp_mask & __GFP_WAIT))
> +			gfp_mask &= GFP_ATOMIC;

Why aren't we turning off __GFP_WAIT instead?  e.g. What if the caller
has one of NUMA flags or __GFP_COLD specified?

> +retry:
> +		if (gfp_mask & __GFP_WAIT)
> +			p = mempool_alloc(bs->bio_pool, gfp_mask);
> +		else
> +			p = kmem_cache_alloc(bs->bio_slab, gfp_mask);

Why is it necessary to avoid using the mempool if __GFP_WAIT is
already cleared?

>  		front_pad = bs->front_pad;
>  		inline_vecs = BIO_INLINE_VECS;
>  	}
>  
>  	if (unlikely(!p))
> -		return NULL;
> +		goto err;
>  
>  	bio = p + front_pad;
>  	bio_init(bio);
> @@ -336,6 +377,19 @@ struct bio *bio_alloc_bioset(gfp_t gfp_mask, int nr_iovecs, struct bio_set *bs)
>  
>  err_free:
>  	mempool_free(p, bs->bio_pool);
> +err:
> +	if (gfp_mask != saved_gfp) {
> +		gfp_mask = saved_gfp;
> +
> +		spin_lock(&bs->rescue_lock);
> +		bio_list_merge(&bs->rescue_list, current->bio_list);
> +		bio_list_init(current->bio_list);
> +		spin_unlock(&bs->rescue_lock);
> +
> +		queue_work(bs->rescue_workqueue, &bs->rescue_work);
> +		goto retry;
> +	}
> +
>  	return NULL;
>  }
>  EXPORT_SYMBOL(bio_alloc_bioset);
> @@ -1544,6 +1598,9 @@ static void biovec_free_pools(struct bio_set *bs)
>  
>  void bioset_free(struct bio_set *bs)
>  {
> +	if (bs->rescue_workqueue)
> +		destroy_workqueue(bs->rescue_workqueue);
> +
>  	if (bs->bio_pool)
>  		mempool_destroy(bs->bio_pool);
>  
> @@ -1579,6 +1636,10 @@ struct bio_set *bioset_create(unsigned int pool_size, unsigned int front_pad)
>  
>  	bs->front_pad = front_pad;
>  
> +	spin_lock_init(&bs->rescue_lock);
> +	bio_list_init(&bs->rescue_list);
> +	INIT_WORK(&bs->rescue_work, bio_alloc_rescue);
> +
>  	bs->bio_slab = bio_find_or_create_slab(front_pad + back_pad);
>  	if (!bs->bio_slab) {
>  		kfree(bs);
> @@ -1589,9 +1650,14 @@ struct bio_set *bioset_create(unsigned int pool_size, unsigned int front_pad)
>  	if (!bs->bio_pool)
>  		goto bad;
>  
> -	if (!biovec_create_pools(bs, pool_size))
> -		return bs;
> +	if (biovec_create_pools(bs, pool_size))
> +		goto bad;
> +
> +	bs->rescue_workqueue = alloc_workqueue("bioset", WQ_MEM_RECLAIM, 0);
> +	if (!bs->rescue_workqueue)
> +		goto bad;
>  
> +	return bs;
>  bad:
>  	bioset_free(bs);
>  	return NULL;
> diff --git a/include/linux/bio.h b/include/linux/bio.h
> index b22c22b..ba5b52e 100644
> --- a/include/linux/bio.h
> +++ b/include/linux/bio.h
> @@ -290,39 +290,6 @@ static inline int bio_associate_current(struct bio *bio) { return -ENOENT; }
>  static inline void bio_disassociate_task(struct bio *bio) { }
>  #endif	/* CONFIG_BLK_CGROUP */
>  
> -/*
> - * bio_set is used to allow other portions of the IO system to
> - * allocate their own private memory pools for bio and iovec structures.
> - * These memory pools in turn all allocate from the bio_slab
> - * and the bvec_slabs[].
> - */
> -#define BIO_POOL_SIZE 2
> -#define BIOVEC_NR_POOLS 6
> -#define BIOVEC_MAX_IDX	(BIOVEC_NR_POOLS - 1)
> -
> -struct bio_set {
> -	struct kmem_cache *bio_slab;
> -	unsigned int front_pad;
> -
> -	mempool_t *bio_pool;
> -#if defined(CONFIG_BLK_DEV_INTEGRITY)
> -	mempool_t *bio_integrity_pool;
> -#endif
> -	mempool_t *bvec_pool;
> -};
> -
> -struct biovec_slab {
> -	int nr_vecs;
> -	char *name;
> -	struct kmem_cache *slab;
> -};

Plesae don't mix struct definition relocation (or any relocation
really) with actual changes.  It buries the actual changes and makes
reviewing difficult.

Thanks.

-- 
tejun
