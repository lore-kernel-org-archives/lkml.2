Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932350Ab0LMGzp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 01:55:45 -0500
Received: from mga11.intel.com ([192.55.52.93]:10937 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753867Ab0LMGtn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 01:49:43 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,335,1288594800"; 
   d="scan'208";a="867484068"
Message-Id: <20101213064837.909758859@intel.com>
User-Agent: quilt/0.48-1
Date: Mon, 13 Dec 2010 14:42:57 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: Jan Kara <jack@suse.cz>, Li Shaohua <shaohua.li@intel.com>,
        Wu Fengguang <fengguang.wu@intel.com>
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
Cc: linux-mm <linux-mm@kvack.org>
Cc: <linux-fsdevel@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 08/47] writeback: bdi write bandwidth estimation
References: <20101213064249.648862451@intel.com>
Content-Disposition: inline; filename=writeback-bandwidth-estimation-in-flusher.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The estimation value will start from 100MB/s and adapt to the real
bandwidth in seconds.  It's pretty accurate for common filesystems.

As the first use case, it replaces the fixed 100MB/s value used for
throttle bandwidth calculation in balance_dirty_pages().

The overheads won't be high because the bdi bandwidth update only occurs
in >10ms intervals.

Initially it's only estimated in balance_dirty_pages() because this is
the most reliable place to get reasonable large bandwidth -- the bdi is
normally fully utilized when bdi_thresh is reached.

Then Shaohua recommends to also do it in the flusher thread, to keep the
value updated when there are only periodic/background writeback and no
tasks throttled.

The estimation cannot be done purely in the flusher thread because it's
not sufficient for NFS. NFS writeback won't block at get_request_wait(),
so tend to complete quickly. Another problem is, slow devices may take
dozens of seconds to write the initial 64MB chunk (write_bandwidth
starts with 100MB/s, this translates to 64MB nr_to_write). So it may
take more than 1 minute to adapt to the smallish bandwidth if the
bandwidth is only updated in the flusher thread.

CC: Li Shaohua <shaohua.li@intel.com>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 fs/fs-writeback.c           |    5 ++++
 include/linux/backing-dev.h |    2 +
 include/linux/writeback.h   |    3 ++
 mm/backing-dev.c            |    1 
 mm/page-writeback.c         |   41 +++++++++++++++++++++++++++++++++-
 5 files changed, 51 insertions(+), 1 deletion(-)

--- linux-next.orig/include/linux/backing-dev.h	2010-12-08 22:44:24.000000000 +0800
+++ linux-next/include/linux/backing-dev.h	2010-12-08 22:44:24.000000000 +0800
@@ -75,6 +75,8 @@ struct backing_dev_info {
 	struct percpu_counter bdi_stat[NR_BDI_STAT_ITEMS];
 
 	struct prop_local_percpu completions;
+	unsigned long write_bandwidth_update_time;
+	int write_bandwidth;
 	int dirty_exceeded;
 
 	unsigned int min_ratio;
--- linux-next.orig/mm/backing-dev.c	2010-12-08 22:44:24.000000000 +0800
+++ linux-next/mm/backing-dev.c	2010-12-08 22:44:24.000000000 +0800
@@ -660,6 +660,7 @@ int bdi_init(struct backing_dev_info *bd
 			goto err;
 	}
 
+	bdi->write_bandwidth = 100 << 20;
 	bdi->dirty_exceeded = 0;
 	err = prop_local_init_percpu(&bdi->completions);
 
--- linux-next.orig/fs/fs-writeback.c	2010-12-08 22:44:22.000000000 +0800
+++ linux-next/fs/fs-writeback.c	2010-12-08 22:44:24.000000000 +0800
@@ -635,6 +635,8 @@ static long wb_writeback(struct bdi_writ
 		.range_cyclic		= work->range_cyclic,
 	};
 	unsigned long oldest_jif;
+	unsigned long bw_time;
+	s64 bw_written = 0;
 	long wrote = 0;
 	long write_chunk;
 	struct inode *inode;
@@ -668,6 +670,8 @@ static long wb_writeback(struct bdi_writ
 		write_chunk = LONG_MAX;
 
 	wbc.wb_start = jiffies; /* livelock avoidance */
+	bdi_update_write_bandwidth(wb->bdi, &bw_time, &bw_written);
+
 	for (;;) {
 		/*
 		 * Stop writeback when nr_pages has been consumed
@@ -702,6 +706,7 @@ static long wb_writeback(struct bdi_writ
 		else
 			writeback_inodes_wb(wb, &wbc);
 		trace_wbc_writeback_written(&wbc, wb->bdi);
+		bdi_update_write_bandwidth(wb->bdi, &bw_time, &bw_written);
 
 		work->nr_pages -= write_chunk - wbc.nr_to_write;
 		wrote += write_chunk - wbc.nr_to_write;
--- linux-next.orig/mm/page-writeback.c	2010-12-08 22:44:24.000000000 +0800
+++ linux-next/mm/page-writeback.c	2010-12-08 22:44:24.000000000 +0800
@@ -515,6 +515,41 @@ out:
 	return 1 + int_sqrt(dirty_thresh - dirty_pages);
 }
 
+void bdi_update_write_bandwidth(struct backing_dev_info *bdi,
+				unsigned long *bw_time,
+				s64 *bw_written)
+{
+	unsigned long written;
+	unsigned long elapsed;
+	unsigned long bw;
+	unsigned long w;
+
+	if (*bw_written == 0)
+		goto snapshot;
+
+	elapsed = jiffies - *bw_time;
+	if (elapsed < HZ/100)
+		return;
+
+	/*
+	 * When there lots of tasks throttled in balance_dirty_pages(), they
+	 * will each try to update the bandwidth for the same period, making
+	 * the bandwidth drift much faster than the desired rate (as in the
+	 * single dirtier case). So do some rate limiting.
+	 */
+	if (jiffies - bdi->write_bandwidth_update_time < elapsed)
+		goto snapshot;
+
+	written = percpu_counter_read(&bdi->bdi_stat[BDI_WRITTEN]) - *bw_written;
+	bw = (HZ * PAGE_CACHE_SIZE * written + elapsed/2) / elapsed;
+	w = min(elapsed / (HZ/100), 128UL);
+	bdi->write_bandwidth = (bdi->write_bandwidth * (1024-w) + bw * w) >> 10;
+	bdi->write_bandwidth_update_time = jiffies;
+snapshot:
+	*bw_written = percpu_counter_read(&bdi->bdi_stat[BDI_WRITTEN]);
+	*bw_time = jiffies;
+}
+
 /*
  * balance_dirty_pages() must be called by processes which are generating dirty
  * data.  It looks at the number of dirty pages in the machine and will force
@@ -535,6 +570,8 @@ static void balance_dirty_pages(struct a
 	unsigned long pause = 0;
 	bool dirty_exceeded = false;
 	struct backing_dev_info *bdi = mapping->backing_dev_info;
+	unsigned long bw_time;
+	s64 bw_written = 0;
 
 	for (;;) {
 		/*
@@ -583,7 +620,7 @@ static void balance_dirty_pages(struct a
 			goto pause;
 		}
 
-		bw = 100 << 20; /* use static 100MB/s for the moment */
+		bw = bdi->write_bandwidth;
 
 		bw = bw * (bdi_thresh - bdi_dirty);
 		bw = bw / (bdi_thresh / TASK_SOFT_DIRTY_LIMIT + 1);
@@ -592,8 +629,10 @@ static void balance_dirty_pages(struct a
 		pause = clamp_val(pause, 1, HZ/10);
 
 pause:
+		bdi_update_write_bandwidth(bdi, &bw_time, &bw_written);
 		__set_current_state(TASK_INTERRUPTIBLE);
 		io_schedule_timeout(pause);
+		bdi_update_write_bandwidth(bdi, &bw_time, &bw_written);
 
 		/*
 		 * The bdi thresh is somehow "soft" limit derived from the
--- linux-next.orig/include/linux/writeback.h	2010-12-08 22:44:22.000000000 +0800
+++ linux-next/include/linux/writeback.h	2010-12-08 22:44:24.000000000 +0800
@@ -138,6 +138,9 @@ void global_dirty_limits(unsigned long *
 unsigned long bdi_dirty_limit(struct backing_dev_info *bdi,
 			       unsigned long dirty,
 			       unsigned long dirty_pages);
+void bdi_update_write_bandwidth(struct backing_dev_info *bdi,
+				unsigned long *bw_time,
+				s64 *bw_written);
 
 void page_writeback_init(void);
 void balance_dirty_pages_ratelimited_nr(struct address_space *mapping,


