Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757805Ab1CCIWO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 03:22:14 -0500
Received: from mga02.intel.com ([134.134.136.20]:10245 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754588Ab1CCIR5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 03:17:57 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,257,1297065600"; 
   d="scan'208";a="715563064"
Message-Id: <20110303074951.964058636@intel.com>
User-Agent: quilt/0.48-1
Date: Thu, 03 Mar 2011 14:45:30 +0800
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
CC: Vivek Goyal <vgoyal@redhat.com>
CC: Andrea Righi <arighi@develer.com>
CC: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: linux-mm <linux-mm@kvack.org>
Cc: <linux-fsdevel@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 25/27] writeback: make nr_to_write a per-file limit
References: <20110303064505.718671603@intel.com>
Content-Disposition: inline; filename=writeback-single-file-limit.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This ensures full 4MB or larger writeback size for large dirty files.

CC: Jan Kara <jack@suse.cz>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 fs/fs-writeback.c         |   11 +++++++++++
 include/linux/writeback.h |    1 +
 2 files changed, 12 insertions(+)

--- linux-next.orig/fs/fs-writeback.c	2011-03-03 14:02:53.000000000 +0800
+++ linux-next/fs/fs-writeback.c	2011-03-03 14:03:32.000000000 +0800
@@ -330,6 +330,8 @@ static int
 writeback_single_inode(struct inode *inode, struct writeback_control *wbc)
 {
 	struct address_space *mapping = inode->i_mapping;
+	long per_file_limit = wbc->per_file_limit;
+	long uninitialized_var(nr_to_write);
 	unsigned dirty;
 	int ret;
 
@@ -365,8 +367,16 @@ writeback_single_inode(struct inode *ino
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
@@ -689,6 +699,7 @@ static long wb_writeback(struct bdi_writ
 
 		wbc.more_io = 0;
 		wbc.nr_to_write = write_chunk;
+		wbc.per_file_limit = write_chunk;
 		wbc.pages_skipped = 0;
 
 		trace_wbc_writeback_start(&wbc, wb->bdi);
--- linux-next.orig/include/linux/writeback.h	2011-03-03 14:02:53.000000000 +0800
+++ linux-next/include/linux/writeback.h	2011-03-03 14:03:32.000000000 +0800
@@ -74,6 +74,7 @@ struct writeback_control {
 					   extra jobs and livelock */
 	long nr_to_write;		/* Write this many pages, and decrement
 					   this for each page written */
+	long per_file_limit;		/* Write this many pages for one file */
 	long pages_skipped;		/* Pages which were not written */
 
 	/*


