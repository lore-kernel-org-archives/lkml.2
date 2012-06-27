Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757853Ab2F0QMb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 12:12:31 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:62359 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753070Ab2F0QM3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 12:12:29 -0400
Date: Wed, 27 Jun 2012 17:12:24 +0100
From: Dave Martin <dave.martin@linaro.org>
To: Minchan Kim <minchan@kernel.org>
Cc: Russell King <linux@arm.linux.org.uk>, Nicolas Pitre <nico@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Chanho Min <chanho.min@lge.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Jongsung Kim <neidhard.kim@lge.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] [RESEND] arm: limit memblock base address for
 early_pte_alloc
Message-ID: <20120627161224.GB2310@linaro.org>
References: <1338880312-17561-1-git-send-email-minchan@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1338880312-17561-1-git-send-email-minchan@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 05, 2012 at 04:11:52PM +0900, Minchan Kim wrote:
> If we do arm_memblock_steal with a page which is not aligned with section size,
> panic can happen during boot by page fault in map_lowmem.
> 
> Detail:
> 
> 1) mdesc->reserve can steal a page which is allocated at 0x1ffff000 by memblock
>    which prefers tail pages of regions.
> 2) map_lowmem maps 0x00000000 - 0x1fe00000
> 3) map_lowmem try to map 0x1fe00000 but it's not aligned by section due to 1.
> 4) calling alloc_init_pte allocates a new page for new pte by memblock_alloc
> 5) allocated memory for pte is 0x1fffe000 -> it's not mapped yet.
> 6) memset(ptr, 0, sz) in early_alloc_aligned got PANICed!
> 
> This patch fix it by limiting memblock to mapped memory range.
> 
> Reported-by: Jongsung Kim <neidhard.kim@lge.com>
> Suggested-by: Chanho Min <chanho.min@lge.com>
> Signed-off-by: Minchan Kim <minchan@kernel.org>
> ---
>  arch/arm/mm/mmu.c |   37 ++++++++++++++++++++++---------------
>  1 file changed, 22 insertions(+), 15 deletions(-)
> 
> diff --git a/arch/arm/mm/mmu.c b/arch/arm/mm/mmu.c
> index e5dad60..a15aafe 100644
> --- a/arch/arm/mm/mmu.c
> +++ b/arch/arm/mm/mmu.c
> @@ -594,7 +594,7 @@ static void __init alloc_init_pte(pmd_t *pmd, unsigned long addr,
>  
>  static void __init alloc_init_section(pud_t *pud, unsigned long addr,
>  				      unsigned long end, phys_addr_t phys,
> -				      const struct mem_type *type)
> +				      const struct mem_type *type, bool lowmem)
>  {
>  	pmd_t *pmd = pmd_offset(pud, addr);
>  
> @@ -619,6 +619,8 @@ static void __init alloc_init_section(pud_t *pud, unsigned long addr,
>  
>  		flush_pmd_entry(p);
>  	} else {
> +		if (lowmem)
> +			memblock_set_current_limit(__pa(addr));

I thought of doing something similar to this.  A concern I have is that
when mapping the first few sections, is it guaranteed that there will be
enough memory available below memblock.current_limit to allocate extra
page tables, in general?  I think we could get failures here even though
there is spare (unmapped) memory above the limit.

An alternative approach would be to install temporary section mappings
to cover all of lowmem before starting to create the real mappings.
The memblock allocator still knows which regions are reserved, so we
shouldn't end up scribbling on pages which are really not supposed to
be mapped in lowmem.

That feels like it should work, but would involve extra overheads, more
flushing etc. to purge all those temporary section mappings from the TLB.

Cheers
---Dave

>  		/*
>  		 * No need to loop; pte's aren't interested in the
>  		 * individual L1 entries.
> @@ -628,14 +630,15 @@ static void __init alloc_init_section(pud_t *pud, unsigned long addr,
>  }
>  
>  static void __init alloc_init_pud(pgd_t *pgd, unsigned long addr,
> -	unsigned long end, unsigned long phys, const struct mem_type *type)
> +				unsigned long end, unsigned long phys,
> +				const struct mem_type *type, bool lowmem)
>  {
>  	pud_t *pud = pud_offset(pgd, addr);
>  	unsigned long next;
>  
>  	do {
>  		next = pud_addr_end(addr, end);
> -		alloc_init_section(pud, addr, next, phys, type);
> +		alloc_init_section(pud, addr, next, phys, type, lowmem);
>  		phys += next - addr;
>  	} while (pud++, addr = next, addr != end);
>  }
> @@ -702,14 +705,7 @@ static void __init create_36bit_mapping(struct map_desc *md,
>  }
>  #endif	/* !CONFIG_ARM_LPAE */
>  
> -/*
> - * Create the page directory entries and any necessary
> - * page tables for the mapping specified by `md'.  We
> - * are able to cope here with varying sizes and address
> - * offsets, and we take full advantage of sections and
> - * supersections.
> - */
> -static void __init create_mapping(struct map_desc *md)
> +static inline void __create_mapping(struct map_desc *md, bool lowmem)
>  {
>  	unsigned long addr, length, end;
>  	phys_addr_t phys;
> @@ -759,7 +755,7 @@ static void __init create_mapping(struct map_desc *md)
>  	do {
>  		unsigned long next = pgd_addr_end(addr, end);
>  
> -		alloc_init_pud(pgd, addr, next, phys, type);
> +		alloc_init_pud(pgd, addr, next, phys, type, lowmem);
>  
>  		phys += next - addr;
>  		addr = next;
> @@ -767,6 +763,18 @@ static void __init create_mapping(struct map_desc *md)
>  }
>  
>  /*
> + * Create the page directory entries and any necessary
> + * page tables for the mapping specified by `md'.  We
> + * are able to cope here with varying sizes and address
> + * offsets, and we take full advantage of sections and
> + * supersections.
> + */
> +static void __init create_mapping(struct map_desc *md)
> +{
> +	__create_mapping(md, false);
> +}
> +
> +/*
>   * Create the architecture specific mappings
>   */
>  void __init iotable_init(struct map_desc *io_desc, int nr)
> @@ -1111,7 +1119,7 @@ static void __init map_lowmem(void)
>  		map.length = end - start;
>  		map.type = MT_MEMORY;
>  
> -		create_mapping(&map);
> +		__create_mapping(&map, true);
>  	}
>  }
>  
> @@ -1123,11 +1131,10 @@ void __init paging_init(struct machine_desc *mdesc)
>  {
>  	void *zero_page;
>  
> -	memblock_set_current_limit(arm_lowmem_limit);
> -
>  	build_mem_type_table();
>  	prepare_page_table();
>  	map_lowmem();
> +	memblock_set_current_limit(arm_lowmem_limit);
>  	dma_contiguous_remap();
>  	devicemaps_init(mdesc);
>  	kmap_init();
> -- 
> 1.7.9.5
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
