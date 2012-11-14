Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423574Ab2KNX2S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 18:28:18 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:43343 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423519Ab2KNX2R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 18:28:17 -0500
Date: Wed, 14 Nov 2012 15:28:15 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>, linux-mm@kvack.org,
        Andi Kleen <ak@linux.intel.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>, linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: Re: [PATCH v5 07/11] thp: implement splitting pmd for huge zero
 page
In-Reply-To: <1352300463-12627-8-git-send-email-kirill.shutemov@linux.intel.com>
Message-ID: <alpine.DEB.2.00.1211141524010.22537@chino.kir.corp.google.com>
References: <1352300463-12627-1-git-send-email-kirill.shutemov@linux.intel.com> <1352300463-12627-8-git-send-email-kirill.shutemov@linux.intel.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Nov 2012, Kirill A. Shutemov wrote:

> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 90e651c..f36bc7d 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -1611,6 +1611,7 @@ int split_huge_page(struct page *page)
>  	struct anon_vma *anon_vma;
>  	int ret = 1;
>  
> +	BUG_ON(is_huge_zero_pfn(page_to_pfn(page)));
>  	BUG_ON(!PageAnon(page));
>  	anon_vma = page_lock_anon_vma(page);
>  	if (!anon_vma)
> @@ -2509,23 +2510,63 @@ static int khugepaged(void *none)
>  	return 0;
>  }
>  
> +static void __split_huge_zero_page_pmd(struct vm_area_struct *vma,
> +		unsigned long haddr, pmd_t *pmd)
> +{

This entire function duplicates other code in mm/huge_memory.c which gives 
even more incentive into breaking do_huge_pmd_wp_zero_page_fallback() into 
logical helper functions and reusing them for both page and !page.  
Duplicating all this code throughout the thp code just becomes a 
maintenance nightmare down the road.

> +	pgtable_t pgtable;
> +	pmd_t _pmd;
> +	int i;
> +
> +	pmdp_clear_flush(vma, haddr, pmd);
> +	/* leave pmd empty until pte is filled */
> +
> +	pgtable = get_pmd_huge_pte(vma->vm_mm);
> +	pmd_populate(vma->vm_mm, &_pmd, pgtable);
> +
> +	for (i = 0; i < HPAGE_PMD_NR; i++, haddr += PAGE_SIZE) {
> +		pte_t *pte, entry;
> +		entry = pfn_pte(my_zero_pfn(haddr), vma->vm_page_prot);
> +		entry = pte_mkspecial(entry);
> +		pte = pte_offset_map(&_pmd, haddr);
> +		VM_BUG_ON(!pte_none(*pte));
> +		set_pte_at(vma->vm_mm, haddr, pte, entry);
> +		pte_unmap(pte);
> +	}
> +	smp_wmb(); /* make pte visible before pmd */
> +	pmd_populate(vma->vm_mm, pmd, pgtable);
> +}
> +
>  void __split_huge_page_pmd(struct vm_area_struct *vma, unsigned long address,
>  		pmd_t *pmd)
>  {
>  	struct page *page;
> +	struct mm_struct *mm = vma->vm_mm;
>  	unsigned long haddr = address & HPAGE_PMD_MASK;
> +	unsigned long mmun_start;	/* For mmu_notifiers */
> +	unsigned long mmun_end;		/* For mmu_notifiers */
>  
>  	BUG_ON(vma->vm_start > haddr || vma->vm_end < haddr + HPAGE_PMD_SIZE);
>  
> -	spin_lock(&vma->vm_mm->page_table_lock);
> +	mmun_start = haddr;
> +	mmun_end   = address + HPAGE_PMD_SIZE;

address or haddr?

> +	mmu_notifier_invalidate_range_start(mm, mmun_start, mmun_end);
> +	spin_lock(&mm->page_table_lock);
>  	if (unlikely(!pmd_trans_huge(*pmd))) {
> -		spin_unlock(&vma->vm_mm->page_table_lock);
> +		spin_unlock(&mm->page_table_lock);
> +		mmu_notifier_invalidate_range_end(mm, mmun_start, mmun_end);
> +		return;
> +	}
> +	if (is_huge_zero_pmd(*pmd)) {
> +		__split_huge_zero_page_pmd(vma, haddr, pmd);
> +		spin_unlock(&mm->page_table_lock);
> +		mmu_notifier_invalidate_range_end(mm, mmun_start, mmun_end);
>  		return;
>  	}
>  	page = pmd_page(*pmd);
>  	VM_BUG_ON(!page_count(page));
>  	get_page(page);
> -	spin_unlock(&vma->vm_mm->page_table_lock);
> +	spin_unlock(&mm->page_table_lock);
> +	mmu_notifier_invalidate_range_end(mm, mmun_start, mmun_end);
>  
>  	split_huge_page(page);
>  
