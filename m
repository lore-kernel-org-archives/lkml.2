Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752099Ab2LEQTl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 11:19:41 -0500
Received: from multi.imgtec.com ([194.200.65.239]:56729 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752912Ab2LEQJb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 11:09:31 -0500
From: James Hogan <james.hogan@imgtec.com>
To: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Arnd Bergmann <arnd@arndb.de>, James Hogan <james.hogan@imgtec.com>
Subject: [PATCH v2 17/44] metag: Highmem support
Date: Wed, 5 Dec 2012 16:08:35 +0000
Message-ID: <1354723742-6195-18-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1354723742-6195-1-git-send-email-james.hogan@imgtec.com>
References: <1354723742-6195-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
X-SEF-Processed: 7_3_0_01181__2012_12_05_16_09_22
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: James Hogan <james.hogan@imgtec.com>
---
 arch/metag/include/asm/fixmap.h  |   99 ++++++++++++++++++++++++++++
 arch/metag/include/asm/highmem.h |   62 ++++++++++++++++++
 arch/metag/mm/highmem.c          |  133 ++++++++++++++++++++++++++++++++++++++
 3 files changed, 294 insertions(+), 0 deletions(-)
 create mode 100644 arch/metag/include/asm/fixmap.h
 create mode 100644 arch/metag/include/asm/highmem.h
 create mode 100644 arch/metag/mm/highmem.c

diff --git a/arch/metag/include/asm/fixmap.h b/arch/metag/include/asm/fixmap.h
new file mode 100644
index 0000000..3331275
--- /dev/null
+++ b/arch/metag/include/asm/fixmap.h
@@ -0,0 +1,99 @@
+/*
+ * fixmap.h: compile-time virtual memory allocation
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 1998 Ingo Molnar
+ *
+ * Support of BIGMEM added by Gerhard Wichert, Siemens AG, July 1999
+ */
+
+#ifndef _ASM_FIXMAP_H
+#define _ASM_FIXMAP_H
+
+#include <asm/pgtable.h>
+#ifdef CONFIG_HIGHMEM
+#include <linux/threads.h>
+#include <asm/kmap_types.h>
+#endif
+
+/*
+ * Here we define all the compile-time 'special' virtual
+ * addresses. The point is to have a constant address at
+ * compile time, but to set the physical address only
+ * in the boot process. We allocate these special  addresses
+ * from the end of the consistent memory region backwards.
+ * Also this lets us do fail-safe vmalloc(), we
+ * can guarantee that these special addresses and
+ * vmalloc()-ed addresses never overlap.
+ *
+ * these 'compile-time allocated' memory buffers are
+ * fixed-size 4k pages. (or larger if used with an increment
+ * higher than 1) use fixmap_set(idx,phys) to associate
+ * physical memory with fixmap indices.
+ *
+ * TLB entries of such buffers will not be flushed across
+ * task switches.
+ */
+enum fixed_addresses {
+#define FIX_N_COLOURS 8
+#ifdef CONFIG_HIGHMEM
+	/* reserved pte's for temporary kernel mappings */
+	FIX_KMAP_BEGIN,
+	FIX_KMAP_END = FIX_KMAP_BEGIN+(KM_TYPE_NR*NR_CPUS)-1,
+#endif
+	__end_of_fixed_addresses
+};
+
+#define FIXADDR_TOP     (CONSISTENT_START - PAGE_SIZE)
+#define FIXADDR_SIZE	(__end_of_fixed_addresses << PAGE_SHIFT)
+#define FIXADDR_START	((FIXADDR_TOP - FIXADDR_SIZE) & PMD_MASK)
+
+#define __fix_to_virt(x)	(FIXADDR_TOP - ((x) << PAGE_SHIFT))
+#define __virt_to_fix(x)	((FIXADDR_TOP - ((x)&PAGE_MASK)) >> PAGE_SHIFT)
+
+extern void __this_fixmap_does_not_exist(void);
+/*
+ * 'index to address' translation. If anyone tries to use the idx
+ * directly without tranlation, we catch the bug with a NULL-deference
+ * kernel oops. Illegal ranges of incoming indices are caught too.
+ */
+static inline unsigned long fix_to_virt(const unsigned int idx)
+{
+	/*
+	 * this branch gets completely eliminated after inlining,
+	 * except when someone tries to use fixaddr indices in an
+	 * illegal way. (such as mixing up address types or using
+	 * out-of-range indices).
+	 *
+	 * If it doesn't get removed, the linker will complain
+	 * loudly with a reasonably clear error message..
+	 */
+	if (idx >= __end_of_fixed_addresses)
+		__this_fixmap_does_not_exist();
+
+	return __fix_to_virt(idx);
+}
+
+static inline unsigned long virt_to_fix(const unsigned long vaddr)
+{
+	BUG_ON(vaddr >= FIXADDR_TOP || vaddr < FIXADDR_START);
+	return __virt_to_fix(vaddr);
+}
+
+#define kmap_get_fixmap_pte(vaddr) \
+	pte_offset_kernel( \
+		pmd_offset(pud_offset(pgd_offset_k(vaddr), (vaddr)), (vaddr)), \
+		(vaddr) \
+	)
+
+/*
+ * Called from pgtable_init()
+ */
+extern void fixrange_init(unsigned long start, unsigned long end,
+	pgd_t *pgd_base);
+
+
+#endif
diff --git a/arch/metag/include/asm/highmem.h b/arch/metag/include/asm/highmem.h
new file mode 100644
index 0000000..6646a15
--- /dev/null
+++ b/arch/metag/include/asm/highmem.h
@@ -0,0 +1,62 @@
+#ifndef _ASM_HIGHMEM_H
+#define _ASM_HIGHMEM_H
+
+#include <asm/cacheflush.h>
+#include <asm/kmap_types.h>
+#include <asm/fixmap.h>
+
+/*
+ * Right now we initialize only a single pte table. It can be extended
+ * easily, subsequent pte tables have to be allocated in one physical
+ * chunk of RAM.
+ */
+/*
+ * Ordering is (from lower to higher memory addresses):
+ *
+ * high_memory
+ *			Persistent kmap area
+ * PKMAP_BASE
+ *			fixed_addresses
+ * FIXADDR_START
+ * FIXADDR_TOP
+ *			Vmalloc area
+ * VMALLOC_START
+ * VMALLOC_END
+ */
+#define PKMAP_BASE		(FIXADDR_START - PMD_SIZE)
+#define LAST_PKMAP		PTRS_PER_PTE
+#define LAST_PKMAP_MASK		(LAST_PKMAP - 1)
+#define PKMAP_NR(virt)		(((virt) - PKMAP_BASE) >> PAGE_SHIFT)
+#define PKMAP_ADDR(nr)		(PKMAP_BASE + ((nr) << PAGE_SHIFT))
+
+#define kmap_prot		PAGE_KERNEL
+
+static inline void flush_cache_kmaps(void)
+{
+	flush_cache_all();
+}
+
+/* declarations for highmem.c */
+extern unsigned long highstart_pfn, highend_pfn;
+
+extern pte_t *pkmap_page_table;
+
+extern void *kmap_high(struct page *page);
+extern void kunmap_high(struct page *page);
+
+extern void kmap_init(void);
+
+/*
+ * The following functions are already defined by <linux/highmem.h>
+ * when CONFIG_HIGHMEM is not set.
+ */
+#ifdef CONFIG_HIGHMEM
+extern void *kmap(struct page *page);
+extern void kunmap(struct page *page);
+extern void *kmap_atomic(struct page *page);
+extern void __kunmap_atomic(void *kvaddr);
+extern void *kmap_atomic_pfn(unsigned long pfn);
+extern struct page *kmap_atomic_to_page(void *ptr);
+#endif
+
+#endif
diff --git a/arch/metag/mm/highmem.c b/arch/metag/mm/highmem.c
new file mode 100644
index 0000000..d71f621
--- /dev/null
+++ b/arch/metag/mm/highmem.c
@@ -0,0 +1,133 @@
+#include <linux/export.h>
+#include <linux/highmem.h>
+#include <linux/sched.h>
+#include <linux/smp.h>
+#include <linux/interrupt.h>
+#include <asm/fixmap.h>
+#include <asm/tlbflush.h>
+
+static pte_t *kmap_pte;
+
+unsigned long highstart_pfn, highend_pfn;
+
+void *kmap(struct page *page)
+{
+	might_sleep();
+	if (!PageHighMem(page))
+		return page_address(page);
+	return kmap_high(page);
+}
+EXPORT_SYMBOL(kmap);
+
+void kunmap(struct page *page)
+{
+	BUG_ON(in_interrupt());
+	if (!PageHighMem(page))
+		return;
+	kunmap_high(page);
+}
+EXPORT_SYMBOL(kunmap);
+
+/*
+ * kmap_atomic/kunmap_atomic is significantly faster than kmap/kunmap because
+ * no global lock is needed and because the kmap code must perform a global TLB
+ * invalidation when the kmap pool wraps.
+ *
+ * However when holding an atomic kmap is is not legal to sleep, so atomic
+ * kmaps are appropriate for short, tight code paths only.
+ */
+
+void *kmap_atomic(struct page *page)
+{
+	enum fixed_addresses idx;
+	unsigned long vaddr;
+	int type;
+
+	/* even !CONFIG_PREEMPT needs this, for in_atomic in do_page_fault */
+	pagefault_disable();
+	if (!PageHighMem(page))
+		return page_address(page);
+
+	type = kmap_atomic_idx_push();
+	idx = type + KM_TYPE_NR * smp_processor_id();
+	vaddr = __fix_to_virt(FIX_KMAP_BEGIN + idx);
+#ifdef CONFIG_DEBUG_HIGHMEM
+	BUG_ON(!pte_none(*(kmap_pte - idx)));
+#endif
+	set_pte(kmap_pte - idx, mk_pte(page, PAGE_KERNEL));
+
+	return (void *)vaddr;
+}
+EXPORT_SYMBOL(kmap_atomic);
+
+void __kunmap_atomic(void *kvaddr)
+{
+	unsigned long vaddr = (unsigned long) kvaddr & PAGE_MASK;
+	int idx, type;
+
+	if (kvaddr >= (void *)FIXADDR_START) {
+		type = kmap_atomic_idx();
+		idx = type + KM_TYPE_NR * smp_processor_id();
+
+		/*
+		 * Force other mappings to Oops if they'll try to access this
+		 * pte without first remap it.  Keeping stale mappings around
+		 * is a bad idea also, in case the page changes cacheability
+		 * attributes or becomes a protected page in a hypervisor.
+		 */
+		pte_clear(&init_mm, vaddr, kmap_pte-idx);
+		flush_tlb_kernel_range(vaddr, vaddr + PAGE_SIZE);
+
+		kmap_atomic_idx_pop();
+	}
+
+	pagefault_enable();
+}
+EXPORT_SYMBOL(__kunmap_atomic);
+
+/*
+ * This is the same as kmap_atomic() but can map memory that doesn't
+ * have a struct page associated with it.
+ */
+void *kmap_atomic_pfn(unsigned long pfn)
+{
+	enum fixed_addresses idx;
+	unsigned long vaddr;
+	int type;
+
+	pagefault_disable();
+
+	type = kmap_atomic_idx_push();
+	idx = type + KM_TYPE_NR * smp_processor_id();
+	vaddr = __fix_to_virt(FIX_KMAP_BEGIN + idx);
+#ifdef CONFIG_DEBUG_HIGHMEM
+	BUG_ON(!pte_none(*(kmap_pte - idx)));
+#endif
+	set_pte(kmap_pte - idx, pfn_pte(pfn, PAGE_KERNEL));
+	flush_tlb_kernel_range(vaddr, vaddr + PAGE_SIZE);
+
+	return (void *)vaddr;
+}
+
+struct page *kmap_atomic_to_page(void *ptr)
+{
+	unsigned long vaddr = (unsigned long)ptr;
+	int idx;
+	pte_t *pte;
+
+	if (vaddr < FIXADDR_START)
+		return virt_to_page(ptr);
+
+	idx = virt_to_fix(vaddr);
+	pte = kmap_pte - (idx - FIX_KMAP_BEGIN);
+	return pte_page(*pte);
+}
+
+void __init kmap_init(void)
+{
+	unsigned long kmap_vstart;
+
+	/* cache the first kmap pte */
+	kmap_vstart = __fix_to_virt(FIX_KMAP_BEGIN);
+	kmap_pte = kmap_get_fixmap_pte(kmap_vstart);
+}
-- 
1.7.7.6


