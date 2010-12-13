Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758166Ab0LMPPz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 10:15:55 -0500
Received: from mga02.intel.com ([134.134.136.20]:36467 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750759Ab0LMPIt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 10:08:49 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,336,1288594800"; 
   d="scan'208";a="686646816"
Message-Id: <20101213150328.407612632@intel.com>
User-Agent: quilt/0.48-1
Date: Mon, 13 Dec 2010 22:47:03 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: Jan Kara <jack@suse.cz>, Wu Fengguang <fengguang.wu@intel.com>
CC: Christoph Hellwig <hch@lst.de>
CC: Trond Myklebust <Trond.Myklebust@netapp.com>
CC: Dave Chinner <david@fromorbit.com>
CC: "Theodore Ts'o" <tytso@mit.edu>
CC: Chris Mason <chris.mason@oracle.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Mel Gorman <mel@csn.ul.ie>
CC: Rik van Riel <riel@redhat.com>
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Greg Thelen <gthelen@google.com>
CC: Minchan Kim <minchan.kim@gmail.com>
Cc: linux-mm <linux-mm@kvack.org>
Cc: <linux-fsdevel@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 17/35] writeback: quit throttling when bdi dirty pages dropped low
References: <20101213144646.341970461@intel.com>
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

It will at least pause for one loop before trying to break out.

The break is designed mainly to help the single task case. The break
threshold is time for writing 125ms data, so that when the task slept
for MAX_PAUSE=200ms, it will have good chance to break out. For NFS
there may be only 1-2 completions of large COMMIT per second, in which
case the task may still get stuck for 1s.

Note that this opens the chance that during normal operation, a huge
number of slow dirtiers writing to a really slow device might manage to
outrun bdi_thresh. But the risk is pretty low.

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 mm/page-writeback.c |   19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

--- linux-next.orig/mm/page-writeback.c	2010-12-13 21:46:16.000000000 +0800
+++ linux-next/mm/page-writeback.c	2010-12-13 21:46:16.000000000 +0800
@@ -693,6 +693,7 @@ static void balance_dirty_pages(struct a
 	long nr_dirty;
 	long bdi_dirty;  /* = file_dirty + writeback + unstable_nfs */
 	long avg_dirty;  /* smoothed bdi_dirty */
+	long bdi_prev_dirty = 0;
 	unsigned long background_thresh;
 	unsigned long dirty_thresh;
 	unsigned long bdi_thresh;
@@ -749,6 +750,24 @@ static void balance_dirty_pages(struct a
 
 		bdi_update_bandwidth(bdi, start_time, bdi_dirty, bdi_thresh);
 
+		/*
+		 * bdi_thresh takes time to ramp up from the initial 0,
+		 * especially for slow devices.
+		 *
+		 * It's possible that at the moment dirty throttling starts,
+		 *	bdi_dirty = nr_dirty
+		 *		  = (background_thresh + dirty_thresh) / 2
+		 *		  >> bdi_thresh
+		 * Then the task could be blocked for many seconds to flush all
+		 * the exceeded (bdi_dirty - bdi_thresh) pages. So offer a
+		 * complementary way to break out of the loop when 125ms worth
+		 * of dirty pages have been cleaned during our pause time.
+		 */
+		if (nr_dirty <= dirty_thresh &&
+		    bdi_prev_dirty - bdi_dirty > (long)bdi->write_bandwidth / 8)
+			break;
+		bdi_prev_dirty = bdi_dirty;
+
 		avg_dirty = bdi->avg_dirty;
 		if (avg_dirty < bdi_dirty || avg_dirty > task_thresh)
 			avg_dirty = bdi_dirty;


