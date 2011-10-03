Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756109Ab1JCNr7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 09:47:59 -0400
Received: from mga03.intel.com ([143.182.124.21]:61846 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755901Ab1JCNp5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 09:45:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,479,1312182000"; 
   d="scan'208";a="58158721"
Message-Id: <20111003134536.476978798@intel.com>
User-Agent: quilt/0.48-1
Date: Mon, 03 Oct 2011 21:42:31 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
to: <linux-fsdevel@vger.kernel.org>
cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Wu Fengguang <fengguang.wu@intel.com>
cc: Andrew Morton <akpm@linux-foundation.org>
CC: Jan Kara <jack@suse.cz>
CC: Christoph Hellwig <hch@lst.de>
CC: Dave Chinner <david@fromorbit.com>
CC: Greg Thelen <gthelen@google.com>
CC: Minchan Kim <minchan.kim@gmail.com>
CC: Vivek Goyal <vgoyal@redhat.com>
CC: Andrea Righi <arighi@develer.com>
Cc: linux-mm <linux-mm@kvack.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 03/11] writeback: add bg_threshold parameter to __bdi_update_bandwidth()
References: <20111003134228.090592370@intel.com>
Content-Disposition: inline; filename=writeback-interface-add-bg_thresh
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No behavior change.

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 fs/fs-writeback.c         |    2 +-
 include/linux/writeback.h |    1 +
 mm/page-writeback.c       |   11 +++++++----
 3 files changed, 9 insertions(+), 5 deletions(-)

--- linux-next.orig/mm/page-writeback.c	2011-10-03 20:44:55.000000000 +0800
+++ linux-next/mm/page-writeback.c	2011-10-03 20:46:17.000000000 +0800
@@ -779,6 +779,7 @@ static void global_update_bandwidth(unsi
 
 void __bdi_update_bandwidth(struct backing_dev_info *bdi,
 			    unsigned long thresh,
+			    unsigned long bg_thresh,
 			    unsigned long dirty,
 			    unsigned long bdi_thresh,
 			    unsigned long bdi_dirty,
@@ -815,6 +816,7 @@ snapshot:
 
 static void bdi_update_bandwidth(struct backing_dev_info *bdi,
 				 unsigned long thresh,
+				 unsigned long bg_thresh,
 				 unsigned long dirty,
 				 unsigned long bdi_thresh,
 				 unsigned long bdi_dirty,
@@ -823,8 +825,8 @@ static void bdi_update_bandwidth(struct 
 	if (time_is_after_eq_jiffies(bdi->bw_time_stamp + BANDWIDTH_INTERVAL))
 		return;
 	spin_lock(&bdi->wb.list_lock);
-	__bdi_update_bandwidth(bdi, thresh, dirty, bdi_thresh, bdi_dirty,
-			       start_time);
+	__bdi_update_bandwidth(bdi, thresh, bg_thresh, dirty,
+			       bdi_thresh, bdi_dirty, start_time);
 	spin_unlock(&bdi->wb.list_lock);
 }
 
@@ -912,8 +914,9 @@ static void balance_dirty_pages(struct a
 		if (!bdi->dirty_exceeded)
 			bdi->dirty_exceeded = 1;
 
-		bdi_update_bandwidth(bdi, dirty_thresh, nr_dirty,
-				     bdi_thresh, bdi_dirty, start_time);
+		bdi_update_bandwidth(bdi, dirty_thresh, background_thresh,
+				     nr_dirty, bdi_thresh, bdi_dirty,
+				     start_time);
 
 		/* Note: nr_reclaimable denotes nr_dirty + nr_unstable.
 		 * Unstable writes are a feature of certain networked
--- linux-next.orig/fs/fs-writeback.c	2011-10-03 20:44:51.000000000 +0800
+++ linux-next/fs/fs-writeback.c	2011-10-03 20:45:27.000000000 +0800
@@ -675,7 +675,7 @@ static inline bool over_bground_thresh(v
 static void wb_update_bandwidth(struct bdi_writeback *wb,
 				unsigned long start_time)
 {
-	__bdi_update_bandwidth(wb->bdi, 0, 0, 0, 0, start_time);
+	__bdi_update_bandwidth(wb->bdi, 0, 0, 0, 0, 0, start_time);
 }
 
 /*
--- linux-next.orig/include/linux/writeback.h	2011-10-03 20:44:51.000000000 +0800
+++ linux-next/include/linux/writeback.h	2011-10-03 20:45:27.000000000 +0800
@@ -143,6 +143,7 @@ unsigned long bdi_dirty_limit(struct bac
 
 void __bdi_update_bandwidth(struct backing_dev_info *bdi,
 			    unsigned long thresh,
+			    unsigned long bg_thresh,
 			    unsigned long dirty,
 			    unsigned long bdi_thresh,
 			    unsigned long bdi_dirty,


