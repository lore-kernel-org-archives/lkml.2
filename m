Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758899Ab0KPOYM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 09:24:12 -0500
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:3958 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758690Ab0KPOYF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 09:24:05 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AiQJAKMh4kx5Ldur/2dsb2JhbACVYYx9cr5mgnWCVgSFEoVGhRA
Message-Id: <20101116142029.917387927@kernel.dk>
User-Agent: quilt/0.48-1
Date: Wed, 17 Nov 2010 01:09:18 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [patch 18/28] fs: dcache remove dcache_lock
References: <20101116140900.039761100@kernel.dk>
Content-Disposition: inline; filename=fs-dcache_lock-remove.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dcache_lock no longer protects anything. remove it.

Signed-off-by: Nick Piggin <npiggin@kernel.dk>

---
 Documentation/filesystems/Locking            |   16 +-
 Documentation/filesystems/dentry-locking.txt |   40 +++---
 Documentation/filesystems/porting            |    8 +
 arch/powerpc/platforms/cell/spufs/inode.c    |    5 
 drivers/infiniband/hw/ipath/ipath_fs.c       |    6 -
 drivers/infiniband/hw/qib/qib_fs.c           |    3 
 drivers/staging/pohmelfs/path_entry.c        |    2 
 drivers/staging/smbfs/cache.c                |    4 
 drivers/usb/core/inode.c                     |    3 
 fs/9p/vfs_inode.c                            |    2 
 fs/affs/amigaffs.c                           |    2 
 fs/autofs4/autofs_i.h                        |    3 
 fs/autofs4/expire.c                          |   10 -
 fs/autofs4/root.c                            |   44 +++----
 fs/autofs4/waitq.c                           |    7 -
 fs/ceph/dir.c                                |    6 -
 fs/ceph/inode.c                              |    4 
 fs/cifs/inode.c                              |    3 
 fs/coda/cache.c                              |    2 
 fs/configfs/configfs_internal.h              |    2 
 fs/configfs/inode.c                          |    6 -
 fs/dcache.c                                  |  162 ++++-----------------------
 fs/exportfs/expfs.c                          |    4 
 fs/libfs.c                                   |    8 -
 fs/namei.c                                   |    9 -
 fs/ncpfs/dir.c                               |   18 +--
 fs/ncpfs/ncplib_kernel.h                     |    4 
 fs/nfs/dir.c                                 |    3 
 fs/nfs/getroot.c                             |    2 
 fs/nfs/namespace.c                           |    3 
 fs/notify/fsnotify.c                         |    2 
 fs/ocfs2/dcache.c                            |    2 
 include/linux/dcache.h                       |    7 -
 include/linux/fs.h                           |    6 -
 include/linux/fsnotify.h                     |    2 
 include/linux/fsnotify_backend.h             |   11 +
 include/linux/namei.h                        |    1 
 kernel/cgroup.c                              |    6 -
 mm/filemap.c                                 |    3 
 security/selinux/selinuxfs.c                 |    4 
 40 files changed, 120 insertions(+), 315 deletions(-)

Index: linux-2.6/fs/dcache.c
===================================================================
--- linux-2.6.orig/fs/dcache.c	2010-11-17 00:52:37.000000000 +1100
+++ linux-2.6/fs/dcache.c	2010-11-17 01:05:40.000000000 +1100
@@ -54,11 +54,10 @@
  *   - d_alias, d_inode
  *
  * Ordering:
- * dcache_lock
- *   dcache_inode_lock
- *     dentry->d_lock
- *       dcache_lru_lock
- *       dcache_hash_lock
+ * dcache_inode_lock
+ *   dentry->d_lock
+ *     dcache_lru_lock
+ *     dcache_hash_lock
  *
  * If there is an ancestor relationship:
  * dentry->d_parent->...->d_parent->d_lock
@@ -77,13 +76,11 @@ EXPORT_SYMBOL_GPL(sysctl_vfs_cache_press
 __cacheline_aligned_in_smp DEFINE_SPINLOCK(dcache_inode_lock);
 __cacheline_aligned_in_smp DEFINE_SPINLOCK(dcache_hash_lock);
 static __cacheline_aligned_in_smp DEFINE_SPINLOCK(dcache_lru_lock);
-__cacheline_aligned_in_smp DEFINE_SPINLOCK(dcache_lock);
 __cacheline_aligned_in_smp DEFINE_SEQLOCK(rename_lock);
 
 EXPORT_SYMBOL(rename_lock);
 EXPORT_SYMBOL(dcache_inode_lock);
 EXPORT_SYMBOL(dcache_hash_lock);
-EXPORT_SYMBOL(dcache_lock);
 
 static struct kmem_cache *dentry_cache __read_mostly;
 
@@ -133,7 +130,7 @@ static void __d_free(struct rcu_head *he
 }
 
 /*
- * no dcache_lock, please.
+ * no locks, please.
  */
 static void d_free(struct dentry *dentry)
 {
@@ -156,7 +153,6 @@ static void d_free(struct dentry *dentry
 static void dentry_iput(struct dentry * dentry)
 	__releases(dentry->d_lock)
 	__releases(dcache_inode_lock)
-	__releases(dcache_lock)
 {
 	struct inode *inode = dentry->d_inode;
 	if (inode) {
@@ -164,7 +160,6 @@ static void dentry_iput(struct dentry *
 		list_del_init(&dentry->d_alias);
 		spin_unlock(&dentry->d_lock);
 		spin_unlock(&dcache_inode_lock);
-		spin_unlock(&dcache_lock);
 		if (!inode->i_nlink)
 			fsnotify_inoderemove(inode);
 		if (dentry->d_op && dentry->d_op->d_iput)
@@ -174,7 +169,6 @@ static void dentry_iput(struct dentry *
 	} else {
 		spin_unlock(&dentry->d_lock);
 		spin_unlock(&dcache_inode_lock);
-		spin_unlock(&dcache_lock);
 	}
 }
 
@@ -229,14 +223,13 @@ static void dentry_lru_move_tail(struct
  *
  * If this is the root of the dentry tree, return NULL.
  *
- * dcache_lock and d_lock and d_parent->d_lock must be held by caller, and
- * are dropped by d_kill.
+ * dentry->d_lock and parent->d_lock must be held by caller, and are dropped by
+ * d_kill.
  */
 static struct dentry *d_kill(struct dentry *dentry, struct dentry *parent)
 	__releases(dentry->d_lock)
 	__releases(parent->d_lock)
 	__releases(dcache_inode_lock)
-	__releases(dcache_lock)
 {
 	dentry->d_parent = NULL;
 	list_del(&dentry->d_u.d_child);
@@ -295,21 +288,10 @@ void dput(struct dentry *dentry)
 	else
 		parent = dentry->d_parent;
 	if (dentry->d_count == 1) {
-		if (!spin_trylock(&dcache_lock)) {
-			/*
-			 * Something of a livelock possibility we could avoid
-			 * by taking dcache_lock and trying again, but we
-			 * want to reduce dcache_lock anyway so this will
-			 * get improved.
-			 */
-drop1:
-			spin_unlock(&dentry->d_lock);
-			goto repeat;
-		}
 		if (!spin_trylock(&dcache_inode_lock)) {
 drop2:
-			spin_unlock(&dcache_lock);
-			goto drop1;
+			spin_unlock(&dentry->d_lock);
+			goto repeat;
 		}
 		if (parent && !spin_trylock(&parent->d_lock)) {
 			spin_unlock(&dcache_inode_lock);
@@ -321,7 +303,6 @@ void dput(struct dentry *dentry)
 		spin_unlock(&dentry->d_lock);
 		if (parent)
 			spin_unlock(&parent->d_lock);
-		spin_unlock(&dcache_lock);
 		return;
 	}
 
@@ -345,7 +326,6 @@ void dput(struct dentry *dentry)
 	if (parent)
 		spin_unlock(&parent->d_lock);
 	spin_unlock(&dcache_inode_lock);
-	spin_unlock(&dcache_lock);
 	return;
 
 unhash_it:
@@ -376,11 +356,9 @@ int d_invalidate(struct dentry * dentry)
 	/*
 	 * If it's already been dropped, return OK.
 	 */
-	spin_lock(&dcache_lock);
 	spin_lock(&dentry->d_lock);
 	if (d_unhashed(dentry)) {
 		spin_unlock(&dentry->d_lock);
-		spin_unlock(&dcache_lock);
 		return 0;
 	}
 	/*
@@ -389,9 +367,7 @@ int d_invalidate(struct dentry * dentry)
 	 */
 	if (!list_empty(&dentry->d_subdirs)) {
 		spin_unlock(&dentry->d_lock);
-		spin_unlock(&dcache_lock);
 		shrink_dcache_parent(dentry);
-		spin_lock(&dcache_lock);
 		spin_lock(&dentry->d_lock);
 	}
 
@@ -408,19 +384,17 @@ int d_invalidate(struct dentry * dentry)
 	if (dentry->d_count > 1) {
 		if (dentry->d_inode && S_ISDIR(dentry->d_inode->i_mode)) {
 			spin_unlock(&dentry->d_lock);
-			spin_unlock(&dcache_lock);
 			return -EBUSY;
 		}
 	}
 
 	__d_drop(dentry);
 	spin_unlock(&dentry->d_lock);
-	spin_unlock(&dcache_lock);
 	return 0;
 }
 EXPORT_SYMBOL(d_invalidate);
 
-/* This must be called with dcache_lock and d_lock held */
+/* This must be called with d_lock held */
 static inline struct dentry * __dget_locked_dlock(struct dentry *dentry)
 {
 	dentry->d_count++;
@@ -428,7 +402,7 @@ static inline struct dentry * __dget_loc
 	return dentry;
 }
 
-/* This should be called _only_ with dcache_lock held */
+/* This must be called with d_lock held */
 static inline struct dentry * __dget_locked(struct dentry *dentry)
 {
 	spin_lock(&dentry->d_lock);
@@ -538,11 +512,9 @@ struct dentry *d_find_alias(struct inode
 	struct dentry *de = NULL;
 
 	if (!list_empty(&inode->i_dentry)) {
-		spin_lock(&dcache_lock);
 		spin_lock(&dcache_inode_lock);
 		de = __d_find_alias(inode, 0);
 		spin_unlock(&dcache_inode_lock);
-		spin_unlock(&dcache_lock);
 	}
 	return de;
 }
@@ -556,7 +528,6 @@ void d_prune_aliases(struct inode *inode
 {
 	struct dentry *dentry;
 restart:
-	spin_lock(&dcache_lock);
 	spin_lock(&dcache_inode_lock);
 	list_for_each_entry(dentry, &inode->i_dentry, d_alias) {
 		spin_lock(&dentry->d_lock);
@@ -565,14 +536,12 @@ void d_prune_aliases(struct inode *inode
 			__d_drop(dentry);
 			spin_unlock(&dentry->d_lock);
 			spin_unlock(&dcache_inode_lock);
-			spin_unlock(&dcache_lock);
 			dput(dentry);
 			goto restart;
 		}
 		spin_unlock(&dentry->d_lock);
 	}
 	spin_unlock(&dcache_inode_lock);
-	spin_unlock(&dcache_lock);
 }
 EXPORT_SYMBOL(d_prune_aliases);
 
@@ -588,17 +557,14 @@ static void prune_one_dentry(struct dent
 	__releases(dentry->d_lock)
 	__releases(parent->d_lock)
 	__releases(dcache_inode_lock)
-	__releases(dcache_lock)
 {
 	__d_drop(dentry);
 	dentry = d_kill(dentry, parent);
 
 	/*
-	 * Prune ancestors.  Locking is simpler than in dput(),
-	 * because dcache_lock needs to be taken anyway.
+	 * Prune ancestors.
 	 */
 	while (dentry) {
-		spin_lock(&dcache_lock);
 		spin_lock(&dcache_inode_lock);
 again:
 		spin_lock(&dentry->d_lock);
@@ -616,7 +582,6 @@ static void prune_one_dentry(struct dent
 				spin_unlock(&parent->d_lock);
 			spin_unlock(&dentry->d_lock);
 			spin_unlock(&dcache_inode_lock);
-			spin_unlock(&dcache_lock);
 			return;
 		}
 
@@ -665,8 +630,7 @@ static void shrink_dentry_list(struct li
 		spin_unlock(&dcache_lru_lock);
 
 		prune_one_dentry(dentry, parent);
-		/* dcache_lock, dcache_inode_lock and dentry->d_lock dropped */
-		spin_lock(&dcache_lock);
+		/* dcache_inode_lock and dentry->d_lock dropped */
 		spin_lock(&dcache_inode_lock);
 		spin_lock(&dcache_lru_lock);
 	}
@@ -688,7 +652,6 @@ static void __shrink_dcache_sb(struct su
 	LIST_HEAD(tmp);
 	int cnt = *count;
 
-	spin_lock(&dcache_lock);
 	spin_lock(&dcache_inode_lock);
 relock:
 	spin_lock(&dcache_lru_lock);
@@ -719,7 +682,6 @@ static void __shrink_dcache_sb(struct su
 			if (!--cnt)
 				break;
 		}
-		/* XXX: re-add cond_resched_lock when dcache_lock goes away */
 	}
 
 	*count = cnt;
@@ -729,7 +691,6 @@ static void __shrink_dcache_sb(struct su
 		list_splice(&referenced, &sb->s_dentry_lru);
 	spin_unlock(&dcache_lru_lock);
 	spin_unlock(&dcache_inode_lock);
-	spin_unlock(&dcache_lock);
 }
 
 /**
@@ -751,7 +712,6 @@ static void prune_dcache(int count)
 
 	if (unused == 0 || count == 0)
 		return;
-	spin_lock(&dcache_lock);
 	if (count >= unused)
 		prune_ratio = 1;
 	else
@@ -788,11 +748,9 @@ static void prune_dcache(int count)
 		if (down_read_trylock(&sb->s_umount)) {
 			if ((sb->s_root != NULL) &&
 			    (!list_empty(&sb->s_dentry_lru))) {
-				spin_unlock(&dcache_lock);
 				__shrink_dcache_sb(sb, &w_count,
 						DCACHE_REFERENCED);
 				pruned -= w_count;
-				spin_lock(&dcache_lock);
 			}
 			up_read(&sb->s_umount);
 		}
@@ -808,7 +766,6 @@ static void prune_dcache(int count)
 	if (p)
 		__put_super(p);
 	spin_unlock(&sb_lock);
-	spin_unlock(&dcache_lock);
 }
 
 /**
@@ -822,7 +779,6 @@ void shrink_dcache_sb(struct super_block
 {
 	LIST_HEAD(tmp);
 
-	spin_lock(&dcache_lock);
 	spin_lock(&dcache_inode_lock);
 	spin_lock(&dcache_lru_lock);
 	while (!list_empty(&sb->s_dentry_lru)) {
@@ -831,7 +787,6 @@ void shrink_dcache_sb(struct super_block
 	}
 	spin_unlock(&dcache_lru_lock);
 	spin_unlock(&dcache_inode_lock);
-	spin_unlock(&dcache_lock);
 }
 EXPORT_SYMBOL(shrink_dcache_sb);
 
@@ -848,12 +803,10 @@ static void shrink_dcache_for_umount_sub
 	BUG_ON(!IS_ROOT(dentry));
 
 	/* detach this root from the system */
-	spin_lock(&dcache_lock);
 	spin_lock(&dentry->d_lock);
 	dentry_lru_del(dentry);
 	__d_drop(dentry);
 	spin_unlock(&dentry->d_lock);
-	spin_unlock(&dcache_lock);
 
 	for (;;) {
 		/* descend to the first leaf in the current subtree */
@@ -862,7 +815,6 @@ static void shrink_dcache_for_umount_sub
 
 			/* this is a branch with children - detach all of them
 			 * from the system in one go */
-			spin_lock(&dcache_lock);
 			spin_lock(&dentry->d_lock);
 			list_for_each_entry(loop, &dentry->d_subdirs,
 					    d_u.d_child) {
@@ -873,7 +825,6 @@ static void shrink_dcache_for_umount_sub
 				spin_unlock(&loop->d_lock);
 			}
 			spin_unlock(&dentry->d_lock);
-			spin_unlock(&dcache_lock);
 
 			/* move to the first child */
 			dentry = list_entry(dentry->d_subdirs.next,
@@ -940,8 +891,7 @@ static void shrink_dcache_for_umount_sub
 
 /*
  * destroy the dentries attached to a superblock on unmounting
- * - we don't need to use dentry->d_lock, and only need dcache_lock when
- *   removing the dentry from the system lists and hashes because:
+ * - we don't need to use dentry->d_lock because:
  *   - the superblock is detached from all mountings and open files, so the
  *     dentry trees will not be rearranged by the VFS
  *   - s_umount is write-locked, so the memory pressure shrinker will ignore
@@ -992,7 +942,6 @@ int have_submounts(struct dentry *parent
 	this_parent = parent;
 	seq = read_seqbegin(&rename_lock);
 
-	spin_lock(&dcache_lock);
 	if (d_mountpoint(parent))
 		goto positive;
 	spin_lock(&this_parent->d_lock);
@@ -1038,7 +987,6 @@ int have_submounts(struct dentry *parent
 		if (this_parent != child->d_parent ||
 				read_seqretry(&rename_lock, seq)) {
 			spin_unlock(&this_parent->d_lock);
-			spin_unlock(&dcache_lock);
 			rcu_read_unlock();
 			goto rename_retry;
 		}
@@ -1047,12 +995,10 @@ int have_submounts(struct dentry *parent
 		goto resume;
 	}
 	spin_unlock(&this_parent->d_lock);
-	spin_unlock(&dcache_lock);
 	if (read_seqretry(&rename_lock, seq))
 		goto rename_retry;
 	return 0; /* No mount points found in tree */
 positive:
-	spin_unlock(&dcache_lock);
 	if (read_seqretry(&rename_lock, seq))
 		goto rename_retry;
 	return 1;
@@ -1084,7 +1030,6 @@ static int select_parent(struct dentry *
 	this_parent = parent;
 	seq = read_seqbegin(&rename_lock);
 
-	spin_lock(&dcache_lock);
 	spin_lock(&this_parent->d_lock);
 repeat:
 	next = this_parent->d_subdirs.next;
@@ -1148,7 +1093,6 @@ static int select_parent(struct dentry *
 		if (this_parent != child->d_parent ||
 				read_seqretry(&rename_lock, seq)) {
 			spin_unlock(&this_parent->d_lock);
-			spin_unlock(&dcache_lock);
 			rcu_read_unlock();
 			goto rename_retry;
 		}
@@ -1158,7 +1102,6 @@ static int select_parent(struct dentry *
 	}
 out:
 	spin_unlock(&this_parent->d_lock);
-	spin_unlock(&dcache_lock);
 	if (read_seqretry(&rename_lock, seq))
 		goto rename_retry;
 	return found;
@@ -1263,7 +1206,6 @@ struct dentry *d_alloc(struct dentry * p
 	INIT_LIST_HEAD(&dentry->d_u.d_child);
 
 	if (parent) {
-		spin_lock(&dcache_lock);
 		spin_lock(&parent->d_lock);
 		spin_lock_nested(&dentry->d_lock, DENTRY_D_LOCK_NESTED);
 		dentry->d_parent = dget_dlock(parent);
@@ -1271,7 +1213,6 @@ struct dentry *d_alloc(struct dentry * p
 		list_add(&dentry->d_u.d_child, &parent->d_subdirs);
 		spin_unlock(&dentry->d_lock);
 		spin_unlock(&parent->d_lock);
-		spin_unlock(&dcache_lock);
 	}
 
 	percpu_counter_inc(&nr_dentry);
@@ -1291,7 +1232,6 @@ struct dentry *d_alloc_name(struct dentr
 }
 EXPORT_SYMBOL(d_alloc_name);
 
-/* the caller must hold dcache_lock */
 static void __d_instantiate(struct dentry *dentry, struct inode *inode)
 {
 	spin_lock(&dentry->d_lock);
@@ -1320,11 +1260,9 @@ static void __d_instantiate(struct dentr
 void d_instantiate(struct dentry *entry, struct inode * inode)
 {
 	BUG_ON(!list_empty(&entry->d_alias));
-	spin_lock(&dcache_lock);
 	spin_lock(&dcache_inode_lock);
 	__d_instantiate(entry, inode);
 	spin_unlock(&dcache_inode_lock);
-	spin_unlock(&dcache_lock);
 	security_d_instantiate(entry, inode);
 }
 EXPORT_SYMBOL(d_instantiate);
@@ -1387,11 +1325,9 @@ struct dentry *d_instantiate_unique(stru
 
 	BUG_ON(!list_empty(&entry->d_alias));
 
-	spin_lock(&dcache_lock);
 	spin_lock(&dcache_inode_lock);
 	result = __d_instantiate_unique(entry, inode);
 	spin_unlock(&dcache_inode_lock);
-	spin_unlock(&dcache_lock);
 
 	if (!result) {
 		security_d_instantiate(entry, inode);
@@ -1480,12 +1416,11 @@ struct dentry *d_obtain_alias(struct ino
 	}
 	tmp->d_parent = tmp; /* make sure dput doesn't croak */
 
-	spin_lock(&dcache_lock);
+
 	spin_lock(&dcache_inode_lock);
 	res = __d_find_alias(inode, 0);
 	if (res) {
 		spin_unlock(&dcache_inode_lock);
-		spin_unlock(&dcache_lock);
 		dput(tmp);
 		goto out_iput;
 	}
@@ -1503,7 +1438,6 @@ struct dentry *d_obtain_alias(struct ino
 	spin_unlock(&tmp->d_lock);
 	spin_unlock(&dcache_inode_lock);
 
-	spin_unlock(&dcache_lock);
 	return tmp;
 
  out_iput:
@@ -1533,21 +1467,18 @@ struct dentry *d_splice_alias(struct ino
 	struct dentry *new = NULL;
 
 	if (inode && S_ISDIR(inode->i_mode)) {
-		spin_lock(&dcache_lock);
 		spin_lock(&dcache_inode_lock);
 		new = __d_find_alias(inode, 1);
 		if (new) {
 			BUG_ON(!(new->d_flags & DCACHE_DISCONNECTED));
 			spin_unlock(&dcache_inode_lock);
-			spin_unlock(&dcache_lock);
 			security_d_instantiate(new, inode);
 			d_move(new, dentry);
 			iput(inode);
 		} else {
-			/* already taking dcache_lock, so d_add() by hand */
+			/* already taking dcache_inode_lock, so d_add() by hand */
 			__d_instantiate(dentry, inode);
 			spin_unlock(&dcache_inode_lock);
-			spin_unlock(&dcache_lock);
 			security_d_instantiate(dentry, inode);
 			d_rehash(dentry);
 		}
@@ -1620,12 +1551,10 @@ struct dentry *d_add_ci(struct dentry *d
 	 * Negative dentry: instantiate it unless the inode is a directory and
 	 * already has a dentry.
 	 */
-	spin_lock(&dcache_lock);
 	spin_lock(&dcache_inode_lock);
 	if (!S_ISDIR(inode->i_mode) || list_empty(&inode->i_dentry)) {
 		__d_instantiate(found, inode);
 		spin_unlock(&dcache_inode_lock);
-		spin_unlock(&dcache_lock);
 		security_d_instantiate(found, inode);
 		return found;
 	}
@@ -1637,7 +1566,6 @@ struct dentry *d_add_ci(struct dentry *d
 	new = list_entry(inode->i_dentry.next, struct dentry, d_alias);
 	dget_locked(new);
 	spin_unlock(&dcache_inode_lock);
-	spin_unlock(&dcache_lock);
 	security_d_instantiate(found, inode);
 	d_move(new, found);
 	iput(inode);
@@ -1808,7 +1736,6 @@ int d_validate(struct dentry *dentry, st
 {
 	struct dentry *child;
 
-	spin_lock(&dcache_lock);
 	spin_lock(&dparent->d_lock);
 	list_for_each_entry(child, &dparent->d_subdirs, d_u.d_child) {
 		if (dentry == child) {
@@ -1816,12 +1743,10 @@ int d_validate(struct dentry *dentry, st
 			__dget_locked_dlock(dentry);
 			spin_unlock(&dentry->d_lock);
 			spin_unlock(&dparent->d_lock);
-			spin_unlock(&dcache_lock);
 			return 1;
 		}
 	}
 	spin_unlock(&dparent->d_lock);
-	spin_unlock(&dcache_lock);
 
 	return 0;
 }
@@ -1854,7 +1779,6 @@ void d_delete(struct dentry * dentry)
 	/*
 	 * Are we the only user?
 	 */
-	spin_lock(&dcache_lock);
 	spin_lock(&dcache_inode_lock);
 	spin_lock(&dentry->d_lock);
 	isdir = S_ISDIR(dentry->d_inode->i_mode);
@@ -1870,7 +1794,6 @@ void d_delete(struct dentry * dentry)
 
 	spin_unlock(&dentry->d_lock);
 	spin_unlock(&dcache_inode_lock);
-	spin_unlock(&dcache_lock);
 
 	fsnotify_nameremove(dentry, isdir);
 }
@@ -1897,13 +1820,11 @@ static void _d_rehash(struct dentry * en
  
 void d_rehash(struct dentry * entry)
 {
-	spin_lock(&dcache_lock);
 	spin_lock(&entry->d_lock);
 	spin_lock(&dcache_hash_lock);
 	_d_rehash(entry);
 	spin_unlock(&dcache_hash_lock);
 	spin_unlock(&entry->d_lock);
-	spin_unlock(&dcache_lock);
 }
 EXPORT_SYMBOL(d_rehash);
 
@@ -1972,14 +1893,14 @@ static void switch_names(struct dentry *
  */
  
 /*
- * d_move_locked - move a dentry
+ * d_move - move a dentry
  * @dentry: entry to move
  * @target: new dentry
  *
  * Update the dcache to reflect the move of a file name. Negative
  * dcache entries should not be moved in this way.
  */
-static void d_move_locked(struct dentry * dentry, struct dentry * target)
+void d_move(struct dentry * dentry, struct dentry * target)
 {
 	if (!dentry->d_inode)
 		printk(KERN_WARNING "VFS: moving negative dcache entry\n");
@@ -2049,22 +1970,6 @@ static void d_move_locked(struct dentry
 	spin_unlock(&dentry->d_lock);
 	write_sequnlock(&rename_lock);
 }
-
-/**
- * d_move - move a dentry
- * @dentry: entry to move
- * @target: new dentry
- *
- * Update the dcache to reflect the move of a file name. Negative
- * dcache entries should not be moved in this way.
- */
-
-void d_move(struct dentry * dentry, struct dentry * target)
-{
-	spin_lock(&dcache_lock);
-	d_move_locked(dentry, target);
-	spin_unlock(&dcache_lock);
-}
 EXPORT_SYMBOL(d_move);
 
 /**
@@ -2090,13 +1995,12 @@ struct dentry *d_ancestor(struct dentry
  * This helper attempts to cope with remotely renamed directories
  *
  * It assumes that the caller is already holding
- * dentry->d_parent->d_inode->i_mutex and the dcache_lock
+ * dentry->d_parent->d_inode->i_mutex and the dcache_inode_lock
  *
  * Note: If ever the locking in lock_rename() changes, then please
  * remember to update this too...
  */
 static struct dentry *__d_unalias(struct dentry *dentry, struct dentry *alias)
-	__releases(dcache_lock)
 	__releases(dcache_inode_lock)
 {
 	struct mutex *m1 = NULL, *m2 = NULL;
@@ -2120,11 +2024,10 @@ static struct dentry *__d_unalias(struct
 		goto out_err;
 	m2 = &alias->d_parent->d_inode->i_mutex;
 out_unalias:
-	d_move_locked(alias, dentry);
+	d_move(alias, dentry);
 	ret = alias;
 out_err:
 	spin_unlock(&dcache_inode_lock);
-	spin_unlock(&dcache_lock);
 	if (m2)
 		mutex_unlock(m2);
 	if (m1)
@@ -2188,7 +2091,6 @@ struct dentry *d_materialise_unique(stru
 
 	BUG_ON(!d_unhashed(dentry));
 
-	spin_lock(&dcache_lock);
 	spin_lock(&dcache_inode_lock);
 
 	if (!inode) {
@@ -2203,6 +2105,11 @@ struct dentry *d_materialise_unique(stru
 		/* Does an aliased dentry already exist? */
 		alias = __d_find_alias(inode, 0);
 		if (alias) {
+			/*
+			 * XXX: after dcache_lock removal, we no longer
+			 * guarantee a !d_unhashed alias here. Is that going to
+			 * be a problem?
+			 */
 			actual = alias;
 			/* Is this an anonymous mountpoint that we could splice
 			 * into our tree? */
@@ -2234,7 +2141,6 @@ struct dentry *d_materialise_unique(stru
 	spin_unlock(&dcache_hash_lock);
 	spin_unlock(&actual->d_lock);
 	spin_unlock(&dcache_inode_lock);
-	spin_unlock(&dcache_lock);
 out_nolock:
 	if (actual == dentry) {
 		security_d_instantiate(dentry, inode);
@@ -2246,7 +2152,6 @@ struct dentry *d_materialise_unique(stru
 
 shouldnt_be_hashed:
 	spin_unlock(&dcache_inode_lock);
-	spin_unlock(&dcache_lock);
 	BUG();
 }
 EXPORT_SYMBOL_GPL(d_materialise_unique);
@@ -2360,11 +2265,9 @@ char *__d_path(const struct path *path,
 	int error;
 
 	prepend(&res, &buflen, "\0", 1);
-	spin_lock(&dcache_lock);
 	write_seqlock(&rename_lock);
 	error = prepend_path(path, root, &res, &buflen);
 	write_sequnlock(&rename_lock);
-	spin_unlock(&dcache_lock);
 
 	if (error)
 		return ERR_PTR(error);
@@ -2426,14 +2329,12 @@ char *d_path(const struct path *path, ch
 		return path->dentry->d_op->d_dname(path->dentry, buf, buflen);
 
 	get_fs_root(current->fs, &root);
-	spin_lock(&dcache_lock);
 	write_seqlock(&rename_lock);
 	tmp = root;
 	error = path_with_deleted(path, &tmp, &res, &buflen);
 	if (error)
 		res = ERR_PTR(error);
 	write_sequnlock(&rename_lock);
-	spin_unlock(&dcache_lock);
 	path_put(&root);
 	return res;
 }
@@ -2459,14 +2360,12 @@ char *d_path_with_unreachable(const stru
 		return path->dentry->d_op->d_dname(path->dentry, buf, buflen);
 
 	get_fs_root(current->fs, &root);
-	spin_lock(&dcache_lock);
 	write_seqlock(&rename_lock);
 	tmp = root;
 	error = path_with_deleted(path, &tmp, &res, &buflen);
 	if (!error && !path_equal(&tmp, &root))
 		error = prepend_unreachable(&res, &buflen);
 	write_sequnlock(&rename_lock);
-	spin_unlock(&dcache_lock);
 	path_put(&root);
 	if (error)
 		res =  ERR_PTR(error);
@@ -2533,11 +2432,9 @@ char *dentry_path_raw(struct dentry *den
 {
 	char *retval;
 
-	spin_lock(&dcache_lock);
 	write_seqlock(&rename_lock);
 	retval = __dentry_path(dentry, buf, buflen);
 	write_sequnlock(&rename_lock);
-	spin_unlock(&dcache_lock);
 
 	return retval;
 }
@@ -2548,7 +2445,6 @@ char *dentry_path(struct dentry *dentry,
 	char *p = NULL;
 	char *retval;
 
-	spin_lock(&dcache_lock);
 	write_seqlock(&rename_lock);
 	if (d_unlinked(dentry)) {
 		p = buf + buflen;
@@ -2558,12 +2454,10 @@ char *dentry_path(struct dentry *dentry,
 	}
 	retval = __dentry_path(dentry, buf, buflen);
 	write_sequnlock(&rename_lock);
-	spin_unlock(&dcache_lock);
 	if (!IS_ERR(retval) && p)
 		*p = '/';	/* restore '/' overriden with '\0' */
 	return retval;
 Elong:
-	spin_unlock(&dcache_lock);
 	return ERR_PTR(-ENAMETOOLONG);
 }
 
@@ -2597,7 +2491,6 @@ SYSCALL_DEFINE2(getcwd, char __user *, b
 	get_fs_root_and_pwd(current->fs, &root, &pwd);
 
 	error = -ENOENT;
-	spin_lock(&dcache_lock);
 	write_seqlock(&rename_lock);
 	if (!d_unlinked(pwd.dentry)) {
 		unsigned long len;
@@ -2608,7 +2501,6 @@ SYSCALL_DEFINE2(getcwd, char __user *, b
 		prepend(&cwd, &buflen, "\0", 1);
 		error = prepend_path(&pwd, &tmp, &cwd, &buflen);
 		write_sequnlock(&rename_lock);
-		spin_unlock(&dcache_lock);
 
 		if (error)
 			goto out;
@@ -2629,7 +2521,6 @@ SYSCALL_DEFINE2(getcwd, char __user *, b
 		}
 	} else {
 		write_sequnlock(&rename_lock);
-		spin_unlock(&dcache_lock);
 	}
 
 out:
@@ -2715,7 +2606,6 @@ void d_genocide(struct dentry *root)
 rename_retry:
 	this_parent = root;
 	seq = read_seqbegin(&rename_lock);
-	spin_lock(&dcache_lock);
 	spin_lock(&this_parent->d_lock);
 repeat:
 	next = this_parent->d_subdirs.next;
@@ -2762,7 +2652,6 @@ void d_genocide(struct dentry *root)
 		if (this_parent != child->d_parent ||
 				read_seqretry(&rename_lock, seq)) {
 			spin_unlock(&this_parent->d_lock);
-			spin_unlock(&dcache_lock);
 			rcu_read_unlock();
 			goto rename_retry;
 		}
@@ -2771,7 +2660,6 @@ void d_genocide(struct dentry *root)
 		goto resume;
 	}
 	spin_unlock(&this_parent->d_lock);
-	spin_unlock(&dcache_lock);
 	if (read_seqretry(&rename_lock, seq))
 		goto rename_retry;
 }
Index: linux-2.6/fs/namei.c
===================================================================
--- linux-2.6.orig/fs/namei.c	2010-11-17 00:52:37.000000000 +1100
+++ linux-2.6/fs/namei.c	2010-11-17 00:52:37.000000000 +1100
@@ -612,8 +612,8 @@ int follow_up(struct path *path)
 	return 1;
 }
 
-/* no need for dcache_lock, as serialization is taken care in
- * namespace.c
+/*
+ * serialization is taken care of in namespace.c
  */
 static int __follow_mount(struct path *path)
 {
@@ -645,9 +645,6 @@ static void follow_mount(struct path *pa
 	}
 }
 
-/* no need for dcache_lock, as serialization is taken care in
- * namespace.c
- */
 int follow_down(struct path *path)
 {
 	struct vfsmount *mounted;
@@ -2128,12 +2125,10 @@ void dentry_unhash(struct dentry *dentry
 {
 	dget(dentry);
 	shrink_dcache_parent(dentry);
-	spin_lock(&dcache_lock);
 	spin_lock(&dentry->d_lock);
 	if (dentry->d_count == 2)
 		__d_drop(dentry);
 	spin_unlock(&dentry->d_lock);
-	spin_unlock(&dcache_lock);
 }
 
 int vfs_rmdir(struct inode *dir, struct dentry *dentry)
Index: linux-2.6/include/linux/dcache.h
===================================================================
--- linux-2.6.orig/include/linux/dcache.h	2010-11-17 00:52:37.000000000 +1100
+++ linux-2.6/include/linux/dcache.h	2010-11-17 01:05:39.000000000 +1100
@@ -184,7 +184,6 @@ struct dentry_operations {
 
 extern spinlock_t dcache_inode_lock;
 extern spinlock_t dcache_hash_lock;
-extern spinlock_t dcache_lock;
 extern seqlock_t rename_lock;
 
 /**
@@ -215,11 +214,9 @@ static inline void __d_drop(struct dentr
 
 static inline void d_drop(struct dentry *dentry)
 {
-	spin_lock(&dcache_lock);
 	spin_lock(&dentry->d_lock);
  	__d_drop(dentry);
 	spin_unlock(&dentry->d_lock);
-	spin_unlock(&dcache_lock);
 }
 
 static inline int dname_external(struct dentry *dentry)
@@ -328,8 +325,8 @@ extern char *dentry_path(struct dentry *
  *	destroyed when it has references. dget() should never be
  *	called for dentries with zero reference counter. For these cases
  *	(preferably none, functions in dcache.c are sufficient for normal
- *	needs and they take necessary precautions) you should hold dcache_lock
- *	and call dget_locked() instead of dget().
+ *	needs and they take necessary precautions) you should hold d_lock
+ *	and call dget_dlock() instead of dget().
  */
 static inline struct dentry *dget_dlock(struct dentry *dentry)
 {
Index: linux-2.6/fs/exportfs/expfs.c
===================================================================
--- linux-2.6.orig/fs/exportfs/expfs.c	2010-11-17 00:52:37.000000000 +1100
+++ linux-2.6/fs/exportfs/expfs.c	2010-11-17 01:05:39.000000000 +1100
@@ -47,24 +47,20 @@ find_acceptable_alias(struct dentry *res
 	if (acceptable(context, result))
 		return result;
 
-	spin_lock(&dcache_lock);
 	spin_lock(&dcache_inode_lock);
 	list_for_each_entry(dentry, &result->d_inode->i_dentry, d_alias) {
 		dget_locked(dentry);
 		spin_unlock(&dcache_inode_lock);
-		spin_unlock(&dcache_lock);
 		if (toput)
 			dput(toput);
 		if (dentry != result && acceptable(context, dentry)) {
 			dput(result);
 			return dentry;
 		}
-		spin_lock(&dcache_lock);
 		spin_lock(&dcache_inode_lock);
 		toput = dentry;
 	}
 	spin_unlock(&dcache_inode_lock);
-	spin_unlock(&dcache_lock);
 
 	if (toput)
 		dput(toput);
Index: linux-2.6/Documentation/filesystems/Locking
===================================================================
--- linux-2.6.orig/Documentation/filesystems/Locking	2010-11-17 00:52:37.000000000 +1100
+++ linux-2.6/Documentation/filesystems/Locking	2010-11-17 00:52:37.000000000 +1100
@@ -22,14 +22,14 @@ be able to use diff(1).
 
 locking rules:
 	none have BKL
-		dcache_lock	rename_lock	->d_lock	may block
-d_revalidate:	no		no		no		yes
-d_hash		no		no		no		no
-d_compare:	no		yes		no		no 
-d_delete:	yes		no		yes		no
-d_release:	no		no		no		yes
-d_iput:		no		no		no		yes
-d_dname:	no		no		no		no
+		rename_lock	->d_lock	may block
+d_revalidate:	no		no		yes
+d_hash		no		no		no
+d_compare:	yes		no		no
+d_delete:	no		yes		no
+d_release:	no		no		yes
+d_iput:		no		no		yes
+d_dname:	no		no		no
 
 --------------------------- inode_operations --------------------------- 
 prototypes:
Index: linux-2.6/arch/powerpc/platforms/cell/spufs/inode.c
===================================================================
--- linux-2.6.orig/arch/powerpc/platforms/cell/spufs/inode.c	2010-11-17 00:52:37.000000000 +1100
+++ linux-2.6/arch/powerpc/platforms/cell/spufs/inode.c	2010-11-17 01:05:39.000000000 +1100
@@ -159,21 +159,18 @@ static void spufs_prune_dir(struct dentr
 
 	mutex_lock(&dir->d_inode->i_mutex);
 	list_for_each_entry_safe(dentry, tmp, &dir->d_subdirs, d_u.d_child) {
-		spin_lock(&dcache_lock);
 		spin_lock(&dentry->d_lock);
 		if (!(d_unhashed(dentry)) && dentry->d_inode) {
 			dget_locked_dlock(dentry);
 			__d_drop(dentry);
 			spin_unlock(&dentry->d_lock);
 			simple_unlink(dir->d_inode, dentry);
-			/* XXX: what is dcache_lock protecting here? Other
+			/* XXX: what was dcache_lock protecting here? Other
 			 * filesystems (IB, configfs) release dcache_lock
 			 * before unlink */
-			spin_unlock(&dcache_lock);
 			dput(dentry);
 		} else {
 			spin_unlock(&dentry->d_lock);
-			spin_unlock(&dcache_lock);
 		}
 	}
 	shrink_dcache_parent(dir);
Index: linux-2.6/drivers/infiniband/hw/ipath/ipath_fs.c
===================================================================
--- linux-2.6.orig/drivers/infiniband/hw/ipath/ipath_fs.c	2010-11-17 00:52:37.000000000 +1100
+++ linux-2.6/drivers/infiniband/hw/ipath/ipath_fs.c	2010-11-17 01:05:39.000000000 +1100
@@ -277,18 +277,14 @@ static int remove_file(struct dentry *pa
 		goto bail;
 	}
 
-	spin_lock(&dcache_lock);
 	spin_lock(&tmp->d_lock);
 	if (!(d_unhashed(tmp) && tmp->d_inode)) {
 		dget_locked_dlock(tmp);
 		__d_drop(tmp);
 		spin_unlock(&tmp->d_lock);
-		spin_unlock(&dcache_lock);
 		simple_unlink(parent->d_inode, tmp);
-	} else {
+	} else
 		spin_unlock(&tmp->d_lock);
-		spin_unlock(&dcache_lock);
-	}
 
 	ret = 0;
 bail:
Index: linux-2.6/drivers/usb/core/inode.c
===================================================================
--- linux-2.6.orig/drivers/usb/core/inode.c	2010-11-17 00:52:37.000000000 +1100
+++ linux-2.6/drivers/usb/core/inode.c	2010-11-17 00:52:37.000000000 +1100
@@ -344,7 +344,6 @@ static int usbfs_empty (struct dentry *d
 {
 	struct list_head *list;
 
-	spin_lock(&dcache_lock);
 	spin_lock(&dentry->d_lock);
 	list_for_each(list, &dentry->d_subdirs) {
 		struct dentry *de = list_entry(list, struct dentry, d_u.d_child);
@@ -353,13 +352,11 @@ static int usbfs_empty (struct dentry *d
 		if (usbfs_positive(de)) {
 			spin_unlock(&de->d_lock);
 			spin_unlock(&dentry->d_lock);
-			spin_unlock(&dcache_lock);
 			return 0;
 		}
 		spin_unlock(&de->d_lock);
 	}
 	spin_unlock(&dentry->d_lock);
-	spin_unlock(&dcache_lock);
 	return 1;
 }
 
Index: linux-2.6/fs/affs/amigaffs.c
===================================================================
--- linux-2.6.orig/fs/affs/amigaffs.c	2010-11-17 00:52:37.000000000 +1100
+++ linux-2.6/fs/affs/amigaffs.c	2010-11-17 00:52:37.000000000 +1100
@@ -128,7 +128,6 @@ affs_fix_dcache(struct dentry *dentry, u
 	void *data = dentry->d_fsdata;
 	struct list_head *head, *next;
 
-	spin_lock(&dcache_lock);
 	spin_lock(&dcache_inode_lock);
 	head = &inode->i_dentry;
 	next = head->next;
@@ -141,7 +140,6 @@ affs_fix_dcache(struct dentry *dentry, u
 		next = next->next;
 	}
 	spin_unlock(&dcache_inode_lock);
-	spin_unlock(&dcache_lock);
 }
 
 
Index: linux-2.6/fs/coda/cache.c
===================================================================
--- linux-2.6.orig/fs/coda/cache.c	2010-11-17 00:52:37.000000000 +1100
+++ linux-2.6/fs/coda/cache.c	2010-11-17 00:52:37.000000000 +1100
@@ -93,7 +93,6 @@ static void coda_flag_children(struct de
 	struct list_head *child;
 	struct dentry *de;
 
-	spin_lock(&dcache_lock);
 	spin_lock(&parent->d_lock);
 	list_for_each(child, &parent->d_subdirs)
 	{
@@ -104,7 +103,6 @@ static void coda_flag_children(struct de
 		coda_flag_inode(de->d_inode, flag);
 	}
 	spin_unlock(&parent->d_lock);
-	spin_unlock(&dcache_lock);
 	return; 
 }
 
Index: linux-2.6/fs/configfs/configfs_internal.h
===================================================================
--- linux-2.6.orig/fs/configfs/configfs_internal.h	2010-11-17 00:52:37.000000000 +1100
+++ linux-2.6/fs/configfs/configfs_internal.h	2010-11-17 00:52:37.000000000 +1100
@@ -120,7 +120,6 @@ static inline struct config_item *config
 {
 	struct config_item * item = NULL;
 
-	spin_lock(&dcache_lock);
 	spin_lock(&dentry->d_lock);
 	if (!d_unhashed(dentry)) {
 		struct configfs_dirent * sd = dentry->d_fsdata;
@@ -131,7 +130,6 @@ static inline struct config_item *config
 			item = config_item_get(sd->s_element);
 	}
 	spin_unlock(&dentry->d_lock);
-	spin_unlock(&dcache_lock);
 
 	return item;
 }
Index: linux-2.6/fs/configfs/inode.c
===================================================================
--- linux-2.6.orig/fs/configfs/inode.c	2010-11-17 00:52:37.000000000 +1100
+++ linux-2.6/fs/configfs/inode.c	2010-11-17 01:05:39.000000000 +1100
@@ -250,18 +250,14 @@ void configfs_drop_dentry(struct configf
 	struct dentry * dentry = sd->s_dentry;
 
 	if (dentry) {
-		spin_lock(&dcache_lock);
 		spin_lock(&dentry->d_lock);
 		if (!(d_unhashed(dentry) && dentry->d_inode)) {
 			dget_locked_dlock(dentry);
 			__d_drop(dentry);
 			spin_unlock(&dentry->d_lock);
-			spin_unlock(&dcache_lock);
 			simple_unlink(parent->d_inode, dentry);
-		} else {
+		} else
 			spin_unlock(&dentry->d_lock);
-			spin_unlock(&dcache_lock);
-		}
 	}
 }
 
Index: linux-2.6/fs/ncpfs/dir.c
===================================================================
--- linux-2.6.orig/fs/ncpfs/dir.c	2010-11-17 00:52:37.000000000 +1100
+++ linux-2.6/fs/ncpfs/dir.c	2010-11-17 01:05:39.000000000 +1100
@@ -394,7 +394,6 @@ ncp_dget_fpos(struct dentry *dentry, str
 	}
 
 	/* If a pointer is invalid, we search the dentry. */
-	spin_lock(&dcache_lock);
 	spin_lock(&parent->d_lock);
 	next = parent->d_subdirs.next;
 	while (next != &parent->d_subdirs) {
@@ -405,13 +404,11 @@ ncp_dget_fpos(struct dentry *dentry, str
 			else
 				dent = NULL;
 			spin_unlock(&parent->d_lock);
-			spin_unlock(&dcache_lock);
 			goto out;
 		}
 		next = next->next;
 	}
 	spin_unlock(&parent->d_lock);
-	spin_unlock(&dcache_lock);
 	return NULL;
 
 out:
@@ -635,21 +632,18 @@ ncp_fill_cache(struct file *filp, void *
 			struct inode *inode = newdent->d_inode;
 
 			/*
-			 * Inside ncpfs all uses of d_name are either for debugging,
-			 * or on functions which acquire inode mutex (mknod, creat,
-			 * lookup).  So grab i_mutex here, to be sure.  d_path
-			 * uses dcache_lock when generating path, so we should too.
-			 * And finally d_compare is protected by dentry's d_lock, so
-			 * here we go.
+			 * Inside ncpfs all uses of d_name are either for
+			 * debugging, or on functions which acquire inode mutex
+			 * (mknod, creat, lookup).  So grab i_mutex here, to be
+			 * sure.  And finally d_compare is protected by
+			 * dentry's d_lock, so here we go.
 			 */
 			if (inode)
 				mutex_lock(&inode->i_mutex);
-			spin_lock(&dcache_lock);
 			spin_lock(&newdent->d_lock);
 			memcpy((char *) newdent->d_name.name, qname.name,
-								newdent->d_name.len);
+							newdent->d_name.len);
 			spin_unlock(&newdent->d_lock);
-			spin_unlock(&dcache_lock);
 			if (inode)
 				mutex_unlock(&inode->i_mutex);
 		}
Index: linux-2.6/fs/ncpfs/ncplib_kernel.h
===================================================================
--- linux-2.6.orig/fs/ncpfs/ncplib_kernel.h	2010-11-17 00:52:37.000000000 +1100
+++ linux-2.6/fs/ncpfs/ncplib_kernel.h	2010-11-17 00:52:37.000000000 +1100
@@ -193,7 +193,6 @@ ncp_renew_dentries(struct dentry *parent
 	struct list_head *next;
 	struct dentry *dentry;
 
-	spin_lock(&dcache_lock);
 	spin_lock(&parent->d_lock);
 	next = parent->d_subdirs.next;
 	while (next != &parent->d_subdirs) {
@@ -207,7 +206,6 @@ ncp_renew_dentries(struct dentry *parent
 		next = next->next;
 	}
 	spin_unlock(&parent->d_lock);
-	spin_unlock(&dcache_lock);
 }
 
 static inline void
@@ -217,7 +215,6 @@ ncp_invalidate_dircache_entries(struct d
 	struct list_head *next;
 	struct dentry *dentry;
 
-	spin_lock(&dcache_lock);
 	spin_lock(&parent->d_lock);
 	next = parent->d_subdirs.next;
 	while (next != &parent->d_subdirs) {
@@ -227,7 +224,6 @@ ncp_invalidate_dircache_entries(struct d
 		next = next->next;
 	}
 	spin_unlock(&parent->d_lock);
-	spin_unlock(&dcache_lock);
 }
 
 struct ncp_cache_head {
Index: linux-2.6/fs/nfs/dir.c
===================================================================
--- linux-2.6.orig/fs/nfs/dir.c	2010-11-17 00:52:37.000000000 +1100
+++ linux-2.6/fs/nfs/dir.c	2010-11-17 00:52:37.000000000 +1100
@@ -1692,11 +1692,9 @@ static int nfs_unlink(struct inode *dir,
 	dfprintk(VFS, "NFS: unlink(%s/%ld, %s)\n", dir->i_sb->s_id,
 		dir->i_ino, dentry->d_name.name);
 
-	spin_lock(&dcache_lock);
 	spin_lock(&dentry->d_lock);
 	if (dentry->d_count > 1) {
 		spin_unlock(&dentry->d_lock);
-		spin_unlock(&dcache_lock);
 		/* Start asynchronous writeout of the inode */
 		write_inode_now(dentry->d_inode, 0);
 		error = nfs_sillyrename(dir, dentry);
@@ -1707,7 +1705,6 @@ static int nfs_unlink(struct inode *dir,
 		need_rehash = 1;
 	}
 	spin_unlock(&dentry->d_lock);
-	spin_unlock(&dcache_lock);
 	error = nfs_safe_remove(dentry);
 	if (!error || error == -ENOENT) {
 		nfs_set_verifier(dentry, nfs_save_change_attribute(dir));
Index: linux-2.6/fs/ocfs2/dcache.c
===================================================================
--- linux-2.6.orig/fs/ocfs2/dcache.c	2010-11-17 00:52:37.000000000 +1100
+++ linux-2.6/fs/ocfs2/dcache.c	2010-11-17 01:05:39.000000000 +1100
@@ -169,7 +169,6 @@ struct dentry *ocfs2_find_local_alias(st
 	struct list_head *p;
 	struct dentry *dentry = NULL;
 
-	spin_lock(&dcache_lock);
 	spin_lock(&dcache_inode_lock);
 	list_for_each(p, &inode->i_dentry) {
 		dentry = list_entry(p, struct dentry, d_alias);
@@ -189,7 +188,6 @@ struct dentry *ocfs2_find_local_alias(st
 	}
 
 	spin_unlock(&dcache_inode_lock);
-	spin_unlock(&dcache_lock);
 
 	return dentry;
 }
Index: linux-2.6/kernel/cgroup.c
===================================================================
--- linux-2.6.orig/kernel/cgroup.c	2010-11-17 00:52:37.000000000 +1100
+++ linux-2.6/kernel/cgroup.c	2010-11-17 01:05:39.000000000 +1100
@@ -874,7 +874,6 @@ static void cgroup_clear_directory(struc
 	struct list_head *node;
 
 	BUG_ON(!mutex_is_locked(&dentry->d_inode->i_mutex));
-	spin_lock(&dcache_lock);
 	spin_lock(&dentry->d_lock);
 	node = dentry->d_subdirs.next;
 	while (node != &dentry->d_subdirs) {
@@ -889,18 +888,15 @@ static void cgroup_clear_directory(struc
 			dget_locked_dlock(d);
 			spin_unlock(&d->d_lock);
 			spin_unlock(&dentry->d_lock);
-			spin_unlock(&dcache_lock);
 			d_delete(d);
 			simple_unlink(dentry->d_inode, d);
 			dput(d);
-			spin_lock(&dcache_lock);
 			spin_lock(&dentry->d_lock);
 		} else
 			spin_unlock(&d->d_lock);
 		node = dentry->d_subdirs.next;
 	}
 	spin_unlock(&dentry->d_lock);
-	spin_unlock(&dcache_lock);
 }
 
 /*
@@ -912,14 +908,12 @@ static void cgroup_d_remove_dir(struct d
 
 	cgroup_clear_directory(dentry);
 
-	spin_lock(&dcache_lock);
 	parent = dentry->d_parent;
 	spin_lock(&parent->d_lock);
 	spin_lock(&dentry->d_lock);
 	list_del_init(&dentry->d_u.d_child);
 	spin_unlock(&dentry->d_lock);
 	spin_unlock(&parent->d_lock);
-	spin_unlock(&dcache_lock);
 	remove_dir(dentry);
 }
 
Index: linux-2.6/security/selinux/selinuxfs.c
===================================================================
--- linux-2.6.orig/security/selinux/selinuxfs.c	2010-11-17 00:52:37.000000000 +1100
+++ linux-2.6/security/selinux/selinuxfs.c	2010-11-17 01:05:39.000000000 +1100
@@ -1145,7 +1145,6 @@ static void sel_remove_entries(struct de
 {
 	struct list_head *node;
 
-	spin_lock(&dcache_lock);
 	spin_lock(&de->d_lock);
 	node = de->d_subdirs.next;
 	while (node != &de->d_subdirs) {
@@ -1158,11 +1157,9 @@ static void sel_remove_entries(struct de
 			dget_locked_dlock(d);
 			spin_unlock(&de->d_lock);
 			spin_unlock(&d->d_lock);
-			spin_unlock(&dcache_lock);
 			d_delete(d);
 			simple_unlink(de->d_inode, d);
 			dput(d);
-			spin_lock(&dcache_lock);
 			spin_lock(&de->d_lock);
 		} else
 			spin_unlock(&d->d_lock);
@@ -1170,7 +1167,6 @@ static void sel_remove_entries(struct de
 	}
 
 	spin_unlock(&de->d_lock);
-	spin_unlock(&dcache_lock);
 }
 
 #define BOOL_DIR_NAME "booleans"
Index: linux-2.6/fs/nfs/getroot.c
===================================================================
--- linux-2.6.orig/fs/nfs/getroot.c	2010-11-17 00:52:37.000000000 +1100
+++ linux-2.6/fs/nfs/getroot.c	2010-11-17 00:52:37.000000000 +1100
@@ -63,13 +63,11 @@ static int nfs_superblock_set_dummy_root
 		 * This again causes shrink_dcache_for_umount_subtree() to
 		 * Oops, since the test for IS_ROOT() will fail.
 		 */
-		spin_lock(&dcache_lock);
 		spin_lock(&dcache_inode_lock);
 		spin_lock(&sb->s_root->d_lock);
 		list_del_init(&sb->s_root->d_alias);
 		spin_unlock(&sb->s_root->d_lock);
 		spin_unlock(&dcache_inode_lock);
-		spin_unlock(&dcache_lock);
 	}
 	return 0;
 }
Index: linux-2.6/drivers/staging/pohmelfs/path_entry.c
===================================================================
--- linux-2.6.orig/drivers/staging/pohmelfs/path_entry.c	2010-11-17 00:52:37.000000000 +1100
+++ linux-2.6/drivers/staging/pohmelfs/path_entry.c	2010-11-17 00:52:37.000000000 +1100
@@ -101,7 +101,6 @@ int pohmelfs_path_length(struct pohmelfs
 	d = first;
 	seq = read_seqbegin(&rename_lock);
 	rcu_read_lock();
-	spin_lock(&dcache_lock);
 
 	if (!IS_ROOT(d) && d_unhashed(d))
 		len += UNHASHED_OBSCURE_STRING_SIZE; /* Obscure " (deleted)" string */
@@ -110,7 +109,6 @@ int pohmelfs_path_length(struct pohmelfs
 		len += d->d_name.len + 1; /* Plus slash */
 		d = d->d_parent;
 	}
-	spin_unlock(&dcache_lock);
 	rcu_read_unlock();
 	if (read_seqretry(&rename_lock, seq))
 		goto rename_retry;
Index: linux-2.6/fs/nfs/namespace.c
===================================================================
--- linux-2.6.orig/fs/nfs/namespace.c	2010-11-17 00:52:37.000000000 +1100
+++ linux-2.6/fs/nfs/namespace.c	2010-11-17 00:52:37.000000000 +1100
@@ -60,7 +60,6 @@ char *nfs_path(const char *base,
 
 	seq = read_seqbegin(&rename_lock);
 	rcu_read_lock();
-	spin_lock(&dcache_lock);
 	while (!IS_ROOT(dentry) && dentry != droot) {
 		namelen = dentry->d_name.len;
 		buflen -= namelen + 1;
@@ -71,7 +70,6 @@ char *nfs_path(const char *base,
 		*--end = '/';
 		dentry = dentry->d_parent;
 	}
-	spin_unlock(&dcache_lock);
 	rcu_read_unlock();
 	if (read_seqretry(&rename_lock, seq))
 		goto rename_retry;
@@ -91,7 +89,6 @@ char *nfs_path(const char *base,
 	memcpy(end, base, namelen);
 	return end;
 Elong_unlock:
-	spin_unlock(&dcache_lock);
 	rcu_read_unlock();
 	if (read_seqretry(&rename_lock, seq))
 		goto rename_retry;
Index: linux-2.6/include/linux/fsnotify_backend.h
===================================================================
--- linux-2.6.orig/include/linux/fsnotify_backend.h	2010-11-17 00:50:48.000000000 +1100
+++ linux-2.6/include/linux/fsnotify_backend.h	2010-11-17 00:52:37.000000000 +1100
@@ -329,9 +329,15 @@ static inline void __fsnotify_update_dca
 {
 	struct dentry *parent;
 
-	assert_spin_locked(&dcache_lock);
 	assert_spin_locked(&dentry->d_lock);
 
+	/*
+	 * Serialisation of setting PARENT_WATCHED on the dentries is provided
+	 * by d_lock. If inotify_inode_watched changes after we have taken
+	 * d_lock, the following __fsnotify_update_child_dentry_flags call will
+	 * find our entry, so it will spin until we complete here, and update
+	 * us with the new state.
+	 */
 	parent = dentry->d_parent;
 	if (parent->d_inode && fsnotify_inode_watches_children(parent->d_inode))
 		dentry->d_flags |= DCACHE_FSNOTIFY_PARENT_WATCHED;
@@ -341,15 +347,12 @@ static inline void __fsnotify_update_dca
 
 /*
  * fsnotify_d_instantiate - instantiate a dentry for inode
- * Called with dcache_lock held.
  */
 static inline void __fsnotify_d_instantiate(struct dentry *dentry, struct inode *inode)
 {
 	if (!inode)
 		return;
 
-	assert_spin_locked(&dcache_lock);
-
 	spin_lock(&dentry->d_lock);
 	__fsnotify_update_dcache_flags(dentry);
 	spin_unlock(&dentry->d_lock);
Index: linux-2.6/fs/notify/fsnotify.c
===================================================================
--- linux-2.6.orig/fs/notify/fsnotify.c	2010-11-17 00:52:37.000000000 +1100
+++ linux-2.6/fs/notify/fsnotify.c	2010-11-17 00:52:37.000000000 +1100
@@ -59,7 +59,6 @@ void __fsnotify_update_child_dentry_flag
 	/* determine if the children should tell inode about their events */
 	watched = fsnotify_inode_watches_children(inode);
 
-	spin_lock(&dcache_lock);
 	spin_lock(&dcache_inode_lock);
 	/* run all of the dentries associated with this inode.  Since this is a
 	 * directory, there damn well better only be one item on this list */
@@ -84,7 +83,6 @@ void __fsnotify_update_child_dentry_flag
 		spin_unlock(&alias->d_lock);
 	}
 	spin_unlock(&dcache_inode_lock);
-	spin_unlock(&dcache_lock);
 }
 
 /* Notify this dentry's parent about a child's events. */
Index: linux-2.6/include/linux/fs.h
===================================================================
--- linux-2.6.orig/include/linux/fs.h	2010-11-17 00:50:47.000000000 +1100
+++ linux-2.6/include/linux/fs.h	2010-11-17 00:52:37.000000000 +1100
@@ -1377,7 +1377,7 @@ struct super_block {
 #else
 	struct list_head	s_files;
 #endif
-	/* s_dentry_lru and s_nr_dentry_unused are protected by dcache_lock */
+	/* s_dentry_lru, s_nr_dentry_unused protected by dcache.c lru locks */
 	struct list_head	s_dentry_lru;	/* unused dentry lru */
 	int			s_nr_dentry_unused;	/* # of dentry on lru */
 
@@ -2446,6 +2446,10 @@ static inline ino_t parent_ino(struct de
 {
 	ino_t res;
 
+	/*
+	 * Don't strictly need d_lock here? If the parent ino could change
+	 * then surely we'd have a deeper race in the caller?
+	 */
 	spin_lock(&dentry->d_lock);
 	res = dentry->d_parent->d_inode->i_ino;
 	spin_unlock(&dentry->d_lock);
Index: linux-2.6/fs/autofs4/autofs_i.h
===================================================================
--- linux-2.6.orig/fs/autofs4/autofs_i.h	2010-11-17 00:52:37.000000000 +1100
+++ linux-2.6/fs/autofs4/autofs_i.h	2010-11-17 00:52:37.000000000 +1100
@@ -16,6 +16,7 @@
 #include <linux/auto_fs4.h>
 #include <linux/auto_dev-ioctl.h>
 #include <linux/mutex.h>
+#include <linux/spinlock.h>
 #include <linux/list.h>
 
 /* This is the range of ioctl() numbers we claim as ours */
@@ -60,6 +61,8 @@ do {							\
 		current->pid, __func__, ##args);	\
 } while (0)
 
+extern spinlock_t autofs4_lock;
+
 /* Unified info structure.  This is pointed to by both the dentry and
    inode structures.  Each file in the filesystem has an instance of this
    structure.  It holds a reference to the dentry, so dentries are never
Index: linux-2.6/fs/autofs4/expire.c
===================================================================
--- linux-2.6.orig/fs/autofs4/expire.c	2010-11-17 00:52:37.000000000 +1100
+++ linux-2.6/fs/autofs4/expire.c	2010-11-17 00:52:37.000000000 +1100
@@ -102,7 +102,7 @@ static struct dentry *get_next_positive_
 	if (prev == NULL)
 		return dget(prev);
 
-	spin_lock(&dcache_lock);
+	spin_lock(&autofs4_lock);
 relock:
 	p = prev;
 	spin_lock(&p->d_lock);
@@ -114,7 +114,7 @@ static struct dentry *get_next_positive_
 
 			if (p == root) {
 				spin_unlock(&p->d_lock);
-				spin_unlock(&dcache_lock);
+				spin_unlock(&autofs4_lock);
 				dput(prev);
 				return NULL;
 			}
@@ -144,7 +144,7 @@ static struct dentry *get_next_positive_
 	dget_dlock(ret);
 	spin_unlock(&ret->d_lock);
 	spin_unlock(&p->d_lock);
-	spin_unlock(&dcache_lock);
+	spin_unlock(&autofs4_lock);
 
 	dput(prev);
 
@@ -408,13 +408,13 @@ struct dentry *autofs4_expire_indirect(s
 	ino->flags |= AUTOFS_INF_EXPIRING;
 	init_completion(&ino->expire_complete);
 	spin_unlock(&sbi->fs_lock);
-	spin_lock(&dcache_lock);
+	spin_lock(&autofs4_lock);
 	spin_lock(&expired->d_parent->d_lock);
 	spin_lock_nested(&expired->d_lock, DENTRY_D_LOCK_NESTED);
   	list_move(&expired->d_parent->d_subdirs, &expired->d_u.d_child);
 	spin_unlock(&expired->d_lock);
 	spin_unlock(&expired->d_parent->d_lock);
-	spin_unlock(&dcache_lock);
+	spin_unlock(&autofs4_lock);
 	return expired;
 }
 
Index: linux-2.6/fs/autofs4/root.c
===================================================================
--- linux-2.6.orig/fs/autofs4/root.c	2010-11-17 00:52:37.000000000 +1100
+++ linux-2.6/fs/autofs4/root.c	2010-11-17 00:52:37.000000000 +1100
@@ -23,6 +23,8 @@
 
 #include "autofs_i.h"
 
+DEFINE_SPINLOCK(autofs4_lock);
+
 static int autofs4_dir_symlink(struct inode *,struct dentry *,const char *);
 static int autofs4_dir_unlink(struct inode *,struct dentry *);
 static int autofs4_dir_rmdir(struct inode *,struct dentry *);
@@ -142,15 +144,15 @@ static int autofs4_dir_open(struct inode
 	 * autofs file system so just let the libfs routines handle
 	 * it.
 	 */
-	spin_lock(&dcache_lock);
+	spin_lock(&autofs4_lock);
 	spin_lock(&dentry->d_lock);
 	if (!d_mountpoint(dentry) && list_empty(&dentry->d_subdirs)) {
 		spin_unlock(&dentry->d_lock);
-		spin_unlock(&dcache_lock);
+		spin_unlock(&autofs4_lock);
 		return -ENOENT;
 	}
 	spin_unlock(&dentry->d_lock);
-	spin_unlock(&dcache_lock);
+	spin_unlock(&autofs4_lock);
 
 out:
 	return dcache_dir_open(inode, file);
@@ -255,11 +257,11 @@ static void *autofs4_follow_link(struct
 	/* We trigger a mount for almost all flags */
 	lookup_type = autofs4_need_mount(nd->flags);
 	spin_lock(&sbi->fs_lock);
-	spin_lock(&dcache_lock);
+	spin_lock(&autofs4_lock);
 	spin_lock(&dentry->d_lock);
 	if (!(lookup_type || ino->flags & AUTOFS_INF_PENDING)) {
 		spin_unlock(&dentry->d_lock);
-		spin_unlock(&dcache_lock);
+		spin_unlock(&autofs4_lock);
 		spin_unlock(&sbi->fs_lock);
 		goto follow;
 	}
@@ -272,7 +274,7 @@ static void *autofs4_follow_link(struct
 	if (ino->flags & AUTOFS_INF_PENDING ||
 	    (!d_mountpoint(dentry) && list_empty(&dentry->d_subdirs))) {
 		spin_unlock(&dentry->d_lock);
-		spin_unlock(&dcache_lock);
+		spin_unlock(&autofs4_lock);
 		spin_unlock(&sbi->fs_lock);
 
 		status = try_to_fill_dentry(dentry, nd->flags);
@@ -282,7 +284,7 @@ static void *autofs4_follow_link(struct
 		goto follow;
 	}
 	spin_unlock(&dentry->d_lock);
-	spin_unlock(&dcache_lock);
+	spin_unlock(&autofs4_lock);
 	spin_unlock(&sbi->fs_lock);
 follow:
 	/*
@@ -353,14 +355,14 @@ static int autofs4_revalidate(struct den
 		return 0;
 
 	/* Check for a non-mountpoint directory with no contents */
-	spin_lock(&dcache_lock);
+	spin_lock(&autofs4_lock);
 	spin_lock(&dentry->d_lock);
 	if (S_ISDIR(dentry->d_inode->i_mode) &&
 	    !d_mountpoint(dentry) && list_empty(&dentry->d_subdirs)) {
 		DPRINTK("dentry=%p %.*s, emptydir",
 			 dentry, dentry->d_name.len, dentry->d_name.name);
 		spin_unlock(&dentry->d_lock);
-		spin_unlock(&dcache_lock);
+		spin_unlock(&autofs4_lock);
 
 		/* The daemon never causes a mount to trigger */
 		if (oz_mode)
@@ -377,7 +379,7 @@ static int autofs4_revalidate(struct den
 		return status;
 	}
 	spin_unlock(&dentry->d_lock);
-	spin_unlock(&dcache_lock);
+	spin_unlock(&autofs4_lock);
 
 	return 1;
 }
@@ -432,7 +434,7 @@ static struct dentry *autofs4_lookup_act
 	const unsigned char *str = name->name;
 	struct list_head *p, *head;
 
-	spin_lock(&dcache_lock);
+	spin_lock(&autofs4_lock);
 	spin_lock(&sbi->lookup_lock);
 	head = &sbi->active_list;
 	list_for_each(p, head) {
@@ -465,14 +467,14 @@ static struct dentry *autofs4_lookup_act
 			dget_dlock(active);
 			spin_unlock(&active->d_lock);
 			spin_unlock(&sbi->lookup_lock);
-			spin_unlock(&dcache_lock);
+			spin_unlock(&autofs4_lock);
 			return active;
 		}
 next:
 		spin_unlock(&active->d_lock);
 	}
 	spin_unlock(&sbi->lookup_lock);
-	spin_unlock(&dcache_lock);
+	spin_unlock(&autofs4_lock);
 
 	return NULL;
 }
@@ -487,7 +489,7 @@ static struct dentry *autofs4_lookup_exp
 	const unsigned char *str = name->name;
 	struct list_head *p, *head;
 
-	spin_lock(&dcache_lock);
+	spin_lock(&autofs4_lock);
 	spin_lock(&sbi->lookup_lock);
 	head = &sbi->expiring_list;
 	list_for_each(p, head) {
@@ -520,14 +522,14 @@ static struct dentry *autofs4_lookup_exp
 			dget_dlock(expiring);
 			spin_unlock(&expiring->d_lock);
 			spin_unlock(&sbi->lookup_lock);
-			spin_unlock(&dcache_lock);
+			spin_unlock(&autofs4_lock);
 			return expiring;
 		}
 next:
 		spin_unlock(&expiring->d_lock);
 	}
 	spin_unlock(&sbi->lookup_lock);
-	spin_unlock(&dcache_lock);
+	spin_unlock(&autofs4_lock);
 
 	return NULL;
 }
@@ -763,12 +765,12 @@ static int autofs4_dir_unlink(struct ino
 
 	dir->i_mtime = CURRENT_TIME;
 
-	spin_lock(&dcache_lock);
+	spin_lock(&autofs4_lock);
 	autofs4_add_expiring(dentry);
 	spin_lock(&dentry->d_lock);
 	__d_drop(dentry);
 	spin_unlock(&dentry->d_lock);
-	spin_unlock(&dcache_lock);
+	spin_unlock(&autofs4_lock);
 
 	return 0;
 }
@@ -785,20 +787,20 @@ static int autofs4_dir_rmdir(struct inod
 	if (!autofs4_oz_mode(sbi))
 		return -EACCES;
 
-	spin_lock(&dcache_lock);
+	spin_lock(&autofs4_lock);
 	spin_lock(&sbi->lookup_lock);
 	spin_lock(&dentry->d_lock);
 	if (!list_empty(&dentry->d_subdirs)) {
 		spin_unlock(&dentry->d_lock);
 		spin_unlock(&sbi->lookup_lock);
-		spin_unlock(&dcache_lock);
+		spin_unlock(&autofs4_lock);
 		return -ENOTEMPTY;
 	}
 	__autofs4_add_expiring(dentry);
 	spin_unlock(&sbi->lookup_lock);
 	__d_drop(dentry);
 	spin_unlock(&dentry->d_lock);
-	spin_unlock(&dcache_lock);
+	spin_unlock(&autofs4_lock);
 
 	if (atomic_dec_and_test(&ino->count)) {
 		p_ino = autofs4_dentry_ino(dentry->d_parent);
Index: linux-2.6/fs/autofs4/waitq.c
===================================================================
--- linux-2.6.orig/fs/autofs4/waitq.c	2010-11-17 00:52:37.000000000 +1100
+++ linux-2.6/fs/autofs4/waitq.c	2010-11-17 00:52:37.000000000 +1100
@@ -194,14 +194,15 @@ static int autofs4_getpath(struct autofs
 rename_retry:
 	buf = *name;
 	len = 0;
+
 	seq = read_seqbegin(&rename_lock);
 	rcu_read_lock();
-	spin_lock(&dcache_lock);
+	spin_lock(&autofs4_lock);
 	for (tmp = dentry ; tmp != root ; tmp = tmp->d_parent)
 		len += tmp->d_name.len + 1;
 
 	if (!len || --len > NAME_MAX) {
-		spin_unlock(&dcache_lock);
+		spin_unlock(&autofs4_lock);
 		rcu_read_unlock();
 		if (read_seqretry(&rename_lock, seq))
 			goto rename_retry;
@@ -217,7 +218,7 @@ static int autofs4_getpath(struct autofs
 		p -= tmp->d_name.len;
 		strncpy(p, tmp->d_name.name, tmp->d_name.len);
 	}
-	spin_unlock(&dcache_lock);
+	spin_unlock(&autofs4_lock);
 	rcu_read_unlock();
 	if (read_seqretry(&rename_lock, seq))
 		goto rename_retry;
Index: linux-2.6/drivers/infiniband/hw/qib/qib_fs.c
===================================================================
--- linux-2.6.orig/drivers/infiniband/hw/qib/qib_fs.c	2010-11-17 00:52:37.000000000 +1100
+++ linux-2.6/drivers/infiniband/hw/qib/qib_fs.c	2010-11-17 01:05:39.000000000 +1100
@@ -453,17 +453,14 @@ static int remove_file(struct dentry *pa
 		goto bail;
 	}
 
-	spin_lock(&dcache_lock);
 	spin_lock(&tmp->d_lock);
 	if (!(d_unhashed(tmp) && tmp->d_inode)) {
 		dget_locked_dlock(tmp);
 		__d_drop(tmp);
 		spin_unlock(&tmp->d_lock);
-		spin_unlock(&dcache_lock);
 		simple_unlink(parent->d_inode, tmp);
 	} else {
 		spin_unlock(&tmp->d_lock);
-		spin_unlock(&dcache_lock);
 	}
 
 	ret = 0;
Index: linux-2.6/fs/ceph/dir.c
===================================================================
--- linux-2.6.orig/fs/ceph/dir.c	2010-11-17 00:52:37.000000000 +1100
+++ linux-2.6/fs/ceph/dir.c	2010-11-17 00:52:37.000000000 +1100
@@ -111,7 +111,6 @@ static int __dcache_readdir(struct file
 	dout("__dcache_readdir %p at %llu (last %p)\n", dir, filp->f_pos,
 	     last);
 
-	spin_lock(&dcache_lock);
 	spin_lock(&parent->d_lock);
 
 	/* start at beginning? */
@@ -155,7 +154,6 @@ static int __dcache_readdir(struct file
 	dget_dlock(dentry);
 	spin_unlock(&dentry->d_lock);
 	spin_unlock(&parent->d_lock);
-	spin_unlock(&dcache_lock);
 
 	dout(" %llu (%llu) dentry %p %.*s %p\n", di->offset, filp->f_pos,
 	     dentry, dentry->d_name.len, dentry->d_name.name, dentry->d_inode);
@@ -181,21 +179,19 @@ static int __dcache_readdir(struct file
 
 	filp->f_pos++;
 
-	/* make sure a dentry wasn't dropped while we didn't have dcache_lock */
+	/* make sure a dentry wasn't dropped while we didn't have parent lock */
 	if (!ceph_i_test(dir, CEPH_I_COMPLETE)) {
 		dout(" lost I_COMPLETE on %p; falling back to mds\n", dir);
 		err = -EAGAIN;
 		goto out;
 	}
 
-	spin_lock(&dcache_lock);
 	spin_lock(&parent->d_lock);
 	p = p->prev;	/* advance to next dentry */
 	goto more;
 
 out_unlock:
 	spin_unlock(&parent->d_lock);
-	spin_unlock(&dcache_lock);
 out:
 	if (last)
 		dput(last);
Index: linux-2.6/fs/ceph/inode.c
===================================================================
--- linux-2.6.orig/fs/ceph/inode.c	2010-11-17 00:52:37.000000000 +1100
+++ linux-2.6/fs/ceph/inode.c	2010-11-17 00:52:37.000000000 +1100
@@ -828,7 +828,6 @@ static void ceph_set_dentry_offset(struc
 	di->offset = ceph_inode(inode)->i_max_offset++;
 	spin_unlock(&inode->i_lock);
 
-	spin_lock(&dcache_lock);
 	spin_lock(&dir->d_lock);
 	spin_lock_nested(&dn->d_lock, DENTRY_D_LOCK_NESTED);
 	list_move(&dn->d_u.d_child, &dir->d_subdirs);
@@ -836,7 +835,6 @@ static void ceph_set_dentry_offset(struc
 	     dn->d_u.d_child.prev, dn->d_u.d_child.next);
 	spin_unlock(&dn->d_lock);
 	spin_unlock(&dir->d_lock);
-	spin_unlock(&dcache_lock);
 }
 
 /*
@@ -1219,13 +1217,11 @@ int ceph_readdir_prepopulate(struct ceph
 			goto retry_lookup;
 		} else {
 			/* reorder parent's d_subdirs */
-			spin_lock(&dcache_lock);
 			spin_lock(&parent->d_lock);
 			spin_lock_nested(&dn->d_lock, DENTRY_D_LOCK_NESTED);
 			list_move(&dn->d_u.d_child, &parent->d_subdirs);
 			spin_unlock(&dn->d_lock);
 			spin_unlock(&parent->d_lock);
-			spin_unlock(&dcache_lock);
 		}
 
 		di = dn->d_fsdata;
Index: linux-2.6/Documentation/filesystems/dentry-locking.txt
===================================================================
--- linux-2.6.orig/Documentation/filesystems/dentry-locking.txt	2010-11-17 00:50:48.000000000 +1100
+++ linux-2.6/Documentation/filesystems/dentry-locking.txt	2010-11-17 00:52:37.000000000 +1100
@@ -31,6 +31,7 @@ significant change is the way d_lookup t
 doesn't acquire the dcache_lock for this and rely on RCU to ensure
 that the dentry has not been *freed*.
 
+dcache_lock no longer exists, dentry locking is explained in fs/dcache.c
 
 Dcache locking details
 ======================
@@ -50,14 +51,12 @@ Safe lock-free look-up of dcache hash ta
 
 Dcache is a complex data structure with the hash table entries also
 linked together in other lists. In 2.4 kernel, dcache_lock protected
-all the lists. We applied RCU only on hash chain walking. The rest of
-the lists are still protected by dcache_lock.  Some of the important
-changes are :
+all the lists. RCU dentry hash walking works like this:
 
 1. The deletion from hash chain is done using hlist_del_rcu() macro
    which doesn't initialize next pointer of the deleted dentry and
    this allows us to walk safely lock-free while a deletion is
-   happening.
+   happening. This is a standard hlist_rcu iteration.
 
 2. Insertion of a dentry into the hash table is done using
    hlist_add_head_rcu() which take care of ordering the writes - the
@@ -66,19 +65,18 @@ the lists are still protected by dcache_
    which has since been replaced by hlist_for_each_entry_rcu(), while
    walking the hash chain. The only requirement is that all
    initialization to the dentry must be done before
-   hlist_add_head_rcu() since we don't have dcache_lock protection
-   while traversing the hash chain. This isn't different from the
-   existing code.
-
-3. The dentry looked up without holding dcache_lock by cannot be
-   returned for walking if it is unhashed. It then may have a NULL
-   d_inode or other bogosity since RCU doesn't protect the other
-   fields in the dentry. We therefore use a flag DCACHE_UNHASHED to
-   indicate unhashed dentries and use this in conjunction with a
-   per-dentry lock (d_lock). Once looked up without the dcache_lock,
-   we acquire the per-dentry lock (d_lock) and check if the dentry is
-   unhashed. If so, the look-up is failed. If not, the reference count
-   of the dentry is increased and the dentry is returned.
+   hlist_add_head_rcu() since we don't have lock protection
+   while traversing the hash chain.
+
+3. The dentry looked up without holding locks cannot be returned for
+   walking if it is unhashed. It then may have a NULL d_inode or other
+   bogosity since RCU doesn't protect the other fields in the dentry. We
+   therefore use a flag DCACHE_UNHASHED to indicate unhashed dentries
+   and use this in conjunction with a per-dentry lock (d_lock). Once
+   looked up without locks, we acquire the per-dentry lock (d_lock) and
+   check if the dentry is unhashed. If so, the look-up is failed. If not,
+   the reference count of the dentry is increased and the dentry is
+   returned.
 
 4. Once a dentry is looked up, it must be ensured during the path walk
    for that component it doesn't go away. In pre-2.5.10 code, this was
@@ -86,10 +84,10 @@ the lists are still protected by dcache_
    In some sense, dcache_rcu path walking looks like the pre-2.5.10
    version.
 
-5. All dentry hash chain updates must take the dcache_lock as well as
-   the per-dentry lock in that order. dput() does this to ensure that
-   a dentry that has just been looked up in another CPU doesn't get
-   deleted before dget() can be done on it.
+5. All dentry hash chain updates must take the per-dentry lock (see
+   fs/dcache.c). This excludes dput() to ensure that a dentry that has
+   been looked up concurrently does not get deleted before dget() can
+   take a ref.
 
 6. There are several ways to do reference counting of RCU protected
    objects. One such example is in ipv4 route cache where deferred
Index: linux-2.6/Documentation/filesystems/porting
===================================================================
--- linux-2.6.orig/Documentation/filesystems/porting	2010-11-17 00:52:37.000000000 +1100
+++ linux-2.6/Documentation/filesystems/porting	2010-11-17 00:52:37.000000000 +1100
@@ -216,7 +216,6 @@ had ->revalidate()) add calls in ->follo
 ->d_parent changes are not protected by BKL anymore.  Read access is safe
 if at least one of the following is true:
 	* filesystem has no cross-directory rename()
-	* dcache_lock is held
 	* we know that parent had been locked (e.g. we are looking at
 ->d_parent of ->lookup() argument).
 	* we are called from ->rename().
@@ -341,3 +340,10 @@ look at examples of other filesystems) f
 changed. Read updated documentation in Documentation/filesystems/vfs.txt (and
 look at examples of other filesystems) for guidance.
 
+---
+[mandatory]
+	dcache_lock is gone, replaced by fine grained locks. See fs/dcache.c
+for details of what locks to replace dcache_lock with in order to protect
+particular things. Most of the time, a filesystem only needs ->d_lock, which
+protects *all* the dcache state of a given dentry.
+
Index: linux-2.6/include/linux/namei.h
===================================================================
--- linux-2.6.orig/include/linux/namei.h	2010-11-17 00:50:47.000000000 +1100
+++ linux-2.6/include/linux/namei.h	2010-11-17 00:52:37.000000000 +1100
@@ -41,7 +41,6 @@ enum {LAST_NORM, LAST_ROOT, LAST_DOT, LA
  *  - require a directory
  *  - ending slashes ok even for nonexistent files
  *  - internal "there are more path components" flag
- *  - locked when lookup done with dcache_lock held
  *  - dentry cache is untrusted; force a real lookup
  */
 #define LOOKUP_FOLLOW		 1
Index: linux-2.6/mm/filemap.c
===================================================================
--- linux-2.6.orig/mm/filemap.c	2010-11-17 00:50:48.000000000 +1100
+++ linux-2.6/mm/filemap.c	2010-11-17 00:52:37.000000000 +1100
@@ -102,9 +102,6 @@
  *    ->inode_lock		(zap_pte_range->set_page_dirty)
  *    ->private_lock		(zap_pte_range->__set_page_dirty_buffers)
  *
- *  ->task->proc_lock
- *    ->dcache_lock		(proc_pid_lookup)
- *
  *  (code doesn't rely on that order, so you could switch it around)
  *  ->tasklist_lock             (memory_failure, collect_procs_ao)
  *    ->i_mmap_lock
Index: linux-2.6/fs/9p/vfs_inode.c
===================================================================
--- linux-2.6.orig/fs/9p/vfs_inode.c	2010-11-17 00:52:37.000000000 +1100
+++ linux-2.6/fs/9p/vfs_inode.c	2010-11-17 00:52:37.000000000 +1100
@@ -270,13 +270,11 @@ static struct dentry *v9fs_dentry_from_d
 {
 	struct dentry *dentry;
 
-	spin_lock(&dcache_lock);
 	spin_lock(&dcache_inode_lock);
 	/* Directory should have only one entry. */
 	BUG_ON(S_ISDIR(inode->i_mode) && !list_is_singular(&inode->i_dentry));
 	dentry = list_entry(inode->i_dentry.next, struct dentry, d_alias);
 	spin_unlock(&dcache_inode_lock);
-	spin_unlock(&dcache_lock);
 	return dentry;
 }
 
Index: linux-2.6/fs/cifs/inode.c
===================================================================
--- linux-2.6.orig/fs/cifs/inode.c	2010-11-17 00:52:37.000000000 +1100
+++ linux-2.6/fs/cifs/inode.c	2010-11-17 00:52:37.000000000 +1100
@@ -804,17 +804,14 @@ inode_has_hashed_dentries(struct inode *
 {
 	struct dentry *dentry;
 
-	spin_lock(&dcache_lock);
 	spin_lock(&dcache_inode_lock);
 	list_for_each_entry(dentry, &inode->i_dentry, d_alias) {
 		if (!d_unhashed(dentry) || IS_ROOT(dentry)) {
 			spin_unlock(&dcache_inode_lock);
-			spin_unlock(&dcache_lock);
 			return true;
 		}
 	}
 	spin_unlock(&dcache_inode_lock);
-	spin_unlock(&dcache_lock);
 	return false;
 }
 
Index: linux-2.6/drivers/staging/smbfs/cache.c
===================================================================
--- linux-2.6.orig/drivers/staging/smbfs/cache.c	2010-11-17 00:52:37.000000000 +1100
+++ linux-2.6/drivers/staging/smbfs/cache.c	2010-11-17 01:05:39.000000000 +1100
@@ -62,7 +62,6 @@ smb_invalidate_dircache_entries(struct d
 	struct list_head *next;
 	struct dentry *dentry;
 
-	spin_lock(&dcache_lock);
 	spin_lock(&parent->d_lock);
 	next = parent->d_subdirs.next;
 	while (next != &parent->d_subdirs) {
@@ -72,7 +71,6 @@ smb_invalidate_dircache_entries(struct d
 		next = next->next;
 	}
 	spin_unlock(&parent->d_lock);
-	spin_unlock(&dcache_lock);
 }
 
 /*
@@ -98,7 +96,6 @@ smb_dget_fpos(struct dentry *dentry, str
 	}
 
 	/* If a pointer is invalid, we search the dentry. */
-	spin_lock(&dcache_lock);
 	spin_lock(&parent->d_lock);
 	next = parent->d_subdirs.next;
 	while (next != &parent->d_subdirs) {
@@ -115,7 +112,6 @@ smb_dget_fpos(struct dentry *dentry, str
 	dent = NULL;
 out_unlock:
 	spin_unlock(&parent->d_lock);
-	spin_unlock(&dcache_lock);
 	return dent;
 }
 
Index: linux-2.6/fs/libfs.c
===================================================================
--- linux-2.6.orig/fs/libfs.c	2010-11-17 00:52:37.000000000 +1100
+++ linux-2.6/fs/libfs.c	2010-11-17 00:52:37.000000000 +1100
@@ -100,7 +100,6 @@ loff_t dcache_dir_lseek(struct file *fil
 			struct dentry *cursor = file->private_data;
 			loff_t n = file->f_pos - 2;
 
-			spin_lock(&dcache_lock);
 			spin_lock(&dentry->d_lock);
 			/* d_lock not required for cursor */
 			list_del(&cursor->d_u.d_child);
@@ -116,7 +115,6 @@ loff_t dcache_dir_lseek(struct file *fil
 			}
 			list_add_tail(&cursor->d_u.d_child, p);
 			spin_unlock(&dentry->d_lock);
-			spin_unlock(&dcache_lock);
 		}
 	}
 	mutex_unlock(&dentry->d_inode->i_mutex);
@@ -159,7 +157,6 @@ int dcache_readdir(struct file * filp, v
 			i++;
 			/* fallthrough */
 		default:
-			spin_lock(&dcache_lock);
 			spin_lock(&dentry->d_lock);
 			if (filp->f_pos == 2)
 				list_move(q, &dentry->d_subdirs);
@@ -175,13 +172,11 @@ int dcache_readdir(struct file * filp, v
 
 				spin_unlock(&next->d_lock);
 				spin_unlock(&dentry->d_lock);
-				spin_unlock(&dcache_lock);
 				if (filldir(dirent, next->d_name.name, 
 					    next->d_name.len, filp->f_pos, 
 					    next->d_inode->i_ino, 
 					    dt_type(next->d_inode)) < 0)
 					return 0;
-				spin_lock(&dcache_lock);
 				spin_lock(&dentry->d_lock);
 				spin_lock_nested(&next->d_lock, DENTRY_D_LOCK_NESTED);
 				/* next is still alive */
@@ -191,7 +186,6 @@ int dcache_readdir(struct file * filp, v
 				filp->f_pos++;
 			}
 			spin_unlock(&dentry->d_lock);
-			spin_unlock(&dcache_lock);
 	}
 	return 0;
 }
@@ -285,7 +279,6 @@ int simple_empty(struct dentry *dentry)
 	struct dentry *child;
 	int ret = 0;
 
-	spin_lock(&dcache_lock);
 	spin_lock(&dentry->d_lock);
 	list_for_each_entry(child, &dentry->d_subdirs, d_u.d_child) {
 		spin_lock_nested(&child->d_lock, DENTRY_D_LOCK_NESTED);
@@ -298,7 +291,6 @@ int simple_empty(struct dentry *dentry)
 	ret = 1;
 out:
 	spin_unlock(&dentry->d_lock);
-	spin_unlock(&dcache_lock);
 	return ret;
 }
 
Index: linux-2.6/include/linux/fsnotify.h
===================================================================
--- linux-2.6.orig/include/linux/fsnotify.h	2010-11-17 00:50:48.000000000 +1100
+++ linux-2.6/include/linux/fsnotify.h	2010-11-17 00:52:37.000000000 +1100
@@ -17,7 +17,6 @@
 
 /*
  * fsnotify_d_instantiate - instantiate a dentry for inode
- * Called with dcache_lock held.
  */
 static inline void fsnotify_d_instantiate(struct dentry *dentry,
 					  struct inode *inode)
@@ -62,7 +61,6 @@ static inline int fsnotify_perm(struct f
 
 /*
  * fsnotify_d_move - dentry has been moved
- * Called with dcache_lock and dentry->d_lock held.
  */
 static inline void fsnotify_d_move(struct dentry *dentry)
 {


