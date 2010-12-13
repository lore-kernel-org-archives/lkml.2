Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755862Ab0LMGwW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 01:52:22 -0500
Received: from mga02.intel.com ([134.134.136.20]:28331 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755463Ab0LMGtr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 01:49:47 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,335,1288594800"; 
   d="scan'208";a="583111659"
Message-Id: <20101213064840.285660174@intel.com>
User-Agent: quilt/0.48-1
Date: Mon, 13 Dec 2010 14:43:16 +0800
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
Subject: [PATCH 27/47] writeback: user space think time compensation
References: <20101213064249.648862451@intel.com>
Content-Disposition: inline; filename=writeback-task-last-dirty-time.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Take the task's think time into account when computing the final pause time.
This will make accurate throttle bandwidth. In the rare case that the task
slept longer than the period time, the extra sleep time will also be
compensated in next period if it's not too big (<100ms).  Accumulated
errors are carefully avoided as long as the task don't sleep for too
long time.

case 1: period > think

		pause = period - think
		paused_when += pause

			     period time
	      |======================================>|
		  think time
	      |===============>|
	------|----------------|----------------------|-----------
	paused_when         jiffies


case 2: period <= think

		don't pause and reduce future pause time by:
		paused_when += period

		       period time
	      |=========================>|
			     think time
	      |======================================>|
	------|--------------------------+------------|-----------
	paused_when                                jiffies


Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 include/linux/sched.h |    1 +
 mm/page-writeback.c   |   22 ++++++++++++++++++++--
 2 files changed, 21 insertions(+), 2 deletions(-)

--- linux-next.orig/include/linux/sched.h	2010-12-09 11:50:59.000000000 +0800
+++ linux-next/include/linux/sched.h	2010-12-09 11:54:28.000000000 +0800
@@ -1477,6 +1477,7 @@ struct task_struct {
 	 */
 	int nr_dirtied;
 	int nr_dirtied_pause;
+	unsigned long paused_when;	/* start of a write-and-pause period */
 
 #ifdef CONFIG_LATENCYTOP
 	int latency_record_count;
--- linux-next.orig/mm/page-writeback.c	2010-12-09 11:54:10.000000000 +0800
+++ linux-next/mm/page-writeback.c	2010-12-09 12:00:53.000000000 +0800
@@ -597,6 +597,7 @@ static void balance_dirty_pages(struct a
 	unsigned long bdi_thresh;
 	unsigned long task_thresh;
 	unsigned long long bw;
+	unsigned long period;
 	unsigned long pause = 0;
 	bool dirty_exceeded = false;
 	struct backing_dev_info *bdi = mapping->backing_dev_info;
@@ -667,7 +668,7 @@ static void balance_dirty_pages(struct a
 
 		bdi_update_bandwidth(bdi, start_time, bdi_dirty, bdi_thresh);
 
-		if (bdi_dirty >= task_thresh) {
+		if (bdi_dirty >= task_thresh || nr_dirty > dirty_thresh) {
 			pause = MAX_PAUSE;
 			goto pause;
 		}
@@ -686,7 +687,22 @@ static void balance_dirty_pages(struct a
 		bw = bw * (task_thresh - bdi_dirty);
 		do_div(bw, bdi_thresh / TASK_SOFT_DIRTY_LIMIT + 1);
 
-		pause = HZ * pages_dirtied / ((unsigned long)bw + 1);
+		period = HZ * pages_dirtied / ((unsigned long)bw + 1) + 1;
+		pause = current->paused_when + period - jiffies;
+		/*
+		 * Take it as long think time if pause falls into (-10s, 0).
+		 * If it's less than 100ms, try to compensate it in future by
+		 * updating the virtual time; otherwise just reset the time, as
+		 * it may be a light dirtier.
+		 */
+		if (unlikely(-pause < HZ*10)) {
+			if (-pause <= HZ/10)
+				current->paused_when += period;
+			else
+				current->paused_when = jiffies;
+			pause = 1;
+			break;
+		}
 		pause = clamp_val(pause, 1, MAX_PAUSE);
 
 pause:
@@ -696,8 +712,10 @@ pause:
 					  task_thresh,
 					  pages_dirtied,
 					  pause);
+		current->paused_when = jiffies;
 		__set_current_state(TASK_UNINTERRUPTIBLE);
 		io_schedule_timeout(pause);
+		current->paused_when += pause;
 
 		/*
 		 * The bdi thresh is somehow "soft" limit derived from the


