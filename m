Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757063Ab2CEWNa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 17:13:30 -0500
Received: from mail-pz0-f52.google.com ([209.85.210.52]:41819 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756678Ab2CEWNZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 17:13:25 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of htejun@gmail.com designates 10.68.191.168 as permitted sender) smtp.mail=htejun@gmail.com; dkim=pass header.i=htejun@gmail.com
Date: Mon, 5 Mar 2012 14:13:21 -0800
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: axboe@kernel.dk, hughd@google.com, avi@redhat.com, nate@cpanel.net,
        cl@linux-foundation.org, linux-kernel@vger.kernel.org,
        dpshah@google.com, ctalbott@google.com, rni@google.com,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCHSET] mempool, percpu, blkcg: fix percpu stat allocation
 and remove stats_lock
Message-ID: <20120305221321.GF1263@google.com>
References: <1330036246-21633-1-git-send-email-tj@kernel.org>
 <20120223144336.58742e1b.akpm@linux-foundation.org>
 <20120223230123.GL22536@google.com>
 <20120223231204.GM22536@google.com>
 <20120224142033.GA5095@redhat.com>
 <20120225214421.GA3401@dhcp-172-17-108-109.mtv.corp.google.com>
 <20120227031146.GA25187@redhat.com>
 <20120227091141.GG3401@dhcp-172-17-108-109.mtv.corp.google.com>
 <20120227194321.GF27677@redhat.com>
 <20120229173639.GB5930@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120229173639.GB5930@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Vivek.

On Wed, Feb 29, 2012 at 12:36:39PM -0500, Vivek Goyal wrote:
> Index: tejun-misc/block/blk-cgroup.h
> ===================================================================
> --- tejun-misc.orig/block/blk-cgroup.h	2012-02-28 01:29:09.238256494 -0500
> +++ tejun-misc/block/blk-cgroup.h	2012-02-28 01:29:12.000000000 -0500
> @@ -180,6 +180,8 @@ struct blkio_group {
>  	struct request_queue *q;
>  	struct list_head q_node;
>  	struct hlist_node blkcg_node;
> +	/* List of blkg waiting for per cpu stats memory to be allocated */
> +	struct list_head pending_alloc_node;

Can we move this right on top of rcu_head?  It's one of the coldest
entries.  Also, long field names tend to be a bit painful.  How about
just alloc_node?

> +static void blkio_stat_alloc_fn(struct work_struct *work)
> +{
> +
> +	void *stat_ptr = NULL;
> +	struct blkio_group *blkg, *n;
> +	int i;
> +
> +alloc_stats:
> +	spin_lock_irq(&pending_alloc_list_lock);
> +		if (list_empty(&pending_alloc_list)) {
> +			/* Nothing to do */
> +			spin_unlock_irq(&pending_alloc_list_lock);
> +			return;
> +		}
> +	spin_unlock_irq(&pending_alloc_list_lock);
> +
> +	WARN_ON(stat_ptr != NULL);
> +	stat_ptr = alloc_percpu(struct blkio_group_stats_cpu);

There will only one of this work item and if queued on nrt wq, only
one instance would be running.  Why not just create static ps[NR_POLS]
array and fill it here.

> +	/* Retry. Should there be an upper limit on number of retries */
> +	if (stat_ptr == NULL)
> +		goto alloc_stats;
> +
> +	spin_lock_irq(&blkio_list_lock);
> +	spin_lock(&pending_alloc_list_lock);
> +
> +	list_for_each_entry_safe(blkg, n, &pending_alloc_list,
> +		pending_alloc_node) {
> +		for (i = 0; i < BLKIO_NR_POLICIES; i++) {
> +			struct blkio_policy_type *pol = blkio_policy[i];
> +			struct blkg_policy_data *pd;
> +
> +			if (!pol)
> +				continue;
> +
> +			if (!blkg->pd[i])
> +				continue;
> +
> +			pd = blkg->pd[i];
> +			if (pd->stats_cpu)
> +				continue;
> +
> +			pd->stats_cpu = stat_ptr;
> +			stat_ptr = NULL;
> +			break;

and install everything here at one go.

> +		}
> +
> +		if (i == BLKIO_NR_POLICIES - 1) {
> +			/* We are done with this group */
> +			list_del_init(&blkg->pending_alloc_node);
> +			continue;
> +		} else
> +			/* Go allocate more memory */
> +			break;
> +	}

remove it from alloc list while holding alloc lock, unlock and go for
retrying or exit and don't worry about stats_cpu left in ps[] as we're
gonna be using that again later anyway.

>  	/* insert */
>  	spin_lock(&blkcg->lock);
> -	swap(blkg, new_blkg);
> +	spin_lock(&pending_alloc_list_lock);

Do we need this nested inside blkcg->lock?  What's wrong with doing it
after release blkcg->lock?

> @@ -648,11 +701,16 @@ static void blkg_destroy(struct blkio_gr
>  	lockdep_assert_held(q->queue_lock);
>  	lockdep_assert_held(&blkcg->lock);
>  
> +	spin_lock(&pending_alloc_list_lock);
> +
>  	/* Something wrong if we are trying to remove same group twice */
>  	WARN_ON_ONCE(list_empty(&blkg->q_node));
>  	WARN_ON_ONCE(hlist_unhashed(&blkg->blkcg_node));
>  	list_del_init(&blkg->q_node);
>  	hlist_del_init_rcu(&blkg->blkcg_node);
> +	list_del_init(&blkg->pending_alloc_node);
> +
> +	spin_unlock(&pending_alloc_list_lock);

Why put the whole thing inside the alloc lock?

Thanks.

-- 
tejun
