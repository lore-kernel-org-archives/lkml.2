Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754712Ab0GKCit (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jul 2010 22:38:49 -0400
Received: from mga03.intel.com ([143.182.124.21]:20602 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754145Ab0GKCiN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jul 2010 22:38:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,182,1278313200"; 
   d="scan'208";a="298739383"
Message-Id: <20100711021748.879183413@intel.com>
User-Agent: quilt/0.48-1
Date: Sun, 11 Jul 2010 10:06:59 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: Christoph Hellwig <hch@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Wu Fengguang <fengguang.wu@intel.com>
CC: Dave Chinner <david@fromorbit.com>
CC: Jan Kara <jack@suse.cz>
cc: <linux-fsdevel@vger.kernel.org>
cc: Linux Memory Management List <linux-mm@kvack.org>
cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/6] writeback: avoid unnecessary calculation of bdi dirty thresholds
References: <20100711020656.340075560@intel.com>
Content-Disposition: inline; filename=writeback-less-bdi-calc.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Split get_dirty_limits() into global_dirty_limits()+bdi_dirty_limit(),
so that the latter can be avoided when under global dirty background
threshold (which is the normal state for most systems).

CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 fs/fs-writeback.c         |    2 
 include/linux/writeback.h |    5 +-
 mm/backing-dev.c          |    3 -
 mm/page-writeback.c       |   74 ++++++++++++++++++------------------
 4 files changed, 43 insertions(+), 41 deletions(-)

--- linux-next.orig/mm/page-writeback.c	2010-07-11 08:50:00.000000000 +0800
+++ linux-next/mm/page-writeback.c	2010-07-11 08:53:44.000000000 +0800
@@ -267,10 +267,11 @@ static inline void task_dirties_fraction
  *
  *   dirty -= (dirty/8) * p_{t}
  */
-static void task_dirty_limit(struct task_struct *tsk, unsigned long *pdirty)
+static unsigned long task_dirty_limit(struct task_struct *tsk,
+				       unsigned long bdi_dirty)
 {
 	long numerator, denominator;
-	unsigned long dirty = *pdirty;
+	unsigned long dirty = bdi_dirty;
 	u64 inv = dirty >> 3;
 
 	task_dirties_fraction(tsk, &numerator, &denominator);
@@ -278,10 +279,8 @@ static void task_dirty_limit(struct task
 	do_div(inv, denominator);
 
 	dirty -= inv;
-	if (dirty < *pdirty/2)
-		dirty = *pdirty/2;
 
-	*pdirty = dirty;
+	return max(dirty, bdi_dirty/2);
 }
 
 /*
@@ -391,9 +390,7 @@ unsigned long determine_dirtyable_memory
 	return x + 1;	/* Ensure that we never return 0 */
 }
 
-void
-get_dirty_limits(unsigned long *pbackground, unsigned long *pdirty,
-		 unsigned long *pbdi_dirty, struct backing_dev_info *bdi)
+void global_dirty_limits(unsigned long *pbackground, unsigned long *pdirty)
 {
 	unsigned long background;
 	unsigned long dirty;
@@ -425,26 +422,28 @@ get_dirty_limits(unsigned long *pbackgro
 	}
 	*pbackground = background;
 	*pdirty = dirty;
+}
 
-	if (bdi) {
-		u64 bdi_dirty;
-		long numerator, denominator;
+unsigned long bdi_dirty_limit(struct backing_dev_info *bdi,
+			       unsigned long dirty)
+{
+	u64 bdi_dirty;
+	long numerator, denominator;
 
-		/*
-		 * Calculate this BDI's share of the dirty ratio.
-		 */
-		bdi_writeout_fraction(bdi, &numerator, &denominator);
+	/*
+	 * Calculate this BDI's share of the dirty ratio.
+	 */
+	bdi_writeout_fraction(bdi, &numerator, &denominator);
 
-		bdi_dirty = (dirty * (100 - bdi_min_ratio)) / 100;
-		bdi_dirty *= numerator;
-		do_div(bdi_dirty, denominator);
-		bdi_dirty += (dirty * bdi->min_ratio) / 100;
-		if (bdi_dirty > (dirty * bdi->max_ratio) / 100)
-			bdi_dirty = dirty * bdi->max_ratio / 100;
+	bdi_dirty = (dirty * (100 - bdi_min_ratio)) / 100;
+	bdi_dirty *= numerator;
+	do_div(bdi_dirty, denominator);
 
-		*pbdi_dirty = bdi_dirty;
-		task_dirty_limit(current, pbdi_dirty);
-	}
+	bdi_dirty += (dirty * bdi->min_ratio) / 100;
+	if (bdi_dirty > (dirty * bdi->max_ratio) / 100)
+		bdi_dirty = dirty * bdi->max_ratio / 100;
+
+	return task_dirty_limit(current, bdi_dirty);
 }
 
 /*
@@ -475,14 +474,24 @@ static void balance_dirty_pages(struct a
 			.range_cyclic	= 1,
 		};
 
-		get_dirty_limits(&background_thresh, &dirty_thresh,
-				 &bdi_thresh, bdi);
-
 		nr_reclaimable = global_page_state(NR_FILE_DIRTY) +
 				 global_page_state(NR_UNSTABLE_NFS);
 		nr_writeback = global_page_state(NR_WRITEBACK) +
 			       global_page_state(NR_WRITEBACK_TEMP);
 
+		global_dirty_limits(&background_thresh, &dirty_thresh);
+
+		/*
+		 * Throttle it only when the background writeback cannot
+		 * catch-up. This avoids (excessively) small writeouts
+		 * when the bdi limits are ramping up.
+		 */
+		if (nr_reclaimable + nr_writeback <
+				(background_thresh + dirty_thresh) / 2)
+			break;
+
+		bdi_thresh = bdi_dirty_limit(bdi, dirty_thresh);
+
 		/*
 		 * In order to avoid the stacked BDI deadlock we need
 		 * to ensure we accurately count the 'dirty' pages when
@@ -514,15 +523,6 @@ static void balance_dirty_pages(struct a
 		if (!dirty_exceeded)
 			break;
 
-		/*
-		 * Throttle it only when the background writeback cannot
-		 * catch-up. This avoids (excessively) small writeouts
-		 * when the bdi limits are ramping up.
-		 */
-		if (nr_reclaimable + nr_writeback <
-				(background_thresh + dirty_thresh) / 2)
-			break;
-
 		if (!bdi->dirty_exceeded)
 			bdi->dirty_exceeded = 1;
 
@@ -635,7 +635,7 @@ void throttle_vm_writeout(gfp_t gfp_mask
 	unsigned long dirty_thresh;
 
         for ( ; ; ) {
-		get_dirty_limits(&background_thresh, &dirty_thresh, NULL, NULL);
+		global_dirty_limits(&background_thresh, &dirty_thresh);
 
                 /*
                  * Boost the allowable dirty threshold a bit for page
--- linux-next.orig/fs/fs-writeback.c	2010-07-11 08:50:00.000000000 +0800
+++ linux-next/fs/fs-writeback.c	2010-07-11 08:53:44.000000000 +0800
@@ -594,7 +594,7 @@ static inline bool over_bground_thresh(v
 {
 	unsigned long background_thresh, dirty_thresh;
 
-	get_dirty_limits(&background_thresh, &dirty_thresh, NULL, NULL);
+	global_dirty_limits(&background_thresh, &dirty_thresh);
 
 	return (global_page_state(NR_FILE_DIRTY) +
 		global_page_state(NR_UNSTABLE_NFS) >= background_thresh);
--- linux-next.orig/mm/backing-dev.c	2010-07-11 08:50:00.000000000 +0800
+++ linux-next/mm/backing-dev.c	2010-07-11 08:53:44.000000000 +0800
@@ -83,7 +83,8 @@ static int bdi_debug_stats_show(struct s
 		nr_more_io++;
 	spin_unlock(&inode_lock);
 
-	get_dirty_limits(&background_thresh, &dirty_thresh, &bdi_thresh, bdi);
+	global_dirty_limits(&background_thresh, &dirty_thresh);
+	bdi_thresh = bdi_dirty_limit(bdi, dirty_thresh);
 
 #define K(x) ((x) << (PAGE_SHIFT - 10))
 	seq_printf(m,
--- linux-next.orig/include/linux/writeback.h	2010-07-11 08:50:00.000000000 +0800
+++ linux-next/include/linux/writeback.h	2010-07-11 08:53:44.000000000 +0800
@@ -124,8 +124,9 @@ struct ctl_table;
 int dirty_writeback_centisecs_handler(struct ctl_table *, int,
 				      void __user *, size_t *, loff_t *);
 
-void get_dirty_limits(unsigned long *pbackground, unsigned long *pdirty,
-		      unsigned long *pbdi_dirty, struct backing_dev_info *bdi);
+void global_dirty_limits(unsigned long *pbackground, unsigned long *pdirty);
+unsigned long bdi_dirty_limit(struct backing_dev_info *bdi,
+			       unsigned long dirty);
 
 void page_writeback_init(void);
 void balance_dirty_pages_ratelimited_nr(struct address_space *mapping,


