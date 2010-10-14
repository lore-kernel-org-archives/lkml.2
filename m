Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754770Ab0JNHBZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 03:01:25 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:36575 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750893Ab0JNHBY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 03:01:24 -0400
Date: Thu, 14 Oct 2010 10:01:23 +0300 (EEST)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: cl@linux.com, rientjes@google.com
cc: linux-kernel@vger.kernel.org
Subject: [RFC/PATCH] slub: Drop slab lock for partial list handling
Message-ID: <alpine.DEB.2.00.1010141000190.18275@melkki.cs.helsinki.fi>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pekka Enberg <penberg@kernel.org>

There's no need to hold 'page' slab lock for partial list handling functions. A
page is bound to a node so 'page->lru' is always protected by n->list_lock.

Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Pekka Enberg <penberg@kernel.org>
---
David, assuming this actually works, does it help with netperf TCP_RR? The 
patch is on top of my slab/next branch.

  mm/slub.c |   26 +++++++++++++++-----------
  1 files changed, 15 insertions(+), 11 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 8fd5401..f41126f 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -1452,8 +1452,11 @@ static void unfreeze_slab(struct kmem_cache *s, struct page *page, int tail)

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
@@ -1461,8 +1464,8 @@ static void unfreeze_slab(struct kmem_cache *s, struct page *page, int tail)
  			if (kmem_cache_debug(s) && (s->flags & SLAB_STORE_USER))
  				add_full(n, page);
  		}
-		slab_unlock(page);
  	} else {
+		slab_unlock(page);
  		stat(s, DEACTIVATE_EMPTY);
  		if (n->nr_partial < s->min_partial) {
  			/*
@@ -1476,9 +1479,7 @@ static void unfreeze_slab(struct kmem_cache *s, struct page *page, int tail)
  			 * the partial list.
  			 */
  			add_partial(n, page, 1);
-			slab_unlock(page);
  		} else {
-			slab_unlock(page);
  			stat(s, FREE_SLAB);
  			discard_slab(s, page);
  		}
@@ -1831,13 +1832,16 @@ checks_ok:
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
@@ -1846,12 +1850,11 @@ checks_ok:
  		add_partial(get_node(s, page_to_nid(page)), page, 1);
  		stat(s, FREE_ADD_PARTIAL);
  	}
-
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
1.7.1

