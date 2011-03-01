Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757136Ab1CAT3p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 14:29:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49839 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756958Ab1CAT3o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 14:29:44 -0500
Date: Tue, 1 Mar 2011 14:29:37 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Justin TerAvest <teravest@google.com>
Cc: jaxboe@fusionio.com, ctalbott@google.com, mrubin@google.com,
        nauman@google.com, guijianfeng@cn.fujitsu.com, czoccolo@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cfq-iosched: Always provide group isolation.
Message-ID: <20110301192937.GC2539@redhat.com>
References: <1299006798-11769-1-git-send-email-teravest@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1299006798-11769-1-git-send-email-teravest@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 01, 2011 at 11:13:18AM -0800, Justin TerAvest wrote:
> Effectively, make group_isolation=1 the default and remove the tunable.
> The setting group_isolation=0 was because by default we idle on
> sync-noidle tree and on fast devices, this can be very harmful for
> throughput.
> 
> However, this problem can also be addressed by tuning slice_idle and
> possibly group_idle on faster storage devices.
> 
> This change simplifies the CFQ code by removing the feature entirely.

I have not come across anybody so far who wants to get isolation only
for sequential queues and not for random cfq queues, hence I think
it makes sense to remove this tunable to reduce the complexity.

Secondly, on faster devices if idling hurts, I think disabling idling
is the only solution and that will either reduce or wipe out any
service differentiation one was getting.

So I am fine with removing this tunable. Anyobdy else has got a use
case for this?

Jens, do we have to worry about ABI regarding this sysfs tunable?

Acked-by: Vivek Goyal <vgoyal@redhat.com>

Thanks
Vivek


> 
> Signed-off-by: Justin TerAvest <teravest@google.com>
> ---
>  Documentation/cgroups/blkio-controller.txt |   28 ---------------------
>  block/cfq-iosched.c                        |   37 +---------------------------
>  2 files changed, 1 insertions(+), 64 deletions(-)
> 
> diff --git a/Documentation/cgroups/blkio-controller.txt b/Documentation/cgroups/blkio-controller.txt
> index 4ed7b5c..d915c16 100644
> --- a/Documentation/cgroups/blkio-controller.txt
> +++ b/Documentation/cgroups/blkio-controller.txt
> @@ -343,34 +343,6 @@ Common files among various policies
>  
>  CFQ sysfs tunable
>  =================
> -/sys/block/<disk>/queue/iosched/group_isolation
> ------------------------------------------------
> -
> -If group_isolation=1, it provides stronger isolation between groups at the
> -expense of throughput. By default group_isolation is 0. In general that
> -means that if group_isolation=0, expect fairness for sequential workload
> -only. Set group_isolation=1 to see fairness for random IO workload also.
> -
> -Generally CFQ will put random seeky workload in sync-noidle category. CFQ
> -will disable idling on these queues and it does a collective idling on group
> -of such queues. Generally these are slow moving queues and if there is a
> -sync-noidle service tree in each group, that group gets exclusive access to
> -disk for certain period. That means it will bring the throughput down if
> -group does not have enough IO to drive deeper queue depths and utilize disk
> -capacity to the fullest in the slice allocated to it. But the flip side is
> -that even a random reader should get better latencies and overall throughput
> -if there are lots of sequential readers/sync-idle workload running in the
> -system.
> -
> -If group_isolation=0, then CFQ automatically moves all the random seeky queues
> -in the root group. That means there will be no service differentiation for
> -that kind of workload. This leads to better throughput as we do collective
> -idling on root sync-noidle tree.
> -
> -By default one should run with group_isolation=0. If that is not sufficient
> -and one wants stronger isolation between groups, then set group_isolation=1
> -but this will come at cost of reduced throughput.
> -
>  /sys/block/<disk>/queue/iosched/slice_idle
>  ------------------------------------------
>  On a faster hardware CFQ can be slow, especially with sequential workload.
> diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
> index 7be4c79..64feb6d 100644
> --- a/block/cfq-iosched.c
> +++ b/block/cfq-iosched.c
> @@ -146,7 +146,6 @@ struct cfq_queue {
>  	struct cfq_rb_root *service_tree;
>  	struct cfq_queue *new_cfqq;
>  	struct cfq_group *cfqg;
> -	struct cfq_group *orig_cfqg;
>  	/* Number of sectors dispatched from queue in single dispatch round */
>  	unsigned long nr_sectors;
>  };
> @@ -285,7 +284,6 @@ struct cfq_data {
>  	unsigned int cfq_slice_idle;
>  	unsigned int cfq_group_idle;
>  	unsigned int cfq_latency;
> -	unsigned int cfq_group_isolation;
>  
>  	unsigned int cic_index;
>  	struct list_head cic_list;
> @@ -1187,32 +1185,6 @@ static void cfq_service_tree_add(struct cfq_data *cfqd, struct cfq_queue *cfqq,
>  	int new_cfqq = 1;
>  	int group_changed = 0;
>  
> -#ifdef CONFIG_CFQ_GROUP_IOSCHED
> -	if (!cfqd->cfq_group_isolation
> -	    && cfqq_type(cfqq) == SYNC_NOIDLE_WORKLOAD
> -	    && cfqq->cfqg && cfqq->cfqg != &cfqd->root_group) {
> -		/* Move this cfq to root group */
> -		cfq_log_cfqq(cfqd, cfqq, "moving to root group");
> -		if (!RB_EMPTY_NODE(&cfqq->rb_node))
> -			cfq_group_service_tree_del(cfqd, cfqq->cfqg);
> -		cfqq->orig_cfqg = cfqq->cfqg;
> -		cfqq->cfqg = &cfqd->root_group;
> -		cfqd->root_group.ref++;
> -		group_changed = 1;
> -	} else if (!cfqd->cfq_group_isolation
> -		   && cfqq_type(cfqq) == SYNC_WORKLOAD && cfqq->orig_cfqg) {
> -		/* cfqq is sequential now needs to go to its original group */
> -		BUG_ON(cfqq->cfqg != &cfqd->root_group);
> -		if (!RB_EMPTY_NODE(&cfqq->rb_node))
> -			cfq_group_service_tree_del(cfqd, cfqq->cfqg);
> -		cfq_put_cfqg(cfqq->cfqg);
> -		cfqq->cfqg = cfqq->orig_cfqg;
> -		cfqq->orig_cfqg = NULL;
> -		group_changed = 1;
> -		cfq_log_cfqq(cfqd, cfqq, "moved to origin group");
> -	}
> -#endif
> -
>  	service_tree = service_tree_for(cfqq->cfqg, cfqq_prio(cfqq),
>  						cfqq_type(cfqq));
>  	if (cfq_class_idle(cfqq)) {
> @@ -2542,7 +2514,7 @@ static int cfq_dispatch_requests(struct request_queue *q, int force)
>  static void cfq_put_queue(struct cfq_queue *cfqq)
>  {
>  	struct cfq_data *cfqd = cfqq->cfqd;
> -	struct cfq_group *cfqg, *orig_cfqg;
> +	struct cfq_group *cfqg;
>  
>  	BUG_ON(cfqq->ref <= 0);
>  
> @@ -2554,7 +2526,6 @@ static void cfq_put_queue(struct cfq_queue *cfqq)
>  	BUG_ON(rb_first(&cfqq->sort_list));
>  	BUG_ON(cfqq->allocated[READ] + cfqq->allocated[WRITE]);
>  	cfqg = cfqq->cfqg;
> -	orig_cfqg = cfqq->orig_cfqg;
>  
>  	if (unlikely(cfqd->active_queue == cfqq)) {
>  		__cfq_slice_expired(cfqd, cfqq, 0);
> @@ -2564,8 +2535,6 @@ static void cfq_put_queue(struct cfq_queue *cfqq)
>  	BUG_ON(cfq_cfqq_on_rr(cfqq));
>  	kmem_cache_free(cfq_pool, cfqq);
>  	cfq_put_cfqg(cfqg);
> -	if (orig_cfqg)
> -		cfq_put_cfqg(orig_cfqg);
>  }
>  
>  /*
> @@ -3953,7 +3922,6 @@ static void *cfq_init_queue(struct request_queue *q)
>  	cfqd->cfq_slice_idle = cfq_slice_idle;
>  	cfqd->cfq_group_idle = cfq_group_idle;
>  	cfqd->cfq_latency = 1;
> -	cfqd->cfq_group_isolation = 0;
>  	cfqd->hw_tag = -1;
>  	/*
>  	 * we optimistically start assuming sync ops weren't delayed in last
> @@ -4029,7 +3997,6 @@ SHOW_FUNCTION(cfq_slice_sync_show, cfqd->cfq_slice[1], 1);
>  SHOW_FUNCTION(cfq_slice_async_show, cfqd->cfq_slice[0], 1);
>  SHOW_FUNCTION(cfq_slice_async_rq_show, cfqd->cfq_slice_async_rq, 0);
>  SHOW_FUNCTION(cfq_low_latency_show, cfqd->cfq_latency, 0);
> -SHOW_FUNCTION(cfq_group_isolation_show, cfqd->cfq_group_isolation, 0);
>  #undef SHOW_FUNCTION
>  
>  #define STORE_FUNCTION(__FUNC, __PTR, MIN, MAX, __CONV)			\
> @@ -4063,7 +4030,6 @@ STORE_FUNCTION(cfq_slice_async_store, &cfqd->cfq_slice[0], 1, UINT_MAX, 1);
>  STORE_FUNCTION(cfq_slice_async_rq_store, &cfqd->cfq_slice_async_rq, 1,
>  		UINT_MAX, 0);
>  STORE_FUNCTION(cfq_low_latency_store, &cfqd->cfq_latency, 0, 1, 0);
> -STORE_FUNCTION(cfq_group_isolation_store, &cfqd->cfq_group_isolation, 0, 1, 0);
>  #undef STORE_FUNCTION
>  
>  #define CFQ_ATTR(name) \
> @@ -4081,7 +4047,6 @@ static struct elv_fs_entry cfq_attrs[] = {
>  	CFQ_ATTR(slice_idle),
>  	CFQ_ATTR(group_idle),
>  	CFQ_ATTR(low_latency),
> -	CFQ_ATTR(group_isolation),
>  	__ATTR_NULL
>  };
>  
> -- 
> 1.7.3.1
