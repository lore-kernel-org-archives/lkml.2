Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757873Ab0DBO1e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 10:27:34 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:49472 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755549Ab0DBO1J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 10:27:09 -0400
Message-Id: <20100402142446.304459165@chello.nl>
User-Agent: quilt/0.47-1
Date: Fri, 02 Apr 2010 16:16:03 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andrea Arcangeli <aarcange@redhat.com>, Avi Kivity <avi@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, Rik van Riel <riel@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, Mel Gorman <mel@csn.ul.ie>,
       Nick Piggin <npiggin@suse.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 2/7] mm: Make use of the anon_vma ref count
References: <20100402141601.435955404@chello.nl>
Content-Disposition: inline; filename=mm-use-anon_vma-ref.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch changes the anon_vma refcount to be 0 when the object is
free. It does this by adding 1 ref to being in use in the anon_vma
structure (iow. the anon_vma->head list is not empty).

This allows a simpler release scheme without having to check both the
refcount and the list as well as avoids taking a ref for each entry
on the list.

We then use this new refcount in the migration code to avoid a long
RCU read side section and convert page_lock_anon_vma() over to use
refcounts.

This later is done for each of convertion of anon_vma from spinlock
to mutex.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/rmap.h |    7 +++++++
 mm/ksm.c             |    9 +--------
 mm/migrate.c         |   17 ++++++-----------
 mm/rmap.c            |   43 +++++++++++++++++++++++++++++--------------
 4 files changed, 43 insertions(+), 33 deletions(-)

Index: linux-2.6/include/linux/rmap.h
===================================================================
--- linux-2.6.orig/include/linux/rmap.h
+++ linux-2.6/include/linux/rmap.h
@@ -100,6 +100,13 @@ static inline void anon_vma_merge(struct
 	unlink_anon_vmas(next);
 }
 
+struct anon_vma *anon_vma_get(struct page *page);
+static inline void anon_vma_put(struct anon_vma *anon_vma)
+{
+	if (atomic_dec_and_test(&anon_vma->ref))
+		anon_vma_free(anon_vma);
+}
+
 /*
  * rmap interfaces called when adding or removing pte of page
  */
Index: linux-2.6/mm/ksm.c
===================================================================
--- linux-2.6.orig/mm/ksm.c
+++ linux-2.6/mm/ksm.c
@@ -323,14 +323,7 @@ static void hold_anon_vma(struct rmap_it
 
 static void drop_anon_vma(struct rmap_item *rmap_item)
 {
-	struct anon_vma *anon_vma = rmap_item->anon_vma;
-
-	if (atomic_dec_and_lock(&anon_vma->ref, &anon_vma->lock)) {
-		int empty = list_empty(&anon_vma->head);
-		spin_unlock(&anon_vma->lock);
-		if (empty)
-			anon_vma_free(anon_vma);
-	}
+	anon_vma_put(rmap_item->anon_vma);
 }
 
 /*
Index: linux-2.6/mm/migrate.c
===================================================================
--- linux-2.6.orig/mm/migrate.c
+++ linux-2.6/mm/migrate.c
@@ -544,7 +544,7 @@ static int unmap_and_move(new_page_t get
 	int rc = 0;
 	int *result = NULL;
 	struct page *newpage = get_new_page(page, private, &result);
-	int rcu_locked = 0;
+	struct anon_vma *anon_vma = NULL;
 	int charge = 0;
 	struct mem_cgroup *mem = NULL;
 
@@ -600,10 +600,8 @@ static int unmap_and_move(new_page_t get
 	 * File Caches may use write_page() or lock_page() in migration, then,
 	 * just care Anon page here.
 	 */
-	if (PageAnon(page)) {
-		rcu_read_lock();
-		rcu_locked = 1;
-	}
+	if (PageAnon(page))
+		anon_vma = anon_vma_get(page);
 
 	/*
 	 * Corner case handling:
@@ -621,10 +619,7 @@ static int unmap_and_move(new_page_t get
 		if (!PageAnon(page) && page_has_private(page)) {
 			/*
 			 * Go direct to try_to_free_buffers() here because
-			 * a) that's what try_to_release_page() would do anyway
-			 * b) we may be under rcu_read_lock() here, so we can't
-			 *    use GFP_KERNEL which is what try_to_release_page()
-			 *    needs to be effective.
+			 * that's what try_to_release_page() would do anyway
 			 */
 			try_to_free_buffers(page);
 			goto rcu_unlock;
@@ -642,8 +637,8 @@ skip_unmap:
 	if (rc)
 		remove_migration_ptes(page, page);
 rcu_unlock:
-	if (rcu_locked)
-		rcu_read_unlock();
+	if (anon_vma)
+		anon_vma_put(anon_vma);
 uncharge:
 	if (!charge)
 		mem_cgroup_end_migration(mem, page, newpage);
Index: linux-2.6/mm/rmap.c
===================================================================
--- linux-2.6.orig/mm/rmap.c
+++ linux-2.6/mm/rmap.c
@@ -66,11 +66,18 @@ static struct kmem_cache *anon_vma_chain
 
 static inline struct anon_vma *anon_vma_alloc(void)
 {
-	return kmem_cache_alloc(anon_vma_cachep, GFP_KERNEL);
+	struct anon_vma *anon_vma;
+
+	anon_vma = kmem_cache_alloc(anon_vma_cachep, GFP_KERNEL);
+	if (anon_vma)
+		atomic_set(&anon_vma->ref, 1);
+
+	return anon_vma;
 }
 
 void anon_vma_free(struct anon_vma *anon_vma)
 {
+	VM_BUG_ON(atomic_read(&anon_vma->ref));
 	kmem_cache_free(anon_vma_cachep, anon_vma);
 }
 
@@ -149,7 +156,7 @@ int anon_vma_prepare(struct vm_area_stru
 
 		spin_unlock(&anon_vma->lock);
 		if (unlikely(allocated)) {
-			anon_vma_free(allocated);
+			anon_vma_put(allocated);
 			anon_vma_chain_free(avc);
 		}
 	}
@@ -230,7 +237,7 @@ int anon_vma_fork(struct vm_area_struct 
 	return 0;
 
  out_error_free_anon_vma:
-	anon_vma_free(anon_vma);
+	anon_vma_put(anon_vma);
  out_error:
 	return -ENOMEM;
 }
@@ -246,13 +253,11 @@ static void anon_vma_unlink(struct anon_
 
 	spin_lock(&anon_vma->lock);
 	list_del(&anon_vma_chain->same_anon_vma);
-
-	/* We must garbage collect the anon_vma if it's empty */
-	empty = list_empty(&anon_vma->head) && !atomic_read(&anon_vma->ref);
+	empty = list_empty(&anon_vma->head);
 	spin_unlock(&anon_vma->lock);
 
 	if (empty)
-		anon_vma_free(anon_vma);
+		anon_vma_put(anon_vma);
 }
 
 void unlink_anon_vmas(struct vm_area_struct *vma)
@@ -285,11 +290,11 @@ void __init anon_vma_init(void)
 
 /*
  * Getting a lock on a stable anon_vma from a page off the LRU is
- * tricky: page_lock_anon_vma rely on RCU to guard against the races.
+ * tricky: page_lock_anon_vma relies on RCU to guard against the races.
  */
-struct anon_vma *page_lock_anon_vma(struct page *page)
+struct anon_vma *anon_vma_get(struct page *page)
 {
-	struct anon_vma *anon_vma;
+	struct anon_vma *anon_vma = NULL;
 	unsigned long anon_mapping;
 
 	rcu_read_lock();
@@ -300,17 +305,27 @@ struct anon_vma *page_lock_anon_vma(stru
 		goto out;
 
 	anon_vma = (struct anon_vma *) (anon_mapping - PAGE_MAPPING_ANON);
-	spin_lock(&anon_vma->lock);
-	return anon_vma;
+	if (!atomic_inc_not_zero(&anon_vma->ref))
+		anon_vma = NULL;
 out:
 	rcu_read_unlock();
-	return NULL;
+	return anon_vma;
+}
+
+struct anon_vma *page_lock_anon_vma(struct page *page)
+{
+	struct anon_vma *anon_vma = anon_vma_get(page);
+
+	if (anon_vma)
+		spin_lock(&anon_vma->lock);
+
+	return anon_vma;
 }
 
 void page_unlock_anon_vma(struct anon_vma *anon_vma)
 {
 	spin_unlock(&anon_vma->lock);
-	rcu_read_unlock();
+	anon_vma_put(anon_vma);
 }
 
 /*


