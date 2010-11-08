Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754010Ab0KHH36 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 02:29:58 -0500
Received: from bld-mail12.adl6.internode.on.net ([150.101.137.97]:59448 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753457Ab0KHH3z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 02:29:55 -0500
From: Dave Chinner <david@fromorbit.com>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        eric.dumazet@gmail.com, paulmck@linux.vnet.ibm.com
Subject: [PATCH 1/4] fs: pull inode->i_lock up out of writeback_single_inode
Date: Mon,  8 Nov 2010 18:28:22 +1100
Message-Id: <1289201305-14866-2-git-send-email-david@fromorbit.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1289201305-14866-1-git-send-email-david@fromorbit.com>
References: <1289201305-14866-1-git-send-email-david@fromorbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

First thing we do in writeback_single_inode() is take the i_lock and
the last thing we do is drop it. A caller already holds the i_lock,
so pull the i_lock out of writeback_single_inode() to reduce the
round trips on this lock during inode writeback.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/fs-writeback.c |   15 ++++++++-------
 1 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 35669f2..567c14c 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -318,9 +318,9 @@ static void inode_wait_for_writeback(struct inode *inode)
 }
 
 /*
- * Write out an inode's dirty pages.  Called under inode_wb_list_lock.  Either
- * the caller has an active reference on the inode or the inode has I_WILL_FREE
- * set.
+ * Write out an inode's dirty pages.  Called under inode_wb_list_lock and
+ * inode->i_lock.  Either the caller has an active reference on the inode or
+ * the inode has I_WILL_FREE set.
  *
  * If `wait' is set, wait on the writeout.
  *
@@ -335,7 +335,6 @@ writeback_single_inode(struct inode *inode, struct writeback_control *wbc)
 	unsigned dirty;
 	int ret;
 
-	spin_lock(&inode->i_lock);
 	if (!atomic_read(&inode->i_count))
 		WARN_ON(!(inode->i_state & (I_WILL_FREE|I_FREEING)));
 	else
@@ -351,7 +350,6 @@ writeback_single_inode(struct inode *inode, struct writeback_control *wbc)
 		 * completed a full scan of b_io.
 		 */
 		if (wbc->sync_mode != WB_SYNC_ALL) {
-			spin_unlock(&inode->i_lock);
 			requeue_io(inode);
 			return 0;
 		}
@@ -442,7 +440,6 @@ writeback_single_inode(struct inode *inode, struct writeback_control *wbc)
 		}
 	}
 	inode_sync_complete(inode);
-	spin_unlock(&inode->i_lock);
 	return ret;
 }
 
@@ -530,7 +527,6 @@ static int writeback_sb_inodes(struct super_block *sb, struct bdi_writeback *wb,
 		}
 
 		__iget(inode);
-		spin_unlock(&inode->i_lock);
 
 		pages_skipped = wbc->pages_skipped;
 		writeback_single_inode(inode, wbc);
@@ -541,6 +537,7 @@ static int writeback_sb_inodes(struct super_block *sb, struct bdi_writeback *wb,
 			 */
 			redirty_tail(inode);
 		}
+		spin_unlock(&inode->i_lock);
 		spin_unlock(&inode_wb_list_lock);
 		iput(inode);
 		cond_resched();
@@ -1212,7 +1209,9 @@ int write_inode_now(struct inode *inode, int sync)
 
 	might_sleep();
 	spin_lock(&inode_wb_list_lock);
+	spin_lock(&inode->i_lock);
 	ret = writeback_single_inode(inode, &wbc);
+	spin_unlock(&inode->i_lock);
 	spin_unlock(&inode_wb_list_lock);
 	if (sync)
 		inode_sync_wait(inode);
@@ -1236,7 +1235,9 @@ int sync_inode(struct inode *inode, struct writeback_control *wbc)
 	int ret;
 
 	spin_lock(&inode_wb_list_lock);
+	spin_lock(&inode->i_lock);
 	ret = writeback_single_inode(inode, wbc);
+	spin_unlock(&inode->i_lock);
 	spin_unlock(&inode_wb_list_lock);
 	return ret;
 }
-- 
1.7.2.3

