Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753303Ab1BCVWb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 16:22:31 -0500
Received: from smtp-out.google.com ([216.239.44.51]:18356 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753022Ab1BCVW3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 16:22:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=d8mh5ElnLwJC++UMHcbJ9Ds/hAIoStq/rfrtAd0J7c8O+j8tOIwHud8hMibHsifUJd
         oHKZUqaVeIY/IzFEYdWg==
Date: Thu, 3 Feb 2011 13:22:21 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Dave Hansen <dave@linux.vnet.ibm.com>
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Michael J Wolf <mjwolf@us.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [RFC][PATCH 2/6] pagewalk: only split huge pages when
 necessary
In-Reply-To: <20110201003359.8DDFF665@kernel>
Message-ID: <alpine.DEB.2.00.1102031257490.948@chino.kir.corp.google.com>
References: <20110201003357.D6F0BE0D@kernel> <20110201003359.8DDFF665@kernel>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 31 Jan 2011, Dave Hansen wrote:

> 
> Right now, if a mm_walk has either ->pte_entry or ->pmd_entry
> set, it will unconditionally split and transparent huge pages
> it runs in to.  In practice, that means that anyone doing a
> 
> 	cat /proc/$pid/smaps
> 
> will unconditionally break down every huge page in the process
> and depend on khugepaged to re-collapse it later.  This is
> fairly suboptimal.
> 
> This patch changes that behavior.  It teaches each ->pmd_entry
> handler (there are three) that they must break down the THPs
> themselves.  Also, the _generic_ code will never break down
> a THP unless a ->pte_entry handler is actually set.
> 
> This means that the ->pmd_entry handlers can now choose to
> deal with THPs without breaking them down.
> 
> 

No sign-off (goes for patches 3 and 4, as well)?

> ---
> 
>  linux-2.6.git-dave/fs/proc/task_mmu.c |    6 ++++++
>  linux-2.6.git-dave/mm/pagewalk.c      |   24 ++++++++++++++++++++----
>  2 files changed, 26 insertions(+), 4 deletions(-)
> 
> diff -puN mm/pagewalk.c~pagewalk-dont-always-split-thp mm/pagewalk.c
> --- linux-2.6.git/mm/pagewalk.c~pagewalk-dont-always-split-thp	2011-01-27 10:57:02.309914973 -0800
> +++ linux-2.6.git-dave/mm/pagewalk.c	2011-01-27 10:57:02.317914965 -0800
> @@ -33,19 +33,35 @@ static int walk_pmd_range(pud_t *pud, un
>  
>  	pmd = pmd_offset(pud, addr);
>  	do {
> +	again:

checkpatch will warn about the indent.

>  		next = pmd_addr_end(addr, end);
> -		split_huge_page_pmd(walk->mm, pmd);
> -		if (pmd_none_or_clear_bad(pmd)) {
> +		if (pmd_none(*pmd)) {

Not sure why this has been changed from pmd_none_or_clear_bad(), that's 
been done even prior to THP.

>  			if (walk->pte_hole)
>  				err = walk->pte_hole(addr, next, walk);
>  			if (err)
>  				break;
>  			continue;
>  		}
> +		/*
> +		 * This implies that each ->pmd_entry() handler
> +		 * needs to know about pmd_trans_huge() pmds
> +		 */

Probably needs to be documented somewhere for users of pagewalk?

>  		if (walk->pmd_entry)
>  			err = walk->pmd_entry(pmd, addr, next, walk);
> -		if (!err && walk->pte_entry)
> -			err = walk_pte_range(pmd, addr, next, walk);
> +		if (err)
> +			break;
> +
> +		/*
> +		 * Check this here so we only break down trans_huge
> +		 * pages when we _need_ to
> +		 */
> +		if (!walk->pte_entry)
> +			continue;
> +
> +		split_huge_page_pmd(walk->mm, pmd);
> +		if (pmd_none_or_clear_bad(pmd))
> +			goto again;
> +		err = walk_pte_range(pmd, addr, next, walk);
>  		if (err)
>  			break;
>  	} while (pmd++, addr = next, addr != end);
> diff -puN fs/proc/task_mmu.c~pagewalk-dont-always-split-thp fs/proc/task_mmu.c
> --- linux-2.6.git/fs/proc/task_mmu.c~pagewalk-dont-always-split-thp	2011-01-27 10:57:02.313914969 -0800
> +++ linux-2.6.git-dave/fs/proc/task_mmu.c	2011-01-27 10:57:02.321914961 -0800
> @@ -343,6 +343,8 @@ static int smaps_pte_range(pmd_t *pmd, u
>  	struct page *page;
>  	int mapcount;
>  
> +	split_huge_page_pmd(walk->mm, pmd);
> +
>  	pte = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
>  	for (; addr != end; pte++, addr += PAGE_SIZE) {
>  		ptent = *pte;
> @@ -467,6 +469,8 @@ static int clear_refs_pte_range(pmd_t *p
>  	spinlock_t *ptl;
>  	struct page *page;
>  
> +	split_huge_page_pmd(walk->mm, pmd);
> +
>  	pte = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
>  	for (; addr != end; pte++, addr += PAGE_SIZE) {
>  		ptent = *pte;
> @@ -623,6 +627,8 @@ static int pagemap_pte_range(pmd_t *pmd,
>  	pte_t *pte;
>  	int err = 0;
>  
> +	split_huge_page_pmd(walk->mm, pmd);
> +
>  	/* find the first VMA at or above 'addr' */
>  	vma = find_vma(walk->mm, addr);
>  	for (; addr != end; addr += PAGE_SIZE) {
