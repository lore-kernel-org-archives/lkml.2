Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754705Ab0FXDWw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 23:22:52 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36075 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754299Ab0FXDQG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 23:16:06 -0400
Message-Id: <20100624030727.818410048@suse.de>
User-Agent: quilt/0.48-4.4
Date: Thu, 24 Jun 2010 13:02:26 +1000
From: npiggin@suse.de
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: John Stultz <johnstul@us.ibm.com>, Frank Mayhar <fmayhar@google.com>
Subject: [patch 14/52] fs: dcache scale subdirs
References: <20100624030212.676457061@suse.de>
Content-Disposition: inline; filename=fs-dcache-scale-d_subdirs.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Protect d_subdirs and d_child with d_lock, except in filesystems that aren't
using dcache_lock for these anyway (eg. using i_mutex).

XXX: probably don't need parent lock in inotify (because child lock
should stabilize parent). Also, possibly some filesystems don't need so
much locking (eg. of child dentry when modifying d_child, so long as
parent is locked)... but be on the safe side. Hmm, maybe we should just
say d_child list is protected by d_parent->d_lock. d_parent could remain
protected with d_lock.

XXX: leave dcache_lock in there until remove dcache_lock patch

Signed-off-by: Nick Piggin <npiggin@suse.de>
---
 drivers/usb/core/inode.c     |    8 +-
 fs/autofs4/expire.c          |   87 +++++++++++++++-------
 fs/autofs4/root.c            |    6 +
 fs/ceph/dir.c                |    6 +
 fs/ceph/inode.c              |    8 +-
 fs/coda/cache.c              |    2 
 fs/dcache.c                  |  164 ++++++++++++++++++++++++++++++++++---------
 fs/libfs.c                   |   40 ++++++----
 fs/ncpfs/dir.c               |    3 
 fs/ncpfs/ncplib_kernel.h     |    4 +
 fs/notify/fsnotify.c         |    4 -
 fs/notify/inotify/inotify.c  |    4 -
 fs/smbfs/cache.c             |    4 +
 include/linux/dcache.h       |    1 
 kernel/cgroup.c              |   19 ++++
 security/selinux/selinuxfs.c |   12 ++-
 16 files changed, 283 insertions(+), 89 deletions(-)

Index: linux-2.6/fs/dcache.c
===================================================================
--- linux-2.6.orig/fs/dcache.c
+++ linux-2.6/fs/dcache.c
@@ -47,6 +47,8 @@
  *   - d_lru
  *   - d_count
  *   - d_unhashed()
+ *   - d_parent and d_subdirs
+ *   - childrens' d_child and d_parent
  *
  * Ordering:
  * dcache_lock
@@ -219,7 +221,8 @@ static void dentry_lru_del_init(struct d
  *
  * If this is the root of the dentry tree, return NULL.
  *
- * dcache_lock and d_lock must be held by caller, are dropped by d_kill.
+ * dcache_lock and d_lock and d_parent->d_lock must be held by caller, and
+ * are dropped by d_kill.
  */
 static struct dentry *d_kill(struct dentry *dentry)
 	__releases(dentry->d_lock)
@@ -228,12 +231,14 @@ static struct dentry *d_kill(struct dent
 	struct dentry *parent;
 
 	list_del(&dentry->d_u.d_child);
-	/*drops the locks, at that point nobody can reach this dentry */
-	dentry_iput(dentry);
+	if (dentry->d_parent && dentry != dentry->d_parent)
+		spin_unlock(&dentry->d_parent->d_lock);
 	if (IS_ROOT(dentry))
 		parent = NULL;
 	else
 		parent = dentry->d_parent;
+	/*drops the locks, at that point nobody can reach this dentry */
+	dentry_iput(dentry);
 	d_free(dentry);
 	return parent;
 }
@@ -269,6 +274,7 @@ static struct dentry *d_kill(struct dent
 
 void dput(struct dentry *dentry)
 {
+	struct dentry *parent = NULL;
 	if (!dentry)
 		return;
 
@@ -287,10 +293,20 @@ repeat:
 			spin_unlock(&dentry->d_lock);
 			goto repeat;
 		}
+		parent = dentry->d_parent;
+		if (parent && parent != dentry) {
+			if (!spin_trylock(&parent->d_lock)) {
+				spin_unlock(&dentry->d_lock);
+				spin_unlock(&dcache_lock);
+				goto repeat;
+			}
+		}
 	}
 	dentry->d_count--;
 	if (dentry->d_count) {
 		spin_unlock(&dentry->d_lock);
+		if (parent && parent != dentry)
+			spin_unlock(&parent->d_lock);
 		spin_unlock(&dcache_lock);
 		return;
 	}
@@ -310,6 +326,8 @@ repeat:
 		dentry_lru_add(dentry);
   	}
  	spin_unlock(&dentry->d_lock);
+	if (parent && parent != dentry)
+		spin_unlock(&parent->d_lock);
 	spin_unlock(&dcache_lock);
 	return;
 
@@ -545,10 +563,22 @@ static void prune_one_dentry(struct dent
 	 * because dcache_lock needs to be taken anyway.
 	 */
 	while (dentry) {
+		struct dentry *parent = NULL;
+
 		spin_lock(&dcache_lock);
+again:
 		spin_lock(&dentry->d_lock);
+		if (dentry->d_parent && dentry != dentry->d_parent) {
+			if (!spin_trylock(&dentry->d_parent->d_lock)) {
+				spin_unlock(&dentry->d_lock);
+				goto again;
+			}
+ 			parent = dentry->d_parent;
+		}
 		dentry->d_count--;
 		if (dentry->d_count) {
+			if (parent)
+				spin_unlock(&parent->d_lock);
 			spin_unlock(&dentry->d_lock);
 			spin_unlock(&dcache_lock);
 			return;
@@ -626,20 +656,27 @@ again:
 		dentry = list_entry(tmp.prev, struct dentry, d_lru);
 
 		if (!spin_trylock(&dentry->d_lock)) {
+again1:
 			spin_unlock(&dcache_lru_lock);
 			goto again;
 		}
-		__dentry_lru_del_init(dentry);
 		/*
 		 * We found an inuse dentry which was not removed from
 		 * the LRU because of laziness during lookup.  Do not free
 		 * it - just keep it off the LRU list.
 		 */
 		if (dentry->d_count) {
+			__dentry_lru_del_init(dentry);
 			spin_unlock(&dentry->d_lock);
 			continue;
 		}
-
+		if (dentry->d_parent && dentry->d_parent != dentry) {
+			if (!spin_trylock(&dentry->d_parent->d_lock)) {
+				spin_unlock(&dentry->d_lock);
+				goto again1;
+			}
+		}
+		__dentry_lru_del_init(dentry);
 		spin_unlock(&dcache_lru_lock);
 		prune_one_dentry(dentry);
 		/* dcache_lock and dentry->d_lock dropped */
@@ -776,14 +813,15 @@ static void shrink_dcache_for_umount_sub
 			/* this is a branch with children - detach all of them
 			 * from the system in one go */
 			spin_lock(&dcache_lock);
+			spin_lock(&dentry->d_lock);
 			list_for_each_entry(loop, &dentry->d_subdirs,
 					    d_u.d_child) {
-				spin_lock(&loop->d_lock);
+				spin_lock_nested(&loop->d_lock, DENTRY_D_LOCK_NESTED);
 				dentry_lru_del_init(loop);
 				__d_drop(loop);
 				spin_unlock(&loop->d_lock);
-				cond_resched_lock(&dcache_lock);
 			}
+			spin_unlock(&dentry->d_lock);
 			spin_unlock(&dcache_lock);
 
 			/* move to the first child */
@@ -811,16 +849,17 @@ static void shrink_dcache_for_umount_sub
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
@@ -905,6 +944,7 @@ int have_submounts(struct dentry *parent
 	spin_lock(&dcache_lock);
 	if (d_mountpoint(parent))
 		goto positive;
+	spin_lock(&this_parent->d_lock);
 repeat:
 	next = this_parent->d_subdirs.next;
 resume:
@@ -912,22 +952,34 @@ resume:
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
@@ -957,6 +1009,7 @@ static int select_parent(struct dentry *
 	int found = 0;
 
 	spin_lock(&dcache_lock);
+	spin_lock(&this_parent->d_lock);
 repeat:
 	next = this_parent->d_subdirs.next;
 resume:
@@ -964,8 +1017,9 @@ resume:
 		struct list_head *tmp = next;
 		struct dentry *dentry = list_entry(tmp, struct dentry, d_u.d_child);
 		next = tmp->next;
+		BUG_ON(this_parent == dentry);
 
-		spin_lock(&dentry->d_lock);
+		spin_lock_nested(&dentry->d_lock, DENTRY_D_LOCK_NESTED);
 		dentry_lru_del_init(dentry);
 		/* 
 		 * move only zero ref count dentries to the end 
@@ -975,33 +1029,45 @@ resume:
 			dentry_lru_add_tail(dentry);
 			found++;
 		}
-		spin_unlock(&dentry->d_lock);
 
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
@@ -1098,19 +1164,20 @@ struct dentry *d_alloc(struct dentry * p
 	INIT_LIST_HEAD(&dentry->d_lru);
 	INIT_LIST_HEAD(&dentry->d_subdirs);
 	INIT_LIST_HEAD(&dentry->d_alias);
-
-	if (parent) {
-		dentry->d_parent = dget(parent);
-		dentry->d_sb = parent->d_sb;
-	} else {
-		INIT_LIST_HEAD(&dentry->d_u.d_child);
-	}
+	INIT_LIST_HEAD(&dentry->d_u.d_child);
 
 	if (parent) {
 		spin_lock(&dcache_lock);
+		spin_lock(&parent->d_lock);
+		spin_lock_nested(&dentry->d_lock, DENTRY_D_LOCK_NESTED);
+		dentry->d_parent = dget_dlock(parent);
+		dentry->d_sb = parent->d_sb;
 		list_add(&dentry->d_u.d_child, &parent->d_subdirs);
+		spin_unlock(&dentry->d_lock);
+		spin_unlock(&parent->d_lock);
 		spin_unlock(&dcache_lock);
 	}
+
 	atomic_inc(&dentry_stat.nr_dentry);
 
 	return dentry;
@@ -1802,15 +1869,26 @@ static void d_move_locked(struct dentry
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
+	if (dentry->d_parent == target->d_parent)
+		spin_lock(&dentry->d_parent->d_lock);
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
@@ -1843,6 +1921,10 @@ static void d_move_locked(struct dentry
 	}
 
 	list_add(&dentry->d_u.d_child, &dentry->d_parent->d_subdirs);
+	if (target->d_parent != dentry->d_parent)
+		spin_unlock(&dentry->d_parent->d_lock);
+	if (target->d_parent != target)
+		spin_unlock(&target->d_parent->d_lock);
 	spin_unlock(&target->d_lock);
 	fsnotify_d_move(dentry);
 	spin_unlock(&dentry->d_lock);
@@ -1943,6 +2025,13 @@ static void __d_materialise_dentry(struc
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
@@ -1957,6 +2046,10 @@ static void __d_materialise_dentry(struc
 	else
 		INIT_LIST_HEAD(&anon->d_u.d_child);
 
+	spin_unlock(&dentry->d_lock);
+	spin_unlock(&dparent->d_lock);
+	spin_unlock(&aparent->d_lock);
+
 	anon->d_flags &= ~DCACHE_DISCONNECTED;
 }
 
@@ -1992,7 +2085,6 @@ struct dentry *d_materialise_unique(stru
 			/* Is this an anonymous mountpoint that we could splice
 			 * into our tree? */
 			if (IS_ROOT(alias)) {
-				spin_lock(&alias->d_lock);
 				__d_materialise_dentry(dentry, alias);
 				__d_drop(alias);
 				goto found;
@@ -2396,6 +2488,7 @@ void d_genocide(struct dentry *root)
 	struct list_head *next;
 
 	spin_lock(&dcache_lock);
+	spin_lock(&this_parent->d_lock);
 repeat:
 	next = this_parent->d_subdirs.next;
 resume:
@@ -2409,8 +2502,10 @@ resume:
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
@@ -2418,12 +2513,13 @@ resume:
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
--- linux-2.6.orig/fs/libfs.c
+++ linux-2.6/fs/libfs.c
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
@@ -99,23 +100,27 @@ loff_t dcache_dir_lseek(struct file *fil
 			struct dentry *cursor = file->private_data;
 			loff_t n = file->f_pos - 2;
 
-			spin_lock(&dcache_lock);
+			spin_lock(&dentry->d_lock);
+			spin_lock_nested(&cursor->d_lock, DENTRY_D_LOCK_NESTED);
 			list_del(&cursor->d_u.d_child);
-			p = file->f_path.dentry->d_subdirs.next;
-			while (n && p != &file->f_path.dentry->d_subdirs) {
+			spin_unlock(&cursor->d_lock);
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
+			spin_lock_nested(&cursor->d_lock, DENTRY_D_LOCK_NESTED);
 			list_add_tail(&cursor->d_u.d_child, p);
-			spin_unlock(&dcache_lock);
+			spin_unlock(&cursor->d_lock);
+			spin_unlock(&dentry->d_lock);
 		}
 	}
-	mutex_unlock(&file->f_path.dentry->d_inode->i_mutex);
+	mutex_unlock(&dentry->d_inode->i_mutex);
 	return offset;
 }
 
@@ -155,9 +160,12 @@ int dcache_readdir(struct file * filp, v
 			i++;
 			/* fallthrough */
 		default:
-			spin_lock(&dcache_lock);
-			if (filp->f_pos == 2)
+			spin_lock(&dentry->d_lock);
+			if (filp->f_pos == 2) {
+				spin_lock_nested(&cursor->d_lock, DENTRY_D_LOCK_NESTED);
 				list_move(q, &dentry->d_subdirs);
+				spin_unlock(&cursor->d_lock);
+			}
 
 			for (p=q->next; p != &dentry->d_subdirs; p=p->next) {
 				struct dentry *next;
@@ -169,19 +177,21 @@ int dcache_readdir(struct file * filp, v
 				}
 
 				spin_unlock(&next->d_lock);
-				spin_unlock(&dcache_lock);
+				spin_unlock(&dentry->d_lock);
 				if (filldir(dirent, next->d_name.name, 
 					    next->d_name.len, filp->f_pos, 
 					    next->d_inode->i_ino, 
 					    dt_type(next->d_inode)) < 0)
 					return 0;
-				spin_lock(&dcache_lock);
+				spin_lock(&dentry->d_lock);
+				spin_lock_nested(&next->d_lock, DENTRY_D_LOCK_NESTED);
 				/* next is still alive */
 				list_move(q, p);
+				spin_unlock(&next->d_lock);
 				p = q;
 				filp->f_pos++;
 			}
-			spin_unlock(&dcache_lock);
+			spin_unlock(&dentry->d_lock);
 	}
 	return 0;
 }
@@ -278,7 +288,7 @@ int simple_empty(struct dentry *dentry)
 	struct dentry *child;
 	int ret = 0;
 
-	spin_lock(&dcache_lock);
+	spin_lock(&dentry->d_lock);
 	list_for_each_entry(child, &dentry->d_subdirs, d_u.d_child) {
 		spin_lock_nested(&child->d_lock, DENTRY_D_LOCK_NESTED);
 		if (simple_positive(child)) {
@@ -289,7 +299,7 @@ int simple_empty(struct dentry *dentry)
 	}
 	ret = 1;
 out:
-	spin_unlock(&dcache_lock);
+	spin_unlock(&dentry->d_lock);
 	return ret;
 }
 
Index: linux-2.6/fs/notify/inotify/inotify.c
===================================================================
--- linux-2.6.orig/fs/notify/inotify/inotify.c
+++ linux-2.6/fs/notify/inotify/inotify.c
@@ -185,17 +185,19 @@ static void set_dentry_child_flags(struc
 	list_for_each_entry(alias, &inode->i_dentry, d_alias) {
 		struct dentry *child;
 
+		spin_lock(&alias->d_lock);
 		list_for_each_entry(child, &alias->d_subdirs, d_u.d_child) {
 			if (!child->d_inode)
 				continue;
 
-			spin_lock(&child->d_lock);
+			spin_lock_nested(&child->d_lock, DENTRY_D_LOCK_NESTED);
 			if (watched)
 				child->d_flags |= DCACHE_INOTIFY_PARENT_WATCHED;
 			else
 				child->d_flags &=~DCACHE_INOTIFY_PARENT_WATCHED;
 			spin_unlock(&child->d_lock);
 		}
+		spin_unlock(&alias->d_lock);
 	}
 	spin_unlock(&dcache_lock);
 }
Index: linux-2.6/include/linux/dcache.h
===================================================================
--- linux-2.6.orig/include/linux/dcache.h
+++ linux-2.6/include/linux/dcache.h
@@ -342,6 +342,7 @@ static inline struct dentry *dget_dlock(
 	}
 	return dentry;
 }
+
 static inline struct dentry *dget(struct dentry *dentry)
 {
 	if (dentry) {
Index: linux-2.6/drivers/usb/core/inode.c
===================================================================
--- linux-2.6.orig/drivers/usb/core/inode.c
+++ linux-2.6/drivers/usb/core/inode.c
@@ -348,18 +348,20 @@ static int usbfs_empty (struct dentry *d
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
--- linux-2.6.orig/fs/autofs4/expire.c
+++ linux-2.6/fs/autofs4/expire.c
@@ -93,22 +93,59 @@ done:
 /*
  * Calculate next entry in top down tree traversal.
  * From next_mnt in namespace.c - elegant.
+ *
+ * How is this supposed to work if we drop dcache_lock between calls anyway?
+ * How does it cope with renames?
+ * And also callers dput the returned dentry before taking dcache_lock again
+ * so what prevents it from being freed??
  */
-static struct dentry *next_dentry(struct dentry *p, struct dentry *root)
+static struct dentry *get_next_positive_dentry(struct dentry *p,
+						struct dentry *root)
 {
-	struct list_head *next = p->d_subdirs.next;
+	struct list_head *next;
+	struct dentry *ret;
 
+	spin_lock(&dcache_lock);
+again:
+	spin_lock(&p->d_lock);
+	next = p->d_subdirs.next;
 	if (next == &p->d_subdirs) {
 		while (1) {
-			if (p == root)
+			struct dentry *parent;
+
+			if (p == root) {
+				spin_unlock(&p->d_lock);
+				spin_unlock(&dcache_lock);
 				return NULL;
+			}
+
+			parent = p->d_parent;
+			if (!spin_trylock(&parent->d_lock)) {
+				spin_unlock(&p->d_lock);
+				goto again;
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
+	return ret;
 }
 
 /*
@@ -158,18 +195,11 @@ static int autofs4_tree_busy(struct vfsm
 	if (!simple_positive(top))
 		return 1;
 
-	spin_lock(&dcache_lock);
-	for (p = top; p; p = next_dentry(p, top)) {
-		/* Negative dentry - give up */
-		if (!simple_positive(p))
-			continue;
+	for (p = dget(top); p; p = get_next_positive_dentry(p, top)) {
 
 		DPRINTK("dentry %p %.*s",
 			p, (int) p->d_name.len, p->d_name.name);
 
-		p = dget(p);
-		spin_unlock(&dcache_lock);
-
 		/*
 		 * Is someone visiting anywhere in the subtree ?
 		 * If there's no mount we need to check the usage
@@ -205,9 +235,7 @@ static int autofs4_tree_busy(struct vfsm
 			}
 		}
 		dput(p);
-		spin_lock(&dcache_lock);
 	}
-	spin_unlock(&dcache_lock);
 
 	/* Timeout of a tree mount is ultimately determined by its top dentry */
 	if (!autofs4_can_expire(top, timeout, do_now))
@@ -226,18 +254,11 @@ static struct dentry *autofs4_check_leav
 	DPRINTK("parent %p %.*s",
 		parent, (int)parent->d_name.len, parent->d_name.name);
 
-	spin_lock(&dcache_lock);
-	for (p = parent; p; p = next_dentry(p, parent)) {
-		/* Negative dentry - give up */
-		if (!simple_positive(p))
-			continue;
+	for (p = dget(parent); p; p = get_next_positive_dentry(p, parent)) {
 
 		DPRINTK("dentry %p %.*s",
 			p, (int) p->d_name.len, p->d_name.name);
 
-		p = dget(p);
-		spin_unlock(&dcache_lock);
-
 		if (d_mountpoint(p)) {
 			/* Can we umount this guy */
 			if (autofs4_mount_busy(mnt, p))
@@ -249,9 +270,7 @@ static struct dentry *autofs4_check_leav
 		}
 cont:
 		dput(p);
-		spin_lock(&dcache_lock);
 	}
-	spin_unlock(&dcache_lock);
 	return NULL;
 }
 
@@ -294,6 +313,8 @@ struct dentry *autofs4_expire_direct(str
  * A tree is eligible if :-
  *  - it is unused by any user process
  *  - it has been unused for exp_timeout time
+ * This seems to be racy dropping dcache_lock and asking for next->next after
+ * the lock has been dropped.
  */
 struct dentry *autofs4_expire_indirect(struct super_block *sb,
 				       struct vfsmount *mnt,
@@ -316,6 +337,7 @@ struct dentry *autofs4_expire_indirect(s
 	timeout = sbi->exp_timeout;
 
 	spin_lock(&dcache_lock);
+	spin_lock(&root->d_lock);
 	next = root->d_subdirs.next;
 
 	/* On exit from the loop expire is set to a dgot dentry
@@ -329,7 +351,10 @@ struct dentry *autofs4_expire_indirect(s
 			continue;
 		}
 
-		dentry = dget(dentry);
+		spin_lock_nested(&dentry->d_lock, DENTRY_D_LOCK_NESTED);
+		dentry = dget_dlock(dentry);
+		spin_unlock(&dentry->d_lock);
+		spin_unlock(&root->d_lock);
 		spin_unlock(&dcache_lock);
 
 		spin_lock(&sbi->fs_lock);
@@ -396,8 +421,10 @@ next:
 		spin_unlock(&sbi->fs_lock);
 		dput(dentry);
 		spin_lock(&dcache_lock);
+		spin_lock(&root->d_lock);
 		next = next->next;
 	}
+	spin_unlock(&root->d_lock);
 	spin_unlock(&dcache_lock);
 	return NULL;
 
@@ -409,7 +436,11 @@ found:
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
--- linux-2.6.orig/fs/autofs4/root.c
+++ linux-2.6/fs/autofs4/root.c
@@ -135,10 +135,13 @@ static int autofs4_dir_open(struct inode
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
@@ -246,7 +249,9 @@ static void *autofs4_follow_link(struct
 	lookup_type = autofs4_need_mount(nd->flags);
 	spin_lock(&sbi->fs_lock);
 	spin_lock(&dcache_lock);
+	spin_lock(&dentry->d_lock);
 	if (!(lookup_type || ino->flags & AUTOFS_INF_PENDING)) {
+		spin_unlock(&dentry->d_lock);
 		spin_unlock(&dcache_lock);
 		spin_unlock(&sbi->fs_lock);
 		goto follow;
@@ -268,6 +273,7 @@ static void *autofs4_follow_link(struct
 
 		goto follow;
 	}
+	spin_unlock(&dentry->d_lock);
 	spin_unlock(&dcache_lock);
 	spin_unlock(&sbi->fs_lock);
 follow:
Index: linux-2.6/fs/coda/cache.c
===================================================================
--- linux-2.6.orig/fs/coda/cache.c
+++ linux-2.6/fs/coda/cache.c
@@ -87,6 +87,7 @@ static void coda_flag_children(struct de
 	struct dentry *de;
 
 	spin_lock(&dcache_lock);
+	spin_lock(&parent->d_lock);
 	list_for_each(child, &parent->d_subdirs)
 	{
 		de = list_entry(child, struct dentry, d_u.d_child);
@@ -95,6 +96,7 @@ static void coda_flag_children(struct de
 			continue;
 		coda_flag_inode(de->d_inode, flag);
 	}
+	spin_unlock(&parent->d_lock);
 	spin_unlock(&dcache_lock);
 	return; 
 }
Index: linux-2.6/fs/ncpfs/dir.c
===================================================================
--- linux-2.6.orig/fs/ncpfs/dir.c
+++ linux-2.6/fs/ncpfs/dir.c
@@ -365,6 +365,7 @@ ncp_dget_fpos(struct dentry *dentry, str
 
 	/* If a pointer is invalid, we search the dentry. */
 	spin_lock(&dcache_lock);
+	spin_lock(&parent->d_lock);
 	next = parent->d_subdirs.next;
 	while (next != &parent->d_subdirs) {
 		dent = list_entry(next, struct dentry, d_u.d_child);
@@ -373,11 +374,13 @@ ncp_dget_fpos(struct dentry *dentry, str
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
--- linux-2.6.orig/fs/ncpfs/ncplib_kernel.h
+++ linux-2.6/fs/ncpfs/ncplib_kernel.h
@@ -193,6 +193,7 @@ ncp_renew_dentries(struct dentry *parent
 	struct dentry *dentry;
 
 	spin_lock(&dcache_lock);
+	spin_lock(&parent->d_lock);
 	next = parent->d_subdirs.next;
 	while (next != &parent->d_subdirs) {
 		dentry = list_entry(next, struct dentry, d_u.d_child);
@@ -204,6 +205,7 @@ ncp_renew_dentries(struct dentry *parent
 
 		next = next->next;
 	}
+	spin_unlock(&parent->d_lock);
 	spin_unlock(&dcache_lock);
 }
 
@@ -215,6 +217,7 @@ ncp_invalidate_dircache_entries(struct d
 	struct dentry *dentry;
 
 	spin_lock(&dcache_lock);
+	spin_lock(&parent->d_lock);
 	next = parent->d_subdirs.next;
 	while (next != &parent->d_subdirs) {
 		dentry = list_entry(next, struct dentry, d_u.d_child);
@@ -222,6 +225,7 @@ ncp_invalidate_dircache_entries(struct d
 		ncp_age_dentry(server, dentry);
 		next = next->next;
 	}
+	spin_unlock(&parent->d_lock);
 	spin_unlock(&dcache_lock);
 }
 
Index: linux-2.6/fs/smbfs/cache.c
===================================================================
--- linux-2.6.orig/fs/smbfs/cache.c
+++ linux-2.6/fs/smbfs/cache.c
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
Index: linux-2.6/kernel/cgroup.c
===================================================================
--- linux-2.6.orig/kernel/cgroup.c
+++ linux-2.6/kernel/cgroup.c
@@ -870,23 +870,31 @@ static void cgroup_clear_directory(struc
 
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
 
@@ -895,10 +903,17 @@ static void cgroup_clear_directory(struc
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
--- linux-2.6.orig/security/selinux/selinuxfs.c
+++ linux-2.6/security/selinux/selinuxfs.c
@@ -942,22 +942,30 @@ static void sel_remove_entries(struct de
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
--- linux-2.6.orig/fs/notify/fsnotify.c
+++ linux-2.6/fs/notify/fsnotify.c
@@ -62,17 +62,19 @@ void __fsnotify_update_child_dentry_flag
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
--- linux-2.6.orig/fs/ceph/dir.c
+++ linux-2.6/fs/ceph/dir.c
@@ -112,6 +112,7 @@ static int __dcache_readdir(struct file
 	     last);
 
 	spin_lock(&dcache_lock);
+	spin_lock(&parent->d_lock);
 
 	/* start at beginning? */
 	if (filp->f_pos == 2 || (last &&
@@ -135,7 +136,7 @@ more:
 			fi->at_end = 1;
 			goto out_unlock;
 		}
-		spin_lock(&dentry->d_lock);
+		spin_lock_nested(&dentry->d_lock, DENTRY_D_LOCK_NESTED);
 		if (!d_unhashed(dentry) && dentry->d_inode &&
 		    ceph_snap(dentry->d_inode) != CEPH_SNAPDIR &&
 		    ceph_ino(dentry->d_inode) != CEPH_INO_CEPH &&
@@ -153,6 +154,7 @@ more:
 
 	dget_dlock(dentry);
 	spin_unlock(&dentry->d_lock);
+	spin_unlock(&parent->d_lock);
 	spin_unlock(&dcache_lock);
 	spin_unlock(&inode->i_lock);
 
@@ -177,6 +179,7 @@ more:
 
 	spin_lock(&inode->i_lock);
 	spin_lock(&dcache_lock);
+	spin_lock(&parent->d_lock);
 
 	last = dentry;
 
@@ -193,6 +196,7 @@ more:
 	err = -EAGAIN;
 
 out_unlock:
+	spin_unlock(&parent->d_lock);
 	spin_unlock(&dcache_lock);
 
 	if (last) {
Index: linux-2.6/fs/ceph/inode.c
===================================================================
--- linux-2.6.orig/fs/ceph/inode.c
+++ linux-2.6/fs/ceph/inode.c
@@ -826,11 +826,13 @@ static void ceph_set_dentry_offset(struc
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
 
@@ -1212,9 +1214,11 @@ retry_lookup:
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
 


