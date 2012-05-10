Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759518Ab2EJNuk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 09:50:40 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37195 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757274Ab2EJNpS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 09:45:18 -0400
From: Mel Gorman <mgorman@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux-MM <linux-mm@kvack.org>, Linux-Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>, Neil Brown <neilb@suse.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Christie <michaelc@cs.wisc.edu>,
        Eric B Munson <emunson@mgebm.net>, Mel Gorman <mgorman@suse.de>
Subject: [PATCH 03/17] mm: slub: Optimise the SLUB fast path to avoid pfmemalloc checks
Date: Thu, 10 May 2012 14:44:56 +0100
Message-Id: <1336657510-24378-4-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1336657510-24378-1-git-send-email-mgorman@suse.de>
References: <1336657510-24378-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christoph Lameter <cl@linux.com>

This patch removes the check for pfmemalloc from the alloc hotpath and
puts the logic after the election of a new per cpu slab. For a pfmemalloc
page we do not use the fast path but force the use of the slow path which
is also used for the debug case.

This has the side-effect of weakening pfmemalloc processing in the
following way;

1. A process that is allocating for network swap calls __slab_alloc.
   pfmemalloc_match is true so the freelist is loaded and c->freelist is
   now pointing to a pfmemalloc page.

2. A process that is attempting normal allocations calls slab_alloc,
   finds the pfmemalloc page on the freelist and uses it because it did
   not check pfmemalloc_match()

The patch allows non-pfmemalloc allocations to use pfmemalloc pages with
the kmalloc slabs being the most vunerable caches on the grounds they
are most likely to have a mix of pfmemalloc and !pfmemalloc requests. A
later patch will still protect the system as processes will get throttled
if the pfmemalloc reserves get depleted but performance will not degrade
as smoothly.

[mgorman@suse.de: Expanded changelog]
Signed-off-by: Christoph Lameter <cl@linux.com>
Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 mm/slub.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index f0909bf..f8cbec4 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2298,11 +2298,11 @@ new_slab:
 		}
 	}
 
-	if (likely(!kmem_cache_debug(s)))
+	if (likely(!kmem_cache_debug(s) && pfmemalloc_match(c, gfpflags)))
 		goto load_freelist;
 
 	/* Only entered in the debug case */
-	if (!alloc_debug_processing(s, c->page, object, addr))
+	if (kmem_cache_debug(s) && !alloc_debug_processing(s, c->page, object, addr))
 		goto new_slab;	/* Slab failed checks. Next slab needed */
 
 	c->freelist = get_freepointer(s, object);
@@ -2352,8 +2352,7 @@ redo:
 	barrier();
 
 	object = c->freelist;
-	if (unlikely(!object || !node_match(c, node) ||
-					!pfmemalloc_match(c, gfpflags)))
+	if (unlikely(!object || !node_match(c, node)))
 		object = __slab_alloc(s, gfpflags, node, addr, c);
 
 	else {
-- 
1.7.9.2

