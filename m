Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756250Ab2JIQAq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 12:00:46 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:51214 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752059Ab2JIQAo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 12:00:44 -0400
Date: Tue, 9 Oct 2012 11:48:57 -0400
From: Konrad Rzeszutek Wilk <konrad@kernel.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>,
        Tejun Heo <tj@kernel.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] x86, mm: Remove early_memremap workaround for page
 table accessing
Message-ID: <20121009154856.GD7639@phenom.dumpdata.com>
References: <CAE9FiQV_xVsHN_+6ui_Vgnn6tk8UBOEKL+0XnoEN9VLw3gcOXA@mail.gmail.com>
 <1349509469-11475-1-git-send-email-yinghai@kernel.org>
 <1349509469-11475-4-git-send-email-yinghai@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349509469-11475-4-git-send-email-yinghai@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 06, 2012 at 12:44:29AM -0700, Yinghai Lu wrote:
> Not needed anymore after premaping page table buf and not clear initial page
> table wrongly.

Your comment should include what patch made the iomap/iounmap part
unnecessary.

.. and also explain how this work-around is not required anymore.

> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> ---
>  arch/x86/mm/init_64.c |   38 ++++----------------------------------
>  1 files changed, 4 insertions(+), 34 deletions(-)
> 
> diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
> index 0348a02..e59c94f 100644
> --- a/arch/x86/mm/init_64.c
> +++ b/arch/x86/mm/init_64.c
> @@ -333,36 +333,12 @@ static __ref void *alloc_low_page(unsigned long *phys)
>  	else
>  		panic("alloc_low_page: ran out of memory");
>  
> -	adr = early_memremap(pfn * PAGE_SIZE, PAGE_SIZE);
> +	adr = __va(pfn * PAGE_SIZE);
>  	clear_page(adr);
>  	*phys  = pfn * PAGE_SIZE;
>  	return adr;
>  }
>  
> -static __ref void *map_low_page(void *virt)
> -{
> -	void *adr;
> -	unsigned long phys, left;
> -
> -	if (after_bootmem)
> -		return virt;
> -
> -	phys = __pa(virt);
> -	left = phys & (PAGE_SIZE - 1);
> -	adr = early_memremap(phys & PAGE_MASK, PAGE_SIZE);
> -	adr = (void *)(((unsigned long)adr) | left);
> -
> -	return adr;
> -}
> -
> -static __ref void unmap_low_page(void *adr)
> -{
> -	if (after_bootmem)
> -		return;
> -
> -	early_iounmap((void *)((unsigned long)adr & PAGE_MASK), PAGE_SIZE);
> -}
> -
>  static unsigned long __meminit
>  phys_pte_init(pte_t *pte_page, unsigned long addr, unsigned long end,
>  	      pgprot_t prot)
> @@ -435,10 +411,9 @@ phys_pmd_init(pmd_t *pmd_page, unsigned long address, unsigned long end,
>  		if (pmd_val(*pmd)) {
>  			if (!pmd_large(*pmd)) {
>  				spin_lock(&init_mm.page_table_lock);
> -				pte = map_low_page((pte_t *)pmd_page_vaddr(*pmd));
> +				pte = (pte_t *)pmd_page_vaddr(*pmd);
>  				last_map_addr = phys_pte_init(pte, address,
>  								end, prot);
> -				unmap_low_page(pte);
>  				spin_unlock(&init_mm.page_table_lock);
>  				continue;
>  			}
> @@ -474,7 +449,6 @@ phys_pmd_init(pmd_t *pmd_page, unsigned long address, unsigned long end,
>  
>  		pte = alloc_low_page(&pte_phys);
>  		last_map_addr = phys_pte_init(pte, address, end, new_prot);
> -		unmap_low_page(pte);
>  
>  		spin_lock(&init_mm.page_table_lock);
>  		pmd_populate_kernel(&init_mm, pmd, __va(pte_phys));
> @@ -509,10 +483,9 @@ phys_pud_init(pud_t *pud_page, unsigned long addr, unsigned long end,
>  
>  		if (pud_val(*pud)) {
>  			if (!pud_large(*pud)) {
> -				pmd = map_low_page(pmd_offset(pud, 0));
> +				pmd = pmd_offset(pud, 0);
>  				last_map_addr = phys_pmd_init(pmd, addr, end,
>  							 page_size_mask, prot);
> -				unmap_low_page(pmd);
>  				__flush_tlb_all();
>  				continue;
>  			}
> @@ -548,7 +521,6 @@ phys_pud_init(pud_t *pud_page, unsigned long addr, unsigned long end,
>  		pmd = alloc_low_page(&pmd_phys);
>  		last_map_addr = phys_pmd_init(pmd, addr, end, page_size_mask,
>  					      prot);
> -		unmap_low_page(pmd);
>  
>  		spin_lock(&init_mm.page_table_lock);
>  		pud_populate(&init_mm, pud, __va(pmd_phys));
> @@ -584,17 +556,15 @@ kernel_physical_mapping_init(unsigned long start,
>  			next = end;
>  
>  		if (pgd_val(*pgd)) {
> -			pud = map_low_page((pud_t *)pgd_page_vaddr(*pgd));
> +			pud = (pud_t *)pgd_page_vaddr(*pgd);
>  			last_map_addr = phys_pud_init(pud, __pa(start),
>  						 __pa(end), page_size_mask);
> -			unmap_low_page(pud);
>  			continue;
>  		}
>  
>  		pud = alloc_low_page(&pud_phys);
>  		last_map_addr = phys_pud_init(pud, __pa(start), __pa(next),
>  						 page_size_mask);
> -		unmap_low_page(pud);
>  
>  		spin_lock(&init_mm.page_table_lock);
>  		pgd_populate(&init_mm, pgd, __va(pud_phys));
> -- 
> 1.7.7
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
