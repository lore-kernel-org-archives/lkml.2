Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758999Ab0KPOYi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 09:24:38 -0500
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:3958 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758731Ab0KPOYI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 09:24:08 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AogKAKMh4kx5Ldur/2dsb2JhbACUX4ECjH1yvmaFSwSKWA
Message-Id: <20101116142030.117651787@kernel.dk>
User-Agent: quilt/0.48-1
Date: Wed, 17 Nov 2010 01:09:20 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [patch 20/28] fs: dcache reduce dput locking
References: <20101116140900.039761100@kernel.dk>
Content-Disposition: inline; filename=dcache-dput-less-dcache_lock.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is possible to run dput without taking data structure locks up-front. In
many cases where we don't kill the dentry anyway, these locks are not required.

Signed-off-by: Nick Piggin <npiggin@kernel.dk>

---
 fs/dcache.c |   56 +++++++++++++++++++++++++-------------------------------
 1 file changed, 25 insertions(+), 31 deletions(-)

Index: linux-2.6/fs/dcache.c
===================================================================
--- linux-2.6.orig/fs/dcache.c	2010-11-17 00:52:37.000000000 +1100
+++ linux-2.6/fs/dcache.c	2010-11-17 01:05:40.000000000 +1100
@@ -283,35 +283,16 @@ void dput(struct dentry *dentry)
 	if (dentry->d_count == 1)
 		might_sleep();
 	spin_lock(&dentry->d_lock);
-	if (IS_ROOT(dentry))
-		parent = NULL;
-	else
-		parent = dentry->d_parent;
-	if (dentry->d_count == 1) {
-		if (!spin_trylock(&dcache_inode_lock)) {
-drop2:
-			spin_unlock(&dentry->d_lock);
-			goto repeat;
-		}
-		if (parent && !spin_trylock(&parent->d_lock)) {
-			spin_unlock(&dcache_inode_lock);
-			goto drop2;
-		}
-	}
-	dentry->d_count--;
-	if (dentry->d_count) {
+	BUG_ON(!dentry->d_count);
+	if (dentry->d_count > 1) {
+		dentry->d_count--;
 		spin_unlock(&dentry->d_lock);
-		if (parent)
-			spin_unlock(&parent->d_lock);
-		return;
-	}
+ 		return;
+ 	}
 
-	/*
-	 * AV: ->d_delete() is _NOT_ allowed to block now.
-	 */
 	if (dentry->d_op && dentry->d_op->d_delete) {
 		if (dentry->d_op->d_delete(dentry))
-			goto unhash_it;
+			goto kill_it;
 	}
 
 	/* Unreachable? Get rid of it */
@@ -322,17 +303,30 @@ void dput(struct dentry *dentry)
 	dentry->d_flags |= DCACHE_REFERENCED;
 	dentry_lru_add(dentry);
 
- 	spin_unlock(&dentry->d_lock);
-	if (parent)
-		spin_unlock(&parent->d_lock);
-	spin_unlock(&dcache_inode_lock);
+	dentry->d_count--;
+	spin_unlock(&dentry->d_lock);
 	return;
 
-unhash_it:
-	__d_drop(dentry);
 kill_it:
+	if (!spin_trylock(&dcache_inode_lock)) {
+relock:
+		spin_unlock(&dentry->d_lock);
+		cpu_relax();
+		goto repeat;
+	}
+	if (IS_ROOT(dentry))
+		parent = NULL;
+	else
+		parent = dentry->d_parent;
+	if (parent && !spin_trylock(&parent->d_lock)) {
+		spin_unlock(&dcache_inode_lock);
+		goto relock;
+	}
+	dentry->d_count--;
 	/* if dentry was on the d_lru list delete it from there */
 	dentry_lru_del(dentry);
+	/* if it was on the hash (d_delete case), then remove it */
+	__d_drop(dentry);
 	dentry = d_kill(dentry, parent);
 	if (dentry)
 		goto repeat;


