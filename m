Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755017Ab0KZPBd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 10:01:33 -0500
Received: from canuck.infradead.org ([134.117.69.58]:50055 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754910Ab0KZPBa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 10:01:30 -0500
Message-Id: <20101126145411.441498352@chello.nl>
User-Agent: quilt/0.47-1
Date: Fri, 26 Nov 2010 15:39:04 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andrea Arcangeli <aarcange@redhat.com>, Avi Kivity <avi@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Rik van Riel <riel@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-mm@kvack.org, Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        David Miller <davem@davemloft.net>,
        Hugh Dickins <hugh.dickins@tiscali.co.uk>, Mel Gorman <mel@csn.ul.ie>,
        Nick Piggin <npiggin@kernel.dk>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Yanmin Zhang <yanmin_zhang@linux.intel.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: [PATCH 21/21] mm: Optimize page_lock_anon_vma() fast-path
References: <20101126143843.801484792@chello.nl>
Content-Disposition: inline; filename=mm-opt-page_lock_anon_vma.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Optimize the page_lock_anon_vma() fast path to be one LOCKed op,
instead of two.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 mm/rmap.c |   71 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 67 insertions(+), 4 deletions(-)

Index: linux-2.6/mm/rmap.c
===================================================================
--- linux-2.6.orig/mm/rmap.c
+++ linux-2.6/mm/rmap.c
@@ -357,20 +357,75 @@ out:
 	return anon_vma;
 }
 
+/*
+ * Similar to page_get_anon_vma() except it locks the anon_vma.
+ *
+ * Its a little more complex as it tries to keep the fast path to a single
+ * atomic op -- the trylock. If we fail the trylock, we fall back to getting a
+ * reference like with page_get_anon_vma() and then block on the mutex.
+ */
 struct anon_vma *page_lock_anon_vma(struct page *page)
 {
-	struct anon_vma *anon_vma = page_get_anon_vma(page);
+	struct anon_vma *anon_vma = NULL;
+	unsigned long anon_mapping;
+
+	rcu_read_lock();
+	anon_mapping = (unsigned long) ACCESS_ONCE(page->mapping);
+	if ((anon_mapping & PAGE_MAPPING_FLAGS) != PAGE_MAPPING_ANON)
+		goto out;
+	if (!page_mapped(page))
+		goto out;
+
+	anon_vma = (struct anon_vma *) (anon_mapping - PAGE_MAPPING_ANON);
+	if (mutex_trylock(&anon_vma->root->lock)) {
+		/*
+		 * If we observe a !0 refcount, then holding the lock ensures
+		 * the anon_vma will not go away, see __put_anon_vma().
+		 */
+		if (!atomic_read(&anon_vma->refcount)) {
+			anon_vma_unlock(anon_vma);
+			anon_vma = NULL;
+		}
+		goto out;
+	}
 
-	if (anon_vma)
-		anon_vma_lock(anon_vma);
+	/* trylock failed, we got to sleep */
+	if (!atomic_inc_not_zero(&anon_vma->refcount)) {
+		anon_vma = NULL;
+		goto out;
+	}
+
+	if (!page_mapped(page)) {
+		put_anon_vma(anon_vma);
+		anon_vma = NULL;
+		goto out;
+	}
+
+	/* we pinned the anon_vma, its safe to sleep */
+	rcu_read_unlock();
+	anon_vma_lock(anon_vma);
+
+	if (atomic_dec_and_test(&anon_vma->refcount)) {
+		/*
+		 * Oops, we held the last refcount, release the lock
+		 * and bail -- can't simply use put_anon_vma() because
+		 * we'll deadlock on the anon_vma_lock() recursion.
+		 */
+		anon_vma_unlock(anon_vma);
+		__put_anon_vma(anon_vma);
+		anon_vma = NULL;
+	}
 
 	return anon_vma;
+
+out:
+	rcu_read_unlock();
+	return anon_vma;
 }
 
 void page_unlock_anon_vma(struct anon_vma *anon_vma)
 {
 	anon_vma_unlock(anon_vma);
-	put_anon_vma(anon_vma);
 }
 
 /*
@@ -1462,6 +1517,14 @@ int try_to_munlock(struct page *page)
 
 void __put_anon_vma(struct anon_vma *anon_vma)
 {
+	/*
+	 * Synchronize against page_lock_anon_vma() such that
+	 * we can safely hold the lock without the anon_vma getting
+	 * freed.
+	 */
+	anon_vma_lock(anon_vma);
+	anon_vma_unlock(anon_vma);
+
 	if (anon_vma->root != anon_vma)
 		put_anon_vma(anon_vma->root);
 	anon_vma_free(anon_vma);


