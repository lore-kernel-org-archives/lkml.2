Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755208Ab2I0GB6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 02:01:58 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54621 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754919Ab2I0GB4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 02:01:56 -0400
Date: Wed, 26 Sep 2012 23:01:38 -0700
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-0g5k80y4df8l83lha9j75xph@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl, pjt@google.com,
        riel@redhat.com, akpm@linux-foundation.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org, pjt@google.com,
        riel@redhat.com, akpm@linux-foundation.org, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/numa] mm/mpol: Create special PROT_NONE infrastructure
Git-Commit-ID: a573b4dfcf58f86235d586ea1f82ed54b2b7e620
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 26 Sep 2012 23:01:44 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a573b4dfcf58f86235d586ea1f82ed54b2b7e620
Gitweb:     http://git.kernel.org/tip/a573b4dfcf58f86235d586ea1f82ed54b2b7e620
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Tue, 17 Jul 2012 18:25:14 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 26 Sep 2012 11:48:32 +0200

mm/mpol: Create special PROT_NONE infrastructure

In order to facilitate a lazy -- fault driven -- migration of pages,
create a special transient PROT_NONE variant, we can then use the
'spurious' protection faults to drive our migrations from.

Pages that already had an effective PROT_NONE mapping will not
be detected to generate these 'spuriuos' faults for the simple reason
that we cannot distinguish them on their protection bits, see
pte_prot_none.

This isn't a problem since PROT_NONE (and possible PROT_WRITE with
dirty tracking) aren't used or are rare enough for us to not care
about their placement.

Suggested-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Reviewed-by: Rik van Riel <riel@redhat.com>
Cc: Paul Turner <pjt@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Link: http://lkml.kernel.org/n/tip-0g5k80y4df8l83lha9j75xph@git.kernel.org
[ fixed various cross-arch and THP/!THP details ]
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/linux/huge_mm.h   |   19 +++++++++++
 include/linux/mempolicy.h |    4 ++-
 include/linux/mm.h        |   12 +++++++
 mm/huge_memory.c          |   32 +++++++++++++++++++
 mm/memory.c               |   75 ++++++++++++++++++++++++++++++++++++++++----
 mm/mempolicy.c            |   24 ++++++++++++++
 mm/mprotect.c             |   24 ++++++++++----
 7 files changed, 175 insertions(+), 15 deletions(-)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index 4c59b11..ed60d79 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -160,6 +160,13 @@ static inline struct page *compound_trans_head(struct page *page)
 	}
 	return page;
 }
+
+extern bool pmd_prot_none(struct vm_area_struct *vma, pmd_t pmd);
+
+extern void do_huge_pmd_prot_none(struct mm_struct *mm, struct vm_area_struct *vma,
+				  unsigned long address, pmd_t *pmd,
+				  unsigned int flags, pmd_t orig_pmd);
+
 #else /* CONFIG_TRANSPARENT_HUGEPAGE */
 #define HPAGE_PMD_SHIFT ({ BUILD_BUG(); 0; })
 #define HPAGE_PMD_MASK ({ BUILD_BUG(); 0; })
@@ -196,6 +203,18 @@ static inline int pmd_trans_huge_lock(pmd_t *pmd,
 {
 	return 0;
 }
+
+static inline bool pmd_prot_none(struct vm_area_struct *vma, pmd_t pmd)
+{
+	return false;
+}
+
+static inline void do_huge_pmd_prot_none(struct mm_struct *mm, struct vm_area_struct *vma,
+				  unsigned long address, pmd_t *pmd,
+				  unsigned int flags, pmd_t orig_pmd)
+{
+}
+
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
 #endif /* _LINUX_HUGE_MM_H */
diff --git a/include/linux/mempolicy.h b/include/linux/mempolicy.h
index 7c73042..dbd48cc 100644
--- a/include/linux/mempolicy.h
+++ b/include/linux/mempolicy.h
@@ -254,7 +254,9 @@ static inline int vma_migratable(struct vm_area_struct *vma)
 	return 1;
 }
 
-#else
+extern void lazy_migrate_process(struct mm_struct *mm);
+
+#else /* CONFIG_NUMA */
 
 struct mempolicy {};
 
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 7d573b8..5f59128 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1088,6 +1088,9 @@ extern unsigned long move_page_tables(struct vm_area_struct *vma,
 extern unsigned long do_mremap(unsigned long addr,
 			       unsigned long old_len, unsigned long new_len,
 			       unsigned long flags, unsigned long new_addr);
+extern void change_protection(struct vm_area_struct *vma, unsigned long start,
+			      unsigned long end, pgprot_t newprot,
+			      int dirty_accountable);
 extern int mprotect_fixup(struct vm_area_struct *vma,
 			  struct vm_area_struct **pprev, unsigned long start,
 			  unsigned long end, unsigned long newflags);
@@ -1539,6 +1542,15 @@ static inline pgprot_t vm_get_page_prot(unsigned long vm_flags)
 }
 #endif
 
+static inline pgprot_t vma_prot_none(struct vm_area_struct *vma)
+{
+	/*
+	 * obtain PROT_NONE by removing READ|WRITE|EXEC privs
+	 */
+	vm_flags_t vmflags = vma->vm_flags & ~(VM_READ|VM_WRITE|VM_EXEC);
+	return pgprot_modify(vma->vm_page_prot, vm_get_page_prot(vmflags));
+}
+
 struct vm_area_struct *find_extend_vma(struct mm_struct *, unsigned long addr);
 int remap_pfn_range(struct vm_area_struct *, unsigned long addr,
 			unsigned long pfn, unsigned long size, pgprot_t);
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 4a74e34..5d7b114 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -750,6 +750,38 @@ out:
 	return handle_pte_fault(mm, vma, address, pte, pmd, flags);
 }
 
+bool pmd_prot_none(struct vm_area_struct *vma, pmd_t pmd)
+{
+	/*
+	 * See pte_prot_none().
+	 */
+	if (pmd_same(pmd, pmd_modify(pmd, vma->vm_page_prot)))
+		return false;
+
+	return pmd_same(pmd, pmd_modify(pmd, vma_prot_none(vma)));
+}
+
+void do_huge_pmd_prot_none(struct mm_struct *mm, struct vm_area_struct *vma,
+			   unsigned long address, pmd_t *pmd,
+			   unsigned int flags, pmd_t entry)
+{
+	unsigned long haddr = address & HPAGE_PMD_MASK;
+
+	spin_lock(&mm->page_table_lock);
+	if (unlikely(!pmd_same(*pmd, entry)))
+		goto out_unlock;
+
+	/* do fancy stuff */
+
+	/* change back to regular protection */
+	entry = pmd_modify(entry, vma->vm_page_prot);
+	if (pmdp_set_access_flags(vma, haddr, pmd, entry, 1))
+		update_mmu_cache(vma, address, entry);
+
+out_unlock:
+	spin_unlock(&mm->page_table_lock);
+}
+
 int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
 		  pmd_t *dst_pmd, pmd_t *src_pmd, unsigned long addr,
 		  struct vm_area_struct *vma)
diff --git a/mm/memory.c b/mm/memory.c
index 5736170..bea2ed5 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -3418,6 +3418,60 @@ static int do_nonlinear_fault(struct mm_struct *mm, struct vm_area_struct *vma,
 	return __do_fault(mm, vma, address, pmd, pgoff, flags, orig_pte);
 }
 
+static bool pte_prot_none(struct vm_area_struct *vma, pte_t pte)
+{
+	/*
+	 * If we have the normal vma->vm_page_prot protections we're not a
+	 * 'special' PROT_NONE page.
+	 *
+	 * This means we cannot get 'special' PROT_NONE faults from genuine
+	 * PROT_NONE maps, nor from PROT_WRITE file maps that do dirty
+	 * tracking.
+	 *
+	 * Neither case is really interesting for our current use though so we
+	 * don't care.
+	 */
+	if (pte_same(pte, pte_modify(pte, vma->vm_page_prot)))
+		return false;
+
+	return pte_same(pte, pte_modify(pte, vma_prot_none(vma)));
+}
+
+static int do_prot_none(struct mm_struct *mm, struct vm_area_struct *vma,
+			unsigned long address, pte_t *ptep, pmd_t *pmd,
+			unsigned int flags, pte_t entry)
+{
+	spinlock_t *ptl;
+	int ret = 0;
+
+	if (!pte_unmap_same(mm, pmd, ptep, entry))
+		goto out;
+
+	/*
+	 * Do fancy stuff...
+	 */
+
+	/*
+	 * OK, nothing to do,.. change the protection back to what it
+	 * ought to be.
+	 */
+	ptep = pte_offset_map_lock(mm, pmd, address, &ptl);
+	if (unlikely(!pte_same(*ptep, entry)))
+		goto unlock;
+
+	flush_cache_page(vma, address, pte_pfn(entry));
+
+	ptep_modify_prot_start(mm, address, ptep);
+	entry = pte_modify(entry, vma->vm_page_prot);
+	ptep_modify_prot_commit(mm, address, ptep, entry);
+
+	update_mmu_cache(vma, address, ptep);
+unlock:
+	pte_unmap_unlock(ptep, ptl);
+out:
+	return ret;
+}
+
 /*
  * These routines also need to handle stuff like marking pages dirty
  * and/or accessed for architectures that don't do it in hardware (most
@@ -3456,6 +3510,9 @@ int handle_pte_fault(struct mm_struct *mm,
 					pte, pmd, flags, entry);
 	}
 
+	if (pte_prot_none(vma, entry))
+		return do_prot_none(mm, vma, address, pte, pmd, flags, entry);
+
 	ptl = pte_lockptr(mm, pmd);
 	spin_lock(ptl);
 	if (unlikely(!pte_same(*pte, entry)))
@@ -3520,13 +3577,16 @@ retry:
 							  pmd, flags);
 	} else {
 		pmd_t orig_pmd = *pmd;
-		int ret;
+		int ret = 0;
 
 		barrier();
-		if (pmd_trans_huge(orig_pmd)) {
-			if (flags & FAULT_FLAG_WRITE &&
-			    !pmd_write(orig_pmd) &&
-			    !pmd_trans_splitting(orig_pmd)) {
+		if (pmd_trans_huge(orig_pmd) && !pmd_trans_splitting(orig_pmd)) {
+			if (pmd_prot_none(vma, orig_pmd)) {
+				do_huge_pmd_prot_none(mm, vma, address, pmd,
+						      flags, orig_pmd);
+			}
+
+			if ((flags & FAULT_FLAG_WRITE) && !pmd_write(orig_pmd)) {
 				ret = do_huge_pmd_wp_page(mm, vma, address, pmd,
 							  orig_pmd);
 				/*
@@ -3536,12 +3596,13 @@ retry:
 				 */
 				if (unlikely(ret & VM_FAULT_OOM))
 					goto retry;
-				return ret;
 			}
-			return 0;
+
+			return ret;
 		}
 	}
 
+
 	/*
 	 * Use __pte_alloc instead of pte_alloc_map, because we can't
 	 * run pte_offset_map on the pmd, if an huge pmd could
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 19f99e8..c4e6065 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -565,6 +565,12 @@ static inline int check_pgd_range(struct vm_area_struct *vma,
 	return 0;
 }
 
+static void
+change_prot_none(struct vm_area_struct *vma, unsigned long start, unsigned long end)
+{
+	change_protection(vma, start, end, vma_prot_none(vma), 0);
+}
+
 /*
  * Check if all pages in a range are on a set of nodes.
  * If pagelist != NULL then isolate pages from the LRU and
@@ -1197,6 +1203,24 @@ static long do_mbind(unsigned long start, unsigned long len,
 	return err;
 }
 
+static void lazy_migrate_vma(struct vm_area_struct *vma)
+{
+	if (!vma_migratable(vma))
+		return;
+
+	change_prot_none(vma, vma->vm_start, vma->vm_end);
+}
+
+void lazy_migrate_process(struct mm_struct *mm)
+{
+	struct vm_area_struct *vma;
+
+	down_read(&mm->mmap_sem);
+	for (vma = mm->mmap; vma; vma = vma->vm_next)
+		lazy_migrate_vma(vma);
+	up_read(&mm->mmap_sem);
+}
+
 /*
  * User space interface with variable sized bitmaps for nodelists.
  */
diff --git a/mm/mprotect.c b/mm/mprotect.c
index e97b0d6..392b124 100644
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -112,7 +112,7 @@ static inline void change_pud_range(struct vm_area_struct *vma, pgd_t *pgd,
 	} while (pud++, addr = next, addr != end);
 }
 
-static void change_protection(struct vm_area_struct *vma,
+static void change_protection_range(struct vm_area_struct *vma,
 		unsigned long addr, unsigned long end, pgprot_t newprot,
 		int dirty_accountable)
 {
@@ -134,6 +134,20 @@ static void change_protection(struct vm_area_struct *vma,
 	flush_tlb_range(vma, start, end);
 }
 
+void change_protection(struct vm_area_struct *vma, unsigned long start,
+		       unsigned long end, pgprot_t newprot,
+		       int dirty_accountable)
+{
+	struct mm_struct *mm = vma->vm_mm;
+
+	mmu_notifier_invalidate_range_start(mm, start, end);
+	if (is_vm_hugetlb_page(vma))
+		hugetlb_change_protection(vma, start, end, newprot);
+	else
+		change_protection_range(vma, start, end, newprot, dirty_accountable);
+	mmu_notifier_invalidate_range_end(mm, start, end);
+}
+
 int
 mprotect_fixup(struct vm_area_struct *vma, struct vm_area_struct **pprev,
 	unsigned long start, unsigned long end, unsigned long newflags)
@@ -206,12 +220,8 @@ success:
 		dirty_accountable = 1;
 	}
 
-	mmu_notifier_invalidate_range_start(mm, start, end);
-	if (is_vm_hugetlb_page(vma))
-		hugetlb_change_protection(vma, start, end, vma->vm_page_prot);
-	else
-		change_protection(vma, start, end, vma->vm_page_prot, dirty_accountable);
-	mmu_notifier_invalidate_range_end(mm, start, end);
+	change_protection(vma, start, end, vma->vm_page_prot, dirty_accountable);
+
 	vm_stat_account(mm, oldflags, vma->vm_file, -nrpages);
 	vm_stat_account(mm, newflags, vma->vm_file, nrpages);
 	perf_event_mmap(vma);
