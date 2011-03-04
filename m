Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760018Ab1CDROv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 12:14:51 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:39221 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759993Ab1CDROi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 12:14:38 -0500
Date: Fri, 4 Mar 2011 17:14:37 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: chris.mason@oracle.com
Cc: linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: [PATCH 1/2] btrfs: don't mess with i_nlink of unlocked inode in
 rename()
Message-ID: <20110304171437.GA26708@ZenIV.linux.org.uk>
References: <20110304171353.GU22723@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110304171353.GU22723@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

old_inode is not locked; it's not safe to play with its link
count.  Instead of bumping it and calling btrfs_unlink_inode(),
add a variant of the latter that does not do btrfs_drop_nlink()/
btrfs_update_inode(), call it instead of btrfs_inc_nlink()/
btrfs_unlink_inode() and do btrfs_update_inode() ourselves.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/btrfs/inode.c |   36 +++++++++++++++++++++++++-----------
 1 files changed, 25 insertions(+), 11 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 0efdb65..099d64c 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2634,10 +2634,10 @@ failed:
  * recovery code.  It remove a link in a directory with a given name, and
  * also drops the back refs in the inode to the directory
  */
-int btrfs_unlink_inode(struct btrfs_trans_handle *trans,
-		       struct btrfs_root *root,
-		       struct inode *dir, struct inode *inode,
-		       const char *name, int name_len)
+static int __btrfs_unlink_inode(struct btrfs_trans_handle *trans,
+				struct btrfs_root *root,
+				struct inode *dir, struct inode *inode,
+				const char *name, int name_len)
 {
 	struct btrfs_path *path;
 	int ret = 0;
@@ -2709,12 +2709,25 @@ err:
 	btrfs_i_size_write(dir, dir->i_size - name_len * 2);
 	inode->i_ctime = dir->i_mtime = dir->i_ctime = CURRENT_TIME;
 	btrfs_update_inode(trans, root, dir);
-	btrfs_drop_nlink(inode);
-	ret = btrfs_update_inode(trans, root, inode);
 out:
 	return ret;
 }
 
+int btrfs_unlink_inode(struct btrfs_trans_handle *trans,
+		       struct btrfs_root *root,
+		       struct inode *dir, struct inode *inode,
+		       const char *name, int name_len)
+{
+	int ret;
+	ret = __btrfs_unlink_inode(trans, root, dir, inode, name, name_len);
+	if (!ret) {
+		btrfs_drop_nlink(inode);
+		ret = btrfs_update_inode(trans, root, inode);
+	}
+	return ret;
+}
+		
+
 /* helper to check if there is any shared block in the path */
 static int check_path_shared(struct btrfs_root *root,
 			     struct btrfs_path *path)
@@ -6908,11 +6921,12 @@ static int btrfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 					old_dentry->d_name.name,
 					old_dentry->d_name.len);
 	} else {
-		btrfs_inc_nlink(old_dentry->d_inode);
-		ret = btrfs_unlink_inode(trans, root, old_dir,
-					 old_dentry->d_inode,
-					 old_dentry->d_name.name,
-					 old_dentry->d_name.len);
+		ret = __btrfs_unlink_inode(trans, root, old_dir,
+					old_dentry->d_inode,
+					old_dentry->d_name.name,
+					old_dentry->d_name.len);
+		if (!ret)
+			ret = btrfs_update_inode(trans, root, old_inode);
 	}
 	BUG_ON(ret);
 
-- 
1.7.2.5

