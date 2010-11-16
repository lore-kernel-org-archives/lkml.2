Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759509Ab0KPO0R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 09:26:17 -0500
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:3958 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758517Ab0KPOX6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 09:23:58 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AogKAKMh4kx5Ldur/2dsb2JhbACUX4ECjH1yvmaFSwSKWIUQ
Message-Id: <20101116142030.312272933@kernel.dk>
User-Agent: quilt/0.48-1
Date: Wed, 17 Nov 2010 01:09:22 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [patch 22/28] fs: dcache reduce dcache_inode_lock
References: <20101116140900.039761100@kernel.dk>
Content-Disposition: inline; filename=fs-dcache-d_delete-less-lock.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dcache_inode_lock can be avoided in d_delete() and d_materialise_unique()
in cases where it is not required.

Signed-off-by: Nick Piggin <npiggin@kernel.dk>

---
 fs/dcache.c |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

Index: linux-2.6/fs/dcache.c
===================================================================
--- linux-2.6.orig/fs/dcache.c	2010-11-17 00:52:37.000000000 +1100
+++ linux-2.6/fs/dcache.c	2010-11-17 01:05:39.000000000 +1100
@@ -1794,10 +1794,15 @@ void d_delete(struct dentry * dentry)
 	/*
 	 * Are we the only user?
 	 */
-	spin_lock(&dcache_inode_lock);
+again:
 	spin_lock(&dentry->d_lock);
 	isdir = S_ISDIR(dentry->d_inode->i_mode);
 	if (dentry->d_count == 1) {
+		if (!spin_trylock(&dcache_inode_lock)) {
+			spin_unlock(&dentry->d_lock);
+			cpu_relax();
+			goto again;
+		}
 		dentry->d_flags &= ~DCACHE_CANT_MOUNT;
 		dentry_iput(dentry);
 		fsnotify_nameremove(dentry, isdir);
@@ -1808,7 +1813,6 @@ void d_delete(struct dentry * dentry)
 		__d_drop(dentry);
 
 	spin_unlock(&dentry->d_lock);
-	spin_unlock(&dcache_inode_lock);
 
 	fsnotify_nameremove(dentry, isdir);
 }
@@ -2106,14 +2110,15 @@ struct dentry *d_materialise_unique(stru
 
 	BUG_ON(!d_unhashed(dentry));
 
-	spin_lock(&dcache_inode_lock);
-
 	if (!inode) {
 		actual = dentry;
 		__d_instantiate(dentry, NULL);
-		goto found_lock;
+		d_rehash(actual);
+		goto out_nolock;
 	}
 
+	spin_lock(&dcache_inode_lock);
+
 	if (S_ISDIR(inode->i_mode)) {
 		struct dentry *alias;
 
@@ -2145,10 +2150,9 @@ struct dentry *d_materialise_unique(stru
 	actual = __d_instantiate_unique(dentry, inode);
 	if (!actual)
 		actual = dentry;
-	else if (unlikely(!d_unhashed(actual)))
-		goto shouldnt_be_hashed;
+	else
+		BUG_ON(!d_unhashed(actual));
 
-found_lock:
 	spin_lock(&actual->d_lock);
 found:
 	spin_lock(&dcache_hash_lock);
@@ -2164,10 +2168,6 @@ struct dentry *d_materialise_unique(stru
 
 	iput(inode);
 	return actual;
-
-shouldnt_be_hashed:
-	spin_unlock(&dcache_inode_lock);
-	BUG();
 }
 EXPORT_SYMBOL_GPL(d_materialise_unique);
 


