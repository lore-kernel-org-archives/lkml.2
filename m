Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755832Ab0I2MTn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 08:19:43 -0400
Received: from bld-mail15.adl6.internode.on.net ([150.101.137.100]:44321 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755655Ab0I2MTk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 08:19:40 -0400
From: Dave Chinner <david@fromorbit.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 12/17] fs: Introduce per-bucket inode hash locks
Date: Wed, 29 Sep 2010 22:18:44 +1000
Message-Id: <1285762729-17928-13-git-send-email-david@fromorbit.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1285762729-17928-1-git-send-email-david@fromorbit.com>
References: <1285762729-17928-1-git-send-email-david@fromorbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nick Piggin <npiggin@suse.de>

Now the inode_hash_lock is private, we can change the hash locking
to be more scalable. Convert the inode hash to use the new
bit-locked hash list implementation that allows per-bucket locks to
be used. This allows us to replace the global inode_hash_lock with
finer grained locking without increasing the size of the hash table.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/btrfs/inode.c        |    2 +-
 fs/fs-writeback.c       |    2 +-
 fs/hfs/hfs_fs.h         |    2 +-
 fs/hfs/inode.c          |    2 +-
 fs/hfsplus/hfsplus_fs.h |    2 +-
 fs/hfsplus/inode.c      |    2 +-
 fs/inode.c              |  198 ++++++++++++++++++++++++++---------------------
 fs/nilfs2/gcinode.c     |   22 +++---
 fs/nilfs2/segment.c     |    2 +-
 fs/nilfs2/the_nilfs.h   |    2 +-
 fs/reiserfs/xattr.c     |    2 +-
 include/linux/fs.h      |    3 +-
 mm/shmem.c              |    4 +-
 13 files changed, 135 insertions(+), 110 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index ffb8aec..7675f0c 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3860,7 +3860,7 @@ again:
 	p = &root->inode_tree.rb_node;
 	parent = NULL;
 
-	if (hlist_unhashed(&inode->i_hash))
+	if (hlist_bl_unhashed(&inode->i_hash))
 		return;
 
 	spin_lock(&root->inode_lock);
diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index dc983ea..9b63fc7 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -990,7 +990,7 @@ void __mark_inode_dirty(struct inode *inode, int flags)
 		 * dirty list.  Add blockdev inodes as well.
 		 */
 		if (!S_ISBLK(inode->i_mode)) {
-			if (hlist_unhashed(&inode->i_hash))
+			if (hlist_bl_unhashed(&inode->i_hash))
 				goto out;
 		}
 		if (inode->i_state & I_FREEING)
diff --git a/fs/hfs/hfs_fs.h b/fs/hfs/hfs_fs.h
index 4f55651..24591be 100644
--- a/fs/hfs/hfs_fs.h
+++ b/fs/hfs/hfs_fs.h
@@ -148,7 +148,7 @@ struct hfs_sb_info {
 
 	int fs_div;
 
-	struct hlist_head rsrc_inodes;
+	struct hlist_bl_head rsrc_inodes;
 };
 
 #define HFS_FLG_BITMAP_DIRTY	0
diff --git a/fs/hfs/inode.c b/fs/hfs/inode.c
index 397b7ad..7778298 100644
--- a/fs/hfs/inode.c
+++ b/fs/hfs/inode.c
@@ -524,7 +524,7 @@ static struct dentry *hfs_file_lookup(struct inode *dir, struct dentry *dentry,
 	HFS_I(inode)->rsrc_inode = dir;
 	HFS_I(dir)->rsrc_inode = inode;
 	igrab(dir);
-	hlist_add_head(&inode->i_hash, &HFS_SB(dir->i_sb)->rsrc_inodes);
+	hlist_bl_add_head(&inode->i_hash, &HFS_SB(dir->i_sb)->rsrc_inodes);
 	mark_inode_dirty(inode);
 out:
 	d_add(dentry, inode);
diff --git a/fs/hfsplus/hfsplus_fs.h b/fs/hfsplus/hfsplus_fs.h
index dc856be..499f5a5 100644
--- a/fs/hfsplus/hfsplus_fs.h
+++ b/fs/hfsplus/hfsplus_fs.h
@@ -144,7 +144,7 @@ struct hfsplus_sb_info {
 
 	unsigned long flags;
 
-	struct hlist_head rsrc_inodes;
+	struct hlist_bl_head rsrc_inodes;
 };
 
 #define HFSPLUS_SB_WRITEBACKUP	0x0001
diff --git a/fs/hfsplus/inode.c b/fs/hfsplus/inode.c
index c5a979d..b755cf0 100644
--- a/fs/hfsplus/inode.c
+++ b/fs/hfsplus/inode.c
@@ -202,7 +202,7 @@ static struct dentry *hfsplus_file_lookup(struct inode *dir, struct dentry *dent
 	HFSPLUS_I(inode).rsrc_inode = dir;
 	HFSPLUS_I(dir).rsrc_inode = inode;
 	igrab(dir);
-	hlist_add_head(&inode->i_hash, &HFSPLUS_SB(sb).rsrc_inodes);
+	hlist_bl_add_head(&inode->i_hash, &HFSPLUS_SB(sb).rsrc_inodes);
 	mark_inode_dirty(inode);
 out:
 	d_add(dentry, inode);
diff --git a/fs/inode.c b/fs/inode.c
index 24141cc..9d1a0fc 100644
--- a/fs/inode.c
+++ b/fs/inode.c
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
@@ -95,7 +96,22 @@ static unsigned int i_hash_shift __read_mostly;
 
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
@@ -105,7 +121,6 @@ static struct hlist_head *inode_hashtable __read_mostly;
  */
 DEFINE_SPINLOCK(sb_inode_list_lock);
 DEFINE_SPINLOCK(wb_inode_list_lock);
-static DEFINE_SPINLOCK(inode_hash_lock);
 
 /*
  * iprune_sem provides exclusion between the kswapd or try_to_free_pages
@@ -278,7 +293,7 @@ void destroy_inode(struct inode *inode)
 void inode_init_once(struct inode *inode)
 {
 	memset(inode, 0, sizeof(*inode));
-	INIT_HLIST_NODE(&inode->i_hash);
+	INIT_HLIST_BL_NODE(&inode->i_hash);
 	INIT_LIST_HEAD(&inode->i_dentry);
 	INIT_LIST_HEAD(&inode->i_devices);
 	INIT_RADIX_TREE(&inode->i_data.page_tree, GFP_ATOMIC);
@@ -589,20 +604,21 @@ static void __wait_on_freeing_inode(struct inode *inode);
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
@@ -610,13 +626,13 @@ repeat:
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
 
@@ -625,30 +641,32 @@ repeat:
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
 
@@ -663,7 +681,7 @@ static unsigned long hash(struct super_block *sb, unsigned long hashval)
 }
 
 static inline void
-__inode_add_to_lists(struct super_block *sb, struct hlist_head *head,
+__inode_add_to_lists(struct super_block *sb, struct inode_hash_bucket *b,
 			struct inode *inode)
 {
 	atomic_inc(&inodes_stat.nr_inodes);
@@ -672,10 +690,10 @@ __inode_add_to_lists(struct super_block *sb, struct hlist_head *head,
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
 
@@ -693,11 +711,11 @@ __inode_add_to_lists(struct super_block *sb, struct hlist_head *head,
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
@@ -779,7 +797,7 @@ EXPORT_SYMBOL(unlock_new_inode);
  *	-- rmk@arm.uk.linux.org
  */
 static struct inode *get_new_inode(struct super_block *sb,
-				struct hlist_head *head,
+				struct inode_hash_bucket *b,
 				int (*test)(struct inode *, void *),
 				int (*set)(struct inode *, void *),
 				void *data)
@@ -791,7 +809,7 @@ static struct inode *get_new_inode(struct super_block *sb,
 		struct inode *old;
 
 		/* We released the lock, so.. */
-		old = find_inode(sb, head, test, data);
+		old = find_inode(sb, b, test, data);
 		if (!old) {
 			spin_lock(&sb_inode_list_lock);
 			spin_lock(&inode->i_lock);
@@ -799,7 +817,7 @@ static struct inode *get_new_inode(struct super_block *sb,
 				goto set_failed;
 
 			inode->i_state = I_NEW;
-			__inode_add_to_lists(sb, head, inode);
+			__inode_add_to_lists(sb, b, inode);
 			spin_unlock(&inode->i_lock);
 
 			/* Return the locked inode with I_NEW set, the
@@ -833,7 +851,7 @@ set_failed:
  * comment at iget_locked for details.
  */
 static struct inode *get_new_inode_fast(struct super_block *sb,
-				struct hlist_head *head, unsigned long ino)
+				struct inode_hash_bucket *b, unsigned long ino)
 {
 	struct inode *inode;
 
@@ -842,13 +860,13 @@ static struct inode *get_new_inode_fast(struct super_block *sb,
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
@@ -871,19 +889,20 @@ static struct inode *get_new_inode_fast(struct super_block *sb,
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
 
@@ -910,7 +929,7 @@ ino_t iunique(struct super_block *sb, ino_t max_reserved)
 	 */
 	static DEFINE_SPINLOCK(unique_lock);
 	static unsigned int counter;
-	struct hlist_head *head;
+	struct inode_hash_bucket *b;
 	ino_t res;
 
 	spin_lock(&unique_lock);
@@ -918,8 +937,8 @@ ino_t iunique(struct super_block *sb, ino_t max_reserved)
 		if (counter <= max_reserved)
 			counter = max_reserved + 1;
 		res = counter++;
-		head = inode_hashtable + hash(sb, res);
-	} while (!test_inode_iunique(sb, head, res));
+		b = inode_hashtable + hash(sb, res);
+	} while (!test_inode_iunique(sb, b, res));
 	spin_unlock(&unique_lock);
 
 	return res;
@@ -967,12 +986,13 @@ EXPORT_SYMBOL(igrab);
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
@@ -999,11 +1019,12 @@ static struct inode *ifind(struct super_block *sb,
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
@@ -1037,9 +1058,9 @@ static struct inode *ifind_fast(struct super_block *sb,
 struct inode *ilookup5_nowait(struct super_block *sb, unsigned long hashval,
 		int (*test)(struct inode *, void *), void *data)
 {
-	struct hlist_head *head = inode_hashtable + hash(sb, hashval);
+	struct inode_hash_bucket *b = inode_hashtable + hash(sb, hashval);
 
-	return ifind(sb, head, test, data, 0);
+	return ifind(sb, b, test, data, 0);
 }
 EXPORT_SYMBOL(ilookup5_nowait);
 
@@ -1065,9 +1086,9 @@ EXPORT_SYMBOL(ilookup5_nowait);
 struct inode *ilookup5(struct super_block *sb, unsigned long hashval,
 		int (*test)(struct inode *, void *), void *data)
 {
-	struct hlist_head *head = inode_hashtable + hash(sb, hashval);
+	struct inode_hash_bucket *b = inode_hashtable + hash(sb, hashval);
 
-	return ifind(sb, head, test, data, 1);
+	return ifind(sb, b, test, data, 1);
 }
 EXPORT_SYMBOL(ilookup5);
 
@@ -1087,9 +1108,9 @@ EXPORT_SYMBOL(ilookup5);
  */
 struct inode *ilookup(struct super_block *sb, unsigned long ino)
 {
-	struct hlist_head *head = inode_hashtable + hash(sb, ino);
+	struct inode_hash_bucket *b = inode_hashtable + hash(sb, ino);
 
-	return ifind_fast(sb, head, ino);
+	return ifind_fast(sb, b, ino);
 }
 EXPORT_SYMBOL(ilookup);
 
@@ -1117,17 +1138,17 @@ struct inode *iget5_locked(struct super_block *sb, unsigned long hashval,
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
 
@@ -1148,17 +1169,17 @@ EXPORT_SYMBOL(iget5_locked);
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
 
@@ -1166,16 +1187,16 @@ int insert_inode_locked(struct inode *inode)
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
@@ -1183,21 +1204,21 @@ repeat:
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
@@ -1210,17 +1231,17 @@ int insert_inode_locked4(struct inode *inode, unsigned long hashval,
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
@@ -1228,21 +1249,21 @@ repeat:
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
@@ -1261,12 +1282,12 @@ EXPORT_SYMBOL(insert_inode_locked4);
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
@@ -1280,9 +1301,10 @@ EXPORT_SYMBOL(__insert_inode_hash);
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
@@ -1312,7 +1334,7 @@ EXPORT_SYMBOL(generic_delete_inode);
  */
 int generic_drop_inode(struct inode *inode)
 {
-	return !inode->i_nlink || hlist_unhashed(&inode->i_hash);
+	return !inode->i_nlink || hlist_bl_unhashed(&inode->i_hash);
 }
 EXPORT_SYMBOL_GPL(generic_drop_inode);
 
@@ -1626,7 +1648,7 @@ void __init inode_init_early(void)
 
 	inode_hashtable =
 		alloc_large_system_hash("Inode-cache",
-					sizeof(struct hlist_head),
+					sizeof(struct inode_hash_bucket),
 					ihash_entries,
 					14,
 					HASH_EARLY,
@@ -1635,7 +1657,7 @@ void __init inode_init_early(void)
 					0);
 
 	for (loop = 0; loop < (1 << i_hash_shift); loop++)
-		INIT_HLIST_HEAD(&inode_hashtable[loop]);
+		INIT_HLIST_BL_HEAD(&inode_hashtable[loop].head);
 }
 
 void __init inode_init(void)
@@ -1657,7 +1679,7 @@ void __init inode_init(void)
 
 	inode_hashtable =
 		alloc_large_system_hash("Inode-cache",
-					sizeof(struct hlist_head),
+					sizeof(struct inode_hash_bucket),
 					ihash_entries,
 					14,
 					0,
@@ -1666,7 +1688,7 @@ void __init inode_init(void)
 					0);
 
 	for (loop = 0; loop < (1 << i_hash_shift); loop++)
-		INIT_HLIST_HEAD(&inode_hashtable[loop]);
+		INIT_HLIST_BL_HEAD(&inode_hashtable[loop].head);
 }
 
 void init_special_inode(struct inode *inode, umode_t mode, dev_t rdev)
diff --git a/fs/nilfs2/gcinode.c b/fs/nilfs2/gcinode.c
index bed3a78..ce7344e 100644
--- a/fs/nilfs2/gcinode.c
+++ b/fs/nilfs2/gcinode.c
@@ -196,13 +196,13 @@ int nilfs_init_gccache(struct the_nilfs *nilfs)
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
 
@@ -254,18 +254,18 @@ static unsigned long ihash(ino_t ino, __u64 cno)
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
@@ -284,16 +284,18 @@ void nilfs_clear_gcinode(struct inode *inode)
  */
 void nilfs_remove_all_gcinode(struct the_nilfs *nilfs)
 {
-	struct hlist_head *head = nilfs->ns_gc_inodes_h;
-	struct hlist_node *node, *n;
+	struct hlist_bl_head *head = nilfs->ns_gc_inodes_h;
+	struct hlist_bl_node *node;
 	struct inode *inode;
 	int loop;
 
 	for (loop = 0; loop < NILFS_GCINODE_HASH_SIZE; loop++, head++) {
-		hlist_for_each_entry_safe(inode, node, n, head, i_hash) {
-			hlist_del_init(&inode->i_hash);
+restart:
+		hlist_bl_for_each_entry(inode, node, head, i_hash) {
+			hlist_bl_del_init(&inode->i_hash);
 			list_del_init(&NILFS_I(inode)->i_dirty);
 			nilfs_clear_gcinode(inode); /* might sleep */
+			goto restart;
 		}
 	}
 }
diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index 9fd051a..038251c 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -2452,7 +2452,7 @@ nilfs_remove_written_gcinodes(struct the_nilfs *nilfs, struct list_head *head)
 	list_for_each_entry_safe(ii, n, head, i_dirty) {
 		if (!test_bit(NILFS_I_UPDATED, &ii->i_state))
 			continue;
-		hlist_del_init(&ii->vfs_inode.i_hash);
+		hlist_bl_del_init(&ii->vfs_inode.i_hash);
 		list_del_init(&ii->i_dirty);
 		nilfs_clear_gcinode(&ii->vfs_inode);
 	}
diff --git a/fs/nilfs2/the_nilfs.h b/fs/nilfs2/the_nilfs.h
index f785a7b..1ab441a 100644
--- a/fs/nilfs2/the_nilfs.h
+++ b/fs/nilfs2/the_nilfs.h
@@ -167,7 +167,7 @@ struct the_nilfs {
 
 	/* GC inode list and hash table head */
 	struct list_head	ns_gc_inodes;
-	struct hlist_head      *ns_gc_inodes_h;
+	struct hlist_bl_head      *ns_gc_inodes_h;
 
 	/* Disk layout information (static) */
 	unsigned int		ns_blocksize_bits;
diff --git a/fs/reiserfs/xattr.c b/fs/reiserfs/xattr.c
index 8c4cf27..ea2f55c 100644
--- a/fs/reiserfs/xattr.c
+++ b/fs/reiserfs/xattr.c
@@ -424,7 +424,7 @@ int reiserfs_prepare_write(struct file *f, struct page *page,
 static void update_ctime(struct inode *inode)
 {
 	struct timespec now = current_fs_time(inode->i_sb);
-	if (hlist_unhashed(&inode->i_hash) || !inode->i_nlink ||
+	if (hlist_bl_unhashed(&inode->i_hash) || !inode->i_nlink ||
 	    timespec_equal(&inode->i_ctime, &now))
 		return;
 
diff --git a/include/linux/fs.h b/include/linux/fs.h
index da0ebf1..f06be07 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -376,6 +376,7 @@ struct files_stat_struct {
 #include <linux/capability.h>
 #include <linux/semaphore.h>
 #include <linux/fiemap.h>
+#include <linux/rculist_bl.h>
 
 #include <asm/atomic.h>
 #include <asm/byteorder.h>
@@ -722,7 +723,7 @@ struct posix_acl;
 #define ACL_NOT_CACHED ((void *)(-1))
 
 struct inode {
-	struct hlist_node	i_hash;
+	struct hlist_bl_node	i_hash;
 	struct list_head	i_list;		/* backing dev IO list */
 	struct list_head	i_sb_list;
 	struct list_head	i_dentry;
diff --git a/mm/shmem.c b/mm/shmem.c
index 56229bb..b83b442 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2148,7 +2148,7 @@ static int shmem_encode_fh(struct dentry *dentry, __u32 *fh, int *len,
 	if (*len < 3)
 		return 255;
 
-	if (hlist_unhashed(&inode->i_hash)) {
+	if (hlist_bl_unhashed(&inode->i_hash)) {
 		/* Unfortunately insert_inode_hash is not idempotent,
 		 * so as we hash inodes here rather than at creation
 		 * time, we need a lock to ensure we only try
@@ -2156,7 +2156,7 @@ static int shmem_encode_fh(struct dentry *dentry, __u32 *fh, int *len,
 		 */
 		static DEFINE_SPINLOCK(lock);
 		spin_lock(&lock);
-		if (hlist_unhashed(&inode->i_hash))
+		if (hlist_bl_unhashed(&inode->i_hash))
 			__insert_inode_hash(inode,
 					    inode->i_ino + inode->i_generation);
 		spin_unlock(&lock);
-- 
1.7.1

