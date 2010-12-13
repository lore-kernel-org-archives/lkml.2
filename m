Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932248Ab0LMGyp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 01:54:45 -0500
Received: from mga11.intel.com ([192.55.52.93]:4455 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755351Ab0LMGto (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 01:49:44 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,335,1288594800"; 
   d="scan'208";a="635713518"
Message-Id: <20101213064840.918401954@intel.com>
User-Agent: quilt/0.48-1
Date: Mon, 13 Dec 2010 14:43:21 +0800
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
Subject: [PATCH 32/47] writeback: extend balance_dirty_pages() trace event
References: <20101213064249.648862451@intel.com>
Content-Disposition: inline; filename=writeback-trace-add-fields.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make it more useful for analyzing the dynamics of the throttling
algorithms, and helpful for debugging user reported problems.

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 include/trace/events/writeback.h |   52 +++++++++++++++++++++--------
 mm/page-writeback.c              |   14 +++++++
 2 files changed, 53 insertions(+), 13 deletions(-)

--- linux-next.orig/include/trace/events/writeback.h	2010-12-09 12:21:04.000000000 +0800
+++ linux-next/include/trace/events/writeback.h	2010-12-09 12:24:49.000000000 +0800
@@ -149,35 +149,53 @@ DEFINE_WBC_EVENT(wbc_writeback_written);
 DEFINE_WBC_EVENT(wbc_writeback_wait);
 DEFINE_WBC_EVENT(wbc_writepage);
 
+#define KBps(x)			((x) << (PAGE_SHIFT - 10))
 #define BDP_PERCENT(a, b, c)	((__entry->a - __entry->b) * 100 * c + \
 				  __entry->bdi_limit/2) / (__entry->bdi_limit|1)
+
 TRACE_EVENT(balance_dirty_pages,
 
 	TP_PROTO(struct backing_dev_info *bdi,
 		 long bdi_dirty,
+		 long avg_dirty,
 		 long bdi_limit,
 		 long task_limit,
-		 long pages_dirtied,
+		 long dirtied,
+		 long task_bw,
+		 long period,
 		 long pause),
 
-	TP_ARGS(bdi, bdi_dirty, bdi_limit, task_limit,
-		pages_dirtied, pause),
+	TP_ARGS(bdi, bdi_dirty, avg_dirty, bdi_limit, task_limit,
+		dirtied, task_bw, period, pause),
 
 	TP_STRUCT__entry(
 		__array(char,	bdi, 32)
 		__field(long,	bdi_dirty)
+		__field(long,	avg_dirty)
 		__field(long,	bdi_limit)
 		__field(long,	task_limit)
-		__field(long,	pages_dirtied)
+		__field(long,	dirtied)
+		__field(long,	bdi_bw)
+		__field(long,	base_bw)
+		__field(long,	task_bw)
+		__field(long,	period)
+		__field(long,	think)
 		__field(long,	pause)
 	),
 
 	TP_fast_assign(
 		strlcpy(__entry->bdi, dev_name(bdi->dev), 32);
 		__entry->bdi_dirty	= bdi_dirty;
+		__entry->avg_dirty	= avg_dirty;
 		__entry->bdi_limit	= bdi_limit;
 		__entry->task_limit	= task_limit;
-		__entry->pages_dirtied	= pages_dirtied;
+		__entry->dirtied	= dirtied;
+		__entry->bdi_bw		= KBps(bdi->write_bandwidth);
+		__entry->base_bw	= KBps(bdi->throttle_bandwidth);
+		__entry->task_bw	= KBps(task_bw);
+		__entry->think		= current->paused_when == 0 ? 0 :
+			 (long)(jiffies - current->paused_when) * 1000 / HZ;
+		__entry->period		= period * 1000 / HZ;
 		__entry->pause		= pause * 1000 / HZ;
 	),
 
@@ -191,19 +209,27 @@ TRACE_EVENT(balance_dirty_pages,
 	 *
 	 * Reasonable large gaps help produce smooth pause times.
 	 */
-	TP_printk("bdi=%s bdi_dirty=%lu bdi_limit=%lu task_limit=%lu "
-		  "task_weight=%ld%% task_gap=%ld%% bdi_gap=%ld%% "
-		  "pages_dirtied=%lu pause=%lu",
+	TP_printk("bdi %s: "
+		  "bdi_limit=%lu task_limit=%lu bdi_dirty=%lu avg_dirty=%lu "
+		  "bdi_gap=%ld%% task_gap=%ld%% task_weight=%ld%% "
+		  "bdi_bw=%lu base_bw=%lu task_bw=%lu "
+		  "dirtied=%lu period=%lu think=%ld pause=%ld",
 		  __entry->bdi,
-		  __entry->bdi_dirty,
 		  __entry->bdi_limit,
 		  __entry->task_limit,
+		  __entry->bdi_dirty,
+		  __entry->avg_dirty,
+		  BDP_PERCENT(bdi_limit, bdi_dirty, BDI_SOFT_DIRTY_LIMIT),
+		  BDP_PERCENT(task_limit, avg_dirty, TASK_SOFT_DIRTY_LIMIT),
 		  /* task weight: proportion of recent dirtied pages */
 		  BDP_PERCENT(bdi_limit, task_limit, TASK_SOFT_DIRTY_LIMIT),
-		  BDP_PERCENT(task_limit, bdi_dirty, TASK_SOFT_DIRTY_LIMIT),
-		  BDP_PERCENT(bdi_limit, bdi_dirty, BDI_SOFT_DIRTY_LIMIT),
-		  __entry->pages_dirtied,
-		  __entry->pause
+		  __entry->bdi_bw,	/* bdi write bandwidth */
+		  __entry->base_bw,	/* bdi base throttle bandwidth */
+		  __entry->task_bw,	/* task throttle bandwidth */
+		  __entry->dirtied,
+		  __entry->period,	/* ms */
+		  __entry->think,	/* ms */
+		  __entry->pause	/* ms */
 		  )
 );
 
--- linux-next.orig/mm/page-writeback.c	2010-12-09 12:24:47.000000000 +0800
+++ linux-next/mm/page-writeback.c	2010-12-09 12:24:49.000000000 +0800
@@ -785,6 +785,8 @@ static void balance_dirty_pages(struct a
 		pause_max = max_pause(bdi_thresh);
 
 		if (avg_dirty >= task_thresh || nr_dirty > dirty_thresh) {
+			bw = 0;
+			period = 0;
 			pause = pause_max;
 			goto pause;
 		}
@@ -812,6 +814,15 @@ static void balance_dirty_pages(struct a
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
@@ -824,9 +835,12 @@ static void balance_dirty_pages(struct a
 pause:
 		trace_balance_dirty_pages(bdi,
 					  bdi_dirty,
+					  avg_dirty,
 					  bdi_thresh,
 					  task_thresh,
 					  pages_dirtied,
+					  bw,
+					  period,
 					  pause);
 		current->paused_when = jiffies;
 		__set_current_state(TASK_UNINTERRUPTIBLE);


