Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753495Ab0K0K25 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Nov 2010 05:28:57 -0500
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:26161 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753118Ab0K0K1A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Nov 2010 05:27:00 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApcFAO1p8Ex5Lcx2/2dsb2JhbACVC44Acr12hUcEimGFFA
Message-Id: <28f4b9b0ae724c70466997303aed4c9b76ea0301.1290852959.git.npiggin@kernel.dk>
In-Reply-To: <cover.1290852958.git.npiggin@kernel.dk>
References: <cover.1290852958.git.npiggin@kernel.dk>
From: Nick Piggin <npiggin@kernel.dk>
Date: Sat, 27 Nov 2010 20:44:57 +1100
Subject: [PATCH 27/46] fs: reduce dcache_inode_lock width in lru scanning
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Nick Piggin <npiggin@kernel.dk>
---
 fs/dcache.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index 4fa27b5..5a7c328 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -586,7 +586,7 @@ static void shrink_dentry_list(struct list_head *list)
 		dentry = list_entry(list->prev, struct dentry, d_lru);
 
 		if (!spin_trylock(&dentry->d_lock)) {
-relock:
+relock1:
 			spin_unlock(&dcache_lru_lock);
 			cpu_relax();
 			spin_lock(&dcache_lru_lock);
@@ -603,20 +603,24 @@ relock:
 			spin_unlock(&dentry->d_lock);
 			continue;
 		}
+		if (!spin_trylock(&dcache_inode_lock)) {
+relock2:
+			spin_unlock(&dentry->d_lock);
+			goto relock1;
+		}
 		if (IS_ROOT(dentry))
 			parent = NULL;
 		else
 			parent = dentry->d_parent;
 		if (parent && !spin_trylock(&parent->d_lock)) {
-			spin_unlock(&dentry->d_lock);
-			goto relock;
+			spin_unlock(&dcache_inode_lock);
+			goto relock2;
 		}
 		__dentry_lru_del(dentry);
 		spin_unlock(&dcache_lru_lock);
 
 		prune_one_dentry(dentry, parent);
 		/* dcache_inode_lock and dentry->d_lock dropped */
-		spin_lock(&dcache_inode_lock);
 		spin_lock(&dcache_lru_lock);
 	}
 }
@@ -637,7 +641,6 @@ static void __shrink_dcache_sb(struct super_block *sb, int *count, int flags)
 	LIST_HEAD(tmp);
 	int cnt = *count;
 
-	spin_lock(&dcache_inode_lock);
 relock:
 	spin_lock(&dcache_lru_lock);
 	while (!list_empty(&sb->s_dentry_lru)) {
@@ -675,7 +678,6 @@ relock:
 	if (!list_empty(&referenced))
 		list_splice(&referenced, &sb->s_dentry_lru);
 	spin_unlock(&dcache_lru_lock);
-	spin_unlock(&dcache_inode_lock);
 }
 
 /**
@@ -764,14 +766,12 @@ void shrink_dcache_sb(struct super_block *sb)
 {
 	LIST_HEAD(tmp);
 
-	spin_lock(&dcache_inode_lock);
 	spin_lock(&dcache_lru_lock);
 	while (!list_empty(&sb->s_dentry_lru)) {
 		list_splice_init(&sb->s_dentry_lru, &tmp);
 		shrink_dentry_list(&tmp);
 	}
 	spin_unlock(&dcache_lru_lock);
-	spin_unlock(&dcache_inode_lock);
 }
 EXPORT_SYMBOL(shrink_dcache_sb);
 
-- 
1.7.1

