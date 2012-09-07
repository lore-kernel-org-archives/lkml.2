Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755468Ab2IGQe3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 12:34:29 -0400
Received: from service87.mimecast.com ([91.220.42.44]:34328 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751977Ab2IGQ1x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 12:27:53 -0400
From: Catalin Marinas <catalin.marinas@arm.com>
To: linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH v3 09/31] arm64: Cache maintenance routines
Date: Fri,  7 Sep 2012 17:26:44 +0100
Message-Id: <1347035226-18649-10-git-send-email-catalin.marinas@arm.com>
X-Mailer: git-send-email 1.7.9.111.gf3fb0
In-Reply-To: <1347035226-18649-1-git-send-email-catalin.marinas@arm.com>
References: <1347035226-18649-1-git-send-email-catalin.marinas@arm.com>
X-OriginalArrivalTime: 07 Sep 2012 16:27:51.0113 (UTC) FILETIME=[B9971B90:01CD8D15]
X-MC-Unique: 112090717275114301
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id q87GYhWH008447

The patch adds functionality required for cache maintenance. The AArch64
architecture mandates non-aliasing VIPT or PIPT D-cache and VIPT (may
have aliases) or ASID-tagged VIVT I-cache. Cache maintenance operations
are automatically broadcast in hardware between CPUs.

Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Acked-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm64/include/asm/cache.h      |   32 +++++
 arch/arm64/include/asm/cacheflush.h |  168 +++++++++++++++++++++++
 arch/arm64/include/asm/cachetype.h  |   48 +++++++
 arch/arm64/mm/cache.S               |  251 +++++++++++++++++++++++++++++++++++
 arch/arm64/mm/flush.c               |  138 +++++++++++++++++++
 5 files changed, 637 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm64/include/asm/cache.h
 create mode 100644 arch/arm64/include/asm/cacheflush.h
 create mode 100644 arch/arm64/include/asm/cachetype.h
 create mode 100644 arch/arm64/mm/cache.S
 create mode 100644 arch/arm64/mm/flush.c

diff --git a/arch/arm64/include/asm/cache.h b/arch/arm64/include/asm/cache.h
new file mode 100644
index 0000000..390308a
--- /dev/null
+++ b/arch/arm64/include/asm/cache.h
@@ -0,0 +1,32 @@
+/*
+ * Copyright (C) 2012 ARM Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+#ifndef __ASM_CACHE_H
+#define __ASM_CACHE_H
+
+#define L1_CACHE_SHIFT		6
+#define L1_CACHE_BYTES		(1 << L1_CACHE_SHIFT)
+
+/*
+ * Memory returned by kmalloc() may be used for DMA, so we must make
+ * sure that all such allocations are cache aligned. Otherwise,
+ * unrelated code may cause parts of the buffer to be read into the
+ * cache before the transfer is done, causing old data to be seen by
+ * the CPU.
+ */
+#define ARCH_DMA_MINALIGN	L1_CACHE_BYTES
+#define ARCH_SLAB_MINALIGN	8
+
+#endif
diff --git a/arch/arm64/include/asm/cacheflush.h b/arch/arm64/include/asm/cacheflush.h
new file mode 100644
index 0000000..0bb9853
--- /dev/null
+++ b/arch/arm64/include/asm/cacheflush.h
@@ -0,0 +1,168 @@
+/*
+ * Based on arch/arm/include/asm/cacheflush.h
+ *
+ * Copyright (C) 1999-2002 Russell King.
+ * Copyright (C) 2012 ARM Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+#ifndef __ASM_CACHEFLUSH_H
+#define __ASM_CACHEFLUSH_H
+
+#include <linux/mm.h>
+
+/*
+ * This flag is used to indicate that the page pointed to by a pte is clean
+ * and does not require cleaning before returning it to the user.
+ */
+#define PG_dcache_clean PG_arch_1
+
+/*
+ *	MM Cache Management
+ *	===================
+ *
+ *	The arch/arm64/mm/cache.S implements these methods.
+ *
+ *	Start addresses are inclusive and end addresses are exclusive; start
+ *	addresses should be rounded down, end addresses up.
+ *
+ *	See Documentation/cachetlb.txt for more information. Please note that
+ *	the implementation assumes non-aliasing VIPT D-cache and (aliasing)
+ *	VIPT or ASID-tagged VIVT I-cache.
+ *
+ *	flush_cache_all()
+ *
+ *		Unconditionally clean and invalidate the entire cache.
+ *
+ *	flush_cache_mm(mm)
+ *
+ *		Clean and invalidate all user space cache entries
+ *		before a change of page tables.
+ *
+ *	flush_icache_range(start, end)
+ *
+ *		Ensure coherency between the I-cache and the D-cache in the
+ *		region described by start, end.
+ *		- start  - virtual start address
+ *		- end    - virtual end address
+ *
+ *	__flush_cache_user_range(start, end)
+ *
+ *		Ensure coherency between the I-cache and the D-cache in the
+ *		region described by start, end.
+ *		- start  - virtual start address
+ *		- end    - virtual end address
+ *
+ *	__flush_dcache_area(kaddr, size)
+ *
+ *		Ensure that the data held in page is written back.
+ *		- kaddr  - page address
+ *		- size   - region size
+ */
+extern void flush_cache_all(void);
+extern void flush_cache_mm(struct mm_struct *mm);
+extern void flush_cache_range(struct vm_area_struct *vma, unsigned long start, unsigned long end);
+extern void flush_cache_page(struct vm_area_struct *vma, unsigned long user_addr, unsigned long pfn);
+extern void flush_icache_range(unsigned long start, unsigned long end);
+extern void __flush_dcache_area(void *addr, size_t len);
+extern void __flush_cache_user_range(unsigned long start, unsigned long end);
+
+/*
+ * These are private to the dma-mapping API.  Do not use directly.
+ * Their sole purpose is to ensure that data held in the cache
+ * is visible to DMA, or data written by DMA to system memory is
+ * visible to the CPU.
+ */
+extern void dmac_map_area(const void *, size_t, int);
+extern void dmac_unmap_area(const void *, size_t, int);
+extern void dmac_flush_range(const void *, const void *);
+
+/*
+ * Copy user data from/to a page which is mapped into a different
+ * processes address space.  Really, we want to allow our "user
+ * space" model to handle this.
+ */
+extern void copy_to_user_page(struct vm_area_struct *, struct page *,
+	unsigned long, void *, const void *, unsigned long);
+#define copy_from_user_page(vma, page, vaddr, dst, src, len) \
+	do {							\
+		memcpy(dst, src, len);				\
+	} while (0)
+
+#define flush_cache_dup_mm(mm) flush_cache_mm(mm)
+
+/*
+ * flush_dcache_page is used when the kernel has written to the page
+ * cache page at virtual address page->virtual.
+ *
+ * If this page isn't mapped (ie, page_mapping == NULL), or it might
+ * have userspace mappings, then we _must_ always clean + invalidate
+ * the dcache entries associated with the kernel mapping.
+ *
+ * Otherwise we can defer the operation, and clean the cache when we are
+ * about to change to user space.  This is the same method as used on SPARC64.
+ * See update_mmu_cache for the user space part.
+ */
+#define ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE 1
+extern void flush_dcache_page(struct page *);
+
+static inline void __flush_icache_all(void)
+{
+	asm("ic	ialluis");
+}
+
+#define ARCH_HAS_FLUSH_ANON_PAGE
+static inline void flush_anon_page(struct vm_area_struct *vma,
+			 struct page *page, unsigned long vmaddr)
+{
+	extern void __flush_anon_page(struct vm_area_struct *vma,
+				struct page *, unsigned long);
+	if (PageAnon(page))
+		__flush_anon_page(vma, page, vmaddr);
+}
+
+#define flush_dcache_mmap_lock(mapping) \
+	spin_lock_irq(&(mapping)->tree_lock)
+#define flush_dcache_mmap_unlock(mapping) \
+	spin_unlock_irq(&(mapping)->tree_lock)
+
+#define flush_icache_user_range(vma,page,addr,len) \
+	flush_dcache_page(page)
+
+/*
+ * We don't appear to need to do anything here.  In fact, if we did, we'd
+ * duplicate cache flushing elsewhere performed by flush_dcache_page().
+ */
+#define flush_icache_page(vma,page)	do { } while (0)
+
+/*
+ * flush_cache_vmap() is used when creating mappings (eg, via vmap,
+ * vmalloc, ioremap etc) in kernel space for pages.  On non-VIPT
+ * caches, since the direct-mappings of these pages may contain cached
+ * data, we need to do a full cache flush to ensure that writebacks
+ * don't corrupt data placed into these pages via the new mappings.
+ */
+static inline void flush_cache_vmap(unsigned long start, unsigned long end)
+{
+	/*
+	 * set_pte_at() called from vmap_pte_range() does not
+	 * have a DSB after cleaning the cache line.
+	 */
+	dsb();
+}
+
+static inline void flush_cache_vunmap(unsigned long start, unsigned long end)
+{
+}
+
+#endif
diff --git a/arch/arm64/include/asm/cachetype.h b/arch/arm64/include/asm/cachetype.h
new file mode 100644
index 0000000..85f5f51
--- /dev/null
+++ b/arch/arm64/include/asm/cachetype.h
@@ -0,0 +1,48 @@
+/*
+ * Copyright (C) 2012 ARM Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+#ifndef __ASM_CACHETYPE_H
+#define __ASM_CACHETYPE_H
+
+#include <asm/cputype.h>
+
+#define CTR_L1IP_SHIFT		14
+#define CTR_L1IP_MASK		3
+
+#define ICACHE_POLICY_RESERVED	0
+#define ICACHE_POLICY_AIVIVT	1
+#define ICACHE_POLICY_VIPT	2
+#define ICACHE_POLICY_PIPT	3
+
+static inline u32 icache_policy(void)
+{
+	return (read_cpuid_cachetype() >> CTR_L1IP_SHIFT) & CTR_L1IP_MASK;
+}
+
+/*
+ * Whilst the D-side always behaves as PIPT on AArch64, aliasing is
+ * permitted in the I-cache.
+ */
+static inline int icache_is_aliasing(void)
+{
+	return icache_policy() != ICACHE_POLICY_PIPT;
+}
+
+static inline int icache_is_aivivt(void)
+{
+	return icache_policy() == ICACHE_POLICY_AIVIVT;
+}
+
+#endif	/* __ASM_CACHETYPE_H */
diff --git a/arch/arm64/mm/cache.S b/arch/arm64/mm/cache.S
new file mode 100644
index 0000000..3df0aa7
--- /dev/null
+++ b/arch/arm64/mm/cache.S
@@ -0,0 +1,251 @@
+/*
+ * Cache maintenance
+ *
+ * Copyright (C) 2001 Deep Blue Solutions Ltd.
+ * Copyright (C) 2012 ARM Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include <linux/linkage.h>
+#include <linux/init.h>
+#include <asm/assembler.h>
+
+#include "proc-macros.S"
+
+/*
+ *	__flush_dcache_all()
+ *
+ *	Flush the whole D-cache.
+ *
+ *	Corrupted registers: x0-x7, x9-x11
+ */
+ENTRY(__flush_dcache_all)
+	dsb	sy				// ensure ordering with previous memory accesses
+	mrs	x0, clidr_el1			// read clidr
+	and	x3, x0, #0x7000000		// extract loc from clidr
+	lsr	x3, x3, #23			// left align loc bit field
+	cbz	x3, finished			// if loc is 0, then no need to clean
+	mov	x10, #0				// start clean at cache level 0
+loop1:
+	add	x2, x10, x10, lsr #1		// work out 3x current cache level
+	lsr	x1, x0, x2			// extract cache type bits from clidr
+	and	x1, x1, #7			// mask of the bits for current cache only
+	cmp	x1, #2				// see what cache we have at this level
+	b.lt	skip				// skip if no cache, or just i-cache
+	save_and_disable_irqs x9		// make CSSELR and CCSIDR access atomic
+	msr	csselr_el1, x10			// select current cache level in csselr
+	isb					// isb to sych the new cssr&csidr
+	mrs	x1, ccsidr_el1			// read the new ccsidr
+	restore_irqs x9
+	and	x2, x1, #7			// extract the length of the cache lines
+	add	x2, x2, #4			// add 4 (line length offset)
+	mov	x4, #0x3ff
+	and	x4, x4, x1, lsr #3		// find maximum number on the way size
+	clz	x5, x4				// find bit position of way size increment
+	mov	x7, #0x7fff
+	and	x7, x7, x1, lsr #13		// extract max number of the index size
+loop2:
+	mov	x9, x4				// create working copy of max way size
+loop3:
+	lsl	x6, x9, x5
+	orr	x11, x10, x6			// factor way and cache number into x11
+	lsl	x6, x7, x2
+	orr	x11, x11, x6			// factor index number into x11
+	dc	cisw, x11			// clean & invalidate by set/way
+	subs	x9, x9, #1			// decrement the way
+	b.ge	loop3
+	subs	x7, x7, #1			// decrement the index
+	b.ge	loop2
+skip:
+	add	x10, x10, #2			// increment cache number
+	cmp	x3, x10
+	b.gt	loop1
+finished:
+	mov	x10, #0				// swith back to cache level 0
+	msr	csselr_el1, x10			// select current cache level in csselr
+	dsb	sy
+	isb
+	ret
+ENDPROC(__flush_dcache_all)
+
+/*
+ *	flush_cache_all()
+ *
+ *	Flush the entire cache system.  The data cache flush is now achieved
+ *	using atomic clean / invalidates working outwards from L1 cache. This
+ *	is done using Set/Way based cache maintainance instructions.  The
+ *	instruction cache can still be invalidated back to the point of
+ *	unification in a single instruction.
+ */
+ENTRY(flush_cache_all)
+	mov	x12, lr
+	bl	__flush_dcache_all
+	mov	x0, #0
+	ic	ialluis				// I+BTB cache invalidate
+	ret	x12
+ENDPROC(flush_cache_all)
+
+/*
+ *	flush_icache_range(start,end)
+ *
+ *	Ensure that the I and D caches are coherent within specified region.
+ *	This is typically used when code has been written to a memory region,
+ *	and will be executed.
+ *
+ *	- start   - virtual start address of region
+ *	- end     - virtual end address of region
+ */
+ENTRY(flush_icache_range)
+	/* FALLTHROUGH */
+
+/*
+ *	__flush_cache_user_range(start,end)
+ *
+ *	Ensure that the I and D caches are coherent within specified region.
+ *	This is typically used when code has been written to a memory region,
+ *	and will be executed.
+ *
+ *	- start   - virtual start address of region
+ *	- end     - virtual end address of region
+ */
+ENTRY(__flush_cache_user_range)
+	dcache_line_size x2, x3
+	sub	x3, x2, #1
+	bic	x4, x0, x3
+1:
+USER(9f, dc	cvau, x4	)		// clean D line to PoU
+	add	x4, x4, x2
+	cmp	x4, x1
+	b.lo	1b
+	dsb	sy
+
+	icache_line_size x2, x3
+	sub	x3, x2, #1
+	bic	x4, x0, x3
+1:
+USER(9f, ic	ivau, x4	)		// invalidate I line PoU
+	add	x4, x4, x2
+	cmp	x4, x1
+	b.lo	1b
+9:						// ignore any faulting cache operation
+	dsb	sy
+	isb
+	ret
+ENDPROC(flush_icache_range)
+ENDPROC(__flush_cache_user_range)
+
+/*
+ *	__flush_kern_dcache_page(kaddr)
+ *
+ *	Ensure that the data held in the page kaddr is written back to the
+ *	page in question.
+ *
+ *	- kaddr   - kernel address
+ *	- size    - size in question
+ */
+ENTRY(__flush_dcache_area)
+	dcache_line_size x2, x3
+	add	x1, x0, x1
+	sub	x3, x2, #1
+	bic	x0, x0, x3
+1:	dc	civac, x0			// clean & invalidate D line / unified line
+	add	x0, x0, x2
+	cmp	x0, x1
+	b.lo	1b
+	dsb	sy
+	ret
+ENDPROC(__flush_dcache_area)
+
+/*
+ *	dmac_inv_range(start,end)
+ *
+ *	Invalidate the data cache within the specified region; we will be
+ *	performing a DMA operation in this region and we want to purge old
+ *	data in the cache.
+ *
+ *	- start   - virtual start address of region
+ *	- end     - virtual end address of region
+ */
+ENTRY(dmac_inv_range)
+	dcache_line_size x2, x3
+	sub	x3, x2, #1
+	bic	x0, x0, x3
+	bic	x1, x1, x3
+1:	dc	ivac, x0			// invalidate D / U line
+	add	x0, x0, x2
+	cmp	x0, x1
+	b.lo	1b
+	dsb	sy
+	ret
+ENDPROC(dmac_inv_range)
+
+/*
+ *	dmac_clean_range(start,end)
+ *	- start   - virtual start address of region
+ *	- end     - virtual end address of region
+ */
+ENTRY(dmac_clean_range)
+	dcache_line_size x2, x3
+	sub	x3, x2, #1
+	bic	x0, x0, x3
+1:	dc	cvac, x0			// clean D / U line
+	add	x0, x0, x2
+	cmp	x0, x1
+	b.lo	1b
+	dsb	sy
+	ret
+ENDPROC(dmac_clean_range)
+
+/*
+ *	dmac_flush_range(start,end)
+ *	- start   - virtual start address of region
+ *	- end     - virtual end address of region
+ */
+ENTRY(dmac_flush_range)
+	dcache_line_size x2, x3
+	sub	x3, x2, #1
+	bic	x0, x0, x3
+1:	dc	civac, x0			// clean & invalidate D / U line
+	add	x0, x0, x2
+	cmp	x0, x1
+	b.lo	1b
+	dsb	sy
+	ret
+ENDPROC(dmac_flush_range)
+
+/*
+ *	dmac_map_area(start, size, dir)
+ *	- start	- kernel virtual start address
+ *	- size	- size of region
+ *	- dir	- DMA direction
+ */
+ENTRY(dmac_map_area)
+	add	x1, x1, x0
+	cmp	x2, #DMA_FROM_DEVICE
+	b.eq	dmac_inv_range
+	b	dmac_clean_range
+ENDPROC(dmac_map_area)
+
+/*
+ *	dmac_unmap_area(start, size, dir)
+ *	- start	- kernel virtual start address
+ *	- size	- size of region
+ *	- dir	- DMA direction
+ */
+ENTRY(dmac_unmap_area)
+	add	x1, x1, x0
+	cmp	x2, #DMA_TO_DEVICE
+	b.ne	dmac_inv_range
+	ret
+ENDPROC(dmac_unmap_area)
diff --git a/arch/arm64/mm/flush.c b/arch/arm64/mm/flush.c
new file mode 100644
index 0000000..6138d86
--- /dev/null
+++ b/arch/arm64/mm/flush.c
@@ -0,0 +1,138 @@
+/*
+ * Based on arch/arm/mm/flush.c
+ *
+ * Copyright (C) 1995-2002 Russell King
+ * Copyright (C) 2012 ARM Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include <linux/export.h>
+#include <linux/mm.h>
+#include <linux/pagemap.h>
+
+#include <asm/cacheflush.h>
+#include <asm/cachetype.h>
+#include <asm/tlbflush.h>
+
+#include "mm.h"
+
+void flush_cache_mm(struct mm_struct *mm)
+{
+}
+
+void flush_cache_range(struct vm_area_struct *vma, unsigned long start,
+		       unsigned long end)
+{
+	if (vma->vm_flags & VM_EXEC)
+		__flush_icache_all();
+}
+
+void flush_cache_page(struct vm_area_struct *vma, unsigned long user_addr,
+		      unsigned long pfn)
+{
+}
+
+static void flush_ptrace_access(struct vm_area_struct *vma, struct page *page,
+				unsigned long uaddr, void *kaddr,
+				unsigned long len)
+{
+	if (vma->vm_flags & VM_EXEC) {
+		unsigned long addr = (unsigned long)kaddr;
+		if (icache_is_aliasing()) {
+			__flush_dcache_area(kaddr, len);
+			__flush_icache_all();
+		} else {
+			flush_icache_range(addr, addr + len);
+		}
+	}
+}
+
+/*
+ * Copy user data from/to a page which is mapped into a different processes
+ * address space.  Really, we want to allow our "user space" model to handle
+ * this.
+ *
+ * Note that this code needs to run on the current CPU.
+ */
+void copy_to_user_page(struct vm_area_struct *vma, struct page *page,
+		       unsigned long uaddr, void *dst, const void *src,
+		       unsigned long len)
+{
+#ifdef CONFIG_SMP
+	preempt_disable();
+#endif
+	memcpy(dst, src, len);
+	flush_ptrace_access(vma, page, uaddr, dst, len);
+#ifdef CONFIG_SMP
+	preempt_enable();
+#endif
+}
+
+void __flush_dcache_page(struct address_space *mapping, struct page *page)
+{
+	__flush_dcache_area(page_address(page), PAGE_SIZE);
+}
+
+void __sync_icache_dcache(pte_t pte)
+{
+	unsigned long pfn;
+	struct page *page;
+
+	pfn = pte_pfn(pte);
+	if (!pfn_valid(pfn))
+		return;
+
+	page = pfn_to_page(pfn);
+	if (!test_and_set_bit(PG_dcache_clean, &page->flags))
+		__flush_dcache_page(NULL, page);
+	__flush_icache_all();
+}
+
+/*
+ * Ensure cache coherency between kernel mapping and userspace mapping of this
+ * page.
+ */
+void flush_dcache_page(struct page *page)
+{
+	struct address_space *mapping;
+
+	/*
+	 * The zero page is never written to, so never has any dirty cache
+	 * lines, and therefore never needs to be flushed.
+	 */
+	if (page == ZERO_PAGE(0))
+		return;
+
+	mapping = page_mapping(page);
+
+	if (mapping && !mapping_mapped(mapping))
+		clear_bit(PG_dcache_clean, &page->flags);
+	else {
+		__flush_dcache_page(mapping, page);
+		if (mapping)
+			__flush_icache_all();
+		set_bit(PG_dcache_clean, &page->flags);
+	}
+}
+EXPORT_SYMBOL(flush_dcache_page);
+
+void __flush_anon_page(struct vm_area_struct *vma, struct page *page, unsigned long vmaddr)
+{
+}
+
+/*
+ * Additional functions defined in assembly.
+ */
+EXPORT_SYMBOL(flush_cache_all);
+EXPORT_SYMBOL(flush_icache_range);

