Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935040Ab1ESVyu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 17:54:50 -0400
Received: from mga09.intel.com ([134.134.136.24]:17849 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934992Ab1ESVyp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 17:54:45 -0400
X-ExtLoop1: 1
Message-Id: <20110519214744.422532523@intel.com>
User-Agent: quilt/0.48-1
Date: Fri, 20 May 2011 05:45:31 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Jan Kara <jack@suse.cz>, Dave Chinner <david@fromorbit.com>,
        Wu Fengguang <fengguang.wu@intel.com>
cc: Christoph Hellwig <hch@infradead.org>
cc: <linux-fsdevel@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 01/18] writeback: introduce .tagged_writepages for the WB_SYNC_NONE sync stage
References: <20110519214530.939830917@intel.com>
Content-Disposition: inline; filename=writeback-for-sync.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sync(2) is performed in two stages: the WB_SYNC_NONE sync and the
WB_SYNC_ALL sync. Identify the first stage with .tagged_writepages and
do livelock prevention for it, too.

Note that writeback_inodes_sb() is called by not only sync(), they are
treated the same because the other callers also need livelock prevention.

Impact:  It changes the order in which pages/inodes are synced to disk.
Now in the WB_SYNC_NONE stage, it won't proceed to write the next inode
until finished with the current inode.

Acked-by: Jan Kara <jack@suse.cz>
CC: Dave Chinner <david@fromorbit.com>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 fs/ext4/inode.c           |    4 ++--
 fs/fs-writeback.c         |   17 +++++++++--------
 include/linux/writeback.h |    1 +
 mm/page-writeback.c       |    4 ++--
 4 files changed, 14 insertions(+), 12 deletions(-)

--- linux-next.orig/fs/fs-writeback.c	2011-05-20 05:01:40.000000000 +0800
+++ linux-next/fs/fs-writeback.c	2011-05-20 05:02:18.000000000 +0800
@@ -36,6 +36,7 @@ struct wb_writeback_work {
 	long nr_pages;
 	struct super_block *sb;
 	enum writeback_sync_modes sync_mode;
+	unsigned int tagged_writepages:1;
 	unsigned int for_kupdate:1;
 	unsigned int range_cyclic:1;
 	unsigned int for_background:1;
@@ -650,6 +651,7 @@ static long wb_writeback(struct bdi_writ
 {
 	struct writeback_control wbc = {
 		.sync_mode		= work->sync_mode,
+		.tagged_writepages	= work->tagged_writepages,
 		.older_than_this	= NULL,
 		.for_kupdate		= work->for_kupdate,
 		.for_background		= work->for_background,
@@ -657,7 +659,7 @@ static long wb_writeback(struct bdi_writ
 	};
 	unsigned long oldest_jif;
 	long wrote = 0;
-	long write_chunk;
+	long write_chunk = MAX_WRITEBACK_PAGES;
 	struct inode *inode;
 
 	if (wbc.for_kupdate) {
@@ -683,9 +685,7 @@ static long wb_writeback(struct bdi_writ
 	 *                   (quickly) tag currently dirty pages
 	 *                   (maybe slowly) sync all tagged pages
 	 */
-	if (wbc.sync_mode == WB_SYNC_NONE)
-		write_chunk = MAX_WRITEBACK_PAGES;
-	else
+	if (wbc.sync_mode == WB_SYNC_ALL || wbc.tagged_writepages)
 		write_chunk = LONG_MAX;
 
 	wbc.wb_start = jiffies; /* livelock avoidance */
@@ -1191,10 +1191,11 @@ void writeback_inodes_sb_nr(struct super
 {
 	DECLARE_COMPLETION_ONSTACK(done);
 	struct wb_writeback_work work = {
-		.sb		= sb,
-		.sync_mode	= WB_SYNC_NONE,
-		.done		= &done,
-		.nr_pages	= nr,
+		.sb			= sb,
+		.sync_mode		= WB_SYNC_NONE,
+		.tagged_writepages	= 1,
+		.done			= &done,
+		.nr_pages		= nr,
 	};
 
 	WARN_ON(!rwsem_is_locked(&sb->s_umount));
--- linux-next.orig/include/linux/writeback.h	2011-05-20 05:01:40.000000000 +0800
+++ linux-next/include/linux/writeback.h	2011-05-20 05:01:42.000000000 +0800
@@ -47,6 +47,7 @@ struct writeback_control {
 	unsigned encountered_congestion:1; /* An output: a queue is full */
 	unsigned for_kupdate:1;		/* A kupdate writeback */
 	unsigned for_background:1;	/* A background writeback */
+	unsigned tagged_writepages:1;	/* tag-and-write to avoid livelock */
 	unsigned for_reclaim:1;		/* Invoked from the page allocator */
 	unsigned range_cyclic:1;	/* range_start is cyclic */
 	unsigned more_io:1;		/* more io to be dispatched */
--- linux-next.orig/mm/page-writeback.c	2011-05-20 05:01:40.000000000 +0800
+++ linux-next/mm/page-writeback.c	2011-05-20 05:01:42.000000000 +0800
@@ -892,12 +892,12 @@ int write_cache_pages(struct address_spa
 			range_whole = 1;
 		cycled = 1; /* ignore range_cyclic tests */
 	}
-	if (wbc->sync_mode == WB_SYNC_ALL)
+	if (wbc->sync_mode == WB_SYNC_ALL || wbc->tagged_writepages)
 		tag = PAGECACHE_TAG_TOWRITE;
 	else
 		tag = PAGECACHE_TAG_DIRTY;
 retry:
-	if (wbc->sync_mode == WB_SYNC_ALL)
+	if (wbc->sync_mode == WB_SYNC_ALL || wbc->tagged_writepages)
 		tag_pages_for_writeback(mapping, index, end);
 	done_index = index;
 	while (!done && (index <= end)) {
--- linux-next.orig/fs/ext4/inode.c	2011-05-20 05:01:40.000000000 +0800
+++ linux-next/fs/ext4/inode.c	2011-05-20 05:01:42.000000000 +0800
@@ -2741,7 +2741,7 @@ static int write_cache_pages_da(struct a
 	index = wbc->range_start >> PAGE_CACHE_SHIFT;
 	end = wbc->range_end >> PAGE_CACHE_SHIFT;
 
-	if (wbc->sync_mode == WB_SYNC_ALL)
+	if (wbc->sync_mode == WB_SYNC_ALL || wbc->tagged_writepages)
 		tag = PAGECACHE_TAG_TOWRITE;
 	else
 		tag = PAGECACHE_TAG_DIRTY;
@@ -2975,7 +2975,7 @@ static int ext4_da_writepages(struct add
 	}
 
 retry:
-	if (wbc->sync_mode == WB_SYNC_ALL)
+	if (wbc->sync_mode == WB_SYNC_ALL || wbc->tagged_writepages)
 		tag_pages_for_writeback(mapping, index, end);
 
 	while (!ret && wbc->nr_to_write > 0) {


