Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933653Ab0JSD4V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 23:56:21 -0400
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:28449 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933438Ab0JSD4S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 23:56:18 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AnEFAJyxvEx5LcB2gWdsb2JhbACUbYx6FgEBFiIiwxaCd4JSBIpK
Message-Id: <20101019034657.044530600@kernel.dk>
User-Agent: quilt/0.48-1
Date: Tue, 19 Oct 2010 14:42:31 +1100
From: npiggin@kernel.dk
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [patch 15/35] fs: icache per-bucket inode hash locks
References: <20101019034216.319085068@kernel.dk>
Content-Disposition: inline; filename=fs-inode_lock-scale-9.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the global inode_hash_lock and replace it with per-hash-bucket locks.

Signed-off-by: Nick Piggin <npiggin@kernel.dk>

---
 fs/btrfs/inode.c        |    2 
 fs/fs-writeback.c       |    2 
 fs/hfs/hfs_fs.h         |    2 
 fs/hfs/inode.c          |    2 
 fs/hfsplus/hfsplus_fs.h |    2 
 fs/hfsplus/inode.c      |    2 
 fs/inode.c              |  189 ++++++++++++++++++++++++++----------------------
 fs/nilfs2/gcinode.c     |   21 ++---
 fs/nilfs2/segment.c     |    2 
 fs/nilfs2/the_nilfs.h   |    2 
 fs/reiserfs/xattr.c     |    2 
 include/linux/fs.h      |    3 
 mm/shmem.c              |    4 -
 13 files changed, 129 insertions(+), 106 deletions(-)

Index: linux-2.6/fs/inode.c
===================================================================
--- linux-2.6.orig/fs/inode.c	2010-10-19 14:18:59.000000000 +1100
+++ linux-2.6/fs/inode.c	2010-10-19 14:19:30.000000000 +1100
@@ -24,12 +24,13 @@
 #include <linux/mount.h>
 #include <linux/async.h>
 #include <linux/posix_acl.h>
+#include <linux/bit_spinlock.h>
 
 /*
  * Usage:
  * sb_inode_list_lock protects:
  *   s_inodes, i_sb_list
- * inode_hash_lock protects:
+ * inode_hash_bucket lock protects:
  *   inode hash table, i_hash
  * wb_inode_list_lock protects:
  *   inode_in_use, inode_unused, b_io, b_more_io, b_dirty, i_list
@@ -44,7 +45,7 @@
  * sb_inode_list_lock
  *   inode->i_lock
  *     wb_inode_list_lock
- *     inode_hash_lock
+ *     inode_hash_bucket lock
  */
 /*
  * This is needed for the following functions:
@@ -95,7 +96,22 @@
 
 LIST_HEAD(inode_in_use);
 LIST_HEAD(inode_unused);
-static struct hlist_head *inode_hashtable __read_mostly;
+
+struct inode_hash_bucket {
+	struct hlist_bl_head head;
+};
+
+static inline void spin_lock_bucket(struct inode_hash_bucket *b)
+{
+	bit_spin_lock(0, (unsigned long *)b);
+}
+
+static inline void spin_unlock_bucket(struct inode_hash_bucket *b)
+{
+	__bit_spin_unlock(0, (unsigned long *)b);
+}
+
+static struct inode_hash_bucket *inode_hashtable __read_mostly;
 
 /*
  * A simple spinlock to protect the list manipulations.
@@ -105,7 +121,6 @@
  */
 DEFINE_SPINLOCK(sb_inode_list_lock);
 DEFINE_SPINLOCK(wb_inode_list_lock);
-static DEFINE_SPINLOCK(inode_hash_lock);
 
 /*
  * iprune_sem provides exclusion between the kswapd or try_to_free_pages
@@ -281,7 +296,7 @@
 void inode_init_once(struct inode *inode)
 {
 	memset(inode, 0, sizeof(*inode));
-	INIT_HLIST_NODE(&inode->i_hash);
+	INIT_HLIST_BL_NODE(&inode->i_hash);
 	INIT_LIST_HEAD(&inode->i_dentry);
 	INIT_LIST_HEAD(&inode->i_devices);
 	INIT_RADIX_TREE(&inode->i_data.page_tree, GFP_ATOMIC);
@@ -598,20 +613,21 @@
  * add any additional branch in the common code.
  */
 static struct inode *find_inode(struct super_block *sb,
-				struct hlist_head *head,
+				struct inode_hash_bucket *b,
 				int (*test)(struct inode *, void *),
 				void *data)
 {
-	struct hlist_node *node;
+	struct hlist_bl_node *node;
 	struct inode *inode = NULL;
 
 repeat:
-	spin_lock(&inode_hash_lock);
-	hlist_for_each_entry(inode, node, head, i_hash) {
+	spin_lock_bucket(b);
+	hlist_bl_for_each_entry(inode, node, &b->head, i_hash) {
 		if (inode->i_sb != sb)
 			continue;
 		if (!spin_trylock(&inode->i_lock)) {
-			spin_unlock(&inode_hash_lock);
+			spin_unlock_bucket(b);
+			cpu_relax();
 			goto repeat;
 		}
 		if (!test(inode, data)) {
@@ -619,13 +635,13 @@
 			continue;
 		}
 		if (inode->i_state & (I_FREEING|I_WILL_FREE)) {
-			spin_unlock(&inode_hash_lock);
+			spin_unlock_bucket(b);
 			__wait_on_freeing_inode(inode);
 			goto repeat;
 		}
 		break;
 	}
-	spin_unlock(&inode_hash_lock);
+	spin_unlock_bucket(b);
 	return node ? inode : NULL;
 }
 
@@ -634,30 +650,32 @@
  * iget_locked for details.
  */
 static struct inode *find_inode_fast(struct super_block *sb,
-				struct hlist_head *head, unsigned long ino)
+				struct inode_hash_bucket *b,
+				unsigned long ino)
 {
-	struct hlist_node *node;
+	struct hlist_bl_node *node;
 	struct inode *inode = NULL;
 
 repeat:
-	spin_lock(&inode_hash_lock);
-	hlist_for_each_entry(inode, node, head, i_hash) {
+	spin_lock_bucket(b);
+	hlist_bl_for_each_entry(inode, node, &b->head, i_hash) {
 		if (inode->i_ino != ino)
 			continue;
 		if (inode->i_sb != sb)
 			continue;
 		if (!spin_trylock(&inode->i_lock)) {
-			spin_unlock(&inode_hash_lock);
+			spin_unlock_bucket(b);
+			cpu_relax();
 			goto repeat;
 		}
 		if (inode->i_state & (I_FREEING|I_WILL_FREE)) {
-			spin_unlock(&inode_hash_lock);
+			spin_unlock_bucket(b);
 			__wait_on_freeing_inode(inode);
 			goto repeat;
 		}
 		break;
 	}
-	spin_unlock(&inode_hash_lock);
+	spin_unlock_bucket(b);
 	return node ? inode : NULL;
 }
 
@@ -672,7 +690,7 @@
 }
 
 static inline void
-__inode_add_to_lists(struct super_block *sb, struct hlist_head *head,
+__inode_add_to_lists(struct super_block *sb, struct inode_hash_bucket *b,
 			struct inode *inode)
 {
 	list_add(&inode->i_sb_list, &sb->s_inodes);
@@ -680,10 +698,10 @@
 	spin_lock(&wb_inode_list_lock);
 	list_add(&inode->i_list, &inode_in_use);
 	spin_unlock(&wb_inode_list_lock);
-	if (head) {
-		spin_lock(&inode_hash_lock);
-		hlist_add_head(&inode->i_hash, head);
-		spin_unlock(&inode_hash_lock);
+	if (b) {
+		spin_lock_bucket(b);
+		hlist_bl_add_head(&inode->i_hash, &b->head);
+		spin_unlock_bucket(b);
 	}
 }
 
@@ -701,11 +719,11 @@
  */
 void inode_add_to_lists(struct super_block *sb, struct inode *inode)
 {
-	struct hlist_head *head = inode_hashtable + hash(sb, inode->i_ino);
+	struct inode_hash_bucket *b = inode_hashtable + hash(sb, inode->i_ino);
 
 	spin_lock(&sb_inode_list_lock);
 	spin_lock(&inode->i_lock);
-	__inode_add_to_lists(sb, head, inode);
+	__inode_add_to_lists(sb, b, inode);
 	spin_unlock(&inode->i_lock);
 }
 EXPORT_SYMBOL_GPL(inode_add_to_lists);
@@ -787,7 +805,7 @@
  *	-- rmk@arm.uk.linux.org
  */
 static struct inode *get_new_inode(struct super_block *sb,
-				struct hlist_head *head,
+				struct inode_hash_bucket *b,
 				int (*test)(struct inode *, void *),
 				int (*set)(struct inode *, void *),
 				void *data)
@@ -799,7 +817,7 @@
 		struct inode *old;
 
 		/* We released the lock, so.. */
-		old = find_inode(sb, head, test, data);
+		old = find_inode(sb, b, test, data);
 		if (!old) {
 			spin_lock(&sb_inode_list_lock);
 			spin_lock(&inode->i_lock);
@@ -807,7 +825,7 @@
 				goto set_failed;
 
 			inode->i_state = I_NEW;
-			__inode_add_to_lists(sb, head, inode);
+			__inode_add_to_lists(sb, b, inode);
 			spin_unlock(&inode->i_lock);
 
 			/* Return the locked inode with I_NEW set, the
@@ -841,7 +859,7 @@
  * comment at iget_locked for details.
  */
 static struct inode *get_new_inode_fast(struct super_block *sb,
-				struct hlist_head *head, unsigned long ino)
+				struct inode_hash_bucket *b, unsigned long ino)
 {
 	struct inode *inode;
 
@@ -850,13 +868,13 @@
 		struct inode *old;
 
 		/* We released the lock, so.. */
-		old = find_inode_fast(sb, head, ino);
+		old = find_inode_fast(sb, b, ino);
 		if (!old) {
 			spin_lock(&sb_inode_list_lock);
 			spin_lock(&inode->i_lock);
 			inode->i_ino = ino;
 			inode->i_state = I_NEW;
-			__inode_add_to_lists(sb, head, inode);
+			__inode_add_to_lists(sb, b, inode);
 			spin_unlock(&inode->i_lock);
 
 			/* Return the locked inode with I_NEW set, the
@@ -882,14 +900,14 @@
 /* Is the ino for this sb hashed right now? */
 static int is_ino_hashed(struct super_block *sb, unsigned long ino)
 {
-	struct hlist_node *node;
+	struct hlist_bl_node *node;
 	struct inode *inode = NULL;
-	struct hlist_head *head = inode_hashtable + hash(sb, ino);
+	struct inode_hash_bucket *b = inode_hashtable + hash(sb, ino);
 
-	spin_lock(&inode_hash_lock);
-	hlist_for_each_entry(inode, node, head, i_hash) {
+	spin_lock_bucket(b);
+	hlist_bl_for_each_entry(inode, node, &b->head, i_hash) {
 		if (inode->i_ino == ino && inode->i_sb == sb) {
-			spin_unlock(&inode_hash_lock);
+			spin_unlock_bucket(b);
 			return 0;
 		}
 		/*
@@ -898,7 +916,7 @@
 		 * skip it and get the next one.
 		 */
 	}
-	spin_unlock(&inode_hash_lock);
+	spin_unlock_bucket(b);
 	return 1;
 }
 
@@ -979,12 +997,13 @@
  * Note, @test is called with the i_lock held, so can't sleep.
  */
 static struct inode *ifind(struct super_block *sb,
-		struct hlist_head *head, int (*test)(struct inode *, void *),
+		struct inode_hash_bucket *b,
+		int (*test)(struct inode *, void *),
 		void *data, const int wait)
 {
 	struct inode *inode;
 
-	inode = find_inode(sb, head, test, data);
+	inode = find_inode(sb, b, test, data);
 	if (inode) {
 		__iget(inode);
 		spin_unlock(&inode->i_lock);
@@ -1011,11 +1030,12 @@
  * Otherwise NULL is returned.
  */
 static struct inode *ifind_fast(struct super_block *sb,
-		struct hlist_head *head, unsigned long ino)
+		struct inode_hash_bucket *b,
+		unsigned long ino)
 {
 	struct inode *inode;
 
-	inode = find_inode_fast(sb, head, ino);
+	inode = find_inode_fast(sb, b, ino);
 	if (inode) {
 		__iget(inode);
 		spin_unlock(&inode->i_lock);
@@ -1049,9 +1069,9 @@
 struct inode *ilookup5_nowait(struct super_block *sb, unsigned long hashval,
 		int (*test)(struct inode *, void *), void *data)
 {
-	struct hlist_head *head = inode_hashtable + hash(sb, hashval);
+	struct inode_hash_bucket *b = inode_hashtable + hash(sb, hashval);
 
-	return ifind(sb, head, test, data, 0);
+	return ifind(sb, b, test, data, 0);
 }
 EXPORT_SYMBOL(ilookup5_nowait);
 
@@ -1077,9 +1097,9 @@
 struct inode *ilookup5(struct super_block *sb, unsigned long hashval,
 		int (*test)(struct inode *, void *), void *data)
 {
-	struct hlist_head *head = inode_hashtable + hash(sb, hashval);
+	struct inode_hash_bucket *b = inode_hashtable + hash(sb, hashval);
 
-	return ifind(sb, head, test, data, 1);
+	return ifind(sb, b, test, data, 1);
 }
 EXPORT_SYMBOL(ilookup5);
 
@@ -1099,9 +1119,9 @@
  */
 struct inode *ilookup(struct super_block *sb, unsigned long ino)
 {
-	struct hlist_head *head = inode_hashtable + hash(sb, ino);
+	struct inode_hash_bucket *b = inode_hashtable + hash(sb, ino);
 
-	return ifind_fast(sb, head, ino);
+	return ifind_fast(sb, b, ino);
 }
 EXPORT_SYMBOL(ilookup);
 
@@ -1129,17 +1149,17 @@
 		int (*test)(struct inode *, void *),
 		int (*set)(struct inode *, void *), void *data)
 {
-	struct hlist_head *head = inode_hashtable + hash(sb, hashval);
+	struct inode_hash_bucket *b = inode_hashtable + hash(sb, hashval);
 	struct inode *inode;
 
-	inode = ifind(sb, head, test, data, 1);
+	inode = ifind(sb, b, test, data, 1);
 	if (inode)
 		return inode;
 	/*
 	 * get_new_inode() will do the right thing, re-trying the search
 	 * in case it had to block at any point.
 	 */
-	return get_new_inode(sb, head, test, set, data);
+	return get_new_inode(sb, b, test, set, data);
 }
 EXPORT_SYMBOL(iget5_locked);
 
@@ -1160,17 +1180,17 @@
  */
 struct inode *iget_locked(struct super_block *sb, unsigned long ino)
 {
-	struct hlist_head *head = inode_hashtable + hash(sb, ino);
+	struct inode_hash_bucket *b = inode_hashtable + hash(sb, ino);
 	struct inode *inode;
 
-	inode = ifind_fast(sb, head, ino);
+	inode = ifind_fast(sb, b, ino);
 	if (inode)
 		return inode;
 	/*
 	 * get_new_inode_fast() will do the right thing, re-trying the search
 	 * in case it had to block at any point.
 	 */
-	return get_new_inode_fast(sb, head, ino);
+	return get_new_inode_fast(sb, b, ino);
 }
 EXPORT_SYMBOL(iget_locked);
 
@@ -1178,16 +1198,16 @@
 {
 	struct super_block *sb = inode->i_sb;
 	ino_t ino = inode->i_ino;
-	struct hlist_head *head = inode_hashtable + hash(sb, ino);
+	struct inode_hash_bucket *b = inode_hashtable + hash(sb, ino);
 
 	inode->i_state |= I_NEW;
 	while (1) {
-		struct hlist_node *node;
+		struct hlist_bl_node *node;
 		struct inode *old = NULL;
 
 repeat:
-		spin_lock(&inode_hash_lock);
-		hlist_for_each_entry(old, node, head, i_hash) {
+		spin_lock_bucket(b);
+		hlist_bl_for_each_entry(old, node, &b->head, i_hash) {
 			if (old->i_ino != ino)
 				continue;
 			if (old->i_sb != sb)
@@ -1195,21 +1215,21 @@
 			if (old->i_state & (I_FREEING|I_WILL_FREE))
 				continue;
 			if (!spin_trylock(&old->i_lock)) {
-				spin_unlock(&inode_hash_lock);
+				spin_unlock_bucket(b);
 				goto repeat;
 			}
 			break;
 		}
 		if (likely(!node)) {
-			hlist_add_head(&inode->i_hash, head);
-			spin_unlock(&inode_hash_lock);
+			hlist_bl_add_head(&inode->i_hash, &b->head);
+			spin_unlock_bucket(b);
 			return 0;
 		}
-		spin_unlock(&inode_hash_lock);
+		spin_unlock_bucket(b);
 		__iget(old);
 		spin_unlock(&old->i_lock);
 		wait_on_inode(old);
-		if (unlikely(!hlist_unhashed(&old->i_hash))) {
+		if (unlikely(!hlist_bl_unhashed(&old->i_hash))) {
 			iput(old);
 			return -EBUSY;
 		}
@@ -1222,17 +1242,17 @@
 		int (*test)(struct inode *, void *), void *data)
 {
 	struct super_block *sb = inode->i_sb;
-	struct hlist_head *head = inode_hashtable + hash(sb, hashval);
+	struct inode_hash_bucket *b = inode_hashtable + hash(sb, hashval);
 
 	inode->i_state |= I_NEW;
 
 	while (1) {
-		struct hlist_node *node;
+		struct hlist_bl_node *node;
 		struct inode *old = NULL;
 
 repeat:
-		spin_lock(&inode_hash_lock);
-		hlist_for_each_entry(old, node, head, i_hash) {
+		spin_lock_bucket(b);
+		hlist_bl_for_each_entry(old, node, &b->head, i_hash) {
 			if (old->i_sb != sb)
 				continue;
 			if (!test(old, data))
@@ -1240,21 +1260,21 @@
 			if (old->i_state & (I_FREEING|I_WILL_FREE))
 				continue;
 			if (!spin_trylock(&old->i_lock)) {
-				spin_unlock(&inode_hash_lock);
+				spin_unlock_bucket(b);
 				goto repeat;
 			}
 			break;
 		}
 		if (likely(!node)) {
-			hlist_add_head(&inode->i_hash, head);
-			spin_unlock(&inode_hash_lock);
+			hlist_bl_add_head(&inode->i_hash, &b->head);
+			spin_unlock_bucket(b);
 			return 0;
 		}
-		spin_unlock(&inode_hash_lock);
+		spin_unlock_bucket(b);
 		__iget(old);
 		spin_unlock(&old->i_lock);
 		wait_on_inode(old);
-		if (unlikely(!hlist_unhashed(&old->i_hash))) {
+		if (unlikely(!hlist_bl_unhashed(&old->i_hash))) {
 			iput(old);
 			return -EBUSY;
 		}
@@ -1273,12 +1293,12 @@
  */
 void __insert_inode_hash(struct inode *inode, unsigned long hashval)
 {
-	struct hlist_head *head = inode_hashtable + hash(inode->i_sb, hashval);
+	struct inode_hash_bucket *b = inode_hashtable + hash(inode->i_sb, hashval);
 
 	spin_lock(&inode->i_lock);
-	spin_lock(&inode_hash_lock);
-	hlist_add_head(&inode->i_hash, head);
-	spin_unlock(&inode_hash_lock);
+	spin_lock_bucket(b);
+	hlist_bl_add_head(&inode->i_hash, &b->head);
+	spin_unlock_bucket(b);
 	spin_unlock(&inode->i_lock);
 }
 EXPORT_SYMBOL(__insert_inode_hash);
@@ -1292,9 +1312,10 @@
  */
 static void __remove_inode_hash(struct inode *inode)
 {
-	spin_lock(&inode_hash_lock);
-	hlist_del_init(&inode->i_hash);
-	spin_unlock(&inode_hash_lock);
+	struct inode_hash_bucket *b = inode_hashtable + hash(inode->i_sb, inode->i_ino);
+	spin_lock_bucket(b);
+	hlist_bl_del_init(&inode->i_hash);
+	spin_unlock_bucket(b);
 }
 
 /**
@@ -1324,7 +1345,7 @@
  */
 int generic_drop_inode(struct inode *inode)
 {
-	return !inode->i_nlink || hlist_unhashed(&inode->i_hash);
+	return !inode->i_nlink || hlist_bl_unhashed(&inode->i_hash);
 }
 EXPORT_SYMBOL_GPL(generic_drop_inode);
 
@@ -1636,7 +1657,7 @@
 
 	inode_hashtable =
 		alloc_large_system_hash("Inode-cache",
-					sizeof(struct hlist_head),
+					sizeof(struct inode_hash_bucket),
 					ihash_entries,
 					14,
 					HASH_EARLY,
@@ -1645,7 +1666,7 @@
 					0);
 
 	for (loop = 0; loop < (1 << i_hash_shift); loop++)
-		INIT_HLIST_HEAD(&inode_hashtable[loop]);
+		INIT_HLIST_BL_HEAD(&inode_hashtable[loop].head);
 }
 
 void __init inode_init(void)
@@ -1667,7 +1688,7 @@
 
 	inode_hashtable =
 		alloc_large_system_hash("Inode-cache",
-					sizeof(struct hlist_head),
+					sizeof(struct inode_hash_bucket),
 					ihash_entries,
 					14,
 					0,
@@ -1676,7 +1697,7 @@
 					0);
 
 	for (loop = 0; loop < (1 << i_hash_shift); loop++)
-		INIT_HLIST_HEAD(&inode_hashtable[loop]);
+		INIT_HLIST_BL_HEAD(&inode_hashtable[loop].head);
 }
 
 void init_special_inode(struct inode *inode, umode_t mode, dev_t rdev)
Index: linux-2.6/fs/fs-writeback.c
===================================================================
--- linux-2.6.orig/fs/fs-writeback.c	2010-10-19 14:18:59.000000000 +1100
+++ linux-2.6/fs/fs-writeback.c	2010-10-19 14:19:30.000000000 +1100
@@ -998,7 +998,7 @@
 		 * dirty list.  Add blockdev inodes as well.
 		 */
 		if (!S_ISBLK(inode->i_mode)) {
-			if (hlist_unhashed(&inode->i_hash))
+			if (hlist_bl_unhashed(&inode->i_hash))
 				goto out;
 		}
 		if (inode->i_state & I_FREEING)
Index: linux-2.6/include/linux/fs.h
===================================================================
--- linux-2.6.orig/include/linux/fs.h	2010-10-19 14:18:59.000000000 +1100
+++ linux-2.6/include/linux/fs.h	2010-10-19 14:19:30.000000000 +1100
@@ -380,6 +380,7 @@
 #include <linux/cache.h>
 #include <linux/kobject.h>
 #include <linux/list.h>
+#include <linux/list_bl.h>
 #include <linux/radix-tree.h>
 #include <linux/prio_tree.h>
 #include <linux/init.h>
@@ -728,7 +729,7 @@
 #define ACL_NOT_CACHED ((void *)(-1))
 
 struct inode {
-	struct hlist_node	i_hash;
+	struct hlist_bl_node	i_hash;
 	struct list_head	i_list;		/* backing dev IO list */
 	struct list_head	i_sb_list;
 	struct list_head	i_dentry;
Index: linux-2.6/mm/shmem.c
===================================================================
--- linux-2.6.orig/mm/shmem.c	2010-10-19 14:18:58.000000000 +1100
+++ linux-2.6/mm/shmem.c	2010-10-19 14:19:28.000000000 +1100
@@ -2148,7 +2148,7 @@
 	if (*len < 3)
 		return 255;
 
-	if (hlist_unhashed(&inode->i_hash)) {
+	if (hlist_bl_unhashed(&inode->i_hash)) {
 		/* Unfortunately insert_inode_hash is not idempotent,
 		 * so as we hash inodes here rather than at creation
 		 * time, we need a lock to ensure we only try
@@ -2156,7 +2156,7 @@
 		 */
 		static DEFINE_SPINLOCK(lock);
 		spin_lock(&lock);
-		if (hlist_unhashed(&inode->i_hash))
+		if (hlist_bl_unhashed(&inode->i_hash))
 			__insert_inode_hash(inode,
 					    inode->i_ino + inode->i_generation);
 		spin_unlock(&lock);
Index: linux-2.6/fs/btrfs/inode.c
===================================================================
--- linux-2.6.orig/fs/btrfs/inode.c	2010-10-19 14:18:58.000000000 +1100
+++ linux-2.6/fs/btrfs/inode.c	2010-10-19 14:19:29.000000000 +1100
@@ -3854,7 +3854,7 @@
 	p = &root->inode_tree.rb_node;
 	parent = NULL;
 
-	if (hlist_unhashed(&inode->i_hash))
+	if (hlist_bl_unhashed(&inode->i_hash))
 		return;
 
 	spin_lock(&root->inode_lock);
Index: linux-2.6/fs/reiserfs/xattr.c
===================================================================
--- linux-2.6.orig/fs/reiserfs/xattr.c	2010-10-19 14:17:22.000000000 +1100
+++ linux-2.6/fs/reiserfs/xattr.c	2010-10-19 14:18:59.000000000 +1100
@@ -424,7 +424,7 @@
 static void update_ctime(struct inode *inode)
 {
 	struct timespec now = current_fs_time(inode->i_sb);
-	if (hlist_unhashed(&inode->i_hash) || !inode->i_nlink ||
+	if (hlist_bl_unhashed(&inode->i_hash) || !inode->i_nlink ||
 	    timespec_equal(&inode->i_ctime, &now))
 		return;
 
Index: linux-2.6/fs/hfs/hfs_fs.h
===================================================================
--- linux-2.6.orig/fs/hfs/hfs_fs.h	2010-10-19 14:17:22.000000000 +1100
+++ linux-2.6/fs/hfs/hfs_fs.h	2010-10-19 14:18:59.000000000 +1100
@@ -148,7 +148,7 @@
 
 	int fs_div;
 
-	struct hlist_head rsrc_inodes;
+	struct hlist_bl_head rsrc_inodes;
 };
 
 #define HFS_FLG_BITMAP_DIRTY	0
Index: linux-2.6/fs/hfs/inode.c
===================================================================
--- linux-2.6.orig/fs/hfs/inode.c	2010-10-19 14:17:22.000000000 +1100
+++ linux-2.6/fs/hfs/inode.c	2010-10-19 14:18:59.000000000 +1100
@@ -524,7 +524,7 @@
 	HFS_I(inode)->rsrc_inode = dir;
 	HFS_I(dir)->rsrc_inode = inode;
 	igrab(dir);
-	hlist_add_head(&inode->i_hash, &HFS_SB(dir->i_sb)->rsrc_inodes);
+	hlist_bl_add_head(&inode->i_hash, &HFS_SB(dir->i_sb)->rsrc_inodes);
 	mark_inode_dirty(inode);
 out:
 	d_add(dentry, inode);
Index: linux-2.6/fs/hfsplus/hfsplus_fs.h
===================================================================
--- linux-2.6.orig/fs/hfsplus/hfsplus_fs.h	2010-10-19 14:17:22.000000000 +1100
+++ linux-2.6/fs/hfsplus/hfsplus_fs.h	2010-10-19 14:18:59.000000000 +1100
@@ -144,7 +144,7 @@
 
 	unsigned long flags;
 
-	struct hlist_head rsrc_inodes;
+	struct hlist_bl_head rsrc_inodes;
 };
 
 #define HFSPLUS_SB_WRITEBACKUP	0x0001
Index: linux-2.6/fs/hfsplus/inode.c
===================================================================
--- linux-2.6.orig/fs/hfsplus/inode.c	2010-10-19 14:17:22.000000000 +1100
+++ linux-2.6/fs/hfsplus/inode.c	2010-10-19 14:18:59.000000000 +1100
@@ -202,7 +202,7 @@
 	HFSPLUS_I(inode).rsrc_inode = dir;
 	HFSPLUS_I(dir).rsrc_inode = inode;
 	igrab(dir);
-	hlist_add_head(&inode->i_hash, &HFSPLUS_SB(sb).rsrc_inodes);
+	hlist_bl_add_head(&inode->i_hash, &HFSPLUS_SB(sb).rsrc_inodes);
 	mark_inode_dirty(inode);
 out:
 	d_add(dentry, inode);
Index: linux-2.6/fs/nilfs2/gcinode.c
===================================================================
--- linux-2.6.orig/fs/nilfs2/gcinode.c	2010-10-19 14:17:22.000000000 +1100
+++ linux-2.6/fs/nilfs2/gcinode.c	2010-10-19 14:18:59.000000000 +1100
@@ -45,6 +45,7 @@
 #include <linux/buffer_head.h>
 #include <linux/mpage.h>
 #include <linux/hash.h>
+#include <linux/list_bl.h>
 #include <linux/slab.h>
 #include <linux/swap.h>
 #include "nilfs.h"
@@ -196,13 +197,13 @@
 	INIT_LIST_HEAD(&nilfs->ns_gc_inodes);
 
 	nilfs->ns_gc_inodes_h =
-		kmalloc(sizeof(struct hlist_head) * NILFS_GCINODE_HASH_SIZE,
+		kmalloc(sizeof(struct hlist_bl_head) * NILFS_GCINODE_HASH_SIZE,
 			GFP_NOFS);
 	if (nilfs->ns_gc_inodes_h == NULL)
 		return -ENOMEM;
 
 	for (loop = 0; loop < NILFS_GCINODE_HASH_SIZE; loop++)
-		INIT_HLIST_HEAD(&nilfs->ns_gc_inodes_h[loop]);
+		INIT_HLIST_BL_HEAD(&nilfs->ns_gc_inodes_h[loop]);
 	return 0;
 }
 
@@ -254,18 +255,18 @@
  */
 struct inode *nilfs_gc_iget(struct the_nilfs *nilfs, ino_t ino, __u64 cno)
 {
-	struct hlist_head *head = nilfs->ns_gc_inodes_h + ihash(ino, cno);
-	struct hlist_node *node;
+	struct hlist_bl_head *head = nilfs->ns_gc_inodes_h + ihash(ino, cno);
+	struct hlist_bl_node *node;
 	struct inode *inode;
 
-	hlist_for_each_entry(inode, node, head, i_hash) {
+	hlist_bl_for_each_entry(inode, node, head, i_hash) {
 		if (inode->i_ino == ino && NILFS_I(inode)->i_cno == cno)
 			return inode;
 	}
 
 	inode = alloc_gcinode(nilfs, ino, cno);
 	if (likely(inode)) {
-		hlist_add_head(&inode->i_hash, head);
+		hlist_bl_add_head(&inode->i_hash, head);
 		list_add(&NILFS_I(inode)->i_dirty, &nilfs->ns_gc_inodes);
 	}
 	return inode;
@@ -284,14 +285,14 @@
  */
 void nilfs_remove_all_gcinode(struct the_nilfs *nilfs)
 {
-	struct hlist_head *head = nilfs->ns_gc_inodes_h;
-	struct hlist_node *node, *n;
+	struct hlist_bl_head *head = nilfs->ns_gc_inodes_h;
+	struct hlist_bl_node *node, *n;
 	struct inode *inode;
 	int loop;
 
 	for (loop = 0; loop < NILFS_GCINODE_HASH_SIZE; loop++, head++) {
-		hlist_for_each_entry_safe(inode, node, n, head, i_hash) {
-			hlist_del_init(&inode->i_hash);
+		hlist_bl_for_each_entry_safe(inode, node, n, head, i_hash) {
+			hlist_bl_del_init(&inode->i_hash);
 			list_del_init(&NILFS_I(inode)->i_dirty);
 			nilfs_clear_gcinode(inode); /* might sleep */
 		}
Index: linux-2.6/fs/nilfs2/segment.c
===================================================================
--- linux-2.6.orig/fs/nilfs2/segment.c	2010-10-19 14:17:22.000000000 +1100
+++ linux-2.6/fs/nilfs2/segment.c	2010-10-19 14:18:59.000000000 +1100
@@ -2452,7 +2452,7 @@
 	list_for_each_entry_safe(ii, n, head, i_dirty) {
 		if (!test_bit(NILFS_I_UPDATED, &ii->i_state))
 			continue;
-		hlist_del_init(&ii->vfs_inode.i_hash);
+		hlist_bl_del_init(&ii->vfs_inode.i_hash);
 		list_del_init(&ii->i_dirty);
 		nilfs_clear_gcinode(&ii->vfs_inode);
 	}
Index: linux-2.6/fs/nilfs2/the_nilfs.h
===================================================================
--- linux-2.6.orig/fs/nilfs2/the_nilfs.h	2010-10-19 14:17:22.000000000 +1100
+++ linux-2.6/fs/nilfs2/the_nilfs.h	2010-10-19 14:18:59.000000000 +1100
@@ -167,7 +167,7 @@
 
 	/* GC inode list and hash table head */
 	struct list_head	ns_gc_inodes;
-	struct hlist_head      *ns_gc_inodes_h;
+	struct hlist_bl_head      *ns_gc_inodes_h;
 
 	/* Disk layout information (static) */
 	unsigned int		ns_blocksize_bits;


