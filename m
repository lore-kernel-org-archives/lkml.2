Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031128Ab2ERKk5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 06:40:57 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42641 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760701Ab2ERKkz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 06:40:55 -0400
Date: Fri, 18 May 2012 03:40:28 -0700
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-7hq9q1dctjz61gosc1tqnse5@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl, pjt@google.com,
        cl@linux.com, riel@redhat.com, akpm@linux-foundation.org,
        bharata.rao@gmail.com, aarcange@redhat.com, Lee.Schermerhorn@hp.com,
        suresh.b.siddha@intel.com, danms@us.ibm.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org, pjt@google.com,
        cl@linux.com, riel@redhat.com, bharata.rao@gmail.com,
        akpm@linux-foundation.org, Lee.Schermerhorn@hp.com,
        aarcange@redhat.com, danms@us.ibm.com, suresh.b.siddha@intel.com,
        tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/numa] mm: Change copy_page_range()
  to take two vma arguments
Git-Commit-ID: 717a4cdb5f6b57e2b463c6fec63a1508d19d1f41
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 18 May 2012 03:40:34 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  717a4cdb5f6b57e2b463c6fec63a1508d19d1f41
Gitweb:     http://git.kernel.org/tip/717a4cdb5f6b57e2b463c6fec63a1508d19d1f41
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Tue, 15 May 2012 23:49:53 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 18 May 2012 08:16:26 +0200

mm: Change copy_page_range() to take two vma arguments

Since copy_page_range() copies from one vma into another, pass it the
two VMAs. This makes dst_vma available inside the callchain and allows
for per vma rss accounting later on.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Paul Turner <pjt@google.com>
Cc: Dan Smith <danms@us.ibm.com>
Cc: Bharata B Rao <bharata.rao@gmail.com>
Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/n/tip-7hq9q1dctjz61gosc1tqnse5@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/linux/huge_mm.h |    9 ++---
 include/linux/mm.h      |    3 +-
 kernel/fork.c           |    2 +-
 mm/huge_memory.c        |    8 ++--
 mm/memory.c             |   77 ++++++++++++++++++++++------------------------
 5 files changed, 47 insertions(+), 52 deletions(-)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index c8af7a2..1fab89c 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -5,9 +5,8 @@ extern int do_huge_pmd_anonymous_page(struct mm_struct *mm,
 				      struct vm_area_struct *vma,
 				      unsigned long address, pmd_t *pmd,
 				      unsigned int flags);
-extern int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
-			 pmd_t *dst_pmd, pmd_t *src_pmd, unsigned long addr,
-			 struct vm_area_struct *vma);
+extern int copy_huge_pmd(struct vm_area_struct *dst_vma, struct vm_area_struct *src_vma,
+			 pmd_t *dst_pmd, pmd_t *src_pmd, unsigned long addr);
 extern int do_huge_pmd_wp_page(struct mm_struct *mm, struct vm_area_struct *vma,
 			       unsigned long address, pmd_t *pmd,
 			       pmd_t orig_pmd);
@@ -82,9 +81,9 @@ extern pmd_t *page_check_address_pmd(struct page *page,
 #endif /* CONFIG_DEBUG_VM */
 
 extern unsigned long transparent_hugepage_flags;
-extern int copy_pte_range(struct mm_struct *dst_mm, struct mm_struct *src_mm,
+extern int copy_pte_range(struct vm_area_struct *dst_vma,
+			  struct vm_area_struct *src_vma,
 			  pmd_t *dst_pmd, pmd_t *src_pmd,
-			  struct vm_area_struct *vma,
 			  unsigned long addr, unsigned long end);
 extern int handle_pte_fault(struct mm_struct *mm,
 			    struct vm_area_struct *vma, unsigned long address,
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 74aa71b..75affe7 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -933,8 +933,7 @@ int walk_page_range(unsigned long addr, unsigned long end,
 		struct mm_walk *walk);
 void free_pgd_range(struct mmu_gather *tlb, unsigned long addr,
 		unsigned long end, unsigned long floor, unsigned long ceiling);
-int copy_page_range(struct mm_struct *dst, struct mm_struct *src,
-			struct vm_area_struct *vma);
+int copy_page_range(struct vm_area_struct *dst_vma, struct vm_area_struct *src_vma);
 void unmap_mapping_range(struct address_space *mapping,
 		loff_t const holebegin, loff_t const holelen, int even_cows);
 int follow_pfn(struct vm_area_struct *vma, unsigned long address,
diff --git a/kernel/fork.c b/kernel/fork.c
index 89deafa..8ff8a7f 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -440,7 +440,7 @@ static int dup_mmap(struct mm_struct *mm, struct mm_struct *oldmm)
 		rb_parent = &tmp->vm_rb;
 
 		mm->map_count++;
-		retval = copy_page_range(mm, oldmm, mpnt);
+		retval = copy_page_range(tmp, mpnt);
 
 		if (tmp->vm_ops && tmp->vm_ops->open)
 			tmp->vm_ops->open(tmp);
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index f0e5306..54038f2 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -748,10 +748,10 @@ out:
 	return handle_pte_fault(mm, vma, address, pte, pmd, flags);
 }
 
-int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
-		  pmd_t *dst_pmd, pmd_t *src_pmd, unsigned long addr,
-		  struct vm_area_struct *vma)
+int copy_huge_pmd(struct vm_area_struct *dst_vma, struct vm_area_struct *src_vma,
+		  pmd_t *dst_pmd, pmd_t *src_pmd, unsigned long addr)
 {
+	struct mm_struct *dst_mm = dst_vma->vm_mm, *src_mm = src_vma->vm_mm;
 	struct page *src_page;
 	pmd_t pmd;
 	pgtable_t pgtable;
@@ -777,7 +777,7 @@ int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
 		spin_unlock(&dst_mm->page_table_lock);
 		pte_free(dst_mm, pgtable);
 
-		wait_split_huge_page(vma->anon_vma, src_pmd); /* src_vma */
+		wait_split_huge_page(src_vma->anon_vma, src_pmd); /* src_vma */
 		goto out;
 	}
 	src_page = pmd_page(pmd);
diff --git a/mm/memory.c b/mm/memory.c
index 08a3489..8127ee9 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -830,11 +830,11 @@ out:
  */
 
 static inline unsigned long
-copy_one_pte(struct mm_struct *dst_mm, struct mm_struct *src_mm,
-		pte_t *dst_pte, pte_t *src_pte, struct vm_area_struct *vma,
-		unsigned long addr, int *rss)
+copy_one_pte(struct vm_area_struct *dst_vma, struct vm_area_struct *src_vma,
+		pte_t *dst_pte, pte_t *src_pte, unsigned long addr, int *rss)
 {
-	unsigned long vm_flags = vma->vm_flags;
+	struct mm_struct *dst_mm = dst_vma->vm_mm, *src_mm = src_vma->vm_mm;
+	unsigned long vm_flags = src_vma->vm_flags;
 	pte_t pte = *src_pte;
 	struct page *page;
 
@@ -896,7 +896,7 @@ copy_one_pte(struct mm_struct *dst_mm, struct mm_struct *src_mm,
 		pte = pte_mkclean(pte);
 	pte = pte_mkold(pte);
 
-	page = vm_normal_page(vma, addr, pte);
+	page = vm_normal_page(src_vma, addr, pte);
 	if (page) {
 		get_page(page);
 		page_dup_rmap(page);
@@ -911,10 +911,10 @@ out_set_pte:
 	return 0;
 }
 
-int copy_pte_range(struct mm_struct *dst_mm, struct mm_struct *src_mm,
-		   pmd_t *dst_pmd, pmd_t *src_pmd, struct vm_area_struct *vma,
-		   unsigned long addr, unsigned long end)
+int copy_pte_range(struct vm_area_struct *dst_vma, struct vm_area_struct *src_vma,
+		pmd_t *dst_pmd, pmd_t *src_pmd, unsigned long addr, unsigned long end)
 {
+	struct mm_struct *dst_mm = dst_vma->vm_mm, *src_mm = src_vma->vm_mm;
 	pte_t *orig_src_pte, *orig_dst_pte;
 	pte_t *src_pte, *dst_pte;
 	spinlock_t *src_ptl, *dst_ptl;
@@ -950,8 +950,8 @@ again:
 			progress++;
 			continue;
 		}
-		entry.val = copy_one_pte(dst_mm, src_mm, dst_pte, src_pte,
-							vma, addr, rss);
+		entry.val = copy_one_pte(dst_vma, src_vma,
+					 dst_pte, src_pte, addr, rss);
 		if (entry.val)
 			break;
 		progress += 8;
@@ -974,14 +974,14 @@ again:
 	return 0;
 }
 
-static inline int copy_pmd_range(struct mm_struct *dst_mm, struct mm_struct *src_mm,
-		pud_t *dst_pud, pud_t *src_pud, struct vm_area_struct *vma,
-		unsigned long addr, unsigned long end)
+static inline
+int copy_pmd_range(struct vm_area_struct *dst_vma, struct vm_area_struct *src_vma,
+		pud_t *dst_pud, pud_t *src_pud, unsigned long addr, unsigned long end)
 {
 	pmd_t *src_pmd, *dst_pmd;
 	unsigned long next;
 
-	dst_pmd = pmd_alloc(dst_mm, dst_pud, addr);
+	dst_pmd = pmd_alloc(dst_vma->vm_mm, dst_pud, addr);
 	if (!dst_pmd)
 		return -ENOMEM;
 	src_pmd = pmd_offset(src_pud, addr);
@@ -990,8 +990,7 @@ static inline int copy_pmd_range(struct mm_struct *dst_mm, struct mm_struct *src
 		if (pmd_trans_huge(*src_pmd)) {
 			int err;
 			VM_BUG_ON(next-addr != HPAGE_PMD_SIZE);
-			err = copy_huge_pmd(dst_mm, src_mm,
-					    dst_pmd, src_pmd, addr, vma);
+			err = copy_huge_pmd(dst_vma, src_vma, dst_pmd, src_pmd, addr);
 			if (err == -ENOMEM)
 				return -ENOMEM;
 			if (!err)
@@ -1000,21 +999,20 @@ static inline int copy_pmd_range(struct mm_struct *dst_mm, struct mm_struct *src
 		}
 		if (pmd_none_or_clear_bad(src_pmd))
 			continue;
-		if (copy_pte_range(dst_mm, src_mm, dst_pmd, src_pmd,
-						vma, addr, next))
+		if (copy_pte_range(dst_vma, src_vma, dst_pmd, src_pmd, addr, next))
 			return -ENOMEM;
 	} while (dst_pmd++, src_pmd++, addr = next, addr != end);
 	return 0;
 }
 
-static inline int copy_pud_range(struct mm_struct *dst_mm, struct mm_struct *src_mm,
-		pgd_t *dst_pgd, pgd_t *src_pgd, struct vm_area_struct *vma,
-		unsigned long addr, unsigned long end)
+static inline
+int copy_pud_range(struct vm_area_struct *dst_vma, struct vm_area_struct *src_vma,
+		pgd_t *dst_pgd, pgd_t *src_pgd, unsigned long addr, unsigned long end)
 {
 	pud_t *src_pud, *dst_pud;
 	unsigned long next;
 
-	dst_pud = pud_alloc(dst_mm, dst_pgd, addr);
+	dst_pud = pud_alloc(dst_vma->vm_mm, dst_pgd, addr);
 	if (!dst_pud)
 		return -ENOMEM;
 	src_pud = pud_offset(src_pgd, addr);
@@ -1022,20 +1020,20 @@ static inline int copy_pud_range(struct mm_struct *dst_mm, struct mm_struct *src
 		next = pud_addr_end(addr, end);
 		if (pud_none_or_clear_bad(src_pud))
 			continue;
-		if (copy_pmd_range(dst_mm, src_mm, dst_pud, src_pud,
-						vma, addr, next))
+		if (copy_pmd_range(dst_vma, src_vma, dst_pud, src_pud, addr, next))
 			return -ENOMEM;
 	} while (dst_pud++, src_pud++, addr = next, addr != end);
 	return 0;
 }
 
-int copy_page_range(struct mm_struct *dst_mm, struct mm_struct *src_mm,
-		struct vm_area_struct *vma)
+int copy_page_range(struct vm_area_struct *dst_vma, struct vm_area_struct *src_vma)
 {
+	struct mm_struct *dst_mm = dst_vma->vm_mm, *src_mm = src_vma->vm_mm;
 	pgd_t *src_pgd, *dst_pgd;
 	unsigned long next;
-	unsigned long addr = vma->vm_start;
-	unsigned long end = vma->vm_end;
+	unsigned long addr = src_vma->vm_start;
+	unsigned long end = src_vma->vm_end;
+	vm_flags_t vm_flags = src_vma->vm_flags;
 	int ret;
 
 	/*
@@ -1044,20 +1042,20 @@ int copy_page_range(struct mm_struct *dst_mm, struct mm_struct *src_mm,
 	 * readonly mappings. The tradeoff is that copy_page_range is more
 	 * efficient than faulting.
 	 */
-	if (!(vma->vm_flags & (VM_HUGETLB|VM_NONLINEAR|VM_PFNMAP|VM_INSERTPAGE))) {
-		if (!vma->anon_vma)
+	if (!(vm_flags & (VM_HUGETLB|VM_NONLINEAR|VM_PFNMAP|VM_INSERTPAGE))) {
+		if (!src_vma->anon_vma)
 			return 0;
 	}
 
-	if (is_vm_hugetlb_page(vma))
-		return copy_hugetlb_page_range(dst_mm, src_mm, vma);
+	if (is_vm_hugetlb_page(src_vma))
+		return copy_hugetlb_page_range(dst_mm, src_mm, src_vma);
 
-	if (unlikely(is_pfn_mapping(vma))) {
+	if (unlikely(is_pfn_mapping(src_vma))) {
 		/*
 		 * We do not free on error cases below as remove_vma
 		 * gets called on error from higher level routine
 		 */
-		ret = track_pfn_vma_copy(vma);
+		ret = track_pfn_vma_copy(src_vma);
 		if (ret)
 			return ret;
 	}
@@ -1068,7 +1066,7 @@ int copy_page_range(struct mm_struct *dst_mm, struct mm_struct *src_mm,
 	 * parent mm. And a permission downgrade will only happen if
 	 * is_cow_mapping() returns true.
 	 */
-	if (is_cow_mapping(vma->vm_flags))
+	if (is_cow_mapping(vm_flags))
 		mmu_notifier_invalidate_range_start(src_mm, addr, end);
 
 	ret = 0;
@@ -1078,16 +1076,15 @@ int copy_page_range(struct mm_struct *dst_mm, struct mm_struct *src_mm,
 		next = pgd_addr_end(addr, end);
 		if (pgd_none_or_clear_bad(src_pgd))
 			continue;
-		if (unlikely(copy_pud_range(dst_mm, src_mm, dst_pgd, src_pgd,
-					    vma, addr, next))) {
+		if (unlikely(copy_pud_range(dst_vma, src_vma, dst_pgd, src_pgd,
+					    addr, next))) {
 			ret = -ENOMEM;
 			break;
 		}
 	} while (dst_pgd++, src_pgd++, addr = next, addr != end);
 
-	if (is_cow_mapping(vma->vm_flags))
-		mmu_notifier_invalidate_range_end(src_mm,
-						  vma->vm_start, end);
+	if (is_cow_mapping(vm_flags))
+		mmu_notifier_invalidate_range_end(src_mm, src_vma->vm_start, end);
 	return ret;
 }
 
