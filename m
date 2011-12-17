Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751437Ab1LQItx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Dec 2011 03:49:53 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:34334 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750806Ab1LQIts (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Dec 2011 03:49:48 -0500
Date: Sat, 17 Dec 2011 08:49:44 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Chris Mason <chris.mason@oracle.com>,
        Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: Linux 3.2-rc6
Message-ID: <20111217084944.GV2203@ZenIV.linux.org.uk>
References: <CA+55aFzd6K2szJD5MLmy3Stcai9oAR=tRXZdQtKgVWBzDr5bdg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzd6K2szJD5MLmy3Stcai9oAR=tRXZdQtKgVWBzDr5bdg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 16, 2011 at 06:53:17PM -0800, Linus Torvalds wrote:

> Casey Schaufler (1):
>       BTRFS: Establish i_ops before calling d_instantiate

I'm sorry, but that's nowhere near enough.  As I said in followup to
the original posting of that patch, it still leaves a race window
where inode is already associated with dentry but still doesn't have
->a_ops, etc. set up.  Hell, ->symlink() doesn't write the symlink
body until after that point...

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 329a5c6..d9501f5 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4590,10 +4590,6 @@ static int btrfs_add_nondir(struct btrfs_trans_handle *trans,
 	int err = btrfs_add_link(trans, dir, inode,
 				 dentry->d_name.name, dentry->d_name.len,
 				 backref, index);
-	if (!err) {
-		d_instantiate(dentry, inode);
-		return 0;
-	}
 	if (err > 0)
 		err = -EEXIST;
 	return err;
@@ -4655,6 +4651,7 @@ static int btrfs_mknod(struct inode *dir, struct dentry *dentry,
 	else {
 		init_special_inode(inode, inode->i_mode, rdev);
 		btrfs_update_inode(trans, root, inode);
+		d_instantiate(dentry, inode);
 	}
 out_unlock:
 	nr = trans->blocks_used;
@@ -4722,6 +4719,7 @@ static int btrfs_create(struct inode *dir, struct dentry *dentry,
 		inode->i_mapping->a_ops = &btrfs_aops;
 		inode->i_mapping->backing_dev_info = &root->fs_info->bdi;
 		BTRFS_I(inode)->io_tree.ops = &btrfs_extent_io_ops;
+		d_instantiate(dentry, inode);
 	}
 out_unlock:
 	nr = trans->blocks_used;
@@ -4780,6 +4778,7 @@ static int btrfs_link(struct dentry *old_dentry, struct inode *dir,
 		err = btrfs_update_inode(trans, root, inode);
 		BUG_ON(err);
 		btrfs_log_new_name(trans, inode, NULL, parent);
+		d_instantiate(dentry, inode);
 	}
 
 	nr = trans->blocks_used;
@@ -7244,6 +7243,8 @@ static int btrfs_symlink(struct inode *dir, struct dentry *dentry,
 		drop_inode = 1;
 
 out_unlock:
+	if (!err)
+		d_instantiate(dentry, inode);
 	nr = trans->blocks_used;
 	btrfs_end_transaction_throttle(trans, root);
 	if (drop_inode) {
