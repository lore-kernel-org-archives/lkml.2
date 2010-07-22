Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757856Ab0GVGUS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 02:20:18 -0400
Received: from mga01.intel.com ([192.55.52.88]:18735 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753204Ab0GVGTc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 02:19:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,241,1278313200"; 
   d="scan'208";a="588555497"
Message-Id: <20100722061823.050523298@intel.com>
User-Agent: quilt/0.48-1
Date: Thu, 22 Jul 2010 13:09:33 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: Dave Chinner <david@fromorbit.com>, Wu Fengguang <fengguang.wu@intel.com>
CC: Christoph Hellwig <hch@infradead.org>
CC: Mel Gorman <mel@csn.ul.ie>
CC: Chris Mason <chris.mason@oracle.com>
CC: Jens Axboe <jens.axboe@oracle.com>
Cc: LKML <linux-kernel@vger.kernel.org>
CC: linux-fsdevel@vger.kernel.org
CC: linux-mm@kvack.org
Subject: [PATCH 5/6] writeback: try more writeback as long as something was written
References: <20100722050928.653312535@intel.com>
Content-Disposition: inline; filename=writeback-background-retry.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

writeback_inodes_wb()/__writeback_inodes_sb() are not agressive in that
they only populate b_io when necessary at entrance time. When the queued
set of inodes are all synced, they just return, possibly with
wbc.nr_to_write > 0.

For kupdate and background writeback, there may be more eligible inodes
sitting in b_dirty when the current set of b_io inodes are completed. So
it is necessary to try another round of writeback as long as we made some
progress in this round. When there are no more eligible inodes, no more
inodes will be enqueued in queue_io(), hence nothing could/will be
synced and we may safely bail.

This will livelock sync when there are heavy dirtiers. However in that case
sync will already be livelocked w/o this patch, as the current livelock
avoidance code is virtually a no-op (for one thing, wb_time should be
set statically at sync start time and be used in move_expired_inodes()).
The sync livelock problem will be addressed in other patches.

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 fs/fs-writeback.c |   19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

--- linux-next.orig/fs/fs-writeback.c	2010-07-22 13:07:51.000000000 +0800
+++ linux-next/fs/fs-writeback.c	2010-07-22 13:07:54.000000000 +0800
@@ -640,20 +640,23 @@ static long wb_writeback(struct bdi_writ
 		wrote += MAX_WRITEBACK_PAGES - wbc.nr_to_write;
 
 		/*
-		 * If we consumed everything, see if we have more
+		 * Did we write something? Try for more
+		 *
+		 * This is needed _before_ the b_more_io test because the
+		 * background writeback moves inodes to b_io and works on
+		 * them in batches (in order to sync old pages first).  The
+		 * completion of the current batch does not necessarily mean
+		 * the overall work is done.
 		 */
-		if (wbc.nr_to_write <= 0)
+		if (wbc.nr_to_write < MAX_WRITEBACK_PAGES)
 			continue;
+
 		/*
-		 * Didn't write everything and we don't have more IO, bail
+		 * Nothing written and no more inodes for IO, bail
 		 */
 		if (list_empty(&wb->b_more_io))
 			break;
-		/*
-		 * Did we write something? Try for more
-		 */
-		if (wbc.nr_to_write < MAX_WRITEBACK_PAGES)
-			continue;
+
 		/*
 		 * Nothing written. Wait for some inode to
 		 * become available for writeback. Otherwise


