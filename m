Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753726Ab2JUM63 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2012 08:58:29 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48871 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753442Ab2JUM61 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2012 08:58:27 -0400
Date: Sun, 21 Oct 2012 05:58:12 -0700
From: tip-bot for Ingo Molnar <mingo@kernel.org>
Message-ID: <tip-eb4f84b1aaad78ca07e274b81410ec9d60abe434@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org, riel@redhat.com,
        akpm@linux-foundation.org, aarcange@redhat.com, tglx@linutronix.de
Reply-To: riel@redhat.com, mingo@kernel.org, hpa@zytor.com,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl,
        aarcange@redhat.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:numa/core] numa, mm: Fix 4K migration races
Git-Commit-ID: eb4f84b1aaad78ca07e274b81410ec9d60abe434
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sun, 21 Oct 2012 05:58:17 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  eb4f84b1aaad78ca07e274b81410ec9d60abe434
Gitweb:     http://git.kernel.org/tip/eb4f84b1aaad78ca07e274b81410ec9d60abe434
Author:     Ingo Molnar <mingo@kernel.org>
AuthorDate: Sat, 20 Oct 2012 23:06:00 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sun, 21 Oct 2012 14:40:42 +0200

numa, mm: Fix 4K migration races

__unmap_and_move() can fail with -EAGAIN:

 - if we race with swapout picking up the page

 - if migrate_page_move_mapping() sees the
   page count changing unexpectedly

 - if two threads are trying to migrate the same page

There are other, more theoretical races as well, such as
the possibility of a pte being WSS mapped twice.

Fix them and clean up the code flow.

Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
Link: http://lkml.kernel.org/n/tip-wdyptm0xGskzbyatienQeft3@git.kernel.org
---
 mm/memory.c  |   44 ++++++++++++++++++++++++++++++++++++--------
 mm/migrate.c |   22 ++++++++++++----------
 2 files changed, 48 insertions(+), 18 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index c0de477..2cc8a29 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -3483,11 +3483,13 @@ static int do_prot_none(struct mm_struct *mm, struct vm_area_struct *vma,
 	struct page *page = NULL;
 	int node, page_nid = -1;
 	spinlock_t *ptl;
+	int account = 1;
+	int locked = 0;
 
 	ptl = pte_lockptr(mm, pmd);
 	spin_lock(ptl);
 	if (unlikely(!pte_same(*ptep, entry)))
-		goto unlock;
+		goto out_unlock;
 
 	page = vm_normal_page(vma, address, entry);
 	if (page) {
@@ -3498,20 +3500,25 @@ static int do_prot_none(struct mm_struct *mm, struct vm_area_struct *vma,
 			goto migrate;
 	}
 
-fixup:
+out_pte_upgrade_unlock:
 	flush_cache_page(vma, address, pte_pfn(entry));
 
 	ptep_modify_prot_start(mm, address, ptep);
 	entry = pte_modify(entry, vma->vm_page_prot);
 	ptep_modify_prot_commit(mm, address, ptep, entry);
 
+	/* No TLB flush needed because we upgraded the PTE */
+
 	update_mmu_cache(vma, address, ptep);
 
-unlock:
+out_unlock:
 	pte_unmap_unlock(ptep, ptl);
 out:
 	if (page) {
-		task_numa_fault(page_nid, 1);
+		if (locked)
+			unlock_page(page);
+		if (account)
+			task_numa_fault(page_nid, 1);
 		put_page(page);
 	}
 
@@ -3520,19 +3527,40 @@ out:
 migrate:
 	pte_unmap_unlock(ptep, ptl);
 
+	locked = 1;
+	lock_page(page);
+
+	/*
+	 * We have to do this again, to make sure
+	 * we have not raced with a pte update
+	 * during the lock_page():
+	 */
+	ptep = pte_offset_map_lock(mm, pmd, address, &ptl);
+	if (!pte_same(*ptep, entry)) {
+		account = 0;
+		goto out_unlock;
+	}
+	pte_unmap_unlock(ptep, ptl);
+
 	if (!migrate_misplaced_page(page, node)) {
+		/*
+		 * Successful migration - account the fault.
+		 * Note, we don't fix up the pte, that will
+		 * happen on the next fault.
+		 */
 		page_nid = node;
+		put_page(page);
+
 		goto out;
 	}
 
 	ptep = pte_offset_map_lock(mm, pmd, address, &ptl);
 	if (!pte_same(*ptep, entry)) {
-		put_page(page);
-		page = NULL;
-		goto unlock;
+		account = 0;
+		goto out_unlock;
 	}
 
-	goto fixup;
+	goto out_pte_upgrade_unlock;
 }
 
 /*
diff --git a/mm/migrate.c b/mm/migrate.c
index 72d1056..6d16bff 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -1449,20 +1449,22 @@ int migrate_misplaced_page(struct page *page, int node)
 	}
 
 	if (isolate_lru_page(page)) {
-		ret = -EBUSY;
-		goto put_new;
+		put_page(newpage);
+		return -EBUSY;
 	}
 
 	inc_zone_page_state(page, NR_ISOLATED_ANON + page_lru);
 	ret = __unmap_and_move(page, newpage, 0, 0, MIGRATE_FAULT);
-	/*
-	 * A page that has been migrated has all references removed and will be
-	 * freed. A page that has not been migrated will have kepts its
-	 * references and be restored.
-	 */
-	dec_zone_page_state(page, NR_ISOLATED_ANON + page_lru);
-	putback_lru_page(page);
-put_new:
+
+	if (ret != -EAGAIN) {
+		/*
+		 * A page that has been migrated has all references removed and will be
+		 * freed. A page that has not been migrated will have kepts its
+		 * references and be restored.
+		 */
+		dec_zone_page_state(page, NR_ISOLATED_ANON + page_lru);
+		putback_lru_page(page);
+	}
 	/*
 	 * Move the new page to the LRU. If migration was not successful
 	 * then this will free the page.
