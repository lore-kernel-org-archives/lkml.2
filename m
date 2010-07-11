Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754565Ab0GKCiU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jul 2010 22:38:20 -0400
Received: from mga03.intel.com ([143.182.124.21]:20602 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754259Ab0GKCiO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jul 2010 22:38:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,182,1278313200"; 
   d="scan'208";a="298739386"
Message-Id: <20100711021749.303817848@intel.com>
User-Agent: quilt/0.48-1
Date: Sun, 11 Jul 2010 10:07:02 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: Christoph Hellwig <hch@infradead.org>, Dave Chinner <david@fromorbit.com>,
       Martin Bligh <mbligh@google.com>, Michael Rubin <mrubin@google.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Wu Fengguang <fengguang.wu@intel.com>
CC: Jan Kara <jack@suse.cz>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: <linux-fsdevel@vger.kernel.org>
cc: Linux Memory Management List <linux-mm@kvack.org>
cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 6/6] writeback: merge for_kupdate and !for_kupdate cases
References: <20100711020656.340075560@intel.com>
Content-Disposition: inline; filename=writeback-merge-kupdate-cases.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Unify the logic for kupdate and non-kupdate cases.
There won't be starvation because the inodes requeued into b_more_io
will later be spliced _after_ the remaining inodes in b_io, hence won't
stand in the way of other inodes in the next run.

It avoids unnecessary redirty_tail() calls, hence the update of
i_dirtied_when. The timestamp update is undesirable because it could
later delay the inode's periodic writeback, or exclude the inode from
the data integrity sync operation (which will check timestamp to avoid
extra work and livelock).

CC: Dave Chinner <david@fromorbit.com>
Cc: Martin Bligh <mbligh@google.com>
Cc: Michael Rubin <mrubin@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 fs/fs-writeback.c |   39 ++++++---------------------------------
 1 file changed, 6 insertions(+), 33 deletions(-)

--- linux-next.orig/fs/fs-writeback.c	2010-07-11 09:13:32.000000000 +0800
+++ linux-next/fs/fs-writeback.c	2010-07-11 09:13:36.000000000 +0800
@@ -373,45 +373,18 @@ writeback_single_inode(struct inode *ino
 		if (mapping_tagged(mapping, PAGECACHE_TAG_DIRTY)) {
 			/*
 			 * We didn't write back all the pages.  nfs_writepages()
-			 * sometimes bales out without doing anything. Redirty
-			 * the inode; Move it from b_io onto b_more_io/b_dirty.
+			 * sometimes bales out without doing anything.
 			 */
-			/*
-			 * akpm: if the caller was the kupdate function we put
-			 * this inode at the head of b_dirty so it gets first
-			 * consideration.  Otherwise, move it to the tail, for
-			 * the reasons described there.  I'm not really sure
-			 * how much sense this makes.  Presumably I had a good
-			 * reasons for doing it this way, and I'd rather not
-			 * muck with it at present.
-			 */
-			if (wbc->for_kupdate) {
+			inode->i_state |= I_DIRTY_PAGES;
+			if (wbc->nr_to_write <= 0) {
 				/*
-				 * For the kupdate function we move the inode
-				 * to b_more_io so it will get more writeout as
-				 * soon as the queue becomes uncongested.
+				 * slice used up: queue for next turn
 				 */
-				inode->i_state |= I_DIRTY_PAGES;
-				if (wbc->nr_to_write <= 0) {
-					/*
-					 * slice used up: queue for next turn
-					 */
-					requeue_io(inode);
-				} else {
-					/*
-					 * somehow blocked: retry later
-					 */
-					redirty_tail(inode);
-				}
+				requeue_io(inode);
 			} else {
 				/*
-				 * Otherwise fully redirty the inode so that
-				 * other inodes on this superblock will get some
-				 * writeout.  Otherwise heavy writing to one
-				 * file would indefinitely suspend writeout of
-				 * all the other files.
+				 * somehow blocked: retry later
 				 */
-				inode->i_state |= I_DIRTY_PAGES;
 				redirty_tail(inode);
 			}
 		} else if (inode->i_state & I_DIRTY) {


