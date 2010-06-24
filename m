Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754867Ab0FXDQ5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 23:16:57 -0400
Received: from cantor.suse.de ([195.135.220.2]:48469 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754185Ab0FXDPx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 23:15:53 -0400
Message-Id: <20100624030728.290183109@suse.de>
User-Agent: quilt/0.48-4.4
Date: Thu, 24 Jun 2010 13:02:29 +1000
From: npiggin@suse.de
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: John Stultz <johnstul@us.ibm.com>, Frank Mayhar <fmayhar@google.com>
Subject: [patch 17/52] fs: dcache remove dcache_lock
References: <20100624030212.676457061@suse.de>
Content-Disposition: inline; filename=fs-dcache_lock-remove.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dcache_lock no longer protects anything. remove it.

Signed-off-by: Nick Piggin <npiggin@suse.de>
---
 Documentation/filesystems/Locking         |    2 
 arch/powerpc/platforms/cell/spufs/inode.c |    5 -
 drivers/infiniband/hw/ipath/ipath_fs.c    |    6 -
 drivers/infiniband/hw/qib/qib_fs.c        |    3 
 drivers/staging/pohmelfs/path_entry.c     |    2 
 drivers/usb/core/inode.c                  |    3 
 fs/affs/amigaffs.c                        |    2 
 fs/autofs4/autofs_i.h                     |    3 
 fs/autofs4/expire.c                       |   24 ++---
 fs/autofs4/root.c                         |   14 +--
 fs/autofs4/waitq.c                        |    7 -
 fs/ceph/dir.c                             |    6 -
 fs/ceph/inode.c                           |    4 
 fs/coda/cache.c                           |    2 
 fs/configfs/configfs_internal.h           |    2 
 fs/configfs/inode.c                       |    6 -
 fs/dcache.c                               |  135 ++++--------------------------
 fs/exportfs/expfs.c                       |    4 
 fs/namei.c                                |    9 --
 fs/ncpfs/dir.c                            |    3 
 fs/ncpfs/ncplib_kernel.h                  |    4 
 fs/nfs/dir.c                              |    3 
 fs/nfs/getroot.c                          |    2 
 fs/nfs/namespace.c                        |    3 
 fs/notify/fsnotify.c                      |    2 
 fs/notify/inotify/inotify.c               |    4 
 fs/ocfs2/dcache.c                         |    2 
 fs/seq_file.c                             |    2 
 fs/smbfs/cache.c                          |    4 
 include/linux/dcache.h                    |   17 +--
 include/linux/fs.h                        |    4 
 include/linux/fsnotify_backend.h          |    5 -
 kernel/cgroup.c                           |    6 -
 security/selinux/selinuxfs.c              |    4 
 security/tomoyo/realpath.c                |    2 
 35 files changed, 67 insertions(+), 239 deletions(-)

Index: linux-2.6/fs/dcache.c
===================================================================
--- linux-2.6.orig/fs/dcache.c
+++ linux-2.6/fs/dcache.c
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
 
@@ -125,7 +122,7 @@ static void d_callback(struct rcu_head *
 }
 
 /*
- * no dcache_lock, please.
+ * no locks, please.
  */
 static void d_free(struct dentry *dentry)
 {
@@ -147,7 +144,6 @@ static void d_free(struct dentry *dentry
 static void dentry_iput(struct dentry * dentry)
 	__releases(dentry->d_lock)
 	__releases(dcache_inode_lock)
-	__releases(dcache_lock)
 {
 	struct inode *inode = dentry->d_inode;
 	if (inode) {
@@ -155,7 +151,6 @@ static void dentry_iput(struct dentry *
 		list_del_init(&dentry->d_alias);
 		spin_unlock(&dentry->d_lock);
 		spin_unlock(&dcache_inode_lock);
-		spin_unlock(&dcache_lock);
 		if (!inode->i_nlink)
 			fsnotify_inoderemove(inode);
 		if (dentry->d_op && dentry->d_op->d_iput)
@@ -165,7 +160,6 @@ static void dentry_iput(struct dentry *
 	} else {
 		spin_unlock(&dentry->d_lock);
 		spin_unlock(&dcache_inode_lock);
-		spin_unlock(&dcache_lock);
 	}
 }
 
@@ -231,13 +225,12 @@ static void dentry_lru_del_init(struct d
  *
  * If this is the root of the dentry tree, return NULL.
  *
- * dcache_lock and d_lock and d_parent->d_lock must be held by caller, and
+ * d_lock and d_parent->d_lock must be held by caller, and
  * are dropped by d_kill.
  */
 static struct dentry *d_kill(struct dentry *dentry)
 	__releases(dentry->d_lock)
 	__releases(dcache_inode_lock)
-	__releases(dcache_lock)
 {
 	struct dentry *parent;
 
@@ -294,21 +287,10 @@ repeat:
 		might_sleep();
 	spin_lock(&dentry->d_lock);
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
 		parent = dentry->d_parent;
 		if (parent && parent != dentry) {
@@ -323,7 +305,6 @@ drop2:
 		spin_unlock(&dentry->d_lock);
 		if (parent && parent != dentry)
 			spin_unlock(&parent->d_lock);
-		spin_unlock(&dcache_lock);
 		return;
 	}
 
@@ -345,7 +326,6 @@ drop2:
 	if (parent && parent != dentry)
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
@@ -526,11 +500,9 @@ struct dentry * d_find_alias(struct inod
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
@@ -544,7 +516,6 @@ void d_prune_aliases(struct inode *inode
 {
 	struct dentry *dentry;
 restart:
-	spin_lock(&dcache_lock);
 	spin_lock(&dcache_inode_lock);
 	list_for_each_entry(dentry, &inode->i_dentry, d_alias) {
 		spin_lock(&dentry->d_lock);
@@ -553,14 +524,12 @@ restart:
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
 
@@ -574,20 +543,16 @@ EXPORT_SYMBOL(d_prune_aliases);
  */
 static void prune_one_dentry(struct dentry * dentry)
 	__releases(dentry->d_lock)
-	__releases(dcache_lock)
-	__acquires(dcache_lock)
 {
 	__d_drop(dentry);
 	dentry = d_kill(dentry);
 
 	/*
-	 * Prune ancestors.  Locking is simpler than in dput(),
-	 * because dcache_lock needs to be taken anyway.
+	 * Prune ancestors.
 	 */
 	while (dentry) {
 		struct dentry *parent = NULL;
 
-		spin_lock(&dcache_lock);
 		spin_lock(&dcache_inode_lock);
 again:
 		spin_lock(&dentry->d_lock);
@@ -604,7 +569,6 @@ again:
 				spin_unlock(&parent->d_lock);
 			spin_unlock(&dentry->d_lock);
 			spin_unlock(&dcache_inode_lock);
-			spin_unlock(&dcache_lock);
 			return;
 		}
 
@@ -673,7 +637,6 @@ restart:
 	}
 	spin_unlock(&dcache_lru_lock);
 
-	spin_lock(&dcache_lock);
 	spin_lock(&dcache_inode_lock);
 again:
 	spin_lock(&dcache_lru_lock); /* lru_lock also protects tmp list */
@@ -703,14 +666,13 @@ again1:
 		}
 		__dentry_lru_del_init(dentry);
 		spin_unlock(&dcache_lru_lock);
+
 		prune_one_dentry(dentry);
-		/* dcache_lock and dentry->d_lock dropped */
-		spin_lock(&dcache_lock);
+		/* dentry->d_lock dropped */
 		spin_lock(&dcache_inode_lock);
 		spin_lock(&dcache_lru_lock);
 	}
 	spin_unlock(&dcache_inode_lock);
-	spin_unlock(&dcache_lock);
 
 	if (count == NULL && !list_empty(&sb->s_dentry_lru))
 		goto restart;
@@ -740,7 +702,6 @@ static void prune_dcache(int count)
 
 	if (unused == 0 || count == 0)
 		return;
-	spin_lock(&dcache_lock);
 	if (count >= unused)
 		prune_ratio = 1;
 	else
@@ -777,11 +738,9 @@ static void prune_dcache(int count)
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
@@ -795,7 +754,6 @@ static void prune_dcache(int count)
 			break;
 	}
 	spin_unlock(&sb_lock);
-	spin_unlock(&dcache_lock);
 }
 
 /**
@@ -825,12 +783,10 @@ static void shrink_dcache_for_umount_sub
 	BUG_ON(!IS_ROOT(dentry));
 
 	/* detach this root from the system */
-	spin_lock(&dcache_lock);
 	spin_lock(&dentry->d_lock);
 	dentry_lru_del_init(dentry);
 	__d_drop(dentry);
 	spin_unlock(&dentry->d_lock);
-	spin_unlock(&dcache_lock);
 
 	for (;;) {
 		/* descend to the first leaf in the current subtree */
@@ -839,7 +795,6 @@ static void shrink_dcache_for_umount_sub
 
 			/* this is a branch with children - detach all of them
 			 * from the system in one go */
-			spin_lock(&dcache_lock);
 			spin_lock(&dentry->d_lock);
 			list_for_each_entry(loop, &dentry->d_subdirs,
 					    d_u.d_child) {
@@ -849,7 +804,6 @@ static void shrink_dcache_for_umount_sub
 				spin_unlock(&loop->d_lock);
 			}
 			spin_unlock(&dentry->d_lock);
-			spin_unlock(&dcache_lock);
 
 			/* move to the first child */
 			dentry = list_entry(dentry->d_subdirs.next,
@@ -920,8 +874,7 @@ out:
 
 /*
  * destroy the dentries attached to a superblock on unmounting
- * - we don't need to use dentry->d_lock, and only need dcache_lock when
- *   removing the dentry from the system lists and hashes because:
+ * - we don't need to use dentry->d_lock because:
  *   - the superblock is detached from all mountings and open files, so the
  *     dentry trees will not be rearranged by the VFS
  *   - s_umount is write-locked, so the memory pressure shrinker will ignore
@@ -972,7 +925,6 @@ rename_retry:
 	this_parent = parent;
 	seq = read_seqbegin(&rename_lock);
 
-	spin_lock(&dcache_lock);
 	if (d_mountpoint(parent))
 		goto positive;
 	spin_lock(&this_parent->d_lock);
@@ -1019,7 +971,6 @@ resume:
 				// d_unlinked(this_parent) || XXX
 				read_seqretry(&rename_lock, seq)) {
 			spin_unlock(&this_parent->d_lock);
-			spin_unlock(&dcache_lock);
 			rcu_read_unlock();
 			goto rename_retry;
 		}
@@ -1028,12 +979,10 @@ resume:
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
@@ -1066,7 +1015,6 @@ rename_retry:
 	this_parent = parent;
 	seq = read_seqbegin(&rename_lock);
 
-	spin_lock(&dcache_lock);
 	spin_lock(&this_parent->d_lock);
 repeat:
 	next = this_parent->d_subdirs.next;
@@ -1129,7 +1077,6 @@ resume:
 				// d_unlinked(this_parent) || XXX
 				read_seqretry(&rename_lock, seq)) {
 			spin_unlock(&this_parent->d_lock);
-			spin_unlock(&dcache_lock);
 			rcu_read_unlock();
 			goto rename_retry;
 		}
@@ -1139,7 +1086,6 @@ resume:
 	}
 out:
 	spin_unlock(&this_parent->d_lock);
-	spin_unlock(&dcache_lock);
 	if (read_seqretry(&rename_lock, seq))
 		goto rename_retry;
 	return found;
@@ -1240,7 +1186,6 @@ struct dentry *d_alloc(struct dentry * p
 	INIT_LIST_HEAD(&dentry->d_u.d_child);
 
 	if (parent) {
-		spin_lock(&dcache_lock);
 		spin_lock(&parent->d_lock);
 		spin_lock_nested(&dentry->d_lock, DENTRY_D_LOCK_NESTED);
 		dentry->d_parent = dget_dlock(parent);
@@ -1248,7 +1193,6 @@ struct dentry *d_alloc(struct dentry * p
 		list_add(&dentry->d_u.d_child, &parent->d_subdirs);
 		spin_unlock(&dentry->d_lock);
 		spin_unlock(&parent->d_lock);
-		spin_unlock(&dcache_lock);
 	}
 
 	atomic_inc(&dentry_stat.nr_dentry);
@@ -1268,7 +1212,6 @@ struct dentry *d_alloc_name(struct dentr
 }
 EXPORT_SYMBOL(d_alloc_name);
 
-/* the caller must hold dcache_lock */
 static void __d_instantiate(struct dentry *dentry, struct inode *inode)
 {
 	spin_lock(&dentry->d_lock);
@@ -1297,11 +1240,9 @@ static void __d_instantiate(struct dentr
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
@@ -1360,11 +1301,9 @@ struct dentry *d_instantiate_unique(stru
 
 	BUG_ON(!list_empty(&entry->d_alias));
 
-	spin_lock(&dcache_lock);
 	spin_lock(&dcache_inode_lock);
 	result = __d_instantiate_unique(entry, inode);
 	spin_unlock(&dcache_inode_lock);
-	spin_unlock(&dcache_lock);
 
 	if (!result) {
 		security_d_instantiate(entry, inode);
@@ -1453,12 +1392,10 @@ struct dentry *d_obtain_alias(struct ino
 	}
 	tmp->d_parent = tmp; /* make sure dput doesn't croak */
 
-	spin_lock(&dcache_lock);
 	spin_lock(&dcache_inode_lock);
 	res = __d_find_alias(inode, 0);
 	if (res) {
 		spin_unlock(&dcache_inode_lock);
-		spin_unlock(&dcache_lock);
 		dput(tmp);
 		goto out_iput;
 	}
@@ -1474,7 +1411,6 @@ struct dentry *d_obtain_alias(struct ino
 	spin_unlock(&tmp->d_lock);
 	spin_unlock(&dcache_inode_lock);
 
-	spin_unlock(&dcache_lock);
 	return tmp;
 
  out_iput:
@@ -1504,21 +1440,18 @@ struct dentry *d_splice_alias(struct ino
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
+			/* already got dcache_inode_lock, so d_add() by hand */
 			__d_instantiate(dentry, inode);
 			spin_unlock(&dcache_inode_lock);
-			spin_unlock(&dcache_lock);
 			security_d_instantiate(dentry, inode);
 			d_rehash(dentry);
 		}
@@ -1591,12 +1524,10 @@ struct dentry *d_add_ci(struct dentry *d
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
@@ -1608,7 +1539,6 @@ struct dentry *d_add_ci(struct dentry *d
 	new = list_entry(inode->i_dentry.next, struct dentry, d_alias);
 	dget_locked(new);
 	spin_unlock(&dcache_inode_lock);
-	spin_unlock(&dcache_lock);
 	security_d_instantiate(found, inode);
 	d_move(new, found);
 	iput(inode);
@@ -1631,7 +1561,7 @@ EXPORT_SYMBOL(d_add_ci);
  * is returned. The caller must use dput to free the entry when it has
  * finished using it. %NULL is returned on failure.
  *
- * __d_lookup is dcache_lock free. The hash list is protected using RCU.
+ * __d_lookup is global lock free. The hash list is protected using RCU.
  * Memory barriers are used while updating and doing lockless traversal. 
  * To avoid races with d_move while rename is happening, d_lock is used.
  *
@@ -1643,7 +1573,7 @@ EXPORT_SYMBOL(d_add_ci);
  *
  * The dentry unused LRU is not updated even if lookup finds the required dentry
  * in there. It is updated in places such as prune_dcache, shrink_dcache_sb,
- * select_parent and __dget_locked. This laziness saves lookup from dcache_lock
+ * select_parent and __dget_locked. This laziness saves lookup from LRU lock
  * acquisition.
  *
  * d_lookup() is protected against the concurrent renames in some unrelated
@@ -1774,25 +1704,22 @@ int d_validate(struct dentry *dentry, st
 	if (dentry->d_parent != dparent)
 		goto out;
 
-	spin_lock(&dcache_lock);
 	spin_lock(&dentry->d_lock);
 	spin_lock(&dcache_hash_lock);
 	base = d_hash(dparent, dentry->d_name.hash);
 	hlist_for_each(lhp,base) { 
 		/* hlist_for_each_entry_rcu() not required for d_hash list
-		 * as it is parsed under dcache_lock
+		 * as it is parsed under dcache_hash_lock
 		 */
 		if (dentry == hlist_entry(lhp, struct dentry, d_hash)) {
 			spin_unlock(&dcache_hash_lock);
 			__dget_locked_dlock(dentry);
 			spin_unlock(&dentry->d_lock);
-			spin_unlock(&dcache_lock);
 			return 1;
 		}
 	}
 	spin_unlock(&dcache_hash_lock);
 	spin_unlock(&dentry->d_lock);
-	spin_unlock(&dcache_lock);
 out:
 	return 0;
 }
@@ -1825,7 +1752,6 @@ void d_delete(struct dentry * dentry)
 	/*
 	 * Are we the only user?
 	 */
-	spin_lock(&dcache_lock);
 	spin_lock(&dcache_inode_lock);
 	spin_lock(&dentry->d_lock);
 	isdir = S_ISDIR(dentry->d_inode->i_mode);
@@ -1841,7 +1767,6 @@ void d_delete(struct dentry * dentry)
 
 	spin_unlock(&dentry->d_lock);
 	spin_unlock(&dcache_inode_lock);
-	spin_unlock(&dcache_lock);
 
 	fsnotify_nameremove(dentry, isdir);
 }
@@ -1868,13 +1793,11 @@ static void _d_rehash(struct dentry * en
  
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
 
@@ -2032,9 +1955,7 @@ static void d_move_locked(struct dentry
 
 void d_move(struct dentry * dentry, struct dentry * target)
 {
-	spin_lock(&dcache_lock);
 	d_move_locked(dentry, target);
-	spin_unlock(&dcache_lock);
 }
 EXPORT_SYMBOL(d_move);
 
@@ -2061,13 +1982,12 @@ struct dentry *d_ancestor(struct dentry
  * This helper attempts to cope with remotely renamed directories
  *
  * It assumes that the caller is already holding
- * dentry->d_parent->d_inode->i_mutex and the dcache_lock
+ * dentry->d_parent->d_inode->i_mutex
  *
  * Note: If ever the locking in lock_rename() changes, then please
  * remember to update this too...
  */
 static struct dentry *__d_unalias(struct dentry *dentry, struct dentry *alias)
-	__releases(dcache_lock)
 {
 	struct mutex *m1 = NULL, *m2 = NULL;
 	struct dentry *ret;
@@ -2094,7 +2014,6 @@ out_unalias:
 	ret = alias;
 out_err:
 	spin_unlock(&dcache_inode_lock);
-	spin_unlock(&dcache_lock);
 	if (m2)
 		mutex_unlock(m2);
 	if (m1)
@@ -2158,7 +2077,6 @@ struct dentry *d_materialise_unique(stru
 
 	BUG_ON(!d_unhashed(dentry));
 
-	spin_lock(&dcache_lock);
 	spin_lock(&dcache_inode_lock);
 
 	if (!inode) {
@@ -2204,7 +2122,6 @@ found:
 	spin_unlock(&dcache_hash_lock);
 	spin_unlock(&actual->d_lock);
 	spin_unlock(&dcache_inode_lock);
-	spin_unlock(&dcache_lock);
 out_nolock:
 	if (actual == dentry) {
 		security_d_instantiate(dentry, inode);
@@ -2216,7 +2133,6 @@ out_nolock:
 
 shouldnt_be_hashed:
 	spin_unlock(&dcache_inode_lock);
-	spin_unlock(&dcache_lock);
 	BUG();
 }
 EXPORT_SYMBOL_GPL(d_materialise_unique);
@@ -2249,8 +2165,7 @@ static int prepend_name(char **buffer, i
  * Returns a pointer into the buffer or an error code if the
  * path was too long.
  *
- * "buflen" should be positive. Caller holds the dcache_lock and
- * path->dentry->d_lock.
+ * "buflen" should be positive. Caller holds the path->dentry->d_lock.
  *
  * If path is not reachable from the supplied root, then the value of
  * root is changed (without modifying refcounts).
@@ -2371,12 +2286,10 @@ char *d_path(const struct path *path, ch
 	path_get(&root);
 	spin_unlock(&current->fs->lock);
 
-	spin_lock(&dcache_lock);
 	br_read_lock(vfsmount_lock);
 	tmp = root;
 	res = __d_path(path, &tmp, buf, buflen);
 	br_read_unlock(vfsmount_lock);
-	spin_unlock(&dcache_lock);
 
 	path_put(&root);
 	return res;
@@ -2418,7 +2331,6 @@ rename_retry:
 	prepend(&end, &buflen, "\0", 1);
 
 	seq = read_seqbegin(&rename_lock);
-	spin_lock(&dcache_lock);
 	br_read_lock(vfsmount_lock);
 	rcu_read_lock(); /* protect parent */
 	spin_lock(&dentry->d_lock);
@@ -2451,7 +2363,6 @@ out:
 	spin_unlock(&dentry->d_lock);
 	rcu_read_unlock();
 	br_read_unlock(vfsmount_lock);
-	spin_unlock(&dcache_lock);
 	if (read_seqretry(&rename_lock, seq))
 		goto rename_retry;
 	return retval;
@@ -2495,7 +2406,6 @@ SYSCALL_DEFINE2(getcwd, char __user *, b
 	spin_unlock(&current->fs->lock);
 
 	error = -ENOENT;
-	spin_lock(&dcache_lock);
 	br_read_lock(vfsmount_lock);
 	spin_lock(&pwd.dentry->d_lock);
 	if (!d_unlinked(pwd.dentry)) {
@@ -2507,7 +2417,6 @@ SYSCALL_DEFINE2(getcwd, char __user *, b
 		/* XXX: race here, have to close (eg. return unlinked from __d_path) */
 		cwd = __d_path(&pwd, &tmp, page, PAGE_SIZE);
 		br_read_unlock(vfsmount_lock);
-		spin_unlock(&dcache_lock);
 
 		error = PTR_ERR(cwd);
 		if (IS_ERR(cwd))
@@ -2523,7 +2432,6 @@ SYSCALL_DEFINE2(getcwd, char __user *, b
 	} else {
 		spin_unlock(&pwd.dentry->d_lock);
 		br_read_unlock(vfsmount_lock);
-		spin_unlock(&dcache_lock);
 	}
 
 out:
@@ -2609,7 +2517,6 @@ void d_genocide(struct dentry *root)
 rename_retry:
 	this_parent = root;
 	seq = read_seqbegin(&rename_lock);
-	spin_lock(&dcache_lock);
 	spin_lock(&this_parent->d_lock);
 repeat:
 	next = this_parent->d_subdirs.next;
@@ -2657,7 +2564,6 @@ resume:
 				// d_unlinked(this_parent) || XXX
 				read_seqretry(&rename_lock, seq)) {
 			spin_unlock(&this_parent->d_lock);
-			spin_unlock(&dcache_lock);
 			rcu_read_unlock();
 			goto rename_retry;
 		}
@@ -2666,7 +2572,6 @@ resume:
 		goto resume;
 	}
 	spin_unlock(&this_parent->d_lock);
-	spin_unlock(&dcache_lock);
 	if (read_seqretry(&rename_lock, seq))
 		goto rename_retry;
 }
Index: linux-2.6/fs/namei.c
===================================================================
--- linux-2.6.orig/fs/namei.c
+++ linux-2.6/fs/namei.c
@@ -618,8 +618,8 @@ int follow_up(struct path *path)
 	return 1;
 }
 
-/* no need for dcache_lock, as serialization is taken care in
- * namespace.c
+/*
+ * serialization is taken care of in namespace.c
  */
 static int __follow_mount(struct path *path)
 {
@@ -651,9 +651,6 @@ static void follow_mount(struct path *pa
 	}
 }
 
-/* no need for dcache_lock, as serialization is taken care in
- * namespace.c
- */
 int follow_down(struct path *path)
 {
 	struct vfsmount *mounted;
@@ -2152,12 +2149,10 @@ void dentry_unhash(struct dentry *dentry
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
Index: linux-2.6/fs/seq_file.c
===================================================================
--- linux-2.6.orig/fs/seq_file.c
+++ linux-2.6/fs/seq_file.c
@@ -465,11 +465,9 @@ int seq_path_root(struct seq_file *m, st
 	if (size) {
 		char *p;
 
-		spin_lock(&dcache_lock);
 		br_read_lock(vfsmount_lock);
 		p = __d_path(path, root, buf, size);
 		br_read_unlock(vfsmount_lock);
-		spin_unlock(&dcache_lock);
 
 		res = PTR_ERR(p);
 		if (!IS_ERR(p)) {
Index: linux-2.6/include/linux/dcache.h
===================================================================
--- linux-2.6.orig/include/linux/dcache.h
+++ linux-2.6/include/linux/dcache.h
@@ -150,13 +150,13 @@ struct dentry_operations {
 
 /*
 locking rules:
-		big lock	dcache_lock	d_lock   may block
-d_revalidate:	no		no		no       yes
-d_hash		no		no		no       yes
-d_compare:	no		yes		yes      no
-d_delete:	no		yes		no       no
-d_release:	no		no		no       yes
-d_iput:		no		no		no       yes
+		big lock	d_lock   may block
+d_revalidate:	no		no       yes
+d_hash		no		no       yes
+d_compare:	no		yes      no
+d_delete:	no		no       no
+d_release:	no		no       yes
+d_iput:		no		no       yes
  */
 
 /* d_flags entries */
@@ -191,7 +191,6 @@ d_iput:		no		no		no       yes
 
 extern spinlock_t dcache_inode_lock;
 extern spinlock_t dcache_hash_lock;
-extern spinlock_t dcache_lock;
 extern seqlock_t rename_lock;
 
 /**
@@ -222,11 +221,9 @@ static inline void __d_drop(struct dentr
 
 static inline void d_drop(struct dentry *dentry)
 {
-	spin_lock(&dcache_lock);
 	spin_lock(&dentry->d_lock);
  	__d_drop(dentry);
 	spin_unlock(&dentry->d_lock);
-	spin_unlock(&dcache_lock);
 }
 
 static inline int dname_external(struct dentry *dentry)
Index: linux-2.6/fs/notify/inotify/inotify.c
===================================================================
--- linux-2.6.orig/fs/notify/inotify/inotify.c
+++ linux-2.6/fs/notify/inotify/inotify.c
@@ -181,7 +181,6 @@ static void set_dentry_child_flags(struc
 {
 	struct dentry *alias;
 
-	spin_lock(&dcache_lock);
 	spin_lock(&dcache_inode_lock);
 	list_for_each_entry(alias, &inode->i_dentry, d_alias) {
 		struct dentry *child;
@@ -201,7 +200,6 @@ static void set_dentry_child_flags(struc
 		spin_unlock(&alias->d_lock);
 	}
 	spin_unlock(&dcache_inode_lock);
-	spin_unlock(&dcache_lock);
 }
 
 /*
@@ -269,6 +267,7 @@ void inotify_d_instantiate(struct dentry
 	if (!inode)
 		return;
 
+	/* XXX: need parent lock in place of dcache_lock? */
 	spin_lock(&entry->d_lock);
 	parent = entry->d_parent;
 	if (parent->d_inode && inotify_inode_watched(parent->d_inode))
@@ -283,6 +282,7 @@ void inotify_d_move(struct dentry *entry
 {
 	struct dentry *parent;
 
+	/* XXX: need parent lock in place of dcache_lock? */
 	parent = entry->d_parent;
 	if (inotify_inode_watched(parent->d_inode))
 		entry->d_flags |= DCACHE_INOTIFY_PARENT_WATCHED;
Index: linux-2.6/fs/exportfs/expfs.c
===================================================================
--- linux-2.6.orig/fs/exportfs/expfs.c
+++ linux-2.6/fs/exportfs/expfs.c
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
--- linux-2.6.orig/Documentation/filesystems/Locking
+++ linux-2.6/Documentation/filesystems/Locking
@@ -17,7 +17,7 @@ prototypes:
 	void (*d_iput)(struct dentry *, struct inode *);
 	char *(*d_dname)((struct dentry *dentry, char *buffer, int buflen);
 
-locking rules:
+locking rules: XXX: update these!!
 	none have BKL
 		dcache_lock	rename_lock	->d_lock	may block
 d_revalidate:	no		no		no		yes
Index: linux-2.6/arch/powerpc/platforms/cell/spufs/inode.c
===================================================================
--- linux-2.6.orig/arch/powerpc/platforms/cell/spufs/inode.c
+++ linux-2.6/arch/powerpc/platforms/cell/spufs/inode.c
@@ -158,21 +158,18 @@ static void spufs_prune_dir(struct dentr
 
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
--- linux-2.6.orig/drivers/infiniband/hw/ipath/ipath_fs.c
+++ linux-2.6/drivers/infiniband/hw/ipath/ipath_fs.c
@@ -273,18 +273,14 @@ static int remove_file(struct dentry *pa
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
--- linux-2.6.orig/drivers/usb/core/inode.c
+++ linux-2.6/drivers/usb/core/inode.c
@@ -347,7 +347,6 @@ static int usbfs_empty (struct dentry *d
 {
 	struct list_head *list;
 
-	spin_lock(&dcache_lock);
 	spin_lock(&dentry->d_lock);
 	list_for_each(list, &dentry->d_subdirs) {
 		struct dentry *de = list_entry(list, struct dentry, d_u.d_child);
@@ -356,13 +355,11 @@ static int usbfs_empty (struct dentry *d
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
--- linux-2.6.orig/fs/affs/amigaffs.c
+++ linux-2.6/fs/affs/amigaffs.c
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
--- linux-2.6.orig/fs/coda/cache.c
+++ linux-2.6/fs/coda/cache.c
@@ -86,7 +86,6 @@ static void coda_flag_children(struct de
 	struct list_head *child;
 	struct dentry *de;
 
-	spin_lock(&dcache_lock);
 	spin_lock(&parent->d_lock);
 	list_for_each(child, &parent->d_subdirs)
 	{
@@ -97,7 +96,6 @@ static void coda_flag_children(struct de
 		coda_flag_inode(de->d_inode, flag);
 	}
 	spin_unlock(&parent->d_lock);
-	spin_unlock(&dcache_lock);
 	return; 
 }
 
Index: linux-2.6/fs/configfs/configfs_internal.h
===================================================================
--- linux-2.6.orig/fs/configfs/configfs_internal.h
+++ linux-2.6/fs/configfs/configfs_internal.h
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
--- linux-2.6.orig/fs/configfs/inode.c
+++ linux-2.6/fs/configfs/inode.c
@@ -249,18 +249,14 @@ void configfs_drop_dentry(struct configf
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
--- linux-2.6.orig/fs/ncpfs/dir.c
+++ linux-2.6/fs/ncpfs/dir.c
@@ -364,7 +364,6 @@ ncp_dget_fpos(struct dentry *dentry, str
 	}
 
 	/* If a pointer is invalid, we search the dentry. */
-	spin_lock(&dcache_lock);
 	spin_lock(&parent->d_lock);
 	next = parent->d_subdirs.next;
 	while (next != &parent->d_subdirs) {
@@ -375,13 +374,11 @@ ncp_dget_fpos(struct dentry *dentry, str
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
Index: linux-2.6/fs/ncpfs/ncplib_kernel.h
===================================================================
--- linux-2.6.orig/fs/ncpfs/ncplib_kernel.h
+++ linux-2.6/fs/ncpfs/ncplib_kernel.h
@@ -192,7 +192,6 @@ ncp_renew_dentries(struct dentry *parent
 	struct list_head *next;
 	struct dentry *dentry;
 
-	spin_lock(&dcache_lock);
 	spin_lock(&parent->d_lock);
 	next = parent->d_subdirs.next;
 	while (next != &parent->d_subdirs) {
@@ -206,7 +205,6 @@ ncp_renew_dentries(struct dentry *parent
 		next = next->next;
 	}
 	spin_unlock(&parent->d_lock);
-	spin_unlock(&dcache_lock);
 }
 
 static inline void
@@ -216,7 +214,6 @@ ncp_invalidate_dircache_entries(struct d
 	struct list_head *next;
 	struct dentry *dentry;
 
-	spin_lock(&dcache_lock);
 	spin_lock(&parent->d_lock);
 	next = parent->d_subdirs.next;
 	while (next != &parent->d_subdirs) {
@@ -226,7 +223,6 @@ ncp_invalidate_dircache_entries(struct d
 		next = next->next;
 	}
 	spin_unlock(&parent->d_lock);
-	spin_unlock(&dcache_lock);
 }
 
 struct ncp_cache_head {
Index: linux-2.6/fs/nfs/dir.c
===================================================================
--- linux-2.6.orig/fs/nfs/dir.c
+++ linux-2.6/fs/nfs/dir.c
@@ -1464,11 +1464,9 @@ static int nfs_unlink(struct inode *dir,
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
@@ -1479,7 +1477,6 @@ static int nfs_unlink(struct inode *dir,
 		need_rehash = 1;
 	}
 	spin_unlock(&dentry->d_lock);
-	spin_unlock(&dcache_lock);
 	error = nfs_safe_remove(dentry);
 	if (!error || error == -ENOENT) {
 		nfs_set_verifier(dentry, nfs_save_change_attribute(dir));
Index: linux-2.6/fs/ocfs2/dcache.c
===================================================================
--- linux-2.6.orig/fs/ocfs2/dcache.c
+++ linux-2.6/fs/ocfs2/dcache.c
@@ -151,7 +151,6 @@ struct dentry *ocfs2_find_local_alias(st
 	struct list_head *p;
 	struct dentry *dentry = NULL;
 
-	spin_lock(&dcache_lock);
 	spin_lock(&dcache_inode_lock);
 	list_for_each(p, &inode->i_dentry) {
 		dentry = list_entry(p, struct dentry, d_alias);
@@ -171,7 +170,6 @@ struct dentry *ocfs2_find_local_alias(st
 	}
 
 	spin_unlock(&dcache_inode_lock);
-	spin_unlock(&dcache_lock);
 
 	return dentry;
 }
Index: linux-2.6/fs/smbfs/cache.c
===================================================================
--- linux-2.6.orig/fs/smbfs/cache.c
+++ linux-2.6/fs/smbfs/cache.c
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
 
Index: linux-2.6/kernel/cgroup.c
===================================================================
--- linux-2.6.orig/kernel/cgroup.c
+++ linux-2.6/kernel/cgroup.c
@@ -869,7 +869,6 @@ static void cgroup_clear_directory(struc
 	struct list_head *node;
 
 	BUG_ON(!mutex_is_locked(&dentry->d_inode->i_mutex));
-	spin_lock(&dcache_lock);
 	spin_lock(&dentry->d_lock);
 	node = dentry->d_subdirs.next;
 	while (node != &dentry->d_subdirs) {
@@ -884,18 +883,15 @@ static void cgroup_clear_directory(struc
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
@@ -907,14 +903,12 @@ static void cgroup_d_remove_dir(struct d
 
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
--- linux-2.6.orig/security/selinux/selinuxfs.c
+++ linux-2.6/security/selinux/selinuxfs.c
@@ -941,7 +941,6 @@ static void sel_remove_entries(struct de
 {
 	struct list_head *node;
 
-	spin_lock(&dcache_lock);
 	spin_lock(&de->d_lock);
 	node = de->d_subdirs.next;
 	while (node != &de->d_subdirs) {
@@ -954,11 +953,9 @@ static void sel_remove_entries(struct de
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
@@ -966,7 +963,6 @@ static void sel_remove_entries(struct de
 	}
 
 	spin_unlock(&de->d_lock);
-	spin_unlock(&dcache_lock);
 }
 
 #define BOOL_DIR_NAME "booleans"
Index: linux-2.6/security/tomoyo/realpath.c
===================================================================
--- linux-2.6.orig/security/tomoyo/realpath.c
+++ linux-2.6/security/tomoyo/realpath.c
@@ -92,12 +92,10 @@ int tomoyo_realpath_from_path2(struct pa
 	} else {
 		struct path ns_root = {.mnt = NULL, .dentry = NULL};
 
-		spin_lock(&dcache_lock);
 		br_read_lock(vfsmount_lock);
 		/* go to whatever namespace root we are under */
 		sp = __d_path(path, &ns_root, newname, newname_len);
 		br_read_unlock(vfsmount_lock);
-		spin_unlock(&dcache_lock);
 		/* Prepend "/proc" prefix if using internal proc vfs mount. */
 		if (!IS_ERR(sp) && (path->mnt->mnt_flags & MNT_INTERNAL) &&
 		    (path->mnt->mnt_sb->s_magic == PROC_SUPER_MAGIC)) {
Index: linux-2.6/fs/nfs/getroot.c
===================================================================
--- linux-2.6.orig/fs/nfs/getroot.c
+++ linux-2.6/fs/nfs/getroot.c
@@ -64,13 +64,11 @@ static int nfs_superblock_set_dummy_root
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
--- linux-2.6.orig/drivers/staging/pohmelfs/path_entry.c
+++ linux-2.6/drivers/staging/pohmelfs/path_entry.c
@@ -101,7 +101,6 @@ rename_retry:
 	d = first;
 	seq = read_seqbegin(&rename_lock);
 	rcu_read_lock();
-	spin_lock(&dcache_lock);
 
 	if (!IS_ROOT(d) && d_unhashed(d))
 		len += UNHASHED_OBSCURE_STRING_SIZE; /* Obscure " (deleted)" string */
@@ -110,7 +109,6 @@ rename_retry:
 		len += d->d_name.len + 1; /* Plus slash */
 		d = d->d_parent;
 	}
-	spin_unlock(&dcache_lock);
 	rcu_read_unlock();
 	if (read_seqretry(&rename_lock, seq))
 		goto rename_retry;
Index: linux-2.6/fs/nfs/namespace.c
===================================================================
--- linux-2.6.orig/fs/nfs/namespace.c
+++ linux-2.6/fs/nfs/namespace.c
@@ -60,7 +60,6 @@ rename_retry:
 
 	seq = read_seqbegin(&rename_lock);
 	rcu_read_lock();
-	spin_lock(&dcache_lock);
 	while (!IS_ROOT(dentry) && dentry != droot) {
 		namelen = dentry->d_name.len;
 		buflen -= namelen + 1;
@@ -71,7 +70,6 @@ rename_retry:
 		*--end = '/';
 		dentry = dentry->d_parent;
 	}
-	spin_unlock(&dcache_lock);
 	rcu_read_unlock();
 	if (read_seqretry(&rename_lock, seq))
 		goto rename_retry;
@@ -91,7 +89,6 @@ rename_retry:
 	memcpy(end, base, namelen);
 	return end;
 Elong_unlock:
-	spin_unlock(&dcache_lock);
 	rcu_read_unlock();
 	if (read_seqretry(&rename_lock, seq))
 		goto rename_retry;
Index: linux-2.6/include/linux/fsnotify_backend.h
===================================================================
--- linux-2.6.orig/include/linux/fsnotify_backend.h
+++ linux-2.6/include/linux/fsnotify_backend.h
@@ -276,10 +276,10 @@ static inline void __fsnotify_update_dca
 {
 	struct dentry *parent;
 
-	assert_spin_locked(&dcache_lock);
 	assert_spin_locked(&dentry->d_lock);
 
 	parent = dentry->d_parent;
+	/* XXX: after dcache_lock removal, there is a race with parent->d_inode and fsnotify_inode_watches_children. must fix */
 	if (parent->d_inode && fsnotify_inode_watches_children(parent->d_inode))
 		dentry->d_flags |= DCACHE_FSNOTIFY_PARENT_WATCHED;
 	else
@@ -288,15 +288,12 @@ static inline void __fsnotify_update_dca
 
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
--- linux-2.6.orig/fs/notify/fsnotify.c
+++ linux-2.6/fs/notify/fsnotify.c
@@ -53,7 +53,6 @@ void __fsnotify_update_child_dentry_flag
 	/* determine if the children should tell inode about their events */
 	watched = fsnotify_inode_watches_children(inode);
 
-	spin_lock(&dcache_lock);
 	spin_lock(&dcache_inode_lock);
 	/* run all of the dentries associated with this inode.  Since this is a
 	 * directory, there damn well better only be one item on this list */
@@ -78,7 +77,6 @@ void __fsnotify_update_child_dentry_flag
 		spin_unlock(&alias->d_lock);
 	}
 	spin_unlock(&dcache_inode_lock);
-	spin_unlock(&dcache_lock);
 }
 
 /* Notify this dentry's parent about a child's events. */
Index: linux-2.6/include/linux/fs.h
===================================================================
--- linux-2.6.orig/include/linux/fs.h
+++ linux-2.6/include/linux/fs.h
@@ -2425,6 +2425,10 @@ static inline ino_t parent_ino(struct de
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
--- linux-2.6.orig/fs/autofs4/autofs_i.h
+++ linux-2.6/fs/autofs4/autofs_i.h
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
--- linux-2.6.orig/fs/autofs4/expire.c
+++ linux-2.6/fs/autofs4/expire.c
@@ -94,9 +94,9 @@ done:
  * Calculate next entry in top down tree traversal.
  * From next_mnt in namespace.c - elegant.
  *
- * How is this supposed to work if we drop dcache_lock between calls anyway?
+ * How is this supposed to work if we drop autofs4_lock between calls anyway?
  * How does it cope with renames?
- * And also callers dput the returned dentry before taking dcache_lock again
+ * And also callers dput the returned dentry before taking autofs4_lock again
  * so what prevents it from being freed??
  */
 static struct dentry *get_next_positive_dentry(struct dentry *p,
@@ -105,7 +105,7 @@ static struct dentry *get_next_positive_
 	struct list_head *next;
 	struct dentry *ret;
 
-	spin_lock(&dcache_lock);
+	spin_lock(&autofs4_lock);
 again:
 	spin_lock(&p->d_lock);
 	next = p->d_subdirs.next;
@@ -115,7 +115,7 @@ again:
 
 			if (p == root) {
 				spin_unlock(&p->d_lock);
-				spin_unlock(&dcache_lock);
+				spin_unlock(&autofs4_lock);
 				return NULL;
 			}
 
@@ -143,7 +143,7 @@ again:
 	dget_dlock(ret);
 	spin_unlock(&ret->d_lock);
 	spin_unlock(&p->d_lock);
-	spin_unlock(&dcache_lock);
+	spin_unlock(&autofs4_lock);
 
 	return ret;
 }
@@ -313,7 +313,7 @@ struct dentry *autofs4_expire_direct(str
  * A tree is eligible if :-
  *  - it is unused by any user process
  *  - it has been unused for exp_timeout time
- * This seems to be racy dropping dcache_lock and asking for next->next after
+ * This seems to be racy dropping autofs4_lock and asking for next->next after
  * the lock has been dropped.
  */
 struct dentry *autofs4_expire_indirect(struct super_block *sb,
@@ -336,7 +336,7 @@ struct dentry *autofs4_expire_indirect(s
 	now = jiffies;
 	timeout = sbi->exp_timeout;
 
-	spin_lock(&dcache_lock);
+	spin_lock(&autofs4_lock);
 	spin_lock(&root->d_lock);
 	next = root->d_subdirs.next;
 
@@ -355,7 +355,7 @@ struct dentry *autofs4_expire_indirect(s
 		dentry = dget_dlock(dentry);
 		spin_unlock(&dentry->d_lock);
 		spin_unlock(&root->d_lock);
-		spin_unlock(&dcache_lock);
+		spin_unlock(&autofs4_lock);
 
 		spin_lock(&sbi->fs_lock);
 		ino = autofs4_dentry_ino(dentry);
@@ -420,12 +420,12 @@ struct dentry *autofs4_expire_indirect(s
 next:
 		spin_unlock(&sbi->fs_lock);
 		dput(dentry);
-		spin_lock(&dcache_lock);
+		spin_lock(&autofs4_lock);
 		spin_lock(&root->d_lock);
 		next = next->next;
 	}
 	spin_unlock(&root->d_lock);
-	spin_unlock(&dcache_lock);
+	spin_unlock(&autofs4_lock);
 	return NULL;
 
 found:
@@ -435,13 +435,13 @@ found:
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
--- linux-2.6.orig/fs/autofs4/root.c
+++ linux-2.6/fs/autofs4/root.c
@@ -134,15 +134,15 @@ static int autofs4_dir_open(struct inode
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
@@ -248,11 +248,11 @@ static void *autofs4_follow_link(struct
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
@@ -274,7 +274,7 @@ static void *autofs4_follow_link(struct
 		goto follow;
 	}
 	spin_unlock(&dentry->d_lock);
-	spin_unlock(&dcache_lock);
+	spin_unlock(&autofs4_lock);
 	spin_unlock(&sbi->fs_lock);
 follow:
 	/*
@@ -476,7 +476,7 @@ static struct dentry *autofs4_lookup_exp
 	const unsigned char *str = name->name;
 	struct list_head *p, *head;
 
-	spin_lock(&dcache_lock);
+	spin_lock(&autofs4_lock);
 	spin_lock(&sbi->lookup_lock);
 	head = &sbi->expiring_list;
 	list_for_each(p, head) {
Index: linux-2.6/fs/autofs4/waitq.c
===================================================================
--- linux-2.6.orig/fs/autofs4/waitq.c
+++ linux-2.6/fs/autofs4/waitq.c
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
@@ -217,7 +218,7 @@ rename_retry:
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
--- linux-2.6.orig/drivers/infiniband/hw/qib/qib_fs.c
+++ linux-2.6/drivers/infiniband/hw/qib/qib_fs.c
@@ -451,17 +451,14 @@ static int remove_file(struct dentry *pa
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
--- linux-2.6.orig/fs/ceph/dir.c
+++ linux-2.6/fs/ceph/dir.c
@@ -111,7 +111,6 @@ static int __dcache_readdir(struct file
 	dout("__dcache_readdir %p at %llu (last %p)\n", dir, filp->f_pos,
 	     last);
 
-	spin_lock(&dcache_lock);
 	spin_lock(&parent->d_lock);
 
 	/* start at beginning? */
@@ -155,7 +154,6 @@ more:
 	dget_dlock(dentry);
 	spin_unlock(&dentry->d_lock);
 	spin_unlock(&parent->d_lock);
-	spin_unlock(&dcache_lock);
 	spin_unlock(&inode->i_lock);
 
 	dout(" %llu (%llu) dentry %p %.*s %p\n", di->offset, filp->f_pos,
@@ -178,7 +176,6 @@ more:
 	}
 
 	spin_lock(&inode->i_lock);
-	spin_lock(&dcache_lock);
 	spin_lock(&parent->d_lock);
 
 	last = dentry;
@@ -189,7 +186,7 @@ more:
 	p = p->prev;
 	filp->f_pos++;
 
-	/* make sure a dentry wasn't dropped while we didn't have dcache_lock */
+	/* make sure a dentry wasn't dropped while we didn't have parent->d_lock */
 	if ((ceph_inode(dir)->i_ceph_flags & CEPH_I_COMPLETE))
 		goto more;
 	dout(" lost I_COMPLETE on %p; falling back to mds\n", dir);
@@ -197,7 +194,6 @@ more:
 
 out_unlock:
 	spin_unlock(&parent->d_lock);
-	spin_unlock(&dcache_lock);
 
 	if (last) {
 		spin_unlock(&inode->i_lock);
Index: linux-2.6/fs/ceph/inode.c
===================================================================
--- linux-2.6.orig/fs/ceph/inode.c
+++ linux-2.6/fs/ceph/inode.c
@@ -825,7 +825,6 @@ static void ceph_set_dentry_offset(struc
 	di->offset = ceph_inode(inode)->i_max_offset++;
 	spin_unlock(&inode->i_lock);
 
-	spin_lock(&dcache_lock);
 	spin_lock(&dir->d_lock);
 	spin_lock_nested(&dn->d_lock, DENTRY_D_LOCK_NESTED);
 	list_move(&dn->d_u.d_child, &dir->d_subdirs);
@@ -833,7 +832,6 @@ static void ceph_set_dentry_offset(struc
 	     dn->d_u.d_child.prev, dn->d_u.d_child.next);
 	spin_unlock(&dn->d_lock);
 	spin_unlock(&dir->d_lock);
-	spin_unlock(&dcache_lock);
 }
 
 /*
@@ -1213,13 +1211,11 @@ retry_lookup:
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


