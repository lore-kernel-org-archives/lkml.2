Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754225Ab1IDCOf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Sep 2011 22:14:35 -0400
Received: from mga03.intel.com ([143.182.124.21]:49417 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752899Ab1IDCN1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Sep 2011 22:13:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,326,1312182000"; 
   d="scan'208";a="45377077"
Message-Id: <20110904020916.329482509@intel.com>
User-Agent: quilt/0.48-1
Date: Sun, 04 Sep 2011 09:53:18 +0800
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
Subject: [PATCH 13/18] writeback: limit max dirty pause time
References: <20110904015305.367445271@intel.com>
Content-Disposition: inline; filename=max-pause
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Apply two policies to scale down the max pause time for

1) small number of concurrent dirtiers
2) small memory system (comparing to storage bandwidth)

MAX_PAUSE=200ms may only be suitable for high end servers with lots of
concurrent dirtiers, where the large pause time can reduce much overheads.

Otherwise, smaller pause time is desirable whenever possible, so as to
get good responsiveness and smooth user experiences. It's actually
required for good disk utilization in the case when all the dirty pages
can be synced to disk within MAX_PAUSE=200ms.

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 mm/page-writeback.c |   45 +++++++++++++++++++++++++++++++++++++++---
 1 file changed, 42 insertions(+), 3 deletions(-)

--- linux-next.orig/mm/page-writeback.c	2011-09-01 09:43:38.000000000 +0800
+++ linux-next/mm/page-writeback.c	2011-09-01 09:43:39.000000000 +0800
@@ -976,6 +976,42 @@ static unsigned long dirty_poll_interval
 	return 1;
 }
 
+static unsigned long bdi_max_pause(struct backing_dev_info *bdi,
+				   unsigned long bdi_dirty)
+{
+	unsigned long hi = ilog2(bdi->write_bandwidth);
+	unsigned long lo = ilog2(bdi->dirty_ratelimit);
+	unsigned long t;
+
+	/* target for ~10ms pause on 1-dd case */
+	t = HZ / 50;
+
+	/*
+	 * Scale up pause time for concurrent dirtiers in order to reduce CPU
+	 * overheads.
+	 *
+	 * (N * 20ms) on 2^N concurrent tasks.
+	 */
+	if (hi > lo)
+		t += (hi - lo) * (20 * HZ) / 1024;
+
+	/*
+	 * Limit pause time for small memory systems. If sleeping for too long
+	 * time, a small pool of dirty/writeback pages may go empty and disk go
+	 * idle.
+	 *
+	 * 1ms for every 1MB; may further consider bdi bandwidth.
+	 */
+	if (bdi_dirty)
+		t = min(t, bdi_dirty >> (30 - PAGE_CACHE_SHIFT - ilog2(HZ)));
+
+	/*
+	 * The pause time will be settled within range (max_pause/4, max_pause).
+	 * Apply a minimal value of 4 to get a non-zero max_pause/4.
+	 */
+	return clamp_val(t, 4, MAX_PAUSE);
+}
+
 /*
  * balance_dirty_pages() must be called by processes which are generating dirty
  * data.  It looks at the number of dirty pages in the machine and will force
@@ -995,6 +1031,7 @@ static void balance_dirty_pages(struct a
 	unsigned long bdi_thresh;
 	long period;
 	long pause = 0;
+	long max_pause;
 	bool dirty_exceeded = false;
 	unsigned long task_ratelimit;
 	unsigned long dirty_ratelimit;
@@ -1079,13 +1116,15 @@ static void balance_dirty_pages(struct a
 		if (unlikely(!dirty_exceeded && bdi_async_underrun(bdi)))
 			break;
 
+		max_pause = bdi_max_pause(bdi, bdi_dirty);
+
 		dirty_ratelimit = bdi->dirty_ratelimit;
 		pos_ratio = bdi_position_ratio(bdi, dirty_thresh,
 					       background_thresh, nr_dirty,
 					       bdi_thresh, bdi_dirty);
 		if (unlikely(pos_ratio == 0)) {
-			period = MAX_PAUSE;
-			pause = MAX_PAUSE;
+			period = max_pause;
+			pause = max_pause;
 			goto pause;
 		}
 		task_ratelimit = (u64)dirty_ratelimit *
@@ -1122,7 +1161,7 @@ static void balance_dirty_pages(struct a
 			pause = 1; /* avoid resetting nr_dirtied_pause below */
 			break;
 		}
-		pause = min_t(long, pause, MAX_PAUSE);
+		pause = min(pause, max_pause);
 
 pause:
 		trace_balance_dirty_pages(bdi,


