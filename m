Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754380Ab0FXDQO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 23:16:14 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36006 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754137Ab0FXDPr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 23:15:47 -0400
Message-Id: <20100624030728.615659215@suse.de>
User-Agent: quilt/0.48-4.4
Date: Thu, 24 Jun 2010 13:02:31 +1000
From: npiggin@suse.de
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: John Stultz <johnstul@us.ibm.com>, Frank Mayhar <fmayhar@google.com>
Subject: [patch 19/52] fs: dcache per-bucket dcache hash locking
References: <20100624030212.676457061@suse.de>
Content-Disposition: inline; filename=dcache-chain-hashlock.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We can turn the dcache hash locking from a global dcache_hash_lock into
per-bucket locking.

Signed-off-by: Nick Piggin <npiggin@suse.de>
---
 fs/dcache.c            |  234 +++++++++++++++++++++++++++----------------------
 fs/super.c             |    3 
 include/linux/dcache.h |   23 ----
 include/linux/fs.h     |    3 
 4 files changed, 141 insertions(+), 122 deletions(-)

Index: linux-2.6/fs/dcache.c
===================================================================
--- linux-2.6.orig/fs/dcache.c
+++ linux-2.6/fs/dcache.c
@@ -33,13 +33,15 @@
 #include <linux/bootmem.h>
 #include <linux/fs_struct.h>
 #include <linux/hardirq.h>
+#include <linux/bit_spinlock.h>
+#include <linux/rculist_bl.h>
 #include "internal.h"
 
 /*
  * Usage:
  * dcache_inode_lock protects:
  *   - i_dentry, d_alias, d_inode
- * dcache_hash_lock protects:
+ * dcache_hash_bucket lock protects:
  *   - the dcache hash table
  * dcache_lru_lock protects:
  *   - the dcache lru lists and counters
@@ -57,7 +59,7 @@
  * dcache_inode_lock
  *   dentry->d_lock
  *     dcache_lru_lock
- *     dcache_hash_lock
+ *     dcache_hash_bucket lock
  *
  * If there is an ancestor relationship:
  * dentry->d_parent->...->d_parent->d_lock
@@ -74,13 +76,11 @@ int sysctl_vfs_cache_pressure __read_mos
 EXPORT_SYMBOL_GPL(sysctl_vfs_cache_pressure);
 
 __cacheline_aligned_in_smp DEFINE_SPINLOCK(dcache_inode_lock);
-__cacheline_aligned_in_smp DEFINE_SPINLOCK(dcache_hash_lock);
 static __cacheline_aligned_in_smp DEFINE_SPINLOCK(dcache_lru_lock);
 __cacheline_aligned_in_smp DEFINE_SEQLOCK(rename_lock);
 
 EXPORT_SYMBOL(rename_lock);
 EXPORT_SYMBOL(dcache_inode_lock);
-EXPORT_SYMBOL(dcache_hash_lock);
 
 static struct kmem_cache *dentry_cache __read_mostly;
 
@@ -99,7 +99,11 @@ static struct kmem_cache *dentry_cache _
 
 static unsigned int d_hash_mask __read_mostly;
 static unsigned int d_hash_shift __read_mostly;
-static struct hlist_head *dentry_hashtable __read_mostly;
+
+struct dcache_hash_bucket {
+	struct hlist_bl_head head;
+};
+static struct dcache_hash_bucket *dentry_hashtable __read_mostly;
 
 /* Statistics gathering. */
 struct dentry_stat_t dentry_stat = {
@@ -107,6 +111,24 @@ struct dentry_stat_t dentry_stat = {
 	.age_limit = 45,
 };
 
+static inline struct dcache_hash_bucket *d_hash(struct dentry *parent,
+					unsigned long hash)
+{
+	hash += ((unsigned long) parent ^ GOLDEN_RATIO_PRIME) / L1_CACHE_BYTES;
+	hash = hash ^ ((hash ^ GOLDEN_RATIO_PRIME) >> D_HASHBITS);
+	return dentry_hashtable + (hash & D_HASHMASK);
+}
+
+static inline void spin_lock_bucket(struct dcache_hash_bucket *b)
+{
+	bit_spin_lock(0, (unsigned long *)b);
+}
+
+static inline void spin_unlock_bucket(struct dcache_hash_bucket *b)
+{
+	__bit_spin_unlock(0, (unsigned long *)b);
+}
+
 static void __d_free(struct dentry *dentry)
 {
 	WARN_ON(!list_empty(&dentry->d_alias));
@@ -131,7 +153,7 @@ static void d_free(struct dentry *dentry
 	if (dentry->d_op && dentry->d_op->d_release)
 		dentry->d_op->d_release(dentry);
 	/* if dentry was never inserted into hash, immediate free is OK */
-	if (hlist_unhashed(&dentry->d_hash))
+	if (hlist_bl_unhashed(&dentry->d_hash))
 		__d_free(dentry);
 	else
 		call_rcu(&dentry->d_u.d_rcu, d_callback);
@@ -247,6 +269,81 @@ static struct dentry *d_kill(struct dent
 	return parent;
 }
 
+void __d_drop(struct dentry *dentry)
+{
+	if (!(dentry->d_flags & DCACHE_UNHASHED)) {
+		struct dcache_hash_bucket *b;
+		b = d_hash(dentry->d_parent, dentry->d_name.hash);
+		/* XXX: put unhashed inside hash lock? (don't need to actually) */
+		dentry->d_flags |= DCACHE_UNHASHED;
+		spin_lock_bucket(b);
+		hlist_bl_del_rcu(&dentry->d_hash);
+		spin_unlock_bucket(b);
+	}
+}
+EXPORT_SYMBOL(__d_drop);
+
+void d_drop(struct dentry *dentry)
+{
+	spin_lock(&dentry->d_lock);
+ 	__d_drop(dentry);
+	spin_unlock(&dentry->d_lock);
+}
+EXPORT_SYMBOL(d_drop);
+
+/* This must be called with d_lock held */
+static inline struct dentry * __dget_locked_dlock(struct dentry *dentry)
+{
+	dentry->d_count++;
+	dentry_lru_del_init(dentry);
+	return dentry;
+}
+
+static inline struct dentry * __dget_locked(struct dentry *dentry)
+{
+	spin_lock(&dentry->d_lock);
+	__dget_locked_dlock(dentry);
+	spin_unlock(&dentry->d_lock);
+	return dentry;
+}
+
+struct dentry * dget_locked_dlock(struct dentry *dentry)
+{
+	return __dget_locked_dlock(dentry);
+}
+
+struct dentry * dget_locked(struct dentry *dentry)
+{
+	return __dget_locked(dentry);
+}
+EXPORT_SYMBOL(dget_locked);
+
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
 /* 
  * This is dput
  *
@@ -398,60 +495,6 @@ int d_invalidate(struct dentry * dentry)
 }
 EXPORT_SYMBOL(d_invalidate);
 
-/* This must be called with d_lock held */
-static inline struct dentry * __dget_locked_dlock(struct dentry *dentry)
-{
-	dentry->d_count++;
-	dentry_lru_del_init(dentry);
-	return dentry;
-}
-
-/* This must be called with d_lock held */
-static inline struct dentry * __dget_locked(struct dentry *dentry)
-{
-	spin_lock(&dentry->d_lock);
-	__dget_locked_dlock(dentry);
-	spin_unlock(&dentry->d_lock);
-	return dentry;
-}
-
-struct dentry * dget_locked_dlock(struct dentry *dentry)
-{
-	return __dget_locked_dlock(dentry);
-}
-
-struct dentry * dget_locked(struct dentry *dentry)
-{
-	return __dget_locked(dentry);
-}
-EXPORT_SYMBOL(dget_locked);
-
-struct dentry *dget_parent(struct dentry *dentry)
-{
-	struct dentry *ret;
-
-repeat:
-	spin_lock(&dentry->d_lock);
-	ret = dentry->d_parent;
-	if (!ret)
-		goto out;
-	if (dentry == ret) {
-		ret->d_count++;
-		goto out;
-	}
-	if (!spin_trylock(&ret->d_lock)) {
-		spin_unlock(&dentry->d_lock);
-		goto repeat;
-	}
-	BUG_ON(!ret->d_count);
-	ret->d_count++;
-	spin_unlock(&ret->d_lock);
-out:
-	spin_unlock(&dentry->d_lock);
-	return ret;
-}
-EXPORT_SYMBOL(dget_parent);
-
 /**
  * d_find_alias - grab a hashed alias of inode
  * @inode: inode in question
@@ -900,8 +943,8 @@ void shrink_dcache_for_umount(struct sup
 	spin_unlock(&dentry->d_lock);
 	shrink_dcache_for_umount_subtree(dentry);
 
-	while (!hlist_empty(&sb->s_anon)) {
-		dentry = hlist_entry(sb->s_anon.first, struct dentry, d_hash);
+	while (!hlist_bl_empty(&sb->s_anon)) {
+		dentry = hlist_bl_entry(hlist_bl_first(&sb->s_anon), struct dentry, d_hash);
 		shrink_dcache_for_umount_subtree(dentry);
 	}
 }
@@ -1183,7 +1226,7 @@ struct dentry *d_alloc(struct dentry * p
 	dentry->d_op = NULL;
 	dentry->d_fsdata = NULL;
 	dentry->d_mounted = 0;
-	INIT_HLIST_NODE(&dentry->d_hash);
+	INIT_HLIST_BL_NODE(&dentry->d_hash);
 	INIT_LIST_HEAD(&dentry->d_lru);
 	INIT_LIST_HEAD(&dentry->d_subdirs);
 	INIT_LIST_HEAD(&dentry->d_alias);
@@ -1348,14 +1391,6 @@ struct dentry * d_alloc_root(struct inod
 }
 EXPORT_SYMBOL(d_alloc_root);
 
-static inline struct hlist_head *d_hash(struct dentry *parent,
-					unsigned long hash)
-{
-	hash += ((unsigned long) parent ^ GOLDEN_RATIO_PRIME) / L1_CACHE_BYTES;
-	hash = hash ^ ((hash ^ GOLDEN_RATIO_PRIME) >> D_HASHBITS);
-	return dentry_hashtable + (hash & D_HASHMASK);
-}
-
 /**
  * d_obtain_alias - find or allocate a dentry for a given inode
  * @inode: inode to allocate the dentry for
@@ -1411,7 +1446,7 @@ struct dentry *d_obtain_alias(struct ino
 	tmp->d_flags |= DCACHE_DISCONNECTED;
 	tmp->d_flags &= ~DCACHE_UNHASHED;
 	list_add(&tmp->d_alias, &inode->i_dentry);
-	hlist_add_head(&tmp->d_hash, &inode->i_sb->s_anon);
+	hlist_bl_add_head(&tmp->d_hash, &inode->i_sb->s_anon); /* XXX: make s_anon a bl list */
 	spin_unlock(&tmp->d_lock);
 	spin_unlock(&dcache_inode_lock);
 
@@ -1604,14 +1639,14 @@ struct dentry * __d_lookup(struct dentry
 	unsigned int len = name->len;
 	unsigned int hash = name->hash;
 	const unsigned char *str = name->name;
-	struct hlist_head *head = d_hash(parent,hash);
+	struct dcache_hash_bucket *b = d_hash(parent, hash);
+	struct hlist_bl_node *node;
 	struct dentry *found = NULL;
-	struct hlist_node *node;
 	struct dentry *dentry;
 
 	rcu_read_lock();
 	
-	hlist_for_each_entry_rcu(dentry, node, head, d_hash) {
+	hlist_bl_for_each_entry_rcu(dentry, node, &b->head, d_hash) {
 		struct qstr *qstr;
 
 		if (dentry->d_name.hash != hash)
@@ -1698,8 +1733,9 @@ out:
  
 int d_validate(struct dentry *dentry, struct dentry *dparent)
 {
-	struct hlist_head *base;
-	struct hlist_node *lhp;
+	struct dcache_hash_bucket *b;
+	struct dentry *lhp;
+	struct hlist_bl_node *node;
 
 	/* Check whether the ptr might be valid at all.. */
 	if (!kmem_ptr_validate(dentry_cache, dentry))
@@ -1709,20 +1745,17 @@ int d_validate(struct dentry *dentry, st
 		goto out;
 
 	spin_lock(&dentry->d_lock);
-	spin_lock(&dcache_hash_lock);
-	base = d_hash(dparent, dentry->d_name.hash);
-	hlist_for_each(lhp,base) { 
-		/* hlist_for_each_entry_rcu() not required for d_hash list
-		 * as it is parsed under dcache_hash_lock
-		 */
-		if (dentry == hlist_entry(lhp, struct dentry, d_hash)) {
-			spin_unlock(&dcache_hash_lock);
+	b = d_hash(dparent, dentry->d_name.hash);
+	rcu_read_lock();
+	hlist_bl_for_each_entry_rcu(lhp, node, &b->head, d_hash) {
+		if (dentry == lhp) {
+			rcu_read_unlock();
 			__dget_locked_dlock(dentry);
 			spin_unlock(&dentry->d_lock);
 			return 1;
 		}
 	}
-	spin_unlock(&dcache_hash_lock);
+	rcu_read_unlock();
 	spin_unlock(&dentry->d_lock);
 out:
 	return 0;
@@ -1776,11 +1809,12 @@ void d_delete(struct dentry * dentry)
 }
 EXPORT_SYMBOL(d_delete);
 
-static void __d_rehash(struct dentry * entry, struct hlist_head *list)
+static void __d_rehash(struct dentry * entry, struct dcache_hash_bucket *b)
 {
-
  	entry->d_flags &= ~DCACHE_UNHASHED;
- 	hlist_add_head_rcu(&entry->d_hash, list);
+	spin_lock_bucket(b);
+ 	hlist_bl_add_head_rcu(&entry->d_hash, &b->head);
+	spin_unlock_bucket(b);
 }
 
 static void _d_rehash(struct dentry * entry)
@@ -1798,9 +1832,7 @@ static void _d_rehash(struct dentry * en
 void d_rehash(struct dentry * entry)
 {
 	spin_lock(&entry->d_lock);
-	spin_lock(&dcache_hash_lock);
 	_d_rehash(entry);
-	spin_unlock(&dcache_hash_lock);
 	spin_unlock(&entry->d_lock);
 }
 EXPORT_SYMBOL(d_rehash);
@@ -1879,6 +1911,7 @@ static void switch_names(struct dentry *
  */
 static void d_move_locked(struct dentry * dentry, struct dentry * target)
 {
+	struct dcache_hash_bucket *b;
 	if (!dentry->d_inode)
 		printk(KERN_WARNING "VFS: moving negative dcache entry\n");
 
@@ -1909,11 +1942,13 @@ static void d_move_locked(struct dentry
 	}
 
 	/* Move the dentry to the target hash queue, if on different bucket */
-	spin_lock(&dcache_hash_lock);
-	if (!d_unhashed(dentry))
-		hlist_del_rcu(&dentry->d_hash);
+	if (!d_unhashed(dentry)) {
+		b = d_hash(dentry->d_parent, dentry->d_name.hash);
+		spin_lock_bucket(b);
+		hlist_bl_del_rcu(&dentry->d_hash);
+		spin_unlock_bucket(b);
+	}
 	__d_rehash(dentry, d_hash(target->d_parent, target->d_name.hash));
-	spin_unlock(&dcache_hash_lock);
 
 	/* Unhash the target: dput() will then get rid of it */
 	__d_drop(target);
@@ -2121,9 +2156,7 @@ struct dentry *d_materialise_unique(stru
 found_lock:
 	spin_lock(&actual->d_lock);
 found:
-	spin_lock(&dcache_hash_lock);
 	_d_rehash(actual);
-	spin_unlock(&dcache_hash_lock);
 	spin_unlock(&actual->d_lock);
 	spin_unlock(&dcache_inode_lock);
 out_nolock:
@@ -2631,7 +2664,7 @@ static void __init dcache_init_early(voi
 
 	dentry_hashtable =
 		alloc_large_system_hash("Dentry cache",
-					sizeof(struct hlist_head),
+					sizeof(struct dcache_hash_bucket),
 					dhash_entries,
 					13,
 					HASH_EARLY,
@@ -2640,7 +2673,7 @@ static void __init dcache_init_early(voi
 					0);
 
 	for (loop = 0; loop < (1 << d_hash_shift); loop++)
-		INIT_HLIST_HEAD(&dentry_hashtable[loop]);
+		INIT_HLIST_BL_HEAD(&dentry_hashtable[loop].head);
 }
 
 static void __init dcache_init(void)
@@ -2663,7 +2696,7 @@ static void __init dcache_init(void)
 
 	dentry_hashtable =
 		alloc_large_system_hash("Dentry cache",
-					sizeof(struct hlist_head),
+					sizeof(struct dcache_hash_bucket),
 					dhash_entries,
 					13,
 					0,
@@ -2672,7 +2705,7 @@ static void __init dcache_init(void)
 					0);
 
 	for (loop = 0; loop < (1 << d_hash_shift); loop++)
-		INIT_HLIST_HEAD(&dentry_hashtable[loop]);
+		INIT_HLIST_BL_HEAD(&dentry_hashtable[loop].head);
 }
 
 /* SLAB cache for __getname() consumers */
Index: linux-2.6/include/linux/dcache.h
===================================================================
--- linux-2.6.orig/include/linux/dcache.h
+++ linux-2.6/include/linux/dcache.h
@@ -4,6 +4,7 @@
 #include <asm/atomic.h>
 #include <linux/list.h>
 #include <linux/rculist.h>
+#include <linux/rculist_bl.h>
 #include <linux/spinlock.h>
 #include <linux/cache.h>
 #include <linux/rcupdate.h>
@@ -97,7 +98,7 @@ struct dentry {
 	 * The next three fields are touched by __d_lookup.  Place them here
 	 * so they all fit in a cache line.
 	 */
-	struct hlist_node d_hash;	/* lookup hash list */
+	struct hlist_bl_node d_hash;	/* lookup hash list */
 	struct dentry *d_parent;	/* parent directory */
 	struct qstr d_name;
 
@@ -190,7 +191,6 @@ d_iput:		no		no       yes
 #define DCACHE_GENOCIDE		0x0200
 
 extern spinlock_t dcache_inode_lock;
-extern spinlock_t dcache_hash_lock;
 extern seqlock_t rename_lock;
 
 /**
@@ -208,23 +208,8 @@ extern seqlock_t rename_lock;
  *
  * __d_drop requires dentry->d_lock.
  */
-
-static inline void __d_drop(struct dentry *dentry)
-{
-	if (!(dentry->d_flags & DCACHE_UNHASHED)) {
-		dentry->d_flags |= DCACHE_UNHASHED;
-		spin_lock(&dcache_hash_lock);
-		hlist_del_rcu(&dentry->d_hash);
-		spin_unlock(&dcache_hash_lock);
-	}
-}
-
-static inline void d_drop(struct dentry *dentry)
-{
-	spin_lock(&dentry->d_lock);
- 	__d_drop(dentry);
-	spin_unlock(&dentry->d_lock);
-}
+void d_drop(struct dentry *dentry);
+void __d_drop(struct dentry *dentry);
 
 static inline int dname_external(struct dentry *dentry)
 {
Index: linux-2.6/fs/super.c
===================================================================
--- linux-2.6.orig/fs/super.c
+++ linux-2.6/fs/super.c
@@ -30,6 +30,7 @@
 #include <linux/idr.h>
 #include <linux/mutex.h>
 #include <linux/backing-dev.h>
+#include <linux/rculist_bl.h>
 #include "internal.h"
 
 
@@ -71,7 +72,7 @@ static struct super_block *alloc_super(s
 		INIT_LIST_HEAD(&s->s_files);
 #endif
 		INIT_LIST_HEAD(&s->s_instances);
-		INIT_HLIST_HEAD(&s->s_anon);
+		INIT_HLIST_BL_HEAD(&s->s_anon);
 		INIT_LIST_HEAD(&s->s_inodes);
 		INIT_LIST_HEAD(&s->s_dentry_lru);
 		init_rwsem(&s->s_umount);
Index: linux-2.6/include/linux/fs.h
===================================================================
--- linux-2.6.orig/include/linux/fs.h
+++ linux-2.6/include/linux/fs.h
@@ -382,6 +382,7 @@ struct inodes_stat_t {
 #include <linux/capability.h>
 #include <linux/semaphore.h>
 #include <linux/fiemap.h>
+#include <linux/rculist_bl.h>
 
 #include <asm/atomic.h>
 #include <asm/byteorder.h>
@@ -1341,7 +1342,7 @@ struct super_block {
 	const struct xattr_handler **s_xattr;
 
 	struct list_head	s_inodes;	/* all inodes */
-	struct hlist_head	s_anon;		/* anonymous dentries for (nfs) exporting */
+	struct hlist_bl_head	s_anon;		/* anonymous dentries for (nfs) exporting */
 #ifdef CONFIG_SMP
 	struct list_head __percpu *s_files;
 #else


