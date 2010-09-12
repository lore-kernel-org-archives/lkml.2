Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753733Ab0ILPzl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Sep 2010 11:55:41 -0400
Received: from mga11.intel.com ([192.55.52.93]:33603 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753419Ab0ILPzD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Sep 2010 11:55:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,355,1280732400"; 
   d="scan'208";a="606204421"
Message-Id: <20100912155204.602761236@intel.com>
User-Agent: quilt/0.48-1
Date: Sun, 12 Sep 2010 23:49:58 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: linux-mm <linux-mm@kvack.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Richard Kennedy <richard@rsk.demon.co.uk>,
        "Martin J. Bligh" <mbligh@google.com>,
        Wu Fengguang <fengguang.wu@intel.com>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: "Theodore Ts'o" <tytso@mit.edu>
CC: Dave Chinner <david@fromorbit.com>
CC: Jan Kara <jack@suse.cz>
CC: Mel Gorman <mel@csn.ul.ie>
CC: Rik van Riel <riel@redhat.com>
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Chris Mason <chris.mason@oracle.com>
CC: Christoph Hellwig <hch@lst.de>
CC: Li Shaohua <shaohua.li@intel.com>
Subject: [PATCH 13/17] writeback: reduce per-bdi dirty threshold ramp up time
References: <20100912154945.758129106@intel.com>
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
16GB mem, which looks good.

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
CC: Martin J. Bligh <mbligh@google.com>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 mm/page-writeback.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next.orig/mm/page-writeback.c	2010-08-30 10:24:00.000000000 +0800
+++ linux-next/mm/page-writeback.c	2010-08-30 10:27:10.000000000 +0800
@@ -131,7 +131,7 @@ static int calc_period_shift(void)
 	else
 		dirty_total = (vm_dirty_ratio * determine_dirtyable_memory()) /
 				100;
-	return 2 + ilog2(dirty_total - 1);
+	return ilog2(dirty_total - 1) - 1;
 }
 
 /*


