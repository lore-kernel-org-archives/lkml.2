Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751777Ab2LQUqT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 15:46:19 -0500
Received: from mx1.redhat.com ([209.132.183.28]:25557 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750889Ab2LQUqR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 15:46:17 -0500
Date: Mon, 17 Dec 2012 15:46:09 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: lizefan@huawei.com, axboe@kernel.dk, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        ctalbott@google.com, rni@google.com
Subject: Re: [PATCH 06/12] cfq-iosched: implement cfq_group->nr_active and
 ->level_weight
Message-ID: <20121217204609.GH7235@redhat.com>
References: <1355524885-22719-1-git-send-email-tj@kernel.org>
 <1355524885-22719-7-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1355524885-22719-7-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 14, 2012 at 02:41:19PM -0800, Tejun Heo wrote:
> To prepare for blkcg hierarchy support, add cfqg->nr_active and
> ->level_weight.  cfqg->nr_active counts the number of active cfqgs at
> the cfqg's level and ->level_weight is sum of weights of those cfqgs.
> The level covers itself (cfqg->leaf_weight) and immediate children.

This notion of level is really confusing. If one says "at cfqg's level"
I immediately associate with cfqg's siblings and not with cfqg's children.

I think confusion happens because we are overloading the definition of
cfqg. It is competing with its siblings at the same time it is competing
against its child groups (on behalf of its children tasks).

Thanks
Vivek

> 
> The two values are updated when a cfqg enters and leaves the group
> service tree.  Unless the hierarchy is very deep, the added overhead
> should be negligible.
> 
> Currently, the parent is determined using cfqg_flat_parent() which
> makes the root cfqg the parent of all other cfqgs.  This is to make
> the transition to hierarchy-aware scheduling gradual.  Scheduling
> logic will be converted to use cfqg->level_weight without actually
> changing the behavior.  When everything is ready,
> blkcg_weight_parent() will be replaced with proper parent function.
> 
> This patch doesn't introduce any behavior chagne.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> ---
>  block/cfq-iosched.c | 76 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 76 insertions(+)
> 
> diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
> index 5f23763..eb290a0 100644
> --- a/block/cfq-iosched.c
> +++ b/block/cfq-iosched.c
> @@ -225,6 +225,18 @@ struct cfq_group {
>  	u64 vdisktime;
>  
>  	/*
> +	 * The number of active cfqgs and sum of their weights under this
> +	 * cfqg.  This covers this cfqg's leaf_weight and all children's
> +	 * weights, but does not cover weights of further descendants.
> +	 *
> +	 * If a cfqg is on the service tree, it's active.  An active cfqg
> +	 * also activates its parent and contributes to the level_weight of
> +	 * the parent.
> +	 */
> +	int nr_active;
> +	unsigned int level_weight;
> +
> +	/*
>  	 * There are two weights - (internal) weight is the weight of this
>  	 * cfqg against the sibling cfqgs.  leaf_weight is the wight of
>  	 * this cfqg against the child cfqgs.  For the root cfqg, both
> @@ -583,6 +595,22 @@ static inline struct cfq_group *blkg_to_cfqg(struct blkcg_gq *blkg)
>  	return pd_to_cfqg(blkg_to_pd(blkg, &blkcg_policy_cfq));
>  }
>  
> +/*
> + * Determine the parent cfqg for weight calculation.  Currently, cfqg
> + * scheduling is flat and the root is the parent of everyone else.
> + */
> +static inline struct cfq_group *cfqg_flat_parent(struct cfq_group *cfqg)
> +{
> +	struct blkcg_gq *blkg = cfqg_to_blkg(cfqg);
> +	struct cfq_group *root;
> +
> +	while (blkg->parent)
> +		blkg = blkg->parent;
> +	root = blkg_to_cfqg(blkg);
> +
> +	return root != cfqg ? root : NULL;
> +}
> +
>  static inline void cfqg_get(struct cfq_group *cfqg)
>  {
>  	return blkg_get(cfqg_to_blkg(cfqg));
> @@ -683,6 +711,7 @@ static void cfq_pd_reset_stats(struct blkcg_gq *blkg)
>  
>  #else	/* CONFIG_CFQ_GROUP_IOSCHED */
>  
> +static inline struct cfq_group *cfqg_flat_parent(struct cfq_group *cfqg) { return NULL; }
>  static inline void cfqg_get(struct cfq_group *cfqg) { }
>  static inline void cfqg_put(struct cfq_group *cfqg) { }
>  
> @@ -1208,11 +1237,33 @@ cfq_update_group_weight(struct cfq_group *cfqg)
>  static void
>  cfq_group_service_tree_add(struct cfq_rb_root *st, struct cfq_group *cfqg)
>  {
> +	struct cfq_group *pos = cfqg;
> +	bool propagate;
> +
> +	/* add to the service tree */
>  	BUG_ON(!RB_EMPTY_NODE(&cfqg->rb_node));
>  
>  	cfq_update_group_weight(cfqg);
>  	__cfq_group_service_tree_add(st, cfqg);
>  	st->total_weight += cfqg->weight;
> +
> +	/*
> +	 * Activate @cfqg and propagate activation upwards until we meet an
> +	 * already activated node or reach root.
> +	 */
> +	propagate = !pos->nr_active++;
> +	pos->level_weight += pos->leaf_weight;
> +
> +	while (propagate) {
> +		struct cfq_group *parent = cfqg_flat_parent(pos);
> +
> +		if (!parent)
> +			break;
> +
> +		propagate = !parent->nr_active++;
> +		parent->level_weight += pos->weight;
> +		pos = parent;
> +	}
>  }
>  
>  static void
> @@ -1243,6 +1294,31 @@ cfq_group_notify_queue_add(struct cfq_data *cfqd, struct cfq_group *cfqg)
>  static void
>  cfq_group_service_tree_del(struct cfq_rb_root *st, struct cfq_group *cfqg)
>  {
> +	struct cfq_group *pos = cfqg;
> +	bool propagate;
> +
> +	/*
> +	 * Undo activation from cfq_group_service_tree_add().  Deactivate
> +	 * @cfqg and propagate deactivation upwards.
> +	 */
> +	propagate = !--pos->nr_active;
> +	pos->level_weight -= pos->leaf_weight;
> +
> +	while (propagate) {
> +		struct cfq_group *parent = cfqg_flat_parent(pos);
> +
> +		/* @pos has 0 nr_active at this point */
> +		WARN_ON_ONCE(pos->level_weight);
> +
> +		if (!parent)
> +			break;
> +
> +		propagate = !--parent->nr_active;
> +		parent->level_weight -= pos->weight;
> +		pos = parent;
> +	}
> +
> +	/* remove from the service tree */
>  	st->total_weight -= cfqg->weight;
>  	if (!RB_EMPTY_NODE(&cfqg->rb_node))
>  		cfq_rb_erase(&cfqg->rb_node, st);
> -- 
> 1.7.11.7
