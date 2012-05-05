Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756900Ab2EEPa0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2012 11:30:26 -0400
Received: from sh.osrg.net ([192.16.179.4]:54302 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756141Ab2EEPaZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2012 11:30:25 -0400
Date: Sun, 06 May 2012 00:30:19 +0900 (JST)
Message-Id: <20120506.003019.194237212.konishi.ryusuke@lab.ntt.co.jp>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-nilfs@vger.kernel.org
Subject: [PATCH] nilfs2: flush disk caches in syncing
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
X-Mailer: Mew version 5.2 on Emacs 22.2 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.3.7 (sh.osrg.net [192.16.179.4]); Sun, 06 May 2012 00:30:19 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

Could you please queue the following patch in the -mm tree ?

I hope this will be sent to upstream at the next merge window through
your tree. (probably only this single change).

Thanks,
Ryusuke Konishi
--
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>

There are two cases that the cache flush is needed to avoid data loss
against unexpected hang or power failure.  One is sync file function
(i.e. nilfs_sync_file) and another is checkpointing ioctl.

This issues a cache flush request to device for such cases if barrier
mount option is enabled, and makes sure data really is on persistent
storage on their completion.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
---
 fs/nilfs2/file.c  |   24 ++++++++++++++----------
 fs/nilfs2/ioctl.c |    8 +++++++-
 2 files changed, 21 insertions(+), 11 deletions(-)

diff --git a/fs/nilfs2/file.c b/fs/nilfs2/file.c
index 2660152..62cebc8 100644
--- a/fs/nilfs2/file.c
+++ b/fs/nilfs2/file.c
@@ -37,6 +37,7 @@ int nilfs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 	 * This function should be implemented when the writeback function
 	 * will be implemented.
 	 */
+	struct the_nilfs *nilfs;
 	struct inode *inode = file->f_mapping->host;
 	int err;
 
@@ -45,18 +46,21 @@ int nilfs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 		return err;
 	mutex_lock(&inode->i_mutex);
 
-	if (!nilfs_inode_dirty(inode)) {
-		mutex_unlock(&inode->i_mutex);
-		return 0;
+	if (nilfs_inode_dirty(inode)) {
+		if (datasync)
+			err = nilfs_construct_dsync_segment(inode->i_sb, inode,
+							    0, LLONG_MAX);
+		else
+			err = nilfs_construct_segment(inode->i_sb);
 	}
-
-	if (datasync)
-		err = nilfs_construct_dsync_segment(inode->i_sb, inode, 0,
-						    LLONG_MAX);
-	else
-		err = nilfs_construct_segment(inode->i_sb);
-
 	mutex_unlock(&inode->i_mutex);
+
+	nilfs = inode->i_sb->s_fs_info;
+	if (!err && nilfs_test_opt(nilfs, BARRIER)) {
+		err = blkdev_issue_flush(inode->i_sb->s_bdev, GFP_KERNEL, NULL);
+		if (err != -EIO)
+			err = 0;
+	}
 	return err;
 }
 
diff --git a/fs/nilfs2/ioctl.c b/fs/nilfs2/ioctl.c
index 2a70fce..06658ca 100644
--- a/fs/nilfs2/ioctl.c
+++ b/fs/nilfs2/ioctl.c
@@ -692,8 +692,14 @@ static int nilfs_ioctl_sync(struct inode *inode, struct file *filp,
 	if (ret < 0)
 		return ret;
 
+	nilfs = inode->i_sb->s_fs_info;
+	if (nilfs_test_opt(nilfs, BARRIER)) {
+		ret = blkdev_issue_flush(inode->i_sb->s_bdev, GFP_KERNEL, NULL);
+		if (ret == -EIO)
+			return ret;
+	}
+
 	if (argp != NULL) {
-		nilfs = inode->i_sb->s_fs_info;
 		down_read(&nilfs->ns_segctor_sem);
 		cno = nilfs->ns_cno - 1;
 		up_read(&nilfs->ns_segctor_sem);
-- 
1.7.9.3

