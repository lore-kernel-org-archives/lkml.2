Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759609Ab2BJRcv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 12:32:51 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:12028 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759593Ab2BJRcs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 12:32:48 -0500
Date: Fri, 10 Feb 2012 18:32:26 +0100
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCHv21 11/16] mm: extract reclaim code from
 __alloc_pages_direct_reclaim()
In-reply-to: <1328895151-5196-1-git-send-email-m.szyprowski@samsung.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org, linux-mm@kvack.org,
        linaro-mm-sig@lists.linaro.org
Cc: Michal Nazarewicz <mina86@mina86.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daniel Walker <dwalker@codeaurora.org>, Mel Gorman <mel@csn.ul.ie>,
        Arnd Bergmann <arnd@arndb.de>, Jesse Barker <jesse.barker@linaro.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Shariq Hasnain <shariq.hasnain@linaro.org>,
        Chunsang Jeong <chunsang.jeong@linaro.org>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Rob Clark <rob.clark@linaro.org>, Ohad Ben-Cohen <ohad@wizery.com>
Message-id: <1328895151-5196-12-git-send-email-m.szyprowski@samsung.com>
MIME-version: 1.0
X-Mailer: git-send-email 1.7.8.3
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1328895151-5196-1-git-send-email-m.szyprowski@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch extracts common reclaim code from __alloc_pages_direct_reclaim()
function to separate function: __perform_reclaim() which can be later used
by alloc_contig_range().

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Michal Nazarewicz <mina86@mina86.com>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Tested-by: Rob Clark <rob.clark@linaro.org>
Tested-by: Ohad Ben-Cohen <ohad@wizery.com>
Tested-by: Benjamin Gaignard <benjamin.gaignard@linaro.org>
---
 mm/page_alloc.c |   30 +++++++++++++++++++++---------
 1 files changed, 21 insertions(+), 9 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 06c66b5..793c4e4 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2092,16 +2092,13 @@ __alloc_pages_direct_compact(gfp_t gfp_mask, unsigned int order,
 }
 #endif /* CONFIG_COMPACTION */
 
-/* The really slow allocator path where we enter direct reclaim */
-static inline struct page *
-__alloc_pages_direct_reclaim(gfp_t gfp_mask, unsigned int order,
-	struct zonelist *zonelist, enum zone_type high_zoneidx,
-	nodemask_t *nodemask, int alloc_flags, struct zone *preferred_zone,
-	int migratetype, unsigned long *did_some_progress)
+/* Perform direct synchronous page reclaim */
+static int
+__perform_reclaim(gfp_t gfp_mask, unsigned int order, struct zonelist *zonelist,
+		  nodemask_t *nodemask)
 {
-	struct page *page = NULL;
 	struct reclaim_state reclaim_state;
-	bool drained = false;
+	int progress;
 
 	cond_resched();
 
@@ -2112,7 +2109,7 @@ __alloc_pages_direct_reclaim(gfp_t gfp_mask, unsigned int order,
 	reclaim_state.reclaimed_slab = 0;
 	current->reclaim_state = &reclaim_state;
 
-	*did_some_progress = try_to_free_pages(zonelist, order, gfp_mask, nodemask);
+	progress = try_to_free_pages(zonelist, order, gfp_mask, nodemask);
 
 	current->reclaim_state = NULL;
 	lockdep_clear_current_reclaim_state();
@@ -2120,6 +2117,21 @@ __alloc_pages_direct_reclaim(gfp_t gfp_mask, unsigned int order,
 
 	cond_resched();
 
+	return progress;
+}
+
+/* The really slow allocator path where we enter direct reclaim */
+static inline struct page *
+__alloc_pages_direct_reclaim(gfp_t gfp_mask, unsigned int order,
+	struct zonelist *zonelist, enum zone_type high_zoneidx,
+	nodemask_t *nodemask, int alloc_flags, struct zone *preferred_zone,
+	int migratetype, unsigned long *did_some_progress)
+{
+	struct page *page = NULL;
+	bool drained = false;
+
+	*did_some_progress = __perform_reclaim(gfp_mask, order, zonelist,
+					       nodemask);
 	if (unlikely(!(*did_some_progress)))
 		return NULL;
 
-- 
1.7.1.569.g6f426

