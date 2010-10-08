Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752953Ab0JHFWX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 01:22:23 -0400
Received: from bld-mail17.adl2.internode.on.net ([150.101.137.102]:60966 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752484Ab0JHFWT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 01:22:19 -0400
From: Dave Chinner <david@fromorbit.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 11/18] fs: Introduce per-bucket inode hash locks
Date: Fri,  8 Oct 2010 16:21:25 +1100
Message-Id: <1286515292-15882-12-git-send-email-david@fromorbit.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1286515292-15882-1-git-send-email-david@fromorbit.com>
References: <1286515292-15882-1-git-send-email-david@fromorbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nick Piggin <npiggin@suse.de>

Protect the inod hash with a single lock is not scalable.  Convert
the inode hash to use the new bit-locked hash list implementation
that allows per-bucket locks to be used. This allows us to replace
the global inode_lock with finer grained locking without increasing
the size of the hash table.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/btrfs/inode.c        |    2 +-
 fs/fs-writeback.c       |    2 +-
 fs/hfs/hfs_fs.h         |    2 +-
 fs/hfs/inode.c          |    2 +-
 fs/hfsplus/hfsplus_fs.h |    2 +-
 fs/hfsplus/inode.c      |    2 +-
 fs/inode.c              |  165 ++++++++++++++++++++++++++++++----------------
 fs/nilfs2/gcinode.c     |   22 ++++---
 fs/nilfs2/segment.c     |    2 +-
 fs/nilfs2/the_nilfs.h   |    2 +-
 fs/reiserfs/xattr.c     |    2 +-
 include/linux/fs.h      |    3 +-
 mm/shmem.c              |    4 +-
 13 files changed, 132 insertions(+), 80 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 9f04478..f908a12 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3855,7 +3855,7 @@ again:
 	p = &root->inode_tree.rb_node;
 	parent = NULL;
 
-	if (hlist_unhashed(&inode->i_hash))
+	if (hlist_bl_unhashed(&inode->i_hash))
 		return;
 
 	spin_lock(&root->inode_lock);
diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index ec7a689..d63ab47 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -959,7 +959,7 @@ void __mark_inode_dirty(struct inode *inode, int flags)
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
index 32da15e..3c07719 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -24,12 +24,20 @@
 #include <linux/mount.h>
 #include <linux/async.h>
 #include <linux/posix_acl.h>
+#include <linux/bit_spinlock.h>
 
 /*
  * Locking rules.
  *
  * inode->i_lock protects:
  *   i_ref
+ * inode_hash_bucket lock protects:
+ *   inode hash table, i_hash
+ *
+ * Lock orders
+ * inode_lock
+ *   inode hash bucket lock
+ *     inode->i_lock
  */
 
 /*
@@ -80,7 +88,22 @@ static unsigned int i_hash_shift __read_mostly;
  */
 
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
@@ -295,7 +318,7 @@ void destroy_inode(struct inode *inode)
 void inode_init_once(struct inode *inode)
 {
 	memset(inode, 0, sizeof(*inode));
-	INIT_HLIST_NODE(&inode->i_hash);
+	init_hlist_bl_node(&inode->i_hash);
 	INIT_LIST_HEAD(&inode->i_dentry);
 	INIT_LIST_HEAD(&inode->i_devices);
 	INIT_LIST_HEAD(&inode->i_io);
@@ -375,9 +398,13 @@ static unsigned long hash(struct super_block *sb, unsigned long hashval)
  */
 void __insert_inode_hash(struct inode *inode, unsigned long hashval)
 {
-	struct hlist_head *head = inode_hashtable + hash(inode->i_sb, hashval);
+	struct inode_hash_bucket *b;
+
+	b = inode_hashtable + hash(inode->i_sb, hashval);
 	spin_lock(&inode_lock);
-	hlist_add_head(&inode->i_hash, head);
+	spin_lock_bucket(b);
+	hlist_bl_add_head(&inode->i_hash, &b->head);
+	spin_unlock_bucket(b);
 	spin_unlock(&inode_lock);
 }
 EXPORT_SYMBOL(__insert_inode_hash);
@@ -391,7 +418,12 @@ EXPORT_SYMBOL(__insert_inode_hash);
  */
 static void __remove_inode_hash(struct inode *inode)
 {
-	hlist_del_init(&inode->i_hash);
+	struct inode_hash_bucket *b;
+
+	b = inode_hashtable + hash(inode->i_sb, inode->i_ino);
+	spin_lock_bucket(b);
+	hlist_bl_del_init(&inode->i_hash);
+	spin_unlock_bucket(b);
 }
 
 /**
@@ -403,7 +435,7 @@ static void __remove_inode_hash(struct inode *inode)
 void remove_inode_hash(struct inode *inode)
 {
 	spin_lock(&inode_lock);
-	hlist_del_init(&inode->i_hash);
+	__remove_inode_hash(inode);
 	spin_unlock(&inode_lock);
 }
 EXPORT_SYMBOL(remove_inode_hash);
@@ -663,25 +695,28 @@ static void __wait_on_freeing_inode(struct inode *inode);
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
-	hlist_for_each_entry(inode, node, head, i_hash) {
+	spin_lock_bucket(b);
+	hlist_bl_for_each_entry(inode, node, &b->head, i_hash) {
 		if (inode->i_sb != sb)
 			continue;
 		if (!test(inode, data))
 			continue;
 		if (inode->i_state & (I_FREEING|I_WILL_FREE)) {
+			spin_unlock_bucket(b);
 			__wait_on_freeing_inode(inode);
 			goto repeat;
 		}
 		break;
 	}
+	spin_unlock_bucket(b);
 	return node ? inode : NULL;
 }
 
@@ -690,33 +725,40 @@ repeat:
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
-	hlist_for_each_entry(inode, node, head, i_hash) {
+	spin_lock_bucket(b);
+	hlist_bl_for_each_entry(inode, node, &b->head, i_hash) {
 		if (inode->i_ino != ino)
 			continue;
 		if (inode->i_sb != sb)
 			continue;
 		if (inode->i_state & (I_FREEING|I_WILL_FREE)) {
+			spin_unlock_bucket(b);
 			__wait_on_freeing_inode(inode);
 			goto repeat;
 		}
 		break;
 	}
+	spin_unlock_bucket(b);
 	return node ? inode : NULL;
 }
 
 static inline void
-__inode_add_to_lists(struct super_block *sb, struct hlist_head *head,
+__inode_add_to_lists(struct super_block *sb, struct inode_hash_bucket *b,
 			struct inode *inode)
 {
 	list_add(&inode->i_sb_list, &sb->s_inodes);
-	if (head)
-		hlist_add_head(&inode->i_hash, head);
+	if (b) {
+		spin_lock_bucket(b);
+		hlist_bl_add_head(&inode->i_hash, &b->head);
+		spin_unlock_bucket(b);
+	}
 }
 
 /**
@@ -733,10 +775,10 @@ __inode_add_to_lists(struct super_block *sb, struct hlist_head *head,
  */
 void inode_add_to_lists(struct super_block *sb, struct inode *inode)
 {
-	struct hlist_head *head = inode_hashtable + hash(sb, inode->i_ino);
+	struct inode_hash_bucket *b = inode_hashtable + hash(sb, inode->i_ino);
 
 	spin_lock(&inode_lock);
-	__inode_add_to_lists(sb, head, inode);
+	__inode_add_to_lists(sb, b, inode);
 	spin_unlock(&inode_lock);
 }
 EXPORT_SYMBOL_GPL(inode_add_to_lists);
@@ -819,7 +861,7 @@ EXPORT_SYMBOL(unlock_new_inode);
  *	-- rmk@arm.uk.linux.org
  */
 static struct inode *get_new_inode(struct super_block *sb,
-				struct hlist_head *head,
+				struct inode_hash_bucket *b,
 				int (*test)(struct inode *, void *),
 				int (*set)(struct inode *, void *),
 				void *data)
@@ -832,12 +874,12 @@ static struct inode *get_new_inode(struct super_block *sb,
 
 		spin_lock(&inode_lock);
 		/* We released the lock, so.. */
-		old = find_inode(sb, head, test, data);
+		old = find_inode(sb, b, test, data);
 		if (!old) {
 			if (set(inode, data))
 				goto set_failed;
 
-			__inode_add_to_lists(sb, head, inode);
+			__inode_add_to_lists(sb, b, inode);
 			inode->i_state = I_NEW;
 			spin_unlock(&inode_lock);
 
@@ -873,7 +915,7 @@ set_failed:
  * comment at iget_locked for details.
  */
 static struct inode *get_new_inode_fast(struct super_block *sb,
-				struct hlist_head *head, unsigned long ino)
+				struct inode_hash_bucket *b, unsigned long ino)
 {
 	struct inode *inode;
 
@@ -883,10 +925,10 @@ static struct inode *get_new_inode_fast(struct super_block *sb,
 
 		spin_lock(&inode_lock);
 		/* We released the lock, so.. */
-		old = find_inode_fast(sb, head, ino);
+		old = find_inode_fast(sb, b, ino);
 		if (!old) {
 			inode->i_ino = ino;
-			__inode_add_to_lists(sb, head, inode);
+			__inode_add_to_lists(sb, b, inode);
 			inode->i_state = I_NEW;
 			spin_unlock(&inode_lock);
 
@@ -935,7 +977,7 @@ ino_t iunique(struct super_block *sb, ino_t max_reserved)
 	 */
 	static unsigned int counter;
 	struct inode *inode;
-	struct hlist_head *head;
+	struct inode_hash_bucket *b;
 	ino_t res;
 
 	spin_lock(&inode_lock);
@@ -943,8 +985,8 @@ ino_t iunique(struct super_block *sb, ino_t max_reserved)
 		if (counter <= max_reserved)
 			counter = max_reserved + 1;
 		res = counter++;
-		head = inode_hashtable + hash(sb, res);
-		inode = find_inode_fast(sb, head, res);
+		b = inode_hashtable + hash(sb, res);
+		inode = find_inode_fast(sb, b, res);
 	} while (inode != NULL);
 	spin_unlock(&inode_lock);
 
@@ -991,13 +1033,14 @@ EXPORT_SYMBOL(igrab);
  * Note, @test is called with the inode_lock held, so can't sleep.
  */
 static struct inode *ifind(struct super_block *sb,
-		struct hlist_head *head, int (*test)(struct inode *, void *),
+		struct inode_hash_bucket *b,
+		int (*test)(struct inode *, void *),
 		void *data, const int wait)
 {
 	struct inode *inode;
 
 	spin_lock(&inode_lock);
-	inode = find_inode(sb, head, test, data);
+	inode = find_inode(sb, b, test, data);
 	if (inode) {
 		spin_lock(&inode->i_lock);
 		iref_locked(inode);
@@ -1027,12 +1070,13 @@ static struct inode *ifind(struct super_block *sb,
  * Otherwise NULL is returned.
  */
 static struct inode *ifind_fast(struct super_block *sb,
-		struct hlist_head *head, unsigned long ino)
+		struct inode_hash_bucket *b,
+		unsigned long ino)
 {
 	struct inode *inode;
 
 	spin_lock(&inode_lock);
-	inode = find_inode_fast(sb, head, ino);
+	inode = find_inode_fast(sb, b, ino);
 	if (inode) {
 		spin_lock(&inode->i_lock);
 		iref_locked(inode);
@@ -1069,9 +1113,9 @@ static struct inode *ifind_fast(struct super_block *sb,
 struct inode *ilookup5_nowait(struct super_block *sb, unsigned long hashval,
 		int (*test)(struct inode *, void *), void *data)
 {
-	struct hlist_head *head = inode_hashtable + hash(sb, hashval);
+	struct inode_hash_bucket *b = inode_hashtable + hash(sb, hashval);
 
-	return ifind(sb, head, test, data, 0);
+	return ifind(sb, b, test, data, 0);
 }
 EXPORT_SYMBOL(ilookup5_nowait);
 
@@ -1097,9 +1141,9 @@ EXPORT_SYMBOL(ilookup5_nowait);
 struct inode *ilookup5(struct super_block *sb, unsigned long hashval,
 		int (*test)(struct inode *, void *), void *data)
 {
-	struct hlist_head *head = inode_hashtable + hash(sb, hashval);
+	struct inode_hash_bucket *b = inode_hashtable + hash(sb, hashval);
 
-	return ifind(sb, head, test, data, 1);
+	return ifind(sb, b, test, data, 1);
 }
 EXPORT_SYMBOL(ilookup5);
 
@@ -1119,9 +1163,9 @@ EXPORT_SYMBOL(ilookup5);
  */
 struct inode *ilookup(struct super_block *sb, unsigned long ino)
 {
-	struct hlist_head *head = inode_hashtable + hash(sb, ino);
+	struct inode_hash_bucket *b = inode_hashtable + hash(sb, ino);
 
-	return ifind_fast(sb, head, ino);
+	return ifind_fast(sb, b, ino);
 }
 EXPORT_SYMBOL(ilookup);
 
@@ -1149,17 +1193,17 @@ struct inode *iget5_locked(struct super_block *sb, unsigned long hashval,
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
 
@@ -1180,17 +1224,17 @@ EXPORT_SYMBOL(iget5_locked);
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
 
@@ -1198,14 +1242,15 @@ int insert_inode_locked(struct inode *inode)
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
 		spin_lock(&inode_lock);
-		hlist_for_each_entry(old, node, head, i_hash) {
+		spin_lock_bucket(b);
+		hlist_bl_for_each_entry(old, node, &b->head, i_hash) {
 			if (old->i_ino != ino)
 				continue;
 			if (old->i_sb != sb)
@@ -1215,16 +1260,18 @@ int insert_inode_locked(struct inode *inode)
 			break;
 		}
 		if (likely(!node)) {
-			hlist_add_head(&inode->i_hash, head);
+			hlist_bl_add_head(&inode->i_hash, &b->head);
+			spin_unlock_bucket(b);
 			spin_unlock(&inode_lock);
 			return 0;
 		}
 		spin_lock(&old->i_lock);
 		iref_locked(old);
 		spin_unlock(&old->i_lock);
+		spin_unlock_bucket(b);
 		spin_unlock(&inode_lock);
 		wait_on_inode(old);
-		if (unlikely(!hlist_unhashed(&old->i_hash))) {
+		if (unlikely(!hlist_bl_unhashed(&old->i_hash))) {
 			iput(old);
 			return -EBUSY;
 		}
@@ -1237,16 +1284,17 @@ int insert_inode_locked4(struct inode *inode, unsigned long hashval,
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
 
 		spin_lock(&inode_lock);
-		hlist_for_each_entry(old, node, head, i_hash) {
+		spin_lock_bucket(b);
+		hlist_bl_for_each_entry(old, node, &b->head, i_hash) {
 			if (old->i_sb != sb)
 				continue;
 			if (!test(old, data))
@@ -1256,16 +1304,18 @@ int insert_inode_locked4(struct inode *inode, unsigned long hashval,
 			break;
 		}
 		if (likely(!node)) {
-			hlist_add_head(&inode->i_hash, head);
+			hlist_bl_add_head(&inode->i_hash, &b->head);
+			spin_unlock_bucket(b);
 			spin_unlock(&inode_lock);
 			return 0;
 		}
 		spin_lock(&old->i_lock);
 		iref_locked(old);
 		spin_unlock(&old->i_lock);
+		spin_unlock_bucket(b);
 		spin_unlock(&inode_lock);
 		wait_on_inode(old);
-		if (unlikely(!hlist_unhashed(&old->i_hash))) {
+		if (unlikely(!hlist_bl_unhashed(&old->i_hash))) {
 			iput(old);
 			return -EBUSY;
 		}
@@ -1288,7 +1338,7 @@ EXPORT_SYMBOL(generic_delete_inode);
  */
 int generic_drop_inode(struct inode *inode)
 {
-	return !inode->i_nlink || hlist_unhashed(&inode->i_hash);
+	return !inode->i_nlink || hlist_bl_unhashed(&inode->i_hash);
 }
 EXPORT_SYMBOL_GPL(generic_drop_inode);
 
@@ -1331,7 +1381,6 @@ static void iput_final(struct inode *inode)
 		spin_lock(&inode_lock);
 		WARN_ON(inode->i_state & I_NEW);
 		inode->i_state &= ~I_WILL_FREE;
-		hlist_del_init(&inode->i_hash);
 		__remove_inode_hash(inode);
 	}
 	list_del_init(&inode->i_io);
@@ -1599,7 +1648,7 @@ void __init inode_init_early(void)
 
 	inode_hashtable =
 		alloc_large_system_hash("Inode-cache",
-					sizeof(struct hlist_head),
+					sizeof(struct inode_hash_bucket),
 					ihash_entries,
 					14,
 					HASH_EARLY,
@@ -1608,7 +1657,7 @@ void __init inode_init_early(void)
 					0);
 
 	for (loop = 0; loop < (1 << i_hash_shift); loop++)
-		INIT_HLIST_HEAD(&inode_hashtable[loop]);
+		INIT_HLIST_BL_HEAD(&inode_hashtable[loop].head);
 
 }
 
@@ -1633,7 +1682,7 @@ void __init inode_init(void)
 
 	inode_hashtable =
 		alloc_large_system_hash("Inode-cache",
-					sizeof(struct hlist_head),
+					sizeof(struct inode_hash_bucket),
 					ihash_entries,
 					14,
 					0,
@@ -1642,7 +1691,7 @@ void __init inode_init(void)
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
index 1162c10..34f983f 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -383,6 +383,7 @@ struct inodes_stat_t {
 #include <linux/capability.h>
 #include <linux/semaphore.h>
 #include <linux/fiemap.h>
+#include <linux/rculist_bl.h>
 
 #include <asm/atomic.h>
 #include <asm/byteorder.h>
@@ -724,7 +725,7 @@ struct posix_acl;
 #define ACL_NOT_CACHED ((void *)(-1))
 
 struct inode {
-	struct hlist_node	i_hash;
+	struct hlist_bl_node	i_hash;
 	struct list_head	i_io;		/* backing dev IO list */
 	struct list_head	i_lru;		/* backing dev IO list */
 	struct list_head	i_sb_list;
diff --git a/mm/shmem.c b/mm/shmem.c
index 4daaa24..7a2a5de 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2146,7 +2146,7 @@ static int shmem_encode_fh(struct dentry *dentry, __u32 *fh, int *len,
 	if (*len < 3)
 		return 255;
 
-	if (hlist_unhashed(&inode->i_hash)) {
+	if (hlist_bl_unhashed(&inode->i_hash)) {
 		/* Unfortunately insert_inode_hash is not idempotent,
 		 * so as we hash inodes here rather than at creation
 		 * time, we need a lock to ensure we only try
@@ -2154,7 +2154,7 @@ static int shmem_encode_fh(struct dentry *dentry, __u32 *fh, int *len,
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

