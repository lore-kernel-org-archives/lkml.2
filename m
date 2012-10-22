Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755413Ab2JVPhO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 11:37:14 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:64993 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751719Ab2JVPhJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 11:37:09 -0400
Date: Mon, 22 Oct 2012 11:24:58 -0400
From: Konrad Rzeszutek Wilk <konrad@kernel.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>,
        Tejun Heo <tj@kernel.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 13/19] x86, mm: only call
 early_ioremap_page_table_range_init() once
Message-ID: <20121022152457.GH22780@phenom.dumpdata.com>
References: <1350593430-24470-1-git-send-email-yinghai@kernel.org>
 <1350593430-24470-17-git-send-email-yinghai@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1350593430-24470-17-git-send-email-yinghai@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 18, 2012 at 01:50:24PM -0700, Yinghai Lu wrote:
> On 32bit, We should not keep calling that during every init_memory_mapping.

Explain pls why.

> 
> Need to update page_table_range_init() to count the pages for kmap page table
> at first, and use new added alloc_low_pages() to get pages in sequence.
> That will conform requirement that page table need to be in low to high order.
                   ^ to the                    ^-s
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> ---
>  arch/x86/mm/init.c    |   13 +++++--------
>  arch/x86/mm/init_32.c |   47 +++++++++++++++++++++++++++++++++++++++++------
>  2 files changed, 46 insertions(+), 14 deletions(-)
> 
> diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
> index de71c0d..4eece3c 100644
> --- a/arch/x86/mm/init.c
> +++ b/arch/x86/mm/init.c
> @@ -334,14 +334,6 @@ unsigned long __init_refok init_memory_mapping(unsigned long start,
>  		ret = kernel_physical_mapping_init(mr[i].start, mr[i].end,
>  						   mr[i].page_size_mask);
>  
> -#ifdef CONFIG_X86_32
> -	early_ioremap_page_table_range_init();
> -
> -	load_cr3(swapper_pg_dir);
> -#endif
> -
> -	__flush_tlb_all();
> -
>  	add_pfn_range_mapped(start >> PAGE_SHIFT, ret >> PAGE_SHIFT);
>  
>  	return ret >> PAGE_SHIFT;
> @@ -435,7 +427,12 @@ void __init init_mem_mapping(void)
>  		/* can we preseve max_low_pfn ?*/
>  		max_low_pfn = max_pfn;
>  	}
> +#else
> +	early_ioremap_page_table_range_init();
> +	load_cr3(swapper_pg_dir);
> +	__flush_tlb_all();
>  #endif
> +
>  	early_memtest(0, max_pfn_mapped << PAGE_SHIFT);
>  }
>  
> diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
> index a7f2df1..ef7f0dc 100644
> --- a/arch/x86/mm/init_32.c
> +++ b/arch/x86/mm/init_32.c
> @@ -135,8 +135,39 @@ pte_t * __init populate_extra_pte(unsigned long vaddr)
>  	return one_page_table_init(pmd) + pte_idx;
>  }
>  
> +static unsigned long __init
> +page_table_range_init_count(unsigned long start, unsigned long end)
> +{
> +	unsigned long count = 0;
> +#ifdef CONFIG_HIGHMEM
> +	int pmd_idx_kmap_begin = fix_to_virt(FIX_KMAP_END) >> PMD_SHIFT;
> +	int pmd_idx_kmap_end = fix_to_virt(FIX_KMAP_BEGIN) >> PMD_SHIFT;
> +	int pgd_idx, pmd_idx;
> +	unsigned long vaddr;
> +
> +	if (pmd_idx_kmap_begin == pmd_idx_kmap_end)
> +		return count;

Or just 'return 0';

