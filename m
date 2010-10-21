Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758132Ab0JUNZC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 09:25:02 -0400
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:11481 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758006Ab0JUNWt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 09:22:49 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AoAGAGfav0x5LdoFgWdsb2JhbACUZ4xxFgEBFiIiwC+FSgSKTQ
Message-Id: <20101021131017.066884583@kernel.dk>
User-Agent: quilt/0.48-1
Date: Fri, 22 Oct 2010 00:08:40 +1100
From: npiggin@kernel.dk
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        npiggin@kernel.dk
Subject: [patch 11/14] fs: icache factor hash lock into functions
References: <20101021130829.442910807@kernel.dk>
Content-Disposition: inline; filename=fs-inode_lock-scale-8.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a function __remove_inode_hash

Signed-off-by: Nick Piggin <npiggin@kernel.dk>

---
 fs/inode.c |   38 ++++++++++++++++++++++++--------------
 1 file changed, 24 insertions(+), 14 deletions(-)

Index: linux-2.6/fs/inode.c
===================================================================
--- linux-2.6.orig/fs/inode.c	2010-10-21 23:50:27.000000000 +1100
+++ linux-2.6/fs/inode.c	2010-10-21 23:50:41.000000000 +1100
@@ -432,6 +432,8 @@ static void evict(struct inode *inode)
 		cd_forget(inode);
 }
 
+static void __remove_inode_hash(struct inode *inode);
+
 /*
  * dispose_list - dispose of the contents of a local list
  * @head: the head of the list to free
@@ -453,9 +455,7 @@ static void dispose_list(struct list_hea
 		evict(inode);
 
 		spin_lock(&inode->i_lock);
-		spin_lock(&inode_hash_lock);
-		hlist_del_init(&inode->i_hash);
-		spin_unlock(&inode_hash_lock);
+		__remove_inode_hash(inode);
 		spin_lock(&sb_inode_list_lock);
 		list_del_init(&inode->i_sb_list);
 		spin_unlock(&sb_inode_list_lock);
@@ -1380,6 +1380,20 @@ void __insert_inode_hash(struct inode *i
 EXPORT_SYMBOL(__insert_inode_hash);
 
 /**
+ *	__remove_inode_hash - remove an inode from the hash
+ *	@inode: inode to unhash
+ *
+ *	Remove an inode from the superblock. inode->i_lock must be
+ *	held.
+ */
+static void __remove_inode_hash(struct inode *inode)
+{
+	spin_lock(&inode_hash_lock);
+	hlist_del_init(&inode->i_hash);
+	spin_unlock(&inode_hash_lock);
+}
+
+/**
  *	remove_inode_hash - remove an inode from the hash
  *	@inode: inode to unhash
  *
@@ -1388,9 +1402,7 @@ EXPORT_SYMBOL(__insert_inode_hash);
 void remove_inode_hash(struct inode *inode)
 {
 	spin_lock(&inode->i_lock);
-	spin_lock(&inode_hash_lock);
-	hlist_del_init(&inode->i_hash);
-	spin_unlock(&inode_hash_lock);
+	__remove_inode_hash(inode);
 	spin_unlock(&inode->i_lock);
 }
 EXPORT_SYMBOL(remove_inode_hash);
@@ -1452,9 +1464,7 @@ static void iput_final(struct inode *ino
 		WARN_ON(inode->i_state & I_NEW);
 		inode->i_state &= ~I_WILL_FREE;
 		atomic_dec(&nr_unused);
-		spin_lock(&inode_hash_lock);
-		hlist_del_init(&inode->i_hash);
-		spin_unlock(&inode_hash_lock);
+		__remove_inode_hash(inode);
 	}
 	spin_lock(&wb_inode_list_lock);
 	list_del_init(&inode->i_list);
@@ -1467,11 +1477,11 @@ static void iput_final(struct inode *ino
 	atomic_dec(&nr_inodes);
 	spin_unlock(&inode->i_lock);
 	evict(inode);
-	spin_lock(&inode->i_lock);
-	spin_lock(&inode_hash_lock);
-	hlist_del_init(&inode->i_hash);
-	spin_unlock(&inode_hash_lock);
-	spin_unlock(&inode->i_lock);
+	/*
+	 * i_lock is required to delete from hash because find_inode_fast
+	 * might find us but go to sleep before we run wake_up_inode.
+	 */
+	remove_inode_hash(inode);
 	wake_up_inode(inode);
 	BUG_ON(inode->i_state != (I_FREEING | I_CLEAR));
 	destroy_inode(inode);


