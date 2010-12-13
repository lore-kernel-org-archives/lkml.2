Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758187Ab0LMPR1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 10:17:27 -0500
Received: from mga01.intel.com ([192.55.52.88]:50490 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751227Ab0LMPIs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 10:08:48 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,336,1288594800"; 
   d="scan'208";a="635822651"
Message-Id: <20101213150328.284979629@intel.com>
User-Agent: quilt/0.48-1
Date: Mon, 13 Dec 2010 22:47:02 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: Jan Kara <jack@suse.cz>, Dave Chinner <david@fromorbit.com>,
        Wu Fengguang <fengguang.wu@intel.com>
CC: Christoph Hellwig <hch@lst.de>
CC: Trond Myklebust <Trond.Myklebust@netapp.com>
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
Subject: [PATCH 16/35] writeback: increase min pause time on concurrent dirtiers
References: <20101213144646.341970461@intel.com>
Content-Disposition: inline; filename=writeback-min-pause-time-for-concurrent-dirtiers.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Target for >60ms pause time when there are 100+ heavy dirtiers per bdi.
(will average around 100ms given 200ms max pause time)

It's OK for 1 dd task doing 100MB/s to be throttle paused 100 times per
second.  However when there are 100 tasks writing to the same disk,
That sums up to 100*100 balance_dirty_pages() calls per second and may
lead to massive cacheline bouncing on accessing the global page states
in NUMA machines.  Even in single socket boxes, we easily see >10% CPU
time reduction by increasing the pause time.

CC: Dave Chinner <david@fromorbit.com>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 mm/page-writeback.c |   23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

--- linux-next.orig/mm/page-writeback.c	2010-12-13 21:46:16.000000000 +0800
+++ linux-next/mm/page-writeback.c	2010-12-13 21:46:16.000000000 +0800
@@ -659,6 +659,27 @@ static unsigned long max_pause(unsigned 
 }
 
 /*
+ * Scale up pause time for concurrent dirtiers in order to reduce CPU overheads.
+ * But ensure reasonably large [min_pause, max_pause] range size, so that
+ * nr_dirtied_pause (and hence future pause time) can stay reasonably stable.
+ */
+static unsigned long min_pause(struct backing_dev_info *bdi,
+			       unsigned long max)
+{
+	unsigned long hi = ilog2(bdi->write_bandwidth);
+	unsigned long lo = ilog2(bdi->throttle_bandwidth);
+	unsigned long t;
+
+	if (lo >= hi)
+		return 1;
+
+	/* (N * 10ms) on 2^N concurrent tasks */
+	t = (hi - lo) * (10 * HZ) / 1024;
+
+	return clamp_val(t, 1, max / 2);
+}
+
+/*
  * balance_dirty_pages() must be called by processes which are generating dirty
  * data.  It looks at the number of dirty pages in the machine and will force
  * the caller to perform writeback if the system is over `vm_dirty_ratio'.
@@ -798,7 +819,7 @@ pause:
 
 	if (pause == 0 && nr_dirty < background_thresh)
 		current->nr_dirtied_pause = ratelimit_pages(bdi);
-	else if (pause == 1)
+	else if (pause <= min_pause(bdi, pause_max))
 		current->nr_dirtied_pause += current->nr_dirtied_pause / 32 + 1;
 	else if (pause >= pause_max)
 		/*


