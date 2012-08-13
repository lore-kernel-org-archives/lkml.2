Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752124Ab2HMMOu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 08:14:50 -0400
Received: from mga02.intel.com ([134.134.136.20]:30186 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751999Ab2HMMOt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 08:14:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,759,1336374000"; 
   d="scan'208";a="185678018"
From: Alex Shi <alex.shi@intel.com>
To: mgorman@suse.de, cl@linux.com
Cc: davem@davemloft.net, a.p.zijlstra@chello.nl, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, alex.shi@intel.com
Subject: [PATCH] mm: correct page->pfmemalloc to fix deactivate_slab regression
Date: Mon, 13 Aug 2012 20:14:35 +0800
Message-Id: <1344860075-31752-1-git-send-email-alex.shi@intel.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit cfd19c5a9ec (mm: only set page->pfmemalloc when
ALLOC_NO_WATERMARKS was used) try to narrow down page->pfmemalloc
setting, but it missed some places the pfmemalloc should be set.

So, in __slab_alloc, the unalignment pfmemalloc and ALLOC_NO_WATERMARKS
cause incorrect deactivate_slab() on our core2 server:

    64.73%           fio  [kernel.kallsyms]     [k] _raw_spin_lock
                     |
                     --- _raw_spin_lock
                        |
                        |---0.34%-- deactivate_slab
                        |          __slab_alloc
                        |          kmem_cache_alloc
                        |          |

That causes our fio sync write performance has 40% regression.

This patch move the checking in get_page_from_freelist, that resolved
this issue.

Signed-off-by: Alex Shi <alex.shi@intel.com>
---
 mm/page_alloc.c |   21 +++++++++++----------
 1 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 009ac28..07f1924 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1928,6 +1928,17 @@ this_zone_full:
 		zlc_active = 0;
 		goto zonelist_scan;
 	}
+
+	if (page)
+		/*
+		 * page->pfmemalloc is set when ALLOC_NO_WATERMARKS was
+		 * necessary to allocate the page. The expectation is
+		 * that the caller is taking steps that will free more
+		 * memory. The caller should avoid the page being used
+		 * for !PFMEMALLOC purposes.
+		 */
+		page->pfmemalloc = !!(alloc_flags & ALLOC_NO_WATERMARKS);
+
 	return page;
 }
 
@@ -2389,14 +2400,6 @@ rebalance:
 				zonelist, high_zoneidx, nodemask,
 				preferred_zone, migratetype);
 		if (page) {
-			/*
-			 * page->pfmemalloc is set when ALLOC_NO_WATERMARKS was
-			 * necessary to allocate the page. The expectation is
-			 * that the caller is taking steps that will free more
-			 * memory. The caller should avoid the page being used
-			 * for !PFMEMALLOC purposes.
-			 */
-			page->pfmemalloc = true;
 			goto got_pg;
 		}
 	}
@@ -2569,8 +2572,6 @@ retry_cpuset:
 		page = __alloc_pages_slowpath(gfp_mask, order,
 				zonelist, high_zoneidx, nodemask,
 				preferred_zone, migratetype);
-	else
-		page->pfmemalloc = false;
 
 	trace_mm_page_alloc(page, order, gfp_mask, migratetype);
 
-- 
1.7.5.4

