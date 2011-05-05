Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754036Ab1EENaI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 09:30:08 -0400
Received: from mga11.intel.com ([192.55.52.93]:43054 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752553Ab1EENaG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 09:30:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,319,1301900400"; 
   d="scan'208";a="688600327"
Date: Thu, 5 May 2011 21:30:02 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>,
        Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Dave Chinner <david@fromorbit.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: [PATCH] writeback: remove .nonblocking and .encountered_congestion
Message-ID: <20110505133002.GA7724@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[allyesconfig compile tested]
[it modifies 3 filesystems all at once, is it OK?]

Remove two unused struct writeback_control fields:

	.encountered_congestion	(completley unused)
	.nonblocking		(never set, checked/showed in XFS,NFS/btrfs)

Proposed-by: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 fs/nfs/write.c               |    3 +--
 fs/xfs/linux-2.6/xfs_aops.c  |    2 +-
 include/linux/writeback.h    |    2 --
 include/trace/events/btrfs.h |    6 ++----
 4 files changed, 4 insertions(+), 9 deletions(-)

--- linux-next.orig/fs/xfs/linux-2.6/xfs_aops.c	2011-05-05 21:10:01.000000000 +0800
+++ linux-next/fs/xfs/linux-2.6/xfs_aops.c	2011-05-05 21:10:37.000000000 +0800
@@ -970,7 +970,7 @@ xfs_vm_writepage(
 	offset = page_offset(page);
 	type = IO_OVERWRITE;
 
-	if (wbc->sync_mode == WB_SYNC_NONE && wbc->nonblocking)
+	if (wbc->sync_mode == WB_SYNC_NONE)
 		nonblocking = 1;
 
 	do {
--- linux-next.orig/include/trace/events/btrfs.h	2011-05-05 21:07:31.000000000 +0800
+++ linux-next/include/trace/events/btrfs.h	2011-05-05 21:09:47.000000000 +0800
@@ -284,7 +284,6 @@ DECLARE_EVENT_CLASS(btrfs__writepage,
 		__field(	long,   pages_skipped		)
 		__field(	loff_t, range_start		)
 		__field(	loff_t, range_end		)
-		__field(	char,   nonblocking		)
 		__field(	char,   for_kupdate		)
 		__field(	char,   for_reclaim		)
 		__field(	char,   range_cyclic		)
@@ -299,7 +298,6 @@ DECLARE_EVENT_CLASS(btrfs__writepage,
 		__entry->pages_skipped	= wbc->pages_skipped;
 		__entry->range_start	= wbc->range_start;
 		__entry->range_end	= wbc->range_end;
-		__entry->nonblocking	= wbc->nonblocking;
 		__entry->for_kupdate	= wbc->for_kupdate;
 		__entry->for_reclaim	= wbc->for_reclaim;
 		__entry->range_cyclic	= wbc->range_cyclic;
@@ -310,13 +308,13 @@ DECLARE_EVENT_CLASS(btrfs__writepage,
 
 	TP_printk("root = %llu(%s), ino = %lu, page_index = %lu, "
 		  "nr_to_write = %ld, pages_skipped = %ld, range_start = %llu, "
-		  "range_end = %llu, nonblocking = %d, for_kupdate = %d, "
+		  "range_end = %llu, for_kupdate = %d, "
 		  "for_reclaim = %d, range_cyclic = %d, writeback_index = %lu",
 		  show_root_type(__entry->root_objectid),
 		  (unsigned long)__entry->ino, __entry->index,
 		  __entry->nr_to_write, __entry->pages_skipped,
 		  __entry->range_start, __entry->range_end,
-		  __entry->nonblocking, __entry->for_kupdate,
+		  __entry->for_kupdate,
 		  __entry->for_reclaim, __entry->range_cyclic,
 		  (unsigned long)__entry->writeback_index)
 );
--- linux-next.orig/fs/nfs/write.c	2011-05-05 21:10:52.000000000 +0800
+++ linux-next/fs/nfs/write.c	2011-05-05 21:11:19.000000000 +0800
@@ -1564,8 +1564,7 @@ int nfs_write_inode(struct inode *inode,
 		int status;
 		bool sync = true;
 
-		if (wbc->sync_mode == WB_SYNC_NONE || wbc->nonblocking ||
-		    wbc->for_background)
+		if (wbc->sync_mode == WB_SYNC_NONE)
 			sync = false;
 
 		status = pnfs_layoutcommit_inode(inode, sync);
--- linux-next.orig/include/linux/writeback.h	2011-05-05 21:07:16.000000000 +0800
+++ linux-next/include/linux/writeback.h	2011-05-05 21:13:20.000000000 +0800
@@ -36,8 +36,6 @@ struct writeback_control {
 	loff_t range_start;
 	loff_t range_end;
 
-	unsigned nonblocking:1;		/* Don't get stuck on request queues */
-	unsigned encountered_congestion:1; /* An output: a queue is full */
 	unsigned for_kupdate:1;		/* A kupdate writeback */
 	unsigned for_background:1;	/* A background writeback */
 	unsigned tagged_sync:1;		/* do livelock prevention for sync */
