Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932359Ab0LMGzr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 01:55:47 -0500
Received: from mga09.intel.com ([134.134.136.24]:10971 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753857Ab0LMGtn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 01:49:43 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,335,1288594800"; 
   d="scan'208";a="686523129"
Message-Id: <20101213064839.658200254@intel.com>
User-Agent: quilt/0.48-1
Date: Mon, 13 Dec 2010 14:43:11 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: Jan Kara <jack@suse.cz>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Rik van Riel <riel@redhat.com>, Wu Fengguang <fengguang.wu@intel.com>
CC: Christoph Hellwig <hch@lst.de>
CC: Trond Myklebust <Trond.Myklebust@netapp.com>
CC: Dave Chinner <david@fromorbit.com>
CC: "Theodore Ts'o" <tytso@mit.edu>
CC: Chris Mason <chris.mason@oracle.com>
CC: Mel Gorman <mel@csn.ul.ie>
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Greg Thelen <gthelen@google.com>
CC: Minchan Kim <minchan.kim@gmail.com>
Cc: linux-mm <linux-mm@kvack.org>
Cc: <linux-fsdevel@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 22/47] writeback: prevent bandwidth calculation overflow
References: <20101213064249.648862451@intel.com>
Content-Disposition: inline; filename=writeback-prevent-bw-overflow.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 32bit kernel, bdi->write_bandwidth can express at most 4GB/s.

However the current calculation code can overflow when disk bandwidth
reaches 800MB/s.  Fix it by using "long long" and div64_u64() in the
calculations.

And further change its unit from bytes/second to pages/second.
That allows up to 16TB/s bandwidth in 32bit kernel.

CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 include/linux/backing-dev.h |    5 +++--
 mm/backing-dev.c            |    4 ++--
 mm/page-writeback.c         |   14 +++++++-------
 3 files changed, 12 insertions(+), 11 deletions(-)

--- linux-next.orig/mm/page-writeback.c	2010-12-08 22:44:28.000000000 +0800
+++ linux-next/mm/page-writeback.c	2010-12-08 22:44:29.000000000 +0800
@@ -531,7 +531,7 @@ void bdi_update_write_bandwidth(struct b
 	unsigned long written;
 	unsigned long elapsed;
 	unsigned long bw;
-	unsigned long w;
+	unsigned long long w;
 
 	if (*bw_written == 0)
 		goto snapshot;
@@ -550,9 +550,10 @@ void bdi_update_write_bandwidth(struct b
 		goto snapshot;
 
 	written = percpu_counter_read(&bdi->bdi_stat[BDI_WRITTEN]) - *bw_written;
-	bw = (HZ * PAGE_CACHE_SIZE * written + elapsed/2) / elapsed;
+	bw = (HZ * written + elapsed / 2) / elapsed;
 	w = min(elapsed / unit_time, 128UL);
-	bdi->write_bandwidth = (bdi->write_bandwidth * (1024-w) + bw * w) >> 10;
+	bdi->write_bandwidth = (bdi->write_bandwidth * (1024-w) +
+				bw * w + 1023) >> 10;
 	bdi->write_bandwidth_update_time = jiffies;
 snapshot:
 	*bw_written = percpu_counter_read(&bdi->bdi_stat[BDI_WRITTEN]);
@@ -577,7 +578,7 @@ static void balance_dirty_pages(struct a
 	unsigned long dirty_thresh;
 	unsigned long bdi_thresh;
 	unsigned long task_thresh;
-	unsigned long bw;
+	unsigned long long bw;
 	unsigned long pause = 0;
 	bool dirty_exceeded = false;
 	struct backing_dev_info *bdi = mapping->backing_dev_info;
@@ -640,8 +641,7 @@ static void balance_dirty_pages(struct a
 		 * of dirty pages have been cleaned during our pause time.
 		 */
 		if (nr_dirty < dirty_thresh &&
-		    bdi_prev_dirty - bdi_dirty >
-		    bdi->write_bandwidth >> (PAGE_CACHE_SHIFT + 2))
+		    bdi_prev_dirty - bdi_dirty > (long)bdi->write_bandwidth / 4)
 			break;
 		bdi_prev_dirty = bdi_dirty;
 
@@ -664,7 +664,7 @@ static void balance_dirty_pages(struct a
 		bw = bw * (task_thresh - bdi_dirty);
 		do_div(bw, bdi_thresh / TASK_SOFT_DIRTY_LIMIT + 1);
 
-		pause = HZ * (pages_dirtied << PAGE_CACHE_SHIFT) / (bw + 1);
+		pause = HZ * pages_dirtied / ((unsigned long)bw + 1);
 		pause = clamp_val(pause, 1, HZ/10);
 
 pause:
--- linux-next.orig/mm/backing-dev.c	2010-12-08 22:44:24.000000000 +0800
+++ linux-next/mm/backing-dev.c	2010-12-08 22:44:29.000000000 +0800
@@ -103,7 +103,7 @@ static int bdi_debug_stats_show(struct s
 		   (unsigned long) K(bdi_stat(bdi, BDI_RECLAIMABLE)),
 		   K(bdi_thresh), K(dirty_thresh), K(background_thresh),
 		   (unsigned long) K(bdi_stat(bdi, BDI_WRITTEN)),
-		   (unsigned long) bdi->write_bandwidth >> 10,
+		   (unsigned long) K(bdi->write_bandwidth),
 		   nr_dirty, nr_io, nr_more_io,
 		   !list_empty(&bdi->bdi_list), bdi->state);
 #undef K
@@ -662,7 +662,7 @@ int bdi_init(struct backing_dev_info *bd
 			goto err;
 	}
 
-	bdi->write_bandwidth = 100 << 20;
+	bdi->write_bandwidth = (100 << 20) / PAGE_CACHE_SIZE;
 	bdi->dirty_exceeded = 0;
 	err = prop_local_init_percpu(&bdi->completions);
 
--- linux-next.orig/include/linux/backing-dev.h	2010-12-08 22:44:24.000000000 +0800
+++ linux-next/include/linux/backing-dev.h	2010-12-08 22:44:29.000000000 +0800
@@ -74,9 +74,10 @@ struct backing_dev_info {
 
 	struct percpu_counter bdi_stat[NR_BDI_STAT_ITEMS];
 
-	struct prop_local_percpu completions;
+	unsigned long write_bandwidth;
 	unsigned long write_bandwidth_update_time;
-	int write_bandwidth;
+
+	struct prop_local_percpu completions;
 	int dirty_exceeded;
 
 	unsigned int min_ratio;


