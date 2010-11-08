Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753752Ab0KHH3v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 02:29:51 -0500
Received: from bld-mail15.adl6.internode.on.net ([150.101.137.100]:39861 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753043Ab0KHH3t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 02:29:49 -0500
From: Dave Chinner <david@fromorbit.com>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        eric.dumazet@gmail.com, paulmck@linux.vnet.ibm.com
Subject: [PATCH 4/4] fs: rcu protect inode hash lookups
Date: Mon,  8 Nov 2010 18:28:25 +1100
Message-Id: <1289201305-14866-5-git-send-email-david@fromorbit.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1289201305-14866-1-git-send-email-david@fromorbit.com>
References: <1289201305-14866-1-git-send-email-david@fromorbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Now that inodes are using RCU freeing, we can walk the hash lists
using RCU protection during lookups. Convert all the hash list
operations to use RCU-based operators and drop the inode_hash_lock
around pure lookup operations.

Because we are using SLAB_DESTROY_BY_RCU, we need to be careful
about the lockless lookups and the way we initialise the struct
inode during allocation. The inode->i_lock is the critical item we
need to avoid touching when allocating an inode, so move the
initialisation of this lock to the slab constructor so that we can
reliably use the lock even after the inode has been freed or is in
the process of being allocated or initialised.

We also need to change the order of checks during hash lookups to
validate we have an active inode before we skip it. That means we
need to revalidate the inode number and superblock after we have
checked it for being freed or unhashed under the inode->i_lock.

Finally, during traversals an inode can be freed and reallocated and
linked into a new hash chain, so an RCU safe traversal can jump to a
different chain without indication. On a cache miss we need to
validate that we ended the search on the same hash chain we started
on. Do this by converting the hash lists to the hlist_null list type
and checking the list null on walk termination.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/hfs/inode.c             |    2 +-
 fs/hfsplus/inode.c         |    2 +-
 fs/inode.c                 |  234 +++++++++++++++++++++++++++++++-------------
 fs/jfs/jfs_imap.c          |    2 +-
 include/linux/fs.h         |    5 +-
 include/linux/list_nulls.h |    7 ++
 6 files changed, 178 insertions(+), 74 deletions(-)

diff --git a/fs/hfs/inode.c b/fs/hfs/inode.c
index dffb4e9..4fcdf03 100644
--- a/fs/hfs/inode.c
+++ b/fs/hfs/inode.c
@@ -524,7 +524,7 @@ static struct dentry *hfs_file_lookup(struct inode *dir, struct dentry *dentry,
 	HFS_I(inode)->rsrc_inode = dir;
 	HFS_I(dir)->rsrc_inode = inode;
 	igrab(dir);
-	hlist_add_fake(&inode->i_hash);
+	hlist_nulls_add_fake(&inode->i_hash);
 	mark_inode_dirty(inode);
 out:
 	d_add(dentry, inode);
diff --git a/fs/hfsplus/inode.c b/fs/hfsplus/inode.c
index 8afd7e8..0167d18 100644
--- a/fs/hfsplus/inode.c
+++ b/fs/hfsplus/inode.c
@@ -211,7 +211,7 @@ static struct dentry *hfsplus_file_lookup(struct inode *dir, struct dentry *dent
 	 * appear hashed, but do not put on any lists.  hlist_del()
 	 * will work fine and require no locking.
 	 */
-	hlist_add_fake(&inode->i_hash);
+	hlist_nulls_add_fake(&inode->i_hash);
 
 	mark_inode_dirty(inode);
 out:
diff --git a/fs/inode.c b/fs/inode.c
index 5592d74..cf5180c 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -51,11 +51,12 @@
  *   inode->i_lock
  *
  * inode_hash_lock
- *   inode_sb_list_lock
- *   inode->i_lock
+ *   rcu_read_lock
+ *     inode_sb_list_lock
+ *     inode->i_lock
  *
  * iunique_lock
- *   inode_hash_lock
+ *   rcu_read_lock
  */
 
 /*
@@ -91,7 +92,7 @@
 
 static unsigned int i_hash_mask __read_mostly;
 static unsigned int i_hash_shift __read_mostly;
-static struct hlist_head *inode_hashtable __read_mostly;
+static struct hlist_nulls_head *inode_hashtable __read_mostly;
 static __cacheline_aligned_in_smp DEFINE_SPINLOCK(inode_hash_lock);
 
 /*
@@ -173,6 +174,12 @@ int proc_nr_inodes(ctl_table *table, int write,
  *
  * These are initializations that need to be done on every inode
  * allocation as the fields are not initialised by slab allocation.
+ *
+ * Because we are using SLAB_DESTROY_BY_RCU, we must not initialise fields used
+ * by list traversals to detect freed inodes here. Checks are made to i_ino,
+ * i_sb, i_hash and i_state, and are protected the i_lock field. We can
+ * overwrite the i_sb field here safely as we do not reset the i_ino or i_state
+ * fields until the inode is to be inserted into the hash. The i_state
  */
 int inode_init_always(struct super_block *sb, struct inode *inode)
 {
@@ -206,7 +213,6 @@ int inode_init_always(struct super_block *sb, struct inode *inode)
 
 	if (security_inode_alloc(inode))
 		goto out;
-	spin_lock_init(&inode->i_lock);
 	lockdep_set_class(&inode->i_lock, &sb->s_type->i_lock_key);
 
 	mutex_init(&inode->i_mutex);
@@ -286,6 +292,12 @@ void __destroy_inode(struct inode *inode)
 	if (inode->i_default_acl && inode->i_default_acl != ACL_NOT_CACHED)
 		posix_acl_release(inode->i_default_acl);
 #endif
+	/*
+	 * reset the inode number so during RCU traversals we do not match this
+	 * inode in any lookups until it is fully re-initialised again during
+	 * allocation.
+	 */
+	inode->i_ino = 0;
 	percpu_counter_dec(&nr_inodes);
 }
 EXPORT_SYMBOL(__destroy_inode);
@@ -308,7 +320,6 @@ static void destroy_inode(struct inode *inode)
 void inode_init_once(struct inode *inode)
 {
 	memset(inode, 0, sizeof(*inode));
-	INIT_HLIST_NODE(&inode->i_hash);
 	INIT_LIST_HEAD(&inode->i_dentry);
 	INIT_LIST_HEAD(&inode->i_devices);
 	INIT_LIST_HEAD(&inode->i_wb_list);
@@ -321,6 +332,7 @@ void inode_init_once(struct inode *inode)
 	INIT_RAW_PRIO_TREE_ROOT(&inode->i_data.i_mmap);
 	INIT_LIST_HEAD(&inode->i_data.i_mmap_nonlinear);
 	i_size_ordered_init(inode);
+	spin_lock_init(&inode->i_lock);
 #ifdef CONFIG_FSNOTIFY
 	INIT_HLIST_HEAD(&inode->i_fsnotify_marks);
 #endif
@@ -410,11 +422,11 @@ static unsigned long hash(struct super_block *sb, unsigned long hashval)
  */
 void __insert_inode_hash(struct inode *inode, unsigned long hashval)
 {
-	struct hlist_head *b = inode_hashtable + hash(inode->i_sb, hashval);
+	struct hlist_nulls_head *b = inode_hashtable + hash(inode->i_sb, hashval);
 
 	spin_lock(&inode_hash_lock);
 	spin_lock(&inode->i_lock);
-	hlist_add_head(&inode->i_hash, b);
+	hlist_nulls_add_head_rcu(&inode->i_hash, b);
 	spin_unlock(&inode->i_lock);
 	spin_unlock(&inode_hash_lock);
 }
@@ -430,7 +442,7 @@ void remove_inode_hash(struct inode *inode)
 {
 	spin_lock(&inode_hash_lock);
 	spin_lock(&inode->i_lock);
-	hlist_del_init(&inode->i_hash);
+	hlist_nulls_del_init_rcu(&inode->i_hash);
 	spin_unlock(&inode->i_lock);
 	spin_unlock(&inode_hash_lock);
 }
@@ -736,32 +748,82 @@ static struct shrinker icache_shrinker = {
 };
 
 static void __wait_on_freeing_inode(struct inode *inode);
+
 /*
- * Called with the inode lock held.
+ * find_inode: look up an inode in the hash
+ *
+ * We can be called without any locks held (@locked == false) and so in this
+ * case we are relying on RCU to protect the chain traversal. As we are using
+ * SLAB_DESTROY_BY_RCU, there are several things we have to do to ensure that
+ * the inode is valid.
+ *
+ * Firstly, we do an unlocked check on the superblock and @test() so we avoid
+ * obvious mismatches. If we get a match, we then need to lock the inode and
+ * check the inode has not been freed. We do this by checking that it is still
+ * hashed and that it is not in the freeing state under the inode->i_lock. by
+ * holding the i_lock we ensure that the inode cannot be change state (i.e. be
+ * removed or added to the hash) so we can safely determine what to do with the
+ * inode.
+ *
+ * Once we have validated that it is an active inode, we need to recheck the
+ * inode matches what we are searching for, this time under the inode->i_lock.
+ * If it is a match, then we can take a reference to it, drop all locks and
+ * return it.
+ *
+ * The final wrinkle is that during traversal we can just hash chains by
+ * following an inode that has been freed and reallocated. Hence on a cache
+ * miss on an unlocked lookup, we need to check that the last inode we checked
+ * is on the same chain as we started. If we jumped chains, restart the search
+ * all over again.
  */
 static struct inode *find_inode(struct super_block *sb,
-				struct hlist_head *head,
+				struct hlist_nulls_head *head, int chain,
 				int (*test)(struct inode *, void *),
-				void *data)
+				void *data, bool locked)
 {
-	struct hlist_node *node;
+	struct hlist_nulls_node *node;
 	struct inode *inode = NULL;
 
 repeat:
-	hlist_for_each_entry(inode, node, head, i_hash) {
+	rcu_read_lock();
+	hlist_nulls_for_each_entry_rcu(inode, node, head, i_hash) {
+		/* toss obvious mismatches */
 		if (inode->i_sb != sb)
 			continue;
 		if (!test(inode, data))
 			continue;
+
+		/* ensure the inode is active */
 		spin_lock(&inode->i_lock);
+		if (inode_unhashed(inode)) {
+			spin_unlock(&inode->i_lock);
+			continue;
+		}
 		if (inode->i_state & (I_FREEING|I_WILL_FREE)) {
+			rcu_read_unlock();
+			if (locked)
+				spin_unlock(&inode_hash_lock);
 			__wait_on_freeing_inode(inode);
+			if (locked)
+				spin_lock(&inode_hash_lock);
 			goto repeat;
 		}
+
+		/* recheck that it is the inode we are looking for */
+		if (inode->i_sb != sb || !test(inode, data)) {
+			spin_unlock(&inode->i_lock);
+			continue;
+		}
 		__iget(inode);
 		spin_unlock(&inode->i_lock);
+		rcu_read_unlock();
 		return inode;
 	}
+	rcu_read_unlock();
+
+	/* cache miss - check if we jumped a chain */
+	if (get_nulls_value(node) != chain) 
+		goto repeat;
 	return NULL;
 }
 
@@ -770,26 +832,48 @@ repeat:
  * iget_locked for details.
  */
 static struct inode *find_inode_fast(struct super_block *sb,
-				struct hlist_head *head, unsigned long ino)
+				struct hlist_nulls_head *head, int chain,
+				unsigned long ino, bool locked)
 {
-	struct hlist_node *node;
+	struct hlist_nulls_node *node;
 	struct inode *inode = NULL;
 
 repeat:
-	hlist_for_each_entry(inode, node, head, i_hash) {
+	rcu_read_lock();
+	hlist_nulls_for_each_entry_rcu(inode, node, head, i_hash) {
 		if (inode->i_ino != ino)
 			continue;
 		if (inode->i_sb != sb)
 			continue;
 		spin_lock(&inode->i_lock);
+		if (inode_unhashed(inode)) {
+			spin_unlock(&inode->i_lock);
+			continue;
+		}
 		if (inode->i_state & (I_FREEING|I_WILL_FREE)) {
+			rcu_read_unlock();
+			if (locked)
+				spin_unlock(&inode_hash_lock);
 			__wait_on_freeing_inode(inode);
+			if (locked)
+				spin_lock(&inode_hash_lock);
 			goto repeat;
 		}
+		/* recheck that it is the inode we are looking for */
+		if (inode->i_sb != sb || inode->i_ino != ino) {
+			spin_unlock(&inode->i_lock);
+			continue;
+		}
 		__iget(inode);
 		spin_unlock(&inode->i_lock);
+		rcu_read_unlock();
 		return inode;
 	}
+	rcu_read_unlock();
+
+	/* cache miss - check if we jumped a chain */
+	if (get_nulls_value(node) != chain) 
+		goto repeat;
 	return NULL;
 }
 
@@ -901,7 +985,7 @@ EXPORT_SYMBOL(unlock_new_inode);
  *	-- rmk@arm.uk.linux.org
  */
 static struct inode *get_new_inode(struct super_block *sb,
-				struct hlist_head *head,
+				struct hlist_nulls_head *head, int chain,
 				int (*test)(struct inode *, void *),
 				int (*set)(struct inode *, void *),
 				void *data)
@@ -914,14 +998,14 @@ static struct inode *get_new_inode(struct super_block *sb,
 
 		spin_lock(&inode_hash_lock);
 		/* We released the lock, so.. */
-		old = find_inode(sb, head, test, data);
+		old = find_inode(sb, head, chain, test, data, true);
 		if (!old) {
 			if (set(inode, data))
 				goto set_failed;
 
 			spin_lock(&inode->i_lock);
 			inode->i_state = I_NEW;
-			hlist_add_head(&inode->i_hash, head);
+			hlist_nulls_add_head_rcu(&inode->i_hash, head);
 			spin_unlock(&inode->i_lock);
 			inode_sb_list_add(inode);
 			spin_unlock(&inode_hash_lock);
@@ -955,7 +1039,8 @@ set_failed:
  * comment at iget_locked for details.
  */
 static struct inode *get_new_inode_fast(struct super_block *sb,
-				struct hlist_head *head, unsigned long ino)
+				struct hlist_nulls_head *head, int chain,
+				unsigned long ino)
 {
 	struct inode *inode;
 
@@ -965,12 +1050,12 @@ static struct inode *get_new_inode_fast(struct super_block *sb,
 
 		spin_lock(&inode_hash_lock);
 		/* We released the lock, so.. */
-		old = find_inode_fast(sb, head, ino);
+		old = find_inode_fast(sb, head, chain, ino, true);
 		if (!old) {
 			inode->i_ino = ino;
 			spin_lock(&inode->i_lock);
 			inode->i_state = I_NEW;
-			hlist_add_head(&inode->i_hash, head);
+			hlist_nulls_add_head_rcu(&inode->i_hash, head);
 			spin_unlock(&inode->i_lock);
 			inode_sb_list_add(inode);
 			spin_unlock(&inode_hash_lock);
@@ -1003,19 +1088,32 @@ static struct inode *get_new_inode_fast(struct super_block *sb,
  */
 static int test_inode_iunique(struct super_block *sb, unsigned long ino)
 {
-	struct hlist_head *b = inode_hashtable + hash(sb, ino);
-	struct hlist_node *node;
+	int chain = hash(sb, ino);
+	struct hlist_nulls_head *b = inode_hashtable + chain;
+	struct hlist_nulls_node *node;
 	struct inode *inode;
 
-	spin_lock(&inode_hash_lock);
-	hlist_for_each_entry(inode, node, b, i_hash) {
-		if (inode->i_ino == ino && inode->i_sb == sb) {
-			spin_unlock(&inode_hash_lock);
-			return 0;
+repeat:
+	rcu_read_lock();
+	hlist_nulls_for_each_entry_rcu(inode, node, b, i_hash) {
+		if (inode->i_ino != ino)
+			continue;
+		if (inode->i_sb != sb)
+			continue;
+		spin_lock(&inode->i_lock);
+		if (inode_unhashed(inode)) {
+			spin_unlock(&inode->i_lock);
+			continue;
 		}
+		spin_unlock(&inode->i_lock);
+		rcu_read_unlock();
+		return 0;
 	}
-	spin_unlock(&inode_hash_lock);
+	rcu_read_unlock();
 
+	/* cache miss - check if we jumped a chain */
+	if (get_nulls_value(node) != chain)
+		goto repeat;
 	return 1;
 }
 
@@ -1095,20 +1193,18 @@ EXPORT_SYMBOL(igrab);
  * Note, @test is called with the inode_lock held, so can't sleep.
  */
 static struct inode *ifind(struct super_block *sb,
-		struct hlist_head *head, int (*test)(struct inode *, void *),
+		struct hlist_nulls_head *head, int chain,
+		int (*test)(struct inode *, void *),
 		void *data, const int wait)
 {
 	struct inode *inode;
 
-	spin_lock(&inode_hash_lock);
-	inode = find_inode(sb, head, test, data);
+	inode = find_inode(sb, head, chain, test, data, false);
 	if (inode) {
-		spin_unlock(&inode_hash_lock);
 		if (likely(wait))
 			wait_on_inode(inode);
 		return inode;
 	}
-	spin_unlock(&inode_hash_lock);
 	return NULL;
 }
 
@@ -1128,18 +1224,15 @@ static struct inode *ifind(struct super_block *sb,
  * Otherwise NULL is returned.
  */
 static struct inode *ifind_fast(struct super_block *sb,
-		struct hlist_head *head, unsigned long ino)
+		struct hlist_nulls_head *head, int chain, unsigned long ino)
 {
 	struct inode *inode;
 
-	spin_lock(&inode_hash_lock);
-	inode = find_inode_fast(sb, head, ino);
+	inode = find_inode_fast(sb, head, chain, ino, false);
 	if (inode) {
-		spin_unlock(&inode_hash_lock);
 		wait_on_inode(inode);
 		return inode;
 	}
-	spin_unlock(&inode_hash_lock);
 	return NULL;
 }
 
@@ -1167,9 +1260,10 @@ static struct inode *ifind_fast(struct super_block *sb,
 struct inode *ilookup5_nowait(struct super_block *sb, unsigned long hashval,
 		int (*test)(struct inode *, void *), void *data)
 {
-	struct hlist_head *head = inode_hashtable + hash(sb, hashval);
+	int chain = hash(sb, hashval);
+	struct hlist_nulls_head *head = inode_hashtable + chain;
 
-	return ifind(sb, head, test, data, 0);
+	return ifind(sb, head, chain, test, data, 0);
 }
 EXPORT_SYMBOL(ilookup5_nowait);
 
@@ -1195,9 +1289,10 @@ EXPORT_SYMBOL(ilookup5_nowait);
 struct inode *ilookup5(struct super_block *sb, unsigned long hashval,
 		int (*test)(struct inode *, void *), void *data)
 {
-	struct hlist_head *head = inode_hashtable + hash(sb, hashval);
+	int chain = hash(sb, hashval);
+	struct hlist_nulls_head *head = inode_hashtable + chain;
 
-	return ifind(sb, head, test, data, 1);
+	return ifind(sb, head, chain, test, data, 1);
 }
 EXPORT_SYMBOL(ilookup5);
 
@@ -1217,9 +1312,10 @@ EXPORT_SYMBOL(ilookup5);
  */
 struct inode *ilookup(struct super_block *sb, unsigned long ino)
 {
-	struct hlist_head *head = inode_hashtable + hash(sb, ino);
+	int chain = hash(sb, ino);
+	struct hlist_nulls_head *head = inode_hashtable + chain;
 
-	return ifind_fast(sb, head, ino);
+	return ifind_fast(sb, head, chain, ino);
 }
 EXPORT_SYMBOL(ilookup);
 
@@ -1247,17 +1343,18 @@ struct inode *iget5_locked(struct super_block *sb, unsigned long hashval,
 		int (*test)(struct inode *, void *),
 		int (*set)(struct inode *, void *), void *data)
 {
-	struct hlist_head *head = inode_hashtable + hash(sb, hashval);
+	int chain = hash(sb, hashval);
+	struct hlist_nulls_head *head = inode_hashtable + chain;
 	struct inode *inode;
 
-	inode = ifind(sb, head, test, data, 1);
+	inode = ifind(sb, head, chain, test, data, 1);
 	if (inode)
 		return inode;
 	/*
 	 * get_new_inode() will do the right thing, re-trying the search
 	 * in case it had to block at any point.
 	 */
-	return get_new_inode(sb, head, test, set, data);
+	return get_new_inode(sb, head, chain, test, set, data);
 }
 EXPORT_SYMBOL(iget5_locked);
 
@@ -1278,17 +1375,18 @@ EXPORT_SYMBOL(iget5_locked);
  */
 struct inode *iget_locked(struct super_block *sb, unsigned long ino)
 {
-	struct hlist_head *head = inode_hashtable + hash(sb, ino);
+	int chain = hash(sb, ino);
+	struct hlist_nulls_head *head = inode_hashtable + chain;
 	struct inode *inode;
 
-	inode = ifind_fast(sb, head, ino);
+	inode = ifind_fast(sb, head, chain, ino);
 	if (inode)
 		return inode;
 	/*
 	 * get_new_inode_fast() will do the right thing, re-trying the search
 	 * in case it had to block at any point.
 	 */
-	return get_new_inode_fast(sb, head, ino);
+	return get_new_inode_fast(sb, head, chain, ino);
 }
 EXPORT_SYMBOL(iget_locked);
 
@@ -1296,13 +1394,13 @@ int insert_inode_locked(struct inode *inode)
 {
 	struct super_block *sb = inode->i_sb;
 	ino_t ino = inode->i_ino;
-	struct hlist_head *head = inode_hashtable + hash(sb, ino);
+	struct hlist_nulls_head *head = inode_hashtable + hash(sb, ino);
 
 	while (1) {
-		struct hlist_node *node;
+		struct hlist_nulls_node *node;
 		struct inode *old = NULL;
 		spin_lock(&inode_hash_lock);
-		hlist_for_each_entry(old, node, head, i_hash) {
+		hlist_nulls_for_each_entry_rcu(old, node, head, i_hash) {
 			if (old->i_ino != ino)
 				continue;
 			if (old->i_sb != sb)
@@ -1314,10 +1412,10 @@ int insert_inode_locked(struct inode *inode)
 			}
 			break;
 		}
-		if (likely(!node)) {
+		if (likely(is_a_nulls(node))) {
 			spin_lock(&inode->i_lock);
 			inode->i_state |= I_NEW;
-			hlist_add_head(&inode->i_hash, head);
+			hlist_nulls_add_head_rcu(&inode->i_hash, head);
 			spin_unlock(&inode->i_lock);
 			spin_unlock(&inode_hash_lock);
 			return 0;
@@ -1339,14 +1437,14 @@ int insert_inode_locked4(struct inode *inode, unsigned long hashval,
 		int (*test)(struct inode *, void *), void *data)
 {
 	struct super_block *sb = inode->i_sb;
-	struct hlist_head *head = inode_hashtable + hash(sb, hashval);
+	struct hlist_nulls_head *head = inode_hashtable + hash(sb, hashval);
 
 	while (1) {
-		struct hlist_node *node;
+		struct hlist_nulls_node *node;
 		struct inode *old = NULL;
 
 		spin_lock(&inode_hash_lock);
-		hlist_for_each_entry(old, node, head, i_hash) {
+		hlist_nulls_for_each_entry_rcu(old, node, head, i_hash) {
 			if (old->i_sb != sb)
 				continue;
 			if (!test(old, data))
@@ -1358,10 +1456,10 @@ int insert_inode_locked4(struct inode *inode, unsigned long hashval,
 			}
 			break;
 		}
-		if (likely(!node)) {
+		if (likely(is_a_nulls(node))) {
 			spin_lock(&inode->i_lock);
 			inode->i_state |= I_NEW;
-			hlist_add_head(&inode->i_hash, head);
+			hlist_nulls_add_head_rcu(&inode->i_hash, head);
 			spin_unlock(&inode->i_lock);
 			spin_unlock(&inode_hash_lock);
 			return 0;
@@ -1647,10 +1745,8 @@ static void __wait_on_freeing_inode(struct inode *inode)
 	wq = bit_waitqueue(&inode->i_state, __I_NEW);
 	prepare_to_wait(wq, &wait.wait, TASK_UNINTERRUPTIBLE);
 	spin_unlock(&inode->i_lock);
-	spin_unlock(&inode_hash_lock);
 	schedule();
 	finish_wait(wq, &wait.wait);
-	spin_lock(&inode_hash_lock);
 }
 
 static __initdata unsigned long ihash_entries;
@@ -1678,7 +1774,7 @@ void __init inode_init_early(void)
 
 	inode_hashtable =
 		alloc_large_system_hash("Inode-cache",
-					sizeof(struct hlist_head),
+					sizeof(struct hlist_nulls_head),
 					ihash_entries,
 					14,
 					HASH_EARLY,
@@ -1687,7 +1783,7 @@ void __init inode_init_early(void)
 					0);
 
 	for (loop = 0; loop < (1 << i_hash_shift); loop++)
-		INIT_HLIST_HEAD(&inode_hashtable[loop]);
+		INIT_HLIST_NULLS_HEAD(&inode_hashtable[loop], loop);
 }
 
 void __init inode_init(void)
@@ -1709,7 +1805,7 @@ void __init inode_init(void)
 
 	inode_hashtable =
 		alloc_large_system_hash("Inode-cache",
-					sizeof(struct hlist_head),
+					sizeof(struct hlist_nulls_head),
 					ihash_entries,
 					14,
 					0,
@@ -1718,7 +1814,7 @@ void __init inode_init(void)
 					0);
 
 	for (loop = 0; loop < (1 << i_hash_shift); loop++)
-		INIT_HLIST_HEAD(&inode_hashtable[loop]);
+		INIT_HLIST_NULLS_HEAD(&inode_hashtable[loop], loop);
 }
 
 void init_special_inode(struct inode *inode, umode_t mode, dev_t rdev)
diff --git a/fs/jfs/jfs_imap.c b/fs/jfs/jfs_imap.c
index 3a09423..5586fc1 100644
--- a/fs/jfs/jfs_imap.c
+++ b/fs/jfs/jfs_imap.c
@@ -497,7 +497,7 @@ struct inode *diReadSpecial(struct super_block *sb, ino_t inum, int secondary)
 	 * appear hashed, but do not put on any lists.  hlist_del()
 	 * will work fine and require no locking.
 	 */
-	hlist_add_fake(&ip->i_hash);
+	hlist_nulls_add_fake(&ip->i_hash);
 
 	return (ip);
 }
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 0327e1f..d99fc969 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -384,6 +384,7 @@ struct inodes_stat_t {
 #include <linux/cache.h>
 #include <linux/kobject.h>
 #include <linux/list.h>
+#include <linux/rculist_nulls.h>
 #include <linux/radix-tree.h>
 #include <linux/prio_tree.h>
 #include <linux/init.h>
@@ -732,7 +733,7 @@ struct posix_acl;
 #define ACL_NOT_CACHED ((void *)(-1))
 
 struct inode {
-	struct hlist_node	i_hash;
+	struct hlist_nulls_node	i_hash;
 	struct list_head	i_wb_list;	/* backing dev IO list */
 	struct list_head	i_lru;		/* inode LRU list */
 	struct list_head	i_sb_list;
@@ -803,7 +804,7 @@ struct inode {
 
 static inline int inode_unhashed(struct inode *inode)
 {
-	return hlist_unhashed(&inode->i_hash);
+	return hlist_nulls_unhashed(&inode->i_hash);
 }
 
 /*
diff --git a/include/linux/list_nulls.h b/include/linux/list_nulls.h
index 5d10ae36..29762d1 100644
--- a/include/linux/list_nulls.h
+++ b/include/linux/list_nulls.h
@@ -83,6 +83,13 @@ static inline void hlist_nulls_del(struct hlist_nulls_node *n)
 	n->pprev = LIST_POISON2;
 }
 
+/* after that we'll appear to be on some hlist and hlist_nulls_del will work */
+static inline void hlist_nulls_add_fake(struct hlist_nulls_node *n)
+{
+	n->next = (struct hlist_nulls_node *)1UL;
+	n->pprev = &n->next;
+}
+
 /**
  * hlist_nulls_for_each_entry	- iterate over list of given type
  * @tpos:	the type * to use as a loop cursor.
-- 
1.7.2.3

