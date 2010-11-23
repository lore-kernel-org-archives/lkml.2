Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752084Ab0KWKW6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 05:22:58 -0500
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:53455 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751426Ab0KWKW4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 05:22:56 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAOIj60x5Ldhv/2dsb2JhbACiYXK9BoVLBI9w
Date: Tue, 23 Nov 2010 21:22:41 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@ZenIV.linux.org.uk>, Christoph Hellwig <hch@lst.de>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: stable@kernel.org
Subject: [patch 1/2] fs: fix d_validate (again)
Message-ID: <20101123102241.GA4317@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Again, I'd like to please fix d_validate. It can be trivally fixed
without delving into filesystem code, and it does not prevent the proper
careful removal of d_validate and untrusted dentry caches from
filesystems.

The right way to merge is fix the bugs in core code now, and remove it
completely if and when filesystems stop using it. But it's no longer a
liability or problem to maintain, so it can stay as long as it likes.

So, we need to revert 3825bdb7ed920845961f32f364454bee5f469abb, and then
apply this patch (which also should apply to .stable kernels and distros
going back a long way).


fs: d_validate fixes

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
--- linux-2.6.orig/fs/dcache.c	2010-11-16 17:20:40.000000000 +1100
+++ linux-2.6/fs/dcache.c	2010-11-16 17:20:40.000000000 +1100
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
