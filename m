Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754347Ab1FSP1x (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jun 2011 11:27:53 -0400
Received: from mga11.intel.com ([192.55.52.93]:3908 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754168Ab1FSP1v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jun 2011 11:27:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,389,1304319600"; 
   d="scan'208";a="18058365"
Message-Id: <20110619150510.011659314@intel.com>
User-Agent: quilt/0.48-1
Date: Sun, 19 Jun 2011 23:01:09 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
CC: Jan Kara <jack@suse.cz>, Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Wu Fengguang <fengguang.wu@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/7] writeback: consolidate variable names in balance_dirty_pages()
References: <20110619150108.691351746@intel.com>
Content-Disposition: inline; filename=writeback-cleanup-name-merge.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce

	nr_dirty = NR_FILE_DIRTY + NR_WRITEBACK + NR_UNSTABLE_NFS

in order to simplify many tests in the following patches.

balance_dirty_pages() will eventually care only about the dirty sums
besides nr_writeback.

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 mm/page-writeback.c |   21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

--- linux-next.orig/mm/page-writeback.c	2011-06-13 17:27:10.000000000 +0800
+++ linux-next/mm/page-writeback.c	2011-06-13 17:27:30.000000000 +0800
@@ -560,8 +560,9 @@ static void bdi_update_bandwidth(struct 
 static void balance_dirty_pages(struct address_space *mapping,
 				unsigned long write_chunk)
 {
-	long nr_reclaimable, bdi_nr_reclaimable;
-	long nr_writeback, bdi_nr_writeback;
+	unsigned long nr_reclaimable, bdi_nr_reclaimable;
+	unsigned long nr_dirty;  /* = file_dirty + writeback + unstable_nfs */
+	unsigned long bdi_dirty;
 	unsigned long background_thresh;
 	unsigned long dirty_thresh;
 	unsigned long bdi_thresh;
@@ -581,7 +582,7 @@ static void balance_dirty_pages(struct a
 
 		nr_reclaimable = global_page_state(NR_FILE_DIRTY) +
 					global_page_state(NR_UNSTABLE_NFS);
-		nr_writeback = global_page_state(NR_WRITEBACK);
+		nr_dirty = nr_reclaimable + global_page_state(NR_WRITEBACK);
 
 		global_dirty_limits(&background_thresh, &dirty_thresh);
 
@@ -590,8 +591,7 @@ static void balance_dirty_pages(struct a
 		 * catch-up. This avoids (excessively) small writeouts
 		 * when the bdi limits are ramping up.
 		 */
-		if (nr_reclaimable + nr_writeback <=
-				(background_thresh + dirty_thresh) / 2)
+		if (nr_dirty <= (background_thresh + dirty_thresh) / 2)
 			break;
 
 		bdi_thresh = bdi_dirty_limit(bdi, dirty_thresh);
@@ -609,10 +609,12 @@ static void balance_dirty_pages(struct a
 		 */
 		if (bdi_thresh < 2*bdi_stat_error(bdi)) {
 			bdi_nr_reclaimable = bdi_stat_sum(bdi, BDI_RECLAIMABLE);
-			bdi_nr_writeback = bdi_stat_sum(bdi, BDI_WRITEBACK);
+			bdi_dirty = bdi_nr_reclaimable +
+				    bdi_stat_sum(bdi, BDI_WRITEBACK);
 		} else {
 			bdi_nr_reclaimable = bdi_stat(bdi, BDI_RECLAIMABLE);
-			bdi_nr_writeback = bdi_stat(bdi, BDI_WRITEBACK);
+			bdi_dirty = bdi_nr_reclaimable +
+				    bdi_stat(bdi, BDI_WRITEBACK);
 		}
 
 		/*
@@ -621,9 +623,8 @@ static void balance_dirty_pages(struct a
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


