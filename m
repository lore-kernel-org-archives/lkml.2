Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754358Ab1LMC0i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 21:26:38 -0500
Received: from mga14.intel.com ([143.182.124.37]:11683 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753991Ab1LMC0h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 21:26:37 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="85015210"
Date: Tue, 13 Dec 2011 10:16:33 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Cc: Jan Kara <jack@suse.cz>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Li Shaohua <shaohua.li@intel.com>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/3] writeback: max, min and target dirty pause time
Message-ID: <20111213021633.GA14193@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Control the pause time and the call intervals to balance_dirty_pages()
with three parameters:

1) max_pause, limited by bdi_dirty and MAX_PAUSE

2) the target pause time, grows with the number of dd tasks
   and is normally limited by max_pause/2

3) the minimal pause, set to half the target pause
   and is used to skip short sleeps and accumulate them into bigger ones

The typical behaviors after patch:

- if ever task_ratelimit is far below dirty_ratelimit, the pause time
  will remain constant at max_pause and nr_dirtied_pause will be
  fluctuating with task_ratelimit

- in the normal cases, nr_dirtied_pause will remain stable (keep in the
  same pace with dirty_ratelimit) and the pause time will be fluctuating
  with task_ratelimit

In summary, someone has to fluctuate with task_ratelimit, because

	task_ratelimit = nr_dirtied_pause / pause

We normally prefer a stable nr_dirtied_pause, until reaching max_pause.

The notable behavior changes are:

- in stable workloads, there will no longer be sudden big trajectory
  switching of nr_dirtied_pause as concerned by Peter. It will be as
  smooth as dirty_ratelimit and changing proportionally with it (as
  always, assuming bdi bandwidth does not fluctuate across 2^N lines,
  otherwise nr_dirtied_pause will show up in 2+ parallel trajectories)

- in the rare cases when something keeps task_ratelimit far below
  dirty_ratelimit, the smoothness can no longer be retained and
  nr_dirtied_pause will be "dancing" with task_ratelimit. This fixes a
  (not that destructive but still not good) bug that
	  dirty_ratelimit gets brought down undesirably
	  <= balanced_dirty_ratelimit is under estimated
	  <= weakly executed task_ratelimit
	  <= pause goes too large and gets trimmed down to max_pause
	  <= nr_dirtied_pause (based on dirty_ratelimit) is set too large
	  <= dirty_ratelimit being much larger than task_ratelimit

- introduce min_pause to avoid small pause sleeps

- when pause is trimmed down to max_pause, try to compensate it at the
  next pause time

The "refactor" type of changes are:

The max_pause equation is slightly transformed to make it slightly more
efficient.

We now scale target_pause by (N * 10ms) on 2^N concurrent tasks, which
is effectively equal to the original scaling max_pause by (N * 20ms)
because the original code does implicit target_pause ~= max_pause / 2.
Based on the same implicit ratio, target_pause starts with 10ms on 1 dd.

CC: Jan Kara <jack@suse.cz>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 mm/page-writeback.c |  125 +++++++++++++++++++++++++++---------------
 1 file changed, 81 insertions(+), 44 deletions(-)

--- linux-next.orig/mm/page-writeback.c	2011-12-11 21:49:27.000000000 +0800
+++ linux-next/mm/page-writeback.c	2011-12-12 19:22:49.000000000 +0800
@@ -955,40 +955,81 @@ static unsigned long dirty_poll_interval
 	return 1;
 }
 
-static unsigned long bdi_max_pause(struct backing_dev_info *bdi,
-				   unsigned long bdi_dirty)
+static long bdi_max_pause(struct backing_dev_info *bdi,
+			  unsigned long bdi_dirty)
 {
-	unsigned long bw = bdi->avg_write_bandwidth;
-	unsigned long hi = ilog2(bw);
-	unsigned long lo = ilog2(bdi->dirty_ratelimit);
-	unsigned long t;
+	long bw = bdi->avg_write_bandwidth;
+	long t;
 
-	/* target for 20ms max pause on 1-dd case */
-	t = HZ / 50;
+	/*
+	 * Limit pause time for small memory systems. If sleeping for too long
+	 * time, a small pool of dirty/writeback pages may go empty and disk go
+	 * idle.
+	 *
+	 * 8 serves as the safety ratio.
+	 */
+	t = bdi_dirty / (1 + bw / roundup_pow_of_two(1 + HZ / 8));
+	t++;
+
+	return min_t(long, t, MAX_PAUSE);
+}
+
+static long bdi_min_pause(struct backing_dev_info *bdi,
+			  long max_pause,
+			  unsigned long task_ratelimit,
+			  unsigned long dirty_ratelimit,
+			  int *nr_dirtied_pause)
+{
+	long hi = ilog2(bdi->avg_write_bandwidth);
+	long lo = ilog2(bdi->dirty_ratelimit);
+	long t;		/* target pause */
+	long pause;	/* estimated next pause */
+	int pages;	/* target nr_dirtied_pause */
+
+	/* target for 10ms pause on 1-dd case */
+	t = max(1, HZ / 100);
 
 	/*
 	 * Scale up pause time for concurrent dirtiers in order to reduce CPU
 	 * overheads.
 	 *
-	 * (N * 20ms) on 2^N concurrent tasks.
+	 * (N * 10ms) on 2^N concurrent tasks.
 	 */
 	if (hi > lo)
-		t += (hi - lo) * (20 * HZ) / 1024;
+		t += (hi - lo) * (10 * HZ) / 1024;
 
 	/*
-	 * Limit pause time for small memory systems. If sleeping for too long
-	 * time, a small pool of dirty/writeback pages may go empty and disk go
-	 * idle.
+	 * This is a bit convoluted. We try to base the next nr_dirtied_pause
+	 * on the much more stable dirty_ratelimit. However the next pause time
+	 * will be computed based on task_ratelimit and the two rate limits may
+	 * depart considerably at some time. Especially if task_ratelimit goes
+	 * below dirty_ratelimit/2 and the target pause is max_pause, the next
+	 * pause time will be max_pause*2 _trimmed down_ to max_pause.  As a
+	 * result task_ratelimit won't be executed faithfully, which could
+	 * eventually bring down dirty_ratelimit.
 	 *
-	 * 8 serves as the safety ratio.
+	 * We apply two rules to fix it up:
+	 * 1) try to estimate the next pause time and if necessary, use a lower
+	 *    nr_dirtied_pause so as not to exceed max_pause. When this happens,
+	 *    nr_dirtied_pause will be "dancing" with task_ratelimit.
+	 * 2) limit the target pause time to max_pause/2, so that the normal
+	 *    small fluctuations of task_ratelimit won't trigger rule (1) and
+	 *    nr_dirtied_pause will remain as stable as dirty_ratelimit.
 	 */
-	t = min(t, bdi_dirty * HZ / (8 * bw + 1));
+	t = min(t, 1 + max_pause / 2);
+	pages = dirty_ratelimit * t / roundup_pow_of_two(HZ);
+
+	pause = HZ * pages / (task_ratelimit + 1);
+	if (pause > max_pause) {
+		t = max_pause;
+		pages = task_ratelimit * t / roundup_pow_of_two(HZ);
+	}
 
+	*nr_dirtied_pause = pages;
 	/*
-	 * The pause time will be settled within range (max_pause/4, max_pause).
-	 * Apply a minimal value of 4 to get a non-zero max_pause/4.
+	 * The minimal pause time will normally be half the target pause time.
 	 */
-	return clamp_val(t, 4, MAX_PAUSE);
+	return 1 + t / 2;
 }
 
 /*
@@ -1010,11 +1051,13 @@ static void balance_dirty_pages(struct a
 	unsigned long dirty_thresh;
 	unsigned long bdi_thresh;
 	long period;
-	long pause = 0;
-	long uninitialized_var(max_pause);
+	long pause;
+	long max_pause;
+	long min_pause;
+	int nr_dirtied_pause;
 	bool dirty_exceeded = false;
 	unsigned long task_ratelimit;
-	unsigned long uninitialized_var(dirty_ratelimit);
+	unsigned long dirty_ratelimit;
 	unsigned long pos_ratio;
 	struct backing_dev_info *bdi = mapping->backing_dev_info;
 	unsigned long start_time = jiffies;
@@ -1044,6 +1087,8 @@ static void balance_dirty_pages(struct a
 		if (nr_dirty <= freerun) {
 			current->dirty_paused_when = now;
 			current->nr_dirtied = 0;
+			current->nr_dirtied_pause =
+				dirty_poll_interval(nr_dirty, dirty_thresh);
 			break;
 		}
 
@@ -1094,14 +1139,17 @@ static void balance_dirty_pages(struct a
 				     nr_dirty, bdi_thresh, bdi_dirty,
 				     start_time);
 
-		max_pause = bdi_max_pause(bdi, bdi_dirty);
-
 		dirty_ratelimit = bdi->dirty_ratelimit;
 		pos_ratio = bdi_position_ratio(bdi, dirty_thresh,
 					       background_thresh, nr_dirty,
 					       bdi_thresh, bdi_dirty);
 		task_ratelimit = ((u64)dirty_ratelimit * pos_ratio) >>
 							RATELIMIT_CALC_SHIFT;
+		max_pause = bdi_max_pause(bdi, bdi_dirty);
+		min_pause = bdi_min_pause(bdi, max_pause,
+					  task_ratelimit, dirty_ratelimit,
+					  &nr_dirtied_pause);
+
 		if (unlikely(task_ratelimit == 0)) {
 			period = max_pause;
 			pause = max_pause;
@@ -1118,7 +1166,7 @@ static void balance_dirty_pages(struct a
 		 * future periods by updating the virtual time; otherwise just
 		 * do a reset, as it may be a light dirtier.
 		 */
-		if (unlikely(pause <= 0)) {
+		if (pause < min_pause) {
 			trace_balance_dirty_pages(bdi,
 						  dirty_thresh,
 						  background_thresh,
@@ -1129,7 +1177,7 @@ static void balance_dirty_pages(struct a
 						  task_ratelimit,
 						  pages_dirtied,
 						  period,
-						  pause,
+						  min(pause, 0L),
 						  start_time);
 			if (pause < -HZ) {
 				current->dirty_paused_when = now;
@@ -1137,11 +1185,15 @@ static void balance_dirty_pages(struct a
 			} else if (period) {
 				current->dirty_paused_when += period;
 				current->nr_dirtied = 0;
-			}
-			pause = 1; /* avoid resetting nr_dirtied_pause below */
+			} else if (current->nr_dirtied_pause <= pages_dirtied)
+				current->nr_dirtied_pause += pages_dirtied;
 			break;
 		}
-		pause = min(pause, max_pause);
+		if (unlikely(pause > max_pause)) {
+			/* for occasional dropped task_ratelimit */
+			now += min(pause - max_pause, max_pause);
+			pause = max_pause;
+		}
 
 pause:
 		trace_balance_dirty_pages(bdi,
@@ -1161,6 +1213,7 @@ pause:
 
 		current->dirty_paused_when = now + pause;
 		current->nr_dirtied = 0;
+		current->nr_dirtied_pause = nr_dirtied_pause;
 
 		/*
 		 * This is typically equal to (nr_dirty < dirty_thresh) and can
@@ -1189,22 +1242,6 @@ pause:
 	if (!dirty_exceeded && bdi->dirty_exceeded)
 		bdi->dirty_exceeded = 0;
 
-	if (pause == 0) { /* in freerun area */
-		current->nr_dirtied_pause =
-				dirty_poll_interval(nr_dirty, dirty_thresh);
-	} else if (period <= max_pause / 4 &&
-		   pages_dirtied >= current->nr_dirtied_pause) {
-		current->nr_dirtied_pause = clamp_val(
-					dirty_ratelimit * (max_pause / 2) / HZ,
-					pages_dirtied + pages_dirtied / 8,
-					pages_dirtied * 4);
-	} else if (pause >= max_pause) {
-		current->nr_dirtied_pause = 1 | clamp_val(
-					dirty_ratelimit * (max_pause / 2) / HZ,
-					pages_dirtied / 4,
-					pages_dirtied - pages_dirtied / 8);
-	}
-
 	if (writeback_in_progress(bdi))
 		return;
 
