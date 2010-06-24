Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754464Ab0FXDQW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 23:16:22 -0400
Received: from cantor.suse.de ([195.135.220.2]:48436 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754058Ab0FXDPp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 23:15:45 -0400
Message-Id: <20100624030728.509091138@suse.de>
User-Agent: quilt/0.48-4.4
Date: Thu, 24 Jun 2010 13:02:30 +1000
From: npiggin@suse.de
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: John Stultz <johnstul@us.ibm.com>, Frank Mayhar <fmayhar@google.com>
Subject: [patch 18/52] fs: dcache reduce dput locking
References: <20100624030212.676457061@suse.de>
Content-Disposition: inline; filename=dcache-dput-less-dcache_lock.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is possible to run dput without taking locks up-front. In many cases
where we don't kill the dentry anyway, these locks are not required.

(I think... need to think about it more). Further changes ->d_delete
locking which is not all audited. d_delete must be idempotent, for one.

Signed-off-by: Nick Piggin <npiggin@suse.de>
---
 fs/dcache.c |   60 ++++++++++++++++++++++++++++++++----------------------------
 1 file changed, 32 insertions(+), 28 deletions(-)

Index: linux-2.6/fs/dcache.c
===================================================================
--- linux-2.6.orig/fs/dcache.c
+++ linux-2.6/fs/dcache.c
@@ -278,7 +278,8 @@ static struct dentry *d_kill(struct dent
 
 void dput(struct dentry *dentry)
 {
-	struct dentry *parent = NULL;
+	struct dentry *parent;
+
 	if (!dentry)
 		return;
 
@@ -286,25 +287,10 @@ repeat:
 	if (dentry->d_count == 1)
 		might_sleep();
 	spin_lock(&dentry->d_lock);
-	if (dentry->d_count == 1) {
-		if (!spin_trylock(&dcache_inode_lock)) {
-drop2:
-			spin_unlock(&dentry->d_lock);
-			goto repeat;
-		}
-		parent = dentry->d_parent;
-		if (parent && parent != dentry) {
-			if (!spin_trylock(&parent->d_lock)) {
-				spin_unlock(&dcache_inode_lock);
-				goto drop2;
-			}
-		}
-	}
-	dentry->d_count--;
-	if (dentry->d_count) {
+	BUG_ON(!dentry->d_count);
+	if (dentry->d_count > 1) {
+		dentry->d_count--;
 		spin_unlock(&dentry->d_lock);
-		if (parent && parent != dentry)
-			spin_unlock(&parent->d_lock);
 		return;
 	}
 
@@ -312,8 +298,10 @@ drop2:
 	 * AV: ->d_delete() is _NOT_ allowed to block now.
 	 */
 	if (dentry->d_op && dentry->d_op->d_delete) {
-		if (dentry->d_op->d_delete(dentry))
-			goto unhash_it;
+		if (dentry->d_op->d_delete(dentry)) {
+			__d_drop(dentry);
+			goto kill_it;
+		}
 	}
 	/* Unreachable? Get rid of it */
  	if (d_unhashed(dentry))
@@ -322,15 +310,31 @@ drop2:
   		dentry->d_flags |= DCACHE_REFERENCED;
 		dentry_lru_add(dentry);
   	}
- 	spin_unlock(&dentry->d_lock);
-	if (parent && parent != dentry)
-		spin_unlock(&parent->d_lock);
-	spin_unlock(&dcache_inode_lock);
-	return;
+	dentry->d_count--;
+	spin_unlock(&dentry->d_lock);
+  	return;
 
-unhash_it:
-	__d_drop(dentry);
 kill_it:
+	spin_unlock(&dentry->d_lock);
+	spin_lock(&dcache_inode_lock);
+relock:
+	spin_lock(&dentry->d_lock);
+	parent = dentry->d_parent;
+	if (parent && parent != dentry) {
+		if (!spin_trylock(&parent->d_lock)) {
+			spin_unlock(&dentry->d_lock);
+			goto relock;
+		}
+	}
+	dentry->d_count--;
+	if (dentry->d_count) {
+		/* This case should be fine */
+		spin_unlock(&dentry->d_lock);
+		if (parent && parent != dentry)
+			spin_unlock(&parent->d_lock);
+		spin_unlock(&dcache_inode_lock);
+		return;
+	}
 	/* if dentry was on the d_lru list delete it from there */
 	dentry_lru_del(dentry);
 	dentry = d_kill(dentry);


