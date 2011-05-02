Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755984Ab1EBDcY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 23:32:24 -0400
Received: from mga11.intel.com ([192.55.52.93]:10451 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753488Ab1EBDcX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 May 2011 23:32:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,300,1301900400"; 
   d="scan'208";a="916796542"
Message-Id: <20110502033035.537736600@intel.com>
User-Agent: quilt/0.48-1
Date: Mon, 02 May 2011 11:17:51 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Jan Kara <jack@suse.cz>, Dave Chinner <david@fromorbit.com>,
        Wu Fengguang <fengguang.wu@intel.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: LKML <linux-kernel@vger.kernel.org>
cc: <linux-fsdevel@vger.kernel.org>
Subject: [PATCH 1/3] writeback: introduce wbc.tagged_sync for the WB_SYNC_NONE sync stage
References: <20110502031750.135798606@intel.com>
Content-Disposition: inline; filename=writeback-for-sync.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sync(2) is performed in two stages: the WB_SYNC_NONE sync and the
WB_SYNC_ALL sync. Tag the first stage with wbc.tagged_sync and do
livelock prevention for it, too.

Note that writeback_inodes_sb() is called by not only sync(), they are
treated the same because the other callers need also need livelock
prevention.

Impacts:

- it changes the order in which pages/inodes are synced to disk. Now in
  the WB_SYNC_NONE stage, it won't proceed to write the next inode until
  finished with the current inode.

- this adds a new field to the writeback trace events and may possibly
  break some scripts.

CC: Jan Kara <jack@suse.cz>
CC: Dave Chinner <david@fromorbit.com>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 fs/ext4/inode.c           |    4 ++--
 fs/fs-writeback.c         |    9 +++++----
 include/linux/writeback.h |    1 +
 mm/page-writeback.c       |    4 ++--
 4 files changed, 10 insertions(+), 8 deletions(-)

--- linux-next.orig/fs/fs-writeback.c	2011-05-02 11:16:12.000000000 +0800
+++ linux-next/fs/fs-writeback.c	2011-05-02 11:17:33.000000000 +0800
@@ -36,6 +36,7 @@ struct wb_writeback_work {
 	long nr_pages;
 	struct super_block *sb;
 	enum writeback_sync_modes sync_mode;
+	unsigned int tagged_sync:1;
 	unsigned int for_kupdate:1;
 	unsigned int range_cyclic:1;
 	unsigned int for_background:1;
@@ -644,6 +645,7 @@ static long wb_writeback(struct bdi_writ
 {
 	struct writeback_control wbc = {
 		.sync_mode		= work->sync_mode,
+		.tagged_sync		= work->tagged_sync,
 		.older_than_this	= NULL,
 		.for_kupdate		= work->for_kupdate,
 		.for_background		= work->for_background,
@@ -651,7 +653,7 @@ static long wb_writeback(struct bdi_writ
 	};
 	unsigned long oldest_jif;
 	long wrote = 0;
-	long write_chunk;
+	long write_chunk = MAX_WRITEBACK_PAGES;
 	struct inode *inode;
 
 	if (!wbc.range_cyclic) {
@@ -672,9 +674,7 @@ static long wb_writeback(struct bdi_writ
 	 *                   (quickly) tag currently dirty pages
 	 *                   (maybe slowly) sync all tagged pages
 	 */
-	if (wbc.sync_mode == WB_SYNC_NONE)
-		write_chunk = MAX_WRITEBACK_PAGES;
-	else
+	if (wbc.sync_mode == WB_SYNC_ALL || wbc.tagged_sync)
 		write_chunk = LONG_MAX;
 
 	wbc.wb_start = jiffies; /* livelock avoidance */
@@ -1209,6 +1209,7 @@ void writeback_inodes_sb_nr(struct super
 	struct wb_writeback_work work = {
 		.sb		= sb,
 		.sync_mode	= WB_SYNC_NONE,
+		.tagged_sync	= 1,
 		.done		= &done,
 		.nr_pages	= nr,
 	};
--- linux-next.orig/include/linux/writeback.h	2011-05-02 11:16:12.000000000 +0800
+++ linux-next/include/linux/writeback.h	2011-05-02 11:17:31.000000000 +0800
@@ -46,6 +46,7 @@ struct writeback_control {
 	unsigned encountered_congestion:1; /* An output: a queue is full */
 	unsigned for_kupdate:1;		/* A kupdate writeback */
 	unsigned for_background:1;	/* A background writeback */
+	unsigned tagged_sync:1;		/* do livelock prevention for sync */
 	unsigned for_reclaim:1;		/* Invoked from the page allocator */
 	unsigned range_cyclic:1;	/* range_start is cyclic */
 	unsigned more_io:1;		/* more io to be dispatched */
--- linux-next.orig/mm/page-writeback.c	2011-05-02 11:07:57.000000000 +0800
+++ linux-next/mm/page-writeback.c	2011-05-02 11:16:12.000000000 +0800
@@ -892,12 +892,12 @@ int write_cache_pages(struct address_spa
 			range_whole = 1;
 		cycled = 1; /* ignore range_cyclic tests */
 	}
-	if (wbc->sync_mode == WB_SYNC_ALL)
+	if (wbc->sync_mode == WB_SYNC_ALL || wbc->tagged_sync)
 		tag = PAGECACHE_TAG_TOWRITE;
 	else
 		tag = PAGECACHE_TAG_DIRTY;
 retry:
-	if (wbc->sync_mode == WB_SYNC_ALL)
+	if (wbc->sync_mode == WB_SYNC_ALL || wbc->tagged_sync)
 		tag_pages_for_writeback(mapping, index, end);
 	done_index = index;
 	while (!done && (index <= end)) {
--- linux-next.orig/fs/ext4/inode.c	2011-05-02 11:07:57.000000000 +0800
+++ linux-next/fs/ext4/inode.c	2011-05-02 11:16:12.000000000 +0800
@@ -2741,7 +2741,7 @@ static int write_cache_pages_da(struct a
 	index = wbc->range_start >> PAGE_CACHE_SHIFT;
 	end = wbc->range_end >> PAGE_CACHE_SHIFT;
 
-	if (wbc->sync_mode == WB_SYNC_ALL)
+	if (wbc->sync_mode == WB_SYNC_ALL || wbc->tagged_sync)
 		tag = PAGECACHE_TAG_TOWRITE;
 	else
 		tag = PAGECACHE_TAG_DIRTY;
@@ -2975,7 +2975,7 @@ static int ext4_da_writepages(struct add
 	}
 
 retry:
-	if (wbc->sync_mode == WB_SYNC_ALL)
+	if (wbc->sync_mode == WB_SYNC_ALL || wbc->tagged_sync)
 		tag_pages_for_writeback(mapping, index, end);
 
 	while (!ret && wbc->nr_to_write > 0) {


