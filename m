Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755291Ab0JNPfE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 11:35:04 -0400
Received: from filtteri5.pp.htv.fi ([213.243.153.188]:49165 "EHLO
	filtteri5.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754869Ab0JNPfD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 11:35:03 -0400
From: Pekka Enberg <penberg@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Pekka Enberg <penberg@kernel.org>, Christoph Lameter <cl@linux.com>,
        David Rientjes <rientjes@google.com>
Subject: [PATCH v2] slub: Drop slab lock for partial list handling
Date: Thu, 14 Oct 2010 18:34:57 +0300
Message-Id: <1287070497-2398-1-git-send-email-penberg@kernel.org>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's no need to hold 'page' slab lock for partial list handling functions. A
page is bound to a node so 'page->lru' is always protected by n->list_lock.

Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Pekka Enberg <penberg@kernel.org>
---
- v1 -> v2: rediff and testing

 mm/slub.c |   38 +++++++++++++++++++++-----------------
 1 files changed, 21 insertions(+), 17 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 8fd5401..30bf642 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -36,14 +36,13 @@
  *   The slab_lock protects operations on the object of a particular
  *   slab and its metadata in the page struct. If the slab lock
  *   has been taken then no allocations nor frees can be performed
- *   on the objects in the slab nor can the slab be added or removed
- *   from the partial or full lists since this would mean modifying
- *   the page_struct of the slab.
+ *   on the objects in the slab.
  *
- *   The list_lock protects the partial and full list on each node and
- *   the partial slab counter. If taken then no new slabs may be added or
- *   removed from the lists nor make the number of partial slabs be modified.
- *   (Note that the total number of slabs is an atomic value that may be
+ *   The list_lock protects the partial and full list on each node and   the
+ *   partial slab counter. It also protects page struct ->lru which is used for
+ *   partial lists. If taken then no new slabs may be added or removed from the
+ *   lists nor make the number of partial slabs be modified.  (Note that the
+ *   total number of slabs is an atomic value that may be
  *   modified without taking the list lock).
  *
  *   The list_lock is a centralized lock and thus we avoid taking it as
@@ -1452,8 +1451,11 @@ static void unfreeze_slab(struct kmem_cache *s, struct page *page, int tail)
 
 	__ClearPageSlubFrozen(page);
 	if (page->inuse) {
+		void *prior = page->freelist;
 
-		if (page->freelist) {
+		slab_unlock(page);
+
+		if (prior) {
 			add_partial(n, page, tail);
 			stat(s, tail ? DEACTIVATE_TO_TAIL : DEACTIVATE_TO_HEAD);
 		} else {
@@ -1461,8 +1463,8 @@ static void unfreeze_slab(struct kmem_cache *s, struct page *page, int tail)
 			if (kmem_cache_debug(s) && (s->flags & SLAB_STORE_USER))
 				add_full(n, page);
 		}
-		slab_unlock(page);
 	} else {
+		slab_unlock(page);
 		stat(s, DEACTIVATE_EMPTY);
 		if (n->nr_partial < s->min_partial) {
 			/*
@@ -1476,9 +1478,7 @@ static void unfreeze_slab(struct kmem_cache *s, struct page *page, int tail)
 			 * the partial list.
 			 */
 			add_partial(n, page, 1);
-			slab_unlock(page);
 		} else {
-			slab_unlock(page);
 			stat(s, FREE_SLAB);
 			discard_slab(s, page);
 		}
@@ -1831,13 +1831,16 @@ checks_ok:
 	page->inuse--;
 
 	if (unlikely(PageSlubFrozen(page))) {
+		slab_unlock(page);
 		stat(s, FREE_FROZEN);
-		goto out_unlock;
+		goto out;
 	}
 
 	if (unlikely(!page->inuse))
 		goto slab_empty;
 
+	slab_unlock(page);
+
 	/*
 	 * Objects left in the slab. If it was not on the partial list before
 	 * then add it.
@@ -1847,11 +1850,11 @@ checks_ok:
 		stat(s, FREE_ADD_PARTIAL);
 	}
 
-out_unlock:
-	slab_unlock(page);
+out:
 	return;
 
 slab_empty:
+	slab_unlock(page);
 	if (prior) {
 		/*
 		 * Slab still on the partial list.
@@ -1859,14 +1862,15 @@ slab_empty:
 		remove_partial(s, page);
 		stat(s, FREE_REMOVE_PARTIAL);
 	}
-	slab_unlock(page);
 	stat(s, FREE_SLAB);
 	discard_slab(s, page);
 	return;
 
 debug:
-	if (!free_debug_processing(s, page, x, addr))
-		goto out_unlock;
+	if (!free_debug_processing(s, page, x, addr)) {
+		slab_unlock(page);
+		goto out;
+	}
 	goto checks_ok;
 }
 
-- 
1.6.3.3

