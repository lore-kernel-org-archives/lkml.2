Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755623Ab2ECMsl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 08:48:41 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34664 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755337Ab2ECMse (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 08:48:34 -0400
From: Jan Kara <jack@suse.cz>
To: linux-fsdevel@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>, Al Viro <viro@ZenIV.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>, dchinner@redhat.com,
        Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>
Subject: [PATCH 4/9] writeback: Separate inode requeueing after writeback
Date: Thu,  3 May 2012 14:47:58 +0200
Message-Id: <1336049283-5859-5-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1336049283-5859-1-git-send-email-jack@suse.cz>
References: <1336049283-5859-1-git-send-email-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move inode requeueing after inode has been written out into a separate
function.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/fs-writeback.c |  102 ++++++++++++++++++++++++++++------------------------
 1 files changed, 55 insertions(+), 47 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 3804a10..5d3de00 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -345,6 +345,60 @@ static void inode_wait_for_writeback(struct inode *inode,
 }
 
 /*
+ * Find proper writeback list for the inode depending on its current state and
+ * possibly also change of its state while we were doing writeback.  Here we
+ * handle things such as livelock prevention or fairness of writeback among
+ * inodes. This function can be called only by flusher thread - noone else
+ * processes all inodes in writeback lists and requeueing inodes behind flusher
+ * thread's back can have unexpected consequences.
+ */
+static void requeue_inode(struct inode *inode, struct bdi_writeback *wb,
+			  struct writeback_control *wbc)
+{
+	if (inode->i_state & I_FREEING)
+		return;
+
+	/*
+	 * Sync livelock prevention. Each inode is tagged and synced in one
+	 * shot. If still dirty, it will be redirty_tail()'ed below.  Update
+	 * the dirty time to prevent enqueue and sync it again.
+	 */
+	if ((inode->i_state & I_DIRTY) &&
+	    (wbc->sync_mode == WB_SYNC_ALL || wbc->tagged_writepages))
+		inode->dirtied_when = jiffies;
+
+	if (mapping_tagged(inode->i_mapping, PAGECACHE_TAG_DIRTY)) {
+		/*
+		 * We didn't write back all the pages.  nfs_writepages()
+		 * sometimes bales out without doing anything.
+		 */
+		if (wbc->nr_to_write <= 0) {
+			/* Slice used up. Queue for next turn. */
+			requeue_io(inode, wb);
+		} else {
+			/*
+			 * Writeback blocked by something other than
+			 * congestion. Delay the inode for some time to
+			 * avoid spinning on the CPU (100% iowait)
+			 * retrying writeback of the dirty page/inode
+			 * that cannot be performed immediately.
+			 */
+			redirty_tail(inode, wb);
+		}
+	} else if (inode->i_state & I_DIRTY) {
+		/*
+		 * Filesystems can dirty the inode during writeback operations,
+		 * such as delayed allocation during submission or metadata
+		 * updates after data IO completion.
+		 */
+		redirty_tail(inode, wb);
+	} else {
+		/* The inode is clean. Remove from writeback lists. */
+		list_del_init(&inode->i_wb_list);
+	}
+}
+
+/*
  * Write out an inode's dirty pages.  Called under wb->list_lock and
  * inode->i_lock.  Either the caller has an active reference on the inode or
  * the inode has I_WILL_FREE set.
@@ -422,53 +476,7 @@ writeback_single_inode(struct inode *inode, struct bdi_writeback *wb,
 
 	spin_lock(&wb->list_lock);
 	spin_lock(&inode->i_lock);
-	if (!(inode->i_state & I_FREEING)) {
-		/*
-		 * Sync livelock prevention. Each inode is tagged and synced in
-		 * one shot. If still dirty, it will be redirty_tail()'ed below.
-		 * Update the dirty time to prevent enqueue and sync it again.
-		 */
-		if ((inode->i_state & I_DIRTY) &&
-		    (wbc->sync_mode == WB_SYNC_ALL || wbc->tagged_writepages))
-			inode->dirtied_when = jiffies;
-
-		if (mapping_tagged(mapping, PAGECACHE_TAG_DIRTY)) {
-			/*
-			 * We didn't write back all the pages.  nfs_writepages()
-			 * sometimes bales out without doing anything.
-			 */
-			if (wbc->nr_to_write <= 0) {
-				/*
-				 * slice used up: queue for next turn
-				 */
-				requeue_io(inode, wb);
-			} else {
-				/*
-				 * Writeback blocked by something other than
-				 * congestion. Delay the inode for some time to
-				 * avoid spinning on the CPU (100% iowait)
-				 * retrying writeback of the dirty page/inode
-				 * that cannot be performed immediately.
-				 */
-				redirty_tail(inode, wb);
-			}
-		} else if (inode->i_state & I_DIRTY) {
-			/*
-			 * Filesystems can dirty the inode during writeback
-			 * operations, such as delayed allocation during
-			 * submission or metadata updates after data IO
-			 * completion.
-			 */
-			redirty_tail(inode, wb);
-		} else {
-			/*
-			 * The inode is clean.  At this point we either have
-			 * a reference to the inode or it's on it's way out.
-			 * No need to add it back to the LRU.
-			 */
-			list_del_init(&inode->i_wb_list);
-		}
-	}
+	requeue_inode(inode, wb, wbc);
 	inode_sync_complete(inode);
 	trace_writeback_single_inode(inode, wbc, nr_to_write);
 	return ret;
-- 
1.7.1

