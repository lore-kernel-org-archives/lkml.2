Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932466Ab0JZKwg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 06:52:36 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:47232 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759553Ab0JZKvH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 06:51:07 -0400
Message-Id: <20101026105102.234191627@szeredi.hu>
References: <20101026105028.575362331@szeredi.hu>
User-Agent: quilt/0.46-1
Date: Tue, 26 Oct 2010 12:50:31 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: apw@canonical.com
Subject: [PATCH 3/8 v4] vfs: introduce s_op->is_same_inode()
Content-Disposition: inline; filename=vfs-introduce-s_op-is_same_inode.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

rename(2) says:

  "If oldpath and newpath are existing hard links referring to the same
   file, then rename() does nothing, and returns a success status."

Overlayfs, however, uses dummy inodes and 'old_dentry->d_inode ==
new_dentry->d_inode' doesn't necessarily mean that they refer to the
same file.

Introduce a new superblock operation: ->is_same_inode() that returns a
boolean value indicating whether the files referred to by the given
dentries are the same or not.

Export a vfs_is_same_inode() helper so that this can be checked
recursively if one of the underlying filesystems is itself an
overlayfs (or another fs that uses this service).

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/namei.c         |   17 ++++++++++++++---
 include/linux/fs.h |    2 ++
 2 files changed, 16 insertions(+), 3 deletions(-)

Index: linux-2.6/fs/namei.c
===================================================================
--- linux-2.6.orig/fs/namei.c	2010-10-26 11:29:24.000000000 +0200
+++ linux-2.6/fs/namei.c	2010-10-26 11:29:26.000000000 +0200
@@ -2623,6 +2623,17 @@ static int vfs_rename_other(struct inode
 	return error;
 }
 
+bool vfs_is_same_inode(struct dentry *d1, struct dentry *d2)
+{
+	BUG_ON(d1->d_sb != d2->d_sb);
+
+	if (d1->d_sb->s_op->is_same_inode && d1->d_inode && d2->d_inode)
+		return d1->d_sb->s_op->is_same_inode(d1, d2);
+	else
+		return d1->d_inode == d2->d_inode;
+}
+EXPORT_SYMBOL(vfs_is_same_inode);
+
 int vfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 	       struct inode *new_dir, struct dentry *new_dentry)
 {
@@ -2630,9 +2641,9 @@ int vfs_rename(struct inode *old_dir, st
 	int is_dir = S_ISDIR(old_dentry->d_inode->i_mode);
 	const unsigned char *old_name;
 
-	if (old_dentry->d_inode == new_dentry->d_inode)
- 		return 0;
- 
+	if (vfs_is_same_inode(old_dentry, new_dentry))
+		return 0;
+
 	error = may_delete(old_dir, old_dentry, is_dir);
 	if (error)
 		return error;
Index: linux-2.6/include/linux/fs.h
===================================================================
--- linux-2.6.orig/include/linux/fs.h	2010-10-26 11:29:24.000000000 +0200
+++ linux-2.6/include/linux/fs.h	2010-10-26 11:29:26.000000000 +0200
@@ -1584,6 +1584,7 @@ struct super_operations {
 	ssize_t (*quota_write)(struct super_block *, int, const char *, size_t, loff_t);
 #endif
 	int (*bdev_try_to_free_page)(struct super_block*, struct page*, gfp_t);
+	bool (*is_same_inode)(struct dentry *, struct dentry *);
 };
 
 /*
@@ -1821,6 +1822,7 @@ extern int vfs_statfs(struct path *, str
 extern int statfs_by_dentry(struct dentry *, struct kstatfs *);
 extern int freeze_super(struct super_block *super);
 extern int thaw_super(struct super_block *super);
+extern bool vfs_is_same_inode(struct dentry *d1, struct dentry *d2);
 
 extern int current_umask(void);
 

-- 
