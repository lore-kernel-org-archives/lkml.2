Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757904Ab0KPO3A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 09:29:00 -0500
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:3958 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755690Ab0KPOXx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 09:23:53 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AiQJAKMh4kx5Ldur/2dsb2JhbACVYYx9cr5mhUsEilg
Message-Id: <20101116142029.238128970@kernel.dk>
User-Agent: quilt/0.48-1
Date: Wed, 17 Nov 2010 01:09:11 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [patch 11/28] fs: dcache scale lru
References: <20101116140900.039761100@kernel.dk>
Content-Disposition: inline; filename=fs-dcache-scale-d_lru.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a new lock, dcache_lru_lock, to protect the dcache LRU list from concurrent
modification. d_lru is also protected by d_lock.

Signed-off-by: Nick Piggin <npiggin@kernel.dk>

---
 fs/dcache.c |  112 +++++++++++++++++++++++++++++++++++++++++++++---------------
 1 file changed, 84 insertions(+), 28 deletions(-)

Index: linux-2.6/fs/dcache.c
===================================================================
--- linux-2.6.orig/fs/dcache.c	2010-11-17 00:52:37.000000000 +1100
+++ linux-2.6/fs/dcache.c	2010-11-17 01:05:46.000000000 +1100
@@ -37,11 +37,19 @@
 
 /*
  * Usage:
- * dcache_hash_lock protects dcache hash table
+ * dcache_hash_lock protects:
+ *   - the dcache hash table
+ * dcache_lru_lock protects:
+ *   - the dcache lru lists and counters
+ * d_lock protects:
+ *   - d_flags
+ *   - d_name
+ *   - d_lru
  *
  * Ordering:
  * dcache_lock
  *   dentry->d_lock
+ *     dcache_lru_lock
  *     dcache_hash_lock
  *
  * if (dentry1 < dentry2)
@@ -52,6 +60,7 @@ int sysctl_vfs_cache_pressure __read_mos
 EXPORT_SYMBOL_GPL(sysctl_vfs_cache_pressure);
 
 __cacheline_aligned_in_smp DEFINE_SPINLOCK(dcache_hash_lock);
+static __cacheline_aligned_in_smp DEFINE_SPINLOCK(dcache_lru_lock);
 __cacheline_aligned_in_smp DEFINE_SPINLOCK(dcache_lock);
 __cacheline_aligned_in_smp DEFINE_SEQLOCK(rename_lock);
 
@@ -148,28 +157,38 @@ static void dentry_iput(struct dentry *
 }
 
 /*
- * dentry_lru_(add|del|move_tail) must be called with dcache_lock held.
+ * dentry_lru_(add|del|move_tail) must be called with d_lock held.
  */
 static void dentry_lru_add(struct dentry *dentry)
 {
 	if (list_empty(&dentry->d_lru)) {
+		spin_lock(&dcache_lru_lock);
 		list_add(&dentry->d_lru, &dentry->d_sb->s_dentry_lru);
 		dentry->d_sb->s_nr_dentry_unused++;
 		percpu_counter_inc(&nr_dentry_unused);
+		spin_unlock(&dcache_lru_lock);
 	}
 }
 
+static void __dentry_lru_del(struct dentry *dentry)
+{
+	list_del_init(&dentry->d_lru);
+	dentry->d_sb->s_nr_dentry_unused--;
+	percpu_counter_dec(&nr_dentry_unused);
+}
+
 static void dentry_lru_del(struct dentry *dentry)
 {
 	if (!list_empty(&dentry->d_lru)) {
-		list_del_init(&dentry->d_lru);
-		dentry->d_sb->s_nr_dentry_unused--;
-		percpu_counter_dec(&nr_dentry_unused);
+		spin_lock(&dcache_lru_lock);
+		__dentry_lru_del(dentry);
+		spin_unlock(&dcache_lru_lock);
 	}
 }
 
 static void dentry_lru_move_tail(struct dentry *dentry)
 {
+	spin_lock(&dcache_lru_lock);
 	if (list_empty(&dentry->d_lru)) {
 		list_add_tail(&dentry->d_lru, &dentry->d_sb->s_dentry_lru);
 		dentry->d_sb->s_nr_dentry_unused++;
@@ -177,6 +196,7 @@ static void dentry_lru_move_tail(struct
 	} else {
 		list_move_tail(&dentry->d_lru, &dentry->d_sb->s_dentry_lru);
 	}
+	spin_unlock(&dcache_lru_lock);
 }
 
 /**
@@ -186,6 +206,8 @@ static void dentry_lru_move_tail(struct
  * The dentry must already be unhashed and removed from the LRU.
  *
  * If this is the root of the dentry tree, return NULL.
+ *
+ * dcache_lock and d_lock must be held by caller, are dropped by d_kill.
  */
 static struct dentry *d_kill(struct dentry *dentry)
 	__releases(dentry->d_lock)
@@ -341,10 +363,19 @@ int d_invalidate(struct dentry * dentry)
 EXPORT_SYMBOL(d_invalidate);
 
 /* This should be called _only_ with dcache_lock held */
+static inline struct dentry * __dget_locked_dlock(struct dentry *dentry)
+{
+	atomic_inc(&dentry->d_count);
+	dentry_lru_del(dentry);
+	return dentry;
+}
+
 static inline struct dentry * __dget_locked(struct dentry *dentry)
 {
 	atomic_inc(&dentry->d_count);
+	spin_lock(&dentry->d_lock);
 	dentry_lru_del(dentry);
+	spin_unlock(&dentry->d_lock);
 	return dentry;
 }
 
@@ -423,7 +454,7 @@ void d_prune_aliases(struct inode *inode
 	list_for_each_entry(dentry, &inode->i_dentry, d_alias) {
 		spin_lock(&dentry->d_lock);
 		if (!atomic_read(&dentry->d_count)) {
-			__dget_locked(dentry);
+			__dget_locked_dlock(dentry);
 			__d_drop(dentry);
 			spin_unlock(&dentry->d_lock);
 			spin_unlock(&dcache_lock);
@@ -447,7 +478,6 @@ EXPORT_SYMBOL(d_prune_aliases);
 static void prune_one_dentry(struct dentry * dentry)
 	__releases(dentry->d_lock)
 	__releases(dcache_lock)
-	__acquires(dcache_lock)
 {
 	__d_drop(dentry);
 	dentry = d_kill(dentry);
@@ -456,15 +486,16 @@ static void prune_one_dentry(struct dent
 	 * Prune ancestors.  Locking is simpler than in dput(),
 	 * because dcache_lock needs to be taken anyway.
 	 */
-	spin_lock(&dcache_lock);
 	while (dentry) {
-		if (!atomic_dec_and_lock(&dentry->d_count, &dentry->d_lock))
+		spin_lock(&dcache_lock);
+		if (!atomic_dec_and_lock(&dentry->d_count, &dentry->d_lock)) {
+			spin_unlock(&dcache_lock);
 			return;
+		}
 
 		dentry_lru_del(dentry);
 		__d_drop(dentry);
 		dentry = d_kill(dentry);
-		spin_lock(&dcache_lock);
 	}
 }
 
@@ -474,21 +505,31 @@ static void shrink_dentry_list(struct li
 
 	while (!list_empty(list)) {
 		dentry = list_entry(list->prev, struct dentry, d_lru);
-		dentry_lru_del(dentry);
+
+		if (!spin_trylock(&dentry->d_lock)) {
+			spin_unlock(&dcache_lru_lock);
+			cpu_relax();
+			spin_lock(&dcache_lru_lock);
+			continue;
+		}
+
+		__dentry_lru_del(dentry);
 
 		/*
 		 * We found an inuse dentry which was not removed from
 		 * the LRU because of laziness during lookup.  Do not free
 		 * it - just keep it off the LRU list.
 		 */
-		spin_lock(&dentry->d_lock);
 		if (atomic_read(&dentry->d_count)) {
 			spin_unlock(&dentry->d_lock);
 			continue;
 		}
+		spin_unlock(&dcache_lru_lock);
+
 		prune_one_dentry(dentry);
-		/* dentry->d_lock was dropped in prune_one_dentry() */
-		cond_resched_lock(&dcache_lock);
+		/* dcache_lock and dentry->d_lock dropped */
+		spin_lock(&dcache_lock);
+		spin_lock(&dcache_lru_lock);
 	}
 }
 
@@ -509,32 +550,36 @@ static void __shrink_dcache_sb(struct su
 	int cnt = *count;
 
 	spin_lock(&dcache_lock);
+relock:
+	spin_lock(&dcache_lru_lock);
 	while (!list_empty(&sb->s_dentry_lru)) {
 		dentry = list_entry(sb->s_dentry_lru.prev,
 				struct dentry, d_lru);
 		BUG_ON(dentry->d_sb != sb);
 
+		if (!spin_trylock(&dentry->d_lock)) {
+			spin_unlock(&dcache_lru_lock);
+			cpu_relax();
+			goto relock;
+		}
+
 		/*
 		 * If we are honouring the DCACHE_REFERENCED flag and the
 		 * dentry has this flag set, don't free it.  Clear the flag
 		 * and put it back on the LRU.
 		 */
-		if (flags & DCACHE_REFERENCED) {
-			spin_lock(&dentry->d_lock);
-			if (dentry->d_flags & DCACHE_REFERENCED) {
-				dentry->d_flags &= ~DCACHE_REFERENCED;
-				list_move(&dentry->d_lru, &referenced);
-				spin_unlock(&dentry->d_lock);
-				cond_resched_lock(&dcache_lock);
-				continue;
-			}
+		if (flags & DCACHE_REFERENCED &&
+				dentry->d_flags & DCACHE_REFERENCED) {
+			dentry->d_flags &= ~DCACHE_REFERENCED;
+			list_move(&dentry->d_lru, &referenced);
 			spin_unlock(&dentry->d_lock);
+		} else {
+			list_move_tail(&dentry->d_lru, &tmp);
+			spin_unlock(&dentry->d_lock);
+			if (!--cnt)
+				break;
 		}
-
-		list_move_tail(&dentry->d_lru, &tmp);
-		if (!--cnt)
-			break;
-		cond_resched_lock(&dcache_lock);
+		/* XXX: re-add cond_resched_lock when dcache_lock goes away */
 	}
 
 	*count = cnt;
@@ -542,6 +587,7 @@ static void __shrink_dcache_sb(struct su
 
 	if (!list_empty(&referenced))
 		list_splice(&referenced, &sb->s_dentry_lru);
+	spin_unlock(&dcache_lru_lock);
 	spin_unlock(&dcache_lock);
 
 }
@@ -637,10 +683,12 @@ void shrink_dcache_sb(struct super_block
 	LIST_HEAD(tmp);
 
 	spin_lock(&dcache_lock);
+	spin_lock(&dcache_lru_lock);
 	while (!list_empty(&sb->s_dentry_lru)) {
 		list_splice_init(&sb->s_dentry_lru, &tmp);
 		shrink_dentry_list(&tmp);
 	}
+	spin_unlock(&dcache_lru_lock);
 	spin_unlock(&dcache_lock);
 }
 EXPORT_SYMBOL(shrink_dcache_sb);
@@ -659,7 +707,9 @@ static void shrink_dcache_for_umount_sub
 
 	/* detach this root from the system */
 	spin_lock(&dcache_lock);
+	spin_lock(&dentry->d_lock);
 	dentry_lru_del(dentry);
+	spin_unlock(&dentry->d_lock);
 	__d_drop(dentry);
 	spin_unlock(&dcache_lock);
 
@@ -673,7 +723,9 @@ static void shrink_dcache_for_umount_sub
 			spin_lock(&dcache_lock);
 			list_for_each_entry(loop, &dentry->d_subdirs,
 					    d_u.d_child) {
+				spin_lock(&loop->d_lock);
 				dentry_lru_del(loop);
+				spin_unlock(&loop->d_lock);
 				__d_drop(loop);
 				cond_resched_lock(&dcache_lock);
 			}
@@ -850,6 +902,8 @@ static int select_parent(struct dentry *
 		struct dentry *dentry = list_entry(tmp, struct dentry, d_u.d_child);
 		next = tmp->next;
 
+		spin_lock(&dentry->d_lock);
+
 		/* 
 		 * move only zero ref count dentries to the end 
 		 * of the unused list for prune_dcache
@@ -861,6 +915,8 @@ static int select_parent(struct dentry *
 			dentry_lru_del(dentry);
 		}
 
+		spin_unlock(&dentry->d_lock);
+
 		/*
 		 * We can return to the caller if we have found some (this
 		 * ensures forward progress). We'll be coming back to find


