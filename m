Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754184Ab1BJCKA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 21:10:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:64719 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753618Ab1BJCJ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 21:09:59 -0500
Date: Wed, 9 Feb 2011 21:09:47 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Chad Talbott <ctalbott@google.com>
Cc: jaxboe@fusionio.com, guijianfeng@cn.fujitsu.com, mrubin@google.com,
        teravest@google.com, jmoyer@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Avoid preferential treatment of groups that aren't
 backlogged
Message-ID: <20110210020946.GA27040@redhat.com>
References: <20110210013211.21573.69260.stgit@neat.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110210013211.21573.69260.stgit@neat.mtv.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 09, 2011 at 05:32:11PM -0800, Chad Talbott wrote:
> Problem: If a group isn't backlogged, we remove it from the service
> tree. When it becomes active again, it gets the minimum vtime of the
> tree. That is true even when the group was idle for a very small time,
> and it consumed some IO time right before it became idle.  If group
> has small weight, it can end up using more disk time than its fair
> share.
> 

Hi Chad,

In upstream code once a group gets backlogged we put it at the end 
and not at the beginning of the tree. (I am wondering are you looking
at the google internal code :-))

So I don't think that issue of a low weight group getting more disk
time than its fair share is present in upstream kernels.

cfq_group_service_tree_add() {
        /*
         * Currently put the group at the end. Later implement something
         * so that groups get lesser vtime based on their weights, so that
         * if group does not loose all if it was not continously
         * backlogged.
         */
        n = rb_last(&st->rb);
        if (n) {
                __cfqg = rb_entry_cfqg(n);
                cfqg->vdisktime = __cfqg->vdisktime + CFQ_IDLE_DELAY;
        } else
                cfqg->vdisktime = st->min_vdisktime;
}

Thanks
Vivek

> Solution: We solve the problem by assigning the group its old vtime if
> it has not been idle long enough. Otherise we assign it the service
> tree's min vtime.
> 
> Complications: When an entire service tree becomes completely idle, we
> lose the vtime state. All the old vtime values are not relevant any
> more. For example, consider the case when the service tree is idle and
> a brand new group sends IO. That group would have an old vtime value
> of zero, but the service tree's vtime would become closer to zero. In
> such a case, it would be unfair for the older groups to get a much
> higher old vtime stored in them.
> 
> We solve that issue by keeping a generation number that counts the
> number of instances when the service tree becomes completely
> empty. The generation number is stored in each group too. If a group
> becomes backlogged after a service tree has been empty, we compare its
> stored generation number with the current service tree generation
> number, and discard the old vtime if the group generation number is
> stale.
> 
> The preemption specific code is taken care of automatically because we
> allow preemption checks after inserting a group back into the service
> tree and assigning it an appropriate vtime.
> 
> Signed-off-by: Chad Talbott <ctalbott@google.com>
> ---
>  block/cfq-iosched.c |   24 +++++++++++++-----------
>  1 files changed, 13 insertions(+), 11 deletions(-)
> 
> diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
> index 501ffdf..f09f3fe 100644
> --- a/block/cfq-iosched.c
> +++ b/block/cfq-iosched.c
> @@ -178,6 +178,7 @@ struct cfq_group {
>  
>  	/* group service_tree key */
>  	u64 vdisktime;
> +	u64 generation_num;
>  	unsigned int weight;
>  
>  	/* number of cfqq currently on this group */
> @@ -300,6 +301,9 @@ struct cfq_data {
>  	/* List of cfq groups being managed on this device*/
>  	struct hlist_head cfqg_list;
>  	struct rcu_head rcu;
> +
> +	/* Generation number, counts service tree empty events */
> +	u64 active_generation;
>  };
>  
>  static struct cfq_group *cfq_get_next_cfqg(struct cfq_data *cfqd);
> @@ -873,18 +877,13 @@ cfq_group_service_tree_add(struct cfq_data *cfqd, struct cfq_group *cfqg)
>  	if (!RB_EMPTY_NODE(&cfqg->rb_node))
>  		return;
>  
> -	/*
> -	 * Currently put the group at the end. Later implement something
> -	 * so that groups get lesser vtime based on their weights, so that
> -	 * if group does not loose all if it was not continously backlogged.
> -	 */
> -	n = rb_last(&st->rb);
> -	if (n) {
> -		__cfqg = rb_entry_cfqg(n);
> -		cfqg->vdisktime = __cfqg->vdisktime + CFQ_IDLE_DELAY;
> -	} else
> +	if (cfqd->active_generation > cfqg->generation_num)
>  		cfqg->vdisktime = st->min_vdisktime;
> -
> +	else
> +		/* We assume that vdisktime was not modified when the task
> +		   was off the service tree.
> +		 */
> +		cfqg->vdisktime = max(st->min_vdisktime, cfqg->vdisktime);
>  	__cfq_group_service_tree_add(st, cfqg);
>  	st->total_weight += cfqg->weight;
>  }
> @@ -906,6 +905,9 @@ cfq_group_service_tree_del(struct cfq_data *cfqd, struct cfq_group *cfqg)
>  	if (!RB_EMPTY_NODE(&cfqg->rb_node))
>  		cfq_rb_erase(&cfqg->rb_node, st);
>  	cfqg->saved_workload_slice = 0;
> +	cfqg->generation_num = cfqd->active_generation;
> +	if (RB_EMPTY_ROOT(&st->rb))
> +		cfqd->active_generation++;
>  	cfq_blkiocg_update_dequeue_stats(&cfqg->blkg, 1);
>  }
>  
