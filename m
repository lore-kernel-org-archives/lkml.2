Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755444Ab0LMGyn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 01:54:43 -0500
Received: from mga09.intel.com ([134.134.136.24]:15822 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755359Ab0LMGto (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 01:49:44 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,335,1288594800"; 
   d="scan'208";a="686523135"
Message-Id: <20101213064840.666913748@intel.com>
User-Agent: quilt/0.48-1
Date: Mon, 13 Dec 2010 14:43:19 +0800
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
Subject: [PATCH 30/47] writeback: adapt max balance pause time to memory size
References: <20101213064249.648862451@intel.com>
Content-Disposition: inline; filename=writeback-max-pause-time-for-small-memory-system.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For small memory systems, sleeping for 200ms at a time is an overkill.
Given 4MB dirty limit, all the dirty/writeback pages will be written to
a 80MB/s disk within 50ms. If the task goes sleep for 200ms after it
dirtied 4MB, the disk will go idle for 150ms without any new data feed.

So allow up to N milliseconds pause time for (4*N) MB bdi dirty limit.
On a typical 4GB desktop, the max pause time will be ~150ms.

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 mm/page-writeback.c |   25 ++++++++++++++++++++++---
 1 file changed, 22 insertions(+), 3 deletions(-)

--- linux-next.orig/mm/page-writeback.c	2010-12-09 12:19:22.000000000 +0800
+++ linux-next/mm/page-writeback.c	2010-12-09 12:23:26.000000000 +0800
@@ -650,6 +650,22 @@ unlock:
 }
 
 /*
+ * Limit pause time for small memory systems. If sleeping for too long time,
+ * the small pool of dirty/writeback pages may go empty and disk go idle.
+ */
+static unsigned long max_pause(unsigned long bdi_thresh)
+{
+	unsigned long t;
+
+	/* 1ms for every 4MB */
+	t = bdi_thresh >> (32 - PAGE_CACHE_SHIFT -
+			   ilog2(roundup_pow_of_two(HZ)));
+	t += 2;
+
+	return min_t(unsigned long, t, MAX_PAUSE);
+}
+
+/*
  * balance_dirty_pages() must be called by processes which are generating dirty
  * data.  It looks at the number of dirty pages in the machine and will force
  * the caller to perform writeback if the system is over `vm_dirty_ratio'.
@@ -671,6 +687,7 @@ static void balance_dirty_pages(struct a
 	unsigned long long bw;
 	unsigned long period;
 	unsigned long pause = 0;
+	unsigned long pause_max;
 	bool dirty_exceeded = false;
 	struct backing_dev_info *bdi = mapping->backing_dev_info;
 	unsigned long start_time = jiffies;
@@ -744,8 +761,10 @@ static void balance_dirty_pages(struct a
 		if (avg_dirty < bdi_dirty || avg_dirty > task_thresh)
 			avg_dirty = bdi_dirty;
 
+		pause_max = max_pause(bdi_thresh);
+
 		if (avg_dirty >= task_thresh || nr_dirty > dirty_thresh) {
-			pause = MAX_PAUSE;
+			pause = pause_max;
 			goto pause;
 		}
 
@@ -779,7 +798,7 @@ static void balance_dirty_pages(struct a
 			pause = 1;
 			break;
 		}
-		pause = clamp_val(pause, 1, MAX_PAUSE);
+		pause = clamp_val(pause, 1, pause_max);
 
 pause:
 		trace_balance_dirty_pages(bdi,
@@ -816,7 +835,7 @@ pause:
 		current->nr_dirtied_pause = ratelimit_pages(bdi);
 	else if (pause == 1)
 		current->nr_dirtied_pause += current->nr_dirtied_pause / 32 + 1;
-	else if (pause >= MAX_PAUSE)
+	else if (pause >= pause_max)
 		/*
 		 * when repeated, writing 1 page per 100ms on slow devices,
 		 * i-(i+2)/4 will be able to reach 1 but never reduce to 0.


