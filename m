Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932141Ab2K1S6e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 13:58:34 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:32689 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755040Ab2K1S6a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 13:58:30 -0500
Date: Wed, 28 Nov 2012 13:57:27 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 22/46] x86, mm: Remove early_memremap workaround for
 page table accessing on 64bit
Message-ID: <20121128185727.GP21266@phenom.dumpdata.com>
References: <1353123563-3103-1-git-send-email-yinghai@kernel.org>
 <1353123563-3103-23-git-send-email-yinghai@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1353123563-3103-23-git-send-email-yinghai@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 16, 2012 at 07:38:59PM -0800, Yinghai Lu wrote:
> We try to put page table high to make room for kdump, and at that time
> those ranges are not mapped yet, and have to use ioremap to access it.
               ^^^ -> were             ^^^^ -> had
> 
> Now after patch that pre-map page table top down.
> 	x86, mm: setup page table in top-down
> We do not need that workaround anymore.
> 
> Just use __va to return directly mapping address.
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> Acked-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> ---
>  arch/x86/mm/init_64.c |   38 ++++----------------------------------
>  1 files changed, 4 insertions(+), 34 deletions(-)
> 
> diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
> index eefaea6..5ee9242 100644
> --- a/arch/x86/mm/init_64.c
> +++ b/arch/x86/mm/init_64.c
> @@ -340,36 +340,12 @@ static __ref void *alloc_low_page(unsigned long *phys)
>  	} else
>  		pfn = pgt_buf_end++;
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
> @@ -442,10 +418,9 @@ phys_pmd_init(pmd_t *pmd_page, unsigned long address, unsigned long end,
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
> @@ -483,7 +458,6 @@ phys_pmd_init(pmd_t *pmd_page, unsigned long address, unsigned long end,
>  
>  		pte = alloc_low_page(&pte_phys);
>  		last_map_addr = phys_pte_init(pte, address, end, new_prot);
> -		unmap_low_page(pte);
>  
>  		spin_lock(&init_mm.page_table_lock);
>  		pmd_populate_kernel(&init_mm, pmd, __va(pte_phys));
> @@ -518,10 +492,9 @@ phys_pud_init(pud_t *pud_page, unsigned long addr, unsigned long end,
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
> @@ -560,7 +533,6 @@ phys_pud_init(pud_t *pud_page, unsigned long addr, unsigned long end,
>  		pmd = alloc_low_page(&pmd_phys);
>  		last_map_addr = phys_pmd_init(pmd, addr, end, page_size_mask,
>  					      prot);
> -		unmap_low_page(pmd);
>  
>  		spin_lock(&init_mm.page_table_lock);
>  		pud_populate(&init_mm, pud, __va(pmd_phys));
> @@ -596,17 +568,15 @@ kernel_physical_mapping_init(unsigned long start,
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
