Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754087Ab2BUKSp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 05:18:45 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:41804 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752285Ab2BUKSn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 05:18:43 -0500
Date: Tue, 21 Feb 2012 11:18:26 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] memcg: rework inactive_ratio logic
Message-ID: <20120221101825.GA1676@cmpxchg.org>
References: <20120215162442.13588.21790.stgit@zurg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120215162442.13588.21790.stgit@zurg>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 15, 2012 at 08:24:42PM +0400, Konstantin Khlebnikov wrote:
> This patch adds mem_cgroup->inactive_ratio calculated from hierarchical memory limit.
> It updated at each limit change before shrinking cgroup to this new limit.
> Ratios for all child cgroups are updated too, because parent limit can affect them.
> Update precedure can be greatly optimized if its performance becomes the problem.
> Inactive ratio for unlimited or huge limit does not matter, because we'll never hit it.
> 
> At global reclaim always use global ratio from zone->inactive_ratio.
> At mem-cgroup reclaim use inactive_ratio from target memory cgroup,
> this is cgroup which hit its limit and cause this reclaimer invocation.
> 
> Thus, global memory reclaimer will try to keep ratio for all lru lists in zone
> above one mark, this guarantee that total ratio in this zone will be above too.
> Meanwhile mem-cgroup will do the same thing for its lru lists in all zones, and
> for all lru lists in all sub-cgroups in hierarchy.
> 
> Also this patch removes some redundant code.
> 
> Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
> ---
>  include/linux/memcontrol.h |   16 ++------
>  mm/memcontrol.c            |   85 ++++++++++++++++++++++++--------------------
>  mm/vmscan.c                |   82 +++++++++++++++++++++++-------------------
>  3 files changed, 93 insertions(+), 90 deletions(-)

> @@ -3373,6 +3341,32 @@ void mem_cgroup_print_bad_page(struct page *page)
>  
>  static DEFINE_MUTEX(set_limit_mutex);
>  
> +/*
> + * Update inactive_ratio accoring to new memory limit
> + */
> +static void mem_cgroup_update_inactive_ratio(struct mem_cgroup *memcg,
> +					     unsigned long long target)
> +{
> +	unsigned long long mem_limit, memsw_limit, gb;
> +	struct mem_cgroup *iter;
> +
> +	for_each_mem_cgroup_tree(iter, memcg) {
> +		memcg_get_hierarchical_limit(iter, &mem_limit, &memsw_limit);
> +		mem_limit = min(mem_limit, target);
> +
> +		gb = mem_limit >> 30;
> +		if (gb && 10 * gb < INT_MAX)
> +			iter->inactive_ratio = int_sqrt(10 * gb);
> +		else
> +			iter->inactive_ratio = 1;
> +	}
> +}

The memcg could have two pages on one zone and a gazillion pages on
another zone.  Why would you want to enforce the same ratios on both
LRU list pairs?

> @@ -1818,29 +1809,33 @@ static int inactive_anon_is_low(struct mem_cgroup_zone *mz)
>  	if (!total_swap_pages)
>  		return 0;
>  
> -	if (!scanning_global_lru(mz))
> -		return mem_cgroup_inactive_anon_is_low(mz->mem_cgroup,
> -						       mz->zone);
> +	if (global_reclaim(sc))
> +		ratio = mz->zone->inactive_ratio;
> +	else
> +		ratio = mem_cgroup_inactive_ratio(sc->target_mem_cgroup);

I don't think we should take the zone ratio when we then proceed to
scan a bunch of LRU lists that could individually be much smaller than
the zone.  Especially since the ratio function is not a linear one.

Otherwise the target ratios can be way too big for small lists, see
the comment above mm/page_alloc.c::calculate_zone_inactive_ratio().

Consequently, I also disagree on using sc->target_mem_cgroup.

This whole mechanism is about balancing one specific pair of inactive
vs. an active list according their size.  We shouldn't derive policy
from numbers that are not correlated to this size.
