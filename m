Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756739Ab0ITSFA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 14:05:00 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:34560 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756627Ab0ITSE4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 14:04:56 -0400
Message-Id: <20100920180440.740320810@szeredi.hu>
References: <20100920180404.939991832@szeredi.hu>
User-Agent: quilt/0.46-1
Date: Mon, 20 Sep 2010 20:04:06 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: vaurora@redhat.com, neilb@suse.de, viro@zeniv.linux.org.uk
Subject: [PATCH 2/7 v3] vfs: make i_op->permission take a dentry instead of an inode
Content-Disposition: inline; filename=vfs-permission-dentry.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Like most other inode operations ->permission() should take a dentry
instead of an inode.  This is necessary for filesystems which operate
on names not on inodes.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/afs/internal.h                  |    2 +-
 fs/afs/security.c                  |    3 ++-
 fs/bad_inode.c                     |    2 +-
 fs/btrfs/inode.c                   |    4 +++-
 fs/btrfs/ioctl.c                   |    8 ++++----
 fs/ceph/inode.c                    |    3 ++-
 fs/ceph/super.h                    |    2 +-
 fs/cifs/cifsfs.c                   |    3 ++-
 fs/coda/dir.c                      |    3 ++-
 fs/coda/pioctl.c                   |    4 ++--
 fs/ecryptfs/inode.c                |    4 ++--
 fs/fuse/dir.c                      |    3 ++-
 fs/gfs2/ops_inode.c                |   11 ++++++++---
 fs/hostfs/hostfs_kern.c            |    3 ++-
 fs/logfs/dir.c                     |    6 ------
 fs/namei.c                         |   37 ++++++++++++++++++++-----------------
 fs/namespace.c                     |    2 +-
 fs/nfs/dir.c                       |    3 ++-
 fs/nfsd/nfsfh.c                    |    2 +-
 fs/nfsd/vfs.c                      |    4 ++--
 fs/nilfs2/nilfs.h                  |    2 +-
 fs/notify/fanotify/fanotify_user.c |    2 +-
 fs/notify/inotify/inotify_user.c   |    2 +-
 fs/ocfs2/file.c                    |    3 ++-
 fs/ocfs2/file.h                    |    2 +-
 fs/ocfs2/refcounttree.c            |    4 ++--
 fs/open.c                          |   10 +++++-----
 fs/proc/base.c                     |    3 ++-
 fs/proc/proc_sysctl.c              |    3 ++-
 fs/reiserfs/xattr.c                |    4 +++-
 fs/smbfs/file.c                    |    4 ++--
 fs/sysfs/inode.c                   |    3 ++-
 fs/sysfs/sysfs.h                   |    2 +-
 fs/utimes.c                        |    2 +-
 fs/xattr.c                         |   12 +++++++-----
 include/linux/coda_linux.h         |    2 +-
 include/linux/fs.h                 |    4 ++--
 include/linux/nfs_fs.h             |    2 +-
 include/linux/reiserfs_xattr.h     |    2 +-
 ipc/mqueue.c                       |    2 +-
 net/unix/af_unix.c                 |    2 +-
 41 files changed, 100 insertions(+), 81 deletions(-)

Index: linux-2.6/fs/btrfs/ioctl.c
===================================================================
--- linux-2.6.orig/fs/btrfs/ioctl.c	2010-09-20 12:33:25.000000000 +0200
+++ linux-2.6/fs/btrfs/ioctl.c	2010-09-20 13:28:59.000000000 +0200
@@ -396,13 +396,13 @@ fail:
 }
 
 /* copy of may_create in fs/namei.c() */
-static inline int btrfs_may_create(struct inode *dir, struct dentry *child)
+static inline int btrfs_may_create(struct dentry *dir, struct dentry *child)
 {
 	if (child->d_inode)
 		return -EEXIST;
-	if (IS_DEADDIR(dir))
+	if (IS_DEADDIR(dir->d_inode))
 		return -ENOENT;
-	return inode_permission(dir, MAY_WRITE | MAY_EXEC);
+	return dentry_permission(dir, MAY_WRITE | MAY_EXEC);
 }
 
 /*
@@ -433,7 +433,7 @@ static noinline int btrfs_mksubvol(struc
 	if (error)
 		goto out_dput;
 
-	error = btrfs_may_create(dir, dentry);
+	error = btrfs_may_create(parent->dentry, dentry);
 	if (error)
 		goto out_drop_write;
 
Index: linux-2.6/fs/ecryptfs/inode.c
===================================================================
--- linux-2.6.orig/fs/ecryptfs/inode.c	2010-09-20 12:33:25.000000000 +0200
+++ linux-2.6/fs/ecryptfs/inode.c	2010-09-20 13:28:59.000000000 +0200
@@ -975,9 +975,9 @@ int ecryptfs_truncate(struct dentry *den
 }
 
 static int
-ecryptfs_permission(struct inode *inode, int mask)
+ecryptfs_permission(struct dentry *dentry, int mask)
 {
-	return inode_permission(ecryptfs_inode_to_lower(inode), mask);
+	return dentry_permission(ecryptfs_dentry_to_lower(dentry), mask);
 }
 
 /**
Index: linux-2.6/fs/namei.c
===================================================================
--- linux-2.6.orig/fs/namei.c	2010-09-20 12:33:25.000000000 +0200
+++ linux-2.6/fs/namei.c	2010-09-20 13:28:59.000000000 +0200
@@ -240,17 +240,18 @@ int generic_permission(struct inode *ino
 }
 
 /**
- * inode_permission  -  check for access rights to a given inode
- * @inode:	inode to check permission on
+ * dentry_permission  -  check for access rights to a given dentry
+ * @dentry:	dentry to check permission on
  * @mask:	right to check for (%MAY_READ, %MAY_WRITE, %MAY_EXEC)
  *
- * Used to check for read/write/execute permissions on an inode.
+ * Used to check for read/write/execute permissions on an dentry.
  * We use "fsuid" for this, letting us set arbitrary permissions
  * for filesystem access without changing the "normal" uids which
  * are used for other things.
  */
-int inode_permission(struct inode *inode, int mask)
+int dentry_permission(struct dentry *dentry, int mask)
 {
+	struct inode *inode = dentry->d_inode;
 	int retval;
 
 	if (mask & MAY_WRITE) {
@@ -271,7 +272,7 @@ int inode_permission(struct inode *inode
 	}
 
 	if (inode->i_op->permission)
-		retval = inode->i_op->permission(inode, mask);
+		retval = inode->i_op->permission(dentry, mask);
 	else
 		retval = generic_permission(inode, mask, inode->i_op->check_acl);
 
@@ -295,11 +296,11 @@ int inode_permission(struct inode *inode
  *
  * Note:
  *	Do not use this function in new code.  All access checks should
- *	be done using inode_permission().
+ *	be done using dentry_permission().
  */
 int file_permission(struct file *file, int mask)
 {
-	return inode_permission(file->f_path.dentry->d_inode, mask);
+	return dentry_permission(file->f_path.dentry, mask);
 }
 
 /*
@@ -459,12 +460,13 @@ force_reval_path(struct path *path, stru
  * short-cut DAC fails, then call ->permission() to do more
  * complete permission check.
  */
-static int exec_permission(struct inode *inode)
+static int exec_permission(struct dentry *dentry)
 {
 	int ret;
+	struct inode *inode = dentry->d_inode;
 
 	if (inode->i_op->permission) {
-		ret = inode->i_op->permission(inode, MAY_EXEC);
+		ret = inode->i_op->permission(dentry, MAY_EXEC);
 		if (!ret)
 			goto ok;
 		return ret;
@@ -837,7 +839,7 @@ static int link_path_walk(const char *na
 		unsigned int c;
 
 		nd->flags |= LOOKUP_CONTINUE;
-		err = exec_permission(inode);
+		err = exec_permission(nd->path.dentry);
  		if (err)
 			break;
 
@@ -1163,7 +1165,7 @@ static struct dentry *lookup_hash(struct
 {
 	int err;
 
-	err = exec_permission(nd->path.dentry->d_inode);
+	err = exec_permission(nd->path.dentry);
 	if (err)
 		return ERR_PTR(err);
 	return __lookup_hash(&nd->last, nd->path.dentry, nd);
@@ -1213,7 +1215,7 @@ struct dentry *lookup_one_len(const char
 	if (err)
 		return ERR_PTR(err);
 
-	err = exec_permission(base->d_inode);
+	err = exec_permission(base);
 	if (err)
 		return ERR_PTR(err);
 	return __lookup_hash(&this, base, NULL);
@@ -1301,7 +1303,7 @@ static int may_delete(struct inode *dir,
 	BUG_ON(victim->d_parent->d_inode != dir);
 	audit_inode_child(victim, dir);
 
-	error = inode_permission(dir, MAY_WRITE | MAY_EXEC);
+	error = dentry_permission(victim->d_parent, MAY_WRITE | MAY_EXEC);
 	if (error)
 		return error;
 	if (IS_APPEND(dir))
@@ -1337,7 +1339,8 @@ static inline int may_create(struct inod
 		return -EEXIST;
 	if (IS_DEADDIR(dir))
 		return -ENOENT;
-	return inode_permission(dir, MAY_WRITE | MAY_EXEC);
+	BUG_ON(child->d_parent->d_inode != dir);
+	return dentry_permission(child->d_parent, MAY_WRITE | MAY_EXEC);
 }
 
 /*
@@ -1430,7 +1433,7 @@ int may_open(struct path *path, int acc_
 		break;
 	}
 
-	error = inode_permission(inode, acc_mode);
+	error = dentry_permission(dentry, acc_mode);
 	if (error)
 		return error;
 
@@ -2545,7 +2548,7 @@ static int vfs_rename_dir(struct inode *
 	 * we'll need to flip '..'.
 	 */
 	if (new_dir != old_dir) {
-		error = inode_permission(old_dentry->d_inode, MAY_WRITE);
+		error = dentry_permission(old_dentry, MAY_WRITE);
 		if (error)
 			return error;
 	}
@@ -2900,7 +2903,7 @@ EXPORT_SYMBOL(page_symlink_inode_operati
 EXPORT_SYMBOL(path_lookup);
 EXPORT_SYMBOL(kern_path);
 EXPORT_SYMBOL(vfs_path_lookup);
-EXPORT_SYMBOL(inode_permission);
+EXPORT_SYMBOL(dentry_permission);
 EXPORT_SYMBOL(file_permission);
 EXPORT_SYMBOL(unlock_rename);
 EXPORT_SYMBOL(vfs_create);
Index: linux-2.6/fs/namespace.c
===================================================================
--- linux-2.6.orig/fs/namespace.c	2010-09-20 12:33:25.000000000 +0200
+++ linux-2.6/fs/namespace.c	2010-09-20 13:28:59.000000000 +0200
@@ -1230,7 +1230,7 @@ static int mount_is_safe(struct path *pa
 		if (current_uid() != path->dentry->d_inode->i_uid)
 			return -EPERM;
 	}
-	if (inode_permission(path->dentry->d_inode, MAY_WRITE))
+	if (dentry_permission(path->dentry, MAY_WRITE))
 		return -EPERM;
 	return 0;
 #endif
Index: linux-2.6/fs/nfsd/nfsfh.c
===================================================================
--- linux-2.6.orig/fs/nfsd/nfsfh.c	2010-09-20 12:33:25.000000000 +0200
+++ linux-2.6/fs/nfsd/nfsfh.c	2010-09-20 13:28:59.000000000 +0200
@@ -38,7 +38,7 @@ static int nfsd_acceptable(void *expv, s
 		/* make sure parents give x permission to user */
 		int err;
 		parent = dget_parent(tdentry);
-		err = inode_permission(parent->d_inode, MAY_EXEC);
+		err = dentry_permission(parent, MAY_EXEC);
 		if (err < 0) {
 			dput(parent);
 			break;
Index: linux-2.6/fs/nfsd/vfs.c
===================================================================
--- linux-2.6.orig/fs/nfsd/vfs.c	2010-09-20 12:33:25.000000000 +0200
+++ linux-2.6/fs/nfsd/vfs.c	2010-09-20 13:28:59.000000000 +0200
@@ -2126,12 +2126,12 @@ nfsd_permission(struct svc_rqst *rqstp,
 		return 0;
 
 	/* This assumes  NFSD_MAY_{READ,WRITE,EXEC} == MAY_{READ,WRITE,EXEC} */
-	err = inode_permission(inode, acc & (MAY_READ|MAY_WRITE|MAY_EXEC));
+	err = dentry_permission(dentry, acc & (MAY_READ|MAY_WRITE|MAY_EXEC));
 
 	/* Allow read access to binaries even when mode 111 */
 	if (err == -EACCES && S_ISREG(inode->i_mode) &&
 	    acc == (NFSD_MAY_READ | NFSD_MAY_OWNER_OVERRIDE))
-		err = inode_permission(inode, MAY_EXEC);
+		err = dentry_permission(dentry, MAY_EXEC);
 
 	return err? nfserrno(err) : 0;
 }
Index: linux-2.6/fs/notify/fanotify/fanotify_user.c
===================================================================
--- linux-2.6.orig/fs/notify/fanotify/fanotify_user.c	2010-09-20 12:33:25.000000000 +0200
+++ linux-2.6/fs/notify/fanotify/fanotify_user.c	2010-09-20 13:28:59.000000000 +0200
@@ -481,7 +481,7 @@ static int fanotify_find_path(int dfd, c
 	}
 
 	/* you can only watch an inode if you have read permissions on it */
-	ret = inode_permission(path->dentry->d_inode, MAY_READ);
+	ret = dentry_permission(path->dentry, MAY_READ);
 	if (ret)
 		path_put(path);
 out:
Index: linux-2.6/fs/notify/inotify/inotify_user.c
===================================================================
--- linux-2.6.orig/fs/notify/inotify/inotify_user.c	2010-09-20 12:33:25.000000000 +0200
+++ linux-2.6/fs/notify/inotify/inotify_user.c	2010-09-20 13:28:59.000000000 +0200
@@ -358,7 +358,7 @@ static int inotify_find_inode(const char
 	if (error)
 		return error;
 	/* you can only watch an inode if you have read permissions on it */
-	error = inode_permission(path->dentry->d_inode, MAY_READ);
+	error = dentry_permission(path->dentry, MAY_READ);
 	if (error)
 		path_put(path);
 	return error;
Index: linux-2.6/fs/ocfs2/refcounttree.c
===================================================================
--- linux-2.6.orig/fs/ocfs2/refcounttree.c	2010-09-20 12:33:25.000000000 +0200
+++ linux-2.6/fs/ocfs2/refcounttree.c	2010-09-20 13:28:59.000000000 +0200
@@ -4323,7 +4323,7 @@ static inline int ocfs2_may_create(struc
 		return -EEXIST;
 	if (IS_DEADDIR(dir))
 		return -ENOENT;
-	return inode_permission(dir, MAY_WRITE | MAY_EXEC);
+	return dentry_permission(child->d_parent, MAY_WRITE | MAY_EXEC);
 }
 
 /* copied from user_path_parent. */
@@ -4396,7 +4396,7 @@ static int ocfs2_vfs_reflink(struct dent
 	 * file.
 	 */
 	if (!preserve) {
-		error = inode_permission(inode, MAY_READ);
+		error = dentry_permission(old_dentry, MAY_READ);
 		if (error)
 			return error;
 	}
Index: linux-2.6/fs/open.c
===================================================================
--- linux-2.6.orig/fs/open.c	2010-09-20 13:26:53.000000000 +0200
+++ linux-2.6/fs/open.c	2010-09-20 13:28:59.000000000 +0200
@@ -89,7 +89,7 @@ static long do_sys_truncate(const char _
 	if (error)
 		goto dput_and_out;
 
-	error = inode_permission(inode, MAY_WRITE);
+	error = dentry_permission(path.dentry, MAY_WRITE);
 	if (error)
 		goto mnt_drop_write_and_out;
 
@@ -328,7 +328,7 @@ SYSCALL_DEFINE3(faccessat, int, dfd, con
 			goto out_path_release;
 	}
 
-	res = inode_permission(inode, mode | MAY_ACCESS);
+	res = dentry_permission(path.dentry, mode | MAY_ACCESS);
 	/* SuS v2 requires we report a read only fs too */
 	if (res || !(mode & S_IWOTH) || special_file(inode->i_mode))
 		goto out_path_release;
@@ -367,7 +367,7 @@ SYSCALL_DEFINE1(chdir, const char __user
 	if (error)
 		goto out;
 
-	error = inode_permission(path.dentry->d_inode, MAY_EXEC | MAY_CHDIR);
+	error = dentry_permission(path.dentry, MAY_EXEC | MAY_CHDIR);
 	if (error)
 		goto dput_and_out;
 
@@ -396,7 +396,7 @@ SYSCALL_DEFINE1(fchdir, unsigned int, fd
 	if (!S_ISDIR(inode->i_mode))
 		goto out_putf;
 
-	error = inode_permission(inode, MAY_EXEC | MAY_CHDIR);
+	error = dentry_permission(file->f_path.dentry, MAY_EXEC | MAY_CHDIR);
 	if (!error)
 		set_fs_pwd(current->fs, &file->f_path);
 out_putf:
@@ -414,7 +414,7 @@ SYSCALL_DEFINE1(chroot, const char __use
 	if (error)
 		goto out;
 
-	error = inode_permission(path.dentry->d_inode, MAY_EXEC | MAY_CHDIR);
+	error = dentry_permission(path.dentry, MAY_EXEC | MAY_CHDIR);
 	if (error)
 		goto dput_and_out;
 
Index: linux-2.6/fs/utimes.c
===================================================================
--- linux-2.6.orig/fs/utimes.c	2010-09-20 12:33:25.000000000 +0200
+++ linux-2.6/fs/utimes.c	2010-09-20 13:28:59.000000000 +0200
@@ -96,7 +96,7 @@ static int utimes_common(struct path *pa
 			goto mnt_drop_write_and_out;
 
 		if (!is_owner_or_cap(inode)) {
-			error = inode_permission(inode, MAY_WRITE);
+			error = dentry_permission(path->dentry, MAY_WRITE);
 			if (error)
 				goto mnt_drop_write_and_out;
 		}
Index: linux-2.6/fs/xattr.c
===================================================================
--- linux-2.6.orig/fs/xattr.c	2010-09-20 12:33:25.000000000 +0200
+++ linux-2.6/fs/xattr.c	2010-09-20 13:28:59.000000000 +0200
@@ -26,8 +26,10 @@
  * because different namespaces have very different rules.
  */
 static int
-xattr_permission(struct inode *inode, const char *name, int mask)
+xattr_permission(struct dentry *dentry, const char *name, int mask)
 {
+	struct inode *inode = dentry->d_inode;
+
 	/*
 	 * We can never set or remove an extended attribute on a read-only
 	 * filesystem  or on an immutable / append-only inode.
@@ -63,7 +65,7 @@ xattr_permission(struct inode *inode, co
 			return -EPERM;
 	}
 
-	return inode_permission(inode, mask);
+	return dentry_permission(dentry, mask);
 }
 
 /**
@@ -115,7 +117,7 @@ vfs_setxattr(struct dentry *dentry, cons
 	struct inode *inode = dentry->d_inode;
 	int error;
 
-	error = xattr_permission(inode, name, MAY_WRITE);
+	error = xattr_permission(dentry, name, MAY_WRITE);
 	if (error)
 		return error;
 
@@ -165,7 +167,7 @@ vfs_getxattr(struct dentry *dentry, cons
 	struct inode *inode = dentry->d_inode;
 	int error;
 
-	error = xattr_permission(inode, name, MAY_READ);
+	error = xattr_permission(dentry, name, MAY_READ);
 	if (error)
 		return error;
 
@@ -224,7 +226,7 @@ vfs_removexattr(struct dentry *dentry, c
 	if (!inode->i_op->removexattr)
 		return -EOPNOTSUPP;
 
-	error = xattr_permission(inode, name, MAY_WRITE);
+	error = xattr_permission(dentry, name, MAY_WRITE);
 	if (error)
 		return error;
 
Index: linux-2.6/include/linux/fs.h
===================================================================
--- linux-2.6.orig/include/linux/fs.h	2010-09-20 13:26:34.000000000 +0200
+++ linux-2.6/include/linux/fs.h	2010-09-20 13:28:59.000000000 +0200
@@ -1525,7 +1525,7 @@ struct inode_operations {
 	void * (*follow_link) (struct dentry *, struct nameidata *);
 	void (*put_link) (struct dentry *, struct nameidata *, void *);
 	void (*truncate) (struct inode *);
-	int (*permission) (struct inode *, int);
+	int (*permission) (struct dentry *, int);
 	int (*check_acl)(struct inode *, int);
 	int (*setattr) (struct dentry *, struct iattr *);
 	int (*getattr) (struct vfsmount *mnt, struct dentry *, struct kstat *);
@@ -2111,7 +2111,7 @@ extern void emergency_remount(void);
 extern sector_t bmap(struct inode *, sector_t);
 #endif
 extern int notify_change(struct dentry *, struct iattr *);
-extern int inode_permission(struct inode *, int);
+extern int dentry_permission(struct dentry *, int);
 extern int generic_permission(struct inode *, int,
 		int (*check_acl)(struct inode *, int));
 
Index: linux-2.6/ipc/mqueue.c
===================================================================
--- linux-2.6.orig/ipc/mqueue.c	2010-09-20 12:33:25.000000000 +0200
+++ linux-2.6/ipc/mqueue.c	2010-09-20 13:28:59.000000000 +0200
@@ -656,7 +656,7 @@ static struct file *do_open(struct ipc_n
 		goto err;
 	}
 
-	if (inode_permission(dentry->d_inode, oflag2acc[oflag & O_ACCMODE])) {
+	if (dentry_permission(dentry, oflag2acc[oflag & O_ACCMODE])) {
 		ret = -EACCES;
 		goto err;
 	}
Index: linux-2.6/net/unix/af_unix.c
===================================================================
--- linux-2.6.orig/net/unix/af_unix.c	2010-09-20 12:33:25.000000000 +0200
+++ linux-2.6/net/unix/af_unix.c	2010-09-20 13:28:59.000000000 +0200
@@ -757,7 +757,7 @@ static struct sock *unix_find_other(stru
 		if (err)
 			goto fail;
 		inode = path.dentry->d_inode;
-		err = inode_permission(inode, MAY_WRITE);
+		err = dentry_permission(path.dentry, MAY_WRITE);
 		if (err)
 			goto put_fail;
 
Index: linux-2.6/fs/afs/internal.h
===================================================================
--- linux-2.6.orig/fs/afs/internal.h	2010-09-20 12:33:25.000000000 +0200
+++ linux-2.6/fs/afs/internal.h	2010-09-20 13:28:59.000000000 +0200
@@ -624,7 +624,7 @@ extern void afs_clear_permits(struct afs
 extern void afs_cache_permit(struct afs_vnode *, struct key *, long);
 extern void afs_zap_permits(struct rcu_head *);
 extern struct key *afs_request_key(struct afs_cell *);
-extern int afs_permission(struct inode *, int);
+extern int afs_permission(struct dentry *, int);
 
 /*
  * server.c
Index: linux-2.6/fs/afs/security.c
===================================================================
--- linux-2.6.orig/fs/afs/security.c	2010-09-20 12:33:25.000000000 +0200
+++ linux-2.6/fs/afs/security.c	2010-09-20 13:28:59.000000000 +0200
@@ -285,8 +285,9 @@ static int afs_check_permit(struct afs_v
  * - AFS ACLs are attached to directories only, and a file is controlled by its
  *   parent directory's ACL
  */
-int afs_permission(struct inode *inode, int mask)
+int afs_permission(struct dentry *dentry, int mask)
 {
+	struct inode *inode = dentry->d_inode;
 	struct afs_vnode *vnode = AFS_FS_I(inode);
 	afs_access_t uninitialized_var(access);
 	struct key *key;
Index: linux-2.6/fs/bad_inode.c
===================================================================
--- linux-2.6.orig/fs/bad_inode.c	2010-09-20 12:33:25.000000000 +0200
+++ linux-2.6/fs/bad_inode.c	2010-09-20 13:28:59.000000000 +0200
@@ -229,7 +229,7 @@ static int bad_inode_readlink(struct den
 	return -EIO;
 }
 
-static int bad_inode_permission(struct inode *inode, int mask)
+static int bad_inode_permission(struct dentry *dentry, int mask)
 {
 	return -EIO;
 }
Index: linux-2.6/fs/btrfs/inode.c
===================================================================
--- linux-2.6.orig/fs/btrfs/inode.c	2010-09-20 12:33:25.000000000 +0200
+++ linux-2.6/fs/btrfs/inode.c	2010-09-20 13:28:59.000000000 +0200
@@ -6922,8 +6922,10 @@ static int btrfs_set_page_dirty(struct p
 	return __set_page_dirty_nobuffers(page);
 }
 
-static int btrfs_permission(struct inode *inode, int mask)
+static int btrfs_permission(struct dentry *dentry, int mask)
 {
+	struct inode *inode = dentry->d_inode;
+
 	if ((BTRFS_I(inode)->flags & BTRFS_INODE_READONLY) && (mask & MAY_WRITE))
 		return -EACCES;
 	return generic_permission(inode, mask, btrfs_check_acl);
Index: linux-2.6/fs/ceph/inode.c
===================================================================
--- linux-2.6.orig/fs/ceph/inode.c	2010-09-20 12:33:25.000000000 +0200
+++ linux-2.6/fs/ceph/inode.c	2010-09-20 13:28:59.000000000 +0200
@@ -1758,8 +1758,9 @@ int ceph_do_getattr(struct inode *inode,
  * Check inode permissions.  We verify we have a valid value for
  * the AUTH cap, then call the generic handler.
  */
-int ceph_permission(struct inode *inode, int mask)
+int ceph_permission(struct dentry *dentry, int mask)
 {
+	struct inode *inode = dentry->d_inode;
 	int err = ceph_do_getattr(inode, CEPH_CAP_AUTH_SHARED);
 
 	if (!err)
Index: linux-2.6/fs/ceph/super.h
===================================================================
--- linux-2.6.orig/fs/ceph/super.h	2010-09-20 12:33:25.000000000 +0200
+++ linux-2.6/fs/ceph/super.h	2010-09-20 13:28:59.000000000 +0200
@@ -779,7 +779,7 @@ extern void ceph_queue_invalidate(struct
 extern void ceph_queue_writeback(struct inode *inode);
 
 extern int ceph_do_getattr(struct inode *inode, int mask);
-extern int ceph_permission(struct inode *inode, int mask);
+extern int ceph_permission(struct dentry *dentry, int mask);
 extern int ceph_setattr(struct dentry *dentry, struct iattr *attr);
 extern int ceph_getattr(struct vfsmount *mnt, struct dentry *dentry,
 			struct kstat *stat);
Index: linux-2.6/fs/cifs/cifsfs.c
===================================================================
--- linux-2.6.orig/fs/cifs/cifsfs.c	2010-09-20 12:33:25.000000000 +0200
+++ linux-2.6/fs/cifs/cifsfs.c	2010-09-20 13:28:59.000000000 +0200
@@ -269,8 +269,9 @@ cifs_statfs(struct dentry *dentry, struc
 	return 0;
 }
 
-static int cifs_permission(struct inode *inode, int mask)
+static int cifs_permission(struct dentry *dentry, int mask)
 {
+	struct inode *inode = dentry->d_inode;
 	struct cifs_sb_info *cifs_sb;
 
 	cifs_sb = CIFS_SB(inode->i_sb);
Index: linux-2.6/fs/coda/dir.c
===================================================================
--- linux-2.6.orig/fs/coda/dir.c	2010-09-20 12:33:25.000000000 +0200
+++ linux-2.6/fs/coda/dir.c	2010-09-20 13:28:59.000000000 +0200
@@ -138,8 +138,9 @@ exit:
 }
 
 
-int coda_permission(struct inode *inode, int mask)
+int coda_permission(struct dentry *dentry, int mask)
 {
+	struct inode *inode = dentry->d_inode;
         int error = 0;
 
 	mask &= MAY_READ | MAY_WRITE | MAY_EXEC;
Index: linux-2.6/fs/fuse/dir.c
===================================================================
--- linux-2.6.orig/fs/fuse/dir.c	2010-09-20 12:33:25.000000000 +0200
+++ linux-2.6/fs/fuse/dir.c	2010-09-20 13:28:59.000000000 +0200
@@ -981,8 +981,9 @@ static int fuse_access(struct inode *ino
  * access request is sent.  Execute permission is still checked
  * locally based on file mode.
  */
-static int fuse_permission(struct inode *inode, int mask)
+static int fuse_permission(struct dentry *dentry, int mask)
 {
+	struct inode *inode = dentry->d_inode;
 	struct fuse_conn *fc = get_fuse_conn(inode);
 	bool refreshed = false;
 	int err = 0;
Index: linux-2.6/fs/gfs2/ops_inode.c
===================================================================
--- linux-2.6.orig/fs/gfs2/ops_inode.c	2010-09-20 12:33:25.000000000 +0200
+++ linux-2.6/fs/gfs2/ops_inode.c	2010-09-20 13:28:59.000000000 +0200
@@ -1071,6 +1071,11 @@ int gfs2_permission(struct inode *inode,
 	return error;
 }
 
+static int gfs2_dentry_permission(struct dentry *dentry, int mask)
+{
+	return gfs2_permission(dentry->d_inode, mask);
+}
+
 /*
  * XXX(truncate): the truncate_setsize calls should be moved to the end.
  */
@@ -1344,7 +1349,7 @@ out:
 }
 
 const struct inode_operations gfs2_file_iops = {
-	.permission = gfs2_permission,
+	.permission = gfs2_dentry_permission,
 	.setattr = gfs2_setattr,
 	.getattr = gfs2_getattr,
 	.setxattr = gfs2_setxattr,
@@ -1364,7 +1369,7 @@ const struct inode_operations gfs2_dir_i
 	.rmdir = gfs2_rmdir,
 	.mknod = gfs2_mknod,
 	.rename = gfs2_rename,
-	.permission = gfs2_permission,
+	.permission = gfs2_dentry_permission,
 	.setattr = gfs2_setattr,
 	.getattr = gfs2_getattr,
 	.setxattr = gfs2_setxattr,
@@ -1378,7 +1383,7 @@ const struct inode_operations gfs2_symli
 	.readlink = generic_readlink,
 	.follow_link = gfs2_follow_link,
 	.put_link = gfs2_put_link,
-	.permission = gfs2_permission,
+	.permission = gfs2_dentry_permission,
 	.setattr = gfs2_setattr,
 	.getattr = gfs2_getattr,
 	.setxattr = gfs2_setxattr,
Index: linux-2.6/fs/coda/pioctl.c
===================================================================
--- linux-2.6.orig/fs/coda/pioctl.c	2010-09-20 12:33:25.000000000 +0200
+++ linux-2.6/fs/coda/pioctl.c	2010-09-20 13:28:59.000000000 +0200
@@ -26,7 +26,7 @@
 #include <linux/smp_lock.h>
 
 /* pioctl ops */
-static int coda_ioctl_permission(struct inode *inode, int mask);
+static int coda_ioctl_permission(struct dentry *dentry, int mask);
 static long coda_pioctl(struct file *filp, unsigned int cmd,
 			unsigned long user_data);
 
@@ -42,7 +42,7 @@ const struct file_operations coda_ioctl_
 };
 
 /* the coda pioctl inode ops */
-static int coda_ioctl_permission(struct inode *inode, int mask)
+static int coda_ioctl_permission(struct dentry *dentry, int mask)
 {
 	return (mask & MAY_EXEC) ? -EACCES : 0;
 }
Index: linux-2.6/fs/hostfs/hostfs_kern.c
===================================================================
--- linux-2.6.orig/fs/hostfs/hostfs_kern.c	2010-09-20 12:33:25.000000000 +0200
+++ linux-2.6/fs/hostfs/hostfs_kern.c	2010-09-20 13:28:59.000000000 +0200
@@ -746,8 +746,9 @@ int hostfs_rename(struct inode *from_ino
 	return err;
 }
 
-int hostfs_permission(struct inode *ino, int desired)
+static int hostfs_permission(struct dentry *dentry, int desired)
 {
+	struct inode *ino = dentry->d_inode;
 	char *name;
 	int r = 0, w = 0, x = 0, err;
 
Index: linux-2.6/fs/logfs/dir.c
===================================================================
--- linux-2.6.orig/fs/logfs/dir.c	2010-09-20 12:33:25.000000000 +0200
+++ linux-2.6/fs/logfs/dir.c	2010-09-20 13:28:59.000000000 +0200
@@ -555,11 +555,6 @@ static int logfs_symlink(struct inode *d
 	return __logfs_create(dir, dentry, inode, target, destlen);
 }
 
-static int logfs_permission(struct inode *inode, int mask)
-{
-	return generic_permission(inode, mask, NULL);
-}
-
 static int logfs_link(struct dentry *old_dentry, struct inode *dir,
 		struct dentry *dentry)
 {
@@ -818,7 +813,6 @@ const struct inode_operations logfs_dir_
 	.mknod		= logfs_mknod,
 	.rename		= logfs_rename,
 	.rmdir		= logfs_rmdir,
-	.permission	= logfs_permission,
 	.symlink	= logfs_symlink,
 	.unlink		= logfs_unlink,
 };
Index: linux-2.6/fs/nfs/dir.c
===================================================================
--- linux-2.6.orig/fs/nfs/dir.c	2010-09-20 12:33:25.000000000 +0200
+++ linux-2.6/fs/nfs/dir.c	2010-09-20 13:28:59.000000000 +0200
@@ -1941,8 +1941,9 @@ int nfs_may_open(struct inode *inode, st
 	return nfs_do_access(inode, cred, nfs_open_permission_mask(openflags));
 }
 
-int nfs_permission(struct inode *inode, int mask)
+int nfs_permission(struct dentry *dentry, int mask)
 {
+	struct inode *inode = dentry->d_inode;
 	struct rpc_cred *cred;
 	int res = 0;
 
Index: linux-2.6/fs/nilfs2/nilfs.h
===================================================================
--- linux-2.6.orig/fs/nilfs2/nilfs.h	2010-09-20 12:33:25.000000000 +0200
+++ linux-2.6/fs/nilfs2/nilfs.h	2010-09-20 13:28:59.000000000 +0200
@@ -200,7 +200,7 @@ static inline struct inode *nilfs_dat_in
  */
 #ifdef CONFIG_NILFS_POSIX_ACL
 #error "NILFS: not yet supported POSIX ACL"
-extern int nilfs_permission(struct inode *, int, struct nameidata *);
+extern int nilfs_permission(struct dentry *, int);
 extern int nilfs_acl_chmod(struct inode *);
 extern int nilfs_init_acl(struct inode *, struct inode *);
 #else
Index: linux-2.6/fs/ocfs2/file.c
===================================================================
--- linux-2.6.orig/fs/ocfs2/file.c	2010-09-20 12:33:25.000000000 +0200
+++ linux-2.6/fs/ocfs2/file.c	2010-09-20 13:28:59.000000000 +0200
@@ -1319,8 +1319,9 @@ bail:
 	return err;
 }
 
-int ocfs2_permission(struct inode *inode, int mask)
+int ocfs2_permission(struct dentry *dentry, int mask)
 {
+	struct inode *inode = dentry->d_inode;
 	int ret;
 
 	mlog_entry_void();
Index: linux-2.6/fs/ocfs2/file.h
===================================================================
--- linux-2.6.orig/fs/ocfs2/file.h	2010-09-20 12:33:25.000000000 +0200
+++ linux-2.6/fs/ocfs2/file.h	2010-09-20 13:28:59.000000000 +0200
@@ -61,7 +61,7 @@ int ocfs2_zero_extend(struct inode *inod
 int ocfs2_setattr(struct dentry *dentry, struct iattr *attr);
 int ocfs2_getattr(struct vfsmount *mnt, struct dentry *dentry,
 		  struct kstat *stat);
-int ocfs2_permission(struct inode *inode, int mask);
+int ocfs2_permission(struct dentry *dentry, int mask);
 
 int ocfs2_should_update_atime(struct inode *inode,
 			      struct vfsmount *vfsmnt);
Index: linux-2.6/fs/proc/base.c
===================================================================
--- linux-2.6.orig/fs/proc/base.c	2010-09-20 12:33:25.000000000 +0200
+++ linux-2.6/fs/proc/base.c	2010-09-20 13:28:59.000000000 +0200
@@ -2050,8 +2050,9 @@ static const struct file_operations proc
  * /proc/pid/fd needs a special permission handler so that a process can still
  * access /proc/self/fd after it has executed a setuid().
  */
-static int proc_fd_permission(struct inode *inode, int mask)
+static int proc_fd_permission(struct dentry *dentry, int mask)
 {
+	struct inode *inode = dentry->d_inode;
 	int rv;
 
 	rv = generic_permission(inode, mask, NULL);
Index: linux-2.6/fs/proc/proc_sysctl.c
===================================================================
--- linux-2.6.orig/fs/proc/proc_sysctl.c	2010-09-20 12:33:25.000000000 +0200
+++ linux-2.6/fs/proc/proc_sysctl.c	2010-09-20 13:28:59.000000000 +0200
@@ -292,12 +292,13 @@ out:
 	return ret;
 }
 
-static int proc_sys_permission(struct inode *inode, int mask)
+static int proc_sys_permission(struct dentry *dentry, int mask)
 {
 	/*
 	 * sysctl entries that are not writeable,
 	 * are _NOT_ writeable, capabilities or not.
 	 */
+	struct inode *inode = dentry->d_inode;
 	struct ctl_table_header *head;
 	struct ctl_table *table;
 	int error;
Index: linux-2.6/fs/reiserfs/xattr.c
===================================================================
--- linux-2.6.orig/fs/reiserfs/xattr.c	2010-09-20 12:33:25.000000000 +0200
+++ linux-2.6/fs/reiserfs/xattr.c	2010-09-20 13:28:59.000000000 +0200
@@ -954,8 +954,10 @@ static int xattr_mount_check(struct supe
 	return 0;
 }
 
-int reiserfs_permission(struct inode *inode, int mask)
+int reiserfs_permission(struct dentry *dentry, int mask)
 {
+	struct inode *inode = dentry->d_inode;
+
 	/*
 	 * We don't do permission checks on the internal objects.
 	 * Permissions are determined by the "owning" object.
Index: linux-2.6/fs/smbfs/file.c
===================================================================
--- linux-2.6.orig/fs/smbfs/file.c	2010-09-20 12:33:25.000000000 +0200
+++ linux-2.6/fs/smbfs/file.c	2010-09-20 13:28:59.000000000 +0200
@@ -408,9 +408,9 @@ smb_file_release(struct inode *inode, st
  * privileges, so we need our own check for this.
  */
 static int
-smb_file_permission(struct inode *inode, int mask)
+smb_file_permission(struct dentry *dentry, int mask)
 {
-	int mode = inode->i_mode;
+	int mode = dentry->d_inode->i_mode;
 	int error = 0;
 
 	VERBOSE("mode=%x, mask=%x\n", mode, mask);
Index: linux-2.6/fs/sysfs/inode.c
===================================================================
--- linux-2.6.orig/fs/sysfs/inode.c	2010-09-20 12:33:25.000000000 +0200
+++ linux-2.6/fs/sysfs/inode.c	2010-09-20 13:28:59.000000000 +0200
@@ -348,8 +348,9 @@ int sysfs_hash_and_remove(struct sysfs_d
 		return -ENOENT;
 }
 
-int sysfs_permission(struct inode *inode, int mask)
+int sysfs_permission(struct dentry *dentry, int mask)
 {
+	struct inode *inode = dentry->d_inode;
 	struct sysfs_dirent *sd = inode->i_private;
 
 	mutex_lock(&sysfs_mutex);
Index: linux-2.6/fs/sysfs/sysfs.h
===================================================================
--- linux-2.6.orig/fs/sysfs/sysfs.h	2010-09-20 12:33:25.000000000 +0200
+++ linux-2.6/fs/sysfs/sysfs.h	2010-09-20 13:28:59.000000000 +0200
@@ -200,7 +200,7 @@ static inline void __sysfs_put(struct sy
 struct inode *sysfs_get_inode(struct super_block *sb, struct sysfs_dirent *sd);
 void sysfs_evict_inode(struct inode *inode);
 int sysfs_sd_setattr(struct sysfs_dirent *sd, struct iattr *iattr);
-int sysfs_permission(struct inode *inode, int mask);
+int sysfs_permission(struct dentry *dentry, int mask);
 int sysfs_setattr(struct dentry *dentry, struct iattr *iattr);
 int sysfs_getattr(struct vfsmount *mnt, struct dentry *dentry, struct kstat *stat);
 int sysfs_setxattr(struct dentry *dentry, const char *name, const void *value,
Index: linux-2.6/include/linux/coda_linux.h
===================================================================
--- linux-2.6.orig/include/linux/coda_linux.h	2010-09-20 12:33:25.000000000 +0200
+++ linux-2.6/include/linux/coda_linux.h	2010-09-20 13:28:59.000000000 +0200
@@ -37,7 +37,7 @@ extern const struct file_operations coda
 /* operations shared over more than one file */
 int coda_open(struct inode *i, struct file *f);
 int coda_release(struct inode *i, struct file *f);
-int coda_permission(struct inode *inode, int mask);
+int coda_permission(struct dentry *dentry, int mask);
 int coda_revalidate_inode(struct dentry *);
 int coda_getattr(struct vfsmount *, struct dentry *, struct kstat *);
 int coda_setattr(struct dentry *, struct iattr *);
Index: linux-2.6/include/linux/nfs_fs.h
===================================================================
--- linux-2.6.orig/include/linux/nfs_fs.h	2010-09-20 12:33:25.000000000 +0200
+++ linux-2.6/include/linux/nfs_fs.h	2010-09-20 13:28:59.000000000 +0200
@@ -348,7 +348,7 @@ extern int nfs_refresh_inode(struct inod
 extern int nfs_post_op_update_inode(struct inode *inode, struct nfs_fattr *fattr);
 extern int nfs_post_op_update_inode_force_wcc(struct inode *inode, struct nfs_fattr *fattr);
 extern int nfs_getattr(struct vfsmount *, struct dentry *, struct kstat *);
-extern int nfs_permission(struct inode *, int);
+extern int nfs_permission(struct dentry *, int);
 extern int nfs_open(struct inode *, struct file *);
 extern int nfs_release(struct inode *, struct file *);
 extern int nfs_attribute_timeout(struct inode *inode);
Index: linux-2.6/include/linux/reiserfs_xattr.h
===================================================================
--- linux-2.6.orig/include/linux/reiserfs_xattr.h	2010-09-20 12:33:25.000000000 +0200
+++ linux-2.6/include/linux/reiserfs_xattr.h	2010-09-20 13:28:59.000000000 +0200
@@ -41,7 +41,7 @@ int reiserfs_xattr_init(struct super_blo
 int reiserfs_lookup_privroot(struct super_block *sb);
 int reiserfs_delete_xattrs(struct inode *inode);
 int reiserfs_chown_xattrs(struct inode *inode, struct iattr *attrs);
-int reiserfs_permission(struct inode *inode, int mask);
+int reiserfs_permission(struct dentry *dentry, int mask);
 
 #ifdef CONFIG_REISERFS_FS_XATTR
 #define has_xattr_dir(inode) (REISERFS_I(inode)->i_flags & i_has_xattr_dir)

-- 
