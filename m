Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932761Ab0KPO0U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 09:26:20 -0500
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:2280 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758501Ab0KPOXz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 09:23:55 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AiQJAKMh4kx5Ldur/2dsb2JhbACVYYx9cr5mhUsEilg
Message-Id: <20101116142029.337889056@kernel.dk>
User-Agent: quilt/0.48-1
Date: Wed, 17 Nov 2010 01:09:12 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [patch 12/28] fs: dcache scale dentry refcount
References: <20101116140900.039761100@kernel.dk>
Content-Disposition: inline; filename=fs-dcache-scale-d_count.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make d_count non-atomic and protect it with d_lock. This allows us to ensure a
0 refcount dentry remains 0 without dcache_lock. It is also fairly natural when
we start protecting many other dentry members with d_lock.

Signed-off-by: Nick Piggin <npiggin@kernel.dk>

---
 arch/powerpc/platforms/cell/spufs/inode.c |    2 
 drivers/infiniband/hw/ipath/ipath_fs.c    |    2 
 drivers/infiniband/hw/qib/qib_fs.c        |    2 
 fs/autofs4/expire.c                       |    8 +-
 fs/autofs4/root.c                         |    6 -
 fs/ceph/dir.c                             |    4 -
 fs/ceph/inode.c                           |    4 -
 fs/ceph/mds_client.c                      |    2 
 fs/coda/dir.c                             |    2 
 fs/configfs/dir.c                         |    3 
 fs/configfs/inode.c                       |    2 
 fs/dcache.c                               |  106 +++++++++++++++++++++++-------
 fs/ecryptfs/inode.c                       |    2 
 fs/locks.c                                |    2 
 fs/namei.c                                |    2 
 fs/nfs/dir.c                              |    6 -
 fs/nfs/unlink.c                           |    2 
 fs/nfsd/vfs.c                             |    5 -
 fs/nilfs2/super.c                         |    2 
 include/linux/dcache.h                    |   29 ++++----
 kernel/cgroup.c                           |    2 
 21 files changed, 126 insertions(+), 69 deletions(-)

Index: linux-2.6/fs/dcache.c
===================================================================
--- linux-2.6.orig/fs/dcache.c	2010-11-17 00:52:37.000000000 +1100
+++ linux-2.6/fs/dcache.c	2010-11-17 01:05:45.000000000 +1100
@@ -45,6 +45,7 @@
  *   - d_flags
  *   - d_name
  *   - d_lru
+ *   - d_count
  *
  * Ordering:
  * dcache_lock
@@ -119,6 +120,7 @@ static void __d_free(struct rcu_head *he
  */
 static void d_free(struct dentry *dentry)
 {
+	BUG_ON(dentry->d_count);
 	percpu_counter_dec(&nr_dentry);
 	if (dentry->d_op && dentry->d_op->d_release)
 		dentry->d_op->d_release(dentry);
@@ -216,8 +218,11 @@ static struct dentry *d_kill(struct dent
 	struct dentry *parent;
 
 	list_del(&dentry->d_u.d_child);
-	/*drops the locks, at that point nobody can reach this dentry */
 	dentry_iput(dentry);
+	/*
+	 * dentry_iput drops the locks, at which point nobody (except
+	 * transient RCU lookups) can reach this dentry.
+	 */
 	if (IS_ROOT(dentry))
 		parent = NULL;
 	else
@@ -261,13 +266,23 @@ void dput(struct dentry *dentry)
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
@@ -347,7 +362,7 @@ int d_invalidate(struct dentry * dentry)
 	 * working directory or similar).
 	 */
 	spin_lock(&dentry->d_lock);
-	if (atomic_read(&dentry->d_count) > 1) {
+	if (dentry->d_count > 1) {
 		if (dentry->d_inode && S_ISDIR(dentry->d_inode->i_mode)) {
 			spin_unlock(&dentry->d_lock);
 			spin_unlock(&dcache_lock);
@@ -362,29 +377,61 @@ int d_invalidate(struct dentry * dentry)
 }
 EXPORT_SYMBOL(d_invalidate);
 
-/* This should be called _only_ with dcache_lock held */
+/* This must be called with dcache_lock and d_lock held */
 static inline struct dentry * __dget_locked_dlock(struct dentry *dentry)
 {
-	atomic_inc(&dentry->d_count);
+	dentry->d_count++;
 	dentry_lru_del(dentry);
 	return dentry;
 }
 
+/* This should be called _only_ with dcache_lock held */
 static inline struct dentry * __dget_locked(struct dentry *dentry)
 {
-	atomic_inc(&dentry->d_count);
 	spin_lock(&dentry->d_lock);
-	dentry_lru_del(dentry);
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
+		cpu_relax();
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
@@ -453,7 +500,7 @@ void d_prune_aliases(struct inode *inode
 	spin_lock(&dcache_lock);
 	list_for_each_entry(dentry, &inode->i_dentry, d_alias) {
 		spin_lock(&dentry->d_lock);
-		if (!atomic_read(&dentry->d_count)) {
+		if (!dentry->d_count) {
 			__dget_locked_dlock(dentry);
 			__d_drop(dentry);
 			spin_unlock(&dentry->d_lock);
@@ -488,7 +535,10 @@ static void prune_one_dentry(struct dent
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
@@ -520,7 +570,7 @@ static void shrink_dentry_list(struct li
 		 * the LRU because of laziness during lookup.  Do not free
 		 * it - just keep it off the LRU list.
 		 */
-		if (atomic_read(&dentry->d_count)) {
+		if (dentry->d_count) {
 			spin_unlock(&dentry->d_lock);
 			continue;
 		}
@@ -741,7 +791,7 @@ static void shrink_dcache_for_umount_sub
 		do {
 			struct inode *inode;
 
-			if (atomic_read(&dentry->d_count) != 0) {
+			if (dentry->d_count != 0) {
 				printk(KERN_ERR
 				       "BUG: Dentry %p{i=%lx,n=%s}"
 				       " still in use (%d)"
@@ -750,7 +800,7 @@ static void shrink_dcache_for_umount_sub
 				       dentry->d_inode ?
 				       dentry->d_inode->i_ino : 0UL,
 				       dentry->d_name.name,
-				       atomic_read(&dentry->d_count),
+				       dentry->d_count,
 				       dentry->d_sb->s_type->name,
 				       dentry->d_sb->s_id);
 				BUG();
@@ -760,7 +810,9 @@ static void shrink_dcache_for_umount_sub
 				parent = NULL;
 			else {
 				parent = dentry->d_parent;
-				atomic_dec(&parent->d_count);
+				spin_lock(&parent->d_lock);
+				parent->d_count--;
+				spin_unlock(&parent->d_lock);
 			}
 
 			list_del(&dentry->d_u.d_child);
@@ -811,7 +863,9 @@ void shrink_dcache_for_umount(struct sup
 
 	dentry = sb->s_root;
 	sb->s_root = NULL;
-	atomic_dec(&dentry->d_count);
+	spin_lock(&dentry->d_lock);
+	dentry->d_count--;
+	spin_unlock(&dentry->d_lock);
 	shrink_dcache_for_umount_subtree(dentry);
 
 	while (!hlist_empty(&sb->s_anon)) {
@@ -908,7 +962,7 @@ static int select_parent(struct dentry *
 		 * move only zero ref count dentries to the end 
 		 * of the unused list for prune_dcache
 		 */
-		if (!atomic_read(&dentry->d_count)) {
+		if (!dentry->d_count) {
 			dentry_lru_move_tail(dentry);
 			found++;
 		} else {
@@ -1029,7 +1083,7 @@ struct dentry *d_alloc(struct dentry * p
 	memcpy(dname, name->name, name->len);
 	dname[name->len] = 0;
 
-	atomic_set(&dentry->d_count, 1);
+	dentry->d_count = 1;
 	dentry->d_flags = DCACHE_UNHASHED;
 	spin_lock_init(&dentry->d_lock);
 	dentry->d_inode = NULL;
@@ -1517,7 +1571,7 @@ struct dentry * __d_lookup(struct dentry
 				goto next;
 		}
 
-		atomic_inc(&dentry->d_count);
+		dentry->d_count++;
 		found = dentry;
 		spin_unlock(&dentry->d_lock);
 		break;
@@ -1614,7 +1668,7 @@ void d_delete(struct dentry * dentry)
 	spin_lock(&dcache_lock);
 	spin_lock(&dentry->d_lock);
 	isdir = S_ISDIR(dentry->d_inode->i_mode);
-	if (atomic_read(&dentry->d_count) == 1) {
+	if (dentry->d_count == 1) {
 		dentry->d_flags &= ~DCACHE_CANT_MOUNT;
 		dentry_iput(dentry);
 		fsnotify_nameremove(dentry, isdir);
@@ -2428,11 +2482,15 @@ void d_genocide(struct dentry *root)
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
--- linux-2.6.orig/include/linux/dcache.h	2010-11-17 00:52:37.000000000 +1100
+++ linux-2.6/include/linux/dcache.h	2010-11-17 01:05:44.000000000 +1100
@@ -87,7 +87,7 @@ full_name_hash(const unsigned char *name
 #endif
 
 struct dentry {
-	atomic_t d_count;
+	unsigned int d_count;		/* protected by d_lock */
 	unsigned int d_flags;		/* protected by d_lock */
 	spinlock_t d_lock;		/* per dentry lock */
 	int d_mounted;
@@ -329,17 +329,28 @@ extern char *dentry_path(struct dentry *
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
@@ -370,16 +381,6 @@ static inline void dont_mount(struct den
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
--- linux-2.6.orig/fs/configfs/dir.c	2010-11-17 00:52:37.000000000 +1100
+++ linux-2.6/fs/configfs/dir.c	2010-11-17 00:52:37.000000000 +1100
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
--- linux-2.6.orig/fs/locks.c	2010-11-17 00:50:51.000000000 +1100
+++ linux-2.6/fs/locks.c	2010-11-17 00:52:37.000000000 +1100
@@ -1390,7 +1390,7 @@ int generic_setlease(struct file *filp,
 		if ((arg == F_RDLCK) && (atomic_read(&inode->i_writecount) > 0))
 			goto out;
 		if ((arg == F_WRLCK)
-		    && ((atomic_read(&dentry->d_count) > 1)
+		    && ((dentry->d_count > 1)
 			|| (atomic_read(&inode->i_count) > 1)))
 			goto out;
 	}
Index: linux-2.6/fs/namei.c
===================================================================
--- linux-2.6.orig/fs/namei.c	2010-11-17 00:52:37.000000000 +1100
+++ linux-2.6/fs/namei.c	2010-11-17 01:05:42.000000000 +1100
@@ -2130,7 +2130,7 @@ void dentry_unhash(struct dentry *dentry
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
--- linux-2.6.orig/fs/autofs4/expire.c	2010-11-17 00:50:51.000000000 +1100
+++ linux-2.6/fs/autofs4/expire.c	2010-11-17 01:05:45.000000000 +1100
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
--- linux-2.6.orig/fs/coda/dir.c	2010-11-17 00:52:37.000000000 +1100
+++ linux-2.6/fs/coda/dir.c	2010-11-17 00:52:37.000000000 +1100
@@ -559,7 +559,7 @@ static int coda_dentry_revalidate(struct
 	if (cii->c_flags & C_FLUSH) 
 		coda_flag_inode_children(inode, C_FLUSH);
 
-	if (atomic_read(&de->d_count) > 1)
+	if (de->d_count > 1)
 		/* pretend it's valid, but don't change the flags */
 		goto out;
 
Index: linux-2.6/fs/ecryptfs/inode.c
===================================================================
--- linux-2.6.orig/fs/ecryptfs/inode.c	2010-11-17 00:52:37.000000000 +1100
+++ linux-2.6/fs/ecryptfs/inode.c	2010-11-17 00:52:37.000000000 +1100
@@ -260,7 +260,7 @@ int ecryptfs_lookup_and_interpose_lower(
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
--- linux-2.6.orig/fs/nfs/dir.c	2010-11-17 00:52:37.000000000 +1100
+++ linux-2.6/fs/nfs/dir.c	2010-11-17 01:05:42.000000000 +1100
@@ -1694,7 +1694,7 @@ static int nfs_unlink(struct inode *dir,
 
 	spin_lock(&dcache_lock);
 	spin_lock(&dentry->d_lock);
-	if (atomic_read(&dentry->d_count) > 1) {
+	if (dentry->d_count > 1) {
 		spin_unlock(&dentry->d_lock);
 		spin_unlock(&dcache_lock);
 		/* Start asynchronous writeout of the inode */
@@ -1842,7 +1842,7 @@ static int nfs_rename(struct inode *old_
 	dfprintk(VFS, "NFS: rename(%s/%s -> %s/%s, ct=%d)\n",
 		 old_dentry->d_parent->d_name.name, old_dentry->d_name.name,
 		 new_dentry->d_parent->d_name.name, new_dentry->d_name.name,
-		 atomic_read(&new_dentry->d_count));
+		 new_dentry->d_count);
 
 	/*
 	 * For non-directories, check whether the target is busy and if so,
@@ -1860,7 +1860,7 @@ static int nfs_rename(struct inode *old_
 			rehash = new_dentry;
 		}
 
-		if (atomic_read(&new_dentry->d_count) > 2) {
+		if (new_dentry->d_count > 2) {
 			int err;
 
 			/* copy the target dentry's name */
Index: linux-2.6/fs/nfsd/vfs.c
===================================================================
--- linux-2.6.orig/fs/nfsd/vfs.c	2010-11-17 00:50:51.000000000 +1100
+++ linux-2.6/fs/nfsd/vfs.c	2010-11-17 00:52:37.000000000 +1100
@@ -1756,8 +1756,7 @@ nfsd_rename(struct svc_rqst *rqstp, stru
 		goto out_dput_new;
 
 	if (svc_msnfs(ffhp) &&
-		((atomic_read(&odentry->d_count) > 1)
-		 || (atomic_read(&ndentry->d_count) > 1))) {
+		((odentry->d_count > 1) || (ndentry->d_count > 1))) {
 			host_err = -EPERM;
 			goto out_dput_new;
 	}
@@ -1843,7 +1842,7 @@ nfsd_unlink(struct svc_rqst *rqstp, stru
 	if (type != S_IFDIR) { /* It's UNLINK */
 #ifdef MSNFS
 		if ((fhp->fh_export->ex_flags & NFSEXP_MSNFS) &&
-			(atomic_read(&rdentry->d_count) > 1)) {
+			(rdentry->d_count > 1)) {
 			host_err = -EPERM;
 		} else
 #endif
Index: linux-2.6/kernel/cgroup.c
===================================================================
--- linux-2.6.orig/kernel/cgroup.c	2010-11-17 00:50:51.000000000 +1100
+++ linux-2.6/kernel/cgroup.c	2010-11-17 01:05:45.000000000 +1100
@@ -3638,9 +3638,7 @@ static int cgroup_rmdir(struct inode *un
 	list_del(&cgrp->sibling);
 	cgroup_unlock_hierarchy(cgrp->root);
 
-	spin_lock(&cgrp->dentry->d_lock);
 	d = dget(cgrp->dentry);
-	spin_unlock(&d->d_lock);
 
 	cgroup_d_remove_dir(d);
 	dput(d);
Index: linux-2.6/arch/powerpc/platforms/cell/spufs/inode.c
===================================================================
--- linux-2.6.orig/arch/powerpc/platforms/cell/spufs/inode.c	2010-11-17 00:50:51.000000000 +1100
+++ linux-2.6/arch/powerpc/platforms/cell/spufs/inode.c	2010-11-17 01:05:45.000000000 +1100
@@ -162,7 +162,7 @@ static void spufs_prune_dir(struct dentr
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
--- linux-2.6.orig/drivers/infiniband/hw/ipath/ipath_fs.c	2010-11-17 00:50:51.000000000 +1100
+++ linux-2.6/drivers/infiniband/hw/ipath/ipath_fs.c	2010-11-17 01:05:42.000000000 +1100
@@ -280,7 +280,7 @@ static int remove_file(struct dentry *pa
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
--- linux-2.6.orig/fs/configfs/inode.c	2010-11-17 00:50:51.000000000 +1100
+++ linux-2.6/fs/configfs/inode.c	2010-11-17 01:05:42.000000000 +1100
@@ -253,7 +253,7 @@ void configfs_drop_dentry(struct configf
 		spin_lock(&dcache_lock);
 		spin_lock(&dentry->d_lock);
 		if (!(d_unhashed(dentry) && dentry->d_inode)) {
-			dget_locked(dentry);
+			dget_locked_dlock(dentry);
 			__d_drop(dentry);
 			spin_unlock(&dentry->d_lock);
 			spin_unlock(&dcache_lock);
Index: linux-2.6/fs/ceph/dir.c
===================================================================
--- linux-2.6.orig/fs/ceph/dir.c	2010-11-17 00:50:51.000000000 +1100
+++ linux-2.6/fs/ceph/dir.c	2010-11-17 01:05:45.000000000 +1100
@@ -149,7 +149,9 @@ static int __dcache_readdir(struct file
 		di = ceph_dentry(dentry);
 	}
 
-	atomic_inc(&dentry->d_count);
+	spin_lock(&dentry->d_lock);
+	dentry->d_count++;
+	spin_unlock(&dentry->d_lock);
 	spin_unlock(&dcache_lock);
 
 	dout(" %llu (%llu) dentry %p %.*s %p\n", di->offset, filp->f_pos,
Index: linux-2.6/fs/ceph/inode.c
===================================================================
--- linux-2.6.orig/fs/ceph/inode.c	2010-11-17 00:50:51.000000000 +1100
+++ linux-2.6/fs/ceph/inode.c	2010-11-17 01:05:45.000000000 +1100
@@ -866,8 +866,8 @@ static struct dentry *splice_dentry(stru
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
--- linux-2.6.orig/fs/ceph/mds_client.c	2010-11-17 00:50:51.000000000 +1100
+++ linux-2.6/fs/ceph/mds_client.c	2010-11-17 00:52:37.000000000 +1100
@@ -1452,7 +1452,7 @@ char *ceph_mdsc_build_path(struct dentry
 	*base = ceph_ino(temp->d_inode);
 	*plen = len;
 	dout("build_path on %p %d built %llx '%.*s'\n",
-	     dentry, atomic_read(&dentry->d_count), *base, len, path);
+	     dentry, dentry->d_count, *base, len, path);
 	return path;
 }
 
Index: linux-2.6/drivers/infiniband/hw/qib/qib_fs.c
===================================================================
--- linux-2.6.orig/drivers/infiniband/hw/qib/qib_fs.c	2010-11-17 00:50:51.000000000 +1100
+++ linux-2.6/drivers/infiniband/hw/qib/qib_fs.c	2010-11-17 01:05:42.000000000 +1100
@@ -456,7 +456,7 @@ static int remove_file(struct dentry *pa
 	spin_lock(&dcache_lock);
 	spin_lock(&tmp->d_lock);
 	if (!(d_unhashed(tmp) && tmp->d_inode)) {
-		dget_locked(tmp);
+		dget_locked_dlock(tmp);
 		__d_drop(tmp);
 		spin_unlock(&tmp->d_lock);
 		spin_unlock(&dcache_lock);
Index: linux-2.6/fs/autofs4/root.c
===================================================================
--- linux-2.6.orig/fs/autofs4/root.c	2010-11-17 00:50:51.000000000 +1100
+++ linux-2.6/fs/autofs4/root.c	2010-11-17 01:05:45.000000000 +1100
@@ -436,7 +436,7 @@ static struct dentry *autofs4_lookup_act
 		spin_lock(&active->d_lock);
 
 		/* Already gone? */
-		if (atomic_read(&active->d_count) == 0)
+		if (active->d_count == 0)
 			goto next;
 
 		qstr = &active->d_name;
@@ -452,7 +452,7 @@ static struct dentry *autofs4_lookup_act
 			goto next;
 
 		if (d_unhashed(active)) {
-			dget(active);
+			dget_dlock(active);
 			spin_unlock(&active->d_lock);
 			spin_unlock(&sbi->lookup_lock);
 			spin_unlock(&dcache_lock);
@@ -507,7 +507,7 @@ static struct dentry *autofs4_lookup_exp
 			goto next;
 
 		if (d_unhashed(expiring)) {
-			dget(expiring);
+			dget_dlock(expiring);
 			spin_unlock(&expiring->d_lock);
 			spin_unlock(&sbi->lookup_lock);
 			spin_unlock(&dcache_lock);
Index: linux-2.6/fs/nfs/unlink.c
===================================================================
--- linux-2.6.orig/fs/nfs/unlink.c	2010-11-17 00:50:51.000000000 +1100
+++ linux-2.6/fs/nfs/unlink.c	2010-11-17 00:52:37.000000000 +1100
@@ -496,7 +496,7 @@ nfs_sillyrename(struct inode *dir, struc
 
 	dfprintk(VFS, "NFS: silly-rename(%s/%s, ct=%d)\n",
 		dentry->d_parent->d_name.name, dentry->d_name.name,
-		atomic_read(&dentry->d_count));
+		dentry->d_count);
 	nfs_inc_stats(dir, NFSIOS_SILLYRENAME);
 
 	/*
Index: linux-2.6/fs/nilfs2/super.c
===================================================================
--- linux-2.6.orig/fs/nilfs2/super.c	2010-11-17 00:50:51.000000000 +1100
+++ linux-2.6/fs/nilfs2/super.c	2010-11-17 00:52:37.000000000 +1100
@@ -838,7 +838,7 @@ static int nilfs_attach_snapshot(struct
 
 static int nilfs_tree_was_touched(struct dentry *root_dentry)
 {
-	return atomic_read(&root_dentry->d_count) > 1;
+	return root_dentry->d_count > 1;
 }
 
 /**


