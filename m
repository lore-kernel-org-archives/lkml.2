Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755979Ab2ECMuN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 08:50:13 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34685 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754357Ab2ECMsg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 08:48:36 -0400
From: Jan Kara <jack@suse.cz>
To: linux-fsdevel@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>, Al Viro <viro@ZenIV.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>, dchinner@redhat.com,
        Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>
Subject: [PATCH 6/9] writeback: Refactor writeback_single_inode()
Date: Thu,  3 May 2012 14:48:00 +0200
Message-Id: <1336049283-5859-7-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1336049283-5859-1-git-send-email-jack@suse.cz>
References: <1336049283-5859-1-git-send-email-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The code in writeback_single_inode() is relatively complex. The list requeing
logic makes sense only for flusher thread but not really for sync_inode() or
write_inode_now() callers. Also when we want to get rid of inode references
held by flusher thread, we will need a special I_SYNC handling there.

So separate part of writeback_single_inode() which does the real writeback work
into __writeback_single_inode() and make writeback_single_inode() do only stuff
necessary for callers writing only one inode, moving the special list handling
into writeback_sb_inodes(). As a sideeffect this fixes a possible race where we
could skip some inode during sync(2) because other writer refiled it from b_io
to b_dirty list. Also I_SYNC handling is moved into the callers of
__writeback_single_inode() to make locking easier.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/fs-writeback.c |  142 ++++++++++++++++++++++++++++++++---------------------
 1 files changed, 86 insertions(+), 56 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 3b87dc8..5f2c682 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -364,6 +364,15 @@ static void requeue_inode(struct inode *inode, struct bdi_writeback *wb,
 	    (wbc->sync_mode == WB_SYNC_ALL || wbc->tagged_writepages))
 		inode->dirtied_when = jiffies;
 
+	if (wbc->pages_skipped) {
+		/*
+		 * writeback is not making progress due to locked
+		 * buffers. Skip this inode for now.
+		 */
+		redirty_tail(inode, wb);
+		return;
+	}
+
 	if (mapping_tagged(inode->i_mapping, PAGECACHE_TAG_DIRTY)) {
 		/*
 		 * We didn't write back all the pages.  nfs_writepages()
@@ -396,46 +405,20 @@ static void requeue_inode(struct inode *inode, struct bdi_writeback *wb,
 }
 
 /*
- * Write out an inode's dirty pages.  Called under wb->list_lock and
- * inode->i_lock.  Either the caller has an active reference on the inode or
- * the inode has I_WILL_FREE set.
- *
- * If `wait' is set, wait on the writeout.
- *
- * The whole writeout design is quite complex and fragile.  We want to avoid
- * starvation of particular inodes when others are being redirtied, prevent
- * livelocks, etc.
+ * Write out an inode and its dirty pages. Do not update the writeback list
+ * linkage. That is left to the caller. The caller is also responsible for
+ * setting I_SYNC flag and calling inode_sync_complete() to clear it.
  */
 static int
-writeback_single_inode(struct inode *inode, struct bdi_writeback *wb,
-		       struct writeback_control *wbc)
+__writeback_single_inode(struct inode *inode, struct bdi_writeback *wb,
+			 struct writeback_control *wbc)
 {
 	struct address_space *mapping = inode->i_mapping;
 	long nr_to_write = wbc->nr_to_write;
 	unsigned dirty;
 	int ret;
 
-	assert_spin_locked(&inode->i_lock);
-
-	if (!atomic_read(&inode->i_count))
-		WARN_ON(!(inode->i_state & (I_WILL_FREE|I_FREEING)));
-	else
-		WARN_ON(inode->i_state & I_WILL_FREE);
-
-	if (inode->i_state & I_SYNC) {
-		if (wbc->sync_mode != WB_SYNC_ALL)
-			return 0;
-		/*
-		 * It's a data-integrity sync.  We must wait.
-		 */
-		inode_wait_for_writeback(inode);
-	}
-
-	BUG_ON(inode->i_state & I_SYNC);
-
-	/* Set I_SYNC, reset I_DIRTY_PAGES */
-	inode->i_state |= I_SYNC;
-	spin_unlock(&inode->i_lock);
+	WARN_ON(!(inode->i_state & I_SYNC));
 
 	ret = do_writepages(mapping, wbc);
 
@@ -468,12 +451,65 @@ writeback_single_inode(struct inode *inode, struct bdi_writeback *wb,
 		if (ret == 0)
 			ret = err;
 	}
+	trace_writeback_single_inode(inode, wbc, nr_to_write);
+	return ret;
+}
+
+/*
+ * Write out an inode's dirty pages. Either the caller has an active reference
+ * on the inode or the inode has I_WILL_FREE set.
+ *
+ * This function is designed to be called for writing back one inode which
+ * we go e.g. from filesystem. Flusher thread uses __writeback_single_inode()
+ * and does more profound writeback list handling in writeback_sb_inodes().
+ */
+static int
+writeback_single_inode(struct inode *inode, struct bdi_writeback *wb,
+		       struct writeback_control *wbc)
+{
+	int ret = 0;
+
+	spin_lock(&inode->i_lock);
+	if (!atomic_read(&inode->i_count))
+		WARN_ON(!(inode->i_state & (I_WILL_FREE|I_FREEING)));
+	else
+		WARN_ON(inode->i_state & I_WILL_FREE);
+
+	if (inode->i_state & I_SYNC) {
+		if (wbc->sync_mode != WB_SYNC_ALL)
+			goto out;
+		/*
+		 * It's a data-integrity sync.  We must wait.
+		 */
+		inode_wait_for_writeback(inode);
+	}
+	WARN_ON(inode->i_state & I_SYNC);
+	/*
+	 * Skip inode if it is clean. We don't want to mess with writeback
+	 * lists in this function since flusher thread may be doing for example
+	 * sync in parallel and if we move the inode, it could get skipped. So
+	 * here we make sure inode is on some writeback list and leave it there
+	 * unless we have completely cleaned the inode.
+	 */
+	if (!(inode->i_state & I_DIRTY))
+		goto out;
+	inode->i_state |= I_SYNC;
+	spin_unlock(&inode->i_lock);
+
+	ret = __writeback_single_inode(inode, wb, wbc);
 
 	spin_lock(&wb->list_lock);
 	spin_lock(&inode->i_lock);
-	requeue_inode(inode, wb, wbc);
+	/*
+	 * If inode is clean, remove it from writeback lists. Otherwise don't
+	 * touch it. See comment above for explanation.
+	 */
+	if (!(inode->i_state & I_DIRTY))
+		list_del_init(&inode->i_wb_list);
+	spin_unlock(&wb->list_lock);
 	inode_sync_complete(inode);
-	trace_writeback_single_inode(inode, wbc, nr_to_write);
+out:
+	spin_unlock(&inode->i_lock);
 	return ret;
 }
 
@@ -585,23 +621,29 @@ static long writeback_sb_inodes(struct super_block *sb,
 		spin_unlock(&wb->list_lock);
 
 		__iget(inode);
+		/*
+		 * We already requeued the inode if it had I_SYNC set and we
+		 * are doing WB_SYNC_NONE writeback. So this catches only the
+		 * WB_SYNC_ALL case.
+		 */
+		if (inode->i_state & I_SYNC)
+			inode_wait_for_writeback(inode);
+		inode->i_state |= I_SYNC;
+		spin_unlock(&inode->i_lock);
 		write_chunk = writeback_chunk_size(wb->bdi, work);
 		wbc.nr_to_write = write_chunk;
 		wbc.pages_skipped = 0;
 
-		writeback_single_inode(inode, wb, &wbc);
+		__writeback_single_inode(inode, wb, &wbc);
 
 		work->nr_pages -= write_chunk - wbc.nr_to_write;
 		wrote += write_chunk - wbc.nr_to_write;
+		spin_lock(&wb->list_lock);
+		spin_lock(&inode->i_lock);
 		if (!(inode->i_state & I_DIRTY))
 			wrote++;
-		if (wbc.pages_skipped) {
-			/*
-			 * writeback is not making progress due to locked
-			 * buffers.  Skip this inode for now.
-			 */
-			redirty_tail(inode, wb);
-		}
+		requeue_inode(inode, wb, &wbc);
+		inode_sync_complete(inode);
 		spin_unlock(&inode->i_lock);
 		spin_unlock(&wb->list_lock);
 		iput(inode);
@@ -1337,7 +1379,6 @@ EXPORT_SYMBOL(sync_inodes_sb);
 int write_inode_now(struct inode *inode, int sync)
 {
 	struct bdi_writeback *wb = &inode_to_bdi(inode)->wb;
-	int ret;
 	struct writeback_control wbc = {
 		.nr_to_write = LONG_MAX,
 		.sync_mode = sync ? WB_SYNC_ALL : WB_SYNC_NONE,
@@ -1349,11 +1390,7 @@ int write_inode_now(struct inode *inode, int sync)
 		wbc.nr_to_write = 0;
 
 	might_sleep();
-	spin_lock(&inode->i_lock);
-	ret = writeback_single_inode(inode, wb, &wbc);
-	spin_unlock(&inode->i_lock);
-	spin_unlock(&wb->list_lock);
-	return ret;
+	return writeback_single_inode(inode, wb, &wbc);
 }
 EXPORT_SYMBOL(write_inode_now);
 
@@ -1370,14 +1407,7 @@ EXPORT_SYMBOL(write_inode_now);
  */
 int sync_inode(struct inode *inode, struct writeback_control *wbc)
 {
-	struct bdi_writeback *wb = &inode_to_bdi(inode)->wb;
-	int ret;
-
-	spin_lock(&inode->i_lock);
-	ret = writeback_single_inode(inode, wb, wbc);
-	spin_unlock(&inode->i_lock);
-	spin_unlock(&wb->list_lock);
-	return ret;
+	return writeback_single_inode(inode, &inode_to_bdi(inode)->wb, wbc);
 }
 EXPORT_SYMBOL(sync_inode);
 
-- 
1.7.1

