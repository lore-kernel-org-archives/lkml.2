Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752018Ab2K1RAW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 12:00:22 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:45490 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407Ab2K1RAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 12:00:20 -0500
Date: Wed, 28 Nov 2012 11:59:18 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 08/46] x86, mm: Separate out
 calculate_table_space_size()
Message-ID: <20121128165918.GI21266@phenom.dumpdata.com>
References: <1353123563-3103-1-git-send-email-yinghai@kernel.org>
 <1353123563-3103-9-git-send-email-yinghai@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1353123563-3103-9-git-send-email-yinghai@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 16, 2012 at 07:38:45PM -0800, Yinghai Lu wrote:
> It should take physical address range that will need to be mapped.
> find_early_table_space should take range that pgt buff should be in.
> 
> Separating page table size calculating and finding early page table to
> reduce confusing.

You verb usage is quite confusing.

Please keep your verbs in the same tense throughout the whole patch
description.

You have the future tense :"calculating" and then you mix the the 
present tense: "take".

So either decide to use the the future all the time ('shall/will take')
or remove the future tense - so 'calculating' ends up being 'calculation'


> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> Reviewed-by: Pekka Enberg <penberg@kernel.org>
> ---
>  arch/x86/mm/init.c |   38 +++++++++++++++++++++++++++-----------
>  1 files changed, 27 insertions(+), 11 deletions(-)
> 
> diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
> index 1ce0d03..7b961d0 100644
> --- a/arch/x86/mm/init.c
> +++ b/arch/x86/mm/init.c
> @@ -196,12 +196,10 @@ static int __meminit split_mem_range(struct map_range *mr, int nr_range,
>   * mr[0].start to mr[nr_range - 1].end, while accounting for possible 2M and 1GB
>   * pages. Then find enough contiguous space for those page tables.
>   */
> -static void __init find_early_table_space(unsigned long start, unsigned long end)
> +static unsigned long __init calculate_table_space_size(unsigned long start, unsigned long end)
>  {
>  	int i;
>  	unsigned long puds = 0, pmds = 0, ptes = 0, tables;
> -	unsigned long good_end;
> -	phys_addr_t base;
>  	struct map_range mr[NR_RANGE_MR];
>  	int nr_range;
>  
> @@ -240,9 +238,17 @@ static void __init find_early_table_space(unsigned long start, unsigned long end
>  #ifdef CONFIG_X86_32
>  	/* for fixmap */
>  	tables += roundup(__end_of_fixed_addresses * sizeof(pte_t), PAGE_SIZE);
> -	good_end = max_pfn_mapped << PAGE_SHIFT;
>  #endif
>  
> +	return tables;
> +}
> +
> +static void __init find_early_table_space(unsigned long start,
> +					  unsigned long good_end,
> +					  unsigned long tables)
> +{
> +	phys_addr_t base;
> +
>  	base = memblock_find_in_range(start, good_end, tables, PAGE_SIZE);
>  	if (!base)
>  		panic("Cannot find space for the kernel page tables");
> @@ -250,10 +256,6 @@ static void __init find_early_table_space(unsigned long start, unsigned long end
>  	pgt_buf_start = base >> PAGE_SHIFT;
>  	pgt_buf_end = pgt_buf_start;
>  	pgt_buf_top = pgt_buf_start + (tables >> PAGE_SHIFT);
> -
> -	printk(KERN_DEBUG "kernel direct mapping tables up to %#lx @ [mem %#010lx-%#010lx]\n",
> -		mr[nr_range - 1].end - 1, pgt_buf_start << PAGE_SHIFT,
> -		(pgt_buf_top << PAGE_SHIFT) - 1);
>  }
>  
>  /*
> @@ -291,6 +293,8 @@ unsigned long __init_refok init_memory_mapping(unsigned long start,
>  
>  void __init init_mem_mapping(void)
>  {
> +	unsigned long tables, good_end, end;
> +
>  	probe_page_size_mask();
>  
>  	/*
> @@ -301,10 +305,18 @@ void __init init_mem_mapping(void)
>  	 * nodes are discovered.
>  	 */
>  #ifdef CONFIG_X86_64
> -	find_early_table_space(0, max_pfn<<PAGE_SHIFT);
> +	end = max_pfn << PAGE_SHIFT;
> +	good_end = end;
>  #else
> -	find_early_table_space(0, max_low_pfn<<PAGE_SHIFT);
> +	end = max_low_pfn << PAGE_SHIFT;
> +	good_end = max_pfn_mapped << PAGE_SHIFT;
>  #endif
> +	tables = calculate_table_space_size(0, end);
> +	find_early_table_space(0, good_end, tables);
> +	printk(KERN_DEBUG "kernel direct mapping tables up to %#lx @ [mem %#010lx-%#010lx] prealloc\n",
> +		end - 1, pgt_buf_start << PAGE_SHIFT,
> +		(pgt_buf_top << PAGE_SHIFT) - 1);
> +
>  	max_low_pfn_mapped = init_memory_mapping(0, max_low_pfn<<PAGE_SHIFT);
>  	max_pfn_mapped = max_low_pfn_mapped;
>  
> @@ -331,9 +343,13 @@ void __init init_mem_mapping(void)
>  	 * RO all the pagetable pages, including the ones that are beyond
>  	 * pgt_buf_end at that time.
>  	 */
> -	if (pgt_buf_end > pgt_buf_start)
> +	if (pgt_buf_end > pgt_buf_start) {
> +		printk(KERN_DEBUG "kernel direct mapping tables up to %#lx @ [mem %#010lx-%#010lx] final\n",
> +			end - 1, pgt_buf_start << PAGE_SHIFT,
> +			(pgt_buf_end << PAGE_SHIFT) - 1);
>  		x86_init.mapping.pagetable_reserve(PFN_PHYS(pgt_buf_start),
>  				PFN_PHYS(pgt_buf_end));
> +	}
>  
>  	/* stop the wrong using */
>  	pgt_buf_top = 0;
> -- 
> 1.7.7
