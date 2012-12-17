Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753417Ab2LQWtA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 17:49:00 -0500
Received: from mail-da0-f53.google.com ([209.85.210.53]:39471 "EHLO
	mail-da0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752701Ab2LQWs6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 17:48:58 -0500
X-Greylist: delayed 394 seconds by postgrey-1.27 at vger.kernel.org; Mon, 17 Dec 2012 17:48:58 EST
Date: Mon, 17 Dec 2012 14:42:26 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Johannes Weiner <hannes@cmpxchg.org>
cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
        Michal Hocko <mhocko@suse.cz>, Mel Gorman <mgorman@suse.de>,
        Satoru Moriya <satoru.moriya@hds.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 7/7] mm: reduce rmap overhead for ex-KSM page copies
 created on swap faults
In-Reply-To: <1355767957-4913-8-git-send-email-hannes@cmpxchg.org>
Message-ID: <alpine.LNX.2.00.1212171430130.25950@eggly.anvils>
References: <1355767957-4913-1-git-send-email-hannes@cmpxchg.org> <1355767957-4913-8-git-send-email-hannes@cmpxchg.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Dec 2012, Johannes Weiner wrote:

> When ex-KSM pages are faulted from swap cache, the fault handler is
> not capable of re-establishing anon_vma-spanning KSM pages.  In this
> case, a copy of the page is created instead, just like during a COW
> break.
> 
> These freshly made copies are known to be exclusive to the faulting
> VMA and there is no reason to go look for this page in parent and
> sibling processes during rmap operations.
> 
> Use page_add_new_anon_rmap() for these copies.  This also puts them on
> the proper LRU lists and marks them SwapBacked, so we can get rid of
> doing this ad-hoc in the KSM copy code.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> Reviewed-by: Rik van Riel <riel@redhat.com>

Yes, that's good, thanks Hannes:
Acked-by: Hugh Dickins <hughd@google.com>

> ---
>  mm/ksm.c    | 6 ------
>  mm/memory.c | 5 ++++-
>  2 files changed, 4 insertions(+), 7 deletions(-)
> 
> diff --git a/mm/ksm.c b/mm/ksm.c
> index 382d930..7275c74 100644
> --- a/mm/ksm.c
> +++ b/mm/ksm.c
> @@ -1590,13 +1590,7 @@ struct page *ksm_does_need_to_copy(struct page *page,
>  
>  		SetPageDirty(new_page);
>  		__SetPageUptodate(new_page);
> -		SetPageSwapBacked(new_page);
>  		__set_page_locked(new_page);
> -
> -		if (!mlocked_vma_newpage(vma, new_page))
> -			lru_cache_add_lru(new_page, LRU_ACTIVE_ANON);
> -		else
> -			add_page_to_unevictable_list(new_page);
>  	}
>  
>  	return new_page;
> diff --git a/mm/memory.c b/mm/memory.c
> index db2e9e7..7e17eb0 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -3020,7 +3020,10 @@ static int do_swap_page(struct mm_struct *mm, struct vm_area_struct *vma,
>  	}
>  	flush_icache_page(vma, page);
>  	set_pte_at(mm, address, page_table, pte);
> -	do_page_add_anon_rmap(page, vma, address, exclusive);
> +	if (swapcache) /* ksm created a completely new copy */
> +		page_add_new_anon_rmap(page, vma, address);
> +	else
> +		do_page_add_anon_rmap(page, vma, address, exclusive);
>  	/* It's better to call commit-charge after rmap is established */
>  	mem_cgroup_commit_charge_swapin(page, ptr);
>  
> -- 
> 1.7.11.7
