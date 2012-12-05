Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754143Ab2LEQTn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 11:19:43 -0500
Received: from multi.imgtec.com ([194.200.65.239]:51616 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752858Ab2LEQJb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 11:09:31 -0500
From: James Hogan <james.hogan@imgtec.com>
To: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Arnd Bergmann <arnd@arndb.de>, James Hogan <james.hogan@imgtec.com>
Subject: [PATCH v2 16/44] metag: Huge TLB
Date: Wed, 5 Dec 2012 16:08:34 +0000
Message-ID: <1354723742-6195-17-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1354723742-6195-1-git-send-email-james.hogan@imgtec.com>
References: <1354723742-6195-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
X-SEF-Processed: 7_3_0_01181__2012_12_05_16_09_21
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add huge TLB support to the metag architecture.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
---
 arch/metag/include/asm/hugetlb.h |   86 +++++++++++
 arch/metag/mm/hugetlbpage.c      |  291 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 377 insertions(+), 0 deletions(-)
 create mode 100644 arch/metag/include/asm/hugetlb.h
 create mode 100644 arch/metag/mm/hugetlbpage.c

diff --git a/arch/metag/include/asm/hugetlb.h b/arch/metag/include/asm/hugetlb.h
new file mode 100644
index 0000000..f545477
--- /dev/null
+++ b/arch/metag/include/asm/hugetlb.h
@@ -0,0 +1,86 @@
+#ifndef _ASM_METAG_HUGETLB_H
+#define _ASM_METAG_HUGETLB_H
+
+#include <asm/page.h>
+
+
+static inline int is_hugepage_only_range(struct mm_struct *mm,
+					 unsigned long addr,
+					 unsigned long len) {
+	return 0;
+}
+
+int prepare_hugepage_range(struct file *file, unsigned long addr,
+						unsigned long len);
+
+static inline void hugetlb_prefault_arch_hook(struct mm_struct *mm)
+{
+}
+
+static inline void hugetlb_free_pgd_range(struct mmu_gather *tlb,
+					  unsigned long addr, unsigned long end,
+					  unsigned long floor,
+					  unsigned long ceiling)
+{
+	free_pgd_range(tlb, addr, end, floor, ceiling);
+}
+
+static inline void set_huge_pte_at(struct mm_struct *mm, unsigned long addr,
+				   pte_t *ptep, pte_t pte)
+{
+	set_pte_at(mm, addr, ptep, pte);
+}
+
+static inline pte_t huge_ptep_get_and_clear(struct mm_struct *mm,
+					    unsigned long addr, pte_t *ptep)
+{
+	return ptep_get_and_clear(mm, addr, ptep);
+}
+
+static inline void huge_ptep_clear_flush(struct vm_area_struct *vma,
+					 unsigned long addr, pte_t *ptep)
+{
+}
+
+static inline int huge_pte_none(pte_t pte)
+{
+	return pte_none(pte);
+}
+
+static inline pte_t huge_pte_wrprotect(pte_t pte)
+{
+	return pte_wrprotect(pte);
+}
+
+static inline void huge_ptep_set_wrprotect(struct mm_struct *mm,
+					   unsigned long addr, pte_t *ptep)
+{
+	ptep_set_wrprotect(mm, addr, ptep);
+}
+
+static inline int huge_ptep_set_access_flags(struct vm_area_struct *vma,
+					     unsigned long addr, pte_t *ptep,
+					     pte_t pte, int dirty)
+{
+	return ptep_set_access_flags(vma, addr, ptep, pte, dirty);
+}
+
+static inline pte_t huge_ptep_get(pte_t *ptep)
+{
+	return *ptep;
+}
+
+static inline int arch_prepare_hugepage(struct page *page)
+{
+	return 0;
+}
+
+static inline void arch_release_hugepage(struct page *page)
+{
+}
+
+static inline void arch_clear_hugepage_flags(struct page *page)
+{
+}
+
+#endif /* _ASM_METAG_HUGETLB_H */
diff --git a/arch/metag/mm/hugetlbpage.c b/arch/metag/mm/hugetlbpage.c
new file mode 100644
index 0000000..24ceed4
--- /dev/null
+++ b/arch/metag/mm/hugetlbpage.c
@@ -0,0 +1,291 @@
+/*
+ * arch/metag/mm/hugetlbpage.c
+ *
+ * METAG HugeTLB page support.
+ *
+ * Cloned from SuperH
+ *
+ * Cloned from sparc64 by Paul Mundt.
+ *
+ * Copyright (C) 2002, 2003 David S. Miller (davem@redhat.com)
+ */
+
+#include <linux/init.h>
+#include <linux/fs.h>
+#include <linux/mm.h>
+#include <linux/hugetlb.h>
+#include <linux/pagemap.h>
+#include <linux/sysctl.h>
+
+#include <asm/mman.h>
+#include <asm/pgalloc.h>
+#include <asm/tlb.h>
+#include <asm/tlbflush.h>
+#include <asm/cacheflush.h>
+
+/*
+ * If the arch doesn't supply something else, assume that hugepage
+ * size aligned regions are ok without further preparation.
+ */
+int prepare_hugepage_range(struct file *file, unsigned long addr,
+						unsigned long len)
+{
+	struct mm_struct *mm = current->mm;
+	struct hstate *h = hstate_file(file);
+	struct vm_area_struct *vma;
+
+	if (len & ~huge_page_mask(h))
+		return -EINVAL;
+	if (addr & ~huge_page_mask(h))
+		return -EINVAL;
+	if (TASK_SIZE - len < addr)
+		return -EINVAL;
+
+	vma = find_vma(mm, ALIGN_HUGEPT(addr));
+	if (vma && !(vma->vm_flags & MAP_HUGETLB))
+		return -EINVAL;
+
+	vma = find_vma(mm, addr);
+	if (vma) {
+		if (addr + len > vma->vm_start)
+			return -EINVAL;
+		if (!(vma->vm_flags & MAP_HUGETLB) &&
+		    (ALIGN_HUGEPT(addr + len) > vma->vm_start))
+			return -EINVAL;
+	}
+	return 0;
+}
+
+pte_t *huge_pte_alloc(struct mm_struct *mm,
+			unsigned long addr, unsigned long sz)
+{
+	pgd_t *pgd;
+	pud_t *pud;
+	pmd_t *pmd;
+	pte_t *pte;
+
+	pgd = pgd_offset(mm, addr);
+	pud = pud_offset(pgd, addr);
+	pmd = pmd_offset(pud, addr);
+	pte = pte_alloc_map(mm, NULL, pmd, addr);
+	pgd->pgd &= ~_PAGE_SZ_MASK;
+	pgd->pgd |= _PAGE_SZHUGE;
+
+	return pte;
+}
+
+pte_t *huge_pte_offset(struct mm_struct *mm, unsigned long addr)
+{
+	pgd_t *pgd;
+	pud_t *pud;
+	pmd_t *pmd;
+	pte_t *pte = NULL;
+
+	pgd = pgd_offset(mm, addr);
+	pud = pud_offset(pgd, addr);
+	pmd = pmd_offset(pud, addr);
+	pte = pte_offset_kernel(pmd, addr);
+
+	return pte;
+}
+
+int huge_pmd_unshare(struct mm_struct *mm, unsigned long *addr, pte_t *ptep)
+{
+	return 0;
+}
+
+struct page *follow_huge_addr(struct mm_struct *mm,
+			      unsigned long address, int write)
+{
+	return ERR_PTR(-EINVAL);
+}
+
+int pmd_huge(pmd_t pmd)
+{
+	return pmd_page_shift(pmd) > PAGE_SHIFT;
+}
+
+int pud_huge(pud_t pud)
+{
+	return 0;
+}
+
+struct page *follow_huge_pmd(struct mm_struct *mm, unsigned long address,
+			     pmd_t *pmd, int write)
+{
+	return NULL;
+}
+
+#ifdef HAVE_ARCH_HUGETLB_UNMAPPED_AREA
+
+/*
+ * Look for an unmapped area starting after another hugetlb vma.
+ * There are guaranteed to be no huge pte's spare if all the huge pages are
+ * full size (4MB), so in that case compile out this search.
+ */
+#if HPAGE_SHIFT == HUGEPT_SHIFT
+static inline unsigned long
+hugetlb_get_unmapped_area_existing(unsigned long len)
+{
+	return 0;
+}
+#else
+static unsigned long
+hugetlb_get_unmapped_area_existing(unsigned long len)
+{
+	struct mm_struct *mm = current->mm;
+	struct vm_area_struct *vma;
+	unsigned long start_addr, addr;
+	int after_huge;
+
+	if (mm->context.part_huge) {
+		start_addr = mm->context.part_huge;
+		after_huge = 1;
+	} else {
+		start_addr = TASK_UNMAPPED_BASE;
+		after_huge = 0;
+	}
+new_search:
+	addr = start_addr;
+
+	for (vma = find_vma(mm, addr); ; vma = vma->vm_next) {
+		if ((!vma && !after_huge) || TASK_SIZE - len < addr) {
+			/*
+			 * Start a new search - just in case we missed
+			 * some holes.
+			 */
+			if (start_addr != TASK_UNMAPPED_BASE) {
+				start_addr = TASK_UNMAPPED_BASE;
+				goto new_search;
+			}
+			return 0;
+		}
+		/* skip ahead if we've aligned right over some vmas */
+		if (vma && vma->vm_end <= addr)
+			continue;
+		/* space before the next vma? */
+		if (after_huge && (!vma || ALIGN_HUGEPT(addr + len)
+			    <= vma->vm_start)) {
+			unsigned long end = addr + len;
+			if (end & HUGEPT_MASK)
+				mm->context.part_huge = end;
+			else if (addr == mm->context.part_huge)
+				mm->context.part_huge = 0;
+			return addr;
+		}
+		if (vma && (vma->vm_flags & MAP_HUGETLB)) {
+			/* space after a huge vma in 2nd level page table? */
+			if (vma->vm_end & HUGEPT_MASK) {
+				after_huge = 1;
+				/* no need to align to the next PT block */
+				addr = vma->vm_end;
+				continue;
+			}
+		}
+		after_huge = 0;
+		addr = ALIGN_HUGEPT(vma->vm_end);
+	}
+}
+#endif
+
+/* Do a full search to find an area without any nearby normal pages. */
+static unsigned long
+hugetlb_get_unmapped_area_new_pmd(unsigned long len)
+{
+	struct mm_struct *mm = current->mm;
+	struct vm_area_struct *vma;
+	unsigned long start_addr, addr;
+
+	if (ALIGN_HUGEPT(len) > mm->cached_hole_size)
+		start_addr = mm->free_area_cache;
+	else
+		start_addr = TASK_UNMAPPED_BASE;
+
+new_search:
+	addr = ALIGN_HUGEPT(start_addr);
+
+	for (vma = find_vma(mm, addr); ; vma = vma->vm_next) {
+		if (TASK_SIZE - len < addr) {
+			/*
+			 * Start a new search - just in case we missed
+			 * some holes.
+			 */
+			if (start_addr != TASK_UNMAPPED_BASE) {
+				start_addr = TASK_UNMAPPED_BASE;
+				mm->cached_hole_size = 0;
+				goto new_search;
+			}
+			return 0;
+		}
+		/* skip ahead if we've aligned right over some vmas */
+		if (vma && vma->vm_end <= addr)
+			continue;
+		if (!vma || ALIGN_HUGEPT(addr + len) <= vma->vm_start) {
+#if HPAGE_SHIFT < HUGEPT_SHIFT
+			if (len & HUGEPT_MASK)
+				mm->context.part_huge = addr + len;
+#endif
+			return addr;
+		}
+		addr = ALIGN_HUGEPT(vma->vm_end);
+	}
+}
+
+unsigned long
+hugetlb_get_unmapped_area(struct file *file, unsigned long addr,
+		unsigned long len, unsigned long pgoff, unsigned long flags)
+{
+	struct hstate *h = hstate_file(file);
+
+	if (len & ~huge_page_mask(h))
+		return -EINVAL;
+	if (len > TASK_SIZE)
+		return -ENOMEM;
+
+	if (flags & MAP_FIXED) {
+		if (prepare_hugepage_range(file, addr, len))
+			return -EINVAL;
+		return addr;
+	}
+
+	if (addr) {
+		addr = ALIGN(addr, huge_page_size(h));
+		if (!prepare_hugepage_range(file, addr, len))
+			return addr;
+	}
+
+	/*
+	 * Look for an existing hugetlb vma with space after it (this is to to
+	 * minimise fragmentation caused by huge pages.
+	 */
+	addr = hugetlb_get_unmapped_area_existing(len);
+	if (addr)
+		return addr;
+
+	/*
+	 * Find an unmapped naturally aligned set of 4MB blocks that we can use
+	 * for huge pages.
+	 */
+	addr = hugetlb_get_unmapped_area_new_pmd(len);
+	if (likely(addr))
+		return addr;
+
+	return -EINVAL;
+}
+
+#endif /*HAVE_ARCH_HUGETLB_UNMAPPED_AREA*/
+
+/* necessary for boot time 4MB huge page allocation */
+static __init int setup_hugepagesz(char *opt)
+{
+	unsigned long ps = memparse(opt, &opt);
+	if (ps == (1 << HPAGE_SHIFT)) {
+		hugetlb_add_hstate(HPAGE_SHIFT - PAGE_SHIFT);
+	} else {
+		pr_err("hugepagesz: Unsupported page size %lu M\n",
+		       ps >> 20);
+		return 0;
+	}
+	return 1;
+}
+__setup("hugepagesz=", setup_hugepagesz);
-- 
1.7.7.6


