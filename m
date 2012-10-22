Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755176Ab2JVPVb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 11:21:31 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:61706 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754427Ab2JVPV2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 11:21:28 -0400
Date: Mon, 22 Oct 2012 11:09:17 -0400
From: Konrad Rzeszutek Wilk <konrad@kernel.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>,
        Tejun Heo <tj@kernel.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 08/19] x86, mm: Remove parameter in alloc_low_page for
 64bit
Message-ID: <20121022150916.GC22780@phenom.dumpdata.com>
References: <1350593430-24470-1-git-send-email-yinghai@kernel.org>
 <1350593430-24470-12-git-send-email-yinghai@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1350593430-24470-12-git-send-email-yinghai@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 18, 2012 at 01:50:19PM -0700, Yinghai Lu wrote:
> Now all page table buf are pre-mapped, and could use virtual address directly.
                     ^^ buffers              ^^^^ -> can

> So don't need to remember physics address anymore.
  ^^ We

physics? Physical.

> 
> Remove that phys pointer in alloc_low_page(), and that will allow us to merge
> alloc_low_page between 64bit and 32bit.
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> ---
>  arch/x86/mm/init_64.c |   19 +++++++------------
>  1 files changed, 7 insertions(+), 12 deletions(-)
> 
> diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
> index 4e6873f..cbf8dbe 100644
> --- a/arch/x86/mm/init_64.c
> +++ b/arch/x86/mm/init_64.c
> @@ -314,14 +314,13 @@ void __init cleanup_highmap(void)
>  	}
>  }
>  
> -static __ref void *alloc_low_page(unsigned long *phys)
> +static __ref void *alloc_low_page(void)
>  {
>  	unsigned long pfn;
>  	void *adr;
>  
>  	if (after_bootmem) {
>  		adr = (void *)get_zeroed_page(GFP_ATOMIC | __GFP_NOTRACK);
> -		*phys = __pa(adr);
>  
>  		return adr;
>  	}
> @@ -342,7 +341,6 @@ static __ref void *alloc_low_page(unsigned long *phys)
>  
>  	adr = __va(pfn * PAGE_SIZE);
>  	clear_page(adr);
> -	*phys  = pfn * PAGE_SIZE;
>  	return adr;
>  }
>  
> @@ -400,7 +398,6 @@ phys_pmd_init(pmd_t *pmd_page, unsigned long address, unsigned long end,
>  	int i = pmd_index(address);
>  
>  	for (; i < PTRS_PER_PMD; i++, address = next) {
> -		unsigned long pte_phys;
>  		pmd_t *pmd = pmd_page + pmd_index(address);
>  		pte_t *pte;
>  		pgprot_t new_prot = prot;
> @@ -453,11 +450,11 @@ phys_pmd_init(pmd_t *pmd_page, unsigned long address, unsigned long end,
>  			continue;
>  		}
>  
> -		pte = alloc_low_page(&pte_phys);
> +		pte = alloc_low_page();
>  		last_map_addr = phys_pte_init(pte, address, end, new_prot);
>  
>  		spin_lock(&init_mm.page_table_lock);
> -		pmd_populate_kernel(&init_mm, pmd, __va(pte_phys));
> +		pmd_populate_kernel(&init_mm, pmd, pte);
>  		spin_unlock(&init_mm.page_table_lock);
>  	}
>  	update_page_count(PG_LEVEL_2M, pages);
> @@ -473,7 +470,6 @@ phys_pud_init(pud_t *pud_page, unsigned long addr, unsigned long end,
>  	int i = pud_index(addr);
>  
>  	for (; i < PTRS_PER_PUD; i++, addr = next) {
> -		unsigned long pmd_phys;
>  		pud_t *pud = pud_page + pud_index(addr);
>  		pmd_t *pmd;
>  		pgprot_t prot = PAGE_KERNEL;
> @@ -525,12 +521,12 @@ phys_pud_init(pud_t *pud_page, unsigned long addr, unsigned long end,
>  			continue;
>  		}
>  
> -		pmd = alloc_low_page(&pmd_phys);
> +		pmd = alloc_low_page();
>  		last_map_addr = phys_pmd_init(pmd, addr, end, page_size_mask,
>  					      prot);
>  
>  		spin_lock(&init_mm.page_table_lock);
> -		pud_populate(&init_mm, pud, __va(pmd_phys));
> +		pud_populate(&init_mm, pud, pmd);
>  		spin_unlock(&init_mm.page_table_lock);
>  	}
>  	__flush_tlb_all();
> @@ -555,7 +551,6 @@ kernel_physical_mapping_init(unsigned long start,
>  
>  	for (; start < end; start = next) {
>  		pgd_t *pgd = pgd_offset_k(start);
> -		unsigned long pud_phys;
>  		pud_t *pud;
>  
>  		next = (start + PGDIR_SIZE) & PGDIR_MASK;
> @@ -569,12 +564,12 @@ kernel_physical_mapping_init(unsigned long start,
>  			continue;
>  		}
>  
> -		pud = alloc_low_page(&pud_phys);
> +		pud = alloc_low_page();
>  		last_map_addr = phys_pud_init(pud, __pa(start), __pa(next),
>  						 page_size_mask);
>  
>  		spin_lock(&init_mm.page_table_lock);
> -		pgd_populate(&init_mm, pgd, __va(pud_phys));
> +		pgd_populate(&init_mm, pgd, pud);
>  		spin_unlock(&init_mm.page_table_lock);
>  		pgd_changed = true;
>  	}
> -- 
> 1.7.7
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
