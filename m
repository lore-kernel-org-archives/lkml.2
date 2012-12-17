Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753654Ab2LQT2V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 14:28:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:2388 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753552Ab2LQT2Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 14:28:16 -0500
Date: Mon, 17 Dec 2012 14:28:08 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: lizefan@huawei.com, axboe@kernel.dk, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        ctalbott@google.com, rni@google.com
Subject: Re: [PATCH 02/12] blkcg: reorganize blkg_lookup_create() and friends
Message-ID: <20121217192808.GE7235@redhat.com>
References: <1355524885-22719-1-git-send-email-tj@kernel.org>
 <1355524885-22719-3-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1355524885-22719-3-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 14, 2012 at 02:41:15PM -0800, Tejun Heo wrote:
> Reorganize such that
> 
> * __blkg_lookup() takes bool param @update_hint to determine whether
>   to update hint.
> 
> * __blkg_lookup_create() no longer performs lookup before trying to
>   create.  Renamed to blkg_create().
> 
> * blkg_lookup_create() now performs lookup and then invokes
>   blkg_create() if lookup fails.
> 
> * root_blkg creation in blkcg_activate_policy() updated accordingly.
>   Note that blkcg_activate_policy() no longer updates lookup hint if
>   root_blkg already exists.
> 
> Except for the last lookup hint bit which is immaterial, this is pure
> reorganization and doesn't introduce any visible behavior change.
> This is to prepare for proper hierarchy support.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>

looks good to me. I particularly like cleanup of __blkg_lookup_create()
which freed new_blkg if a blkg was already found.

Acked-by: Vivek Goyal <vgoyal@redhat.com>

Vivek

> ---
>  block/blk-cgroup.c | 75 +++++++++++++++++++++++++++++++++++++-----------------
>  1 file changed, 52 insertions(+), 23 deletions(-)
> 
> diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
> index feda49f..ffbd237 100644
> --- a/block/blk-cgroup.c
> +++ b/block/blk-cgroup.c
> @@ -126,7 +126,7 @@ err_free:
>  }
>  
>  static struct blkcg_gq *__blkg_lookup(struct blkcg *blkcg,
> -				      struct request_queue *q)
> +				      struct request_queue *q, bool update_hint)
>  {
>  	struct blkcg_gq *blkg;
>  
> @@ -135,14 +135,19 @@ static struct blkcg_gq *__blkg_lookup(struct blkcg *blkcg,
>  		return blkg;
>  
>  	/*
> -	 * Hint didn't match.  Look up from the radix tree.  Note that we
> -	 * may not be holding queue_lock and thus are not sure whether
> -	 * @blkg from blkg_tree has already been removed or not, so we
> -	 * can't update hint to the lookup result.  Leave it to the caller.
> +	 * Hint didn't match.  Look up from the radix tree.  Note that the
> +	 * hint can only be updated under queue_lock as otherwise @blkg
> +	 * could have already been removed from blkg_tree.  The caller is
> +	 * responsible for grabbing queue_lock if @update_hint.
>  	 */
>  	blkg = radix_tree_lookup(&blkcg->blkg_tree, q->id);
> -	if (blkg && blkg->q == q)
> +	if (blkg && blkg->q == q) {
> +		if (update_hint) {
> +			lockdep_assert_held(q->queue_lock);
> +			rcu_assign_pointer(blkcg->blkg_hint, blkg);
> +		}
>  		return blkg;
> +	}
>  
>  	return NULL;
>  }
> @@ -162,7 +167,7 @@ struct blkcg_gq *blkg_lookup(struct blkcg *blkcg, struct request_queue *q)
>  
>  	if (unlikely(blk_queue_bypass(q)))
>  		return NULL;
> -	return __blkg_lookup(blkcg, q);
> +	return __blkg_lookup(blkcg, q, false);
>  }
>  EXPORT_SYMBOL_GPL(blkg_lookup);
>  
> @@ -170,9 +175,9 @@ EXPORT_SYMBOL_GPL(blkg_lookup);
>   * If @new_blkg is %NULL, this function tries to allocate a new one as
>   * necessary using %GFP_ATOMIC.  @new_blkg is always consumed on return.
>   */
> -static struct blkcg_gq *__blkg_lookup_create(struct blkcg *blkcg,
> -					     struct request_queue *q,
> -					     struct blkcg_gq *new_blkg)
> +static struct blkcg_gq *blkg_create(struct blkcg *blkcg,
> +				    struct request_queue *q,
> +				    struct blkcg_gq *new_blkg)
>  {
>  	struct blkcg_gq *blkg;
>  	int ret;
> @@ -180,13 +185,6 @@ static struct blkcg_gq *__blkg_lookup_create(struct blkcg *blkcg,
>  	WARN_ON_ONCE(!rcu_read_lock_held());
>  	lockdep_assert_held(q->queue_lock);
>  
> -	/* lookup and update hint on success, see __blkg_lookup() for details */
> -	blkg = __blkg_lookup(blkcg, q);
> -	if (blkg) {
> -		rcu_assign_pointer(blkcg->blkg_hint, blkg);
> -		goto out_free;
> -	}
> -
>  	/* blkg holds a reference to blkcg */
>  	if (!css_tryget(&blkcg->css)) {
>  		blkg = ERR_PTR(-EINVAL);
> @@ -223,16 +221,39 @@ out_free:
>  	return blkg;
>  }
>  
> +/**
> + * blkg_lookup_create - lookup blkg, try to create one if not there
> + * @blkcg: blkcg of interest
> + * @q: request_queue of interest
> + *
> + * Lookup blkg for the @blkcg - @q pair.  If it doesn't exist, try to
> + * create one.  This function should be called under RCU read lock and
> + * @q->queue_lock.
> + *
> + * Returns pointer to the looked up or created blkg on success, ERR_PTR()
> + * value on error.  If @q is dead, returns ERR_PTR(-EINVAL).  If @q is not
> + * dead and bypassing, returns ERR_PTR(-EBUSY).
> + */
>  struct blkcg_gq *blkg_lookup_create(struct blkcg *blkcg,
>  				    struct request_queue *q)
>  {
> +	struct blkcg_gq *blkg;
> +
> +	WARN_ON_ONCE(!rcu_read_lock_held());
> +	lockdep_assert_held(q->queue_lock);
> +
>  	/*
>  	 * This could be the first entry point of blkcg implementation and
>  	 * we shouldn't allow anything to go through for a bypassing queue.
>  	 */
>  	if (unlikely(blk_queue_bypass(q)))
>  		return ERR_PTR(blk_queue_dead(q) ? -EINVAL : -EBUSY);
> -	return __blkg_lookup_create(blkcg, q, NULL);
> +
> +	blkg = __blkg_lookup(blkcg, q, true);
> +	if (blkg)
> +		return blkg;
> +
> +	return blkg_create(blkcg, q, NULL);
>  }
>  EXPORT_SYMBOL_GPL(blkg_lookup_create);
>  
> @@ -777,7 +798,7 @@ int blkcg_activate_policy(struct request_queue *q,
>  			  const struct blkcg_policy *pol)
>  {
>  	LIST_HEAD(pds);
> -	struct blkcg_gq *blkg;
> +	struct blkcg_gq *blkg, *new_blkg;
>  	struct blkg_policy_data *pd, *n;
>  	int cnt = 0, ret;
>  	bool preloaded;
> @@ -786,19 +807,27 @@ int blkcg_activate_policy(struct request_queue *q,
>  		return 0;
>  
>  	/* preallocations for root blkg */
> -	blkg = blkg_alloc(&blkcg_root, q, GFP_KERNEL);
> -	if (!blkg)
> +	new_blkg = blkg_alloc(&blkcg_root, q, GFP_KERNEL);
> +	if (!new_blkg)
>  		return -ENOMEM;
>  
>  	preloaded = !radix_tree_preload(GFP_KERNEL);
>  
>  	blk_queue_bypass_start(q);
>  
> -	/* make sure the root blkg exists and count the existing blkgs */
> +	/*
> +	 * Make sure the root blkg exists and count the existing blkgs.  As
> +	 * @q is bypassing at this point, blkg_lookup_create() can't be
> +	 * used.  Open code it.
> +	 */
>  	spin_lock_irq(q->queue_lock);
>  
>  	rcu_read_lock();
> -	blkg = __blkg_lookup_create(&blkcg_root, q, blkg);
> +	blkg = __blkg_lookup(&blkcg_root, q, false);
> +	if (blkg)
> +		blkg_free(new_blkg);
> +	else
> +		blkg = blkg_create(&blkcg_root, q, new_blkg);
>  	rcu_read_unlock();
>  
>  	if (preloaded)
> -- 
> 1.7.11.7
