Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755713Ab1DPOFE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Apr 2011 10:05:04 -0400
Received: from mga11.intel.com ([192.55.52.93]:2530 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753925Ab1DPODg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Apr 2011 10:03:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,223,1301900400"; 
   d="scan'208";a="910491965"
Message-Id: <20110416134333.047784214@intel.com>
User-Agent: quilt/0.48-1
Date: Sat, 16 Apr 2011 21:25:51 +0800
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
CC: Vivek Goyal <vgoyal@redhat.com>
CC: Andrea Righi <arighi@develer.com>
CC: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: linux-mm <linux-mm@kvack.org>
Cc: <linux-fsdevel@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 05/12] writeback: smoothed dirty threshold and limit
References: <20110416132546.765212221@intel.com>
Content-Disposition: inline; filename=writeback-dirty-thresh-limit.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Both the global/bdi dirty thresholds may fluctuate undesirably.

- the start of a heavy weight application (ie. KVM) may instantly knock
  down determine_dirtyable_memory() and hence the global/bdi dirty thresholds.

- in JBOD setup, the bdi dirty thresholds are observed to fluctuate more

So maintain a version of smoothed bdi dirty threshold in
bdi->dirty_threshold and introduce the global dirty limit in
default_backing_dev_info.dirty_threshold.

The global limit can effectively mask out the impact of sudden drop of
dirtyable memory.  Without it, the dirtier tasks may be blocked in the
block area for 10s after someone eats 500MB memory; with the limit, the
dirtier tasks will be throttled at eg. 1/8 => 1/4 => 1/2 => original
dirty bandwith by the main control line and bring down the dirty pages
at reasonable speeds.

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 include/linux/backing-dev.h |    2 +
 include/linux/writeback.h   |   38 ++++++++++++++++++++++++++++
 mm/backing-dev.c            |    1 
 mm/page-writeback.c         |   45 ++++++++++++++++++++++++++++++++++
 4 files changed, 86 insertions(+)

--- linux-next.orig/include/linux/writeback.h	2011-04-16 17:53:50.000000000 +0800
+++ linux-next/include/linux/writeback.h	2011-04-16 17:54:02.000000000 +0800
@@ -12,6 +12,44 @@ struct backing_dev_info;
 extern spinlock_t inode_wb_list_lock;
 
 /*
+ * 4MB minimal write chunk size
+ */
+#define MIN_WRITEBACK_PAGES	(4096UL >> (PAGE_CACHE_SHIFT - 10))
+
+/*
+ * The 1/4 region under the global dirty thresh is for smooth dirty throttling:
+ *
+ *		(thresh - thresh/DIRTY_FULL_SCOPE, thresh)
+ *
+ * The 1/8 region under the global dirty limit will be more rigidly throttled:
+ *
+ *		(limit - limit/DIRTY_BRAKE, limit)
+ *
+ * The 1/16 region above the global dirty limit will be put to maximum pauses:
+ *
+ *		(limit, limit + limit/DIRTY_MAXPAUSE)
+ *
+ * The 1/16 region above the max-pause region, dirty exceeded bdi's will be put
+ * to loops:
+ *
+ *		(limit + limit/DIRTY_MAXPAUSE, limit + limit/DIRTY_PASSGOOD)
+ *
+ * Further beyond, all dirtier tasks will enter a loop waiting (possibly long
+ * time) for the dirty pages to drop.
+ *
+ * The global dirty threshold is normally at the low bound of the brake region,
+ * except when the system suddenly allocates a lot of anonymous memory and
+ * knocks down the global dirty threshold quickly, in which case the global
+ * dirty limit will follow down slowly to prevent livelocking all dirtier tasks.
+ */
+#define DIRTY_RAMPUP		32
+#define DIRTY_SCOPE		8
+#define DIRTY_FULL_SCOPE	(DIRTY_SCOPE / 2)
+#define DIRTY_BRAKE		8
+#define DIRTY_MAXPAUSE		16
+#define DIRTY_PASSGOOD		8
+
+/*
  * fs/fs-writeback.c
  */
 enum writeback_sync_modes {
--- linux-next.orig/mm/page-writeback.c	2011-04-16 17:54:01.000000000 +0800
+++ linux-next/mm/page-writeback.c	2011-04-16 17:54:02.000000000 +0800
@@ -562,6 +562,49 @@ static void __bdi_update_write_bandwidth
 	bdi->avg_write_bandwidth = avg;
 }
 
+static void update_dirty_limit(unsigned long thresh,
+			       unsigned long dirty)
+{
+	unsigned long limit = default_backing_dev_info.dirty_threshold;
+	unsigned long min = dirty + limit / DIRTY_BRAKE;
+
+	thresh += thresh / DIRTY_BRAKE;
+
+	if (limit < thresh) {
+		limit = thresh;
+		goto update;
+	}
+
+	/* take care not to follow into the brake area */
+	if (limit > thresh &&
+	    limit > min) {
+		limit -= (limit - max(thresh, min)) >> 5;
+		goto update;
+	}
+	return;
+update:
+	default_backing_dev_info.dirty_threshold = limit;
+}
+
+static void bdi_update_dirty_threshold(struct backing_dev_info *bdi,
+				       unsigned long thresh,
+				       unsigned long dirty)
+{
+	unsigned long old = bdi->old_dirty_threshold;
+	unsigned long avg = bdi->dirty_threshold;
+
+	thresh = bdi_dirty_limit(bdi, thresh);
+
+	if (avg > old && old >= thresh)
+		avg -= (avg - old) >> 3;
+
+	if (avg < old && old <= thresh)
+		avg += (old - avg) >> 3;
+
+	bdi->dirty_threshold = avg;
+	bdi->old_dirty_threshold = thresh;
+}
+
 void bdi_update_bandwidth(struct backing_dev_info *bdi,
 			  unsigned long thresh,
 			  unsigned long dirty,
@@ -595,10 +638,12 @@ void bdi_update_bandwidth(struct backing
 
 	if (thresh &&
 	    now - default_backing_dev_info.bw_time_stamp >= HZ / 5) {
+		update_dirty_limit(thresh, dirty);
 		bdi_update_dirty_smooth(&default_backing_dev_info, dirty);
 		default_backing_dev_info.bw_time_stamp = now;
 	}
 	if (thresh) {
+		bdi_update_dirty_threshold(bdi, thresh, dirty);
 		bdi_update_dirty_smooth(bdi, bdi_dirty);
 	}
 	__bdi_update_write_bandwidth(bdi, elapsed, written);
--- linux-next.orig/include/linux/backing-dev.h	2011-04-16 17:54:01.000000000 +0800
+++ linux-next/include/linux/backing-dev.h	2011-04-16 17:54:02.000000000 +0800
@@ -79,6 +79,8 @@ struct backing_dev_info {
 	unsigned long avg_write_bandwidth;
 	unsigned long avg_dirty;
 	unsigned long old_dirty;
+	unsigned long dirty_threshold;
+	unsigned long old_dirty_threshold;
 
 	struct prop_local_percpu completions;
 	int dirty_exceeded;
--- linux-next.orig/mm/backing-dev.c	2011-04-16 17:54:01.000000000 +0800
+++ linux-next/mm/backing-dev.c	2011-04-16 17:54:02.000000000 +0800
@@ -671,6 +671,7 @@ int bdi_init(struct backing_dev_info *bd
 
 	bdi->avg_dirty = 0;
 	bdi->old_dirty = 0;
+	bdi->dirty_threshold = MIN_WRITEBACK_PAGES;
 
 	err = prop_local_init_percpu(&bdi->completions);
 


