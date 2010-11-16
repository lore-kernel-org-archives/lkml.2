Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758667Ab0KPOX7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 09:23:59 -0500
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:32788 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758582Ab0KPOX5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 09:23:57 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AiQJAKMh4kx5Ldur/2dsb2JhbACVYYx9cr5mhUsEilg
Message-Id: <20101116142029.623791796@kernel.dk>
User-Agent: quilt/0.48-1
Date: Wed, 17 Nov 2010 01:09:15 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [patch 15/28] fs: scale inode alias list
References: <20101116140900.039761100@kernel.dk>
Content-Disposition: inline; filename=fs-dcache-scale-i_dentry.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a new lock, dcache_inode_lock, to protect the inode's i_dentry list
from concurrent modification. d_alias is also protected by d_lock.

Signed-off-by: Nick Piggin <npiggin@kernel.dk>

---
 fs/9p/vfs_inode.c      |    2 +
 fs/affs/amigaffs.c     |    2 +
 fs/cifs/inode.c        |    3 ++
 fs/dcache.c            |   66 +++++++++++++++++++++++++++++++++++++++++++------
 fs/exportfs/expfs.c    |    4 ++
 fs/nfs/getroot.c       |    4 ++
 fs/notify/fsnotify.c   |    2 +
 fs/ocfs2/dcache.c      |    3 +-
 include/linux/dcache.h |    1 
 9 files changed, 78 insertions(+), 9 deletions(-)

Index: linux-2.6/fs/dcache.c
===================================================================
--- linux-2.6.orig/fs/dcache.c	2010-11-17 00:52:37.000000000 +1100
+++ linux-2.6/fs/dcache.c	2010-11-17 01:05:43.000000000 +1100
@@ -37,6 +37,8 @@
 
 /*
  * Usage:
+ * dcache_inode_lock protects:
+ *   - i_dentry, d_alias, d_inode
  * dcache_hash_lock protects:
  *   - the dcache hash table
  * dcache_lru_lock protects:
@@ -49,12 +51,14 @@
  *   - d_unhashed()
  *   - d_parent and d_subdirs
  *   - childrens' d_child and d_parent
+ *   - d_alias, d_inode
  *
  * Ordering:
  * dcache_lock
- *   dentry->d_lock
- *     dcache_lru_lock
- *     dcache_hash_lock
+ *   dcache_inode_lock
+ *     dentry->d_lock
+ *       dcache_lru_lock
+ *       dcache_hash_lock
  *
  * If there is an ancestor relationship:
  * dentry->d_parent->...->d_parent->d_lock
@@ -70,11 +74,13 @@
 int sysctl_vfs_cache_pressure __read_mostly = 100;
 EXPORT_SYMBOL_GPL(sysctl_vfs_cache_pressure);
 
+__cacheline_aligned_in_smp DEFINE_SPINLOCK(dcache_inode_lock);
 __cacheline_aligned_in_smp DEFINE_SPINLOCK(dcache_hash_lock);
 static __cacheline_aligned_in_smp DEFINE_SPINLOCK(dcache_lru_lock);
 __cacheline_aligned_in_smp DEFINE_SPINLOCK(dcache_lock);
 __cacheline_aligned_in_smp DEFINE_SEQLOCK(rename_lock);
 
+EXPORT_SYMBOL(dcache_inode_lock);
 EXPORT_SYMBOL(dcache_hash_lock);
 EXPORT_SYMBOL(dcache_lock);
 
@@ -148,6 +154,7 @@ static void d_free(struct dentry *dentry
  */
 static void dentry_iput(struct dentry * dentry)
 	__releases(dentry->d_lock)
+	__releases(dcache_inode_lock)
 	__releases(dcache_lock)
 {
 	struct inode *inode = dentry->d_inode;
@@ -155,6 +162,7 @@ static void dentry_iput(struct dentry *
 		dentry->d_inode = NULL;
 		list_del_init(&dentry->d_alias);
 		spin_unlock(&dentry->d_lock);
+		spin_unlock(&dcache_inode_lock);
 		spin_unlock(&dcache_lock);
 		if (!inode->i_nlink)
 			fsnotify_inoderemove(inode);
@@ -164,6 +172,7 @@ static void dentry_iput(struct dentry *
 			iput(inode);
 	} else {
 		spin_unlock(&dentry->d_lock);
+		spin_unlock(&dcache_inode_lock);
 		spin_unlock(&dcache_lock);
 	}
 }
@@ -225,6 +234,7 @@ static void dentry_lru_move_tail(struct
 static struct dentry *d_kill(struct dentry *dentry, struct dentry *parent)
 	__releases(dentry->d_lock)
 	__releases(parent->d_lock)
+	__releases(dcache_inode_lock)
 	__releases(dcache_lock)
 {
 	list_del(&dentry->d_u.d_child);
@@ -290,13 +300,18 @@ void dput(struct dentry *dentry)
 			 * want to reduce dcache_lock anyway so this will
 			 * get improved.
 			 */
+drop1:
 			spin_unlock(&dentry->d_lock);
 			goto repeat;
 		}
-		if (parent && !spin_trylock(&parent->d_lock)) {
-			spin_unlock(&dentry->d_lock);
+		if (!spin_trylock(&dcache_inode_lock)) {
+drop2:
 			spin_unlock(&dcache_lock);
-			goto repeat;
+			goto drop1;
+		}
+		if (parent && !spin_trylock(&parent->d_lock)) {
+			spin_unlock(&dcache_inode_lock);
+			goto drop2;
 		}
 	}
 	dentry->d_count--;
@@ -327,6 +342,7 @@ void dput(struct dentry *dentry)
  	spin_unlock(&dentry->d_lock);
 	if (parent)
 		spin_unlock(&parent->d_lock);
+	spin_unlock(&dcache_inode_lock);
 	spin_unlock(&dcache_lock);
 	return;
 
@@ -521,7 +537,9 @@ struct dentry *d_find_alias(struct inode
 
 	if (!list_empty(&inode->i_dentry)) {
 		spin_lock(&dcache_lock);
+		spin_lock(&dcache_inode_lock);
 		de = __d_find_alias(inode, 0);
+		spin_unlock(&dcache_inode_lock);
 		spin_unlock(&dcache_lock);
 	}
 	return de;
@@ -537,18 +555,21 @@ void d_prune_aliases(struct inode *inode
 	struct dentry *dentry;
 restart:
 	spin_lock(&dcache_lock);
+	spin_lock(&dcache_inode_lock);
 	list_for_each_entry(dentry, &inode->i_dentry, d_alias) {
 		spin_lock(&dentry->d_lock);
 		if (!dentry->d_count) {
 			__dget_locked_dlock(dentry);
 			__d_drop(dentry);
 			spin_unlock(&dentry->d_lock);
+			spin_unlock(&dcache_inode_lock);
 			spin_unlock(&dcache_lock);
 			dput(dentry);
 			goto restart;
 		}
 		spin_unlock(&dentry->d_lock);
 	}
+	spin_unlock(&dcache_inode_lock);
 	spin_unlock(&dcache_lock);
 }
 EXPORT_SYMBOL(d_prune_aliases);
@@ -564,6 +585,7 @@ EXPORT_SYMBOL(d_prune_aliases);
 static void prune_one_dentry(struct dentry *dentry, struct dentry *parent)
 	__releases(dentry->d_lock)
 	__releases(parent->d_lock)
+	__releases(dcache_inode_lock)
 	__releases(dcache_lock)
 {
 	__d_drop(dentry);
@@ -575,6 +597,7 @@ static void prune_one_dentry(struct dent
 	 */
 	while (dentry) {
 		spin_lock(&dcache_lock);
+		spin_lock(&dcache_inode_lock);
 again:
 		spin_lock(&dentry->d_lock);
 		if (IS_ROOT(dentry))
@@ -590,6 +613,7 @@ static void prune_one_dentry(struct dent
 			if (parent)
 				spin_unlock(&parent->d_lock);
 			spin_unlock(&dentry->d_lock);
+			spin_unlock(&dcache_inode_lock);
 			spin_unlock(&dcache_lock);
 			return;
 		}
@@ -639,8 +663,9 @@ static void shrink_dentry_list(struct li
 		spin_unlock(&dcache_lru_lock);
 
 		prune_one_dentry(dentry, parent);
-		/* dcache_lock and dentry->d_lock dropped */
+		/* dcache_lock, dcache_inode_lock and dentry->d_lock dropped */
 		spin_lock(&dcache_lock);
+		spin_lock(&dcache_inode_lock);
 		spin_lock(&dcache_lru_lock);
 	}
 }
@@ -662,6 +687,7 @@ static void __shrink_dcache_sb(struct su
 	int cnt = *count;
 
 	spin_lock(&dcache_lock);
+	spin_lock(&dcache_inode_lock);
 relock:
 	spin_lock(&dcache_lru_lock);
 	while (!list_empty(&sb->s_dentry_lru)) {
@@ -700,8 +726,8 @@ static void __shrink_dcache_sb(struct su
 	if (!list_empty(&referenced))
 		list_splice(&referenced, &sb->s_dentry_lru);
 	spin_unlock(&dcache_lru_lock);
+	spin_unlock(&dcache_inode_lock);
 	spin_unlock(&dcache_lock);
-
 }
 
 /**
@@ -795,12 +821,14 @@ void shrink_dcache_sb(struct super_block
 	LIST_HEAD(tmp);
 
 	spin_lock(&dcache_lock);
+	spin_lock(&dcache_inode_lock);
 	spin_lock(&dcache_lru_lock);
 	while (!list_empty(&sb->s_dentry_lru)) {
 		list_splice_init(&sb->s_dentry_lru, &tmp);
 		shrink_dentry_list(&tmp);
 	}
 	spin_unlock(&dcache_lru_lock);
+	spin_unlock(&dcache_inode_lock);
 	spin_unlock(&dcache_lock);
 }
 EXPORT_SYMBOL(shrink_dcache_sb);
@@ -1221,9 +1249,11 @@ EXPORT_SYMBOL(d_alloc_name);
 /* the caller must hold dcache_lock */
 static void __d_instantiate(struct dentry *dentry, struct inode *inode)
 {
+	spin_lock(&dentry->d_lock);
 	if (inode)
 		list_add(&dentry->d_alias, &inode->i_dentry);
 	dentry->d_inode = inode;
+	spin_unlock(&dentry->d_lock);
 	fsnotify_d_instantiate(dentry, inode);
 }
 
@@ -1246,7 +1276,9 @@ void d_instantiate(struct dentry *entry,
 {
 	BUG_ON(!list_empty(&entry->d_alias));
 	spin_lock(&dcache_lock);
+	spin_lock(&dcache_inode_lock);
 	__d_instantiate(entry, inode);
+	spin_unlock(&dcache_inode_lock);
 	spin_unlock(&dcache_lock);
 	security_d_instantiate(entry, inode);
 }
@@ -1307,7 +1339,9 @@ struct dentry *d_instantiate_unique(stru
 	BUG_ON(!list_empty(&entry->d_alias));
 
 	spin_lock(&dcache_lock);
+	spin_lock(&dcache_inode_lock);
 	result = __d_instantiate_unique(entry, inode);
+	spin_unlock(&dcache_inode_lock);
 	spin_unlock(&dcache_lock);
 
 	if (!result) {
@@ -1398,8 +1432,10 @@ struct dentry *d_obtain_alias(struct ino
 	tmp->d_parent = tmp; /* make sure dput doesn't croak */
 
 	spin_lock(&dcache_lock);
+	spin_lock(&dcache_inode_lock);
 	res = __d_find_alias(inode, 0);
 	if (res) {
+		spin_unlock(&dcache_inode_lock);
 		spin_unlock(&dcache_lock);
 		dput(tmp);
 		goto out_iput;
@@ -1416,6 +1452,7 @@ struct dentry *d_obtain_alias(struct ino
 	hlist_add_head(&tmp->d_hash, &inode->i_sb->s_anon);
 	spin_unlock(&dcache_hash_lock);
 	spin_unlock(&tmp->d_lock);
+	spin_unlock(&dcache_inode_lock);
 
 	spin_unlock(&dcache_lock);
 	return tmp;
@@ -1448,9 +1485,11 @@ struct dentry *d_splice_alias(struct ino
 
 	if (inode && S_ISDIR(inode->i_mode)) {
 		spin_lock(&dcache_lock);
+		spin_lock(&dcache_inode_lock);
 		new = __d_find_alias(inode, 1);
 		if (new) {
 			BUG_ON(!(new->d_flags & DCACHE_DISCONNECTED));
+			spin_unlock(&dcache_inode_lock);
 			spin_unlock(&dcache_lock);
 			security_d_instantiate(new, inode);
 			d_move(new, dentry);
@@ -1458,6 +1497,7 @@ struct dentry *d_splice_alias(struct ino
 		} else {
 			/* already taking dcache_lock, so d_add() by hand */
 			__d_instantiate(dentry, inode);
+			spin_unlock(&dcache_inode_lock);
 			spin_unlock(&dcache_lock);
 			security_d_instantiate(dentry, inode);
 			d_rehash(dentry);
@@ -1532,8 +1572,10 @@ struct dentry *d_add_ci(struct dentry *d
 	 * already has a dentry.
 	 */
 	spin_lock(&dcache_lock);
+	spin_lock(&dcache_inode_lock);
 	if (!S_ISDIR(inode->i_mode) || list_empty(&inode->i_dentry)) {
 		__d_instantiate(found, inode);
+		spin_unlock(&dcache_inode_lock);
 		spin_unlock(&dcache_lock);
 		security_d_instantiate(found, inode);
 		return found;
@@ -1545,6 +1587,7 @@ struct dentry *d_add_ci(struct dentry *d
 	 */
 	new = list_entry(inode->i_dentry.next, struct dentry, d_alias);
 	dget_locked(new);
+	spin_unlock(&dcache_inode_lock);
 	spin_unlock(&dcache_lock);
 	security_d_instantiate(found, inode);
 	d_move(new, found);
@@ -1763,6 +1806,7 @@ void d_delete(struct dentry * dentry)
 	 * Are we the only user?
 	 */
 	spin_lock(&dcache_lock);
+	spin_lock(&dcache_inode_lock);
 	spin_lock(&dentry->d_lock);
 	isdir = S_ISDIR(dentry->d_inode->i_mode);
 	if (dentry->d_count == 1) {
@@ -1776,6 +1820,7 @@ void d_delete(struct dentry * dentry)
 		__d_drop(dentry);
 
 	spin_unlock(&dentry->d_lock);
+	spin_unlock(&dcache_inode_lock);
 	spin_unlock(&dcache_lock);
 
 	fsnotify_nameremove(dentry, isdir);
@@ -2003,6 +2048,7 @@ struct dentry *d_ancestor(struct dentry
  */
 static struct dentry *__d_unalias(struct dentry *dentry, struct dentry *alias)
 	__releases(dcache_lock)
+	__releases(dcache_inode_lock)
 {
 	struct mutex *m1 = NULL, *m2 = NULL;
 	struct dentry *ret;
@@ -2028,6 +2074,7 @@ static struct dentry *__d_unalias(struct
 	d_move_locked(alias, dentry);
 	ret = alias;
 out_err:
+	spin_unlock(&dcache_inode_lock);
 	spin_unlock(&dcache_lock);
 	if (m2)
 		mutex_unlock(m2);
@@ -2093,6 +2140,7 @@ struct dentry *d_materialise_unique(stru
 	BUG_ON(!d_unhashed(dentry));
 
 	spin_lock(&dcache_lock);
+	spin_lock(&dcache_inode_lock);
 
 	if (!inode) {
 		actual = dentry;
@@ -2136,6 +2184,7 @@ struct dentry *d_materialise_unique(stru
 	_d_rehash(actual);
 	spin_unlock(&dcache_hash_lock);
 	spin_unlock(&actual->d_lock);
+	spin_unlock(&dcache_inode_lock);
 	spin_unlock(&dcache_lock);
 out_nolock:
 	if (actual == dentry) {
@@ -2147,6 +2196,7 @@ struct dentry *d_materialise_unique(stru
 	return actual;
 
 shouldnt_be_hashed:
+	spin_unlock(&dcache_inode_lock);
 	spin_unlock(&dcache_lock);
 	BUG();
 }
Index: linux-2.6/include/linux/dcache.h
===================================================================
--- linux-2.6.orig/include/linux/dcache.h	2010-11-17 00:52:37.000000000 +1100
+++ linux-2.6/include/linux/dcache.h	2010-11-17 01:05:43.000000000 +1100
@@ -181,6 +181,7 @@ struct dentry_operations {
 
 #define DCACHE_CANT_MOUNT	0x0100
 
+extern spinlock_t dcache_inode_lock;
 extern spinlock_t dcache_hash_lock;
 extern spinlock_t dcache_lock;
 extern seqlock_t rename_lock;
Index: linux-2.6/fs/exportfs/expfs.c
===================================================================
--- linux-2.6.orig/fs/exportfs/expfs.c	2010-11-17 00:50:49.000000000 +1100
+++ linux-2.6/fs/exportfs/expfs.c	2010-11-17 01:05:42.000000000 +1100
@@ -48,8 +48,10 @@ find_acceptable_alias(struct dentry *res
 		return result;
 
 	spin_lock(&dcache_lock);
+	spin_lock(&dcache_inode_lock);
 	list_for_each_entry(dentry, &result->d_inode->i_dentry, d_alias) {
 		dget_locked(dentry);
+		spin_unlock(&dcache_inode_lock);
 		spin_unlock(&dcache_lock);
 		if (toput)
 			dput(toput);
@@ -58,8 +60,10 @@ find_acceptable_alias(struct dentry *res
 			return dentry;
 		}
 		spin_lock(&dcache_lock);
+		spin_lock(&dcache_inode_lock);
 		toput = dentry;
 	}
+	spin_unlock(&dcache_inode_lock);
 	spin_unlock(&dcache_lock);
 
 	if (toput)
Index: linux-2.6/fs/affs/amigaffs.c
===================================================================
--- linux-2.6.orig/fs/affs/amigaffs.c	2010-11-17 00:50:49.000000000 +1100
+++ linux-2.6/fs/affs/amigaffs.c	2010-11-17 01:05:42.000000000 +1100
@@ -129,6 +129,7 @@ affs_fix_dcache(struct dentry *dentry, u
 	struct list_head *head, *next;
 
 	spin_lock(&dcache_lock);
+	spin_lock(&dcache_inode_lock);
 	head = &inode->i_dentry;
 	next = head->next;
 	while (next != head) {
@@ -139,6 +140,7 @@ affs_fix_dcache(struct dentry *dentry, u
 		}
 		next = next->next;
 	}
+	spin_unlock(&dcache_inode_lock);
 	spin_unlock(&dcache_lock);
 }
 
Index: linux-2.6/fs/ocfs2/dcache.c
===================================================================
--- linux-2.6.orig/fs/ocfs2/dcache.c	2010-11-17 00:52:37.000000000 +1100
+++ linux-2.6/fs/ocfs2/dcache.c	2010-11-17 01:05:42.000000000 +1100
@@ -170,7 +170,7 @@ struct dentry *ocfs2_find_local_alias(st
 	struct dentry *dentry = NULL;
 
 	spin_lock(&dcache_lock);
-
+	spin_lock(&dcache_inode_lock);
 	list_for_each(p, &inode->i_dentry) {
 		dentry = list_entry(p, struct dentry, d_alias);
 
@@ -188,6 +188,7 @@ struct dentry *ocfs2_find_local_alias(st
 		dentry = NULL;
 	}
 
+	spin_unlock(&dcache_inode_lock);
 	spin_unlock(&dcache_lock);
 
 	return dentry;
Index: linux-2.6/fs/nfs/getroot.c
===================================================================
--- linux-2.6.orig/fs/nfs/getroot.c	2010-11-17 00:50:49.000000000 +1100
+++ linux-2.6/fs/nfs/getroot.c	2010-11-17 01:05:42.000000000 +1100
@@ -64,7 +64,11 @@ static int nfs_superblock_set_dummy_root
 		 * Oops, since the test for IS_ROOT() will fail.
 		 */
 		spin_lock(&dcache_lock);
+		spin_lock(&dcache_inode_lock);
+		spin_lock(&sb->s_root->d_lock);
 		list_del_init(&sb->s_root->d_alias);
+		spin_unlock(&sb->s_root->d_lock);
+		spin_unlock(&dcache_inode_lock);
 		spin_unlock(&dcache_lock);
 	}
 	return 0;
Index: linux-2.6/fs/notify/fsnotify.c
===================================================================
--- linux-2.6.orig/fs/notify/fsnotify.c	2010-11-17 00:52:37.000000000 +1100
+++ linux-2.6/fs/notify/fsnotify.c	2010-11-17 01:05:42.000000000 +1100
@@ -60,6 +60,7 @@ void __fsnotify_update_child_dentry_flag
 	watched = fsnotify_inode_watches_children(inode);
 
 	spin_lock(&dcache_lock);
+	spin_lock(&dcache_inode_lock);
 	/* run all of the dentries associated with this inode.  Since this is a
 	 * directory, there damn well better only be one item on this list */
 	list_for_each_entry(alias, &inode->i_dentry, d_alias) {
@@ -82,6 +83,7 @@ void __fsnotify_update_child_dentry_flag
 		}
 		spin_unlock(&alias->d_lock);
 	}
+	spin_unlock(&dcache_inode_lock);
 	spin_unlock(&dcache_lock);
 }
 
Index: linux-2.6/fs/9p/vfs_inode.c
===================================================================
--- linux-2.6.orig/fs/9p/vfs_inode.c	2010-11-17 00:50:49.000000000 +1100
+++ linux-2.6/fs/9p/vfs_inode.c	2010-11-17 01:05:42.000000000 +1100
@@ -271,9 +271,11 @@ static struct dentry *v9fs_dentry_from_d
 	struct dentry *dentry;
 
 	spin_lock(&dcache_lock);
+	spin_lock(&dcache_inode_lock);
 	/* Directory should have only one entry. */
 	BUG_ON(S_ISDIR(inode->i_mode) && !list_is_singular(&inode->i_dentry));
 	dentry = list_entry(inode->i_dentry.next, struct dentry, d_alias);
+	spin_unlock(&dcache_inode_lock);
 	spin_unlock(&dcache_lock);
 	return dentry;
 }
Index: linux-2.6/fs/cifs/inode.c
===================================================================
--- linux-2.6.orig/fs/cifs/inode.c	2010-11-17 00:50:49.000000000 +1100
+++ linux-2.6/fs/cifs/inode.c	2010-11-17 01:05:42.000000000 +1100
@@ -805,12 +805,15 @@ inode_has_hashed_dentries(struct inode *
 	struct dentry *dentry;
 
 	spin_lock(&dcache_lock);
+	spin_lock(&dcache_inode_lock);
 	list_for_each_entry(dentry, &inode->i_dentry, d_alias) {
 		if (!d_unhashed(dentry) || IS_ROOT(dentry)) {
+			spin_unlock(&dcache_inode_lock);
 			spin_unlock(&dcache_lock);
 			return true;
 		}
 	}
+	spin_unlock(&dcache_inode_lock);
 	spin_unlock(&dcache_lock);
 	return false;
 }


