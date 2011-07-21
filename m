Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753330Ab1GUQaA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 12:30:00 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50931 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753128Ab1GUQ3z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 12:29:55 -0400
From: Mel Gorman <mgorman@suse.de>
To: Linux-MM <linux-mm@kvack.org>
Cc: LKML <linux-kernel@vger.kernel.org>, XFS <xfs@oss.sgi.com>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>,
        Johannes Weiner <jweiner@redhat.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
        Rik van Riel <riel@redhat.com>, Minchan Kim <minchan.kim@gmail.com>,
        Mel Gorman <mgorman@suse.de>
Subject: [PATCH 8/8] mm: vmscan: Do not writeback filesystem pages from kswapd
Date: Thu, 21 Jul 2011 17:28:50 +0100
Message-Id: <1311265730-5324-9-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1311265730-5324-1-git-send-email-mgorman@suse.de>
References: <1311265730-5324-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Assuming that flusher threads will always write back dirty pages promptly
then it is always faster for reclaimers to wait for flushers. This patch
prevents kswapd writing back any filesystem pages.

Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 mm/vmscan.c |   15 ++++-----------
 1 files changed, 4 insertions(+), 11 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index c3d8341..6023494 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -720,7 +720,6 @@ static noinline_for_stack void free_page_list(struct list_head *free_pages)
 static unsigned long shrink_page_list(struct list_head *page_list,
 				      struct zone *zone,
 				      struct scan_control *sc,
-				      int priority,
 				      unsigned long *ret_nr_dirty)
 {
 	LIST_HEAD(ret_pages);
@@ -827,13 +826,8 @@ static unsigned long shrink_page_list(struct list_head *page_list,
 		if (PageDirty(page)) {
 			nr_dirty++;
 
-			/*
-			 * Only kswapd can writeback filesystem pages to
-			 * avoid risk of stack overflow but do not writeback
-			 * unless under significant pressure.
-			 */
-			if (page_is_file_cache(page) &&
-					(!current_is_kswapd() || priority >= DEF_PRIORITY - 2)) {
+			/* Flusher must clean dirty filesystem-backed pages */
+			if (page_is_file_cache(page)) {
 				/*
 				 * Immediately reclaim when written back.
 				 * Similar in principal to deactivate_page()
@@ -1479,14 +1473,13 @@ shrink_inactive_list(unsigned long nr_to_scan, struct zone *zone,
 
 	spin_unlock_irq(&zone->lru_lock);
 
-	nr_reclaimed = shrink_page_list(&page_list, zone, sc,
-							priority, &nr_dirty);
+	nr_reclaimed = shrink_page_list(&page_list, zone, sc, &nr_dirty);
 
 	/* Check if we should syncronously wait for writeback */
 	if (should_reclaim_stall(nr_taken, nr_reclaimed, priority, sc)) {
 		set_reclaim_mode(priority, sc, true);
 		nr_reclaimed += shrink_page_list(&page_list, zone, sc,
-							priority, &nr_dirty);
+							&nr_dirty);
 	}
 
 	local_irq_disable();
-- 
1.7.3.4

