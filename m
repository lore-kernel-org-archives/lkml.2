Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935132Ab1ESV73 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 17:59:29 -0400
Received: from mga14.intel.com ([143.182.124.37]:61718 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934998Ab1ESVyq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 17:54:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,239,1304319600"; 
   d="scan'208";a="439348029"
Message-Id: <20110519214744.801506906@intel.com>
User-Agent: quilt/0.48-1
Date: Fri, 20 May 2011 05:45:34 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Jan Kara <jack@suse.cz>, Wu Fengguang <fengguang.wu@intel.com>
cc: Dave Chinner <david@fromorbit.com>
cc: Christoph Hellwig <hch@infradead.org>
cc: <linux-fsdevel@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 04/18] writeback: try more writeback as long as something was written
References: <20110519214530.939830917@intel.com>
Content-Disposition: inline; filename=writeback-background-retry.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

writeback_inodes_wb()/__writeback_inodes_sb() are not aggressive in that
they only populate possibly a subset of eligible inodes into b_io at
entrance time. When the queued set of inodes are all synced, they just
return, possibly with all queued inode pages written but still
wbc.nr_to_write > 0.

For kupdate and background writeback, there may be more eligible inodes
sitting in b_dirty when the current set of b_io inodes are completed. So
it is necessary to try another round of writeback as long as we made some
progress in this round. When there are no more eligible inodes, no more
inodes will be enqueued in queue_io(), hence nothing could/will be
synced and we may safely bail.

For example, imagine 100 inodes

        i0, i1, i2, ..., i90, i91, i99

At queue_io() time, i90-i99 happen to be expired and moved to s_io for
IO. When finished successfully, if their total size is less than
MAX_WRITEBACK_PAGES, nr_to_write will be > 0. Then wb_writeback() will
quit the background work (w/o this patch) while it's still over
background threshold. This will be a fairly normal/frequent case I guess.

Now that we do tagged sync and update inode->dirtied_when after the sync,
this change won't livelock sync(1).  I actually tried to write 1 page
per 1ms with this command

	write-and-fsync -n10000 -S 1000 -c 4096 /fs/test

and do sync(1) at the same time. The sync completes quickly on ext4,
xfs, btrfs.

Acked-by: Jan Kara <jack@suse.cz>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 fs/fs-writeback.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- linux-next.orig/fs/fs-writeback.c	2011-05-20 05:11:24.000000000 +0800
+++ linux-next/fs/fs-writeback.c	2011-05-20 05:11:28.000000000 +0800
@@ -739,23 +739,23 @@ static long wb_writeback(struct bdi_writ
 		wrote += write_chunk - wbc.nr_to_write;
 
 		/*
-		 * If we consumed everything, see if we have more
+		 * Did we write something? Try for more
+		 *
+		 * Dirty inodes are moved to b_io for writeback in batches.
+		 * The completion of the current batch does not necessarily
+		 * mean the overall work is done. So we keep looping as long
+		 * as made some progress on cleaning pages or inodes.
 		 */
-		if (wbc.nr_to_write <= 0)
+		if (wbc.nr_to_write < write_chunk)
 			continue;
 		if (wbc.inodes_cleaned)
 			continue;
 		/*
-		 * Didn't write everything and we don't have more IO, bail
+		 * No more inodes for IO, bail
 		 */
 		if (!wbc.more_io)
 			break;
 		/*
-		 * Did we write something? Try for more
-		 */
-		if (wbc.nr_to_write < write_chunk)
-			continue;
-		/*
 		 * Nothing written. Wait for some inode to
 		 * become available for writeback. Otherwise
 		 * we'll just busyloop.


