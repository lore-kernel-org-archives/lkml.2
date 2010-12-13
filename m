Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932337Ab0LMGzn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 01:55:43 -0500
Received: from mga02.intel.com ([134.134.136.20]:4695 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754407Ab0LMGtn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 01:49:43 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,335,1288594800"; 
   d="scan'208";a="583111649"
Message-Id: <20101213064840.410471655@intel.com>
User-Agent: quilt/0.48-1
Date: Mon, 13 Dec 2010 14:43:17 +0800
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
Subject: [PATCH 28/47] writeback: bdi base throttle bandwidth
References: <20101213064249.648862451@intel.com>
Content-Disposition: inline; filename=writeback-bw-for-concurrent-dirtiers.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This basically does

-	task_bw = linear_function(task_weight, bdi_dirty, bdi->write_bandwidth)
+	task_bw = linear_function(task_weight, bdi_dirty, bdi->throttle_bandwidth)

where
                                    adapt to
	bdi->throttle_bandwidth ================> bdi->write_bandwidth / N
	                        stabilize around

	N = number of concurrent heavy dirtier tasks
	    (light dirtiers will have little effect)

It offers two great benefits:

1) in many configurations (eg. NFS), bdi->write_bandwidth fluctuates a lot
   (more than 100%) by nature. bdi->throttle_bandwidth will be much more
   stable.  It will normally be a flat line in the time-bw graph.

2) bdi->throttle_bandwidth will be close to the final task_bw in stable state.
   In contrast, bdi->write_bandwidth is N times larger than task_bw.
   Given N=4, bdi_dirty will float around A before patch, and we want it
   stabilize around B by lowering the slope of the control line, so that
   when bdi_dirty fluctuates for the same delta (to points A'/B'), the
   corresponding fluctuation of task_bw is reduced to 1/4. The benefit
   is obvious: when there are 1000 concurrent dirtiers, the fluctuations
   quickly go out of control; with this patch, the max fluctuations
   virtually are the same as the single dirtier case. In this way, the
   control system can scale to whatever huge number of dirtiers.

fig.1 before patch

               bdi->write_bandwidth   ........o
                                               o
                                                o
                                                 o
                                                  o
                                                   o
                                                    o
                                                     o
                                                      o
                                                       o
                                                        o
                                                         o
   task_bw = bdi->write_bandwidth / 4 ....................o
                                                          |o
                                                          | o
                                                          |  o <= A'
----------------------------------------------------------+---o
                                                          A   C

fig.2 after patch

task_bw = bdi->throttle_bandwidth     ........o
        = bdi->write_bandwidth / 4            |   o <= B'
                                              |       o
                                              |           o
----------------------------------------------+---------------o
                                              B               C

The added complexity is, it will take some time for
bdi->throttle_bandwidth to adapt to the workload:

- 2 seconds to scale to 10 times more dirtier tasks
- 10 seconds to 10 times less dirtier tasks

The slower adapt time to reduced tasks is not a big problem. Because
the control line is not linear. At worst, bdi_dirty will drop below the
15% throttle threshold where the tasks won't be throttled at all.

When the system has dirtiers of different speed, bdi->throttle_bandwidth
will adapt to around the most fast speed.

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 include/linux/backing-dev.h |    1 
 mm/backing-dev.c            |    1 
 mm/page-writeback.c         |   42 +++++++++++++++++++++++++++++++++-
 3 files changed, 43 insertions(+), 1 deletion(-)

--- linux-next.orig/include/linux/backing-dev.h	2010-12-09 11:50:58.000000000 +0800
+++ linux-next/include/linux/backing-dev.h	2010-12-09 12:01:39.000000000 +0800
@@ -78,6 +78,7 @@ struct backing_dev_info {
 	unsigned long bw_time_stamp;
 	unsigned long written_stamp;
 	unsigned long write_bandwidth;
+	unsigned long throttle_bandwidth;
 
 	struct prop_local_percpu completions;
 	int dirty_exceeded;
--- linux-next.orig/mm/page-writeback.c	2010-12-09 12:00:53.000000000 +0800
+++ linux-next/mm/page-writeback.c	2010-12-09 12:01:39.000000000 +0800
@@ -528,6 +528,45 @@ out:
 	return 1 + int_sqrt(dirty_thresh - dirty_pages);
 }
 
+/*
+ * The bdi throttle bandwidth is introduced for resisting bdi_dirty from
+ * getting too close to task_thresh. It allows scaling up to 1000+ concurrent
+ * dirtier tasks while keeping the fluctuation level flat.
+ */
+static void __bdi_update_throttle_bandwidth(struct backing_dev_info *bdi,
+					    unsigned long dirty,
+					    unsigned long thresh)
+{
+	unsigned long gap = thresh / TASK_SOFT_DIRTY_LIMIT + 1;
+	unsigned long bw = bdi->throttle_bandwidth;
+
+	if (dirty > thresh)
+		return;
+
+	/* adapt to concurrent dirtiers */
+	if (dirty > thresh - gap) {
+		bw -= bw >> (3 + 4 * (thresh - dirty) / gap);
+		goto out;
+	}
+
+	/* adapt to one single dirtier */
+	if (dirty > thresh - gap * 2 + gap / 4 &&
+	    bw > bdi->write_bandwidth + bdi->write_bandwidth / 2) {
+		bw -= bw >> (3 + 4 * (thresh - dirty - gap) / gap);
+		goto out;
+	}
+
+	if (dirty <= thresh - gap * 2 - gap / 2 &&
+	    bw < bdi->write_bandwidth - bdi->write_bandwidth / 2) {
+		bw += (bw >> 4) + 1;
+		goto out;
+	}
+
+	return;
+out:
+	bdi->throttle_bandwidth = bw;
+}
+
 static void __bdi_update_write_bandwidth(struct backing_dev_info *bdi,
 					 unsigned long elapsed,
 					 unsigned long written)
@@ -570,6 +609,7 @@ void bdi_update_bandwidth(struct backing
 		goto unlock;
 
 	__bdi_update_write_bandwidth(bdi, elapsed, written);
+	__bdi_update_throttle_bandwidth(bdi, bdi_dirty, bdi_thresh);
 
 snapshot:
 	bdi->written_stamp = written;
@@ -680,7 +720,7 @@ static void balance_dirty_pages(struct a
 		 * close to task_thresh, and help reduce fluctuations of pause
 		 * time when there are lots of dirtiers.
 		 */
-		bw = bdi->write_bandwidth;
+		bw = bdi->throttle_bandwidth;
 		bw = bw * (bdi_thresh - bdi_dirty);
 		do_div(bw, bdi_thresh / BDI_SOFT_DIRTY_LIMIT + 1);
 
--- linux-next.orig/mm/backing-dev.c	2010-12-09 11:50:58.000000000 +0800
+++ linux-next/mm/backing-dev.c	2010-12-09 12:01:39.000000000 +0800
@@ -664,6 +664,7 @@ int bdi_init(struct backing_dev_info *bd
 
 	spin_lock_init(&bdi->bw_lock);
 	bdi->write_bandwidth = 100 << (20 - PAGE_SHIFT);  /* 100 MB/s */
+	bdi->throttle_bandwidth = 100 << (20 - PAGE_SHIFT);
 
 	bdi->dirty_exceeded = 0;
 	err = prop_local_init_percpu(&bdi->completions);


