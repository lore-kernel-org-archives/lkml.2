Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755078Ab0FXD0V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 23:26:21 -0400
Received: from cantor.suse.de ([195.135.220.2]:48481 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754194Ab0FXDPz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 23:15:55 -0400
Message-Id: <20100624030733.869946613@suse.de>
User-Agent: quilt/0.48-4.4
Date: Thu, 24 Jun 2010 13:03:03 +1000
From: npiggin@suse.de
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: John Stultz <johnstul@us.ibm.com>, Frank Mayhar <fmayhar@google.com>
Subject: [patch 51/52] fs: per-zone dentry and inode LRU
References: <20100624030212.676457061@suse.de>
Content-Disposition: inline; filename=fs-dcache-per-zone-lru.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Per-zone LRUs and shrinkers for dentry and inode caches.

Signed-off-by: Nick Piggin <npiggin@suse.de>

Index: linux-2.6/include/linux/fs.h
===================================================================
--- linux-2.6.orig/include/linux/fs.h
+++ linux-2.6/include/linux/fs.h
@@ -382,6 +382,7 @@ struct files_stat_struct {
 #include <linux/semaphore.h>
 #include <linux/fiemap.h>
 #include <linux/rculist_bl.h>
+#include <linux/mmzone.h>
 
 #include <asm/atomic.h>
 #include <asm/byteorder.h>
@@ -1325,6 +1326,25 @@ extern int send_sigurg(struct fown_struc
 extern struct list_head super_blocks;
 extern spinlock_t sb_lock;
 
+#define sb_zone_info(sb, ___z)			\
+	&sb->s_reclaim.node[zone_to_nid(___z)].zone[zone_idx(___z)]
+
+struct sb_zoneinfo {
+	/* protected by zone->dentry_lru_lock */
+	spinlock_t		s_dentry_lru_lock;
+	struct list_head	s_dentry_lru;
+	long			s_nr_dentry_scan;
+	unsigned long		s_nr_dentry_unused;
+};
+
+struct sb_nodeinfo {
+	struct sb_zoneinfo zone[MAX_NR_ZONES];
+};
+
+struct sb_reclaim {
+	struct sb_nodeinfo node[MAX_NUMNODES];
+};
+
 struct super_block {
 	struct list_head	s_list;		/* Keep this first */
 	dev_t			s_dev;		/* search index; _not_ kdev_t */
@@ -1357,9 +1377,7 @@ struct super_block {
 	struct list_head	s_inodes;	/* all inodes */
 	struct list_head	s_files;
 #endif
-	/* s_dentry_lru and s_nr_dentry_unused are protected by dcache_lock */
-	struct list_head	s_dentry_lru;	/* unused dentry lru */
-	int			s_nr_dentry_unused;	/* # of dentry on lru */
+	struct sb_reclaim	s_reclaim;
 
 	struct block_device	*s_bdev;
 	struct backing_dev_info *s_bdi;
Index: linux-2.6/fs/dcache.c
===================================================================
--- linux-2.6.orig/fs/dcache.c
+++ linux-2.6/fs/dcache.c
@@ -43,8 +43,8 @@
  *   - i_dentry, d_alias, d_inode of aliases
  * dcache_hash_bucket lock protects:
  *   - the dcache hash table
- * dcache_lru_lock protects:
- *   - the dcache lru lists and counters
+ * sbz->s_dcache_lru_lock protects:
+ *   - the per-sb x per-zone dcache lru lists and counters
  * d_lock protects:
  *   - d_flags
  *   - d_name
@@ -58,7 +58,7 @@
  * Ordering:
  * dentry->d_inode->i_lock
  *   dentry->d_lock
- *     dcache_lru_lock
+ *     sbz->s_dcache_lru_lock
  *     dcache_hash_bucket lock
  *
  * If there is an ancestor relationship:
@@ -75,7 +75,6 @@
 int sysctl_vfs_cache_pressure __read_mostly = 100;
 EXPORT_SYMBOL_GPL(sysctl_vfs_cache_pressure);
 
-static __cacheline_aligned_in_smp DEFINE_SPINLOCK(dcache_lru_lock);
 __cacheline_aligned_in_smp DEFINE_SEQLOCK(rename_lock);
 
 EXPORT_SYMBOL(rename_lock);
@@ -186,51 +185,55 @@ static void dentry_iput(struct dentry *
  */
 static void dentry_lru_add(struct dentry *dentry)
 {
-	spin_lock(&dcache_lru_lock);
-	list_add(&dentry->d_lru, &dentry->d_sb->s_dentry_lru);
-	dentry->d_sb->s_nr_dentry_unused++;
-	dentry_stat.nr_unused++;
-	spin_unlock(&dcache_lru_lock);
+	struct sb_zoneinfo *sbz = sb_zone_info(dentry->d_sb,
+					page_zone(virt_to_page(dentry)));
+	spin_lock(&sbz->s_dentry_lru_lock);
+	list_add(&dentry->d_lru, &sbz->s_dentry_lru);
+	sbz->s_nr_dentry_unused++;
+	spin_unlock(&sbz->s_dentry_lru_lock);
 }
 
 static void dentry_lru_add_tail(struct dentry *dentry)
 {
-	spin_lock(&dcache_lru_lock);
-	list_add_tail(&dentry->d_lru, &dentry->d_sb->s_dentry_lru);
-	dentry->d_sb->s_nr_dentry_unused++;
-	dentry_stat.nr_unused++;
-	spin_unlock(&dcache_lru_lock);
+	struct sb_zoneinfo *sbz = sb_zone_info(dentry->d_sb,
+					page_zone(virt_to_page(dentry)));
+	spin_lock(&sbz->s_dentry_lru_lock);
+	list_add_tail(&dentry->d_lru, &sbz->s_dentry_lru);
+	sbz->s_nr_dentry_unused++;
+	spin_unlock(&sbz->s_dentry_lru_lock);
 }
 
-static void __dentry_lru_del(struct dentry *dentry)
+static void __dentry_lru_del(struct sb_zoneinfo *sbz, struct dentry *dentry)
 {
 	list_del(&dentry->d_lru);
-	dentry->d_sb->s_nr_dentry_unused--;
-	dentry_stat.nr_unused--;
+	sbz->s_nr_dentry_unused--;
 }
 
-static void __dentry_lru_del_init(struct dentry *dentry)
+static void __dentry_lru_del_init(struct sb_zoneinfo *sbz,struct dentry *dentry)
 {
 	list_del_init(&dentry->d_lru);
-	dentry->d_sb->s_nr_dentry_unused--;
-	dentry_stat.nr_unused--;
+	sbz->s_nr_dentry_unused--;
 }
 
 static void dentry_lru_del(struct dentry *dentry)
 {
 	if (!list_empty(&dentry->d_lru)) {
-		spin_lock(&dcache_lru_lock);
-		__dentry_lru_del(dentry);
-		spin_unlock(&dcache_lru_lock);
+		struct sb_zoneinfo *sbz = sb_zone_info(dentry->d_sb,
+					page_zone(virt_to_page(dentry)));
+		spin_lock(&sbz->s_dentry_lru_lock);
+		__dentry_lru_del(sbz, dentry);
+		spin_unlock(&sbz->s_dentry_lru_lock);
 	}
 }
 
 static void dentry_lru_del_init(struct dentry *dentry)
 {
 	if (likely(!list_empty(&dentry->d_lru))) {
-		spin_lock(&dcache_lru_lock);
-		__dentry_lru_del_init(dentry);
-		spin_unlock(&dcache_lru_lock);
+		struct sb_zoneinfo *sbz = sb_zone_info(dentry->d_sb,
+					page_zone(virt_to_page(dentry)));
+		spin_lock(&sbz->s_dentry_lru_lock);
+		__dentry_lru_del_init(sbz, dentry);
+		spin_unlock(&sbz->s_dentry_lru_lock);
 	}
 }
 
@@ -638,32 +641,33 @@ again:
  * which flags are set. This means we don't need to maintain multiple
  * similar copies of this loop.
  */
-static void __shrink_dcache_sb(struct super_block *sb, int *count, int flags)
+static void __shrink_dcache_sb_zone(struct super_block *sb,
+		struct sb_zoneinfo *sbz, unsigned long *count, int flags)
 {
 	LIST_HEAD(referenced);
 	LIST_HEAD(tmp);
 	struct dentry *dentry;
-	int cnt = 0;
+	unsigned long cnt = 0;
 
 	BUG_ON(!sb);
 	BUG_ON((flags & DCACHE_REFERENCED) && count == NULL);
 	if (count != NULL)
 		/* called from prune_dcache() and shrink_dcache_parent() */
 		cnt = *count;
-relock:
-	spin_lock(&dcache_lru_lock);
 restart:
 	if (count == NULL)
-		list_splice_init(&sb->s_dentry_lru, &tmp);
+		list_splice_init(&sbz->s_dentry_lru, &tmp);
 	else {
-		while (!list_empty(&sb->s_dentry_lru)) {
-			dentry = list_entry(sb->s_dentry_lru.prev,
-					struct dentry, d_lru);
+		while (!list_empty(&sbz->s_dentry_lru)) {
+			dentry = list_entry(sbz->s_dentry_lru.prev,
+							struct dentry, d_lru);
 			BUG_ON(dentry->d_sb != sb);
 
 			if (!spin_trylock(&dentry->d_lock)) {
-				spin_unlock(&dcache_lru_lock);
-				goto relock;
+				spin_unlock(&sbz->s_dentry_lru_lock);
+				cpu_relax();
+				spin_lock(&sbz->s_dentry_lru_lock);
+				continue;
 			}
 			/*
 			 * If we are honouring the DCACHE_REFERENCED flag and
@@ -682,13 +686,10 @@ restart:
 				if (!cnt)
 					break;
 			}
-			cond_resched_lock(&dcache_lru_lock);
+			cond_resched_lock(&sbz->s_dentry_lru_lock);
 		}
 	}
-	spin_unlock(&dcache_lru_lock);
 
-again:
-	spin_lock(&dcache_lru_lock); /* lru_lock also protects tmp list */
 	while (!list_empty(&tmp)) {
 		struct inode *inode;
 
@@ -696,8 +697,10 @@ again:
 
 		if (!spin_trylock(&dentry->d_lock)) {
 again1:
-			spin_unlock(&dcache_lru_lock);
-			goto again;
+			spin_unlock(&sbz->s_dentry_lru_lock);
+			cpu_relax();
+			spin_lock(&sbz->s_dentry_lru_lock);
+			continue;
 		}
 		/*
 		 * We found an inuse dentry which was not removed from
@@ -705,7 +708,7 @@ again1:
 		 * it - just keep it off the LRU list.
 		 */
 		if (dentry->d_count) {
-			__dentry_lru_del_init(dentry);
+			__dentry_lru_del_init(sbz, dentry);
 			spin_unlock(&dentry->d_lock);
 			continue;
 		}
@@ -722,21 +725,33 @@ again2:
 				goto again2;
 			}
 		}
-		__dentry_lru_del_init(dentry);
-		spin_unlock(&dcache_lru_lock);
+		__dentry_lru_del_init(sbz, dentry);
+		spin_unlock(&sbz->s_dentry_lru_lock);
 
 		prune_one_dentry(dentry);
+		cond_resched();
 		/* dentry->d_lock dropped */
-		spin_lock(&dcache_lru_lock);
+		spin_lock(&sbz->s_dentry_lru_lock);
 	}
 
-	if (count == NULL && !list_empty(&sb->s_dentry_lru))
+	if (count == NULL && !list_empty(&sbz->s_dentry_lru))
 		goto restart;
 	if (count != NULL)
 		*count = cnt;
 	if (!list_empty(&referenced))
-		list_splice(&referenced, &sb->s_dentry_lru);
-	spin_unlock(&dcache_lru_lock);
+		list_splice(&referenced, &sbz->s_dentry_lru);
+}
+
+static void __shrink_dcache_sb(struct super_block *sb, unsigned long *count, int flags)
+{
+	struct zone *zone;
+	for_each_zone(zone) {
+		struct sb_zoneinfo *sbz = sb_zone_info(sb, zone);
+
+		spin_lock(&sbz->s_dentry_lru_lock);
+		__shrink_dcache_sb_zone(sb, sbz, count, flags);
+		spin_unlock(&sbz->s_dentry_lru_lock);
+	}
 }
 
 /**
@@ -749,31 +764,29 @@ again2:
  * This function may fail to free any resources if all the dentries are in use.
  */
 static void prune_dcache(struct zone *zone, unsigned long scanned,
-			unsigned long total, gfp_t gfp_mask)
-
+					unsigned long total, gfp_t gfp_mask)
 {
-	unsigned long nr_to_scan;
 	struct super_block *sb, *n;
-	int w_count;
-	int prune_ratio;
-	int count, pruned;
 
-	shrinker_add_scan(&nr_to_scan, scanned, total, dentry_stat.nr_unused,
-			DEFAULT_SEEKS * sysctl_vfs_cache_pressure / 100);
-done:
-	count = shrinker_do_scan(&nr_to_scan, SHRINK_BATCH);
-	if (dentry_stat.nr_unused == 0 || count == 0)
-		return;
-	if (count >= dentry_stat.nr_unused)
-		prune_ratio = 1;
-	else
-		prune_ratio = dentry_stat.nr_unused / count;
 	spin_lock(&sb_lock);
 	list_for_each_entry_safe(sb, n, &super_blocks, s_list) {
+		struct sb_zoneinfo *sbz = sb_zone_info(sb, zone);
+		unsigned long nr;
+
 		if (list_empty(&sb->s_instances))
 			continue;
-		if (sb->s_nr_dentry_unused == 0)
+		if (sbz->s_nr_dentry_unused == 0)
+			continue;
+
+		shrinker_add_scan(&sbz->s_nr_dentry_scan, scanned, total,
+						sbz->s_nr_dentry_unused,
+			DEFAULT_SEEKS * sysctl_vfs_cache_pressure / 100);
+		if (!(gfp_mask & __GFP_FS))
+		       continue;
+		nr = ACCESS_ONCE(sbz->s_nr_dentry_scan);
+		if (nr < SHRINK_BATCH)
 			continue;
+
 		sb->s_count++;
 		/* Now, we reclaim unused dentrins with fairness.
 		 * We reclaim them same percentage from each superblock.
@@ -785,11 +798,8 @@ done:
 		 * number of dentries in the machine)
 		 */
 		spin_unlock(&sb_lock);
-		if (prune_ratio != 1)
-			w_count = (sb->s_nr_dentry_unused / prune_ratio) + 1;
-		else
-			w_count = sb->s_nr_dentry_unused;
-		pruned = w_count;
+
+
 		/*
 		 * We need to be sure this filesystem isn't being unmounted,
 		 * otherwise we could race with generic_shutdown_super(), and
@@ -798,28 +808,24 @@ done:
 		 * s_root isn't NULL.
 		 */
 		if (down_read_trylock(&sb->s_umount)) {
-			if ((sb->s_root != NULL) &&
-			    (!list_empty(&sb->s_dentry_lru))) {
-				__shrink_dcache_sb(sb, &w_count,
-						DCACHE_REFERENCED);
-				pruned -= w_count;
+			spin_lock(&sbz->s_dentry_lru_lock);
+			if (sb->s_root != NULL &&
+					!list_empty(&sbz->s_dentry_lru)) {
+				count_vm_events(SLABS_SCANNED, nr);
+				sbz->s_nr_dentry_scan = 0;
+				__shrink_dcache_sb_zone(sb, sbz,
+					&nr, DCACHE_REFERENCED);
+				sbz->s_nr_dentry_scan += nr;
 			}
+			spin_unlock(&sbz->s_dentry_lru_lock);
 			up_read(&sb->s_umount);
 		}
 		spin_lock(&sb_lock);
 		/* lock was dropped, must reset next */
 		list_safe_reset_next(sb, n, s_list);
-		count -= pruned;
 		__put_super(sb);
-		/* more work left to do? */
-		if (count <= 0)
-			break;
 	}
 	spin_unlock(&sb_lock);
-	if (count <= 0) {
-		cond_resched();
-		goto done;
-	}
 }
 
 /**
@@ -1167,8 +1173,9 @@ out:
 void shrink_dcache_parent(struct dentry * parent)
 {
 	struct super_block *sb = parent->d_sb;
-	int found;
+	unsigned long found;
 
+	/* doesn't work well anymore :( */
 	while ((found = select_parent(parent)) != 0)
 		__shrink_dcache_sb(sb, &found, 0);
 }
@@ -1189,7 +1196,7 @@ EXPORT_SYMBOL(shrink_dcache_parent);
 static int shrink_dcache_memory(struct zone *zone, unsigned long scanned,
 		unsigned long total, unsigned long global, gfp_t gfp_mask)
 {
-	prune_dcache(zone, scanned, global, gfp_mask);
+	prune_dcache(zone, scanned, total, gfp_mask);
 	return 0;
 }
 
Index: linux-2.6/fs/inode.c
===================================================================
--- linux-2.6.orig/fs/inode.c
+++ linux-2.6/fs/inode.c
@@ -35,7 +35,7 @@
  *   s_inodes, i_sb_list
  * inode_hash_bucket lock protects:
  *   inode hash table, i_hash
- * inode_lru_lock protects:
+ * zone->inode_lru_lock protects:
  *   inode_lru, i_lru
  * wb->b_lock protects:
  *   b_io, b_more_io, b_dirty, i_io, i_lru
@@ -51,7 +51,7 @@
  * inode_lock
  *   inode->i_lock
  *     inode_list_lglock
- *     inode_lru_lock
+ *     zone->inode_lru_lock
  *     wb->b_lock
  *     inode_hash_bucket lock
  */
@@ -102,8 +102,6 @@ static unsigned int i_hash_shift __read_
  * allowing for low-overhead inode sync() operations.
  */
 
-static LIST_HEAD(inode_lru);
-
 struct inode_hash_bucket {
 	struct hlist_bl_head head;
 };
@@ -129,8 +127,6 @@ static struct inode_hash_bucket *inode_h
 DECLARE_LGLOCK(inode_list_lglock);
 DEFINE_LGLOCK(inode_list_lglock);
 
-static DEFINE_SPINLOCK(inode_lru_lock);
-
 /*
  * iprune_sem provides exclusion between the kswapd or try_to_free_pages
  * icache shrinking path, and the umount path.  Without this exclusion,
@@ -428,18 +424,22 @@ static void dispose_list(struct list_hea
 
 void __inode_lru_list_add(struct inode *inode)
 {
-	spin_lock(&inode_lru_lock);
-	list_add(&inode->i_lru, &inode_lru);
-	inodes_stat.nr_unused++;
-	spin_unlock(&inode_lru_lock);
+	struct zone *z = page_zone(virt_to_page(inode));
+
+	spin_lock(&z->inode_lru_lock);
+	list_add(&inode->i_lru, &z->inode_lru);
+	z->inode_nr_lru++;
+	spin_unlock(&z->inode_lru_lock);
 }
 
 void __inode_lru_list_del(struct inode *inode)
 {
-	spin_lock(&inode_lru_lock);
+	struct zone *z = page_zone(virt_to_page(inode));
+
+	spin_lock(&z->inode_lru_lock);
 	list_del_init(&inode->i_lru);
-	inodes_stat.nr_unused--;
-	spin_unlock(&inode_lru_lock);
+	z->inode_nr_lru--;
+	spin_unlock(&z->inode_lru_lock);
 }
 
 /*
@@ -464,10 +464,7 @@ static int invalidate_sb_inodes(struct s
 			list_del_init(&inode->i_io);
 			spin_unlock(&wb->b_lock);
 
-			spin_lock(&inode_lru_lock);
-			list_del(&inode->i_lru);
-			inodes_stat.nr_unused--;
-			spin_unlock(&inode_lru_lock);
+			__inode_lru_list_del(inode);
 
 			WARN_ON(inode->i_state & I_NEW);
 			inode->i_state |= I_FREEING;
@@ -534,55 +531,58 @@ static void prune_icache(struct zone *zo
 
 	down_read(&iprune_sem);
 again:
-	spin_lock(&inode_lru_lock);
+	spin_lock(&zone->inode_lru_lock);
 	for (; nr_to_scan; nr_to_scan--) {
 		struct inode *inode;
 
-		if (list_empty(&inode_lru))
+		if (list_empty(&zone->inode_lru))
 			break;
 
-		inode = list_entry(inode_lru.prev, struct inode, i_lru);
+		inode = list_entry(zone->inode_lru.prev, struct inode, i_lru);
 
 		if (!spin_trylock(&inode->i_lock)) {
-			spin_unlock(&inode_lru_lock);
+			spin_unlock(&zone->inode_lru_lock);
+			cpu_relax();
 			goto again;
 		}
 		if (inode->i_count || (inode->i_state & ~I_REFERENCED)) {
 			list_del_init(&inode->i_lru);
 			spin_unlock(&inode->i_lock);
-			inodes_stat.nr_unused--;
+			zone->inode_nr_lru--;
 			continue;
 		}
 		if (inode->i_state) {
-			list_move(&inode->i_lru, &inode_lru);
+			list_move(&inode->i_lru, &zone->inode_lru);
 			inode->i_state &= ~I_REFERENCED;
 			spin_unlock(&inode->i_lock);
 			continue;
 		}
 		if (inode_has_buffers(inode) || inode->i_data.nrpages) {
-			list_move(&inode->i_lru, &inode_lru);
-			spin_unlock(&inode_lru_lock);
+			list_move(&inode->i_lru, &zone->inode_lru);
+			spin_unlock(&zone->inode_lru_lock);
 			__iget(inode);
 			spin_unlock(&inode->i_lock);
 
+			dispose_list(&freeable);
+
 			if (remove_inode_buffers(inode))
 				reap += invalidate_mapping_pages(&inode->i_data,
 								0, -1);
 			iput(inode);
-			spin_lock(&inode_lru_lock);
+			spin_lock(&zone->inode_lru_lock);
 			continue;
 		}
 		list_move(&inode->i_lru, &freeable);
 		WARN_ON(inode->i_state & I_NEW);
 		inode->i_state |= I_FREEING;
 		spin_unlock(&inode->i_lock);
-		inodes_stat.nr_unused--;
+		zone->inode_nr_lru--;
 	}
 	if (current_is_kswapd())
 		__count_vm_events(KSWAPD_INODESTEAL, reap);
 	else
 		__count_vm_events(PGINODESTEAL, reap);
-	spin_unlock(&inode_lru_lock);
+	spin_unlock(&zone->inode_lru_lock);
 
 	dispose_list(&freeable);
 	up_read(&iprune_sem);
@@ -600,19 +600,24 @@ again:
 static int shrink_icache_memory(struct zone *zone, unsigned long scanned,
 		unsigned long total, unsigned long global, gfp_t gfp_mask)
 {
-	static unsigned long nr_to_scan;
 	unsigned long nr;
 
-	shrinker_add_scan(&nr_to_scan, scanned, global,
-			inodes_stat.nr_unused,
+	shrinker_add_scan(&zone->inode_nr_scan, scanned, total,
+					zone->inode_nr_lru,
 			DEFAULT_SEEKS * sysctl_vfs_cache_pressure / 100);
+	/*
+	 * Nasty deadlock avoidance.  We may hold various FS locks,
+	 * and we don't want to recurse into the FS that called us
+	 * in clear_inode() and friends..
+	 */
 	if (!(gfp_mask & __GFP_FS))
-	       return 0;
+		return 0;
 
-	while ((nr = shrinker_do_scan(&nr_to_scan, SHRINK_BATCH))) {
-		prune_icache(zone, nr);
-		cond_resched();
-	}
+	nr = ACCESS_ONCE(zone->inode_nr_scan);
+	if (nr < SHRINK_BATCH)
+		return 0;
+	zone->inode_nr_scan = 0;
+	prune_icache(zone, nr);
 
 	return 0;
 }
@@ -1431,12 +1436,8 @@ void generic_delete_inode(struct inode *
 {
 	const struct super_operations *op = inode->i_sb->s_op;
 
-	if (!list_empty(&inode->i_lru)) {
-		spin_lock(&inode_lru_lock);
-		list_del_init(&inode->i_lru);
-		inodes_stat.nr_unused--;
-		spin_unlock(&inode_lru_lock);
-	}
+	if (!list_empty(&inode->i_lru))
+		__inode_lru_list_del(inode);
 	if (!list_empty(&inode->i_io)) {
 		struct bdi_writeback *wb = inode_to_wb(inode);
 		spin_lock(&wb->b_lock);
@@ -1493,10 +1494,7 @@ int generic_detach_inode(struct inode *i
 			inode->i_state |= I_REFERENCED;
 			if (!(inode->i_state & (I_DIRTY|I_SYNC)) &&
 					list_empty(&inode->i_lru)) {
-				spin_lock(&inode_lru_lock);
-				list_add(&inode->i_lru, &inode_lru);
-				inodes_stat.nr_unused++;
-				spin_unlock(&inode_lru_lock);
+				__inode_lru_list_add(inode);
 			}
 			spin_unlock(&inode->i_lock);
 			return 0;
@@ -1510,12 +1508,8 @@ int generic_detach_inode(struct inode *i
 		inode->i_state &= ~I_WILL_FREE;
 		__remove_inode_hash(inode);
 	}
-	if (!list_empty(&inode->i_lru)) {
-		spin_lock(&inode_lru_lock);
-		list_del_init(&inode->i_lru);
-		inodes_stat.nr_unused--;
-		spin_unlock(&inode_lru_lock);
-	}
+	if (!list_empty(&inode->i_lru))
+		__inode_lru_list_del(inode);
 	if (!list_empty(&inode->i_io)) {
 		struct bdi_writeback *wb = inode_to_wb(inode);
 		spin_lock(&wb->b_lock);
@@ -1831,6 +1825,7 @@ void __init inode_init_early(void)
 void __init inode_init(void)
 {
 	int loop;
+	struct zone *zone;
 
 	percpu_counter_init(&nr_inodes, 0);
 	/* inode slab cache */
@@ -1840,6 +1835,12 @@ void __init inode_init(void)
 					 (SLAB_RECLAIM_ACCOUNT|SLAB_PANIC|
 					 SLAB_MEM_SPREAD),
 					 init_once);
+	for_each_zone(zone) {
+		spin_lock_init(&zone->inode_lru_lock);
+		INIT_LIST_HEAD(&zone->inode_lru);
+		zone->inode_nr_lru = 0;
+		zone->inode_nr_scan = 0;
+	}
 	register_shrinker(&icache_shrinker);
 
 	lg_lock_init(inode_list_lglock);
Index: linux-2.6/fs/super.c
===================================================================
--- linux-2.6.orig/fs/super.c
+++ linux-2.6/fs/super.c
@@ -50,6 +50,8 @@ static struct super_block *alloc_super(s
 	static const struct super_operations default_op;
 
 	if (s) {
+		struct zone *zone;
+
 		if (security_sb_alloc(s)) {
 			kfree(s);
 			s = NULL;
@@ -88,7 +90,6 @@ static struct super_block *alloc_super(s
 #endif
 		INIT_LIST_HEAD(&s->s_instances);
 		INIT_HLIST_BL_HEAD(&s->s_anon);
-		INIT_LIST_HEAD(&s->s_dentry_lru);
 		init_rwsem(&s->s_umount);
 		mutex_init(&s->s_lock);
 		lockdep_set_class(&s->s_umount, &type->s_umount_key);
@@ -125,6 +126,15 @@ static struct super_block *alloc_super(s
 		s->s_maxbytes = MAX_NON_LFS;
 		s->s_op = &default_op;
 		s->s_time_gran = 1000000000;
+
+		for_each_zone(zone) {
+			struct sb_zoneinfo *sbz = sb_zone_info(s, zone);
+
+			spin_lock_init(&sbz->s_dentry_lru_lock);
+			INIT_LIST_HEAD(&sbz->s_dentry_lru);
+			sbz->s_nr_dentry_scan = 0;
+			sbz->s_nr_dentry_unused = 0;
+		}
 	}
 out:
 	return s;
Index: linux-2.6/include/linux/mmzone.h
===================================================================
--- linux-2.6.orig/include/linux/mmzone.h
+++ linux-2.6/include/linux/mmzone.h
@@ -370,6 +370,13 @@ struct zone {
 
 
 	ZONE_PADDING(_pad2_)
+
+	spinlock_t inode_lru_lock;
+	struct list_head inode_lru;
+	unsigned long inode_nr_lru;
+	unsigned long inode_nr_scan;
+
+	ZONE_PADDING(_pad3_)
 	/* Rarely used or read-mostly fields */
 
 	/*
Index: linux-2.6/include/linux/mm.h
===================================================================
--- linux-2.6.orig/include/linux/mm.h
+++ linux-2.6/include/linux/mm.h
@@ -1004,7 +1004,8 @@ struct shrinker {
 	/* These are for internal use */
 	struct list_head list;
 };
-#define DEFAULT_SEEKS	(128UL*2) /* A good number if you don't know better. */
+#define SHRINK_FIXED	(128UL)	/* Fixed point for shrinker ratio */
+#define DEFAULT_SEEKS	(SHRINK_FIXED*2) /* A good number if you don't know better. */
 #define SHRINK_BATCH	128	/* A good number if you don't know better */
 extern void register_shrinker(struct shrinker *);
 extern void unregister_shrinker(struct shrinker *);


