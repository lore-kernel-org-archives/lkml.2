Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757290Ab1KQL7X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 06:59:23 -0500
Received: from mga14.intel.com ([143.182.124.37]:36630 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756972Ab1KQL7T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 06:59:19 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,526,1315206000"; 
   d="scan'208";a="76151200"
Date: Thu, 17 Nov 2011 19:59:14 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: linux-fsdevel@vger.kernel.org
Cc: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] writeback: hard throttle 1000+ dd on a slow USB stick
Message-ID: <20111117115914.GA24502@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The sleep based balance_dirty_pages() can pause at most MAX_PAUSE=200ms
on every 1 4KB-page, which means it cannot throttle a task under
4KB/200ms=20KB/s. So when there are more than 512 dd writing to a
10MB/s USB stick, its bdi dirty pages could grow out of control.

Even if we can increase MAX_PAUSE, the minimal (task_ratelimit = 1)
means a limit of 4KB/s.

They can eventually be safeguarded by the global limit check
(nr_dirty < dirty_thresh). However if someone is also writing to an
HDD at the same time, it'll get poor HDD write performance.

We at least want to maintain good write performance for other devices
when one device is attacked by some "massive parallel" workload, or
suffers from slow write bandwidth, or somehow get stalled due to some
error condition (eg. NFS server not responding).

For a stalled device, we need to completely block its dirtiers, too,
before its bdi dirty pages grow all the way up to the global limit and
leave no space for the other functional devices.

So change the loop exit condition to

	/*
	 * Always enforce global dirty limit; also enforce bdi dirty limit
	 * if the normal max_pause sleeps cannot keep things under control.
	 */
	if (nr_dirty < dirty_thresh &&
	    (bdi_dirty < bdi_thresh || bdi->dirty_ratelimit > 1))
		break;

which can be further simplified to

	if (task_ratelimit)
		break;

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 mm/page-writeback.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

--- linux-next.orig/mm/page-writeback.c	2011-11-17 19:23:57.000000000 +0800
+++ linux-next/mm/page-writeback.c	2011-11-17 19:23:59.000000000 +0800
@@ -1136,14 +1136,11 @@ pause:
 		__set_current_state(TASK_KILLABLE);
 		io_schedule_timeout(pause);
 
-		dirty_thresh = hard_dirty_limit(dirty_thresh);
 		/*
-		 * max-pause area. If dirty exceeded but still within this
-		 * area, no need to sleep for more than 200ms: (a) 8 pages per
-		 * 200ms is typically more than enough to curb heavy dirtiers;
-		 * (b) the pause time limit makes the dirtiers more responsive.
+		 * This is typically equal to (nr_dirty < dirty_thresh) and can
+		 * also keep "1000+ dd on a slow USB stick" under control.
 		 */
-		if (nr_dirty < dirty_thresh)
+		if (task_ratelimit)
 			break;
 
 		if (fatal_signal_pending(current))
