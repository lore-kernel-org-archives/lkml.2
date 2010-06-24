Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754693Ab0FXDQn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 23:16:43 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36027 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754184Ab0FXDPv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 23:15:51 -0400
Message-Id: <20100624030732.852905122@suse.de>
User-Agent: quilt/0.48-4.4
Date: Thu, 24 Jun 2010 13:02:57 +1000
From: npiggin@suse.de
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: John Stultz <johnstul@us.ibm.com>, Frank Mayhar <fmayhar@google.com>
Subject: [patch 45/52] fs: icache RCU hash lookups
References: <20100624030212.676457061@suse.de>
Content-Disposition: inline; filename=fs-inode-hash-rcu.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Nick Piggin <npiggin@suse.de>
---
 fs/inode.c |   38 ++++++++++++++++++++------------------
 1 file changed, 20 insertions(+), 18 deletions(-)

Index: linux-2.6/fs/inode.c
===================================================================
--- linux-2.6.orig/fs/inode.c
+++ linux-2.6/fs/inode.c
@@ -603,27 +603,27 @@ static struct inode *find_inode(struct s
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
 		if (inode->i_state & (I_FREEING|I_CLEAR|I_WILL_FREE)) {
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
 
@@ -639,25 +639,25 @@ static struct inode *find_inode_fast(str
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
 		if (inode->i_state & (I_FREEING|I_CLEAR|I_WILL_FREE)) {
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
 


