Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933803Ab0J2JCV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 05:02:21 -0400
Received: from bld-mail16.adl2.internode.on.net ([150.101.137.101]:49295 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933715Ab0J2JBW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 05:01:22 -0400
From: Dave Chinner <david@fromorbit.com>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 7/8] fs: rename inode_lock to inode_hash_lock
Date: Fri, 29 Oct 2010 20:00:02 +1100
Message-Id: <1288342803-14957-8-git-send-email-david@fromorbit.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1288342803-14957-1-git-send-email-david@fromorbit.com>
References: <1288342803-14957-1-git-send-email-david@fromorbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

All that remains of the inode_lock is protecting the inode hash list
manipulation and traversals. Rename the inode_lock to
inode_hash_lock to reflect it's actual function.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/inode.c                |   80 +++++++++++++++++++++++----------------------
 fs/notify/inode_mark.c    |    1 -
 fs/notify/mark.c          |    1 -
 fs/notify/vfsmount_mark.c |    1 -
 include/linux/writeback.h |    1 -
 5 files changed, 41 insertions(+), 43 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index 94e5a5c..c5baf18 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -37,10 +37,10 @@
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
@@ -48,6 +48,13 @@
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
@@ -83,6 +90,8 @@
 
 static unsigned int i_hash_mask __read_mostly;
 static unsigned int i_hash_shift __read_mostly;
+static struct hlist_head *inode_hashtable __read_mostly;
+static __cacheline_aligned_in_smp DEFINE_SPINLOCK(inode_hash_lock);
 
 /*
  * Each inode can be on two separate lists. One is
@@ -98,15 +107,6 @@ static unsigned int i_hash_shift __read_mostly;
 
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
@@ -411,11 +411,11 @@ void __insert_inode_hash(struct inode *inode, unsigned long hashval)
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
 
@@ -427,11 +427,11 @@ EXPORT_SYMBOL(__insert_inode_hash);
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
 
@@ -911,7 +911,7 @@ static struct inode *get_new_inode(struct super_block *sb,
 	if (inode) {
 		struct inode *old;
 
-		spin_lock(&inode_lock);
+		spin_lock(&inode_hash_lock);
 		/* We released the lock, so.. */
 		old = find_inode(sb, head, test, data);
 		if (!old) {
@@ -923,7 +923,7 @@ static struct inode *get_new_inode(struct super_block *sb,
 			hlist_add_head(&inode->i_hash, head);
 			spin_unlock(&inode->i_lock);
 			inode_sb_list_add(inode);
-			spin_unlock(&inode_lock);
+			spin_unlock(&inode_hash_lock);
 
 			/* Return the locked inode with I_NEW set, the
 			 * caller is responsible for filling in the contents
@@ -936,7 +936,7 @@ static struct inode *get_new_inode(struct super_block *sb,
 		 * us. Use the old inode instead of the one we just
 		 * allocated.
 		 */
-		spin_unlock(&inode_lock);
+		spin_unlock(&inode_hash_lock);
 		destroy_inode(inode);
 		inode = old;
 		wait_on_inode(inode);
@@ -944,7 +944,7 @@ static struct inode *get_new_inode(struct super_block *sb,
 	return inode;
 
 set_failed:
-	spin_unlock(&inode_lock);
+	spin_unlock(&inode_hash_lock);
 	destroy_inode(inode);
 	return NULL;
 }
@@ -962,7 +962,7 @@ static struct inode *get_new_inode_fast(struct super_block *sb,
 	if (inode) {
 		struct inode *old;
 
-		spin_lock(&inode_lock);
+		spin_lock(&inode_hash_lock);
 		/* We released the lock, so.. */
 		old = find_inode_fast(sb, head, ino);
 		if (!old) {
@@ -972,7 +972,7 @@ static struct inode *get_new_inode_fast(struct super_block *sb,
 			hlist_add_head(&inode->i_hash, head);
 			spin_unlock(&inode->i_lock);
 			inode_sb_list_add(inode);
-			spin_unlock(&inode_lock);
+			spin_unlock(&inode_hash_lock);
 
 			/* Return the locked inode with I_NEW set, the
 			 * caller is responsible for filling in the contents
@@ -985,7 +985,7 @@ static struct inode *get_new_inode_fast(struct super_block *sb,
 		 * us. Use the old inode instead of the one we just
 		 * allocated.
 		 */
-		spin_unlock(&inode_lock);
+		spin_unlock(&inode_hash_lock);
 		destroy_inode(inode);
 		inode = old;
 		wait_on_inode(inode);
@@ -1006,10 +1006,14 @@ static int test_inode_iunique(struct super_block *sb, unsigned long ino)
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
@@ -1039,7 +1043,6 @@ ino_t iunique(struct super_block *sb, ino_t max_reserved)
 	static unsigned int counter;
 	ino_t res;
 
-	spin_lock(&inode_lock);
 	spin_lock(&iunique_lock);
 	do {
 		if (counter <= max_reserved)
@@ -1047,7 +1050,6 @@ ino_t iunique(struct super_block *sb, ino_t max_reserved)
 		res = counter++;
 	} while (!test_inode_iunique(sb, res));
 	spin_unlock(&iunique_lock);
-	spin_unlock(&inode_lock);
 
 	return res;
 }
@@ -1097,15 +1099,15 @@ static struct inode *ifind(struct super_block *sb,
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
 
@@ -1129,14 +1131,14 @@ static struct inode *ifind_fast(struct super_block *sb,
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
 
@@ -1298,7 +1300,7 @@ int insert_inode_locked(struct inode *inode)
 	while (1) {
 		struct hlist_node *node;
 		struct inode *old = NULL;
-		spin_lock(&inode_lock);
+		spin_lock(&inode_hash_lock);
 		hlist_for_each_entry(old, node, head, i_hash) {
 			if (old->i_ino != ino)
 				continue;
@@ -1316,12 +1318,12 @@ int insert_inode_locked(struct inode *inode)
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
@@ -1342,7 +1344,7 @@ int insert_inode_locked4(struct inode *inode, unsigned long hashval,
 		struct hlist_node *node;
 		struct inode *old = NULL;
 
-		spin_lock(&inode_lock);
+		spin_lock(&inode_hash_lock);
 		hlist_for_each_entry(old, node, head, i_hash) {
 			if (old->i_sb != sb)
 				continue;
@@ -1360,12 +1362,12 @@ int insert_inode_locked4(struct inode *inode, unsigned long hashval,
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
@@ -1644,10 +1646,10 @@ static void __wait_on_freeing_inode(struct inode *inode)
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
index 06c8216..a33b0f9 100644
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
index 56772b5..6f8eefe 100644
--- a/fs/notify/vfsmount_mark.c
+++ b/fs/notify/vfsmount_mark.c
@@ -23,7 +23,6 @@
 #include <linux/mount.h>
 #include <linux/mutex.h>
 #include <linux/spinlock.h>
-#include <linux/writeback.h> /* for inode_lock */
 
 #include <asm/atomic.h>
 
diff --git a/include/linux/writeback.h b/include/linux/writeback.h
index e78a240..949bb4a 100644
--- a/include/linux/writeback.h
+++ b/include/linux/writeback.h
@@ -9,7 +9,6 @@
 
 struct backing_dev_info;
 
-extern spinlock_t inode_lock;
 extern spinlock_t inode_wb_list_lock;
 
 /*
-- 
1.7.1

