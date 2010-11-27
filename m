Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753151Ab0K0KaL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Nov 2010 05:30:11 -0500
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:34785 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752876Ab0K0K01 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Nov 2010 05:26:27 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAO1p8Ex5Lcx2/2dsb2JhbACjC3K9doVHBIUUhU0
Message-Id: <b97bd09189fe1e7787094792cb047c298361bd02.1290852960.git.npiggin@kernel.dk>
In-Reply-To: <cover.1290852958.git.npiggin@kernel.dk>
References: <cover.1290852958.git.npiggin@kernel.dk>
From: Nick Piggin <npiggin@kernel.dk>
Date: Sat, 27 Nov 2010 20:45:14 +1100
Subject: [PATCH 44/46] fs: dcache per-bucket dcache hash locking
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We can turn the dcache hash locking from a global dcache_hash_lock into
per-bucket locking.

Signed-off-by: Nick Piggin <npiggin@kernel.dk>
---
 fs/dcache.c            |  131 ++++++++++++++++++++++++++++++++---------------
 fs/super.c             |    3 +-
 include/linux/dcache.h |   23 ++-------
 include/linux/fs.h     |    3 +-
 4 files changed, 97 insertions(+), 63 deletions(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index 67a08d4..5e19940 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
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
@@ -74,13 +76,11 @@ int sysctl_vfs_cache_pressure __read_mostly = 100;
 EXPORT_SYMBOL_GPL(sysctl_vfs_cache_pressure);
 
 __cacheline_aligned_in_smp DEFINE_SPINLOCK(dcache_inode_lock);
-__cacheline_aligned_in_smp DEFINE_SPINLOCK(dcache_hash_lock);
 static __cacheline_aligned_in_smp DEFINE_SPINLOCK(dcache_lru_lock);
 __cacheline_aligned_in_smp DEFINE_SEQLOCK(rename_lock);
 
 EXPORT_SYMBOL(rename_lock);
 EXPORT_SYMBOL(dcache_inode_lock);
-EXPORT_SYMBOL(dcache_hash_lock);
 
 static struct kmem_cache *dentry_cache __read_mostly;
 
@@ -97,13 +97,35 @@ static struct kmem_cache *dentry_cache __read_mostly;
 
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
 static struct percpu_counter nr_dentry __cacheline_aligned_in_smp;
 static struct percpu_counter nr_dentry_unused __cacheline_aligned_in_smp;
 
@@ -138,7 +160,7 @@ static void d_free(struct dentry *dentry)
 		dentry->d_op->d_release(dentry);
 
 	/* if dentry was never inserted into hash, immediate free is OK */
-	if (hlist_unhashed(&dentry->d_hash))
+	if (hlist_bl_unhashed(&dentry->d_hash))
 		__d_free(&dentry->d_u.d_rcu);
 	else
 		call_rcu(&dentry->d_u.d_rcu, __d_free);
@@ -278,6 +300,39 @@ relock:
 	return d_kill(dentry, parent);
 }
 
+void __d_drop(struct dentry *dentry)
+{
+	if (!(dentry->d_flags & DCACHE_UNHASHED)) {
+		if (unlikely(dentry->d_flags & DCACHE_DISCONNECTED)) {
+			bit_spin_lock(0, (unsigned long *)&dentry->d_sb->s_anon);
+			dentry->d_flags |= DCACHE_UNHASHED;
+			hlist_bl_del_init(&dentry->d_hash);
+			__bit_spin_unlock(0, (unsigned long *)&dentry->d_sb->s_anon);
+		} else {
+			struct dcache_hash_bucket *b;
+			b = d_hash(dentry->d_parent, dentry->d_name.hash);
+			spin_lock_bucket(b);
+			/*
+			 * We may not actually need to put DCACHE_UNHASHED
+			 * manipulations under the hash lock, but follow
+			 * the principle of least surprise.
+			 */
+			dentry->d_flags |= DCACHE_UNHASHED;
+			hlist_bl_del_rcu(&dentry->d_hash);
+			spin_unlock_bucket(b);
+		}
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
 /* 
  * This is dput
  *
@@ -891,8 +946,8 @@ void shrink_dcache_for_umount(struct super_block *sb)
 	spin_unlock(&dentry->d_lock);
 	shrink_dcache_for_umount_subtree(dentry);
 
-	while (!hlist_empty(&sb->s_anon)) {
-		dentry = hlist_entry(sb->s_anon.first, struct dentry, d_hash);
+	while (!hlist_bl_empty(&sb->s_anon)) {
+		dentry = hlist_bl_entry(hlist_bl_first(&sb->s_anon), struct dentry, d_hash);
 		shrink_dcache_for_umount_subtree(dentry);
 	}
 }
@@ -1196,7 +1251,7 @@ struct dentry *d_alloc(struct dentry * parent, const struct qstr *name)
 	dentry->d_sb = NULL;
 	dentry->d_op = NULL;
 	dentry->d_fsdata = NULL;
-	INIT_HLIST_NODE(&dentry->d_hash);
+	INIT_HLIST_BL_NODE(&dentry->d_hash);
 	INIT_LIST_HEAD(&dentry->d_lru);
 	INIT_LIST_HEAD(&dentry->d_subdirs);
 	INIT_LIST_HEAD(&dentry->d_alias);
@@ -1387,14 +1442,6 @@ struct dentry * d_alloc_root(struct inode * root_inode)
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
@@ -1449,11 +1496,11 @@ struct dentry *d_obtain_alias(struct inode *inode)
 	tmp->d_sb = inode->i_sb;
 	tmp->d_inode = inode;
 	tmp->d_flags |= DCACHE_DISCONNECTED;
-	tmp->d_flags &= ~DCACHE_UNHASHED;
 	list_add(&tmp->d_alias, &inode->i_dentry);
-	spin_lock(&dcache_hash_lock);
-	hlist_add_head(&tmp->d_hash, &inode->i_sb->s_anon);
-	spin_unlock(&dcache_hash_lock);
+	bit_spin_lock(0, (unsigned long *)&tmp->d_sb->s_anon);
+	tmp->d_flags &= ~DCACHE_UNHASHED;
+	hlist_bl_add_head(&tmp->d_hash, &tmp->d_sb->s_anon);
+	__bit_spin_unlock(0, (unsigned long *)&tmp->d_sb->s_anon);
 	spin_unlock(&tmp->d_lock);
 	spin_unlock(&dcache_inode_lock);
 
@@ -1617,8 +1664,8 @@ struct dentry *__d_lookup_rcu(struct dentry *parent, struct qstr *name,
 	unsigned int len = name->len;
 	unsigned int hash = name->hash;
 	const unsigned char *str = name->name;
-	struct hlist_head *head = d_hash(parent,hash);
-	struct hlist_node *node;
+	struct dcache_hash_bucket *b = d_hash(parent, hash);
+	struct hlist_bl_node *node;
 	struct dentry *dentry;
 
  	/*
@@ -1641,7 +1688,7 @@ struct dentry *__d_lookup_rcu(struct dentry *parent, struct qstr *name,
 	 *
 	 * See Documentation/vfs/dcache-locking.txt for more details.
 	 */
-	hlist_for_each_entry_rcu(dentry, node, head, d_hash) {
+	hlist_bl_for_each_entry_rcu(dentry, node, &b->head, d_hash) {
 		struct inode *i;
 		const char *tname;
 		int tlen;
@@ -1754,8 +1801,8 @@ struct dentry *__d_lookup(struct dentry *parent, struct qstr *name)
 	unsigned int len = name->len;
 	unsigned int hash = name->hash;
 	const unsigned char *str = name->name;
-	struct hlist_head *head = d_hash(parent,hash);
-	struct hlist_node *node;
+	struct dcache_hash_bucket *b = d_hash(parent, hash);
+	struct hlist_bl_node *node;
 	struct dentry *found = NULL;
 	struct dentry *dentry;
 
@@ -1781,7 +1828,7 @@ struct dentry *__d_lookup(struct dentry *parent, struct qstr *name)
 	 */
 	rcu_read_lock();
 	
-	hlist_for_each_entry_rcu(dentry, node, head, d_hash) {
+	hlist_bl_for_each_entry_rcu(dentry, node, &b->head, d_hash) {
 		const char *tname;
 		int tlen;
 
@@ -1932,11 +1979,12 @@ again:
 }
 EXPORT_SYMBOL(d_delete);
 
-static void __d_rehash(struct dentry * entry, struct hlist_head *list)
+static void __d_rehash(struct dentry * entry, struct dcache_hash_bucket *b)
 {
-
+	spin_lock_bucket(b);
  	entry->d_flags &= ~DCACHE_UNHASHED;
- 	hlist_add_head_rcu(&entry->d_hash, list);
+ 	hlist_bl_add_head_rcu(&entry->d_hash, &b->head);
+	spin_unlock_bucket(b);
 }
 
 static void _d_rehash(struct dentry * entry)
@@ -1954,9 +2002,7 @@ static void _d_rehash(struct dentry * entry)
 void d_rehash(struct dentry * entry)
 {
 	spin_lock(&entry->d_lock);
-	spin_lock(&dcache_hash_lock);
 	_d_rehash(entry);
-	spin_unlock(&dcache_hash_lock);
 	spin_unlock(&entry->d_lock);
 }
 EXPORT_SYMBOL(d_rehash);
@@ -2035,6 +2081,7 @@ static void switch_names(struct dentry *dentry, struct dentry *target)
  */
 void d_move(struct dentry * dentry, struct dentry * target)
 {
+	struct dcache_hash_bucket *b;
 	if (!dentry->d_inode)
 		printk(KERN_WARNING "VFS: moving negative dcache entry\n");
 
@@ -2065,11 +2112,13 @@ void d_move(struct dentry * dentry, struct dentry * target)
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
@@ -2280,9 +2329,7 @@ struct dentry *d_materialise_unique(struct dentry *dentry, struct inode *inode)
 
 	spin_lock(&actual->d_lock);
 found:
-	spin_lock(&dcache_hash_lock);
 	_d_rehash(actual);
-	spin_unlock(&dcache_hash_lock);
 	spin_unlock(&actual->d_lock);
 	spin_unlock(&dcache_inode_lock);
 out_nolock:
@@ -2864,7 +2911,7 @@ static void __init dcache_init_early(void)
 
 	dentry_hashtable =
 		alloc_large_system_hash("Dentry cache",
-					sizeof(struct hlist_head),
+					sizeof(struct dcache_hash_bucket),
 					dhash_entries,
 					13,
 					HASH_EARLY,
@@ -2873,7 +2920,7 @@ static void __init dcache_init_early(void)
 					0);
 
 	for (loop = 0; loop < (1 << d_hash_shift); loop++)
-		INIT_HLIST_HEAD(&dentry_hashtable[loop]);
+		INIT_HLIST_BL_HEAD(&dentry_hashtable[loop].head);
 }
 
 static void __init dcache_init(void)
@@ -2899,7 +2946,7 @@ static void __init dcache_init(void)
 
 	dentry_hashtable =
 		alloc_large_system_hash("Dentry cache",
-					sizeof(struct hlist_head),
+					sizeof(struct dcache_hash_bucket),
 					dhash_entries,
 					13,
 					0,
@@ -2908,7 +2955,7 @@ static void __init dcache_init(void)
 					0);
 
 	for (loop = 0; loop < (1 << d_hash_shift); loop++)
-		INIT_HLIST_HEAD(&dentry_hashtable[loop]);
+		INIT_HLIST_BL_HEAD(&dentry_hashtable[loop].head);
 }
 
 /* SLAB cache for __getname() consumers */
diff --git a/fs/super.c b/fs/super.c
index ca69615..968ba01 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -30,6 +30,7 @@
 #include <linux/idr.h>
 #include <linux/mutex.h>
 #include <linux/backing-dev.h>
+#include <linux/rculist_bl.h>
 #include "internal.h"
 
 
@@ -71,7 +72,7 @@ static struct super_block *alloc_super(struct file_system_type *type)
 		INIT_LIST_HEAD(&s->s_files);
 #endif
 		INIT_LIST_HEAD(&s->s_instances);
-		INIT_HLIST_HEAD(&s->s_anon);
+		INIT_HLIST_BL_HEAD(&s->s_anon);
 		INIT_LIST_HEAD(&s->s_inodes);
 		INIT_LIST_HEAD(&s->s_dentry_lru);
 		init_rwsem(&s->s_umount);
diff --git a/include/linux/dcache.h b/include/linux/dcache.h
index 72f5f32..97c2d78 100644
--- a/include/linux/dcache.h
+++ b/include/linux/dcache.h
@@ -4,6 +4,7 @@
 #include <asm/atomic.h>
 #include <linux/list.h>
 #include <linux/rculist.h>
+#include <linux/rculist_bl.h>
 #include <linux/spinlock.h>
 #include <linux/seqlock.h>
 #include <linux/cache.h>
@@ -91,7 +92,7 @@ struct dentry {
 	/* RCU lookup touched fields */
 	unsigned int d_flags;		/* protected by d_lock */
 	seqcount_t d_seq;		/* per dentry seqlock */
-	struct hlist_node d_hash;	/* lookup hash list */
+	struct hlist_bl_node d_hash;	/* lookup hash list */
 	struct dentry *d_parent;	/* parent directory */
 	struct qstr d_name;
 	struct inode *d_inode;		/* Where the name belongs to - NULL is
@@ -193,7 +194,6 @@ struct dentry_operations {
 	(DCACHE_OP_REVALIDATE|DCACHE_OP_REVALIDATE_RCU)
 
 extern spinlock_t dcache_inode_lock;
-extern spinlock_t dcache_hash_lock;
 extern seqlock_t rename_lock;
 
 /**
@@ -211,23 +211,8 @@ extern seqlock_t rename_lock;
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
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 490eedd..315d0e9 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -392,6 +392,7 @@ struct inodes_stat_t {
 #include <linux/capability.h>
 #include <linux/semaphore.h>
 #include <linux/fiemap.h>
+#include <linux/rculist_bl.h>
 
 #include <asm/atomic.h>
 #include <asm/byteorder.h>
@@ -1376,7 +1377,7 @@ struct super_block {
 	const struct xattr_handler **s_xattr;
 
 	struct list_head	s_inodes;	/* all inodes */
-	struct hlist_head	s_anon;		/* anonymous dentries for (nfs) exporting */
+	struct hlist_bl_head	s_anon;		/* anonymous dentries for (nfs) exporting */
 #ifdef CONFIG_SMP
 	struct list_head __percpu *s_files;
 #else
-- 
1.7.1

