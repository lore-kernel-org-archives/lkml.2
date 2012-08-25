Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752761Ab2HYOMf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2012 10:12:35 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44547 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751441Ab2HYOM1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2012 10:12:27 -0400
From: Joonsoo Kim <js1304@gmail.com>
To: Pekka Enberg <penberg@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Joonsoo Kim <js1304@gmail.com>, Mel Gorman <mgorman@suse.de>,
        Christoph Lameter <cl@linux-foundation.org>
Subject: [PATCH 1/2] slab:  do ClearSlabPfmemalloc() for all pages of slab
Date: Sat, 25 Aug 2012 23:11:10 +0900
Message-Id: <1345903871-1921-1-git-send-email-js1304@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <Yes>
References: <Yes>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now, we just do ClearSlabPfmemalloc() for first page of slab
when we clear SlabPfmemalloc flag. It is a problem because we sometimes
test flag of page which is not first page of slab in __ac_put_obj().

So add code to do ClearSlabPfmemalloc for all pages of slab.

Signed-off-by: Joonsoo Kim <js1304@gmail.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Christoph Lameter <cl@linux-foundation.org>
---
This patch based on Pekka's slab/next tree

diff --git a/mm/slab.c b/mm/slab.c
index 3b4587b..45cf59a 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -992,8 +992,11 @@ static void *__ac_get_obj(struct kmem_cache *cachep, struct array_cache *ac,
 		 */
 		l3 = cachep->nodelists[numa_mem_id()];
 		if (!list_empty(&l3->slabs_free) && force_refill) {
-			struct slab *slabp = virt_to_slab(objp);
-			ClearPageSlabPfmemalloc(virt_to_page(slabp->s_mem));
+			int i, nr_pages = (1 << cachep->gfporder);
+			struct page *page = virt_to_head_page(objp);
+
+			for (i = 0; i < nr_pages; i++)
+				ClearPageSlabPfmemalloc(page + i);
 			clear_obj_pfmemalloc(&objp);
 			recheck_pfmemalloc_active(cachep, ac);
 			return objp;
-- 
1.7.9.5

