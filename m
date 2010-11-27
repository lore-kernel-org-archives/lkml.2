Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753846Ab0K0KdN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Nov 2010 05:33:13 -0500
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:34802 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752803Ab0K0K0O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Nov 2010 05:26:14 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAO1p8Ex5Lcx2/2dsb2JhbACjC3K9doVHBIph
Message-Id: <d44ddcf1d1e0813b3ce2b3872c7c702a31b62894.1290852959.git.npiggin@kernel.dk>
In-Reply-To: <cover.1290852958.git.npiggin@kernel.dk>
References: <cover.1290852958.git.npiggin@kernel.dk>
From: Nick Piggin <npiggin@kernel.dk>
Date: Sat, 27 Nov 2010 20:44:47 +1100
Subject: [PATCH 17/46] fs: Use rename lock and RCU for multi-step operations
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The remaining usages for dcache_lock is to allow atomic, multi-step read-side
operations over the directory tree by excluding modifications to the tree.
Also, to walk in the leaf->root direction in the tree where we don't have
a natural d_lock ordering.

This could be accomplished by taking every d_lock, but this would mean a
huge number of locks and actually gets very tricky.

Solve this instead by using the rename seqlock for multi-step read-side
operations, retry in case of a rename so we don't walk up the wrong parent.
Concurrent dentry insertions are not serialised against.  Concurrent deletes
are tricky when walking up the directory: our parent might have been deleted
when dropping locks so also need to check and retry for that.

We can also use the rename lock in cases where livelock is a worry (and it
is introduced in subsequent patch).

Signed-off-by: Nick Piggin <npiggin@kernel.dk>
---
 drivers/staging/pohmelfs/path_entry.c |   15 +++-
 fs/autofs4/waitq.c                    |   18 ++++-
 fs/dcache.c                           |  136 +++++++++++++++++++++++++++------
 fs/nfs/namespace.c                    |   14 +++-
 include/linux/dcache.h                |    1 +
 5 files changed, 153 insertions(+), 31 deletions(-)

diff --git a/drivers/staging/pohmelfs/path_entry.c b/drivers/staging/pohmelfs/path_entry.c
index 8ec83d2..bbe42f4 100644
--- a/drivers/staging/pohmelfs/path_entry.c
+++ b/drivers/staging/pohmelfs/path_entry.c
@@ -83,10 +83,11 @@ out:
 int pohmelfs_path_length(struct pohmelfs_inode *pi)
 {
 	struct dentry *d, *root, *first;
-	int len = 1; /* Root slash */
+	int len;
+	unsigned seq;
 
-	first = d = d_find_alias(&pi->vfs_inode);
-	if (!d) {
+	first = d_find_alias(&pi->vfs_inode);
+	if (!first) {
 		dprintk("%s: ino: %llu, mode: %o.\n", __func__, pi->ino, pi->vfs_inode.i_mode);
 		return -ENOENT;
 	}
@@ -95,6 +96,11 @@ int pohmelfs_path_length(struct pohmelfs_inode *pi)
 	root = dget(current->fs->root.dentry);
 	spin_unlock(&current->fs->lock);
 
+rename_retry:
+	len = 1; /* Root slash */
+	d = first;
+	seq = read_seqbegin(&rename_lock);
+	rcu_read_lock();
 	spin_lock(&dcache_lock);
 
 	if (!IS_ROOT(d) && d_unhashed(d))
@@ -105,6 +111,9 @@ int pohmelfs_path_length(struct pohmelfs_inode *pi)
 		d = d->d_parent;
 	}
 	spin_unlock(&dcache_lock);
+	rcu_read_unlock();
+	if (read_seqretry(&rename_lock, seq))
+		goto rename_retry;
 
 	dput(root);
 	dput(first);
diff --git a/fs/autofs4/waitq.c b/fs/autofs4/waitq.c
index 2341375..4be8f77 100644
--- a/fs/autofs4/waitq.c
+++ b/fs/autofs4/waitq.c
@@ -186,16 +186,25 @@ static int autofs4_getpath(struct autofs_sb_info *sbi,
 {
 	struct dentry *root = sbi->sb->s_root;
 	struct dentry *tmp;
-	char *buf = *name;
+	char *buf;
 	char *p;
-	int len = 0;
-
+	int len;
+	unsigned seq;
+
+rename_retry:
+	buf = *name;
+	len = 0;
+	seq = read_seqbegin(&rename_lock);
+	rcu_read_lock();
 	spin_lock(&dcache_lock);
 	for (tmp = dentry ; tmp != root ; tmp = tmp->d_parent)
 		len += tmp->d_name.len + 1;
 
 	if (!len || --len > NAME_MAX) {
 		spin_unlock(&dcache_lock);
+		rcu_read_unlock();
+		if (read_seqretry(&rename_lock, seq))
+			goto rename_retry;
 		return 0;
 	}
 
@@ -209,6 +218,9 @@ static int autofs4_getpath(struct autofs_sb_info *sbi,
 		strncpy(p, tmp->d_name.name, tmp->d_name.len);
 	}
 	spin_unlock(&dcache_lock);
+	rcu_read_unlock();
+	if (read_seqretry(&rename_lock, seq))
+		goto rename_retry;
 
 	return len;
 }
diff --git a/fs/dcache.c b/fs/dcache.c
index 4c6f553..35420f7 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -80,6 +80,7 @@ static __cacheline_aligned_in_smp DEFINE_SPINLOCK(dcache_lru_lock);
 __cacheline_aligned_in_smp DEFINE_SPINLOCK(dcache_lock);
 __cacheline_aligned_in_smp DEFINE_SEQLOCK(rename_lock);
 
+EXPORT_SYMBOL(rename_lock);
 EXPORT_SYMBOL(dcache_inode_lock);
 EXPORT_SYMBOL(dcache_hash_lock);
 EXPORT_SYMBOL(dcache_lock);
@@ -237,6 +238,7 @@ static struct dentry *d_kill(struct dentry *dentry, struct dentry *parent)
 	__releases(dcache_inode_lock)
 	__releases(dcache_lock)
 {
+	dentry->d_parent = NULL;
 	list_del(&dentry->d_u.d_child);
 	if (parent)
 		spin_unlock(&parent->d_lock);
@@ -980,11 +982,15 @@ void shrink_dcache_for_umount(struct super_block *sb)
  * Return true if the parent or its subdirectories contain
  * a mount point
  */
- 
 int have_submounts(struct dentry *parent)
 {
-	struct dentry *this_parent = parent;
+	struct dentry *this_parent;
 	struct list_head *next;
+	unsigned seq;
+
+rename_retry:
+	this_parent = parent;
+	seq = read_seqbegin(&rename_lock);
 
 	spin_lock(&dcache_lock);
 	if (d_mountpoint(parent))
@@ -1018,17 +1024,37 @@ resume:
 	 * All done at this level ... ascend and resume the search.
 	 */
 	if (this_parent != parent) {
-		next = this_parent->d_u.d_child.next;
+		struct dentry *tmp;
+		struct dentry *child;
+
+		tmp = this_parent->d_parent;
+		rcu_read_lock();
 		spin_unlock(&this_parent->d_lock);
-		this_parent = this_parent->d_parent;
+		child = this_parent;
+		this_parent = tmp;
 		spin_lock(&this_parent->d_lock);
+		/* might go back up the wrong parent if we have had a rename
+		 * or deletion */
+		if (this_parent != child->d_parent ||
+				read_seqretry(&rename_lock, seq)) {
+			spin_unlock(&this_parent->d_lock);
+			spin_unlock(&dcache_lock);
+			rcu_read_unlock();
+			goto rename_retry;
+		}
+		rcu_read_unlock();
+		next = child->d_u.d_child.next;
 		goto resume;
 	}
 	spin_unlock(&this_parent->d_lock);
 	spin_unlock(&dcache_lock);
+	if (read_seqretry(&rename_lock, seq))
+		goto rename_retry;
 	return 0; /* No mount points found in tree */
 positive:
 	spin_unlock(&dcache_lock);
+	if (read_seqretry(&rename_lock, seq))
+		goto rename_retry;
 	return 1;
 }
 EXPORT_SYMBOL(have_submounts);
@@ -1049,10 +1075,15 @@ EXPORT_SYMBOL(have_submounts);
  */
 static int select_parent(struct dentry * parent)
 {
-	struct dentry *this_parent = parent;
+	struct dentry *this_parent;
 	struct list_head *next;
+	unsigned seq;
 	int found = 0;
 
+rename_retry:
+	this_parent = parent;
+	seq = read_seqbegin(&rename_lock);
+
 	spin_lock(&dcache_lock);
 	spin_lock(&this_parent->d_lock);
 repeat:
@@ -1062,7 +1093,6 @@ resume:
 		struct list_head *tmp = next;
 		struct dentry *dentry = list_entry(tmp, struct dentry, d_u.d_child);
 		next = tmp->next;
-		BUG_ON(this_parent == dentry);
 
 		spin_lock_nested(&dentry->d_lock, DENTRY_D_LOCK_NESTED);
 
@@ -1105,17 +1135,32 @@ resume:
 	 */
 	if (this_parent != parent) {
 		struct dentry *tmp;
-		next = this_parent->d_u.d_child.next;
+		struct dentry *child;
+
 		tmp = this_parent->d_parent;
+		rcu_read_lock();
 		spin_unlock(&this_parent->d_lock);
-		BUG_ON(tmp == this_parent);
+		child = this_parent;
 		this_parent = tmp;
 		spin_lock(&this_parent->d_lock);
+		/* might go back up the wrong parent if we have had a rename
+		 * or deletion */
+		if (this_parent != child->d_parent ||
+				read_seqretry(&rename_lock, seq)) {
+			spin_unlock(&this_parent->d_lock);
+			spin_unlock(&dcache_lock);
+			rcu_read_unlock();
+			goto rename_retry;
+		}
+		rcu_read_unlock();
+		next = child->d_u.d_child.next;
 		goto resume;
 	}
 out:
 	spin_unlock(&this_parent->d_lock);
 	spin_unlock(&dcache_lock);
+	if (read_seqretry(&rename_lock, seq))
+		goto rename_retry;
 	return found;
 }
 
@@ -1615,7 +1660,7 @@ EXPORT_SYMBOL(d_add_ci);
 struct dentry * d_lookup(struct dentry * parent, struct qstr * name)
 {
 	struct dentry * dentry = NULL;
-	unsigned long seq;
+	unsigned seq;
 
         do {
                 seq = read_seqbegin(&rename_lock);
@@ -2225,7 +2270,7 @@ static int prepend_name(char **buffer, int *buflen, struct qstr *name)
  * @buffer: pointer to the end of the buffer
  * @buflen: pointer to buffer length
  *
- * Caller holds the dcache_lock.
+ * Caller holds the rename_lock.
  *
  * If path is not reachable from the supplied root, then the value of
  * root is changed (without modifying refcounts).
@@ -2310,7 +2355,9 @@ char *__d_path(const struct path *path, struct path *root,
 
 	prepend(&res, &buflen, "\0", 1);
 	spin_lock(&dcache_lock);
+	write_seqlock(&rename_lock);
 	error = prepend_path(path, root, &res, &buflen);
+	write_sequnlock(&rename_lock);
 	spin_unlock(&dcache_lock);
 
 	if (error)
@@ -2374,10 +2421,12 @@ char *d_path(const struct path *path, char *buf, int buflen)
 
 	get_fs_root(current->fs, &root);
 	spin_lock(&dcache_lock);
+	write_seqlock(&rename_lock);
 	tmp = root;
 	error = path_with_deleted(path, &tmp, &res, &buflen);
 	if (error)
 		res = ERR_PTR(error);
+	write_sequnlock(&rename_lock);
 	spin_unlock(&dcache_lock);
 	path_put(&root);
 	return res;
@@ -2405,10 +2454,12 @@ char *d_path_with_unreachable(const struct path *path, char *buf, int buflen)
 
 	get_fs_root(current->fs, &root);
 	spin_lock(&dcache_lock);
+	write_seqlock(&rename_lock);
 	tmp = root;
 	error = path_with_deleted(path, &tmp, &res, &buflen);
 	if (!error && !path_equal(&tmp, &root))
 		error = prepend_unreachable(&res, &buflen);
+	write_sequnlock(&rename_lock);
 	spin_unlock(&dcache_lock);
 	path_put(&root);
 	if (error)
@@ -2474,7 +2525,9 @@ char *dentry_path_raw(struct dentry *dentry, char *buf, int buflen)
 	char *retval;
 
 	spin_lock(&dcache_lock);
+	write_seqlock(&rename_lock);
 	retval = __dentry_path(dentry, buf, buflen);
+	write_sequnlock(&rename_lock);
 	spin_unlock(&dcache_lock);
 
 	return retval;
@@ -2487,6 +2540,7 @@ char *dentry_path(struct dentry *dentry, char *buf, int buflen)
 	char *retval;
 
 	spin_lock(&dcache_lock);
+	write_seqlock(&rename_lock);
 	if (d_unlinked(dentry)) {
 		p = buf + buflen;
 		if (prepend(&p, &buflen, "//deleted", 10) != 0)
@@ -2494,6 +2548,7 @@ char *dentry_path(struct dentry *dentry, char *buf, int buflen)
 		buflen++;
 	}
 	retval = __dentry_path(dentry, buf, buflen);
+	write_sequnlock(&rename_lock);
 	spin_unlock(&dcache_lock);
 	if (!IS_ERR(retval) && p)
 		*p = '/';	/* restore '/' overriden with '\0' */
@@ -2534,6 +2589,7 @@ SYSCALL_DEFINE2(getcwd, char __user *, buf, unsigned long, size)
 
 	error = -ENOENT;
 	spin_lock(&dcache_lock);
+	write_seqlock(&rename_lock);
 	if (!d_unlinked(pwd.dentry)) {
 		unsigned long len;
 		struct path tmp = root;
@@ -2542,6 +2598,7 @@ SYSCALL_DEFINE2(getcwd, char __user *, buf, unsigned long, size)
 
 		prepend(&cwd, &buflen, "\0", 1);
 		error = prepend_path(&pwd, &tmp, &cwd, &buflen);
+		write_sequnlock(&rename_lock);
 		spin_unlock(&dcache_lock);
 
 		if (error)
@@ -2561,8 +2618,10 @@ SYSCALL_DEFINE2(getcwd, char __user *, buf, unsigned long, size)
 			if (copy_to_user(buf, cwd, len))
 				error = -EFAULT;
 		}
-	} else
+	} else {
+		write_sequnlock(&rename_lock);
 		spin_unlock(&dcache_lock);
+	}
 
 out:
 	path_put(&pwd);
@@ -2590,25 +2649,25 @@ out:
 int is_subdir(struct dentry *new_dentry, struct dentry *old_dentry)
 {
 	int result;
-	unsigned long seq;
+	unsigned seq;
 
 	if (new_dentry == old_dentry)
 		return 1;
 
-	/*
-	 * Need rcu_readlock to protect against the d_parent trashing
-	 * due to d_move
-	 */
-	rcu_read_lock();
 	do {
 		/* for restarting inner loop in case of seq retry */
 		seq = read_seqbegin(&rename_lock);
+		/*
+		 * Need rcu_readlock to protect against the d_parent trashing
+		 * due to d_move
+		 */
+		rcu_read_lock();
 		if (d_ancestor(old_dentry, new_dentry))
 			result = 1;
 		else
 			result = 0;
+		rcu_read_unlock();
 	} while (read_seqretry(&rename_lock, seq));
-	rcu_read_unlock();
 
 	return result;
 }
@@ -2640,9 +2699,13 @@ EXPORT_SYMBOL(path_is_under);
 
 void d_genocide(struct dentry *root)
 {
-	struct dentry *this_parent = root;
+	struct dentry *this_parent;
 	struct list_head *next;
+	unsigned seq;
 
+rename_retry:
+	this_parent = root;
+	seq = read_seqbegin(&rename_lock);
 	spin_lock(&dcache_lock);
 	spin_lock(&this_parent->d_lock);
 repeat:
@@ -2652,6 +2715,7 @@ resume:
 		struct list_head *tmp = next;
 		struct dentry *dentry = list_entry(tmp, struct dentry, d_u.d_child);
 		next = tmp->next;
+
 		spin_lock_nested(&dentry->d_lock, DENTRY_D_LOCK_NESTED);
 		if (d_unhashed(dentry) || !dentry->d_inode) {
 			spin_unlock(&dentry->d_lock);
@@ -2664,19 +2728,43 @@ resume:
 			spin_acquire(&this_parent->d_lock.dep_map, 0, 1, _RET_IP_);
 			goto repeat;
 		}
- 		dentry->d_count--;
+		if (!(dentry->d_flags & DCACHE_GENOCIDE)) {
+			dentry->d_flags |= DCACHE_GENOCIDE;
+			dentry->d_count--;
+		}
  		spin_unlock(&dentry->d_lock);
 	}
 	if (this_parent != root) {
-		next = this_parent->d_u.d_child.next;
-		this_parent->d_count--;
+		struct dentry *tmp;
+		struct dentry *child;
+
+		tmp = this_parent->d_parent;
+		if (!(this_parent->d_flags & DCACHE_GENOCIDE)) {
+			this_parent->d_flags |= DCACHE_GENOCIDE;
+			this_parent->d_count--;
+		}
+		rcu_read_lock();
 		spin_unlock(&this_parent->d_lock);
-		this_parent = this_parent->d_parent;
-		spin_lock(&this_parent->d_lock);
+		child = this_parent;
+		this_parent = tmp;
+ 		spin_lock(&this_parent->d_lock);
+		/* might go back up the wrong parent if we have had a rename
+		 * or deletion */
+		if (this_parent != child->d_parent ||
+				read_seqretry(&rename_lock, seq)) {
+			spin_unlock(&this_parent->d_lock);
+			spin_unlock(&dcache_lock);
+			rcu_read_unlock();
+			goto rename_retry;
+		}
+		rcu_read_unlock();
+		next = child->d_u.d_child.next;
 		goto resume;
 	}
 	spin_unlock(&this_parent->d_lock);
 	spin_unlock(&dcache_lock);
+	if (read_seqretry(&rename_lock, seq))
+		goto rename_retry;
 }
 
 /**
diff --git a/fs/nfs/namespace.c b/fs/nfs/namespace.c
index db6aa36..78c0ebb 100644
--- a/fs/nfs/namespace.c
+++ b/fs/nfs/namespace.c
@@ -49,11 +49,17 @@ char *nfs_path(const char *base,
 	       const struct dentry *dentry,
 	       char *buffer, ssize_t buflen)
 {
-	char *end = buffer+buflen;
+	char *end;
 	int namelen;
+	unsigned seq;
 
+rename_retry:
+	end = buffer+buflen;
 	*--end = '\0';
 	buflen--;
+
+	seq = read_seqbegin(&rename_lock);
+	rcu_read_lock();
 	spin_lock(&dcache_lock);
 	while (!IS_ROOT(dentry) && dentry != droot) {
 		namelen = dentry->d_name.len;
@@ -66,6 +72,9 @@ char *nfs_path(const char *base,
 		dentry = dentry->d_parent;
 	}
 	spin_unlock(&dcache_lock);
+	rcu_read_unlock();
+	if (read_seqretry(&rename_lock, seq))
+		goto rename_retry;
 	if (*end != '/') {
 		if (--buflen < 0)
 			goto Elong;
@@ -83,6 +92,9 @@ char *nfs_path(const char *base,
 	return end;
 Elong_unlock:
 	spin_unlock(&dcache_lock);
+	rcu_read_unlock();
+	if (read_seqretry(&rename_lock, seq))
+		goto rename_retry;
 Elong:
 	return ERR_PTR(-ENAMETOOLONG);
 }
diff --git a/include/linux/dcache.h b/include/linux/dcache.h
index b23b64e..f9b5744 100644
--- a/include/linux/dcache.h
+++ b/include/linux/dcache.h
@@ -180,6 +180,7 @@ struct dentry_operations {
 #define DCACHE_FSNOTIFY_PARENT_WATCHED	0x0080 /* Parent inode is watched by some fsnotify listener */
 
 #define DCACHE_CANT_MOUNT	0x0100
+#define DCACHE_GENOCIDE		0x0200
 
 extern spinlock_t dcache_inode_lock;
 extern spinlock_t dcache_hash_lock;
-- 
1.7.1

