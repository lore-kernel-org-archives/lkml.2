Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967993Ab2ERKlu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 06:41:50 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42660 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965410Ab2ERKls (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 06:41:48 -0400
Date: Fri, 18 May 2012 03:41:17 -0700
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-go9ckttsju4wrm7cf7oj25rq@git.kernel.org>
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
Subject: [tip:sched/numa] mm: Rework the RSS accounting functions
Git-Commit-ID: 9e7b0f30b17bacb7ed2904cb3fee514208b5b42e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 18 May 2012 03:41:25 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9e7b0f30b17bacb7ed2904cb3fee514208b5b42e
Gitweb:     http://git.kernel.org/tip/9e7b0f30b17bacb7ed2904cb3fee514208b5b42e
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Thu, 8 Mar 2012 23:03:20 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 18 May 2012 08:16:26 +0200

mm: Rework the RSS accounting functions

Rework the RSS accounting functions so we could do per vma RSS
accounting. This replaces the mm_struct argument with a
vm_area_struct and renames them from *mm_counter* to *rss_counter*.

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
Link: http://lkml.kernel.org/n/tip-go9ckttsju4wrm7cf7oj25rq@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 fs/exec.c          |    2 +-
 include/linux/mm.h |   12 ++++++------
 mm/filemap_xip.c   |    2 +-
 mm/fremap.c        |    2 +-
 mm/huge_memory.c   |    8 ++++----
 mm/memory.c        |   51 +++++++++++++++++++++++++++------------------------
 mm/rmap.c          |   12 ++++++------
 mm/swapfile.c      |    4 ++--
 8 files changed, 48 insertions(+), 45 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index 8a12a7f..c2b570e 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -184,7 +184,7 @@ static void acct_arg_size(struct linux_binprm *bprm, unsigned long pages)
 		return;
 
 	bprm->vma_pages = pages;
-	add_mm_counter(mm, MM_ANONPAGES, diff);
+	add_rss_counter(bprm->vma, MM_ANONPAGES, diff);
 }
 
 static struct page *get_arg_page(struct linux_binprm *bprm, unsigned long pos,
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 75affe7..a89817e 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1076,19 +1076,19 @@ static inline unsigned long get_mm_counter(struct mm_struct *mm, int member)
 	return (unsigned long)val;
 }
 
-static inline void add_mm_counter(struct mm_struct *mm, int member, long value)
+static inline void add_rss_counter(struct vm_area_struct *vma, int member, long value)
 {
-	atomic_long_add(value, &mm->rss_stat.count[member]);
+	atomic_long_add(value, &vma->vm_mm->rss_stat.count[member]);
 }
 
-static inline void inc_mm_counter(struct mm_struct *mm, int member)
+static inline void inc_rss_counter(struct vm_area_struct *vma, int member)
 {
-	atomic_long_inc(&mm->rss_stat.count[member]);
+	atomic_long_inc(&vma->vm_mm->rss_stat.count[member]);
 }
 
-static inline void dec_mm_counter(struct mm_struct *mm, int member)
+static inline void dec_rss_counter(struct vm_area_struct *vma, int member)
 {
-	atomic_long_dec(&mm->rss_stat.count[member]);
+	atomic_long_dec(&vma->vm_mm->rss_stat.count[member]);
 }
 
 static inline unsigned long get_mm_rss(struct mm_struct *mm)
diff --git a/mm/filemap_xip.c b/mm/filemap_xip.c
index a4eb311..655b3a5 100644
--- a/mm/filemap_xip.c
+++ b/mm/filemap_xip.c
@@ -195,7 +195,7 @@ retry:
 			flush_cache_page(vma, address, pte_pfn(*pte));
 			pteval = ptep_clear_flush_notify(vma, address, pte);
 			page_remove_rmap(page);
-			dec_mm_counter(mm, MM_FILEPAGES);
+			dec_rss_counter(vma, MM_FILEPAGES);
 			BUG_ON(pte_dirty(pteval));
 			pte_unmap_unlock(pte, ptl);
 			page_cache_release(page);
diff --git a/mm/fremap.c b/mm/fremap.c
index 9ed4fd4..7da5777 100644
--- a/mm/fremap.c
+++ b/mm/fremap.c
@@ -39,7 +39,7 @@ static void zap_pte(struct mm_struct *mm, struct vm_area_struct *vma,
 			page_remove_rmap(page);
 			page_cache_release(page);
 			update_hiwater_rss(mm);
-			dec_mm_counter(mm, MM_FILEPAGES);
+			dec_rss_counter(vma, MM_FILEPAGES);
 		}
 	} else {
 		if (!pte_file(pte))
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 54038f2..0d75a57 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -670,7 +670,7 @@ static int __do_huge_pmd_anonymous_page(struct mm_struct *mm,
 		page_add_new_anon_rmap(page, vma, haddr);
 		set_pmd_at(mm, haddr, pmd, entry);
 		prepare_pmd_huge_pte(pgtable, mm);
-		add_mm_counter(mm, MM_ANONPAGES, HPAGE_PMD_NR);
+		add_rss_counter(vma, MM_ANONPAGES, HPAGE_PMD_NR);
 		mm->nr_ptes++;
 		spin_unlock(&mm->page_table_lock);
 	}
@@ -784,7 +784,7 @@ int copy_huge_pmd(struct vm_area_struct *dst_vma, struct vm_area_struct *src_vma
 	VM_BUG_ON(!PageHead(src_page));
 	get_page(src_page);
 	page_dup_rmap(src_page);
-	add_mm_counter(dst_mm, MM_ANONPAGES, HPAGE_PMD_NR);
+	add_rss_counter(dst_vma, MM_ANONPAGES, HPAGE_PMD_NR);
 
 	pmdp_set_wrprotect(src_mm, addr, src_pmd);
 	pmd = pmd_mkold(pmd_wrprotect(pmd));
@@ -1040,7 +1040,7 @@ int zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 		tlb_remove_pmd_tlb_entry(tlb, pmd, addr);
 		page_remove_rmap(page);
 		VM_BUG_ON(page_mapcount(page) < 0);
-		add_mm_counter(tlb->mm, MM_ANONPAGES, -HPAGE_PMD_NR);
+		add_rss_counter(vma, MM_ANONPAGES, -HPAGE_PMD_NR);
 		VM_BUG_ON(!PageHead(page));
 		tlb->mm->nr_ptes--;
 		spin_unlock(&tlb->mm->page_table_lock);
@@ -1797,7 +1797,7 @@ static void __collapse_huge_page_copy(pte_t *pte, struct page *page,
 
 		if (pte_none(pteval)) {
 			clear_user_highpage(page, address);
-			add_mm_counter(vma->vm_mm, MM_ANONPAGES, 1);
+			add_rss_counter(vma, MM_ANONPAGES, 1);
 		} else {
 			src_page = pte_page(pteval);
 			copy_user_highpage(page, src_page, address, vma);
diff --git a/mm/memory.c b/mm/memory.c
index 8127ee9..6b39551c 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -132,24 +132,25 @@ void sync_mm_rss(struct mm_struct *mm)
 
 	for (i = 0; i < NR_MM_COUNTERS; i++) {
 		if (current->rss_stat.count[i]) {
-			add_mm_counter(mm, i, current->rss_stat.count[i]);
+			atomic_long_add(current->rss_stat.count[i],
+					&mm->rss_stat.count[i]);
 			current->rss_stat.count[i] = 0;
 		}
 	}
 	current->rss_stat.events = 0;
 }
 
-static void add_mm_counter_fast(struct mm_struct *mm, int member, int val)
+static void add_rss_counter_fast(struct vm_area_struct *vma, int member, int val)
 {
 	struct task_struct *task = current;
 
-	if (likely(task->mm == mm))
+	if (likely(task->mm == vma->vm_mm))
 		task->rss_stat.count[member] += val;
 	else
-		add_mm_counter(mm, member, val);
+		add_rss_counter(vma, member, val);
 }
-#define inc_mm_counter_fast(mm, member) add_mm_counter_fast(mm, member, 1)
-#define dec_mm_counter_fast(mm, member) add_mm_counter_fast(mm, member, -1)
+#define inc_rss_counter_fast(vma, member) add_rss_counter_fast(vma, member, 1)
+#define dec_rss_counter_fast(vma, member) add_rss_counter_fast(vma, member, -1)
 
 /* sync counter once per 64 page faults */
 #define TASK_RSS_EVENTS_THRESH	(64)
@@ -162,8 +163,8 @@ static void check_sync_rss_stat(struct task_struct *task)
 }
 #else /* SPLIT_RSS_COUNTING */
 
-#define inc_mm_counter_fast(mm, member) inc_mm_counter(mm, member)
-#define dec_mm_counter_fast(mm, member) dec_mm_counter(mm, member)
+#define inc_rss_counter_fast(vma, member) inc_rss_counter(vma, member)
+#define dec_rss_counter_fast(vma, member) dec_rss_counter(vma, member)
 
 static void check_sync_rss_stat(struct task_struct *task)
 {
@@ -634,15 +635,17 @@ static inline void init_rss_vec(int *rss)
 	memset(rss, 0, sizeof(int) * NR_MM_COUNTERS);
 }
 
-static inline void add_mm_rss_vec(struct mm_struct *mm, int *rss)
+static inline
+void add_rss_vec(struct vm_area_struct *vma, int *rss)
 {
 	int i;
 
-	if (current->mm == mm)
-		sync_mm_rss(mm);
-	for (i = 0; i < NR_MM_COUNTERS; i++)
+	if (current->mm == vma->vm_mm)
+		sync_mm_rss(vma->vm_mm);
+	for (i = 0; i < NR_MM_COUNTERS; i++) {
 		if (rss[i])
-			add_mm_counter(mm, i, rss[i]);
+			add_rss_counter(vma, i, rss[i]);
+	}
 }
 
 /*
@@ -960,7 +963,7 @@ again:
 	arch_leave_lazy_mmu_mode();
 	spin_unlock(src_ptl);
 	pte_unmap(orig_src_pte);
-	add_mm_rss_vec(dst_mm, rss);
+	add_rss_vec(dst_vma, rss);
 	pte_unmap_unlock(orig_dst_pte, dst_ptl);
 	cond_resched();
 
@@ -1191,7 +1194,7 @@ again:
 		pte_clear_not_present_full(mm, addr, pte, tlb->fullmm);
 	} while (pte++, addr += PAGE_SIZE, addr != end);
 
-	add_mm_rss_vec(mm, rss);
+	add_rss_vec(vma, rss);
 	arch_leave_lazy_mmu_mode();
 	pte_unmap_unlock(start_pte, ptl);
 
@@ -2032,7 +2035,7 @@ static int insert_page(struct vm_area_struct *vma, unsigned long addr,
 
 	/* Ok, finally just insert the thing.. */
 	get_page(page);
-	inc_mm_counter_fast(mm, MM_FILEPAGES);
+	inc_rss_counter_fast(vma, MM_FILEPAGES);
 	page_add_file_rmap(page);
 	set_pte_at(mm, addr, pte, mk_pte(page, prot));
 
@@ -2687,11 +2690,11 @@ gotten:
 	if (likely(pte_same(*page_table, orig_pte))) {
 		if (old_page) {
 			if (!PageAnon(old_page)) {
-				dec_mm_counter_fast(mm, MM_FILEPAGES);
-				inc_mm_counter_fast(mm, MM_ANONPAGES);
+				dec_rss_counter_fast(vma, MM_FILEPAGES);
+				inc_rss_counter_fast(vma, MM_ANONPAGES);
 			}
 		} else
-			inc_mm_counter_fast(mm, MM_ANONPAGES);
+			inc_rss_counter_fast(vma, MM_ANONPAGES);
 		flush_cache_page(vma, address, pte_pfn(orig_pte));
 		entry = mk_pte(new_page, vma->vm_page_prot);
 		entry = maybe_mkwrite(pte_mkdirty(entry), vma);
@@ -3013,8 +3016,8 @@ static int do_swap_page(struct mm_struct *mm, struct vm_area_struct *vma,
 	 * discarded at swap_free().
 	 */
 
-	inc_mm_counter_fast(mm, MM_ANONPAGES);
-	dec_mm_counter_fast(mm, MM_SWAPENTS);
+	inc_rss_counter_fast(vma, MM_ANONPAGES);
+	dec_rss_counter_fast(vma, MM_SWAPENTS);
 	pte = mk_pte(page, vma->vm_page_prot);
 	if ((flags & FAULT_FLAG_WRITE) && reuse_swap_page(page)) {
 		pte = maybe_mkwrite(pte_mkdirty(pte), vma);
@@ -3154,7 +3157,7 @@ static int do_anonymous_page(struct mm_struct *mm, struct vm_area_struct *vma,
 	if (!pte_none(*page_table))
 		goto release;
 
-	inc_mm_counter_fast(mm, MM_ANONPAGES);
+	inc_rss_counter_fast(vma, MM_ANONPAGES);
 	page_add_new_anon_rmap(page, vma, address);
 setpte:
 	set_pte_at(mm, address, page_table, entry);
@@ -3309,10 +3312,10 @@ static int __do_fault(struct mm_struct *mm, struct vm_area_struct *vma,
 		if (flags & FAULT_FLAG_WRITE)
 			entry = maybe_mkwrite(pte_mkdirty(entry), vma);
 		if (anon) {
-			inc_mm_counter_fast(mm, MM_ANONPAGES);
+			inc_rss_counter_fast(vma, MM_ANONPAGES);
 			page_add_new_anon_rmap(page, vma, address);
 		} else {
-			inc_mm_counter_fast(mm, MM_FILEPAGES);
+			inc_rss_counter_fast(vma, MM_FILEPAGES);
 			page_add_file_rmap(page);
 			if (flags & FAULT_FLAG_WRITE) {
 				dirty_page = page;
diff --git a/mm/rmap.c b/mm/rmap.c
index b10f2f9..62adf5a 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -1273,9 +1273,9 @@ int try_to_unmap_one(struct page *page, struct vm_area_struct *vma,
 
 	if (PageHWPoison(page) && !(flags & TTU_IGNORE_HWPOISON)) {
 		if (PageAnon(page))
-			dec_mm_counter(mm, MM_ANONPAGES);
+			dec_rss_counter(vma, MM_ANONPAGES);
 		else
-			dec_mm_counter(mm, MM_FILEPAGES);
+			dec_rss_counter(vma, MM_FILEPAGES);
 		set_pte_at(mm, address, pte,
 				swp_entry_to_pte(make_hwpoison_entry(page)));
 	} else if (PageAnon(page)) {
@@ -1297,8 +1297,8 @@ int try_to_unmap_one(struct page *page, struct vm_area_struct *vma,
 					list_add(&mm->mmlist, &init_mm.mmlist);
 				spin_unlock(&mmlist_lock);
 			}
-			dec_mm_counter(mm, MM_ANONPAGES);
-			inc_mm_counter(mm, MM_SWAPENTS);
+			dec_rss_counter(vma, MM_ANONPAGES);
+			inc_rss_counter(vma, MM_SWAPENTS);
 		} else if (IS_ENABLED(CONFIG_MIGRATION)) {
 			/*
 			 * Store the pfn of the page in a special migration
@@ -1317,7 +1317,7 @@ int try_to_unmap_one(struct page *page, struct vm_area_struct *vma,
 		entry = make_migration_entry(page, pte_write(pteval));
 		set_pte_at(mm, address, pte, swp_entry_to_pte(entry));
 	} else
-		dec_mm_counter(mm, MM_FILEPAGES);
+		dec_rss_counter(vma, MM_FILEPAGES);
 
 	page_remove_rmap(page);
 	page_cache_release(page);
@@ -1456,7 +1456,7 @@ static int try_to_unmap_cluster(unsigned long cursor, unsigned int *mapcount,
 
 		page_remove_rmap(page);
 		page_cache_release(page);
-		dec_mm_counter(mm, MM_FILEPAGES);
+		dec_rss_counter(vma, MM_FILEPAGES);
 		(*mapcount)--;
 	}
 	pte_unmap_unlock(pte - 1, ptl);
diff --git a/mm/swapfile.c b/mm/swapfile.c
index c5952c0..e1c1454 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -879,8 +879,8 @@ static int unuse_pte(struct vm_area_struct *vma, pmd_t *pmd,
 		goto out;
 	}
 
-	dec_mm_counter(vma->vm_mm, MM_SWAPENTS);
-	inc_mm_counter(vma->vm_mm, MM_ANONPAGES);
+	dec_rss_counter(vma, MM_SWAPENTS);
+	inc_rss_counter(vma, MM_ANONPAGES);
 	get_page(page);
 	set_pte_at(vma->vm_mm, addr, pte,
 		   pte_mkold(mk_pte(page, vma->vm_page_prot)));
