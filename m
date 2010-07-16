Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965672Ab0GPOAm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 10:00:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18366 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965621Ab0GPOAl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 10:00:41 -0400
Date: Fri, 16 Jul 2010 10:00:34 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Cc: Jens Axboe <axboe@kernel.dk>, Jeff Moyer <jmoyer@redhat.com>,
        Corrado Zoccolo <czoccolo@gmail.com>,
        Shaohua Li <shaohua.li@intel.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] [RFC] CFQ: Make prio_trees per cfq group basis to
 improve IO performance
Message-ID: <20100716140034.GC15382@redhat.com>
References: <4C40247C.2010405@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C40247C.2010405@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 16, 2010 at 05:21:00PM +0800, Gui Jianfeng wrote:
> Currently, prio_trees is global, and we rely on cfqq_close() to search
> a coorperator. If the returned cfqq and the active cfqq don't belong to
> the same group, coorperator searching fails. Actually, that's not the case.
> Even if cfqq_close() returns a cfqq which belong to another cfq group, 
> it's still likely that a coorperator(same cfqg) resides in prio_trees.
> This patch introduces per cfq group prio_trees that should solve the above
> issue.
> 

Hi Gui,

I am not sure I understand the issue here.  So are you saying that once
we find a cfqq which is close but belongs to a different group we reject
it. But there could be another cfqq in the same group which is not as
close but still close enough.

For example, assume there are two queues q1 and q2 and in group and third
queue q3 in group B. Assume q1 is active queue and we are searching for
cooperator. If cooperator code finds q3 as closest then we will not pick
this queue as it belongs to a different group. But it could happen that
q2 is also close enough and we never considered that possibility.

If yes, then its a good theoritical concern but I am worried practically
how often does it happen. Do you have any workload which suffers because
of this?

I am not too inclined to push more complexity in CFQ until and unless we
have a good use case.

Thanks
Vivek
 

> Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
> ---
>  block/cfq-iosched.c |  171 ++++++++++++++++++++++++++-------------------------
>  1 files changed, 86 insertions(+), 85 deletions(-)
> 
> diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
> index eb4086f..43606e4 100644
> --- a/block/cfq-iosched.c
> +++ b/block/cfq-iosched.c
> @@ -190,6 +190,15 @@ struct cfq_group {
>  	struct cfq_rb_root service_trees[2][3];
>  	struct cfq_rb_root service_tree_idle;
>  
> +
> +	/*
> +	 * Each priority tree is sorted by next_request position.  These
> +	 * trees are used when determining if two or more queues are
> +	 * interleaving requests (see cfq_close_cooperator).
> +	 * Currently, priority tree is per cfq group basis.
> +	 */
> +	struct rb_root prio_trees[CFQ_PRIO_LISTS];
> +
>  	unsigned long saved_workload_slice;
>  	enum wl_type_t saved_workload;
>  	enum wl_prio_t saved_serving_prio;
> @@ -218,13 +227,6 @@ struct cfq_data {
>  	struct cfq_group *serving_group;
>  	bool noidle_tree_requires_idle;
>  
> -	/*
> -	 * Each priority tree is sorted by next_request position.  These
> -	 * trees are used when determining if two or more queues are
> -	 * interleaving requests (see cfq_close_cooperator).
> -	 */
> -	struct rb_root prio_trees[CFQ_PRIO_LISTS];
> -
>  	unsigned int busy_queues;
>  
>  	int rq_in_driver;
> @@ -987,6 +989,14 @@ cfq_find_alloc_cfqg(struct cfq_data *cfqd, struct cgroup *cgroup, int create)
>  	RB_CLEAR_NODE(&cfqg->rb_node);
>  
>  	/*
> +	 * Not strictly needed (since RB_ROOT just clears the node and we
> +	 * zeroed cfqd on alloc), but better be safe in case someone decides
> +	 * to add magic to the rb code
> +	 */
> +	for (i = 0; i < CFQ_PRIO_LISTS; i++)
> +		cfqg->prio_trees[i] = RB_ROOT;
> +
> +	/*
>  	 * Take the initial reference that will be released on destroy
>  	 * This can be thought of a joint reference by cgroup and
>  	 * elevator which will be dropped by either elevator exit
> @@ -1130,6 +1140,67 @@ static inline void cfq_put_cfqg(struct cfq_group *cfqg) {}
>  
>  #endif /* GROUP_IOSCHED */
>  
> +static struct cfq_queue *
> +cfq_prio_tree_lookup(struct cfq_group *cfqg, struct rb_root *root,
> +		     sector_t sector, struct rb_node **ret_parent,
> +		     struct rb_node ***rb_link)
> +{
> +	struct rb_node **p, *parent;
> +	struct cfq_queue *cfqq = NULL;
> +
> +	parent = NULL;
> +	p = &root->rb_node;
> +	while (*p) {
> +		struct rb_node **n;
> +
> +		parent = *p;
> +		cfqq = rb_entry(parent, struct cfq_queue, p_node);
> +
> +		/*
> +		 * Sort strictly based on sector.  Smallest to the left,
> +		 * largest to the right.
> +		 */
> +		if (sector > blk_rq_pos(cfqq->next_rq))
> +			n = &(*p)->rb_right;
> +		else if (sector < blk_rq_pos(cfqq->next_rq))
> +			n = &(*p)->rb_left;
> +		else
> +			break;
> +		p = n;
> +		cfqq = NULL;
> +	}
> +
> +	*ret_parent = parent;
> +	if (rb_link)
> +		*rb_link = p;
> +	return cfqq;
> +}
> +
> +static void cfq_prio_tree_add(struct cfq_group *cfqg, struct cfq_queue *cfqq)
> +{
> +	struct rb_node **p, *parent;
> +	struct cfq_queue *__cfqq;
> +
> +	if (cfqq->p_root) {
> +		rb_erase(&cfqq->p_node, cfqq->p_root);
> +		cfqq->p_root = NULL;
> +	}
> +
> +	if (cfq_class_idle(cfqq))
> +		return;
> +	if (!cfqq->next_rq)
> +		return;
> +
> +	cfqq->p_root = &cfqg->prio_trees[cfqq->org_ioprio];
> +	__cfqq = cfq_prio_tree_lookup(cfqg, cfqq->p_root,
> +				      blk_rq_pos(cfqq->next_rq), &parent, &p);
> +	if (!__cfqq) {
> +		rb_link_node(&cfqq->p_node, parent, p);
> +		rb_insert_color(&cfqq->p_node, cfqq->p_root);
> +	} else
> +		cfqq->p_root = NULL;
> +}
> +
>  /*
>   * The cfqd->service_trees holds all pending cfq_queue's that have
>   * requests waiting to be processed. It is sorted in the order that
> @@ -1156,6 +1227,7 @@ static void cfq_service_tree_add(struct cfq_data *cfqd, struct cfq_queue *cfqq,
>  			cfq_group_service_tree_del(cfqd, cfqq->cfqg);
>  		cfqq->orig_cfqg = cfqq->cfqg;
>  		cfqq->cfqg = &cfqd->root_group;
> +		cfq_prio_tree_add(cfqq->cfqg, cfqq);
>  		atomic_inc(&cfqd->root_group.ref);
>  		group_changed = 1;
>  	} else if (!cfqd->cfq_group_isolation
> @@ -1166,6 +1238,7 @@ static void cfq_service_tree_add(struct cfq_data *cfqd, struct cfq_queue *cfqq,
>  			cfq_group_service_tree_del(cfqd, cfqq->cfqg);
>  		cfq_put_cfqg(cfqq->cfqg);
>  		cfqq->cfqg = cfqq->orig_cfqg;
> +		cfq_prio_tree_add(cfqq->cfqg, cfqq);
>  		cfqq->orig_cfqg = NULL;
>  		group_changed = 1;
>  		cfq_log_cfqq(cfqd, cfqq, "moved to origin group");
> @@ -1246,67 +1319,6 @@ static void cfq_service_tree_add(struct cfq_data *cfqd, struct cfq_queue *cfqq,
>  	cfq_group_service_tree_add(cfqd, cfqq->cfqg);
>  }
>  
> -static struct cfq_queue *
> -cfq_prio_tree_lookup(struct cfq_data *cfqd, struct rb_root *root,
> -		     sector_t sector, struct rb_node **ret_parent,
> -		     struct rb_node ***rb_link)
> -{
> -	struct rb_node **p, *parent;
> -	struct cfq_queue *cfqq = NULL;
> -
> -	parent = NULL;
> -	p = &root->rb_node;
> -	while (*p) {
> -		struct rb_node **n;
> -
> -		parent = *p;
> -		cfqq = rb_entry(parent, struct cfq_queue, p_node);
> -
> -		/*
> -		 * Sort strictly based on sector.  Smallest to the left,
> -		 * largest to the right.
> -		 */
> -		if (sector > blk_rq_pos(cfqq->next_rq))
> -			n = &(*p)->rb_right;
> -		else if (sector < blk_rq_pos(cfqq->next_rq))
> -			n = &(*p)->rb_left;
> -		else
> -			break;
> -		p = n;
> -		cfqq = NULL;
> -	}
> -
> -	*ret_parent = parent;
> -	if (rb_link)
> -		*rb_link = p;
> -	return cfqq;
> -}
> -
> -static void cfq_prio_tree_add(struct cfq_data *cfqd, struct cfq_queue *cfqq)
> -{
> -	struct rb_node **p, *parent;
> -	struct cfq_queue *__cfqq;
> -
> -	if (cfqq->p_root) {
> -		rb_erase(&cfqq->p_node, cfqq->p_root);
> -		cfqq->p_root = NULL;
> -	}
> -
> -	if (cfq_class_idle(cfqq))
> -		return;
> -	if (!cfqq->next_rq)
> -		return;
> -
> -	cfqq->p_root = &cfqd->prio_trees[cfqq->org_ioprio];
> -	__cfqq = cfq_prio_tree_lookup(cfqd, cfqq->p_root,
> -				      blk_rq_pos(cfqq->next_rq), &parent, &p);
> -	if (!__cfqq) {
> -		rb_link_node(&cfqq->p_node, parent, p);
> -		rb_insert_color(&cfqq->p_node, cfqq->p_root);
> -	} else
> -		cfqq->p_root = NULL;
> -}
> -
>  /*
>   * Update cfqq's position in the service tree.
>   */
> @@ -1317,7 +1329,7 @@ static void cfq_resort_rr_list(struct cfq_data *cfqd, struct cfq_queue *cfqq)
>  	 */
>  	if (cfq_cfqq_on_rr(cfqq)) {
>  		cfq_service_tree_add(cfqd, cfqq, 0);
> -		cfq_prio_tree_add(cfqd, cfqq);
> +		cfq_prio_tree_add(cfqq->cfqg, cfqq);
>  	}
>  }
>  
> @@ -1413,7 +1425,7 @@ static void cfq_add_rq_rb(struct request *rq)
>  	 * adjust priority tree position, if ->next_rq changes
>  	 */
>  	if (prev != cfqq->next_rq)
> -		cfq_prio_tree_add(cfqd, cfqq);
> +		cfq_prio_tree_add(cfqq->cfqg, cfqq);
>  
>  	BUG_ON(!cfqq->next_rq);
>  }
> @@ -1729,9 +1741,10 @@ static inline int cfq_rq_close(struct cfq_data *cfqd, struct cfq_queue *cfqq,
>  }
>  
>  static struct cfq_queue *cfqq_close(struct cfq_data *cfqd,
> +				    struct cfq_group *cfqg,
>  				    struct cfq_queue *cur_cfqq)
>  {
> -	struct rb_root *root = &cfqd->prio_trees[cur_cfqq->org_ioprio];
> +	struct rb_root *root = &cfqg->prio_trees[cur_cfqq->org_ioprio];
>  	struct rb_node *parent, *node;
>  	struct cfq_queue *__cfqq;
>  	sector_t sector = cfqd->last_position;
> @@ -1743,7 +1756,7 @@ static struct cfq_queue *cfqq_close(struct cfq_data *cfqd,
>  	 * First, if we find a request starting at the end of the last
>  	 * request, choose it.
>  	 */
> -	__cfqq = cfq_prio_tree_lookup(cfqd, root, sector, &parent, NULL);
> +	__cfqq = cfq_prio_tree_lookup(cfqg, root, sector, &parent, NULL);
>  	if (__cfqq)
>  		return __cfqq;
>  
> @@ -1802,14 +1815,10 @@ static struct cfq_queue *cfq_close_cooperator(struct cfq_data *cfqd,
>  	 * working closely on the same area of the disk. In that case,
>  	 * we can group them together and don't waste time idling.
>  	 */
> -	cfqq = cfqq_close(cfqd, cur_cfqq);
> +	cfqq = cfqq_close(cfqd, cur_cfqq->cfqg, cur_cfqq);
>  	if (!cfqq)
>  		return NULL;
>  
> -	/* If new queue belongs to different cfq_group, don't choose it */
> -	if (cur_cfqq->cfqg != cfqq->cfqg)
> -		return NULL;
> -
>  	/*
>  	 * It only makes sense to merge sync queues.
>  	 */
> @@ -3815,14 +3824,6 @@ static void *cfq_init_queue(struct request_queue *q)
>  	rcu_read_unlock();
>  #endif
>  	/*
> -	 * Not strictly needed (since RB_ROOT just clears the node and we
> -	 * zeroed cfqd on alloc), but better be safe in case someone decides
> -	 * to add magic to the rb code
> -	 */
> -	for (i = 0; i < CFQ_PRIO_LISTS; i++)
> -		cfqd->prio_trees[i] = RB_ROOT;
> -
> -	/*
>  	 * Our fallback cfqq if cfq_find_alloc_queue() runs into OOM issues.
>  	 * Grab a permanent reference to it, so that the normal code flow
>  	 * will not attempt to free it.
> -- 
> 1.5.4.rc3
