Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752638Ab2GIIWJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 04:22:09 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44796 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752550Ab2GIIWG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 04:22:06 -0400
Date: Mon, 9 Jul 2012 09:22:00 +0100
From: Mel Gorman <mgorman@suse.de>
To: Minchan Kim <minchan@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH] mm: Warn about costly page allocation
Message-ID: <20120709082200.GX14154@suse.de>
References: <1341801500-5798-1-git-send-email-minchan@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1341801500-5798-1-git-send-email-minchan@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 09, 2012 at 11:38:20AM +0900, Minchan Kim wrote:
> Since lumpy reclaim was introduced at 2.6.23, it helped higher
> order allocation.
> Recently, we removed it at 3.4 and we didn't enable compaction
> forcingly[1]. The reason makes sense that compaction.o + migration.o
> isn't trivial for system doesn't use higher order allocation.
> But the problem is that we have to enable compaction explicitly
> while lumpy reclaim enabled unconditionally.
> 
> Normally, admin doesn't know his system have used higher order
> allocation and even lumpy reclaim have helped it.
> Admin in embdded system have a tendency to minimise code size so that
> they can disable compaction. In this case, we can see page allocation
> failure we can never see in the past. It's critical on embedded side
> because...
> 
> Let's think this scenario.
> 
> There is QA team in embedded company and they have tested their product.
> In test scenario, they can allocate 100 high order allocation.
> (they don't matter how many high order allocations in kernel are needed
> during test. their concern is just only working well or fail of their
> middleware/application) High order allocation will be serviced well
> by natural buddy allocation without lumpy's help. So they released
> the product and sold out all over the world.
> Unfortunately, in real practice, sometime, 105 high order allocation was
> needed rarely and fortunately, lumpy reclaim could help it so the product
> doesn't have a problem until now.
> 
> If they use latest kernel, they will see the new config CONFIG_COMPACTION
> which is very poor documentation, and they can't know it's replacement of
> lumpy reclaim(even, they don't know lumpy reclaim) so they simply disable

Depending on lumpy reclaim or compaction for high-order kernel allocations
is dangerous. Both depend on being able to move MIGRATE_MOVABLE allocations
to satisy the high-order allocation. If used regularly for high-order kernel
allocations and they are long-lived, the system will eventually be unable
to grant these allocations, with or without compaction or lumpy reclaim.

Be also aware that lumpy reclaim was very aggressive when reclaiming pages
to satisfy an allocation. Compaction is not and compaction can be temporarily
disabled if an allocation attempt fails. If lumpy reclaim was being depended
upon to satisfy high-order allocations, there is no guarantee, particularly
with 3.4, that compaction will succeed as it does not reclaim aggressively.

> that option for size optimization. Of course, QA team still test it but they
> can't find the problem if they don't do test stronger than old.
> It ends up release the product and sold out all over the world, again.
> But in this time, we don't have both lumpy and compaction so the problem
> would happen in real practice. A poor enginner from Korea have to flight
> to the USA for the fix a ton of products. Otherwise, should recall products
> from all over the world. Maybe he can lose a job. :(
> 
> This patch adds warning for notice. If the system try to allocate
> PAGE_ALLOC_COSTLY_ORDER above page and system enters reclaim path,
> it emits the warning. At least, it gives a chance to look into their
> system before the relase.
> 
> This patch avoids false positive by alloc_large_system_hash which
> allocates with GFP_ATOMIC and a fallback mechanism so it can make
> this warning useless.
> 
> [1] c53919ad(mm: vmscan: remove lumpy reclaim)
> 
> Signed-off-by: Minchan Kim <minchan@kernel.org>
> ---
>  mm/page_alloc.c |   16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index a4d3a19..1155e00 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -2276,6 +2276,20 @@ gfp_to_alloc_flags(gfp_t gfp_mask)
>  	return alloc_flags;
>  }
>  
> +#if defined(CONFIG_DEBUG_VM) && !defined(CONFIG_COMPACTION)
> +static inline void check_page_alloc_costly_order(unsigned int order)
> +{
> +	if (unlikely(order > PAGE_ALLOC_COSTLY_ORDER)) {
> +		printk_once("WARNING: You are tring to allocate %d-order page."
> +		" You might need to turn on CONFIG_COMPACTION\n", order);
> +	}

WARN_ON_ONCE would tell you what is trying to satisfy the allocation.

It should further check if this is a GFP_MOVABLE allocation or not and if
not, then it should either be documented that compaction may only delay
allocation failures and that they may need to consider reserving the memory
in advance or doing something like forcing MIGRATE_RESERVE to only be used
for high-order allocations.

> +}
> +#else
> +static inline void check_page_alloc_costly_order(unsigned int order)
> +{
> +}
> +#endif
> +
>  static inline struct page *
>  __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
>  	struct zonelist *zonelist, enum zone_type high_zoneidx,
> @@ -2353,6 +2367,8 @@ rebalance:
>  	if (!wait)
>  		goto nopage;
>  
> +	check_page_alloc_costly_order(order);
> +
>  	/* Avoid recursion of direct reclaim */
>  	if (current->flags & PF_MEMALLOC)
>  		goto nopage;
> -- 
> 1.7.9.5
> 

-- 
Mel Gorman
SUSE Labs
