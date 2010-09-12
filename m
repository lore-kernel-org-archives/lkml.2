Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753599Ab0ILPzc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Sep 2010 11:55:32 -0400
Received: from mga11.intel.com ([192.55.52.93]:33603 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753331Ab0ILPzB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Sep 2010 11:55:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,355,1280732400"; 
   d="scan'208";a="606204416"
Message-Id: <20100912155204.296003287@intel.com>
User-Agent: quilt/0.48-1
Date: Sun, 12 Sep 2010 23:49:56 +0800
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
Subject: [PATCH 11/17] writeback: make nr_to_write a per-file limit
References: <20100912154945.758129106@intel.com>
Content-Disposition: inline; filename=writeback-single-file-limit.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This ensures full 4MB (or larger) writeback size for large dirty files.

CC: Jan Kara <jack@suse.cz>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 fs/fs-writeback.c         |   11 +++++++++++
 include/linux/writeback.h |    1 +
 2 files changed, 12 insertions(+)

--- linux-next.orig/fs/fs-writeback.c	2010-09-08 13:50:32.000000000 +0800
+++ linux-next/fs/fs-writeback.c	2010-09-08 13:50:35.000000000 +0800
@@ -304,6 +304,8 @@ static int
 writeback_single_inode(struct inode *inode, struct writeback_control *wbc)
 {
 	struct address_space *mapping = inode->i_mapping;
+	long per_file_limit = wbc->per_file_limit;
+	long nr_to_write;
 	unsigned dirty;
 	int ret;
 
@@ -339,8 +341,16 @@ writeback_single_inode(struct inode *ino
 	inode->i_state &= ~I_DIRTY_PAGES;
 	spin_unlock(&inode_lock);
 
+	if (per_file_limit) {
+		nr_to_write = wbc->nr_to_write;
+		wbc->nr_to_write = per_file_limit;
+	}
+
 	ret = do_writepages(mapping, wbc);
 
+	if (per_file_limit)
+		wbc->nr_to_write += nr_to_write - per_file_limit;
+
 	/*
 	 * Make sure to wait on the data before writing out the metadata.
 	 * This is important for filesystems that modify metadata on data
@@ -635,6 +645,7 @@ static long wb_writeback(struct bdi_writ
 			break;
 
 		wbc.more_io = 0;
+		wbc.per_file_limit = MAX_WRITEBACK_PAGES;
 		wbc.nr_to_write = MAX_WRITEBACK_PAGES;
 		wbc.pages_skipped = 0;
 
--- linux-next.orig/include/linux/writeback.h	2010-09-08 13:50:32.000000000 +0800
+++ linux-next/include/linux/writeback.h	2010-09-08 13:50:35.000000000 +0800
@@ -44,6 +44,7 @@ struct writeback_control {
 					   extra jobs and livelock */
 	long nr_to_write;		/* Write this many pages, and decrement
 					   this for each page written */
+	long per_file_limit;		/* Write this many pages for one file */
 	long pages_skipped;		/* Pages which were not written */
 
 	/*


