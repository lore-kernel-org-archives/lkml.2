Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758814Ab2HIVop (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 17:44:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37942 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757387Ab2HIVon (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 17:44:43 -0400
Date: Thu, 9 Aug 2012 23:44:30 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: mingo@kernel.org, riel@redhat.com, oleg@redhat.com, pjt@google.com,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        tglx@linutronix.de, Lee.Schermerhorn@hp.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 10/19] mm, mpol: Use special PROT_NONE to migrate pages
Message-ID: <20120809214430.GJ10459@redhat.com>
References: <20120731191204.540691987@chello.nl>
 <20120731192808.950441936@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120731192808.950441936@chello.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 31, 2012 at 09:12:14PM +0200, Peter Zijlstra wrote:
> +#ifdef CONFIG_NUMA
>  	/*
> -	 * Do fancy stuff...
> +	 * For NUMA systems we use the special PROT_NONE maps to drive
> +	 * lazy page migration, see MPOL_MF_LAZY and related.
>  	 */
> +	page = vm_normal_page(vma, address, entry);
> +	if (!page)
> +		goto do_fixup_locked;
> +
> +	get_page(page);
> +	pte_unmap_unlock(ptep, ptl);
> +
> +	node = mpol_misplaced(page, vma, address);
> +	if (node == -1)
> +		goto do_fixup;
>  
>  	/*
> +	 * Page migration will install a new pte with vma->vm_page_prot,
> +	 * otherwise fall-through to the fixup. Next time,.. perhaps.
> +	 */
> +	if (!migrate_misplaced_page(mm, page, node)) {
> +		put_page(page);
> +		return 0;
> +	}
> +
> +do_fixup:
> +	/*
>  	 * OK, nothing to do,.. change the protection back to what it
>  	 * ought to be.
>  	 */
> @@ -3467,6 +3493,9 @@ static int do_prot_none(struct mm_struct
>  	if (unlikely(!pte_same(*ptep, entry)))
>  		goto unlock;
>  
> +do_fixup_locked:
> +#endif /* CONFIG_NUMA */
> +

Do fancy stuff would better of be in a separate file instead of mixing
it with the numa hinting page fault entry points in memory.c. My
"fancy stuff" happens in mm/autonuma.c. memory.c calls it.

>  	flush_cache_page(vma, address, pte_pfn(entry));
>  
>  	ptep_modify_prot_start(mm, address, ptep);
> @@ -3476,8 +3505,9 @@ static int do_prot_none(struct mm_struct
>  	update_mmu_cache(vma, address, ptep);
>  unlock:
>  	pte_unmap_unlock(ptep, ptl);
> -out:
> -	return ret;
> +	if (page)
> +		put_page(page);
> +	return 0;
>  }
>  
>  /*
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
