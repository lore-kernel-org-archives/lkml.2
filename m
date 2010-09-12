Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753916Ab0ILPzt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Sep 2010 11:55:49 -0400
Received: from mga03.intel.com ([143.182.124.21]:18093 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753376Ab0ILPzC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Sep 2010 11:55:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,355,1280732400"; 
   d="scan'208";a="323693160"
Message-Id: <20100912155202.733389420@intel.com>
User-Agent: quilt/0.48-1
Date: Sun, 12 Sep 2010 23:49:46 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: linux-mm <linux-mm@kvack.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Jan Kara <jack@suse.cz>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Wu Fengguang <fengguang.wu@intel.com>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: "Theodore Ts'o" <tytso@mit.edu>
CC: Dave Chinner <david@fromorbit.com>
CC: Mel Gorman <mel@csn.ul.ie>
CC: Rik van Riel <riel@redhat.com>
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Chris Mason <chris.mason@oracle.com>
CC: Christoph Hellwig <hch@lst.de>
CC: Li Shaohua <shaohua.li@intel.com>
Subject: [PATCH 01/17] writeback: remove the internal 5% low bound on dirty_ratio
References: <20100912154945.758129106@intel.com>
Content-Disposition: inline; filename=writeback-remove-dirty_ratio-low-bound.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The dirty_ratio was siliently limited in global_dirty_limits() to >= 5%.
This is not a user expected behavior. And it's inconsistent with
calc_period_shift(), which uses the plain vm_dirty_ratio value.

Let's rip the arbitrary internal bound. It may impact some very weird
user space applications. However we are going to dynamicly sizing the
dirty limits anyway, which may well break such applications, too.

At the same time, fix balance_dirty_pages() to work with the
dirty_thresh=0 case. This allows applications to proceed when
dirty+writeback pages are all cleaned.

And ">" fits with the name "exceeded" better than ">=" does. Neil
think it is an aesthetic improvement as well as a functional one :)

CC: Jan Kara <jack@suse.cz>
Proposed-by: Con Kolivas <kernel@kolivas.org>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Reviewed-by: Rik van Riel <riel@redhat.com>
Reviewed-by: Neil Brown <neilb@suse.de>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 fs/fs-writeback.c   |    2 +-
 mm/page-writeback.c |   16 +++++-----------
 2 files changed, 6 insertions(+), 12 deletions(-)

--- linux-next.orig/mm/page-writeback.c	2010-08-29 08:10:30.000000000 +0800
+++ linux-next/mm/page-writeback.c	2010-08-29 08:12:08.000000000 +0800
@@ -415,14 +415,8 @@ void global_dirty_limits(unsigned long *
 
 	if (vm_dirty_bytes)
 		dirty = DIV_ROUND_UP(vm_dirty_bytes, PAGE_SIZE);
-	else {
-		int dirty_ratio;
-
-		dirty_ratio = vm_dirty_ratio;
-		if (dirty_ratio < 5)
-			dirty_ratio = 5;
-		dirty = (dirty_ratio * available_memory) / 100;
-	}
+	else
+		dirty = (vm_dirty_ratio * available_memory) / 100;
 
 	if (dirty_background_bytes)
 		background = DIV_ROUND_UP(dirty_background_bytes, PAGE_SIZE);
@@ -510,7 +504,7 @@ static void balance_dirty_pages(struct a
 		 * catch-up. This avoids (excessively) small writeouts
 		 * when the bdi limits are ramping up.
 		 */
-		if (nr_reclaimable + nr_writeback <
+		if (nr_reclaimable + nr_writeback <=
 				(background_thresh + dirty_thresh) / 2)
 			break;
 
@@ -542,8 +536,8 @@ static void balance_dirty_pages(struct a
 		 * the last resort safeguard.
 		 */
 		dirty_exceeded =
-			(bdi_nr_reclaimable + bdi_nr_writeback >= bdi_thresh)
-			|| (nr_reclaimable + nr_writeback >= dirty_thresh);
+			(bdi_nr_reclaimable + bdi_nr_writeback > bdi_thresh)
+			|| (nr_reclaimable + nr_writeback > dirty_thresh);
 
 		if (!dirty_exceeded)
 			break;
--- linux-next.orig/fs/fs-writeback.c	2010-08-29 08:12:51.000000000 +0800
+++ linux-next/fs/fs-writeback.c	2010-08-29 08:12:53.000000000 +0800
@@ -574,7 +574,7 @@ static inline bool over_bground_thresh(v
 	global_dirty_limits(&background_thresh, &dirty_thresh);
 
 	return (global_page_state(NR_FILE_DIRTY) +
-		global_page_state(NR_UNSTABLE_NFS) >= background_thresh);
+		global_page_state(NR_UNSTABLE_NFS) > background_thresh);
 }
 
 /*


