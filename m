Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933632Ab1JZQbv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 12:31:51 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:59386 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933014Ab1JZQbt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 12:31:49 -0400
Date: Wed, 26 Oct 2011 12:31:26 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Ingo Molnar <mingo@elte.hu>, hpa@zytor.com
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] x86/mm changes for v3.2
Message-ID: <20111026163126.GC660@phenom.dumpdata.com>
References: <20111026153600.GA819@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111026153600.GA819@elte.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090203.4EA835E8.00E6,ss=1,re=-2.300,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 26, 2011 at 05:36:00PM +0200, Ingo Molnar wrote:
> Linus,
> 
> Please pull the latest x86-mm-for-linus git tree from:
> 
>    git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-mm-for-linus
> 
Hey Ingo,

When I spoke to hpa (LinuxCon in Canada) he mentioned that you guys decided
against this patchset and just stick with the

"x86,xen: introduce x86_init.mapping.pagetable_reserve"?

Maybe I am misremembering the conversation - there was a fair amount of beer
involved.

>  Thanks,
> 
> 	Ingo
> 
> ------------------>
> Stefano Stabellini (5):
>       x86, mm: Calculate precisely the memory needed by init_memory_mapping
>       Revert "x86,xen: introduce x86_init.mapping.pagetable_reserve"
>       x86, init : Move memblock_x86_reserve_range PGTABLE to find_early_table_space
>       x86-64, mm: Do not assume head_64.S used 4KB pages when !use_pse
>       x86_32: Calculate additional memory needed by the fixmap
> 
> 
>  arch/x86/include/asm/pgtable_types.h |    1 -
>  arch/x86/include/asm/x86_init.h      |   12 ---
>  arch/x86/kernel/x86_init.c           |    4 -
>  arch/x86/mm/init.c                   |  147 +++++++++++++++++++++++++---------
>  arch/x86/xen/mmu.c                   |   15 ----
>  5 files changed, 109 insertions(+), 70 deletions(-)
> 
> diff --git a/arch/x86/include/asm/pgtable_types.h b/arch/x86/include/asm/pgtable_types.h
> index d56187c..7db7723 100644
> --- a/arch/x86/include/asm/pgtable_types.h
> +++ b/arch/x86/include/asm/pgtable_types.h
> @@ -299,7 +299,6 @@ int phys_mem_access_prot_allowed(struct file *file, unsigned long pfn,
>  /* Install a pte for a particular vaddr in kernel space. */
>  void set_pte_vaddr(unsigned long vaddr, pte_t pte);
>  
> -extern void native_pagetable_reserve(u64 start, u64 end);
>  #ifdef CONFIG_X86_32
>  extern void native_pagetable_setup_start(pgd_t *base);
>  extern void native_pagetable_setup_done(pgd_t *base);
> diff --git a/arch/x86/include/asm/x86_init.h b/arch/x86/include/asm/x86_init.h
> index d3d8590..643ebf2 100644
> --- a/arch/x86/include/asm/x86_init.h
> +++ b/arch/x86/include/asm/x86_init.h
> @@ -68,17 +68,6 @@ struct x86_init_oem {
>  };
>  
>  /**
> - * struct x86_init_mapping - platform specific initial kernel pagetable setup
> - * @pagetable_reserve:	reserve a range of addresses for kernel pagetable usage
> - *
> - * For more details on the purpose of this hook, look in
> - * init_memory_mapping and the commit that added it.
> - */
> -struct x86_init_mapping {
> -	void (*pagetable_reserve)(u64 start, u64 end);
> -};
> -
> -/**
>   * struct x86_init_paging - platform specific paging functions
>   * @pagetable_setup_start:	platform specific pre paging_init() call
>   * @pagetable_setup_done:	platform specific post paging_init() call
> @@ -134,7 +123,6 @@ struct x86_init_ops {
>  	struct x86_init_mpparse		mpparse;
>  	struct x86_init_irqs		irqs;
>  	struct x86_init_oem		oem;
> -	struct x86_init_mapping		mapping;
>  	struct x86_init_paging		paging;
>  	struct x86_init_timers		timers;
>  	struct x86_init_iommu		iommu;
> diff --git a/arch/x86/kernel/x86_init.c b/arch/x86/kernel/x86_init.c
> index 6f164bd..6eee082 100644
> --- a/arch/x86/kernel/x86_init.c
> +++ b/arch/x86/kernel/x86_init.c
> @@ -61,10 +61,6 @@ struct x86_init_ops x86_init __initdata = {
>  		.banner			= default_banner,
>  	},
>  
> -	.mapping = {
> -		.pagetable_reserve		= native_pagetable_reserve,
> -	},
> -
>  	.paging = {
>  		.pagetable_setup_start	= native_pagetable_setup_start,
>  		.pagetable_setup_done	= native_pagetable_setup_done,
> diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
> index 3032644..a90ccc4 100644
> --- a/arch/x86/mm/init.c
> +++ b/arch/x86/mm/init.c
> @@ -28,22 +28,110 @@ int direct_gbpages
>  #endif
>  ;
>  
> -static void __init find_early_table_space(unsigned long end, int use_pse,
> -					  int use_gbpages)
> +static unsigned long __init find_early_fixmap_space(void)
>  {
> -	unsigned long puds, pmds, ptes, tables, start = 0, good_end = end;
> +	unsigned long size = 0;
> +#ifdef CONFIG_X86_32
> +	int kmap_begin_pmd_idx, kmap_end_pmd_idx;
> +	int fixmap_begin_pmd_idx, fixmap_end_pmd_idx;
> +	int btmap_begin_pmd_idx;
> +
> +	fixmap_begin_pmd_idx =
> +		__fix_to_virt(__end_of_fixed_addresses - 1) >> PMD_SHIFT;
> +	/*
> +	 * fixmap_end_pmd_idx is the end of the fixmap minus the PMD that
> +	 * has been defined in the data section by head_32.S (see
> +	 * initial_pg_fixmap).
> +	 * Note: This is similar to what early_ioremap_page_table_range_init
> +	 * does except that the "end" has PMD_SIZE expunged as per previous
> +	 * comment.
> +	 */
> +	fixmap_end_pmd_idx = (FIXADDR_TOP - 1) >> PMD_SHIFT;
> +	btmap_begin_pmd_idx = __fix_to_virt(FIX_BTMAP_BEGIN) >> PMD_SHIFT;
> +	kmap_begin_pmd_idx = __fix_to_virt(FIX_KMAP_END) >> PMD_SHIFT;
> +	kmap_end_pmd_idx = __fix_to_virt(FIX_KMAP_BEGIN) >> PMD_SHIFT;
> +
> +	size = fixmap_end_pmd_idx - fixmap_begin_pmd_idx;
> +	/*
> +	 * early_ioremap_init has already allocated a PMD at
> +	 * btmap_begin_pmd_idx
> +	 */
> +	if (btmap_begin_pmd_idx < fixmap_end_pmd_idx)
> +		size--;
> +
> +#ifdef CONFIG_HIGHMEM
> +	/*
> +	 * see page_table_kmap_check: if the kmap spans multiple PMDs, make
> +	 * sure the pte pages are allocated contiguously. It might need up
> +	 * to two additional pte pages to replace the page declared by
> +	 * head_32.S and the one allocated by early_ioremap_init, if they
> +	 * are even partially used for the kmap.
> +	 */
> +	if (kmap_begin_pmd_idx != kmap_end_pmd_idx) {
> +		if (kmap_end_pmd_idx == fixmap_end_pmd_idx)
> +			size++;
> +		if (btmap_begin_pmd_idx >= kmap_begin_pmd_idx &&
> +				btmap_begin_pmd_idx <= kmap_end_pmd_idx)
> +			size++;
> +	}
> +#endif
> +#endif
> +	return (size * PMD_SIZE + PAGE_SIZE - 1) >> PAGE_SHIFT;
> +}
> +
> +static void __init find_early_table_space(unsigned long start,
> +		unsigned long end, int use_pse, int use_gbpages)
> +{
> +	unsigned long pmds = 0, ptes = 0, tables = 0, good_end = end,
> +				  pud_mapped = 0, pmd_mapped = 0, size = end - start;
>  	phys_addr_t base;
>  
> -	puds = (end + PUD_SIZE - 1) >> PUD_SHIFT;
> -	tables = roundup(puds * sizeof(pud_t), PAGE_SIZE);
> +	pud_mapped = DIV_ROUND_UP(PFN_PHYS(max_pfn_mapped),
> +			(PUD_SIZE * PTRS_PER_PUD));
> +	pud_mapped *= (PUD_SIZE * PTRS_PER_PUD);
> +	pmd_mapped = DIV_ROUND_UP(PFN_PHYS(max_pfn_mapped),
> +			(PMD_SIZE * PTRS_PER_PMD));
> +	pmd_mapped *= (PMD_SIZE * PTRS_PER_PMD);
> +
> +	/*
> +	 * On x86_64 do not limit the size we need to cover with 4KB pages
> +	 * depending on the initial allocation because head_64.S always uses
> +	 * 2MB pages.
> +	 */
> +#ifdef CONFIG_X86_32
> +	if (start < PFN_PHYS(max_pfn_mapped)) {
> +		if (PFN_PHYS(max_pfn_mapped) < end)
> +			size -= PFN_PHYS(max_pfn_mapped) - start;
> +		else
> +			size = 0;
> +	}
> +#endif
> +
> +#ifndef __PAGETABLE_PUD_FOLDED
> +	if (end > pud_mapped) {
> +		unsigned long puds;
> +		if (start < pud_mapped)
> +			puds = (end - pud_mapped + PUD_SIZE - 1) >> PUD_SHIFT;
> +		else
> +			puds = (end - start + PUD_SIZE - 1) >> PUD_SHIFT;
> +		tables += roundup(puds * sizeof(pud_t), PAGE_SIZE);
> +	}
> +#endif
>  
>  	if (use_gbpages) {
>  		unsigned long extra;
>  
>  		extra = end - ((end>>PUD_SHIFT) << PUD_SHIFT);
>  		pmds = (extra + PMD_SIZE - 1) >> PMD_SHIFT;
> -	} else
> -		pmds = (end + PMD_SIZE - 1) >> PMD_SHIFT;
> +	}
> +#ifndef __PAGETABLE_PMD_FOLDED
> +	else if (end > pmd_mapped) {
> +		if (start < pmd_mapped)
> +			pmds = (end - pmd_mapped + PMD_SIZE - 1) >> PMD_SHIFT;
> +		else
> +			pmds = (end - start + PMD_SIZE - 1) >> PMD_SHIFT;
> +	}
> +#endif
>  
>  	tables += roundup(pmds * sizeof(pmd_t), PAGE_SIZE);
>  
> @@ -51,23 +139,22 @@ static void __init find_early_table_space(unsigned long end, int use_pse,
>  		unsigned long extra;
>  
>  		extra = end - ((end>>PMD_SHIFT) << PMD_SHIFT);
> -#ifdef CONFIG_X86_32
> -		extra += PMD_SIZE;
> -#endif
>  		ptes = (extra + PAGE_SIZE - 1) >> PAGE_SHIFT;
>  	} else
> -		ptes = (end + PAGE_SIZE - 1) >> PAGE_SHIFT;
> +		ptes = (size + PAGE_SIZE - 1) >> PAGE_SHIFT;
> +
> +	ptes += find_early_fixmap_space();
>  
>  	tables += roundup(ptes * sizeof(pte_t), PAGE_SIZE);
>  
> -#ifdef CONFIG_X86_32
> -	/* for fixmap */
> -	tables += roundup(__end_of_fixed_addresses * sizeof(pte_t), PAGE_SIZE);
> +	if (!tables)
> +		return;
>  
> +#ifdef CONFIG_X86_32
>  	good_end = max_pfn_mapped << PAGE_SHIFT;
>  #endif
>  
> -	base = memblock_find_in_range(start, good_end, tables, PAGE_SIZE);
> +	base = memblock_find_in_range(0x00, good_end, tables, PAGE_SIZE);
>  	if (base == MEMBLOCK_ERROR)
>  		panic("Cannot find space for the kernel page tables");
>  
> @@ -77,11 +164,10 @@ static void __init find_early_table_space(unsigned long end, int use_pse,
>  
>  	printk(KERN_DEBUG "kernel direct mapping tables up to %lx @ %lx-%lx\n",
>  		end, pgt_buf_start << PAGE_SHIFT, pgt_buf_top << PAGE_SHIFT);
> -}
>  
> -void __init native_pagetable_reserve(u64 start, u64 end)
> -{
> -	memblock_x86_reserve_range(start, end, "PGTABLE");
> +	if (pgt_buf_top > pgt_buf_start)
> +		memblock_x86_reserve_range(pgt_buf_start << PAGE_SHIFT,
> +				 pgt_buf_top << PAGE_SHIFT, "PGTABLE");
>  }
>  
>  struct map_range {
> @@ -261,7 +347,7 @@ unsigned long __init_refok init_memory_mapping(unsigned long start,
>  	 * nodes are discovered.
>  	 */
>  	if (!after_bootmem)
> -		find_early_table_space(end, use_pse, use_gbpages);
> +		find_early_table_space(start, end, use_pse, use_gbpages);
>  
>  	for (i = 0; i < nr_range; i++)
>  		ret = kernel_physical_mapping_init(mr[i].start, mr[i].end,
> @@ -275,24 +361,9 @@ unsigned long __init_refok init_memory_mapping(unsigned long start,
>  
>  	__flush_tlb_all();
>  
> -	/*
> -	 * Reserve the kernel pagetable pages we used (pgt_buf_start -
> -	 * pgt_buf_end) and free the other ones (pgt_buf_end - pgt_buf_top)
> -	 * so that they can be reused for other purposes.
> -	 *
> -	 * On native it just means calling memblock_x86_reserve_range, on Xen it
> -	 * also means marking RW the pagetable pages that we allocated before
> -	 * but that haven't been used.
> -	 *
> -	 * In fact on xen we mark RO the whole range pgt_buf_start -
> -	 * pgt_buf_top, because we have to make sure that when
> -	 * init_memory_mapping reaches the pagetable pages area, it maps
> -	 * RO all the pagetable pages, including the ones that are beyond
> -	 * pgt_buf_end at that time.
> -	 */
> -	if (!after_bootmem && pgt_buf_end > pgt_buf_start)
> -		x86_init.mapping.pagetable_reserve(PFN_PHYS(pgt_buf_start),
> -				PFN_PHYS(pgt_buf_end));
> +	if (pgt_buf_end != pgt_buf_top)
> +		printk(KERN_DEBUG "initial kernel pagetable allocation wasted %lx"
> +				" pages\n", pgt_buf_top - pgt_buf_end);
>  
>  	if (!after_bootmem)
>  		early_memtest(start, end);
> diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
> index dc708dc..2004f1e 100644
> --- a/arch/x86/xen/mmu.c
> +++ b/arch/x86/xen/mmu.c
> @@ -1153,20 +1153,6 @@ static void __init xen_pagetable_setup_start(pgd_t *base)
>  {
>  }
>  
> -static __init void xen_mapping_pagetable_reserve(u64 start, u64 end)
> -{
> -	/* reserve the range used */
> -	native_pagetable_reserve(start, end);
> -
> -	/* set as RW the rest */
> -	printk(KERN_DEBUG "xen: setting RW the range %llx - %llx\n", end,
> -			PFN_PHYS(pgt_buf_top));
> -	while (end < PFN_PHYS(pgt_buf_top)) {
> -		make_lowmem_page_readwrite(__va(end));
> -		end += PAGE_SIZE;
> -	}
> -}
> -
>  static void xen_post_allocator_init(void);
>  
>  static void __init xen_pagetable_setup_done(pgd_t *base)
> @@ -1997,7 +1983,6 @@ static const struct pv_mmu_ops xen_mmu_ops __initconst = {
>  
>  void __init xen_init_mmu_ops(void)
>  {
> -	x86_init.mapping.pagetable_reserve = xen_mapping_pagetable_reserve;
>  	x86_init.paging.pagetable_setup_start = xen_pagetable_setup_start;
>  	x86_init.paging.pagetable_setup_done = xen_pagetable_setup_done;
>  	pv_mmu_ops = xen_mmu_ops;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
