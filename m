Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754247Ab0K0KeV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Nov 2010 05:34:21 -0500
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:34794 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752302Ab0K0K0F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Nov 2010 05:26:05 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAO1p8Ex5Lcx2/2dsb2JhbACjC3K9doVHBIph
Message-Id: <3eb32695435ae6c5fd1601467d78b560b5058e2b.1290852959.git.npiggin@kernel.dk>
In-Reply-To: <cover.1290852958.git.npiggin@kernel.dk>
References: <cover.1290852958.git.npiggin@kernel.dk>
From: Nick Piggin <npiggin@kernel.dk>
Date: Sat, 27 Nov 2010 20:44:41 +1100
Subject: [PATCH 11/46] fs: dcache scale hash
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a new lock, dcache_hash_lock, to protect the dcache hash table from
concurrent modification. d_hash is also protected by d_lock.

Signed-off-by: Nick Piggin <npiggin@kernel.dk>
---
 fs/dcache.c            |   38 +++++++++++++++++++++++++++-----------
 include/linux/dcache.h |    3 +++
 2 files changed, 30 insertions(+), 11 deletions(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index 4f9ccbe..50c65c7 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
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
@@ -1195,7 +1210,9 @@ struct dentry *d_obtain_alias(struct inode *inode)
 	tmp->d_flags |= DCACHE_DISCONNECTED;
 	tmp->d_flags &= ~DCACHE_UNHASHED;
 	list_add(&tmp->d_alias, &inode->i_dentry);
+	spin_lock(&dcache_hash_lock);
 	hlist_add_head(&tmp->d_hash, &inode->i_sb->s_anon);
+	spin_unlock(&dcache_hash_lock);
 	spin_unlock(&tmp->d_lock);
 
 	spin_unlock(&dcache_lock);
@@ -1581,7 +1598,9 @@ void d_rehash(struct dentry * entry)
 {
 	spin_lock(&dcache_lock);
 	spin_lock(&entry->d_lock);
+	spin_lock(&dcache_hash_lock);
 	_d_rehash(entry);
+	spin_unlock(&dcache_hash_lock);
 	spin_unlock(&entry->d_lock);
 	spin_unlock(&dcache_lock);
 }
@@ -1661,8 +1680,6 @@ static void switch_names(struct dentry *dentry, struct dentry *target)
  */
 static void d_move_locked(struct dentry * dentry, struct dentry * target)
 {
-	struct hlist_head *list;
-
 	if (!dentry->d_inode)
 		printk(KERN_WARNING "VFS: moving negative dcache entry\n");
 
@@ -1679,14 +1696,11 @@ static void d_move_locked(struct dentry * dentry, struct dentry * target)
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
@@ -1883,7 +1897,9 @@ struct dentry *d_materialise_unique(struct dentry *dentry, struct inode *inode)
 found_lock:
 	spin_lock(&actual->d_lock);
 found:
+	spin_lock(&dcache_hash_lock);
 	_d_rehash(actual);
+	spin_unlock(&dcache_hash_lock);
 	spin_unlock(&actual->d_lock);
 	spin_unlock(&dcache_lock);
 out_nolock:
diff --git a/include/linux/dcache.h b/include/linux/dcache.h
index 6b5760b..7ce20f5 100644
--- a/include/linux/dcache.h
+++ b/include/linux/dcache.h
@@ -181,6 +181,7 @@ struct dentry_operations {
 
 #define DCACHE_CANT_MOUNT	0x0100
 
+extern spinlock_t dcache_hash_lock;
 extern spinlock_t dcache_lock;
 extern seqlock_t rename_lock;
 
@@ -204,7 +205,9 @@ static inline void __d_drop(struct dentry *dentry)
 {
 	if (!(dentry->d_flags & DCACHE_UNHASHED)) {
 		dentry->d_flags |= DCACHE_UNHASHED;
+		spin_lock(&dcache_hash_lock);
 		hlist_del_rcu(&dentry->d_hash);
+		spin_unlock(&dcache_hash_lock);
 	}
 }
 
-- 
1.7.1

