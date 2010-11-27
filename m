Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753696Ab0K0KaU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Nov 2010 05:30:20 -0500
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:34794 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753035Ab0K0K01 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Nov 2010 05:26:27 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAO1p8Ex5Lcx2/2dsb2JhbACjC3K9doVHBIph
Message-Id: <d04c9af2e386443c8406f17b956d6f5173cfc331.1290852960.git.npiggin@kernel.dk>
In-Reply-To: <cover.1290852958.git.npiggin@kernel.dk>
References: <cover.1290852958.git.npiggin@kernel.dk>
From: Nick Piggin <npiggin@kernel.dk>
Date: Sat, 27 Nov 2010 20:45:15 +1100
Subject: [PATCH 45/46] fs: dcache per-inode inode alias locking
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dcache_inode_lock can be replaced with per-inode locking. Use existing
inode->i_lock for this. This is slightly non-trivial because we sometimes
need to find the inode from the dentry, which requires d_inode to be
stabilised (either with refcount or d_lock).

Signed-off-by: Nick Piggin <npiggin@kernel.dk>
---
 fs/9p/vfs_inode.c      |    4 +-
 fs/affs/amigaffs.c     |    4 +-
 fs/dcache.c            |   84 +++++++++++++++++++++++++----------------------
 fs/exportfs/expfs.c    |   12 ++++---
 fs/nfs/getroot.c       |    4 +-
 fs/notify/fsnotify.c   |    4 +-
 fs/ocfs2/dcache.c      |    4 +-
 include/linux/dcache.h |    1 -
 8 files changed, 62 insertions(+), 55 deletions(-)

diff --git a/fs/9p/vfs_inode.c b/fs/9p/vfs_inode.c
index df8bbb3..5978298 100644
--- a/fs/9p/vfs_inode.c
+++ b/fs/9p/vfs_inode.c
@@ -277,11 +277,11 @@ static struct dentry *v9fs_dentry_from_dir_inode(struct inode *inode)
 {
 	struct dentry *dentry;
 
-	spin_lock(&dcache_inode_lock);
+	spin_lock(&inode->i_lock);
 	/* Directory should have only one entry. */
 	BUG_ON(S_ISDIR(inode->i_mode) && !list_is_singular(&inode->i_dentry));
 	dentry = list_entry(inode->i_dentry.next, struct dentry, d_alias);
-	spin_unlock(&dcache_inode_lock);
+	spin_unlock(&inode->i_lock);
 	return dentry;
 }
 
diff --git a/fs/affs/amigaffs.c b/fs/affs/amigaffs.c
index 600101a..3a4557e 100644
--- a/fs/affs/amigaffs.c
+++ b/fs/affs/amigaffs.c
@@ -128,7 +128,7 @@ affs_fix_dcache(struct dentry *dentry, u32 entry_ino)
 	void *data = dentry->d_fsdata;
 	struct list_head *head, *next;
 
-	spin_lock(&dcache_inode_lock);
+	spin_lock(&inode->i_lock);
 	head = &inode->i_dentry;
 	next = head->next;
 	while (next != head) {
@@ -139,7 +139,7 @@ affs_fix_dcache(struct dentry *dentry, u32 entry_ino)
 		}
 		next = next->next;
 	}
-	spin_unlock(&dcache_inode_lock);
+	spin_unlock(&inode->i_lock);
 }
 
 
diff --git a/fs/dcache.c b/fs/dcache.c
index 5e19940..809ec46 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
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
 
@@ -172,7 +170,7 @@ static void d_free(struct dentry *dentry)
  */
 static void dentry_iput(struct dentry * dentry)
 	__releases(dentry->d_lock)
-	__releases(dcache_inode_lock)
+	__releases(dentry->d_inode->i_lock)
 {
 	struct inode *inode = dentry->d_inode;
 	if (inode) {
@@ -181,7 +179,7 @@ static void dentry_iput(struct dentry * dentry)
 		write_seqcount_end(&dentry->d_seq);
 		list_del_init(&dentry->d_alias);
 		spin_unlock(&dentry->d_lock);
-		spin_unlock(&dcache_inode_lock);
+		spin_unlock(&inode->i_lock);
 		if (!inode->i_nlink)
 			fsnotify_inoderemove(inode);
 		if (dentry->d_op && dentry->d_op->d_iput)
@@ -190,7 +188,6 @@ static void dentry_iput(struct dentry * dentry)
 			iput(inode);
 	} else {
 		spin_unlock(&dentry->d_lock);
-		spin_unlock(&dcache_inode_lock);
 	}
 }
 
@@ -251,7 +248,7 @@ static void dentry_lru_move_tail(struct dentry *dentry)
 static struct dentry *d_kill(struct dentry *dentry, struct dentry *parent)
 	__releases(dentry->d_lock)
 	__releases(parent->d_lock)
-	__releases(dcache_inode_lock)
+	__releases(dentry->d_inode->i_lock)
 {
 	dentry->d_parent = NULL;
 	list_del(&dentry->d_u.d_child);
@@ -275,9 +272,11 @@ static struct dentry *d_kill(struct dentry *dentry, struct dentry *parent)
 static inline struct dentry *dentry_kill(struct dentry *dentry, int ref)
 	__releases(dentry->d_lock)
 {
+	struct inode *inode;
 	struct dentry *parent;
 
-	if (!spin_trylock(&dcache_inode_lock)) {
+	inode = dentry->d_inode;
+	if (inode && !spin_trylock(&inode->i_lock)) {
 relock:
 		spin_unlock(&dentry->d_lock);
 		cpu_relax();
@@ -288,7 +287,8 @@ relock:
 	else
 		parent = dentry->d_parent;
 	if (parent && !spin_trylock(&parent->d_lock)) {
-		spin_unlock(&dcache_inode_lock);
+		if (inode)
+			spin_unlock(&inode->i_lock);
 		goto relock;
 	}
 	if (ref)
@@ -560,9 +560,9 @@ struct dentry *d_find_alias(struct inode *inode)
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
@@ -576,20 +576,20 @@ void d_prune_aliases(struct inode *inode)
 {
 	struct dentry *dentry;
 restart:
-	spin_lock(&dcache_inode_lock);
+	spin_lock(&inode->i_lock);
 	list_for_each_entry(dentry, &inode->i_dentry, d_alias) {
 		spin_lock(&dentry->d_lock);
 		if (!dentry->d_count) {
 			__dget_dlock(dentry);
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
 
@@ -1334,9 +1334,11 @@ static void __d_instantiate(struct dentry *dentry, struct inode *inode)
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
@@ -1399,9 +1401,11 @@ struct dentry *d_instantiate_unique(struct dentry *entry, struct inode *inode)
 
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
@@ -1483,10 +1487,10 @@ struct dentry *d_obtain_alias(struct inode *inode)
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
@@ -1502,7 +1506,7 @@ struct dentry *d_obtain_alias(struct inode *inode)
 	hlist_bl_add_head(&tmp->d_hash, &tmp->d_sb->s_anon);
 	__bit_spin_unlock(0, (unsigned long *)&tmp->d_sb->s_anon);
 	spin_unlock(&tmp->d_lock);
-	spin_unlock(&dcache_inode_lock);
+	spin_unlock(&inode->i_lock);
 
 	return tmp;
 
@@ -1533,18 +1537,18 @@ struct dentry *d_splice_alias(struct inode *inode, struct dentry *dentry)
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
-			/* already taking dcache_inode_lock, so d_add() by hand */
+			/* already taking inode->i_lock, so d_add() by hand */
 			__d_instantiate(dentry, inode);
-			spin_unlock(&dcache_inode_lock);
+			spin_unlock(&inode->i_lock);
 			security_d_instantiate(dentry, inode);
 			d_rehash(dentry);
 		}
@@ -1617,10 +1621,10 @@ struct dentry *d_add_ci(struct dentry *dentry, struct inode *inode,
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
@@ -1631,7 +1635,7 @@ struct dentry *d_add_ci(struct dentry *dentry, struct inode *inode,
 	 */
 	new = list_entry(inode->i_dentry.next, struct dentry, d_alias);
 	__dget(new);
-	spin_unlock(&dcache_inode_lock);
+	spin_unlock(&inode->i_lock);
 	security_d_instantiate(found, inode);
 	d_move(new, found);
 	iput(inode);
@@ -1951,15 +1955,17 @@ EXPORT_SYMBOL(d_validate);
  
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
@@ -2181,13 +2187,13 @@ struct dentry *d_ancestor(struct dentry *p1, struct dentry *p2)
  * This helper attempts to cope with remotely renamed directories
  *
  * It assumes that the caller is already holding
- * dentry->d_parent->d_inode->i_mutex and the dcache_inode_lock
+ * dentry->d_parent->d_inode->i_mutex and the inode->i_lock
  *
  * Note: If ever the locking in lock_rename() changes, then please
  * remember to update this too...
  */
-static struct dentry *__d_unalias(struct dentry *dentry, struct dentry *alias)
-	__releases(dcache_inode_lock)
+static struct dentry *__d_unalias(struct inode *inode,
+		struct dentry *dentry, struct dentry *alias)
 {
 	struct mutex *m1 = NULL, *m2 = NULL;
 	struct dentry *ret;
@@ -2213,7 +2219,7 @@ out_unalias:
 	d_move(alias, dentry);
 	ret = alias;
 out_err:
-	spin_unlock(&dcache_inode_lock);
+	spin_unlock(&inode->i_lock);
 	if (m2)
 		mutex_unlock(m2);
 	if (m1)
@@ -2291,7 +2297,7 @@ struct dentry *d_materialise_unique(struct dentry *dentry, struct inode *inode)
 		goto out_nolock;
 	}
 
-	spin_lock(&dcache_inode_lock);
+	spin_lock(&inode->i_lock);
 
 	if (S_ISDIR(inode->i_mode)) {
 		struct dentry *alias;
@@ -2313,7 +2319,7 @@ struct dentry *d_materialise_unique(struct dentry *dentry, struct inode *inode)
 				goto found;
 			}
 			/* Nope, but we must(!) avoid directory aliasing */
-			actual = __d_unalias(dentry, alias);
+			actual = __d_unalias(inode, dentry, alias);
 			if (IS_ERR(actual))
 				dput(alias);
 			goto out_nolock;
@@ -2331,7 +2337,7 @@ struct dentry *d_materialise_unique(struct dentry *dentry, struct inode *inode)
 found:
 	_d_rehash(actual);
 	spin_unlock(&actual->d_lock);
-	spin_unlock(&dcache_inode_lock);
+	spin_unlock(&inode->i_lock);
 out_nolock:
 	if (actual == dentry) {
 		security_d_instantiate(dentry, inode);
diff --git a/fs/exportfs/expfs.c b/fs/exportfs/expfs.c
index f06a940..4b68257 100644
--- a/fs/exportfs/expfs.c
+++ b/fs/exportfs/expfs.c
@@ -43,24 +43,26 @@ find_acceptable_alias(struct dentry *result,
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
 		dget(dentry);
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
diff --git a/fs/nfs/getroot.c b/fs/nfs/getroot.c
index c3a5a11..5596c6a 100644
--- a/fs/nfs/getroot.c
+++ b/fs/nfs/getroot.c
@@ -63,11 +63,11 @@ static int nfs_superblock_set_dummy_root(struct super_block *sb, struct inode *i
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
diff --git a/fs/notify/fsnotify.c b/fs/notify/fsnotify.c
index 9be6ec1..79b47cb 100644
--- a/fs/notify/fsnotify.c
+++ b/fs/notify/fsnotify.c
@@ -59,7 +59,7 @@ void __fsnotify_update_child_dentry_flags(struct inode *inode)
 	/* determine if the children should tell inode about their events */
 	watched = fsnotify_inode_watches_children(inode);
 
-	spin_lock(&dcache_inode_lock);
+	spin_lock(&inode->i_lock);
 	/* run all of the dentries associated with this inode.  Since this is a
 	 * directory, there damn well better only be one item on this list */
 	list_for_each_entry(alias, &inode->i_dentry, d_alias) {
@@ -82,7 +82,7 @@ void __fsnotify_update_child_dentry_flags(struct inode *inode)
 		}
 		spin_unlock(&alias->d_lock);
 	}
-	spin_unlock(&dcache_inode_lock);
+	spin_unlock(&inode->i_lock);
 }
 
 /* Notify this dentry's parent about a child's events. */
diff --git a/fs/ocfs2/dcache.c b/fs/ocfs2/dcache.c
index 8b26b54..b4d9421 100644
--- a/fs/ocfs2/dcache.c
+++ b/fs/ocfs2/dcache.c
@@ -169,7 +169,7 @@ struct dentry *ocfs2_find_local_alias(struct inode *inode,
 	struct list_head *p;
 	struct dentry *dentry = NULL;
 
-	spin_lock(&dcache_inode_lock);
+	spin_lock(&inode->i_lock);
 	list_for_each(p, &inode->i_dentry) {
 		dentry = list_entry(p, struct dentry, d_alias);
 
@@ -187,7 +187,7 @@ struct dentry *ocfs2_find_local_alias(struct inode *inode,
 		dentry = NULL;
 	}
 
-	spin_unlock(&dcache_inode_lock);
+	spin_unlock(&inode->i_lock);
 
 	return dentry;
 }
diff --git a/include/linux/dcache.h b/include/linux/dcache.h
index 97c2d78..8ff803b 100644
--- a/include/linux/dcache.h
+++ b/include/linux/dcache.h
@@ -193,7 +193,6 @@ struct dentry_operations {
 #define DCACHE_OP_REVALIDATE_EITHER	\
 	(DCACHE_OP_REVALIDATE|DCACHE_OP_REVALIDATE_RCU)
 
-extern spinlock_t dcache_inode_lock;
 extern seqlock_t rename_lock;
 
 /**
-- 
1.7.1

