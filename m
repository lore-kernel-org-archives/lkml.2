Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754725Ab0GITMW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 15:12:22 -0400
Received: from nlpi157.sbcis.sbc.com ([207.115.36.171]:34278 "EHLO
	nlpi157.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753491Ab0GITMR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 15:12:17 -0400
Message-Id: <20100709190854.930694716@quilx.com>
User-Agent: quilt/0.48-1
Date: Fri, 09 Jul 2010 14:07:15 -0500
From: Christoph Lameter <cl@linux-foundation.org>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
Cc: Nick Piggin <npiggin@suse.de>
Cc: David Rientjes <rientjes@google.com>
Subject: [S+Q2 09/19] slub: discard_slab_unlock
References: <20100709190706.938177313@quilx.com>
Content-Disposition: inline; filename=slub_discard_unlock
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The sequence of unlocking a slab and freeing occurs multiple times.
Put the common into a single function. There is no intend here
to use this to enforce a sequencing of events leading up
to the discarding of a slab page.

Signed-off-by: Christoph Lameter <cl@linux-foundation.org>

---
 mm/slub.c |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

Index: linux-2.6/mm/slub.c
===================================================================
--- linux-2.6.orig/mm/slub.c	2010-06-01 08:58:50.000000000 -0500
+++ linux-2.6/mm/slub.c	2010-06-01 08:58:54.000000000 -0500
@@ -1260,6 +1260,13 @@ static __always_inline int slab_trylock(
 	return rc;
 }
 
+static void discard_slab_unlock(struct kmem_cache *s,
+	struct page *page)
+{
+	slab_unlock(page);
+	discard_slab(s, page);
+}
+
 /*
  * Management of partially allocated slabs
  */
@@ -1437,9 +1444,8 @@ static void unfreeze_slab(struct kmem_ca
 			add_partial(n, page, 1);
 			slab_unlock(page);
 		} else {
-			slab_unlock(page);
 			stat(s, FREE_SLAB);
-			discard_slab(s, page);
+			discard_slab_unlock(s, page);
 		}
 	}
 }
@@ -1822,9 +1828,8 @@ slab_empty:
 		remove_partial(s, page);
 		stat(s, FREE_REMOVE_PARTIAL);
 	}
-	slab_unlock(page);
 	stat(s, FREE_SLAB);
-	discard_slab(s, page);
+	discard_slab_unlock(s, page);
 	return;
 
 debug:
@@ -2893,8 +2898,7 @@ int kmem_cache_shrink(struct kmem_cache 
 				 */
 				list_del(&page->lru);
 				n->nr_partial--;
-				slab_unlock(page);
-				discard_slab(s, page);
+				discard_slab_unlock(s, page);
 			} else {
 				list_move(&page->lru,
 				slabs_by_inuse + page->inuse);

