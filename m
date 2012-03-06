Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756218Ab2CFQV6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 11:21:58 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:14848 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755742Ab2CFQTw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 11:19:52 -0500
X-Authority-Analysis: v=2.0 cv=d9t3OGfE c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=UBy9sU4F98IA:10 a=6iVrTBwxlv8A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=CjxXgO3LAAAA:8 a=0ntXfJu0GYAOtdxmhyMA:9 a=xkOOQvSjkQoM9-P8f_oA:7 a=Zh68SRI7RUMA:10 a=jeBq3FmKZ4MA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120306161949.574358808@goodmis.org>
User-Agent: quilt/0.50-1
Date: Tue, 06 Mar 2012 11:16:49 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>, stable-rt@vger.kernel.org
Subject: [PATCH RT 13/25][RFC 3.0.23-rt39-rc1] fs: fs_struct use seqlock
References: <20120306161636.491172179@goodmis.org>
Content-Disposition: inline; filename=0013-fs-fs_struct-use-seqlock.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

Replace the open coded seqlock with a real one, so RT can handle it.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable-rt@vger.kernel.org
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 fs/exec.c                 |    4 +-
 fs/fhandle.c              |    4 +-
 fs/fs_struct.c            |   46 +++++++++++++++++---------------------------
 fs/namei.c                |   14 ++++++------
 include/linux/fs_struct.h |   16 ++++++--------
 kernel/fork.c             |   10 ++++----
 6 files changed, 41 insertions(+), 53 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index 709557e..3116940 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1230,7 +1230,7 @@ int check_unsafe_exec(struct linux_binprm *bprm)
 	bprm->unsafe = tracehook_unsafe_exec(p);
 
 	n_fs = 1;
-	spin_lock(&p->fs->lock);
+	seq_spin_lock(&p->fs->lock);
 	rcu_read_lock();
 	for (t = next_thread(p); t != p; t = next_thread(t)) {
 		if (t->fs == p->fs)
@@ -1247,7 +1247,7 @@ int check_unsafe_exec(struct linux_binprm *bprm)
 			res = 1;
 		}
 	}
-	spin_unlock(&p->fs->lock);
+	seq_spin_unlock(&p->fs->lock);
 
 	return res;
 }
diff --git a/fs/fhandle.c b/fs/fhandle.c
index 6b08864..9f437ac 100644
--- a/fs/fhandle.c
+++ b/fs/fhandle.c
@@ -115,10 +115,10 @@ static struct vfsmount *get_vfsmount_from_fd(int fd)
 
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
diff --git a/fs/fs_struct.c b/fs/fs_struct.c
index 78b519c..84db5f1 100644
--- a/fs/fs_struct.c
+++ b/fs/fs_struct.c
@@ -26,13 +26,11 @@ void set_fs_root(struct fs_struct *fs, struct path *path)
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
@@ -45,13 +43,11 @@ void set_fs_pwd(struct fs_struct *fs, struct path *path)
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
@@ -68,8 +64,7 @@ void chroot_fs_refs(struct path *old_root, struct path *new_root)
 		task_lock(p);
 		fs = p->fs;
 		if (fs) {
-			spin_lock(&fs->lock);
-			write_seqcount_begin(&fs->seq);
+			write_seqlock(&fs->lock);
 			if (fs->root.dentry == old_root->dentry
 			    && fs->root.mnt == old_root->mnt) {
 				path_get_longterm(new_root);
@@ -82,8 +77,7 @@ void chroot_fs_refs(struct path *old_root, struct path *new_root)
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
@@ -125,16 +117,15 @@ struct fs_struct *copy_fs_struct(struct fs_struct *old)
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
diff --git a/fs/namei.c b/fs/namei.c
index f7593c0..b364372 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -424,7 +424,7 @@ static int unlazy_walk(struct nameidata *nd, struct dentry *dentry)
 	BUG_ON(!(nd->flags & LOOKUP_RCU));
 	if (nd->root.mnt && !(nd->flags & LOOKUP_ROOT)) {
 		want_root = 1;
-		spin_lock(&fs->lock);
+		seq_spin_lock(&fs->lock);
 		if (nd->root.mnt != fs->root.mnt ||
 				nd->root.dentry != fs->root.dentry)
 			goto err_root;
@@ -454,7 +454,7 @@ static int unlazy_walk(struct nameidata *nd, struct dentry *dentry)
 	spin_unlock(&parent->d_lock);
 	if (want_root) {
 		path_get(&nd->root);
-		spin_unlock(&fs->lock);
+		seq_spin_unlock(&fs->lock);
 	}
 	mntget(nd->path.mnt);
 
@@ -469,7 +469,7 @@ err_parent:
 	spin_unlock(&parent->d_lock);
 err_root:
 	if (want_root)
-		spin_unlock(&fs->lock);
+		seq_spin_unlock(&fs->lock);
 	return -ECHILD;
 }
 
@@ -619,10 +619,10 @@ static __always_inline void set_root_rcu(struct nameidata *nd)
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
 
@@ -1501,10 +1501,10 @@ static int path_init(int dfd, const char *name, unsigned int flags,
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
diff --git a/include/linux/fs_struct.h b/include/linux/fs_struct.h
index 003dc0f..f748403 100644
--- a/include/linux/fs_struct.h
+++ b/include/linux/fs_struct.h
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
diff --git a/kernel/fork.c b/kernel/fork.c
index 0429130..1643f63 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -856,13 +856,13 @@ static int copy_fs(unsigned long clone_flags, struct task_struct *tsk)
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
@@ -1729,13 +1729,13 @@ SYSCALL_DEFINE1(unshare, unsigned long, unshare_flags)
 
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
-- 
1.7.8.3


