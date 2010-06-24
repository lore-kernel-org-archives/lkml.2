Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754509Ab0FXDQ0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 23:16:26 -0400
Received: from cantor.suse.de ([195.135.220.2]:48441 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754078Ab0FXDPq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 23:15:46 -0400
Message-Id: <20100624030728.129875799@suse.de>
User-Agent: quilt/0.48-4.4
Date: Thu, 24 Jun 2010 13:02:28 +1000
From: npiggin@suse.de
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: John Stultz <johnstul@us.ibm.com>, Frank Mayhar <fmayhar@google.com>
Subject: [patch 16/52] fs: dcache RCU for multi-step operaitons
References: <20100624030212.676457061@suse.de>
Content-Disposition: inline; filename=fs-dcache_lock-multi-step.patch
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
operations. Insert operations are not serialised. Delete operations are
tricky when walking up the directory our parent might have been deleted
when dropping locks so also need to check and retry for that.

XXX: hmm, we could of course just take the rename lock if there is any worry
about livelock. Most of these are slow paths.

Signed-off-by: Nick Piggin <npiggin@suse.de>
---
 drivers/staging/pohmelfs/path_entry.c |   15 ++-
 fs/autofs4/waitq.c                    |   16 +++
 fs/dcache.c                           |  151 +++++++++++++++++++++++++++-------
 fs/nfs/namespace.c                    |   14 ++-
 fs/seq_file.c                         |    1 
 5 files changed, 163 insertions(+), 34 deletions(-)

Index: linux-2.6/fs/dcache.c
===================================================================
--- linux-2.6.orig/fs/dcache.c
+++ linux-2.6/fs/dcache.c
@@ -80,6 +80,7 @@ static __cacheline_aligned_in_smp DEFINE
 __cacheline_aligned_in_smp DEFINE_SPINLOCK(dcache_lock);
 __cacheline_aligned_in_smp DEFINE_SEQLOCK(rename_lock);
 
+EXPORT_SYMBOL(rename_lock);
 EXPORT_SYMBOL(dcache_inode_lock);
 EXPORT_SYMBOL(dcache_hash_lock);
 EXPORT_SYMBOL(dcache_lock);
@@ -961,11 +962,15 @@ void shrink_dcache_for_umount(struct sup
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
@@ -999,17 +1004,38 @@ resume:
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
+				// d_unlinked(this_parent) || XXX
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
@@ -1030,9 +1056,15 @@ EXPORT_SYMBOL(have_submounts);
  */
 static int select_parent(struct dentry * parent)
 {
-	struct dentry *this_parent = parent;
+	struct dentry *this_parent;
 	struct list_head *next;
-	int found = 0;
+	unsigned seq;
+	int found;
+
+rename_retry:
+	found = 0;
+	this_parent = parent;
+	seq = read_seqbegin(&rename_lock);
 
 	spin_lock(&dcache_lock);
 	spin_lock(&this_parent->d_lock);
@@ -1043,7 +1075,6 @@ resume:
 		struct list_head *tmp = next;
 		struct dentry *dentry = list_entry(tmp, struct dentry, d_u.d_child);
 		next = tmp->next;
-		BUG_ON(this_parent == dentry);
 
 		spin_lock_nested(&dentry->d_lock, DENTRY_D_LOCK_NESTED);
 		dentry_lru_del_init(dentry);
@@ -1084,17 +1115,33 @@ resume:
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
+				// d_unlinked(this_parent) || XXX
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
 
@@ -1606,7 +1653,7 @@ EXPORT_SYMBOL(d_add_ci);
 struct dentry * d_lookup(struct dentry * parent, struct qstr * name)
 {
 	struct dentry * dentry = NULL;
-	unsigned long seq;
+	unsigned seq;
 
         do {
                 seq = read_seqbegin(&rename_lock);
@@ -2211,12 +2258,20 @@ static int prepend_name(char **buffer, i
 char *__d_path(const struct path *path, struct path *root,
 	       char *buffer, int buflen)
 {
-	struct dentry *dentry = path->dentry;
-	struct vfsmount *vfsmnt = path->mnt;
-	char *end = buffer + buflen;
+	struct dentry *dentry;
+	struct vfsmount *vfsmnt;
+	char *end;
 	char *retval;
+	unsigned seq;
 
+rename_retry:
+	dentry = path->dentry;
+	vfsmnt = path->mnt;
+	end = buffer + buflen;
 	prepend(&end, &buflen, "\0", 1);
+
+	seq = read_seqbegin(&rename_lock);
+	rcu_read_lock();
 	spin_lock(&dentry->d_lock);
 unlinked:
 	if (d_unlinked(dentry) &&
@@ -2253,12 +2308,16 @@ unlinked:
 		retval = end;
 		spin_unlock(&dentry->d_lock);
 		dentry = parent;
+		spin_lock(&dentry->d_lock);
 		if (d_unlinked(dentry))
 			goto unlinked;
 	}
 
 out:
 	spin_unlock(&dentry->d_lock);
+	rcu_read_unlock();
+	if (read_seqretry(&rename_lock, seq))
+		goto rename_retry;
 	return retval;
 
 global_root:
@@ -2267,6 +2326,7 @@ global_root:
 		goto Elong;
 	root->mnt = vfsmnt;
 	root->dentry = dentry;
+	/* XXX: this could wrongly modify root if we rename retry */
 	goto out;
 
 Elong:
@@ -2349,12 +2409,19 @@ char *dynamic_dname(struct dentry *dentr
  */
 char *dentry_path(struct dentry *dentry, char *buf, int buflen)
 {
-	char *end = buf + buflen;
+	char *end;
 	char *retval;
+	unsigned seq;
+
+rename_retry:
+	end = buf + buflen;
+	prepend(&end, &buflen, "\0", 1);
 
+	seq = read_seqbegin(&rename_lock);
 	spin_lock(&dcache_lock);
+	br_read_lock(vfsmount_lock);
+	rcu_read_lock(); /* protect parent */
 	spin_lock(&dentry->d_lock);
-	prepend(&end, &buflen, "\0", 1);
 unlinked:
 	if (d_unlinked(dentry) &&
 		(prepend(&end, &buflen, "//deleted", 9) != 0))
@@ -2380,13 +2447,17 @@ unlinked:
 		if (d_unlinked(dentry))
 			goto unlinked;
 	}
+out:
 	spin_unlock(&dentry->d_lock);
+	rcu_read_unlock();
+	br_read_unlock(vfsmount_lock);
 	spin_unlock(&dcache_lock);
+	if (read_seqretry(&rename_lock, seq))
+		goto rename_retry;
 	return retval;
 Elong:
-	spin_unlock(&dentry->d_lock);
-	spin_unlock(&dcache_lock);
-	return ERR_PTR(-ENAMETOOLONG);
+	retval = ERR_PTR(-ENAMETOOLONG);
+	goto out;
 }
 
 /*
@@ -2481,25 +2552,25 @@ out:
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
@@ -2531,9 +2602,13 @@ EXPORT_SYMBOL(path_is_under);
 
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
@@ -2543,6 +2618,7 @@ resume:
 		struct list_head *tmp = next;
 		struct dentry *dentry = list_entry(tmp, struct dentry, d_u.d_child);
 		next = tmp->next;
+
 		spin_lock_nested(&dentry->d_lock, DENTRY_D_LOCK_NESTED);
 		if (d_unhashed(dentry) || !dentry->d_inode) {
 			spin_unlock(&dentry->d_lock);
@@ -2555,19 +2631,44 @@ resume:
 			spin_acquire(&this_parent->d_lock.dep_map, 0, 1, _RET_IP_);
 			goto repeat;
 		}
-		dentry->d_count--;
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
+		child = this_parent;
+		this_parent = tmp;
 		spin_lock(&this_parent->d_lock);
+		/* might go back up the wrong parent if we have had a rename
+		 * or deletion */
+		if (this_parent != child->d_parent ||
+				// d_unlinked(this_parent) || XXX
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
Index: linux-2.6/fs/seq_file.c
===================================================================
--- linux-2.6.orig/fs/seq_file.c
+++ linux-2.6/fs/seq_file.c
@@ -470,6 +470,7 @@ int seq_path_root(struct seq_file *m, st
 		p = __d_path(path, root, buf, size);
 		br_read_unlock(vfsmount_lock);
 		spin_unlock(&dcache_lock);
+
 		res = PTR_ERR(p);
 		if (!IS_ERR(p)) {
 			char *end = mangle_path(buf, p, esc);
Index: linux-2.6/drivers/staging/pohmelfs/path_entry.c
===================================================================
--- linux-2.6.orig/drivers/staging/pohmelfs/path_entry.c
+++ linux-2.6/drivers/staging/pohmelfs/path_entry.c
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
@@ -95,6 +96,11 @@ int pohmelfs_path_length(struct pohmelfs
 	root = dget(current->fs->root.dentry);
 	spin_unlock(&current->fs->lock);
 
+rename_retry:
+	len = 1; /* Root slash */
+	d = first;
+	seq = read_seqbegin(&rename_lock);
+	rcu_read_lock();
 	spin_lock(&dcache_lock);
 
 	if (!IS_ROOT(d) && d_unhashed(d))
@@ -105,6 +111,9 @@ int pohmelfs_path_length(struct pohmelfs
 		d = d->d_parent;
 	}
 	spin_unlock(&dcache_lock);
+	rcu_read_unlock();
+	if (read_seqretry(&rename_lock, seq))
+		goto rename_retry;
 
 	dput(root);
 	dput(first);
Index: linux-2.6/fs/autofs4/waitq.c
===================================================================
--- linux-2.6.orig/fs/autofs4/waitq.c
+++ linux-2.6/fs/autofs4/waitq.c
@@ -186,16 +186,25 @@ static int autofs4_getpath(struct autofs
 {
 	struct dentry *root = sbi->sb->s_root;
 	struct dentry *tmp;
-	char *buf = *name;
+	char *buf;
 	char *p;
-	int len = 0;
+	int len;
+	unsigned seq;
 
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
 
@@ -209,6 +218,9 @@ static int autofs4_getpath(struct autofs
 		strncpy(p, tmp->d_name.name, tmp->d_name.len);
 	}
 	spin_unlock(&dcache_lock);
+	rcu_read_unlock();
+	if (read_seqretry(&rename_lock, seq))
+		goto rename_retry;
 
 	return len;
 }
Index: linux-2.6/fs/nfs/namespace.c
===================================================================
--- linux-2.6.orig/fs/nfs/namespace.c
+++ linux-2.6/fs/nfs/namespace.c
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
Index: linux-2.6/include/linux/dcache.h
===================================================================
--- linux-2.6.orig/include/linux/dcache.h
+++ linux-2.6/include/linux/dcache.h
@@ -187,6 +187,7 @@ d_iput:		no		no		no       yes
 #define DCACHE_FSNOTIFY_PARENT_WATCHED	0x0080 /* Parent inode is watched by some fsnotify listener */
 
 #define DCACHE_CANT_MOUNT	0x0100
+#define DCACHE_GENOCIDE		0x0200
 
 extern spinlock_t dcache_inode_lock;
 extern spinlock_t dcache_hash_lock;


