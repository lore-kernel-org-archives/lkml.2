Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752817Ab0KAFeg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 01:34:36 -0400
Received: from bld-mail15.adl6.internode.on.net ([150.101.137.100]:56276 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752157Ab0KAFeb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 01:34:31 -0400
From: Dave Chinner <david@fromorbit.com>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] fs: rcu protect inode hash lookups
Date: Mon,  1 Nov 2010 16:33:44 +1100
Message-Id: <1288589624-15251-4-git-send-email-david@fromorbit.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1288589624-15251-1-git-send-email-david@fromorbit.com>
References: <1288589624-15251-1-git-send-email-david@fromorbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Now that inodes are using RCU freeing, we can walk the hash lists
using RCU protection during lookups. Convert all the hash list
operations to use RCU-based operators and drop the inode_hash_lock
around pure lookup operations.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/inode.c |   89 ++++++++++++++++++++++++++++++++++++++---------------------
 1 files changed, 57 insertions(+), 32 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index 106ec7a..6bead3d 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -50,11 +50,12 @@
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
@@ -413,7 +414,7 @@ void __insert_inode_hash(struct inode *inode, unsigned long hashval)
 
 	spin_lock(&inode_hash_lock);
 	spin_lock(&inode->i_lock);
-	hlist_add_head(&inode->i_hash, b);
+	hlist_add_head_rcu(&inode->i_hash, b);
 	spin_unlock(&inode->i_lock);
 	spin_unlock(&inode_hash_lock);
 }
@@ -429,7 +430,7 @@ void remove_inode_hash(struct inode *inode)
 {
 	spin_lock(&inode_hash_lock);
 	spin_lock(&inode->i_lock);
-	hlist_del_init(&inode->i_hash);
+	hlist_del_init_rcu(&inode->i_hash);
 	spin_unlock(&inode->i_lock);
 	spin_unlock(&inode_hash_lock);
 }
@@ -741,26 +742,38 @@ static void __wait_on_freeing_inode(struct inode *inode);
 static struct inode *find_inode(struct super_block *sb,
 				struct hlist_head *head,
 				int (*test)(struct inode *, void *),
-				void *data)
+				void *data, bool locked)
 {
 	struct hlist_node *node;
 	struct inode *inode = NULL;
 
 repeat:
+	rcu_read_lock();
 	hlist_for_each_entry(inode, node, head, i_hash) {
 		if (inode->i_sb != sb)
 			continue;
 		if (!test(inode, data))
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
 		__iget(inode);
 		spin_unlock(&inode->i_lock);
+		rcu_read_unlock();
 		return inode;
 	}
+	rcu_read_unlock();
 	return NULL;
 }
 
@@ -769,26 +782,39 @@ repeat:
  * iget_locked for details.
  */
 static struct inode *find_inode_fast(struct super_block *sb,
-				struct hlist_head *head, unsigned long ino)
+				struct hlist_head *head, unsigned long ino,
+				bool locked)
 {
 	struct hlist_node *node;
 	struct inode *inode = NULL;
 
 repeat:
+	rcu_read_lock();
 	hlist_for_each_entry(inode, node, head, i_hash) {
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
 		__iget(inode);
 		spin_unlock(&inode->i_lock);
+		rcu_read_unlock();
 		return inode;
 	}
+	rcu_read_unlock();
 	return NULL;
 }
 
@@ -913,14 +939,14 @@ static struct inode *get_new_inode(struct super_block *sb,
 
 		spin_lock(&inode_hash_lock);
 		/* We released the lock, so.. */
-		old = find_inode(sb, head, test, data);
+		old = find_inode(sb, head, test, data, true);
 		if (!old) {
 			if (set(inode, data))
 				goto set_failed;
 
 			spin_lock(&inode->i_lock);
 			inode->i_state = I_NEW;
-			hlist_add_head(&inode->i_hash, head);
+			hlist_add_head_rcu(&inode->i_hash, head);
 			spin_unlock(&inode->i_lock);
 			inode_sb_list_add(inode);
 			spin_unlock(&inode_hash_lock);
@@ -964,12 +990,12 @@ static struct inode *get_new_inode_fast(struct super_block *sb,
 
 		spin_lock(&inode_hash_lock);
 		/* We released the lock, so.. */
-		old = find_inode_fast(sb, head, ino);
+		old = find_inode_fast(sb, head, ino, true);
 		if (!old) {
 			inode->i_ino = ino;
 			spin_lock(&inode->i_lock);
 			inode->i_state = I_NEW;
-			hlist_add_head(&inode->i_hash, head);
+			hlist_add_head_rcu(&inode->i_hash, head);
 			spin_unlock(&inode->i_lock);
 			inode_sb_list_add(inode);
 			spin_unlock(&inode_hash_lock);
@@ -1006,15 +1032,22 @@ static int test_inode_iunique(struct super_block *sb, unsigned long ino)
 	struct hlist_node *node;
 	struct inode *inode;
 
-	spin_lock(&inode_hash_lock);
-	hlist_for_each_entry(inode, node, b, i_hash) {
-		if (inode->i_ino == ino && inode->i_sb == sb) {
-			spin_unlock(&inode_hash_lock);
-			return 0;
+	rcu_read_lock();
+	hlist_for_each_entry_rcu(inode, node, b, i_hash) {
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
-
+	rcu_read_unlock();
 	return 1;
 }
 
@@ -1099,15 +1132,12 @@ static struct inode *ifind(struct super_block *sb,
 {
 	struct inode *inode;
 
-	spin_lock(&inode_hash_lock);
-	inode = find_inode(sb, head, test, data);
+	inode = find_inode(sb, head, test, data, false);
 	if (inode) {
-		spin_unlock(&inode_hash_lock);
 		if (likely(wait))
 			wait_on_inode(inode);
 		return inode;
 	}
-	spin_unlock(&inode_hash_lock);
 	return NULL;
 }
 
@@ -1131,14 +1161,11 @@ static struct inode *ifind_fast(struct super_block *sb,
 {
 	struct inode *inode;
 
-	spin_lock(&inode_hash_lock);
-	inode = find_inode_fast(sb, head, ino);
+	inode = find_inode_fast(sb, head, ino, false);
 	if (inode) {
-		spin_unlock(&inode_hash_lock);
 		wait_on_inode(inode);
 		return inode;
 	}
-	spin_unlock(&inode_hash_lock);
 	return NULL;
 }
 
@@ -1301,7 +1328,7 @@ int insert_inode_locked(struct inode *inode)
 		struct hlist_node *node;
 		struct inode *old = NULL;
 		spin_lock(&inode_hash_lock);
-		hlist_for_each_entry(old, node, head, i_hash) {
+		hlist_for_each_entry_rcu(old, node, head, i_hash) {
 			if (old->i_ino != ino)
 				continue;
 			if (old->i_sb != sb)
@@ -1316,7 +1343,7 @@ int insert_inode_locked(struct inode *inode)
 		if (likely(!node)) {
 			spin_lock(&inode->i_lock);
 			inode->i_state |= I_NEW;
-			hlist_add_head(&inode->i_hash, head);
+			hlist_add_head_rcu(&inode->i_hash, head);
 			spin_unlock(&inode->i_lock);
 			spin_unlock(&inode_hash_lock);
 			return 0;
@@ -1345,7 +1372,7 @@ int insert_inode_locked4(struct inode *inode, unsigned long hashval,
 		struct inode *old = NULL;
 
 		spin_lock(&inode_hash_lock);
-		hlist_for_each_entry(old, node, head, i_hash) {
+		hlist_for_each_entry_rcu(old, node, head, i_hash) {
 			if (old->i_sb != sb)
 				continue;
 			if (!test(old, data))
@@ -1360,7 +1387,7 @@ int insert_inode_locked4(struct inode *inode, unsigned long hashval,
 		if (likely(!node)) {
 			spin_lock(&inode->i_lock);
 			inode->i_state |= I_NEW;
-			hlist_add_head(&inode->i_hash, head);
+			hlist_add_head_rcu(&inode->i_hash, head);
 			spin_unlock(&inode->i_lock);
 			spin_unlock(&inode_hash_lock);
 			return 0;
@@ -1646,10 +1673,8 @@ static void __wait_on_freeing_inode(struct inode *inode)
 	wq = bit_waitqueue(&inode->i_state, __I_NEW);
 	prepare_to_wait(wq, &wait.wait, TASK_UNINTERRUPTIBLE);
 	spin_unlock(&inode->i_lock);
-	spin_unlock(&inode_hash_lock);
 	schedule();
 	finish_wait(wq, &wait.wait);
-	spin_lock(&inode_hash_lock);
 }
 
 static __initdata unsigned long ihash_entries;
-- 
1.7.1

