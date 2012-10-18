Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932605Ab2JRRE4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 13:04:56 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46745 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932343Ab2JRREy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 13:04:54 -0400
Date: Thu, 18 Oct 2012 10:04:41 -0700
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-h1utred3dhv2ausjg1wqwuym@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:numa/core] sched/numa/mm:
  Avoid pointless TLB invalidation from page-migration
Git-Commit-ID: 5cc4a4cb0abc63699b6741d7737e07e49b502782
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 18 Oct 2012 10:04:46 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5cc4a4cb0abc63699b6741d7737e07e49b502782
Gitweb:     http://git.kernel.org/tip/5cc4a4cb0abc63699b6741d7737e07e49b502782
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Thu, 11 Oct 2012 17:42:06 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 15 Oct 2012 13:56:50 +0200

sched/numa/mm: Avoid pointless TLB invalidation from page-migration

When we do migrate-on-fault we faulted on a PROT_NONE entry, this is
a !present entry, we then replace this with a regular entry and then
proceed with page-migration.

Page-migration in turn replaces the now valid entry with a
migration-PTE (which is again !present) which requires a TLB
invalidate.

Instead, leave the PROT_NONE entry in-place when we need to migrate
such that the PROT_NONE -> migration-PTE transition is a !preset ->
!preset transition and doesn't require a TLB invalidate.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/n/tip-h1utred3dhv2ausjg1wqwuym@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 mm/memory.c |   63 +++++++++++++++++++++++++++++------------------------------
 1 files changed, 31 insertions(+), 32 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 9ada7ed..8b1ad86 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -3442,38 +3442,12 @@ static bool pte_prot_none(struct vm_area_struct *vma, pte_t pte)
 	return pte_same(pte, pte_modify(pte, vma_prot_none(vma)));
 }
 
-#ifdef CONFIG_NUMA
-
-
-static void do_prot_none_numa(struct mm_struct *mm, struct vm_area_struct *vma,
-			      unsigned long address, struct page *page)
-{
-	int node, page_nid = page_to_nid(page);
-
-	task_numa_placement();
-
-	/*
-	 * For NUMA systems we use the special PROT_NONE maps to drive
-	 * lazy page migration, see MPOL_MF_LAZY and related.
-	 */
-	node = mpol_misplaced(page, vma, address);
-	if (node != -1 && !migrate_misplaced_page(mm, page, node))
-		page_nid = node;
-
-	task_numa_fault(page_nid);
-}
-#else
-static void do_prot_none_numa(struct mm_struct *mm, struct vm_area_struct *vma,
-			      unsigned long address, struct page *page)
-{
-}
-#endif /* CONFIG_NUMA */
-
 static int do_prot_none(struct mm_struct *mm, struct vm_area_struct *vma,
 			unsigned long address, pte_t *ptep, pmd_t *pmd,
 			unsigned int flags, pte_t entry)
 {
 	struct page *page = NULL;
+	int node, page_nid = -1;
 	spinlock_t *ptl;
 
 	ptl = pte_lockptr(mm, pmd);
@@ -3481,6 +3455,16 @@ static int do_prot_none(struct mm_struct *mm, struct vm_area_struct *vma,
 	if (unlikely(!pte_same(*ptep, entry)))
 		goto unlock;
 
+	page = vm_normal_page(vma, address, entry);
+	if (page) {
+		get_page(page);
+		page_nid = page_to_nid(page);
+		node = mpol_misplaced(page, vma, address);
+		if (node != -1)
+			goto migrate;
+	}
+
+fixup:
 	flush_cache_page(vma, address, pte_pfn(entry));
 
 	ptep_modify_prot_start(mm, address, ptep);
@@ -3489,17 +3473,32 @@ static int do_prot_none(struct mm_struct *mm, struct vm_area_struct *vma,
 
 	update_mmu_cache(vma, address, ptep);
 
-	page = vm_normal_page(vma, address, entry);
-	if (page)
-		get_page(page);
-
 unlock:
 	pte_unmap_unlock(ptep, ptl);
+out:
 	if (page) {
-		do_prot_none_numa(mm, vma, address, page);
+		task_numa_fault(page_nid, 1);
 		put_page(page);
 	}
+
 	return 0;
+
+migrate:
+	pte_unmap_unlock(ptep, ptl);
+
+	if (!migrate_misplaced_page(mm, page, node)) {
+		page_nid = node;
+		goto out;
+	}
+
+	ptep = pte_offset_map_lock(mm, pmd, address, &ptl);
+	if (!pte_same(*ptep, entry)) {
+		put_page(page);
+		page = NULL;
+		goto unlock;
+	}
+
+	goto fixup;
 }
 
 /*
