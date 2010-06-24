Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754291Ab0FXDQD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 23:16:03 -0400
Received: from cantor.suse.de ([195.135.220.2]:48434 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753660Ab0FXDPo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 23:15:44 -0400
Message-Id: <20100624030727.007569850@suse.de>
User-Agent: quilt/0.48-4.4
Date: Thu, 24 Jun 2010 13:02:21 +1000
From: npiggin@suse.de
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: John Stultz <johnstul@us.ibm.com>, Frank Mayhar <fmayhar@google.com>
Subject: [patch 09/52] fs: dcache scale hash
References: <20100624030212.676457061@suse.de>
Content-Disposition: inline; filename=fs-dcache-scale-d_hash.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a new lock, dcache_hash_lock, to protect the dcache hash table from
concurrent modification. d_hash is also protected by d_lock.

Signed-off-by: Nick Piggin <npiggin@suse.de>
---
 fs/dcache.c            |   35 ++++++++++++++++++++++++-----------
 include/linux/dcache.h |    3 +++
 2 files changed, 27 insertions(+), 11 deletions(-)

Index: linux-2.6/fs/dcache.c
===================================================================
--- linux-2.6.orig/fs/dcache.c
+++ linux-2.6/fs/dcache.c
@@ -35,12 +35,27 @@
 #include <linux/hardirq.h>
 #include "internal.h"
 
+/*
+ * Usage:
+ * dcache_hash_lock protects dcache hash table
+ *
+ * Ordering:
+ * dcache_lock
+ *   dentry->d_lock
+ *     dcache_hash_lock
+ *
+ * if (dentry1 < dentry2)
+ *   dentry1->d_lock
+ *     dentry2->d_lock
+ */
 int sysctl_vfs_cache_pressure __read_mostly = 100;
 EXPORT_SYMBOL_GPL(sysctl_vfs_cache_pressure);
 
- __cacheline_aligned_in_smp DEFINE_SPINLOCK(dcache_lock);
+__cacheline_aligned_in_smp DEFINE_SPINLOCK(dcache_hash_lock);
+__cacheline_aligned_in_smp DEFINE_SPINLOCK(dcache_lock);
 __cacheline_aligned_in_smp DEFINE_SEQLOCK(rename_lock);
 
+EXPORT_SYMBOL(dcache_hash_lock);
 EXPORT_SYMBOL(dcache_lock);
 
 static struct kmem_cache *dentry_cache __read_mostly;
@@ -1480,17 +1495,20 @@ int d_validate(struct dentry *dentry, st
 		goto out;
 
 	spin_lock(&dcache_lock);
+	spin_lock(&dcache_hash_lock);
 	base = d_hash(dparent, dentry->d_name.hash);
 	hlist_for_each(lhp,base) { 
 		/* hlist_for_each_entry_rcu() not required for d_hash list
 		 * as it is parsed under dcache_lock
 		 */
 		if (dentry == hlist_entry(lhp, struct dentry, d_hash)) {
+			spin_unlock(&dcache_hash_lock);
 			__dget_locked(dentry);
 			spin_unlock(&dcache_lock);
 			return 1;
 		}
 	}
+	spin_unlock(&dcache_hash_lock);
 	spin_unlock(&dcache_lock);
 out:
 	return 0;
@@ -1567,7 +1585,9 @@ void d_rehash(struct dentry * entry)
 {
 	spin_lock(&dcache_lock);
 	spin_lock(&entry->d_lock);
+	spin_lock(&dcache_hash_lock);
 	_d_rehash(entry);
+	spin_unlock(&dcache_hash_lock);
 	spin_unlock(&entry->d_lock);
 	spin_unlock(&dcache_lock);
 }
@@ -1647,8 +1667,6 @@ static void switch_names(struct dentry *
  */
 static void d_move_locked(struct dentry * dentry, struct dentry * target)
 {
-	struct hlist_head *list;
-
 	if (!dentry->d_inode)
 		printk(KERN_WARNING "VFS: moving negative dcache entry\n");
 
@@ -1665,14 +1683,11 @@ static void d_move_locked(struct dentry
 	}
 
 	/* Move the dentry to the target hash queue, if on different bucket */
-	if (d_unhashed(dentry))
-		goto already_unhashed;
-
-	hlist_del_rcu(&dentry->d_hash);
-
-already_unhashed:
-	list = d_hash(target->d_parent, target->d_name.hash);
-	__d_rehash(dentry, list);
+	spin_lock(&dcache_hash_lock);
+	if (!d_unhashed(dentry))
+		hlist_del_rcu(&dentry->d_hash);
+	__d_rehash(dentry, d_hash(target->d_parent, target->d_name.hash));
+	spin_unlock(&dcache_hash_lock);
 
 	/* Unhash the target: dput() will then get rid of it */
 	__d_drop(target);
@@ -1869,7 +1884,9 @@ struct dentry *d_materialise_unique(stru
 found_lock:
 	spin_lock(&actual->d_lock);
 found:
+	spin_lock(&dcache_hash_lock);
 	_d_rehash(actual);
+	spin_unlock(&dcache_hash_lock);
 	spin_unlock(&actual->d_lock);
 	spin_unlock(&dcache_lock);
 out_nolock:
Index: linux-2.6/include/linux/dcache.h
===================================================================
--- linux-2.6.orig/include/linux/dcache.h
+++ linux-2.6/include/linux/dcache.h
@@ -188,6 +188,7 @@ d_iput:		no		no		no       yes
 
 #define DCACHE_CANT_MOUNT	0x0100
 
+extern spinlock_t dcache_hash_lock;
 extern spinlock_t dcache_lock;
 extern seqlock_t rename_lock;
 
@@ -211,7 +212,9 @@ static inline void __d_drop(struct dentr
 {
 	if (!(dentry->d_flags & DCACHE_UNHASHED)) {
 		dentry->d_flags |= DCACHE_UNHASHED;
+		spin_lock(&dcache_hash_lock);
 		hlist_del_rcu(&dentry->d_hash);
+		spin_unlock(&dcache_hash_lock);
 	}
 }
 


