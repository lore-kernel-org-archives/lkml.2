Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755154Ab0DBO16 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 10:27:58 -0400
Received: from casper.infradead.org ([85.118.1.10]:39610 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756958Ab0DBO1V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 10:27:21 -0400
Message-Id: <20100402142446.250170860@chello.nl>
User-Agent: quilt/0.47-1
Date: Fri, 02 Apr 2010 16:16:02 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andrea Arcangeli <aarcange@redhat.com>, Avi Kivity <avi@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, Rik van Riel <riel@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, Mel Gorman <mel@csn.ul.ie>,
       Nick Piggin <npiggin@suse.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 1/7] mm: Move anon_vma ref out from under CONFIG_KSM
References: <20100402141601.435955404@chello.nl>
Content-Disposition: inline; filename=mm-anon_vma-ref.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need an anon_vma refcount for preemptible anon_vma->lock as well
as memory compaction, so move it out into generic code.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
Index: linux-2.6/include/linux/rmap.h
===================================================================
--- linux-2.6.orig/include/linux/rmap.h
+++ linux-2.6/include/linux/rmap.h
@@ -26,9 +26,7 @@
  */
 struct anon_vma {
 	spinlock_t lock;	/* Serialize access to vma list */
-#ifdef CONFIG_KSM
-	atomic_t ksm_refcount;
-#endif
+	atomic_t ref;
 	/*
 	 * NOTE: the LSB of the head.next is set by
 	 * mm_take_all_locks() _after_ taking the above lock. So the
@@ -61,26 +59,6 @@ struct anon_vma_chain {
 };
 
 #ifdef CONFIG_MMU
-#ifdef CONFIG_KSM
-static inline void ksm_refcount_init(struct anon_vma *anon_vma)
-{
-	atomic_set(&anon_vma->ksm_refcount, 0);
-}
-
-static inline int ksm_refcount(struct anon_vma *anon_vma)
-{
-	return atomic_read(&anon_vma->ksm_refcount);
-}
-#else
-static inline void ksm_refcount_init(struct anon_vma *anon_vma)
-{
-}
-
-static inline int ksm_refcount(struct anon_vma *anon_vma)
-{
-	return 0;
-}
-#endif /* CONFIG_KSM */
 
 static inline struct anon_vma *page_anon_vma(struct page *page)
 {
Index: linux-2.6/mm/ksm.c
===================================================================
--- linux-2.6.orig/mm/ksm.c
+++ linux-2.6/mm/ksm.c
@@ -318,14 +318,14 @@ static void hold_anon_vma(struct rmap_it
 			  struct anon_vma *anon_vma)
 {
 	rmap_item->anon_vma = anon_vma;
-	atomic_inc(&anon_vma->ksm_refcount);
+	atomic_inc(&anon_vma->ref);
 }
 
 static void drop_anon_vma(struct rmap_item *rmap_item)
 {
 	struct anon_vma *anon_vma = rmap_item->anon_vma;
 
-	if (atomic_dec_and_lock(&anon_vma->ksm_refcount, &anon_vma->lock)) {
+	if (atomic_dec_and_lock(&anon_vma->ref, &anon_vma->lock)) {
 		int empty = list_empty(&anon_vma->head);
 		spin_unlock(&anon_vma->lock);
 		if (empty)
Index: linux-2.6/mm/rmap.c
===================================================================
--- linux-2.6.orig/mm/rmap.c
+++ linux-2.6/mm/rmap.c
@@ -248,7 +248,7 @@ static void anon_vma_unlink(struct anon_
 	list_del(&anon_vma_chain->same_anon_vma);
 
 	/* We must garbage collect the anon_vma if it's empty */
-	empty = list_empty(&anon_vma->head) && !ksm_refcount(anon_vma);
+	empty = list_empty(&anon_vma->head) && !atomic_read(&anon_vma->ref);
 	spin_unlock(&anon_vma->lock);
 
 	if (empty)
@@ -272,7 +272,7 @@ static void anon_vma_ctor(void *data)
 	struct anon_vma *anon_vma = data;
 
 	spin_lock_init(&anon_vma->lock);
-	ksm_refcount_init(anon_vma);
+	atomic_set(&anon_vma->ref, 0);
 	INIT_LIST_HEAD(&anon_vma->head);
 }
 


