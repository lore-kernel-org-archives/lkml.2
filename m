Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755704Ab2ECMsm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 08:48:42 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34669 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755342Ab2ECMse (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 08:48:34 -0400
From: Jan Kara <jack@suse.cz>
To: linux-fsdevel@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>, Al Viro <viro@ZenIV.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>, dchinner@redhat.com,
        Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>
Subject: [PATCH 5/9] writeback: Remove wb->list_lock from writeback_single_inode()
Date: Thu,  3 May 2012 14:47:59 +0200
Message-Id: <1336049283-5859-6-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1336049283-5859-1-git-send-email-jack@suse.cz>
References: <1336049283-5859-1-git-send-email-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

writeback_single_inode() doesn't need wb->list_lock for anything on entry now.
So remove the requirement. This makes locking of writeback_single_inode()
temporarily awkward (entering with i_lock, returning with i_lock and
wb->list_lock) but it will be sanitized in the next patch.

Also inode_wait_for_writeback() doesn't need wb->list_lock for anything. It was
just taking it to make usage convenient for callers but with
writeback_single_inode() changing it's not very convenient anymore. So remove
the lock from that function.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/fs-writeback.c |   17 +++++++----------
 1 files changed, 7 insertions(+), 10 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 5d3de00..3b87dc8 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -328,8 +328,7 @@ static int write_inode(struct inode *inode, struct writeback_control *wbc)
 /*
  * Wait for writeback on an inode to complete.
  */
-static void inode_wait_for_writeback(struct inode *inode,
-				     struct bdi_writeback *wb)
+static void inode_wait_for_writeback(struct inode *inode)
 {
 	DEFINE_WAIT_BIT(wq, &inode->i_state, __I_SYNC);
 	wait_queue_head_t *wqh;
@@ -337,9 +336,7 @@ static void inode_wait_for_writeback(struct inode *inode,
 	wqh = bit_waitqueue(&inode->i_state, __I_SYNC);
 	while (inode->i_state & I_SYNC) {
 		spin_unlock(&inode->i_lock);
-		spin_unlock(&wb->list_lock);
 		__wait_on_bit(wqh, &wq, inode_wait, TASK_UNINTERRUPTIBLE);
-		spin_lock(&wb->list_lock);
 		spin_lock(&inode->i_lock);
 	}
 }
@@ -418,7 +415,6 @@ writeback_single_inode(struct inode *inode, struct bdi_writeback *wb,
 	unsigned dirty;
 	int ret;
 
-	assert_spin_locked(&wb->list_lock);
 	assert_spin_locked(&inode->i_lock);
 
 	if (!atomic_read(&inode->i_count))
@@ -432,7 +428,7 @@ writeback_single_inode(struct inode *inode, struct bdi_writeback *wb,
 		/*
 		 * It's a data-integrity sync.  We must wait.
 		 */
-		inode_wait_for_writeback(inode, wb);
+		inode_wait_for_writeback(inode);
 	}
 
 	BUG_ON(inode->i_state & I_SYNC);
@@ -440,7 +436,6 @@ writeback_single_inode(struct inode *inode, struct bdi_writeback *wb,
 	/* Set I_SYNC, reset I_DIRTY_PAGES */
 	inode->i_state |= I_SYNC;
 	spin_unlock(&inode->i_lock);
-	spin_unlock(&wb->list_lock);
 
 	ret = do_writepages(mapping, wbc);
 
@@ -587,6 +582,8 @@ static long writeback_sb_inodes(struct super_block *sb,
 			trace_writeback_sb_inodes_requeue(inode);
 			continue;
 		}
+		spin_unlock(&wb->list_lock);
+
 		__iget(inode);
 		write_chunk = writeback_chunk_size(wb->bdi, work);
 		wbc.nr_to_write = write_chunk;
@@ -803,8 +800,10 @@ static long wb_writeback(struct bdi_writeback *wb,
 			trace_writeback_wait(wb->bdi, work);
 			inode = wb_inode(wb->b_more_io.prev);
 			spin_lock(&inode->i_lock);
-			inode_wait_for_writeback(inode, wb);
+			spin_unlock(&wb->list_lock);
+			inode_wait_for_writeback(inode);
 			spin_unlock(&inode->i_lock);
+			spin_lock(&wb->list_lock);
 		}
 	}
 	spin_unlock(&wb->list_lock);
@@ -1350,7 +1349,6 @@ int write_inode_now(struct inode *inode, int sync)
 		wbc.nr_to_write = 0;
 
 	might_sleep();
-	spin_lock(&wb->list_lock);
 	spin_lock(&inode->i_lock);
 	ret = writeback_single_inode(inode, wb, &wbc);
 	spin_unlock(&inode->i_lock);
@@ -1375,7 +1373,6 @@ int sync_inode(struct inode *inode, struct writeback_control *wbc)
 	struct bdi_writeback *wb = &inode_to_bdi(inode)->wb;
 	int ret;
 
-	spin_lock(&wb->list_lock);
 	spin_lock(&inode->i_lock);
 	ret = writeback_single_inode(inode, wb, wbc);
 	spin_unlock(&inode->i_lock);
-- 
1.7.1

