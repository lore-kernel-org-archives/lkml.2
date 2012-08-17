Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964910Ab2HQJ5b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 05:57:31 -0400
Received: from na3sys009aog134.obsmtp.com ([74.125.149.83]:38353 "EHLO
	na3sys009aog134.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756423Ab2HQJ51 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 05:57:27 -0400
Message-ID: <502E1580.70702@ti.com>
Date: Fri, 17 Aug 2012 15:27:20 +0530
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120410 Thunderbird/11.0.1
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>
CC: linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH v2 09/31] arm64: Cache maintenance routines
References: <1344966752-16102-1-git-send-email-catalin.marinas@arm.com> <1344966752-16102-10-git-send-email-catalin.marinas@arm.com>
In-Reply-To: <1344966752-16102-10-git-send-email-catalin.marinas@arm.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 14 August 2012 11:22 PM, Catalin Marinas wrote:
> The patch adds functionality required for cache maintenance. The AArch64
> architecture mandates non-aliasing VIPT or PIPT D-cache and VIPT (may
> have aliases) or ASID-tagged VIVT I-cache. Cache maintenance operations
> are automatically broadcast in hardware between CPUs.
>
> Signed-off-by: Will Deacon<will.deacon@arm.com>
> Signed-off-by: Catalin Marinas<catalin.marinas@arm.com>
> ---
>   arch/arm64/include/asm/cache.h      |   32 ++++
>   arch/arm64/include/asm/cacheflush.h |  209 ++++++++++++++++++++++++++
>   arch/arm64/include/asm/cachetype.h  |   48 ++++++
>   arch/arm64/mm/cache.S               |  279 +++++++++++++++++++++++++++++++++++
>   arch/arm64/mm/flush.c               |  132 +++++++++++++++++
>   5 files changed, 700 insertions(+), 0 deletions(-)
>   create mode 100644 arch/arm64/include/asm/cache.h
>   create mode 100644 arch/arm64/include/asm/cacheflush.h
>   create mode 100644 arch/arm64/include/asm/cachetype.h
>   create mode 100644 arch/arm64/mm/cache.S
>   create mode 100644 arch/arm64/mm/flush.c
>
> diff --git a/arch/arm64/include/asm/cache.h b/arch/arm64/include/asm/cache.h
> new file mode 100644
> index 0000000..390308a
> --- /dev/null
> +++ b/arch/arm64/include/asm/cache.h
> @@ -0,0 +1,32 @@
> +/*
> + * Copyright (C) 2012 ARM Ltd.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program.  If not, see<http://www.gnu.org/licenses/>.
> + */
> +#ifndef __ASM_CACHE_H
> +#define __ASM_CACHE_H
> +
> +#define L1_CACHE_SHIFT		6
> +#define L1_CACHE_BYTES		(1<<  L1_CACHE_SHIFT)
> +
> +/*
> + * Memory returned by kmalloc() may be used for DMA, so we must make
> + * sure that all such allocations are cache aligned. Otherwise,
> + * unrelated code may cause parts of the buffer to be read into the
> + * cache before the transfer is done, causing old data to be seen by
> + * the CPU.
> + */
> +#define ARCH_DMA_MINALIGN	L1_CACHE_BYTES
> +#define ARCH_SLAB_MINALIGN	8
> +
> +#endif
> diff --git a/arch/arm64/include/asm/cacheflush.h b/arch/arm64/include/asm/cacheflush.h
> new file mode 100644
> index 0000000..93b5590
> --- /dev/null
> +++ b/arch/arm64/include/asm/cacheflush.h
> @@ -0,0 +1,209 @@
> +/*
> + * Based on arch/arm/include/asm/cacheflush.h
> + *
> + * Copyright (C) 1999-2002 Russell King.
> + * Copyright (C) 2012 ARM Ltd.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program.  If not, see<http://www.gnu.org/licenses/>.
> + */
> +#ifndef __ASM_CACHEFLUSH_H
> +#define __ASM_CACHEFLUSH_H
> +
> +#include<linux/mm.h>
> +
> +/*
> + * This flag is used to indicate that the page pointed to by a pte is clean
> + * and does not require cleaning before returning it to the user.
> + */
> +#define PG_dcache_clean PG_arch_1
> +
> +/*
> + *	MM Cache Management
> + *	===================
> + *
> + *	The arch/arm/mm/cache-*.S and arch/arm/mm/proc-*.S files
> + *	implement these methods.
> + *
> + *	Start addresses are inclusive and end addresses are exclusive;
> + *	start addresses should be rounded down, end addresses up.
> + *
> + *	See Documentation/cachetlb.txt for more information.
> + *	Please note that the implementation of these, and the required
> + *	effects are cache-type (VIVT/VIPT/PIPT) specific.
> + *
> + *	flush_cache_kern_all()
> + *
> + *		Unconditionally clean and invalidate the entire cache.
> + *
> + *	flush_cache_user_mm(mm)
> + *
> + *		Clean and invalidate all user space cache entries
> + *		before a change of page tables.
> + *
> + *	flush_cache_user_range(start, end, flags)
> + *
> + *		Clean and invalidate a range of cache entries in the
> + *		specified address space before a change of page tables.
> + *		- start - user start address (inclusive, page aligned)
> + *		- end   - user end address   (exclusive, page aligned)
> + *		- flags - vma->vm_flags field
> + *
> + *	coherent_kern_range(start, end)
> + *
> + *		Ensure coherency between the Icache and the Dcache in the
> + *		region described by start, end.  If you have non-snooping
> + *		Harvard caches, you need to implement this function.
> + *		- start  - virtual start address
> + *		- end    - virtual end address
> + *
> + *	coherent_user_range(start, end)
> + *
> + *		Ensure coherency between the Icache and the Dcache in the
> + *		region described by start, end.  If you have non-snooping
> + *		Harvard caches, you need to implement this function.
> + *		- start  - virtual start address
> + *		- end    - virtual end address
> + *
> + *	flush_kern_dcache_area(kaddr, size)
> + *
> + *		Ensure that the data held in page is written back.
> + *		- kaddr  - page address
> + *		- size   - region size
> + *
> + *	DMA Cache Coherency
> + *	===================
> + *
> + *	dma_flush_range(start, end)
> + *
> + *		Clean and invalidate the specified virtual address range.
> + *		- start  - virtual start address
> + *		- end    - virtual end address
> + */
> +extern void __cpuc_flush_kern_all(void);
> +extern void __cpuc_flush_user_all(void);
> +extern void __cpuc_flush_user_range(unsigned long, unsigned long, unsigned int);
> +extern void __cpuc_coherent_kern_range(unsigned long, unsigned long);
> +extern void __cpuc_coherent_user_range(unsigned long, unsigned long);
> +extern void __cpuc_flush_dcache_area(void *, size_t);
> +
> +/*
> + * These are private to the dma-mapping API.  Do not use directly.
> + * Their sole purpose is to ensure that data held in the cache
> + * is visible to DMA, or data written by DMA to system memory is
> + * visible to the CPU.
> + */
> +extern void dmac_map_area(const void *, size_t, int);
> +extern void dmac_unmap_area(const void *, size_t, int);
> +extern void dmac_flush_range(const void *, const void *);
> +
> +/*
> + * Copy user data from/to a page which is mapped into a different
> + * processes address space.  Really, we want to allow our "user
> + * space" model to handle this.
> + */
> +extern void copy_to_user_page(struct vm_area_struct *, struct page *,
> +	unsigned long, void *, const void *, unsigned long);
> +#define copy_from_user_page(vma, page, vaddr, dst, src, len) \
> +	do {							\
> +		memcpy(dst, src, len);				\
> +	} while (0)
> +
> +/*
> + * Convert calls to our calling convention.
> + */
> +#define flush_cache_all()		__cpuc_flush_kern_all()
> +extern void flush_cache_mm(struct mm_struct *mm);
> +extern void flush_cache_range(struct vm_area_struct *vma, unsigned long start, unsigned long end);
> +extern void flush_cache_page(struct vm_area_struct *vma, unsigned long user_addr, unsigned long pfn);
> +
> +#define flush_cache_dup_mm(mm) flush_cache_mm(mm)
> +
> +/*
> + * flush_cache_user_range is used when we want to ensure that the
> + * Harvard caches are synchronised for the user space address range.
> + * This is used for the ARM private sys_cacheflush system call.
> + */
> +#define flush_cache_user_range(start, end) \
> +	__cpuc_coherent_user_range((start)&  PAGE_MASK, PAGE_ALIGN(end))
> +
> +/*
> + * Perform necessary cache operations to ensure that data previously
> + * stored within this range of addresses can be executed by the CPU.
> + */
> +#define flush_icache_range(s,e)		__cpuc_coherent_kern_range(s,e)
> +
> +/*
> + * flush_dcache_page is used when the kernel has written to the page
> + * cache page at virtual address page->virtual.
> + *
> + * If this page isn't mapped (ie, page_mapping == NULL), or it might
> + * have userspace mappings, then we _must_ always clean + invalidate
> + * the dcache entries associated with the kernel mapping.
> + *
> + * Otherwise we can defer the operation, and clean the cache when we are
> + * about to change to user space.  This is the same method as used on SPARC64.
> + * See update_mmu_cache for the user space part.
> + */
> +#define ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE 1
> +extern void flush_dcache_page(struct page *);
> +
> +static inline void __flush_icache_all(void)
> +{
> +	asm("ic	ialluis");
> +}
> +
> +#define ARCH_HAS_FLUSH_ANON_PAGE
> +static inline void flush_anon_page(struct vm_area_struct *vma,
> +			 struct page *page, unsigned long vmaddr)
> +{
> +	extern void __flush_anon_page(struct vm_area_struct *vma,
> +				struct page *, unsigned long);
> +	if (PageAnon(page))
> +		__flush_anon_page(vma, page, vmaddr);
> +}
> +
> +#define flush_dcache_mmap_lock(mapping) \
> +	spin_lock_irq(&(mapping)->tree_lock)
> +#define flush_dcache_mmap_unlock(mapping) \
> +	spin_unlock_irq(&(mapping)->tree_lock)
> +
> +#define flush_icache_user_range(vma,page,addr,len) \
> +	flush_dcache_page(page)
> +
> +/*
> + * We don't appear to need to do anything here.  In fact, if we did, we'd
> + * duplicate cache flushing elsewhere performed by flush_dcache_page().
> + */
> +#define flush_icache_page(vma,page)	do { } while (0)
> +
> +/*
> + * flush_cache_vmap() is used when creating mappings (eg, via vmap,
> + * vmalloc, ioremap etc) in kernel space for pages.  On non-VIPT
> + * caches, since the direct-mappings of these pages may contain cached
> + * data, we need to do a full cache flush to ensure that writebacks
> + * don't corrupt data placed into these pages via the new mappings.
> + */
> +static inline void flush_cache_vmap(unsigned long start, unsigned long end)
> +{
> +	/*
> +	 * set_pte_at() called from vmap_pte_range() does not
> +	 * have a DSB after cleaning the cache line.
> +	 */
> +	dsb();
> +}
> +
> +static inline void flush_cache_vunmap(unsigned long start, unsigned long end)
> +{
> +}
> +
> +#endif
> diff --git a/arch/arm64/include/asm/cachetype.h b/arch/arm64/include/asm/cachetype.h
> new file mode 100644
> index 0000000..85f5f51
> --- /dev/null
> +++ b/arch/arm64/include/asm/cachetype.h
> @@ -0,0 +1,48 @@
> +/*
> + * Copyright (C) 2012 ARM Ltd.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program.  If not, see<http://www.gnu.org/licenses/>.
> + */
> +#ifndef __ASM_CACHETYPE_H
> +#define __ASM_CACHETYPE_H
> +
> +#include<asm/cputype.h>
> +
> +#define CTR_L1IP_SHIFT		14
> +#define CTR_L1IP_MASK		3
> +
> +#define ICACHE_POLICY_RESERVED	0
> +#define ICACHE_POLICY_AIVIVT	1
> +#define ICACHE_POLICY_VIPT	2
> +#define ICACHE_POLICY_PIPT	3
> +
> +static inline u32 icache_policy(void)
> +{
> +	return (read_cpuid_cachetype()>>  CTR_L1IP_SHIFT)&  CTR_L1IP_MASK;
> +}
> +
> +/*
> + * Whilst the D-side always behaves as PIPT on AArch64, aliasing is
> + * permitted in the I-cache.
> + */
> +static inline int icache_is_aliasing(void)
> +{
> +	return icache_policy() != ICACHE_POLICY_PIPT;
> +}
> +
> +static inline int icache_is_aivivt(void)
> +{
> +	return icache_policy() == ICACHE_POLICY_AIVIVT;
> +}
> +
> +#endif	/* __ASM_CACHETYPE_H */
> diff --git a/arch/arm64/mm/cache.S b/arch/arm64/mm/cache.S
> new file mode 100644
> index 0000000..f4efa04
> --- /dev/null
> +++ b/arch/arm64/mm/cache.S
> @@ -0,0 +1,279 @@
> +/*
> + * Cache maintenance
> + *
> + * Copyright (C) 2001 Deep Blue Solutions Ltd.
> + * Copyright (C) 2012 ARM Ltd.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program.  If not, see<http://www.gnu.org/licenses/>.
> + */
> +
> +#include<linux/linkage.h>
> +#include<linux/init.h>
> +#include<asm/assembler.h>
> +
> +#include "proc-macros.S"
> +
> +/*
> + *	__cpuc_flush_dcache_all()
> + *
> + *	Flush the whole D-cache.
> + *
> + *	Corrupted registers: x0-x7, x9-x11
> + */
> +ENTRY(__cpuc_flush_dcache_all)
> +	dsb	sy				// ensure ordering with previous memory accesses
> +	mrs	x0, clidr_el1			// read clidr
> +	and	x3, x0, #0x7000000		// extract loc from clidr
> +	lsr	x3, x3, #23			// left align loc bit field
> +	cbz	x3, finished			// if loc is 0, then no need to clean
> +	mov	x10, #0				// start clean at cache level 0
> +loop1:
> +	add	x2, x10, x10, lsr #1		// work out 3x current cache level
> +	lsr	x1, x0, x2			// extract cache type bits from clidr
> +	and	x1, x1, #7			// mask of the bits for current cache only
> +	cmp	x1, #2				// see what cache we have at this level
> +	b.lt	skip				// skip if no cache, or just i-cache
> +	save_and_disable_irqs x9		// make CSSELR and CCSIDR access atomic
> +	msr	csselr_el1, x10			// select current cache level in csselr
> +	isb					// isb to sych the new cssr&csidr
> +	mrs	x1, ccsidr_el1			// read the new ccsidr
> +	restore_irqs x9
> +	and	x2, x1, #7			// extract the length of the cache lines
> +	add	x2, x2, #4			// add 4 (line length offset)
> +	mov	x4, #0x3ff
> +	and	x4, x4, x1, lsr #3		// find maximum number on the way size
> +	clz	x5, x4				// find bit position of way size increment
> +	mov	x7, #0x7fff
> +	and	x7, x7, x1, lsr #13		// extract max number of the index size
> +loop2:
> +	mov	x9, x4				// create working copy of max way size
> +loop3:
> +	lsl	x6, x9, x5
> +	orr	x11, x10, x6			// factor way and cache number into x11
> +	lsl	x6, x7, x2
> +	orr	x11, x11, x6			// factor index number into x11
> +	dc	cisw, x11			// clean&  invalidate by set/way
> +	subs	x9, x9, #1			// decrement the way
> +	b.ge	loop3
> +	subs	x7, x7, #1			// decrement the index
> +	b.ge	loop2
> +skip:
> +	add	x10, x10, #2			// increment cache number
> +	cmp	x3, x10
> +	b.gt	loop1
> +finished:
> +	mov	x10, #0				// swith back to cache level 0
> +	msr	csselr_el1, x10			// select current cache level in csselr
> +	dsb	sy
> +	isb
> +	ret
> +ENDPROC(__cpuc_flush_dcache_all)
> +
>
We have discussed the need of cache maintenance by
level kind of API for ARMv7 (A15).

Shouldn't we add such API for arm64 as well ?

Regards
Santosh

