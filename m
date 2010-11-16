Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758392Ab0KPOYz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 09:24:55 -0500
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:32788 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758625Ab0KPOYH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 09:24:07 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AogKAKMh4kx5Ldur/2dsb2JhbACUX4ECjH1yvmaFSwSKWIUQ
Message-Id: <20101116142030.809122063@kernel.dk>
User-Agent: quilt/0.48-1
Date: Wed, 17 Nov 2010 01:09:27 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [patch 27/28] fs: use RCU in shrink_dentry_list to reduce lock nesting
References: <20101116140900.039761100@kernel.dk>
Content-Disposition: inline; filename=dcache-lru-scanning-rcu.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Nick Piggin <npiggin@kernel.dk>

---
 fs/dcache.c |   38 +++++++++++++++++++++-----------------
 1 file changed, 21 insertions(+), 17 deletions(-)

Index: linux-2.6/fs/dcache.c
===================================================================
--- linux-2.6.orig/fs/dcache.c	2010-11-17 00:52:38.000000000 +1100
+++ linux-2.6/fs/dcache.c	2010-11-17 01:05:37.000000000 +1100
@@ -580,16 +580,16 @@ static void shrink_dentry_list(struct li
 {
 	struct dentry *dentry;
 
+	rcu_read_lock();
 	while (!list_empty(list)) {
 		struct dentry *parent;
 
 		dentry = list_entry(list->prev, struct dentry, d_lru);
 
-		if (!spin_trylock(&dentry->d_lock)) {
-relock1:
-			spin_unlock(&dcache_lru_lock);
-			cpu_relax();
-			spin_lock(&dcache_lru_lock);
+		/* Don't need RCU dereference because we recheck under lock */
+		spin_lock(&dentry->d_lock);
+		if (dentry != list_entry(list->prev, struct dentry, d_lru)) {
+			spin_unlock(&dentry->d_lock);
 			continue;
 		}
 
@@ -599,14 +599,16 @@ static void shrink_dentry_list(struct li
 		 * it - just keep it off the LRU list.
 		 */
 		if (dentry->d_count) {
-			__dentry_lru_del(dentry);
+			dentry_lru_del(dentry);
 			spin_unlock(&dentry->d_lock);
 			continue;
 		}
+
 		if (!spin_trylock(&dcache_inode_lock)) {
-relock2:
+relock:
 			spin_unlock(&dentry->d_lock);
-			goto relock1;
+			cpu_relax();
+			continue;
 		}
 		if (IS_ROOT(dentry))
 			parent = NULL;
@@ -614,15 +616,15 @@ static void shrink_dentry_list(struct li
 			parent = dentry->d_parent;
 		if (parent && !spin_trylock(&parent->d_lock)) {
 			spin_unlock(&dcache_inode_lock);
-			goto relock2;
+			goto relock;
 		}
-		__dentry_lru_del(dentry);
-		spin_unlock(&dcache_lru_lock);
+		dentry_lru_del(dentry);
 
+		rcu_read_unlock();
 		prune_one_dentry(dentry, parent);
-		/* dcache_inode_lock and dentry->d_lock dropped */
-		spin_lock(&dcache_lru_lock);
+		rcu_read_lock();
 	}
+	rcu_read_unlock();
 }
 
 /**
@@ -671,13 +673,13 @@ static void __shrink_dcache_sb(struct su
 				break;
 		}
 	}
-
-	*count = cnt;
-	shrink_dentry_list(&tmp);
-
 	if (!list_empty(&referenced))
 		list_splice(&referenced, &sb->s_dentry_lru);
 	spin_unlock(&dcache_lru_lock);
+
+	shrink_dentry_list(&tmp);
+
+	*count = cnt;
 }
 
 /**
@@ -769,7 +771,9 @@ void shrink_dcache_sb(struct super_block
 	spin_lock(&dcache_lru_lock);
 	while (!list_empty(&sb->s_dentry_lru)) {
 		list_splice_init(&sb->s_dentry_lru, &tmp);
+		spin_unlock(&dcache_lru_lock);
 		shrink_dentry_list(&tmp);
+		spin_lock(&dcache_lru_lock);
 	}
 	spin_unlock(&dcache_lru_lock);
 }


