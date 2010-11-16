Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933415Ab0KPO15 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 09:27:57 -0500
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:20700 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933311Ab0KPO1m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 09:27:42 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AiQJAKMh4kx5Ldur/2dsb2JhbACVYYx9cr5mhUsEilg
Message-Id: <20101116142029.528762151@kernel.dk>
User-Agent: quilt/0.48-1
Date: Wed, 17 Nov 2010 01:09:14 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [patch 14/28] fs: dcache scale subdirs
References: <20101116140900.039761100@kernel.dk>
Content-Disposition: inline; filename=fs-dcache-scale-d_subdirs.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Protect d_subdirs and d_child with d_lock, except in filesystems that aren't
using dcache_lock for these anyway (eg. using i_mutex).

Note: if we change the locking rule in future so that ->d_child protection is
provided only with ->d_parent->d_lock, it may allow us to reduce some locking.
But it would be an exception to an otherwise regular locking scheme, so we'd
have to see some good results. Probably not worthwhile.

Signed-off-by: Nick Piggin <npiggin@kernel.dk>

---
 drivers/staging/smbfs/cache.c |    4 
 drivers/usb/core/inode.c      |    8 +
 fs/autofs4/autofs_i.h         |   11 ++
 fs/autofs4/expire.c           |  129 +++++++++++++--------------
 fs/autofs4/root.c             |   18 +++
 fs/ceph/dir.c                 |    6 +
 fs/ceph/inode.c               |    8 +
 fs/coda/cache.c               |    2 
 fs/dcache.c                   |  195 +++++++++++++++++++++++++++++++-----------
 fs/libfs.c                    |   24 +++--
 fs/ncpfs/dir.c                |    3 
 fs/ncpfs/ncplib_kernel.h      |    4 
 fs/notify/fsnotify.c          |    4 
 include/linux/dcache.h        |    1 
 kernel/cgroup.c               |   19 +++-
 security/selinux/selinuxfs.c  |   12 ++
 16 files changed, 314 insertions(+), 134 deletions(-)

Index: linux-2.6/fs/dcache.c
===================================================================
--- linux-2.6.orig/fs/dcache.c	2010-11-17 00:52:37.000000000 +1100
+++ linux-2.6/fs/dcache.c	2010-11-17 01:05:44.000000000 +1100
@@ -47,6 +47,8 @@
  *   - d_lru
  *   - d_count
  *   - d_unhashed()
+ *   - d_parent and d_subdirs
+ *   - childrens' d_child and d_parent
  *
  * Ordering:
  * dcache_lock
@@ -217,24 +219,22 @@ static void dentry_lru_move_tail(struct
  *
  * If this is the root of the dentry tree, return NULL.
  *
- * dcache_lock and d_lock must be held by caller, are dropped by d_kill.
+ * dcache_lock and d_lock and d_parent->d_lock must be held by caller, and
+ * are dropped by d_kill.
  */
-static struct dentry *d_kill(struct dentry *dentry)
+static struct dentry *d_kill(struct dentry *dentry, struct dentry *parent)
 	__releases(dentry->d_lock)
+	__releases(parent->d_lock)
 	__releases(dcache_lock)
 {
-	struct dentry *parent;
-
 	list_del(&dentry->d_u.d_child);
+	if (parent)
+		spin_unlock(&parent->d_lock);
 	dentry_iput(dentry);
 	/*
 	 * dentry_iput drops the locks, at which point nobody (except
 	 * transient RCU lookups) can reach this dentry.
 	 */
-	if (IS_ROOT(dentry))
-		parent = NULL;
-	else
-		parent = dentry->d_parent;
 	d_free(dentry);
 	return parent;
 }
@@ -270,6 +270,7 @@ static struct dentry *d_kill(struct dent
 
 void dput(struct dentry *dentry)
 {
+	struct dentry *parent;
 	if (!dentry)
 		return;
 
@@ -277,6 +278,10 @@ void dput(struct dentry *dentry)
 	if (dentry->d_count == 1)
 		might_sleep();
 	spin_lock(&dentry->d_lock);
+	if (IS_ROOT(dentry))
+		parent = NULL;
+	else
+		parent = dentry->d_parent;
 	if (dentry->d_count == 1) {
 		if (!spin_trylock(&dcache_lock)) {
 			/*
@@ -288,10 +293,17 @@ void dput(struct dentry *dentry)
 			spin_unlock(&dentry->d_lock);
 			goto repeat;
 		}
+		if (parent && !spin_trylock(&parent->d_lock)) {
+			spin_unlock(&dentry->d_lock);
+			spin_unlock(&dcache_lock);
+			goto repeat;
+		}
 	}
 	dentry->d_count--;
 	if (dentry->d_count) {
 		spin_unlock(&dentry->d_lock);
+		if (parent)
+			spin_unlock(&parent->d_lock);
 		spin_unlock(&dcache_lock);
 		return;
 	}
@@ -313,6 +325,8 @@ void dput(struct dentry *dentry)
 	dentry_lru_add(dentry);
 
  	spin_unlock(&dentry->d_lock);
+	if (parent)
+		spin_unlock(&parent->d_lock);
 	spin_unlock(&dcache_lock);
 	return;
 
@@ -321,7 +335,7 @@ void dput(struct dentry *dentry)
 kill_it:
 	/* if dentry was on the d_lru list delete it from there */
 	dentry_lru_del(dentry);
-	dentry = d_kill(dentry);
+	dentry = d_kill(dentry, parent);
 	if (dentry)
 		goto repeat;
 }
@@ -547,12 +561,13 @@ EXPORT_SYMBOL(d_prune_aliases);
  * quadratic behavior of shrink_dcache_parent(), but is also expected
  * to be beneficial in reducing dentry cache fragmentation.
  */
-static void prune_one_dentry(struct dentry * dentry)
+static void prune_one_dentry(struct dentry *dentry, struct dentry *parent)
 	__releases(dentry->d_lock)
+	__releases(parent->d_lock)
 	__releases(dcache_lock)
 {
 	__d_drop(dentry);
-	dentry = d_kill(dentry);
+	dentry = d_kill(dentry, parent);
 
 	/*
 	 * Prune ancestors.  Locking is simpler than in dput(),
@@ -560,9 +575,20 @@ static void prune_one_dentry(struct dent
 	 */
 	while (dentry) {
 		spin_lock(&dcache_lock);
+again:
 		spin_lock(&dentry->d_lock);
+		if (IS_ROOT(dentry))
+			parent = NULL;
+		else
+			parent = dentry->d_parent;
+		if (parent && !spin_trylock(&parent->d_lock)) {
+			spin_unlock(&dentry->d_lock);
+			goto again;
+		}
 		dentry->d_count--;
 		if (dentry->d_count) {
+			if (parent)
+				spin_unlock(&parent->d_lock);
 			spin_unlock(&dentry->d_lock);
 			spin_unlock(&dcache_lock);
 			return;
@@ -570,7 +596,7 @@ static void prune_one_dentry(struct dent
 
 		dentry_lru_del(dentry);
 		__d_drop(dentry);
-		dentry = d_kill(dentry);
+		dentry = d_kill(dentry, parent);
 	}
 }
 
@@ -579,29 +605,40 @@ static void shrink_dentry_list(struct li
 	struct dentry *dentry;
 
 	while (!list_empty(list)) {
+		struct dentry *parent;
+
 		dentry = list_entry(list->prev, struct dentry, d_lru);
 
 		if (!spin_trylock(&dentry->d_lock)) {
+relock:
 			spin_unlock(&dcache_lru_lock);
 			cpu_relax();
 			spin_lock(&dcache_lru_lock);
 			continue;
 		}
 
-		__dentry_lru_del(dentry);
-
 		/*
 		 * We found an inuse dentry which was not removed from
 		 * the LRU because of laziness during lookup.  Do not free
 		 * it - just keep it off the LRU list.
 		 */
 		if (dentry->d_count) {
+			__dentry_lru_del(dentry);
 			spin_unlock(&dentry->d_lock);
 			continue;
 		}
+		if (IS_ROOT(dentry))
+			parent = NULL;
+		else
+			parent = dentry->d_parent;
+		if (parent && !spin_trylock(&parent->d_lock)) {
+			spin_unlock(&dentry->d_lock);
+			goto relock;
+		}
+		__dentry_lru_del(dentry);
 		spin_unlock(&dcache_lru_lock);
 
-		prune_one_dentry(dentry);
+		prune_one_dentry(dentry, parent);
 		/* dcache_lock and dentry->d_lock dropped */
 		spin_lock(&dcache_lock);
 		spin_lock(&dcache_lru_lock);
@@ -796,14 +833,16 @@ static void shrink_dcache_for_umount_sub
 			/* this is a branch with children - detach all of them
 			 * from the system in one go */
 			spin_lock(&dcache_lock);
+			spin_lock(&dentry->d_lock);
 			list_for_each_entry(loop, &dentry->d_subdirs,
 					    d_u.d_child) {
-				spin_lock(&loop->d_lock);
+				spin_lock_nested(&loop->d_lock,
+						DENTRY_D_LOCK_NESTED);
 				dentry_lru_del(loop);
 				__d_drop(loop);
 				spin_unlock(&loop->d_lock);
-				cond_resched_lock(&dcache_lock);
 			}
+			spin_unlock(&dentry->d_lock);
 			spin_unlock(&dcache_lock);
 
 			/* move to the first child */
@@ -831,16 +870,17 @@ static void shrink_dcache_for_umount_sub
 				BUG();
 			}
 
-			if (IS_ROOT(dentry))
+			if (IS_ROOT(dentry)) {
 				parent = NULL;
-			else {
+				list_del(&dentry->d_u.d_child);
+			} else {
 				parent = dentry->d_parent;
 				spin_lock(&parent->d_lock);
 				parent->d_count--;
+				list_del(&dentry->d_u.d_child);
 				spin_unlock(&parent->d_lock);
 			}
 
-			list_del(&dentry->d_u.d_child);
 			detached++;
 
 			inode = dentry->d_inode;
@@ -921,6 +961,7 @@ int have_submounts(struct dentry *parent
 	spin_lock(&dcache_lock);
 	if (d_mountpoint(parent))
 		goto positive;
+	spin_lock(&this_parent->d_lock);
 repeat:
 	next = this_parent->d_subdirs.next;
 resume:
@@ -928,22 +969,34 @@ int have_submounts(struct dentry *parent
 		struct list_head *tmp = next;
 		struct dentry *dentry = list_entry(tmp, struct dentry, d_u.d_child);
 		next = tmp->next;
+
+		spin_lock_nested(&dentry->d_lock, DENTRY_D_LOCK_NESTED);
 		/* Have we found a mount point ? */
-		if (d_mountpoint(dentry))
+		if (d_mountpoint(dentry)) {
+			spin_unlock(&dentry->d_lock);
+			spin_unlock(&this_parent->d_lock);
 			goto positive;
+		}
 		if (!list_empty(&dentry->d_subdirs)) {
+			spin_unlock(&this_parent->d_lock);
+			spin_release(&dentry->d_lock.dep_map, 1, _RET_IP_);
 			this_parent = dentry;
+			spin_acquire(&this_parent->d_lock.dep_map, 0, 1, _RET_IP_);
 			goto repeat;
 		}
+		spin_unlock(&dentry->d_lock);
 	}
 	/*
 	 * All done at this level ... ascend and resume the search.
 	 */
 	if (this_parent != parent) {
 		next = this_parent->d_u.d_child.next;
+		spin_unlock(&this_parent->d_lock);
 		this_parent = this_parent->d_parent;
+		spin_lock(&this_parent->d_lock);
 		goto resume;
 	}
+	spin_unlock(&this_parent->d_lock);
 	spin_unlock(&dcache_lock);
 	return 0; /* No mount points found in tree */
 positive:
@@ -973,6 +1026,7 @@ static int select_parent(struct dentry *
 	int found = 0;
 
 	spin_lock(&dcache_lock);
+	spin_lock(&this_parent->d_lock);
 repeat:
 	next = this_parent->d_subdirs.next;
 resume:
@@ -980,8 +1034,9 @@ static int select_parent(struct dentry *
 		struct list_head *tmp = next;
 		struct dentry *dentry = list_entry(tmp, struct dentry, d_u.d_child);
 		next = tmp->next;
+		BUG_ON(this_parent == dentry);
 
-		spin_lock(&dentry->d_lock);
+		spin_lock_nested(&dentry->d_lock, DENTRY_D_LOCK_NESTED);
 
 		/* 
 		 * move only zero ref count dentries to the end 
@@ -994,33 +1049,44 @@ static int select_parent(struct dentry *
 			dentry_lru_del(dentry);
 		}
 
-		spin_unlock(&dentry->d_lock);
-
 		/*
 		 * We can return to the caller if we have found some (this
 		 * ensures forward progress). We'll be coming back to find
 		 * the rest.
 		 */
-		if (found && need_resched())
+		if (found && need_resched()) {
+			spin_unlock(&dentry->d_lock);
 			goto out;
+		}
 
 		/*
 		 * Descend a level if the d_subdirs list is non-empty.
 		 */
 		if (!list_empty(&dentry->d_subdirs)) {
+			spin_unlock(&this_parent->d_lock);
+			spin_release(&dentry->d_lock.dep_map, 1, _RET_IP_);
 			this_parent = dentry;
+			spin_acquire(&this_parent->d_lock.dep_map, 0, 1, _RET_IP_);
 			goto repeat;
 		}
+
+		spin_unlock(&dentry->d_lock);
 	}
 	/*
 	 * All done at this level ... ascend and resume the search.
 	 */
 	if (this_parent != parent) {
+		struct dentry *tmp;
 		next = this_parent->d_u.d_child.next;
-		this_parent = this_parent->d_parent;
+		tmp = this_parent->d_parent;
+		spin_unlock(&this_parent->d_lock);
+		BUG_ON(tmp == this_parent);
+		this_parent = tmp;
+		spin_lock(&this_parent->d_lock);
 		goto resume;
 	}
 out:
+	spin_unlock(&this_parent->d_lock);
 	spin_unlock(&dcache_lock);
 	return found;
 }
@@ -1121,18 +1187,19 @@ struct dentry *d_alloc(struct dentry * p
 	INIT_LIST_HEAD(&dentry->d_lru);
 	INIT_LIST_HEAD(&dentry->d_subdirs);
 	INIT_LIST_HEAD(&dentry->d_alias);
+	INIT_LIST_HEAD(&dentry->d_u.d_child);
 
 	if (parent) {
-		dentry->d_parent = dget(parent);
+		spin_lock(&dcache_lock);
+		spin_lock(&parent->d_lock);
+		spin_lock_nested(&dentry->d_lock, DENTRY_D_LOCK_NESTED);
+		dentry->d_parent = dget_dlock(parent);
 		dentry->d_sb = parent->d_sb;
-	} else {
-		INIT_LIST_HEAD(&dentry->d_u.d_child);
-	}
-
-	spin_lock(&dcache_lock);
-	if (parent)
 		list_add(&dentry->d_u.d_child, &parent->d_subdirs);
-	spin_unlock(&dcache_lock);
+		spin_unlock(&dentry->d_lock);
+		spin_unlock(&parent->d_lock);
+		spin_unlock(&dcache_lock);
+	}
 
 	percpu_counter_inc(&nr_dentry);
 
@@ -1650,13 +1717,18 @@ int d_validate(struct dentry *dentry, st
 	struct dentry *child;
 
 	spin_lock(&dcache_lock);
+	spin_lock(&dparent->d_lock);
 	list_for_each_entry(child, &dparent->d_subdirs, d_u.d_child) {
 		if (dentry == child) {
-			__dget_locked(dentry);
+			spin_lock_nested(&dentry->d_lock, DENTRY_D_LOCK_NESTED);
+			__dget_locked_dlock(dentry);
+			spin_unlock(&dentry->d_lock);
+			spin_unlock(&dparent->d_lock);
 			spin_unlock(&dcache_lock);
 			return 1;
 		}
 	}
+	spin_unlock(&dparent->d_lock);
 	spin_unlock(&dcache_lock);
 
 	return 0;
@@ -1822,15 +1894,26 @@ static void d_move_locked(struct dentry
 	/*
 	 * XXXX: do we really need to take target->d_lock?
 	 */
-	if (d_ancestor(dentry, target)) {
-		spin_lock(&dentry->d_lock);
-		spin_lock_nested(&target->d_lock, DENTRY_D_LOCK_NESTED);
-	} else if (d_ancestor(target, dentry) || target < dentry) {
-		spin_lock(&target->d_lock);
-		spin_lock_nested(&dentry->d_lock, DENTRY_D_LOCK_NESTED);
-	} else {
-		spin_lock(&dentry->d_lock);
-		spin_lock_nested(&target->d_lock, DENTRY_D_LOCK_NESTED);
+	BUG_ON(d_ancestor(dentry, target));
+	BUG_ON(d_ancestor(target, dentry));
+
+	if (IS_ROOT(dentry) || dentry->d_parent == target->d_parent)
+		spin_lock(&target->d_parent->d_lock);
+	else {
+		if (d_ancestor(dentry->d_parent, target->d_parent)) {
+			spin_lock(&dentry->d_parent->d_lock);
+			spin_lock_nested(&target->d_parent->d_lock, DENTRY_D_LOCK_NESTED);
+		} else {
+			spin_lock(&target->d_parent->d_lock);
+			spin_lock_nested(&dentry->d_parent->d_lock, DENTRY_D_LOCK_NESTED);
+		}
+	}
+	if (target < dentry) {
+		spin_lock_nested(&target->d_lock, 2);
+		spin_lock_nested(&dentry->d_lock, 3);
+ 	} else {
+		spin_lock_nested(&dentry->d_lock, 2);
+		spin_lock_nested(&target->d_lock, 3);
 	}
 
 	/* Move the dentry to the target hash queue, if on different bucket */
@@ -1863,6 +1946,10 @@ static void d_move_locked(struct dentry
 	}
 
 	list_add(&dentry->d_u.d_child, &dentry->d_parent->d_subdirs);
+	if (target->d_parent != dentry->d_parent)
+		spin_unlock(&dentry->d_parent->d_lock);
+	if (target->d_parent != target)
+		spin_unlock(&target->d_parent->d_lock);
 	spin_unlock(&target->d_lock);
 	fsnotify_d_move(dentry);
 	spin_unlock(&dentry->d_lock);
@@ -1963,6 +2050,13 @@ static void __d_materialise_dentry(struc
 	dparent = dentry->d_parent;
 	aparent = anon->d_parent;
 
+	/* XXX: hack */
+	/* returns with anon->d_lock held! */
+	spin_lock(&aparent->d_lock);
+	spin_lock(&dparent->d_lock);
+	spin_lock(&dentry->d_lock);
+	spin_lock(&anon->d_lock);
+
 	dentry->d_parent = (aparent == anon) ? dentry : aparent;
 	list_del(&dentry->d_u.d_child);
 	if (!IS_ROOT(dentry))
@@ -1977,6 +2071,10 @@ static void __d_materialise_dentry(struc
 	else
 		INIT_LIST_HEAD(&anon->d_u.d_child);
 
+	spin_unlock(&dentry->d_lock);
+	spin_unlock(&dparent->d_lock);
+	spin_unlock(&aparent->d_lock);
+
 	anon->d_flags &= ~DCACHE_DISCONNECTED;
 }
 
@@ -2012,7 +2110,6 @@ struct dentry *d_materialise_unique(stru
 			/* Is this an anonymous mountpoint that we could splice
 			 * into our tree? */
 			if (IS_ROOT(alias)) {
-				spin_lock(&alias->d_lock);
 				__d_materialise_dentry(dentry, alias);
 				__d_drop(alias);
 				goto found;
@@ -2497,6 +2594,7 @@ void d_genocide(struct dentry *root)
 	struct list_head *next;
 
 	spin_lock(&dcache_lock);
+	spin_lock(&this_parent->d_lock);
 repeat:
 	next = this_parent->d_subdirs.next;
 resume:
@@ -2510,8 +2608,10 @@ void d_genocide(struct dentry *root)
 			continue;
 		}
 		if (!list_empty(&dentry->d_subdirs)) {
-			spin_unlock(&dentry->d_lock);
+			spin_unlock(&this_parent->d_lock);
+			spin_release(&dentry->d_lock.dep_map, 1, _RET_IP_);
 			this_parent = dentry;
+			spin_acquire(&this_parent->d_lock.dep_map, 0, 1, _RET_IP_);
 			goto repeat;
 		}
  		dentry->d_count--;
@@ -2519,12 +2619,13 @@ void d_genocide(struct dentry *root)
 	}
 	if (this_parent != root) {
 		next = this_parent->d_u.d_child.next;
-		spin_lock(&this_parent->d_lock);
 		this_parent->d_count--;
 		spin_unlock(&this_parent->d_lock);
 		this_parent = this_parent->d_parent;
+		spin_lock(&this_parent->d_lock);
 		goto resume;
 	}
+	spin_unlock(&this_parent->d_lock);
 	spin_unlock(&dcache_lock);
 }
 
Index: linux-2.6/fs/libfs.c
===================================================================
--- linux-2.6.orig/fs/libfs.c	2010-11-17 00:52:37.000000000 +1100
+++ linux-2.6/fs/libfs.c	2010-11-17 01:05:42.000000000 +1100
@@ -81,7 +81,8 @@ int dcache_dir_close(struct inode *inode
 
 loff_t dcache_dir_lseek(struct file *file, loff_t offset, int origin)
 {
-	mutex_lock(&file->f_path.dentry->d_inode->i_mutex);
+	struct dentry *dentry = file->f_path.dentry;
+	mutex_lock(&dentry->d_inode->i_mutex);
 	switch (origin) {
 		case 1:
 			offset += file->f_pos;
@@ -89,7 +90,7 @@ loff_t dcache_dir_lseek(struct file *fil
 			if (offset >= 0)
 				break;
 		default:
-			mutex_unlock(&file->f_path.dentry->d_inode->i_mutex);
+			mutex_unlock(&dentry->d_inode->i_mutex);
 			return -EINVAL;
 	}
 	if (offset != file->f_pos) {
@@ -100,22 +101,25 @@ loff_t dcache_dir_lseek(struct file *fil
 			loff_t n = file->f_pos - 2;
 
 			spin_lock(&dcache_lock);
+			spin_lock(&dentry->d_lock);
+			/* d_lock not required for cursor */
 			list_del(&cursor->d_u.d_child);
-			p = file->f_path.dentry->d_subdirs.next;
-			while (n && p != &file->f_path.dentry->d_subdirs) {
+			p = dentry->d_subdirs.next;
+			while (n && p != &dentry->d_subdirs) {
 				struct dentry *next;
 				next = list_entry(p, struct dentry, d_u.d_child);
-				spin_lock(&next->d_lock);
+				spin_lock_nested(&next->d_lock, DENTRY_D_LOCK_NESTED);
 				if (simple_positive(next))
 					n--;
 				spin_unlock(&next->d_lock);
 				p = p->next;
 			}
 			list_add_tail(&cursor->d_u.d_child, p);
+			spin_unlock(&dentry->d_lock);
 			spin_unlock(&dcache_lock);
 		}
 	}
-	mutex_unlock(&file->f_path.dentry->d_inode->i_mutex);
+	mutex_unlock(&dentry->d_inode->i_mutex);
 	return offset;
 }
 
@@ -156,6 +160,7 @@ int dcache_readdir(struct file * filp, v
 			/* fallthrough */
 		default:
 			spin_lock(&dcache_lock);
+			spin_lock(&dentry->d_lock);
 			if (filp->f_pos == 2)
 				list_move(q, &dentry->d_subdirs);
 
@@ -169,6 +174,7 @@ int dcache_readdir(struct file * filp, v
 				}
 
 				spin_unlock(&next->d_lock);
+				spin_unlock(&dentry->d_lock);
 				spin_unlock(&dcache_lock);
 				if (filldir(dirent, next->d_name.name, 
 					    next->d_name.len, filp->f_pos, 
@@ -176,11 +182,15 @@ int dcache_readdir(struct file * filp, v
 					    dt_type(next->d_inode)) < 0)
 					return 0;
 				spin_lock(&dcache_lock);
+				spin_lock(&dentry->d_lock);
+				spin_lock_nested(&next->d_lock, DENTRY_D_LOCK_NESTED);
 				/* next is still alive */
 				list_move(q, p);
+				spin_unlock(&next->d_lock);
 				p = q;
 				filp->f_pos++;
 			}
+			spin_unlock(&dentry->d_lock);
 			spin_unlock(&dcache_lock);
 	}
 	return 0;
@@ -276,6 +286,7 @@ int simple_empty(struct dentry *dentry)
 	int ret = 0;
 
 	spin_lock(&dcache_lock);
+	spin_lock(&dentry->d_lock);
 	list_for_each_entry(child, &dentry->d_subdirs, d_u.d_child) {
 		spin_lock_nested(&child->d_lock, DENTRY_D_LOCK_NESTED);
 		if (simple_positive(child)) {
@@ -286,6 +297,7 @@ int simple_empty(struct dentry *dentry)
 	}
 	ret = 1;
 out:
+	spin_unlock(&dentry->d_lock);
 	spin_unlock(&dcache_lock);
 	return ret;
 }
Index: linux-2.6/include/linux/dcache.h
===================================================================
--- linux-2.6.orig/include/linux/dcache.h	2010-11-17 00:52:37.000000000 +1100
+++ linux-2.6/include/linux/dcache.h	2010-11-17 01:05:44.000000000 +1100
@@ -337,6 +337,7 @@ static inline struct dentry *dget_dlock(
 	}
 	return dentry;
 }
+
 static inline struct dentry *dget(struct dentry *dentry)
 {
 	if (dentry) {
Index: linux-2.6/drivers/usb/core/inode.c
===================================================================
--- linux-2.6.orig/drivers/usb/core/inode.c	2010-11-17 00:52:37.000000000 +1100
+++ linux-2.6/drivers/usb/core/inode.c	2010-11-17 01:05:42.000000000 +1100
@@ -345,18 +345,20 @@ static int usbfs_empty (struct dentry *d
 	struct list_head *list;
 
 	spin_lock(&dcache_lock);
-
+	spin_lock(&dentry->d_lock);
 	list_for_each(list, &dentry->d_subdirs) {
 		struct dentry *de = list_entry(list, struct dentry, d_u.d_child);
-		spin_lock(&de->d_lock);
+
+		spin_lock_nested(&de->d_lock, DENTRY_D_LOCK_NESTED);
 		if (usbfs_positive(de)) {
 			spin_unlock(&de->d_lock);
+			spin_unlock(&dentry->d_lock);
 			spin_unlock(&dcache_lock);
 			return 0;
 		}
 		spin_unlock(&de->d_lock);
 	}
-
+	spin_unlock(&dentry->d_lock);
 	spin_unlock(&dcache_lock);
 	return 1;
 }
Index: linux-2.6/fs/autofs4/expire.c
===================================================================
--- linux-2.6.orig/fs/autofs4/expire.c	2010-11-17 00:52:37.000000000 +1100
+++ linux-2.6/fs/autofs4/expire.c	2010-11-17 01:05:42.000000000 +1100
@@ -91,24 +91,64 @@ static int autofs4_mount_busy(struct vfs
 }
 
 /*
- * Calculate next entry in top down tree traversal.
- * From next_mnt in namespace.c - elegant.
+ * Calculate and dget next entry in top down tree traversal.
  */
-static struct dentry *next_dentry(struct dentry *p, struct dentry *root)
+static struct dentry *get_next_positive_dentry(struct dentry *prev,
+						struct dentry *root)
 {
-	struct list_head *next = p->d_subdirs.next;
+	struct list_head *next;
+	struct dentry *p, *ret;
+
+	if (prev == NULL)
+		return dget(prev);
 
+	spin_lock(&dcache_lock);
+relock:
+	p = prev;
+	spin_lock(&p->d_lock);
+again:
+	next = p->d_subdirs.next;
 	if (next == &p->d_subdirs) {
 		while (1) {
-			if (p == root)
+			struct dentry *parent;
+
+			if (p == root) {
+				spin_unlock(&p->d_lock);
+				spin_unlock(&dcache_lock);
+				dput(prev);
 				return NULL;
+			}
+
+			parent = p->d_parent;
+			if (!spin_trylock(&parent->d_lock)) {
+				spin_unlock(&p->d_lock);
+				cpu_relax();
+				goto relock;
+			}
+			spin_unlock(&p->d_lock);
 			next = p->d_u.d_child.next;
-			if (next != &p->d_parent->d_subdirs)
+			p = parent;
+			if (next != &parent->d_subdirs)
 				break;
-			p = p->d_parent;
 		}
 	}
-	return list_entry(next, struct dentry, d_u.d_child);
+	ret = list_entry(next, struct dentry, d_u.d_child);
+
+	spin_lock_nested(&ret->d_lock, DENTRY_D_LOCK_NESTED);
+	/* Negative dentry - try next */
+	if (!simple_positive(ret)) {
+		spin_unlock(&ret->d_lock);
+		p = ret;
+		goto again;
+	}
+	dget_dlock(ret);
+	spin_unlock(&ret->d_lock);
+	spin_unlock(&p->d_lock);
+	spin_unlock(&dcache_lock);
+
+	dput(prev);
+
+	return ret;
 }
 
 /*
@@ -158,22 +198,11 @@ static int autofs4_tree_busy(struct vfsm
 	if (!simple_positive(top))
 		return 1;
 
-	spin_lock(&dcache_lock);
-	for (p = top; p; p = next_dentry(p, top)) {
-		spin_lock(&p->d_lock);
-		/* Negative dentry - give up */
-		if (!simple_positive(p)) {
-			spin_unlock(&p->d_lock);
-			continue;
-		}
-
+	p = NULL;
+	while ((p = get_next_positive_dentry(p, top))) {
 		DPRINTK("dentry %p %.*s",
 			p, (int) p->d_name.len, p->d_name.name);
 
-		p = dget_dlock(p);
-		spin_unlock(&p->d_lock);
-		spin_unlock(&dcache_lock);
-
 		/*
 		 * Is someone visiting anywhere in the subtree ?
 		 * If there's no mount we need to check the usage
@@ -208,10 +237,7 @@ static int autofs4_tree_busy(struct vfsm
 				return 1;
 			}
 		}
-		dput(p);
-		spin_lock(&dcache_lock);
 	}
-	spin_unlock(&dcache_lock);
 
 	/* Timeout of a tree mount is ultimately determined by its top dentry */
 	if (!autofs4_can_expire(top, timeout, do_now))
@@ -230,36 +256,21 @@ static struct dentry *autofs4_check_leav
 	DPRINTK("parent %p %.*s",
 		parent, (int)parent->d_name.len, parent->d_name.name);
 
-	spin_lock(&dcache_lock);
-	for (p = parent; p; p = next_dentry(p, parent)) {
-		spin_lock(&p->d_lock);
-		/* Negative dentry - give up */
-		if (!simple_positive(p)) {
-			spin_unlock(&p->d_lock);
-			continue;
-		}
-
+	p = NULL;
+	while ((p = get_next_positive_dentry(p, parent))) {
 		DPRINTK("dentry %p %.*s",
 			p, (int) p->d_name.len, p->d_name.name);
 
-		p = dget_dlock(p);
-		spin_unlock(&p->d_lock);
-		spin_unlock(&dcache_lock);
-
 		if (d_mountpoint(p)) {
 			/* Can we umount this guy */
 			if (autofs4_mount_busy(mnt, p))
-				goto cont;
+				continue;
 
 			/* Can we expire this guy */
 			if (autofs4_can_expire(p, timeout, do_now))
 				return p;
 		}
-cont:
-		dput(p);
-		spin_lock(&dcache_lock);
 	}
-	spin_unlock(&dcache_lock);
 	return NULL;
 }
 
@@ -310,8 +321,8 @@ struct dentry *autofs4_expire_indirect(s
 {
 	unsigned long timeout;
 	struct dentry *root = sb->s_root;
+	struct dentry *dentry;
 	struct dentry *expired = NULL;
-	struct list_head *next;
 	int do_now = how & AUTOFS_EXP_IMMEDIATE;
 	int exp_leaves = how & AUTOFS_EXP_LEAVES;
 	struct autofs_info *ino;
@@ -323,26 +334,8 @@ struct dentry *autofs4_expire_indirect(s
 	now = jiffies;
 	timeout = sbi->exp_timeout;
 
-	spin_lock(&dcache_lock);
-	next = root->d_subdirs.next;
-
-	/* On exit from the loop expire is set to a dgot dentry
-	 * to expire or it's NULL */
-	while ( next != &root->d_subdirs ) {
-		struct dentry *dentry = list_entry(next, struct dentry, d_u.d_child);
-
-		/* Negative dentry - give up */
-		spin_lock(&dentry->d_lock);
-		if (!simple_positive(dentry)) {
-			next = next->next;
-			spin_unlock(&dentry->d_lock);
-			continue;
-		}
-
-		dentry = dget_dlock(dentry);
-		spin_unlock(&dentry->d_lock);
-		spin_unlock(&dcache_lock);
-
+	dentry = NULL;
+	while ((dentry = get_next_positive_dentry(dentry, root))) {
 		spin_lock(&sbi->fs_lock);
 		ino = autofs4_dentry_ino(dentry);
 
@@ -405,11 +398,7 @@ struct dentry *autofs4_expire_indirect(s
 		}
 next:
 		spin_unlock(&sbi->fs_lock);
-		dput(dentry);
-		spin_lock(&dcache_lock);
-		next = next->next;
 	}
-	spin_unlock(&dcache_lock);
 	return NULL;
 
 found:
@@ -420,7 +409,11 @@ struct dentry *autofs4_expire_indirect(s
 	init_completion(&ino->expire_complete);
 	spin_unlock(&sbi->fs_lock);
 	spin_lock(&dcache_lock);
-	list_move(&expired->d_parent->d_subdirs, &expired->d_u.d_child);
+	spin_lock(&expired->d_parent->d_lock);
+	spin_lock_nested(&expired->d_lock, DENTRY_D_LOCK_NESTED);
+  	list_move(&expired->d_parent->d_subdirs, &expired->d_u.d_child);
+	spin_unlock(&expired->d_lock);
+	spin_unlock(&expired->d_parent->d_lock);
 	spin_unlock(&dcache_lock);
 	return expired;
 }
Index: linux-2.6/fs/autofs4/root.c
===================================================================
--- linux-2.6.orig/fs/autofs4/root.c	2010-11-17 00:52:37.000000000 +1100
+++ linux-2.6/fs/autofs4/root.c	2010-11-17 01:05:42.000000000 +1100
@@ -143,10 +143,13 @@ static int autofs4_dir_open(struct inode
 	 * it.
 	 */
 	spin_lock(&dcache_lock);
+	spin_lock(&dentry->d_lock);
 	if (!d_mountpoint(dentry) && list_empty(&dentry->d_subdirs)) {
+		spin_unlock(&dentry->d_lock);
 		spin_unlock(&dcache_lock);
 		return -ENOENT;
 	}
+	spin_unlock(&dentry->d_lock);
 	spin_unlock(&dcache_lock);
 
 out:
@@ -253,7 +256,9 @@ static void *autofs4_follow_link(struct
 	lookup_type = autofs4_need_mount(nd->flags);
 	spin_lock(&sbi->fs_lock);
 	spin_lock(&dcache_lock);
+	spin_lock(&dentry->d_lock);
 	if (!(lookup_type || ino->flags & AUTOFS_INF_PENDING)) {
+		spin_unlock(&dentry->d_lock);
 		spin_unlock(&dcache_lock);
 		spin_unlock(&sbi->fs_lock);
 		goto follow;
@@ -266,6 +271,7 @@ static void *autofs4_follow_link(struct
 	 */
 	if (ino->flags & AUTOFS_INF_PENDING ||
 	    (!d_mountpoint(dentry) && list_empty(&dentry->d_subdirs))) {
+		spin_unlock(&dentry->d_lock);
 		spin_unlock(&dcache_lock);
 		spin_unlock(&sbi->fs_lock);
 
@@ -275,6 +281,7 @@ static void *autofs4_follow_link(struct
 
 		goto follow;
 	}
+	spin_unlock(&dentry->d_lock);
 	spin_unlock(&dcache_lock);
 	spin_unlock(&sbi->fs_lock);
 follow:
@@ -347,10 +354,12 @@ static int autofs4_revalidate(struct den
 
 	/* Check for a non-mountpoint directory with no contents */
 	spin_lock(&dcache_lock);
+	spin_lock(&dentry->d_lock);
 	if (S_ISDIR(dentry->d_inode->i_mode) &&
 	    !d_mountpoint(dentry) && list_empty(&dentry->d_subdirs)) {
 		DPRINTK("dentry=%p %.*s, emptydir",
 			 dentry, dentry->d_name.len, dentry->d_name.name);
+		spin_unlock(&dentry->d_lock);
 		spin_unlock(&dcache_lock);
 
 		/* The daemon never causes a mount to trigger */
@@ -367,6 +376,7 @@ static int autofs4_revalidate(struct den
 
 		return status;
 	}
+	spin_unlock(&dentry->d_lock);
 	spin_unlock(&dcache_lock);
 
 	return 1;
@@ -776,12 +786,16 @@ static int autofs4_dir_rmdir(struct inod
 		return -EACCES;
 
 	spin_lock(&dcache_lock);
+	spin_lock(&sbi->lookup_lock);
+	spin_lock(&dentry->d_lock);
 	if (!list_empty(&dentry->d_subdirs)) {
+		spin_unlock(&dentry->d_lock);
+		spin_unlock(&sbi->lookup_lock);
 		spin_unlock(&dcache_lock);
 		return -ENOTEMPTY;
 	}
-	autofs4_add_expiring(dentry);
-	spin_lock(&dentry->d_lock);
+	__autofs4_add_expiring(dentry);
+	spin_unlock(&sbi->lookup_lock);
 	__d_drop(dentry);
 	spin_unlock(&dentry->d_lock);
 	spin_unlock(&dcache_lock);
Index: linux-2.6/fs/coda/cache.c
===================================================================
--- linux-2.6.orig/fs/coda/cache.c	2010-11-17 00:50:50.000000000 +1100
+++ linux-2.6/fs/coda/cache.c	2010-11-17 01:05:42.000000000 +1100
@@ -94,6 +94,7 @@ static void coda_flag_children(struct de
 	struct dentry *de;
 
 	spin_lock(&dcache_lock);
+	spin_lock(&parent->d_lock);
 	list_for_each(child, &parent->d_subdirs)
 	{
 		de = list_entry(child, struct dentry, d_u.d_child);
@@ -102,6 +103,7 @@ static void coda_flag_children(struct de
 			continue;
 		coda_flag_inode(de->d_inode, flag);
 	}
+	spin_unlock(&parent->d_lock);
 	spin_unlock(&dcache_lock);
 	return; 
 }
Index: linux-2.6/fs/ncpfs/dir.c
===================================================================
--- linux-2.6.orig/fs/ncpfs/dir.c	2010-11-17 00:52:37.000000000 +1100
+++ linux-2.6/fs/ncpfs/dir.c	2010-11-17 01:05:42.000000000 +1100
@@ -395,6 +395,7 @@ ncp_dget_fpos(struct dentry *dentry, str
 
 	/* If a pointer is invalid, we search the dentry. */
 	spin_lock(&dcache_lock);
+	spin_lock(&parent->d_lock);
 	next = parent->d_subdirs.next;
 	while (next != &parent->d_subdirs) {
 		dent = list_entry(next, struct dentry, d_u.d_child);
@@ -403,11 +404,13 @@ ncp_dget_fpos(struct dentry *dentry, str
 				dget_locked(dent);
 			else
 				dent = NULL;
+			spin_unlock(&parent->d_lock);
 			spin_unlock(&dcache_lock);
 			goto out;
 		}
 		next = next->next;
 	}
+	spin_unlock(&parent->d_lock);
 	spin_unlock(&dcache_lock);
 	return NULL;
 
Index: linux-2.6/fs/ncpfs/ncplib_kernel.h
===================================================================
--- linux-2.6.orig/fs/ncpfs/ncplib_kernel.h	2010-11-17 00:52:37.000000000 +1100
+++ linux-2.6/fs/ncpfs/ncplib_kernel.h	2010-11-17 01:05:42.000000000 +1100
@@ -194,6 +194,7 @@ ncp_renew_dentries(struct dentry *parent
 	struct dentry *dentry;
 
 	spin_lock(&dcache_lock);
+	spin_lock(&parent->d_lock);
 	next = parent->d_subdirs.next;
 	while (next != &parent->d_subdirs) {
 		dentry = list_entry(next, struct dentry, d_u.d_child);
@@ -205,6 +206,7 @@ ncp_renew_dentries(struct dentry *parent
 
 		next = next->next;
 	}
+	spin_unlock(&parent->d_lock);
 	spin_unlock(&dcache_lock);
 }
 
@@ -216,6 +218,7 @@ ncp_invalidate_dircache_entries(struct d
 	struct dentry *dentry;
 
 	spin_lock(&dcache_lock);
+	spin_lock(&parent->d_lock);
 	next = parent->d_subdirs.next;
 	while (next != &parent->d_subdirs) {
 		dentry = list_entry(next, struct dentry, d_u.d_child);
@@ -223,6 +226,7 @@ ncp_invalidate_dircache_entries(struct d
 		ncp_age_dentry(server, dentry);
 		next = next->next;
 	}
+	spin_unlock(&parent->d_lock);
 	spin_unlock(&dcache_lock);
 }
 
Index: linux-2.6/kernel/cgroup.c
===================================================================
--- linux-2.6.orig/kernel/cgroup.c	2010-11-17 00:52:37.000000000 +1100
+++ linux-2.6/kernel/cgroup.c	2010-11-17 01:05:42.000000000 +1100
@@ -875,23 +875,31 @@ static void cgroup_clear_directory(struc
 
 	BUG_ON(!mutex_is_locked(&dentry->d_inode->i_mutex));
 	spin_lock(&dcache_lock);
+	spin_lock(&dentry->d_lock);
 	node = dentry->d_subdirs.next;
 	while (node != &dentry->d_subdirs) {
 		struct dentry *d = list_entry(node, struct dentry, d_u.d_child);
+
+		spin_lock_nested(&d->d_lock, DENTRY_D_LOCK_NESTED);
 		list_del_init(node);
 		if (d->d_inode) {
 			/* This should never be called on a cgroup
 			 * directory with child cgroups */
 			BUG_ON(d->d_inode->i_mode & S_IFDIR);
-			d = dget_locked(d);
+			dget_locked_dlock(d);
+			spin_unlock(&d->d_lock);
+			spin_unlock(&dentry->d_lock);
 			spin_unlock(&dcache_lock);
 			d_delete(d);
 			simple_unlink(dentry->d_inode, d);
 			dput(d);
 			spin_lock(&dcache_lock);
-		}
+			spin_lock(&dentry->d_lock);
+		} else
+			spin_unlock(&d->d_lock);
 		node = dentry->d_subdirs.next;
 	}
+	spin_unlock(&dentry->d_lock);
 	spin_unlock(&dcache_lock);
 }
 
@@ -900,10 +908,17 @@ static void cgroup_clear_directory(struc
  */
 static void cgroup_d_remove_dir(struct dentry *dentry)
 {
+	struct dentry *parent;
+
 	cgroup_clear_directory(dentry);
 
 	spin_lock(&dcache_lock);
+	parent = dentry->d_parent;
+	spin_lock(&parent->d_lock);
+	spin_lock(&dentry->d_lock);
 	list_del_init(&dentry->d_u.d_child);
+	spin_unlock(&dentry->d_lock);
+	spin_unlock(&parent->d_lock);
 	spin_unlock(&dcache_lock);
 	remove_dir(dentry);
 }
Index: linux-2.6/security/selinux/selinuxfs.c
===================================================================
--- linux-2.6.orig/security/selinux/selinuxfs.c	2010-11-17 00:50:50.000000000 +1100
+++ linux-2.6/security/selinux/selinuxfs.c	2010-11-17 01:05:42.000000000 +1100
@@ -1146,22 +1146,30 @@ static void sel_remove_entries(struct de
 	struct list_head *node;
 
 	spin_lock(&dcache_lock);
+	spin_lock(&de->d_lock);
 	node = de->d_subdirs.next;
 	while (node != &de->d_subdirs) {
 		struct dentry *d = list_entry(node, struct dentry, d_u.d_child);
+
+		spin_lock_nested(&d->d_lock, DENTRY_D_LOCK_NESTED);
 		list_del_init(node);
 
 		if (d->d_inode) {
-			d = dget_locked(d);
+			dget_locked_dlock(d);
+			spin_unlock(&de->d_lock);
+			spin_unlock(&d->d_lock);
 			spin_unlock(&dcache_lock);
 			d_delete(d);
 			simple_unlink(de->d_inode, d);
 			dput(d);
 			spin_lock(&dcache_lock);
-		}
+			spin_lock(&de->d_lock);
+		} else
+			spin_unlock(&d->d_lock);
 		node = de->d_subdirs.next;
 	}
 
+	spin_unlock(&de->d_lock);
 	spin_unlock(&dcache_lock);
 }
 
Index: linux-2.6/fs/notify/fsnotify.c
===================================================================
--- linux-2.6.orig/fs/notify/fsnotify.c	2010-11-17 00:50:50.000000000 +1100
+++ linux-2.6/fs/notify/fsnotify.c	2010-11-17 01:05:44.000000000 +1100
@@ -68,17 +68,19 @@ void __fsnotify_update_child_dentry_flag
 		/* run all of the children of the original inode and fix their
 		 * d_flags to indicate parental interest (their parent is the
 		 * original inode) */
+		spin_lock(&alias->d_lock);
 		list_for_each_entry(child, &alias->d_subdirs, d_u.d_child) {
 			if (!child->d_inode)
 				continue;
 
-			spin_lock(&child->d_lock);
+			spin_lock_nested(&child->d_lock, DENTRY_D_LOCK_NESTED);
 			if (watched)
 				child->d_flags |= DCACHE_FSNOTIFY_PARENT_WATCHED;
 			else
 				child->d_flags &= ~DCACHE_FSNOTIFY_PARENT_WATCHED;
 			spin_unlock(&child->d_lock);
 		}
+		spin_unlock(&alias->d_lock);
 	}
 	spin_unlock(&dcache_lock);
 }
Index: linux-2.6/fs/ceph/dir.c
===================================================================
--- linux-2.6.orig/fs/ceph/dir.c	2010-11-17 00:52:37.000000000 +1100
+++ linux-2.6/fs/ceph/dir.c	2010-11-17 01:05:42.000000000 +1100
@@ -112,6 +112,7 @@ static int __dcache_readdir(struct file
 	     last);
 
 	spin_lock(&dcache_lock);
+	spin_lock(&parent->d_lock);
 
 	/* start at beginning? */
 	if (filp->f_pos == 2 || (last &&
@@ -135,7 +136,7 @@ static int __dcache_readdir(struct file
 			fi->at_end = 1;
 			goto out_unlock;
 		}
-		spin_lock(&dentry->d_lock);
+		spin_lock_nested(&dentry->d_lock, DENTRY_D_LOCK_NESTED);
 		if (!d_unhashed(dentry) && dentry->d_inode &&
 		    ceph_snap(dentry->d_inode) != CEPH_SNAPDIR &&
 		    ceph_ino(dentry->d_inode) != CEPH_INO_CEPH &&
@@ -153,6 +154,7 @@ static int __dcache_readdir(struct file
 
 	dget_dlock(dentry);
 	spin_unlock(&dentry->d_lock);
+	spin_unlock(&parent->d_lock);
 	spin_unlock(&dcache_lock);
 
 	dout(" %llu (%llu) dentry %p %.*s %p\n", di->offset, filp->f_pos,
@@ -187,10 +189,12 @@ static int __dcache_readdir(struct file
 	}
 
 	spin_lock(&dcache_lock);
+	spin_lock(&parent->d_lock);
 	p = p->prev;	/* advance to next dentry */
 	goto more;
 
 out_unlock:
+	spin_unlock(&parent->d_lock);
 	spin_unlock(&dcache_lock);
 out:
 	if (last)
Index: linux-2.6/fs/ceph/inode.c
===================================================================
--- linux-2.6.orig/fs/ceph/inode.c	2010-11-17 00:52:37.000000000 +1100
+++ linux-2.6/fs/ceph/inode.c	2010-11-17 01:05:42.000000000 +1100
@@ -829,11 +829,13 @@ static void ceph_set_dentry_offset(struc
 	spin_unlock(&inode->i_lock);
 
 	spin_lock(&dcache_lock);
-	spin_lock(&dn->d_lock);
+	spin_lock(&dir->d_lock);
+	spin_lock_nested(&dn->d_lock, DENTRY_D_LOCK_NESTED);
 	list_move(&dn->d_u.d_child, &dir->d_subdirs);
 	dout("set_dentry_offset %p %lld (%p %p)\n", dn, di->offset,
 	     dn->d_u.d_child.prev, dn->d_u.d_child.next);
 	spin_unlock(&dn->d_lock);
+	spin_unlock(&dir->d_lock);
 	spin_unlock(&dcache_lock);
 }
 
@@ -1218,9 +1220,11 @@ int ceph_readdir_prepopulate(struct ceph
 		} else {
 			/* reorder parent's d_subdirs */
 			spin_lock(&dcache_lock);
-			spin_lock(&dn->d_lock);
+			spin_lock(&parent->d_lock);
+			spin_lock_nested(&dn->d_lock, DENTRY_D_LOCK_NESTED);
 			list_move(&dn->d_u.d_child, &parent->d_subdirs);
 			spin_unlock(&dn->d_lock);
+			spin_unlock(&parent->d_lock);
 			spin_unlock(&dcache_lock);
 		}
 
Index: linux-2.6/fs/autofs4/autofs_i.h
===================================================================
--- linux-2.6.orig/fs/autofs4/autofs_i.h	2010-11-17 00:52:37.000000000 +1100
+++ linux-2.6/fs/autofs4/autofs_i.h	2010-11-17 01:05:42.000000000 +1100
@@ -254,6 +254,17 @@ static inline int simple_positive(struct
 	return dentry->d_inode && !d_unhashed(dentry);
 }
 
+static inline void __autofs4_add_expiring(struct dentry *dentry)
+{
+	struct autofs_sb_info *sbi = autofs4_sbi(dentry->d_sb);
+	struct autofs_info *ino = autofs4_dentry_ino(dentry);
+	if (ino) {
+		if (list_empty(&ino->expiring))
+			list_add(&ino->expiring, &sbi->expiring_list);
+	}
+	return;
+}
+
 static inline void autofs4_add_expiring(struct dentry *dentry)
 {
 	struct autofs_sb_info *sbi = autofs4_sbi(dentry->d_sb);
Index: linux-2.6/drivers/staging/smbfs/cache.c
===================================================================
--- linux-2.6.orig/drivers/staging/smbfs/cache.c	2010-11-17 00:50:50.000000000 +1100
+++ linux-2.6/drivers/staging/smbfs/cache.c	2010-11-17 01:05:42.000000000 +1100
@@ -63,6 +63,7 @@ smb_invalidate_dircache_entries(struct d
 	struct dentry *dentry;
 
 	spin_lock(&dcache_lock);
+	spin_lock(&parent->d_lock);
 	next = parent->d_subdirs.next;
 	while (next != &parent->d_subdirs) {
 		dentry = list_entry(next, struct dentry, d_u.d_child);
@@ -70,6 +71,7 @@ smb_invalidate_dircache_entries(struct d
 		smb_age_dentry(server, dentry);
 		next = next->next;
 	}
+	spin_unlock(&parent->d_lock);
 	spin_unlock(&dcache_lock);
 }
 
@@ -97,6 +99,7 @@ smb_dget_fpos(struct dentry *dentry, str
 
 	/* If a pointer is invalid, we search the dentry. */
 	spin_lock(&dcache_lock);
+	spin_lock(&parent->d_lock);
 	next = parent->d_subdirs.next;
 	while (next != &parent->d_subdirs) {
 		dent = list_entry(next, struct dentry, d_u.d_child);
@@ -111,6 +114,7 @@ smb_dget_fpos(struct dentry *dentry, str
 	}
 	dent = NULL;
 out_unlock:
+	spin_unlock(&parent->d_lock);
 	spin_unlock(&dcache_lock);
 	return dent;
 }


