Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759411Ab0KPO0O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 09:26:14 -0500
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:3958 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758645Ab0KPOYB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 09:24:01 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AogKAKMh4kx5Ldur/2dsb2JhbACUX4ECjH1yvmaFSwSKWIUQ
Message-Id: <20101116142030.710208884@kernel.dk>
User-Agent: quilt/0.48-1
Date: Wed, 17 Nov 2010 01:09:26 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [patch 26/28] fs: reduce dcache_inode_lock width in lru scanning
References: <20101116140900.039761100@kernel.dk>
Content-Disposition: inline; filename=dcache-lru-scanning-less-lock.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Nick Piggin <npiggin@kernel.dk>

---
 fs/dcache.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

Index: linux-2.6/fs/dcache.c
===================================================================
--- linux-2.6.orig/fs/dcache.c	2010-11-17 00:52:38.000000000 +1100
+++ linux-2.6/fs/dcache.c	2010-11-17 01:05:37.000000000 +1100
@@ -586,7 +586,7 @@ static void shrink_dentry_list(struct li
 		dentry = list_entry(list->prev, struct dentry, d_lru);
 
 		if (!spin_trylock(&dentry->d_lock)) {
-relock:
+relock1:
 			spin_unlock(&dcache_lru_lock);
 			cpu_relax();
 			spin_lock(&dcache_lru_lock);
@@ -603,20 +603,24 @@ static void shrink_dentry_list(struct li
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
@@ -637,7 +641,6 @@ static void __shrink_dcache_sb(struct su
 	LIST_HEAD(tmp);
 	int cnt = *count;
 
-	spin_lock(&dcache_inode_lock);
 relock:
 	spin_lock(&dcache_lru_lock);
 	while (!list_empty(&sb->s_dentry_lru)) {
@@ -675,7 +678,6 @@ static void __shrink_dcache_sb(struct su
 	if (!list_empty(&referenced))
 		list_splice(&referenced, &sb->s_dentry_lru);
 	spin_unlock(&dcache_lru_lock);
-	spin_unlock(&dcache_inode_lock);
 }
 
 /**
@@ -764,14 +766,12 @@ void shrink_dcache_sb(struct super_block
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
 


