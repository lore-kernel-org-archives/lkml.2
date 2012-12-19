Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752154Ab2LSHnP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 02:43:15 -0500
Received: from mail-pb0-f49.google.com ([209.85.160.49]:63883 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751544Ab2LSHnJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 02:43:09 -0500
Subject: Re: [patch 7/7] mm: reduce rmap overhead for ex-KSM page copies
 created on swap faults
From: Simon Jeons <simon.jeons@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
        Michal Hocko <mhocko@suse.cz>, Mel Gorman <mgorman@suse.de>,
        Hugh Dickins <hughd@google.com>, Satoru Moriya <satoru.moriya@hds.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
In-Reply-To: <1355767957-4913-8-git-send-email-hannes@cmpxchg.org>
References: <1355767957-4913-1-git-send-email-hannes@cmpxchg.org>
	 <1355767957-4913-8-git-send-email-hannes@cmpxchg.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 19 Dec 2012 02:01:19 -0500
Message-ID: <1355900479.1381.1.camel@kernel-VirtualBox>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-12-17 at 13:12 -0500, Johannes Weiner wrote:
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

Is it just a code cleanup instead of reduce rmap overhead?

> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> Reviewed-by: Rik van Riel <riel@redhat.com>
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


