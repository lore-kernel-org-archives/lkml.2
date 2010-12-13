Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757828Ab0LMWL5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 17:11:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:3109 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752642Ab0LMWL4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 17:11:56 -0500
Date: Mon, 13 Dec 2010 17:11:41 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Cc: Jens Axboe <axboe@kernel.dk>, Corrado Zoccolo <czoccolo@gmail.com>,
        Chad Talbott <ctalbott@google.com>, Nauman Rafique <nauman@google.com>,
        Divyesh Shah <dpshah@google.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/8 v2] cfq-iosched: Extract some common code of service
 tree handling for CFQ queue and CFQ group.
Message-ID: <20101213221141.GF3999@redhat.com>
References: <4CDF7BC5.9080803@cn.fujitsu.com>
 <4CDF9CC6.2040106@cn.fujitsu.com>
 <20101115165319.GI30792@redhat.com>
 <4CE2718C.6010406@kernel.dk>
 <4D01C6AB.9040807@cn.fujitsu.com>
 <4D057A96.10707@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D057A96.10707@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 13, 2010 at 09:44:54AM +0800, Gui Jianfeng wrote:
> Extract some common code of service tree handling for CFQ queue and 
> CFQ group. This helps when CFQ queue and CFQ group are scheduling
> together.
> 
> Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
> ---
>  block/cfq-iosched.c |   87 +++++++++++++++++++++------------------------------
>  1 files changed, 36 insertions(+), 51 deletions(-)

This looks good to me. 

Acked-by: Vivek Goyal <vgoyal@redhat.com>

> 
> diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
> index 30d19c0..6486956 100644
> --- a/block/cfq-iosched.c
> +++ b/block/cfq-iosched.c
> @@ -863,12 +863,11 @@ entity_key(struct cfq_rb_root *st, struct cfq_entity *entity)
>  }
>  
>  static void
> -__cfq_group_service_tree_add(struct cfq_rb_root *st, struct cfq_group *cfqg)
> +__cfq_entity_service_tree_add(struct cfq_rb_root *st, struct cfq_entity *cfqe)
>  {
>  	struct rb_node **node = &st->rb.rb_node;
>  	struct rb_node *parent = NULL;
>  	struct cfq_entity *__cfqe;
> -	struct cfq_entity *cfqe = &cfqg->cfqe;
>  	s64 key = entity_key(st, cfqe);
>  	int left = 1;
>  
> @@ -892,6 +891,14 @@ __cfq_group_service_tree_add(struct cfq_rb_root *st, struct cfq_group *cfqg)
>  }
>  
>  static void
> +cfq_entity_service_tree_add(struct cfq_rb_root *st, struct cfq_entity *cfqe)
> +{
> +	__cfq_entity_service_tree_add(st, cfqe);
> +	st->count++;
> +	st->total_weight += cfqe->weight;
> +}
> +
> +static void
>  cfq_group_service_tree_add(struct cfq_data *cfqd, struct cfq_group *cfqg)
>  {
>  	struct cfq_rb_root *st = &cfqd->grp_service_tree;
> @@ -915,8 +922,23 @@ cfq_group_service_tree_add(struct cfq_data *cfqd, struct cfq_group *cfqg)
>  	} else
>  		cfqe->vdisktime = st->min_vdisktime;
>  
> -	__cfq_group_service_tree_add(st, cfqg);
> -	st->total_weight += cfqe->weight;
> +	cfq_entity_service_tree_add(st, cfqe);
> +}
> +
> +static void
> +__cfq_entity_service_tree_del(struct cfq_rb_root *st, struct cfq_entity *cfqe)
> +{
> +	cfq_rb_erase(&cfqe->rb_node, st);
> +}
> +
> +static void
> +cfq_entity_service_tree_del(struct cfq_rb_root *st, struct cfq_entity *cfqe)
> +{
> +	if (!RB_EMPTY_NODE(&cfqe->rb_node)) {
> +		__cfq_entity_service_tree_del(st, cfqe);
> +		st->total_weight -= cfqe->weight;
> +		cfqe->service_tree = NULL;
> +	}
>  }
>  
>  static void
> @@ -933,9 +955,7 @@ cfq_group_service_tree_del(struct cfq_data *cfqd, struct cfq_group *cfqg)
>  		return;
>  
>  	cfq_log_cfqg(cfqd, cfqg, "del_from_rr group");
> -	st->total_weight -= cfqe->weight;
> -	if (!RB_EMPTY_NODE(&cfqe->rb_node))
> -		cfq_rb_erase(&cfqe->rb_node, st);
> +	cfq_entity_service_tree_del(st, cfqe);
>  	cfqg->saved_workload_slice = 0;
>  	cfq_blkiocg_update_dequeue_stats(&cfqg->blkg, 1);
>  }
> @@ -984,9 +1004,9 @@ static void cfq_group_served(struct cfq_data *cfqd, struct cfq_group *cfqg,
>  		charge = cfqq->allocated_slice;
>  
>  	/* Can't update vdisktime while group is on service tree */
> -	cfq_rb_erase(&cfqe->rb_node, st);
> +	__cfq_entity_service_tree_del(st, cfqe);
>  	cfqe->vdisktime += cfq_scale_slice(charge, cfqe);
> -	__cfq_group_service_tree_add(st, cfqg);
> +	__cfq_entity_service_tree_add(st, cfqe);
>  
>  	/* This group is being expired. Save the context */
>  	if (time_after(cfqd->workload_expires, jiffies)) {
> @@ -1223,13 +1243,11 @@ static void cfq_service_tree_add(struct cfq_data *cfqd, struct cfq_queue *cfqq,
>  				 bool add_front)
>  {
>  	struct cfq_entity *cfqe;
> -	struct rb_node **p, *parent;
> +	struct rb_node *parent;
>  	struct cfq_entity *__cfqe;
>  	struct cfq_rb_root *service_tree, *orig_st;
> -	int left;
>  	int new_cfqq = 1;
>  	int group_changed = 0;
> -	s64 key;
>  
>  	cfqe = &cfqq->cfqe;
>  	orig_st = cfqe->service_tree;
> @@ -1246,8 +1264,7 @@ static void cfq_service_tree_add(struct cfq_data *cfqd, struct cfq_queue *cfqq,
>  			 * Group changed, dequeue this CFQ queue from the
>  			 * original service tree.
>  			 */
> -			cfq_rb_erase(&cfqe->rb_node, cfqe->service_tree);
> -			orig_st->total_weight -= cfqe->weight;
> +			cfq_entity_service_tree_del(orig_st, cfqe);
>  		}
>  		cfqq->orig_cfqg = cfqq->cfqg;
>  		cfqq->cfqg = &cfqd->root_group;
> @@ -1263,8 +1280,7 @@ static void cfq_service_tree_add(struct cfq_data *cfqd, struct cfq_queue *cfqq,
>  			 * Group changed, dequeue this CFQ queue from the
>  			 * original service tree.
>  			 */
> -			cfq_rb_erase(&cfqe->rb_node, cfqe->service_tree);
> -			orig_st->total_weight -= cfqe->weight;
> +			cfq_entity_service_tree_del(orig_st, cfqe);
>  		}
>  		cfq_put_cfqg(cfqq->cfqg);
>  		cfqq->cfqg = cfqq->orig_cfqg;
> @@ -1310,8 +1326,7 @@ static void cfq_service_tree_add(struct cfq_data *cfqd, struct cfq_queue *cfqq,
>  	 * Ok, we get here, this CFQ queue is on the service tree, dequeue it
>  	 * firstly.
>  	 */
> -	cfq_rb_erase(&cfqe->rb_node, cfqe->service_tree);
> -	orig_st->total_weight -= cfqe->weight;
> +	cfq_entity_service_tree_del(orig_st, cfqe);
>  
>  	new_cfqq = 0;
>  
> @@ -1338,39 +1353,12 @@ static void cfq_service_tree_add(struct cfq_data *cfqd, struct cfq_queue *cfqq,
>  	}
>  
>  insert:
> -	left = 1;
> -	parent = NULL;
>  	cfqe->service_tree = service_tree;
> -	p = &service_tree->rb.rb_node;
> -	key = entity_key(service_tree, cfqe);
> -	while (*p) {
> -		struct rb_node **n;
> -
> -		parent = *p;
> -		__cfqe = rb_entry(parent, struct cfq_entity,
> -					  rb_node);
> -
> -		/*
> -		 * sort by key, that represents service time.
> -		 */
> -		if (key < entity_key(service_tree, __cfqe))
> -			n = &(*p)->rb_left;
> -		else {
> -			n = &(*p)->rb_right;
> -			left = 0;
> -		}
>  
> -		p = n;
> -	}
> +	/* Add cfqq onto service tree. */
> +	cfq_entity_service_tree_add(service_tree, cfqe);
>  
> -	if (left)
> -		service_tree->left = &cfqe->rb_node;
> -
> -	rb_link_node(&cfqe->rb_node, parent, p);
> -	rb_insert_color(&cfqe->rb_node, &service_tree->rb);
>  	update_min_vdisktime(service_tree);
> -	service_tree->count++;
> -	service_tree->total_weight += cfqe->weight;
>  	cfqq->reposition_time = jiffies;
>  	if ((add_front || !new_cfqq) && !group_changed)
>  		return;
> @@ -1483,10 +1471,7 @@ static void cfq_del_cfqq_rr(struct cfq_data *cfqd, struct cfq_queue *cfqq)
>  	service_tree = cfqe->service_tree;
>  
>  	if (!RB_EMPTY_NODE(&cfqe->rb_node)) {
> -		cfq_rb_erase(&cfqe->rb_node,
> -			     cfqe->service_tree);
> -		service_tree->total_weight -= cfqe->weight;
> -		cfqe->service_tree = NULL;
> +		cfq_entity_service_tree_del(service_tree, cfqe);
>  	}
>  	if (cfqq->p_root) {
>  		rb_erase(&cfqq->p_node, cfqq->p_root);
> -- 
> 1.6.5.2
> 
