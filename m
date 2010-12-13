Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932376Ab0LMG7h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 01:59:37 -0500
Received: from mga09.intel.com ([134.134.136.24]:15822 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752728Ab0LMGtj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 01:49:39 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,335,1288594800"; 
   d="scan'208";a="686523116"
Message-Id: <20101213064838.285412238@intel.com>
User-Agent: quilt/0.48-1
Date: Mon, 13 Dec 2010 14:43:00 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: Jan Kara <jack@suse.cz>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Richard Kennedy <richard@rsk.demon.co.uk>,
        Wu Fengguang <fengguang.wu@intel.com>
CC: Christoph Hellwig <hch@lst.de>
CC: Trond Myklebust <Trond.Myklebust@netapp.com>
CC: Dave Chinner <david@fromorbit.com>
CC: "Theodore Ts'o" <tytso@mit.edu>
CC: Chris Mason <chris.mason@oracle.com>
CC: Mel Gorman <mel@csn.ul.ie>
CC: Rik van Riel <riel@redhat.com>
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Greg Thelen <gthelen@google.com>
CC: Minchan Kim <minchan.kim@gmail.com>
Cc: linux-mm <linux-mm@kvack.org>
Cc: <linux-fsdevel@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 11/47] writeback: reduce per-bdi dirty threshold ramp up time
References: <20101213064249.648862451@intel.com>
Content-Disposition: inline; filename=writeback-speedup-per-bdi-threshold-ramp-up.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reduce the dampening for the control system, yielding faster
convergence.

Currently it converges at a snail's pace for slow devices (in order of
minutes).  For really fast storage, the convergence speed should be fine.

It makes sense to make it reasonably fast for typical desktops.

After patch, it converges in ~10 seconds for 60MB/s writes and 4GB mem.
So expect ~1s for a fast 600MB/s storage under 4GB mem, or ~4s under
16GB mem, which seems reasonable.

$ while true; do grep BdiDirtyThresh /debug/bdi/8:0/stats; sleep 1; done
BdiDirtyThresh:            0 kB
BdiDirtyThresh:       118748 kB
BdiDirtyThresh:       214280 kB
BdiDirtyThresh:       303868 kB
BdiDirtyThresh:       376528 kB
BdiDirtyThresh:       411180 kB
BdiDirtyThresh:       448636 kB
BdiDirtyThresh:       472260 kB
BdiDirtyThresh:       490924 kB
BdiDirtyThresh:       499596 kB
BdiDirtyThresh:       507068 kB
...
DirtyThresh:          530392 kB

CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Richard Kennedy <richard@rsk.demon.co.uk>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 mm/page-writeback.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next.orig/mm/page-writeback.c	2010-12-08 22:44:25.000000000 +0800
+++ linux-next/mm/page-writeback.c	2010-12-08 22:44:25.000000000 +0800
@@ -125,7 +125,7 @@ static int calc_period_shift(void)
 	else
 		dirty_total = (vm_dirty_ratio * determine_dirtyable_memory()) /
 				100;
-	return 2 + ilog2(dirty_total - 1);
+	return ilog2(dirty_total - 1) - 1;
 }
 
 /*


