Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965866Ab0HFWpW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 18:45:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56514 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761687Ab0HFWgH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 18:36:07 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Jan Blunck <jblunck@suse.de>,
        Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Valerie Aurora <vaurora@redhat.com>
Subject: [PATCH 07/38] whiteout: Set opaque flag if new directory was previously a whiteout
Date: Fri,  6 Aug 2010 15:34:53 -0700
Message-Id: <1281134124-17041-8-git-send-email-vaurora@redhat.com>
In-Reply-To: <1281134124-17041-1-git-send-email-vaurora@redhat.com>
References: <1281134124-17041-1-git-send-email-vaurora@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Blunck <jblunck@suse.de>

If we mkdir() a directory on the top layer of a union, we don't want
entries from a matching directory on the lower layer to "show through"
suddenly.  To prevent this, we set the opaque flag on a directory if
there was previously a white-out with the same name. (If there is no
white-out and the directory exists in a lower layer, then mkdir() will
fail with EEXIST.)

Signed-off-by: Jan Blunck <jblunck@suse.de>
Signed-off-by: Valerie Aurora <vaurora@redhat.com>
---
 fs/namei.c         |   11 ++++++++++-
 include/linux/fs.h |    5 +++++
 2 files changed, 15 insertions(+), 1 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 665d394..cd8b0d0 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2108,6 +2108,7 @@ SYSCALL_DEFINE3(mknod, const char __user *, filename, int, mode, unsigned, dev)
 int vfs_mkdir(struct inode *dir, struct dentry *dentry, int mode)
 {
 	int error = may_create(dir, dentry);
+	int opaque = 0;
 
 	if (error)
 		return error;
@@ -2120,9 +2121,17 @@ int vfs_mkdir(struct inode *dir, struct dentry *dentry, int mode)
 	if (error)
 		return error;
 
+	if (d_is_whiteout(dentry))
+		opaque = 1;
+
 	error = dir->i_op->mkdir(dir, dentry, mode);
-	if (!error)
+	if (!error) {
 		fsnotify_mkdir(dir, dentry);
+		if (opaque) {
+			dentry->d_inode->i_flags |= S_OPAQUE;
+			mark_inode_dirty(dentry->d_inode);
+		}
+	}
 	return error;
 }
 
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 1f80897..1dbe156 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -236,6 +236,7 @@ struct inodes_stat_t {
 #define S_NOCMTIME	128	/* Do not update file c/mtime */
 #define S_SWAPFILE	256	/* Do not truncate: swapon got its bmaps */
 #define S_PRIVATE	512	/* Inode is fs-internal */
+#define S_OPAQUE	1024	/* Directory is opaque */
 
 /*
  * Note that nosuid etc flags are inode-specific: setting some file-system
@@ -270,6 +271,7 @@ struct inodes_stat_t {
 #define IS_NOCMTIME(inode)	((inode)->i_flags & S_NOCMTIME)
 #define IS_SWAPFILE(inode)	((inode)->i_flags & S_SWAPFILE)
 #define IS_PRIVATE(inode)	((inode)->i_flags & S_PRIVATE)
+#define IS_OPAQUE(inode)	((inode)->i_flags & S_OPAQUE)
 
 /* the read-only stuff doesn't really belong here, but any other place is
    probably as bad and I don't want to create yet another include file. */
@@ -351,8 +353,11 @@ struct inodes_stat_t {
 #define FS_NOTAIL_FL			0x00008000 /* file tail should not be merged */
 #define FS_DIRSYNC_FL			0x00010000 /* dirsync behaviour (directories only) */
 #define FS_TOPDIR_FL			0x00020000 /* Top of directory hierarchies*/
+/* 0x00040000 is used by ext4 */
 #define FS_EXTENT_FL			0x00080000 /* Extents */
 #define FS_DIRECTIO_FL			0x00100000 /* Use direct i/o */
+/* 0x00200000 and 0x00400000 also used by ext4 */
+#define FS_OPAQUE_FL			0x00800000 /* Dir is opaque */
 #define FS_RESERVED_FL			0x80000000 /* reserved for ext2 lib */
 
 #define FS_FL_USER_VISIBLE		0x0003DFFF /* User visible flags */
-- 
1.6.3.3

