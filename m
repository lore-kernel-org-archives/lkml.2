Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754524Ab1DSDKs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 23:10:48 -0400
Received: from mga01.intel.com ([192.55.52.88]:45032 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754296Ab1DSDKW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 23:10:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,236,1301900400"; 
   d="scan'208";a="680845554"
Message-Id: <20110419030532.778889102@intel.com>
User-Agent: quilt/0.48-1
Date: Tue, 19 Apr 2011 11:00:08 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Jan Kara <jack@suse.cz>, Mel Gorman <mel@linux.vnet.ibm.com>,
        Wu Fengguang <fengguang.wu@intel.com>
cc: Dave Chinner <david@fromorbit.com>
cc: Trond Myklebust <Trond.Myklebust@netapp.com>
cc: Itaru Kitayama <kitayama@cl.bb4u.ne.jp>
CC: Minchan Kim <minchan.kim@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
cc: <linux-fsdevel@vger.kernel.org>,
        Linux Memory Management List <linux-mm@kvack.org>
Subject: [PATCH 5/6] writeback: try more writeback as long as something was written
References: <20110419030003.108796967@intel.com>
Content-Disposition: inline; filename=writeback-background-retry.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

writeback_inodes_wb()/__writeback_inodes_sb() are not aggressive in that
they only populate possibly a subset of elegible inodes into b_io at
entrance time. When the queued set of inodes are all synced, they just
return, possibly with all queued inode pages written but still
wbc.nr_to_write > 0.

For kupdate and background writeback, there may be more eligible inodes
sitting in b_dirty when the current set of b_io inodes are completed. So
it is necessary to try another round of writeback as long as we made some
progress in this round. When there are no more eligible inodes, no more
inodes will be enqueued in queue_io(), hence nothing could/will be
synced and we may safely bail.

Jan raised the concern

	I'm just afraid that in some pathological cases this could
	result in bad writeback pattern - like if there is some process
	which manages to dirty just a few pages while we are doing
	writeout, this looping could result in writing just a few pages
	in each round which is bad for fragmentation etc.

However it requires really strong timing to make that to (continuously)
happen.  In practice it's very hard to produce such a pattern even if
it's possible in theory. I actually tried to write 1 page per 1ms with
this command

	write-and-fsync -n10000 -S 1000 -c 4096 /fs/test

and do sync(1) at the same time. The sync completes quickly on ext4,
xfs, btrfs. The readers could try other write-and-sleep patterns and
check if it can block sync for longer time.

CC: Jan Kara <jack@suse.cz>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 fs/fs-writeback.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- linux-next.orig/fs/fs-writeback.c	2011-04-19 10:18:30.000000000 +0800
+++ linux-next/fs/fs-writeback.c	2011-04-19 10:18:31.000000000 +0800
@@ -750,23 +750,23 @@ static long wb_writeback(struct bdi_writ
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


