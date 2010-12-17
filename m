Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756214Ab0LQW2L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 17:28:11 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:58103 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754817Ab0LQW2I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 17:28:08 -0500
Date: Fri, 17 Dec 2010 14:28:05 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, jaxboe@fusionio.com, oleg@redhat.com
Subject: Re: [PATCH 2/2] blk-throttle: Some cleanups and race fixes in
 limit update code
Message-ID: <20101217222805.GK2181@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1292447255-10698-1-git-send-email-vgoyal@redhat.com>
 <1292447255-10698-3-git-send-email-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1292447255-10698-3-git-send-email-vgoyal@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 15, 2010 at 04:07:35PM -0500, Vivek Goyal wrote:
> o When throttle group limits are updated through cgroups, a thread is woken
>   up to process these updates. While reviewing that code, oleg noted couple
>   of race conditions existed in the code and he also suggested that code can
>   be simplified.
> 
> o This patch fixes the races simplifies the code based on Oleg's suggestions.
>         - Use xchg().
>         - Introduced a common function throtl_update_blkio_group_common()
>           which is shared now by all iops/bps update functions.

OK, this looks good at the moment.  The HW guys are still tearing their
hair out, but this approach does appear to have an excellent chance of
turning out to be safe.  ;-)

A few questions below, but assuming the answers turn out to be what
I believe them to be:

Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

> Reviewed-by: Oleg Nesterov <oleg@redhat.com>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> ---
>  block/blk-throttle.c |   96 +++++++++++++++++++++-----------------------------
>  1 files changed, 40 insertions(+), 56 deletions(-)
> 
> diff --git a/block/blk-throttle.c b/block/blk-throttle.c
> index 91bd444..549bc8e 100644
> --- a/block/blk-throttle.c
> +++ b/block/blk-throttle.c
> @@ -97,7 +97,7 @@ struct throtl_data
>  	/* Work for dispatching throttled bios */
>  	struct delayed_work throtl_work;
> 
> -	atomic_t limits_changed;
> +	bool limits_changed;
>  };
> 
>  enum tg_state_flags {
> @@ -188,6 +188,7 @@ static struct throtl_grp * throtl_find_alloc_tg(struct throtl_data *td,
>  	RB_CLEAR_NODE(&tg->rb_node);
>  	bio_list_init(&tg->bio_lists[0]);
>  	bio_list_init(&tg->bio_lists[1]);
> +	td->limits_changed = false;

This is at initialization time, correct?  No other CPUs have access
at this point, right?

>  	/*
>  	 * Take the initial reference that will be released on destroy
> @@ -725,34 +726,27 @@ static void throtl_process_limit_change(struct throtl_data *td)
>  	struct throtl_grp *tg;
>  	struct hlist_node *pos, *n;
> 
> -	if (!atomic_read(&td->limits_changed))
> +	if (!td->limits_changed)
>  		return;
> 
> -	throtl_log(td, "limit changed =%d", atomic_read(&td->limits_changed));
> +	xchg(&td->limits_changed, false);
> 
> -	/*
> -	 * Make sure updates from throtl_update_blkio_group_read_bps() group
> -	 * of functions to tg->limits_changed are visible. We do not
> -	 * want update td->limits_changed to be visible but update to
> -	 * tg->limits_changed not being visible yet on this cpu. Hence
> -	 * the read barrier.
> -	 */
> -	smp_rmb();
> +	throtl_log(td, "limits changed");
> 
>  	hlist_for_each_entry_safe(tg, pos, n, &td->tg_list, tg_node) {
> -		if (throtl_tg_on_rr(tg) && tg->limits_changed) {
> -			throtl_log_tg(td, tg, "limit change rbps=%llu wbps=%llu"
> -				" riops=%u wiops=%u", tg->bps[READ],
> -				tg->bps[WRITE], tg->iops[READ],
> -				tg->iops[WRITE]);
> +		if (!tg->limits_changed)
> +			continue;
> +
> +		if (!xchg(&tg->limits_changed, false))
> +			continue;
> +
> +		throtl_log_tg(td, tg, "limit change rbps=%llu wbps=%llu"
> +			" riops=%u wiops=%u", tg->bps[READ], tg->bps[WRITE],
> +			tg->iops[READ], tg->iops[WRITE]);
> +
> +		if (throtl_tg_on_rr(tg))
>  			tg_update_disptime(td, tg);
> -			tg->limits_changed = false;
> -		}
>  	}
> -
> -	smp_mb__before_atomic_dec();
> -	atomic_dec(&td->limits_changed);
> -	smp_mb__after_atomic_dec();
>  }
> 
>  /* Dispatch throttled bios. Should be called without queue lock held. */
> @@ -887,6 +881,15 @@ void throtl_unlink_blkio_group(void *key, struct blkio_group *blkg)
>  	spin_unlock_irqrestore(td->queue->queue_lock, flags);
>  }
> 
> +static void throtl_update_blkio_group_common(struct throtl_data *td,
> +				struct throtl_grp *tg)
> +{
> +	xchg(&tg->limits_changed, true);
> +	xchg(&td->limits_changed, true);
> +	/* Schedule a work now to process the limit change */
> +	throtl_schedule_delayed_work(td->queue, 0);
> +}
> +
>  /*
>   * For all update functions, key should be a valid pointer because these
>   * update functions are called under blkcg_lock, that means, blkg is
> @@ -900,61 +903,40 @@ static void throtl_update_blkio_group_read_bps(void *key,
>  				struct blkio_group *blkg, u64 read_bps)
>  {
>  	struct throtl_data *td = key;
> +	struct throtl_grp *tg = tg_of_blkg(blkg);
> 
> -	tg_of_blkg(blkg)->bps[READ] = read_bps;
> -	/* Make sure read_bps is updated before setting limits_changed */
> -	smp_wmb();
> -	tg_of_blkg(blkg)->limits_changed = true;
> -
> -	/* Make sure tg->limits_changed is updated before td->limits_changed */
> -	smp_mb__before_atomic_inc();
> -	atomic_inc(&td->limits_changed);
> -	smp_mb__after_atomic_inc();
> -
> -	/* Schedule a work now to process the limit change */
> -	throtl_schedule_delayed_work(td->queue, 0);
> +	tg->bps[READ] = read_bps;
> +	throtl_update_blkio_group_common(td, tg);
>  }
> 
>  static void throtl_update_blkio_group_write_bps(void *key,
>  				struct blkio_group *blkg, u64 write_bps)
>  {
>  	struct throtl_data *td = key;
> +	struct throtl_grp *tg = tg_of_blkg(blkg);
> 
> -	tg_of_blkg(blkg)->bps[WRITE] = write_bps;
> -	smp_wmb();
> -	tg_of_blkg(blkg)->limits_changed = true;
> -	smp_mb__before_atomic_inc();
> -	atomic_inc(&td->limits_changed);
> -	smp_mb__after_atomic_inc();
> -	throtl_schedule_delayed_work(td->queue, 0);
> +	tg->bps[WRITE] = write_bps;
> +	throtl_update_blkio_group_common(td, tg);
>  }
> 
>  static void throtl_update_blkio_group_read_iops(void *key,
>  			struct blkio_group *blkg, unsigned int read_iops)
>  {
>  	struct throtl_data *td = key;
> +	struct throtl_grp *tg = tg_of_blkg(blkg);
> 
> -	tg_of_blkg(blkg)->iops[READ] = read_iops;
> -	smp_wmb();
> -	tg_of_blkg(blkg)->limits_changed = true;
> -	smp_mb__before_atomic_inc();
> -	atomic_inc(&td->limits_changed);
> -	smp_mb__after_atomic_inc();
> -	throtl_schedule_delayed_work(td->queue, 0);
> +	tg->iops[READ] = read_iops;
> +	throtl_update_blkio_group_common(td, tg);
>  }
> 
>  static void throtl_update_blkio_group_write_iops(void *key,
>  			struct blkio_group *blkg, unsigned int write_iops)
>  {
>  	struct throtl_data *td = key;
> +	struct throtl_grp *tg = tg_of_blkg(blkg);
> 
> -	tg_of_blkg(blkg)->iops[WRITE] = write_iops;
> -	smp_wmb();
> -	tg_of_blkg(blkg)->limits_changed = true;
> -	smp_mb__before_atomic_inc();
> -	atomic_inc(&td->limits_changed);
> -	smp_mb__after_atomic_inc();
> -	throtl_schedule_delayed_work(td->queue, 0);
> +	tg->iops[WRITE] = write_iops;
> +	throtl_update_blkio_group_common(td, tg);
>  }
> 
>  void throtl_shutdown_timer_wq(struct request_queue *q)
> @@ -1001,6 +983,7 @@ int blk_throtl_bio(struct request_queue *q, struct bio **biop)
>  		 */
>  		update_disptime = false;
>  		goto queue_bio;
> +
>  	}
> 
>  	/* Bio is with-in rate limit of group */
> @@ -1041,7 +1024,7 @@ int blk_throtl_init(struct request_queue *q)
> 
>  	INIT_HLIST_HEAD(&td->tg_list);
>  	td->tg_service_tree = THROTL_RB_ROOT;
> -	atomic_set(&td->limits_changed, 0);
> +	td->limits_changed = false;

And the name leads me to believe that there are no other CPUs accessing
things at this point as well.  Correct?

>  	/* Init root group */
>  	tg = &td->root_tg;
> @@ -1053,6 +1036,7 @@ int blk_throtl_init(struct request_queue *q)
>  	/* Practically unlimited BW */
>  	tg->bps[0] = tg->bps[1] = -1;
>  	tg->iops[0] = tg->iops[1] = -1;
> +	td->limits_changed = false;

Ditto?

>  	/*
>  	 * Set root group reference to 2. One reference will be dropped when
> -- 
> 1.7.1
> 
