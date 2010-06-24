Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754486Ab0FXDQl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 23:16:41 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36010 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754142Ab0FXDPr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 23:15:47 -0400
Message-Id: <20100624030729.395195069@suse.de>
User-Agent: quilt/0.48-4.4
Date: Thu, 24 Jun 2010 13:02:36 +1000
From: npiggin@suse.de
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: John Stultz <johnstul@us.ibm.com>, Frank Mayhar <fmayhar@google.com>
Subject: [patch 24/52] fs: dcache reduce d_parent locking
References: <20100624030212.676457061@suse.de>
Content-Disposition: inline; filename=fs-dget_parent-opt.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use RCU property of dcache to simplify locking in some places where we
take d_parent and d_lock.

Comment: don't need rcu_deref because we take the spinlock and recheck it.

Signed-off-by: Nick Piggin <npiggin@suse.de>
--

Index: linux-2.6/fs/dcache.c
===================================================================
--- linux-2.6.orig/fs/dcache.c
+++ linux-2.6/fs/dcache.c
@@ -311,23 +311,18 @@ struct dentry *dget_parent(struct dentry
 	struct dentry *ret;
 
 repeat:
-	spin_lock(&dentry->d_lock);
+	rcu_read_lock();
 	ret = dentry->d_parent;
-	if (!ret)
-		goto out;
-	if (dentry == ret) {
-		ret->d_count++;
-		goto out;
-	}
-	if (!spin_trylock(&ret->d_lock)) {
-		spin_unlock(&dentry->d_lock);
+	spin_lock(&ret->d_lock);
+	if (unlikely(ret != dentry->d_parent)) {
+		spin_unlock(&ret->d_lock);
+		rcu_read_unlock();
 		goto repeat;
 	}
+	rcu_read_unlock();
 	BUG_ON(!ret->d_count);
 	ret->d_count++;
 	spin_unlock(&ret->d_lock);
-out:
-	spin_unlock(&dentry->d_lock);
 	return ret;
 }
 EXPORT_SYMBOL(dget_parent);
@@ -601,14 +596,22 @@ static void prune_one_dentry(struct dent
 		if (inode)
 			spin_lock(&inode->i_lock);
 again:
-		spin_lock(&dentry->d_lock);
-		if (dentry->d_parent && dentry != dentry->d_parent) {
-			if (!spin_trylock(&dentry->d_parent->d_lock)) {
-				spin_unlock(&dentry->d_lock);
+		rcu_read_lock();
+		parent = dentry->d_parent;
+		if (parent) {
+			spin_lock(&parent->d_lock);
+			if (unlikely(parent != dentry->d_parent)) {
+				spin_unlock(&parent->d_lock);
+				rcu_read_unlock();
 				goto again;
 			}
- 			parent = dentry->d_parent;
-		}
+			if (parent != dentry)
+				spin_lock_nested(&dentry->d_lock, DENTRY_D_LOCK_NESTED);
+			else
+				parent = NULL;
+		} else
+			spin_lock(&dentry->d_lock);
+		rcu_read_unlock();
 		dentry->d_count--;
 		if (dentry->d_count) {
 			if (parent)


