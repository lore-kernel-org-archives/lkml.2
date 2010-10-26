Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932345Ab0JZKvR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 06:51:17 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:47244 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759801Ab0JZKvP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 06:51:15 -0400
Message-Id: <20101026105110.223625187@szeredi.hu>
References: <20101026105028.575362331@szeredi.hu>
User-Agent: quilt/0.46-1
Date: Tue, 26 Oct 2010 12:50:35 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: apw@canonical.com
Subject: [PATCH 7/8 v4] overlayfs: add statfs support
Content-Disposition: inline; filename=ovl-add-statfs-support.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andy Whitcroft <apw@canonical.com>

Add support for statfs to the overlayfs filesystem.  As the upper layer
is the target of all write operations assume that the space in that
filesystem is the space in the overlayfs.  There will be some inaccuracy as
overwriting a file will copy it up and consume space we were not expecting,
but it is better than nothing.

Use the upper layer dentry and mount from the overlayfs root inode,
passing the statfs call to that filesystem.

Signed-off-by: Andy Whitcroft <apw@canonical.com>
Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/overlayfs/overlayfs.c |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

Index: linux-2.6/fs/overlayfs/overlayfs.c
===================================================================
--- linux-2.6.orig/fs/overlayfs/overlayfs.c	2010-10-26 11:29:29.000000000 +0200
+++ linux-2.6/fs/overlayfs/overlayfs.c	2010-10-26 11:29:32.000000000 +0200
@@ -1963,10 +1963,30 @@ static bool ovl_is_same_inode(struct den
 	return vfs_is_same_inode(ovl_dentry_lower(d1), ovl_dentry_lower(d2));
 }
 
+/**
+ * ovl_statfs
+ * @sb: The overlayfs super block
+ * @buf: The struct kstatfs to fill in with stats
+ *
+ * Get the filesystem statistics.  As writes always target the upper layer
+ * filesystem pass the statfs to the same filesystem.
+ */
+static int ovl_statfs(struct dentry *dentry, struct kstatfs *buf)
+{
+	struct dentry *root_dentry = dentry->d_sb->s_root;
+	struct path path;
+	ovl_path_upper(root_dentry, &path);
+
+	if (!path.dentry->d_sb->s_op->statfs)
+		return -ENOSYS;
+	return path.dentry->d_sb->s_op->statfs(path.dentry, buf);
+}
+
 static const struct super_operations ovl_super_operations = {
 	.put_super	= ovl_put_super,
 	.remount_fs	= ovl_remount_fs,
 	.is_same_inode	= ovl_is_same_inode,
+	.statfs		= ovl_statfs,
 };
 
 struct ovl_config {

-- 
