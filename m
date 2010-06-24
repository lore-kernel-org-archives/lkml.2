Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754634Ab0FXDQh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 23:16:37 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36003 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754106Ab0FXDPr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 23:15:47 -0400
Message-Id: <20100624030728.949700313@suse.de>
User-Agent: quilt/0.48-4.4
Date: Thu, 24 Jun 2010 13:02:33 +1000
From: npiggin@suse.de
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: John Stultz <johnstul@us.ibm.com>, Frank Mayhar <fmayhar@google.com>
Subject: [patch 21/52] fs: dcache per-inode inode alias locking
References: <20100624030212.676457061@suse.de>
Content-Disposition: inline; filename=dcache-split-inode_lock.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dcache_inode_lock can be replaced with per-inode locking. Use existing
inode->i_lock for this. This is slightly non-trivial because we sometimes
need to find the inode from the dentry, which requires d_inode to be
stabilised (either with refcount or d_lock).

Signed-off-by: Nick Piggin <npiggin@suse.de>
---
 fs/affs/amigaffs.c          |    4 -
 fs/dcache.c                 |  117 +++++++++++++++++++++++++-------------------
 fs/exportfs/expfs.c         |   12 ++--
 fs/nfs/getroot.c            |    4 -
 fs/notify/fsnotify.c        |    4 -
 fs/notify/inotify/inotify.c |    4 -
 fs/ocfs2/dcache.c           |    4 -
 fs/sysfs/dir.c              |    6 +-
 include/linux/dcache.h      |    1 
 9 files changed, 89 insertions(+), 67 deletions(-)

Index: linux-2.6/fs/dcache.c
===================================================================
--- linux-2.6.orig/fs/dcache.c
+++ linux-2.6/fs/dcache.c
@@ -39,8 +39,8 @@
 
 /*
  * Usage:
- * dcache_inode_lock protects:
- *   - i_dentry, d_alias, d_inode
+ * dcache->d_inode->i_lock protects:
+ *   - i_dentry, d_alias, d_inode of aliases
  * dcache_hash_bucket lock protects:
  *   - the dcache hash table
  * dcache_lru_lock protects:
@@ -56,7 +56,7 @@
  *   - d_alias, d_inode
  *
  * Ordering:
- * dcache_inode_lock
+ * dentry->d_inode->i_lock
  *   dentry->d_lock
  *     dcache_lru_lock
  *     dcache_hash_bucket lock
@@ -75,12 +75,10 @@
 int sysctl_vfs_cache_pressure __read_mostly = 100;
 EXPORT_SYMBOL_GPL(sysctl_vfs_cache_pressure);
 
-__cacheline_aligned_in_smp DEFINE_SPINLOCK(dcache_inode_lock);
 static __cacheline_aligned_in_smp DEFINE_SPINLOCK(dcache_lru_lock);
 __cacheline_aligned_in_smp DEFINE_SEQLOCK(rename_lock);
 
 EXPORT_SYMBOL(rename_lock);
-EXPORT_SYMBOL(dcache_inode_lock);
 
 static struct kmem_cache *dentry_cache __read_mostly;
 
@@ -165,14 +163,13 @@ static void d_free(struct dentry *dentry
  */
 static void dentry_iput(struct dentry * dentry)
 	__releases(dentry->d_lock)
-	__releases(dcache_inode_lock)
 {
 	struct inode *inode = dentry->d_inode;
 	if (inode) {
 		dentry->d_inode = NULL;
 		list_del_init(&dentry->d_alias);
 		spin_unlock(&dentry->d_lock);
-		spin_unlock(&dcache_inode_lock);
+		spin_unlock(&inode->i_lock);
 		if (!inode->i_nlink)
 			fsnotify_inoderemove(inode);
 		if (dentry->d_op && dentry->d_op->d_iput)
@@ -181,7 +178,6 @@ static void dentry_iput(struct dentry *
 			iput(inode);
 	} else {
 		spin_unlock(&dentry->d_lock);
-		spin_unlock(&dcache_inode_lock);
 	}
 }
 
@@ -252,7 +248,6 @@ static void dentry_lru_del_init(struct d
  */
 static struct dentry *d_kill(struct dentry *dentry)
 	__releases(dentry->d_lock)
-	__releases(dcache_inode_lock)
 {
 	struct dentry *parent;
 
@@ -376,6 +371,7 @@ EXPORT_SYMBOL(dget_parent);
 void dput(struct dentry *dentry)
 {
 	struct dentry *parent;
+	struct inode *inode;
 
 	if (!dentry)
 		return;
@@ -412,14 +408,21 @@ repeat:
   	return;
 
 kill_it:
-	spin_unlock(&dentry->d_lock);
-	spin_lock(&dcache_inode_lock);
+	inode = dentry->d_inode;
+	if (inode) {
+		if (!spin_trylock(&inode->i_lock)) {
 relock:
-	spin_lock(&dentry->d_lock);
+			spin_unlock(&dentry->d_lock);
+			cpu_relax();
+			spin_lock(&dentry->d_lock);
+			goto kill_it;
+		}
+	}
 	parent = dentry->d_parent;
 	if (parent && parent != dentry) {
 		if (!spin_trylock(&parent->d_lock)) {
-			spin_unlock(&dentry->d_lock);
+			if (inode)
+				spin_unlock(&inode->i_lock);
 			goto relock;
 		}
 	}
@@ -429,7 +432,8 @@ relock:
 		spin_unlock(&dentry->d_lock);
 		if (parent && parent != dentry)
 			spin_unlock(&parent->d_lock);
-		spin_unlock(&dcache_inode_lock);
+		if (inode)
+			spin_unlock(&inode->i_lock);
 		return;
 	}
 	/* if dentry was on the d_lru list delete it from there */
@@ -547,9 +551,9 @@ struct dentry * d_find_alias(struct inod
 	struct dentry *de = NULL;
 
 	if (!list_empty(&inode->i_dentry)) {
-		spin_lock(&dcache_inode_lock);
+		spin_lock(&inode->i_lock);
 		de = __d_find_alias(inode, 0);
-		spin_unlock(&dcache_inode_lock);
+		spin_unlock(&inode->i_lock);
 	}
 	return de;
 }
@@ -563,20 +567,20 @@ void d_prune_aliases(struct inode *inode
 {
 	struct dentry *dentry;
 restart:
-	spin_lock(&dcache_inode_lock);
+	spin_lock(&inode->i_lock);
 	list_for_each_entry(dentry, &inode->i_dentry, d_alias) {
 		spin_lock(&dentry->d_lock);
 		if (!dentry->d_count) {
 			__dget_locked_dlock(dentry);
 			__d_drop(dentry);
 			spin_unlock(&dentry->d_lock);
-			spin_unlock(&dcache_inode_lock);
+			spin_unlock(&inode->i_lock);
 			dput(dentry);
 			goto restart;
 		}
 		spin_unlock(&dentry->d_lock);
 	}
-	spin_unlock(&dcache_inode_lock);
+	spin_unlock(&inode->i_lock);
 }
 EXPORT_SYMBOL(d_prune_aliases);
 
@@ -599,8 +603,10 @@ static void prune_one_dentry(struct dent
 	 */
 	while (dentry) {
 		struct dentry *parent = NULL;
+		struct inode *inode = dentry->d_inode;
 
-		spin_lock(&dcache_inode_lock);
+		if (inode)
+			spin_lock(&inode->i_lock);
 again:
 		spin_lock(&dentry->d_lock);
 		if (dentry->d_parent && dentry != dentry->d_parent) {
@@ -615,7 +621,8 @@ again:
 			if (parent)
 				spin_unlock(&parent->d_lock);
 			spin_unlock(&dentry->d_lock);
-			spin_unlock(&dcache_inode_lock);
+			if (inode)
+				spin_unlock(&inode->i_lock);
 			return;
 		}
 
@@ -684,10 +691,11 @@ restart:
 	}
 	spin_unlock(&dcache_lru_lock);
 
-	spin_lock(&dcache_inode_lock);
 again:
 	spin_lock(&dcache_lru_lock); /* lru_lock also protects tmp list */
 	while (!list_empty(&tmp)) {
+		struct inode *inode;
+
 		dentry = list_entry(tmp.prev, struct dentry, d_lru);
 
 		if (!spin_trylock(&dentry->d_lock)) {
@@ -705,10 +713,17 @@ again1:
 			spin_unlock(&dentry->d_lock);
 			continue;
 		}
+		inode = dentry->d_inode;
+		if (inode && !spin_trylock(&inode->i_lock)) {
+again2:
+			spin_unlock(&dentry->d_lock);
+			goto again1;
+		}
 		if (dentry->d_parent && dentry->d_parent != dentry) {
 			if (!spin_trylock(&dentry->d_parent->d_lock)) {
-				spin_unlock(&dentry->d_lock);
-				goto again1;
+				if (inode)
+					spin_unlock(&inode->i_lock);
+				goto again2;
 			}
 		}
 		__dentry_lru_del_init(dentry);
@@ -716,10 +731,8 @@ again1:
 
 		prune_one_dentry(dentry);
 		/* dentry->d_lock dropped */
-		spin_lock(&dcache_inode_lock);
 		spin_lock(&dcache_lru_lock);
 	}
-	spin_unlock(&dcache_inode_lock);
 
 	if (count == NULL && !list_empty(&sb->s_dentry_lru))
 		goto restart;
@@ -1287,9 +1300,11 @@ static void __d_instantiate(struct dentr
 void d_instantiate(struct dentry *entry, struct inode * inode)
 {
 	BUG_ON(!list_empty(&entry->d_alias));
-	spin_lock(&dcache_inode_lock);
+	if (inode)
+		spin_lock(&inode->i_lock);
 	__d_instantiate(entry, inode);
-	spin_unlock(&dcache_inode_lock);
+	if (inode)
+		spin_unlock(&inode->i_lock);
 	security_d_instantiate(entry, inode);
 }
 EXPORT_SYMBOL(d_instantiate);
@@ -1348,9 +1363,11 @@ struct dentry *d_instantiate_unique(stru
 
 	BUG_ON(!list_empty(&entry->d_alias));
 
-	spin_lock(&dcache_inode_lock);
+	if (inode)
+		spin_lock(&inode->i_lock);
 	result = __d_instantiate_unique(entry, inode);
-	spin_unlock(&dcache_inode_lock);
+	if (inode)
+		spin_unlock(&inode->i_lock);
 
 	if (!result) {
 		security_d_instantiate(entry, inode);
@@ -1431,10 +1448,10 @@ struct dentry *d_obtain_alias(struct ino
 	}
 	tmp->d_parent = tmp; /* make sure dput doesn't croak */
 
-	spin_lock(&dcache_inode_lock);
+	spin_lock(&inode->i_lock);
 	res = __d_find_alias(inode, 0);
 	if (res) {
-		spin_unlock(&dcache_inode_lock);
+		spin_unlock(&inode->i_lock);
 		dput(tmp);
 		goto out_iput;
 	}
@@ -1448,7 +1465,7 @@ struct dentry *d_obtain_alias(struct ino
 	list_add(&tmp->d_alias, &inode->i_dentry);
 	hlist_bl_add_head(&tmp->d_hash, &inode->i_sb->s_anon); /* XXX: make s_anon a bl list */
 	spin_unlock(&tmp->d_lock);
-	spin_unlock(&dcache_inode_lock);
+	spin_unlock(&inode->i_lock);
 
 	return tmp;
 
@@ -1479,18 +1496,18 @@ struct dentry *d_splice_alias(struct ino
 	struct dentry *new = NULL;
 
 	if (inode && S_ISDIR(inode->i_mode)) {
-		spin_lock(&dcache_inode_lock);
+		spin_lock(&inode->i_lock);
 		new = __d_find_alias(inode, 1);
 		if (new) {
 			BUG_ON(!(new->d_flags & DCACHE_DISCONNECTED));
-			spin_unlock(&dcache_inode_lock);
+			spin_unlock(&inode->i_lock);
 			security_d_instantiate(new, inode);
 			d_move(new, dentry);
 			iput(inode);
 		} else {
-			/* already got dcache_inode_lock, so d_add() by hand */
+			/* already got inode->i_lock, so d_add() by hand */
 			__d_instantiate(dentry, inode);
-			spin_unlock(&dcache_inode_lock);
+			spin_unlock(&inode->i_lock);
 			security_d_instantiate(dentry, inode);
 			d_rehash(dentry);
 		}
@@ -1563,10 +1580,10 @@ struct dentry *d_add_ci(struct dentry *d
 	 * Negative dentry: instantiate it unless the inode is a directory and
 	 * already has a dentry.
 	 */
-	spin_lock(&dcache_inode_lock);
+	spin_lock(&inode->i_lock);
 	if (!S_ISDIR(inode->i_mode) || list_empty(&inode->i_dentry)) {
 		__d_instantiate(found, inode);
-		spin_unlock(&dcache_inode_lock);
+		spin_unlock(&inode->i_lock);
 		security_d_instantiate(found, inode);
 		return found;
 	}
@@ -1577,7 +1594,7 @@ struct dentry *d_add_ci(struct dentry *d
 	 */
 	new = list_entry(inode->i_dentry.next, struct dentry, d_alias);
 	dget_locked(new);
-	spin_unlock(&dcache_inode_lock);
+	spin_unlock(&inode->i_lock);
 	security_d_instantiate(found, inode);
 	d_move(new, found);
 	iput(inode);
@@ -1785,15 +1802,17 @@ EXPORT_SYMBOL(d_validate);
  
 void d_delete(struct dentry * dentry)
 {
+	struct inode *inode;
 	int isdir = 0;
 	/*
 	 * Are we the only user?
 	 */
 again:
 	spin_lock(&dentry->d_lock);
-	isdir = S_ISDIR(dentry->d_inode->i_mode);
+	inode = dentry->d_inode;
+	isdir = S_ISDIR(inode->i_mode);
 	if (dentry->d_count == 1) {
-		if (!spin_trylock(&dcache_inode_lock)) {
+		if (inode && !spin_trylock(&inode->i_lock)) {
 			spin_unlock(&dentry->d_lock);
 			cpu_relax();
 			goto again;
@@ -2034,6 +2053,7 @@ static struct dentry *__d_unalias(struct
 {
 	struct mutex *m1 = NULL, *m2 = NULL;
 	struct dentry *ret;
+	struct inode *inode;
 
 	/* If alias and dentry share a parent, then no extra locks required */
 	if (alias->d_parent == dentry->d_parent)
@@ -2049,14 +2069,15 @@ static struct dentry *__d_unalias(struct
 	if (!mutex_trylock(&dentry->d_sb->s_vfs_rename_mutex))
 		goto out_err;
 	m1 = &dentry->d_sb->s_vfs_rename_mutex;
-	if (!mutex_trylock(&alias->d_parent->d_inode->i_mutex))
+	inode = alias->d_parent->d_inode;
+	if (!mutex_trylock(&inode->i_mutex))
 		goto out_err;
-	m2 = &alias->d_parent->d_inode->i_mutex;
+	m2 = &inode->i_mutex;
 out_unalias:
 	d_move_locked(alias, dentry);
 	ret = alias;
 out_err:
-	spin_unlock(&dcache_inode_lock);
+	spin_unlock(&inode->i_lock);
 	if (m2)
 		mutex_unlock(m2);
 	if (m1)
@@ -2127,7 +2148,7 @@ struct dentry *d_materialise_unique(stru
 		goto out_nolock;
 	}
 
-	spin_lock(&dcache_inode_lock);
+	spin_lock(&inode->i_lock);
 
 	if (S_ISDIR(inode->i_mode)) {
 		struct dentry *alias;
@@ -2162,7 +2183,7 @@ struct dentry *d_materialise_unique(stru
 found:
 	_d_rehash(actual);
 	spin_unlock(&actual->d_lock);
-	spin_unlock(&dcache_inode_lock);
+	spin_unlock(&inode->i_lock);
 out_nolock:
 	if (actual == dentry) {
 		security_d_instantiate(dentry, inode);
Index: linux-2.6/include/linux/dcache.h
===================================================================
--- linux-2.6.orig/include/linux/dcache.h
+++ linux-2.6/include/linux/dcache.h
@@ -190,7 +190,6 @@ d_iput:		no		no       yes
 #define DCACHE_CANT_MOUNT	0x0100
 #define DCACHE_GENOCIDE		0x0200
 
-extern spinlock_t dcache_inode_lock;
 extern seqlock_t rename_lock;
 
 /**
Index: linux-2.6/fs/notify/inotify/inotify.c
===================================================================
--- linux-2.6.orig/fs/notify/inotify/inotify.c
+++ linux-2.6/fs/notify/inotify/inotify.c
@@ -181,7 +181,7 @@ static void set_dentry_child_flags(struc
 {
 	struct dentry *alias;
 
-	spin_lock(&dcache_inode_lock);
+	spin_lock(&inode->i_lock);
 	list_for_each_entry(alias, &inode->i_dentry, d_alias) {
 		struct dentry *child;
 
@@ -199,7 +199,7 @@ static void set_dentry_child_flags(struc
 		}
 		spin_unlock(&alias->d_lock);
 	}
-	spin_unlock(&dcache_inode_lock);
+	spin_unlock(&inode->i_lock);
 }
 
 /*
Index: linux-2.6/fs/exportfs/expfs.c
===================================================================
--- linux-2.6.orig/fs/exportfs/expfs.c
+++ linux-2.6/fs/exportfs/expfs.c
@@ -43,24 +43,26 @@ find_acceptable_alias(struct dentry *res
 		void *context)
 {
 	struct dentry *dentry, *toput = NULL;
+	struct inode *inode;
 
 	if (acceptable(context, result))
 		return result;
 
-	spin_lock(&dcache_inode_lock);
-	list_for_each_entry(dentry, &result->d_inode->i_dentry, d_alias) {
+	inode = result->d_inode;
+	spin_lock(&inode->i_lock);
+	list_for_each_entry(dentry, &inode->i_dentry, d_alias) {
 		dget_locked(dentry);
-		spin_unlock(&dcache_inode_lock);
+		spin_unlock(&inode->i_lock);
 		if (toput)
 			dput(toput);
 		if (dentry != result && acceptable(context, dentry)) {
 			dput(result);
 			return dentry;
 		}
-		spin_lock(&dcache_inode_lock);
+		spin_lock(&inode->i_lock);
 		toput = dentry;
 	}
-	spin_unlock(&dcache_inode_lock);
+	spin_unlock(&inode->i_lock);
 
 	if (toput)
 		dput(toput);
Index: linux-2.6/fs/affs/amigaffs.c
===================================================================
--- linux-2.6.orig/fs/affs/amigaffs.c
+++ linux-2.6/fs/affs/amigaffs.c
@@ -128,7 +128,7 @@ affs_fix_dcache(struct dentry *dentry, u
 	void *data = dentry->d_fsdata;
 	struct list_head *head, *next;
 
-	spin_lock(&dcache_inode_lock);
+	spin_lock(&inode->i_lock);
 	head = &inode->i_dentry;
 	next = head->next;
 	while (next != head) {
@@ -139,7 +139,7 @@ affs_fix_dcache(struct dentry *dentry, u
 		}
 		next = next->next;
 	}
-	spin_unlock(&dcache_inode_lock);
+	spin_unlock(&inode->i_lock);
 }
 
 
Index: linux-2.6/fs/nfs/getroot.c
===================================================================
--- linux-2.6.orig/fs/nfs/getroot.c
+++ linux-2.6/fs/nfs/getroot.c
@@ -64,11 +64,11 @@ static int nfs_superblock_set_dummy_root
 		 * This again causes shrink_dcache_for_umount_subtree() to
 		 * Oops, since the test for IS_ROOT() will fail.
 		 */
-		spin_lock(&dcache_inode_lock);
+		spin_lock(&sb->s_root->d_inode->i_lock);
 		spin_lock(&sb->s_root->d_lock);
 		list_del_init(&sb->s_root->d_alias);
 		spin_unlock(&sb->s_root->d_lock);
-		spin_unlock(&dcache_inode_lock);
+		spin_unlock(&sb->s_root->d_inode->i_lock);
 	}
 	return 0;
 }
Index: linux-2.6/fs/ocfs2/dcache.c
===================================================================
--- linux-2.6.orig/fs/ocfs2/dcache.c
+++ linux-2.6/fs/ocfs2/dcache.c
@@ -151,7 +151,7 @@ struct dentry *ocfs2_find_local_alias(st
 	struct list_head *p;
 	struct dentry *dentry = NULL;
 
-	spin_lock(&dcache_inode_lock);
+	spin_lock(&inode->i_lock);
 	list_for_each(p, &inode->i_dentry) {
 		dentry = list_entry(p, struct dentry, d_alias);
 
@@ -169,7 +169,7 @@ struct dentry *ocfs2_find_local_alias(st
 		dentry = NULL;
 	}
 
-	spin_unlock(&dcache_inode_lock);
+	spin_unlock(&inode->i_lock);
 
 	return dentry;
 }
Index: linux-2.6/fs/notify/fsnotify.c
===================================================================
--- linux-2.6.orig/fs/notify/fsnotify.c
+++ linux-2.6/fs/notify/fsnotify.c
@@ -53,7 +53,7 @@ void __fsnotify_update_child_dentry_flag
 	/* determine if the children should tell inode about their events */
 	watched = fsnotify_inode_watches_children(inode);
 
-	spin_lock(&dcache_inode_lock);
+	spin_lock(&inode->i_lock);
 	/* run all of the dentries associated with this inode.  Since this is a
 	 * directory, there damn well better only be one item on this list */
 	list_for_each_entry(alias, &inode->i_dentry, d_alias) {
@@ -76,7 +76,7 @@ void __fsnotify_update_child_dentry_flag
 		}
 		spin_unlock(&alias->d_lock);
 	}
-	spin_unlock(&dcache_inode_lock);
+	spin_unlock(&inode->i_lock);
 }
 
 /* Notify this dentry's parent about a child's events. */


