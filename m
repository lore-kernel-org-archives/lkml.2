Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752468Ab2AZJDl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 04:03:41 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:59815 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752180Ab2AZJBK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 04:01:10 -0500
Date: Thu, 26 Jan 2012 10:00:52 +0100
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH 10/15] mm: extract reclaim code from
 __alloc_pages_direct_reclaim()
In-reply-to: <1327568457-27734-1-git-send-email-m.szyprowski@samsung.com>
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
        Benjamin Gaignard <benjamin.gaignard@linaro.org>
Message-id: <1327568457-27734-11-git-send-email-m.szyprowski@samsung.com>
MIME-version: 1.0
X-Mailer: git-send-email 1.7.7.3
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1327568457-27734-1-git-send-email-m.szyprowski@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch extracts common reclaim code from __alloc_pages_direct_reclaim()
function to separate function: __perform_reclaim() which can be later used
by alloc_contig_range().

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
CC: Michal Nazarewicz <mina86@mina86.com>
---
 mm/page_alloc.c |   30 +++++++++++++++++++++---------
 1 files changed, 21 insertions(+), 9 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 4e60c0b..e35d06b 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2094,16 +2094,13 @@ __alloc_pages_direct_compact(gfp_t gfp_mask, unsigned int order,
 }
 #endif /* CONFIG_COMPACTION */
 
-/* The really slow allocator path where we enter direct reclaim */
-static inline struct page *
-__alloc_pages_direct_reclaim(gfp_t gfp_mask, unsigned int order,
-	struct zonelist *zonelist, enum zone_type high_zoneidx,
-	nodemask_t *nodemask, int alloc_flags, struct zone *preferred_zone,
-	int migratetype, unsigned long *did_some_progress)
+/* Perform direct synchronous page reclaim */
+static inline int
+__perform_reclaim(gfp_t gfp_mask, unsigned int order, struct zonelist *zonelist,
+		  nodemask_t *nodemask)
 {
-	struct page *page = NULL;
 	struct reclaim_state reclaim_state;
-	bool drained = false;
+	int progress;
 
 	cond_resched();
 
@@ -2114,7 +2111,7 @@ __alloc_pages_direct_reclaim(gfp_t gfp_mask, unsigned int order,
 	reclaim_state.reclaimed_slab = 0;
 	current->reclaim_state = &reclaim_state;
 
-	*did_some_progress = try_to_free_pages(zonelist, order, gfp_mask, nodemask);
+	progress = try_to_free_pages(zonelist, order, gfp_mask, nodemask);
 
 	current->reclaim_state = NULL;
 	lockdep_clear_current_reclaim_state();
@@ -2122,6 +2119,21 @@ __alloc_pages_direct_reclaim(gfp_t gfp_mask, unsigned int order,
 
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

