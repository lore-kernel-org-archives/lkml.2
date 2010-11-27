Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753476Ab0K0K1N (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Nov 2010 05:27:13 -0500
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:6979 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753334Ab0K0K1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Nov 2010 05:27:07 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAO1p8Ex5Lcx2/2dsb2JhbACjC3K9doJ0glMEimGFFA
Message-Id: <5c27a30f9abfb0efe7ec9e6ce2ddadca37110980.1290852959.git.npiggin@kernel.dk>
In-Reply-To: <cover.1290852958.git.npiggin@kernel.dk>
References: <cover.1290852958.git.npiggin@kernel.dk>
From: Nick Piggin <npiggin@kernel.dk>
Date: Sat, 27 Nov 2010 20:45:04 +1100
Subject: [PATCH 34/46] fs: fs_struct use seqlock
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use a seqlock in the fs_struct to enable us to take an atomic copy of the
complete cwd and root paths. Use this in the RCU lookup path to avoid a
thread-shared spinlock in RCU lookup operations.

Signed-off-by: Nick Piggin <npiggin@kernel.dk>
---
 fs/fs_struct.c            |   10 ++++++++++
 fs/namei.c                |   36 ++++++++++++++++++++++--------------
 include/linux/fs_struct.h |    3 +++
 3 files changed, 35 insertions(+), 14 deletions(-)

diff --git a/fs/fs_struct.c b/fs/fs_struct.c
index ed45a9c..60b8531 100644
--- a/fs/fs_struct.c
+++ b/fs/fs_struct.c
@@ -14,9 +14,11 @@ void set_fs_root(struct fs_struct *fs, struct path *path)
 	struct path old_root;
 
 	spin_lock(&fs->lock);
+	write_seqcount_begin(&fs->seq);
 	old_root = fs->root;
 	fs->root = *path;
 	path_get(path);
+	write_seqcount_end(&fs->seq);
 	spin_unlock(&fs->lock);
 	if (old_root.dentry)
 		path_put(&old_root);
@@ -31,9 +33,11 @@ void set_fs_pwd(struct fs_struct *fs, struct path *path)
 	struct path old_pwd;
 
 	spin_lock(&fs->lock);
+	write_seqcount_begin(&fs->seq);
 	old_pwd = fs->pwd;
 	fs->pwd = *path;
 	path_get(path);
+	write_seqcount_end(&fs->seq);
 	spin_unlock(&fs->lock);
 
 	if (old_pwd.dentry)
@@ -52,6 +56,7 @@ void chroot_fs_refs(struct path *old_root, struct path *new_root)
 		fs = p->fs;
 		if (fs) {
 			spin_lock(&fs->lock);
+			write_seqcount_begin(&fs->seq);
 			if (fs->root.dentry == old_root->dentry
 			    && fs->root.mnt == old_root->mnt) {
 				path_get(new_root);
@@ -64,6 +69,7 @@ void chroot_fs_refs(struct path *old_root, struct path *new_root)
 				fs->pwd = *new_root;
 				count++;
 			}
+			write_seqcount_end(&fs->seq);
 			spin_unlock(&fs->lock);
 		}
 		task_unlock(p);
@@ -88,8 +94,10 @@ void exit_fs(struct task_struct *tsk)
 		int kill;
 		task_lock(tsk);
 		spin_lock(&fs->lock);
+		write_seqcount_begin(&fs->seq);
 		tsk->fs = NULL;
 		kill = !--fs->users;
+		write_seqcount_end(&fs->seq);
 		spin_unlock(&fs->lock);
 		task_unlock(tsk);
 		if (kill)
@@ -105,6 +113,7 @@ struct fs_struct *copy_fs_struct(struct fs_struct *old)
 		fs->users = 1;
 		fs->in_exec = 0;
 		spin_lock_init(&fs->lock);
+		seqcount_init(&fs->seq);
 		fs->umask = old->umask;
 		get_fs_root_and_pwd(old, &fs->root, &fs->pwd);
 	}
@@ -144,6 +153,7 @@ EXPORT_SYMBOL(current_umask);
 struct fs_struct init_fs = {
 	.users		= 1,
 	.lock		= __SPIN_LOCK_UNLOCKED(init_fs.lock),
+	.seq		= SEQCNT_ZERO,
 	.umask		= 0022,
 };
 
diff --git a/fs/namei.c b/fs/namei.c
index 5185752..c48d208 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -640,9 +640,12 @@ static __always_inline void set_root_rcu(struct nameidata *nd)
 {
 	if (!nd->root.mnt) {
 		struct fs_struct *fs = current->fs;
-		spin_lock(&fs->lock);
-		nd->root = fs->root;
-		spin_unlock(&fs->lock);
+		unsigned seq;
+
+		do {
+			seq = read_seqcount_begin(&fs->seq);
+			nd->root = fs->root;
+		} while (read_seqcount_retry(&fs->seq, seq));
 	}
 }
 
@@ -1324,26 +1327,31 @@ static int path_init_rcu(int dfd, const char *name, unsigned int flags, struct n
 
 	if (*name=='/') {
 		struct fs_struct *fs = current->fs;
+		unsigned seq;
 
 		br_read_lock(vfsmount_lock);
 		rcu_read_lock();
 
-		spin_lock(&fs->lock);
-		nd->root = fs->root;
-		nd->path = nd->root;
-		nd->seq = read_seqcount_begin(&nd->path.dentry->d_seq);
-		spin_unlock(&fs->lock);
+		do {
+			seq = read_seqcount_begin(&fs->seq);
+			nd->root = fs->root;
+			nd->path = nd->root;
+			nd->seq = __read_seqcount_begin(&nd->path.dentry->d_seq);
+		} while (read_seqcount_retry(&fs->seq, seq));
 
 	} else if (dfd == AT_FDCWD) {
 		struct fs_struct *fs = current->fs;
+		unsigned seq;
 
 		br_read_lock(vfsmount_lock);
 		rcu_read_lock();
 
-		spin_lock(&fs->lock);
-		nd->path = fs->pwd;
-		nd->seq = read_seqcount_begin(&nd->path.dentry->d_seq);
-		spin_unlock(&fs->lock);
+		do {
+			seq = read_seqcount_begin(&fs->seq);
+			nd->path = fs->pwd;
+			nd->seq = __read_seqcount_begin(&nd->path.dentry->d_seq);
+		} while (read_seqcount_retry(&fs->seq, seq));
+
 	} else {
 		struct dentry *dentry;
 
@@ -1366,7 +1374,7 @@ static int path_init_rcu(int dfd, const char *name, unsigned int flags, struct n
 		if (fput_needed)
 			nd->file = file;
 
-		nd->seq = read_seqcount_begin(&nd->path.dentry->d_seq);
+		nd->seq = __read_seqcount_begin(&nd->path.dentry->d_seq);
 		br_read_lock(vfsmount_lock);
 		rcu_read_lock();
 	}
@@ -2199,7 +2207,7 @@ creat:
 	if (error)
 		goto out_filp;
 	error = path_walk_rcu(pathname, &nd);
-	path_finish_rcu(&nd);
+	path_finish_rcu(&nd); /* XXX: ok to throw out root here?? */
 	if (unlikely(error == -ECHILD || error == -ESTALE)) {
 		/* slower, locked walk */
 		if (error == -ESTALE) {
diff --git a/include/linux/fs_struct.h b/include/linux/fs_struct.h
index a42b5bf..003dc0f 100644
--- a/include/linux/fs_struct.h
+++ b/include/linux/fs_struct.h
@@ -2,10 +2,13 @@
 #define _LINUX_FS_STRUCT_H
 
 #include <linux/path.h>
+#include <linux/spinlock.h>
+#include <linux/seqlock.h>
 
 struct fs_struct {
 	int users;
 	spinlock_t lock;
+	seqcount_t seq;
 	int umask;
 	int in_exec;
 	struct path root, pwd;
-- 
1.7.1

