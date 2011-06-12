Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754098Ab1FLPfq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jun 2011 11:35:46 -0400
Received: from mga01.intel.com ([192.55.52.88]:58023 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752366Ab1FLPen (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jun 2011 11:34:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,355,1304319600"; 
   d="scan'208";a="15357470"
Message-Id: <20110612152910.792898836@intel.com>
User-Agent: quilt/0.48-1
Date: Sun, 12 Jun 2011 23:18:23 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: <linux-fsdevel@vger.kernel.org>
cc: Jan Kara <jack@suse.cz>, Li Shaohua <shaohua.li@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Wu Fengguang <fengguang.wu@intel.com>
cc: Dave Chinner <david@fromorbit.com>
cc: Christoph Hellwig <hch@infradead.org>
cc: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/3] writeback: bdi write bandwidth estimation
References: <20110612151821.601514494@intel.com>
Content-Disposition: inline; filename=writeback-write-bandwidth.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The estimation value will start from 100MB/s and adapt to the real
bandwidth in seconds.

It tries to update the bandwidth only when disk is fully utilized.
Any inactive period of more than one second will be skipped.

The estimation is not done purely in the flusher thread because
there is no guarantee for write_cache_pages() to return timely
to update the bandwidth.

The bdi->avg_write_bandwidth smoothing is very effective for filtering
out sudden spikes, however has the cost of possibly a little biased
towards low.

The overheads are low because the bdi bandwidth update only occurs
at >200ms intervals.

CC: Li Shaohua <shaohua.li@intel.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 fs/fs-writeback.c           |   13 +++++
 include/linux/backing-dev.h |    5 ++
 include/linux/writeback.h   |    3 +
 mm/backing-dev.c            |   12 +++++
 mm/page-writeback.c         |   81 ++++++++++++++++++++++++++++++++++
 5 files changed, 114 insertions(+)

--- linux-next.orig/fs/fs-writeback.c	2011-06-12 20:57:01.000000000 +0800
+++ linux-next/fs/fs-writeback.c	2011-06-12 20:59:33.000000000 +0800
@@ -629,6 +629,16 @@ static inline bool over_bground_thresh(v
 }
 
 /*
+ * Called under &wb->list_lock. If there are multiple wb per bdi,
+ * only the flusher working on the first wb should do it.
+ */
+static void wb_update_bandwidth(struct bdi_writeback *wb,
+				unsigned long start_time)
+{
+	__bdi_update_bandwidth(wb->bdi, start_time);
+}
+
+/*
  * Explicit flushing or periodic writeback of "old" data.
  *
  * Define "old": the first time one of an inode's pages is dirtied, we mark the
@@ -658,6 +668,7 @@ static long wb_writeback(struct bdi_writ
 	long wrote = 0;
 	long write_chunk = MAX_WRITEBACK_PAGES;
 	struct inode *inode;
+	unsigned long wb_start = jiffies;
 
 	if (!wbc.range_cyclic) {
 		wbc.range_start = 0;
@@ -727,6 +738,8 @@ static long wb_writeback(struct bdi_writ
 			__writeback_inodes_wb(wb, &wbc);
 		trace_wbc_writeback_written(&wbc, wb->bdi);
 
+		wb_update_bandwidth(wb, wb_start);
+
 		work->nr_pages -= write_chunk - wbc.nr_to_write;
 		wrote += write_chunk - wbc.nr_to_write;
 
--- linux-next.orig/include/linux/backing-dev.h	2011-06-12 20:57:03.000000000 +0800
+++ linux-next/include/linux/backing-dev.h	2011-06-12 20:59:32.000000000 +0800
@@ -73,6 +73,11 @@ struct backing_dev_info {
 
 	struct percpu_counter bdi_stat[NR_BDI_STAT_ITEMS];
 
+	unsigned long bw_time_stamp;
+	unsigned long written_stamp;
+	unsigned long write_bandwidth;
+	unsigned long avg_write_bandwidth;
+
 	struct prop_local_percpu completions;
 	int dirty_exceeded;
 
--- linux-next.orig/include/linux/writeback.h	2011-06-12 20:57:01.000000000 +0800
+++ linux-next/include/linux/writeback.h	2011-06-12 20:59:33.000000000 +0800
@@ -122,6 +122,9 @@ void global_dirty_limits(unsigned long *
 unsigned long bdi_dirty_limit(struct backing_dev_info *bdi,
 			       unsigned long dirty);
 
+void __bdi_update_bandwidth(struct backing_dev_info *bdi,
+			    unsigned long start_time);
+
 void page_writeback_init(void);
 void balance_dirty_pages_ratelimited_nr(struct address_space *mapping,
 					unsigned long nr_pages_dirtied);
--- linux-next.orig/mm/backing-dev.c	2011-06-12 20:57:03.000000000 +0800
+++ linux-next/mm/backing-dev.c	2011-06-12 21:06:11.000000000 +0800
@@ -649,6 +649,11 @@ static void bdi_wb_init(struct bdi_write
 	setup_timer(&wb->wakeup_timer, wakeup_timer_fn, (unsigned long)bdi);
 }
 
+/*
+ * Initial write bandwidth: 100 MB/s
+ */
+#define INIT_BW		(100 << (20 - PAGE_SHIFT))
+
 int bdi_init(struct backing_dev_info *bdi)
 {
 	int i, err;
@@ -671,6 +676,13 @@ int bdi_init(struct backing_dev_info *bd
 	}
 
 	bdi->dirty_exceeded = 0;
+
+	bdi->bw_time_stamp = jiffies;
+	bdi->written_stamp = 0;
+
+	bdi->write_bandwidth = INIT_BW;
+	bdi->avg_write_bandwidth = INIT_BW;
+
 	err = prop_local_init_percpu(&bdi->completions);
 
 	if (err) {
--- linux-next.orig/mm/page-writeback.c	2011-06-12 20:57:03.000000000 +0800
+++ linux-next/mm/page-writeback.c	2011-06-12 21:14:57.000000000 +0800
@@ -37,6 +37,11 @@
 #include <trace/events/writeback.h>
 
 /*
+ * Sleep at most 200ms at a time in balance_dirty_pages().
+ */
+#define MAX_PAUSE	max(HZ/5, 1)
+
+/*
  * After a CPU has dirtied this many pages, balance_dirty_pages_ratelimited
  * will look to see if it needs to force writeback or throttling.
  */
@@ -472,6 +477,79 @@ unsigned long bdi_dirty_limit(struct bac
 	return bdi_dirty;
 }
 
+static void bdi_update_write_bandwidth(struct backing_dev_info *bdi,
+				       unsigned long elapsed,
+				       unsigned long written)
+{
+	const unsigned long period = roundup_pow_of_two(3 * HZ);
+	unsigned long avg = bdi->avg_write_bandwidth;
+	unsigned long old = bdi->write_bandwidth;
+	unsigned long cur;
+	u64 bw;
+
+	bw = written - bdi->written_stamp;
+	bw *= HZ;
+	if (unlikely(elapsed > period / 2)) {
+		do_div(bw, elapsed);
+		elapsed = period / 2;
+		bw *= elapsed;
+	}
+	bw += (u64)bdi->write_bandwidth * (period - elapsed);
+	cur = bw >> ilog2(period);
+	bdi->write_bandwidth = cur;
+
+	/*
+	 * one more level of smoothing
+	 */
+	if (avg > old && old > cur)
+		avg -= (avg - old) >> 3;
+
+	if (avg < old && old < cur)
+		avg += (old - avg) >> 3;
+
+	bdi->avg_write_bandwidth = avg;
+}
+
+void __bdi_update_bandwidth(struct backing_dev_info *bdi,
+			    unsigned long start_time)
+{
+	unsigned long now = jiffies;
+	unsigned long elapsed = now - bdi->bw_time_stamp;
+	unsigned long written;
+
+	/*
+	 * rate-limit, only update once every 200ms.
+	 */
+	if (elapsed < MAX_PAUSE)
+		return;
+
+	written = percpu_counter_read(&bdi->bdi_stat[BDI_WRITTEN]);
+
+	/*
+	 * Skip quiet periods when disk bandwidth is under-utilized.
+	 * (at least 1s idle time between two flusher runs)
+	 */
+	if (elapsed > HZ && time_before(bdi->bw_time_stamp, start_time))
+		goto snapshot;
+
+	bdi_update_write_bandwidth(bdi, elapsed, written);
+
+snapshot:
+	bdi->written_stamp = written;
+	bdi->bw_time_stamp = now;
+}
+
+static void bdi_update_bandwidth(struct backing_dev_info *bdi,
+				 unsigned long start_time)
+{
+	if (jiffies - bdi->bw_time_stamp <= MAX_PAUSE + MAX_PAUSE / 10)
+		return;
+	if (spin_trylock(&bdi->wb.list_lock)) {
+		__bdi_update_bandwidth(bdi, start_time);
+		spin_unlock(&bdi->wb.list_lock);
+	}
+}
+
 /*
  * balance_dirty_pages() must be called by processes which are generating dirty
  * data.  It looks at the number of dirty pages in the machine and will force
@@ -491,6 +569,7 @@ static void balance_dirty_pages(struct a
 	unsigned long pause = 1;
 	bool dirty_exceeded = false;
 	struct backing_dev_info *bdi = mapping->backing_dev_info;
+	unsigned long start_time = jiffies;
 
 	for (;;) {
 		struct writeback_control wbc = {
@@ -552,6 +631,8 @@ static void balance_dirty_pages(struct a
 		if (!bdi->dirty_exceeded)
 			bdi->dirty_exceeded = 1;
 
+		bdi_update_bandwidth(bdi, start_time);
+
 		/* Note: nr_reclaimable denotes nr_dirty + nr_unstable.
 		 * Unstable writes are a feature of certain networked
 		 * filesystems (i.e. NFS) in which data may have been


