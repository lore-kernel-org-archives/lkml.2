Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755342Ab2KMQxB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 11:53:01 -0500
Received: from smtp.citrix.com ([66.165.176.89]:25264 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755282Ab2KMQw7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 11:52:59 -0500
X-IronPort-AV: E=Sophos;i="4.80,768,1344211200"; 
   d="scan'208";a="44442760"
Date: Tue, 13 Nov 2012 16:52:25 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Yinghai Lu <yinghai@kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 22/46] x86, mm: Remove early_memremap workaround for page
 table accessing on 64bit
In-Reply-To: <1352755122-25660-23-git-send-email-yinghai@kernel.org>
Message-ID: <alpine.DEB.2.02.1211131649570.28049@kaball.uk.xensource.com>
References: <20121112193044.GA11615@phenom.dumpdata.com> <1352755122-25660-1-git-send-email-yinghai@kernel.org> <1352755122-25660-23-git-send-email-yinghai@kernel.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Nov 2012, Yinghai Lu wrote:
> We try to put page table high to make room for kdump, and at that time
> those ranges are not mapped yet, and have to use ioremap to access it.
> 
> Now after patch that pre-map page table top down.
> 	x86, mm: setup page table in top-down
> We do not need that workaround anymore.
> 
> Just use __va to return directly mapping address.
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>


Acked-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

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
> 
