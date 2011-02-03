Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753354Ab1BCVWe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 16:22:34 -0500
Received: from smtp-out.google.com ([216.239.44.51]:18396 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753262Ab1BCVWc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 16:22:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=Akiko+ZrpRzeowoO43hoRa251Y6JA5CnusCdtX4mY7/I6Fxnow+L+pVJ3SwrWbOlw9
         qlotaeimerVogvOaxGYw==
Date: Thu, 3 Feb 2011 13:22:26 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Dave Hansen <dave@linux.vnet.ibm.com>
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Michael J Wolf <mjwolf@us.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [RFC][PATCH 3/6] break out smaps_pte_entry() from
 smaps_pte_range()
In-Reply-To: <20110201003401.95CFBFA6@kernel>
Message-ID: <alpine.DEB.2.00.1102031315080.1307@chino.kir.corp.google.com>
References: <20110201003357.D6F0BE0D@kernel> <20110201003401.95CFBFA6@kernel>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 31 Jan 2011, Dave Hansen wrote:

> 
> We will use smaps_pte_entry() in a moment to handle both small
> and transparent large pages.  But, we must break it out of
> smaps_pte_range() first.
> 

The extraction from smaps_pte_range() looks good.  What's the performance 
impact on very frequent consumers of /proc/pid/smaps, though, as the 
result of the calls throughout the iteration if smaps_pte_entry() doesn't 
get inlined (supposedly because you'll be reusing the extracted function 
again elsewhere)?

> 
> ---
> 
>  linux-2.6.git-dave/fs/proc/task_mmu.c |   85 ++++++++++++++++++----------------
>  1 file changed, 46 insertions(+), 39 deletions(-)
> 
> diff -puN fs/proc/task_mmu.c~break-out-smaps_pte_entry fs/proc/task_mmu.c
> --- linux-2.6.git/fs/proc/task_mmu.c~break-out-smaps_pte_entry	2011-01-27 11:03:06.761548697 -0800
> +++ linux-2.6.git-dave/fs/proc/task_mmu.c	2011-01-27 11:03:06.773548685 -0800
> @@ -333,56 +333,63 @@ struct mem_size_stats {
>  	u64 pss;
>  };
>  
> -static int smaps_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
> -			   struct mm_walk *walk)
> +
> +static void smaps_pte_entry(pte_t ptent, unsigned long addr,
> +		struct mm_walk *walk)
>  {
>  	struct mem_size_stats *mss = walk->private;
>  	struct vm_area_struct *vma = mss->vma;
> -	pte_t *pte, ptent;
> -	spinlock_t *ptl;
>  	struct page *page;
>  	int mapcount;
>  
> -	split_huge_page_pmd(walk->mm, pmd);
> -
> -	pte = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
> -	for (; addr != end; pte++, addr += PAGE_SIZE) {
> -		ptent = *pte;
> +	if (is_swap_pte(ptent)) {
> +		mss->swap += PAGE_SIZE;
> +		return;
> +	}
>  
> -		if (is_swap_pte(ptent)) {
> -			mss->swap += PAGE_SIZE;
> -			continue;
> -		}
> +	if (!pte_present(ptent))
> +		return;
>  
> -		if (!pte_present(ptent))
> -			continue;
> +	page = vm_normal_page(vma, addr, ptent);
> +	if (!page)
> +		return;
> +
> +	if (PageAnon(page))
> +		mss->anonymous += PAGE_SIZE;
> +
> +	mss->resident += PAGE_SIZE;
> +	/* Accumulate the size in pages that have been accessed. */
> +	if (pte_young(ptent) || PageReferenced(page))
> +		mss->referenced += PAGE_SIZE;
> +	mapcount = page_mapcount(page);
> +	if (mapcount >= 2) {
> +		if (pte_dirty(ptent) || PageDirty(page))
> +			mss->shared_dirty += PAGE_SIZE;
> +		else
> +			mss->shared_clean += PAGE_SIZE;
> +		mss->pss += (PAGE_SIZE << PSS_SHIFT) / mapcount;
> +	} else {
> +		if (pte_dirty(ptent) || PageDirty(page))
> +			mss->private_dirty += PAGE_SIZE;
> +		else
> +			mss->private_clean += PAGE_SIZE;
> +		mss->pss += (PAGE_SIZE << PSS_SHIFT);
> +	}
> +}
>  
> -		page = vm_normal_page(vma, addr, ptent);
> -		if (!page)
> -			continue;
> +static int smaps_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
> +			   struct mm_walk *walk)
> +{
> +	struct mem_size_stats *mss = walk->private;
> +	struct vm_area_struct *vma = mss->vma;
> +	pte_t *pte;
> +	spinlock_t *ptl;
>  
> -		if (PageAnon(page))
> -			mss->anonymous += PAGE_SIZE;
> +	split_huge_page_pmd(walk->mm, pmd);
>  
> -		mss->resident += PAGE_SIZE;
> -		/* Accumulate the size in pages that have been accessed. */
> -		if (pte_young(ptent) || PageReferenced(page))
> -			mss->referenced += PAGE_SIZE;
> -		mapcount = page_mapcount(page);
> -		if (mapcount >= 2) {
> -			if (pte_dirty(ptent) || PageDirty(page))
> -				mss->shared_dirty += PAGE_SIZE;
> -			else
> -				mss->shared_clean += PAGE_SIZE;
> -			mss->pss += (PAGE_SIZE << PSS_SHIFT) / mapcount;
> -		} else {
> -			if (pte_dirty(ptent) || PageDirty(page))
> -				mss->private_dirty += PAGE_SIZE;
> -			else
> -				mss->private_clean += PAGE_SIZE;
> -			mss->pss += (PAGE_SIZE << PSS_SHIFT);
> -		}
> -	}
> +	pte = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
> +	for (; addr != end; pte++, addr += PAGE_SIZE)
> +		smaps_pte_entry(*pte, addr, walk);
>  	pte_unmap_unlock(pte - 1, ptl);
>  	cond_resched();
>  	return 0;
> diff -puN mm/huge_memory.c~break-out-smaps_pte_entry mm/huge_memory.c
> _

Is there a missing change to mm/huge_memory.c?
