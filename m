Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757450Ab0HJJoe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 05:44:34 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:47706 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757319Ab0HJJns (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 05:43:48 -0400
Message-Id: <20100810094324.673936888@szeredi.hu>
References: <20100810094134.596235651@szeredi.hu>
User-Agent: quilt/0.46-1
Date: Tue, 10 Aug 2010 11:41:36 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/7] vfs: add helpers to get root and pwd
Content-Disposition: inline; filename=vfs-add-get_fs-helpers.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Add three helpers that retrieve a refcounted copy of the root and cwd
from the supplied fs_struct.

 get_fs_root()
 get_fs_pwd()
 get_fs_root_and_pwd()

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/cachefiles/daemon.c    |   14 ++------------
 fs/dcache.c               |   12 ++----------
 fs/fs_struct.c            |    7 +------
 fs/namei.c                |   15 +++------------
 fs/namespace.c            |    5 +----
 fs/proc/base.c            |   22 +++++++++++-----------
 include/linux/fs_struct.h |   27 +++++++++++++++++++++++++++
 kernel/auditsc.c          |    9 ++-------
 8 files changed, 49 insertions(+), 62 deletions(-)

Index: linux-2.6/fs/fs_struct.c
===================================================================
--- linux-2.6.orig/fs/fs_struct.c	2010-07-06 17:59:05.000000000 +0200
+++ linux-2.6/fs/fs_struct.c	2010-07-06 18:08:06.000000000 +0200
@@ -106,12 +106,7 @@ struct fs_struct *copy_fs_struct(struct
 		fs->in_exec = 0;
 		rwlock_init(&fs->lock);
 		fs->umask = old->umask;
-		read_lock(&old->lock);
-		fs->root = old->root;
-		path_get(&old->root);
-		fs->pwd = old->pwd;
-		path_get(&old->pwd);
-		read_unlock(&old->lock);
+		get_fs_root_and_pwd(old, &fs->root, &fs->pwd);
 	}
 	return fs;
 }
Index: linux-2.6/include/linux/fs_struct.h
===================================================================
--- linux-2.6.orig/include/linux/fs_struct.h	2010-07-06 17:59:05.000000000 +0200
+++ linux-2.6/include/linux/fs_struct.h	2010-07-06 18:08:06.000000000 +0200
@@ -21,4 +21,31 @@ extern void free_fs_struct(struct fs_str
 extern void daemonize_fs_struct(void);
 extern int unshare_fs_struct(void);
 
+static inline void get_fs_root(struct fs_struct *fs, struct path *root)
+{
+	read_lock(&fs->lock);
+	*root = fs->root;
+	path_get(root);
+	read_unlock(&fs->lock);
+}
+
+static inline void get_fs_pwd(struct fs_struct *fs, struct path *pwd)
+{
+	read_lock(&fs->lock);
+	*pwd = fs->pwd;
+	path_get(pwd);
+	read_unlock(&fs->lock);
+}
+
+static inline void get_fs_root_and_pwd(struct fs_struct *fs, struct path *root,
+				       struct path *pwd)
+{
+	read_lock(&fs->lock);
+	*root = fs->root;
+	path_get(root);
+	*pwd = fs->pwd;
+	path_get(pwd);
+	read_unlock(&fs->lock);
+}
+
 #endif /* _LINUX_FS_STRUCT_H */
Index: linux-2.6/fs/dcache.c
===================================================================
--- linux-2.6.orig/fs/dcache.c	2010-07-06 17:59:05.000000000 +0200
+++ linux-2.6/fs/dcache.c	2010-07-06 18:08:06.000000000 +0200
@@ -2012,10 +2012,7 @@ char *d_path(const struct path *path, ch
 	if (path->dentry->d_op && path->dentry->d_op->d_dname)
 		return path->dentry->d_op->d_dname(path->dentry, buf, buflen);
 
-	read_lock(&current->fs->lock);
-	root = current->fs->root;
-	path_get(&root);
-	read_unlock(&current->fs->lock);
+	get_fs_root(current->fs, &root);
 	spin_lock(&dcache_lock);
 	tmp = root;
 	res = __d_path(path, &tmp, buf, buflen);
@@ -2110,12 +2107,7 @@ SYSCALL_DEFINE2(getcwd, char __user *, b
 	if (!page)
 		return -ENOMEM;
 
-	read_lock(&current->fs->lock);
-	pwd = current->fs->pwd;
-	path_get(&pwd);
-	root = current->fs->root;
-	path_get(&root);
-	read_unlock(&current->fs->lock);
+	get_fs_root_and_pwd(current->fs, &root, &pwd);
 
 	error = -ENOENT;
 	spin_lock(&dcache_lock);
Index: linux-2.6/fs/proc/base.c
===================================================================
--- linux-2.6.orig/fs/proc/base.c	2010-07-06 17:59:05.000000000 +0200
+++ linux-2.6/fs/proc/base.c	2010-07-06 18:08:06.000000000 +0200
@@ -148,18 +148,13 @@ static unsigned int pid_entry_count_dirs
 	return count;
 }
 
-static int get_fs_path(struct task_struct *task, struct path *path, bool root)
+static int get_task_root(struct task_struct *task, struct path *root)
 {
-	struct fs_struct *fs;
 	int result = -ENOENT;
 
 	task_lock(task);
-	fs = task->fs;
-	if (fs) {
-		read_lock(&fs->lock);
-		*path = root ? fs->root : fs->pwd;
-		path_get(path);
-		read_unlock(&fs->lock);
+	if (task->fs) {
+		get_fs_root(task->fs, root);
 		result = 0;
 	}
 	task_unlock(task);
@@ -172,7 +167,12 @@ static int proc_cwd_link(struct inode *i
 	int result = -ENOENT;
 
 	if (task) {
-		result = get_fs_path(task, path, 0);
+		task_lock(task);
+		if (task->fs) {
+			get_fs_pwd(task->fs, path);
+			result = 0;
+		}
+		task_unlock(task);
 		put_task_struct(task);
 	}
 	return result;
@@ -184,7 +184,7 @@ static int proc_root_link(struct inode *
 	int result = -ENOENT;
 
 	if (task) {
-		result = get_fs_path(task, path, 1);
+		result = get_task_root(task, path);
 		put_task_struct(task);
 	}
 	return result;
@@ -589,7 +589,7 @@ static int mounts_open_common(struct ino
 				get_mnt_ns(ns);
 		}
 		rcu_read_unlock();
-		if (ns && get_fs_path(task, &root, 1) == 0)
+		if (ns && get_task_root(task, &root) == 0)
 			ret = 0;
 		put_task_struct(task);
 	}
Index: linux-2.6/fs/cachefiles/daemon.c
===================================================================
--- linux-2.6.orig/fs/cachefiles/daemon.c	2010-07-06 18:08:00.000000000 +0200
+++ linux-2.6/fs/cachefiles/daemon.c	2010-07-06 18:08:06.000000000 +0200
@@ -552,7 +552,6 @@ static int cachefiles_daemon_tag(struct
  */
 static int cachefiles_daemon_cull(struct cachefiles_cache *cache, char *args)
 {
-	struct fs_struct *fs;
 	struct path path;
 	const struct cred *saved_cred;
 	int ret;
@@ -573,11 +572,7 @@ static int cachefiles_daemon_cull(struct
 	}
 
 	/* extract the directory dentry from the cwd */
-	fs = current->fs;
-	read_lock(&fs->lock);
-	path = fs->pwd;
-	path_get(&path);
-	read_unlock(&fs->lock);
+	get_fs_pwd(current->fs, &path);
 
 	if (!S_ISDIR(path.dentry->d_inode->i_mode))
 		goto notdir;
@@ -629,7 +624,6 @@ inval:
  */
 static int cachefiles_daemon_inuse(struct cachefiles_cache *cache, char *args)
 {
-	struct fs_struct *fs;
 	struct path path;
 	const struct cred *saved_cred;
 	int ret;
@@ -650,11 +644,7 @@ static int cachefiles_daemon_inuse(struc
 	}
 
 	/* extract the directory dentry from the cwd */
-	fs = current->fs;
-	read_lock(&fs->lock);
-	path = fs->pwd;
-	path_get(&path);
-	read_unlock(&fs->lock);
+	get_fs_pwd(current->fs, &path);
 
 	if (!S_ISDIR(path.dentry->d_inode->i_mode))
 		goto notdir;
Index: linux-2.6/fs/namei.c
===================================================================
--- linux-2.6.orig/fs/namei.c	2010-07-06 17:59:05.000000000 +0200
+++ linux-2.6/fs/namei.c	2010-07-06 18:08:06.000000000 +0200
@@ -484,13 +484,8 @@ ok:
 
 static __always_inline void set_root(struct nameidata *nd)
 {
-	if (!nd->root.mnt) {
-		struct fs_struct *fs = current->fs;
-		read_lock(&fs->lock);
-		nd->root = fs->root;
-		path_get(&nd->root);
-		read_unlock(&fs->lock);
-	}
+	if (!nd->root.mnt)
+		get_fs_root(current->fs, &nd->root);
 }
 
 static int link_path_walk(const char *, struct nameidata *);
@@ -1016,11 +1011,7 @@ static int path_init(int dfd, const char
 		nd->path = nd->root;
 		path_get(&nd->root);
 	} else if (dfd == AT_FDCWD) {
-		struct fs_struct *fs = current->fs;
-		read_lock(&fs->lock);
-		nd->path = fs->pwd;
-		path_get(&fs->pwd);
-		read_unlock(&fs->lock);
+		get_fs_pwd(current->fs, &nd->path);
 	} else {
 		struct dentry *dentry;
 
Index: linux-2.6/kernel/auditsc.c
===================================================================
--- linux-2.6.orig/kernel/auditsc.c	2010-07-06 17:59:05.000000000 +0200
+++ linux-2.6/kernel/auditsc.c	2010-07-06 18:08:06.000000000 +0200
@@ -1837,13 +1837,8 @@ void __audit_getname(const char *name)
 	context->names[context->name_count].ino  = (unsigned long)-1;
 	context->names[context->name_count].osid = 0;
 	++context->name_count;
-	if (!context->pwd.dentry) {
-		read_lock(&current->fs->lock);
-		context->pwd = current->fs->pwd;
-		path_get(&current->fs->pwd);
-		read_unlock(&current->fs->lock);
-	}
-
+	if (!context->pwd.dentry)
+		get_fs_pwd(current->fs, &context->pwd);
 }
 
 /* audit_putname - intercept a putname request
Index: linux-2.6/fs/namespace.c
===================================================================
--- linux-2.6.orig/fs/namespace.c	2010-07-06 17:59:05.000000000 +0200
+++ linux-2.6/fs/namespace.c	2010-07-06 18:08:06.000000000 +0200
@@ -2208,10 +2208,7 @@ SYSCALL_DEFINE2(pivot_root, const char _
 		goto out1;
 	}
 
-	read_lock(&current->fs->lock);
-	root = current->fs->root;
-	path_get(&current->fs->root);
-	read_unlock(&current->fs->lock);
+	get_fs_root(current->fs, &root);
 	down_write(&namespace_sem);
 	mutex_lock(&old.dentry->d_inode->i_mutex);
 	error = -EINVAL;

-- 
