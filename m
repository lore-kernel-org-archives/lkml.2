Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755585Ab2K1Qvj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 11:51:39 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:45334 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754159Ab2K1QvX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 11:51:23 -0500
Date: Wed, 28 Nov 2012 11:50:26 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 07/46] x86, mm: Find early page table buffer together
Message-ID: <20121128165026.GH21266@phenom.dumpdata.com>
References: <1353123563-3103-1-git-send-email-yinghai@kernel.org>
 <1353123563-3103-8-git-send-email-yinghai@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1353123563-3103-8-git-send-email-yinghai@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 16, 2012 at 07:38:44PM -0800, Yinghai Lu wrote:
> We should not do that in every calling of init_memory_mapping.

Right. 
> 
> At the same time need to move down early_memtest, and could remove after_bootmem
                                                        ^^^^^^^^^^^^->'remove the'

> checking.
> 
> -v2: fix one early_memtest with 32bit by passing max_pfn_mapped instead.
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> ---
>  arch/x86/mm/init.c |   66 ++++++++++++++++++++++++++-------------------------
>  1 files changed, 34 insertions(+), 32 deletions(-)
> 
> diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
> index 51f919f..1ce0d03 100644
> --- a/arch/x86/mm/init.c
> +++ b/arch/x86/mm/init.c
> @@ -274,16 +274,6 @@ unsigned long __init_refok init_memory_mapping(unsigned long start,
>  	memset(mr, 0, sizeof(mr));
>  	nr_range = split_mem_range(mr, 0, start, end);
>  
> -	/*
> -	 * Find space for the kernel direct mapping tables.
> -	 *
> -	 * Later we should allocate these tables in the local node of the
> -	 * memory mapped. Unfortunately this is done currently before the
> -	 * nodes are discovered.
> -	 */
> -	if (!after_bootmem)
> -		find_early_table_space(start, end);
> -
>  	for (i = 0; i < nr_range; i++)
>  		ret = kernel_physical_mapping_init(mr[i].start, mr[i].end,
>  						   mr[i].page_size_mask);
> @@ -296,6 +286,36 @@ unsigned long __init_refok init_memory_mapping(unsigned long start,
>  
>  	__flush_tlb_all();
>  
> +	return ret >> PAGE_SHIFT;
> +}
> +
> +void __init init_mem_mapping(void)
> +{
> +	probe_page_size_mask();
> +
> +	/*
> +	 * Find space for the kernel direct mapping tables.
> +	 *
> +	 * Later we should allocate these tables in the local node of the
> +	 * memory mapped. Unfortunately this is done currently before the
> +	 * nodes are discovered.
> +	 */
> +#ifdef CONFIG_X86_64
> +	find_early_table_space(0, max_pfn<<PAGE_SHIFT);
> +#else
> +	find_early_table_space(0, max_low_pfn<<PAGE_SHIFT);
> +#endif
> +	max_low_pfn_mapped = init_memory_mapping(0, max_low_pfn<<PAGE_SHIFT);
> +	max_pfn_mapped = max_low_pfn_mapped;
> +
> +#ifdef CONFIG_X86_64
> +	if (max_pfn > max_low_pfn) {
> +		max_pfn_mapped = init_memory_mapping(1UL<<32,
> +						     max_pfn<<PAGE_SHIFT);
> +		/* can we preseve max_low_pfn ?*/
> +		max_low_pfn = max_pfn;
> +	}
> +#endif
>  	/*
>  	 * Reserve the kernel pagetable pages we used (pgt_buf_start -
>  	 * pgt_buf_end) and free the other ones (pgt_buf_end - pgt_buf_top)
> @@ -311,32 +331,14 @@ unsigned long __init_refok init_memory_mapping(unsigned long start,
>  	 * RO all the pagetable pages, including the ones that are beyond
>  	 * pgt_buf_end at that time.
>  	 */
> -	if (!after_bootmem && pgt_buf_end > pgt_buf_start)
> +	if (pgt_buf_end > pgt_buf_start)
>  		x86_init.mapping.pagetable_reserve(PFN_PHYS(pgt_buf_start),
>  				PFN_PHYS(pgt_buf_end));
>  
> -	if (!after_bootmem)
> -		early_memtest(start, end);
> +	/* stop the wrong using */

Huh? Can you clarify that comment please?

> +	pgt_buf_top = 0;
>  
> -	return ret >> PAGE_SHIFT;
> -}
> -
> -void __init init_mem_mapping(void)
> -{
> -	probe_page_size_mask();
> -
> -	/* max_pfn_mapped is updated here */
> -	max_low_pfn_mapped = init_memory_mapping(0, max_low_pfn<<PAGE_SHIFT);
> -	max_pfn_mapped = max_low_pfn_mapped;
> -
> -#ifdef CONFIG_X86_64
> -	if (max_pfn > max_low_pfn) {
> -		max_pfn_mapped = init_memory_mapping(1UL<<32,
> -						     max_pfn<<PAGE_SHIFT);
> -		/* can we preseve max_low_pfn ?*/
> -		max_low_pfn = max_pfn;
> -	}
> -#endif
> +	early_memtest(0, max_pfn_mapped << PAGE_SHIFT);
>  }
>  
>  /*
> -- 
> 1.7.7
