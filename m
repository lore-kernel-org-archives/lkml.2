Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751713Ab1LSPsY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 10:48:24 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:35045 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750901Ab1LSPsW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 10:48:22 -0500
Date: Mon, 19 Dec 2011 16:48:17 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Michal Hocko <mhocko@suse.cz>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, Ying Han <yinghan@google.com>
Subject: Re: [PATCH 4/4] memcg: simplify LRU handling by new rule
Message-ID: <20111219154817.GD1415@cmpxchg.org>
References: <20111214164734.4d7d6d97.kamezawa.hiroyu@jp.fujitsu.com>
 <20111214165226.1c3b666e.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111214165226.1c3b666e.kamezawa.hiroyu@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 14, 2011 at 04:52:26PM +0900, KAMEZAWA Hiroyuki wrote:
> From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 
> Now, at LRU handling, memory cgroup needs to do complicated works
> to see valid pc->mem_cgroup, which may be overwritten.
> 
> This patch is for relaxing the protocol. This patch guarantees
>    - when pc->mem_cgroup is overwritten, page must not be on LRU.
> 
> By this, LRU routine can believe pc->mem_cgroup and don't need to
> check bits on pc->flags. This new rule may adds small overheads to
> swapin. But in most case, lru handling gets faster.
> 
> After this patch, PCG_ACCT_LRU bit is obsolete and removed.
> 
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>
> ---
>  include/linux/page_cgroup.h |    8 -----
>  mm/memcontrol.c             |   72 ++++++++++--------------------------------
>  2 files changed, 17 insertions(+), 63 deletions(-)

This, too, speaks for itself and the logic seems sound to me.

Acked-by: Johannes Weiner <hannes@cmpxchg.org>

Minor style things:

> @@ -974,30 +974,8 @@ struct lruvec *mem_cgroup_lru_add_list(struct zone *zone, struct page *page,
>  		return &zone->lruvec;
>  
>  	pc = lookup_page_cgroup(page);
> -	VM_BUG_ON(PageCgroupAcctLRU(pc));
> -	/*
> -	 * putback:				charge:
> -	 * SetPageLRU				SetPageCgroupUsed
> -	 * smp_mb				smp_mb
> -	 * PageCgroupUsed && add to memcg LRU	PageLRU && add to memcg LRU
> -	 *
> -	 * Ensure that one of the two sides adds the page to the memcg
> -	 * LRU during a race.
> -	 */
> -	smp_mb();
> -	/*
> -	 * If the page is uncharged, it may be freed soon, but it
> -	 * could also be swap cache (readahead, swapoff) that needs to
> -	 * be reclaimable in the future.  root_mem_cgroup will babysit
> -	 * it for the time being.
> -	 */
> -	if (PageCgroupUsed(pc)) {
> -		/* Ensure pc->mem_cgroup is visible after reading PCG_USED. */
> -		smp_rmb();
> -		memcg = pc->mem_cgroup;
> -		SetPageCgroupAcctLRU(pc);
> -	} else
> -		memcg = root_mem_cgroup;
> +	memcg = pc->mem_cgroup;
> +	VM_BUG_ON(!memcg);
>  	mz = page_cgroup_zoneinfo(memcg, page);

I think the memcg local variable is not really needed anymore.

Also, please don't add bug-ons for simple NULL tests, they are
redundant when the dereference would blow up just as well.

> @@ -2399,6 +2368,8 @@ void mem_cgroup_split_huge_fixup(struct page *head)
>  {
>  	struct page_cgroup *head_pc = lookup_page_cgroup(head);
>  	struct page_cgroup *pc;
> +	struct mem_cgroup_per_zone *mz;
> +	enum lru_list lru;
>  	int i;

You broke the reverse christmas tree sorting!
