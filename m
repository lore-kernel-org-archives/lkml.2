Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754794Ab0FXDQv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 23:16:51 -0400
Received: from cantor.suse.de ([195.135.220.2]:48463 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754183Ab0FXDPv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 23:15:51 -0400
Message-Id: <20100624030728.766241107@suse.de>
User-Agent: quilt/0.48-4.4
Date: Thu, 24 Jun 2010 13:02:32 +1000
From: npiggin@suse.de
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: John Stultz <johnstul@us.ibm.com>, Frank Mayhar <fmayhar@google.com>
Subject: [patch 20/52] fs: dcache reduce dcache_inode_lock
References: <20100624030212.676457061@suse.de>
Content-Disposition: inline; filename=fs-dcache-d_delete-less-lock.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dcache_inode_lock can be avoided in d_delete() and d_materialise_unique()
in cases where it is not required.

Signed-off-by: Nick Piggin <npiggin@suse.de>
---
 fs/dcache.c |   23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

Index: linux-2.6/fs/dcache.c
===================================================================
--- linux-2.6.orig/fs/dcache.c
+++ linux-2.6/fs/dcache.c
@@ -1789,10 +1789,15 @@ void d_delete(struct dentry * dentry)
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
@@ -1803,7 +1808,6 @@ void d_delete(struct dentry * dentry)
 		__d_drop(dentry);
 
 	spin_unlock(&dentry->d_lock);
-	spin_unlock(&dcache_inode_lock);
 
 	fsnotify_nameremove(dentry, isdir);
 }
@@ -2116,14 +2120,15 @@ struct dentry *d_materialise_unique(stru
 
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
 
@@ -2150,10 +2155,9 @@ struct dentry *d_materialise_unique(stru
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
 	_d_rehash(actual);
@@ -2167,10 +2171,6 @@ out_nolock:
 
 	iput(inode);
 	return actual;
-
-shouldnt_be_hashed:
-	spin_unlock(&dcache_inode_lock);
-	BUG();
 }
 EXPORT_SYMBOL_GPL(d_materialise_unique);
 


