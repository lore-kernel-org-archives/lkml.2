Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752894Ab0K0K0Y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Nov 2010 05:26:24 -0500
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:34794 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752876Ab0K0K0R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Nov 2010 05:26:17 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApcFAO1p8Ex5Lcx2/2dsb2JhbACVC44Acr12hUcEimGFFA
Message-Id: <41cf0f67bed97948600e55e25a1081523a699afe.1290852959.git.npiggin@kernel.dk>
In-Reply-To: <cover.1290852958.git.npiggin@kernel.dk>
References: <cover.1290852958.git.npiggin@kernel.dk>
From: Nick Piggin <npiggin@kernel.dk>
Date: Sat, 27 Nov 2010 20:44:58 +1100
Subject: [PATCH 28/46] fs: use RCU in shrink_dentry_list to reduce lock nesting
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Nick Piggin <npiggin@kernel.dk>
---
 fs/dcache.c |   38 +++++++++++++++++++++-----------------
 1 files changed, 21 insertions(+), 17 deletions(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index 5a7c328..4dbcb6c 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -580,16 +580,16 @@ static void shrink_dentry_list(struct list_head *list)
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
 
@@ -599,14 +599,16 @@ relock1:
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
@@ -614,15 +616,15 @@ relock2:
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
@@ -671,13 +673,13 @@ relock:
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
@@ -769,7 +771,9 @@ void shrink_dcache_sb(struct super_block *sb)
 	spin_lock(&dcache_lru_lock);
 	while (!list_empty(&sb->s_dentry_lru)) {
 		list_splice_init(&sb->s_dentry_lru, &tmp);
+		spin_unlock(&dcache_lru_lock);
 		shrink_dentry_list(&tmp);
+		spin_lock(&dcache_lru_lock);
 	}
 	spin_unlock(&dcache_lru_lock);
 }
-- 
1.7.1

