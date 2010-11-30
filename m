Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751516Ab0K3O24 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 09:28:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:28397 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751112Ab0K3O2z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 09:28:55 -0500
Date: Tue, 30 Nov 2010 09:28:50 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Cc: Jens Axboe <axboe@kernel.dk>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cfq-iosched: Get rid of st->active
Message-ID: <20101130142850.GB26758@redhat.com>
References: <4CF4B7C6.7080600@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CF4B7C6.7080600@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 30, 2010 at 04:37:26PM +0800, Gui Jianfeng wrote:
> When a cfq group is running, it won't be dequeued from service tree, so
> there's no need to store the active one in st->active. Just gid rid of it.
> 
> Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
> Acked-by: Vivek Goyal <vgoyal@redhat.com>

Looks good to me. st->left and st->active seems to be same as we never
dequeue the group while it is being serviced.

I think in previous implementations I had first dequeued the group while
it is being serviced and in that case st->left and st->active will be
different, hence this additional pointer. Later changed the implementation
and now st->active should not be needed.

Thanks for the cleanup Gui.

Acked-by: Vivek Goyal <vgoyal@redhat.com>

Vivek

> ---
>  block/cfq-iosched.c |   15 +--------------
>  1 files changed, 1 insertions(+), 14 deletions(-)
> 
> diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
> index 73a5862..e18d316 100644
> --- a/block/cfq-iosched.c
> +++ b/block/cfq-iosched.c
> @@ -87,7 +87,6 @@ struct cfq_rb_root {
>  	unsigned count;
>  	unsigned total_weight;
>  	u64 min_vdisktime;
> -	struct rb_node *active;
>  };
>  #define CFQ_RB_ROOT	(struct cfq_rb_root) { .rb = RB_ROOT, .left = NULL, \
>  			.count = 0, .min_vdisktime = 0, }
> @@ -563,11 +562,6 @@ static void update_min_vdisktime(struct cfq_rb_root *st)
>  	u64 vdisktime = st->min_vdisktime;
>  	struct cfq_group *cfqg;
>  
> -	if (st->active) {
> -		cfqg = rb_entry_cfqg(st->active);
> -		vdisktime = cfqg->vdisktime;
> -	}
> -
>  	if (st->left) {
>  		cfqg = rb_entry_cfqg(st->left);
>  		vdisktime = min_vdisktime(vdisktime, cfqg->vdisktime);
> @@ -894,9 +888,6 @@ cfq_group_service_tree_del(struct cfq_data *cfqd, struct cfq_group *cfqg)
>  {
>  	struct cfq_rb_root *st = &cfqd->grp_service_tree;
>  
> -	if (st->active == &cfqg->rb_node)
> -		st->active = NULL;
> -
>  	BUG_ON(cfqg->nr_cfqq < 1);
>  	cfqg->nr_cfqq--;
>  
> @@ -1095,7 +1086,7 @@ static void cfq_put_cfqg(struct cfq_group *cfqg)
>  	if (!atomic_dec_and_test(&cfqg->ref))
>  		return;
>  	for_each_cfqg_st(cfqg, i, j, st)
> -		BUG_ON(!RB_EMPTY_ROOT(&st->rb) || st->active != NULL);
> +		BUG_ON(!RB_EMPTY_ROOT(&st->rb));
>  	kfree(cfqg);
>  }
>  
> @@ -1687,9 +1678,6 @@ __cfq_slice_expired(struct cfq_data *cfqd, struct cfq_queue *cfqq,
>  	if (cfqq == cfqd->active_queue)
>  		cfqd->active_queue = NULL;
>  
> -	if (&cfqq->cfqg->rb_node == cfqd->grp_service_tree.active)
> -		cfqd->grp_service_tree.active = NULL;
> -
>  	if (cfqd->active_cic) {
>  		put_io_context(cfqd->active_cic->ioc);
>  		cfqd->active_cic = NULL;
> @@ -2199,7 +2187,6 @@ static struct cfq_group *cfq_get_next_cfqg(struct cfq_data *cfqd)
>  	if (RB_EMPTY_ROOT(&st->rb))
>  		return NULL;
>  	cfqg = cfq_rb_first_group(st);
> -	st->active = &cfqg->rb_node;
>  	update_min_vdisktime(st);
>  	return cfqg;
>  }
> -- 
> 1.6.5.2
> 
> 
