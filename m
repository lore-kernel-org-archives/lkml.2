Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753537Ab1HJKss (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 06:48:48 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57301 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752610Ab1HJKrZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 06:47:25 -0400
From: Mel Gorman <mgorman@suse.de>
To: Linux-MM <linux-mm@kvack.org>
Cc: LKML <linux-kernel@vger.kernel.org>, XFS <xfs@oss.sgi.com>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>,
        Johannes Weiner <jweiner@redhat.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
        Rik van Riel <riel@redhat.com>, Minchan Kim <minchan.kim@gmail.com>,
        Mel Gorman <mgorman@suse.de>
Subject: [PATCH 2/7] mm: vmscan: Remove dead code related to lumpy reclaim waiting on pages under writeback
Date: Wed, 10 Aug 2011 11:47:15 +0100
Message-Id: <1312973240-32576-3-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1312973240-32576-1-git-send-email-mgorman@suse.de>
References: <1312973240-32576-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lumpy reclaim worked with two passes - the first which queued pages for
IO and the second which waited on writeback. As direct reclaim can no
longer write pages there is some dead code. This patch removes it but
direct reclaim will continue to wait on pages under writeback while in
synchronous reclaim mode.

Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 mm/vmscan.c |   21 +++++----------------
 1 files changed, 5 insertions(+), 16 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 1522b0f..7863f8e 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -455,15 +455,6 @@ static pageout_t pageout(struct page *page, struct address_space *mapping,
 			return PAGE_ACTIVATE;
 		}
 
-		/*
-		 * Wait on writeback if requested to. This happens when
-		 * direct reclaiming a large contiguous area and the
-		 * first attempt to free a range of pages fails.
-		 */
-		if (PageWriteback(page) &&
-		    (sc->reclaim_mode & RECLAIM_MODE_SYNC))
-			wait_on_page_writeback(page);
-
 		if (!PageWriteback(page)) {
 			/* synchronous write or broken a_ops? */
 			ClearPageReclaim(page);
@@ -764,12 +755,10 @@ static unsigned long shrink_page_list(struct list_head *page_list,
 
 		if (PageWriteback(page)) {
 			/*
-			 * Synchronous reclaim is performed in two passes,
-			 * first an asynchronous pass over the list to
-			 * start parallel writeback, and a second synchronous
-			 * pass to wait for the IO to complete.  Wait here
-			 * for any page for which writeback has already
-			 * started.
+			 * Synchronous reclaim cannot queue pages for
+			 * writeback due to the possibility of stack overflow
+			 * but if it encounters a page under writeback, wait
+			 * for the IO to complete.
 			 */
 			if ((sc->reclaim_mode & RECLAIM_MODE_SYNC) &&
 			    may_enter_fs)
@@ -1363,7 +1352,7 @@ static noinline_for_stack void update_isolated_counts(struct zone *zone,
 }
 
 /*
- * Returns true if the caller should wait to clean dirty/writeback pages.
+ * Returns true if a direct reclaim should wait on pages under writeback.
  *
  * If we are direct reclaiming for contiguous pages and we do not reclaim
  * everything in the list, try again and wait for writeback IO to complete.
-- 
1.7.3.4

