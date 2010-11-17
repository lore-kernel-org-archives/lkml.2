Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934251Ab0KQEbe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 23:31:34 -0500
Received: from mga11.intel.com ([192.55.52.93]:17287 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932962Ab0KQEba (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 23:31:30 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,209,1288594800"; 
   d="scan'208";a="627558218"
Message-Id: <20101117042850.599696225@intel.com>
User-Agent: quilt/0.48-1
Date: Wed, 17 Nov 2010 12:27:31 +0800
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
Subject: [PATCH 11/13] writeback: scale down max throttle bandwidth on concurrent dirtiers
References: <20101117042720.033773013@intel.com>
Content-Disposition: inline; filename=writeback-adaptive-throttle-bandwidth.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This will noticeably reduce the fluctuaions of pause time when there are
100+ concurrent dirtiers.

The more parallel dirtiers (1 dirtier => 4 dirtiers), the smaller
bandwidth each dirtier will share (bdi_bandwidth => bdi_bandwidth/4),
the less gap to the dirty limit ((C-A) => (C-B)), the less stable the
pause time will be (given the same fluctuation of bdi_dirty).

For example, if A drifts to A', its pause time may drift from 5ms to
6ms, while B to B' may drift from 50ms to 90ms.  It's much larger
fluctuations in relative ratio as well as absolute time.

Fig.1 before patch, gap (C-B) is too low to get smooth pause time

throttle_bandwidth_A = bdi_bandwidth .........o
                                              | o <= A'
                                              |   o
                                              |     o
                                              |       o
                                              |         o
throttle_bandwidth_B = bdi_bandwidth / 4 .....|...........o
                                              |           | o <= B'
----------------------------------------------+-----------+---o
                                              A           B   C

The solution is to lower the slope of the throttle line accordingly,
which makes B stabilize at some point more far away from C.

Fig.2 after patch

throttle_bandwidth_A = bdi_bandwidth .........o
                                              | o <= A'
                                              |   o
                                              |     o
    lowered max throttle bandwidth for B ===> *       o
                                              |   *     o
throttle_bandwidth_B = bdi_bandwidth / 4 .............*   o
                                              |       |   * o
----------------------------------------------+-------+-------o
                                              A       B       C

Note that C is actually different points for 1-dirty and 4-dirtiers
cases, but for easy graphing, we move them together.

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 mm/page-writeback.c |   16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

--- linux-next.orig/mm/page-writeback.c	2010-11-15 19:52:43.000000000 +0800
+++ linux-next/mm/page-writeback.c	2010-11-15 21:30:45.000000000 +0800
@@ -537,6 +537,7 @@ static void balance_dirty_pages(struct a
 	unsigned long background_thresh;
 	unsigned long dirty_thresh;
 	unsigned long bdi_thresh;
+	unsigned long task_thresh;
 	unsigned long bw;
 	unsigned long pause = 0;
 	bool dirty_exceeded = false;
@@ -566,7 +567,7 @@ static void balance_dirty_pages(struct a
 			break;
 
 		bdi_thresh = bdi_dirty_limit(bdi, dirty_thresh);
-		bdi_thresh = task_dirty_limit(current, bdi_thresh);
+		task_thresh = task_dirty_limit(current, bdi_thresh);
 
 		/*
 		 * In order to avoid the stacked BDI deadlock we need
@@ -605,14 +606,23 @@ static void balance_dirty_pages(struct a
 			break;
 		bdi_prev_dirty = bdi_dirty;
 
-		if (bdi_dirty >= bdi_thresh) {
+		if (bdi_dirty >= task_thresh) {
 			pause = HZ/10;
 			goto pause;
 		}
 
+		/*
+		 * When bdi_dirty grows closer to bdi_thresh, it indicates more
+		 * concurrent dirtiers. Proportionally lower the max throttle
+		 * bandwidth. This will resist bdi_dirty from approaching to
+		 * close to task_thresh, and help reduce fluctuations of pause
+		 * time when there are lots of dirtiers.
+		 */
 		bw = bdi->write_bandwidth;
-
 		bw = bw * (bdi_thresh - bdi_dirty);
+		bw = bw / (bdi_thresh / BDI_SOFT_DIRTY_LIMIT + 1);
+
+		bw = bw * (task_thresh - bdi_dirty);
 		bw = bw / (bdi_thresh / TASK_SOFT_DIRTY_LIMIT + 1);
 
 		pause = HZ * (pages_dirtied << PAGE_CACHE_SHIFT) / (bw + 1);


