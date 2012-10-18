Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932646Ab2JRRGN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 13:06:13 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46782 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932629Ab2JRRGL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 13:06:11 -0400
Date: Thu, 18 Oct 2012 10:05:39 -0700
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-yv9vbiz2s455zxq1ffzx3fye@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl,
        hannes@cmpxchg.org, akpm@linux-foundation.org, mgorman@suse.de,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org,
        hannes@cmpxchg.org, akpm@linux-foundation.org, mgorman@suse.de,
        tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:numa/core] sched/numa/mm: Improve migration
Git-Commit-ID: 713f937655c4b15131b5a0eae4610918a4febe17
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 18 Oct 2012 10:05:45 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  713f937655c4b15131b5a0eae4610918a4febe17
Gitweb:     http://git.kernel.org/tip/713f937655c4b15131b5a0eae4610918a4febe17
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Fri, 12 Oct 2012 19:30:14 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 15 Oct 2012 14:18:40 +0200

sched/numa/mm: Improve migration

Add THP migration. Extend task_numa_fault() to absorb THP faults.

[ Would be nice if the gents on Cc: expressed their opinion about
  this change. A missing detail might be cgroup page accounting,
  plus the fact that some architectures might cache PMD_NONE pmds
  in their TLBs, needing some extra TLB magic beyond what we already
  do here? ]

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Link: http://lkml.kernel.org/n/tip-yv9vbiz2s455zxq1ffzx3fye@git.kernel.org
[ Significant fixes ]
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/linux/sched.h |    4 +-
 kernel/sched/fair.c   |    4 +-
 mm/huge_memory.c      |  142 +++++++++++++++++++++++++++++++++++++++---------
 mm/migrate.c          |    2 +-
 4 files changed, 120 insertions(+), 32 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 22be2d6..2c3009b 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1609,7 +1609,7 @@ static inline int tsk_home_node(struct task_struct *p)
 }
 
 extern void task_numa_placement(void);
-extern void task_numa_fault(int node);
+extern void task_numa_fault(int node, int pages);
 #else
 static inline int tsk_home_node(struct task_struct *p)
 {
@@ -1620,7 +1620,7 @@ static inline void task_numa_placement(void)
 {
 }
 
-static inline void task_numa_fault(int node)
+static inline void task_numa_fault(int node, int pages)
 {
 }
 #endif /* CONFIG_SCHED_NUMA */
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 7d522d0..df35c8d 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -835,7 +835,7 @@ unsigned int sysctl_sched_numa_settle_count = 2;
 /*
  * Got a PROT_NONE fault for a page on @node.
  */
-void task_numa_fault(int node)
+void task_numa_fault(int node, int pages)
 {
 	struct task_struct *p = current;
 
@@ -846,7 +846,7 @@ void task_numa_fault(int node)
 			return;
 	}
 
-	p->numa_faults[node]++;
+	p->numa_faults[node] += pages;
 }
 
 void task_numa_placement(void)
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index d14c8b2..2b65116 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -767,11 +767,13 @@ void do_huge_pmd_prot_none(struct mm_struct *mm, struct vm_area_struct *vma,
 			   unsigned int flags, pmd_t entry)
 {
 	unsigned long haddr = address & HPAGE_PMD_MASK;
+	struct page *new_page = NULL;
 	struct page *page = NULL;
+	int node, lru;
 
 	spin_lock(&mm->page_table_lock);
 	if (unlikely(!pmd_same(*pmd, entry)))
-		goto out_unlock;
+		goto unlock;
 
 	if (unlikely(pmd_trans_splitting(entry))) {
 		spin_unlock(&mm->page_table_lock);
@@ -779,44 +781,130 @@ void do_huge_pmd_prot_none(struct mm_struct *mm, struct vm_area_struct *vma,
 		return;
 	}
 
-#ifdef CONFIG_NUMA
 	page = pmd_page(entry);
-	VM_BUG_ON(!PageCompound(page) || !PageHead(page));
+	if (page) {
+		VM_BUG_ON(!PageCompound(page) || !PageHead(page));
 
-	get_page(page);
+		get_page(page);
+		node = mpol_misplaced(page, vma, haddr);
+		if (node != -1)
+			goto migrate;
+	}
+
+fixup:
+	/* change back to regular protection */
+	entry = pmd_modify(entry, vma->vm_page_prot);
+	set_pmd_at(mm, haddr, pmd, entry);
+	update_mmu_cache(vma, address, entry);
+
+unlock:
 	spin_unlock(&mm->page_table_lock);
+	if (page) {
+		task_numa_placement();
+		task_numa_fault(page_to_nid(page), HPAGE_PMD_NR);
+		put_page(page);
+	}
+	return;
 
-	/*
-	 * XXX should we serialize against split_huge_page ?
-	 */
+migrate:
+	WARN_ON(!(((unsigned long)page->mapping & PAGE_MAPPING_ANON)));
+	WARN_ON((((unsigned long)page->mapping & PAGE_MAPPING_KSM)));
+	BUG_ON(PageSwapCache(page));
+
+	spin_unlock(&mm->page_table_lock);
 
-	if (mpol_misplaced(page, vma, haddr) == -1)
-		goto do_fixup;
+	lock_page(page);
+	spin_lock(&mm->page_table_lock);
+	if (unlikely(!pmd_same(*pmd, entry))) {
+		spin_unlock(&mm->page_table_lock);
+		unlock_page(page);
+		put_page(page);
+		return;
+	}
+	spin_unlock(&mm->page_table_lock);
 
-	/*
-	 * Due to lacking code to migrate thp pages, we'll split
-	 * (which preserves the special PROT_NONE) and re-take the
-	 * fault on the normal pages.
-	 */
-	split_huge_page(page);
-	put_page(page);
-	return;
+	task_numa_placement();
+
+	new_page = alloc_pages_node(node,
+	    (GFP_TRANSHUGE | GFP_THISNODE) & ~(__GFP_NO_KSWAPD | __GFP_WAIT),
+	    HPAGE_PMD_ORDER);
+
+	WARN_ON(PageLRU(new_page));
+
+	if (!new_page)
+		goto alloc_fail;
+
+	lru = PageLRU(page);
+
+	if (lru && isolate_lru_page(page)) /* does an implicit get_page() */
+		goto alloc_fail;
+
+	if (!trylock_page(new_page))
+		BUG();
+
+	/* anon mapping, we can simply copy page->mapping to the new page: */
+	new_page->mapping = page->mapping;
+	new_page->index = page->index;
+
+	migrate_page_copy(new_page, page);
+
+	WARN_ON(PageLRU(new_page));
 
-do_fixup:
 	spin_lock(&mm->page_table_lock);
-	if (unlikely(!pmd_same(*pmd, entry)))
-		goto out_unlock;
-#endif
+	if (unlikely(!pmd_same(*pmd, entry))) {
+		spin_unlock(&mm->page_table_lock);
+		if (lru)
+			putback_lru_page(page);
 
-	/* change back to regular protection */
-	entry = pmd_modify(entry, vma->vm_page_prot);
-	if (pmdp_set_access_flags(vma, haddr, pmd, entry, 1))
-		update_mmu_cache(vma, address, entry);
+		unlock_page(new_page);
+		ClearPageActive(new_page);	/* Set by migrate_page_copy() */
+		new_page->mapping = NULL;
+		put_page(new_page);		/* Free it */
 
-out_unlock:
+		unlock_page(page);
+		put_page(page);			/* Drop the local reference */
+
+		return;
+	}
+
+	entry = mk_pmd(new_page, vma->vm_page_prot);
+	entry = maybe_pmd_mkwrite(pmd_mkdirty(entry), vma);
+	entry = pmd_mkhuge(entry);
+
+	page_add_new_anon_rmap(new_page, vma, haddr);
+
+	set_pmd_at(mm, haddr, pmd, entry);
+	update_mmu_cache(vma, address, entry);
+	page_remove_rmap(page);
 	spin_unlock(&mm->page_table_lock);
-	if (page)
+
+	put_page(page);			/* Drop the rmap reference */
+
+	task_numa_fault(node, HPAGE_PMD_NR);
+
+	if (lru)
+		put_page(page);		/* drop the LRU isolation reference */
+
+	unlock_page(new_page);
+	unlock_page(page);
+	put_page(page);			/* Drop the local reference */
+
+	return;
+
+alloc_fail:
+	if (new_page)
+		put_page(new_page);
+
+	task_numa_fault(page_to_nid(page), HPAGE_PMD_NR);
+	unlock_page(page);
+
+	spin_lock(&mm->page_table_lock);
+	if (unlikely(!pmd_same(*pmd, entry))) {
 		put_page(page);
+		page = NULL;
+		goto unlock;
+	}
+	goto fixup;
 }
 
 int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
diff --git a/mm/migrate.c b/mm/migrate.c
index e03ed0b..e3cff03 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -417,7 +417,7 @@ int migrate_huge_page_move_mapping(struct address_space *mapping,
  */
 void migrate_page_copy(struct page *newpage, struct page *page)
 {
-	if (PageHuge(page))
+	if (PageHuge(page) || PageTransHuge(page))
 		copy_huge_page(newpage, page);
 	else
 		copy_highpage(newpage, page);
