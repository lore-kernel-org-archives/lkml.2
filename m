Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762272Ab2FHRZv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 13:25:51 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44869 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762199Ab2FHRZE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 13:25:04 -0400
From: Joonsoo Kim <js1304@gmail.com>
To: Pekka Enberg <penberg@kernel.org>
Cc: Christoph Lameter <cl@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Joonsoo Kim <js1304@gmail.com>
Subject: [PATCH 3/4] slub: refactoring unfreeze_partials()
Date: Sat,  9 Jun 2012 02:23:16 +0900
Message-Id: <1339176197-13270-3-git-send-email-js1304@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1339176197-13270-1-git-send-email-js1304@gmail.com>
References: <yes>
 <1339176197-13270-1-git-send-email-js1304@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current implementation of unfreeze_partials() is so complicated,
but benefit from it is insignificant. In addition many code in
do {} while loop have a bad influence to a fail rate of cmpxchg_double_slab.
Under current implementation which test status of cpu partial slab
and acquire list_lock in do {} while loop,
we don't need to acquire a list_lock and gain a little benefit
when front of the cpu partial slab is to be discarded, but this is a rare case.
In case that add_partial is performed and cmpxchg_double_slab is failed,
remove_partial should be called case by case.

I think that these are disadvantages of current implementation,
so I do refactoring unfreeze_partials().

Minimizing code in do {} while loop introduce a reduced fail rate
of cmpxchg_double_slab. Below is output of 'slabinfo -r kmalloc-256'
when './perf stat -r 33 hackbench 50 process 4000 > /dev/null' is done.

** before **
Cmpxchg_double Looping
------------------------
Locked Cmpxchg Double redos   182685
Unlocked Cmpxchg Double redos 0

** after **
Cmpxchg_double Looping
------------------------
Locked Cmpxchg Double redos   177995
Unlocked Cmpxchg Double redos 1

We can see cmpxchg_double_slab fail rate is improved slightly.

Bolow is output of './perf stat -r 30 hackbench 50 process 4000 > /dev/null'.

** before **
 Performance counter stats for './hackbench 50 process 4000' (30 runs):

     108517.190463 task-clock                #    7.926 CPUs utilized            ( +-  0.24% )
         2,919,550 context-switches          #    0.027 M/sec                    ( +-  3.07% )
           100,774 CPU-migrations            #    0.929 K/sec                    ( +-  4.72% )
           124,201 page-faults               #    0.001 M/sec                    ( +-  0.15% )
   401,500,234,387 cycles                    #    3.700 GHz                      ( +-  0.24% )
   <not supported> stalled-cycles-frontend
   <not supported> stalled-cycles-backend
   250,576,913,354 instructions              #    0.62  insns per cycle          ( +-  0.13% )
    45,934,956,860 branches                  #  423.297 M/sec                    ( +-  0.14% )
       188,219,787 branch-misses             #    0.41% of all branches          ( +-  0.56% )

      13.691837307 seconds time elapsed                                          ( +-  0.24% )

** after **
 Performance counter stats for './hackbench 50 process 4000' (30 runs):

     107784.479767 task-clock                #    7.928 CPUs utilized            ( +-  0.22% )
         2,834,781 context-switches          #    0.026 M/sec                    ( +-  2.33% )
            93,083 CPU-migrations            #    0.864 K/sec                    ( +-  3.45% )
           123,967 page-faults               #    0.001 M/sec                    ( +-  0.15% )
   398,781,421,836 cycles                    #    3.700 GHz                      ( +-  0.22% )
   <not supported> stalled-cycles-frontend
   <not supported> stalled-cycles-backend
   250,189,160,419 instructions              #    0.63  insns per cycle          ( +-  0.09% )
    45,855,370,128 branches                  #  425.436 M/sec                    ( +-  0.10% )
       169,881,248 branch-misses             #    0.37% of all branches          ( +-  0.43% )

      13.596272341 seconds time elapsed                                          ( +-  0.22% )

No regression is found, but rather we can see slightly better result.

Acked-by: Christoph Lameter <cl@linux.com>
Signed-off-by: Joonsoo Kim <js1304@gmail.com>

diff --git a/mm/slub.c b/mm/slub.c
index 686ed90..b5f2108 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -1886,18 +1886,24 @@ redo:
  */
 static void unfreeze_partials(struct kmem_cache *s)
 {
-	struct kmem_cache_node *n = NULL;
+	struct kmem_cache_node *n = NULL, *n2 = NULL;
 	struct kmem_cache_cpu *c = this_cpu_ptr(s->cpu_slab);
 	struct page *page, *discard_page = NULL;
 
 	while ((page = c->partial)) {
-		enum slab_modes { M_PARTIAL, M_FREE };
-		enum slab_modes l, m;
 		struct page new;
 		struct page old;
 
 		c->partial = page->next;
-		l = M_FREE;
+
+		n2 = get_node(s, page_to_nid(page));
+		if (n != n2) {
+			if (n)
+				spin_unlock(&n->list_lock);
+
+			n = n2;
+			spin_lock(&n->list_lock);
+		}
 
 		do {
 
@@ -1910,43 +1916,17 @@ static void unfreeze_partials(struct kmem_cache *s)
 
 			new.frozen = 0;
 
-			if (!new.inuse && (!n || n->nr_partial > s->min_partial))
-				m = M_FREE;
-			else {
-				struct kmem_cache_node *n2 = get_node(s,
-							page_to_nid(page));
-
-				m = M_PARTIAL;
-				if (n != n2) {
-					if (n)
-						spin_unlock(&n->list_lock);
-
-					n = n2;
-					spin_lock(&n->list_lock);
-				}
-			}
-
-			if (l != m) {
-				if (l == M_PARTIAL) {
-					remove_partial(n, page);
-					stat(s, FREE_REMOVE_PARTIAL);
-				} else {
-					add_partial(n, page,
-						DEACTIVATE_TO_TAIL);
-					stat(s, FREE_ADD_PARTIAL);
-				}
-
-				l = m;
-			}
-
 		} while (!__cmpxchg_double_slab(s, page,
 				old.freelist, old.counters,
 				new.freelist, new.counters,
 				"unfreezing slab"));
 
-		if (m == M_FREE) {
+		if (unlikely(!new.inuse && n->nr_partial > s->min_partial)) {
 			page->next = discard_page;
 			discard_page = page;
+		} else {
+			add_partial(n, page, DEACTIVATE_TO_TAIL);
+			stat(s, FREE_ADD_PARTIAL);
 		}
 	}
 
-- 
1.7.9.5

