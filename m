Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754719Ab1KUNP6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 08:15:58 -0500
Received: from mga03.intel.com ([143.182.124.21]:51780 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754035Ab1KUNPl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 08:15:41 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,547,1315206000"; 
   d="scan'208";a="77539451"
Message-Id: <20111121131216.159488456@intel.com>
User-Agent: quilt/0.48-1
Date: Mon, 21 Nov 2011 21:03:47 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
to: <linux-fsdevel@vger.kernel.org>
cc: Jan Kara <jack@suse.cz>, Wu Fengguang <fengguang.wu@intel.com>
cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Christoph Hellwig <hch@lst.de>
cc: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 5/5] writeback: dirty ratelimit - think time compensation
References: <20111121130342.211953629@intel.com>
Content-Disposition: inline; filename=think-time-compensation
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Compensate the task's think time when computing the final pause time,
so that ->dirty_ratelimit can be executed accurately.

        think time := time spend outside of balance_dirty_pages()

In the rare case that the task slept longer than the 200ms period time
(result in negative pause time), the sleep time will be compensated in
the following periods, too, if it's less than 1 second.

Accumulated errors are carefully avoided as long as the max pause area
is not hitted.

Pseudo code:

        period = pages_dirtied / task_ratelimit;
        think = jiffies - dirty_paused_when;
        pause = period - think;

1) normal case: period > think

        pause = period - think
        dirty_paused_when = jiffies + pause
        nr_dirtied = 0

                             period time
              |===============================>|
                  think time      pause time
              |===============>|==============>|
        ------|----------------|---------------|------------------------
        dirty_paused_when   jiffies


2) no pause case: period <= think

        don't pause; reduce future pause time by:
        dirty_paused_when += period
        nr_dirtied = 0

                           period time
              |===============================>|
                                  think time
              |===================================================>|
        ------|--------------------------------+-------------------|----
        dirty_paused_when                                       jiffies

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 include/linux/sched.h            |    1 
 include/trace/events/writeback.h |   14 ++++++++---
 kernel/fork.c                    |    1 
 mm/page-writeback.c              |   36 +++++++++++++++++++++++++----
 4 files changed, 45 insertions(+), 7 deletions(-)

--- linux-next.orig/include/linux/sched.h	2011-11-17 20:12:22.000000000 +0800
+++ linux-next/include/linux/sched.h	2011-11-17 20:12:35.000000000 +0800
@@ -1527,6 +1527,7 @@ struct task_struct {
 	 */
 	int nr_dirtied;
 	int nr_dirtied_pause;
+	unsigned long dirty_paused_when; /* start of a write-and-pause period */
 
 #ifdef CONFIG_LATENCYTOP
 	int latency_record_count;
--- linux-next.orig/mm/page-writeback.c	2011-11-17 20:12:22.000000000 +0800
+++ linux-next/mm/page-writeback.c	2011-11-17 20:12:38.000000000 +0800
@@ -1010,6 +1010,7 @@ static void balance_dirty_pages(struct a
 	unsigned long background_thresh;
 	unsigned long dirty_thresh;
 	unsigned long bdi_thresh;
+	long period;
 	long pause = 0;
 	long uninitialized_var(max_pause);
 	bool dirty_exceeded = false;
@@ -1020,6 +1021,8 @@ static void balance_dirty_pages(struct a
 	unsigned long start_time = jiffies;
 
 	for (;;) {
+		unsigned long now = jiffies;
+
 		/*
 		 * Unstable writes are a feature of certain networked
 		 * filesystems (i.e. NFS) in which data may have been
@@ -1039,8 +1042,11 @@ static void balance_dirty_pages(struct a
 		 */
 		freerun = dirty_freerun_ceiling(dirty_thresh,
 						background_thresh);
-		if (nr_dirty <= freerun)
+		if (nr_dirty <= freerun) {
+			current->dirty_paused_when = now;
+			current->nr_dirtied = 0;
 			break;
+		}
 
 		if (unlikely(!writeback_in_progress(bdi)))
 			bdi_start_background_writeback(bdi);
@@ -1098,10 +1104,21 @@ static void balance_dirty_pages(struct a
 		task_ratelimit = ((u64)dirty_ratelimit * pos_ratio) >>
 							RATELIMIT_CALC_SHIFT;
 		if (unlikely(task_ratelimit == 0)) {
+			period = max_pause;
 			pause = max_pause;
 			goto pause;
 		}
-		pause = HZ * pages_dirtied / task_ratelimit;
+		period = HZ * pages_dirtied / task_ratelimit;
+		pause = period;
+		if (current->dirty_paused_when)
+			pause -= now - current->dirty_paused_when;
+		/*
+		 * For less than 1s think time (ext3/4 may block the dirtier
+		 * for up to 800ms from time to time on 1-HDD; so does xfs,
+		 * however at much less frequency), try to compensate it in
+		 * future periods by updating the virtual time; otherwise just
+		 * do a reset, as it may be a light dirtier.
+		 */
 		if (unlikely(pause <= 0)) {
 			trace_balance_dirty_pages(bdi,
 						  dirty_thresh,
@@ -1112,8 +1129,16 @@ static void balance_dirty_pages(struct a
 						  dirty_ratelimit,
 						  task_ratelimit,
 						  pages_dirtied,
+						  period,
 						  pause,
 						  start_time);
+			if (pause < -HZ) {
+				current->dirty_paused_when = now;
+				current->nr_dirtied = 0;
+			} else if (period) {
+				current->dirty_paused_when += period;
+				current->nr_dirtied = 0;
+			}
 			pause = 1; /* avoid resetting nr_dirtied_pause below */
 			break;
 		}
@@ -1129,11 +1154,15 @@ pause:
 					  dirty_ratelimit,
 					  task_ratelimit,
 					  pages_dirtied,
+					  period,
 					  pause,
 					  start_time);
 		__set_current_state(TASK_KILLABLE);
 		io_schedule_timeout(pause);
 
+		current->dirty_paused_when = now + pause;
+		current->nr_dirtied = 0;
+
 		/*
 		 * This is typically equal to (nr_dirty < dirty_thresh) and can
 		 * also keep "1000+ dd on a slow USB stick" under control.
@@ -1148,11 +1177,10 @@ pause:
 	if (!dirty_exceeded && bdi->dirty_exceeded)
 		bdi->dirty_exceeded = 0;
 
-	current->nr_dirtied = 0;
 	if (pause == 0) { /* in freerun area */
 		current->nr_dirtied_pause =
 				dirty_poll_interval(nr_dirty, dirty_thresh);
-	} else if (pause <= max_pause / 4 &&
+	} else if (period <= max_pause / 4 &&
 		   pages_dirtied >= current->nr_dirtied_pause) {
 		current->nr_dirtied_pause = clamp_val(
 					dirty_ratelimit * (max_pause / 2) / HZ,
--- linux-next.orig/kernel/fork.c	2011-11-17 20:12:23.000000000 +0800
+++ linux-next/kernel/fork.c	2011-11-17 20:12:35.000000000 +0800
@@ -1296,6 +1296,7 @@ static struct task_struct *copy_process(
 
 	p->nr_dirtied = 0;
 	p->nr_dirtied_pause = 128 >> (PAGE_SHIFT - 10);
+	p->dirty_paused_when = 0;
 
 	/*
 	 * Ok, make it visible to the rest of the system.
--- linux-next.orig/include/trace/events/writeback.h	2011-11-17 19:13:41.000000000 +0800
+++ linux-next/include/trace/events/writeback.h	2011-11-17 20:12:35.000000000 +0800
@@ -289,12 +289,13 @@ TRACE_EVENT(balance_dirty_pages,
 		 unsigned long dirty_ratelimit,
 		 unsigned long task_ratelimit,
 		 unsigned long dirtied,
+		 unsigned long period,
 		 long pause,
 		 unsigned long start_time),
 
 	TP_ARGS(bdi, thresh, bg_thresh, dirty, bdi_thresh, bdi_dirty,
 		dirty_ratelimit, task_ratelimit,
-		dirtied, pause, start_time),
+		dirtied, period, pause, start_time),
 
 	TP_STRUCT__entry(
 		__array(	 char,	bdi, 32)
@@ -309,6 +310,8 @@ TRACE_EVENT(balance_dirty_pages,
 		__field(unsigned int,	dirtied_pause)
 		__field(unsigned long,	paused)
 		__field(	 long,	pause)
+		__field(unsigned long,	period)
+		__field(	 long,	think)
 	),
 
 	TP_fast_assign(
@@ -325,6 +328,9 @@ TRACE_EVENT(balance_dirty_pages,
 		__entry->task_ratelimit	= KBps(task_ratelimit);
 		__entry->dirtied	= dirtied;
 		__entry->dirtied_pause	= current->nr_dirtied_pause;
+		__entry->think		= current->dirty_paused_when == 0 ? 0 :
+			 (long)(jiffies - current->dirty_paused_when) * 1000/HZ;
+		__entry->period		= period * 1000 / HZ;
 		__entry->pause		= pause * 1000 / HZ;
 		__entry->paused		= (jiffies - start_time) * 1000 / HZ;
 	),
@@ -335,7 +341,7 @@ TRACE_EVENT(balance_dirty_pages,
 		  "bdi_setpoint=%lu bdi_dirty=%lu "
 		  "dirty_ratelimit=%lu task_ratelimit=%lu "
 		  "dirtied=%u dirtied_pause=%u "
-		  "paused=%lu pause=%ld",
+		  "paused=%lu pause=%ld period=%lu think=%ld",
 		  __entry->bdi,
 		  __entry->limit,
 		  __entry->setpoint,
@@ -347,7 +353,9 @@ TRACE_EVENT(balance_dirty_pages,
 		  __entry->dirtied,
 		  __entry->dirtied_pause,
 		  __entry->paused,	/* ms */
-		  __entry->pause	/* ms */
+		  __entry->pause,	/* ms */
+		  __entry->period,	/* ms */
+		  __entry->think	/* ms */
 	  )
 );
 


