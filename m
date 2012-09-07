Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755634Ab2IGQfy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 12:35:54 -0400
Received: from service87.mimecast.com ([91.220.42.44]:34314 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751868Ab2IGQ1x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 12:27:53 -0400
From: Catalin Marinas <catalin.marinas@arm.com>
To: linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH v3 10/31] arm64: TLB maintenance functionality
Date: Fri,  7 Sep 2012 17:26:45 +0100
Message-Id: <1347035226-18649-11-git-send-email-catalin.marinas@arm.com>
X-Mailer: git-send-email 1.7.9.111.gf3fb0
In-Reply-To: <1347035226-18649-1-git-send-email-catalin.marinas@arm.com>
References: <1347035226-18649-1-git-send-email-catalin.marinas@arm.com>
X-OriginalArrivalTime: 07 Sep 2012 16:27:51.0519 (UTC) FILETIME=[B9D50EF0:01CD8D15]
X-MC-Unique: 112090717275114201
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id q87GaYvs008479

This patch adds the TLB maintenance functions. There is no distinction
made between the I and D TLBs. TLB maintenance operations are
automatically broadcast between CPUs in hardware. The inner-shareable
operations are always present, even on UP systems.

NOTE: Large part of this patch to be dropped once Peter Z's generic
mmu_gather patches are merged.

Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Acked-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm64/include/asm/tlb.h      |  190 +++++++++++++++++++++++++++++++++++++
 arch/arm64/include/asm/tlbflush.h |  122 ++++++++++++++++++++++++
 arch/arm64/mm/tlb.S               |   71 ++++++++++++++
 3 files changed, 383 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm64/include/asm/tlb.h
 create mode 100644 arch/arm64/include/asm/tlbflush.h
 create mode 100644 arch/arm64/mm/tlb.S

diff --git a/arch/arm64/include/asm/tlb.h b/arch/arm64/include/asm/tlb.h
new file mode 100644
index 0000000..654f096
--- /dev/null
+++ b/arch/arm64/include/asm/tlb.h
@@ -0,0 +1,190 @@
+/*
+ * Based on arch/arm/include/asm/tlb.h
+ *
+ * Copyright (C) 2002 Russell King
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
+#ifndef __ASM_TLB_H
+#define __ASM_TLB_H
+
+#include <linux/pagemap.h>
+#include <linux/swap.h>
+
+#include <asm/pgalloc.h>
+#include <asm/tlbflush.h>
+
+#define MMU_GATHER_BUNDLE	8
+
+/*
+ * TLB handling.  This allows us to remove pages from the page
+ * tables, and efficiently handle the TLB issues.
+ */
+struct mmu_gather {
+	struct mm_struct	*mm;
+	unsigned int		fullmm;
+	struct vm_area_struct	*vma;
+	unsigned long		range_start;
+	unsigned long		range_end;
+	unsigned int		nr;
+	unsigned int		max;
+	struct page		**pages;
+	struct page		*local[MMU_GATHER_BUNDLE];
+};
+
+/*
+ * This is unnecessarily complex.  There's three ways the TLB shootdown
+ * code is used:
+ *  1. Unmapping a range of vmas.  See zap_page_range(), unmap_region().
+ *     tlb->fullmm = 0, and tlb_start_vma/tlb_end_vma will be called.
+ *     tlb->vma will be non-NULL.
+ *  2. Unmapping all vmas.  See exit_mmap().
+ *     tlb->fullmm = 1, and tlb_start_vma/tlb_end_vma will be called.
+ *     tlb->vma will be non-NULL.  Additionally, page tables will be freed.
+ *  3. Unmapping argument pages.  See shift_arg_pages().
+ *     tlb->fullmm = 0, but tlb_start_vma/tlb_end_vma will not be called.
+ *     tlb->vma will be NULL.
+ */
+static inline void tlb_flush(struct mmu_gather *tlb)
+{
+	if (tlb->fullmm || !tlb->vma)
+		flush_tlb_mm(tlb->mm);
+	else if (tlb->range_end > 0) {
+		flush_tlb_range(tlb->vma, tlb->range_start, tlb->range_end);
+		tlb->range_start = TASK_SIZE;
+		tlb->range_end = 0;
+	}
+}
+
+static inline void tlb_add_flush(struct mmu_gather *tlb, unsigned long addr)
+{
+	if (!tlb->fullmm) {
+		if (addr < tlb->range_start)
+			tlb->range_start = addr;
+		if (addr + PAGE_SIZE > tlb->range_end)
+			tlb->range_end = addr + PAGE_SIZE;
+	}
+}
+
+static inline void __tlb_alloc_page(struct mmu_gather *tlb)
+{
+	unsigned long addr = __get_free_pages(GFP_NOWAIT | __GFP_NOWARN, 0);
+
+	if (addr) {
+		tlb->pages = (void *)addr;
+		tlb->max = PAGE_SIZE / sizeof(struct page *);
+	}
+}
+
+static inline void tlb_flush_mmu(struct mmu_gather *tlb)
+{
+	tlb_flush(tlb);
+	free_pages_and_swap_cache(tlb->pages, tlb->nr);
+	tlb->nr = 0;
+	if (tlb->pages == tlb->local)
+		__tlb_alloc_page(tlb);
+}
+
+static inline void
+tlb_gather_mmu(struct mmu_gather *tlb, struct mm_struct *mm, unsigned int fullmm)
+{
+	tlb->mm = mm;
+	tlb->fullmm = fullmm;
+	tlb->vma = NULL;
+	tlb->max = ARRAY_SIZE(tlb->local);
+	tlb->pages = tlb->local;
+	tlb->nr = 0;
+	__tlb_alloc_page(tlb);
+}
+
+static inline void
+tlb_finish_mmu(struct mmu_gather *tlb, unsigned long start, unsigned long end)
+{
+	tlb_flush_mmu(tlb);
+
+	/* keep the page table cache within bounds */
+	check_pgt_cache();
+
+	if (tlb->pages != tlb->local)
+		free_pages((unsigned long)tlb->pages, 0);
+}
+
+/*
+ * Memorize the range for the TLB flush.
+ */
+static inline void
+tlb_remove_tlb_entry(struct mmu_gather *tlb, pte_t *ptep, unsigned long addr)
+{
+	tlb_add_flush(tlb, addr);
+}
+
+/*
+ * In the case of tlb vma handling, we can optimise these away in the
+ * case where we're doing a full MM flush.  When we're doing a munmap,
+ * the vmas are adjusted to only cover the region to be torn down.
+ */
+static inline void
+tlb_start_vma(struct mmu_gather *tlb, struct vm_area_struct *vma)
+{
+	if (!tlb->fullmm) {
+		tlb->vma = vma;
+		tlb->range_start = TASK_SIZE;
+		tlb->range_end = 0;
+	}
+}
+
+static inline void
+tlb_end_vma(struct mmu_gather *tlb, struct vm_area_struct *vma)
+{
+	if (!tlb->fullmm)
+		tlb_flush(tlb);
+}
+
+static inline int __tlb_remove_page(struct mmu_gather *tlb, struct page *page)
+{
+	tlb->pages[tlb->nr++] = page;
+	VM_BUG_ON(tlb->nr > tlb->max);
+	return tlb->max - tlb->nr;
+}
+
+static inline void tlb_remove_page(struct mmu_gather *tlb, struct page *page)
+{
+	if (!__tlb_remove_page(tlb, page))
+		tlb_flush_mmu(tlb);
+}
+
+static inline void __pte_free_tlb(struct mmu_gather *tlb, pgtable_t pte,
+	unsigned long addr)
+{
+	pgtable_page_dtor(pte);
+	tlb_add_flush(tlb, addr);
+	tlb_remove_page(tlb, pte);
+}
+
+#ifndef CONFIG_ARM64_64K_PAGES
+static inline void __pmd_free_tlb(struct mmu_gather *tlb, pmd_t *pmdp,
+				  unsigned long addr)
+{
+	tlb_add_flush(tlb, addr);
+	tlb_remove_page(tlb, virt_to_page(pmdp));
+}
+#endif
+
+#define pte_free_tlb(tlb, ptep, addr)	__pte_free_tlb(tlb, ptep, addr)
+#define pmd_free_tlb(tlb, pmdp, addr)	__pmd_free_tlb(tlb, pmdp, addr)
+#define pud_free_tlb(tlb, pudp, addr)	pud_free((tlb)->mm, pudp)
+
+#define tlb_migrate_finish(mm)		do { } while (0)
+
+#endif
diff --git a/arch/arm64/include/asm/tlbflush.h b/arch/arm64/include/asm/tlbflush.h
new file mode 100644
index 0000000..122d632
--- /dev/null
+++ b/arch/arm64/include/asm/tlbflush.h
@@ -0,0 +1,122 @@
+/*
+ * Based on arch/arm/include/asm/tlbflush.h
+ *
+ * Copyright (C) 1999-2003 Russell King
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
+#ifndef __ASM_TLBFLUSH_H
+#define __ASM_TLBFLUSH_H
+
+#ifndef __ASSEMBLY__
+
+#include <linux/sched.h>
+#include <asm/cputype.h>
+
+extern void __cpu_flush_user_tlb_range(unsigned long, unsigned long, struct vm_area_struct *);
+extern void __cpu_flush_kern_tlb_range(unsigned long, unsigned long);
+
+extern struct cpu_tlb_fns cpu_tlb;
+
+/*
+ *	TLB Management
+ *	==============
+ *
+ *	The arch/arm64/mm/tlb.S files implement these methods.
+ *
+ *	The TLB specific code is expected to perform whatever tests it needs
+ *	to determine if it should invalidate the TLB for each call.  Start
+ *	addresses are inclusive and end addresses are exclusive; it is safe to
+ *	round these addresses down.
+ *
+ *	flush_tlb_all()
+ *
+ *		Invalidate the entire TLB.
+ *
+ *	flush_tlb_mm(mm)
+ *
+ *		Invalidate all TLB entries in a particular address space.
+ *		- mm	- mm_struct describing address space
+ *
+ *	flush_tlb_range(mm,start,end)
+ *
+ *		Invalidate a range of TLB entries in the specified address
+ *		space.
+ *		- mm	- mm_struct describing address space
+ *		- start - start address (may not be aligned)
+ *		- end	- end address (exclusive, may not be aligned)
+ *
+ *	flush_tlb_page(vaddr,vma)
+ *
+ *		Invalidate the specified page in the specified address range.
+ *		- vaddr - virtual address (may not be aligned)
+ *		- vma	- vma_struct describing address range
+ *
+ *	flush_kern_tlb_page(kaddr)
+ *
+ *		Invalidate the TLB entry for the specified page.  The address
+ *		will be in the kernels virtual memory space.  Current uses
+ *		only require the D-TLB to be invalidated.
+ *		- kaddr - Kernel virtual memory address
+ */
+static inline void flush_tlb_all(void)
+{
+	dsb();
+	asm("tlbi	vmalle1is");
+	dsb();
+	isb();
+}
+
+static inline void flush_tlb_mm(struct mm_struct *mm)
+{
+	unsigned long asid = (unsigned long)ASID(mm) << 48;
+
+	dsb();
+	asm("tlbi	aside1is, %0" : : "r" (asid));
+	dsb();
+}
+
+static inline void flush_tlb_page(struct vm_area_struct *vma,
+				  unsigned long uaddr)
+{
+	unsigned long addr = uaddr >> 12 |
+		((unsigned long)ASID(vma->vm_mm) << 48);
+
+	dsb();
+	asm("tlbi	vae1is, %0" : : "r" (addr));
+	dsb();
+}
+
+/*
+ * Convert calls to our calling convention.
+ */
+#define flush_tlb_range(vma,start,end)	__cpu_flush_user_tlb_range(start,end,vma)
+#define flush_tlb_kernel_range(s,e)	__cpu_flush_kern_tlb_range(s,e)
+
+/*
+ * On AArch64, the cache coherency is handled via the set_pte_at() function.
+ */
+static inline void update_mmu_cache(struct vm_area_struct *vma,
+				    unsigned long addr, pte_t *ptep)
+{
+	/*
+	 * set_pte() does not have a DSB, so make sure that the page table
+	 * write is visible.
+	 */
+	dsb();
+}
+
+#endif
+
+#endif
diff --git a/arch/arm64/mm/tlb.S b/arch/arm64/mm/tlb.S
new file mode 100644
index 0000000..8ae80a1
--- /dev/null
+++ b/arch/arm64/mm/tlb.S
@@ -0,0 +1,71 @@
+/*
+ * Based on arch/arm/mm/tlb.S
+ *
+ * Copyright (C) 1997-2002 Russell King
+ * Copyright (C) 2012 ARM Ltd.
+ * Written by Catalin Marinas <catalin.marinas@arm.com>
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
+#include <linux/linkage.h>
+#include <asm/assembler.h>
+#include <asm/asm-offsets.h>
+#include <asm/page.h>
+#include <asm/tlbflush.h>
+#include "proc-macros.S"
+
+/*
+ *	__cpu_flush_user_tlb_range(start, end, vma)
+ *
+ *	Invalidate a range of TLB entries in the specified address space.
+ *
+ *	- start - start address (may not be aligned)
+ *	- end   - end address (exclusive, may not be aligned)
+ *	- vma   - vma_struct describing address range
+ */
+ENTRY(__cpu_flush_user_tlb_range)
+	vma_vm_mm x3, x2			// get vma->vm_mm
+	mmid	x3, x3				// get vm_mm->context.id
+	dsb	sy
+	lsr	x0, x0, #12			// align address
+	lsr	x1, x1, #12
+	bfi	x0, x3, #48, #16		// start VA and ASID
+	bfi	x1, x3, #48, #16		// end VA and ASID
+1:	tlbi	vae1is, x0			// TLB invalidate by address and ASID
+	add	x0, x0, #1
+	cmp	x0, x1
+	b.lo	1b
+	dsb	sy
+	ret
+ENDPROC(__cpu_flush_user_tlb_range)
+
+/*
+ *	__cpu_flush_kern_tlb_range(start,end)
+ *
+ *	Invalidate a range of kernel TLB entries.
+ *
+ *	- start - start address (may not be aligned)
+ *	- end   - end address (exclusive, may not be aligned)
+ */
+ENTRY(__cpu_flush_kern_tlb_range)
+	dsb	sy
+	lsr	x0, x0, #12			// align address
+	lsr	x1, x1, #12
+1:	tlbi	vaae1is, x0			// TLB invalidate by address
+	add	x0, x0, #1
+	cmp	x0, x1
+	b.lo	1b
+	dsb	sy
+	isb
+	ret
+ENDPROC(__cpu_flush_kern_tlb_range)

