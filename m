Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758088Ab0JUNZf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 09:25:35 -0400
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:11481 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757971Ab0JUNWn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 09:22:43 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AoAGAGfav0x5LdoFgWdsb2JhbACUZ4xxFgEBFiIiwC+CeIJSBIpN
Message-Id: <20101021131016.533198770@kernel.dk>
User-Agent: quilt/0.48-1
Date: Fri, 22 Oct 2010 00:08:35 +1100
From: npiggin@kernel.dk
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        npiggin@kernel.dk
Subject: [patch 06/14] fs: icache lock inode hash
References: <20101021130829.442910807@kernel.dk>
Content-Disposition: inline; filename=fs-inode_lock-scale-2.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a new lock, inode_hash_lock, to protect the inode hash table lists.

[note: inode_lock can't be lifted much further here, because hash lookups
tend to involve insertions etc onto other data structures]

Signed-off-by: Nick Piggin <npiggin@kernel.dk>

---
 fs/inode.c |   88 +++++++++++++++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 75 insertions(+), 13 deletions(-)

Index: linux-2.6/fs/inode.c
===================================================================
--- linux-2.6.orig/fs/inode.c	2010-10-21 23:50:27.000000000 +1100
+++ linux-2.6/fs/inode.c	2010-10-21 23:50:44.000000000 +1100
@@ -39,11 +39,14 @@
  *   i_sb_list
  * sb_inode_list_lock protects:
  *   s_inodes, i_sb_list
+ * inode_hash_lock protects:
+ *   inode hash table, i_hash
  *
  * Ordering:
  * inode_lock
  *   i_lock
  *     sb_inode_list_lock
+ *     inode_hash_lock
  */
 /*
  * This is needed for the following functions:
@@ -104,6 +107,7 @@ static struct hlist_head *inode_hashtabl
  */
 DEFINE_SPINLOCK(inode_lock);
 DEFINE_SPINLOCK(sb_inode_list_lock);
+static DEFINE_SPINLOCK(inode_hash_lock);
 
 /*
  * iprune_sem provides exclusion between the kswapd or try_to_free_pages
@@ -390,7 +394,9 @@ static void dispose_list(struct list_hea
 
 		spin_lock(&inode_lock);
 		spin_lock(&inode->i_lock);
+		spin_lock(&inode_hash_lock);
 		hlist_del_init(&inode->i_hash);
+		spin_unlock(&inode_hash_lock);
 		spin_lock(&sb_inode_list_lock);
 		list_del_init(&inode->i_sb_list);
 		spin_unlock(&sb_inode_list_lock);
@@ -615,7 +621,12 @@ static struct inode *find_inode(struct s
 			continue;
 		if (!test(inode, data))
 			continue;
-		spin_lock(&inode->i_lock);
+		if (!spin_trylock(&inode->i_lock)) {
+			spin_unlock(&inode_hash_lock);
+			cpu_relax();
+			spin_lock(&inode_hash_lock);
+			goto repeat;
+		}
 		if (inode->i_state & (I_FREEING|I_WILL_FREE)) {
 			__wait_on_freeing_inode(inode);
 			goto repeat;
@@ -641,7 +652,12 @@ static struct inode *find_inode_fast(str
 			continue;
 		if (inode->i_sb != sb)
 			continue;
-		spin_lock(&inode->i_lock);
+		if (!spin_trylock(&inode->i_lock)) {
+			spin_unlock(&inode_hash_lock);
+			cpu_relax();
+			spin_lock(&inode_hash_lock);
+			goto repeat;
+		}
 		if (inode->i_state & (I_FREEING|I_WILL_FREE)) {
 			__wait_on_freeing_inode(inode);
 			goto repeat;
@@ -670,8 +686,11 @@ __inode_add_to_lists(struct super_block
 	spin_lock(&sb_inode_list_lock);
 	list_add(&inode->i_sb_list, &sb->s_inodes);
 	spin_unlock(&sb_inode_list_lock);
-	if (head)
+	if (head) {
+		spin_lock(&inode_hash_lock);
 		hlist_add_head(&inode->i_hash, head);
+		spin_unlock(&inode_hash_lock);
+	}
 }
 
 /**
@@ -790,15 +809,18 @@ static struct inode *get_new_inode(struc
 		struct inode *old;
 
 		spin_lock(&inode_lock);
+		spin_lock(&inode_hash_lock);
 		/* We released the lock, so.. */
 		old = find_inode(sb, head, test, data);
 		if (!old) {
 			if (set(inode, data))
 				goto set_failed;
 
-			spin_lock(&inode->i_lock);
+			BUG_ON(!spin_trylock(&inode->i_lock));
 			inode->i_state = I_NEW;
-			__inode_add_to_lists(sb, head, inode);
+			hlist_add_head(&inode->i_hash, head);
+			spin_unlock(&inode_hash_lock);
+			__inode_add_to_lists(sb, NULL, inode);
 			spin_unlock(&inode->i_lock);
 			spin_unlock(&inode_lock);
 
@@ -814,6 +836,7 @@ static struct inode *get_new_inode(struc
 		 * allocated.
 		 */
 		inode_get_ilock(old);
+		spin_unlock(&inode_hash_lock);
 		spin_unlock(&old->i_lock);
 		spin_unlock(&inode_lock);
 		destroy_inode(inode);
@@ -823,6 +846,7 @@ static struct inode *get_new_inode(struc
 	return inode;
 
 set_failed:
+	spin_unlock(&inode_hash_lock);
 	spin_unlock(&inode_lock);
 	destroy_inode(inode);
 	return NULL;
@@ -842,13 +866,16 @@ static struct inode *get_new_inode_fast(
 		struct inode *old;
 
 		spin_lock(&inode_lock);
+		spin_lock(&inode_hash_lock);
 		/* We released the lock, so.. */
 		old = find_inode_fast(sb, head, ino);
 		if (!old) {
-			spin_lock(&inode->i_lock);
+			BUG_ON(!spin_trylock(&inode->i_lock));
 			inode->i_ino = ino;
 			inode->i_state = I_NEW;
-			__inode_add_to_lists(sb, head, inode);
+			hlist_add_head(&inode->i_hash, head);
+			spin_unlock(&inode_hash_lock);
+			__inode_add_to_lists(sb, NULL, inode);
 			spin_unlock(&inode->i_lock);
 			spin_unlock(&inode_lock);
 
@@ -864,6 +891,7 @@ static struct inode *get_new_inode_fast(
 		 * allocated.
 		 */
 		inode_get_ilock(old);
+		spin_unlock(&inode_hash_lock);
 		spin_unlock(&old->i_lock);
 		spin_unlock(&inode_lock);
 		destroy_inode(inode);
@@ -900,15 +928,17 @@ ino_t iunique(struct super_block *sb, in
 	ino_t res;
 
 	spin_lock(&inode_lock);
+	spin_lock(&inode_hash_lock);
 	do {
 		if (counter <= max_reserved)
 			counter = max_reserved + 1;
 		res = counter++;
 		head = inode_hashtable + hash(sb, res);
 		inode = find_inode_fast(sb, head, res);
-		if (inode)
-			spin_unlock(&inode->i_lock);
 	} while (inode != NULL);
+	spin_unlock(&inode_hash_lock);
+	if (inode)
+		spin_unlock(&inode->i_lock);
 	spin_unlock(&inode_lock);
 
 	return res;
@@ -963,15 +993,18 @@ static struct inode *ifind(struct super_
 	struct inode *inode;
 
 	spin_lock(&inode_lock);
+	spin_lock(&inode_hash_lock);
 	inode = find_inode(sb, head, test, data);
 	if (inode) {
 		inode_get_ilock(inode);
+		spin_unlock(&inode_hash_lock);
 		spin_unlock(&inode->i_lock);
 		spin_unlock(&inode_lock);
 		if (likely(wait))
 			wait_on_inode(inode);
 		return inode;
 	}
+	spin_unlock(&inode_hash_lock);
 	spin_unlock(&inode_lock);
 	return NULL;
 }
@@ -997,14 +1030,17 @@ static struct inode *ifind_fast(struct s
 	struct inode *inode;
 
 	spin_lock(&inode_lock);
+	spin_lock(&inode_hash_lock);
 	inode = find_inode_fast(sb, head, ino);
 	if (inode) {
 		inode_get_ilock(inode);
+		spin_unlock(&inode_hash_lock);
 		spin_unlock(&inode->i_lock);
 		spin_unlock(&inode_lock);
 		wait_on_inode(inode);
 		return inode;
 	}
+	spin_unlock(&inode_hash_lock);
 	spin_unlock(&inode_lock);
 	return NULL;
 }
@@ -1169,26 +1205,34 @@ int insert_inode_locked(struct inode *in
 		struct hlist_node *node;
 		struct inode *old = NULL;
 		spin_lock(&inode_lock);
+lock_again:
+		spin_lock(&inode_hash_lock);
 		hlist_for_each_entry(old, node, head, i_hash) {
 			if (old->i_ino != ino)
 				continue;
 			if (old->i_sb != sb)
 				continue;
-			spin_lock(&old->i_lock);
+			if (!spin_trylock(&old->i_lock)) {
+				spin_unlock(&inode_hash_lock);
+				cpu_relax();
+				goto lock_again;
+			}
 			if (old->i_state & (I_FREEING|I_WILL_FREE)) {
 				spin_unlock(&old->i_lock);
 				continue;
 			}
 			goto found_old;
 		}
-		spin_lock(&inode->i_lock);
+		BUG_ON(!spin_trylock(&inode->i_lock)); /* XXX: init locked */
 		hlist_add_head(&inode->i_hash, head);
+		spin_unlock(&inode_hash_lock);
 		spin_unlock(&inode->i_lock);
 		spin_unlock(&inode_lock);
 		return 0;
 
 found_old:
 		inode_get_ilock(old);
+		spin_unlock(&inode_hash_lock);
 		spin_unlock(&old->i_lock);
 		spin_unlock(&inode_lock);
 		wait_on_inode(old);
@@ -1214,26 +1258,34 @@ int insert_inode_locked4(struct inode *i
 		struct inode *old = NULL;
 
 		spin_lock(&inode_lock);
+lock_again:
+		spin_lock(&inode_hash_lock);
 		hlist_for_each_entry(old, node, head, i_hash) {
 			if (old->i_sb != sb)
 				continue;
 			if (!test(old, data))
 				continue;
-			spin_lock(&old->i_lock);
+			if (!spin_trylock(&old->i_lock)) {
+				spin_unlock(&inode_hash_lock);
+				cpu_relax();
+				goto lock_again;
+			}
 			if (old->i_state & (I_FREEING|I_WILL_FREE)) {
 				spin_unlock(&old->i_lock);
 				continue;
 			}
 			goto found_old;
 		}
-		spin_lock(&inode->i_lock);
+		BUG_ON(!spin_trylock(&inode->i_lock)); /* XXX: init locked */
 		hlist_add_head(&inode->i_hash, head);
+		spin_unlock(&inode_hash_lock);
 		spin_unlock(&inode->i_lock);
 		spin_unlock(&inode_lock);
 		return 0;
 
 found_old:
 		inode_get_ilock(old);
+		spin_unlock(&inode_hash_lock);
 		spin_unlock(&old->i_lock);
 		spin_unlock(&inode_lock);
 		wait_on_inode(old);
@@ -1259,7 +1311,9 @@ void __insert_inode_hash(struct inode *i
 	struct hlist_head *head = inode_hashtable + hash(inode->i_sb, hashval);
 	spin_lock(&inode_lock);
 	spin_lock(&inode->i_lock);
+	spin_lock(&inode_hash_lock);
 	hlist_add_head(&inode->i_hash, head);
+	spin_unlock(&inode_hash_lock);
 	spin_unlock(&inode->i_lock);
 	spin_unlock(&inode_lock);
 }
@@ -1275,7 +1329,9 @@ void remove_inode_hash(struct inode *ino
 {
 	spin_lock(&inode_lock);
 	spin_lock(&inode->i_lock);
+	spin_lock(&inode_hash_lock);
 	hlist_del_init(&inode->i_hash);
+	spin_unlock(&inode_hash_lock);
 	spin_unlock(&inode->i_lock);
 	spin_unlock(&inode_lock);
 }
@@ -1338,7 +1394,9 @@ static void iput_final(struct inode *ino
 		WARN_ON(inode->i_state & I_NEW);
 		inode->i_state &= ~I_WILL_FREE;
 		inodes_stat.nr_unused--;
+		spin_lock(&inode_hash_lock);
 		hlist_del_init(&inode->i_hash);
+		spin_unlock(&inode_hash_lock);
 	}
 	list_del_init(&inode->i_list);
 	spin_lock(&sb_inode_list_lock);
@@ -1352,7 +1410,9 @@ static void iput_final(struct inode *ino
 	evict(inode);
 	spin_lock(&inode_lock);
 	spin_lock(&inode->i_lock);
+	spin_lock(&inode_hash_lock);
 	hlist_del_init(&inode->i_hash);
+	spin_unlock(&inode_hash_lock);
 	spin_unlock(&inode->i_lock);
 	spin_unlock(&inode_lock);
 	wake_up_inode(inode);
@@ -1573,11 +1633,13 @@ static void __wait_on_freeing_inode(stru
 	DEFINE_WAIT_BIT(wait, &inode->i_state, __I_NEW);
 	wq = bit_waitqueue(&inode->i_state, __I_NEW);
 	prepare_to_wait(wq, &wait.wait, TASK_UNINTERRUPTIBLE);
+	spin_unlock(&inode_hash_lock);
 	spin_unlock(&inode->i_lock);
 	spin_unlock(&inode_lock);
 	schedule();
 	finish_wait(wq, &wait.wait);
 	spin_lock(&inode_lock);
+	spin_lock(&inode_hash_lock);
 }
 
 static __initdata unsigned long ihash_entries;


