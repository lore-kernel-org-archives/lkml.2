Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754496Ab1FSP2H (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jun 2011 11:28:07 -0400
Received: from mga01.intel.com ([192.55.52.88]:2099 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754438Ab1FSP2C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jun 2011 11:28:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,389,1304319600"; 
   d="scan'208";a="20092982"
Message-Id: <20110619150510.367141119@intel.com>
User-Agent: quilt/0.48-1
Date: Sun, 19 Jun 2011 23:01:12 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
CC: Jan Kara <jack@suse.cz>, Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Wu Fengguang <fengguang.wu@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 4/7] writeback: introduce max-pause and pass-good dirty limits
References: <20110619150108.691351746@intel.com>
Content-Disposition: inline; filename=writeback-dirty-limits
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The max-pause limit helps to keep the sleep time inside
balance_dirty_pages() within 200ms. The 200ms max sleep means per task
rate limit of 8pages/200ms=160KB/s, which normally is enough to stop
dirtiers from continue pushing the dirty pages high, unless there are
a sufficient large number of slow dirtiers (ie. 500 tasks doing 160KB/s
will still sum up to 80MB/s, reaching the write bandwidth of a slow disk).

The pass-good limit helps to let go of the good bdi's in the presence of
a blocked bdi (ie. NFS server not responding) or slow USB disk which for
some reason build up a large number of initial dirty pages that refuse
to go away anytime soon.

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 include/linux/writeback.h |   21 +++++++++++++++++++++
 mm/page-writeback.c       |   13 +++++++++++++
 2 files changed, 34 insertions(+)

--- linux-next.orig/include/linux/writeback.h	2011-06-19 22:59:29.000000000 +0800
+++ linux-next/include/linux/writeback.h	2011-06-19 22:59:47.000000000 +0800
@@ -7,6 +7,27 @@
 #include <linux/sched.h>
 #include <linux/fs.h>
 
+/*
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
+ * time) for the dirty pages to drop, unless written enough pages.
+ *
+ * The global dirty threshold is normally equal to the global dirty limit,
+ * except when the system suddenly allocates a lot of anonymous memory and
+ * knocks down the global dirty threshold quickly, in which case the global
+ * dirty limit will follow down slowly to prevent livelocking all dirtier tasks.
+ */
+#define DIRTY_MAXPAUSE		16
+#define DIRTY_PASSGOOD		8
+
 struct backing_dev_info;
 
 /*
--- linux-next.orig/mm/page-writeback.c	2011-06-19 22:59:29.000000000 +0800
+++ linux-next/mm/page-writeback.c	2011-06-19 22:59:47.000000000 +0800
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
@@ -704,6 +709,14 @@ static void balance_dirty_pages(struct a
 		__set_current_state(TASK_UNINTERRUPTIBLE);
 		io_schedule_timeout(pause);
 
+		dirty_thresh = hard_dirty_limit(dirty_thresh);
+		if (nr_dirty < dirty_thresh + dirty_thresh / DIRTY_MAXPAUSE &&
+		    jiffies - start_time > MAX_PAUSE)
+			break;
+		if (nr_dirty < dirty_thresh + dirty_thresh / DIRTY_PASSGOOD &&
+		    bdi_dirty < bdi_thresh)
+			break;
+
 		/*
 		 * Increase the delay for each loop, up to our previous
 		 * default of taking a 100ms nap.


