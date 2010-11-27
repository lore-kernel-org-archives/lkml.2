Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753488Ab0K0K2D (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Nov 2010 05:28:03 -0500
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:58234 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753345Ab0K0K1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Nov 2010 05:27:07 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApcFAO1p8Ex5Lcx2/2dsb2JhbACVC44Acr12hUcEimE
Message-Id: <155252edd9f31ae2b61dca9a58e1ddc90b0a2d20.1290852959.git.npiggin@kernel.dk>
In-Reply-To: <cover.1290852958.git.npiggin@kernel.dk>
References: <cover.1290852958.git.npiggin@kernel.dk>
From: Nick Piggin <npiggin@kernel.dk>
Date: Sat, 27 Nov 2010 20:44:51 +1100
Subject: [PATCH 21/46] fs: dcache reduce dput locking
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is possible to run dput without taking data structure locks up-front. In
many cases where we don't kill the dentry anyway, these locks are not required.

Signed-off-by: Nick Piggin <npiggin@kernel.dk>
---
 fs/dcache.c |   56 +++++++++++++++++++++++++-------------------------------
 1 files changed, 25 insertions(+), 31 deletions(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index 73f5552..a117139 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -283,35 +283,16 @@ repeat:
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
@@ -322,17 +303,30 @@ drop2:
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
-- 
1.7.1

