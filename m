Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756680Ab0LMG5f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 01:57:35 -0500
Received: from mga02.intel.com ([134.134.136.20]:53133 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753731Ab0LMGtm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 01:49:42 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,335,1288594800"; 
   d="scan'208";a="583111647"
Message-Id: <20101213064839.907210153@intel.com>
User-Agent: quilt/0.48-1
Date: Mon, 13 Dec 2010 14:43:13 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: Jan Kara <jack@suse.cz>, Dave Chinner <david@fromorbit.com>,
        Wu Fengguang <fengguang.wu@intel.com>
CC: Christoph Hellwig <hch@lst.de>
CC: Trond Myklebust <Trond.Myklebust@netapp.com>
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
Subject: [PATCH 24/47] writeback: increase pause time on concurrent dirtiers
References: <20101213064249.648862451@intel.com>
Content-Disposition: inline; filename=writeback-200ms-pause-time.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Increase max pause time to 200ms, and make it work for (HZ < 5).

The larger 200ms will help reduce overheads in server workloads with
lots of concurrent dirtier tasks.

CC: Dave Chinner <david@fromorbit.com>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 mm/page-writeback.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- linux-next.orig/mm/page-writeback.c	2010-12-09 11:52:05.000000000 +0800
+++ linux-next/mm/page-writeback.c	2010-12-09 11:54:05.000000000 +0800
@@ -36,6 +36,11 @@
 #include <linux/pagevec.h>
 #include <trace/events/writeback.h>
 
+/*
+ * Don't sleep more than 200ms at a time in balance_dirty_pages().
+ */
+#define MAX_PAUSE	max(HZ/5, 1)
+
 /* The following parameters are exported via /proc/sys/vm */
 
 /*
@@ -660,7 +665,7 @@ static void balance_dirty_pages(struct a
 		bdi_update_bandwidth(bdi, start_time, bdi_dirty, bdi_thresh);
 
 		if (bdi_dirty >= task_thresh) {
-			pause = HZ/10;
+			pause = MAX_PAUSE;
 			goto pause;
 		}
 
@@ -679,7 +684,7 @@ static void balance_dirty_pages(struct a
 		do_div(bw, bdi_thresh / TASK_SOFT_DIRTY_LIMIT + 1);
 
 		pause = HZ * pages_dirtied / ((unsigned long)bw + 1);
-		pause = clamp_val(pause, 1, HZ/10);
+		pause = clamp_val(pause, 1, MAX_PAUSE);
 
 pause:
 		trace_balance_dirty_pages(bdi,
@@ -714,7 +719,7 @@ pause:
 		current->nr_dirtied_pause = ratelimit_pages(bdi);
 	else if (pause == 1)
 		current->nr_dirtied_pause += current->nr_dirtied_pause / 32 + 1;
-	else if (pause >= HZ/10)
+	else if (pause >= MAX_PAUSE)
 		/*
 		 * when repeated, writing 1 page per 100ms on slow devices,
 		 * i-(i+2)/4 will be able to reach 1 but never reduce to 0.


