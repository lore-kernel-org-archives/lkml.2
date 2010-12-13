Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932291Ab0LMGx3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 01:53:29 -0500
Received: from mga02.intel.com ([134.134.136.20]:4695 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755371Ab0LMGto (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 01:49:44 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,335,1288594800"; 
   d="scan'208";a="686523144"
Message-Id: <20101213064841.322569223@intel.com>
User-Agent: quilt/0.48-1
Date: Mon, 13 Dec 2010 14:43:24 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: Jan Kara <jack@suse.cz>, Theodore Tso <tytso@mit.edu>,
        Dave Chinner <david@fromorbit.com>,
        Chris Mason <chris.mason@oracle.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Wu Fengguang <fengguang.wu@intel.com>
CC: Christoph Hellwig <hch@lst.de>
CC: Trond Myklebust <Trond.Myklebust@netapp.com>
CC: Mel Gorman <mel@csn.ul.ie>
CC: Rik van Riel <riel@redhat.com>
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Greg Thelen <gthelen@google.com>
CC: Minchan Kim <minchan.kim@gmail.com>
Cc: linux-mm <linux-mm@kvack.org>
Cc: <linux-fsdevel@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 35/47] writeback: scale IO chunk size up to device bandwidth
References: <20101213064249.648862451@intel.com>
Content-Disposition: inline; filename=writeback-128M-MAX_WRITEBACK_PAGES.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Originally, MAX_WRITEBACK_PAGES was hard-coded to 1024 because of a
concern of not holding I_SYNC for too long.  (At least, that was the
comment previously.)  This doesn't make sense now because the only
time we wait for I_SYNC is if we are calling sync or fsync, and in
that case we need to write out all of the data anyway.  Previously
there may have been other code paths that waited on I_SYNC, but not
any more.					    -- Theodore Ts'o

According to Christoph, the current writeback size is way too small,
and XFS had a hack that bumped out nr_to_write to four times the value
sent by the VM to be able to saturate medium-sized RAID arrays.  This
value was also problematic for ext4 as well, as it caused large files
to be come interleaved on disk by in 8 megabyte chunks (we bumped up
the nr_to_write by a factor of two).

So remove the MAX_WRITEBACK_PAGES constraint totally. The writeback pages
will adapt to as large as the storage device can write within 1 second.

For a typical hard disk, the resulted chunk size will be 32MB or 64MB.

http://bugzilla.kernel.org/show_bug.cgi?id=13930

CC: Theodore Ts'o <tytso@mit.edu>
CC: Dave Chinner <david@fromorbit.com>
CC: Chris Mason <chris.mason@oracle.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 fs/fs-writeback.c         |   60 +++++++++++++++++++-----------------
 include/linux/writeback.h |    5 +++
 2 files changed, 38 insertions(+), 27 deletions(-)

--- linux-next.orig/fs/fs-writeback.c	2010-12-09 12:24:57.000000000 +0800
+++ linux-next/fs/fs-writeback.c	2010-12-09 12:24:58.000000000 +0800
@@ -602,15 +602,6 @@ static void __writeback_inodes_sb(struct
 	spin_unlock(&inode_lock);
 }
 
-/*
- * The maximum number of pages to writeout in a single bdi flush/kupdate
- * operation.  We do this so we don't hold I_SYNC against an inode for
- * enormous amounts of time, which would block a userspace task which has
- * been forced to throttle against that inode.  Also, the code reevaluates
- * the dirty each time it has written this many pages.
- */
-#define MAX_WRITEBACK_PAGES     1024
-
 static inline bool over_bground_thresh(void)
 {
 	unsigned long background_thresh, dirty_thresh;
@@ -622,6 +613,38 @@ static inline bool over_bground_thresh(v
 }
 
 /*
+ * Give each inode a nr_to_write that can complete within 1 second.
+ */
+static unsigned long writeback_chunk_size(struct backing_dev_info *bdi,
+					  int sync_mode)
+{
+	unsigned long pages;
+
+	/*
+	 * WB_SYNC_ALL mode does livelock avoidance by syncing dirty
+	 * inodes/pages in one big loop. Setting wbc.nr_to_write=LONG_MAX
+	 * here avoids calling into writeback_inodes_wb() more than once.
+	 *
+	 * The intended call sequence for WB_SYNC_ALL writeback is:
+	 *
+	 *      wb_writeback()
+	 *          __writeback_inodes_sb()     <== called only once
+	 *              write_cache_pages()     <== called once for each inode
+	 *                  (quickly) tag currently dirty pages
+	 *                  (maybe slowly) sync all tagged pages
+	 */
+	if (sync_mode == WB_SYNC_ALL)
+		return LONG_MAX;
+
+	pages = bdi->write_bandwidth;
+
+	if (pages < MIN_WRITEBACK_PAGES)
+		return MIN_WRITEBACK_PAGES;
+
+	return rounddown_pow_of_two(pages);
+}
+
+/*
  * Explicit flushing or periodic writeback of "old" data.
  *
  * Define "old": the first time one of an inode's pages is dirtied, we mark the
@@ -661,24 +684,6 @@ static long wb_writeback(struct bdi_writ
 		wbc.range_end = LLONG_MAX;
 	}
 
-	/*
-	 * WB_SYNC_ALL mode does livelock avoidance by syncing dirty
-	 * inodes/pages in one big loop. Setting wbc.nr_to_write=LONG_MAX
-	 * here avoids calling into writeback_inodes_wb() more than once.
-	 *
-	 * The intended call sequence for WB_SYNC_ALL writeback is:
-	 *
-	 *      wb_writeback()
-	 *          __writeback_inodes_sb()     <== called only once
-	 *              write_cache_pages()     <== called once for each inode
-	 *                   (quickly) tag currently dirty pages
-	 *                   (maybe slowly) sync all tagged pages
-	 */
-	if (wbc.sync_mode == WB_SYNC_NONE)
-		write_chunk = MAX_WRITEBACK_PAGES;
-	else
-		write_chunk = LONG_MAX;
-
 	wbc.wb_start = jiffies; /* livelock avoidance */
 	bdi_update_write_bandwidth(wb->bdi, wbc.wb_start);
 
@@ -707,6 +712,7 @@ static long wb_writeback(struct bdi_writ
 			break;
 
 		wbc.more_io = 0;
+		write_chunk = writeback_chunk_size(wb->bdi, wbc.sync_mode);
 		wbc.nr_to_write = write_chunk;
 		wbc.per_file_limit = write_chunk;
 		wbc.pages_skipped = 0;
--- linux-next.orig/include/linux/writeback.h	2010-12-09 12:21:03.000000000 +0800
+++ linux-next/include/linux/writeback.h	2010-12-09 12:24:58.000000000 +0800
@@ -22,6 +22,11 @@ extern spinlock_t inode_lock;
 #define TASK_SOFT_DIRTY_LIMIT	(BDI_SOFT_DIRTY_LIMIT * 2)
 
 /*
+ * 4MB minimal write chunk size
+ */
+#define MIN_WRITEBACK_PAGES     (4096 >> (PAGE_CACHE_SHIFT - 10))
+
+/*
  * fs/fs-writeback.c
  */
 enum writeback_sync_modes {


