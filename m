Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753208Ab1GUQ3G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 12:29:06 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50829 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751343Ab1GUQ3C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 12:29:02 -0400
From: Mel Gorman <mgorman@suse.de>
To: Linux-MM <linux-mm@kvack.org>
Cc: LKML <linux-kernel@vger.kernel.org>, XFS <xfs@oss.sgi.com>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>,
        Johannes Weiner <jweiner@redhat.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
        Rik van Riel <riel@redhat.com>, Minchan Kim <minchan.kim@gmail.com>,
        Mel Gorman <mgorman@suse.de>
Subject: [PATCH 1/8] mm: vmscan: Do not writeback filesystem pages in direct reclaim
Date: Thu, 21 Jul 2011 17:28:43 +0100
Message-Id: <1311265730-5324-2-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1311265730-5324-1-git-send-email-mgorman@suse.de>
References: <1311265730-5324-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mel Gorman <mel@csn.ul.ie>

When kswapd is failing to keep zones above the min watermark, a process
will enter direct reclaim in the same manner kswapd does. If a dirty
page is encountered during the scan, this page is written to backing
storage using mapping->writepage.

This causes two problems. First, it can result in very deep call
stacks, particularly if the target storage or filesystem are complex.
Some filesystems ignore write requests from direct reclaim as a result.
The second is that a single-page flush is inefficient in terms of IO.
While there is an expectation that the elevator will merge requests,
this does not always happen. Quoting Christoph Hellwig;

	The elevator has a relatively small window it can operate on,
	and can never fix up a bad large scale writeback pattern.

This patch prevents direct reclaim writing back filesystem pages by
checking if current is kswapd. Anonymous pages are still written to
swap as there is not the equivalent of a flusher thread for anonymous
pages. If the dirty pages cannot be written back, they are placed
back on the LRU lists. There is now a direct dependency on dirty page
balancing to prevent too many pages in the system being dirtied which
would prevent reclaim making forward progress.

Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 include/linux/mmzone.h |    1 +
 mm/vmscan.c            |    9 +++++++++
 mm/vmstat.c            |    1 +
 3 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 9f7c3eb..b70a0c0 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -100,6 +100,7 @@ enum zone_stat_item {
 	NR_UNSTABLE_NFS,	/* NFS unstable pages */
 	NR_BOUNCE,
 	NR_VMSCAN_WRITE,
+	NR_VMSCAN_WRITE_SKIP,
 	NR_WRITEBACK_TEMP,	/* Writeback using temporary buffers */
 	NR_ISOLATED_ANON,	/* Temporary isolated pages from anon lru */
 	NR_ISOLATED_FILE,	/* Temporary isolated pages from file lru */
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 5ed24b9..ee00c94 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -825,6 +825,15 @@ static unsigned long shrink_page_list(struct list_head *page_list,
 		if (PageDirty(page)) {
 			nr_dirty++;
 
+			/*
+			 * Only kswapd can writeback filesystem pages to
+			 * avoid risk of stack overflow
+			 */
+			if (page_is_file_cache(page) && !current_is_kswapd()) {
+				inc_zone_page_state(page, NR_VMSCAN_WRITE_SKIP);
+				goto keep_locked;
+			}
+
 			if (references == PAGEREF_RECLAIM_CLEAN)
 				goto keep_locked;
 			if (!may_enter_fs)
diff --git a/mm/vmstat.c b/mm/vmstat.c
index 20c18b7..fd109f3 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -702,6 +702,7 @@ const char * const vmstat_text[] = {
 	"nr_unstable",
 	"nr_bounce",
 	"nr_vmscan_write",
+	"nr_vmscan_write_skip",
 	"nr_writeback_temp",
 	"nr_isolated_anon",
 	"nr_isolated_file",
-- 
1.7.3.4

