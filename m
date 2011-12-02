Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752775Ab1LBIYr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 03:24:47 -0500
Received: from mga14.intel.com ([143.182.124.37]:60268 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752682Ab1LBIYq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 03:24:46 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,282,1320652800"; 
   d="scan'208";a="81430341"
From: Alex Shi <alex.shi@intel.com>
To: cl@linux.com, penberg@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH 1/3] slub: set a criteria for slub node partial adding
Date: Fri,  2 Dec 2011 16:23:07 +0800
Message-Id: <1322814189-17318-1-git-send-email-alex.shi@intel.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alex Shi <alexs@intel.com>

Times performance regression were due to slub add to node partial head
or tail. That inspired me to do tunning on the node partial adding, to
set a criteria for head or tail position selection when do partial
adding.
My experiment show, when used objects is less than 1/4 total objects
of slub performance will get about 1.5% improvement on netperf loopback
testing with 2048 clients, wherever on our 4 or 2 sockets platforms,
includes sandbridge or core2.

Signed-off-by: Alex Shi <alex.shi@intel.com>
---
 mm/slub.c |   18 ++++++++----------
 1 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index ed3334d..c419e80 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -1461,14 +1461,13 @@ static void discard_slab(struct kmem_cache *s, struct page *page)
  *
  * list_lock must be held.
  */
-static inline void add_partial(struct kmem_cache_node *n,
-				struct page *page, int tail)
+static inline void add_partial(struct kmem_cache_node *n, struct page *page)
 {
 	n->nr_partial++;
-	if (tail == DEACTIVATE_TO_TAIL)
-		list_add_tail(&page->lru, &n->partial);
-	else
+	if (page->inuse <= page->objects / 4)
 		list_add(&page->lru, &n->partial);
+	else
+		list_add_tail(&page->lru, &n->partial);
 }
 
 /*
@@ -1829,7 +1828,7 @@ redo:
 
 		if (m == M_PARTIAL) {
 
-			add_partial(n, page, tail);
+			add_partial(n, page);
 			stat(s, tail);
 
 		} else if (m == M_FULL) {
@@ -1904,8 +1903,7 @@ static void unfreeze_partials(struct kmem_cache *s)
 				if (l == M_PARTIAL)
 					remove_partial(n, page);
 				else
-					add_partial(n, page,
-						DEACTIVATE_TO_TAIL);
+					add_partial(n, page);
 
 				l = m;
 			}
@@ -2476,7 +2474,7 @@ static void __slab_free(struct kmem_cache *s, struct page *page,
 		 */
 		if (unlikely(!prior)) {
 			remove_full(s, page);
-			add_partial(n, page, DEACTIVATE_TO_TAIL);
+			add_partial(n, page);
 			stat(s, FREE_ADD_PARTIAL);
 		}
 	}
@@ -2793,7 +2791,7 @@ static void early_kmem_cache_node_alloc(int node)
 	init_kmem_cache_node(n, kmem_cache_node);
 	inc_slabs_node(kmem_cache_node, node, page->objects);
 
-	add_partial(n, page, DEACTIVATE_TO_HEAD);
+	add_partial(n, page);
 }
 
 static void free_kmem_cache_nodes(struct kmem_cache *s)
-- 
1.7.0.1

