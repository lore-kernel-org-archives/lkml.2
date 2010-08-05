Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933501Ab0HEQ32 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 12:29:28 -0400
Received: from mga02.intel.com ([134.134.136.20]:49471 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760474Ab0HEQ3S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 12:29:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,323,1278313200"; 
   d="scan'208";a="542252516"
Message-Id: <20100805162434.512614226@intel.com>
User-Agent: quilt/0.48-1
Date: Fri, 06 Aug 2010 00:11:04 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Wu Fengguang <fengguang.wu@intel.com>, LKML <linux-kernel@vger.kernel.org>
CC: Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@infradead.org>,
        Mel Gorman <mel@csn.ul.ie>, Chris Mason <chris.mason@oracle.com>,
        Jens Axboe <axboe@kernel.dk>, Jan Kara <jack@suse.cz>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: [PATCH 13/13] writeback: introduce writeback_control.inodes_written
References: <20100805161051.501816677@intel.com>
Content-Disposition: inline; filename=writeback-inodes_written.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce writeback_control.inodes_written to count successful
->write_inode() calls.  A non-zero value means there are some
progress on writeback, in which case more writeback will be tried.

This prevents aborting a background writeback work prematurely when
the current set of inodes for IO happen to be only metadata-only dirty.

Acked-by: Mel Gorman <mel@csn.ul.ie> 
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 fs/fs-writeback.c         |    5 +++++
 include/linux/writeback.h |    1 +
 2 files changed, 6 insertions(+)

--- linux-next.orig/fs/fs-writeback.c	2010-08-05 23:30:45.000000000 +0800
+++ linux-next/fs/fs-writeback.c	2010-08-05 23:38:55.000000000 +0800
@@ -389,6 +389,8 @@ writeback_single_inode(struct inode *ino
 		int err = write_inode(inode, wbc);
 		if (ret == 0)
 			ret = err;
+		if (!err)
+			wbc->inodes_written++;
 	}
 
 	spin_lock(&inode_lock);
@@ -642,6 +644,7 @@ static long wb_writeback(struct bdi_writ
 
 		wbc.nr_to_write = MAX_WRITEBACK_PAGES;
 		wbc.pages_skipped = 0;
+		wbc.inodes_written = 0;
 
 		trace_wbc_writeback_start(&wbc, wb->bdi);
 		if (work->sb)
@@ -664,6 +667,8 @@ static long wb_writeback(struct bdi_writ
 		 */
 		if (wbc.nr_to_write < MAX_WRITEBACK_PAGES)
 			continue;
+		if (wbc.inodes_written)
+			continue;
 
 		/*
 		 * Nothing written and no more inodes for IO, bail
--- linux-next.orig/include/linux/writeback.h	2010-08-05 23:28:35.000000000 +0800
+++ linux-next/include/linux/writeback.h	2010-08-05 23:40:46.000000000 +0800
@@ -34,6 +34,7 @@ struct writeback_control {
 	long nr_to_write;		/* Write this many pages, and decrement
 					   this for each page written */
 	long pages_skipped;		/* Pages which were not written */
+	long inodes_written;		/* # of inodes (metadata) written */
 
 	/*
 	 * For a_ops->writepages(): is start or end are non-zero then this is


