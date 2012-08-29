Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753231Ab2H2QZA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2012 12:25:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26535 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752822Ab2H2QY5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2012 12:24:57 -0400
Date: Wed, 29 Aug 2012 12:24:43 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file.rdu.redhat.com
To: Kent Overstreet <koverstreet@google.com>
cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, tj@kernel.org, vgoyal@redhat.com,
        bharrosh@panasas.com, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH v7 9/9] block: Avoid deadlocks with bio allocation by
 stacking drivers
In-Reply-To: <1346175456-1572-10-git-send-email-koverstreet@google.com>
Message-ID: <Pine.LNX.4.64.1208291210180.774@file.rdu.redhat.com>
References: <1346175456-1572-1-git-send-email-koverstreet@google.com>
 <1346175456-1572-10-git-send-email-koverstreet@google.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

This fixes the bio allocation problems, but doesn't fix a similar deadlock 
in device mapper when allocating from md->io_pool or other mempools in 
the target driver.

The problem is that majority of device mapper code assumes that if we 
submit a bio, that bio will be finished in a finite time. The commit 
d89d87965dcbe6fe4f96a2a7e8421b3a75f634d1 in 2.6.22 broke this assumption.

I suggest - instead of writing workarounds for this current->bio_list 
misbehavior, why not remove current->bio_list at all? We could revert 
d89d87965dcbe6fe4f96a2a7e8421b3a75f634d1, allocate a per-device workqueue, 
test stack usage in generic_make_request, and if it is too high (more than 
half of the stack used, or so), put the bio to the target device's 
blockqueue.

That could be simpler than allocating per-bioset workqueue and it also 
solves more problems (possible deadlocks in dm).

Mikulas



On Tue, 28 Aug 2012, Kent Overstreet wrote:

> Previously, if we ever try to allocate more than once from the same bio
> set while running under generic_make_request() (i.e. a stacking block
> driver), we risk deadlock.
> 
> This is because of the code in generic_make_request() that converts
> recursion to iteration; any bios we submit won't actually be submitted
> (so they can complete and eventually be freed) until after we return -
> this means if we allocate a second bio, we're blocking the first one
> from ever being freed.
> 
> Thus if enough threads call into a stacking block driver at the same
> time with bios that need multiple splits, and the bio_set's reserve gets
> used up, we deadlock.
> 
> This can be worked around in the driver code - we could check if we're
> running under generic_make_request(), then mask out __GFP_WAIT when we
> go to allocate a bio, and if the allocation fails punt to workqueue and
> retry the allocation.
> 
> But this is tricky and not a generic solution. This patch solves it for
> all users by inverting the previously described technique. We allocate a
> rescuer workqueue for each bio_set, and then in the allocation code if
> there are bios on current->bio_list we would be blocking, we punt them
> to the rescuer workqueue to be submitted.
> 
> Tested it by forcing the rescue codepath to be taken (by disabling the
> first GFP_NOWAIT) attempt, and then ran it with bcache (which does a lot
> of arbitrary bio splitting) and verified that the rescuer was being
> invoked.
> 
> Signed-off-by: Kent Overstreet <koverstreet@google.com>
> CC: Jens Axboe <axboe@kernel.dk>
> ---
>  fs/bio.c            | 73 ++++++++++++++++++++++++++++++++++++++++++++++++++---
>  include/linux/bio.h |  9 +++++++
>  2 files changed, 79 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/bio.c b/fs/bio.c
> index 31e637a..5d46318 100644
> --- a/fs/bio.c
> +++ b/fs/bio.c
> @@ -285,6 +285,23 @@ void bio_reset(struct bio *bio)
>  }
>  EXPORT_SYMBOL(bio_reset);
>  
> +static void bio_alloc_rescue(struct work_struct *work)
> +{
> +	struct bio_set *bs = container_of(work, struct bio_set, rescue_work);
> +	struct bio *bio;
> +
> +	while (1) {
> +		spin_lock(&bs->rescue_lock);
> +		bio = bio_list_pop(&bs->rescue_list);
> +		spin_unlock(&bs->rescue_lock);
> +
> +		if (!bio)
> +			break;
> +
> +		generic_make_request(bio);
> +	}
> +}
> +
>  /**
>   * bio_alloc_bioset - allocate a bio for I/O
>   * @gfp_mask:   the GFP_ mask given to the slab allocator
> @@ -307,6 +324,7 @@ EXPORT_SYMBOL(bio_reset);
>   */
>  struct bio *bio_alloc_bioset(gfp_t gfp_mask, int nr_iovecs, struct bio_set *bs)
>  {
> +	gfp_t saved_gfp = gfp_mask;
>  	unsigned front_pad;
>  	unsigned inline_vecs;
>  	unsigned long idx = BIO_POOL_NONE;
> @@ -324,13 +342,37 @@ struct bio *bio_alloc_bioset(gfp_t gfp_mask, int nr_iovecs, struct bio_set *bs)
>  		front_pad = 0;
>  		inline_vecs = nr_iovecs;
>  	} else {
> +		/*
> +		 * generic_make_request() converts recursion to iteration; this
> +		 * means if we're running beneath it, any bios we allocate and
> +		 * submit will not be submitted (and thus freed) until after we
> +		 * return.
> +		 *
> +		 * This exposes us to a potential deadlock if we allocate
> +		 * multiple bios from the same bio_set() while running
> +		 * underneath generic_make_request(). If we were to allocate
> +		 * multiple bios (say a stacking block driver that was splitting
> +		 * bios), we would deadlock if we exhausted the mempool's
> +		 * reserve.
> +		 *
> +		 * We solve this, and guarantee forward progress, with a rescuer
> +		 * workqueue per bio_set. If we go to allocate and there are
> +		 * bios on current->bio_list, we first try the allocation
> +		 * without __GFP_WAIT; if that fails, we punt those bios we
> +		 * would be blocking to the rescuer workqueue before we retry
> +		 * with the original gfp_flags.
> +		 */
> +
> +		if (current->bio_list && !bio_list_empty(current->bio_list))
> +			gfp_mask &= ~__GFP_WAIT;
> +retry:
>  		p = mempool_alloc(bs->bio_pool, gfp_mask);
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
> @@ -351,6 +393,19 @@ struct bio *bio_alloc_bioset(gfp_t gfp_mask, int nr_iovecs, struct bio_set *bs)
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
> @@ -1562,6 +1617,9 @@ static void biovec_free_pools(struct bio_set *bs)
>  
>  void bioset_free(struct bio_set *bs)
>  {
> +	if (bs->rescue_workqueue)
> +		destroy_workqueue(bs->rescue_workqueue);
> +
>  	if (bs->bio_pool)
>  		mempool_destroy(bs->bio_pool);
>  
> @@ -1597,6 +1655,10 @@ struct bio_set *bioset_create(unsigned int pool_size, unsigned int front_pad)
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
> @@ -1607,9 +1669,14 @@ struct bio_set *bioset_create(unsigned int pool_size, unsigned int front_pad)
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
> index 3a8345e..84fdaac 100644
> --- a/include/linux/bio.h
> +++ b/include/linux/bio.h
> @@ -492,6 +492,15 @@ struct bio_set {
>  	mempool_t *bio_integrity_pool;
>  #endif
>  	mempool_t *bvec_pool;
> +
> +	/*
> +	 * Deadlock avoidance for stacking block drivers: see comments in
> +	 * bio_alloc_bioset() for details
> +	 */
> +	spinlock_t		rescue_lock;
> +	struct bio_list		rescue_list;
> +	struct work_struct	rescue_work;
> +	struct workqueue_struct	*rescue_workqueue;
>  };
>  
>  struct biovec_slab {
> -- 
> 1.7.12
> 
