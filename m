Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755579Ab1CVLYZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 07:24:25 -0400
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:23856 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755430Ab1CVLXs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 07:23:48 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApQGAK8jiE15LK5JgWdsb2JhbACYRIx/FQEBFiYlxBSFZASSZw
From: Dave Chinner <david@fromorbit.com>
To: viro@ZenIV.linux.org.uk
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH 8/8] fs: pull inode->i_lock up out of writeback_single_inode
Date: Tue, 22 Mar 2011 22:23:43 +1100
Message-Id: <1300793023-3775-9-git-send-email-david@fromorbit.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1300793023-3775-1-git-send-email-david@fromorbit.com>
References: <1300793023-3775-1-git-send-email-david@fromorbit.com>
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
 fs/fs-writeback.c |   18 +++++++++++-------
 1 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index ed80065..b5ed541 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -332,9 +332,9 @@ static void inode_wait_for_writeback(struct inode *inode)
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
@@ -349,7 +349,9 @@ writeback_single_inode(struct inode *inode, struct writeback_control *wbc)
 	unsigned dirty;
 	int ret;
 
-	spin_lock(&inode->i_lock);
+	assert_spin_locked(&inode_wb_list_lock);
+	assert_spin_locked(&inode->i_lock);
+
 	if (!atomic_read(&inode->i_count))
 		WARN_ON(!(inode->i_state & (I_WILL_FREE|I_FREEING)));
 	else
@@ -365,7 +367,6 @@ writeback_single_inode(struct inode *inode, struct writeback_control *wbc)
 		 * completed a full scan of b_io.
 		 */
 		if (wbc->sync_mode != WB_SYNC_ALL) {
-			spin_unlock(&inode->i_lock);
 			requeue_io(inode);
 			return 0;
 		}
@@ -456,7 +457,6 @@ writeback_single_inode(struct inode *inode, struct writeback_control *wbc)
 		}
 	}
 	inode_sync_complete(inode);
-	spin_unlock(&inode->i_lock);
 	return ret;
 }
 
@@ -544,7 +544,6 @@ static int writeback_sb_inodes(struct super_block *sb, struct bdi_writeback *wb,
 		}
 
 		__iget(inode);
-		spin_unlock(&inode->i_lock);
 
 		pages_skipped = wbc->pages_skipped;
 		writeback_single_inode(inode, wbc);
@@ -555,6 +554,7 @@ static int writeback_sb_inodes(struct super_block *sb, struct bdi_writeback *wb,
 			 */
 			redirty_tail(inode);
 		}
+		spin_unlock(&inode->i_lock);
 		spin_unlock(&inode_wb_list_lock);
 		iput(inode);
 		cond_resched();
@@ -1309,7 +1309,9 @@ int write_inode_now(struct inode *inode, int sync)
 
 	might_sleep();
 	spin_lock(&inode_wb_list_lock);
+	spin_lock(&inode->i_lock);
 	ret = writeback_single_inode(inode, &wbc);
+	spin_unlock(&inode->i_lock);
 	spin_unlock(&inode_wb_list_lock);
 	if (sync)
 		inode_sync_wait(inode);
@@ -1333,7 +1335,9 @@ int sync_inode(struct inode *inode, struct writeback_control *wbc)
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

