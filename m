Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758311Ab0DBO2a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 10:28:30 -0400
Received: from casper.infradead.org ([85.118.1.10]:39618 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757232Ab0DBO1X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 10:27:23 -0400
Message-Id: <20100402142446.526743723@chello.nl>
User-Agent: quilt/0.47-1
Date: Fri, 02 Apr 2010 16:16:07 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andrea Arcangeli <aarcange@redhat.com>, Avi Kivity <avi@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, Rik van Riel <riel@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, Mel Gorman <mel@csn.ul.ie>,
       Nick Piggin <npiggin@suse.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 6/7] mm: Convert i_mmap_lock and anon_vma->lock to mutexes
References: <20100402141601.435955404@chello.nl>
Content-Disposition: inline; filename=mm-mutex.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Straight fwd conversion of i_mmap_lock and anon_vma->lock to mutexes.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 arch/x86/mm/hugetlbpage.c |    4 ++--
 fs/hugetlbfs/inode.c      |    4 ++--
 fs/inode.c                |    2 +-
 include/linux/fs.h        |    2 +-
 include/linux/mm.h        |    2 +-
 include/linux/rmap.h      |   10 +++++-----
 kernel/fork.c             |    4 ++--
 mm/filemap_xip.c          |    4 ++--
 mm/fremap.c               |    4 ++--
 mm/hugetlb.c              |   12 ++++++------
 mm/ksm.c                  |   16 ++++++++--------
 mm/memory-failure.c       |    4 ++--
 mm/memory.c               |   14 +++++++-------
 mm/mmap.c                 |   20 ++++++++++----------
 mm/mremap.c               |    4 ++--
 mm/rmap.c                 |   42 +++++++++++++++++++++---------------------
 16 files changed, 74 insertions(+), 74 deletions(-)

Index: linux-2.6/arch/x86/mm/hugetlbpage.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/hugetlbpage.c
+++ linux-2.6/arch/x86/mm/hugetlbpage.c
@@ -73,7 +73,7 @@ static void huge_pmd_share(struct mm_str
 	if (!vma_shareable(vma, addr))
 		return;
 
-	spin_lock(&mapping->i_mmap_lock);
+	mutex_lock(&mapping->i_mmap_lock);
 	vma_prio_tree_foreach(svma, &iter, &mapping->i_mmap, idx, idx) {
 		if (svma == vma)
 			continue;
@@ -98,7 +98,7 @@ static void huge_pmd_share(struct mm_str
 		put_page(virt_to_page(spte));
 	spin_unlock(&mm->page_table_lock);
 out:
-	spin_unlock(&mapping->i_mmap_lock);
+	mutex_unlock(&mapping->i_mmap_lock);
 }
 
 /*
Index: linux-2.6/fs/hugetlbfs/inode.c
===================================================================
--- linux-2.6.orig/fs/hugetlbfs/inode.c
+++ linux-2.6/fs/hugetlbfs/inode.c
@@ -429,10 +429,10 @@ static int hugetlb_vmtruncate(struct ino
 	pgoff = offset >> PAGE_SHIFT;
 
 	i_size_write(inode, offset);
-	spin_lock(&mapping->i_mmap_lock);
+	mutex_lock(&mapping->i_mmap_lock);
 	if (!prio_tree_empty(&mapping->i_mmap))
 		hugetlb_vmtruncate_list(&mapping->i_mmap, pgoff);
-	spin_unlock(&mapping->i_mmap_lock);
+	mutex_unlock(&mapping->i_mmap_lock);
 	truncate_hugepages(inode, offset);
 	return 0;
 }
Index: linux-2.6/fs/inode.c
===================================================================
--- linux-2.6.orig/fs/inode.c
+++ linux-2.6/fs/inode.c
@@ -258,7 +258,7 @@ void inode_init_once(struct inode *inode
 	INIT_LIST_HEAD(&inode->i_devices);
 	INIT_RADIX_TREE(&inode->i_data.page_tree, GFP_ATOMIC);
 	spin_lock_init(&inode->i_data.tree_lock);
-	spin_lock_init(&inode->i_data.i_mmap_lock);
+	mutex_init(&inode->i_data.i_mmap_lock);
 	INIT_LIST_HEAD(&inode->i_data.private_list);
 	spin_lock_init(&inode->i_data.private_lock);
 	INIT_RAW_PRIO_TREE_ROOT(&inode->i_data.i_mmap);
Index: linux-2.6/include/linux/fs.h
===================================================================
--- linux-2.6.orig/include/linux/fs.h
+++ linux-2.6/include/linux/fs.h
@@ -627,7 +627,7 @@ struct address_space {
 	unsigned int		i_mmap_writable;/* count VM_SHARED mappings */
 	struct prio_tree_root	i_mmap;		/* tree of private and shared mappings */
 	struct list_head	i_mmap_nonlinear;/*list VM_NONLINEAR mappings */
-	spinlock_t		i_mmap_lock;	/* protect tree, count, list */
+	struct mutex		i_mmap_lock;	/* protect tree, count, list */
 	unsigned int		truncate_count;	/* Cover race condition with truncate */
 	unsigned long		nrpages;	/* number of total pages */
 	pgoff_t			writeback_index;/* writeback starts here */
Index: linux-2.6/include/linux/mm.h
===================================================================
--- linux-2.6.orig/include/linux/mm.h
+++ linux-2.6/include/linux/mm.h
@@ -749,7 +749,7 @@ struct zap_details {
 	struct address_space *check_mapping;	/* Check page->mapping if set */
 	pgoff_t	first_index;			/* Lowest page->index to unmap */
 	pgoff_t last_index;			/* Highest page->index to unmap */
-	spinlock_t *i_mmap_lock;		/* For unmap_mapping_range: */
+	struct mutex *i_mmap_lock;		/* For unmap_mapping_range: */
 	unsigned long truncate_count;		/* Compare vm_truncate_count */
 };
 
Index: linux-2.6/include/linux/rmap.h
===================================================================
--- linux-2.6.orig/include/linux/rmap.h
+++ linux-2.6/include/linux/rmap.h
@@ -7,7 +7,7 @@
 #include <linux/list.h>
 #include <linux/slab.h>
 #include <linux/mm.h>
-#include <linux/spinlock.h>
+#include <linux/mutex.h>
 #include <linux/memcontrol.h>
 
 /*
@@ -25,8 +25,7 @@
  * pointing to this anon_vma once its vma list is empty.
  */
 struct anon_vma {
-	spinlock_t lock;	/* Serialize access to vma list */
-	atomic_t ref;
+	struct mutex lock;	/* Serialize access to vma list */
 	/*
 	 * NOTE: the LSB of the head.next is set by
 	 * mm_take_all_locks() _after_ taking the above lock. So the
@@ -36,6 +35,7 @@ struct anon_vma {
 	 * mm_take_all_locks() (mm_all_locks_mutex).
 	 */
 	struct list_head head;	/* Chain of private "related" vmas */
+	atomic_t ref;
 };
 
 /*
@@ -72,14 +72,14 @@ static inline void anon_vma_lock(struct 
 {
 	struct anon_vma *anon_vma = vma->anon_vma;
 	if (anon_vma)
-		spin_lock(&anon_vma->lock);
+		mutex_lock(&anon_vma->lock);
 }
 
 static inline void anon_vma_unlock(struct vm_area_struct *vma)
 {
 	struct anon_vma *anon_vma = vma->anon_vma;
 	if (anon_vma)
-		spin_unlock(&anon_vma->lock);
+		mutex_unlock(&anon_vma->lock);
 }
 
 /*
Index: linux-2.6/kernel/fork.c
===================================================================
--- linux-2.6.orig/kernel/fork.c
+++ linux-2.6/kernel/fork.c
@@ -355,7 +355,7 @@ static int dup_mmap(struct mm_struct *mm
 			get_file(file);
 			if (tmp->vm_flags & VM_DENYWRITE)
 				atomic_dec(&inode->i_writecount);
-			spin_lock(&mapping->i_mmap_lock);
+			mutex_lock(&mapping->i_mmap_lock);
 			if (tmp->vm_flags & VM_SHARED)
 				mapping->i_mmap_writable++;
 			tmp->vm_truncate_count = mpnt->vm_truncate_count;
@@ -363,7 +363,7 @@ static int dup_mmap(struct mm_struct *mm
 			/* insert tmp into the share list, just after mpnt */
 			vma_prio_tree_add(tmp, mpnt);
 			flush_dcache_mmap_unlock(mapping);
-			spin_unlock(&mapping->i_mmap_lock);
+			mutex_unlock(&mapping->i_mmap_lock);
 		}
 
 		/*
Index: linux-2.6/mm/filemap_xip.c
===================================================================
--- linux-2.6.orig/mm/filemap_xip.c
+++ linux-2.6/mm/filemap_xip.c
@@ -182,7 +182,7 @@ __xip_unmap (struct address_space * mapp
 		return;
 
 retry:
-	spin_lock(&mapping->i_mmap_lock);
+	mutex_lock(&mapping->i_mmap_lock);
 	vma_prio_tree_foreach(vma, &iter, &mapping->i_mmap, pgoff, pgoff) {
 		mm = vma->vm_mm;
 		address = vma->vm_start +
@@ -200,7 +200,7 @@ retry:
 			page_cache_release(page);
 		}
 	}
-	spin_unlock(&mapping->i_mmap_lock);
+	mutex_unlock(&mapping->i_mmap_lock);
 
 	if (locked) {
 		mutex_unlock(&xip_sparse_mutex);
Index: linux-2.6/mm/fremap.c
===================================================================
--- linux-2.6.orig/mm/fremap.c
+++ linux-2.6/mm/fremap.c
@@ -208,13 +208,13 @@ SYSCALL_DEFINE5(remap_file_pages, unsign
 			}
 			goto out;
 		}
-		spin_lock(&mapping->i_mmap_lock);
+		mutex_lock(&mapping->i_mmap_lock);
 		flush_dcache_mmap_lock(mapping);
 		vma->vm_flags |= VM_NONLINEAR;
 		vma_prio_tree_remove(vma, &mapping->i_mmap);
 		vma_nonlinear_insert(vma, &mapping->i_mmap_nonlinear);
 		flush_dcache_mmap_unlock(mapping);
-		spin_unlock(&mapping->i_mmap_lock);
+		mutex_unlock(&mapping->i_mmap_lock);
 	}
 
 	if (vma->vm_flags & VM_LOCKED) {
Index: linux-2.6/mm/hugetlb.c
===================================================================
--- linux-2.6.orig/mm/hugetlb.c
+++ linux-2.6/mm/hugetlb.c
@@ -2210,9 +2210,9 @@ void __unmap_hugepage_range(struct vm_ar
 void unmap_hugepage_range(struct vm_area_struct *vma, unsigned long start,
 			  unsigned long end, struct page *ref_page)
 {
-	spin_lock(&vma->vm_file->f_mapping->i_mmap_lock);
+	mutex_lock(&vma->vm_file->f_mapping->i_mmap_lock);
 	__unmap_hugepage_range(vma, start, end, ref_page);
-	spin_unlock(&vma->vm_file->f_mapping->i_mmap_lock);
+	mutex_unlock(&vma->vm_file->f_mapping->i_mmap_lock);
 }
 
 /*
@@ -2244,7 +2244,7 @@ static int unmap_ref_private(struct mm_s
 	 * this mapping should be shared between all the VMAs,
 	 * __unmap_hugepage_range() is called as the lock is already held
 	 */
-	spin_lock(&mapping->i_mmap_lock);
+	mutex_lock(&mapping->i_mmap_lock);
 	vma_prio_tree_foreach(iter_vma, &iter, &mapping->i_mmap, pgoff, pgoff) {
 		/* Do not unmap the current VMA */
 		if (iter_vma == vma)
@@ -2262,7 +2262,7 @@ static int unmap_ref_private(struct mm_s
 				address, address + huge_page_size(h),
 				page);
 	}
-	spin_unlock(&mapping->i_mmap_lock);
+	mutex_unlock(&mapping->i_mmap_lock);
 
 	return 1;
 }
@@ -2678,7 +2678,7 @@ void hugetlb_change_protection(struct vm
 	BUG_ON(address >= end);
 	flush_cache_range(vma, address, end);
 
-	spin_lock(&vma->vm_file->f_mapping->i_mmap_lock);
+	mutex_lock(&vma->vm_file->f_mapping->i_mmap_lock);
 	spin_lock(&mm->page_table_lock);
 	for (; address < end; address += huge_page_size(h)) {
 		ptep = huge_pte_offset(mm, address);
@@ -2693,7 +2693,7 @@ void hugetlb_change_protection(struct vm
 		}
 	}
 	spin_unlock(&mm->page_table_lock);
-	spin_unlock(&vma->vm_file->f_mapping->i_mmap_lock);
+	mutex_unlock(&vma->vm_file->f_mapping->i_mmap_lock);
 
 	flush_tlb_range(vma, start, end);
 }
Index: linux-2.6/mm/ksm.c
===================================================================
--- linux-2.6.orig/mm/ksm.c
+++ linux-2.6/mm/ksm.c
@@ -1559,7 +1559,7 @@ again:
 		struct anon_vma_chain *vmac;
 		struct vm_area_struct *vma;
 
-		spin_lock(&anon_vma->lock);
+		mutex_lock(&anon_vma->lock);
 		list_for_each_entry(vmac, &anon_vma->head, same_anon_vma) {
 			vma = vmac->vma;
 			if (rmap_item->address < vma->vm_start ||
@@ -1582,7 +1582,7 @@ again:
 			if (!search_new_forks || !mapcount)
 				break;
 		}
-		spin_unlock(&anon_vma->lock);
+		mutex_unlock(&anon_vma->lock);
 		if (!mapcount)
 			goto out;
 	}
@@ -1612,7 +1612,7 @@ again:
 		struct anon_vma_chain *vmac;
 		struct vm_area_struct *vma;
 
-		spin_lock(&anon_vma->lock);
+		mutex_lock(&anon_vma->lock);
 		list_for_each_entry(vmac, &anon_vma->head, same_anon_vma) {
 			vma = vmac->vma;
 			if (rmap_item->address < vma->vm_start ||
@@ -1630,11 +1630,11 @@ again:
 			ret = try_to_unmap_one(page, vma,
 					rmap_item->address, flags);
 			if (ret != SWAP_AGAIN || !page_mapped(page)) {
-				spin_unlock(&anon_vma->lock);
+				mutex_unlock(&anon_vma->lock);
 				goto out;
 			}
 		}
-		spin_unlock(&anon_vma->lock);
+		mutex_unlock(&anon_vma->lock);
 	}
 	if (!search_new_forks++)
 		goto again;
@@ -1664,7 +1664,7 @@ again:
 		struct anon_vma_chain *vmac;
 		struct vm_area_struct *vma;
 
-		spin_lock(&anon_vma->lock);
+		mutex_lock(&anon_vma->lock);
 		list_for_each_entry(vmac, &anon_vma->head, same_anon_vma) {
 			vma = vmac->vma;
 			if (rmap_item->address < vma->vm_start ||
@@ -1681,11 +1681,11 @@ again:
 
 			ret = rmap_one(page, vma, rmap_item->address, arg);
 			if (ret != SWAP_AGAIN) {
-				spin_unlock(&anon_vma->lock);
+				mutex_unlock(&anon_vma->lock);
 				goto out;
 			}
 		}
-		spin_unlock(&anon_vma->lock);
+		mutex_unlock(&anon_vma->lock);
 	}
 	if (!search_new_forks++)
 		goto again;
Index: linux-2.6/mm/memory-failure.c
===================================================================
--- linux-2.6.orig/mm/memory-failure.c
+++ linux-2.6/mm/memory-failure.c
@@ -421,7 +421,7 @@ static void collect_procs_file(struct pa
 	 */
 
 	read_lock(&tasklist_lock);
-	spin_lock(&mapping->i_mmap_lock);
+	mutex_lock(&mapping->i_mmap_lock);
 	for_each_process(tsk) {
 		pgoff_t pgoff = page->index << (PAGE_CACHE_SHIFT - PAGE_SHIFT);
 
@@ -441,7 +441,7 @@ static void collect_procs_file(struct pa
 				add_to_kill(tsk, page, vma, to_kill, tkc);
 		}
 	}
-	spin_unlock(&mapping->i_mmap_lock);
+	mutex_unlock(&mapping->i_mmap_lock);
 	read_unlock(&tasklist_lock);
 }
 
Index: linux-2.6/mm/memory.c
===================================================================
--- linux-2.6.orig/mm/memory.c
+++ linux-2.6/mm/memory.c
@@ -1102,7 +1102,7 @@ unsigned long unmap_vmas(struct mmu_gath
 {
 	long zap_work = ZAP_BLOCK_SIZE;
 	unsigned long start = start_addr;
-	spinlock_t *i_mmap_lock = details? details->i_mmap_lock: NULL;
+	struct mutex *i_mmap_lock = details ? details->i_mmap_lock : NULL;
 	struct mm_struct *mm = vma->vm_mm;
 
 	mmu_notifier_invalidate_range_start(mm, start_addr, end_addr);
@@ -1152,7 +1152,7 @@ unsigned long unmap_vmas(struct mmu_gath
 			}
 
 			if (need_resched() ||
-				(i_mmap_lock && spin_needbreak(i_mmap_lock))) {
+				(i_mmap_lock && mutex_is_contended(i_mmap_lock))) {
 				if (i_mmap_lock)
 					goto out;
 				cond_resched();
@@ -2427,7 +2427,7 @@ again:
 
 	restart_addr = zap_page_range(vma, start_addr,
 					end_addr - start_addr, details);
-	need_break = need_resched() || spin_needbreak(details->i_mmap_lock);
+	need_break = need_resched() || mutex_is_contended(details->i_mmap_lock);
 
 	if (restart_addr >= end_addr) {
 		/* We have now completed this vma: mark it so */
@@ -2441,9 +2441,9 @@ again:
 			goto again;
 	}
 
-	spin_unlock(details->i_mmap_lock);
+	mutex_unlock(details->i_mmap_lock);
 	cond_resched();
-	spin_lock(details->i_mmap_lock);
+	mutex_lock(details->i_mmap_lock);
 	return -EINTR;
 }
 
@@ -2539,7 +2539,7 @@ void unmap_mapping_range(struct address_
 		details.last_index = ULONG_MAX;
 	details.i_mmap_lock = &mapping->i_mmap_lock;
 
-	spin_lock(&mapping->i_mmap_lock);
+	mutex_lock(&mapping->i_mmap_lock);
 
 	/* Protect against endless unmapping loops */
 	mapping->truncate_count++;
@@ -2554,7 +2554,7 @@ void unmap_mapping_range(struct address_
 		unmap_mapping_range_tree(&mapping->i_mmap, &details);
 	if (unlikely(!list_empty(&mapping->i_mmap_nonlinear)))
 		unmap_mapping_range_list(&mapping->i_mmap_nonlinear, &details);
-	spin_unlock(&mapping->i_mmap_lock);
+	mutex_unlock(&mapping->i_mmap_lock);
 }
 EXPORT_SYMBOL(unmap_mapping_range);
 
Index: linux-2.6/mm/mmap.c
===================================================================
--- linux-2.6.orig/mm/mmap.c
+++ linux-2.6/mm/mmap.c
@@ -216,9 +216,9 @@ void unlink_file_vma(struct vm_area_stru
 
 	if (file) {
 		struct address_space *mapping = file->f_mapping;
-		spin_lock(&mapping->i_mmap_lock);
+		mutex_lock(&mapping->i_mmap_lock);
 		__remove_shared_vm_struct(vma, file, mapping);
-		spin_unlock(&mapping->i_mmap_lock);
+		mutex_unlock(&mapping->i_mmap_lock);
 	}
 }
 
@@ -449,7 +449,7 @@ static void vma_link(struct mm_struct *m
 		mapping = vma->vm_file->f_mapping;
 
 	if (mapping) {
-		spin_lock(&mapping->i_mmap_lock);
+		mutex_lock(&mapping->i_mmap_lock);
 		vma->vm_truncate_count = mapping->truncate_count;
 	}
 	anon_vma_lock(vma);
@@ -459,7 +459,7 @@ static void vma_link(struct mm_struct *m
 
 	anon_vma_unlock(vma);
 	if (mapping)
-		spin_unlock(&mapping->i_mmap_lock);
+		mutex_unlock(&mapping->i_mmap_lock);
 
 	mm->map_count++;
 	validate_mm(mm);
@@ -565,7 +565,7 @@ again:			remove_next = 1 + (end > next->
 		mapping = file->f_mapping;
 		if (!(vma->vm_flags & VM_NONLINEAR))
 			root = &mapping->i_mmap;
-		spin_lock(&mapping->i_mmap_lock);
+		mutex_lock(&mapping->i_mmap_lock);
 		if (importer &&
 		    vma->vm_truncate_count != next->vm_truncate_count) {
 			/*
@@ -626,7 +626,7 @@ again:			remove_next = 1 + (end > next->
 	}
 
 	if (mapping)
-		spin_unlock(&mapping->i_mmap_lock);
+		mutex_unlock(&mapping->i_mmap_lock);
 
 	if (remove_next) {
 		if (file) {
@@ -2440,7 +2440,7 @@ static void vm_lock_anon_vma(struct mm_s
 		 * The LSB of head.next can't change from under us
 		 * because we hold the mm_all_locks_mutex.
 		 */
-		spin_lock_nest_lock(&anon_vma->lock, &mm->mmap_sem);
+		mutex_lock_nest_lock(&anon_vma->lock, &mm->mmap_sem);
 		/*
 		 * We can safely modify head.next after taking the
 		 * anon_vma->lock. If some other vma in this mm shares
@@ -2470,7 +2470,7 @@ static void vm_lock_mapping(struct mm_st
 		 */
 		if (test_and_set_bit(AS_MM_ALL_LOCKS, &mapping->flags))
 			BUG();
-		spin_lock_nest_lock(&mapping->i_mmap_lock, &mm->mmap_sem);
+		mutex_lock_nest_lock(&mapping->i_mmap_lock, &mm->mmap_sem);
 	}
 }
 
@@ -2558,7 +2558,7 @@ static void vm_unlock_anon_vma(struct an
 		if (!__test_and_clear_bit(0, (unsigned long *)
 					  &anon_vma->head.next))
 			BUG();
-		spin_unlock(&anon_vma->lock);
+		mutex_unlock(&anon_vma->lock);
 	}
 }
 
@@ -2569,7 +2569,7 @@ static void vm_unlock_mapping(struct add
 		 * AS_MM_ALL_LOCKS can't change to 0 from under us
 		 * because we hold the mm_all_locks_mutex.
 		 */
-		spin_unlock(&mapping->i_mmap_lock);
+		mutex_unlock(&mapping->i_mmap_lock);
 		if (!test_and_clear_bit(AS_MM_ALL_LOCKS,
 					&mapping->flags))
 			BUG();
Index: linux-2.6/mm/mremap.c
===================================================================
--- linux-2.6.orig/mm/mremap.c
+++ linux-2.6/mm/mremap.c
@@ -91,7 +91,7 @@ static void move_ptes(struct vm_area_str
 		 * and we propagate stale pages into the dst afterward.
 		 */
 		mapping = vma->vm_file->f_mapping;
-		spin_lock(&mapping->i_mmap_lock);
+		mutex_lock(&mapping->i_mmap_lock);
 		if (new_vma->vm_truncate_count &&
 		    new_vma->vm_truncate_count != vma->vm_truncate_count)
 			new_vma->vm_truncate_count = 0;
@@ -123,7 +123,7 @@ static void move_ptes(struct vm_area_str
 	pte_unmap_nested(new_pte - 1);
 	pte_unmap_unlock(old_pte - 1, old_ptl);
 	if (mapping)
-		spin_unlock(&mapping->i_mmap_lock);
+		mutex_unlock(&mapping->i_mmap_lock);
 	mmu_notifier_invalidate_range_end(vma->vm_mm, old_start, old_end);
 }
 
Index: linux-2.6/mm/rmap.c
===================================================================
--- linux-2.6.orig/mm/rmap.c
+++ linux-2.6/mm/rmap.c
@@ -140,7 +140,7 @@ int anon_vma_prepare(struct vm_area_stru
 				goto out_enomem_free_avc;
 			allocated = anon_vma;
 		}
-		spin_lock(&anon_vma->lock);
+		mutex_lock(&anon_vma->lock);
 
 		/* page_table_lock to protect against threads */
 		spin_lock(&mm->page_table_lock);
@@ -154,7 +154,7 @@ int anon_vma_prepare(struct vm_area_stru
 		}
 		spin_unlock(&mm->page_table_lock);
 
-		spin_unlock(&anon_vma->lock);
+		mutex_unlock(&anon_vma->lock);
 		if (unlikely(allocated)) {
 			anon_vma_put(allocated);
 			anon_vma_chain_free(avc);
@@ -176,9 +176,9 @@ static void anon_vma_chain_link(struct v
 	avc->anon_vma = anon_vma;
 	list_add(&avc->same_vma, &vma->anon_vma_chain);
 
-	spin_lock(&anon_vma->lock);
+	mutex_lock(&anon_vma->lock);
 	list_add_tail(&avc->same_anon_vma, &anon_vma->head);
-	spin_unlock(&anon_vma->lock);
+	mutex_unlock(&anon_vma->lock);
 }
 
 /*
@@ -251,10 +251,10 @@ static void anon_vma_unlink(struct anon_
 	if (!anon_vma)
 		return;
 
-	spin_lock(&anon_vma->lock);
+	mutex_lock(&anon_vma->lock);
 	list_del(&anon_vma_chain->same_anon_vma);
 	empty = list_empty(&anon_vma->head);
-	spin_unlock(&anon_vma->lock);
+	mutex_unlock(&anon_vma->lock);
 
 	if (empty)
 		anon_vma_put(anon_vma);
@@ -276,7 +276,7 @@ static void anon_vma_ctor(void *data)
 {
 	struct anon_vma *anon_vma = data;
 
-	spin_lock_init(&anon_vma->lock);
+	mutex_init(&anon_vma->lock);
 	atomic_set(&anon_vma->ref, 0);
 	INIT_LIST_HEAD(&anon_vma->head);
 }
@@ -317,14 +317,14 @@ struct anon_vma *page_lock_anon_vma(stru
 	struct anon_vma *anon_vma = anon_vma_get(page);
 
 	if (anon_vma)
-		spin_lock(&anon_vma->lock);
+		mutex_lock(&anon_vma->lock);
 
 	return anon_vma;
 }
 
 void page_unlock_anon_vma(struct anon_vma *anon_vma)
 {
-	spin_unlock(&anon_vma->lock);
+	mutex_unlock(&anon_vma->lock);
 	anon_vma_put(anon_vma);
 }
 
@@ -569,7 +569,7 @@ static int page_referenced_file(struct p
 	 */
 	BUG_ON(!PageLocked(page));
 
-	spin_lock(&mapping->i_mmap_lock);
+	mutex_lock(&mapping->i_mmap_lock);
 
 	/*
 	 * i_mmap_lock does not stabilize mapcount at all, but mapcount
@@ -594,7 +594,7 @@ static int page_referenced_file(struct p
 			break;
 	}
 
-	spin_unlock(&mapping->i_mmap_lock);
+	mutex_unlock(&mapping->i_mmap_lock);
 	return referenced;
 }
 
@@ -681,7 +681,7 @@ static int page_mkclean_file(struct addr
 
 	BUG_ON(PageAnon(page));
 
-	spin_lock(&mapping->i_mmap_lock);
+	mutex_lock(&mapping->i_mmap_lock);
 	vma_prio_tree_foreach(vma, &iter, &mapping->i_mmap, pgoff, pgoff) {
 		if (vma->vm_flags & VM_SHARED) {
 			unsigned long address = vma_address(page, vma);
@@ -690,7 +690,7 @@ static int page_mkclean_file(struct addr
 			ret += page_mkclean_one(page, vma, address);
 		}
 	}
-	spin_unlock(&mapping->i_mmap_lock);
+	mutex_unlock(&mapping->i_mmap_lock);
 	return ret;
 }
 
@@ -1196,7 +1196,7 @@ static int try_to_unmap_file(struct page
 	unsigned long max_nl_size = 0;
 	unsigned int mapcount;
 
-	spin_lock(&mapping->i_mmap_lock);
+	mutex_lock(&mapping->i_mmap_lock);
 	vma_prio_tree_foreach(vma, &iter, &mapping->i_mmap, pgoff, pgoff) {
 		unsigned long address = vma_address(page, vma);
 		if (address == -EFAULT)
@@ -1242,7 +1242,7 @@ static int try_to_unmap_file(struct page
 	mapcount = page_mapcount(page);
 	if (!mapcount)
 		goto out;
-	cond_resched_lock(&mapping->i_mmap_lock);
+	cond_resched();
 
 	max_nl_size = (max_nl_size + CLUSTER_SIZE - 1) & CLUSTER_MASK;
 	if (max_nl_cursor == 0)
@@ -1264,7 +1264,7 @@ static int try_to_unmap_file(struct page
 			}
 			vma->vm_private_data = (void *) max_nl_cursor;
 		}
-		cond_resched_lock(&mapping->i_mmap_lock);
+		cond_resched();
 		max_nl_cursor += CLUSTER_SIZE;
 	} while (max_nl_cursor <= max_nl_size);
 
@@ -1276,7 +1276,7 @@ static int try_to_unmap_file(struct page
 	list_for_each_entry(vma, &mapping->i_mmap_nonlinear, shared.vm_set.list)
 		vma->vm_private_data = NULL;
 out:
-	spin_unlock(&mapping->i_mmap_lock);
+	mutex_unlock(&mapping->i_mmap_lock);
 	return ret;
 }
 
@@ -1361,7 +1361,7 @@ static int rmap_walk_anon(struct page *p
 	anon_vma = page_anon_vma(page);
 	if (!anon_vma)
 		return ret;
-	spin_lock(&anon_vma->lock);
+	mutex_lock(&anon_vma->lock);
 	list_for_each_entry(avc, &anon_vma->head, same_anon_vma) {
 		struct vm_area_struct *vma = avc->vma;
 		unsigned long address = vma_address(page, vma);
@@ -1371,7 +1371,7 @@ static int rmap_walk_anon(struct page *p
 		if (ret != SWAP_AGAIN)
 			break;
 	}
-	spin_unlock(&anon_vma->lock);
+	mutex_unlock(&anon_vma->lock);
 	return ret;
 }
 
@@ -1386,7 +1386,7 @@ static int rmap_walk_file(struct page *p
 
 	if (!mapping)
 		return ret;
-	spin_lock(&mapping->i_mmap_lock);
+	mutex_lock(&mapping->i_mmap_lock);
 	vma_prio_tree_foreach(vma, &iter, &mapping->i_mmap, pgoff, pgoff) {
 		unsigned long address = vma_address(page, vma);
 		if (address == -EFAULT)
@@ -1400,7 +1400,7 @@ static int rmap_walk_file(struct page *p
 	 * never contain migration ptes.  Decide what to do about this
 	 * limitation to linear when we need rmap_walk() on nonlinear.
 	 */
-	spin_unlock(&mapping->i_mmap_lock);
+	mutex_unlock(&mapping->i_mmap_lock);
 	return ret;
 }
 


