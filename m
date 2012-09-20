Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755772Ab2ITS6l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 14:58:41 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:46700 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754669Ab2ITSy1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 14:54:27 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk, torvalds@linux-foundation.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, akpm@linux-foundation.org, apw@canonical.com,
        nbd@openwrt.org, neilb@suse.de, jordipujolp@gmail.com,
        ezk@fsl.cs.sunysb.edu, dhowells@redhat.com, sedat.dilek@googlemail.com,
        hooanon05@yahoo.co.jp, mszeredi@suse.cz
Subject: [PATCH 05/13] overlayfs: add statfs support
Date: Thu, 20 Sep 2012 20:55:22 +0200
Message-Id: <1348167330-30288-6-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1348167330-30288-1-git-send-email-miklos@szeredi.hu>
References: <1348167330-30288-1-git-send-email-miklos@szeredi.hu>
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
 fs/overlayfs/super.c |   40 ++++++++++++++++++++++++++++++++++++++++
 1 files changed, 40 insertions(+), 0 deletions(-)

diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 02deecd..928b1b1 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -17,15 +17,19 @@
 #include <linux/module.h>
 #include <linux/cred.h>
 #include <linux/sched.h>
+#include <linux/statfs.h>
 #include "overlayfs.h"
 
 MODULE_AUTHOR("Miklos Szeredi <miklos@szeredi.hu>");
 MODULE_DESCRIPTION("Overlay filesystem");
 MODULE_LICENSE("GPL");
 
+#define OVERLAYFS_SUPER_MAGIC 0x794c764f
+
 struct ovl_fs {
 	struct vfsmount *upper_mnt;
 	struct vfsmount *lower_mnt;
+	long lower_namelen;
 };
 
 struct ovl_entry {
@@ -406,9 +410,36 @@ static int ovl_remount_fs(struct super_block *sb, int *flagsp, char *data)
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
+	struct ovl_fs *ofs = dentry->d_sb->s_fs_info;
+	struct dentry *root_dentry = dentry->d_sb->s_root;
+	struct path path;
+	int err;
+
+	ovl_path_upper(root_dentry, &path);
+
+	err = vfs_statfs(&path, buf);
+	if (!err) {
+		buf->f_namelen = max(buf->f_namelen, ofs->lower_namelen);
+		buf->f_type = OVERLAYFS_SUPER_MAGIC;
+	}
+
+	return err;
+}
+
 static const struct super_operations ovl_super_operations = {
 	.put_super	= ovl_put_super,
 	.remount_fs	= ovl_remount_fs,
+	.statfs		= ovl_statfs,
 };
 
 struct ovl_config {
@@ -474,6 +505,7 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 	struct ovl_entry *oe;
 	struct ovl_fs *ufs;
 	struct ovl_config config;
+	struct kstatfs statfs;
 	int err;
 
 	err = ovl_parse_opt((char *) data, &config);
@@ -508,6 +540,13 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 	    !S_ISDIR(lowerpath.dentry->d_inode->i_mode))
 		goto out_put_lowerpath;
 
+	err = vfs_statfs(&lowerpath, &statfs);
+	if (err) {
+		printk(KERN_ERR "overlayfs: statfs failed on lowerpath\n");
+		goto out_put_lowerpath;
+	}
+	ufs->lower_namelen = statfs.f_namelen;
+
 	ufs->upper_mnt = clone_private_mount(&upperpath);
 	err = PTR_ERR(ufs->upper_mnt);
 	if (IS_ERR(ufs->upper_mnt)) {
@@ -556,6 +595,7 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 	root_dentry->d_fsdata = oe;
 	root_dentry->d_op = &ovl_dentry_operations;
 
+	sb->s_magic = OVERLAYFS_SUPER_MAGIC;
 	sb->s_op = &ovl_super_operations;
 	sb->s_root = root_dentry;
 	sb->s_fs_info = ufs;
-- 
1.7.7

