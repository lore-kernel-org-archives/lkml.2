Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753056Ab0LXTiO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Dec 2010 14:38:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44942 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752830Ab0LXTiN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Dec 2010 14:38:13 -0500
Date: Fri, 24 Dec 2010 14:38:10 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Shaohua Li <shaohua.li@intel.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Jens Axboe <jaxboe@fusionio.com>,
        "jmoyer@redhat.com" <jmoyer@redhat.com>
Subject: Re: [PATCH 2/2]block cfq: don't use atomic_t for cfq_group
Message-ID: <20101224193810.GC2082@redhat.com>
References: <1293072335.10593.22.camel@sli10-conroe>
 <20101223151844.GD9502@redhat.com>
 <1293151259.10593.24.camel@sli10-conroe>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1293151259.10593.24.camel@sli10-conroe>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 24, 2010 at 08:40:59AM +0800, Shaohua Li wrote:
> On Thu, 2010-12-23 at 23:18 +0800, Vivek Goyal wrote:
> > On Thu, Dec 23, 2010 at 10:45:35AM +0800, Shaohua Li wrote:
> > > cfq_group->ref is used with queue_lock hold, the only exception is
> > > cfq_set_request, which looks like a bug to me, so ref doesn't need
> > > to be an atomic and atomic operation is slower.
> > > 
> > 
> > [..]
> > >  
> > > @@ -3683,12 +3685,13 @@ new_queue:
> > >  
> > >  	cfqq->allocated[rw]++;
> > >  	cfqq->ref++;
> > > +	cfqg = cfq_ref_get_cfqg(cfqq->cfqg);
> > >  
> > >  	spin_unlock_irqrestore(q->queue_lock, flags);
> > >  
> > >  	rq->elevator_private = cic;
> > >  	rq->elevator_private2 = cfqq;
> > > -	rq->elevator_private3 = cfq_ref_get_cfqg(cfqq->cfqg);
> > > +	rq->elevator_private3 = cfqg;
> > 
> > I think you can move every thing under spinlock. IOW, first set the
> > rq->elevator_private* fields and delay the release of spinlock. Few
> > days back I was also looking at wondering that why are we releasing
> > the spinlock early.
> sure, it's harmless anyway and more readable. Updated the patch.
> 
> cfq_group->ref is used with queue_lock hold, the only exception is
> cfq_set_request, which looks like a bug to me, so ref doesn't need
> to be an atomic and atomic operation is slower.
> 
> Signed-off-by: Shaohua Li <shaohua.li@intel.com>
> Reviewed-by: Jeff Moyer <jmoyer@redhat.com>

Looks good to me.

Acked-by: Vivek Goyal <vgoyal@redhat.com>

Vivek

> ---
>  block/cfq-iosched.c |   23 ++++++++++++-----------
>  1 file changed, 12 insertions(+), 11 deletions(-)
> 
> Index: linux/block/cfq-iosched.c
> ===================================================================
> --- linux.orig/block/cfq-iosched.c	2010-12-24 08:32:19.000000000 +0800
> +++ linux/block/cfq-iosched.c	2010-12-24 08:33:10.000000000 +0800
> @@ -209,7 +209,7 @@ struct cfq_group {
>  	struct blkio_group blkg;
>  #ifdef CONFIG_CFQ_GROUP_IOSCHED
>  	struct hlist_node cfqd_node;
> -	atomic_t ref;
> +	int ref;
>  #endif
>  	/* number of requests that are on the dispatch list or inside driver */
>  	int dispatched;
> @@ -1026,7 +1026,7 @@ cfq_find_alloc_cfqg(struct cfq_data *cfq
>  	 * elevator which will be dropped by either elevator exit
>  	 * or cgroup deletion path depending on who is exiting first.
>  	 */
> -	atomic_set(&cfqg->ref, 1);
> +	cfqg->ref = 1;
>  
>  	/*
>  	 * Add group onto cgroup list. It might happen that bdi->dev is
> @@ -1071,7 +1071,7 @@ static struct cfq_group *cfq_get_cfqg(st
>  
>  static inline struct cfq_group *cfq_ref_get_cfqg(struct cfq_group *cfqg)
>  {
> -	atomic_inc(&cfqg->ref);
> +	cfqg->ref++;
>  	return cfqg;
>  }
>  
> @@ -1083,7 +1083,7 @@ static void cfq_link_cfqq_cfqg(struct cf
>  
>  	cfqq->cfqg = cfqg;
>  	/* cfqq reference on cfqg */
> -	atomic_inc(&cfqq->cfqg->ref);
> +	cfqq->cfqg->ref++;
>  }
>  
>  static void cfq_put_cfqg(struct cfq_group *cfqg)
> @@ -1091,8 +1091,9 @@ static void cfq_put_cfqg(struct cfq_grou
>  	struct cfq_rb_root *st;
>  	int i, j;
>  
> -	BUG_ON(atomic_read(&cfqg->ref) <= 0);
> -	if (!atomic_dec_and_test(&cfqg->ref))
> +	BUG_ON(cfqg->ref <= 0);
> +	cfqg->ref--;
> +	if (cfqg->ref)
>  		return;
>  	for_each_cfqg_st(cfqg, i, j, st)
>  		BUG_ON(!RB_EMPTY_ROOT(&st->rb) || st->active != NULL);
> @@ -1200,7 +1201,7 @@ static void cfq_service_tree_add(struct
>  			cfq_group_service_tree_del(cfqd, cfqq->cfqg);
>  		cfqq->orig_cfqg = cfqq->cfqg;
>  		cfqq->cfqg = &cfqd->root_group;
> -		atomic_inc(&cfqd->root_group.ref);
> +		cfqd->root_group.ref++;
>  		group_changed = 1;
>  	} else if (!cfqd->cfq_group_isolation
>  		   && cfqq_type(cfqq) == SYNC_WORKLOAD && cfqq->orig_cfqg) {
> @@ -3683,12 +3684,12 @@ new_queue:
>  
>  	cfqq->allocated[rw]++;
>  	cfqq->ref++;
> -
> -	spin_unlock_irqrestore(q->queue_lock, flags);
> -
>  	rq->elevator_private = cic;
>  	rq->elevator_private2 = cfqq;
>  	rq->elevator_private3 = cfq_ref_get_cfqg(cfqq->cfqg);
> +
> +	spin_unlock_irqrestore(q->queue_lock, flags);
> +
>  	return 0;
>  
>  queue_fail:
> @@ -3886,7 +3887,7 @@ static void *cfq_init_queue(struct reque
>  	 * Take a reference to root group which we never drop. This is just
>  	 * to make sure that cfq_put_cfqg() does not try to kfree root group
>  	 */
> -	atomic_set(&cfqg->ref, 1);
> +	cfqg->ref = 1;
>  	rcu_read_lock();
>  	cfq_blkiocg_add_blkio_group(&blkio_root_cgroup, &cfqg->blkg,
>  					(void *)cfqd, 0);
> 
