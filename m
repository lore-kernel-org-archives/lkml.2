Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933767Ab0JSD5F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 23:57:05 -0400
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:28439 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933693Ab0JSD4Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 23:56:24 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AnEFAJyxvEx5LcB2gWdsb2JhbACUbYx6FgEBFiIiwxaFSQSKSoUA
Message-Id: <20101019034658.852112492@kernel.dk>
User-Agent: quilt/0.48-1
Date: Tue, 19 Oct 2010 14:42:48 +1100
From: npiggin@kernel.dk
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [patch 32/35] fs: icache minimise I_FREEING latency
References: <20101019034216.319085068@kernel.dk>
Content-Disposition: inline; filename=fs-inode-less-i_freeing.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Problem with inode reclaim is that it puts inodes into I_FREEING state
and then continues to gather more, during which it may iput,
invalidate_mapping_pages, be preempted, etc. Holding these inodes in
I_FREEING can cause pauses.

After the inode scalability work, there is not a big reason to batch
up inodes to reclaim them, so dispose them as they are found from the
LRU.

Signed-off-by: Nick Piggin <npiggin@kernel.dk>

---
 fs/inode.c |   32 ++++++++++++++++++++------------
 1 file changed, 20 insertions(+), 12 deletions(-)

Index: linux-2.6/fs/inode.c
===================================================================
--- linux-2.6.orig/fs/inode.c	2010-10-19 14:19:00.000000000 +1100
+++ linux-2.6/fs/inode.c	2010-10-19 14:19:18.000000000 +1100
@@ -410,6 +410,19 @@
 
 static void inode_sb_list_del(struct inode *inode);
 
+static void dispose_one_inode(struct inode *inode)
+{
+	evict(inode);
+
+	spin_lock(&inode->i_lock);
+	__remove_inode_hash(inode);
+	inode_sb_list_del(inode);
+	spin_unlock(&inode->i_lock);
+
+	wake_up_inode(inode);
+	destroy_inode(inode);
+}
+
 /*
  * dispose_list - dispose of the contents of a local list
  * @head: the head of the list to free
@@ -425,15 +438,8 @@
 		inode = list_first_entry(head, struct inode, i_lru);
 		list_del_init(&inode->i_lru);
 
-		evict(inode);
-
-		spin_lock(&inode->i_lock);
-		__remove_inode_hash(inode);
-		inode_sb_list_del(inode);
-		spin_unlock(&inode->i_lock);
-
-		wake_up_inode(inode);
-		destroy_inode(inode);
+		dispose_one_inode(inode);
+		cond_resched();
 	}
 }
 
@@ -557,7 +563,6 @@
  */
 static void prune_icache(struct zone *zone, unsigned long nr_to_scan)
 {
-	LIST_HEAD(freeable);
 	unsigned long reap = 0;
 
 	down_read(&iprune_sem);
@@ -617,11 +622,15 @@
 			continue;
 		}
 freeable:
-		list_move(&inode->i_lru, &freeable);
+		list_del_init(&inode->i_lru);
 		WARN_ON(inode->i_state & I_NEW);
 		inode->i_state |= I_FREEING;
 		spin_unlock(&inode->i_lock);
 		zone->inode_nr_lru--;
+		spin_unlock(&zone->inode_lru_lock);
+		dispose_one_inode(inode);
+		cond_resched();
+		spin_lock(&zone->inode_lru_lock);
 	}
 	if (current_is_kswapd())
 		__count_vm_events(KSWAPD_INODESTEAL, reap);
@@ -629,7 +638,6 @@
 		__count_vm_events(PGINODESTEAL, reap);
 	spin_unlock(&zone->inode_lru_lock);
 
-	dispose_list(&freeable);
 	up_read(&iprune_sem);
 }
 


