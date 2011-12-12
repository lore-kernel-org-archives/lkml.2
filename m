Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752195Ab1LLJ2a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 04:28:30 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:45725 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750862Ab1LLJ22 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 04:28:28 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 12 Dec 2011 18:27:11 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: kosaki.motohiro@gmail.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrew Morton (commit_signer:15/23=65%) 
	<akpm@linux-foundation.org>,
        Hugh Dickins (commit_signer:7/23=30%) <hughd@google.com>,
        Peter Zijlstra (commit_signer:4/23=17%) 
	<a.p.zijlstra@chello.nl>,
        Shaohua Li (commit_signer:3/23=13%) <shaohua.li@intel.com>
Subject: Re: [PATCH v3] mm: simplify find_vma_prev
Message-Id: <20111212182711.3a072358.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20111212094930.9d4716e1.kamezawa.hiroyu@jp.fujitsu.com>
References: <1323466526.27746.29.camel@joe2Laptop>
	<1323470921-12931-1-git-send-email-kosaki.motohiro@gmail.com>
	<20111212094930.9d4716e1.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Dec 2011 09:49:30 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> On Fri,  9 Dec 2011 17:48:40 -0500
> kosaki.motohiro@gmail.com wrote:
> 
> > From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> > 
> > commit 297c5eee37 (mm: make the vma list be doubly linked) added
> > vm_prev member into vm_area_struct. Therefore we can simplify
> > find_vma_prev() by using it. Also, this change help to improve
> > page fault performance because it has strong locality of reference.
> > 
> > Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> 
> Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 

Hmm, your work remind me of a patch I tried in past.
Here is a refleshed one...how do you think ?

==
>From c0261936fc01322d06425731d33f38b2021e8067 Mon Sep 17 00:00:00 2001
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Date: Mon, 12 Dec 2011 18:31:19 +0900
Subject: [PATCH] per thread vma cache.

This is a toy patch. How do you think ?

This is a patch for per-thread mmap_cache without heavy atomic ops.

I'm sure overhead of find_vma() is pretty small in usual application
and this will not show good improvement. But I think, if we need
to have cache of vma, it should be per thread rather than per mm.

This patch adds thread->mmap_cache, a pointer for vm_area_struct
and update it appropriately. Because we have no refcnt on vm_area_struct,
thread->mmap_cache may be a stale pointer. This patch detects stale
pointer by checking

    - thread->mmap_cache is one of SLABs in vm_area_cachep.
    - thread->mmap_cache->vm_mm == mm.

vma->vm_mm will be cleared before kmem_cache_free() by this patch.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Note:
   Kosaki's work will merge find_vma_prev() and find_vma().
   Then, we'll cover most of case just by modifying find_vma().
---
 include/linux/mm_types.h |    2 +
 include/linux/sched.h    |    1 +
 include/linux/slab_def.h |   13 ++++++++++
 include/linux/slub_def.h |   12 +++++++++
 init/Kconfig             |    5 ++++
 kernel/fork.c            |    3 +-
 mm/mmap.c                |   61 +++++++++++++++++++++++++++++++++++++++-------
 mm/nommu.c               |    4 +-
 8 files changed, 89 insertions(+), 12 deletions(-)

diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 81a56df..8a9be1a 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -255,6 +255,8 @@ struct vm_area_struct {
 #endif
 };
 
+extern void free_vma(struct vm_area_struct *vma);
+
 struct core_thread {
 	struct task_struct *task;
 	struct core_thread *next;
diff --git a/include/linux/sched.h b/include/linux/sched.h
index cbb5d3e..a161c2b 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1294,6 +1294,7 @@ struct task_struct {
 #endif
 
 	struct mm_struct *mm, *active_mm;
+	struct vm_area_struct *mmap_cache;
 #ifdef CONFIG_COMPAT_BRK
 	unsigned brk_randomized:1;
 #endif
diff --git a/include/linux/slab_def.h b/include/linux/slab_def.h
index d00e0ba..763c1d9 100644
--- a/include/linux/slab_def.h
+++ b/include/linux/slab_def.h
@@ -214,4 +214,17 @@ found:
 
 #endif	/* CONFIG_NUMA */
 
+/*
+ * Check the object is under specified kmem_cache.
+ */
+static inline bool is_kmem_cache(void *data, struct kmem_cache *s)
+{
+	struct page *page;
+
+	page = virt_to_head_page(data);
+	if (PageSlab(page) && page->lru.prev == s)
+		return true;
+	return false;
+}
+
 #endif	/* _LINUX_SLAB_DEF_H */
diff --git a/include/linux/slub_def.h b/include/linux/slub_def.h
index a32bcfd..9eba7e7 100644
--- a/include/linux/slub_def.h
+++ b/include/linux/slub_def.h
@@ -10,6 +10,7 @@
 #include <linux/gfp.h>
 #include <linux/workqueue.h>
 #include <linux/kobject.h>
+#include <linux/mm.h>
 
 #include <linux/kmemleak.h>
 
@@ -313,4 +314,15 @@ static __always_inline void *kmalloc_node(size_t size, gfp_t flags, int node)
 }
 #endif
 
+/*
+ * Check the object is under specified kmem cache.
+ */
+static inline bool is_kmem_cache(void *data, struct kmem_cache *s)
+{
+	struct page *page = virt_to_head_page(data);
+
+	if (PageSlab(page) && page->slab == s)
+		return true;
+	return false;
+}
 #endif /* _LINUX_SLUB_DEF_H */
diff --git a/init/Kconfig b/init/Kconfig
index 6dfc8c3..7fcfffd 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1266,6 +1266,11 @@ config SLOB
 
 endchoice
 
+config PER_THREAD_MMAP_CACHE
+	bool
+	default y
+	depends on SLAB || SLUB
+
 config MMAP_ALLOW_UNINITIALIZED
 	bool "Allow mmapped anonymous memory to be uninitialized"
 	depends on EXPERT && !MMU
diff --git a/kernel/fork.c b/kernel/fork.c
index e20518d..18d73c2 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -432,7 +432,7 @@ out:
 fail_nomem_anon_vma_fork:
 	mpol_put(pol);
 fail_nomem_policy:
-	kmem_cache_free(vm_area_cachep, tmp);
+	free_vma(tmp);
 fail_nomem:
 	retval = -ENOMEM;
 	vm_unacct_memory(charge);
@@ -825,6 +825,7 @@ good_mm:
 
 	tsk->mm = mm;
 	tsk->active_mm = mm;
+	tsk->mmap_cache = NULL;
 	return 0;
 
 fail_nomem:
diff --git a/mm/mmap.c b/mm/mmap.c
index 83813fa..7b86e05 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -238,7 +238,7 @@ static struct vm_area_struct *remove_vma(struct vm_area_struct *vma)
 			removed_exe_file_vma(vma->vm_mm);
 	}
 	mpol_put(vma_policy(vma));
-	kmem_cache_free(vm_area_cachep, vma);
+	free_vma(vma);
 	return next;
 }
 
@@ -478,8 +478,11 @@ __vma_unlink(struct mm_struct *mm, struct vm_area_struct *vma,
 	if (next)
 		next->vm_prev = prev;
 	rb_erase(&vma->vm_rb, &mm->mm_rb);
-	if (mm->mmap_cache == vma)
+	if (mm->mmap_cache == vma) {
 		mm->mmap_cache = prev;
+		if (current->mm == mm)
+			current->mmap_cache = prev;
+	}
 }
 
 /*
@@ -642,7 +645,7 @@ again:			remove_next = 1 + (end > next->vm_end);
 			anon_vma_merge(vma, next);
 		mm->map_count--;
 		mpol_put(vma_policy(next));
-		kmem_cache_free(vm_area_cachep, next);
+		free_vma(next);
 		/*
 		 * In mprotect's case 6 (see comments on vma_merge),
 		 * we must remove another next too. It would clutter
@@ -1364,7 +1367,7 @@ unmap_and_free_vma:
 	unmap_region(mm, vma, prev, vma->vm_start, vma->vm_end);
 	charged = 0;
 free_vma:
-	kmem_cache_free(vm_area_cachep, vma);
+	free_vma(vma);
 unacct_error:
 	if (charged)
 		vm_unacct_memory(charged);
@@ -1588,10 +1591,42 @@ get_unmapped_area(struct file *file, unsigned long addr, unsigned long len,
 
 EXPORT_SYMBOL(get_unmapped_area);
 
+#ifdef CONFIG_PER_THREAD_MMAP_CACHE
+static struct vm_area_struct *thread_mmap_cache(struct mm_struct *mm)
+{
+	struct vm_area_struct *vma = current->mmap_cache;
+
+	if (!vma || current->mm != mm)
+		return NULL;
+
+	if ((vma->vm_mm != mm) || !is_kmem_cache(vma, vm_area_cachep))
+		return NULL;
+
+	return vma;
+}
+
+static void set_thread_mmap_cache(struct mm_struct *mm,
+		struct vm_area_struct *vma)
+{
+	if (current->mm == mm)
+		current->mmap_cache = vma;
+}
+#else
+static struct vm_area_struct *thread_mmap_cache(struct mm_struct *mm)
+{
+	return NULL;
+}
+
+static void set_thread_mmap_cache(struct mm_struct *mm,
+		struct vm_area_struct *vma)
+{
+}
+#endif
+
 /* Look up the first VMA which satisfies  addr < vm_end,  NULL if none. */
 struct vm_area_struct *find_vma(struct mm_struct *mm, unsigned long addr)
 {
-	struct vm_area_struct *vma = NULL;
+	struct vm_area_struct *vma = thread_mmap_cache(mm);
 
 	if (mm) {
 		/* Check the cache first. */
@@ -1617,8 +1652,10 @@ struct vm_area_struct *find_vma(struct mm_struct *mm, unsigned long addr)
 				} else
 					rb_node = rb_node->rb_right;
 			}
-			if (vma)
+			if (vma) {
 				mm->mmap_cache = vma;
+				set_thread_mmap_cache(mm, vma);
+			}
 		}
 	}
 	return vma;
@@ -2017,7 +2054,7 @@ static int __split_vma(struct mm_struct * mm, struct vm_area_struct * vma,
  out_free_mpol:
 	mpol_put(pol);
  out_free_vma:
-	kmem_cache_free(vm_area_cachep, new);
+	free_vma(new);
  out_err:
 	return err;
 }
@@ -2400,7 +2437,7 @@ struct vm_area_struct *copy_vma(struct vm_area_struct **vmap,
  out_free_mempol:
 	mpol_put(pol);
  out_free_vma:
-	kmem_cache_free(vm_area_cachep, new_vma);
+	free_vma(new_vma);
 	return NULL;
 }
 
@@ -2506,7 +2543,7 @@ int install_special_mapping(struct mm_struct *mm,
 	return 0;
 
 out:
-	kmem_cache_free(vm_area_cachep, vma);
+	free_vma(vma);
 	return ret;
 }
 
@@ -2675,6 +2712,12 @@ void mm_drop_all_locks(struct mm_struct *mm)
 	mutex_unlock(&mm_all_locks_mutex);
 }
 
+void free_vma(struct vm_area_struct *vma)
+{
+	vma->vm_mm = NULL;
+	kmem_cache_free(vm_area_cachep, vma);
+}
+
 /*
  * initialise the VMA slab
  */
diff --git a/mm/nommu.c b/mm/nommu.c
index b982290..3c98fd5 100644
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -793,7 +793,7 @@ static void delete_vma(struct mm_struct *mm, struct vm_area_struct *vma)
 			removed_exe_file_vma(mm);
 	}
 	put_nommu_region(vma->vm_region);
-	kmem_cache_free(vm_area_cachep, vma);
+	free_vma(vma);
 }
 
 /*
@@ -1443,7 +1443,7 @@ error:
 		fput(vma->vm_file);
 	if (vma->vm_flags & VM_EXECUTABLE)
 		removed_exe_file_vma(vma->vm_mm);
-	kmem_cache_free(vm_area_cachep, vma);
+	free_vma(vma);
 	kleave(" = %d", ret);
 	return ret;
 
-- 
1.7.4.1


