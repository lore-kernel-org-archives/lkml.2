Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753173Ab1DTIrX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 04:47:23 -0400
Received: from mga01.intel.com ([192.55.52.88]:2992 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752759Ab1DTIqO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 04:46:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,245,1301900400"; 
   d="scan'208";a="912118764"
Message-Id: <20110420080917.890756812@intel.com>
User-Agent: quilt/0.48-1
Date: Wed, 20 Apr 2011 16:03:38 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Jan Kara <jack@suse.cz>, Mel Gorman <mel@linux.vnet.ibm.com>,
        Mel Gorman <mel@csn.ul.ie>, Wu Fengguang <fengguang.wu@intel.com>
cc: Dave Chinner <david@fromorbit.com>
cc: Itaru Kitayama <kitayama@cl.bb4u.ne.jp>
CC: Minchan Kim <minchan.kim@gmail.com>
cc: Linux Memory Management List <linux-mm@kvack.org>,
        <linux-fsdevel@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/6] writeback: introduce writeback_control.inodes_cleaned
References: <20110420080336.441157866@intel.com>
Content-Disposition: inline; filename=writeback-inodes_written.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The flusher works on dirty inodes in batches, and may quit prematurely
if the batch of inodes happen to be metadata-only dirtied: in this case
wbc->nr_to_write won't be decreased at all, which stands for "no pages
written" but also mis-interpreted as "no progress".

So introduce writeback_control.inodes_cleaned to count the inodes get
cleaned.  A non-zero value means there are some progress on writeback,
in which case more writeback can be tried.

about v1: The initial version was to count successful ->write_inode()
calls.  However it leads to busy loops for sync() over NFS, because NFS
ridiculously returns 0 (success) while at the same time redirties the
inode.  The NFS case can be trivially fixed, however there may be more
hidden bugs in other filesystems..

Acked-by: Jan Kara <jack@suse.cz>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 fs/fs-writeback.c         |    4 ++++
 include/linux/writeback.h |    1 +
 2 files changed, 5 insertions(+)

--- linux-next.orig/fs/fs-writeback.c	2011-04-20 11:50:10.000000000 +0800
+++ linux-next/fs/fs-writeback.c	2011-04-20 11:53:35.000000000 +0800
@@ -454,6 +454,7 @@ writeback_single_inode(struct inode *ino
 			 * No need to add it back to the LRU.
 			 */
 			list_del_init(&inode->i_wb_list);
+			wbc->inodes_cleaned++;
 		}
 	}
 	inode_sync_complete(inode);
@@ -716,6 +717,7 @@ static long wb_writeback(struct bdi_writ
 		wbc.more_io = 0;
 		wbc.nr_to_write = write_chunk;
 		wbc.pages_skipped = 0;
+		wbc.inodes_cleaned = 0;
 
 		trace_wbc_writeback_start(&wbc, wb->bdi);
 		if (work->sb)
@@ -732,6 +734,8 @@ static long wb_writeback(struct bdi_writ
 		 */
 		if (wbc.nr_to_write <= 0)
 			continue;
+		if (wbc.inodes_cleaned)
+			continue;
 		/*
 		 * Didn't write everything and we don't have more IO, bail
 		 */
--- linux-next.orig/include/linux/writeback.h	2011-04-20 10:30:29.000000000 +0800
+++ linux-next/include/linux/writeback.h	2011-04-20 11:53:35.000000000 +0800
@@ -34,6 +34,7 @@ struct writeback_control {
 	long nr_to_write;		/* Write this many pages, and decrement
 					   this for each page written */
 	long pages_skipped;		/* Pages which were not written */
+	long inodes_cleaned;		/* # of inodes cleaned */
 
 	/*
 	 * For a_ops->writepages(): is start or end are non-zero then this is


