Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932607Ab0FGLX4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 07:23:56 -0400
Received: from casper.infradead.org ([85.118.1.10]:41254 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752440Ab0FGLUS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 07:20:18 -0400
Message-Id: <20100607111407.216849162@chello.nl>
User-Agent: quilt/0.48-1
Date: Mon, 07 Jun 2010 13:07:03 +0200
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
Subject: [PATCH 09/28] mm: Move anon_vma ref out from under CONFIG_KSM
References: <20100607110654.606530953@chello.nl>
Content-Disposition: inline; filename=mm-anon_vma-ref.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need an anon_vma refcount for preemptible anon_vma->lock.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/rmap.h |   40 ++++------------------------------------
 mm/rmap.c            |   10 ++++------
 2 files changed, 8 insertions(+), 42 deletions(-)

Index: linux-2.6/include/linux/rmap.h
===================================================================
--- linux-2.6.orig/include/linux/rmap.h
+++ linux-2.6/include/linux/rmap.h
@@ -27,18 +27,15 @@
 struct anon_vma {
 	spinlock_t lock;	/* Serialize access to vma list */
 	struct anon_vma *root;	/* Root of this anon_vma tree */
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
@@ -267,7 +267,7 @@ static void anon_vma_unlink(struct anon_
 	list_del(&anon_vma_chain->same_anon_vma);
 
 	/* We must garbage collect the anon_vma if it's empty */
-	empty = list_empty(&anon_vma->head) && !anonvma_external_refcount(anon_vma);
+	empty = list_empty(&anon_vma->head) && !atomic_read(&anon_vma->refcount);
 	anon_vma_unlock(anon_vma);
 
 	if (empty) {
@@ -297,7 +297,7 @@ static void anon_vma_ctor(void *data)
 	struct anon_vma *anon_vma = data;
 
 	spin_lock_init(&anon_vma->lock);
-	anonvma_external_refcount_init(anon_vma);
+	atomic_set(&anon_vma->refcount, 0);
 	INIT_LIST_HEAD(&anon_vma->head);
 }
 
@@ -1391,7 +1391,6 @@ int try_to_munlock(struct page *page)
 		return try_to_unmap_file(page, TTU_MUNLOCK);
 }
 
-#if defined(CONFIG_KSM) || defined(CONFIG_MIGRATION)
 /*
  * Drop an anon_vma refcount, freeing the anon_vma and anon_vma->root
  * if necessary.  Be careful to do all the tests under the lock.  Once
@@ -1400,7 +1399,7 @@ int try_to_munlock(struct page *page)
  */
 void put_anon_vma(struct anon_vma *anon_vma)
 {
-	if (atomic_dec_and_lock(&anon_vma->external_refcount, &anon_vma->root->lock)) {
+	if (atomic_dec_and_lock(&anon_vma->refcount, &anon_vma->root->lock)) {
 		struct anon_vma *root = anon_vma->root;
 		int empty = list_empty(&anon_vma->head);
 		int last_root_user = 0;
@@ -1411,7 +1410,7 @@ void put_anon_vma(struct anon_vma *anon_
 		 * the refcount on the root and check if we need to free it.
 		 */
 		if (empty && anon_vma != root) {
-			last_root_user = atomic_dec_and_test(&root->external_refcount);
+			last_root_user = atomic_dec_and_test(&root->refcount);
 			root_empty = list_empty(&root->head);
 		}
 		anon_vma_unlock(anon_vma);
@@ -1423,7 +1422,6 @@ void put_anon_vma(struct anon_vma *anon_
 		}
 	}
 }
-#endif
 
 #ifdef CONFIG_MIGRATION
 /*


