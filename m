Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757031Ab1BQRKt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 12:10:49 -0500
Received: from casper.infradead.org ([85.118.1.10]:35981 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756672Ab1BQRKq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 12:10:46 -0500
Message-Id: <20110217162124.388877866@chello.nl>
User-Agent: quilt/0.48-1
Date: Thu, 17 Feb 2011 17:19:50 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andrea Arcangeli <aarcange@redhat.com>, Avi Kivity <avi@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Rik van Riel <riel@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        David Miller <davem@davemloft.net>,
        Hugh Dickins <hugh.dickins@tiscali.co.uk>, Mel Gorman <mel@csn.ul.ie>,
        Nick Piggin <npiggin@kernel.dk>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Yanmin Zhang <yanmin_zhang@linux.intel.com>,
        Hugh Dickins <hughd@google.com>
Subject: [PATCH 2/3] mm: Move anon_vma ref out from under CONFIG_foo
References: <20110217161948.045410404@chello.nl>
Content-Disposition: inline; filename=peter_zijlstra-mm-move_anon_vma_ref_out_from_under_config_ksm.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need the anon_vma refcount unconditionally to simplify the anon_vma
lifetime rules.

Acked-by: Mel Gorman <mel@csn.ul.ie>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/rmap.h |   40 ++++------------------------------------
 mm/rmap.c            |   14 ++++++--------
 2 files changed, 10 insertions(+), 44 deletions(-)

Index: linux-2.6/include/linux/rmap.h
===================================================================
--- linux-2.6.orig/include/linux/rmap.h
+++ linux-2.6/include/linux/rmap.h
@@ -27,18 +27,15 @@
 struct anon_vma {
 	struct anon_vma *root;	/* Root of this anon_vma tree */
 	spinlock_t lock;	/* Serialize access to vma list */
-#if defined(CONFIG_KSM) || defined(CONFIG_MIGRATION)
-
 	/*
-	 * The external_refcount is taken by either KSM or page migration
-	 * to take a reference to an anon_vma when there is no
+	 * The refcount is taken on an anon_vma when there is no
 	 * guarantee that the vma of page tables will exist for
 	 * the duration of the operation. A caller that takes
 	 * the reference is responsible for clearing up the
 	 * anon_vma if they are the last user on release
 	 */
-	atomic_t external_refcount;
-#endif
+	atomic_t refcount;
+
 	/*
 	 * NOTE: the LSB of the head.next is set by
 	 * mm_take_all_locks() _after_ taking the above lock. So the
@@ -71,41 +68,12 @@ struct anon_vma_chain {
 };
 
 #ifdef CONFIG_MMU
-#if defined(CONFIG_KSM) || defined(CONFIG_MIGRATION)
-static inline void anonvma_external_refcount_init(struct anon_vma *anon_vma)
-{
-	atomic_set(&anon_vma->external_refcount, 0);
-}
-
-static inline int anonvma_external_refcount(struct anon_vma *anon_vma)
-{
-	return atomic_read(&anon_vma->external_refcount);
-}
-
 static inline void get_anon_vma(struct anon_vma *anon_vma)
 {
-	atomic_inc(&anon_vma->external_refcount);
+	atomic_inc(&anon_vma->refcount);
 }
 
 void put_anon_vma(struct anon_vma *);
-#else
-static inline void anonvma_external_refcount_init(struct anon_vma *anon_vma)
-{
-}
-
-static inline int anonvma_external_refcount(struct anon_vma *anon_vma)
-{
-	return 0;
-}
-
-static inline void get_anon_vma(struct anon_vma *anon_vma)
-{
-}
-
-static inline void put_anon_vma(struct anon_vma *anon_vma)
-{
-}
-#endif /* CONFIG_KSM */
 
 static inline struct anon_vma *page_anon_vma(struct page *page)
 {
Index: linux-2.6/mm/rmap.c
===================================================================
--- linux-2.6.orig/mm/rmap.c
+++ linux-2.6/mm/rmap.c
@@ -272,7 +272,7 @@ static void anon_vma_unlink(struct anon_
 	list_del(&anon_vma_chain->same_anon_vma);
 
 	/* We must garbage collect the anon_vma if it's empty */
-	empty = list_empty(&anon_vma->head) && !anonvma_external_refcount(anon_vma);
+	empty = list_empty(&anon_vma->head) && !atomic_read(&anon_vma->refcount);
 	anon_vma_unlock(anon_vma);
 
 	if (empty) {
@@ -303,7 +303,7 @@ static void anon_vma_ctor(void *data)
 	struct anon_vma *anon_vma = data;
 
 	spin_lock_init(&anon_vma->lock);
-	anonvma_external_refcount_init(anon_vma);
+	atomic_set(&anon_vma->refcount, 0);
 	INIT_LIST_HEAD(&anon_vma->head);
 }
 
@@ -1482,7 +1482,6 @@ int try_to_munlock(struct page *page)
 		return try_to_unmap_file(page, TTU_MUNLOCK);
 }
 
-#if defined(CONFIG_KSM) || defined(CONFIG_MIGRATION)
 /*
  * Drop an anon_vma refcount, freeing the anon_vma and anon_vma->root
  * if necessary.  Be careful to do all the tests under the lock.  Once
@@ -1491,8 +1490,8 @@ int try_to_munlock(struct page *page)
  */
 void put_anon_vma(struct anon_vma *anon_vma)
 {
-	BUG_ON(atomic_read(&anon_vma->external_refcount) <= 0);
-	if (atomic_dec_and_lock(&anon_vma->external_refcount, &anon_vma->root->lock)) {
+	BUG_ON(atomic_read(&anon_vma->refcount) <= 0);
+	if (atomic_dec_and_lock(&anon_vma->refcount, &anon_vma->root->lock)) {
 		struct anon_vma *root = anon_vma->root;
 		int empty = list_empty(&anon_vma->head);
 		int last_root_user = 0;
@@ -1503,8 +1502,8 @@ void put_anon_vma(struct anon_vma *anon_
 		 * the refcount on the root and check if we need to free it.
 		 */
 		if (empty && anon_vma != root) {
-			BUG_ON(atomic_read(&root->external_refcount) <= 0);
-			last_root_user = atomic_dec_and_test(&root->external_refcount);
+			BUG_ON(atomic_read(&root->refcount) <= 0);
+			last_root_user = atomic_dec_and_test(&root->refcount);
 			root_empty = list_empty(&root->head);
 		}
 		anon_vma_unlock(anon_vma);
@@ -1516,7 +1515,6 @@ void put_anon_vma(struct anon_vma *anon_
 		}
 	}
 }
-#endif
 
 #ifdef CONFIG_MIGRATION
 /*


