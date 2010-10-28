Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932911Ab0J1Lnr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 07:43:47 -0400
Received: from bld-mail12.adl6.internode.on.net ([150.101.137.97]:46822 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932745Ab0J1Lno (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 07:43:44 -0400
From: Dave Chinner <david@fromorbit.com>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] fs: move i_hash out from under inode_lock
Date: Thu, 28 Oct 2010 22:42:41 +1100
Message-Id: <1288266161-28897-4-git-send-email-david@fromorbit.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1288266161-28897-1-git-send-email-david@fromorbit.com>
References: <1288266161-28897-1-git-send-email-david@fromorbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Protect the inode hash lists with a new global lock
inode_hash_lock and use it to protect the list manipulations and
traversals. This lock replaces the inode_lock as the inodes on the
list can be validity checked while holding the inode->i_lock and
hence the inode_lock is no longer needed to protect the lists.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/inode.c |   69 ++++++++++++++++++++++++++++++++++-------------------------
 1 files changed, 40 insertions(+), 29 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index 130aa74..738ba4e 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -37,6 +37,8 @@
  *   sb->s_inodes, inode->i_sb_list
  * inode_sb_list_lock protects:
  *   bdi->wb.b_{dirty,io,more_io}, inode->i_wb_list
+ * inode_hash_lock protects:
+ *   inode_hashtable, inode->i_hash
  *
  * Lock ordering:
  * inode_lock
@@ -48,6 +50,12 @@
  *
  * inode_wb_list_lock
  *   inode->i_lock
+ *
+ * inode_hash_lock
+ *   inode->i_lock
+ *
+ * iunique_lock
+ *   inode_hash_lock
  */
 
 /*
@@ -83,6 +91,8 @@
 
 static unsigned int i_hash_mask __read_mostly;
 static unsigned int i_hash_shift __read_mostly;
+static struct hlist_head *inode_hashtable __read_mostly;
+static __cacheline_aligned_in_smp DEFINE_SPINLOCK(inode_hash_lock);
 
 /*
  * Each inode can be on two separate lists. One is
@@ -98,7 +108,6 @@ static unsigned int i_hash_shift __read_mostly;
 
 static LIST_HEAD(inode_lru);
 static DEFINE_SPINLOCK(inode_lru_lock);
-static struct hlist_head *inode_hashtable __read_mostly;
 
 /*
  * A simple spinlock to protect the list manipulations.
@@ -420,9 +429,9 @@ void __insert_inode_hash(struct inode *inode, unsigned long hashval)
 {
 	struct hlist_head *b = inode_hashtable + hash(inode->i_sb, hashval);
 
-	spin_lock(&inode_lock);
+	spin_lock(&inode_hash_lock);
 	hlist_add_head(&inode->i_hash, b);
-	spin_unlock(&inode_lock);
+	spin_unlock(&inode_hash_lock);
 }
 EXPORT_SYMBOL(__insert_inode_hash);
 
@@ -434,9 +443,9 @@ EXPORT_SYMBOL(__insert_inode_hash);
  */
 void remove_inode_hash(struct inode *inode)
 {
-	spin_lock(&inode_lock);
+	spin_lock(&inode_hash_lock);
 	hlist_del_init(&inode->i_hash);
-	spin_unlock(&inode_lock);
+	spin_unlock(&inode_hash_lock);
 }
 EXPORT_SYMBOL(remove_inode_hash);
 
@@ -914,7 +923,7 @@ static struct inode *get_new_inode(struct super_block *sb,
 	if (inode) {
 		struct inode *old;
 
-		spin_lock(&inode_lock);
+		spin_lock(&inode_hash_lock);
 		/* We released the lock, so.. */
 		old = find_inode(sb, head, test, data);
 		if (!old) {
@@ -925,8 +934,8 @@ static struct inode *get_new_inode(struct super_block *sb,
 			inode->i_state = I_NEW;
 			spin_unlock(&inode->i_lock);
 			hlist_add_head(&inode->i_hash, head);
+			spin_unlock(&inode_hash_lock);
 			inode_sb_list_add(inode);
-			spin_unlock(&inode_lock);
 
 			/* Return the locked inode with I_NEW set, the
 			 * caller is responsible for filling in the contents
@@ -939,7 +948,7 @@ static struct inode *get_new_inode(struct super_block *sb,
 		 * us. Use the old inode instead of the one we just
 		 * allocated.
 		 */
-		spin_unlock(&inode_lock);
+		spin_unlock(&inode_hash_lock);
 		destroy_inode(inode);
 		inode = old;
 		wait_on_inode(inode);
@@ -947,7 +956,7 @@ static struct inode *get_new_inode(struct super_block *sb,
 	return inode;
 
 set_failed:
-	spin_unlock(&inode_lock);
+	spin_unlock(&inode_hash_lock);
 	destroy_inode(inode);
 	return NULL;
 }
@@ -965,7 +974,7 @@ static struct inode *get_new_inode_fast(struct super_block *sb,
 	if (inode) {
 		struct inode *old;
 
-		spin_lock(&inode_lock);
+		spin_lock(&inode_hash_lock);
 		/* We released the lock, so.. */
 		old = find_inode_fast(sb, head, ino);
 		if (!old) {
@@ -974,8 +983,8 @@ static struct inode *get_new_inode_fast(struct super_block *sb,
 			inode->i_state = I_NEW;
 			spin_unlock(&inode->i_lock);
 			hlist_add_head(&inode->i_hash, head);
+			spin_unlock(&inode_hash_lock);
 			inode_sb_list_add(inode);
-			spin_unlock(&inode_lock);
 
 			/* Return the locked inode with I_NEW set, the
 			 * caller is responsible for filling in the contents
@@ -988,7 +997,7 @@ static struct inode *get_new_inode_fast(struct super_block *sb,
 		 * us. Use the old inode instead of the one we just
 		 * allocated.
 		 */
-		spin_unlock(&inode_lock);
+		spin_unlock(&inode_hash_lock);
 		destroy_inode(inode);
 		inode = old;
 		wait_on_inode(inode);
@@ -1009,10 +1018,14 @@ static int test_inode_iunique(struct super_block *sb, unsigned long ino)
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
@@ -1042,7 +1055,6 @@ ino_t iunique(struct super_block *sb, ino_t max_reserved)
 	static unsigned int counter;
 	ino_t res;
 
-	spin_lock(&inode_lock);
 	spin_lock(&iunique_lock);
 	do {
 		if (counter <= max_reserved)
@@ -1050,7 +1062,6 @@ ino_t iunique(struct super_block *sb, ino_t max_reserved)
 		res = counter++;
 	} while (!test_inode_iunique(sb, res));
 	spin_unlock(&iunique_lock);
-	spin_unlock(&inode_lock);
 
 	return res;
 }
@@ -1102,15 +1113,15 @@ static struct inode *ifind(struct super_block *sb,
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
 
@@ -1134,14 +1145,14 @@ static struct inode *ifind_fast(struct super_block *sb,
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
 
@@ -1306,7 +1317,7 @@ int insert_inode_locked(struct inode *inode)
 	while (1) {
 		struct hlist_node *node;
 		struct inode *old = NULL;
-		spin_lock(&inode_lock);
+		spin_lock(&inode_hash_lock);
 		hlist_for_each_entry(old, node, head, i_hash) {
 			if (old->i_ino != ino)
 				continue;
@@ -1321,12 +1332,12 @@ int insert_inode_locked(struct inode *inode)
 		}
 		if (likely(!node)) {
 			hlist_add_head(&inode->i_hash, head);
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
@@ -1351,7 +1362,7 @@ int insert_inode_locked4(struct inode *inode, unsigned long hashval,
 		struct hlist_node *node;
 		struct inode *old = NULL;
 
-		spin_lock(&inode_lock);
+		spin_lock(&inode_hash_lock);
 		hlist_for_each_entry(old, node, head, i_hash) {
 			if (old->i_sb != sb)
 				continue;
@@ -1366,12 +1377,12 @@ int insert_inode_locked4(struct inode *inode, unsigned long hashval,
 		}
 		if (likely(!node)) {
 			hlist_add_head(&inode->i_hash, head);
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
@@ -1651,10 +1662,10 @@ static void __wait_on_freeing_inode(struct inode *inode)
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
-- 
1.7.1

