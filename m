Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752006Ab0JSEBS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 00:01:18 -0400
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:28439 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933435Ab0JSD4R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 23:56:17 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AnEFAJyxvEx5LcB2gWdsb2JhbACUbYx6FgEBFiIiwxaFSQSKSg
Message-Id: <20101019034658.003190769@kernel.dk>
User-Agent: quilt/0.48-1
Date: Tue, 19 Oct 2010 14:42:40 +1100
From: npiggin@kernel.dk
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [patch 24/35] fs: icache use RCU to avoid locking in hash lookups
References: <20101019034216.319085068@kernel.dk>
Content-Disposition: inline; filename=fs-inode-hash-rcu.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Nick Piggin <npiggin@kernel.dk>

---
 fs/inode.c |   32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

Index: linux-2.6/fs/inode.c
===================================================================
--- linux-2.6.orig/fs/inode.c	2010-10-19 14:18:59.000000000 +1100
+++ linux-2.6/fs/inode.c	2010-10-19 14:19:22.000000000 +1100
@@ -646,27 +646,27 @@
 	struct inode *inode = NULL;
 
 repeat:
-	spin_lock_bucket(b);
-	hlist_bl_for_each_entry(inode, node, &b->head, i_hash) {
+	rcu_read_lock();
+	hlist_bl_for_each_entry_rcu(inode, node, &b->head, i_hash) {
 		if (inode->i_sb != sb)
 			continue;
-		if (!spin_trylock(&inode->i_lock)) {
-			spin_unlock_bucket(b);
-			cpu_relax();
-			goto repeat;
+		spin_lock(&inode->i_lock);
+		if (hlist_bl_unhashed(&inode->i_hash)) {
+			spin_unlock(&inode->i_lock);
+			continue;
 		}
 		if (!test(inode, data)) {
 			spin_unlock(&inode->i_lock);
 			continue;
 		}
 		if (inode->i_state & (I_FREEING|I_WILL_FREE)) {
-			spin_unlock_bucket(b);
+			rcu_read_unlock();
 			__wait_on_freeing_inode(inode);
 			goto repeat;
 		}
 		break;
 	}
-	spin_unlock_bucket(b);
+	rcu_read_unlock();
 	return node ? inode : NULL;
 }
 
@@ -682,25 +682,25 @@
 	struct inode *inode = NULL;
 
 repeat:
-	spin_lock_bucket(b);
-	hlist_bl_for_each_entry(inode, node, &b->head, i_hash) {
+	rcu_read_lock();
+	hlist_bl_for_each_entry_rcu(inode, node, &b->head, i_hash) {
 		if (inode->i_ino != ino)
 			continue;
 		if (inode->i_sb != sb)
 			continue;
-		if (!spin_trylock(&inode->i_lock)) {
-			spin_unlock_bucket(b);
-			cpu_relax();
-			goto repeat;
+		spin_lock(&inode->i_lock);
+		if (hlist_bl_unhashed(&inode->i_hash)) {
+			spin_unlock(&inode->i_lock);
+			continue;
 		}
 		if (inode->i_state & (I_FREEING|I_WILL_FREE)) {
-			spin_unlock_bucket(b);
+			rcu_read_unlock();
 			__wait_on_freeing_inode(inode);
 			goto repeat;
 		}
 		break;
 	}
-	spin_unlock_bucket(b);
+	rcu_read_unlock();
 	return node ? inode : NULL;
 }
 


