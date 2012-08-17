Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756797Ab2HQOPV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 10:15:21 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35413 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757036Ab2HQOOl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 10:14:41 -0400
From: Mel Gorman <mgorman@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Rik van Riel <riel@redhat.com>, Minchan Kim <minchan@kernel.org>,
        Jim Schutt <jaschut@sandia.gov>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, Mel Gorman <mgorman@suse.de>
Subject: [PATCH 6/7] mm: vmscan: Scale number of pages reclaimed by reclaim/compaction based on failures
Date: Fri, 17 Aug 2012 15:14:32 +0100
Message-Id: <1345212873-22447-7-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1345212873-22447-1-git-send-email-mgorman@suse.de>
References: <1345212873-22447-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If allocation fails after compaction then compaction may be deferred for
a number of allocation attempts. If there are subsequent failures,
compact_defer_shift is increased to defer for longer periods. This patch
uses that information to scale the number of pages reclaimed with
compact_defer_shift until allocations succeed again. The rationale is
that reclaiming the normal number of pages still allowed compaction to
fail and its success depends on the number of pages. If it's failing,
reclaim more pages until it succeeds again.

Note that this is not implying that VM reclaim is not reclaiming enough
pages or that its logic is broken. try_to_free_pages() always asks for
SWAP_CLUSTER_MAX pages to be reclaimed regardless of order and that is
what it does. Direct reclaim stops normally with this check.

	if (sc->nr_reclaimed >= sc->nr_to_reclaim)
		goto out;

should_continue_reclaim delays when that check is made until a minimum number
of pages for reclaim/compaction are reclaimed. It is possible that this patch
could instead set nr_to_reclaim in try_to_free_pages() and drive it from
there but that's behaves differently and not necessarily for the better. If
driven from do_try_to_free_pages(), it is also possible that priorities
will rise. When they reach DEF_PRIORITY-2, it will also start stalling
and setting pages for immediate reclaim which is more disruptive than not
desirable in this case. That is a more wide-reaching change that could
cause another regression related to THP requests causing interactive jitter.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Acked-by: Rik van Riel <riel@redhat.com>
Reviewed-by: Minchan Kim <minchan@kernel.org>
---
 mm/vmscan.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 8d01243..0dd35ef 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1743,6 +1743,7 @@ static inline bool should_continue_reclaim(struct lruvec *lruvec,
 {
 	unsigned long pages_for_compaction;
 	unsigned long inactive_lru_pages;
+	struct zone *zone;
 
 	/* If not in reclaim/compaction mode, stop */
 	if (!in_reclaim_compaction(sc))
@@ -1776,6 +1777,15 @@ static inline bool should_continue_reclaim(struct lruvec *lruvec,
 	 * inactive lists are large enough, continue reclaiming
 	 */
 	pages_for_compaction = (2UL << sc->order);
+
+	/*
+	 * If compaction is deferred for sc->order then scale the number of
+	 * pages reclaimed based on the number of consecutive allocation
+	 * failures
+	 */
+	zone = lruvec_zone(lruvec);
+	if (zone->compact_order_failed <= sc->order)
+		pages_for_compaction <<= zone->compact_defer_shift;
 	inactive_lru_pages = get_lru_size(lruvec, LRU_INACTIVE_FILE);
 	if (nr_swap_pages > 0)
 		inactive_lru_pages += get_lru_size(lruvec, LRU_INACTIVE_ANON);
-- 
1.7.9.2

