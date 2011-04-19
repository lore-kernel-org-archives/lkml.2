Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754601Ab1DSDKx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 23:10:53 -0400
Received: from mga01.intel.com ([192.55.52.88]:6529 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754285Ab1DSDKV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 23:10:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,236,1301900400"; 
   d="scan'208";a="911423212"
Message-Id: <20110419030532.392203618@intel.com>
User-Agent: quilt/0.48-1
Date: Tue, 19 Apr 2011 11:00:05 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Jan Kara <jack@suse.cz>, Mel Gorman <mel@linux.vnet.ibm.com>,
        Mel Gorman <mel@csn.ul.ie>, Itaru Kitayama <kitayama@cl.bb4u.ne.jp>,
        Wu Fengguang <fengguang.wu@intel.com>
cc: Dave Chinner <david@fromorbit.com>
cc: Trond Myklebust <Trond.Myklebust@netapp.com>
CC: Minchan Kim <minchan.kim@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
cc: <linux-fsdevel@vger.kernel.org>,
        Linux Memory Management List <linux-mm@kvack.org>
Subject: [PATCH 2/6] writeback: the kupdate expire timestamp should be a moving target
References: <20110419030003.108796967@intel.com>
Content-Disposition: inline; filename=writeback-moving-target-dirty-expired.patch
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

Acked-by: Jan Kara <jack@suse.cz>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Itaru Kitayama <kitayama@cl.bb4u.ne.jp>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 fs/fs-writeback.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- linux-next.orig/fs/fs-writeback.c	2011-04-19 10:18:28.000000000 +0800
+++ linux-next/fs/fs-writeback.c	2011-04-19 10:18:29.000000000 +0800
@@ -254,16 +254,23 @@ static void move_expired_inodes(struct l
 				struct list_head *dispatch_queue,
 				struct writeback_control *wbc)
 {
+	unsigned long expire_interval = 0;
+	unsigned long older_than_this;
 	LIST_HEAD(tmp);
 	struct list_head *pos, *node;
 	struct super_block *sb = NULL;
 	struct inode *inode;
 	int do_sb_sort = 0;
 
+	if (wbc->for_kupdate) {
+		expire_interval = msecs_to_jiffies(dirty_expire_interval * 10);
+		older_than_this = jiffies - expire_interval;
+	}
+
 	while (!list_empty(delaying_queue)) {
 		inode = wb_inode(delaying_queue->prev);
-		if (wbc->older_than_this &&
-		    inode_dirtied_after(inode, *wbc->older_than_this))
+		if (expire_interval &&
+		    inode_dirtied_after(inode, older_than_this))
 			break;
 		if (sb && sb != inode->i_sb)
 			do_sb_sort = 1;


