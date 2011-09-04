Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754076Ab1IDCOX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Sep 2011 22:14:23 -0400
Received: from mga03.intel.com ([143.182.124.21]:49417 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753085Ab1IDCN3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Sep 2011 22:13:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,326,1312182000"; 
   d="scan'208";a="45377107"
Message-Id: <20110904020916.070059502@intel.com>
User-Agent: quilt/0.48-1
Date: Sun, 04 Sep 2011 09:53:16 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
to: <linux-fsdevel@vger.kernel.org>
cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Tejun Heo <tj@kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Li Shaohua <shaohua.li@intel.com>,
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
Subject: [PATCH 11/18] block: add bdi flag to indicate risk of io queue underrun
References: <20110904015305.367445271@intel.com>
Content-Disposition: inline; filename=blk-queue-underrun.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hurry it up when there are less than 3 async requests in the block io queue:

1) don't dirty throttle the current dirtier

2) wakeup the flusher for background writeout (XXX: the flusher may then
   abort not being aware of the underrun)

When doing 1-dd write test with dirty_bytes=1MB, it increased the XFS
writeout throughput from 5MB/s to 55MB/s and increased disk utilization
from ~3% to ~85%.  ext4 achieves almost the same. However btrfs is not
good: it only does 1MB/s normally, with sudden rushes to 10-60MB/s.

CC: Tejun Heo <tj@kernel.org>
CC: Jens Axboe <axboe@kernel.dk>
CC: Li Shaohua <shaohua.li@intel.com>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 block/blk-core.c            |    7 +++++++
 include/linux/backing-dev.h |   18 ++++++++++++++++++
 include/linux/blkdev.h      |   12 ++++++++++++
 mm/page-writeback.c         |    3 +++
 4 files changed, 40 insertions(+)

--- linux-next.orig/block/blk-core.c	2011-08-31 10:27:11.000000000 +0800
+++ linux-next/block/blk-core.c	2011-08-31 14:41:38.000000000 +0800
@@ -637,6 +637,10 @@ static void __freed_request(struct reque
 {
 	struct request_list *rl = &q->rq;
 
+	if (rl->count[sync] <= q->in_flight[sync] &&
+	    rl->count[!sync] == 0)
+		blk_set_queue_underrun(q, sync);
+
 	if (rl->count[sync] < queue_congestion_off_threshold(q))
 		blk_clear_queue_congested(q, sync);
 
@@ -738,6 +742,9 @@ static struct request *get_request(struc
 	if (rl->count[is_sync] >= (3 * q->nr_requests / 2))
 		goto out;
 
+	if (rl->count[is_sync] >= q->in_flight[is_sync] + BLK_UNDERRUN_REQUESTS)
+		blk_clear_queue_underrun(q, is_sync);
+
 	rl->count[is_sync]++;
 	rl->starved[is_sync] = 0;
 
--- linux-next.orig/include/linux/blkdev.h	2011-08-31 10:27:11.000000000 +0800
+++ linux-next/include/linux/blkdev.h	2011-08-31 10:49:43.000000000 +0800
@@ -699,6 +699,18 @@ static inline void blk_set_queue_congest
 	set_bdi_congested(&q->backing_dev_info, sync);
 }
 
+#define BLK_UNDERRUN_REQUESTS	3
+
+static inline void blk_clear_queue_underrun(struct request_queue *q, int sync)
+{
+	clear_bdi_underrun(&q->backing_dev_info, sync);
+}
+
+static inline void blk_set_queue_underrun(struct request_queue *q, int sync)
+{
+	set_bdi_underrun(&q->backing_dev_info, sync);
+}
+
 extern void blk_start_queue(struct request_queue *q);
 extern void blk_stop_queue(struct request_queue *q);
 extern void blk_sync_queue(struct request_queue *q);
--- linux-next.orig/include/linux/backing-dev.h	2011-08-31 10:27:11.000000000 +0800
+++ linux-next/include/linux/backing-dev.h	2011-08-31 10:49:43.000000000 +0800
@@ -32,6 +32,7 @@ enum bdi_state {
 	BDI_sync_congested,	/* The sync queue is getting full */
 	BDI_registered,		/* bdi_register() was done */
 	BDI_writeback_running,	/* Writeback is in progress */
+	BDI_async_underrun,	/* The async queue is getting underrun */
 	BDI_unused,		/* Available bits start here */
 };
 
@@ -301,6 +302,23 @@ void set_bdi_congested(struct backing_de
 long congestion_wait(int sync, long timeout);
 long wait_iff_congested(struct zone *zone, int sync, long timeout);
 
+static inline void clear_bdi_underrun(struct backing_dev_info *bdi, int sync)
+{
+	if (sync == BLK_RW_ASYNC)
+		clear_bit(BDI_async_underrun, &bdi->state);
+}
+
+static inline void set_bdi_underrun(struct backing_dev_info *bdi, int sync)
+{
+	if (sync == BLK_RW_ASYNC)
+		set_bit(BDI_async_underrun, &bdi->state);
+}
+
+static inline int bdi_async_underrun(struct backing_dev_info *bdi)
+{
+	return bdi->state & (1 << BDI_async_underrun);
+}
+
 static inline bool bdi_cap_writeback_dirty(struct backing_dev_info *bdi)
 {
 	return !(bdi->capabilities & BDI_CAP_NO_WRITEBACK);
--- linux-next.orig/mm/page-writeback.c	2011-08-31 10:49:43.000000000 +0800
+++ linux-next/mm/page-writeback.c	2011-08-31 14:40:58.000000000 +0800
@@ -1067,6 +1067,9 @@ static void balance_dirty_pages(struct a
 				     nr_dirty, bdi_thresh, bdi_dirty,
 				     start_time);
 
+		if (unlikely(!dirty_exceeded && bdi_async_underrun(bdi)))
+			break;
+
 		dirty_ratelimit = bdi->dirty_ratelimit;
 		pos_ratio = bdi_position_ratio(bdi, dirty_thresh,
 					       background_thresh, nr_dirty,


