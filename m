Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752439Ab0G1Fpi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 01:45:38 -0400
Received: from gate.crashing.org ([63.228.1.57]:56225 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751071Ab0G1Fpf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 01:45:35 -0400
Subject: Re: [PATCH 30/31] memblock: Add ARCH_DISCARD_MEMBLOCK to put
 memblock code to .init
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Miller <davem@davemloft.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
In-Reply-To: <1279822864-17154-31-git-send-email-yinghai@kernel.org>
References: <1279822864-17154-1-git-send-email-yinghai@kernel.org>
	 <1279822864-17154-31-git-send-email-yinghai@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 28 Jul 2010 15:45:02 +1000
Message-ID: <1280295902.1970.247.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-07-22 at 11:21 -0700, Yinghai Lu wrote:
> So those memblock bits could be released after kernel is booted up.
> 
> Arch code could define ARCH_DISCARD_MEMBLOCK in asm/memblock.h,
> __init_memblock will become __init, __initdata_memblock will becom __initdata

Actually, that sucks.

A bunch of memblock is already __init. The bits that aren't fall mostly
into two categories:

 - Stuff used by powerpc memory hotplug. Most of this could be covered
by __meminit

 - The arrays themselves. We really only care about keeping the memory
array and a couple of things to walk it.

I'm merging the patch now to avoid further delays but we need to
revisit that too.

Ben.


> x86 code will use that.
> 
> if ARCH_DISCARD_MEMBLOCK is defined, debugfs is not used
> 
> -v2: use ARCH_DISCARD_MEMBLOCK according to Michael Ellerman
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> ---
>  include/linux/memblock.h |    8 +++++++
>  mm/memblock.c            |   48 +++++++++++++++++++++++-----------------------
>  2 files changed, 32 insertions(+), 24 deletions(-)
> 
> diff --git a/include/linux/memblock.h b/include/linux/memblock.h
> index 4aaaf0d..751a4eb 100644
> --- a/include/linux/memblock.h
> +++ b/include/linux/memblock.h
> @@ -148,6 +148,14 @@ static inline unsigned long memblock_region_pages(const struct memblock_region *
>  	     region++)
>  
> 
> +#ifdef ARCH_DISCARD_MEMBLOCK
> +#define __init_memblock __init
> +#define __initdata_memblock __initdata
> +#else
> +#define __init_memblock
> +#define __initdata_memblock
> +#endif
> +
>  #endif /* CONFIG_HAVE_MEMBLOCK */
>  
>  #endif /* __KERNEL__ */
> diff --git a/mm/memblock.c b/mm/memblock.c
> index 3d0a754..7471dac 100644
> --- a/mm/memblock.c
> +++ b/mm/memblock.c
> @@ -20,12 +20,12 @@
>  #include <linux/seq_file.h>
>  #include <linux/memblock.h>
>  
> -struct memblock memblock;
> +struct memblock memblock __initdata_memblock;
>  
> -int memblock_debug;
> -int memblock_can_resize;
> -static struct memblock_region memblock_memory_init_regions[INIT_MEMBLOCK_REGIONS + 1];
> -struct memblock_region memblock_reserved_init_regions[INIT_MEMBLOCK_REGIONS + 1];
> +int memblock_debug __initdata_memblock;
> +int memblock_can_resize __initdata_memblock;
> +static struct memblock_region memblock_memory_init_regions[INIT_MEMBLOCK_REGIONS + 1] __initdata_memblock;
> +struct memblock_region memblock_reserved_init_regions[INIT_MEMBLOCK_REGIONS + 1] __initdata_memblock;
>  
>  /* inline so we don't get a warning when pr_debug is compiled out */
>  static inline const char *memblock_type_name(struct memblock_type *type)
> @@ -42,23 +42,23 @@ static inline const char *memblock_type_name(struct memblock_type *type)
>   * Address comparison utilities
>   */
>  
> -static phys_addr_t memblock_align_down(phys_addr_t addr, phys_addr_t size)
> +static phys_addr_t __init_memblock memblock_align_down(phys_addr_t addr, phys_addr_t size)
>  {
>  	return addr & ~(size - 1);
>  }
>  
> -static phys_addr_t memblock_align_up(phys_addr_t addr, phys_addr_t size)
> +static phys_addr_t __init_memblock memblock_align_up(phys_addr_t addr, phys_addr_t size)
>  {
>  	return (addr + (size - 1)) & ~(size - 1);
>  }
>  
> -static unsigned long memblock_addrs_overlap(phys_addr_t base1, phys_addr_t size1,
> +static unsigned long __init_memblock memblock_addrs_overlap(phys_addr_t base1, phys_addr_t size1,
>  				       phys_addr_t base2, phys_addr_t size2)
>  {
>  	return ((base1 < (base2 + size2)) && (base2 < (base1 + size1)));
>  }
>  
> -static long memblock_addrs_adjacent(phys_addr_t base1, phys_addr_t size1,
> +static long __init_memblock memblock_addrs_adjacent(phys_addr_t base1, phys_addr_t size1,
>  			       phys_addr_t base2, phys_addr_t size2)
>  {
>  	if (base2 == base1 + size1)
> @@ -69,7 +69,7 @@ static long memblock_addrs_adjacent(phys_addr_t base1, phys_addr_t size1,
>  	return 0;
>  }
>  
> -static long memblock_regions_adjacent(struct memblock_type *type,
> +static long __init_memblock memblock_regions_adjacent(struct memblock_type *type,
>  				 unsigned long r1, unsigned long r2)
>  {
>  	phys_addr_t base1 = type->regions[r1].base;
> @@ -80,7 +80,7 @@ static long memblock_regions_adjacent(struct memblock_type *type,
>  	return memblock_addrs_adjacent(base1, size1, base2, size2);
>  }
>  
> -long memblock_overlaps_region(struct memblock_type *type, phys_addr_t base, phys_addr_t size)
> +long __init_memblock memblock_overlaps_region(struct memblock_type *type, phys_addr_t base, phys_addr_t size)
>  {
>  	unsigned long i;
>  
> @@ -156,7 +156,7 @@ static phys_addr_t __init memblock_find_base(phys_addr_t size, phys_addr_t align
>  	return MEMBLOCK_ERROR;
>  }
>  
> -static void memblock_remove_region(struct memblock_type *type, unsigned long r)
> +static void __init_memblock memblock_remove_region(struct memblock_type *type, unsigned long r)
>  {
>  	unsigned long i;
>  
> @@ -168,7 +168,7 @@ static void memblock_remove_region(struct memblock_type *type, unsigned long r)
>  }
>  
>  /* Assumption: base addr of region 1 < base addr of region 2 */
> -static void memblock_coalesce_regions(struct memblock_type *type,
> +static void __init_memblock memblock_coalesce_regions(struct memblock_type *type,
>  		unsigned long r1, unsigned long r2)
>  {
>  	type->regions[r1].size += type->regions[r2].size;
> @@ -178,7 +178,7 @@ static void memblock_coalesce_regions(struct memblock_type *type,
>  /* Defined below but needed now */
>  static long memblock_add_region(struct memblock_type *type, phys_addr_t base, phys_addr_t size);
>  
> -static int memblock_double_array(struct memblock_type *type)
> +static int __init_memblock memblock_double_array(struct memblock_type *type)
>  {
>  	struct memblock_region *new_array, *old_array;
>  	phys_addr_t old_size, new_size, addr;
> @@ -249,13 +249,13 @@ static int memblock_double_array(struct memblock_type *type)
>  	return 0;
>  }
>  
> -extern int __weak memblock_memory_can_coalesce(phys_addr_t addr1, phys_addr_t size1,
> +extern int __init_memblock __weak memblock_memory_can_coalesce(phys_addr_t addr1, phys_addr_t size1,
>  					  phys_addr_t addr2, phys_addr_t size2)
>  {
>  	return 1;
>  }
>  
> -static long memblock_add_region(struct memblock_type *type, phys_addr_t base, phys_addr_t size)
> +static long __init_memblock memblock_add_region(struct memblock_type *type, phys_addr_t base, phys_addr_t size)
>  {
>  	unsigned long coalesced = 0;
>  	long adjacent, i;
> @@ -342,13 +342,13 @@ static long memblock_add_region(struct memblock_type *type, phys_addr_t base, ph
>  	return 0;
>  }
>  
> -long memblock_add(phys_addr_t base, phys_addr_t size)
> +long __init_memblock memblock_add(phys_addr_t base, phys_addr_t size)
>  {
>  	return memblock_add_region(&memblock.memory, base, size);
>  
>  }
>  
> -static long __memblock_remove(struct memblock_type *type, phys_addr_t base, phys_addr_t size)
> +static long __init_memblock __memblock_remove(struct memblock_type *type, phys_addr_t base, phys_addr_t size)
>  {
>  	phys_addr_t rgnbegin, rgnend;
>  	phys_addr_t end = base + size;
> @@ -396,7 +396,7 @@ static long __memblock_remove(struct memblock_type *type, phys_addr_t base, phys
>  	return memblock_add_region(type, end, rgnend - end);
>  }
>  
> -long memblock_remove(phys_addr_t base, phys_addr_t size)
> +long __init_memblock memblock_remove(phys_addr_t base, phys_addr_t size)
>  {
>  	return __memblock_remove(&memblock.memory, base, size);
>  }
> @@ -562,7 +562,7 @@ phys_addr_t __init memblock_phys_mem_size(void)
>  	return memblock.memory_size;
>  }
>  
> -phys_addr_t memblock_end_of_DRAM(void)
> +phys_addr_t __init_memblock memblock_end_of_DRAM(void)
>  {
>  	int idx = memblock.memory.cnt - 1;
>  
> @@ -623,7 +623,7 @@ int __init memblock_is_reserved(phys_addr_t addr)
>  	return 0;
>  }
>  
> -int memblock_is_region_reserved(phys_addr_t base, phys_addr_t size)
> +int __init_memblock memblock_is_region_reserved(phys_addr_t base, phys_addr_t size)
>  {
>  	return memblock_overlaps_region(&memblock.reserved, base, size);
>  }
> @@ -634,7 +634,7 @@ void __init memblock_set_current_limit(phys_addr_t limit)
>  	memblock.current_limit = limit;
>  }
>  
> -static void memblock_dump(struct memblock_type *region, char *name)
> +static void __init_memblock memblock_dump(struct memblock_type *region, char *name)
>  {
>  	unsigned long long base, size;
>  	int i;
> @@ -650,7 +650,7 @@ static void memblock_dump(struct memblock_type *region, char *name)
>  	}
>  }
>  
> -void memblock_dump_all(void)
> +void __init_memblock memblock_dump_all(void)
>  {
>  	if (!memblock_debug)
>  		return;
> @@ -716,7 +716,7 @@ static int __init early_memblock(char *p)
>  }
>  early_param("memblock", early_memblock);
>  
> -#ifdef CONFIG_DEBUG_FS
> +#if defined(CONFIG_DEBUG_FS) && !defined(ARCH_DISCARD_MEMBLOCK)
>  
>  static int memblock_debug_show(struct seq_file *m, void *private)
>  {


