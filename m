Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753974Ab2DPQTy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 12:19:54 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40941 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752294Ab2DPQOX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 12:14:23 -0400
From: Jan Kara <jack@suse.cz>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: dchinner@redhat.com, LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>
Subject: [PATCH 14/27] fs: Add freezing handling to mnt_want_write() / mnt_drop_write()
Date: Mon, 16 Apr 2012 18:13:52 +0200
Message-Id: <1334592845-22862-15-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1334592845-22862-1-git-send-email-jack@suse.cz>
References: <1334592845-22862-1-git-send-email-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Most of places where we want freeze protection coincides with the places where
we also have remount-ro protection. So make mnt_want_write() and
mnt_drop_write() (and their _file alternative) prevent freezing as well.
For the few cases that are really interested only in remount-ro protection
provide new function variants.

BugLink: https://bugs.launchpad.net/bugs/897421
Tested-by: Kamal Mostafa <kamal@canonical.com>
Tested-by: Peter M. Petrakis <peter.petrakis@canonical.com>
Tested-by: Dann Frazier <dann.frazier@canonical.com>
Tested-by: Massimo Morana <massimo.morana@canonical.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/file_table.c       |    2 +-
 fs/inode.c            |    4 +-
 fs/namei.c            |   16 +++++++-
 fs/namespace.c        |  101 +++++++++++++++++++++++++++++++++++++++----------
 fs/open.c             |    2 +-
 include/linux/mount.h |    4 ++
 6 files changed, 103 insertions(+), 26 deletions(-)

diff --git a/fs/file_table.c b/fs/file_table.c
index 70f2a0f..e842ca3 100644
--- a/fs/file_table.c
+++ b/fs/file_table.c
@@ -216,7 +216,7 @@ static void drop_file_write_access(struct file *file)
 		return;
 	if (file_check_writeable(file) != 0)
 		return;
-	mnt_drop_write(mnt);
+	__mnt_drop_write(mnt);
 	file_release_write(file);
 }
 
diff --git a/fs/inode.c b/fs/inode.c
index 9f4f5fe..396a388 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -1560,7 +1560,7 @@ void file_update_time(struct file *file)
 		return;
 
 	/* Finally allowed to write? Takes lock. */
-	if (mnt_want_write_file(file))
+	if (__mnt_want_write_file(file))
 		return;
 
 	/* Only change inode inside the lock region */
@@ -1571,7 +1571,7 @@ void file_update_time(struct file *file)
 	if (sync_it & S_MTIME)
 		inode->i_mtime = now;
 	mark_inode_dirty_sync(inode);
-	mnt_drop_write_file(file);
+	__mnt_drop_write_file(file);
 }
 EXPORT_SYMBOL(file_update_time);
 
diff --git a/fs/namei.c b/fs/namei.c
index 5417fa1..87dd013 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2243,12 +2243,21 @@ static struct file *do_last(struct nameidata *nd, struct path *path,
 	if (nd->last.name[nd->last.len])
 		goto exit;
 
+	/*
+	 * We don't know whether write access will be needed or not. But we
+	 * must get the protection before getting i_mutex due to locking
+	 * constraints. Thus O_CREAT open will get blocked on frozen filesystem
+	 * even if it didn't need to create anything. Not that surprising...
+	 */
+	sb_start_write(dir->d_sb);
+
 	mutex_lock(&dir->d_inode->i_mutex);
 
 	dentry = lookup_hash(nd);
 	error = PTR_ERR(dentry);
 	if (IS_ERR(dentry)) {
 		mutex_unlock(&dir->d_inode->i_mutex);
+		sb_end_write(dir->d_sb);
 		goto exit;
 	}
 
@@ -2267,9 +2276,11 @@ static struct file *do_last(struct nameidata *nd, struct path *path,
 		 * a permanent write count is taken through
 		 * the 'struct file' in nameidata_to_filp().
 		 */
-		error = mnt_want_write(nd->path.mnt);
-		if (error)
+		error = __mnt_want_write(nd->path.mnt);
+		if (error) {
+			sb_end_write(dir->d_sb);
 			goto exit_mutex_unlock;
+		}
 		want_write = 1;
 		/* Don't check for write permission, don't truncate */
 		open_flag &= ~O_TRUNC;
@@ -2291,6 +2302,7 @@ static struct file *do_last(struct nameidata *nd, struct path *path,
 	 * It already exists.
 	 */
 	mutex_unlock(&dir->d_inode->i_mutex);
+	sb_end_write(dir->d_sb);
 	audit_inode(pathname, path->dentry);
 
 	error = -EEXIST;
diff --git a/fs/namespace.c b/fs/namespace.c
index e608199..157afbe 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -283,24 +283,22 @@ static int mnt_is_readonly(struct vfsmount *mnt)
 }
 
 /*
- * Most r/o checks on a fs are for operations that take
- * discrete amounts of time, like a write() or unlink().
- * We must keep track of when those operations start
- * (for permission checks) and when they end, so that
- * we can determine when writes are able to occur to
- * a filesystem.
+ * Most r/o & frozen checks on a fs are for operations that take discrete
+ * amounts of time, like a write() or unlink().  We must keep track of when
+ * those operations start (for permission checks) and when they end, so that we
+ * can determine when writes are able to occur to a filesystem.
  */
 /**
- * mnt_want_write - get write access to a mount
+ * __mnt_want_write - get write access to a mount without freeze protection
  * @m: the mount on which to take a write
  *
- * This tells the low-level filesystem that a write is
- * about to be performed to it, and makes sure that
- * writes are allowed before returning success.  When
- * the write operation is finished, mnt_drop_write()
- * must be called.  This is effectively a refcount.
+ * This tells the low-level filesystem that a write is about to be performed to
+ * it, and makes sure that writes are allowed (mnt it read-write) before
+ * returning success. This operation does not protect against filesystem being
+ * frozen. When the write operation is finished, __mnt_drop_write() must be
+ * called. This is effectively a refcount.
  */
-int mnt_want_write(struct vfsmount *m)
+int __mnt_want_write(struct vfsmount *m)
 {
 	struct mount *mnt = real_mount(m);
 	int ret = 0;
@@ -326,6 +324,28 @@ int mnt_want_write(struct vfsmount *m)
 		ret = -EROFS;
 	}
 	preempt_enable();
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(__mnt_want_write);
+
+/**
+ * mnt_want_write - get write access to a mount
+ * @m: the mount on which to take a write
+ *
+ * This tells the low-level filesystem that a write is about to be performed to
+ * it, and makes sure that writes are allowed (mount is read-write, filesystem
+ * is not frozen) before returning success.  When the write operation is
+ * finished, mnt_drop_write() must be called.  This is effectively a refcount.
+ */
+int mnt_want_write(struct vfsmount *m)
+{
+	int ret;
+
+	sb_start_write(m->mnt_sb);
+	ret = __mnt_want_write(m);
+	if (ret)
+		sb_end_write(m->mnt_sb);
 	return ret;
 }
 EXPORT_SYMBOL_GPL(mnt_want_write);
@@ -355,38 +375,79 @@ int mnt_clone_write(struct vfsmount *mnt)
 EXPORT_SYMBOL_GPL(mnt_clone_write);
 
 /**
- * mnt_want_write_file - get write access to a file's mount
+ * __mnt_want_write_file - get write access to a file's mount
  * @file: the file who's mount on which to take a write
  *
- * This is like mnt_want_write, but it takes a file and can
+ * This is like __mnt_want_write, but it takes a file and can
  * do some optimisations if the file is open for write already
  */
-int mnt_want_write_file(struct file *file)
+int __mnt_want_write_file(struct file *file)
 {
 	struct inode *inode = file->f_dentry->d_inode;
+
 	if (!(file->f_mode & FMODE_WRITE) || special_file(inode->i_mode))
-		return mnt_want_write(file->f_path.mnt);
+		return __mnt_want_write(file->f_path.mnt);
 	else
 		return mnt_clone_write(file->f_path.mnt);
 }
+EXPORT_SYMBOL_GPL(__mnt_want_write_file);
+
+/**
+ * mnt_want_write_file - get write access to a file's mount
+ * @file: the file who's mount on which to take a write
+ *
+ * This is like mnt_want_write, but it takes a file and can
+ * do some optimisations if the file is open for write already
+ */
+int mnt_want_write_file(struct file *file)
+{
+	int ret;
+
+	sb_start_write(file->f_path.mnt->mnt_sb);
+	ret = __mnt_want_write_file(file);
+	if (ret)
+		sb_end_write(file->f_path.mnt->mnt_sb);
+	return ret;
+}
 EXPORT_SYMBOL_GPL(mnt_want_write_file);
 
 /**
- * mnt_drop_write - give up write access to a mount
+ * __mnt_drop_write - give up write access to a mount
  * @mnt: the mount on which to give up write access
  *
  * Tells the low-level filesystem that we are done
  * performing writes to it.  Must be matched with
- * mnt_want_write() call above.
+ * __mnt_want_write() call above.
  */
-void mnt_drop_write(struct vfsmount *mnt)
+void __mnt_drop_write(struct vfsmount *mnt)
 {
 	preempt_disable();
 	mnt_dec_writers(real_mount(mnt));
 	preempt_enable();
 }
+EXPORT_SYMBOL_GPL(__mnt_drop_write);
+
+/**
+ * mnt_drop_write - give up write access to a mount
+ * @mnt: the mount on which to give up write access
+ *
+ * Tells the low-level filesystem that we are done performing writes to it and
+ * also allows filesystem to be frozen again.  Must be matched with
+ * mnt_want_write() call above.
+ */
+void mnt_drop_write(struct vfsmount *mnt)
+{
+	__mnt_drop_write(mnt);
+	sb_end_write(mnt->mnt_sb);
+}
 EXPORT_SYMBOL_GPL(mnt_drop_write);
 
+void __mnt_drop_write_file(struct file *file)
+{
+	__mnt_drop_write(file->f_path.mnt);
+}
+EXPORT_SYMBOL(__mnt_drop_write_file);
+
 void mnt_drop_write_file(struct file *file)
 {
 	mnt_drop_write(file->f_path.mnt);
diff --git a/fs/open.c b/fs/open.c
index 5720854..06afb5b 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -637,7 +637,7 @@ static inline int __get_file_write_access(struct inode *inode,
 		/*
 		 * Balanced in __fput()
 		 */
-		error = mnt_want_write(mnt);
+		error = __mnt_want_write(mnt);
 		if (error)
 			put_write_access(inode);
 	}
diff --git a/include/linux/mount.h b/include/linux/mount.h
index d7029f4..d6ffc3d 100644
--- a/include/linux/mount.h
+++ b/include/linux/mount.h
@@ -55,10 +55,14 @@ struct vfsmount {
 
 struct file; /* forward dec */
 
+extern int __mnt_want_write(struct vfsmount *mnt);
 extern int mnt_want_write(struct vfsmount *mnt);
+extern int __mnt_want_write_file(struct file *file);
 extern int mnt_want_write_file(struct file *file);
 extern int mnt_clone_write(struct vfsmount *mnt);
+extern void __mnt_drop_write(struct vfsmount *mnt);
 extern void mnt_drop_write(struct vfsmount *mnt);
+extern void __mnt_drop_write_file(struct file *file);
 extern void mnt_drop_write_file(struct file *file);
 extern void mntput(struct vfsmount *mnt);
 extern struct vfsmount *mntget(struct vfsmount *mnt);
-- 
1.7.1

