Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755682Ab1DPOEp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Apr 2011 10:04:45 -0400
Received: from mga02.intel.com ([134.134.136.20]:50901 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754312Ab1DPODh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Apr 2011 10:03:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,223,1301900400"; 
   d="scan'208";a="734315230"
Message-Id: <20110416134333.820103797@intel.com>
User-Agent: quilt/0.48-1
Date: Sat, 16 Apr 2011 21:25:57 +0800
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
CC: Vivek Goyal <vgoyal@redhat.com>
CC: Andrea Righi <arighi@develer.com>
CC: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: linux-mm <linux-mm@kvack.org>
Cc: <linux-fsdevel@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 11/12] writeback: trace balance_dirty_pages
References: <20110416132546.765212221@intel.com>
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

Trace outputs (an old version) within 0.1 second, grouped by tasks:

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
 include/trace/events/writeback.h |   80 +++++++++++++++++++++++++++++
 mm/page-writeback.c              |   20 +++++++
 2 files changed, 100 insertions(+)

--- linux-next.orig/include/trace/events/writeback.h	2011-04-16 11:28:27.000000000 +0800
+++ linux-next/include/trace/events/writeback.h	2011-04-16 11:28:28.000000000 +0800
@@ -197,6 +197,86 @@ TRACE_EVENT(dirty_ratelimit,
 	)
 );
 
+TRACE_EVENT(balance_dirty_pages,
+
+	TP_PROTO(struct backing_dev_info *bdi,
+		 unsigned long thresh,
+		 unsigned long dirty,
+		 unsigned long bdi_dirty,
+		 unsigned long base_bw,
+		 unsigned long task_bw,
+		 unsigned long dirtied,
+		 unsigned long period,
+		 long pause,
+		 unsigned long start_time),
+
+	TP_ARGS(bdi, thresh, dirty, bdi_dirty,
+		base_bw, task_bw, dirtied, period, pause, start_time),
+
+	TP_STRUCT__entry(
+		__array(	 char,	bdi, 32)
+		__field(unsigned long,	limit)
+		__field(unsigned long,	goal)
+		__field(unsigned long,	dirty)
+		__field(unsigned long,	bdi_goal)
+		__field(unsigned long,	bdi_dirty)
+		__field(unsigned long,	avg_dirty)
+		__field(unsigned long,	base_bw)
+		__field(unsigned long,	task_bw)
+		__field(unsigned int,	dirtied)
+		__field(unsigned int,	dirtied_pause)
+		__field(unsigned long,	period)
+		__field(	 long,	think)
+		__field(	 long,	pause)
+		__field(unsigned long,	paused)
+	),
+
+	TP_fast_assign(
+		strlcpy(__entry->bdi, dev_name(bdi->dev), 32);
+
+		__entry->limit = default_backing_dev_info.dirty_threshold;
+		__entry->goal		= thresh - thresh / DIRTY_SCOPE;
+		__entry->dirty		= dirty;
+		__entry->bdi_goal	= bdi->dirty_threshold -
+					  bdi->dirty_threshold / DIRTY_SCOPE;
+		__entry->bdi_dirty	= bdi_dirty;
+		__entry->avg_dirty	= bdi->avg_dirty;
+		__entry->base_bw	= KBps(base_bw);
+		__entry->task_bw	= KBps(task_bw);
+		__entry->dirtied	= dirtied;
+		__entry->dirtied_pause	= current->nr_dirtied_pause;
+		__entry->think		= current->paused_when == 0 ? 0 :
+			 (long)(jiffies - current->paused_when) * 1000 / HZ;
+		__entry->period		= period * 1000 / HZ;
+		__entry->pause		= pause * 1000 / HZ;
+		__entry->paused		= (jiffies - start_time) * 1000 / HZ;
+	),
+
+
+	TP_printk("bdi %s: "
+		  "limit=%lu goal=%lu dirty=%lu "
+		  "bdi_goal=%lu bdi_dirty=%lu avg_dirty=%lu "
+		  "base_bw=%lu task_bw=%lu "
+		  "dirtied=%u dirtied_pause=%u "
+		  "period=%lu think=%ld pause=%ld paused=%lu",
+		  __entry->bdi,
+		  __entry->limit,
+		  __entry->goal,
+		  __entry->dirty,
+		  __entry->bdi_goal,
+		  __entry->bdi_dirty,
+		  __entry->avg_dirty,
+		  __entry->base_bw,	/* base throttle bandwidth */
+		  __entry->task_bw,	/* task throttle bandwidth */
+		  __entry->dirtied,
+		  __entry->dirtied_pause,
+		  __entry->period,	/* ms */
+		  __entry->think,	/* ms */
+		  __entry->pause,	/* ms */
+		  __entry->paused	/* ms */
+		  )
+);
+
 DECLARE_EVENT_CLASS(writeback_congest_waited_template,
 
 	TP_PROTO(unsigned int usec_timeout, unsigned int usec_delayed),
--- linux-next.orig/mm/page-writeback.c	2011-04-16 11:28:27.000000000 +0800
+++ linux-next/mm/page-writeback.c	2011-04-16 11:28:28.000000000 +0800
@@ -1163,6 +1163,16 @@ static void balance_dirty_pages(struct a
 		 * it may be a light dirtier.
 		 */
 		if (unlikely(-pause < HZ*10)) {
+			trace_balance_dirty_pages(bdi,
+						  dirty_thresh,
+						  nr_dirty,
+						  bdi_dirty,
+						  base_bw,
+						  bw,
+						  pages_dirtied,
+						  period,
+						  pause,
+						  start_time);
 			if (-pause > HZ/2) {
 				current->paused_when = now;
 				current->nr_dirtied = 0;
@@ -1176,6 +1186,16 @@ static void balance_dirty_pages(struct a
 		pause = min(pause, pause_max);
 
 pause:
+		trace_balance_dirty_pages(bdi,
+					  dirty_thresh,
+					  nr_dirty,
+					  bdi_dirty,
+					  base_bw,
+					  bw,
+					  pages_dirtied,
+					  period,
+					  pause,
+					  start_time);
 		current->paused_when = now;
 		__set_current_state(TASK_UNINTERRUPTIBLE);
 		io_schedule_timeout(pause);


