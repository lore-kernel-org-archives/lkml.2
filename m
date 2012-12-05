Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753250Ab2LEQVf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 11:21:35 -0500
Received: from multi.imgtec.com ([194.200.65.239]:56729 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752836Ab2LEQJ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 11:09:26 -0500
From: James Hogan <james.hogan@imgtec.com>
To: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Arnd Bergmann <arnd@arndb.de>, James Hogan <james.hogan@imgtec.com>
Subject: [PATCH v2 13/44] metag: Cache/TLB handling
Date: Wed, 5 Dec 2012 16:08:31 +0000
Message-ID: <1354723742-6195-14-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1354723742-6195-1-git-send-email-james.hogan@imgtec.com>
References: <1354723742-6195-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
X-SEF-Processed: 7_3_0_01181__2012_12_05_16_09_19
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add cache and TLB handling code for metag, including the required
callbacks used by MM switches and DMA operations. Caches can be
partitioned between the hardware threads and the global space, however
this is usually configured by the bootloader so Linux doesn't make any
changes to this configuration. TLBs aren't configurable, so only need
consideration to flush them.

On Meta1 the L1 cache was VIVT which required a full flush on MM switch.
Meta2 has a VIPT L1 cache so it doesn't require the full flush on MM
switch. Meta2 can also have a writeback L2 with hardware prefetch which
requires some special handling. Support is optional, and the L2 can be
detected and initialised by Linux.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
---
 arch/metag/include/asm/cache.h      |   23 +++
 arch/metag/include/asm/cacheflush.h |  228 +++++++++++++++++++++++++++++++
 arch/metag/include/asm/l2cache.h    |  258 +++++++++++++++++++++++++++++++++++
 arch/metag/include/asm/tlb.h        |   36 +++++
 arch/metag/include/asm/tlbflush.h   |   77 +++++++++++
 arch/metag/mm/l2cache.c             |  192 ++++++++++++++++++++++++++
 6 files changed, 814 insertions(+), 0 deletions(-)
 create mode 100644 arch/metag/include/asm/cache.h
 create mode 100644 arch/metag/include/asm/cacheflush.h
 create mode 100644 arch/metag/include/asm/l2cache.h
 create mode 100644 arch/metag/include/asm/tlb.h
 create mode 100644 arch/metag/include/asm/tlbflush.h
 create mode 100644 arch/metag/mm/l2cache.c

diff --git a/arch/metag/include/asm/cache.h b/arch/metag/include/asm/cache.h
new file mode 100644
index 0000000..a43b650
--- /dev/null
+++ b/arch/metag/include/asm/cache.h
@@ -0,0 +1,23 @@
+#ifndef __ASM_METAG_CACHE_H
+#define __ASM_METAG_CACHE_H
+
+/* L1 cache line size (64 bytes) */
+#define L1_CACHE_SHIFT		6
+#define L1_CACHE_BYTES		(1 << L1_CACHE_SHIFT)
+
+/* Meta requires large data items to be 8 byte aligned. */
+#define ARCH_SLAB_MINALIGN	8
+
+/*
+ * With an L2 cache, we may invalidate dirty lines, so we need to ensure DMA
+ * buffers have cache line alignment.
+ */
+#ifdef CONFIG_METAG_L2C
+#define ARCH_DMA_MINALIGN	L1_CACHE_BYTES
+#else
+#define ARCH_DMA_MINALIGN	8
+#endif
+
+#define __read_mostly __attribute__((__section__(".data..read_mostly")))
+
+#endif
diff --git a/arch/metag/include/asm/cacheflush.h b/arch/metag/include/asm/cacheflush.h
new file mode 100644
index 0000000..0159145
--- /dev/null
+++ b/arch/metag/include/asm/cacheflush.h
@@ -0,0 +1,228 @@
+#ifndef _METAG_CACHEFLUSH_H
+#define _METAG_CACHEFLUSH_H
+
+#include <linux/mm.h>
+#include <linux/sched.h>
+#include <linux/io.h>
+
+#include <asm/l2cache.h>
+#include <asm/metag_isa.h>
+#include <asm/metag_mem.h>
+#include <asm/tbx.h>
+
+/* TBX optimizes large (>= 4k) flushes into a full flush. */
+#define CACHE_FLUSH_MAX (4*1024)
+
+#ifdef CONFIG_METAG_META12
+
+/* Write through, virtually tagged, split I/D cache. */
+
+static inline void __flush_cache_all(void)
+{
+	__TBICodeCacheFlush((void *) PAGE_OFFSET, CACHE_FLUSH_MAX);
+	__TBIDataCacheFlush((void *) PAGE_OFFSET, CACHE_FLUSH_MAX);
+}
+
+#define flush_cache_all() __flush_cache_all()
+
+/* flush the entire user address space referenced in this mm structure */
+static inline void flush_cache_mm(struct mm_struct *mm)
+{
+	if (mm == current->mm)
+		__flush_cache_all();
+}
+
+#define flush_cache_dup_mm(mm) flush_cache_mm(mm)
+
+/* flush a range of addresses from this mm */
+static inline void flush_cache_range(struct vm_area_struct *vma,
+				     unsigned long start, unsigned long end)
+{
+	flush_cache_mm(vma->vm_mm);
+}
+
+static inline void flush_cache_page(struct vm_area_struct *vma,
+				    unsigned long vmaddr, unsigned long pfn)
+{
+	flush_cache_mm(vma->vm_mm);
+}
+
+#define ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE	1
+static inline void flush_dcache_page(struct page *page)
+{
+	__TBIDataCacheFlush((void *) PAGE_OFFSET, CACHE_FLUSH_MAX);
+}
+
+#define flush_dcache_mmap_lock(mapping)		do { } while (0)
+#define flush_dcache_mmap_unlock(mapping)	do { } while (0)
+
+static inline void flush_icache_page(struct vm_area_struct *vma,
+				     struct page *page)
+{
+	__TBICodeCacheFlush(page_to_virt(page), PAGE_SIZE);
+}
+
+static inline void flush_cache_vmap(unsigned long start, unsigned long end)
+{
+	__TBIDataCacheFlush((void *) PAGE_OFFSET, CACHE_FLUSH_MAX);
+}
+
+static inline void flush_cache_vunmap(unsigned long start, unsigned long end)
+{
+	__TBIDataCacheFlush((void *) PAGE_OFFSET, CACHE_FLUSH_MAX);
+}
+
+#else
+
+/* Write through, physically tagged, split I/D cache. */
+
+#define flush_cache_all()			do { } while (0)
+#define flush_cache_mm(mm)			do { } while (0)
+#define flush_cache_dup_mm(mm)			do { } while (0)
+#define flush_cache_range(vma, start, end)	do { } while (0)
+#define flush_cache_page(vma, vmaddr, pfn)	do { } while (0)
+#define flush_dcache_mmap_lock(mapping)		do { } while (0)
+#define flush_dcache_mmap_unlock(mapping)	do { } while (0)
+#define flush_icache_page(vma, pg)		do { } while (0)
+#define flush_cache_vmap(start, end)		do { } while (0)
+#define flush_cache_vunmap(start, end)		do { } while (0)
+
+#define ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE	1
+static inline void flush_dcache_page(struct page *page)
+{
+	/* FIXME: We can do better than this. All we are trying to do is
+	 * make the i-cache coherent, we should use the PG_arch_1 bit like
+	 * e.g. powerpc.
+	 */
+#ifdef CONFIG_SMP
+	metag_out32(1, SYSC_ICACHE_FLUSH);
+#else
+	__TBICodeCacheFlush((void *) PAGE_OFFSET, CACHE_FLUSH_MAX);
+#endif
+}
+
+#endif
+
+/* Push n pages at kernel virtual address and clear the icache */
+static inline void flush_icache_range(unsigned long address,
+				      unsigned long endaddr)
+{
+#ifdef CONFIG_SMP
+	metag_out32(1, SYSC_ICACHE_FLUSH);
+#else
+	__TBICodeCacheFlush((void *) address, endaddr - address);
+#endif
+}
+
+static inline void flush_cache_sigtramp(unsigned long addr, int size)
+{
+	/*
+	 * Flush the icache in case there was previously some code
+	 * fetched from this address, perhaps a previous sigtramp.
+	 *
+	 * We don't need to flush the dcache, it's write through and
+	 * we just wrote the sigtramp code through it.
+	 */
+#ifdef CONFIG_SMP
+	metag_out32(1, SYSC_ICACHE_FLUSH);
+#else
+	__TBICodeCacheFlush((void *) addr, size);
+#endif
+}
+
+#ifdef CONFIG_METAG_L2C
+/* Perform a certain CACHEW op on each cache line in a range */
+static inline void cachew_region_op(void *start, unsigned long size,
+				    unsigned int op)
+{
+	unsigned long offset = (unsigned long)start & 0x3f;
+	int i;
+	if (offset) {
+		size += offset;
+		start -= offset;
+	}
+	i = (size - 1) >> 6;
+	do {
+		TBIXCACHE_WD(start, op);
+		start += 0x40;
+	} while (i--);
+}
+
+/* prevent write fence and flushbacks being reordered in L2 */
+static inline void l2c_fence_flush(void *addr)
+{
+	/*
+	 * Synchronise by reading back and re-flushing.
+	 * It is assumed this access will miss, as the caller should have just
+	 * flushed the cache line.
+	 */
+	(void)(volatile u8 *)addr;
+	TBIXCACHE_WD((unsigned long)addr & -0x40, CACHEW_FLUSH_L1D_L2);
+}
+
+/* prevent write fence and writebacks being reordered in L2 */
+static inline void l2c_fence(void *addr)
+{
+	/*
+	 * A write back has occurred, but not necessarily an invalidate, so the
+	 * readback in l2c_fence_flush() would hit in the cache and have no
+	 * effect. Therefore fully flush the line first.
+	 */
+	TBIXCACHE_WD((unsigned long)addr & -0x40, CACHEW_FLUSH_L1D_L2);
+	l2c_fence_flush(addr);
+}
+
+/* Used to keep memory consistent when doing DMA. */
+static inline void flush_dcache_region(void *start, unsigned long size)
+{
+	/* TBIDataCacheFlush won't flush L2 cache lines if size >= 4096 */
+	if (meta_l2c_is_enabled()) {
+		cachew_region_op(start, size, CACHEW_FLUSH_L1D_L2);
+		if (meta_l2c_is_writeback())
+			l2c_fence_flush(start + size - 1);
+	} else {
+		__TBIDataCacheFlush(start, size);
+	}
+}
+
+/* Write back dirty lines to memory (or do nothing if no writeback caches) */
+static inline void writeback_dcache_region(void *start, unsigned long size)
+{
+	if (meta_l2c_is_enabled() && meta_l2c_is_writeback()) {
+		cachew_region_op(start, size, CACHEW_WRITEBACK_L1D_L2);
+		l2c_fence(start + size - 1);
+	}
+}
+
+/* Invalidate (may also write back if necessary) */
+static inline void invalidate_dcache_region(void *start, unsigned long size)
+{
+	if (meta_l2c_is_enabled())
+		cachew_region_op(start, size, CACHEW_INVALIDATE_L1D_L2);
+	else
+		__TBIDataCacheFlush(start, size);
+}
+#else
+#define flush_dcache_region(s, l)	__TBIDataCacheFlush((s), (l))
+#define writeback_dcache_region(s, l)	do {} while (0)
+#define invalidate_dcache_region(s, l)	flush_dcache_region((s), (l))
+#endif
+
+static inline void copy_to_user_page(struct vm_area_struct *vma,
+				     struct page *page, unsigned long vaddr,
+				     void *dst, const void *src,
+				     unsigned long len)
+{
+	memcpy(dst, src, len);
+	flush_icache_range((unsigned long)dst, (unsigned long)dst + len);
+}
+
+static inline void copy_from_user_page(struct vm_area_struct *vma,
+				       struct page *page, unsigned long vaddr,
+				       void *dst, const void *src,
+				       unsigned long len)
+{
+	memcpy(dst, src, len);
+}
+
+#endif /* _METAG_CACHEFLUSH_H */
diff --git a/arch/metag/include/asm/l2cache.h b/arch/metag/include/asm/l2cache.h
new file mode 100644
index 0000000..522af0f
--- /dev/null
+++ b/arch/metag/include/asm/l2cache.h
@@ -0,0 +1,258 @@
+#ifndef _METAG_L2CACHE_H
+#define _METAG_L2CACHE_H
+
+#ifdef CONFIG_METAG_L2C
+
+#include <asm/io.h>
+#include <asm/lock.h>
+
+/*
+ * Store the last known value of pfenable (we don't want prefetch enabled while
+ * L2 is off).
+ */
+extern int l2c_pfenable;
+
+/* defined in arch/metag/drivers/core-sysfs.c */
+extern struct sysdev_class cache_sysclass;
+
+static inline void wr_fence(void);
+
+/*
+ * Functions for reading of L2 cache configuration.
+ */
+
+/* Get raw L2 config register (CORE_CONFIG3) */
+static inline unsigned int meta_l2c_config(void)
+{
+	const unsigned int *corecfg3 = (const unsigned int *)METAC_CORE_CONFIG3;
+	return *corecfg3;
+}
+
+/* Get whether the L2 is present */
+static inline int meta_l2c_is_present(void)
+{
+	return meta_l2c_config() & METAC_CORECFG3_L2C_HAVE_L2C_BIT;
+}
+
+/* Get whether the L2 is configured for write-back instead of write-through */
+static inline int meta_l2c_is_writeback(void)
+{
+	return meta_l2c_config() & METAC_CORECFG3_L2C_MODE_BIT;
+}
+
+/* Get whether the L2 is unified instead of separated code/data */
+static inline int meta_l2c_is_unified(void)
+{
+	return meta_l2c_config() & METAC_CORECFG3_L2C_UNIFIED_BIT;
+}
+
+/* Get the L2 cache size in bytes */
+static inline unsigned int meta_l2c_size(void)
+{
+	unsigned int size_s;
+	if (!meta_l2c_is_present())
+		return 0;
+	size_s = (meta_l2c_config() & METAC_CORECFG3_L2C_SIZE_BITS)
+			>> METAC_CORECFG3_L2C_SIZE_S;
+	/* L2CSIZE is in KiB */
+	return 1024 << size_s;
+}
+
+/* Get the number of ways in the L2 cache */
+static inline unsigned int meta_l2c_ways(void)
+{
+	unsigned int ways_s;
+	if (!meta_l2c_is_present())
+		return 0;
+	ways_s = (meta_l2c_config() & METAC_CORECFG3_L2C_NUM_WAYS_BITS)
+			>> METAC_CORECFG3_L2C_NUM_WAYS_S;
+	return 0x1 << ways_s;
+}
+
+/* Get the line size of the L2 cache */
+static inline unsigned int meta_l2c_linesize(void)
+{
+	unsigned int line_size;
+	if (!meta_l2c_is_present())
+		return 0;
+	line_size = (meta_l2c_config() & METAC_CORECFG3_L2C_LINE_SIZE_BITS)
+			>> METAC_CORECFG3_L2C_LINE_SIZE_S;
+	switch (line_size) {
+	case METAC_CORECFG3_L2C_LINE_SIZE_64B:
+		return 64;
+	default:
+		return 0;
+	}
+}
+
+/* Get the revision ID of the L2 cache */
+static inline unsigned int meta_l2c_revision(void)
+{
+	return (meta_l2c_config() & METAC_CORECFG3_L2C_REV_ID_BITS)
+			>> METAC_CORECFG3_L2C_REV_ID_S;
+}
+
+
+/*
+ * Start an initialisation of the L2 cachelines and wait for completion.
+ * This should only be done in a LOCK1 or LOCK2 critical section while the L2
+ * is disabled.
+ */
+static inline void _meta_l2c_init(void)
+{
+	metag_out32(SYSC_L2C_INIT_INIT, SYSC_L2C_INIT);
+	while (metag_in32(SYSC_L2C_INIT) == SYSC_L2C_INIT_IN_PROGRESS)
+		/* do nothing */;
+}
+
+/*
+ * Start a writeback of dirty L2 cachelines and wait for completion.
+ * This should only be done in a LOCK1 or LOCK2 critical section.
+ */
+static inline void _meta_l2c_purge(void)
+{
+	metag_out32(SYSC_L2C_PURGE_PURGE, SYSC_L2C_PURGE);
+	while (metag_in32(SYSC_L2C_PURGE) == SYSC_L2C_PURGE_IN_PROGRESS)
+		/* do nothing */;
+}
+
+/* Set whether the L2 cache is enabled. */
+static inline void _meta_l2c_enable(int enabled)
+{
+	unsigned int enable;
+
+	enable = metag_in32(SYSC_L2C_ENABLE);
+	if (enabled)
+		enable |= SYSC_L2C_ENABLE_ENABLE_BIT;
+	else
+		enable &= ~SYSC_L2C_ENABLE_ENABLE_BIT;
+	metag_out32(enable, SYSC_L2C_ENABLE);
+}
+
+/* Set whether the L2 cache prefetch is enabled. */
+static inline void _meta_l2c_pf_enable(int pfenabled)
+{
+	unsigned int enable;
+
+	enable = metag_in32(SYSC_L2C_ENABLE);
+	if (pfenabled)
+		enable |= SYSC_L2C_ENABLE_PFENABLE_BIT;
+	else
+		enable &= ~SYSC_L2C_ENABLE_PFENABLE_BIT;
+	metag_out32(enable, SYSC_L2C_ENABLE);
+}
+
+/* Return whether the L2 cache is enabled */
+static inline int _meta_l2c_is_enabled(void)
+{
+	return metag_in32(SYSC_L2C_ENABLE) & SYSC_L2C_ENABLE_ENABLE_BIT;
+}
+
+/* Return whether the L2 cache prefetch is enabled */
+static inline int _meta_l2c_pf_is_enabled(void)
+{
+	return metag_in32(SYSC_L2C_ENABLE) & SYSC_L2C_ENABLE_PFENABLE_BIT;
+}
+
+
+/* Return whether the L2 cache is enabled */
+static inline int meta_l2c_is_enabled(void)
+{
+	int en;
+
+	/*
+	 * There is no need to lock at the moment, as the enable bit is never
+	 * intermediately changed, so we will never see an intermediate result.
+	 */
+	en = _meta_l2c_is_enabled();
+
+	return en;
+}
+
+/*
+ * Ensure the L2 cache is disabled.
+ * Return whether the L2 was previously disabled.
+ */
+int meta_l2c_disable(void);
+
+/*
+ * Ensure the L2 cache is enabled.
+ * Return whether the L2 was previously enabled.
+ */
+int meta_l2c_enable(void);
+
+/* Return whether the L2 cache prefetch is enabled */
+static inline int meta_l2c_pf_is_enabled(void)
+{
+	return l2c_pfenable;
+}
+
+/*
+ * Set whether the L2 cache prefetch is enabled.
+ * Return whether the L2 prefetch was previously enabled.
+ */
+int meta_l2c_pf_enable(int pfenable);
+
+/*
+ * Flush the L2 cache.
+ * Return 1 if the L2 is disabled.
+ */
+int meta_l2c_flush(void);
+
+/*
+ * Write back all dirty cache lines in the L2 cache.
+ * Return 1 if the L2 is disabled or there isn't any writeback.
+ */
+static inline int meta_l2c_writeback(void)
+{
+	unsigned long flags;
+	int en;
+
+	/* no need to purge if it's not a writeback cache */
+	if (!meta_l2c_is_writeback())
+		return 1;
+
+	/*
+	 * Purge only works if the L2 is enabled, and involves reading back to
+	 * detect completion, so keep this operation atomic with other threads.
+	 */
+	__global_lock1(flags);
+	en = meta_l2c_is_enabled();
+	if (likely(en)) {
+		wr_fence();
+		_meta_l2c_purge();
+	}
+	__global_unlock1(flags);
+
+	return !en;
+}
+
+#else /* CONFIG_METAG_L2C */
+
+#define meta_l2c_config()		0
+#define meta_l2c_is_present()		0
+#define meta_l2c_is_writeback()		0
+#define meta_l2c_is_unified()		0
+#define meta_l2c_size()			0
+#define meta_l2c_ways()			0
+#define meta_l2c_linesize()		0
+#define meta_l2c_revision()		0
+
+#define meta_l2c_is_enabled()		0
+#define _meta_l2c_pf_is_enabled()	0
+#define meta_l2c_pf_is_enabled()	0
+#define meta_l2c_disable()		1
+#define meta_l2c_enable()		0
+#define meta_l2c_pf_enable(X)		0
+static inline int meta_l2c_flush(void)
+{
+	return 1;
+}
+static inline int meta_l2c_writeback(void)
+{
+	return 1;
+}
+
+#endif /* CONFIG_METAG_L2C */
+
+#endif /* _METAG_L2CACHE_H */
diff --git a/arch/metag/include/asm/tlb.h b/arch/metag/include/asm/tlb.h
new file mode 100644
index 0000000..048282f1
--- /dev/null
+++ b/arch/metag/include/asm/tlb.h
@@ -0,0 +1,36 @@
+#ifndef __ASM_METAG_TLB_H
+#define __ASM_METAG_TLB_H
+
+#include <asm/cacheflush.h>
+#include <asm/page.h>
+
+/* Note, read http://lkml.org/lkml/2004/1/15/6 */
+
+#ifdef CONFIG_METAG_META12
+
+#define tlb_start_vma(tlb, vma)						      \
+	do {								      \
+		if (!tlb->fullmm)					      \
+			flush_cache_range(vma, vma->vm_start, vma->vm_end);   \
+	} while (0)
+
+#define tlb_end_vma(tlb, vma)						      \
+	do {								      \
+		if (!tlb->fullmm)					      \
+			flush_tlb_range(vma, vma->vm_start, vma->vm_end);     \
+	} while (0)
+
+
+#else
+
+#define tlb_start_vma(tlb, vma)			do { } while (0)
+#define tlb_end_vma(tlb, vma)			do { } while (0)
+
+#endif
+
+#define __tlb_remove_tlb_entry(tlb, pte, addr)	do { } while (0)
+#define tlb_flush(tlb)				flush_tlb_mm((tlb)->mm)
+
+#include <asm-generic/tlb.h>
+
+#endif
diff --git a/arch/metag/include/asm/tlbflush.h b/arch/metag/include/asm/tlbflush.h
new file mode 100644
index 0000000..572cfbb
--- /dev/null
+++ b/arch/metag/include/asm/tlbflush.h
@@ -0,0 +1,77 @@
+#ifndef __ASM_METAG_TLBFLUSH_H
+#define __ASM_METAG_TLBFLUSH_H
+
+#include <linux/sched.h>
+#include <asm/pgalloc.h>
+#include <asm/tbx.h>
+
+/*
+ * TLB flushing:
+ *
+ *  - flush_tlb() flushes the current mm struct TLBs
+ *  - flush_tlb_all() flushes all processes TLBs
+ *  - flush_tlb_mm(mm) flushes the specified mm context TLB's
+ *  - flush_tlb_page(vma, vmaddr) flushes one page
+ *  - flush_tlb_range(mm, start, end) flushes a range of pages
+ *  - flush_tlb_kernel_range(start, end) flushes a range of kernel pages
+ *  - flush_tlb_pgtables(mm, start, end) flushes a range of page tables
+ *
+ * FIXME: Meta 2 can flush single TLB entries.
+ *
+ */
+
+#if defined(CONFIG_METAG_META21) && !defined(CONFIG_SMP)
+static inline void __flush_tlb(void)
+{
+#ifdef TBIMCACHE_TFLUSH
+	int thread = hard_processor_id();
+	TBIMCACHE_TFLUSH(thread);
+#else
+	TBIMCACHE_FLUSH();
+#endif
+}
+#else
+static inline void __flush_tlb(void)
+{
+	TBIMCACHE_FLUSH();
+}
+#endif /* defined(CONFIG_METAG_META21) && !defined(CONFIG_SMP) */
+
+#define flush_tlb() __flush_tlb()
+
+#define flush_tlb_all() __flush_tlb()
+
+#define local_flush_tlb_all() __flush_tlb()
+
+static inline void flush_tlb_mm(struct mm_struct *mm)
+{
+	if (mm == current->active_mm)
+		__flush_tlb();
+}
+
+static inline void flush_tlb_page(struct vm_area_struct *vma,
+				  unsigned long addr)
+{
+	flush_tlb_mm(vma->vm_mm);
+}
+
+static inline void flush_tlb_range(struct vm_area_struct *vma,
+				   unsigned long start, unsigned long end)
+{
+	flush_tlb_mm(vma->vm_mm);
+}
+
+static inline void flush_tlb_pgtables(struct mm_struct *mm,
+				      unsigned long start, unsigned long end)
+{
+	flush_tlb_mm(mm);
+}
+
+static inline void flush_tlb_kernel_range(unsigned long start,
+					  unsigned long end)
+{
+	flush_tlb_all();
+}
+
+#endif /* __ASM_METAG_TLBFLUSH_H */
+
diff --git a/arch/metag/mm/l2cache.c b/arch/metag/mm/l2cache.c
new file mode 100644
index 0000000..c64ee61
--- /dev/null
+++ b/arch/metag/mm/l2cache.c
@@ -0,0 +1,192 @@
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/delay.h>
+
+#include <asm/l2cache.h>
+#include <asm/metag_isa.h>
+
+/* If non-0, then initialise the L2 cache */
+static int l2cache_init = 1;
+/* If non-0, then initialise the L2 cache prefetch */
+static int l2cache_init_pf = 1;
+
+int l2c_pfenable;
+
+static volatile u32 l2c_testdata[16] __initdata __aligned(64);
+
+static int __init parse_l2cache(char *p)
+{
+	char *cp = p;
+
+	if (get_option(&cp, &l2cache_init) != 1) {
+		pr_err("Bad l2cache parameter (%s)\n", p);
+		return 1;
+	}
+	return 0;
+}
+early_param("l2cache", parse_l2cache);
+
+static int __init parse_l2cache_pf(char *p)
+{
+	char *cp = p;
+
+	if (get_option(&cp, &l2cache_init_pf) != 1) {
+		pr_err("Bad l2cache_pf parameter (%s)\n", p);
+		return 1;
+	}
+	return 0;
+}
+early_param("l2cache_pf", parse_l2cache_pf);
+
+static int __init meta_l2c_setup(void)
+{
+	/*
+	 * If the L2 cache isn't even present, don't do anything, but say so in
+	 * the log.
+	 */
+	if (!meta_l2c_is_present()) {
+		pr_info("L2 Cache: Not present\n");
+		return 0;
+	}
+
+	/*
+	 * Check whether the line size is recognised.
+	 */
+	if (!meta_l2c_linesize()) {
+		pr_warn_once("L2 Cache: unknown line size id (config=0x%08x)\n",
+			     meta_l2c_config());
+	}
+
+	/*
+	 * Initialise state.
+	 */
+	l2c_pfenable = _meta_l2c_pf_is_enabled();
+
+	/*
+	 * Enable the L2 cache and print to log whether it was already enabled
+	 * by the bootloader.
+	 */
+	if (l2cache_init) {
+		pr_info("L2 Cache: Enabling... ");
+		if (meta_l2c_enable())
+			pr_cont("already enabled\n");
+		else
+			pr_cont("done\n");
+	} else {
+		pr_info("L2 Cache: Not enabling\n");
+	}
+
+	/*
+	 * Enable L2 cache prefetch.
+	 */
+	if (l2cache_init_pf) {
+		pr_info("L2 Cache: Enabling prefetch... ");
+		if (meta_l2c_pf_enable(1))
+			pr_cont("already enabled\n");
+		else
+			pr_cont("done\n");
+	} else {
+		pr_info("L2 Cache: Not enabling prefetch\n");
+	}
+
+	return 0;
+}
+core_initcall(meta_l2c_setup);
+
+int meta_l2c_disable(void)
+{
+	unsigned long flags;
+	int en;
+
+	if (!meta_l2c_is_present())
+		return 1;
+
+	/*
+	 * Prevent other threads writing during the writeback, otherwise the
+	 * writes will get "lost" when the L2 is disabled.
+	 */
+	__global_lock2(flags);
+	en = meta_l2c_is_enabled();
+	if (likely(en)) {
+		_meta_l2c_pf_enable(0);
+		wr_fence();
+		_meta_l2c_purge();
+		_meta_l2c_enable(0);
+	}
+	__global_unlock2(flags);
+
+	return !en;
+}
+
+int meta_l2c_enable(void)
+{
+	unsigned long flags;
+	int en;
+
+	if (!meta_l2c_is_present())
+		return 0;
+
+	/*
+	 * Init (clearing the L2) can happen while the L2 is disabled, so other
+	 * threads are safe to continue executing, however we must not init the
+	 * cache if it's already enabled (dirty lines would be discarded), so
+	 * this operation should still be atomic with other threads.
+	 */
+	__global_lock1(flags);
+	en = meta_l2c_is_enabled();
+	if (likely(!en)) {
+		_meta_l2c_init();
+		_meta_l2c_enable(1);
+		_meta_l2c_pf_enable(l2c_pfenable);
+	}
+	__global_unlock1(flags);
+
+	return en;
+}
+
+int meta_l2c_pf_enable(int pfenable)
+{
+	unsigned long flags;
+	int en = l2c_pfenable;
+
+	if (!meta_l2c_is_present())
+		return 0;
+
+	/*
+	 * We read modify write the enable register, so this operation must be
+	 * atomic with other threads.
+	 */
+	__global_lock1(flags);
+	en = l2c_pfenable;
+	l2c_pfenable = pfenable;
+	if (meta_l2c_is_enabled())
+		_meta_l2c_pf_enable(pfenable);
+	__global_unlock1(flags);
+
+	return en;
+}
+
+int meta_l2c_flush(void)
+{
+	unsigned long flags;
+	int en;
+
+	/*
+	 * Prevent other threads writing during the writeback. This also
+	 * involves read modify writes.
+	 */
+	__global_lock2(flags);
+	en = meta_l2c_is_enabled();
+	if (likely(en)) {
+		_meta_l2c_pf_enable(0);
+		wr_fence();
+		_meta_l2c_purge();
+		_meta_l2c_enable(0);
+		_meta_l2c_init();
+		_meta_l2c_enable(1);
+		_meta_l2c_pf_enable(l2c_pfenable);
+	}
+	__global_unlock2(flags);
+
+	return !en;
+}
-- 
1.7.7.6


