Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754810Ab0FXDQw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 23:16:52 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36021 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754170Ab0FXDPu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 23:15:50 -0400
Message-Id: <20100624030731.414500798@suse.de>
User-Agent: quilt/0.48-4.4
Date: Thu, 24 Jun 2010 13:02:48 +1000
From: npiggin@suse.de
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: John Stultz <johnstul@us.ibm.com>, Frank Mayhar <fmayhar@google.com>
Subject: [patch 36/52] fs: icache per-bucket inode hash locks
References: <20100624030212.676457061@suse.de>
Content-Disposition: inline; filename=fs-inode_lock-scale-9.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the global inode_hash_lock and replace it with per-hash-bucket locks.

Signed-off-by: Nick Piggin <npiggin@suse.de>
---
 fs/inode.c |  167 ++++++++++++++++++++++++++++++++-----------------------------
 1 file changed, 90 insertions(+), 77 deletions(-)

Index: linux-2.6/fs/inode.c
===================================================================
--- linux-2.6.orig/fs/inode.c
+++ linux-2.6/fs/inode.c
@@ -25,12 +25,13 @@
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
@@ -46,7 +47,7 @@
  *   sb_inode_list_lock
  *     inode->i_lock
  *       wb_inode_list_lock
- *       inode_hash_lock
+ *       inode_hash_bucket lock
  */
 /*
  * This is needed for the following functions:
@@ -97,7 +98,22 @@ static unsigned int i_hash_shift __read_
 
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
@@ -107,7 +123,6 @@ static struct hlist_head *inode_hashtabl
  */
 DEFINE_SPINLOCK(sb_inode_list_lock);
 DEFINE_SPINLOCK(wb_inode_list_lock);
-static DEFINE_SPINLOCK(inode_hash_lock);
 
 /*
  * iprune_sem provides exclusion between the kswapd or try_to_free_pages
@@ -280,7 +295,7 @@ void destroy_inode(struct inode *inode)
 void inode_init_once(struct inode *inode)
 {
 	memset(inode, 0, sizeof(*inode));
-	INIT_HLIST_NODE(&inode->i_hash);
+	INIT_HLIST_BL_NODE(&inode->i_hash);
 	INIT_LIST_HEAD(&inode->i_dentry);
 	INIT_LIST_HEAD(&inode->i_devices);
 	INIT_RADIX_TREE(&inode->i_data.page_tree, GFP_ATOMIC);
@@ -596,20 +611,21 @@ static void __wait_on_freeing_inode(stru
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
@@ -617,13 +633,13 @@ repeat:
 			continue;
 		}
 		if (inode->i_state & (I_FREEING|I_CLEAR|I_WILL_FREE)) {
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
 
@@ -632,30 +648,32 @@ repeat:
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
 		if (inode->i_state & (I_FREEING|I_CLEAR|I_WILL_FREE)) {
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
 
@@ -670,7 +688,7 @@ static unsigned long hash(struct super_b
 }
 
 static inline void
-__inode_add_to_lists(struct super_block *sb, struct hlist_head *head,
+__inode_add_to_lists(struct super_block *sb, struct inode_hash_bucket *b,
 			struct inode *inode)
 {
 	atomic_inc(&inodes_stat.nr_inodes);
@@ -679,10 +697,10 @@ __inode_add_to_lists(struct super_block
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
 
@@ -700,11 +718,11 @@ __inode_add_to_lists(struct super_block
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
@@ -786,7 +804,7 @@ EXPORT_SYMBOL(unlock_new_inode);
  *	-- rmk@arm.uk.linux.org
  */
 static struct inode *get_new_inode(struct super_block *sb,
-				struct hlist_head *head,
+				struct inode_hash_bucket *b,
 				int (*test)(struct inode *, void *),
 				int (*set)(struct inode *, void *),
 				void *data)
@@ -798,7 +816,7 @@ static struct inode *get_new_inode(struc
 		struct inode *old;
 
 		/* We released the lock, so.. */
-		old = find_inode(sb, head, test, data);
+		old = find_inode(sb, b, test, data);
 		if (!old) {
 			spin_lock(&sb_inode_list_lock);
 			spin_lock(&inode->i_lock);
@@ -806,7 +824,7 @@ static struct inode *get_new_inode(struc
 				goto set_failed;
 
 			inode->i_state = I_NEW;
-			__inode_add_to_lists(sb, head, inode);
+			__inode_add_to_lists(sb, b, inode);
 			spin_unlock(&inode->i_lock);
 
 			/* Return the locked inode with I_NEW set, the
@@ -840,7 +858,7 @@ set_failed:
  * comment at iget_locked for details.
  */
 static struct inode *get_new_inode_fast(struct super_block *sb,
-				struct hlist_head *head, unsigned long ino)
+				struct inode_hash_bucket *b, unsigned long ino)
 {
 	struct inode *inode;
 
@@ -849,13 +867,13 @@ static struct inode *get_new_inode_fast(
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
@@ -878,19 +896,20 @@ static struct inode *get_new_inode_fast(
 	return inode;
 }
 
-static int test_inode_iunique(struct super_block * sb, struct hlist_head *head, unsigned long ino)
+static int test_inode_iunique(struct super_block *sb,
+				struct inode_hash_bucket *b, unsigned long ino)
 {
-	struct hlist_node *node;
-	struct inode * inode = NULL;
+	struct hlist_bl_node *node;
+	struct inode *inode = NULL;
 
-	spin_lock(&inode_hash_lock);
-	hlist_for_each_entry(inode, node, head, i_hash) {
+	spin_lock_bucket(b);
+	hlist_bl_for_each_entry(inode, node, &b->head, i_hash) {
 		if (inode->i_ino == ino && inode->i_sb == sb) {
-			spin_unlock(&inode_hash_lock);
+			spin_unlock_bucket(b);
 			return 0;
 		}
 	}
-	spin_unlock(&inode_hash_lock);
+	spin_unlock_bucket(b);
 	return 1;
 }
 
@@ -917,7 +936,7 @@ ino_t iunique(struct super_block *sb, in
 	 */
 	static DEFINE_SPINLOCK(unique_lock);
 	static unsigned int counter;
-	struct hlist_head *head;
+	struct inode_hash_bucket *b;
 	ino_t res;
 
 	spin_lock(&unique_lock);
@@ -925,8 +944,8 @@ ino_t iunique(struct super_block *sb, in
 		if (counter <= max_reserved)
 			counter = max_reserved + 1;
 		res = counter++;
-		head = inode_hashtable + hash(sb, res);
-	} while (!test_inode_iunique(sb, head, res));
+		b = inode_hashtable + hash(sb, res);
+	} while (!test_inode_iunique(sb, b, res));
 	spin_unlock(&unique_lock);
 
 	return res;
@@ -973,12 +992,13 @@ EXPORT_SYMBOL(igrab);
  * Note, @test is called with the inode_lock held, so can't sleep.
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
@@ -1005,11 +1025,12 @@ static struct inode *ifind(struct super_
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
@@ -1043,9 +1064,9 @@ static struct inode *ifind_fast(struct s
 struct inode *ilookup5_nowait(struct super_block *sb, unsigned long hashval,
 		int (*test)(struct inode *, void *), void *data)
 {
-	struct hlist_head *head = inode_hashtable + hash(sb, hashval);
+	struct inode_hash_bucket *b = inode_hashtable + hash(sb, hashval);
 
-	return ifind(sb, head, test, data, 0);
+	return ifind(sb, b, test, data, 0);
 }
 EXPORT_SYMBOL(ilookup5_nowait);
 
@@ -1071,9 +1092,9 @@ EXPORT_SYMBOL(ilookup5_nowait);
 struct inode *ilookup5(struct super_block *sb, unsigned long hashval,
 		int (*test)(struct inode *, void *), void *data)
 {
-	struct hlist_head *head = inode_hashtable + hash(sb, hashval);
+	struct inode_hash_bucket *b = inode_hashtable + hash(sb, hashval);
 
-	return ifind(sb, head, test, data, 1);
+	return ifind(sb, b, test, data, 1);
 }
 EXPORT_SYMBOL(ilookup5);
 
@@ -1093,9 +1114,9 @@ EXPORT_SYMBOL(ilookup5);
  */
 struct inode *ilookup(struct super_block *sb, unsigned long ino)
 {
-	struct hlist_head *head = inode_hashtable + hash(sb, ino);
+	struct inode_hash_bucket *b = inode_hashtable + hash(sb, ino);
 
-	return ifind_fast(sb, head, ino);
+	return ifind_fast(sb, b, ino);
 }
 EXPORT_SYMBOL(ilookup);
 
@@ -1123,17 +1144,17 @@ struct inode *iget5_locked(struct super_
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
 
@@ -1154,17 +1175,17 @@ EXPORT_SYMBOL(iget5_locked);
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
 
@@ -1172,16 +1193,16 @@ int insert_inode_locked(struct inode *in
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
@@ -1189,21 +1210,21 @@ repeat:
 			if (old->i_state & (I_FREEING|I_CLEAR|I_WILL_FREE))
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
@@ -1216,17 +1237,17 @@ int insert_inode_locked4(struct inode *i
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
@@ -1234,21 +1255,21 @@ repeat:
 			if (old->i_state & (I_FREEING|I_CLEAR|I_WILL_FREE))
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
@@ -1267,12 +1288,12 @@ EXPORT_SYMBOL(insert_inode_locked4);
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
@@ -1286,9 +1307,10 @@ EXPORT_SYMBOL(__insert_inode_hash);
  */
 void __remove_inode_hash(struct inode *inode)
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
@@ -1370,7 +1392,7 @@ int generic_detach_inode(struct inode *i
 {
 	struct super_block *sb = inode->i_sb;
 
-	if (!hlist_unhashed(&inode->i_hash)) {
+	if (!hlist_bl_unhashed(&inode->i_hash)) {
 		if (!(inode->i_state & (I_DIRTY|I_SYNC))) {
 			spin_lock(&wb_inode_list_lock);
 			list_move(&inode->i_list, &inode_unused);
@@ -1699,7 +1721,7 @@ void __init inode_init_early(void)
 
 	inode_hashtable =
 		alloc_large_system_hash("Inode-cache",
-					sizeof(struct hlist_head),
+					sizeof(struct inode_hash_bucket),
 					ihash_entries,
 					14,
 					HASH_EARLY,
@@ -1708,7 +1730,7 @@ void __init inode_init_early(void)
 					0);
 
 	for (loop = 0; loop < (1 << i_hash_shift); loop++)
-		INIT_HLIST_HEAD(&inode_hashtable[loop]);
+		INIT_HLIST_BL_HEAD(&inode_hashtable[loop].head);
 }
 
 void __init inode_init(void)
@@ -1730,7 +1752,7 @@ void __init inode_init(void)
 
 	inode_hashtable =
 		alloc_large_system_hash("Inode-cache",
-					sizeof(struct hlist_head),
+					sizeof(struct inode_hash_bucket),
 					ihash_entries,
 					14,
 					0,
@@ -1739,7 +1761,7 @@ void __init inode_init(void)
 					0);
 
 	for (loop = 0; loop < (1 << i_hash_shift); loop++)
-		INIT_HLIST_HEAD(&inode_hashtable[loop]);
+		INIT_HLIST_BL_HEAD(&inode_hashtable[loop].head);
 }
 
 void init_special_inode(struct inode *inode, umode_t mode, dev_t rdev)
Index: linux-2.6/fs/fs-writeback.c
===================================================================
--- linux-2.6.orig/fs/fs-writeback.c
+++ linux-2.6/fs/fs-writeback.c
@@ -1147,7 +1147,7 @@ void __mark_inode_dirty(struct inode *in
 		 * dirty list.  Add blockdev inodes as well.
 		 */
 		if (!S_ISBLK(inode->i_mode)) {
-			if (hlist_unhashed(&inode->i_hash))
+			if (hlist_bl_unhashed(&inode->i_hash))
 				goto out;
 		}
 		if (inode->i_state & (I_FREEING|I_CLEAR))
Index: linux-2.6/include/linux/fs.h
===================================================================
--- linux-2.6.orig/include/linux/fs.h
+++ linux-2.6/include/linux/fs.h
@@ -723,7 +723,7 @@ struct posix_acl;
 #define ACL_NOT_CACHED ((void *)(-1))
 
 struct inode {
-	struct hlist_node	i_hash;
+	struct hlist_bl_node	i_hash;
 	struct list_head	i_list;		/* backing dev IO list */
 	struct list_head	i_sb_list;
 	struct list_head	i_dentry;
Index: linux-2.6/mm/shmem.c
===================================================================
--- linux-2.6.orig/mm/shmem.c
+++ linux-2.6/mm/shmem.c
@@ -2122,7 +2122,7 @@ static int shmem_encode_fh(struct dentry
 	if (*len < 3)
 		return 255;
 
-	if (hlist_unhashed(&inode->i_hash)) {
+	if (hlist_bl_unhashed(&inode->i_hash)) {
 		/* Unfortunately insert_inode_hash is not idempotent,
 		 * so as we hash inodes here rather than at creation
 		 * time, we need a lock to ensure we only try
@@ -2130,7 +2130,7 @@ static int shmem_encode_fh(struct dentry
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
--- linux-2.6.orig/fs/btrfs/inode.c
+++ linux-2.6/fs/btrfs/inode.c
@@ -3849,7 +3849,7 @@ again:
 	p = &root->inode_tree.rb_node;
 	parent = NULL;
 
-	if (hlist_unhashed(&inode->i_hash))
+	if (hlist_bl_unhashed(&inode->i_hash))
 		return;
 
 	spin_lock(&root->inode_lock);
Index: linux-2.6/fs/reiserfs/xattr.c
===================================================================
--- linux-2.6.orig/fs/reiserfs/xattr.c
+++ linux-2.6/fs/reiserfs/xattr.c
@@ -424,7 +424,7 @@ int reiserfs_prepare_write(struct file *
 static void update_ctime(struct inode *inode)
 {
 	struct timespec now = current_fs_time(inode->i_sb);
-	if (hlist_unhashed(&inode->i_hash) || !inode->i_nlink ||
+	if (hlist_bl_unhashed(&inode->i_hash) || !inode->i_nlink ||
 	    timespec_equal(&inode->i_ctime, &now))
 		return;
 
Index: linux-2.6/fs/hfs/hfs_fs.h
===================================================================
--- linux-2.6.orig/fs/hfs/hfs_fs.h
+++ linux-2.6/fs/hfs/hfs_fs.h
@@ -148,7 +148,7 @@ struct hfs_sb_info {
 
 	int fs_div;
 
-	struct hlist_head rsrc_inodes;
+	struct hlist_bl_head rsrc_inodes;
 };
 
 #define HFS_FLG_BITMAP_DIRTY	0
Index: linux-2.6/fs/hfs/inode.c
===================================================================
--- linux-2.6.orig/fs/hfs/inode.c
+++ linux-2.6/fs/hfs/inode.c
@@ -500,7 +500,7 @@ static struct dentry *hfs_file_lookup(st
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
--- linux-2.6.orig/fs/hfsplus/hfsplus_fs.h
+++ linux-2.6/fs/hfsplus/hfsplus_fs.h
@@ -144,7 +144,7 @@ struct hfsplus_sb_info {
 
 	unsigned long flags;
 
-	struct hlist_head rsrc_inodes;
+	struct hlist_bl_head rsrc_inodes;
 };
 
 #define HFSPLUS_SB_WRITEBACKUP	0x0001
Index: linux-2.6/fs/hfsplus/inode.c
===================================================================
--- linux-2.6.orig/fs/hfsplus/inode.c
+++ linux-2.6/fs/hfsplus/inode.c
@@ -178,7 +178,7 @@ static struct dentry *hfsplus_file_looku
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
--- linux-2.6.orig/fs/nilfs2/gcinode.c
+++ linux-2.6/fs/nilfs2/gcinode.c
@@ -187,13 +187,13 @@ int nilfs_init_gccache(struct the_nilfs
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
 
@@ -245,18 +245,18 @@ static unsigned long ihash(ino_t ino, __
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
@@ -275,14 +275,14 @@ void nilfs_clear_gcinode(struct inode *i
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
--- linux-2.6.orig/fs/nilfs2/segment.c
+++ linux-2.6/fs/nilfs2/segment.c
@@ -2447,7 +2447,7 @@ nilfs_remove_written_gcinodes(struct the
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
--- linux-2.6.orig/fs/nilfs2/the_nilfs.h
+++ linux-2.6/fs/nilfs2/the_nilfs.h
@@ -164,7 +164,7 @@ struct the_nilfs {
 
 	/* GC inode list and hash table head */
 	struct list_head	ns_gc_inodes;
-	struct hlist_head      *ns_gc_inodes_h;
+	struct hlist_bl_head      *ns_gc_inodes_h;
 
 	/* Disk layout information (static) */
 	unsigned int		ns_blocksize_bits;


