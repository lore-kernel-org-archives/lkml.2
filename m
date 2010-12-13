Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932211Ab0LMPP5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 10:15:57 -0500
Received: from mga11.intel.com ([192.55.52.93]:65468 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752987Ab0LMPIt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 10:08:49 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,336,1288594800"; 
   d="scan'208";a="867612935"
Message-Id: <20101213150328.886689684@intel.com>
User-Agent: quilt/0.48-1
Date: Mon, 13 Dec 2010 22:47:07 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: Jan Kara <jack@suse.cz>, Wu Fengguang <fengguang.wu@intel.com>
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
Subject: [PATCH 21/35] writeback: trace balance_dirty_pages()
References: <20101213144646.341970461@intel.com>
Content-Disposition: inline; filename=writeback-trace-balance_dirty_pages.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It would be useful for analyzing the dynamics of the throttling
algorithms, and helpful for debugging user reported problems.

Here is an interesting test to verify the theory with balance_dirty_pages()
tracing. On a partition that can do ~60MB/s, a sparse file is created and
4 rsync tasks with different write bandwidth started:

	dd if=/dev/zero of=/mnt/1T bs=1M count=1 seek=1024000
	echo 1 > /debug/tracing/events/writeback/balance_dirty_pages/enable

	rsync localhost:/mnt/1T /mnt/a --bwlimit 10000&
	rsync localhost:/mnt/1T /mnt/A --bwlimit 10000&
	rsync localhost:/mnt/1T /mnt/b --bwlimit 20000&
	rsync localhost:/mnt/1T /mnt/c --bwlimit 30000&

Trace outputs within 0.1 second, grouped by tasks:

rsync-3824  [004] 15002.076447: balance_dirty_pages: bdi=btrfs-2 weight=15% limit=130876 gap=5340 dirtied=192 pause=20

rsync-3822  [003] 15002.091701: balance_dirty_pages: bdi=btrfs-2 weight=15% limit=130777 gap=5113 dirtied=192 pause=20

rsync-3821  [006] 15002.004667: balance_dirty_pages: bdi=btrfs-2 weight=30% limit=129570 gap=3714 dirtied=64 pause=8
rsync-3821  [006] 15002.012654: balance_dirty_pages: bdi=btrfs-2 weight=30% limit=129589 gap=3733 dirtied=64 pause=8
rsync-3821  [006] 15002.021838: balance_dirty_pages: bdi=btrfs-2 weight=30% limit=129604 gap=3748 dirtied=64 pause=8
rsync-3821  [004] 15002.091193: balance_dirty_pages: bdi=btrfs-2 weight=29% limit=129583 gap=3983 dirtied=64 pause=8
rsync-3821  [004] 15002.102729: balance_dirty_pages: bdi=btrfs-2 weight=29% limit=129594 gap=3802 dirtied=64 pause=8
rsync-3821  [000] 15002.109252: balance_dirty_pages: bdi=btrfs-2 weight=29% limit=129619 gap=3827 dirtied=64 pause=8

rsync-3823  [002] 15002.009029: balance_dirty_pages: bdi=btrfs-2 weight=39% limit=128762 gap=2842 dirtied=64 pause=12
rsync-3823  [002] 15002.021598: balance_dirty_pages: bdi=btrfs-2 weight=39% limit=128813 gap=3021 dirtied=64 pause=12
rsync-3823  [003] 15002.032973: balance_dirty_pages: bdi=btrfs-2 weight=39% limit=128805 gap=2885 dirtied=64 pause=12
rsync-3823  [003] 15002.048800: balance_dirty_pages: bdi=btrfs-2 weight=39% limit=128823 gap=2967 dirtied=64 pause=12
rsync-3823  [003] 15002.060728: balance_dirty_pages: bdi=btrfs-2 weight=39% limit=128821 gap=3221 dirtied=64 pause=12
rsync-3823  [000] 15002.073152: balance_dirty_pages: bdi=btrfs-2 weight=39% limit=128825 gap=3225 dirtied=64 pause=12
rsync-3823  [005] 15002.090111: balance_dirty_pages: bdi=btrfs-2 weight=39% limit=128782 gap=3214 dirtied=64 pause=12
rsync-3823  [004] 15002.102520: balance_dirty_pages: bdi=btrfs-2 weight=39% limit=128764 gap=3036 dirtied=64 pause=12

The data vividly show that

- the heaviest writer is throttled a bit (weight=39%)

- the lighter writers run at full speed (weight=15%,15%,30%)

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 include/trace/events/writeback.h |   87 ++++++++++++++++++++++++++++-
 mm/page-writeback.c              |   20 ++++++
 2 files changed, 104 insertions(+), 3 deletions(-)

--- linux-next.orig/include/trace/events/writeback.h	2010-12-13 21:46:09.000000000 +0800
+++ linux-next/include/trace/events/writeback.h	2010-12-13 21:46:18.000000000 +0800
@@ -147,11 +147,92 @@ DEFINE_EVENT(wbc_class, name, \
 DEFINE_WBC_EVENT(wbc_writeback_start);
 DEFINE_WBC_EVENT(wbc_writeback_written);
 DEFINE_WBC_EVENT(wbc_writeback_wait);
-DEFINE_WBC_EVENT(wbc_balance_dirty_start);
-DEFINE_WBC_EVENT(wbc_balance_dirty_written);
-DEFINE_WBC_EVENT(wbc_balance_dirty_wait);
 DEFINE_WBC_EVENT(wbc_writepage);
 
+#define KBps(x)			((x) << (PAGE_SHIFT - 10))
+#define BDP_PERCENT(a, b, c)	(((__entry->a) - (__entry->b)) * 100 * (c) + \
+				  __entry->bdi_limit/2) / (__entry->bdi_limit|1)
+
+TRACE_EVENT(balance_dirty_pages,
+
+	TP_PROTO(struct backing_dev_info *bdi,
+		 long bdi_dirty,
+		 long avg_dirty,
+		 long bdi_limit,
+		 long task_limit,
+		 long dirtied,
+		 long task_bw,
+		 long period,
+		 long pause),
+
+	TP_ARGS(bdi, bdi_dirty, avg_dirty, bdi_limit, task_limit,
+		dirtied, task_bw, period, pause),
+
+	TP_STRUCT__entry(
+		__array(char,	bdi, 32)
+		__field(long,	bdi_dirty)
+		__field(long,	avg_dirty)
+		__field(long,	bdi_limit)
+		__field(long,	task_limit)
+		__field(long,	dirtied)
+		__field(long,	bdi_bw)
+		__field(long,	base_bw)
+		__field(long,	task_bw)
+		__field(long,	period)
+		__field(long,	think)
+		__field(long,	pause)
+	),
+
+	TP_fast_assign(
+		strlcpy(__entry->bdi, dev_name(bdi->dev), 32);
+		__entry->bdi_dirty	= bdi_dirty;
+		__entry->avg_dirty	= avg_dirty;
+		__entry->bdi_limit	= bdi_limit;
+		__entry->task_limit	= task_limit;
+		__entry->dirtied	= dirtied;
+		__entry->bdi_bw		= KBps(bdi->write_bandwidth);
+		__entry->base_bw	= KBps(bdi->throttle_bandwidth);
+		__entry->task_bw	= KBps(task_bw);
+		__entry->think		= current->paused_when == 0 ? 0 :
+			 (long)(jiffies - current->paused_when) * 1000 / HZ;
+		__entry->period		= period * 1000 / HZ;
+		__entry->pause		= pause * 1000 / HZ;
+	),
+
+
+	/*
+	 *            [..............soft throttling range............]
+	 *            ^               |<=========== bdi_gap =========>|
+	 * (background+dirty)/2       |<== task_gap ==>|
+	 * -------------------|-------+----------------|--------------|
+	 *   (bdi_limit * 7/8)^       ^bdi_dirty       ^task_limit    ^bdi_limit
+	 *
+	 * Reasonable large gaps help produce smooth pause times.
+	 */
+	TP_printk("bdi %s: "
+		  "bdi_limit=%lu task_limit=%lu bdi_dirty=%lu avg_dirty=%lu "
+		  "bdi_gap=%ld%% task_gap=%ld%% task_weight=%ld%% "
+		  "bdi_bw=%lu base_bw=%lu task_bw=%lu "
+		  "dirtied=%lu period=%lu think=%ld pause=%ld",
+		  __entry->bdi,
+		  __entry->bdi_limit,
+		  __entry->task_limit,
+		  __entry->bdi_dirty,
+		  __entry->avg_dirty,
+		  BDP_PERCENT(bdi_limit, bdi_dirty, BDI_SOFT_DIRTY_LIMIT),
+		  BDP_PERCENT(task_limit, avg_dirty, TASK_SOFT_DIRTY_LIMIT),
+		  /* task weight: proportion of recent dirtied pages */
+		  BDP_PERCENT(bdi_limit, task_limit, TASK_SOFT_DIRTY_LIMIT),
+		  __entry->bdi_bw,	/* bdi write bandwidth */
+		  __entry->base_bw,	/* bdi base throttle bandwidth */
+		  __entry->task_bw,	/* task throttle bandwidth */
+		  __entry->dirtied,
+		  __entry->period,	/* ms */
+		  __entry->think,	/* ms */
+		  __entry->pause	/* ms */
+		  )
+);
+
 DECLARE_EVENT_CLASS(writeback_congest_waited_template,
 
 	TP_PROTO(unsigned int usec_timeout, unsigned int usec_delayed),
--- linux-next.orig/mm/page-writeback.c	2010-12-13 21:46:17.000000000 +0800
+++ linux-next/mm/page-writeback.c	2010-12-13 21:46:18.000000000 +0800
@@ -778,6 +778,8 @@ static void balance_dirty_pages(struct a
 		pause_max = max_pause(bdi_thresh);
 
 		if (avg_dirty >= task_thresh || nr_dirty > dirty_thresh) {
+			bw = 0;
+			period = 0;
 			pause = pause_max;
 			goto pause;
 		}
@@ -805,6 +807,15 @@ static void balance_dirty_pages(struct a
 		 * it may be a light dirtier.
 		 */
 		if (unlikely(-pause < HZ*10)) {
+			trace_balance_dirty_pages(bdi,
+						  bdi_dirty,
+						  avg_dirty,
+						  bdi_thresh,
+						  task_thresh,
+						  pages_dirtied,
+						  bw,
+						  period,
+						  pause);
 			if (-pause <= HZ/10)
 				current->paused_when += period;
 			else
@@ -815,6 +826,15 @@ static void balance_dirty_pages(struct a
 		pause = clamp_val(pause, 1, pause_max);
 
 pause:
+		trace_balance_dirty_pages(bdi,
+					  bdi_dirty,
+					  avg_dirty,
+					  bdi_thresh,
+					  task_thresh,
+					  pages_dirtied,
+					  bw,
+					  period,
+					  pause);
 		current->paused_when = jiffies;
 		__set_current_state(TASK_UNINTERRUPTIBLE);
 		io_schedule_timeout(pause);


