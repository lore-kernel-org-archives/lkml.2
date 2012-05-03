Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755912Ab2ECMuL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 08:50:11 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34688 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755359Ab2ECMsg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 08:48:36 -0400
From: Jan Kara <jack@suse.cz>
To: linux-fsdevel@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>, Al Viro <viro@ZenIV.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>, dchinner@redhat.com,
        Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>
Subject: [PATCH 9/9] writeback: Avoid iput() from flusher thread
Date: Thu,  3 May 2012 14:48:03 +0200
Message-Id: <1336049283-5859-10-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1336049283-5859-1-git-send-email-jack@suse.cz>
References: <1336049283-5859-1-git-send-email-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Doing iput() from flusher thread (writeback_sb_inodes()) can create problems
because iput() can do a lot of work - for example truncate the inode if it's
the last iput on unlinked file. Some filesystems depend on flusher thread
progressing (e.g. because they need to flush delay allocated blocks to reduce
allocation uncertainty) and so flusher thread doing truncate creates
interesting dependencies and possibilities for deadlocks.

We get rid of iput() in flusher thread by using the fact that I_SYNC inode
flag effectively pins the inode in memory. So if we take care to either hold
i_lock or have I_SYNC set, we can get away without taking inode reference
in writeback_sb_inodes().

As a side effect of these changes, we also fix possible use-after-free in
wb_writeback() because inode_wait_for_writeback() call could try to reacquire
i_lock on the inode that was already free.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/fs-writeback.c         |   66 ++++++++++++++++++++++++++++++++++++---------
 fs/inode.c                |    8 +++++-
 include/linux/fs.h        |    7 +++--
 include/linux/writeback.h |    7 +----
 4 files changed, 65 insertions(+), 23 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 5f2c682..8d2fb8c 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -326,9 +326,12 @@ static int write_inode(struct inode *inode, struct writeback_control *wbc)
 }
 
 /*
- * Wait for writeback on an inode to complete.
+ * Wait for writeback on an inode to complete. Called with i_lock held.
+ * Caller must make sure inode cannot go away when we drop i_lock.
  */
-static void inode_wait_for_writeback(struct inode *inode)
+static void __inode_wait_for_writeback(struct inode *inode)
+	__releases(inode->i_lock)
+	__acquires(inode->i_lock)
 {
 	DEFINE_WAIT_BIT(wq, &inode->i_state, __I_SYNC);
 	wait_queue_head_t *wqh;
@@ -342,6 +345,36 @@ static void inode_wait_for_writeback(struct inode *inode)
 }
 
 /*
+ * Wait for writeback on an inode to complete. Caller must have inode pinned.
+ */
+void inode_wait_for_writeback(struct inode *inode)
+{
+	spin_lock(&inode->i_lock);
+	__inode_wait_for_writeback(inode);
+	spin_unlock(&inode->i_lock);
+}
+
+/*
+ * Sleep until I_SYNC is cleared. This function must be called with i_lock
+ * held and drops it. It is aimed for callers not holding any inode reference
+ * so once i_lock is dropped, inode can go away.
+ */
+static void inode_sleep_on_writeback(struct inode *inode)
+	__releases(inode->i_lock)
+{
+	DEFINE_WAIT(wait);
+	wait_queue_head_t *wqh = bit_waitqueue(&inode->i_state, __I_SYNC);
+	int sleep;
+
+	prepare_to_wait(wqh, &wait, TASK_UNINTERRUPTIBLE);
+	sleep = inode->i_state & I_SYNC;
+	spin_unlock(&inode->i_lock);
+	if (sleep)
+		schedule();
+	finish_wait(wqh, &wait);
+}
+
+/*
  * Find proper writeback list for the inode depending on its current state and
  * possibly also change of its state while we were doing writeback.  Here we
  * handle things such as livelock prevention or fairness of writeback among
@@ -479,9 +512,11 @@ writeback_single_inode(struct inode *inode, struct bdi_writeback *wb,
 		if (wbc->sync_mode != WB_SYNC_ALL)
 			goto out;
 		/*
-		 * It's a data-integrity sync.  We must wait.
+		 * It's a data-integrity sync. We must wait. Since callers hold
+		 * inode reference or inode has I_WILL_FREE set, it cannot go
+		 * away under us.
 		 */
-		inode_wait_for_writeback(inode);
+		__inode_wait_for_writeback(inode);
 	}
 	WARN_ON(inode->i_state & I_SYNC);
 	/*
@@ -620,20 +655,28 @@ static long writeback_sb_inodes(struct super_block *sb,
 		}
 		spin_unlock(&wb->list_lock);
 
-		__iget(inode);
 		/*
 		 * We already requeued the inode if it had I_SYNC set and we
 		 * are doing WB_SYNC_NONE writeback. So this catches only the
 		 * WB_SYNC_ALL case.
 		 */
-		if (inode->i_state & I_SYNC)
-			inode_wait_for_writeback(inode);
+		if (inode->i_state & I_SYNC) {
+			/* Wait for I_SYNC. This function drops i_lock... */
+			inode_sleep_on_writeback(inode);
+			/* Inode may be gone, start again */
+			continue;
+		}
 		inode->i_state |= I_SYNC;
 		spin_unlock(&inode->i_lock);
+
 		write_chunk = writeback_chunk_size(wb->bdi, work);
 		wbc.nr_to_write = write_chunk;
 		wbc.pages_skipped = 0;
 
+		/*
+		 * We use I_SYNC to pin the inode in memory. While it is set
+		 * evict_inode() will wait so the inode cannot be freed.
+		 */
 		__writeback_single_inode(inode, wb, &wbc);
 
 		work->nr_pages -= write_chunk - wbc.nr_to_write;
@@ -645,10 +688,7 @@ static long writeback_sb_inodes(struct super_block *sb,
 		requeue_inode(inode, wb, &wbc);
 		inode_sync_complete(inode);
 		spin_unlock(&inode->i_lock);
-		spin_unlock(&wb->list_lock);
-		iput(inode);
-		cond_resched();
-		spin_lock(&wb->list_lock);
+		cond_resched_lock(&wb->list_lock);
 		/*
 		 * bail out to wb_writeback() often enough to check
 		 * background threshold and other termination conditions.
@@ -843,8 +883,8 @@ static long wb_writeback(struct bdi_writeback *wb,
 			inode = wb_inode(wb->b_more_io.prev);
 			spin_lock(&inode->i_lock);
 			spin_unlock(&wb->list_lock);
-			inode_wait_for_writeback(inode);
-			spin_unlock(&inode->i_lock);
+			/* This function drops i_lock... */
+			inode_sleep_on_writeback(inode);
 			spin_lock(&wb->list_lock);
 		}
 	}
diff --git a/fs/inode.c b/fs/inode.c
index 02c0fa5..f4e1450 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -530,7 +530,13 @@ static void evict(struct inode *inode)
 
 	inode_sb_list_del(inode);
 
-	inode_sync_wait(inode);
+	/*
+	 * Wait for flusher thread to be done with the inode so that filesystem
+	 * does not start destroying it while writeback is still running. Since
+	 * the inode has I_FREEING set, flusher thread won't start new work on
+	 * the inode.  We just have to wait for running writeback to finish.
+	 */
+	inode_wait_for_writeback(inode);
 
 	if (op->evict_inode) {
 		op->evict_inode(inode);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index c79316c..1c71e7f 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1753,9 +1753,10 @@ struct super_operations {
  *			anew.  Other functions will just ignore such inodes,
  *			if appropriate.  I_NEW is used for waiting.
  *
- * I_SYNC		Synchonized write of dirty inode data.  The bits is
- *			set during data writeback, and cleared with a wakeup
- *			on the bit address once it is done.
+ * I_SYNC		Writeback of inode is running. The bit is set during
+ *			data writeback, and cleared with a wakeup on the bit
+ *			address once it is done. The bit is also used to pin
+ *			the inode in memory for flusher thread.
  *
  * I_REFERENCED		Marks the inode as recently references on the LRU list.
  *
diff --git a/include/linux/writeback.h b/include/linux/writeback.h
index a2b84f5..6fd3dfb 100644
--- a/include/linux/writeback.h
+++ b/include/linux/writeback.h
@@ -94,6 +94,7 @@ long writeback_inodes_wb(struct bdi_writeback *wb, long nr_pages,
 				enum wb_reason reason);
 long wb_do_writeback(struct bdi_writeback *wb, int force_wait);
 void wakeup_flusher_threads(long nr_pages, enum wb_reason reason);
+void inode_wait_for_writeback(struct inode *inode);
 
 /* writeback.h requires fs.h; it, too, is not included from here. */
 static inline void wait_on_inode(struct inode *inode)
@@ -101,12 +102,6 @@ static inline void wait_on_inode(struct inode *inode)
 	might_sleep();
 	wait_on_bit(&inode->i_state, __I_NEW, inode_wait, TASK_UNINTERRUPTIBLE);
 }
-static inline void inode_sync_wait(struct inode *inode)
-{
-	might_sleep();
-	wait_on_bit(&inode->i_state, __I_SYNC, inode_wait,
-							TASK_UNINTERRUPTIBLE);
-}
 
 
 /*
-- 
1.7.1

