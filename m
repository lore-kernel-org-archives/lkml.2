Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753798Ab1LUSaw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 13:30:52 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:43012 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751908Ab1LUSaq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 13:30:46 -0500
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk, torvalds@linux-foundation.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, akpm@linux-foundation.org, apw@canonical.com,
        nbd@openwrt.org, neilb@suse.de, hramrach@centrum.cz,
        jordipujolp@gmail.com, ezk@fsl.cs.sunysb.edu, ricwheeler@gmail.com,
        dhowells@redhat.com, hpj@urpla.net, sedat.dilek@googlemail.com,
        penberg@kernel.org, mszeredi@suse.cz
Subject: [PATCH 2/9] vfs: add i_op->open()
Date: Wed, 21 Dec 2011 19:29:41 +0100
Message-Id: <1324492188-3481-3-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1324492188-3481-1-git-send-email-miklos@szeredi.hu>
References: <1324492188-3481-1-git-send-email-miklos@szeredi.hu>
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
 Documentation/filesystems/vfs.txt |    8 ++++++++
 fs/open.c                         |   25 +++++++++++++++++++++++--
 include/linux/fs.h                |    3 +++
 4 files changed, 36 insertions(+), 2 deletions(-)

diff --git a/Documentation/filesystems/Locking b/Documentation/filesystems/Locking
index 4fca82e..42b0539 100644
--- a/Documentation/filesystems/Locking
+++ b/Documentation/filesystems/Locking
@@ -62,6 +62,7 @@ ata *);
 	int (*removexattr) (struct dentry *, const char *);
 	void (*truncate_range)(struct inode *, loff_t, loff_t);
 	int (*fiemap)(struct inode *, struct fiemap_extent_info *, u64 start, u64 len);
+	struct file *(*open)(struct dentry *,struct file *,const struct cred *);
 
 locking rules:
 	all may block
@@ -89,6 +90,7 @@ listxattr:	no
 removexattr:	yes
 truncate_range:	yes
 fiemap:		no
+open:		no
 	Additionally, ->rmdir(), ->unlink() and ->rename() have ->i_mutex on
 victim.
 	cross-directory ->rename() has (per-superblock) ->s_vfs_rename_sem.
diff --git a/Documentation/filesystems/vfs.txt b/Documentation/filesystems/vfs.txt
index 3d9393b..3c65a0f 100644
--- a/Documentation/filesystems/vfs.txt
+++ b/Documentation/filesystems/vfs.txt
@@ -364,6 +364,8 @@ struct inode_operations {
 	ssize_t (*listxattr) (struct dentry *, char *, size_t);
 	int (*removexattr) (struct dentry *, const char *);
 	void (*truncate_range)(struct inode *, loff_t, loff_t);
+	struct file *(*open) (struct dentry *, struct file *,
+			      const struct cred *);
 };
 
 Again, all methods are called without any locks being held, unless
@@ -475,6 +477,12 @@ otherwise noted.
   truncate_range: a method provided by the underlying filesystem to truncate a
   	range of blocks , i.e. punch a hole somewhere in a file.
 
+  open: this is an alternative to f_op->open(), the difference is that this
+	method may return any open file, not necessarily originating from the
+	same filesystem as the one i_op->open() was called on.  It may be useful
+	for stacking filesystems which want to allow native I/O directly on
+	underlying files.
+
 
 The Address Space Object
 ========================
diff --git a/fs/open.c b/fs/open.c
index ceab906..7f56fc1 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -796,7 +796,7 @@ struct file *nameidata_to_filp(struct nameidata *nd)
 
 	/* Has the filesystem initialised the file for us? */
 	if (filp->f_path.dentry == NULL)
-		filp = __dentry_open(&nd->path, filp, NULL, cred);
+		filp = vfs_open(&nd->path, filp, cred);
 
 	return filp;
 }
@@ -821,7 +821,7 @@ struct file *dentry_open(struct dentry *dentry, struct vfsmount *mnt, int flags,
 	f = get_empty_filp();
 	if (f != NULL) {
 		f->f_flags = flags;
-		ret = __dentry_open(&path, f, NULL, cred);
+		ret = vfs_open(&path, f, cred);
 	}
 	path_put(&path);
 
@@ -829,6 +829,27 @@ struct file *dentry_open(struct dentry *dentry, struct vfsmount *mnt, int flags,
 }
 EXPORT_SYMBOL(dentry_open);
 
+/**
+ * vfs_open - open the file at the given path
+ * @path: path to open
+ * @filp: newly allocated file with f_flag initialized
+ * @cred: credentials to use
+ *
+ * Open the file.  If successful, the returned file will have acquired
+ * an additional reference for path.
+ */
+struct file *vfs_open(struct path *path, struct file *filp,
+		      const struct cred *cred)
+{
+	struct inode *inode = path->dentry->d_inode;
+
+	if (inode->i_op->open)
+		return inode->i_op->open(path->dentry, filp, cred);
+	else
+		return __dentry_open(path, filp, NULL, cred);
+}
+EXPORT_SYMBOL(vfs_open);
+
 static void __put_unused_fd(struct files_struct *files, unsigned int fd)
 {
 	struct fdtable *fdt = files_fdtable(files);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index df499ad..c744032 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1645,6 +1645,8 @@ struct inode_operations {
 	void (*truncate_range)(struct inode *, loff_t, loff_t);
 	int (*fiemap)(struct inode *, struct fiemap_extent_info *, u64 start,
 		      u64 len);
+	struct file *(*open) (struct dentry *, struct file *,
+			      const struct cred *);
 } ____cacheline_aligned;
 
 struct seq_file;
@@ -2015,6 +2017,7 @@ extern long do_sys_open(int dfd, const char __user *filename, int flags,
 extern struct file *filp_open(const char *, int, umode_t);
 extern struct file *file_open_root(struct dentry *, struct vfsmount *,
 				   const char *, int);
+extern struct file *vfs_open(struct path *, struct file *, const struct cred *);
 extern struct file * dentry_open(struct dentry *, struct vfsmount *, int,
 				 const struct cred *);
 extern int filp_close(struct file *, fl_owner_t id);
-- 
1.7.7

