Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754622Ab1HWAfo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 20:35:44 -0400
Received: from mga09.intel.com ([134.134.136.24]:28350 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753934Ab1HWAfj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 20:35:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="40781625"
Subject: [patch 2/2]slub: add a type for slab partial list position
From: Shaohua Li <shaohua.li@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm <linux-mm@kvack.org>, lkml <linux-kernel@vger.kernel.org>,
        cl@linux.com, penberg@kernel.org, "Shi, Alex" <alex.shi@intel.com>,
        "Chen, Tim C" <tim.c.chen@intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 23 Aug 2011 08:37:03 +0800
Message-ID: <1314059823.29510.19.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding slab to partial list head/tail is sensentive to performance.
So adding a type to document it to avoid we get it wrong.

Signed-off-by: Shaohua Li <shli@kernel.org>
Signed-off-by: Shaohua Li <shaohua.li@intel.com>
---
 mm/slub.c |   20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

Index: linux/mm/slub.c
===================================================================
--- linux.orig/mm/slub.c	2011-08-23 08:20:24.000000000 +0800
+++ linux/mm/slub.c	2011-08-23 08:34:29.000000000 +0800
@@ -1525,16 +1525,21 @@ static void discard_slab(struct kmem_cac
 	free_slab(s, page);
 }
 
+enum partial_list_position {
+	PARTIAL_LIST_HEAD,
+	PARTIAL_LIST_TAIL,
+};
+
 /*
  * Management of partially allocated slabs.
  *
  * list_lock must be held.
  */
 static inline void add_partial(struct kmem_cache_node *n,
-				struct page *page, int tail)
+			struct page *page, enum partial_list_position tail)
 {
 	n->nr_partial++;
-	if (tail)
+	if (tail == PARTIAL_LIST_TAIL)
 		list_add_tail(&page->lru, &n->partial);
 	else
 		list_add(&page->lru, &n->partial);
@@ -1781,13 +1786,13 @@ static void deactivate_slab(struct kmem_
 	enum slab_modes l = M_NONE, m = M_NONE;
 	void *freelist;
 	void *nextfree;
-	int tail = 0;
+	enum partial_list_position tail = PARTIAL_LIST_HEAD;
 	struct page new;
 	struct page old;
 
 	if (page->freelist) {
 		stat(s, DEACTIVATE_REMOTE_FREES);
-		tail = 1;
+		tail = PARTIAL_LIST_TAIL;
 	}
 
 	c->tid = next_tid(c->tid);
@@ -1893,7 +1898,8 @@ redo:
 		if (m == M_PARTIAL) {
 
 			add_partial(n, page, tail);
-			stat(s, tail ? DEACTIVATE_TO_TAIL : DEACTIVATE_TO_HEAD);
+			stat(s, tail == PARTIAL_LIST_TAIL ? DEACTIVATE_TO_TAIL
+				: DEACTIVATE_TO_HEAD);
 
 		} else if (m == M_FULL) {
 
@@ -2377,7 +2383,7 @@ static void __slab_free(struct kmem_cach
 		 */
 		if (unlikely(!prior)) {
 			remove_full(s, page);
-			add_partial(n, page, 1);
+			add_partial(n, page, PARTIAL_LIST_TAIL);
 			stat(s, FREE_ADD_PARTIAL);
 		}
 	}
@@ -2695,7 +2701,7 @@ static void early_kmem_cache_node_alloc(
 	init_kmem_cache_node(n, kmem_cache_node);
 	inc_slabs_node(kmem_cache_node, node, page->objects);
 
-	add_partial(n, page, 0);
+	add_partial(n, page, PARTIAL_LIST_HEAD);
 }
 
 static void free_kmem_cache_nodes(struct kmem_cache *s)


