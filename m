Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756016Ab1CAMhS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 07:37:18 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:57942 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755388Ab1CAMhP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 07:37:15 -0500
Message-Id: <20110301123710.179755757@szeredi.hu>
References: <20110301123645.189703316@szeredi.hu>
User-Agent: quilt/0.46-1
Date: Tue, 01 Mar 2011 13:36:50 +0100
From: Miklos Szeredi <miklos@szeredi.hu>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: apw@canonical.com
Subject: [PATCH 5/6 v6] overlayfs: add statfs support
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
--- linux-2.6.orig/fs/overlayfs/overlayfs.c	2011-03-01 12:18:18.000000000 +0100
+++ linux-2.6/fs/overlayfs/overlayfs.c	2011-03-01 12:18:19.000000000 +0100
@@ -2140,9 +2140,29 @@ static int ovl_remount_fs(struct super_b
 		return mnt_want_write(ufs->upper_mnt);
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
+	.statfs		= ovl_statfs,
 };
 
 struct ovl_config {

-- 
