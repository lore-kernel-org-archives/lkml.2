Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933432Ab0DHTas (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 15:30:48 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:47324 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933262Ab0DHTae (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 15:30:34 -0400
Message-Id: <20100408192723.158842551@chello.nl>
User-Agent: quilt/0.47-1
Date: Thu, 08 Apr 2010 21:17:50 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andrea Arcangeli <aarcange@redhat.com>, Avi Kivity <avi@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, Rik van Riel <riel@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       David Miller <davem@davemloft.net>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, Mel Gorman <mel@csn.ul.ie>,
       Nick Piggin <npiggin@suse.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 13/13] mm: Optimize page_lock_anon_vma
References: <20100408191737.296180458@chello.nl>
Content-Disposition: inline; filename=mm-opt-rmap.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Optimize page_lock_anon_vma() by removing the atomic ref count
ops from the fast path.

Rather complicates the code a lot, but might be worth it.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 mm/rmap.c |   71 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 67 insertions(+), 4 deletions(-)

Index: linux-2.6/mm/rmap.c
===================================================================
--- linux-2.6.orig/mm/rmap.c
+++ linux-2.6/mm/rmap.c
@@ -78,6 +78,12 @@ static inline struct anon_vma *anon_vma_
 void anon_vma_free(struct anon_vma *anon_vma)
 {
 	VM_BUG_ON(atomic_read(&anon_vma->ref));
+	/*
+	 * Sync against the anon_vma->lock, so that we can hold the
+	 * lock without requiring a reference. See page_lock_anon_vma().
+	 */
+	mutex_lock(&anon_vma->lock);
+	mutex_unlock(&anon_vma->lock);
 	kmem_cache_free(anon_vma_cachep, anon_vma);
 }
 
@@ -291,7 +297,7 @@ void __init anon_vma_init(void)
 
 /*
  * Getting a lock on a stable anon_vma from a page off the LRU is
- * tricky: page_lock_anon_vma relies on RCU to guard against the races.
+ * tricky: anon_vma_get relies on RCU to guard against the races.
  */
 struct anon_vma *anon_vma_get(struct page *page)
 {
@@ -320,12 +326,70 @@ out:
 	return anon_vma;
 }
 
+/*
+ * Similar to anon_vma_get(), however it relies on the anon_vma->lock
+ * to pin the object. However since we cannot wait for the mutex
+ * acquisition inside the RCU read lock, we use the ref count
+ * in the slow path.
+ */
 struct anon_vma *page_lock_anon_vma(struct page *page)
 {
-	struct anon_vma *anon_vma = anon_vma_get(page);
+	struct anon_vma *anon_vma = NULL;
+	unsigned long anon_mapping;
+
+again:
+	rcu_read_lock();
+	anon_mapping = (unsigned long) ACCESS_ONCE(page->mapping);
+	if ((anon_mapping & PAGE_MAPPING_FLAGS) != PAGE_MAPPING_ANON)
+		goto unlock;
+	if (!page_mapped(page))
+		goto unlock;
+
+	anon_vma = (struct anon_vma *) (anon_mapping - PAGE_MAPPING_ANON);
+	if (!mutex_trylock(&anon_vma->lock)) {
+		/*
+		 * We failed to acquire the lock, take a ref so we can
+		 * drop the RCU read lock and sleep on it.
+		 */
+		if (!atomic_inc_not_zero(&anon_vma->ref)) {
+			/*
+			 * Failed to get a ref, we're dead, bail.
+			 */
+			anon_vma = NULL;
+			goto unlock;
+		}
+		rcu_read_unlock();
 
-	if (anon_vma)
 		mutex_lock(&anon_vma->lock);
+		/*
+		 * We got the lock, drop the temp. ref, if it was the last
+		 * one free it and bail.
+		 */
+		if (atomic_dec_and_test(&anon_vma->ref)) {
+			mutex_unlock(&anon_vma->lock);
+			anon_vma_free(anon_vma);
+			anon_vma = NULL;
+		}
+		goto out;
+	}
+	/*
+	 * Got the lock, check we're still alive. Seeing a ref
+	 * here guarantees the object will stay alive due to
+	 * anon_vma_free() syncing against the lock we now hold.
+	 */
+	smp_rmb(); /* Order against anon_vma_put() */
+	if (!atomic_read(&anon_vma->ref)) {
+		mutex_unlock(&anon_vma->lock);
+		anon_vma = NULL;
+	}
+
+unlock:
+	rcu_read_unlock();
+out:
+	if (anon_vma && page_rmapping(page) != anon_vma) {
+		mutex_unlock(&anon_vma->lock);
+		goto again;
+	}
 
 	return anon_vma;
 }
@@ -333,7 +397,6 @@ struct anon_vma *page_lock_anon_vma(stru
 void page_unlock_anon_vma(struct anon_vma *anon_vma)
 {
 	mutex_unlock(&anon_vma->lock);
-	anon_vma_put(anon_vma);
 }
 
 /*


