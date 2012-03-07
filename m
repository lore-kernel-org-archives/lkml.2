Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758896Ab2CGRFx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 12:05:53 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:34214 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758175Ab2CGRFu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 12:05:50 -0500
Date: Wed, 7 Mar 2012 09:05:44 -0800
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, axboe@kernel.dk,
        hughd@google.com, avi@redhat.com, nate@cpanel.net,
        cl@linux-foundation.org, linux-kernel@vger.kernel.org,
        dpshah@google.com, ctalbott@google.com, rni@google.com
Subject: Re: [PATCHSET] mempool, percpu, blkcg: fix percpu stat allocation
 and remove stats_lock
Message-ID: <20120307170544.GA30676@google.com>
References: <20120227031146.GA25187@redhat.com>
 <20120227091141.GG3401@dhcp-172-17-108-109.mtv.corp.google.com>
 <20120227194321.GF27677@redhat.com>
 <20120229173639.GB5930@redhat.com>
 <20120305221321.GF1263@google.com>
 <20120306210954.GF32148@redhat.com>
 <20120306132034.ecaf8b20.akpm@linux-foundation.org>
 <20120306213437.GG32148@redhat.com>
 <20120306135531.828ca78e.akpm@linux-foundation.org>
 <20120307145556.GA11262@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120307145556.GA11262@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 07, 2012 at 09:55:56AM -0500, Vivek Goyal wrote:
> +/*
> + * Worker for allocating per cpu stat for blk groups. This is scheduled
> + * once there are some groups on the alloc_list waiting for allocation
> + */
> +static void blkio_stat_alloc_fn(struct work_struct *work)
> +{
> +
> +	struct blkio_group *blkg, *n;
> +	int i;
> +
> +alloc_stats:
> +	spin_lock_irq(&alloc_list_lock);
> +		if (list_empty(&alloc_list)) {
> +			/* No more groups needing per cpu stat allocation */
> +			spin_unlock_irq(&alloc_list_lock);
> +			return;
> +		}
> +	spin_unlock_irq(&alloc_list_lock);

I don't think we really need the above.  Just proceed with allocation.

> +	for (i = 0; i < BLKIO_NR_POLICIES; i++) {
> +		if (pcpu_stats[i] != NULL)
> +			continue;
> +
> +		pcpu_stats[i] = alloc_percpu(struct blkio_group_stats_cpu);
> +		/* Allocatoin failed. Try again after some time. */
		          ^^ typo
> +		if (pcpu_stats[i] == NULL) {
> +			msleep(10);
> +			goto alloc_stats;
> +		}
> +	}

Why not queue_delayed_work(system_nrt_wq, work, msecs_to_jiffies(10))?
Why hog the worker thread?

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

I think this can be slightly more compact.  How about the following?

	struct blkg_policy_data *pd = blkg->pd[i];

	if (blkio_policy[i] && pd && !pd->stats_cpu)
		swap(pd->stats_cpu, pcpu_stats[i]);

> +		}
> +		list_del_init(&blkg->alloc_node);
> +		break;

If we're breaking after the first iteration, why are we using
list_for_each at all?

> +	}

and we can test whether we need to loop here, right?

Thanks.

-- 
tejun
