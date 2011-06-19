Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754429Ab1FSP3H (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jun 2011 11:29:07 -0400
Received: from mga03.intel.com ([143.182.124.21]:58128 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754308Ab1FSP1v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jun 2011 11:27:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,389,1304319600"; 
   d="scan'208";a="15188372"
Message-Id: <20110619150510.246140117@intel.com>
User-Agent: quilt/0.48-1
Date: Sun, 19 Jun 2011 23:01:11 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
CC: Jan Kara <jack@suse.cz>, Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Wu Fengguang <fengguang.wu@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/7] writeback: introduce smoothed global dirty limit
References: <20110619150108.691351746@intel.com>
Content-Disposition: inline; filename=writeback-dirty-thresh-limit.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The start of a heavy weight application (ie. KVM) may instantly knock
down determine_dirtyable_memory() and hence the global/bdi dirty
thresholds.

So introduce global_dirty_limit for tracking the global dirty threshold
with policies

- follow downwards slowly
- follow up in one shot

global_dirty_limit can effectively mask out the impact of sudden drop of
dirtyable memory. It will be used in the next patch for two new type of
dirty limits.

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 include/linux/writeback.h |    2 +
 mm/page-writeback.c       |   41 ++++++++++++++++++++++++++++++++++++
 2 files changed, 43 insertions(+)

--- linux-next.orig/include/linux/writeback.h	2011-06-19 22:56:18.000000000 +0800
+++ linux-next/include/linux/writeback.h	2011-06-19 22:59:29.000000000 +0800
@@ -88,6 +88,8 @@ static inline void laptop_sync_completio
 #endif
 void throttle_vm_writeout(gfp_t gfp_mask);
 
+extern unsigned long global_dirty_limit;
+
 /* These are exported to sysctl. */
 extern int dirty_background_ratio;
 extern unsigned long dirty_background_bytes;
--- linux-next.orig/mm/page-writeback.c	2011-06-19 22:56:18.000000000 +0800
+++ linux-next/mm/page-writeback.c	2011-06-19 22:59:29.000000000 +0800
@@ -116,6 +116,7 @@ EXPORT_SYMBOL(laptop_mode);
 
 /* End of sysctl-exported parameters */
 
+unsigned long global_dirty_limit;
 
 /*
  * Scale the writeback cache size proportional to the relative writeout speeds.
@@ -510,6 +511,43 @@ static void bdi_update_write_bandwidth(s
 	bdi->avg_write_bandwidth = avg;
 }
 
+static void update_dirty_limit(unsigned long thresh,
+				 unsigned long dirty)
+{
+	unsigned long limit = global_dirty_limit;
+
+	if (limit < thresh) {
+		limit = thresh;
+		goto update;
+	}
+
+	if (limit > thresh &&
+	    limit > dirty) {
+		limit -= (limit - max(thresh, dirty)) >> 5;
+		goto update;
+	}
+	return;
+update:
+	global_dirty_limit = limit;
+}
+
+static void global_update_bandwidth(unsigned long thresh,
+				    unsigned long dirty,
+				    unsigned long now)
+{
+	static DEFINE_SPINLOCK(dirty_lock);
+
+	if (now - default_backing_dev_info.bw_time_stamp < MAX_PAUSE)
+		return;
+
+	spin_lock(&dirty_lock);
+	if (now - default_backing_dev_info.bw_time_stamp >= MAX_PAUSE) {
+		update_dirty_limit(thresh, dirty);
+		default_backing_dev_info.bw_time_stamp = now;
+	}
+	spin_unlock(&dirty_lock);
+}
+
 void __bdi_update_bandwidth(struct backing_dev_info *bdi,
 			    unsigned long thresh,
 			    unsigned long dirty,
@@ -535,6 +573,9 @@ void __bdi_update_bandwidth(struct backi
 	if (elapsed > HZ && time_before(bdi->bw_time_stamp, start_time))
 		goto snapshot;
 
+	if (thresh)
+		global_update_bandwidth(thresh, dirty, now);
+
 	bdi_update_write_bandwidth(bdi, elapsed, written);
 
 snapshot:


