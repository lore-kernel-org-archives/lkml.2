Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757578Ab1ELOHE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 10:07:04 -0400
Received: from mga03.intel.com ([143.182.124.21]:65228 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757486Ab1ELOEO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 10:04:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,358,1301900400"; 
   d="scan'208";a="434940486"
Message-Id: <20110512140031.265688206@intel.com>
User-Agent: quilt/0.48-1
Date: Thu, 12 May 2011 21:57:11 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Jan Kara <jack@suse.cz>, Dave Chinner <david@fromorbit.com>,
        Mel Gorman <mel@csn.ul.ie>, Itaru Kitayama <kitayama@cl.bb4u.ne.jp>,
        Wu Fengguang <fengguang.wu@intel.com>
cc: Christoph Hellwig <hch@infradead.org>
cc: <linux-fsdevel@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 05/17] writeback: the kupdate expire timestamp should be a moving target
References: <20110512135706.937596128@intel.com>
Content-Disposition: inline; filename=writeback-moving-dirty-expired.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dynamically compute the dirty expire timestamp at queue_io() time.

writeback_control.older_than_this used to be determined at entrance to
the kupdate writeback work. This _static_ timestamp may go stale if the
kupdate work runs on and on. The flusher may then stuck with some old
busy inodes, never considering newly expired inodes thereafter.

This has two possible problems:

- It is unfair for a large dirty inode to delay (for a long time) the
  writeback of small dirty inodes.

- As time goes by, the large and busy dirty inode may contain only
  _freshly_ dirtied pages. Ignoring newly expired dirty inodes risks
  delaying the expired dirty pages to the end of LRU lists, triggering
  the evil pageout(). Nevertheless this patch merely addresses part
  of the problem.

v2: keep policy changes inside wb_writeback() and keep the
wbc.older_than_this visibility as suggested by Dave.

CC: Dave Chinner <david@fromorbit.com>
Acked-by: Jan Kara <jack@suse.cz>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Itaru Kitayama <kitayama@cl.bb4u.ne.jp>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 fs/fs-writeback.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- linux-next.orig/fs/fs-writeback.c	2011-05-05 23:30:25.000000000 +0800
+++ linux-next/fs/fs-writeback.c	2011-05-05 23:30:25.000000000 +0800
@@ -672,11 +672,6 @@ static long wb_writeback(struct bdi_writ
 	long write_chunk = MAX_WRITEBACK_PAGES;
 	struct inode *inode;
 
-	if (wbc.for_kupdate) {
-		wbc.older_than_this = &oldest_jif;
-		oldest_jif = jiffies -
-				msecs_to_jiffies(dirty_expire_interval * 10);
-	}
 	if (!wbc.range_cyclic) {
 		wbc.range_start = 0;
 		wbc.range_end = LLONG_MAX;
@@ -723,6 +718,12 @@ static long wb_writeback(struct bdi_writ
 		if (work->for_background && !over_bground_thresh())
 			break;
 
+		if (work->for_kupdate) {
+			oldest_jif = jiffies -
+				msecs_to_jiffies(dirty_expire_interval * 10);
+			wbc.older_than_this = &oldest_jif;
+		}
+
 		wbc.more_io = 0;
 		wbc.nr_to_write = write_chunk;
 		wbc.pages_skipped = 0;


