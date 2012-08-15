Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755529Ab2HOPux (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 11:50:53 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:56976 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755228Ab2HOPrG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 11:47:06 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, apw@canonical.com, nbd@openwrt.org,
        neilb@suse.de, hramrach@centrum.cz, jordipujolp@gmail.com,
        ezk@fsl.cs.sunysb.edu, ricwheeler@gmail.com, dhowells@redhat.com,
        hpj@urpla.net, sedat.dilek@googlemail.com, penberg@kernel.org,
        goran.cetusic@gmail.com, romain@orebokech.com, mszeredi@suse.cz
Subject: [PATCH 01/13] vfs: add i_op->open()
Date: Wed, 15 Aug 2012 17:48:08 +0200
Message-Id: <1345045700-9062-2-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1345045700-9062-1-git-send-email-miklos@szeredi.hu>
References: <1345045700-9062-1-git-send-email-miklos@szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Add a new inode operation i_op->open().  This is for stacked
filesystems that want to return a struct file from a different
filesystem.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 Documentation/filesystems/Locking |    2 ++
 Documentation/filesystems/vfs.txt |    7 +++++++
 fs/namei.c                        |    9 ++++++---
 fs/open.c                         |   23 +++++++++++++++++++++--
 include/linux/fs.h                |    2 ++
 5 files changed, 38 insertions(+), 5 deletions(-)

diff --git a/Documentation/filesystems/Locking b/Documentation/filesystems/Locking
index 0f103e3..d222b6a 100644
--- a/Documentation/filesystems/Locking
+++ b/Documentation/filesystems/Locking
@@ -64,6 +64,7 @@ prototypes:
 	int (*atomic_open)(struct inode *, struct dentry *,
 				struct file *, unsigned open_flag,
 				umode_t create_mode, int *opened);
+	int (*dentry_open)(struct dentry *, struct file *, const struct cred *);
 
 locking rules:
 	all may block
@@ -92,6 +93,7 @@ removexattr:	yes
 fiemap:		no
 update_time:	no
 atomic_open:	yes
+open:		no
 
 	Additionally, ->rmdir(), ->unlink() and ->rename() have ->i_mutex on
 victim.
diff --git a/Documentation/filesystems/vfs.txt b/Documentation/filesystems/vfs.txt
index 065aa2d..f53d93c 100644
--- a/Documentation/filesystems/vfs.txt
+++ b/Documentation/filesystems/vfs.txt
@@ -367,6 +367,7 @@ struct inode_operations {
 	int (*atomic_open)(struct inode *, struct dentry *,
 				struct file *, unsigned open_flag,
 				umode_t create_mode, int *opened);
+	int (*dentry_open)(struct dentry *, struct file *, const struct cred *);
 };
 
 Again, all methods are called without any locks being held, unless
@@ -696,6 +697,12 @@ struct address_space_operations {
   	but instead uses bmap to find out where the blocks in the file
   	are and uses those addresses directly.
 
+  dentry_open: this is an alternative to f_op->open(), the difference is that
+	this method may open a file not necessarily originating from the same
+	filesystem as the one i_op->open() was called on.  It may be
+	useful for stacking filesystems which want to allow native I/O directly
+	on underlying files.
+
 
   invalidatepage: If a page has PagePrivate set, then invalidatepage
         will be called when part or all of the page is to be removed
diff --git a/fs/namei.c b/fs/namei.c
index 1b46439..ac2526d 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2816,9 +2816,12 @@ finish_open_created:
 	error = may_open(&nd->path, acc_mode, open_flag);
 	if (error)
 		goto out;
-	file->f_path.mnt = nd->path.mnt;
-	error = finish_open(file, nd->path.dentry, NULL, opened);
-	if (error) {
+
+	BUG_ON(*opened & FILE_OPENED); /* once it's opened, it's opened */
+	error = vfs_open(&nd->path, file, current_cred());
+	if (!error) {
+		*opened |= FILE_OPENED;
+	} else {
 		if (error == -EOPENSTALE)
 			goto stale_open;
 		goto out;
diff --git a/fs/open.c b/fs/open.c
index f3d96e7..c5a8cac 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -787,8 +787,7 @@ struct file *dentry_open(const struct path *path, int flags,
 		return ERR_PTR(error);
 
 	f->f_flags = flags;
-	f->f_path = *path;
-	error = do_dentry_open(f, NULL, cred);
+	error = vfs_open(path, f, cred);
 	if (!error) {
 		error = open_check_o_direct(f);
 		if (error) {
@@ -803,6 +802,26 @@ struct file *dentry_open(const struct path *path, int flags,
 }
 EXPORT_SYMBOL(dentry_open);
 
+/**
+ * vfs_open - open the file at the given path
+ * @path: path to open
+ * @filp: newly allocated file with f_flag initialized
+ * @cred: credentials to use
+ */
+int vfs_open(const struct path *path, struct file *filp,
+	     const struct cred *cred)
+{
+	struct inode *inode = path->dentry->d_inode;
+
+	if (inode->i_op->dentry_open)
+		return inode->i_op->dentry_open(path->dentry, filp, cred);
+	else {
+		filp->f_path = *path;
+		return do_dentry_open(filp, NULL, cred);
+	}
+}
+EXPORT_SYMBOL(vfs_open);
+
 static void __put_unused_fd(struct files_struct *files, unsigned int fd)
 {
 	struct fdtable *fdt = files_fdtable(files);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 38dba16..abc7a53 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1836,6 +1836,7 @@ struct inode_operations {
 	int (*atomic_open)(struct inode *, struct dentry *,
 			   struct file *, unsigned open_flag,
 			   umode_t create_mode, int *opened);
+	int (*dentry_open)(struct dentry *, struct file *, const struct cred *);
 } ____cacheline_aligned;
 
 struct seq_file;
@@ -2201,6 +2202,7 @@ extern long do_sys_open(int dfd, const char __user *filename, int flags,
 extern struct file *filp_open(const char *, int, umode_t);
 extern struct file *file_open_root(struct dentry *, struct vfsmount *,
 				   const char *, int);
+extern int vfs_open(const struct path *, struct file *, const struct cred *);
 extern struct file * dentry_open(const struct path *, int, const struct cred *);
 extern int filp_close(struct file *, fl_owner_t id);
 extern char * getname(const char __user *);
-- 
1.7.7

