Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934066Ab2JZRz6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 13:55:58 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:49746 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932894Ab2JZRzy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 13:55:54 -0400
From: Yan Hong <clouds.yan@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] debugfs: code clean and refactor
Date: Sat, 27 Oct 2012 01:55:43 +0800
Message-Id: <1351274144-31591-2-git-send-email-clouds.yan@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1351274144-31591-1-git-send-email-clouds.yan@gmail.com>
References: <1351274144-31591-1-git-send-email-clouds.yan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

debug_fill_super():
	return directly if failed to allocate debugfs_fs_info.

__create_file():
	remove redundant initialization.

__debugfs_remove():
	remove redundant check.
	debugfs_positive() already checked dentry->inode is not NULL.

Signed-off-by: Yan Hong <clouds.yan@gmail.com>
---
 fs/debugfs/inode.c |   37 ++++++++++++++++---------------------
 1 file changed, 16 insertions(+), 21 deletions(-)

diff --git a/fs/debugfs/inode.c b/fs/debugfs/inode.c
index b607d92..58eadc1 100644
--- a/fs/debugfs/inode.c
+++ b/fs/debugfs/inode.c
@@ -262,10 +262,8 @@ static int debug_fill_super(struct super_block *sb, void *data, int silent)
 
 	fsi = kzalloc(sizeof(struct debugfs_fs_info), GFP_KERNEL);
 	sb->s_fs_info = fsi;
-	if (!fsi) {
-		err = -ENOMEM;
-		goto fail;
-	}
+	if (!fsi)
+		return -ENOMEM;
 
 	err = debugfs_parse_options(data, &fsi->mount_opts);
 	if (err)
@@ -323,7 +321,6 @@ static struct dentry *__create_file(const char *name, umode_t mode,
 	if (!parent)
 		parent = debugfs_mount->mnt_root;
 
-	dentry = NULL;
 	mutex_lock(&parent->d_inode->i_mutex);
 	dentry = lookup_one_len(name, parent, strlen(name));
 	if (!IS_ERR(dentry)) {
@@ -466,23 +463,21 @@ static int __debugfs_remove(struct dentry *dentry, struct dentry *parent)
 	int ret = 0;
 
 	if (debugfs_positive(dentry)) {
-		if (dentry->d_inode) {
-			dget(dentry);
-			switch (dentry->d_inode->i_mode & S_IFMT) {
-			case S_IFDIR:
-				ret = simple_rmdir(parent->d_inode, dentry);
-				break;
-			case S_IFLNK:
-				kfree(dentry->d_inode->i_private);
-				/* fall through */
-			default:
-				simple_unlink(parent->d_inode, dentry);
-				break;
-			}
-			if (!ret)
-				d_delete(dentry);
-			dput(dentry);
+		dget(dentry);
+		switch (dentry->d_inode->i_mode & S_IFMT) {
+		case S_IFDIR:
+			ret = simple_rmdir(parent->d_inode, dentry);
+			break;
+		case S_IFLNK:
+			kfree(dentry->d_inode->i_private);
+			/* fall through */
+		default:
+			simple_unlink(parent->d_inode, dentry);
+			break;
 		}
+		if (!ret)
+			d_delete(dentry);
+		dput(dentry);
 	}
 	return ret;
 }
-- 
1.7.9.5

