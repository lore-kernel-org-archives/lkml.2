Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757513Ab0GVGTi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 02:19:38 -0400
Received: from mga03.intel.com ([143.182.124.21]:24953 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756633Ab0GVGT1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 02:19:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,241,1278313200"; 
   d="scan'208";a="303004449"
Message-Id: <20100722061823.196659592@intel.com>
User-Agent: quilt/0.48-1
Date: Thu, 22 Jul 2010 13:09:34 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: Dave Chinner <david@fromorbit.com>, Wu Fengguang <fengguang.wu@intel.com>
CC: Christoph Hellwig <hch@infradead.org>
CC: Mel Gorman <mel@csn.ul.ie>
CC: Chris Mason <chris.mason@oracle.com>
CC: Jens Axboe <jens.axboe@oracle.com>
Cc: LKML <linux-kernel@vger.kernel.org>
CC: linux-fsdevel@vger.kernel.org
CC: linux-mm@kvack.org
Subject: [PATCH 6/6] writeback: introduce writeback_control.inodes_written
References: <20100722050928.653312535@intel.com>
Content-Disposition: inline; filename=writeback-inodes_written.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce writeback_control.inodes_written to count successful
->write_inode() calls.  A non-zero value means there are some
progress on writeback, in which case more writeback will be tried.

This prevents aborting a background writeback work prematually when
the current set of inodes for IO happen to be metadata-only dirty.

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 fs/fs-writeback.c         |    5 +++++
 include/linux/writeback.h |    1 +
 2 files changed, 6 insertions(+)

--- linux-next.orig/fs/fs-writeback.c	2010-07-22 13:07:54.000000000 +0800
+++ linux-next/fs/fs-writeback.c	2010-07-22 13:07:58.000000000 +0800
@@ -379,6 +379,8 @@ writeback_single_inode(struct inode *ino
 		int err = write_inode(inode, wbc);
 		if (ret == 0)
 			ret = err;
+		if (!err)
+			wbc->inodes_written++;
 	}
 
 	spin_lock(&inode_lock);
@@ -628,6 +630,7 @@ static long wb_writeback(struct bdi_writ
 
 		wbc.nr_to_write = MAX_WRITEBACK_PAGES;
 		wbc.pages_skipped = 0;
+		wbc.inodes_written = 0;
 
 		trace_wbc_writeback_start(&wbc, wb->bdi);
 		if (work->sb)
@@ -650,6 +653,8 @@ static long wb_writeback(struct bdi_writ
 		 */
 		if (wbc.nr_to_write < MAX_WRITEBACK_PAGES)
 			continue;
+		if (wbc.inodes_written)
+			continue;
 
 		/*
 		 * Nothing written and no more inodes for IO, bail
--- linux-next.orig/include/linux/writeback.h	2010-07-22 11:24:46.000000000 +0800
+++ linux-next/include/linux/writeback.h	2010-07-22 13:07:58.000000000 +0800
@@ -34,6 +34,7 @@ struct writeback_control {
 	long nr_to_write;		/* Write this many pages, and decrement
 					   this for each page written */
 	long pages_skipped;		/* Pages which were not written */
+	long inodes_written;		/* Number of inodes(metadata) synced */
 
 	/*
 	 * For a_ops->writepages(): is start or end are non-zero then this is


