Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759873Ab2CGTW3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 14:22:29 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:60160 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759853Ab2CGTWY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 14:22:24 -0500
Date: Wed, 7 Mar 2012 11:22:19 -0800
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, axboe@kernel.dk,
        hughd@google.com, avi@redhat.com, nate@cpanel.net,
        cl@linux-foundation.org, linux-kernel@vger.kernel.org,
        dpshah@google.com, ctalbott@google.com, rni@google.com
Subject: Re: [PATCHSET] mempool, percpu, blkcg: fix percpu stat allocation
 and remove stats_lock
Message-ID: <20120307192219.GC30676@google.com>
References: <20120227194321.GF27677@redhat.com>
 <20120229173639.GB5930@redhat.com>
 <20120305221321.GF1263@google.com>
 <20120306210954.GF32148@redhat.com>
 <20120306132034.ecaf8b20.akpm@linux-foundation.org>
 <20120306213437.GG32148@redhat.com>
 <20120306135531.828ca78e.akpm@linux-foundation.org>
 <20120307145556.GA11262@redhat.com>
 <20120307170544.GA30676@google.com>
 <20120307191334.GG13430@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120307191334.GG13430@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Vivek.

On Wed, Mar 07, 2012 at 02:13:34PM -0500, Vivek Goyal wrote:
> +static void blkio_stat_alloc_fn(struct work_struct *work)
> +{
> +
> +	struct delayed_work *dwork = to_delayed_work(work);
> +	struct blkio_group *blkg;
> +	int i;
> +	bool alloc_more = false;
> +
> +alloc_stats:
> +	for (i = 0; i < BLKIO_NR_POLICIES; i++) {
> +		if (pcpu_stats[i] != NULL)
> +			continue;
> +
> +		pcpu_stats[i] = alloc_percpu(struct blkio_group_stats_cpu);
> +
> +		/* Allocation failed. Try again after some time. */
> +		if (pcpu_stats[i] == NULL) {
> +			queue_delayed_work(system_nrt_wq, dwork,
> +						msecs_to_jiffies(10));
> +			return;
> +		}
> +	}
> +
> +	spin_lock_irq(&blkio_list_lock);
> +	spin_lock(&alloc_list_lock);
> +
> +	/* cgroup got deleted or queue exited. */
> +	if (list_empty(&alloc_list)) {
> +		alloc_more = false;
> +		goto unlock;
> +	}
> +
> +	blkg = list_first_entry(&alloc_list, struct blkio_group, alloc_node);
> +
> +	for (i = 0; i < BLKIO_NR_POLICIES; i++) {
> +		struct blkg_policy_data *pd = blkg->pd[i];
> +
> +		if (blkio_policy[i] && pd && !pd->stats_cpu)
> +			swap(pd->stats_cpu, pcpu_stats[i]);
> +	}
> +
> +	list_del_init(&blkg->alloc_node);
> +
> +	if (list_empty(&alloc_list))
> +		alloc_more = false;
> +	else
> +		alloc_more = true;

Sorry about being a pain in the ass for small stuff but how about the
following?

	lock_stuff()

	if (!list_empty()) {
		struct blkio_group *blkg = list_first_entry();

		for (i = 0; ..) {
			set stuff;
		}
		list_del_init();
	}
	empty = list_empty();

	unlock_stuff();

	if (!empty)
		goto repeat;

Thanks.

-- 
tejun
