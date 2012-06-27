Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754766Ab2F0QCg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 12:02:36 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:63312 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752976Ab2F0QCd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 12:02:33 -0400
Date: Wed, 27 Jun 2012 17:02:20 +0100
From: Dave Martin <dave.martin@linaro.org>
To: "Kim, Jong-Sung" <neidhard.kim@lge.com>
Cc: "'Minchan Kim'" <minchan@kernel.org>,
        "'Russell King'" <linux@arm.linux.org.uk>,
        "'Nicolas Pitre'" <nico@linaro.org>,
        "'Catalin Marinas'" <catalin.marinas@arm.com>,
        "'Chanho Min'" <chanho.min@lge.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] [RESEND] arm: limit memblock base address for
 early_pte_alloc
Message-ID: <20120627160220.GA2310@linaro.org>
References: <1338880312-17561-1-git-send-email-minchan@kernel.org>
 <025701cd457e$d5065410$7f12fc30$@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <025701cd457e$d5065410$7f12fc30$@lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 08, 2012 at 10:58:50PM +0900, Kim, Jong-Sung wrote:
> > From: Minchan Kim [mailto:minchan@kernel.org]
> > Sent: Tuesday, June 05, 2012 4:12 PM
> > 
> > If we do arm_memblock_steal with a page which is not aligned with section
> > size, panic can happen during boot by page fault in map_lowmem.
> > 
> > Detail:
> > 
> > 1) mdesc->reserve can steal a page which is allocated at 0x1ffff000 by
> > memblock
> >    which prefers tail pages of regions.
> > 2) map_lowmem maps 0x00000000 - 0x1fe00000
> > 3) map_lowmem try to map 0x1fe00000 but it's not aligned by section due to
> 1.
> > 4) calling alloc_init_pte allocates a new page for new pte by
> memblock_alloc
> > 5) allocated memory for pte is 0x1fffe000 -> it's not mapped yet.
> > 6) memset(ptr, 0, sz) in early_alloc_aligned got PANICed!
> 
> May I suggest another simple approach? The first continuous couples of
> sections are always safely section-mapped inside alloc_init_section funtion.
> So, by limiting memblock_alloc to the end of the first continuous couples of
> sections at the start of map_lowmem, map_lowmem can safely memblock_alloc &
> memset even if we have one or more section-unaligned memory regions. The
> limit can be extended back to arm_lowmem_limit after the map_lowmem is done.

By a strange coincidence, I hit exactly the same problem today.

This approach looks nice and simple, but ...

> 
> diff --git a/arch/arm/mm/mmu.c b/arch/arm/mm/mmu.c
> index e5dad60..edf1e2d 100644
> --- a/arch/arm/mm/mmu.c
> +++ b/arch/arm/mm/mmu.c
> @@ -1094,6 +1094,11 @@ static void __init kmap_init(void)
>  static void __init map_lowmem(void)
>  {
>  	struct memblock_region *reg;
> +	phys_addr_t pmd_map_end;
> +
> +	pmd_map_end = (memblock.memory.regions[0].base +
> +	               memblock.memory.regions[0].size) & PMD_MASK;

What does memblock.memory.regions[0] actually refer to at this point?
Just before map_lowmem(), memblock_dump_all() gives me this:

[    0.000000] MEMBLOCK configuration:
[    0.000000]  memory size = 0x1ff00000 reserved size = 0x6220a5
[    0.000000]  memory.cnt  = 0x1
[    0.000000]  memory[0x0]     [0x00000080000000-0x0000009fefffff], 0x1ff00000 bytes
[    0.000000]  reserved.cnt  = 0x4
[    0.000000]  reserved[0x0]   [0x00000080004000-0x00000080007fff], 0x4000 bytes
[    0.000000]  reserved[0x1]   [0x00000080008200-0x00000080582c83], 0x57aa84 bytes
[    0.000000]  reserved[0x2]   [0x000000807d4e78-0x000000807d6603], 0x178c bytes
[    0.000000]  reserved[0x3]   [0x00000080d00000-0x00000080da1e94], 0xa1e95 bytes

For me, it appears that this block just contains the initial region
passed in ATAG_MEM or on the command line, with some reservations
for swapper_pg_dir, the kernel text/data, device tree and initramfs.

So far as I can tell, the only memory guaranteed to be mapped here
is the kernel image: there may be no guarantee that there is any unused
space in this region which could be used to allocate extra page tables.
The rest appears during the execution of map_lowmem().

Cheers
---Dave

> +	memblock_set_current_limit(pmd_map_end);
>  
>  	/* Map all the lowmem memory banks. */
>  	for_each_memblock(memory, reg) {
> @@ -1113,6 +1118,8 @@ static void __init map_lowmem(void)
>  
>  		create_mapping(&map);
>  	}
> +
> +	memblock_set_current_limit(arm_lowmem_limit);
>  }
>  
>  /*
> @@ -1123,8 +1130,6 @@ void __init paging_init(struct machine_desc *mdesc)
>  {
>  	void *zero_page;
>  
> -	memblock_set_current_limit(arm_lowmem_limit);
> -
>  	build_mem_type_table();
>  	prepare_page_table();
>  	map_lowmem();
> 
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
