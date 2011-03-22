Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755490Ab1CVLXw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 07:23:52 -0400
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:23864 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755337Ab1CVLXr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 07:23:47 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApkEAK8jiE15LK5JgWdsb2JhbAClQxUBARYmJcQUgn6CZgSSZw
From: Dave Chinner <david@fromorbit.com>
To: viro@ZenIV.linux.org.uk
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH 7/8] fs: rename inode_lock to inode_hash_lock
Date: Tue, 22 Mar 2011 22:23:42 +1100
Message-Id: <1300793023-3775-8-git-send-email-david@fromorbit.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1300793023-3775-1-git-send-email-david@fromorbit.com>
References: <1300793023-3775-1-git-send-email-david@fromorbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

All that remains of the inode_lock is protecting the inode hash list
manipulation and traversals. Rename the inode_lock to
inode_hash_lock to reflect it's actual function.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/inode.c                |  111 +++++++++++++++++++++++++--------------------
 fs/notify/inode_mark.c    |    1 -
 fs/notify/mark.c          |    1 -
 fs/notify/vfsmount_mark.c |    1 -
 fs/ntfs/inode.c           |    4 +-
 include/linux/writeback.h |    1 -
 6 files changed, 63 insertions(+), 56 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index 5a7f8ef..730ddd6 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -38,10 +38,10 @@
  *   sb->s_inodes, inode->i_sb_list
  * inode_wb_list_lock protects:
  *   bdi->wb.b_{dirty,io,more_io}, inode->i_wb_list
+ * inode_hash_lock protects:
+ *   inode_hashtable, inode->i_hash
  *
  * Lock ordering:
- * inode_lock
- *   inode->i_lock
  *
  * inode_sb_list_lock
  *   inode->i_lock
@@ -49,6 +49,13 @@
  *
  * inode_wb_list_lock
  *   inode->i_lock
+ *
+ * inode_hash_lock
+ *   inode_sb_list_lock
+ *   inode->i_lock
+ *
+ * iunique_lock
+ *   inode_hash_lock
  */
 
 /*
@@ -84,6 +91,8 @@
 
 static unsigned int i_hash_mask __read_mostly;
 static unsigned int i_hash_shift __read_mostly;
+static struct hlist_head *inode_hashtable __read_mostly;
+static __cacheline_aligned_in_smp DEFINE_SPINLOCK(inode_hash_lock);
 
 /*
  * Each inode can be on two separate lists. One is
@@ -99,15 +108,6 @@ static unsigned int i_hash_shift __read_mostly;
 
 static LIST_HEAD(inode_lru);
 static DEFINE_SPINLOCK(inode_lru_lock);
-static struct hlist_head *inode_hashtable __read_mostly;
-
-/*
- * A simple spinlock to protect the list manipulations.
- *
- * NOTE! You also have to own the lock if you change
- * the i_state of an inode while it is in use..
- */
-DEFINE_SPINLOCK(inode_lock);
 
 __cacheline_aligned_in_smp DEFINE_SPINLOCK(inode_sb_list_lock);
 __cacheline_aligned_in_smp DEFINE_SPINLOCK(inode_wb_list_lock);
@@ -432,11 +432,11 @@ void __insert_inode_hash(struct inode *inode, unsigned long hashval)
 {
 	struct hlist_head *b = inode_hashtable + hash(inode->i_sb, hashval);
 
-	spin_lock(&inode_lock);
+	spin_lock(&inode_hash_lock);
 	spin_lock(&inode->i_lock);
 	hlist_add_head(&inode->i_hash, b);
 	spin_unlock(&inode->i_lock);
-	spin_unlock(&inode_lock);
+	spin_unlock(&inode_hash_lock);
 }
 EXPORT_SYMBOL(__insert_inode_hash);
 
@@ -448,11 +448,11 @@ EXPORT_SYMBOL(__insert_inode_hash);
  */
 void remove_inode_hash(struct inode *inode)
 {
-	spin_lock(&inode_lock);
+	spin_lock(&inode_hash_lock);
 	spin_lock(&inode->i_lock);
 	hlist_del_init(&inode->i_hash);
 	spin_unlock(&inode->i_lock);
-	spin_unlock(&inode_lock);
+	spin_unlock(&inode_hash_lock);
 }
 EXPORT_SYMBOL(remove_inode_hash);
 
@@ -777,11 +777,15 @@ static struct inode *find_inode(struct super_block *sb,
 
 repeat:
 	hlist_for_each_entry(inode, node, head, i_hash) {
-		if (inode->i_sb != sb)
+		spin_lock(&inode->i_lock);
+		if (inode->i_sb != sb) {
+			spin_unlock(&inode->i_lock);
 			continue;
-		if (!test(inode, data))
+		}
+		if (!test(inode, data)) {
+			spin_unlock(&inode->i_lock);
 			continue;
-		spin_lock(&inode->i_lock);
+		}
 		if (inode->i_state & (I_FREEING|I_WILL_FREE)) {
 			__wait_on_freeing_inode(inode);
 			goto repeat;
@@ -805,11 +809,15 @@ static struct inode *find_inode_fast(struct super_block *sb,
 
 repeat:
 	hlist_for_each_entry(inode, node, head, i_hash) {
-		if (inode->i_ino != ino)
+		spin_lock(&inode->i_lock);
+		if (inode->i_ino != ino) {
+			spin_unlock(&inode->i_lock);
 			continue;
-		if (inode->i_sb != sb)
+		}
+		if (inode->i_sb != sb) {
+			spin_unlock(&inode->i_lock);
 			continue;
-		spin_lock(&inode->i_lock);
+		}
 		if (inode->i_state & (I_FREEING|I_WILL_FREE)) {
 			__wait_on_freeing_inode(inode);
 			goto repeat;
@@ -923,7 +931,7 @@ void unlock_new_inode(struct inode *inode)
 EXPORT_SYMBOL(unlock_new_inode);
 
 /*
- * This is called without the inode lock held.. Be careful.
+ * This is called without the inode hash lock held.. Be careful.
  *
  * We no longer cache the sb_flags in i_flags - see fs.h
  *	-- rmk@arm.uk.linux.org
@@ -940,7 +948,7 @@ static struct inode *get_new_inode(struct super_block *sb,
 	if (inode) {
 		struct inode *old;
 
-		spin_lock(&inode_lock);
+		spin_lock(&inode_hash_lock);
 		/* We released the lock, so.. */
 		old = find_inode(sb, head, test, data);
 		if (!old) {
@@ -952,7 +960,7 @@ static struct inode *get_new_inode(struct super_block *sb,
 			hlist_add_head(&inode->i_hash, head);
 			spin_unlock(&inode->i_lock);
 			inode_sb_list_add(inode);
-			spin_unlock(&inode_lock);
+			spin_unlock(&inode_hash_lock);
 
 			/* Return the locked inode with I_NEW set, the
 			 * caller is responsible for filling in the contents
@@ -965,7 +973,7 @@ static struct inode *get_new_inode(struct super_block *sb,
 		 * us. Use the old inode instead of the one we just
 		 * allocated.
 		 */
-		spin_unlock(&inode_lock);
+		spin_unlock(&inode_hash_lock);
 		destroy_inode(inode);
 		inode = old;
 		wait_on_inode(inode);
@@ -973,7 +981,7 @@ static struct inode *get_new_inode(struct super_block *sb,
 	return inode;
 
 set_failed:
-	spin_unlock(&inode_lock);
+	spin_unlock(&inode_hash_lock);
 	destroy_inode(inode);
 	return NULL;
 }
@@ -991,7 +999,7 @@ static struct inode *get_new_inode_fast(struct super_block *sb,
 	if (inode) {
 		struct inode *old;
 
-		spin_lock(&inode_lock);
+		spin_lock(&inode_hash_lock);
 		/* We released the lock, so.. */
 		old = find_inode_fast(sb, head, ino);
 		if (!old) {
@@ -1001,7 +1009,7 @@ static struct inode *get_new_inode_fast(struct super_block *sb,
 			hlist_add_head(&inode->i_hash, head);
 			spin_unlock(&inode->i_lock);
 			inode_sb_list_add(inode);
-			spin_unlock(&inode_lock);
+			spin_unlock(&inode_hash_lock);
 
 			/* Return the locked inode with I_NEW set, the
 			 * caller is responsible for filling in the contents
@@ -1014,7 +1022,7 @@ static struct inode *get_new_inode_fast(struct super_block *sb,
 		 * us. Use the old inode instead of the one we just
 		 * allocated.
 		 */
-		spin_unlock(&inode_lock);
+		spin_unlock(&inode_hash_lock);
 		destroy_inode(inode);
 		inode = old;
 		wait_on_inode(inode);
@@ -1035,10 +1043,14 @@ static int test_inode_iunique(struct super_block *sb, unsigned long ino)
 	struct hlist_node *node;
 	struct inode *inode;
 
+	spin_lock(&inode_hash_lock);
 	hlist_for_each_entry(inode, node, b, i_hash) {
-		if (inode->i_ino == ino && inode->i_sb == sb)
+		if (inode->i_ino == ino && inode->i_sb == sb) {
+			spin_unlock(&inode_hash_lock);
 			return 0;
+		}
 	}
+	spin_unlock(&inode_hash_lock);
 
 	return 1;
 }
@@ -1068,7 +1080,6 @@ ino_t iunique(struct super_block *sb, ino_t max_reserved)
 	static unsigned int counter;
 	ino_t res;
 
-	spin_lock(&inode_lock);
 	spin_lock(&iunique_lock);
 	do {
 		if (counter <= max_reserved)
@@ -1076,7 +1087,6 @@ ino_t iunique(struct super_block *sb, ino_t max_reserved)
 		res = counter++;
 	} while (!test_inode_iunique(sb, res));
 	spin_unlock(&iunique_lock);
-	spin_unlock(&inode_lock);
 
 	return res;
 }
@@ -1118,7 +1128,7 @@ EXPORT_SYMBOL(igrab);
  *
  * Otherwise NULL is returned.
  *
- * Note, @test is called with the inode_lock held, so can't sleep.
+ * Note, @test is called with the inode_hash_lock held, so can't sleep.
  */
 static struct inode *ifind(struct super_block *sb,
 		struct hlist_head *head, int (*test)(struct inode *, void *),
@@ -1126,15 +1136,15 @@ static struct inode *ifind(struct super_block *sb,
 {
 	struct inode *inode;
 
-	spin_lock(&inode_lock);
+	spin_lock(&inode_hash_lock);
 	inode = find_inode(sb, head, test, data);
 	if (inode) {
-		spin_unlock(&inode_lock);
+		spin_unlock(&inode_hash_lock);
 		if (likely(wait))
 			wait_on_inode(inode);
 		return inode;
 	}
-	spin_unlock(&inode_lock);
+	spin_unlock(&inode_hash_lock);
 	return NULL;
 }
 
@@ -1158,14 +1168,14 @@ static struct inode *ifind_fast(struct super_block *sb,
 {
 	struct inode *inode;
 
-	spin_lock(&inode_lock);
+	spin_lock(&inode_hash_lock);
 	inode = find_inode_fast(sb, head, ino);
 	if (inode) {
-		spin_unlock(&inode_lock);
+		spin_unlock(&inode_hash_lock);
 		wait_on_inode(inode);
 		return inode;
 	}
-	spin_unlock(&inode_lock);
+	spin_unlock(&inode_hash_lock);
 	return NULL;
 }
 
@@ -1188,7 +1198,7 @@ static struct inode *ifind_fast(struct super_block *sb,
  *
  * Otherwise NULL is returned.
  *
- * Note, @test is called with the inode_lock held, so can't sleep.
+ * Note, @test is called with the inode_hash_lock held, so can't sleep.
  */
 struct inode *ilookup5_nowait(struct super_block *sb, unsigned long hashval,
 		int (*test)(struct inode *, void *), void *data)
@@ -1216,7 +1226,7 @@ EXPORT_SYMBOL(ilookup5_nowait);
  *
  * Otherwise NULL is returned.
  *
- * Note, @test is called with the inode_lock held, so can't sleep.
+ * Note, @test is called with the inode_hash_lock held, so can't sleep.
  */
 struct inode *ilookup5(struct super_block *sb, unsigned long hashval,
 		int (*test)(struct inode *, void *), void *data)
@@ -1267,7 +1277,8 @@ EXPORT_SYMBOL(ilookup);
  * inode and this is returned locked, hashed, and with the I_NEW flag set. The
  * file system gets to fill it in before unlocking it via unlock_new_inode().
  *
- * Note both @test and @set are called with the inode_lock held, so can't sleep.
+ * Note both @test and @set are called with the inode_hash_lock held, so can't
+ * sleep.
  */
 struct inode *iget5_locked(struct super_block *sb, unsigned long hashval,
 		int (*test)(struct inode *, void *),
@@ -1327,7 +1338,7 @@ int insert_inode_locked(struct inode *inode)
 	while (1) {
 		struct hlist_node *node;
 		struct inode *old = NULL;
-		spin_lock(&inode_lock);
+		spin_lock(&inode_hash_lock);
 		hlist_for_each_entry(old, node, head, i_hash) {
 			if (old->i_ino != ino)
 				continue;
@@ -1345,12 +1356,12 @@ int insert_inode_locked(struct inode *inode)
 			inode->i_state |= I_NEW;
 			hlist_add_head(&inode->i_hash, head);
 			spin_unlock(&inode->i_lock);
-			spin_unlock(&inode_lock);
+			spin_unlock(&inode_hash_lock);
 			return 0;
 		}
 		__iget(old);
 		spin_unlock(&old->i_lock);
-		spin_unlock(&inode_lock);
+		spin_unlock(&inode_hash_lock);
 		wait_on_inode(old);
 		if (unlikely(!inode_unhashed(old))) {
 			iput(old);
@@ -1371,7 +1382,7 @@ int insert_inode_locked4(struct inode *inode, unsigned long hashval,
 		struct hlist_node *node;
 		struct inode *old = NULL;
 
-		spin_lock(&inode_lock);
+		spin_lock(&inode_hash_lock);
 		hlist_for_each_entry(old, node, head, i_hash) {
 			if (old->i_sb != sb)
 				continue;
@@ -1389,12 +1400,12 @@ int insert_inode_locked4(struct inode *inode, unsigned long hashval,
 			inode->i_state |= I_NEW;
 			hlist_add_head(&inode->i_hash, head);
 			spin_unlock(&inode->i_lock);
-			spin_unlock(&inode_lock);
+			spin_unlock(&inode_hash_lock);
 			return 0;
 		}
 		__iget(old);
 		spin_unlock(&old->i_lock);
-		spin_unlock(&inode_lock);
+		spin_unlock(&inode_hash_lock);
 		wait_on_inode(old);
 		if (unlikely(!inode_unhashed(old))) {
 			iput(old);
@@ -1673,10 +1684,10 @@ static void __wait_on_freeing_inode(struct inode *inode)
 	wq = bit_waitqueue(&inode->i_state, __I_NEW);
 	prepare_to_wait(wq, &wait.wait, TASK_UNINTERRUPTIBLE);
 	spin_unlock(&inode->i_lock);
-	spin_unlock(&inode_lock);
+	spin_unlock(&inode_hash_lock);
 	schedule();
 	finish_wait(wq, &wait.wait);
-	spin_lock(&inode_lock);
+	spin_lock(&inode_hash_lock);
 }
 
 static __initdata unsigned long ihash_entries;
diff --git a/fs/notify/inode_mark.c b/fs/notify/inode_mark.c
index fb3b3c5..07ea8d3 100644
--- a/fs/notify/inode_mark.c
+++ b/fs/notify/inode_mark.c
@@ -22,7 +22,6 @@
 #include <linux/module.h>
 #include <linux/mutex.h>
 #include <linux/spinlock.h>
-#include <linux/writeback.h> /* for inode_lock */
 
 #include <asm/atomic.h>
 
diff --git a/fs/notify/mark.c b/fs/notify/mark.c
index 325185e..50c0085 100644
--- a/fs/notify/mark.c
+++ b/fs/notify/mark.c
@@ -91,7 +91,6 @@
 #include <linux/slab.h>
 #include <linux/spinlock.h>
 #include <linux/srcu.h>
-#include <linux/writeback.h> /* for inode_lock */
 
 #include <asm/atomic.h>
 
diff --git a/fs/notify/vfsmount_mark.c b/fs/notify/vfsmount_mark.c
index 85eebff..e86577d 100644
--- a/fs/notify/vfsmount_mark.c
+++ b/fs/notify/vfsmount_mark.c
@@ -23,7 +23,6 @@
 #include <linux/mount.h>
 #include <linux/mutex.h>
 #include <linux/spinlock.h>
-#include <linux/writeback.h> /* for inode_lock */
 
 #include <asm/atomic.h>
 
diff --git a/fs/ntfs/inode.c b/fs/ntfs/inode.c
index a627ed8..0b56c6b 100644
--- a/fs/ntfs/inode.c
+++ b/fs/ntfs/inode.c
@@ -54,7 +54,7 @@
  *
  * Return 1 if the attributes match and 0 if not.
  *
- * NOTE: This function runs with the inode_lock spin lock held so it is not
+ * NOTE: This function runs with the inode->i_lock spin lock held so it is not
  * allowed to sleep.
  */
 int ntfs_test_inode(struct inode *vi, ntfs_attr *na)
@@ -98,7 +98,7 @@ int ntfs_test_inode(struct inode *vi, ntfs_attr *na)
  *
  * Return 0 on success and -errno on error.
  *
- * NOTE: This function runs with the inode_lock spin lock held so it is not
+ * NOTE: This function runs with the inode->i_lock spin lock held so it is not
  * allowed to sleep. (Hence the GFP_ATOMIC allocation.)
  */
 static int ntfs_init_locked_inode(struct inode *vi, ntfs_attr *na)
diff --git a/include/linux/writeback.h b/include/linux/writeback.h
index 3f5fee7..17e7ccc 100644
--- a/include/linux/writeback.h
+++ b/include/linux/writeback.h
@@ -9,7 +9,6 @@
 
 struct backing_dev_info;
 
-extern spinlock_t inode_lock;
 extern spinlock_t inode_wb_list_lock;
 
 /*
-- 
1.7.2.3

