Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935259Ab1JER6q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 13:58:46 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35644 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758085Ab1JER6f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 13:58:35 -0400
From: Jan Kara <jack@suse.cz>
To: Christoph Hellwig <hch@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Jan Kara <jack@suse.cz>,
        Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 2/2] writeback: Replace some redirty_tail() calls with requeue_io()
Date: Wed,  5 Oct 2011 19:58:19 +0200
Message-Id: <1317837499-9842-3-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1317837499-9842-1-git-send-email-jack@suse.cz>
References: <1317837499-9842-1-git-send-email-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Calling redirty_tail() can put off inode writeback for upto 30 seconds (or
whatever dirty_expire_centisecs is). This is unnecessarily big delay in some
cases and in other cases it is a really bad thing. In particular XFS tries to
be nice to writeback and when ->write_inode is called for an inode with locked
ilock, it just redirties the inode and returns EAGAIN. That currently causes
writeback_single_inode() to redirty_tail() the inode. As contended ilock is
common thing with XFS while extending files the result can be that inode
writeout is put off for a really long time.

Now that we have more robust busyloop prevention in wb_writeback() we can
call requeue_io() in cases where quick retry is required without fear of
raising CPU consumption too much.

CC: Christoph Hellwig <hch@infradead.org>
Acked-by: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/fs-writeback.c |   61 ++++++++++++++++++++++++----------------------------
 1 files changed, 28 insertions(+), 33 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index bdeb26a..c786023 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -356,6 +356,7 @@ writeback_single_inode(struct inode *inode, struct bdi_writeback *wb,
 	long nr_to_write = wbc->nr_to_write;
 	unsigned dirty;
 	int ret;
+	bool inode_written = false;
 
 	assert_spin_locked(&wb->list_lock);
 	assert_spin_locked(&inode->i_lock);
@@ -420,6 +421,8 @@ writeback_single_inode(struct inode *inode, struct bdi_writeback *wb,
 	/* Don't write the inode if only I_DIRTY_PAGES was set */
 	if (dirty & (I_DIRTY_SYNC | I_DIRTY_DATASYNC)) {
 		int err = write_inode(inode, wbc);
+		if (!err)
+			inode_written = true;
 		if (ret == 0)
 			ret = err;
 	}
@@ -430,42 +433,39 @@ writeback_single_inode(struct inode *inode, struct bdi_writeback *wb,
 	if (!(inode->i_state & I_FREEING)) {
 		/*
 		 * Sync livelock prevention. Each inode is tagged and synced in
-		 * one shot. If still dirty, it will be redirty_tail()'ed below.
-		 * Update the dirty time to prevent enqueue and sync it again.
+		 * one shot. If still dirty, update dirty time and put it back
+		 * to dirty list to prevent enqueue and syncing it again.
 		 */
 		if ((inode->i_state & I_DIRTY) &&
-		    (wbc->sync_mode == WB_SYNC_ALL || wbc->tagged_writepages))
+		    (wbc->sync_mode == WB_SYNC_ALL || wbc->tagged_writepages)) {
 			inode->dirtied_when = jiffies;
-
-		if (mapping_tagged(mapping, PAGECACHE_TAG_DIRTY)) {
+			redirty_tail(inode, wb);
+		} else if (mapping_tagged(mapping, PAGECACHE_TAG_DIRTY)) {
 			/*
-			 * We didn't write back all the pages.  nfs_writepages()
-			 * sometimes bales out without doing anything.
+			 * We didn't write back all the pages. nfs_writepages()
+			 * sometimes bales out without doing anything or we
+			 * just run our of our writeback slice.
 			 */
 			inode->i_state |= I_DIRTY_PAGES;
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
+			requeue_io(inode, wb);
 		} else if (inode->i_state & I_DIRTY) {
 			/*
 			 * Filesystems can dirty the inode during writeback
 			 * operations, such as delayed allocation during
 			 * submission or metadata updates after data IO
-			 * completion.
+			 * completion. Also inode could have been dirtied by
+			 * some process aggressively touching metadata.
+			 * Finally, filesystem could just fail to write the
+			 * inode for some reason. We have to distinguish the
+			 * last case from the previous ones - in the last case
+			 * we want to give the inode quick retry, in the
+			 * other cases we want to put it back to the dirty list
+			 * to avoid livelocking of writeback.
 			 */
-			redirty_tail(inode, wb);
+			if (inode_written)
+				redirty_tail(inode, wb);
+			else
+				requeue_io(inode, wb);
 		} else {
 			/*
 			 * The inode is clean.  At this point we either have
@@ -583,10 +583,10 @@ static long writeback_sb_inodes(struct super_block *sb,
 			wrote++;
 		if (wbc.pages_skipped) {
 			/*
-			 * writeback is not making progress due to locked
-			 * buffers.  Skip this inode for now.
+			 * Writeback is not making progress due to unavailable
+			 * fs locks or similar condition. Retry in next round.
 			 */
-			redirty_tail(inode, wb);
+			requeue_io(inode, wb);
 		}
 		spin_unlock(&inode->i_lock);
 		spin_unlock(&wb->list_lock);
@@ -618,12 +618,7 @@ static long __writeback_inodes_wb(struct bdi_writeback *wb,
 		struct super_block *sb = inode->i_sb;
 
 		if (!grab_super_passive(sb)) {
-			/*
-			 * grab_super_passive() may fail consistently due to
-			 * s_umount being grabbed by someone else. Don't use
-			 * requeue_io() to avoid busy retrying the inode/sb.
-			 */
-			redirty_tail(inode, wb);
+			requeue_io(inode, wb);
 			continue;
 		}
 		wrote += writeback_sb_inodes(sb, wb, work);
-- 
1.7.1

