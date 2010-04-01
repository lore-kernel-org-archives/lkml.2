Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755602Ab0DALna (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 07:43:30 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:52867 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755579Ab0DALnV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 07:43:21 -0400
Subject: Re: [COUNTERPATCH] mm: avoid overflowing preempt_count() in
 mmu_take_all_locks()
From: Peter Zijlstra <peterz@infradead.org>
To: Avi Kivity <avi@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Rik van Riel <riel@redhat.com>,
       linux-kernel@vger.kernel.org, aarcange@redhat.com,
       akpm@linux-foundation.org, Kent Overstreet <kent.overstreet@gmail.com>,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1270121264.1653.205.camel@laptop>
References: <1270117906.1653.139.camel@laptop>
	 <alpine.LFD.2.00.1004011300550.32352@localhost.localdomain>
	 <4BB47FC3.1020606@redhat.com>  <4BB480CC.2060503@redhat.com>
	 <1270121264.1653.205.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 01 Apr 2010 13:43:14 +0200
Message-ID: <1270122194.1653.223.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-04-01 at 13:27 +0200, Peter Zijlstra wrote:
> 
> I've almost got a patch done that converts those two, still need to look
> where that tasklist_lock muck happens.

OK, so the below builds and boots, only need to track down that
tasklist_lock nesting, but I got to run an errand first.

---
 arch/x86/mm/hugetlbpage.c |    4 ++--
 fs/hugetlbfs/inode.c      |    4 ++--
 fs/inode.c                |    2 +-
 include/linux/fs.h        |    2 +-
 include/linux/lockdep.h   |    3 +++
 include/linux/mm.h        |    2 +-
 include/linux/mutex.h     |    8 ++++++++
 include/linux/rmap.h      |    8 ++++----
 kernel/fork.c             |    4 ++--
 kernel/mutex.c            |   25 +++++++++++++++++--------
 mm/filemap_xip.c          |    4 ++--
 mm/fremap.c               |    4 ++--
 mm/hugetlb.c              |   12 ++++++------
 mm/ksm.c                  |   18 +++++++++---------
 mm/memory-failure.c       |    4 ++--
 mm/memory.c               |   21 ++++++---------------
 mm/mmap.c                 |   20 ++++++++++----------
 mm/mremap.c               |    4 ++--
 mm/rmap.c                 |   40 +++++++++++++++++++---------------------
 19 files changed, 99 insertions(+), 90 deletions(-)

diff --git a/arch/x86/mm/hugetlbpage.c b/arch/x86/mm/hugetlbpage.c
index f46c340..5e5ac7d 100644
--- a/arch/x86/mm/hugetlbpage.c
+++ b/arch/x86/mm/hugetlbpage.c
@@ -73,7 +73,7 @@ static void huge_pmd_share(struct mm_struct *mm, unsigned long addr, pud_t *pud)
 	if (!vma_shareable(vma, addr))
 		return;
 
-	spin_lock(&mapping->i_mmap_lock);
+	mutex_lock(&mapping->i_mmap_lock);
 	vma_prio_tree_foreach(svma, &iter, &mapping->i_mmap, idx, idx) {
 		if (svma == vma)
 			continue;
@@ -98,7 +98,7 @@ static void huge_pmd_share(struct mm_struct *mm, unsigned long addr, pud_t *pud)
 		put_page(virt_to_page(spte));
 	spin_unlock(&mm->page_table_lock);
 out:
-	spin_unlock(&mapping->i_mmap_lock);
+	mutex_unlock(&mapping->i_mmap_lock);
 }
 
 /*
diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index a0bbd3d..141065d 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -429,10 +429,10 @@ static int hugetlb_vmtruncate(struct inode *inode, loff_t offset)
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
diff --git a/fs/inode.c b/fs/inode.c
index 407bf39..6d1ea52 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -258,7 +258,7 @@ void inode_init_once(struct inode *inode)
 	INIT_LIST_HEAD(&inode->i_devices);
 	INIT_RADIX_TREE(&inode->i_data.page_tree, GFP_ATOMIC);
 	spin_lock_init(&inode->i_data.tree_lock);
-	spin_lock_init(&inode->i_data.i_mmap_lock);
+	mutex_init(&inode->i_data.i_mmap_lock);
 	INIT_LIST_HEAD(&inode->i_data.private_list);
 	spin_lock_init(&inode->i_data.private_lock);
 	INIT_RAW_PRIO_TREE_ROOT(&inode->i_data.i_mmap);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 10b8ded..6aa624b 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -627,7 +627,7 @@ struct address_space {
 	unsigned int		i_mmap_writable;/* count VM_SHARED mappings */
 	struct prio_tree_root	i_mmap;		/* tree of private and shared mappings */
 	struct list_head	i_mmap_nonlinear;/*list VM_NONLINEAR mappings */
-	spinlock_t		i_mmap_lock;	/* protect tree, count, list */
+	struct mutex		i_mmap_lock;	/* protect tree, count, list */
 	unsigned int		truncate_count;	/* Cover race condition with truncate */
 	unsigned long		nrpages;	/* number of total pages */
 	pgoff_t			writeback_index;/* writeback starts here */
diff --git a/include/linux/lockdep.h b/include/linux/lockdep.h
index a03977a..4bb7620 100644
--- a/include/linux/lockdep.h
+++ b/include/linux/lockdep.h
@@ -484,12 +484,15 @@ static inline void print_irqtrace_events(struct task_struct *curr)
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 # ifdef CONFIG_PROVE_LOCKING
 #  define mutex_acquire(l, s, t, i)		lock_acquire(l, s, t, 0, 2, NULL, i)
+#  define mutex_acquire_nest(l, s, t, n, i)	lock_acquire(l, s, t, 0, 2, n, i)
 # else
 #  define mutex_acquire(l, s, t, i)		lock_acquire(l, s, t, 0, 1, NULL, i)
+#  define mutex_acquire_nest(l, s, t, n, i)	lock_acquire(l, s, t, 0, 1, n, i)
 # endif
 # define mutex_release(l, n, i)			lock_release(l, n, i)
 #else
 # define mutex_acquire(l, s, t, i)		do { } while (0)
+# define mutex_acquire_nest(l, s, t, n, i)	do { } while (0)
 # define mutex_release(l, n, i)			do { } while (0)
 #endif
 
diff --git a/include/linux/mm.h b/include/linux/mm.h
index c8442b6..ed7cfd2 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -749,7 +749,7 @@ struct zap_details {
 	struct address_space *check_mapping;	/* Check page->mapping if set */
 	pgoff_t	first_index;			/* Lowest page->index to unmap */
 	pgoff_t last_index;			/* Highest page->index to unmap */
-	spinlock_t *i_mmap_lock;		/* For unmap_mapping_range: */
+	struct mutex *i_mmap_lock;		/* For unmap_mapping_range: */
 	unsigned long truncate_count;		/* Compare vm_truncate_count */
 };
 
diff --git a/include/linux/mutex.h b/include/linux/mutex.h
index 878cab4..2bd2847 100644
--- a/include/linux/mutex.h
+++ b/include/linux/mutex.h
@@ -132,6 +132,13 @@ extern int __must_check mutex_lock_killable_nested(struct mutex *lock,
 #define mutex_lock(lock) mutex_lock_nested(lock, 0)
 #define mutex_lock_interruptible(lock) mutex_lock_interruptible_nested(lock, 0)
 #define mutex_lock_killable(lock) mutex_lock_killable_nested(lock, 0)
+
+#define mutex_lock_nest_lock(lock, nest_lock)				\
+do {									\
+	typecheck(struct lockdep_map *, &(nest_lock)->dep_map);		\
+	_mutex_lock_nest_lock(lock, &(nest_lock)->dep_map);		\
+} while (0)
+
 #else
 extern void mutex_lock(struct mutex *lock);
 extern int __must_check mutex_lock_interruptible(struct mutex *lock);
@@ -140,6 +147,7 @@ extern int __must_check mutex_lock_killable(struct mutex *lock);
 # define mutex_lock_nested(lock, subclass) mutex_lock(lock)
 # define mutex_lock_interruptible_nested(lock, subclass) mutex_lock_interruptible(lock)
 # define mutex_lock_killable_nested(lock, subclass) mutex_lock_killable(lock)
+# define mutex_lock_nest_lock(lock, nest_lock) mutex_lock(lock)
 #endif
 
 /*
diff --git a/include/linux/rmap.h b/include/linux/rmap.h
index d25bd22..a3c2657 100644
--- a/include/linux/rmap.h
+++ b/include/linux/rmap.h
@@ -7,7 +7,7 @@
 #include <linux/list.h>
 #include <linux/slab.h>
 #include <linux/mm.h>
-#include <linux/spinlock.h>
+#include <linux/mutex.h>
 #include <linux/memcontrol.h>
 
 /*
@@ -25,7 +25,7 @@
  * pointing to this anon_vma once its vma list is empty.
  */
 struct anon_vma {
-	spinlock_t lock;	/* Serialize access to vma list */
+	struct mutex lock;	/* Serialize access to vma list */
 #ifdef CONFIG_KSM
 	atomic_t ksm_refcount;
 #endif
@@ -94,14 +94,14 @@ static inline void anon_vma_lock(struct vm_area_struct *vma)
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
diff --git a/kernel/fork.c b/kernel/fork.c
index d67f1db..a3a688e 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -355,7 +355,7 @@ static int dup_mmap(struct mm_struct *mm, struct mm_struct *oldmm)
 			get_file(file);
 			if (tmp->vm_flags & VM_DENYWRITE)
 				atomic_dec(&inode->i_writecount);
-			spin_lock(&mapping->i_mmap_lock);
+			mutex_lock(&mapping->i_mmap_lock);
 			if (tmp->vm_flags & VM_SHARED)
 				mapping->i_mmap_writable++;
 			tmp->vm_truncate_count = mpnt->vm_truncate_count;
@@ -363,7 +363,7 @@ static int dup_mmap(struct mm_struct *mm, struct mm_struct *oldmm)
 			/* insert tmp into the share list, just after mpnt */
 			vma_prio_tree_add(tmp, mpnt);
 			flush_dcache_mmap_unlock(mapping);
-			spin_unlock(&mapping->i_mmap_lock);
+			mutex_unlock(&mapping->i_mmap_lock);
 		}
 
 		/*
diff --git a/kernel/mutex.c b/kernel/mutex.c
index 632f04c..e3a0f26 100644
--- a/kernel/mutex.c
+++ b/kernel/mutex.c
@@ -140,14 +140,14 @@ EXPORT_SYMBOL(mutex_unlock);
  */
 static inline int __sched
 __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
-	       	unsigned long ip)
+		    struct lockdep_map *nest_lock, unsigned long ip)
 {
 	struct task_struct *task = current;
 	struct mutex_waiter waiter;
 	unsigned long flags;
 
 	preempt_disable();
-	mutex_acquire(&lock->dep_map, subclass, 0, ip);
+	mutex_acquire_nest(&lock->dep_map, subclass, 0, nest_lock, ip);
 
 #ifdef CONFIG_MUTEX_SPIN_ON_OWNER
 	/*
@@ -278,7 +278,16 @@ void __sched
 mutex_lock_nested(struct mutex *lock, unsigned int subclass)
 {
 	might_sleep();
-	__mutex_lock_common(lock, TASK_UNINTERRUPTIBLE, subclass, _RET_IP_);
+	__mutex_lock_common(lock, TASK_UNINTERRUPTIBLE, subclass, NULL, _RET_IP_);
+}
+
+EXPORT_SYMBOL_GPL(mutex_lock_nested);
+
+void __sched
+_mutex_lock_nest_lock(struct mutex *lock, struct lockdep_map *nest)
+{
+	might_sleep();
+	__mutex_lock_common(lock, TASK_UNINTERRUPTIBLE, subclass, nest, _RET_IP_);
 }
 
 EXPORT_SYMBOL_GPL(mutex_lock_nested);
@@ -287,7 +296,7 @@ int __sched
 mutex_lock_killable_nested(struct mutex *lock, unsigned int subclass)
 {
 	might_sleep();
-	return __mutex_lock_common(lock, TASK_KILLABLE, subclass, _RET_IP_);
+	return __mutex_lock_common(lock, TASK_KILLABLE, subclass, NULL, _RET_IP_);
 }
 EXPORT_SYMBOL_GPL(mutex_lock_killable_nested);
 
@@ -296,7 +305,7 @@ mutex_lock_interruptible_nested(struct mutex *lock, unsigned int subclass)
 {
 	might_sleep();
 	return __mutex_lock_common(lock, TASK_INTERRUPTIBLE,
-				   subclass, _RET_IP_);
+				   subclass, NULL, _RET_IP_);
 }
 
 EXPORT_SYMBOL_GPL(mutex_lock_interruptible_nested);
@@ -402,7 +411,7 @@ __mutex_lock_slowpath(atomic_t *lock_count)
 {
 	struct mutex *lock = container_of(lock_count, struct mutex, count);
 
-	__mutex_lock_common(lock, TASK_UNINTERRUPTIBLE, 0, _RET_IP_);
+	__mutex_lock_common(lock, TASK_UNINTERRUPTIBLE, 0, NULL, _RET_IP_);
 }
 
 static noinline int __sched
@@ -410,7 +419,7 @@ __mutex_lock_killable_slowpath(atomic_t *lock_count)
 {
 	struct mutex *lock = container_of(lock_count, struct mutex, count);
 
-	return __mutex_lock_common(lock, TASK_KILLABLE, 0, _RET_IP_);
+	return __mutex_lock_common(lock, TASK_KILLABLE, 0, NULL, _RET_IP_);
 }
 
 static noinline int __sched
@@ -418,7 +427,7 @@ __mutex_lock_interruptible_slowpath(atomic_t *lock_count)
 {
 	struct mutex *lock = container_of(lock_count, struct mutex, count);
 
-	return __mutex_lock_common(lock, TASK_INTERRUPTIBLE, 0, _RET_IP_);
+	return __mutex_lock_common(lock, TASK_INTERRUPTIBLE, 0, NULL, _RET_IP_);
 }
 #endif
 
diff --git a/mm/filemap_xip.c b/mm/filemap_xip.c
index 78b94f0..61157dc 100644
--- a/mm/filemap_xip.c
+++ b/mm/filemap_xip.c
@@ -182,7 +182,7 @@ __xip_unmap (struct address_space * mapping,
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
diff --git a/mm/fremap.c b/mm/fremap.c
index 46f5dac..2c0528e 100644
--- a/mm/fremap.c
+++ b/mm/fremap.c
@@ -208,13 +208,13 @@ SYSCALL_DEFINE5(remap_file_pages, unsigned long, start, unsigned long, size,
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
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 3a5aeb3..3807dd5 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -2210,9 +2210,9 @@ void __unmap_hugepage_range(struct vm_area_struct *vma, unsigned long start,
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
@@ -2244,7 +2244,7 @@ static int unmap_ref_private(struct mm_struct *mm, struct vm_area_struct *vma,
 	 * this mapping should be shared between all the VMAs,
 	 * __unmap_hugepage_range() is called as the lock is already held
 	 */
-	spin_lock(&mapping->i_mmap_lock);
+	mutex_lock(&mapping->i_mmap_lock);
 	vma_prio_tree_foreach(iter_vma, &iter, &mapping->i_mmap, pgoff, pgoff) {
 		/* Do not unmap the current VMA */
 		if (iter_vma == vma)
@@ -2262,7 +2262,7 @@ static int unmap_ref_private(struct mm_struct *mm, struct vm_area_struct *vma,
 				address, address + huge_page_size(h),
 				page);
 	}
-	spin_unlock(&mapping->i_mmap_lock);
+	mutex_unlock(&mapping->i_mmap_lock);
 
 	return 1;
 }
@@ -2678,7 +2678,7 @@ void hugetlb_change_protection(struct vm_area_struct *vma,
 	BUG_ON(address >= end);
 	flush_cache_range(vma, address, end);
 
-	spin_lock(&vma->vm_file->f_mapping->i_mmap_lock);
+	mutex_lock(&vma->vm_file->f_mapping->i_mmap_lock);
 	spin_lock(&mm->page_table_lock);
 	for (; address < end; address += huge_page_size(h)) {
 		ptep = huge_pte_offset(mm, address);
@@ -2693,7 +2693,7 @@ void hugetlb_change_protection(struct vm_area_struct *vma,
 		}
 	}
 	spin_unlock(&mm->page_table_lock);
-	spin_unlock(&vma->vm_file->f_mapping->i_mmap_lock);
+	mutex_unlock(&vma->vm_file->f_mapping->i_mmap_lock);
 
 	flush_tlb_range(vma, start, end);
 }
diff --git a/mm/ksm.c b/mm/ksm.c
index 8cdfc2a..27861d8 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -327,7 +327,7 @@ static void drop_anon_vma(struct rmap_item *rmap_item)
 
 	if (atomic_dec_and_lock(&anon_vma->ksm_refcount, &anon_vma->lock)) {
 		int empty = list_empty(&anon_vma->head);
-		spin_unlock(&anon_vma->lock);
+		mutex_unlock(&anon_vma->lock);
 		if (empty)
 			anon_vma_free(anon_vma);
 	}
@@ -1566,7 +1566,7 @@ again:
 		struct anon_vma_chain *vmac;
 		struct vm_area_struct *vma;
 
-		spin_lock(&anon_vma->lock);
+		mutex_lock(&anon_vma->lock);
 		list_for_each_entry(vmac, &anon_vma->head, same_anon_vma) {
 			vma = vmac->vma;
 			if (rmap_item->address < vma->vm_start ||
@@ -1589,7 +1589,7 @@ again:
 			if (!search_new_forks || !mapcount)
 				break;
 		}
-		spin_unlock(&anon_vma->lock);
+		mutex_unlock(&anon_vma->lock);
 		if (!mapcount)
 			goto out;
 	}
@@ -1619,7 +1619,7 @@ again:
 		struct anon_vma_chain *vmac;
 		struct vm_area_struct *vma;
 
-		spin_lock(&anon_vma->lock);
+		mutex_lock(&anon_vma->lock);
 		list_for_each_entry(vmac, &anon_vma->head, same_anon_vma) {
 			vma = vmac->vma;
 			if (rmap_item->address < vma->vm_start ||
@@ -1637,11 +1637,11 @@ again:
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
@@ -1671,7 +1671,7 @@ again:
 		struct anon_vma_chain *vmac;
 		struct vm_area_struct *vma;
 
-		spin_lock(&anon_vma->lock);
+		mutex_lock(&anon_vma->lock);
 		list_for_each_entry(vmac, &anon_vma->head, same_anon_vma) {
 			vma = vmac->vma;
 			if (rmap_item->address < vma->vm_start ||
@@ -1688,11 +1688,11 @@ again:
 
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
diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index d1f3351..ebbfb33 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -421,7 +421,7 @@ static void collect_procs_file(struct page *page, struct list_head *to_kill,
 	 */
 
 	read_lock(&tasklist_lock);
-	spin_lock(&mapping->i_mmap_lock);
+	mutex_lock(&mapping->i_mmap_lock);
 	for_each_process(tsk) {
 		pgoff_t pgoff = page->index << (PAGE_CACHE_SHIFT - PAGE_SHIFT);
 
@@ -441,7 +441,7 @@ static void collect_procs_file(struct page *page, struct list_head *to_kill,
 				add_to_kill(tsk, page, vma, to_kill, tkc);
 		}
 	}
-	spin_unlock(&mapping->i_mmap_lock);
+	mutex_unlock(&mapping->i_mmap_lock);
 	read_unlock(&tasklist_lock);
 }
 
diff --git a/mm/memory.c b/mm/memory.c
index bc9ba5a..9e386b6 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1104,7 +1104,6 @@ unsigned long unmap_vmas(struct mmu_gather **tlbp,
 	unsigned long tlb_start = 0;	/* For tlb_finish_mmu */
 	int tlb_start_valid = 0;
 	unsigned long start = start_addr;
-	spinlock_t *i_mmap_lock = details? details->i_mmap_lock: NULL;
 	int fullmm = (*tlbp)->fullmm;
 	struct mm_struct *mm = vma->vm_mm;
 
@@ -1161,21 +1160,13 @@ unsigned long unmap_vmas(struct mmu_gather **tlbp,
 
 			tlb_finish_mmu(*tlbp, tlb_start, start);
 
-			if (need_resched() ||
-				(i_mmap_lock && spin_needbreak(i_mmap_lock))) {
-				if (i_mmap_lock) {
-					*tlbp = NULL;
-					goto out;
-				}
-				cond_resched();
-			}
+			cond_resched();
 
 			*tlbp = tlb_gather_mmu(vma->vm_mm, fullmm);
 			tlb_start_valid = 0;
 			zap_work = ZAP_BLOCK_SIZE;
 		}
 	}
-out:
 	mmu_notifier_invalidate_range_end(mm, start_addr, end_addr);
 	return start;	/* which is now the end (or restart) address */
 }
@@ -2442,7 +2433,7 @@ again:
 
 	restart_addr = zap_page_range(vma, start_addr,
 					end_addr - start_addr, details);
-	need_break = need_resched() || spin_needbreak(details->i_mmap_lock);
+	need_break = need_resched();
 
 	if (restart_addr >= end_addr) {
 		/* We have now completed this vma: mark it so */
@@ -2456,9 +2447,9 @@ again:
 			goto again;
 	}
 
-	spin_unlock(details->i_mmap_lock);
+	mutex_unlock(details->i_mmap_lock);
 	cond_resched();
-	spin_lock(details->i_mmap_lock);
+	mutex_lock(details->i_mmap_lock);
 	return -EINTR;
 }
 
@@ -2554,7 +2545,7 @@ void unmap_mapping_range(struct address_space *mapping,
 		details.last_index = ULONG_MAX;
 	details.i_mmap_lock = &mapping->i_mmap_lock;
 
-	spin_lock(&mapping->i_mmap_lock);
+	mutex_lock(&mapping->i_mmap_lock);
 
 	/* Protect against endless unmapping loops */
 	mapping->truncate_count++;
@@ -2569,7 +2560,7 @@ void unmap_mapping_range(struct address_space *mapping,
 		unmap_mapping_range_tree(&mapping->i_mmap, &details);
 	if (unlikely(!list_empty(&mapping->i_mmap_nonlinear)))
 		unmap_mapping_range_list(&mapping->i_mmap_nonlinear, &details);
-	spin_unlock(&mapping->i_mmap_lock);
+	mutex_unlock(&mapping->i_mmap_lock);
 }
 EXPORT_SYMBOL(unmap_mapping_range);
 
diff --git a/mm/mmap.c b/mm/mmap.c
index 75557c6..2602682 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -216,9 +216,9 @@ void unlink_file_vma(struct vm_area_struct *vma)
 
 	if (file) {
 		struct address_space *mapping = file->f_mapping;
-		spin_lock(&mapping->i_mmap_lock);
+		mutex_lock(&mapping->i_mmap_lock);
 		__remove_shared_vm_struct(vma, file, mapping);
-		spin_unlock(&mapping->i_mmap_lock);
+		mutex_unlock(&mapping->i_mmap_lock);
 	}
 }
 
@@ -449,7 +449,7 @@ static void vma_link(struct mm_struct *mm, struct vm_area_struct *vma,
 		mapping = vma->vm_file->f_mapping;
 
 	if (mapping) {
-		spin_lock(&mapping->i_mmap_lock);
+		mutex_lock(&mapping->i_mmap_lock);
 		vma->vm_truncate_count = mapping->truncate_count;
 	}
 	anon_vma_lock(vma);
@@ -459,7 +459,7 @@ static void vma_link(struct mm_struct *mm, struct vm_area_struct *vma,
 
 	anon_vma_unlock(vma);
 	if (mapping)
-		spin_unlock(&mapping->i_mmap_lock);
+		mutex_unlock(&mapping->i_mmap_lock);
 
 	mm->map_count++;
 	validate_mm(mm);
@@ -565,7 +565,7 @@ again:			remove_next = 1 + (end > next->vm_end);
 		mapping = file->f_mapping;
 		if (!(vma->vm_flags & VM_NONLINEAR))
 			root = &mapping->i_mmap;
-		spin_lock(&mapping->i_mmap_lock);
+		mutex_lock(&mapping->i_mmap_lock);
 		if (importer &&
 		    vma->vm_truncate_count != next->vm_truncate_count) {
 			/*
@@ -626,7 +626,7 @@ again:			remove_next = 1 + (end > next->vm_end);
 	}
 
 	if (mapping)
-		spin_unlock(&mapping->i_mmap_lock);
+		mutex_unlock(&mapping->i_mmap_lock);
 
 	if (remove_next) {
 		if (file) {
@@ -2440,7 +2440,7 @@ static void vm_lock_anon_vma(struct mm_struct *mm, struct anon_vma *anon_vma)
 		 * The LSB of head.next can't change from under us
 		 * because we hold the mm_all_locks_mutex.
 		 */
-		spin_lock_nest_lock(&anon_vma->lock, &mm->mmap_sem);
+		mutex_lock_nest_lock(&anon_vma->lock, &mm->mmap_sem);
 		/*
 		 * We can safely modify head.next after taking the
 		 * anon_vma->lock. If some other vma in this mm shares
@@ -2470,7 +2470,7 @@ static void vm_lock_mapping(struct mm_struct *mm, struct address_space *mapping)
 		 */
 		if (test_and_set_bit(AS_MM_ALL_LOCKS, &mapping->flags))
 			BUG();
-		spin_lock_nest_lock(&mapping->i_mmap_lock, &mm->mmap_sem);
+		mutex_lock_nest_lock(&mapping->i_mmap_lock, &mm->mmap_sem);
 	}
 }
 
@@ -2558,7 +2558,7 @@ static void vm_unlock_anon_vma(struct anon_vma *anon_vma)
 		if (!__test_and_clear_bit(0, (unsigned long *)
 					  &anon_vma->head.next))
 			BUG();
-		spin_unlock(&anon_vma->lock);
+		mutex_unlock(&anon_vma->lock);
 	}
 }
 
@@ -2569,7 +2569,7 @@ static void vm_unlock_mapping(struct address_space *mapping)
 		 * AS_MM_ALL_LOCKS can't change to 0 from under us
 		 * because we hold the mm_all_locks_mutex.
 		 */
-		spin_unlock(&mapping->i_mmap_lock);
+		mutex_unlock(&mapping->i_mmap_lock);
 		if (!test_and_clear_bit(AS_MM_ALL_LOCKS,
 					&mapping->flags))
 			BUG();
diff --git a/mm/mremap.c b/mm/mremap.c
index e9c75ef..e47933a 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -91,7 +91,7 @@ static void move_ptes(struct vm_area_struct *vma, pmd_t *old_pmd,
 		 * and we propagate stale pages into the dst afterward.
 		 */
 		mapping = vma->vm_file->f_mapping;
-		spin_lock(&mapping->i_mmap_lock);
+		mutex_lock(&mapping->i_mmap_lock);
 		if (new_vma->vm_truncate_count &&
 		    new_vma->vm_truncate_count != vma->vm_truncate_count)
 			new_vma->vm_truncate_count = 0;
@@ -123,7 +123,7 @@ static void move_ptes(struct vm_area_struct *vma, pmd_t *old_pmd,
 	pte_unmap_nested(new_pte - 1);
 	pte_unmap_unlock(old_pte - 1, old_ptl);
 	if (mapping)
-		spin_unlock(&mapping->i_mmap_lock);
+		mutex_unlock(&mapping->i_mmap_lock);
 	mmu_notifier_invalidate_range_end(vma->vm_mm, old_start, old_end);
 }
 
diff --git a/mm/rmap.c b/mm/rmap.c
index fcd593c..00c646a 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -133,7 +133,7 @@ int anon_vma_prepare(struct vm_area_struct *vma)
 				goto out_enomem_free_avc;
 			allocated = anon_vma;
 		}
-		spin_lock(&anon_vma->lock);
+		mutex_lock(&anon_vma->lock);
 
 		/* page_table_lock to protect against threads */
 		spin_lock(&mm->page_table_lock);
@@ -147,7 +147,7 @@ int anon_vma_prepare(struct vm_area_struct *vma)
 		}
 		spin_unlock(&mm->page_table_lock);
 
-		spin_unlock(&anon_vma->lock);
+		mutex_unlock(&anon_vma->lock);
 		if (unlikely(allocated)) {
 			anon_vma_free(allocated);
 			anon_vma_chain_free(avc);
@@ -169,9 +169,9 @@ static void anon_vma_chain_link(struct vm_area_struct *vma,
 	avc->anon_vma = anon_vma;
 	list_add(&avc->same_vma, &vma->anon_vma_chain);
 
-	spin_lock(&anon_vma->lock);
+	mutex_lock(&anon_vma->lock);
 	list_add_tail(&avc->same_anon_vma, &anon_vma->head);
-	spin_unlock(&anon_vma->lock);
+	mutex_unlock(&anon_vma->lock);
 }
 
 /*
@@ -244,12 +244,12 @@ static void anon_vma_unlink(struct anon_vma_chain *anon_vma_chain)
 	if (!anon_vma)
 		return;
 
-	spin_lock(&anon_vma->lock);
+	mutex_lock(&anon_vma->lock);
 	list_del(&anon_vma_chain->same_anon_vma);
 
 	/* We must garbage collect the anon_vma if it's empty */
 	empty = list_empty(&anon_vma->head) && !ksm_refcount(anon_vma);
-	spin_unlock(&anon_vma->lock);
+	mutex_unlock(&anon_vma->lock);
 
 	if (empty)
 		anon_vma_free(anon_vma);
@@ -271,7 +271,7 @@ static void anon_vma_ctor(void *data)
 {
 	struct anon_vma *anon_vma = data;
 
-	spin_lock_init(&anon_vma->lock);
+	mutex_init(&anon_vma->lock);
 	ksm_refcount_init(anon_vma);
 	INIT_LIST_HEAD(&anon_vma->head);
 }
@@ -300,7 +300,7 @@ struct anon_vma *page_lock_anon_vma(struct page *page)
 		goto out;
 
 	anon_vma = (struct anon_vma *) (anon_mapping - PAGE_MAPPING_ANON);
-	spin_lock(&anon_vma->lock);
+	mutex_lock(&anon_vma->lock);
 	return anon_vma;
 out:
 	rcu_read_unlock();
@@ -309,7 +309,7 @@ out:
 
 void page_unlock_anon_vma(struct anon_vma *anon_vma)
 {
-	spin_unlock(&anon_vma->lock);
+	mutex_unlock(&anon_vma->lock);
 	rcu_read_unlock();
 }
 
@@ -554,7 +554,7 @@ static int page_referenced_file(struct page *page,
 	 */
 	BUG_ON(!PageLocked(page));
 
-	spin_lock(&mapping->i_mmap_lock);
+	mutex_lock(&mapping->i_mmap_lock);
 
 	/*
 	 * i_mmap_lock does not stabilize mapcount at all, but mapcount
@@ -579,7 +579,7 @@ static int page_referenced_file(struct page *page,
 			break;
 	}
 
-	spin_unlock(&mapping->i_mmap_lock);
+	mutex_unlock(&mapping->i_mmap_lock);
 	return referenced;
 }
 
@@ -666,7 +666,7 @@ static int page_mkclean_file(struct address_space *mapping, struct page *page)
 
 	BUG_ON(PageAnon(page));
 
-	spin_lock(&mapping->i_mmap_lock);
+	mutex_lock(&mapping->i_mmap_lock);
 	vma_prio_tree_foreach(vma, &iter, &mapping->i_mmap, pgoff, pgoff) {
 		if (vma->vm_flags & VM_SHARED) {
 			unsigned long address = vma_address(page, vma);
@@ -675,7 +675,7 @@ static int page_mkclean_file(struct address_space *mapping, struct page *page)
 			ret += page_mkclean_one(page, vma, address);
 		}
 	}
-	spin_unlock(&mapping->i_mmap_lock);
+	mutex_unlock(&mapping->i_mmap_lock);
 	return ret;
 }
 
@@ -1181,7 +1181,7 @@ static int try_to_unmap_file(struct page *page, enum ttu_flags flags)
 	unsigned long max_nl_size = 0;
 	unsigned int mapcount;
 
-	spin_lock(&mapping->i_mmap_lock);
+	mutex_lock(&mapping->i_mmap_lock);
 	vma_prio_tree_foreach(vma, &iter, &mapping->i_mmap, pgoff, pgoff) {
 		unsigned long address = vma_address(page, vma);
 		if (address == -EFAULT)
@@ -1227,7 +1227,6 @@ static int try_to_unmap_file(struct page *page, enum ttu_flags flags)
 	mapcount = page_mapcount(page);
 	if (!mapcount)
 		goto out;
-	cond_resched_lock(&mapping->i_mmap_lock);
 
 	max_nl_size = (max_nl_size + CLUSTER_SIZE - 1) & CLUSTER_MASK;
 	if (max_nl_cursor == 0)
@@ -1249,7 +1248,6 @@ static int try_to_unmap_file(struct page *page, enum ttu_flags flags)
 			}
 			vma->vm_private_data = (void *) max_nl_cursor;
 		}
-		cond_resched_lock(&mapping->i_mmap_lock);
 		max_nl_cursor += CLUSTER_SIZE;
 	} while (max_nl_cursor <= max_nl_size);
 
@@ -1261,7 +1259,7 @@ static int try_to_unmap_file(struct page *page, enum ttu_flags flags)
 	list_for_each_entry(vma, &mapping->i_mmap_nonlinear, shared.vm_set.list)
 		vma->vm_private_data = NULL;
 out:
-	spin_unlock(&mapping->i_mmap_lock);
+	mutex_unlock(&mapping->i_mmap_lock);
 	return ret;
 }
 
@@ -1346,7 +1344,7 @@ static int rmap_walk_anon(struct page *page, int (*rmap_one)(struct page *,
 	anon_vma = page_anon_vma(page);
 	if (!anon_vma)
 		return ret;
-	spin_lock(&anon_vma->lock);
+	mutex_lock(&anon_vma->lock);
 	list_for_each_entry(avc, &anon_vma->head, same_anon_vma) {
 		struct vm_area_struct *vma = avc->vma;
 		unsigned long address = vma_address(page, vma);
@@ -1356,7 +1354,7 @@ static int rmap_walk_anon(struct page *page, int (*rmap_one)(struct page *,
 		if (ret != SWAP_AGAIN)
 			break;
 	}
-	spin_unlock(&anon_vma->lock);
+	mutex_unlock(&anon_vma->lock);
 	return ret;
 }
 
@@ -1371,7 +1369,7 @@ static int rmap_walk_file(struct page *page, int (*rmap_one)(struct page *,
 
 	if (!mapping)
 		return ret;
-	spin_lock(&mapping->i_mmap_lock);
+	mutex_lock(&mapping->i_mmap_lock);
 	vma_prio_tree_foreach(vma, &iter, &mapping->i_mmap, pgoff, pgoff) {
 		unsigned long address = vma_address(page, vma);
 		if (address == -EFAULT)
@@ -1385,7 +1383,7 @@ static int rmap_walk_file(struct page *page, int (*rmap_one)(struct page *,
 	 * never contain migration ptes.  Decide what to do about this
 	 * limitation to linear when we need rmap_walk() on nonlinear.
 	 */
-	spin_unlock(&mapping->i_mmap_lock);
+	mutex_unlock(&mapping->i_mmap_lock);
 	return ret;
 }
 


