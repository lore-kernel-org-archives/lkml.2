Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752631Ab2GSOi1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 10:38:27 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40463 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751924Ab2GSOhE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 10:37:04 -0400
From: Mel Gorman <mgorman@suse.de>
To: Stable <stable@vger.kernel.org>
Cc: "Linux-MM <linux-mm"@kvack.org, LKML <linux-kernel@vger.kernel.org>,
        Mel Gorman <mgorman@suse.de>
Subject: [PATCH 28/34] mm/vmscan.c: consider swap space when deciding whether to continue reclaim
Date: Thu, 19 Jul 2012 15:36:38 +0100
Message-Id: <1342708604-26540-29-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1342708604-26540-1-git-send-email-mgorman@suse.de>
References: <1342708604-26540-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Minchan Kim <minchan@kernel.org>

commit 86cfd3a45042ab242d47f3935a02811a402beab6 upstream.

Stable note: Not tracked in Bugzilla. This patch reduces kswapd CPU
	usage on swapless systems with high anonymous memory usage.

It's pointless to continue reclaiming when we have no swap space and lots
of anon pages in the inactive list.

Without this patch, it is possible when swap is disabled to continue
trying to reclaim when there are only anonymous pages in the system even
though that will not make any progress.

Signed-off-by: Minchan Kim <minchan@kernel.org>
Acked-by: Mel Gorman <mgorman@suse.de>
Reviewed-by: Rik van Riel <riel@redhat.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Johannes Weiner <jweiner@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 mm/vmscan.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 8b98a75..da195c2 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2008,8 +2008,9 @@ static inline bool should_continue_reclaim(struct zone *zone,
 	 * inactive lists are large enough, continue reclaiming
 	 */
 	pages_for_compaction = (2UL << sc->order);
-	inactive_lru_pages = zone_nr_lru_pages(zone, sc, LRU_INACTIVE_ANON) +
-				zone_nr_lru_pages(zone, sc, LRU_INACTIVE_FILE);
+	inactive_lru_pages = zone_nr_lru_pages(zone, sc, LRU_INACTIVE_FILE);
+	if (nr_swap_pages > 0)
+		inactive_lru_pages += zone_nr_lru_pages(zone, sc, LRU_INACTIVE_ANON);
 	if (sc->nr_reclaimed < pages_for_compaction &&
 			inactive_lru_pages > pages_for_compaction)
 		return true;
-- 
1.7.9.2

