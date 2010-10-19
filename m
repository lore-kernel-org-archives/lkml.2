Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751092Ab0JSEAJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 00:00:09 -0400
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:35868 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933640Ab0JSD7O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 23:59:14 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AnEFAJyxvEx5LcB2gWdsb2JhbACUbYx6FgEBFiIiwxaFSQSKSg
Message-Id: <20101019034656.936568369@kernel.dk>
User-Agent: quilt/0.48-1
Date: Tue, 19 Oct 2010 14:42:30 +1100
From: npiggin@kernel.dk
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [patch 14/35] fs: icache factor hash lock into functions
References: <20101019034216.319085068@kernel.dk>
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
--- linux-2.6.orig/fs/inode.c	2010-10-19 14:18:59.000000000 +1100
+++ linux-2.6/fs/inode.c	2010-10-19 14:19:31.000000000 +1100
@@ -353,6 +353,8 @@
 		cd_forget(inode);
 }
 
+static void __remove_inode_hash(struct inode *inode);
+
 /*
  * dispose_list - dispose of the contents of a local list
  * @head: the head of the list to free
@@ -372,9 +374,7 @@
 
 		spin_lock(&sb_inode_list_lock);
 		spin_lock(&inode->i_lock);
-		spin_lock(&inode_hash_lock);
-		hlist_del_init(&inode->i_hash);
-		spin_unlock(&inode_hash_lock);
+		__remove_inode_hash(inode);
 		list_del_init(&inode->i_sb_list);
 		spin_unlock(&inode->i_lock);
 		spin_unlock(&sb_inode_list_lock);
@@ -1284,6 +1284,20 @@
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
@@ -1292,9 +1306,7 @@
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
@@ -1358,9 +1370,7 @@
 		spin_lock(&inode->i_lock);
 		WARN_ON(inode->i_state & I_NEW);
 		inode->i_state &= ~I_WILL_FREE;
-		spin_lock(&inode_hash_lock);
-		hlist_del_init(&inode->i_hash);
-		spin_unlock(&inode_hash_lock);
+		__remove_inode_hash(inode);
 		atomic_dec(&inodes_stat.nr_unused);
 	}
 	spin_lock(&wb_inode_list_lock);
@@ -1372,11 +1382,11 @@
 	inode->i_state |= I_FREEING;
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


