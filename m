Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755143Ab2CFVUh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 16:20:37 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:42499 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752802Ab2CFVUg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 16:20:36 -0500
Date: Tue, 6 Mar 2012 13:20:34 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, axboe@kernel.dk, hughd@google.com,
        avi@redhat.com, nate@cpanel.net, cl@linux-foundation.org,
        linux-kernel@vger.kernel.org, dpshah@google.com, ctalbott@google.com,
        rni@google.com
Subject: Re: [PATCHSET] mempool, percpu, blkcg: fix percpu stat allocation
 and remove stats_lock
Message-Id: <20120306132034.ecaf8b20.akpm@linux-foundation.org>
In-Reply-To: <20120306210954.GF32148@redhat.com>
References: <20120223144336.58742e1b.akpm@linux-foundation.org>
	<20120223230123.GL22536@google.com>
	<20120223231204.GM22536@google.com>
	<20120224142033.GA5095@redhat.com>
	<20120225214421.GA3401@dhcp-172-17-108-109.mtv.corp.google.com>
	<20120227031146.GA25187@redhat.com>
	<20120227091141.GG3401@dhcp-172-17-108-109.mtv.corp.google.com>
	<20120227194321.GF27677@redhat.com>
	<20120229173639.GB5930@redhat.com>
	<20120305221321.GF1263@google.com>
	<20120306210954.GF32148@redhat.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Mar 2012 16:09:55 -0500
Vivek Goyal <vgoyal@redhat.com> wrote:

>
> ...
>
> blk-cgroup: Alloc per cpu stats from worker thread in a delayed manner
> 
> Current per cpu stat allocation assumes GFP_KERNEL allocation flag. But in
> IO path there are times when we want GFP_NOIO semantics. As there is no
> way to pass the allocation flags to alloc_percpu(), this patch delays the
> allocation of stats using a worker thread.
> 
> v2-> tejun suggested following changes. Changed the patch accordingly.
> 	- move alloc_node location in structure
> 	- reduce the size of names of some of the fields
> 	- Reduce the scope of locking of alloc_list_lock
> 	- Simplified stat_alloc_fn() by allocating stats for all
> 	  policies in one go and then assigning these to a group.

<takes a look to see if he can understand some block stuff>

<decides he can't>

>
> ...
>
> @@ -30,6 +30,15 @@ static LIST_HEAD(blkio_list);
>  static DEFINE_MUTEX(all_q_mutex);
>  static LIST_HEAD(all_q_list);
>  
> +/* List of groups pending per cpu stats allocation */
> +static DEFINE_SPINLOCK(alloc_list_lock);
> +static LIST_HEAD(alloc_list);
> +
> +/* Array of per cpu stat pointers allocated for blk groups */
> +static void *pcpu_stats[BLKIO_NR_POLICIES];
> +static void blkio_stat_alloc_fn(struct work_struct *);
> +static DECLARE_WORK(blkio_stat_alloc_work, blkio_stat_alloc_fn);
> +
>  struct blkio_cgroup blkio_root_cgroup = { .weight = 2*BLKIO_WEIGHT_DEFAULT };
>  EXPORT_SYMBOL_GPL(blkio_root_cgroup);
>  
> @@ -391,6 +400,9 @@ void blkiocg_update_dispatch_stats(struc
>  	struct blkio_group_stats_cpu *stats_cpu;
>  	unsigned long flags;
>  
> +	if (pd->stats_cpu == NULL)
> +		return;

Maybe add a comment explaining how this comes about?  It isn't very
obvious..

>  	/*
>  	 * Disabling interrupts to provide mutual exclusion between two
>  	 * writes on same cpu. It probably is not needed for 64bit. Not
> @@ -443,6 +455,9 @@ void blkiocg_update_io_merged_stats(stru
>  	struct blkio_group_stats_cpu *stats_cpu;
>  	unsigned long flags;
>  
> +	if (pd->stats_cpu == NULL)
> +		return;
> +
>  	/*
>  	 * Disabling interrupts to provide mutual exclusion between two
>  	 * writes on same cpu. It probably is not needed for 64bit. Not
> @@ -460,6 +475,59 @@ void blkiocg_update_io_merged_stats(stru
>  }
>  EXPORT_SYMBOL_GPL(blkiocg_update_io_merged_stats);
>  
> +static void blkio_stat_alloc_fn(struct work_struct *work)
> +{
> +
> +	struct blkio_group *blkg, *n;
> +	int i;
> +
> +alloc_stats:
> +	spin_lock_irq(&alloc_list_lock);
> +		if (list_empty(&alloc_list)) {
> +			/* Nothing to do */

That's not a very helpful comment, given that we weren't told what the
function is supposed to do in the first place.

> +			spin_unlock_irq(&alloc_list_lock);
> +			return;
> +		}
> +	spin_unlock_irq(&alloc_list_lock);

Interesting code layout - I rather like it!

> +	for (i = 0; i < BLKIO_NR_POLICIES; i++) {
> +		if (pcpu_stats[i] != NULL)
> +			continue;
> +
> +		pcpu_stats[i] = alloc_percpu(struct blkio_group_stats_cpu);
> +		if (pcpu_stats[i] == NULL)
> +			goto alloc_stats;

hoo boy that looks like an infinite loop.  What's going on here?

> +	}
> +
> +	spin_lock_irq(&blkio_list_lock);
> +	spin_lock(&alloc_list_lock);
> +
> +	list_for_each_entry_safe(blkg, n, &alloc_list, alloc_node) {
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
> +			pd->stats_cpu = pcpu_stats[i];
> +			pcpu_stats[i] = NULL;
> +		}
> +		list_del_init(&blkg->alloc_node);
> +		break;
> +	}
> +	spin_unlock(&alloc_list_lock);
> +	spin_unlock_irq(&blkio_list_lock);
> +	goto alloc_stats;
> +}

So the function runs until alloc_list is empty.  Very mysterious.

>
> ...
>

