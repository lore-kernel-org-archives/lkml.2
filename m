Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755687Ab2J0IGx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2012 04:06:53 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:53093 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754921Ab2J0IGC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2012 04:06:02 -0400
From: Yan Hong <clouds.yan@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 4/5] debugfs: remove redundant check in __debugfs_remove()
Date: Sat, 27 Oct 2012 16:05:28 +0800
Message-Id: <1351325129-10097-4-git-send-email-clouds.yan@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1351325129-10097-1-git-send-email-clouds.yan@gmail.com>
References: <1351325129-10097-1-git-send-email-clouds.yan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

debugfs_positive() already checked dentry->d_inode is
not NUUL, no need to check it again.

Signed-off-by: Yan Hong <clouds.yan@gmail.com>
---
 fs/debugfs/inode.c |   30 ++++++++++++++----------------
 1 file changed, 14 insertions(+), 16 deletions(-)

diff --git a/fs/debugfs/inode.c b/fs/debugfs/inode.c
index 12f1282..58eadc1 100644
--- a/fs/debugfs/inode.c
+++ b/fs/debugfs/inode.c
@@ -463,23 +463,21 @@ static int __debugfs_remove(struct dentry *dentry, struct dentry *parent)
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

