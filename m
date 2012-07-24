Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753787Ab2GXPMy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 11:12:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36379 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753409Ab2GXPMx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 11:12:53 -0400
Date: Tue, 24 Jul 2012 11:12:22 -0400
From: Rik van Riel <riel@redhat.com>
To: linux-mm@kvack.org
Cc: Andrea Arcangeli <aarcange@redhat.com>,
        lkml <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>
Subject: [PATCH -mm] remove __GFP_NO_KSWAPD
Message-ID: <20120724111222.2c5e6b30@annuminas.surriel.com>
Organization: Red Hat, Inc.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When transparent huge pages were introduced, memory compaction and
swap storms were an issue, and the kernel had to be careful to not
make THP allocations cause pageout or compaction.

Now that we have working compaction deferral, kswapd is smart enough
to invoke compaction and the quadratic behaviour around isolate_free_pages
has been fixed, it should be safe to remove __GFP_NO_KSWAPD.

Signed-off-by: Rik van Riel <riel@redhat.com>
---
This has been running fine on my system for a while, but my system
only has 12GB and moderate memory pressure. I propose we keep this
in -mm and -next for a while, and merge it for 3.7 if nobody complains.

 include/linux/gfp.h |    5 +----
 mm/page_alloc.c     |    7 +++----
 2 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/include/linux/gfp.h b/include/linux/gfp.h
index 581e74b..4f3d4d2 100644
--- a/include/linux/gfp.h
+++ b/include/linux/gfp.h
@@ -34,7 +34,6 @@ struct vm_area_struct;
 #else
 #define ___GFP_NOTRACK		0
 #endif
-#define ___GFP_NO_KSWAPD	0x400000u
 #define ___GFP_OTHER_NODE	0x800000u
 #define ___GFP_WRITE		0x1000000u
 
@@ -84,7 +83,6 @@ struct vm_area_struct;
 #define __GFP_RECLAIMABLE ((__force gfp_t)___GFP_RECLAIMABLE) /* Page is reclaimable */
 #define __GFP_NOTRACK	((__force gfp_t)___GFP_NOTRACK)  /* Don't track with kmemcheck */
 
-#define __GFP_NO_KSWAPD	((__force gfp_t)___GFP_NO_KSWAPD)
 #define __GFP_OTHER_NODE ((__force gfp_t)___GFP_OTHER_NODE) /* On behalf of other node */
 #define __GFP_WRITE	((__force gfp_t)___GFP_WRITE)	/* Allocator intends to dirty page */
 
@@ -114,8 +112,7 @@ struct vm_area_struct;
 				 __GFP_MOVABLE)
 #define GFP_IOFS	(__GFP_IO | __GFP_FS)
 #define GFP_TRANSHUGE	(GFP_HIGHUSER_MOVABLE | __GFP_COMP | \
-			 __GFP_NOMEMALLOC | __GFP_NORETRY | __GFP_NOWARN | \
-			 __GFP_NO_KSWAPD)
+			 __GFP_NOMEMALLOC | __GFP_NORETRY | __GFP_NOWARN)
 
 #ifdef CONFIG_NUMA
 #define GFP_THISNODE	(__GFP_THISNODE | __GFP_NOWARN | __GFP_NORETRY)
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index a13ded1..87b7721 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2217,9 +2217,8 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 		goto nopage;
 
 restart:
-	if (!(gfp_mask & __GFP_NO_KSWAPD))
-		wake_all_kswapd(order, zonelist, high_zoneidx,
-						zone_idx(preferred_zone));
+	wake_all_kswapd(order, zonelist, high_zoneidx,
+					zone_idx(preferred_zone));
 
 	/*
 	 * OK, we're below the kswapd watermark and have kicked background
@@ -2286,7 +2285,7 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 	 * has requested the system not be heavily disrupted, fail the
 	 * allocation now instead of entering direct reclaim
 	 */
-	if (deferred_compaction && (gfp_mask & __GFP_NO_KSWAPD))
+	if (deferred_compaction)
 		goto nopage;
 
 	/* Try direct reclaim and then allocating */
