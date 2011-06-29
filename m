Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755540Ab1F2PJO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 11:09:14 -0400
Received: from mga11.intel.com ([192.55.52.93]:10680 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755324Ab1F2PJL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 11:09:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,443,1304319600"; 
   d="scan'208";a="24301023"
Message-Id: <20110629145553.906668553@intel.com>
User-Agent: quilt/0.48-1
Date: Wed, 29 Jun 2011 22:52:48 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: <linux-fsdevel@vger.kernel.org>
CC: Jan Kara <jack@suse.cz>, Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Li Shaohua <shaohua.li@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Wu Fengguang <fengguang.wu@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/9] writeback: bdi write bandwidth estimation
References: <20110629145245.835998321@intel.com>
Content-Disposition: inline; filename=writeback-write-bandwidth.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The estimation value will start from 100MB/s and adapt to the real
bandwidth in seconds.

It tries to update the bandwidth only when disk is fully utilized.
Any inactive period of more than one second will be skipped.

The estimated bandwidth will be reflecting how fast the device can
writeout when _fully utilized_, and won't drop to 0 when it goes idle.
The value will remain constant at disk idle time. At busy write time, if
not considering fluctuations, it will also remain high unless be knocked
down by possible concurrent reads that compete for the disk time and
bandwidth with async writes.

The estimation is not done purely in the flusher because there is no
guarantee for write_cache_pages() to return timely to update bandwidth.

The bdi->avg_write_bandwidth smoothing is very effective for filtering
out sudden spikes, however may be a little biased in long term.

The overheads are low because the bdi bandwidth update only occurs at
200ms intervals.

The 200ms update interval is suitable, becuase it's not possible to get
the real bandwidth for the instance at all, due to large fluctuations.

The NFS commits can be as large as seconds worth of data. One XFS
completion may be as large as half second worth of data if we are going
to increase the write chunk to half second worth of data. In ext4,
fluctuations with time period of around 5 seconds is observed. And there
is another pattern of irregular periods of up to 20 seconds on SSD tests.

That's why we are not only doing the estimation at 200ms intervals, but
also averaging them over a period of 3 seconds and then go further to do
another level of smoothing in avg_write_bandwidth.

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

To get an idea of the adaption speed and fluctuation range, here are
some real examples (check the red dots and the yellow line):

http://www.kernel.org/pub/linux/kernel/people/wfg/writeback/dirty-throttling-v8/3G/xfs-1dd-4k-8p-2948M-20:10-3.0.0-rc2-next-20110610+-2011-06-12.21:51/balance_dirty_pages-bandwidth.png
http://www.kernel.org/pub/linux/kernel/people/wfg/writeback/dirty-throttling-v8/3G/ext3-1dd-4k-8p-2948M-20:10-3.0.0-rc2-next-20110610+-2011-06-12.22:02/balance_dirty_pages-bandwidth.png
http://www.kernel.org/pub/linux/kernel/people/wfg/writeback/dirty-throttling-v8/3G/ext4-1dd-4k-8p-2948M-20:10-3.0.0-rc2-next-20110610+-2011-06-12.21:57/balance_dirty_pages-bandwidth.png
http://www.kernel.org/pub/linux/kernel/people/wfg/writeback/dirty-throttling-v8/3G/btrfs-1dd-4k-8p-2948M-20:10-3.0.0-rc2-next-20110610+-2011-06-12.22:07/balance_dirty_pages-bandwidth.png

old version:
http://www.kernel.org/pub/linux/kernel/people/wfg/writeback/dirty-throttling-v6/4G-60%25/ext3-1dd-1M-8p-3911M-60%25-2.6.38-rc5-dt6+-2011-02-22-11-51/balance_dirty_pages-bandwidth.png
http://www.kernel.org/pub/linux/kernel/people/wfg/writeback/dirty-throttling-v6/4G-60%25/xfs-1dd-1M-8p-3911M-60%25-2.6.38-rc5-dt6+-2011-02-22-11-10/balance_dirty_pages-bandwidth.png
http://www.kernel.org/pub/linux/kernel/people/wfg/writeback/dirty-throttling-v6/NFS/nfs-1dd-1M-8p-2945M-20%25-2.6.38-rc6-dt6+-2011-02-22-21-09/balance_dirty_pages-bandwidth.png

--- linux-next.orig/fs/fs-writeback.c	2011-06-23 10:31:40.000000000 +0800
+++ linux-next/fs/fs-writeback.c	2011-06-29 16:23:05.000000000 +0800
@@ -693,6 +693,16 @@ static inline bool over_bground_thresh(v
 }
 
 /*
+ * Called under wb->list_lock. If there are multiple wb per bdi,
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
@@ -710,6 +720,7 @@ static inline bool over_bground_thresh(v
 static long wb_writeback(struct bdi_writeback *wb,
 			 struct wb_writeback_work *work)
 {
+	unsigned long wb_start = jiffies;
 	long nr_pages = work->nr_pages;
 	unsigned long oldest_jif;
 	struct inode *inode;
@@ -758,6 +769,8 @@ static long wb_writeback(struct bdi_writ
 			progress = __writeback_inodes_wb(wb, work);
 		trace_writeback_written(wb->bdi, work);
 
+		wb_update_bandwidth(wb, wb_start);
+
 		/*
 		 * Did we write something? Try for more
 		 *
--- linux-next.orig/include/linux/backing-dev.h	2011-06-23 10:31:40.000000000 +0800
+++ linux-next/include/linux/backing-dev.h	2011-06-29 16:23:05.000000000 +0800
@@ -73,6 +73,11 @@ struct backing_dev_info {
 
 	struct percpu_counter bdi_stat[NR_BDI_STAT_ITEMS];
 
+	unsigned long bw_time_stamp;
+	unsigned long written_stamp;
+	unsigned long write_bandwidth;
+	unsigned long avg_write_bandwidth;
+
 	struct prop_local_percpu completions;
 	int dirty_exceeded;
 
--- linux-next.orig/include/linux/writeback.h	2011-06-23 10:31:40.000000000 +0800
+++ linux-next/include/linux/writeback.h	2011-06-29 16:23:05.000000000 +0800
@@ -118,6 +118,9 @@ void global_dirty_limits(unsigned long *
 unsigned long bdi_dirty_limit(struct backing_dev_info *bdi,
 			       unsigned long dirty);
 
+void __bdi_update_bandwidth(struct backing_dev_info *bdi,
+			    unsigned long start_time);
+
 void page_writeback_init(void);
 void balance_dirty_pages_ratelimited_nr(struct address_space *mapping,
 					unsigned long nr_pages_dirtied);
--- linux-next.orig/mm/backing-dev.c	2011-06-23 10:31:40.000000000 +0800
+++ linux-next/mm/backing-dev.c	2011-06-29 16:23:06.000000000 +0800
@@ -638,6 +638,11 @@ static void bdi_wb_init(struct bdi_write
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
@@ -660,6 +665,13 @@ int bdi_init(struct backing_dev_info *bd
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
--- linux-next.orig/mm/page-writeback.c	2011-06-23 10:31:40.000000000 +0800
+++ linux-next/mm/page-writeback.c	2011-06-29 16:23:44.000000000 +0800
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
+
+	/*
+	 * one more level of smoothing, for filtering out sudden spikes
+	 */
+	if (avg > old && old > cur)
+		avg -= (avg - old) >> 3;
+
+	if (avg < old && old < cur)
+		avg += (old - avg) >> 3;
+
+	bdi->write_bandwidth = cur;
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
 		nr_reclaimable = global_page_state(NR_FILE_DIRTY) +
@@ -545,6 +624,8 @@ static void balance_dirty_pages(struct a
 		if (!bdi->dirty_exceeded)
 			bdi->dirty_exceeded = 1;
 
+		bdi_update_bandwidth(bdi, start_time);
+
 		/* Note: nr_reclaimable denotes nr_dirty + nr_unstable.
 		 * Unstable writes are a feature of certain networked
 		 * filesystems (i.e. NFS) in which data may have been


