Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756251Ab1F2PLY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 11:11:24 -0400
Received: from mga09.intel.com ([134.134.136.24]:4262 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754704Ab1F2PJF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 11:09:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,443,1304319600"; 
   d="scan'208";a="19718759"
Message-Id: <20110629145554.419192597@intel.com>
User-Agent: quilt/0.48-1
Date: Wed, 29 Jun 2011 22:52:52 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: <linux-fsdevel@vger.kernel.org>
CC: Jan Kara <jack@suse.cz>, Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Wu Fengguang <fengguang.wu@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 7/9] writeback: introduce max-pause and pass-good dirty limits
References: <20110629145245.835998321@intel.com>
Content-Disposition: inline; filename=writeback-dirty-limits
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The max-pause limit helps to keep the sleep time inside
balance_dirty_pages() within MAX_PAUSE=200ms. The 200ms max sleep means
per task rate limit of 8pages/200ms=160KB/s when dirty exceeded, which
normally is enough to stop dirtiers from continue pushing the dirty
pages high, unless there are a sufficient large number of slow dirtiers
(eg. 500 tasks doing 160KB/s will still sum up to 80MB/s, exceeding the
write bandwidth of a slow disk and hence accumulating more and more dirty
pages).

The pass-good limit helps to let go of the good bdi's in the presence of
a blocked bdi (ie. NFS server not responding) or slow USB disk which for
some reason build up a large number of initial dirty pages that refuse
to go away anytime soon.

For example, given two bdi's A and B and the initial state

	bdi_thresh_A = dirty_thresh / 2
	bdi_thresh_B = dirty_thresh / 2
	bdi_dirty_A  = dirty_thresh / 2
	bdi_dirty_B  = dirty_thresh / 2

Then A get blocked, after a dozen seconds

	bdi_thresh_A = 0
	bdi_thresh_B = dirty_thresh
	bdi_dirty_A  = dirty_thresh / 2
	bdi_dirty_B  = dirty_thresh / 2

The (bdi_dirty_B < bdi_thresh_B) test is now useless and the dirty pages
will be effectively throttled by condition (nr_dirty < dirty_thresh).
This has two problems:
(1) we lose the protections for light dirtiers
(2) balance_dirty_pages() effectively becomes IO-less because the
    (bdi_nr_reclaimable > bdi_thresh) test won't be true. This is good
    for IO, but balance_dirty_pages() loses an important way to break
    out of the loop which leads to more spread out throttle delays.

DIRTY_PASSGOOD_AREA can eliminate the above issues. The only problem is,
DIRTY_PASSGOOD_AREA needs to be defined as 2 to fully cover the above
example while this patch uses the more conservative value 8 so as not to
surprise people with too many dirty pages than expected.

The max-pause limit won't noticeably impact the speed dirty pages are
knocked down when there is a sudden drop of global/bdi dirty thresholds.
Because the heavy dirties will be throttled below 160KB/s which is slow
enough. It does help to avoid long dirty throttle delays and especially
will make light dirtiers more responsive.

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 include/linux/writeback.h |   21 +++++++++++++++++++++
 mm/page-writeback.c       |   28 ++++++++++++++++++++++++++++
 2 files changed, 49 insertions(+)

--- linux-next.orig/include/linux/writeback.h	2011-06-23 10:31:40.000000000 +0800
+++ linux-next/include/linux/writeback.h	2011-06-23 10:31:40.000000000 +0800
@@ -7,6 +7,27 @@
 #include <linux/sched.h>
 #include <linux/fs.h>
 
+/*
+ * The 1/16 region above the global dirty limit will be put to maximum pauses:
+ *
+ *	(limit, limit + limit/DIRTY_MAXPAUSE_AREA)
+ *
+ * The 1/16 region above the max-pause region, dirty exceeded bdi's will be put
+ * to loops:
+ *
+ *	(limit + limit/DIRTY_MAXPAUSE_AREA, limit + limit/DIRTY_PASSGOOD_AREA)
+ *
+ * Further beyond, all dirtier tasks will enter a loop waiting (possibly long
+ * time) for the dirty pages to drop, unless written enough pages.
+ *
+ * The global dirty threshold is normally equal to the global dirty limit,
+ * except when the system suddenly allocates a lot of anonymous memory and
+ * knocks down the global dirty threshold quickly, in which case the global
+ * dirty limit will follow down slowly to prevent livelocking all dirtier tasks.
+ */
+#define DIRTY_MAXPAUSE_AREA		16
+#define DIRTY_PASSGOOD_AREA		8
+
 struct backing_dev_info;
 
 /*
--- linux-next.orig/mm/page-writeback.c	2011-06-23 10:31:40.000000000 +0800
+++ linux-next/mm/page-writeback.c	2011-06-23 10:59:47.000000000 +0800
@@ -399,6 +399,11 @@ unsigned long determine_dirtyable_memory
 	return x + 1;	/* Ensure that we never return 0 */
 }
 
+static unsigned long hard_dirty_limit(unsigned long thresh)
+{
+	return max(thresh, global_dirty_limit);
+}
+
 /*
  * global_dirty_limits - background-writeback and dirty-throttling thresholds
  *
@@ -716,6 +721,29 @@ static void balance_dirty_pages(struct a
 		io_schedule_timeout(pause);
 		trace_balance_dirty_wait(bdi);
 
+		dirty_thresh = hard_dirty_limit(dirty_thresh);
+		/*
+		 * max-pause area. If dirty exceeded but still within this
+		 * area, no need to sleep for more than 200ms: (a) 8 pages per
+		 * 200ms is typically more than enough to curb heavy dirtiers;
+		 * (b) the pause time limit makes the dirtiers more responsive.
+		 */
+		if (nr_dirty < dirty_thresh +
+			       dirty_thresh / DIRTY_MAXPAUSE_AREA &&
+		    time_after(jiffies, start_time + MAX_PAUSE))
+			break;
+		/*
+		 * pass-good area. When some bdi gets blocked (eg. NFS server
+		 * not responding), or write bandwidth dropped dramatically due
+		 * to concurrent reads, or dirty threshold suddenly dropped and
+		 * the dirty pages cannot be brought down anytime soon (eg. on
+		 * slow USB stick), at least let go of the good bdi's.
+		 */
+		if (nr_dirty < dirty_thresh +
+			       dirty_thresh / DIRTY_PASSGOOD_AREA &&
+		    bdi_dirty < bdi_thresh)
+			break;
+
 		/*
 		 * Increase the delay for each loop, up to our previous
 		 * default of taking a 100ms nap.


