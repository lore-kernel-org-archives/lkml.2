Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755632Ab2I0GGj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 02:06:39 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54699 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755035Ab2I0GGg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 02:06:36 -0400
Date: Wed, 26 Sep 2012 23:06:20 -0700
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-e98gyl8kr9jzooh2s4piuils@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl, pjt@google.com,
        riel@redhat.com, akpm@linux-foundation.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org, pjt@google.com,
        riel@redhat.com, akpm@linux-foundation.org, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/numa] mm/mpol: Use special PROT_NONE to migrate pages
Git-Commit-ID: 39d6cb39a81744473e13c693a9f988a9e342018b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 26 Sep 2012 23:06:26 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  39d6cb39a81744473e13c693a9f988a9e342018b
Gitweb:     http://git.kernel.org/tip/39d6cb39a81744473e13c693a9f988a9e342018b
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Tue, 17 Jul 2012 22:54:51 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 26 Sep 2012 11:48:35 +0200

mm/mpol: Use special PROT_NONE to migrate pages

Combine our previous PROT_NONE, mpol_misplaced and
migrate_misplaced_page() pieces into an effective migrate on fault
scheme.

Suggested-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Reviewed-by: Rik van Riel <riel@redhat.com>
Cc: Paul Turner <pjt@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Link: http://lkml.kernel.org/n/tip-e98gyl8kr9jzooh2s4piuils@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 mm/huge_memory.c |   41 ++++++++++++++++++++++++++++++++++++++++-
 mm/memory.c      |   42 ++++++++++++++++++++++++++++++++++++------
 2 files changed, 76 insertions(+), 7 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 5d7b114..a147d29 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -17,6 +17,7 @@
 #include <linux/khugepaged.h>
 #include <linux/freezer.h>
 #include <linux/mman.h>
+#include <linux/migrate.h>
 #include <asm/tlb.h>
 #include <asm/pgalloc.h>
 #include "internal.h"
@@ -766,12 +767,48 @@ void do_huge_pmd_prot_none(struct mm_struct *mm, struct vm_area_struct *vma,
 			   unsigned int flags, pmd_t entry)
 {
 	unsigned long haddr = address & HPAGE_PMD_MASK;
+	struct page *page = NULL;
+	int node;
 
 	spin_lock(&mm->page_table_lock);
 	if (unlikely(!pmd_same(*pmd, entry)))
 		goto out_unlock;
 
-	/* do fancy stuff */
+	if (unlikely(pmd_trans_splitting(entry))) {
+		spin_unlock(&mm->page_table_lock);
+		wait_split_huge_page(vma->anon_vma, pmd);
+		return;
+	}
+
+#ifdef CONFIG_NUMA
+	page = pmd_page(entry);
+	VM_BUG_ON(!PageCompound(page) || !PageHead(page));
+
+	get_page(page);
+	spin_unlock(&mm->page_table_lock);
+
+	/*
+	 * XXX should we serialize against split_huge_page ?
+	 */
+
+	node = mpol_misplaced(page, vma, haddr);
+	if (node == -1)
+		goto do_fixup;
+
+	/*
+	 * Due to lacking code to migrate thp pages, we'll split
+	 * (which preserves the special PROT_NONE) and re-take the
+	 * fault on the normal pages.
+	 */
+	split_huge_page(page);
+	put_page(page);
+	return;
+
+do_fixup:
+	spin_lock(&mm->page_table_lock);
+	if (unlikely(!pmd_same(*pmd, entry)))
+		goto out_unlock;
+#endif
 
 	/* change back to regular protection */
 	entry = pmd_modify(entry, vma->vm_page_prot);
@@ -780,6 +817,8 @@ void do_huge_pmd_prot_none(struct mm_struct *mm, struct vm_area_struct *vma,
 
 out_unlock:
 	spin_unlock(&mm->page_table_lock);
+	if (page)
+		put_page(page);
 }
 
 int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
diff --git a/mm/memory.c b/mm/memory.c
index bea2ed5..d896a24 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -57,6 +57,7 @@
 #include <linux/swapops.h>
 #include <linux/elf.h>
 #include <linux/gfp.h>
+#include <linux/migrate.h>
 
 #include <asm/io.h>
 #include <asm/pgalloc.h>
@@ -3441,17 +3442,42 @@ static int do_prot_none(struct mm_struct *mm, struct vm_area_struct *vma,
 			unsigned long address, pte_t *ptep, pmd_t *pmd,
 			unsigned int flags, pte_t entry)
 {
+	struct page *page = NULL;
 	spinlock_t *ptl;
-	int ret = 0;
+	int node;
 
-	if (!pte_unmap_same(mm, pmd, ptep, entry))
-		goto out;
+	ptl = pte_lockptr(mm, pmd);
+	spin_lock(ptl);
+	if (unlikely(!pte_same(*ptep, entry)))
+		goto unlock;
 
+#ifdef CONFIG_NUMA
 	/*
-	 * Do fancy stuff...
+	 * For NUMA systems we use the special PROT_NONE maps to drive
+	 * lazy page migration, see MPOL_MF_LAZY and related.
 	 */
+	page = vm_normal_page(vma, address, entry);
+	if (!page)
+		goto do_fixup_locked;
+
+	get_page(page);
+	pte_unmap_unlock(ptep, ptl);
+
+	node = mpol_misplaced(page, vma, address);
+	if (node == -1)
+		goto do_fixup;
 
 	/*
+	 * Page migration will install a new pte with vma->vm_page_prot,
+	 * otherwise fall-through to the fixup. Next time,.. perhaps.
+	 */
+	if (!migrate_misplaced_page(mm, page, node)) {
+		put_page(page);
+		return 0;
+	}
+
+do_fixup:
+	/*
 	 * OK, nothing to do,.. change the protection back to what it
 	 * ought to be.
 	 */
@@ -3459,6 +3485,9 @@ static int do_prot_none(struct mm_struct *mm, struct vm_area_struct *vma,
 	if (unlikely(!pte_same(*ptep, entry)))
 		goto unlock;
 
+do_fixup_locked:
+#endif /* CONFIG_NUMA */
+
 	flush_cache_page(vma, address, pte_pfn(entry));
 
 	ptep_modify_prot_start(mm, address, ptep);
@@ -3468,8 +3497,9 @@ static int do_prot_none(struct mm_struct *mm, struct vm_area_struct *vma,
 	update_mmu_cache(vma, address, ptep);
 unlock:
 	pte_unmap_unlock(ptep, ptl);
-out:
-	return ret;
+	if (page)
+		put_page(page);
+	return 0;
 }
 
 /*
