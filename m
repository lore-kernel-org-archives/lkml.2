Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756807Ab0LMHAU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 02:00:20 -0500
Received: from mga02.intel.com ([134.134.136.20]:4695 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752268Ab0LMGtj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 01:49:39 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,335,1288594800"; 
   d="scan'208";a="583111634"
Message-Id: <20101213064837.404605715@intel.com>
User-Agent: quilt/0.48-1
Date: Mon, 13 Dec 2010 14:42:53 +0800
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
Subject: [PATCH 04/47] writeback: consolidate variable names in balance_dirty_pages()
References: <20101213064249.648862451@intel.com>
Content-Disposition: inline; filename=writeback-cleanup-name-merge.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lots of lengthy tests.. Let's compact the names

	nr_dirty = NR_FILE_DIRTY + NR_WRITEBACK + NR_UNSTABLE_NFS

balance_dirty_pages() only cares about the above dirty sum except
in one place -- on starting background writeback.

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 mm/page-writeback.c |   30 ++++++++++++++----------------
 1 file changed, 14 insertions(+), 16 deletions(-)

--- linux-next.orig/mm/page-writeback.c	2010-12-08 22:44:22.000000000 +0800
+++ linux-next/mm/page-writeback.c	2010-12-08 22:44:22.000000000 +0800
@@ -497,8 +497,9 @@ unsigned long bdi_dirty_limit(struct bac
 static void balance_dirty_pages(struct address_space *mapping,
 				unsigned long pages_dirtied)
 {
-	long nr_reclaimable, bdi_nr_reclaimable;
-	long nr_writeback, bdi_nr_writeback;
+	long nr_reclaimable;
+	long nr_dirty;
+	long bdi_dirty;  /* = file_dirty + writeback + unstable_nfs */
 	unsigned long background_thresh;
 	unsigned long dirty_thresh;
 	unsigned long bdi_thresh;
@@ -516,7 +517,7 @@ static void balance_dirty_pages(struct a
 		 */
 		nr_reclaimable = global_page_state(NR_FILE_DIRTY) +
 					global_page_state(NR_UNSTABLE_NFS);
-		nr_writeback = global_page_state(NR_WRITEBACK);
+		nr_dirty = nr_reclaimable + global_page_state(NR_WRITEBACK);
 
 		global_dirty_limits(&background_thresh, &dirty_thresh);
 
@@ -525,12 +526,10 @@ static void balance_dirty_pages(struct a
 		 * catch-up. This avoids (excessively) small writeouts
 		 * when the bdi limits are ramping up.
 		 */
-		if (nr_reclaimable + nr_writeback <=
-				(background_thresh + dirty_thresh) / 2)
+		if (nr_dirty <= (background_thresh + dirty_thresh) / 2)
 			break;
 
-		bdi_thresh = bdi_dirty_limit(bdi, dirty_thresh,
-					     nr_reclaimable + nr_writeback);
+		bdi_thresh = bdi_dirty_limit(bdi, dirty_thresh, nr_dirty);
 		bdi_thresh = task_dirty_limit(current, bdi_thresh);
 
 		/*
@@ -544,21 +543,21 @@ static void balance_dirty_pages(struct a
 		 * deltas.
 		 */
 		if (bdi_thresh < 2*bdi_stat_error(bdi)) {
-			bdi_nr_reclaimable = bdi_stat_sum(bdi, BDI_RECLAIMABLE);
-			bdi_nr_writeback = bdi_stat_sum(bdi, BDI_WRITEBACK);
+			bdi_dirty = bdi_stat_sum(bdi, BDI_RECLAIMABLE) +
+				    bdi_stat_sum(bdi, BDI_WRITEBACK);
 		} else {
-			bdi_nr_reclaimable = bdi_stat(bdi, BDI_RECLAIMABLE);
-			bdi_nr_writeback = bdi_stat(bdi, BDI_WRITEBACK);
+			bdi_dirty = bdi_stat(bdi, BDI_RECLAIMABLE) +
+				    bdi_stat(bdi, BDI_WRITEBACK);
 		}
 
-		if (bdi_nr_reclaimable + bdi_nr_writeback >= bdi_thresh) {
+		if (bdi_dirty >= bdi_thresh) {
 			pause = HZ/10;
 			goto pause;
 		}
 
 		bw = 100 << 20; /* use static 100MB/s for the moment */
 
-		bw = bw * (bdi_thresh - (bdi_nr_reclaimable + bdi_nr_writeback));
+		bw = bw * (bdi_thresh - bdi_dirty);
 		bw = bw / (bdi_thresh / TASK_SOFT_DIRTY_LIMIT + 1);
 
 		pause = HZ * (pages_dirtied << PAGE_CACHE_SHIFT) / (bw + 1);
@@ -574,9 +573,8 @@ pause:
 		 * bdi or process from holding back light ones; The latter is
 		 * the last resort safeguard.
 		 */
-		dirty_exceeded =
-			(bdi_nr_reclaimable + bdi_nr_writeback > bdi_thresh)
-			|| (nr_reclaimable + nr_writeback > dirty_thresh);
+		dirty_exceeded = (bdi_dirty > bdi_thresh) ||
+				  (nr_dirty > dirty_thresh);
 
 		if (!dirty_exceeded)
 			break;


