Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753635Ab0ILPze (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Sep 2010 11:55:34 -0400
Received: from mga02.intel.com ([134.134.136.20]:32253 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753343Ab0ILPzB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Sep 2010 11:55:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,355,1280732400"; 
   d="scan'208";a="553787498"
Message-Id: <20100912155203.815667143@intel.com>
User-Agent: quilt/0.48-1
Date: Sun, 12 Sep 2010 23:49:53 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: linux-mm <linux-mm@kvack.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Jan Kara <jack@suse.cz>,
        Wu Fengguang <fengguang.wu@intel.com>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: "Theodore Ts'o" <tytso@mit.edu>
CC: Dave Chinner <david@fromorbit.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Mel Gorman <mel@csn.ul.ie>
CC: Rik van Riel <riel@redhat.com>
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Chris Mason <chris.mason@oracle.com>
CC: Christoph Hellwig <hch@lst.de>
CC: Li Shaohua <shaohua.li@intel.com>
Subject: [PATCH 08/17] writeback: account per-bdi accumulated written pages
References: <20100912154945.758129106@intel.com>
Content-Disposition: inline; filename=writeback-bdi-written.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce the BDI_WRITTEN counter. It will be used for estimating the
bdi's write bandwidth.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 include/linux/backing-dev.h |    1 +
 mm/backing-dev.c            |    6 ++++--
 mm/page-writeback.c         |    1 +
 3 files changed, 6 insertions(+), 2 deletions(-)

--- linux-next.orig/include/linux/backing-dev.h	2010-09-09 15:39:25.000000000 +0800
+++ linux-next/include/linux/backing-dev.h	2010-09-09 16:02:43.000000000 +0800
@@ -40,6 +40,7 @@ typedef int (congested_fn)(void *, int);
 enum bdi_stat_item {
 	BDI_RECLAIMABLE,
 	BDI_WRITEBACK,
+	BDI_WRITTEN,
 	NR_BDI_STAT_ITEMS
 };
 
--- linux-next.orig/mm/backing-dev.c	2010-09-09 15:39:25.000000000 +0800
+++ linux-next/mm/backing-dev.c	2010-09-09 16:02:43.000000000 +0800
@@ -91,6 +91,7 @@ static int bdi_debug_stats_show(struct s
 		   "BdiDirtyThresh:   %8lu kB\n"
 		   "DirtyThresh:      %8lu kB\n"
 		   "BackgroundThresh: %8lu kB\n"
+		   "BdiWritten:       %8lu kB\n"
 		   "b_dirty:          %8lu\n"
 		   "b_io:             %8lu\n"
 		   "b_more_io:        %8lu\n"
@@ -98,8 +99,9 @@ static int bdi_debug_stats_show(struct s
 		   "state:            %8lx\n",
 		   (unsigned long) K(bdi_stat(bdi, BDI_WRITEBACK)),
 		   (unsigned long) K(bdi_stat(bdi, BDI_RECLAIMABLE)),
-		   K(bdi_thresh), K(dirty_thresh),
-		   K(background_thresh), nr_dirty, nr_io, nr_more_io,
+		   K(bdi_thresh), K(dirty_thresh), K(background_thresh),
+		   (unsigned long) K(bdi_stat(bdi, BDI_WRITTEN)),
+		   nr_dirty, nr_io, nr_more_io,
 		   !list_empty(&bdi->bdi_list), bdi->state);
 #undef K
 
--- linux-next.orig/mm/page-writeback.c	2010-09-09 16:02:33.000000000 +0800
+++ linux-next/mm/page-writeback.c	2010-09-09 16:02:43.000000000 +0800
@@ -1305,6 +1305,7 @@ int test_clear_page_writeback(struct pag
 						PAGECACHE_TAG_WRITEBACK);
 			if (bdi_cap_account_writeback(bdi)) {
 				__dec_bdi_stat(bdi, BDI_WRITEBACK);
+				__inc_bdi_stat(bdi, BDI_WRITTEN);
 				__bdi_writeout_inc(bdi);
 			}
 		}


