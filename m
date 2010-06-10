Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759421Ab0FJP3a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 11:29:30 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52986 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751997Ab0FJP32 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 11:29:28 -0400
Date: Fri, 11 Jun 2010 01:29:23 +1000
From: Nick Piggin <npiggin@suse.de>
To: Al Viro <viro@ZenIV.linux.org.uk>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [patch] change fs_struct.lock from rwlock to spinlock
Message-ID: <20100610152922.GA16436@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


struct fs_struct.lock is an rwlock with the read-side used to protect
root and pwd members while taking references to them. Taking a reference
to a path typically requires just 2 atomic ops, so the critical section
is very small. Parallel read-side operations would have cacheline contention
on the lock, the dentry, and the vfsmount cachelines, so the rwlock is
unlikely to ever give a real parallelism increase.

Replace it with a spinlock to avoid one or two atomic operations in
typical path lookup fastpath.

Signed-off-by: Nick Piggin <npiggin@suse.de>
---
 drivers/staging/pohmelfs/path_entry.c |    8 +++----
 fs/cachefiles/daemon.c                |    8 +++----
 fs/dcache.c                           |    8 +++----
 fs/exec.c                             |    4 +--
 fs/fs_struct.c                        |   36 +++++++++++++++++-----------------
 fs/namei.c                            |    8 +++----
 fs/namespace.c                        |    4 +--
 fs/proc/base.c                        |    4 +--
 include/linux/fs_struct.h             |    2 -
 kernel/auditsc.c                      |    4 +--
 kernel/fork.c                         |   10 ++++-----
 11 files changed, 48 insertions(+), 48 deletions(-)

Index: linux-2.6/fs/dcache.c
===================================================================
--- linux-2.6.orig/fs/dcache.c
+++ linux-2.6/fs/dcache.c
@@ -2010,10 +2010,10 @@ char *d_path(const struct path *path, ch
 	if (path->dentry->d_op && path->dentry->d_op->d_dname)
 		return path->dentry->d_op->d_dname(path->dentry, buf, buflen);
 
-	read_lock(&current->fs->lock);
+	spin_lock(&current->fs->lock);
 	root = current->fs->root;
 	path_get(&root);
-	read_unlock(&current->fs->lock);
+	spin_unlock(&current->fs->lock);
 	spin_lock(&dcache_lock);
 	tmp = root;
 	res = __d_path(path, &tmp, buf, buflen);
@@ -2108,12 +2108,12 @@ SYSCALL_DEFINE2(getcwd, char __user *, b
 	if (!page)
 		return -ENOMEM;
 
-	read_lock(&current->fs->lock);
+	spin_lock(&current->fs->lock);
 	pwd = current->fs->pwd;
 	path_get(&pwd);
 	root = current->fs->root;
 	path_get(&root);
-	read_unlock(&current->fs->lock);
+	spin_unlock(&current->fs->lock);
 
 	error = -ENOENT;
 	spin_lock(&dcache_lock);
Index: linux-2.6/fs/fs_struct.c
===================================================================
--- linux-2.6.orig/fs/fs_struct.c
+++ linux-2.6/fs/fs_struct.c
@@ -13,11 +13,11 @@ void set_fs_root(struct fs_struct *fs, s
 {
 	struct path old_root;
 
-	write_lock(&fs->lock);
+	spin_lock(&fs->lock);
 	old_root = fs->root;
 	fs->root = *path;
 	path_get(path);
-	write_unlock(&fs->lock);
+	spin_unlock(&fs->lock);
 	if (old_root.dentry)
 		path_put(&old_root);
 }
@@ -30,11 +30,11 @@ void set_fs_pwd(struct fs_struct *fs, st
 {
 	struct path old_pwd;
 
-	write_lock(&fs->lock);
+	spin_lock(&fs->lock);
 	old_pwd = fs->pwd;
 	fs->pwd = *path;
 	path_get(path);
-	write_unlock(&fs->lock);
+	spin_unlock(&fs->lock);
 
 	if (old_pwd.dentry)
 		path_put(&old_pwd);
@@ -51,7 +51,7 @@ void chroot_fs_refs(struct path *old_roo
 		task_lock(p);
 		fs = p->fs;
 		if (fs) {
-			write_lock(&fs->lock);
+			spin_lock(&fs->lock);
 			if (fs->root.dentry == old_root->dentry
 			    && fs->root.mnt == old_root->mnt) {
 				path_get(new_root);
@@ -64,7 +64,7 @@ void chroot_fs_refs(struct path *old_roo
 				fs->pwd = *new_root;
 				count++;
 			}
-			write_unlock(&fs->lock);
+			spin_unlock(&fs->lock);
 		}
 		task_unlock(p);
 	} while_each_thread(g, p);
@@ -87,10 +87,10 @@ void exit_fs(struct task_struct *tsk)
 	if (fs) {
 		int kill;
 		task_lock(tsk);
-		write_lock(&fs->lock);
+		spin_lock(&fs->lock);
 		tsk->fs = NULL;
 		kill = !--fs->users;
-		write_unlock(&fs->lock);
+		spin_unlock(&fs->lock);
 		task_unlock(tsk);
 		if (kill)
 			free_fs_struct(fs);
@@ -104,14 +104,14 @@ struct fs_struct *copy_fs_struct(struct
 	if (fs) {
 		fs->users = 1;
 		fs->in_exec = 0;
-		rwlock_init(&fs->lock);
+		spin_lock_init(&fs->lock);
 		fs->umask = old->umask;
-		read_lock(&old->lock);
+		spin_lock(&old->lock);
 		fs->root = old->root;
 		path_get(&old->root);
 		fs->pwd = old->pwd;
 		path_get(&old->pwd);
-		read_unlock(&old->lock);
+		spin_unlock(&old->lock);
 	}
 	return fs;
 }
@@ -126,10 +126,10 @@ int unshare_fs_struct(void)
 		return -ENOMEM;
 
 	task_lock(current);
-	write_lock(&fs->lock);
+	spin_lock(&fs->lock);
 	kill = !--fs->users;
 	current->fs = new_fs;
-	write_unlock(&fs->lock);
+	spin_unlock(&fs->lock);
 	task_unlock(current);
 
 	if (kill)
@@ -148,7 +148,7 @@ EXPORT_SYMBOL(current_umask);
 /* to be mentioned only in INIT_TASK */
 struct fs_struct init_fs = {
 	.users		= 1,
-	.lock		= __RW_LOCK_UNLOCKED(init_fs.lock),
+	.lock		= __SPIN_LOCK_UNLOCKED(init_fs.lock),
 	.umask		= 0022,
 };
 
@@ -161,14 +161,14 @@ void daemonize_fs_struct(void)
 
 		task_lock(current);
 
-		write_lock(&init_fs.lock);
+		spin_lock(&init_fs.lock);
 		init_fs.users++;
-		write_unlock(&init_fs.lock);
+		spin_unlock(&init_fs.lock);
 
-		write_lock(&fs->lock);
+		spin_lock(&fs->lock);
 		current->fs = &init_fs;
 		kill = !--fs->users;
-		write_unlock(&fs->lock);
+		spin_unlock(&fs->lock);
 
 		task_unlock(current);
 		if (kill)
Index: linux-2.6/fs/namei.c
===================================================================
--- linux-2.6.orig/fs/namei.c
+++ linux-2.6/fs/namei.c
@@ -486,10 +486,10 @@ static __always_inline void set_root(str
 {
 	if (!nd->root.mnt) {
 		struct fs_struct *fs = current->fs;
-		read_lock(&fs->lock);
+		spin_lock(&fs->lock);
 		nd->root = fs->root;
 		path_get(&nd->root);
-		read_unlock(&fs->lock);
+		spin_unlock(&fs->lock);
 	}
 }
 
@@ -1017,10 +1017,10 @@ static int path_init(int dfd, const char
 		path_get(&nd->root);
 	} else if (dfd == AT_FDCWD) {
 		struct fs_struct *fs = current->fs;
-		read_lock(&fs->lock);
+		spin_lock(&fs->lock);
 		nd->path = fs->pwd;
 		path_get(&fs->pwd);
-		read_unlock(&fs->lock);
+		spin_unlock(&fs->lock);
 	} else {
 		struct dentry *dentry;
 
Index: linux-2.6/fs/namespace.c
===================================================================
--- linux-2.6.orig/fs/namespace.c
+++ linux-2.6/fs/namespace.c
@@ -2208,10 +2208,10 @@ SYSCALL_DEFINE2(pivot_root, const char _
 		goto out1;
 	}
 
-	read_lock(&current->fs->lock);
+	spin_lock(&current->fs->lock);
 	root = current->fs->root;
 	path_get(&current->fs->root);
-	read_unlock(&current->fs->lock);
+	spin_unlock(&current->fs->lock);
 	down_write(&namespace_sem);
 	mutex_lock(&old.dentry->d_inode->i_mutex);
 	error = -EINVAL;
Index: linux-2.6/include/linux/fs_struct.h
===================================================================
--- linux-2.6.orig/include/linux/fs_struct.h
+++ linux-2.6/include/linux/fs_struct.h
@@ -5,7 +5,7 @@
 
 struct fs_struct {
 	int users;
-	rwlock_t lock;
+	spinlock_t lock;
 	int umask;
 	int in_exec;
 	struct path root, pwd;
Index: linux-2.6/fs/exec.c
===================================================================
--- linux-2.6.orig/fs/exec.c
+++ linux-2.6/fs/exec.c
@@ -1117,7 +1117,7 @@ int check_unsafe_exec(struct linux_binpr
 	bprm->unsafe = tracehook_unsafe_exec(p);
 
 	n_fs = 1;
-	write_lock(&p->fs->lock);
+	spin_lock(&p->fs->lock);
 	rcu_read_lock();
 	for (t = next_thread(p); t != p; t = next_thread(t)) {
 		if (t->fs == p->fs)
@@ -1134,7 +1134,7 @@ int check_unsafe_exec(struct linux_binpr
 			res = 1;
 		}
 	}
-	write_unlock(&p->fs->lock);
+	spin_unlock(&p->fs->lock);
 
 	return res;
 }
Index: linux-2.6/fs/proc/base.c
===================================================================
--- linux-2.6.orig/fs/proc/base.c
+++ linux-2.6/fs/proc/base.c
@@ -156,10 +156,10 @@ static int get_fs_path(struct task_struc
 	task_lock(task);
 	fs = task->fs;
 	if (fs) {
-		read_lock(&fs->lock);
+		spin_lock(&fs->lock);
 		*path = root ? fs->root : fs->pwd;
 		path_get(path);
-		read_unlock(&fs->lock);
+		spin_unlock(&fs->lock);
 		result = 0;
 	}
 	task_unlock(task);
Index: linux-2.6/kernel/fork.c
===================================================================
--- linux-2.6.orig/kernel/fork.c
+++ linux-2.6/kernel/fork.c
@@ -752,13 +752,13 @@ static int copy_fs(unsigned long clone_f
 	struct fs_struct *fs = current->fs;
 	if (clone_flags & CLONE_FS) {
 		/* tsk->fs is already what we want */
-		write_lock(&fs->lock);
+		spin_lock(&fs->lock);
 		if (fs->in_exec) {
-			write_unlock(&fs->lock);
+			spin_unlock(&fs->lock);
 			return -EAGAIN;
 		}
 		fs->users++;
-		write_unlock(&fs->lock);
+		spin_unlock(&fs->lock);
 		return 0;
 	}
 	tsk->fs = copy_fs_struct(fs);
@@ -1675,13 +1675,13 @@ SYSCALL_DEFINE1(unshare, unsigned long,
 
 		if (new_fs) {
 			fs = current->fs;
-			write_lock(&fs->lock);
+			spin_lock(&fs->lock);
 			current->fs = new_fs;
 			if (--fs->users)
 				new_fs = NULL;
 			else
 				new_fs = fs;
-			write_unlock(&fs->lock);
+			spin_unlock(&fs->lock);
 		}
 
 		if (new_mm) {
Index: linux-2.6/drivers/staging/pohmelfs/path_entry.c
===================================================================
--- linux-2.6.orig/drivers/staging/pohmelfs/path_entry.c
+++ linux-2.6/drivers/staging/pohmelfs/path_entry.c
@@ -44,9 +44,9 @@ int pohmelfs_construct_path_string(struc
 		return -ENOENT;
 	}
 
-	read_lock(&current->fs->lock);
+	spin_lock(&current->fs->lock);
 	path.mnt = mntget(current->fs->root.mnt);
-	read_unlock(&current->fs->lock);
+	spin_unlock(&current->fs->lock);
 
 	path.dentry = d;
 
@@ -91,9 +91,9 @@ int pohmelfs_path_length(struct pohmelfs
 		return -ENOENT;
 	}
 
-	read_lock(&current->fs->lock);
+	spin_lock(&current->fs->lock);
 	root = dget(current->fs->root.dentry);
-	read_unlock(&current->fs->lock);
+	spin_unlock(&current->fs->lock);
 
 	spin_lock(&dcache_lock);
 
Index: linux-2.6/fs/cachefiles/daemon.c
===================================================================
--- linux-2.6.orig/fs/cachefiles/daemon.c
+++ linux-2.6/fs/cachefiles/daemon.c
@@ -574,9 +574,9 @@ static int cachefiles_daemon_cull(struct
 
 	/* extract the directory dentry from the cwd */
 	fs = current->fs;
-	read_lock(&fs->lock);
+	spin_lock(&fs->lock);
 	dir = dget(fs->pwd.dentry);
-	read_unlock(&fs->lock);
+	spin_unlock(&fs->lock);
 
 	if (!S_ISDIR(dir->d_inode->i_mode))
 		goto notdir;
@@ -650,9 +650,9 @@ static int cachefiles_daemon_inuse(struc
 
 	/* extract the directory dentry from the cwd */
 	fs = current->fs;
-	read_lock(&fs->lock);
+	spin_lock(&fs->lock);
 	dir = dget(fs->pwd.dentry);
-	read_unlock(&fs->lock);
+	spin_unlock(&fs->lock);
 
 	if (!S_ISDIR(dir->d_inode->i_mode))
 		goto notdir;
Index: linux-2.6/kernel/auditsc.c
===================================================================
--- linux-2.6.orig/kernel/auditsc.c
+++ linux-2.6/kernel/auditsc.c
@@ -1838,10 +1838,10 @@ void __audit_getname(const char *name)
 	context->names[context->name_count].osid = 0;
 	++context->name_count;
 	if (!context->pwd.dentry) {
-		read_lock(&current->fs->lock);
+		spin_lock(&current->fs->lock);
 		context->pwd = current->fs->pwd;
 		path_get(&current->fs->pwd);
-		read_unlock(&current->fs->lock);
+		spin_unlock(&current->fs->lock);
 	}
 
 }
