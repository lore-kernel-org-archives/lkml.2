Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754884Ab0KWONL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 09:13:11 -0500
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:21941 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751721Ab0KWOLu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 09:11:50 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AsoJAMpZ60x5LdQd/2dsb2JhbACVY40Acr1HgnWCVgSKXg
Message-Id: <20101123140707.846551304@kernel.dk>
User-Agent: quilt/0.48-1
Date: Wed, 24 Nov 2010 01:06:13 +1100
From: npiggin@kernel.dk
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [patch 3/7] fs: introduce inode writeback helpers
References: <20101123140610.292941494@kernel.dk>
Content-Disposition: inline; filename=fs-inode-clear-dirty-for-io.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Inode dirty state cannot be securely tested without participating properly
in the inode writeback protocol. Some filesystems need to check this state,
so break out the code into helpers and make them available.

This could also be used to reduce strange interactions between background
writeback and fsync. Currently if we fsync a single page in a file, the
entire file gets requeued to the back of the background IO list, even if
it is due for writeout and has a large number of pages. That's left for
a later time.

Signed-off-by: Nick Piggin <npiggin@kernel.dk>

Index: linux-2.6/fs/fs-writeback.c
===================================================================
--- linux-2.6.orig/fs/fs-writeback.c	2010-11-23 21:51:20.000000000 +1100
+++ linux-2.6/fs/fs-writeback.c	2010-11-23 22:05:00.000000000 +1100
@@ -299,6 +299,102 @@ static void inode_wait_for_writeback(str
 	}
 }
 
+/**
+ * inode_writeback_begin -- prepare to writeback an inode
+ * @indoe: inode to write back
+ * @wait: synch writeout or not
+ * @Returns: 0 if wait == 0 and this call would block (due to other writeback).
+ *           otherwise returns 1.
+ *
+ * Context: inode_lock must be held, may be dropped. Returns with it held.
+ *
+ * inode_writeback_begin sets up an inode to be written back (data and/or
+ * metadata). This must be called before examining I_DIRTY state of the
+ * inode, and should be called at least before any data integrity writeout.
+ *
+ * If inode_writeback_begin returns 1, it must be followed by a call to
+ * inode_writeback_end.
+ */
+int inode_writeback_begin(struct inode *inode, int wait)
+{
+	assert_spin_locked(&inode_lock);
+	if (!atomic_read(&inode->i_count))
+		WARN_ON(!(inode->i_state & (I_WILL_FREE|I_FREEING)));
+	else
+		WARN_ON(inode->i_state & I_WILL_FREE);
+
+	if (inode->i_state & I_SYNC) {
+		/*
+		 * If this inode is locked for writeback and we are not doing
+		 * writeback-for-data-integrity, skip it.
+		 */
+		if (!wait)
+			return 0;
+
+		/*
+		 * It's a data-integrity sync.  We must wait.
+		 */
+		inode_wait_for_writeback(inode);
+	}
+
+	BUG_ON(inode->i_state & I_SYNC);
+
+	inode->i_state |= I_SYNC;
+	inode->i_state &= ~I_DIRTY;
+
+	return 1;
+}
+EXPORT_SYMBOL(inode_writeback_begin);
+
+/**
+ * inode_writeback_end - end a writeback section opened by inode_writeback_begin
+ * @inode: inode in question
+ * @Returns: 0 if the inode still has dirty pagecache, otherwise 1.
+ *
+ * Context: inode_lock must be held, not dropped.
+ *
+ * inode_writeback_end must follow a successful call to inode_writeback_begin
+ * after we have finished submitting writeback to the inode.
+ */
+int inode_writeback_end(struct inode *inode)
+{
+	int ret = 1;
+
+	assert_spin_locked(&inode_lock);
+	BUG_ON(!(inode->i_state & I_SYNC));
+
+	if (!(inode->i_state & I_FREEING)) {
+		if (mapping_tagged(inode->i_mapping, PAGECACHE_TAG_DIRTY)) {
+			/*
+			 * We didn't write back all the pages.  nfs_writepages()
+			 * sometimes bales out without doing anything.
+			 */
+			inode->i_state |= I_DIRTY_PAGES;
+			ret = 0;
+		} else if (inode->i_state & I_DIRTY) {
+			/*
+			 * Filesystems can dirty the inode during writeback
+			 * operations, such as delayed allocation during
+			 * submission or metadata updates after data IO
+			 * completion.
+			 */
+			redirty_tail(inode);
+		} else {
+			/*
+			 * The inode is clean.  At this point we either have
+			 * a reference to the inode or it's on it's way out.
+			 * No need to add it back to the LRU.
+			 */
+			list_del_init(&inode->i_wb_list);
+		}
+	}
+	inode->i_state &= ~I_SYNC;
+	inode_sync_complete(inode);
+
+	return ret;
+}
+EXPORT_SYMBOL(inode_writeback_end);
+
 /*
  * Write out an inode's dirty pages.  Called under inode_lock.  Either the
  * caller has ref on the inode (either via __iget or via syscall against an fd)
@@ -319,36 +415,15 @@ writeback_single_inode(struct inode *ino
 	unsigned dirty;
 	int ret;
 
-	if (!atomic_read(&inode->i_count))
-		WARN_ON(!(inode->i_state & (I_WILL_FREE|I_FREEING)));
-	else
-		WARN_ON(inode->i_state & I_WILL_FREE);
-
-	if (inode->i_state & I_SYNC) {
+	if (!inode_writeback_begin(inode, wbc->sync_mode == WB_SYNC_ALL)) {
 		/*
-		 * If this inode is locked for writeback and we are not doing
-		 * writeback-for-data-integrity, move it to b_more_io so that
-		 * writeback can proceed with the other inodes on s_io.
-		 *
 		 * We'll have another go at writing back this inode when we
 		 * completed a full scan of b_io.
 		 */
-		if (wbc->sync_mode != WB_SYNC_ALL) {
-			requeue_io(inode);
-			return 0;
-		}
-
-		/*
-		 * It's a data-integrity sync.  We must wait.
-		 */
-		inode_wait_for_writeback(inode);
+		requeue_io(inode);
+		return 0;
 	}
 
-	BUG_ON(inode->i_state & I_SYNC);
-
-	/* Set I_SYNC, reset I_DIRTY_PAGES */
-	inode->i_state |= I_SYNC;
-	inode->i_state &= ~I_DIRTY_PAGES;
 	spin_unlock(&inode_lock);
 
 	ret = do_writepages(mapping, wbc);
@@ -381,47 +456,24 @@ writeback_single_inode(struct inode *ino
 	}
 
 	spin_lock(&inode_lock);
-	inode->i_state &= ~I_SYNC;
-	if (!(inode->i_state & I_FREEING)) {
-		if (mapping_tagged(mapping, PAGECACHE_TAG_DIRTY)) {
+	if (!inode_writeback_end(inode)) {
+		if (wbc->nr_to_write <= 0) {
 			/*
-			 * We didn't write back all the pages.  nfs_writepages()
-			 * sometimes bales out without doing anything.
+			 * slice used up: queue for next turn
 			 */
-			inode->i_state |= I_DIRTY_PAGES;
-			if (wbc->nr_to_write <= 0) {
-				/*
-				 * slice used up: queue for next turn
-				 */
-				requeue_io(inode);
-			} else {
-				/*
-				 * Writeback blocked by something other than
-				 * congestion. Delay the inode for some time to
-				 * avoid spinning on the CPU (100% iowait)
-				 * retrying writeback of the dirty page/inode
-				 * that cannot be performed immediately.
-				 */
-				redirty_tail(inode);
-			}
-		} else if (inode->i_state & I_DIRTY) {
-			/*
-			 * Filesystems can dirty the inode during writeback
-			 * operations, such as delayed allocation during
-			 * submission or metadata updates after data IO
-			 * completion.
-			 */
-			redirty_tail(inode);
+			requeue_io(inode);
 		} else {
 			/*
-			 * The inode is clean.  At this point we either have
-			 * a reference to the inode or it's on it's way out.
-			 * No need to add it back to the LRU.
+			 * Writeback blocked by something other than
+			 * congestion. Delay the inode for some time to
+			 * avoid spinning on the CPU (100% iowait)
+			 * retrying writeback of the dirty page/inode
+			 * that cannot be performed immediately.
 			 */
-			list_del_init(&inode->i_wb_list);
+			redirty_tail(inode);
 		}
 	}
-	inode_sync_complete(inode);
+
 	return ret;
 }
 
Index: linux-2.6/include/linux/fs.h
===================================================================
--- linux-2.6.orig/include/linux/fs.h	2010-11-23 22:04:18.000000000 +1100
+++ linux-2.6/include/linux/fs.h	2010-11-23 22:04:44.000000000 +1100
@@ -1765,6 +1765,8 @@ static inline void file_accessed(struct
 
 int sync_inode(struct inode *inode, struct writeback_control *wbc);
 int sync_inode_metadata(struct inode *inode, int wait);
+int inode_writeback_begin(struct inode *inode, int wait);
+int inode_writeback_end(struct inode *inode);
 
 struct file_system_type {
 	const char *name;


