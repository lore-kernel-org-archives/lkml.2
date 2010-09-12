Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753705Ab0ILPzj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Sep 2010 11:55:39 -0400
Received: from mga11.intel.com ([192.55.52.93]:58857 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753420Ab0ILPzD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Sep 2010 11:55:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,355,1280732400"; 
   d="scan'208";a="606204423"
Message-Id: <20100912155205.275730419@intel.com>
User-Agent: quilt/0.48-1
Date: Sun, 12 Sep 2010 23:50:02 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: linux-mm <linux-mm@kvack.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Wu Fengguang <fengguang.wu@intel.com>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: "Theodore Ts'o" <tytso@mit.edu>
CC: Dave Chinner <david@fromorbit.com>
CC: Jan Kara <jack@suse.cz>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Mel Gorman <mel@csn.ul.ie>
CC: Rik van Riel <riel@redhat.com>
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Chris Mason <chris.mason@oracle.com>
CC: Christoph Hellwig <hch@lst.de>
CC: Li Shaohua <shaohua.li@intel.com>
Subject: [PATCH 17/17] writeback: consolidate balance_dirty_pages() variable names
References: <20100912154945.758129106@intel.com>
Content-Disposition: inline; filename=writeback-cleanup-name-merge.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lots of lenthy tests.. Let's compact the names

	*_dirty3 = dirty + writeback + unstable

balance_dirty_pages() only cares about the above dirty sum except
in one place -- on starting background writeback.

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 mm/page-writeback.c |   34 ++++++++++++++++------------------
 1 file changed, 16 insertions(+), 18 deletions(-)

--- linux-next.orig/mm/page-writeback.c	2010-09-12 13:30:38.000000000 +0800
+++ linux-next/mm/page-writeback.c	2010-09-12 13:34:04.000000000 +0800
@@ -493,8 +493,8 @@ start_over:
 static void balance_dirty_pages(struct address_space *mapping,
 				unsigned long pages_dirtied)
 {
-	long nr_reclaimable, bdi_nr_reclaimable;
-	long nr_writeback, bdi_nr_writeback;
+	long nr_reclaimable;
+	long nr_dirty3, bdi_dirty3;
 	long bdi_prev_dirty3 = 0;
 	unsigned long background_thresh;
 	unsigned long dirty_thresh;
@@ -518,7 +518,7 @@ static void balance_dirty_pages(struct a
 		 */
 		nr_reclaimable = global_page_state(NR_FILE_DIRTY) +
 					global_page_state(NR_UNSTABLE_NFS);
-		nr_writeback = global_page_state(NR_WRITEBACK);
+		nr_dirty3 = nr_reclaimable + global_page_state(NR_WRITEBACK);
 
 		global_dirty_limits(&background_thresh, &dirty_thresh);
 
@@ -529,7 +529,7 @@ static void balance_dirty_pages(struct a
 		 */
 		thresh = (background_thresh + dirty_thresh) / 2;
 		thresh = thresh * vm_dirty_pressure / VM_DIRTY_PRESSURE;
-		if (nr_reclaimable + nr_writeback <= thresh)
+		if (nr_dirty3 <= thresh)
 			break;
 
 		task_dirties_fraction(current, &numerator, &denominator);
@@ -548,11 +548,11 @@ static void balance_dirty_pages(struct a
 		 * deltas.
 		 */
 		if (bdi_thresh < 2*bdi_stat_error(bdi)) {
-			bdi_nr_reclaimable = bdi_stat_sum(bdi, BDI_RECLAIMABLE);
-			bdi_nr_writeback = bdi_stat_sum(bdi, BDI_WRITEBACK);
+			bdi_dirty3 = bdi_stat_sum(bdi, BDI_RECLAIMABLE) +
+				     bdi_stat_sum(bdi, BDI_WRITEBACK);
 		} else {
-			bdi_nr_reclaimable = bdi_stat(bdi, BDI_RECLAIMABLE);
-			bdi_nr_writeback = bdi_stat(bdi, BDI_WRITEBACK);
+			bdi_dirty3 = bdi_stat(bdi, BDI_RECLAIMABLE) +
+				     bdi_stat(bdi, BDI_WRITEBACK);
 		}
 
 		/*
@@ -563,11 +563,10 @@ static void balance_dirty_pages(struct a
 		 * So offer a complementary way to break out of the loop when
 		 * enough bdi pages have been cleaned during our pause time.
 		 */
-		if (nr_reclaimable + nr_writeback <= dirty_thresh &&
-		    bdi_prev_dirty3 - (bdi_nr_reclaimable + bdi_nr_writeback) >
-							(long)pages_dirtied * 8)
+		if (nr_dirty3 <= dirty_thresh &&
+		    bdi_prev_dirty3 - bdi_dirty3 > (long)pages_dirtied * 8)
 			break;
-		bdi_prev_dirty3 = bdi_nr_reclaimable + bdi_nr_writeback;
+		bdi_prev_dirty3 = bdi_dirty3;
 
 
 		thresh = bdi_thresh - bdi_thresh / DIRTY_SOFT_THROTTLE_RATIO;
@@ -584,13 +583,13 @@ static void balance_dirty_pages(struct a
 			else if (thresh > bw)
 				thresh = bw;
 		}
-		if (bdi_nr_reclaimable + bdi_nr_writeback <= thresh)
+		if (bdi_dirty3 <= thresh)
 			goto check_exceeded;
 
 		bdi_update_write_bandwidth(bdi, &bw_time, &bw_written);
 
-		gap = bdi_thresh > (bdi_nr_reclaimable + bdi_nr_writeback) ?
-		      bdi_thresh - (bdi_nr_reclaimable + bdi_nr_writeback) : 0;
+		gap = bdi_thresh > bdi_dirty3 ?
+		      bdi_thresh - bdi_dirty3 : 0;
 
 		bw = bdi->write_bandwidth * gap / (bdi_thresh - thresh + 1);
 
@@ -622,9 +621,8 @@ check_exceeded:
 		 * bdi or process from holding back light ones; The latter is
 		 * the last resort safeguard.
 		 */
-		dirty_exceeded =
-			(bdi_nr_reclaimable + bdi_nr_writeback > bdi_thresh)
-			|| (nr_reclaimable + nr_writeback > dirty_thresh);
+		dirty_exceeded = (bdi_dirty3 > bdi_thresh) ||
+				  (nr_dirty3 > dirty_thresh);
 
 		if (!dirty_exceeded)
 			break;


