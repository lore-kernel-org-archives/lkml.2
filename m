Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758053Ab0JUNWx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 09:22:53 -0400
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:7306 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758003Ab0JUNWs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 09:22:48 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AoAGAGfav0x5LdoFgWdsb2JhbACUZ4xxFgEBFiIiwC+FSgSKTQ
Message-Id: <20101021131017.375682018@kernel.dk>
User-Agent: quilt/0.48-1
Date: Fri, 22 Oct 2010 00:08:43 +1100
From: npiggin@kernel.dk
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        npiggin@kernel.dk
Subject: [patch 14/14] fs: icache split writeback and lru locks
References: <20101021130829.442910807@kernel.dk>
Content-Disposition: inline; filename=fs-inode-split-wb-lru-locks.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Split wb_inode_list_lock lock into two locks, inode_lru_lock to protect
inode LRU list, and a per-bdi lock to protect the inode writeback lists.

Signed-off-by: Nick Piggin <npiggin@kernel.dk>

---
 fs/inode.c |   26 +++++++++++++++-----------
 1 file changed, 15 insertions(+), 11 deletions(-)

Index: linux-2.6/fs/inode.c
===================================================================
--- linux-2.6.orig/fs/inode.c	2010-10-21 23:50:27.000000000 +1100
+++ linux-2.6/fs/inode.c	2010-10-21 23:50:27.000000000 +1100
@@ -40,13 +40,16 @@
  *   s_inodes, i_sb_list
  * inode_hash_lock protects:
  *   inode hash table, i_hash
+ * inode_lru_lock protects:
+ *   inode_lru, i_lru
  * wb_inode_list_lock protects:
- *   inode_lru, b_io, b_more_io, b_dirty, i_lru, i_io
+ *   b_io, b_more_io, b_dirty, i_io
  *
  * Ordering:
  * i_lock
  *   sb_inode_list_lock
  *   wb_inode_list_lock
+ *   inode_lru_lock
  *   inode_hash_lock
  */
 /*
@@ -107,6 +110,7 @@ static struct hlist_head *inode_hashtabl
  */
 DEFINE_SPINLOCK(sb_inode_list_lock);
 DEFINE_SPINLOCK(wb_inode_list_lock);
+static DEFINE_SPINLOCK(inode_lru_lock);
 static DEFINE_SPINLOCK(inode_hash_lock);
 
 /*
@@ -394,9 +398,9 @@ static void evict(struct inode *inode)
 static void insert_inode_lru(struct inode *inode)
 {
 	if (list_empty(&inode->i_lru)) {
-		spin_lock(&wb_inode_list_lock);
+		spin_lock(&inode_lru_lock);
 		list_add(&inode->i_lru, &inode_lru);
-		spin_unlock(&wb_inode_list_lock);
+		spin_unlock(&inode_lru_lock);
 		atomic_inc(&nr_unused);
 	}
 }
@@ -404,9 +408,9 @@ static void insert_inode_lru(struct inod
 static void remove_inode_lru(struct inode *inode)
 {
 	if (!list_empty(&inode->i_lru)) {
-		spin_lock(&wb_inode_list_lock);
+		spin_lock(&inode_lru_lock);
 		list_del_init(&inode->i_lru);
-		spin_unlock(&wb_inode_list_lock);
+		spin_unlock(&inode_lru_lock);
 		atomic_dec(&nr_unused);
 	}
 }
@@ -561,7 +565,7 @@ static void prune_icache(int nr_to_scan)
 
 	down_read(&iprune_sem);
 lock_again:
-	spin_lock(&wb_inode_list_lock);
+	spin_lock(&inode_lru_lock);
 	for (nr_scanned = 0; nr_scanned < nr_to_scan; nr_scanned++) {
 		struct inode *inode;
 
@@ -571,7 +575,7 @@ static void prune_icache(int nr_to_scan)
 		inode = list_entry(inode_lru.prev, struct inode, i_lru);
 
 		if (!spin_trylock(&inode->i_lock)) {
-			spin_unlock(&wb_inode_list_lock);
+			spin_unlock(&inode_lru_lock);
 			cpu_relax();
 			goto lock_again;
 		}
@@ -598,16 +602,16 @@ static void prune_icache(int nr_to_scan)
 			 */
 			list_move(&inode->i_lru, &inode_lru);
 			inode->i_count++;
-			spin_unlock(&wb_inode_list_lock);
+			spin_unlock(&inode_lru_lock);
 			spin_unlock(&inode->i_lock);
 			if (remove_inode_buffers(inode))
 				reap += invalidate_mapping_pages(&inode->i_data,
 								0, -1);
 			iput(inode);
 lock_again_2:
-			spin_lock(&wb_inode_list_lock);
+			spin_lock(&inode_lru_lock);
 			if (!spin_trylock(&inode->i_lock)) {
-				spin_unlock(&wb_inode_list_lock);
+				spin_unlock(&inode_lru_lock);
 				cpu_relax();
 				goto lock_again_2;
 			}
@@ -633,7 +637,7 @@ static void prune_icache(int nr_to_scan)
 		__count_vm_events(KSWAPD_INODESTEAL, reap);
 	else
 		__count_vm_events(PGINODESTEAL, reap);
-	spin_unlock(&wb_inode_list_lock);
+	spin_unlock(&inode_lru_lock);
 
 	dispose_list(&freeable);
 	up_read(&iprune_sem);


