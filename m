Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756691Ab0FGLYx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 07:24:53 -0400
Received: from [18.85.46.34] ([18.85.46.34]:37698 "EHLO bombadil.infradead.org"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755689Ab0FGLUO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 07:20:14 -0400
Message-Id: <20100607111406.942477856@chello.nl>
User-Agent: quilt/0.48-1
Date: Mon, 07 Jun 2010 13:07:00 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andrea Arcangeli <aarcange@redhat.com>, Avi Kivity <avi@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, Rik van Riel <riel@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       David Miller <davem@davemloft.net>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, Mel Gorman <mel@csn.ul.ie>,
       Nick Piggin <npiggin@suse.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH 06/28] always lock the root (oldest) anon_vma
References: <20100607110654.606530953@chello.nl>
Content-Disposition: inline; filename=riel-04-mm-always_lock_the_root__oldest__anon_vma.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rik van Riel <riel@redhat.com>

Always (and only) lock the root (oldest) anon_vma whenever we do something in an
anon_vma.  The recently introduced anon_vma scalability is due to the rmap code
scanning only the VMAs that need to be scanned.  Many common operations still
took the anon_vma lock on the root anon_vma, so always taking that lock is not
expected to introduce any scalability issues.

However, always taking the same lock does mean we only need to take one lock,
which means rmap_walk on pages from any anon_vma in the vma is excluded from
occurring during an munmap, expand_stack or other operation that needs to
exclude rmap_walk and similar functions.

Also add the proper locking to vma_adjust.

Signed-off-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <20100526154044.2769e707@annuminas.surriel.com>
---
v3:
 - fix locking inversion in vma_adjust, spotted by Andrea
 - mm_take_all locks needs to use the bitflag in the root anon_vma,
   since that is the one that gets locked (Andrea Arcangeli)
v2:
 - conditionally take the anon_vma lock in vma_adjust, like introduced
   in 252c5f94d944487e9f50ece7942b0fbf659c5c31  (with a proper comment)

 include/linux/rmap.h |    8 ++++----
 mm/ksm.c             |    2 +-
 mm/migrate.c         |    2 +-
 mm/mmap.c            |   30 ++++++++++++++++++++++--------
 4 files changed, 28 insertions(+), 14 deletions(-)

Index: linux-2.6/include/linux/rmap.h
===================================================================
--- linux-2.6.orig/include/linux/rmap.h
+++ linux-2.6/include/linux/rmap.h
@@ -104,24 +104,24 @@ static inline void vma_lock_anon_vma(str
 {
 	struct anon_vma *anon_vma = vma->anon_vma;
 	if (anon_vma)
-		spin_lock(&anon_vma->lock);
+		spin_lock(&anon_vma->root->lock);
 }
 
 static inline void vma_unlock_anon_vma(struct vm_area_struct *vma)
 {
 	struct anon_vma *anon_vma = vma->anon_vma;
 	if (anon_vma)
-		spin_unlock(&anon_vma->lock);
+		spin_unlock(&anon_vma->root->lock);
 }
 
 static inline void anon_vma_lock(struct anon_vma *anon_vma)
 {
-	spin_lock(&anon_vma->lock);
+	spin_lock(&anon_vma->root->lock);
 }
 
 static inline void anon_vma_unlock(struct anon_vma *anon_vma)
 {
-	spin_unlock(&anon_vma->lock);
+	spin_unlock(&anon_vma->root->lock);
 }
 
 /*
Index: linux-2.6/mm/ksm.c
===================================================================
--- linux-2.6.orig/mm/ksm.c
+++ linux-2.6/mm/ksm.c
@@ -325,7 +325,7 @@ static void drop_anon_vma(struct rmap_it
 {
 	struct anon_vma *anon_vma = rmap_item->anon_vma;
 
-	if (atomic_dec_and_lock(&anon_vma->external_refcount, &anon_vma->lock)) {
+	if (atomic_dec_and_lock(&anon_vma->external_refcount, &anon_vma->root->lock)) {
 		int empty = list_empty(&anon_vma->head);
 		anon_vma_unlock(anon_vma);
 		if (empty)
Index: linux-2.6/mm/mmap.c
===================================================================
--- linux-2.6.orig/mm/mmap.c
+++ linux-2.6/mm/mmap.c
@@ -506,6 +506,7 @@ int vma_adjust(struct vm_area_struct *vm
 	struct vm_area_struct *importer = NULL;
 	struct address_space *mapping = NULL;
 	struct prio_tree_root *root = NULL;
+	struct anon_vma *anon_vma = NULL;
 	struct file *file = vma->vm_file;
 	long adjust_next = 0;
 	int remove_next = 0;
@@ -578,6 +579,17 @@ again:			remove_next = 1 + (end > next->
 		}
 	}
 
+	/*
+	 * When changing only vma->vm_end, we don't really need anon_vma
+	 * lock. This is a fairly rare case by itself, but the anon_vma
+	 * lock may be shared between many sibling processes.  Skipping
+	 * the lock for brk adjustments makes a difference sometimes.
+	 */
+	if (vma->anon_vma && (insert || importer || start != vma->vm_start)) {
+		anon_vma = vma->anon_vma;
+		anon_vma_lock(anon_vma);
+	}
+
 	if (root) {
 		flush_dcache_mmap_lock(mapping);
 		vma_prio_tree_remove(vma, root);
@@ -617,6 +629,8 @@ again:			remove_next = 1 + (end > next->
 		__insert_vm_struct(mm, insert);
 	}
 
+	if (anon_vma)
+		anon_vma_unlock(anon_vma);
 	if (mapping)
 		spin_unlock(&mapping->i_mmap_lock);
 
@@ -2466,23 +2480,23 @@ static DEFINE_MUTEX(mm_all_locks_mutex);
 
 static void vm_lock_anon_vma(struct mm_struct *mm, struct anon_vma *anon_vma)
 {
-	if (!test_bit(0, (unsigned long *) &anon_vma->head.next)) {
+	if (!test_bit(0, (unsigned long *) &anon_vma->root->head.next)) {
 		/*
 		 * The LSB of head.next can't change from under us
 		 * because we hold the mm_all_locks_mutex.
 		 */
-		spin_lock_nest_lock(&anon_vma->lock, &mm->mmap_sem);
+		spin_lock_nest_lock(&anon_vma->root->lock, &mm->mmap_sem);
 		/*
 		 * We can safely modify head.next after taking the
-		 * anon_vma->lock. If some other vma in this mm shares
+		 * anon_vma->root->lock. If some other vma in this mm shares
 		 * the same anon_vma we won't take it again.
 		 *
 		 * No need of atomic instructions here, head.next
 		 * can't change from under us thanks to the
-		 * anon_vma->lock.
+		 * anon_vma->root->lock.
 		 */
 		if (__test_and_set_bit(0, (unsigned long *)
-				       &anon_vma->head.next))
+				       &anon_vma->root->head.next))
 			BUG();
 	}
 }
@@ -2573,7 +2587,7 @@ out_unlock:
 
 static void vm_unlock_anon_vma(struct anon_vma *anon_vma)
 {
-	if (test_bit(0, (unsigned long *) &anon_vma->head.next)) {
+	if (test_bit(0, (unsigned long *) &anon_vma->root->head.next)) {
 		/*
 		 * The LSB of head.next can't change to 0 from under
 		 * us because we hold the mm_all_locks_mutex.
@@ -2584,10 +2598,10 @@ static void vm_unlock_anon_vma(struct an
 		 *
 		 * No need of atomic instructions here, head.next
 		 * can't change from under us until we release the
-		 * anon_vma->lock.
+		 * anon_vma->root->lock.
 		 */
 		if (!__test_and_clear_bit(0, (unsigned long *)
-					  &anon_vma->head.next))
+					  &anon_vma->root->head.next))
 			BUG();
 		anon_vma_unlock(anon_vma);
 	}
Index: linux-2.6/mm/migrate.c
===================================================================
--- linux-2.6.orig/mm/migrate.c
+++ linux-2.6/mm/migrate.c
@@ -682,7 +682,7 @@ skip_unmap:
 rcu_unlock:
 
 	/* Drop an anon_vma reference if we took one */
-	if (anon_vma && atomic_dec_and_lock(&anon_vma->external_refcount, &anon_vma->lock)) {
+	if (anon_vma && atomic_dec_and_lock(&anon_vma->external_refcount, &anon_vma->root->lock)) {
 		int empty = list_empty(&anon_vma->head);
 		anon_vma_unlock(anon_vma);
 		if (empty)


