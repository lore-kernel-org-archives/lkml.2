Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934365Ab0KQEdp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 23:33:45 -0500
Received: from mga09.intel.com ([134.134.136.24]:41568 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934203Ab0KQEbd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 23:31:33 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,209,1288594800"; 
   d="scan'208";a="678256138"
Message-Id: <20101117042850.245782303@intel.com>
User-Agent: quilt/0.48-1
Date: Wed, 17 Nov 2010 12:27:28 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: Jan Kara <jack@suse.cz>, Wu Fengguang <fengguang.wu@intel.com>
CC: Christoph Hellwig <hch@lst.de>
CC: Dave Chinner <david@fromorbit.com>
CC: "Theodore Ts'o" <tytso@mit.edu>
CC: Chris Mason <chris.mason@oracle.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Mel Gorman <mel@csn.ul.ie>
CC: Rik van Riel <riel@redhat.com>
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: linux-mm <linux-mm@kvack.org>
Cc: <linux-fsdevel@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 08/13] writeback: quit throttling when bdi dirty pages dropped low
References: <20101117042720.033773013@intel.com>
Content-Disposition: inline; filename=writeback-bdi-throttle-break.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tests show that bdi_thresh may take minutes to ramp up on a typical
desktop. The time should be improvable but cannot be eliminated totally.
So when (background_thresh + dirty_thresh)/2 is reached and
balance_dirty_pages() starts to throttle the task, it will suddenly find
the (still low and ramping up) bdi_thresh is exceeded _excessively_. Here
we definitely don't want to stall the task for one minute (when it's
writing to USB stick). So introduce an alternative way to break out of
the loop when the bdi dirty/write pages has dropped by a reasonable
amount.

When dirty_background_ratio is set close to dirty_ratio, bdi_thresh may
also be constantly exceeded due to the task_dirty_limit() gap. This is
addressed by another patch to lower the background threshold when
necessary.

It will take at least 100ms before trying to break out.

Note that this opens the chance that during normal operation, a huge
number of slow dirtiers writing to a really slow device might manage to
outrun bdi_thresh. But the risk is pretty low. It takes at least one
100ms sleep loop to break out, and the global limit is still enforced.

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 mm/page-writeback.c |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

--- linux-next.orig/mm/page-writeback.c	2010-11-15 12:52:34.000000000 +0800
+++ linux-next/mm/page-writeback.c	2010-11-15 13:08:16.000000000 +0800
@@ -526,6 +526,7 @@ static void balance_dirty_pages(struct a
 {
 	long nr_reclaimable;
 	long nr_dirty, bdi_dirty;  /* = file_dirty + writeback + unstable_nfs */
+	long bdi_prev_dirty = 0;
 	unsigned long background_thresh;
 	unsigned long dirty_thresh;
 	unsigned long bdi_thresh;
@@ -578,6 +579,25 @@ static void balance_dirty_pages(struct a
 				    bdi_stat(bdi, BDI_WRITEBACK);
 		}
 
+		/*
+		 * bdi_thresh takes time to ramp up from the initial 0,
+		 * especially for slow devices.
+		 *
+		 * It's possible that at the moment dirty throttling starts,
+		 * 	bdi_dirty = nr_dirty
+		 * 		  = (background_thresh + dirty_thresh) / 2
+		 * 		  >> bdi_thresh
+		 * Then the task could be blocked for a dozen second to flush
+		 * all the exceeded (bdi_dirty - bdi_thresh) pages. So offer a
+		 * complementary way to break out of the loop when 250ms worth
+		 * of dirty pages have been cleaned during our pause time.
+		 */
+		if (nr_dirty < dirty_thresh &&
+		    bdi_prev_dirty - bdi_dirty >
+		    bdi->write_bandwidth >> (PAGE_CACHE_SHIFT + 2))
+			break;
+		bdi_prev_dirty = bdi_dirty;
+
 		if (bdi_dirty >= bdi_thresh) {
 			pause = HZ/10;
 			goto pause;


