Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755224Ab2JWLBt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 07:01:49 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43199 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751969Ab2JWLBr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 07:01:47 -0400
Date: Tue, 23 Oct 2012 04:01:21 -0700
From: tip-bot for Ingo Molnar <mingo@kernel.org>
Message-ID: <tip-9d6800cb12d36964a6fd4e68da06cd0c5c8d1ca0@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl, riel@redhat.com,
        akpm@linux-foundation.org, aarcange@redhat.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: riel@redhat.com, mingo@kernel.org, hpa@zytor.com,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org,
        aarcange@redhat.com, tglx@linutronix.de, mingo@elte.hu
To: linux-tip-commits@vger.kernel.org
Subject: [tip:numa/core] numa, mm, sched: Use down_write()
  in task_numa_work()
Git-Commit-ID: 9d6800cb12d36964a6fd4e68da06cd0c5c8d1ca0
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 23 Oct 2012 04:01:28 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9d6800cb12d36964a6fd4e68da06cd0c5c8d1ca0
Gitweb:     http://git.kernel.org/tip/9d6800cb12d36964a6fd4e68da06cd0c5c8d1ca0
Author:     Ingo Molnar <mingo@kernel.org>
AuthorDate: Sat, 20 Oct 2012 23:06:00 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 23 Oct 2012 11:53:53 +0200

numa, mm, sched: Use down_write() in task_numa_work()

change_protection() needs to be called with the mmap_sem write-locked,
like the mprotect() variants do it.

With that in place we can avoid the intrusive (and partially
incorrect) page locking changes in the:

   "numa, mm: Fix 4K migration races"

patch, because the down_write() will properly serialize with the
down_read() page fault path.

Keep the cleanups and debug code removal.

In theory calling change_protection() with just down_read()
should work, but in practice it seems messy.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
Link: http://lkml.kernel.org/n/tip-g3xyfmqqmmpubhcdww2TrbLc@git.kernel.org
---
 kernel/sched/fair.c |    4 ++--
 mm/huge_memory.c    |    6 ------
 mm/memory.c         |   12 +++++++-----
 3 files changed, 9 insertions(+), 13 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 9f7406e..f8b3539 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -937,7 +937,7 @@ void task_numa_work(struct callback_head *work)
 	length = sysctl_sched_numa_scan_size;
 	length <<= 20;
 
-	down_read(&mm->mmap_sem);
+	down_write(&mm->mmap_sem);
 	vma = find_vma(mm, offset);
 again:
 	if (!vma) {
@@ -964,7 +964,7 @@ again:
 		goto again;
 	}
 	mm->numa_scan_offset = offset;
-	up_read(&mm->mmap_sem);
+	up_write(&mm->mmap_sem);
 
 }
 
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index bcba184..4767200 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -781,10 +781,6 @@ unlock:
 	return;
 
 migrate:
-	WARN_ON(!(((unsigned long)page->mapping & PAGE_MAPPING_ANON)));
-	WARN_ON((((unsigned long)page->mapping & PAGE_MAPPING_KSM)));
-	BUG_ON(PageSwapCache(page));
-
 	spin_unlock(&mm->page_table_lock);
 
 	lock_page(page);
@@ -801,8 +797,6 @@ migrate:
 	    (GFP_TRANSHUGE | GFP_THISNODE) & ~__GFP_WAIT,
 	    HPAGE_PMD_ORDER);
 
-	WARN_ON(PageLRU(new_page));
-
 	if (!new_page)
 		goto alloc_fail;
 
diff --git a/mm/memory.c b/mm/memory.c
index 7ff1905..2c17d82 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -3489,7 +3489,7 @@ static int do_numa_page(struct mm_struct *mm, struct vm_area_struct *vma,
 	ptl = pte_lockptr(mm, pmd);
 	spin_lock(ptl);
 	if (unlikely(!pte_same(*ptep, entry)))
-		goto unlock;
+		goto out_unlock;
 
 	page = vm_normal_page(vma, address, entry);
 	if (page) {
@@ -3500,16 +3500,18 @@ static int do_numa_page(struct mm_struct *mm, struct vm_area_struct *vma,
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
@@ -3531,10 +3533,10 @@ migrate:
 	if (!pte_same(*ptep, entry)) {
 		put_page(page);
 		page = NULL;
-		goto unlock;
+		goto out_unlock;
 	}
 
-	goto fixup;
+	goto out_pte_upgrade_unlock;
 }
 
 /*
