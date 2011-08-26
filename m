Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753339Ab1HZLsV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 07:48:21 -0400
Received: from mga03.intel.com ([143.182.124.21]:36035 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752072Ab1HZLry (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 07:47:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,284,1312182000"; 
   d="scan'208";a="42702471"
Message-Id: <20110826114618.744796470@intel.com>
User-Agent: quilt/0.48-1
Date: Fri, 26 Aug 2011 19:38:14 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
to: <linux-fsdevel@vger.kernel.org>
cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Jan Kara <jack@suse.cz>,
        Michael Rubin <mrubin@google.com>,
        Wu Fengguang <fengguang.wu@intel.com>
cc: Andrew Morton <akpm@linux-foundation.org>
CC: Christoph Hellwig <hch@lst.de>
CC: Dave Chinner <david@fromorbit.com>
CC: Greg Thelen <gthelen@google.com>
CC: Minchan Kim <minchan.kim@gmail.com>
CC: Vivek Goyal <vgoyal@redhat.com>
CC: Andrea Righi <arighi@develer.com>
Cc: linux-mm <linux-mm@kvack.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 01/10] writeback: account per-bdi accumulated dirtied pages
References: <20110826113813.895522398@intel.com>
Content-Disposition: inline; filename=writeback-bdi-dirtied.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce the BDI_DIRTIED counter. It will be used for estimating the
bdi's dirty bandwidth.

CC: Jan Kara <jack@suse.cz>
CC: Michael Rubin <mrubin@google.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 include/linux/backing-dev.h |    1 +
 mm/backing-dev.c            |    2 ++
 mm/page-writeback.c         |    1 +
 3 files changed, 4 insertions(+)

--- linux-next.orig/include/linux/backing-dev.h	2011-08-16 09:30:23.000000000 +0800
+++ linux-next/include/linux/backing-dev.h	2011-08-17 10:15:45.000000000 +0800
@@ -40,6 +40,7 @@ typedef int (congested_fn)(void *, int);
 enum bdi_stat_item {
 	BDI_RECLAIMABLE,
 	BDI_WRITEBACK,
+	BDI_DIRTIED,
 	BDI_WRITTEN,
 	NR_BDI_STAT_ITEMS
 };
--- linux-next.orig/mm/page-writeback.c	2011-08-16 09:30:23.000000000 +0800
+++ linux-next/mm/page-writeback.c	2011-08-17 20:35:22.000000000 +0800
@@ -1333,6 +1333,7 @@ void account_page_dirtied(struct page *p
 		__inc_zone_page_state(page, NR_FILE_DIRTY);
 		__inc_zone_page_state(page, NR_DIRTIED);
 		__inc_bdi_stat(mapping->backing_dev_info, BDI_RECLAIMABLE);
+		__inc_bdi_stat(mapping->backing_dev_info, BDI_DIRTIED);
 		task_dirty_inc(current);
 		task_io_account_write(PAGE_CACHE_SIZE);
 	}
--- linux-next.orig/mm/backing-dev.c	2011-08-16 09:30:23.000000000 +0800
+++ linux-next/mm/backing-dev.c	2011-08-17 10:15:45.000000000 +0800
@@ -97,6 +97,7 @@ static int bdi_debug_stats_show(struct s
 		   "BdiDirtyThresh:     %10lu kB\n"
 		   "DirtyThresh:        %10lu kB\n"
 		   "BackgroundThresh:   %10lu kB\n"
+		   "BdiDirtied:         %10lu kB\n"
 		   "BdiWritten:         %10lu kB\n"
 		   "BdiWriteBandwidth:  %10lu kBps\n"
 		   "b_dirty:            %10lu\n"
@@ -109,6 +110,7 @@ static int bdi_debug_stats_show(struct s
 		   K(bdi_thresh),
 		   K(dirty_thresh),
 		   K(background_thresh),
+		   (unsigned long) K(bdi_stat(bdi, BDI_DIRTIED)),
 		   (unsigned long) K(bdi_stat(bdi, BDI_WRITTEN)),
 		   (unsigned long) K(bdi->write_bandwidth),
 		   nr_dirty,


