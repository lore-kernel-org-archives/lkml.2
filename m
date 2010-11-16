Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758462Ab0KPOXu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 09:23:50 -0500
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:32788 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755690Ab0KPOXr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 09:23:47 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AogKAKMh4kx5Ldur/2dsb2JhbACUX4ECjH1yvmaFSwSKWIUQ
Message-Id: <20101116142028.254946611@kernel.dk>
User-Agent: quilt/0.48-1
Date: Wed, 17 Nov 2010 01:09:01 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [patch 01/28] fs: d_validate fixes
References: <20101116140900.039761100@kernel.dk>
Content-Disposition: inline; filename=fs-d_validate-fix.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

d_validate has been broken for a long time.

kmem_ptr_validate does not guarantee that a pointer can be dereferenced
if it can go away at any time. Even rcu_read_lock doesn't help, because
the pointer might be queued in RCU callbacks but not executed yet.

So the parent cannot be checked, nor the name hashed. The dentry pointer
can not be touched until it can be verified under lock. Hashing simply
cannot be used.

Instead, verify the parent/child relationship by traversing parent's
d_child list. It's slow, but only ncpfs and the destaged smbfs care
about it, at this point.

Signed-off-by: Nick Piggin <npiggin@kernel.dk>

---
 fs/dcache.c |   25 +++++++------------------
 1 file changed, 7 insertions(+), 18 deletions(-)

Index: linux-2.6/fs/dcache.c
===================================================================
--- linux-2.6.orig/fs/dcache.c	2010-11-17 00:11:48.000000000 +1100
+++ linux-2.6/fs/dcache.c	2010-11-17 01:05:52.000000000 +1100
@@ -1483,41 +1483,30 @@ struct dentry *d_hash_and_lookup(struct
 }
 
 /**
- * d_validate - verify dentry provided from insecure source
+ * d_validate - verify dentry provided from insecure source (deprecated)
  * @dentry: The dentry alleged to be valid child of @dparent
  * @dparent: The parent dentry (known to be valid)
  *
  * An insecure source has sent us a dentry, here we verify it and dget() it.
  * This is used by ncpfs in its readdir implementation.
  * Zero is returned in the dentry is invalid.
+ *
+ * This function is slow for big directories, and deprecated, do not use it.
  */
- 
 int d_validate(struct dentry *dentry, struct dentry *dparent)
 {
-	struct hlist_head *base;
-	struct hlist_node *lhp;
-
-	/* Check whether the ptr might be valid at all.. */
-	if (!kmem_ptr_validate(dentry_cache, dentry))
-		goto out;
-
-	if (dentry->d_parent != dparent)
-		goto out;
+	struct dentry *child;
 
 	spin_lock(&dcache_lock);
-	base = d_hash(dparent, dentry->d_name.hash);
-	hlist_for_each(lhp,base) { 
-		/* hlist_for_each_entry_rcu() not required for d_hash list
-		 * as it is parsed under dcache_lock
-		 */
-		if (dentry == hlist_entry(lhp, struct dentry, d_hash)) {
+	list_for_each_entry(child, &dparent->d_subdirs, d_u.d_child) {
+		if (dentry == child) {
 			__dget_locked(dentry);
 			spin_unlock(&dcache_lock);
 			return 1;
 		}
 	}
 	spin_unlock(&dcache_lock);
-out:
+
 	return 0;
 }
 EXPORT_SYMBOL(d_validate);


