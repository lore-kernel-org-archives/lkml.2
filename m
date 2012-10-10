Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755598Ab2JJQin (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 12:38:43 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:15286 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754179Ab2JJQil (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 12:38:41 -0400
X-IronPort-AV: E=Sophos;i="4.80,565,1344211200"; 
   d="scan'208";a="15081008"
Date: Wed, 10 Oct 2012 17:38:22 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Yinghai Lu <yinghai@kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>,
        Tejun Heo <tj@kernel.org>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 6/7] x86, mm: setup page table from top-down
In-Reply-To: <1349827115-16600-7-git-send-email-yinghai@kernel.org>
Message-ID: <alpine.DEB.2.02.1210101733220.2689@kaball.uk.xensource.com>
References: <1349827115-16600-1-git-send-email-yinghai@kernel.org> <1349827115-16600-7-git-send-email-yinghai@kernel.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Oct 2012, Yinghai Lu wrote:
> Get pgt_buf early from BRK, and use it to map PMD_SIZE to top at first.
> then use page from PMD_SIZE to map next blow range.
> 
> alloc_low_page will use page from BRK at first, then will switch to use
> to memblock to find and reserve page for page table usage.
> 
> At last we could get rid of calculation and find early pgt related code.
> 
> Suggested-by: "H. Peter Anvin" <hpa@zytor.com>
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> ---
>  arch/x86/include/asm/page_types.h |    1 +
>  arch/x86/include/asm/pgtable.h    |    1 +
>  arch/x86/kernel/setup.c           |    3 +
>  arch/x86/mm/init.c                |  188 ++++++++-----------------------------
>  arch/x86/mm/init_32.c             |   17 +++-
>  arch/x86/mm/init_64.c             |   17 +++-
>  6 files changed, 71 insertions(+), 156 deletions(-)
> 
> diff --git a/arch/x86/include/asm/page_types.h b/arch/x86/include/asm/page_types.h
> index 54c9787..9f6f3e6 100644
> --- a/arch/x86/include/asm/page_types.h
> +++ b/arch/x86/include/asm/page_types.h
> @@ -45,6 +45,7 @@ extern int devmem_is_allowed(unsigned long pagenr);
>  
>  extern unsigned long max_low_pfn_mapped;
>  extern unsigned long max_pfn_mapped;
> +extern unsigned long min_pfn_mapped;
>  
>  static inline phys_addr_t get_max_mapped(void)
>  {
> diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
> index 52d40a1..25fa5bb 100644
> --- a/arch/x86/include/asm/pgtable.h
> +++ b/arch/x86/include/asm/pgtable.h
> @@ -599,6 +599,7 @@ static inline int pgd_none(pgd_t pgd)
>  
>  extern int direct_gbpages;
>  void init_mem_mapping(void);
> +void early_alloc_pgt_buf(void);
>  
>  /* local pte updates need not use xchg for locking */
>  static inline pte_t native_local_ptep_get_and_clear(pte_t *ptep)
> diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
> index 4989f80..3987daa 100644
> --- a/arch/x86/kernel/setup.c
> +++ b/arch/x86/kernel/setup.c
> @@ -123,6 +123,7 @@
>   */
>  unsigned long max_low_pfn_mapped;
>  unsigned long max_pfn_mapped;
> +unsigned long min_pfn_mapped;
>  
>  #ifdef CONFIG_DMI
>  RESERVE_BRK(dmi_alloc, 65536);
> @@ -896,6 +897,8 @@ void __init setup_arch(char **cmdline_p)
>  
>  	reserve_ibft_region();
>  
> +	early_alloc_pgt_buf();
> +
>  	/*
>  	 * Need to conclude brk, before memblock_x86_fill()
>  	 *  it could use memblock_find_in_range, could overlap with
> diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
> index 23ce4db..a060381 100644
> --- a/arch/x86/mm/init.c
> +++ b/arch/x86/mm/init.c
> @@ -223,105 +223,6 @@ static int __meminit split_mem_range(struct map_range *mr, int nr_range,
>  	return nr_range;
>  }
>  
> -static unsigned long __init calculate_table_space_size(unsigned long start,
> -					  unsigned long end)
> -{
> -	unsigned long puds = 0, pmds = 0, ptes = 0, tables;
> -	struct map_range mr[NR_RANGE_MR];
> -	int nr_range, i;
> -
> -	pr_info("calculate_table_space_size: [mem %#010lx-%#010lx]\n",
> -	       start, end - 1);
> -
> -	memset(mr, 0, sizeof(mr));
> -	nr_range = 0;
> -	nr_range = split_mem_range(mr, nr_range, start, end);
> -
> -	for (i = 0; i < nr_range; i++) {
> -		unsigned long range, extra;
> -
> -		range = mr[i].end - mr[i].start;
> -		puds += (range + PUD_SIZE - 1) >> PUD_SHIFT;
> -
> -		if (mr[i].page_size_mask & (1 << PG_LEVEL_1G)) {
> -			extra = range - ((range >> PUD_SHIFT) << PUD_SHIFT);
> -			pmds += (extra + PMD_SIZE - 1) >> PMD_SHIFT;
> -		} else
> -			pmds += (range + PMD_SIZE - 1) >> PMD_SHIFT;
> -
> -		if (mr[i].page_size_mask & (1 << PG_LEVEL_2M)) {
> -			extra = range - ((range >> PMD_SHIFT) << PMD_SHIFT);
> -#ifdef CONFIG_X86_32
> -			extra += PMD_SIZE;
> -#endif
> -			/* The first 2/4M doesn't use large pages. */
> -			if (mr[i].start < PMD_SIZE)
> -				extra += PMD_SIZE - mr[i].start;
> -
> -			ptes += (extra + PAGE_SIZE - 1) >> PAGE_SHIFT;
> -		} else
> -			ptes += (range + PAGE_SIZE - 1) >> PAGE_SHIFT;
> -	}
> -
> -	tables = roundup(puds * sizeof(pud_t), PAGE_SIZE);
> -	tables += roundup(pmds * sizeof(pmd_t), PAGE_SIZE);
> -	tables += roundup(ptes * sizeof(pte_t), PAGE_SIZE);
> -
> -#ifdef CONFIG_X86_32
> -	/* for fixmap */
> -	tables += roundup(__end_of_fixed_addresses * sizeof(pte_t), PAGE_SIZE);
> -#endif
> -
> -	return tables;
> -}
> -
> -static unsigned long __init calculate_all_table_space_size(void)
> -{
> -	unsigned long start_pfn, end_pfn;
> -	unsigned long tables;
> -	int i;
> -
> -	/* the ISA range is always mapped regardless of memory holes */
> -	tables = calculate_table_space_size(0, ISA_END_ADDRESS);
> -
> -	for_each_mem_pfn_range(i, MAX_NUMNODES, &start_pfn, &end_pfn, NULL) {
> -		u64 start = start_pfn << PAGE_SHIFT;
> -		u64 end = end_pfn << PAGE_SHIFT;
> -
> -		if (end <= ISA_END_ADDRESS)
> -			continue;
> -
> -		if (start < ISA_END_ADDRESS)
> -			start = ISA_END_ADDRESS;
> -#ifdef CONFIG_X86_32
> -		/* on 32 bit, we only map up to max_low_pfn */
> -		if ((start >> PAGE_SHIFT) >= max_low_pfn)
> -			continue;
> -
> -		if ((end >> PAGE_SHIFT) > max_low_pfn)
> -			end = max_low_pfn << PAGE_SHIFT;
> -#endif
> -		tables += calculate_table_space_size(start, end);
> -	}
> -
> -	return tables;
> -}
> -
> -static void __init find_early_table_space(unsigned long start,
> -					  unsigned long good_end,
> -					  unsigned long tables)
> -{
> -	phys_addr_t base;
> -
> -	base = memblock_find_in_range(start, good_end, tables, PAGE_SIZE);
> -	if (!base)
> -		panic("Cannot find space for the kernel page tables");
> -
> -	pgt_buf_start = base >> PAGE_SHIFT;
> -	pgt_buf_end = pgt_buf_start;
> -	pgt_buf_top = pgt_buf_start + (tables >> PAGE_SHIFT);
> -}
> -
>  static struct range pfn_mapped[E820_X_MAX];
>  static int nr_pfn_mapped;
>  
> @@ -386,22 +287,17 @@ unsigned long __init_refok init_memory_mapping(unsigned long start,
>  }
>  
>  /*
> - * Iterate through E820 memory map and create direct mappings for only E820_RAM
> - * regions. We cannot simply create direct mappings for all pfns from
> - * [0 to max_low_pfn) and [4GB to max_pfn) because of possible memory holes in
> - * high addresses that cannot be marked as UC by fixed/variable range MTRRs.
> - * Depending on the alignment of E820 ranges, this may possibly result in using
> - * smaller size (i.e. 4K instead of 2M or 1G) page tables.
> + * this one could take range with hole in it
>   */
> -static void __init init_all_memory_mapping(unsigned long all_start,
> +static void __init init_range_memory_mapping(unsigned long all_start,
>  					   unsigned long all_end)
>  {
>  	unsigned long start_pfn, end_pfn;
>  	int i;
>  
>  	for_each_mem_pfn_range(i, MAX_NUMNODES, &start_pfn, &end_pfn, NULL) {
> -		u64 start = start_pfn << PAGE_SHIFT;
> -		u64 end = end_pfn << PAGE_SHIFT;
> +		u64 start = (u64)start_pfn << PAGE_SHIFT;
> +		u64 end = (u64)end_pfn << PAGE_SHIFT;
>  
>  		if (end <= all_start)
>  			continue;
> @@ -421,67 +317,59 @@ static void __init init_all_memory_mapping(unsigned long all_start,
>  
>  void __init init_mem_mapping(void)
>  {
> -	unsigned long tables, good_end, end;
> +	unsigned long end, start, last_start;
> +	unsigned long step_size;
>  
>  	probe_page_size_mask();
>  
> -	/*
> -	 * Find space for the kernel direct mapping tables.
> -	 *
> -	 * Later we should allocate these tables in the local node of the
> -	 * memory mapped. Unfortunately this is done currently before the
> -	 * nodes are discovered.
> -	 */
>  #ifdef CONFIG_X86_64
>  	end = max_pfn << PAGE_SHIFT;
> -	good_end = end;
>  #else
>  	end = max_low_pfn << PAGE_SHIFT;
> -	good_end = max_pfn_mapped << PAGE_SHIFT;
>  #endif
> -	tables = calculate_all_table_space_size();
> -	find_early_table_space(0, good_end, tables);
> -	printk(KERN_DEBUG "kernel direct mapping tables up to %#lx @ [mem %#010lx-%#010lx] prealloc\n",
> -		end - 1, pgt_buf_start << PAGE_SHIFT,
> -		(pgt_buf_top << PAGE_SHIFT) - 1);
>  
> -	max_pfn_mapped = 0; /* will get exact value next */
>  	/* the ISA range is always mapped regardless of memory holes */
>  	init_memory_mapping(0, ISA_END_ADDRESS);
> -	init_all_memory_mapping(ISA_END_ADDRESS, end);
> +
> +	/* step_size need to be small so pgt_buf from BRK could cover it */
> +	step_size = PMD_SIZE;
> +	max_pfn_mapped = 0; /* will get exact value next */
> +	min_pfn_mapped = end >> PAGE_SHIFT;
> +	last_start = start = end;
> +	while (last_start > ISA_END_ADDRESS) {
> +		if (last_start > step_size) {
> +			start = round_down(last_start - 1, step_size);
> +			if (start < ISA_END_ADDRESS)
> +				start = ISA_END_ADDRESS;
> +		} else
> +			start = ISA_END_ADDRESS;
> +		init_all_memory_mapping(start, last_start);
> +		last_start = start;
> +		min_pfn_mapped = last_start >> PAGE_SHIFT;
> +		step_size <<= 5;
> +	}
> +
>  #ifdef CONFIG_X86_64
>  	if (max_pfn > max_low_pfn) {
>  		/* can we preseve max_low_pfn ?*/
>  		max_low_pfn = max_pfn;
>  	}
>  #endif
> -	/*
> -	 * Reserve the kernel pagetable pages we used (pgt_buf_start -
> -	 * pgt_buf_end) and free the other ones (pgt_buf_end - pgt_buf_top)
> -	 * so that they can be reused for other purposes.
> -	 *
> -	 * On native it just means calling memblock_reserve, on Xen it also
> -	 * means marking RW the pagetable pages that we allocated before
> -	 * but that haven't been used.
> -	 *
> -	 * In fact on xen we mark RO the whole range pgt_buf_start -
> -	 * pgt_buf_top, because we have to make sure that when
> -	 * init_memory_mapping reaches the pagetable pages area, it maps
> -	 * RO all the pagetable pages, including the ones that are beyond
> -	 * pgt_buf_end at that time.
> -	 */
> -	if (pgt_buf_end > pgt_buf_start) {
> -		printk(KERN_DEBUG "kernel direct mapping tables up to %#lx @ [mem %#010lx-%#010lx] final\n",
> -			end - 1, pgt_buf_start << PAGE_SHIFT,
> -			(pgt_buf_end << PAGE_SHIFT) - 1);
> -		x86_init.mapping.pagetable_reserve(PFN_PHYS(pgt_buf_start),
> -				PFN_PHYS(pgt_buf_end));
> -	}
> +	early_memtest(0, max_pfn_mapped << PAGE_SHIFT);
> +}
>  
> -	/* stop the wrong using */
> -	pgt_buf_top = 0;
> +/* need 3 4k for initial PMD_SIZE, 4k for 0-ISA_END_ADDRESS */
> +RESERVE_BRK(early_pgt_alloc, 16384);
> +void  __init early_alloc_pgt_buf(void)
> +{
> +	unsigned long tables = 16384;
> +	phys_addr_t base;
>  
> -	early_memtest(0, max_pfn_mapped << PAGE_SHIFT);
> +	base = __pa(extend_brk(tables, PAGE_SIZE));
> +
> +	pgt_buf_start = base >> PAGE_SHIFT;
> +	pgt_buf_end = pgt_buf_start;
> +	pgt_buf_top = pgt_buf_start + (tables >> PAGE_SHIFT);
>  }
>  
>  /*
> diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
> index 27f7fc6..7bb1106 100644
> --- a/arch/x86/mm/init_32.c
> +++ b/arch/x86/mm/init_32.c
> @@ -61,11 +61,22 @@ bool __read_mostly __vmalloc_start_set = false;
>  
>  static __init void *alloc_low_page(void)
>  {
> -	unsigned long pfn = pgt_buf_end++;
> +	unsigned long pfn;
>  	void *adr;
>  
> -	if (pfn >= pgt_buf_top)
> -		panic("alloc_low_page: ran out of memory");
> +	if ((pgt_buf_end + 1) >= pgt_buf_top) {
> +		unsigned long ret;
> +		if (min_pfn_mapped >= max_pfn_mapped)
> +			panic("alloc_low_page: ran out of memory");
> +		ret = memblock_find_in_range(min_pfn_mapped << PAGE_SHIFT,
> +					max_pfn_mapped << PAGE_SHIFT,
> +					PAGE_SIZE, PAGE_SIZE);
> +		if (!ret)
> +			panic("alloc_low_page: can not alloc memory");
> +		memblock_reserve(ret, PAGE_SIZE);
> +		pfn = ret >> PAGE_SHIFT;
> +	} else
> +		pfn = pgt_buf_end++;
>  
>  	adr = __va(pfn * PAGE_SIZE);
>  	clear_page(adr);
> diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
> index 4898e80..7dfa69b 100644
> --- a/arch/x86/mm/init_64.c
> +++ b/arch/x86/mm/init_64.c
> @@ -316,7 +316,7 @@ void __init cleanup_highmap(void)
>  
>  static __ref void *alloc_low_page(unsigned long *phys)
>  {
> -	unsigned long pfn = pgt_buf_end++;
> +	unsigned long pfn;
>  	void *adr;
>  
>  	if (after_bootmem) {
> @@ -326,8 +326,19 @@ static __ref void *alloc_low_page(unsigned long *phys)
>  		return adr;
>  	}
>  
> -	if (pfn >= pgt_buf_top)
> -		panic("alloc_low_page: ran out of memory");
> +	if ((pgt_buf_end + 1) >= pgt_buf_top) {
> +		unsigned long ret;
> +		if (min_pfn_mapped >= max_pfn_mapped)
> +			panic("alloc_low_page: ran out of memory");
> +		ret = memblock_find_in_range(min_pfn_mapped << PAGE_SHIFT,
> +					max_pfn_mapped << PAGE_SHIFT,
> +					PAGE_SIZE, PAGE_SIZE);
> +		if (!ret)
> +			panic("alloc_low_page: can not alloc memory");
> +		memblock_reserve(ret, PAGE_SIZE);
> +		pfn = ret >> PAGE_SHIFT;

This cannot be right: you are allocating another page to be used as
pagetable page, outside the range pgt_buf_start-pgt_buf_top.

When that page is going to be hooked into the live pagetable, the kernel
is going to panic on Xen because the page wasn't marked RO.

If you want to do that you need to tell the Xen subsystem of the new
page. pagetable_reserve is not the right call, we need a new one (see
past emails).


> +	} else
> +		pfn = pgt_buf_end++;
>  
>  	adr = early_memremap(pfn * PAGE_SIZE, PAGE_SIZE);
>  	clear_page(adr);
> -- 
> 1.7.7
> 
