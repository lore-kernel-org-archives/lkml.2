Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754428Ab0FXDQT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 23:16:19 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36000 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754023Ab0FXDPp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 23:15:45 -0400
Message-Id: <20100624030727.494329661@suse.de>
User-Agent: quilt/0.48-4.4
Date: Thu, 24 Jun 2010 13:02:24 +1000
From: npiggin@suse.de
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: John Stultz <johnstul@us.ibm.com>, Frank Mayhar <fmayhar@google.com>
Subject: [patch 12/52] fs: dcache scale dentry refcount
References: <20100624030212.676457061@suse.de>
Content-Disposition: inline; filename=fs-dcache-scale-d_count.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make d_count non-atomic and protect it with d_lock. This allows us to
ensure a 0 refcount dentry remains 0 without dcache_lock. It is also
fairly natural when we start protecting many other dentry members with
d_lock.

Signed-off-by: Nick Piggin <npiggin@suse.de>
---
 arch/powerpc/platforms/cell/spufs/inode.c |    2 
 drivers/infiniband/hw/ipath/ipath_fs.c    |    2 
 fs/autofs4/expire.c                       |    8 +-
 fs/autofs4/root.c                         |    6 -
 fs/coda/dir.c                             |    2 
 fs/configfs/dir.c                         |    3 
 fs/configfs/inode.c                       |    2 
 fs/dcache.c                               |  107 ++++++++++++++++++++++--------
 fs/ecryptfs/inode.c                       |    2 
 fs/exportfs/expfs.c                       |    9 ++
 fs/hpfs/namei.c                           |    2 
 fs/locks.c                                |    2 
 fs/namei.c                                |    2 
 fs/nfs/dir.c                              |   12 +--
 fs/nfsd/vfs.c                             |    5 -
 fs/notify/fsnotify.c                      |   11 ++-
 fs/notify/inotify/inotify.c               |   14 +++
 fs/smbfs/dir.c                            |    8 +-
 fs/smbfs/proc.c                           |    8 +-
 include/linux/dcache.h                    |   29 ++++----
 kernel/cgroup.c                           |    2 
 21 files changed, 162 insertions(+), 76 deletions(-)

Index: linux-2.6/fs/dcache.c
===================================================================
--- linux-2.6.orig/fs/dcache.c
+++ linux-2.6/fs/dcache.c
@@ -45,6 +45,7 @@
  *   - d_flags
  *   - d_name
  *   - d_lru
+ *   - d_count
  *
  * Ordering:
  * dcache_lock
@@ -112,6 +113,7 @@ static void d_callback(struct rcu_head *
 static void d_free(struct dentry *dentry)
 {
 	atomic_dec(&dentry_stat.nr_dentry);
+	BUG_ON(dentry->d_count);
 	if (dentry->d_op && dentry->d_op->d_release)
 		dentry->d_op->d_release(dentry);
 	/* if dentry was never inserted into hash, immediate free is OK */
@@ -263,13 +265,23 @@ void dput(struct dentry *dentry)
 		return;
 
 repeat:
-	if (atomic_read(&dentry->d_count) == 1)
+	if (dentry->d_count == 1)
 		might_sleep();
-	if (!atomic_dec_and_lock(&dentry->d_count, &dcache_lock))
-		return;
-
 	spin_lock(&dentry->d_lock);
-	if (atomic_read(&dentry->d_count)) {
+	if (dentry->d_count == 1) {
+		if (!spin_trylock(&dcache_lock)) {
+			/*
+			 * Something of a livelock possibility we could avoid
+			 * by taking dcache_lock and trying again, but we
+			 * want to reduce dcache_lock anyway so this will
+			 * get improved.
+			 */
+			spin_unlock(&dentry->d_lock);
+			goto repeat;
+		}
+	}
+	dentry->d_count--;
+	if (dentry->d_count) {
 		spin_unlock(&dentry->d_lock);
 		spin_unlock(&dcache_lock);
 		return;
@@ -347,7 +359,7 @@ int d_invalidate(struct dentry * dentry)
 	 * working directory or similar).
 	 */
 	spin_lock(&dentry->d_lock);
-	if (atomic_read(&dentry->d_count) > 1) {
+	if (dentry->d_count > 1) {
 		if (dentry->d_inode && S_ISDIR(dentry->d_inode->i_mode)) {
 			spin_unlock(&dentry->d_lock);
 			spin_unlock(&dcache_lock);
@@ -362,29 +374,60 @@ int d_invalidate(struct dentry * dentry)
 }
 EXPORT_SYMBOL(d_invalidate);
 
-/* This should be called _only_ with dcache_lock held */
+/* This must be called with dcache_lock and d_lock held */
 static inline struct dentry * __dget_locked_dlock(struct dentry *dentry)
 {
-	atomic_inc(&dentry->d_count);
+	dentry->d_count++;
 	dentry_lru_del_init(dentry);
 	return dentry;
 }
 
+/* This should be called _only_ with dcache_lock held */
 static inline struct dentry * __dget_locked(struct dentry *dentry)
 {
-	atomic_inc(&dentry->d_count);
 	spin_lock(&dentry->d_lock);
-	dentry_lru_del_init(dentry);
+	__dget_locked_dlock(dentry);
 	spin_unlock(&dentry->d_lock);
 	return dentry;
 }
 
+struct dentry * dget_locked_dlock(struct dentry *dentry)
+{
+	return __dget_locked_dlock(dentry);
+}
+
 struct dentry * dget_locked(struct dentry *dentry)
 {
 	return __dget_locked(dentry);
 }
 EXPORT_SYMBOL(dget_locked);
 
+struct dentry *dget_parent(struct dentry *dentry)
+{
+	struct dentry *ret;
+
+repeat:
+	spin_lock(&dentry->d_lock);
+	ret = dentry->d_parent;
+	if (!ret)
+		goto out;
+	if (dentry == ret) {
+		ret->d_count++;
+		goto out;
+	}
+	if (!spin_trylock(&ret->d_lock)) {
+		spin_unlock(&dentry->d_lock);
+		goto repeat;
+	}
+	BUG_ON(!ret->d_count);
+	ret->d_count++;
+	spin_unlock(&ret->d_lock);
+out:
+	spin_unlock(&dentry->d_lock);
+	return ret;
+}
+EXPORT_SYMBOL(dget_parent);
+
 /**
  * d_find_alias - grab a hashed alias of inode
  * @inode: inode in question
@@ -453,7 +496,7 @@ restart:
 	spin_lock(&dcache_lock);
 	list_for_each_entry(dentry, &inode->i_dentry, d_alias) {
 		spin_lock(&dentry->d_lock);
-		if (!atomic_read(&dentry->d_count)) {
+		if (!dentry->d_count) {
 			__dget_locked_dlock(dentry);
 			__d_drop(dentry);
 			spin_unlock(&dentry->d_lock);
@@ -489,7 +532,10 @@ static void prune_one_dentry(struct dent
 	 */
 	while (dentry) {
 		spin_lock(&dcache_lock);
-		if (!atomic_dec_and_lock(&dentry->d_count, &dentry->d_lock)) {
+		spin_lock(&dentry->d_lock);
+		dentry->d_count--;
+		if (dentry->d_count) {
+			spin_unlock(&dentry->d_lock);
 			spin_unlock(&dcache_lock);
 			return;
 		}
@@ -575,7 +621,7 @@ again:
 		 * the LRU because of laziness during lookup.  Do not free
 		 * it - just keep it off the LRU list.
 		 */
-		if (atomic_read(&dentry->d_count)) {
+		if (dentry->d_count) {
 			spin_unlock(&dentry->d_lock);
 			continue;
 		}
@@ -736,7 +782,7 @@ static void shrink_dcache_for_umount_sub
 		do {
 			struct inode *inode;
 
-			if (atomic_read(&dentry->d_count) != 0) {
+			if (dentry->d_count != 0) {
 				printk(KERN_ERR
 				       "BUG: Dentry %p{i=%lx,n=%s}"
 				       " still in use (%d)"
@@ -745,7 +791,7 @@ static void shrink_dcache_for_umount_sub
 				       dentry->d_inode ?
 				       dentry->d_inode->i_ino : 0UL,
 				       dentry->d_name.name,
-				       atomic_read(&dentry->d_count),
+				       dentry->d_count,
 				       dentry->d_sb->s_type->name,
 				       dentry->d_sb->s_id);
 				BUG();
@@ -755,7 +801,9 @@ static void shrink_dcache_for_umount_sub
 				parent = NULL;
 			else {
 				parent = dentry->d_parent;
-				atomic_dec(&parent->d_count);
+				spin_lock(&parent->d_lock);
+				parent->d_count--;
+				spin_unlock(&parent->d_lock);
 			}
 
 			list_del(&dentry->d_u.d_child);
@@ -810,7 +858,9 @@ void shrink_dcache_for_umount(struct sup
 
 	dentry = sb->s_root;
 	sb->s_root = NULL;
-	atomic_dec(&dentry->d_count);
+	spin_lock(&dentry->d_lock);
+	dentry->d_count--;
+	spin_unlock(&dentry->d_lock);
 	shrink_dcache_for_umount_subtree(dentry);
 
 	while (!hlist_empty(&sb->s_anon)) {
@@ -903,17 +953,15 @@ resume:
 
 		spin_lock(&dentry->d_lock);
 		dentry_lru_del_init(dentry);
-		spin_unlock(&dentry->d_lock);
 		/* 
 		 * move only zero ref count dentries to the end 
 		 * of the unused list for prune_dcache
 		 */
-		if (!atomic_read(&dentry->d_count)) {
-			spin_lock(&dentry->d_lock);
+		if (!dentry->d_count) {
 			dentry_lru_add_tail(dentry);
-			spin_unlock(&dentry->d_lock);
 			found++;
 		}
+		spin_unlock(&dentry->d_lock);
 
 		/*
 		 * We can return to the caller if we have found some (this
@@ -1023,7 +1071,7 @@ struct dentry *d_alloc(struct dentry * p
 	memcpy(dname, name->name, name->len);
 	dname[name->len] = 0;
 
-	atomic_set(&dentry->d_count, 1);
+	dentry->d_count = 1;
 	dentry->d_flags = DCACHE_UNHASHED;
 	spin_lock_init(&dentry->d_lock);
 	dentry->d_inode = NULL;
@@ -1497,7 +1545,7 @@ struct dentry * __d_lookup(struct dentry
 				goto next;
 		}
 
-		atomic_inc(&dentry->d_count);
+		dentry->d_count++;
 		found = dentry;
 		spin_unlock(&dentry->d_lock);
 		break;
@@ -1558,6 +1606,7 @@ int d_validate(struct dentry *dentry, st
 		goto out;
 
 	spin_lock(&dcache_lock);
+	spin_lock(&dentry->d_lock);
 	spin_lock(&dcache_hash_lock);
 	base = d_hash(dparent, dentry->d_name.hash);
 	hlist_for_each(lhp,base) { 
@@ -1566,12 +1615,14 @@ int d_validate(struct dentry *dentry, st
 		 */
 		if (dentry == hlist_entry(lhp, struct dentry, d_hash)) {
 			spin_unlock(&dcache_hash_lock);
-			__dget_locked(dentry);
+			__dget_locked_dlock(dentry);
+			spin_unlock(&dentry->d_lock);
 			spin_unlock(&dcache_lock);
 			return 1;
 		}
 	}
 	spin_unlock(&dcache_hash_lock);
+	spin_unlock(&dentry->d_lock);
 	spin_unlock(&dcache_lock);
 out:
 	return 0;
@@ -1608,7 +1659,7 @@ void d_delete(struct dentry * dentry)
 	spin_lock(&dcache_lock);
 	spin_lock(&dentry->d_lock);
 	isdir = S_ISDIR(dentry->d_inode->i_mode);
-	if (atomic_read(&dentry->d_count) == 1) {
+	if (dentry->d_count == 1) {
 		dentry->d_flags &= ~DCACHE_CANT_MOUNT;
 		dentry_iput(dentry);
 		fsnotify_nameremove(dentry, isdir);
@@ -2314,11 +2365,15 @@ resume:
 			this_parent = dentry;
 			goto repeat;
 		}
-		atomic_dec(&dentry->d_count);
+		spin_lock(&dentry->d_lock);
+		dentry->d_count--;
+		spin_unlock(&dentry->d_lock);
 	}
 	if (this_parent != root) {
 		next = this_parent->d_u.d_child.next;
-		atomic_dec(&this_parent->d_count);
+		spin_lock(&this_parent->d_lock);
+		this_parent->d_count--;
+		spin_unlock(&this_parent->d_lock);
 		this_parent = this_parent->d_parent;
 		goto resume;
 	}
Index: linux-2.6/include/linux/dcache.h
===================================================================
--- linux-2.6.orig/include/linux/dcache.h
+++ linux-2.6/include/linux/dcache.h
@@ -87,7 +87,7 @@ full_name_hash(const unsigned char *name
 #endif
 
 struct dentry {
-	atomic_t d_count;
+	unsigned int d_count;		/* protected by d_lock */
 	unsigned int d_flags;		/* protected by d_lock */
 	spinlock_t d_lock;		/* per dentry lock */
 	int d_mounted;
@@ -334,17 +334,28 @@ extern char *dentry_path(struct dentry *
  *	needs and they take necessary precautions) you should hold dcache_lock
  *	and call dget_locked() instead of dget().
  */
- 
+static inline struct dentry *dget_dlock(struct dentry *dentry)
+{
+	if (dentry) {
+		BUG_ON(!dentry->d_count);
+		dentry->d_count++;
+	}
+	return dentry;
+}
 static inline struct dentry *dget(struct dentry *dentry)
 {
 	if (dentry) {
-		BUG_ON(!atomic_read(&dentry->d_count));
-		atomic_inc(&dentry->d_count);
+		spin_lock(&dentry->d_lock);
+		dget_dlock(dentry);
+		spin_unlock(&dentry->d_lock);
 	}
 	return dentry;
 }
 
 extern struct dentry * dget_locked(struct dentry *);
+extern struct dentry * dget_locked_dlock(struct dentry *);
+
+extern struct dentry *dget_parent(struct dentry *dentry);
 
 /**
  *	d_unhashed -	is dentry hashed
@@ -375,16 +386,6 @@ static inline void dont_mount(struct den
 	spin_unlock(&dentry->d_lock);
 }
 
-static inline struct dentry *dget_parent(struct dentry *dentry)
-{
-	struct dentry *ret;
-
-	spin_lock(&dentry->d_lock);
-	ret = dget(dentry->d_parent);
-	spin_unlock(&dentry->d_lock);
-	return ret;
-}
-
 extern void dput(struct dentry *);
 
 static inline int d_mountpoint(struct dentry *dentry)
Index: linux-2.6/fs/configfs/dir.c
===================================================================
--- linux-2.6.orig/fs/configfs/dir.c
+++ linux-2.6/fs/configfs/dir.c
@@ -399,8 +399,7 @@ static void remove_dir(struct dentry * d
 	if (d->d_inode)
 		simple_rmdir(parent->d_inode,d);
 
-	pr_debug(" o %s removing done (%d)\n",d->d_name.name,
-		 atomic_read(&d->d_count));
+	pr_debug(" o %s removing done (%d)\n",d->d_name.name, d->d_count);
 
 	dput(parent);
 }
Index: linux-2.6/fs/locks.c
===================================================================
--- linux-2.6.orig/fs/locks.c
+++ linux-2.6/fs/locks.c
@@ -1375,7 +1375,7 @@ int generic_setlease(struct file *filp,
 		if ((arg == F_RDLCK) && (atomic_read(&inode->i_writecount) > 0))
 			goto out;
 		if ((arg == F_WRLCK)
-		    && ((atomic_read(&dentry->d_count) > 1)
+		    && (dentry->d_count > 1
 			|| (atomic_read(&inode->i_count) > 1)))
 			goto out;
 	}
Index: linux-2.6/fs/namei.c
===================================================================
--- linux-2.6.orig/fs/namei.c
+++ linux-2.6/fs/namei.c
@@ -2154,7 +2154,7 @@ void dentry_unhash(struct dentry *dentry
 	shrink_dcache_parent(dentry);
 	spin_lock(&dcache_lock);
 	spin_lock(&dentry->d_lock);
-	if (atomic_read(&dentry->d_count) == 2)
+	if (dentry->d_count == 2)
 		__d_drop(dentry);
 	spin_unlock(&dentry->d_lock);
 	spin_unlock(&dcache_lock);
Index: linux-2.6/fs/autofs4/expire.c
===================================================================
--- linux-2.6.orig/fs/autofs4/expire.c
+++ linux-2.6/fs/autofs4/expire.c
@@ -198,7 +198,7 @@ static int autofs4_tree_busy(struct vfsm
 			else
 				ino_count++;
 
-			if (atomic_read(&p->d_count) > ino_count) {
+			if (p->d_count > ino_count) {
 				top_ino->last_used = jiffies;
 				dput(p);
 				return 1;
@@ -347,7 +347,7 @@ struct dentry *autofs4_expire_indirect(s
 
 			/* Path walk currently on this dentry? */
 			ino_count = atomic_read(&ino->count) + 2;
-			if (atomic_read(&dentry->d_count) > ino_count)
+			if (dentry->d_count > ino_count)
 				goto next;
 
 			/* Can we umount this guy */
@@ -369,7 +369,7 @@ struct dentry *autofs4_expire_indirect(s
 		if (!exp_leaves) {
 			/* Path walk currently on this dentry? */
 			ino_count = atomic_read(&ino->count) + 1;
-			if (atomic_read(&dentry->d_count) > ino_count)
+			if (dentry->d_count > ino_count)
 				goto next;
 
 			if (!autofs4_tree_busy(mnt, dentry, timeout, do_now)) {
@@ -383,7 +383,7 @@ struct dentry *autofs4_expire_indirect(s
 		} else {
 			/* Path walk currently on this dentry? */
 			ino_count = atomic_read(&ino->count) + 1;
-			if (atomic_read(&dentry->d_count) > ino_count)
+			if (dentry->d_count > ino_count)
 				goto next;
 
 			expired = autofs4_check_leaves(mnt, dentry, timeout, do_now);
Index: linux-2.6/fs/coda/dir.c
===================================================================
--- linux-2.6.orig/fs/coda/dir.c
+++ linux-2.6/fs/coda/dir.c
@@ -612,7 +612,7 @@ static int coda_dentry_revalidate(struct
 	if (cii->c_flags & C_FLUSH) 
 		coda_flag_inode_children(inode, C_FLUSH);
 
-	if (atomic_read(&de->d_count) > 1)
+	if (de->d_count > 1)
 		/* pretend it's valid, but don't change the flags */
 		goto out;
 
Index: linux-2.6/fs/ecryptfs/inode.c
===================================================================
--- linux-2.6.orig/fs/ecryptfs/inode.c
+++ linux-2.6/fs/ecryptfs/inode.c
@@ -255,7 +255,7 @@ int ecryptfs_lookup_and_interpose_lower(
 				   ecryptfs_dentry->d_parent));
 	lower_inode = lower_dentry->d_inode;
 	fsstack_copy_attr_atime(ecryptfs_dir_inode, lower_dir_dentry->d_inode);
-	BUG_ON(!atomic_read(&lower_dentry->d_count));
+	BUG_ON(!lower_dentry->d_count);
 	ecryptfs_set_dentry_private(ecryptfs_dentry,
 				    kmem_cache_alloc(ecryptfs_dentry_info_cache,
 						     GFP_KERNEL));
Index: linux-2.6/fs/nfs/dir.c
===================================================================
--- linux-2.6.orig/fs/nfs/dir.c
+++ linux-2.6/fs/nfs/dir.c
@@ -1357,7 +1357,7 @@ static int nfs_sillyrename(struct inode
 
 	dfprintk(VFS, "NFS: silly-rename(%s/%s, ct=%d)\n",
 		dentry->d_parent->d_name.name, dentry->d_name.name, 
-		atomic_read(&dentry->d_count));
+		dentry->d_count);
 	nfs_inc_stats(dir, NFSIOS_SILLYRENAME);
 
 	/*
@@ -1466,7 +1466,7 @@ static int nfs_unlink(struct inode *dir,
 
 	spin_lock(&dcache_lock);
 	spin_lock(&dentry->d_lock);
-	if (atomic_read(&dentry->d_count) > 1) {
+	if (dentry->d_count > 1) {
 		spin_unlock(&dentry->d_lock);
 		spin_unlock(&dcache_lock);
 		/* Start asynchronous writeout of the inode */
@@ -1614,7 +1614,7 @@ static int nfs_rename(struct inode *old_
 	dfprintk(VFS, "NFS: rename(%s/%s -> %s/%s, ct=%d)\n",
 		 old_dentry->d_parent->d_name.name, old_dentry->d_name.name,
 		 new_dentry->d_parent->d_name.name, new_dentry->d_name.name,
-		 atomic_read(&new_dentry->d_count));
+		 new_dentry->d_count);
 
 	/*
 	 * For non-directories, check whether the target is busy and if so,
@@ -1632,7 +1632,7 @@ static int nfs_rename(struct inode *old_
 			rehash = new_dentry;
 		}
 
-		if (atomic_read(&new_dentry->d_count) > 2) {
+		if (new_dentry->d_count > 2) {
 			int err;
 
 			/* copy the target dentry's name */
@@ -1655,7 +1655,7 @@ static int nfs_rename(struct inode *old_
 	/*
 	 * ... prune child dentries and writebacks if needed.
 	 */
-	if (atomic_read(&old_dentry->d_count) > 1) {
+	if (old_dentry->d_count > 1) {
 		if (S_ISREG(old_inode->i_mode))
 			nfs_wb_all(old_inode);
 		shrink_dcache_parent(old_dentry);
Index: linux-2.6/fs/nfsd/vfs.c
===================================================================
--- linux-2.6.orig/fs/nfsd/vfs.c
+++ linux-2.6/fs/nfsd/vfs.c
@@ -1752,8 +1752,7 @@ nfsd_rename(struct svc_rqst *rqstp, stru
 		goto out_dput_new;
 
 	if (svc_msnfs(ffhp) &&
-		((atomic_read(&odentry->d_count) > 1)
-		 || (atomic_read(&ndentry->d_count) > 1))) {
+		((odentry->d_count > 1) || (ndentry->d_count > 1))) {
 			host_err = -EPERM;
 			goto out_dput_new;
 	}
@@ -1839,7 +1838,7 @@ nfsd_unlink(struct svc_rqst *rqstp, stru
 	if (type != S_IFDIR) { /* It's UNLINK */
 #ifdef MSNFS
 		if ((fhp->fh_export->ex_flags & NFSEXP_MSNFS) &&
-			(atomic_read(&rdentry->d_count) > 1)) {
+			(rdentry->d_count > 1)) {
 			host_err = -EPERM;
 		} else
 #endif
Index: linux-2.6/fs/exportfs/expfs.c
===================================================================
--- linux-2.6.orig/fs/exportfs/expfs.c
+++ linux-2.6/fs/exportfs/expfs.c
@@ -74,12 +74,19 @@ static struct dentry *
 find_disconnected_root(struct dentry *dentry)
 {
 	dget(dentry);
+again:
 	spin_lock(&dentry->d_lock);
 	while (!IS_ROOT(dentry) &&
 	       (dentry->d_parent->d_flags & DCACHE_DISCONNECTED)) {
 		struct dentry *parent = dentry->d_parent;
-		dget(parent);
+
+		if (!spin_trylock(&parent->d_lock)) {
+			spin_unlock(&dentry->d_lock);
+			goto again;
+		}
+		dget_dlock(parent);
 		spin_unlock(&dentry->d_lock);
+		spin_unlock(&parent->d_lock);
 		dput(dentry);
 		dentry = parent;
 		spin_lock(&dentry->d_lock);
Index: linux-2.6/fs/notify/inotify/inotify.c
===================================================================
--- linux-2.6.orig/fs/notify/inotify/inotify.c
+++ linux-2.6/fs/notify/inotify/inotify.c
@@ -335,18 +335,28 @@ void inotify_dentry_parent_queue_event(s
 	if (!(dentry->d_flags & DCACHE_INOTIFY_PARENT_WATCHED))
 		return;
 
+again:
 	spin_lock(&dentry->d_lock);
 	parent = dentry->d_parent;
+	if (parent != dentry && !spin_trylock(&parent->d_lock)) {
+		spin_unlock(&dentry->d_lock);
+		goto again;
+	}
 	inode = parent->d_inode;
 
 	if (inotify_inode_watched(inode)) {
-		dget(parent);
+		dget_dlock(parent);
 		spin_unlock(&dentry->d_lock);
+		if (parent != dentry)
+			spin_unlock(&parent->d_lock);
 		inotify_inode_queue_event(inode, mask, cookie, name,
 					  dentry->d_inode);
 		dput(parent);
-	} else
+	} else {
 		spin_unlock(&dentry->d_lock);
+		if (parent != dentry)
+			spin_unlock(&parent->d_lock);
+	}
 }
 EXPORT_SYMBOL_GPL(inotify_dentry_parent_queue_event);
 
Index: linux-2.6/fs/smbfs/dir.c
===================================================================
--- linux-2.6.orig/fs/smbfs/dir.c
+++ linux-2.6/fs/smbfs/dir.c
@@ -406,6 +406,7 @@ void
 smb_renew_times(struct dentry * dentry)
 {
 	dget(dentry);
+again:
 	spin_lock(&dentry->d_lock);
 	for (;;) {
 		struct dentry *parent;
@@ -414,8 +415,13 @@ smb_renew_times(struct dentry * dentry)
 		if (IS_ROOT(dentry))
 			break;
 		parent = dentry->d_parent;
-		dget(parent);
+		if (!spin_trylock(&parent->d_lock)) {
+			spin_unlock(&dentry->d_lock);
+			goto again;
+		}
+		dget_dlock(parent);
 		spin_unlock(&dentry->d_lock);
+		spin_unlock(&parent->d_lock);
 		dput(dentry);
 		dentry = parent;
 		spin_lock(&dentry->d_lock);
Index: linux-2.6/fs/smbfs/proc.c
===================================================================
--- linux-2.6.orig/fs/smbfs/proc.c
+++ linux-2.6/fs/smbfs/proc.c
@@ -332,6 +332,7 @@ static int smb_build_path(struct smb_sb_
 	 * and store it in reversed order [see reverse_string()]
 	 */
 	dget(entry);
+again:
 	spin_lock(&entry->d_lock);
 	while (!IS_ROOT(entry)) {
 		struct dentry *parent;
@@ -350,6 +351,7 @@ static int smb_build_path(struct smb_sb_
 			dput(entry);
 			return len;
 		}
+
 		reverse_string(path, len);
 		path += len;
 		if (unicode) {
@@ -361,7 +363,11 @@ static int smb_build_path(struct smb_sb_
 		maxlen -= len+1;
 
 		parent = entry->d_parent;
-		dget(parent);
+		if (!spin_trylock(&parent->d_lock)) {
+			spin_unlock(&entry->d_lock);
+			goto again;
+		}
+		dget_dlock(parent);
 		spin_unlock(&entry->d_lock);
 		dput(entry);
 		entry = parent;
Index: linux-2.6/kernel/cgroup.c
===================================================================
--- linux-2.6.orig/kernel/cgroup.c
+++ linux-2.6/kernel/cgroup.c
@@ -3545,9 +3545,7 @@ again:
 	list_del(&cgrp->sibling);
 	cgroup_unlock_hierarchy(cgrp->root);
 
-	spin_lock(&cgrp->dentry->d_lock);
 	d = dget(cgrp->dentry);
-	spin_unlock(&d->d_lock);
 
 	cgroup_d_remove_dir(d);
 	dput(d);
Index: linux-2.6/arch/powerpc/platforms/cell/spufs/inode.c
===================================================================
--- linux-2.6.orig/arch/powerpc/platforms/cell/spufs/inode.c
+++ linux-2.6/arch/powerpc/platforms/cell/spufs/inode.c
@@ -161,7 +161,7 @@ static void spufs_prune_dir(struct dentr
 		spin_lock(&dcache_lock);
 		spin_lock(&dentry->d_lock);
 		if (!(d_unhashed(dentry)) && dentry->d_inode) {
-			dget_locked(dentry);
+			dget_locked_dlock(dentry);
 			__d_drop(dentry);
 			spin_unlock(&dentry->d_lock);
 			simple_unlink(dir->d_inode, dentry);
Index: linux-2.6/drivers/infiniband/hw/ipath/ipath_fs.c
===================================================================
--- linux-2.6.orig/drivers/infiniband/hw/ipath/ipath_fs.c
+++ linux-2.6/drivers/infiniband/hw/ipath/ipath_fs.c
@@ -276,7 +276,7 @@ static int remove_file(struct dentry *pa
 	spin_lock(&dcache_lock);
 	spin_lock(&tmp->d_lock);
 	if (!(d_unhashed(tmp) && tmp->d_inode)) {
-		dget_locked(tmp);
+		dget_locked_dlock(tmp);
 		__d_drop(tmp);
 		spin_unlock(&tmp->d_lock);
 		spin_unlock(&dcache_lock);
Index: linux-2.6/fs/configfs/inode.c
===================================================================
--- linux-2.6.orig/fs/configfs/inode.c
+++ linux-2.6/fs/configfs/inode.c
@@ -252,7 +252,7 @@ void configfs_drop_dentry(struct configf
 		spin_lock(&dcache_lock);
 		spin_lock(&dentry->d_lock);
 		if (!(d_unhashed(dentry) && dentry->d_inode)) {
-			dget_locked(dentry);
+			dget_locked_dlock(dentry);
 			__d_drop(dentry);
 			spin_unlock(&dentry->d_lock);
 			spin_unlock(&dcache_lock);
Index: linux-2.6/fs/notify/fsnotify.c
===================================================================
--- linux-2.6.orig/fs/notify/fsnotify.c
+++ linux-2.6/fs/notify/fsnotify.c
@@ -88,13 +88,18 @@ void __fsnotify_parent(struct dentry *de
 	if (!(dentry->d_flags & DCACHE_FSNOTIFY_PARENT_WATCHED))
 		return;
 
+again:
 	spin_lock(&dentry->d_lock);
 	parent = dentry->d_parent;
+	if (parent != dentry && !spin_trylock(&parent->d_lock)) {
+		spin_unlock(&dentry->d_lock);
+		goto again;
+	}
 	p_inode = parent->d_inode;
 
 	if (fsnotify_inode_watches_children(p_inode)) {
 		if (p_inode->i_fsnotify_mask & mask) {
-			dget(parent);
+			dget_dlock(parent);
 			send = true;
 		}
 	} else {
@@ -104,11 +109,13 @@ void __fsnotify_parent(struct dentry *de
 		 * children and update their d_flags to let them know p_inode
 		 * doesn't care about them any more.
 		 */
-		dget(parent);
+		dget_dlock(parent);
 		should_update_children = true;
 	}
 
 	spin_unlock(&dentry->d_lock);
+	if (parent != dentry)
+		spin_unlock(&parent->d_lock);
 
 	if (send) {
 		/* we are notifying a parent so come up with the new mask which
Index: linux-2.6/fs/ceph/dir.c
===================================================================
--- linux-2.6.orig/fs/ceph/dir.c
+++ linux-2.6/fs/ceph/dir.c
@@ -149,7 +149,9 @@ more:
 		di = ceph_dentry(dentry);
 	}
 
-	atomic_inc(&dentry->d_count);
+	spin_lock(&dentry->d_lock);
+	dentry->d_count++;
+	spin_unlock(&dentry->d_lock);
 	spin_unlock(&dcache_lock);
 	spin_unlock(&inode->i_lock);
 
Index: linux-2.6/fs/ceph/inode.c
===================================================================
--- linux-2.6.orig/fs/ceph/inode.c
+++ linux-2.6/fs/ceph/inode.c
@@ -863,8 +863,8 @@ static struct dentry *splice_dentry(stru
 	} else if (realdn) {
 		dout("dn %p (%d) spliced with %p (%d) "
 		     "inode %p ino %llx.%llx\n",
-		     dn, atomic_read(&dn->d_count),
-		     realdn, atomic_read(&realdn->d_count),
+		     dn, dn->d_count,
+		     realdn, realdn->d_count,
 		     realdn->d_inode, ceph_vinop(realdn->d_inode));
 		dput(dn);
 		dn = realdn;
Index: linux-2.6/fs/ceph/mds_client.c
===================================================================
--- linux-2.6.orig/fs/ceph/mds_client.c
+++ linux-2.6/fs/ceph/mds_client.c
@@ -1371,7 +1371,7 @@ retry:
 	*base = ceph_ino(temp->d_inode);
 	*plen = len;
 	dout("build_path on %p %d built %llx '%.*s'\n",
-	     dentry, atomic_read(&dentry->d_count), *base, len, path);
+	     dentry, dentry->d_count, *base, len, path);
 	return path;
 }
 
Index: linux-2.6/drivers/infiniband/hw/qib/qib_fs.c
===================================================================
--- linux-2.6.orig/drivers/infiniband/hw/qib/qib_fs.c
+++ linux-2.6/drivers/infiniband/hw/qib/qib_fs.c
@@ -454,7 +454,7 @@ static int remove_file(struct dentry *pa
 	spin_lock(&dcache_lock);
 	spin_lock(&tmp->d_lock);
 	if (!(d_unhashed(tmp) && tmp->d_inode)) {
-		dget_locked(tmp);
+		dget_locked_dlock(tmp);
 		__d_drop(tmp);
 		spin_unlock(&tmp->d_lock);
 		spin_unlock(&dcache_lock);


