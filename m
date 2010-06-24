Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754954Ab0FXDYh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 23:24:37 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36056 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753960Ab0FXDP7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 23:15:59 -0400
Message-Id: <20100624030734.042332166@suse.de>
User-Agent: quilt/0.48-4.4
Date: Thu, 24 Jun 2010 13:03:04 +1000
From: npiggin@suse.de
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: John Stultz <johnstul@us.ibm.com>, Frank Mayhar <fmayhar@google.com>
Subject: [patch 52/52] fs: icache less I_FREEING time
References: <20100624030212.676457061@suse.de>
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

Signed-off-by: Nick Piggin <npiggin@suse.de>

Index: linux-2.6/fs/inode.c
===================================================================
--- linux-2.6.orig/fs/inode.c
+++ linux-2.6/fs/inode.c
@@ -390,6 +390,19 @@ EXPORT_SYMBOL(clear_inode);
 
 static void inode_sb_list_del(struct inode *inode);
 
+static void dispose_one_inode(struct inode *inode)
+{
+	clear_inode(inode);
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
@@ -409,15 +422,8 @@ static void dispose_list(struct list_hea
 
 		if (inode->i_data.nrpages)
 			truncate_inode_pages(&inode->i_data, 0);
-		clear_inode(inode);
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
 		nr_disposed++;
 	}
 }
@@ -526,7 +532,6 @@ EXPORT_SYMBOL(invalidate_inodes);
  */
 static void prune_icache(struct zone *zone, unsigned long nr_to_scan)
 {
-	LIST_HEAD(freeable);
 	unsigned long reap = 0;
 
 	down_read(&iprune_sem);
@@ -563,8 +568,6 @@ again:
 			__iget(inode);
 			spin_unlock(&inode->i_lock);
 
-			dispose_list(&freeable);
-
 			if (remove_inode_buffers(inode))
 				reap += invalidate_mapping_pages(&inode->i_data,
 								0, -1);
@@ -572,11 +575,15 @@ again:
 			spin_lock(&zone->inode_lru_lock);
 			continue;
 		}
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
@@ -584,7 +591,6 @@ again:
 		__count_vm_events(PGINODESTEAL, reap);
 	spin_unlock(&zone->inode_lru_lock);
 
-	dispose_list(&freeable);
 	up_read(&iprune_sem);
 }
 


