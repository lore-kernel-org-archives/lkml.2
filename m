Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761741Ab2COLpV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 07:45:21 -0400
Received: from www.linutronix.de ([62.245.132.108]:39751 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761560Ab2COLo0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 07:44:26 -0400
Message-Id: <20120314170918.605019314@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 15 Mar 2012 11:44:24 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Nick Piggin <npiggin@kernel.dk>
Subject: [patch 4/5] fs: fs_struct use seqlock
References: <20120314170736.617746873@linutronix.de>
Content-Disposition: inline; filename=fs-struct-use-seqlock.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace the open coded seqlock with a real one.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

---
 fs/exec.c                 |    4 ++--
 fs/fhandle.c              |    4 ++--
 fs/fs_struct.c            |   46 ++++++++++++++++++----------------------------
 fs/namei.c                |   14 +++++++-------
 include/linux/fs_struct.h |   16 +++++++---------
 kernel/fork.c             |   10 +++++-----
 6 files changed, 41 insertions(+), 53 deletions(-)

Index: tip/fs/exec.c
===================================================================
--- tip.orig/fs/exec.c
+++ tip/fs/exec.c
@@ -1244,7 +1244,7 @@ static int check_unsafe_exec(struct linu
 	}
 
 	n_fs = 1;
-	spin_lock(&p->fs->lock);
+	seq_spin_lock(&p->fs->lock);
 	rcu_read_lock();
 	for (t = next_thread(p); t != p; t = next_thread(t)) {
 		if (t->fs == p->fs)
@@ -1261,7 +1261,7 @@ static int check_unsafe_exec(struct linu
 			res = 1;
 		}
 	}
-	spin_unlock(&p->fs->lock);
+	seq_spin_unlock(&p->fs->lock);
 
 	return res;
 }
Index: tip/fs/fhandle.c
===================================================================
--- tip.orig/fs/fhandle.c
+++ tip/fs/fhandle.c
@@ -117,10 +117,10 @@ static struct vfsmount *get_vfsmount_fro
 
 	if (fd == AT_FDCWD) {
 		struct fs_struct *fs = current->fs;
-		spin_lock(&fs->lock);
+		seq_spin_lock(&fs->lock);
 		path = fs->pwd;
 		mntget(path.mnt);
-		spin_unlock(&fs->lock);
+		seq_spin_unlock(&fs->lock);
 	} else {
 		int fput_needed;
 		struct file *file = fget_light(fd, &fput_needed);
Index: tip/fs/fs_struct.c
===================================================================
--- tip.orig/fs/fs_struct.c
+++ tip/fs/fs_struct.c
@@ -26,13 +26,11 @@ void set_fs_root(struct fs_struct *fs, s
 {
 	struct path old_root;
 
-	spin_lock(&fs->lock);
-	write_seqcount_begin(&fs->seq);
+	write_seqlock(&fs->lock);
 	old_root = fs->root;
 	fs->root = *path;
 	path_get_longterm(path);
-	write_seqcount_end(&fs->seq);
-	spin_unlock(&fs->lock);
+	write_sequnlock(&fs->lock);
 	if (old_root.dentry)
 		path_put_longterm(&old_root);
 }
@@ -45,13 +43,11 @@ void set_fs_pwd(struct fs_struct *fs, st
 {
 	struct path old_pwd;
 
-	spin_lock(&fs->lock);
-	write_seqcount_begin(&fs->seq);
+	write_seqlock(&fs->lock);
 	old_pwd = fs->pwd;
 	fs->pwd = *path;
 	path_get_longterm(path);
-	write_seqcount_end(&fs->seq);
-	spin_unlock(&fs->lock);
+	write_sequnlock(&fs->lock);
 
 	if (old_pwd.dentry)
 		path_put_longterm(&old_pwd);
@@ -68,8 +64,7 @@ void chroot_fs_refs(struct path *old_roo
 		task_lock(p);
 		fs = p->fs;
 		if (fs) {
-			spin_lock(&fs->lock);
-			write_seqcount_begin(&fs->seq);
+			write_seqlock(&fs->lock);
 			if (fs->root.dentry == old_root->dentry
 			    && fs->root.mnt == old_root->mnt) {
 				path_get_longterm(new_root);
@@ -82,8 +77,7 @@ void chroot_fs_refs(struct path *old_roo
 				fs->pwd = *new_root;
 				count++;
 			}
-			write_seqcount_end(&fs->seq);
-			spin_unlock(&fs->lock);
+			write_sequnlock(&fs->lock);
 		}
 		task_unlock(p);
 	} while_each_thread(g, p);
@@ -106,12 +100,10 @@ void exit_fs(struct task_struct *tsk)
 	if (fs) {
 		int kill;
 		task_lock(tsk);
-		spin_lock(&fs->lock);
-		write_seqcount_begin(&fs->seq);
+		write_seqlock(&fs->lock);
 		tsk->fs = NULL;
 		kill = !--fs->users;
-		write_seqcount_end(&fs->seq);
-		spin_unlock(&fs->lock);
+		write_sequnlock(&fs->lock);
 		task_unlock(tsk);
 		if (kill)
 			free_fs_struct(fs);
@@ -125,16 +117,15 @@ struct fs_struct *copy_fs_struct(struct 
 	if (fs) {
 		fs->users = 1;
 		fs->in_exec = 0;
-		spin_lock_init(&fs->lock);
-		seqcount_init(&fs->seq);
+		seqlock_init(&fs->lock);
 		fs->umask = old->umask;
 
-		spin_lock(&old->lock);
+		seq_spin_lock(&old->lock);
 		fs->root = old->root;
 		path_get_longterm(&fs->root);
 		fs->pwd = old->pwd;
 		path_get_longterm(&fs->pwd);
-		spin_unlock(&old->lock);
+		seq_spin_unlock(&old->lock);
 	}
 	return fs;
 }
@@ -149,10 +140,10 @@ int unshare_fs_struct(void)
 		return -ENOMEM;
 
 	task_lock(current);
-	spin_lock(&fs->lock);
+	seq_spin_lock(&fs->lock);
 	kill = !--fs->users;
 	current->fs = new_fs;
-	spin_unlock(&fs->lock);
+	seq_spin_unlock(&fs->lock);
 	task_unlock(current);
 
 	if (kill)
@@ -171,8 +162,7 @@ EXPORT_SYMBOL(current_umask);
 /* to be mentioned only in INIT_TASK */
 struct fs_struct init_fs = {
 	.users		= 1,
-	.lock		= __SPIN_LOCK_UNLOCKED(init_fs.lock),
-	.seq		= SEQCNT_ZERO,
+	.lock		= __SEQLOCK_UNLOCKED(init_fs.lock),
 	.umask		= 0022,
 };
 
@@ -185,14 +175,14 @@ void daemonize_fs_struct(void)
 
 		task_lock(current);
 
-		spin_lock(&init_fs.lock);
+		seq_spin_lock(&init_fs.lock);
 		init_fs.users++;
-		spin_unlock(&init_fs.lock);
+		seq_spin_unlock(&init_fs.lock);
 
-		spin_lock(&fs->lock);
+		seq_spin_lock(&fs->lock);
 		current->fs = &init_fs;
 		kill = !--fs->users;
-		spin_unlock(&fs->lock);
+		seq_spin_unlock(&fs->lock);
 
 		task_unlock(current);
 		if (kill)
Index: tip/fs/namei.c
===================================================================
--- tip.orig/fs/namei.c
+++ tip/fs/namei.c
@@ -427,7 +427,7 @@ static int unlazy_walk(struct nameidata 
 	BUG_ON(!(nd->flags & LOOKUP_RCU));
 	if (nd->root.mnt && !(nd->flags & LOOKUP_ROOT)) {
 		want_root = 1;
-		spin_lock(&fs->lock);
+		seq_spin_lock(&fs->lock);
 		if (nd->root.mnt != fs->root.mnt ||
 				nd->root.dentry != fs->root.dentry)
 			goto err_root;
@@ -457,7 +457,7 @@ static int unlazy_walk(struct nameidata 
 	spin_unlock(&parent->d_lock);
 	if (want_root) {
 		path_get(&nd->root);
-		spin_unlock(&fs->lock);
+		seq_spin_unlock(&fs->lock);
 	}
 	mntget(nd->path.mnt);
 
@@ -472,7 +472,7 @@ err_parent:
 	spin_unlock(&parent->d_lock);
 err_root:
 	if (want_root)
-		spin_unlock(&fs->lock);
+		seq_spin_unlock(&fs->lock);
 	return -ECHILD;
 }
 
@@ -566,10 +566,10 @@ static __always_inline void set_root_rcu
 		unsigned seq;
 
 		do {
-			seq = read_seqcount_begin(&fs->seq);
+			seq = read_seqbegin(&fs->lock);
 			nd->root = fs->root;
 			nd->seq = __read_seqcount_begin(&nd->root.dentry->d_seq);
-		} while (read_seqcount_retry(&fs->seq, seq));
+		} while (read_seqretry(&fs->lock, seq));
 	}
 }
 
@@ -1545,10 +1545,10 @@ static int path_init(int dfd, const char
 			rcu_read_lock();
 
 			do {
-				seq = read_seqcount_begin(&fs->seq);
+				seq = read_seqbegin(&fs->lock);
 				nd->path = fs->pwd;
 				nd->seq = __read_seqcount_begin(&nd->path.dentry->d_seq);
-			} while (read_seqcount_retry(&fs->seq, seq));
+			} while (read_seqretry(&fs->lock, seq));
 		} else {
 			get_fs_pwd(current->fs, &nd->path);
 		}
Index: tip/include/linux/fs_struct.h
===================================================================
--- tip.orig/include/linux/fs_struct.h
+++ tip/include/linux/fs_struct.h
@@ -2,13 +2,11 @@
 #define _LINUX_FS_STRUCT_H
 
 #include <linux/path.h>
-#include <linux/spinlock.h>
 #include <linux/seqlock.h>
 
 struct fs_struct {
 	int users;
-	spinlock_t lock;
-	seqcount_t seq;
+	seqlock_t lock;
 	int umask;
 	int in_exec;
 	struct path root, pwd;
@@ -26,29 +24,29 @@ extern int unshare_fs_struct(void);
 
 static inline void get_fs_root(struct fs_struct *fs, struct path *root)
 {
-	spin_lock(&fs->lock);
+	seq_spin_lock(&fs->lock);
 	*root = fs->root;
 	path_get(root);
-	spin_unlock(&fs->lock);
+	seq_spin_unlock(&fs->lock);
 }
 
 static inline void get_fs_pwd(struct fs_struct *fs, struct path *pwd)
 {
-	spin_lock(&fs->lock);
+	seq_spin_lock(&fs->lock);
 	*pwd = fs->pwd;
 	path_get(pwd);
-	spin_unlock(&fs->lock);
+	seq_spin_unlock(&fs->lock);
 }
 
 static inline void get_fs_root_and_pwd(struct fs_struct *fs, struct path *root,
 				       struct path *pwd)
 {
-	spin_lock(&fs->lock);
+	seq_spin_lock(&fs->lock);
 	*root = fs->root;
 	path_get(root);
 	*pwd = fs->pwd;
 	path_get(pwd);
-	spin_unlock(&fs->lock);
+	seq_spin_unlock(&fs->lock);
 }
 
 #endif /* _LINUX_FS_STRUCT_H */
Index: tip/kernel/fork.c
===================================================================
--- tip.orig/kernel/fork.c
+++ tip/kernel/fork.c
@@ -876,13 +876,13 @@ static int copy_fs(unsigned long clone_f
 	struct fs_struct *fs = current->fs;
 	if (clone_flags & CLONE_FS) {
 		/* tsk->fs is already what we want */
-		spin_lock(&fs->lock);
+		seq_spin_lock(&fs->lock);
 		if (fs->in_exec) {
-			spin_unlock(&fs->lock);
+			seq_spin_unlock(&fs->lock);
 			return -EAGAIN;
 		}
 		fs->users++;
-		spin_unlock(&fs->lock);
+		seq_spin_unlock(&fs->lock);
 		return 0;
 	}
 	tsk->fs = copy_fs_struct(fs);
@@ -1757,13 +1757,13 @@ SYSCALL_DEFINE1(unshare, unsigned long, 
 
 		if (new_fs) {
 			fs = current->fs;
-			spin_lock(&fs->lock);
+			seq_spin_lock(&fs->lock);
 			current->fs = new_fs;
 			if (--fs->users)
 				new_fs = NULL;
 			else
 				new_fs = fs;
-			spin_unlock(&fs->lock);
+			seq_spin_unlock(&fs->lock);
 		}
 
 		if (new_fd) {


