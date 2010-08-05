Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933209Ab0HEQ3Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 12:29:25 -0400
Received: from mga03.intel.com ([143.182.124.21]:19701 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760462Ab0HEQ3S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 12:29:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,323,1278313200"; 
   d="scan'208";a="308628097"
Message-Id: <20100805162433.105093335@intel.com>
User-Agent: quilt/0.48-1
Date: Fri, 06 Aug 2010 00:10:54 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Wu Fengguang <fengguang.wu@intel.com>, LKML <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Dave Chinner <david@fromorbit.com>, Jens Axboe <axboe@kernel.dk>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Mel Gorman <mel@csn.ul.ie>, Chris Mason <chris.mason@oracle.com>,
        Jan Kara <jack@suse.cz>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: [PATCH 03/13] writeback: add comment to the dirty limits functions
References: <20100805161051.501816677@intel.com>
Content-Disposition: inline; filename=dirty-limits-comment.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Document global_dirty_limits(), bdi_dirty_limit() and task_dirty_limit().

Cc: Christoph Hellwig <hch@infradead.org>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 mm/page-writeback.c |   31 ++++++++++++++++++++++++++++---
 1 file changed, 28 insertions(+), 3 deletions(-)

--- linux-next.orig/mm/page-writeback.c	2010-08-03 23:14:19.000000000 +0800
+++ linux-next/mm/page-writeback.c	2010-08-05 00:37:17.000000000 +0800
@@ -261,11 +261,18 @@ static inline void task_dirties_fraction
 }
 
 /*
- * scale the dirty limit
+ * task_dirty_limit - scale down dirty throttling threshold for one task
  *
  * task specific dirty limit:
  *
  *   dirty -= (dirty/8) * p_{t}
+ *
+ * To protect light/slow dirtying tasks from heavier/fast ones, we start
+ * throttling individual tasks before reaching the bdi dirty limit.
+ * Relatively low thresholds will be allocated to heavy dirtiers. So when
+ * dirty pages grow large, heavy dirtiers will be throttled first, which will
+ * effectively curb the growth of dirty pages. Light dirtiers with high enough
+ * dirty threshold may never get throttled.
  */
 static unsigned long task_dirty_limit(struct task_struct *tsk,
 				       unsigned long bdi_dirty)
@@ -390,6 +397,15 @@ unsigned long determine_dirtyable_memory
 	return x + 1;	/* Ensure that we never return 0 */
 }
 
+/**
+ * global_dirty_limits - background-writeback and dirty-throttling thresholds
+ *
+ * Calculate the dirty thresholds based on sysctl parameters
+ * - vm.dirty_background_ratio  or  vm.dirty_background_bytes
+ * - vm.dirty_ratio             or  vm.dirty_bytes
+ * The dirty limits will be lifted by 1/4 for PF_LESS_THROTTLE (ie. nfsd) and
+ * runtime tasks.
+ */
 void global_dirty_limits(unsigned long *pbackground, unsigned long *pdirty)
 {
 	unsigned long background;
@@ -424,8 +440,17 @@ void global_dirty_limits(unsigned long *
 	*pdirty = dirty;
 }
 
-unsigned long bdi_dirty_limit(struct backing_dev_info *bdi,
-			       unsigned long dirty)
+/**
+ * bdi_dirty_limit - @bdi's share of dirty throttling threshold
+ *
+ * Allocate high/low dirty limits to fast/slow devices, in order to prevent
+ * - starving fast devices
+ * - piling up dirty pages (that will take long time to sync) on slow devices
+ *
+ * The bdi's share of dirty limit will be adapting to its throughput and
+ * bounded by the bdi->min_ratio and/or bdi->max_ratio parameters, if set.
+ */
+unsigned long bdi_dirty_limit(struct backing_dev_info *bdi, unsigned long dirty)
 {
 	u64 bdi_dirty;
 	long numerator, denominator;


