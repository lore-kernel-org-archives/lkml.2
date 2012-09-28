Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756837Ab2I1H4P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 03:56:15 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37985 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756540Ab2I1H4M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 03:56:12 -0400
Date: Fri, 28 Sep 2012 00:55:43 -0700
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-fvywddcv5mj2lr0y76i7ai1j@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl, riel@redhat.com,
        akpm@linux-foundation.org, tglx@linutronix.de
Reply-To: riel@redhat.com, mingo@kernel.org, hpa@zytor.com,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org,
        tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/numa] mm: Optimize do_prot_none()
Git-Commit-ID: 1a201bacffd9f7cbc0f9a3b790dcb8108336784d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 28 Sep 2012 00:55:51 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1a201bacffd9f7cbc0f9a3b790dcb8108336784d
Gitweb:     http://git.kernel.org/tip/1a201bacffd9f7cbc0f9a3b790dcb8108336784d
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Wed, 26 Sep 2012 16:05:01 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 27 Sep 2012 14:46:02 +0200

mm: Optimize do_prot_none()

Reduces do_prot_none() to a single pte_lock acquisition in the !migrate case.

Also flipping the protection bits back sooner avoids the chance of
other CPUs hitting it and causing a pile-up on the pte_lock.

This significantly reduces contention on the pte_lock in a NUMA page fault
benchmark, system time dropped from around 78% to 35% and __memset_sse2()
is the most expensive function instead of _raw_spin_lock()/handle_pte_fault().

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Rik van Riel <riel@redhat.com>
Link: http://lkml.kernel.org/n/tip-fvywddcv5mj2lr0y76i7ai1j@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 mm/memory.c |   66 +++++++++++++++++++++++++----------------------------------
 1 files changed, 28 insertions(+), 38 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index d896a24..965eeef 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -3438,56 +3438,39 @@ static bool pte_prot_none(struct vm_area_struct *vma, pte_t pte)
 	return pte_same(pte, pte_modify(pte, vma_prot_none(vma)));
 }
 
-static int do_prot_none(struct mm_struct *mm, struct vm_area_struct *vma,
-			unsigned long address, pte_t *ptep, pmd_t *pmd,
-			unsigned int flags, pte_t entry)
+#ifdef CONFIG_NUMA
+static void do_prot_none_numa(struct mm_struct *mm, struct vm_area_struct *vma,
+			      unsigned long address, struct page *page)
 {
-	struct page *page = NULL;
-	spinlock_t *ptl;
 	int node;
 
-	ptl = pte_lockptr(mm, pmd);
-	spin_lock(ptl);
-	if (unlikely(!pte_same(*ptep, entry)))
-		goto unlock;
-
-#ifdef CONFIG_NUMA
 	/*
 	 * For NUMA systems we use the special PROT_NONE maps to drive
 	 * lazy page migration, see MPOL_MF_LAZY and related.
 	 */
-	page = vm_normal_page(vma, address, entry);
-	if (!page)
-		goto do_fixup_locked;
-
-	get_page(page);
-	pte_unmap_unlock(ptep, ptl);
-
 	node = mpol_misplaced(page, vma, address);
-	if (node == -1)
-		goto do_fixup;
+	if (node != -1)
+		migrate_misplaced_page(mm, page, node);
+}
+#else
+static void do_prot_none_numa(struct mm_struct *mm, struct vm_area_struct *vma,
+			      unsigned long address, struct page *page)
+{
+}
+#endif /* CONFIG_NUMA */
 
-	/*
-	 * Page migration will install a new pte with vma->vm_page_prot,
-	 * otherwise fall-through to the fixup. Next time,.. perhaps.
-	 */
-	if (!migrate_misplaced_page(mm, page, node)) {
-		put_page(page);
-		return 0;
-	}
+static int do_prot_none(struct mm_struct *mm, struct vm_area_struct *vma,
+			unsigned long address, pte_t *ptep, pmd_t *pmd,
+			unsigned int flags, pte_t entry)
+{
+	struct page *page = NULL;
+	spinlock_t *ptl;
 
-do_fixup:
-	/*
-	 * OK, nothing to do,.. change the protection back to what it
-	 * ought to be.
-	 */
-	ptep = pte_offset_map_lock(mm, pmd, address, &ptl);
+	ptl = pte_lockptr(mm, pmd);
+	spin_lock(ptl);
 	if (unlikely(!pte_same(*ptep, entry)))
 		goto unlock;
 
-do_fixup_locked:
-#endif /* CONFIG_NUMA */
-
 	flush_cache_page(vma, address, pte_pfn(entry));
 
 	ptep_modify_prot_start(mm, address, ptep);
@@ -3495,10 +3478,17 @@ do_fixup_locked:
 	ptep_modify_prot_commit(mm, address, ptep, entry);
 
 	update_mmu_cache(vma, address, ptep);
+
+	page = vm_normal_page(vma, address, entry);
+	if (page)
+		get_page(page);
+
 unlock:
 	pte_unmap_unlock(ptep, ptl);
-	if (page)
+	if (page) {
+		do_prot_none_numa(mm, vma, address, page);
 		put_page(page);
+	}
 	return 0;
 }
 
