Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754464Ab2HGMcr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 08:32:47 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53653 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753415Ab2HGMbW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 08:31:22 -0400
From: Mel Gorman <mgorman@suse.de>
To: Linux-MM <linux-mm@kvack.org>
Cc: Rik van Riel <riel@redhat.com>, Minchan Kim <minchan@kernel.org>,
        Jim Schutt <jaschut@sandia.gov>, LKML <linux-kernel@vger.kernel.org>,
        Mel Gorman <mgorman@suse.de>
Subject: [PATCH 2/6] mm: vmscan: Scale number of pages reclaimed by reclaim/compaction based on failures
Date: Tue,  7 Aug 2012 13:31:13 +0100
Message-Id: <1344342677-5845-3-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1344342677-5845-1-git-send-email-mgorman@suse.de>
References: <1344342677-5845-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If allocation fails after compaction then compaction may be deferred for
a number of allocation attempts. If there are subsequent failures,
compact_defer_shift is increased to defer for longer periods. This patch
uses that information to scale the number of pages reclaimed with
compact_defer_shift until allocations succeed again.

Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 mm/vmscan.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 66e4310..0cb2593 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1708,6 +1708,7 @@ static inline bool should_continue_reclaim(struct lruvec *lruvec,
 {
 	unsigned long pages_for_compaction;
 	unsigned long inactive_lru_pages;
+	struct zone *zone;
 
 	/* If not in reclaim/compaction mode, stop */
 	if (!in_reclaim_compaction(sc))
@@ -1741,6 +1742,15 @@ static inline bool should_continue_reclaim(struct lruvec *lruvec,
 	 * inactive lists are large enough, continue reclaiming
 	 */
 	pages_for_compaction = (2UL << sc->order);
+
+	/*
+	 * If compaction is deferred for this order then scale the number of
+	 * pages reclaimed based on the number of consecutive allocation
+	 * failures
+	 */
+	zone = lruvec_zone(lruvec);
+	if (zone->compact_order_failed >= sc->order)
+		pages_for_compaction <<= zone->compact_defer_shift;
 	inactive_lru_pages = get_lru_size(lruvec, LRU_INACTIVE_FILE);
 	if (nr_swap_pages > 0)
 		inactive_lru_pages += get_lru_size(lruvec, LRU_INACTIVE_ANON);
-- 
1.7.9.2

