Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755474Ab2LRSkx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 13:40:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:19030 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755426Ab2LRSkv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 13:40:51 -0500
Date: Tue, 18 Dec 2012 13:40:23 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: lizefan@huawei.com, axboe@kernel.dk, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        ctalbott@google.com, rni@google.com
Subject: Re: [PATCH 09/12] cfq-iosched: enable full blkcg hierarchy support
Message-ID: <20121218184022.GC24050@redhat.com>
References: <1355524885-22719-1-git-send-email-tj@kernel.org>
 <1355524885-22719-10-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1355524885-22719-10-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 14, 2012 at 02:41:22PM -0800, Tejun Heo wrote:
> With the previous two patches, all cfqg scheduling decisions are based
> on vfraction and ready for hierarchy support.  The only thing which
> keeps the behavior flat is cfqg_flat_parent() which makes vfraction
> calculation consider all non-root cfqgs children of the root cfqg.
> 
> Replace it with cfqg_parent() which returns the real parent.  This
> enables full blkcg hierarchy support for cfq-iosched.  For example,
> consider the following hierarchy.
> 
>         root
>       /      \
>    A:500      B:250
>   /     \
>  AA:500  AB:1000
> 
> For simplicity, let's say all the leaf nodes have active tasks and are
> on service tree.  For each leaf node, vfraction would be
> 
>  AA: (500  / 1500) * (500 / 750) =~ 0.2222
>  AB: (1000 / 1500) * (500 / 750) =~ 0.4444
>   B:                 (250 / 750) =~ 0.3333
> 
> and vdisktime will be distributed accordingly.

Can we update Documentation/blkio-controller.txt file to explain all
this. Also it would be nice to also explain the case of a group having
both tasks and groups as child and then how shares will be calculated.
There we can also explain the notion of group->weight and
group->leaf_weight.

So in above picture assume group A had some tasks, say T1 and T2, and
root group had task T3. Also assuming that A->weight = 500 and
A->leaf_weight = 750 and root->weigt = root->leaf_weight = 125.

           root
       /   |     \ 
    A:500  B:250 root-auto-group:125
   /   | \                    |
  AA  AB  A-auto-group:750     T3
(500)(1000)   / \ 
	     T1 T2

Now vfraction (% share) will should look as follows.

root-auto-group: 125/875		=~ .1428 =~ 14%
B: 250/875				=~ .2857 =~ 28%
A-auto-group: (750/2250) * (500/875)	=~ .1904 =~ 19%
AA: (500  / 2250) * (500 / 875)		=~ .1269 =~ 12%
AB: (1000/2250) * (500/875)		=~ .2539 =~ 25% 

Thanks
Vivek

> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> ---
>  block/cfq-iosched.c | 21 ++++++---------------
>  1 file changed, 6 insertions(+), 15 deletions(-)
> 
> diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
> index fd2f4b4..ceade6e 100644
> --- a/block/cfq-iosched.c
> +++ b/block/cfq-iosched.c
> @@ -603,20 +603,11 @@ static inline struct cfq_group *blkg_to_cfqg(struct blkcg_gq *blkg)
>  	return pd_to_cfqg(blkg_to_pd(blkg, &blkcg_policy_cfq));
>  }
>  
> -/*
> - * Determine the parent cfqg for weight calculation.  Currently, cfqg
> - * scheduling is flat and the root is the parent of everyone else.
> - */
> -static inline struct cfq_group *cfqg_flat_parent(struct cfq_group *cfqg)
> +static inline struct cfq_group *cfqg_parent(struct cfq_group *cfqg)
>  {
> -	struct blkcg_gq *blkg = cfqg_to_blkg(cfqg);
> -	struct cfq_group *root;
> -
> -	while (blkg->parent)
> -		blkg = blkg->parent;
> -	root = blkg_to_cfqg(blkg);
> +	struct blkcg_gq *pblkg = cfqg_to_blkg(cfqg)->parent;
>  
> -	return root != cfqg ? root : NULL;
> +	return pblkg ? blkg_to_cfqg(pblkg) : NULL;
>  }
>  
>  static inline void cfqg_get(struct cfq_group *cfqg)
> @@ -719,7 +710,7 @@ static void cfq_pd_reset_stats(struct blkcg_gq *blkg)
>  
>  #else	/* CONFIG_CFQ_GROUP_IOSCHED */
>  
> -static inline struct cfq_group *cfqg_flat_parent(struct cfq_group *cfqg) { return NULL; }
> +static inline struct cfq_group *cfqg_parent(struct cfq_group *cfqg) { return NULL; }
>  static inline void cfqg_get(struct cfq_group *cfqg) { }
>  static inline void cfqg_put(struct cfq_group *cfqg) { }
>  
> @@ -1286,7 +1277,7 @@ cfq_group_service_tree_add(struct cfq_rb_root *st, struct cfq_group *cfqg)
>  	 * activated node is met.  vfraction calculation should always
>  	 * continue to the root.
>  	 */
> -	while ((parent = cfqg_flat_parent(pos))) {
> +	while ((parent = cfqg_parent(pos))) {
>  		if (propagate) {
>  			propagate = !parent->nr_active++;
>  			parent->level_weight += pos->weight;
> @@ -1337,7 +1328,7 @@ cfq_group_service_tree_del(struct cfq_rb_root *st, struct cfq_group *cfqg)
>  	pos->level_weight -= pos->leaf_weight;
>  
>  	while (propagate) {
> -		struct cfq_group *parent = cfqg_flat_parent(pos);
> +		struct cfq_group *parent = cfqg_parent(pos);
>  
>  		/* @pos has 0 nr_active at this point */
>  		WARN_ON_ONCE(pos->level_weight);
> -- 
> 1.7.11.7
