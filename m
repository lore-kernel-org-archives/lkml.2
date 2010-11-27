Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752980Ab0K0K0W (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Nov 2010 05:26:22 -0500
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:34780 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752886Ab0K0K0R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Nov 2010 05:26:17 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAO1p8Ex5Lcx2/2dsb2JhbACjC3K9doVHBIph
Message-Id: <944c2e520a82b2f6df0f0f9982dd98778f82e63d.1290852959.git.npiggin@kernel.dk>
In-Reply-To: <cover.1290852958.git.npiggin@kernel.dk>
References: <cover.1290852958.git.npiggin@kernel.dk>
From: Nick Piggin <npiggin@kernel.dk>
Date: Sat, 27 Nov 2010 20:44:59 +1100
Subject: [PATCH 29/46] fs: consolidate dentry kill sequence
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The tricky locking for disposing of a dentry is duplicated 3 times in the
dcache (dput, pruning a dentry from the LRU, and pruning its ancestors).
Consolidate them all into a single function dentry_kill.

Signed-off-by: Nick Piggin <npiggin@kernel.dk>
---
 fs/dcache.c |  137 +++++++++++++++++++++++++++--------------------------------
 1 files changed, 62 insertions(+), 75 deletions(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index 4dbcb6c..5abb8f2 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -244,6 +244,40 @@ static struct dentry *d_kill(struct dentry *dentry, struct dentry *parent)
 	return parent;
 }
 
+/*
+ * Finish off a dentry we've decided to kill.
+ * dentry->d_lock must be held, returns with it unlocked.
+ * If ref is non-zero, then decrement the refcount too.
+ * Returns dentry requiring refcount drop, or NULL if we're done.
+ */
+static inline struct dentry *dentry_kill(struct dentry *dentry, int ref)
+	__releases(dentry->d_lock)
+{
+	struct dentry *parent;
+
+	if (!spin_trylock(&dcache_inode_lock)) {
+relock:
+		spin_unlock(&dentry->d_lock);
+		cpu_relax();
+		return dentry; /* try again with same dentry */
+	}
+	if (IS_ROOT(dentry))
+		parent = NULL;
+	else
+		parent = dentry->d_parent;
+	if (parent && !spin_trylock(&parent->d_lock)) {
+		spin_unlock(&dcache_inode_lock);
+		goto relock;
+	}
+	if (ref)
+		dentry->d_count--;
+	/* if dentry was on the d_lru list delete it from there */
+	dentry_lru_del(dentry);
+	/* if it was on the hash then remove it */
+	__d_drop(dentry);
+	return d_kill(dentry, parent);
+}
+
 /* 
  * This is dput
  *
@@ -269,13 +303,9 @@ static struct dentry *d_kill(struct dentry *dentry, struct dentry *parent)
  * call the dentry unlink method as well as removing it from the queues and
  * releasing its resources. If the parent dentries were scheduled for release
  * they too may now get deleted.
- *
- * no dcache lock, please.
  */
-
 void dput(struct dentry *dentry)
 {
-	struct dentry *parent;
 	if (!dentry)
 		return;
 
@@ -308,26 +338,7 @@ repeat:
 	return;
 
 kill_it:
-	if (!spin_trylock(&dcache_inode_lock)) {
-relock:
-		spin_unlock(&dentry->d_lock);
-		cpu_relax();
-		goto repeat;
-	}
-	if (IS_ROOT(dentry))
-		parent = NULL;
-	else
-		parent = dentry->d_parent;
-	if (parent && !spin_trylock(&parent->d_lock)) {
-		spin_unlock(&dcache_inode_lock);
-		goto relock;
-	}
-	dentry->d_count--;
-	/* if dentry was on the d_lru list delete it from there */
-	dentry_lru_del(dentry);
-	/* if it was on the hash (d_delete case), then remove it */
-	__d_drop(dentry);
-	dentry = d_kill(dentry, parent);
+	dentry = dentry_kill(dentry, 1);
 	if (dentry)
 		goto repeat;
 }
@@ -528,51 +539,43 @@ restart:
 EXPORT_SYMBOL(d_prune_aliases);
 
 /*
- * Throw away a dentry - free the inode, dput the parent.  This requires that
- * the LRU list has already been removed.
+ * Try to throw away a dentry - free the inode, dput the parent.
+ * Requires dentry->d_lock is held, and dentry->d_count == 0.
+ * Releases dentry->d_lock.
  *
- * Try to prune ancestors as well.  This is necessary to prevent
- * quadratic behavior of shrink_dcache_parent(), but is also expected
- * to be beneficial in reducing dentry cache fragmentation.
+ * This may fail if locks cannot be acquired no problem, just try again.
  */
-static void prune_one_dentry(struct dentry *dentry, struct dentry *parent)
+static void try_prune_one_dentry(struct dentry *dentry)
 	__releases(dentry->d_lock)
-	__releases(parent->d_lock)
-	__releases(dcache_inode_lock)
 {
-	__d_drop(dentry);
-	dentry = d_kill(dentry, parent);
+	struct dentry *parent;
 
+	parent = dentry_kill(dentry, 0);
 	/*
-	 * Prune ancestors.
+	 * If dentry_kill returns NULL, we have nothing more to do.
+	 * if it returns the same dentry, trylocks failed. In either
+	 * case, just loop again.
+	 *
+	 * Otherwise, we need to prune ancestors too. This is necessary
+	 * to prevent quadratic behavior of shrink_dcache_parent(), but
+	 * is also expected to be beneficial in reducing dentry cache
+	 * fragmentation.
 	 */
+	if (!parent)
+		return;
+	if (parent == dentry)
+		return;
+
+	/* Prune ancestors. */
+	dentry = parent;
 	while (dentry) {
-relock:
 		spin_lock(&dentry->d_lock);
 		if (dentry->d_count > 1) {
 			dentry->d_count--;
 			spin_unlock(&dentry->d_lock);
-	 		return;
-	 	}
-		if (!spin_trylock(&dcache_inode_lock)) {
-relock2:
-			spin_unlock(&dentry->d_lock);
-			cpu_relax();
-			goto relock;
-		}
-
-		if (IS_ROOT(dentry))
-			parent = NULL;
-		else
-			parent = dentry->d_parent;
-		if (parent && !spin_trylock(&parent->d_lock)) {
-			spin_unlock(&dcache_inode_lock);
-			goto relock2;
+			return;
 		}
-		dentry->d_count--;
-		dentry_lru_del(dentry);
-		__d_drop(dentry);
-		dentry = d_kill(dentry, parent);
+		dentry = dentry_kill(dentry, 1);
 	}
 }
 
@@ -582,8 +585,6 @@ static void shrink_dentry_list(struct list_head *list)
 
 	rcu_read_lock();
 	while (!list_empty(list)) {
-		struct dentry *parent;
-
 		dentry = list_entry(list->prev, struct dentry, d_lru);
 
 		/* Don't need RCU dereference because we recheck under lock */
@@ -604,24 +605,10 @@ static void shrink_dentry_list(struct list_head *list)
 			continue;
 		}
 
-		if (!spin_trylock(&dcache_inode_lock)) {
-relock:
-			spin_unlock(&dentry->d_lock);
-			cpu_relax();
-			continue;
-		}
-		if (IS_ROOT(dentry))
-			parent = NULL;
-		else
-			parent = dentry->d_parent;
-		if (parent && !spin_trylock(&parent->d_lock)) {
-			spin_unlock(&dcache_inode_lock);
-			goto relock;
-		}
-		dentry_lru_del(dentry);
-
 		rcu_read_unlock();
-		prune_one_dentry(dentry, parent);
+
+		try_prune_one_dentry(dentry);
+
 		rcu_read_lock();
 	}
 	rcu_read_unlock();
-- 
1.7.1

