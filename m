Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754419Ab1FSP16 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jun 2011 11:27:58 -0400
Received: from mga02.intel.com ([134.134.136.20]:57825 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754249Ab1FSP1v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jun 2011 11:27:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,389,1304319600"; 
   d="scan'208";a="16865961"
Message-Id: <20110619150510.130768812@intel.com>
User-Agent: quilt/0.48-1
Date: Sun, 19 Jun 2011 23:01:10 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
CC: Jan Kara <jack@suse.cz>, Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Wu Fengguang <fengguang.wu@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/7] writeback: add parameters to __bdi_update_bandwidth()
References: <20110619150108.691351746@intel.com>
Content-Disposition: inline; filename=lll
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The added parameters will be used by the next patch and more future patches.

It's separated out for easier review, and will be merged either with the
next patch or with the previous write bandwidth patch in future posts.

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 fs/fs-writeback.c         |    2 +-
 include/linux/writeback.h |    3 +++
 mm/page-writeback.c       |   21 +++++++++++++++++++--
 3 files changed, 23 insertions(+), 3 deletions(-)

--- linux-next.orig/mm/page-writeback.c	2011-06-19 22:51:50.000000000 +0800
+++ linux-next/mm/page-writeback.c	2011-06-19 22:53:46.000000000 +0800
@@ -549,6 +549,9 @@ static void global_update_bandwidth(unsi
 }
 
 void __bdi_update_bandwidth(struct backing_dev_info *bdi,
+			    unsigned long thresh,
+			    unsigned long dirty,
+			    unsigned long bdi_dirty,
 			    unsigned long start_time)
 {
 	unsigned long now = jiffies;
@@ -581,12 +593,16 @@ snapshot:
 }
 
 static void bdi_update_bandwidth(struct backing_dev_info *bdi,
+				 unsigned long thresh,
+				 unsigned long dirty,
+				 unsigned long bdi_dirty,
 				 unsigned long start_time)
 {
 	if (jiffies - bdi->bw_time_stamp <= MAX_PAUSE + MAX_PAUSE / 10)
 		return;
 	if (spin_trylock(&bdi->wb.list_lock)) {
-		__bdi_update_bandwidth(bdi, start_time);
+		__bdi_update_bandwidth(bdi, thresh, dirty, bdi_dirty,
+				       start_time);
 		spin_unlock(&bdi->wb.list_lock);
 	}
 }
@@ -673,7 +689,8 @@ static void balance_dirty_pages(struct a
 		if (!bdi->dirty_exceeded)
 			bdi->dirty_exceeded = 1;
 
-		bdi_update_bandwidth(bdi, start_time);
+		bdi_update_bandwidth(bdi, dirty_thresh, nr_dirty, bdi_dirty,
+				     start_time);
 
 		/* Note: nr_reclaimable denotes nr_dirty + nr_unstable.
 		 * Unstable writes are a feature of certain networked
--- linux-next.orig/include/linux/writeback.h	2011-06-19 22:51:50.000000000 +0800
+++ linux-next/include/linux/writeback.h	2011-06-19 22:53:29.000000000 +0800
@@ -125,6 +125,9 @@ unsigned long bdi_dirty_limit(struct bac
 			       unsigned long dirty);
 
 void __bdi_update_bandwidth(struct backing_dev_info *bdi,
+			    unsigned long thresh,
+			    unsigned long dirty,
+			    unsigned long bdi_dirty,
 			    unsigned long start_time);
 
 void page_writeback_init(void);
--- linux-next.orig/fs/fs-writeback.c	2011-06-19 22:51:50.000000000 +0800
+++ linux-next/fs/fs-writeback.c	2011-06-19 22:53:29.000000000 +0800
@@ -635,7 +635,7 @@ static inline bool over_bground_thresh(v
 static void wb_update_bandwidth(struct bdi_writeback *wb,
 				unsigned long start_time)
 {
-	__bdi_update_bandwidth(wb->bdi, start_time);
+	__bdi_update_bandwidth(wb->bdi, 0, 0, 0, start_time);
 }
 
 /*


