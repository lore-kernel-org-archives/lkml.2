Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933752Ab0JSD4r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 23:56:47 -0400
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:28444 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933713Ab0JSD40 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 23:56:26 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AnEFAJyxvEx5LcB2gWdsb2JhbACUbYx6FgEBFiIiwxaFSQSKSg
Message-Id: <20101019034658.744504135@kernel.dk>
User-Agent: quilt/0.48-1
Date: Tue, 19 Oct 2010 14:42:47 +1100
From: npiggin@kernel.dk
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [patch 31/35] fs: icache per-zone inode LRU
References: <20101019034216.319085068@kernel.dk>
Content-Disposition: inline; filename=fs-inode-per-zone-lru.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Per-zone LRUs and shrinkers for inode cache.

Signed-off-by: Nick Piggin <npiggin@kernel.dk>

---
 fs/inode.c             |   84 ++++++++++++++++++++++++++++---------------------
 include/linux/mmzone.h |    7 ++++
 2 files changed, 56 insertions(+), 35 deletions(-)

Index: linux-2.6/fs/inode.c
===================================================================
--- linux-2.6.orig/fs/inode.c	2010-10-19 14:38:31.000000000 +1100
+++ linux-2.6/fs/inode.c	2010-10-19 14:39:04.000000000 +1100
@@ -34,7 +34,7 @@
  *   s_inodes, i_sb_list
  * inode_hash_bucket lock protects:
  *   inode hash table, i_hash
- * inode_lru_lock protects:
+ * zone->inode_lru_lock protects:
  *   inode_lru, i_lru
  * wb->b_lock protects:
  *   b_io, b_more_io, b_dirty, i_io, i_lru
@@ -49,7 +49,7 @@
  * Ordering:
  * inode->i_lock
  *   inode_list_lglock
- *   inode_lru_lock
+ *   zone->inode_lru_lock
  *   wb->b_lock
  *   inode_hash_bucket lock
  */
@@ -100,8 +100,6 @@
  * allowing for low-overhead inode sync() operations.
  */
 
-static LIST_HEAD(inode_lru);
-
 struct inode_hash_bucket {
 	struct hlist_bl_head head;
 };
@@ -127,8 +125,6 @@
 DECLARE_LGLOCK(inode_list_lglock);
 DEFINE_LGLOCK(inode_list_lglock);
 
-static DEFINE_SPINLOCK(inode_lru_lock);
-
 /*
  * iprune_sem provides exclusion between the kswapd or try_to_free_pages
  * icache shrinking path, and the umount path.  Without this exclusion,
@@ -166,7 +162,12 @@
 
 int get_nr_inodes_unused(void)
 {
-	return inodes_stat.nr_unused;
+	int nr = 0;
+	struct zone *z;
+
+	for_each_populated_zone(z)
+		nr += z->inode_nr_lru;
+	return nr;
 }
 
 /*
@@ -177,6 +178,7 @@
 {
 #if defined(CONFIG_SYSCTL) && defined(CONFIG_PROC_FS)
 	inodes_stat.nr_inodes = get_nr_inodes();
+	inodes_stat.nr_unused = get_nr_inodes_unused();
 	return proc_dointvec(table, write, buffer, lenp, ppos);
 #else
 	return -ENOSYS;
@@ -440,10 +442,12 @@
  */
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
 
 /*
@@ -451,10 +455,12 @@
  */
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
@@ -549,34 +555,35 @@
  * If the inode has metadata buffers attached to mapping->private_list then
  * try to remove them.
  */
-static void prune_icache(unsigned long nr_to_scan)
+static void prune_icache(struct zone *zone, unsigned long nr_to_scan)
 {
 	LIST_HEAD(freeable);
 	unsigned long reap = 0;
 
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
 		if (inode->i_state & I_REFERENCED) {
-			list_move(&inode->i_lru, &inode_lru);
+			list_move(&inode->i_lru, &zone->inode_lru);
 			inode->i_state &= ~I_REFERENCED;
 			spin_unlock(&inode->i_lock);
 			continue;
@@ -589,8 +596,8 @@
 			 *
 			 * We'll try to get it back if it becomes freeable.
 			 */
-			list_move(&inode->i_lru, &inode_lru);
-			spin_unlock(&inode_lru_lock);
+			list_move(&inode->i_lru, &zone->inode_lru);
+			spin_unlock(&zone->inode_lru_lock);
 			__iget(inode);
 			spin_unlock(&inode->i_lock);
 
@@ -598,8 +605,8 @@
 				reap += invalidate_mapping_pages(&inode->i_data,
 								0, -1);
 			iput(inode);
-			spin_lock(&inode_lru_lock);
-			if (inode == list_entry(inode_lru.next,
+			spin_lock(&zone->inode_lru_lock);
+			if (inode == list_entry(zone->inode_lru.next,
 						struct inode, i_lru)) {
 				if (spin_trylock(&inode->i_lock)) {
 					if (can_unuse(inode))
@@ -614,13 +621,13 @@
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
@@ -639,11 +646,10 @@
 		unsigned long total, unsigned long global,
 		unsigned long flags, gfp_t gfp_mask)
 {
-	static unsigned long nr_to_scan;
 	unsigned long nr;
 
-	shrinker_add_scan(&nr_to_scan, scanned, global,
-			inodes_stat.nr_unused,
+	shrinker_add_scan(&zone->inode_nr_scan, scanned, total,
+			zone->inode_nr_lru,
 			SHRINK_DEFAULT_SEEKS * 100 / sysctl_vfs_cache_pressure);
 	/*
 	 * Nasty deadlock avoidance.  We may hold various FS locks,
@@ -653,11 +659,12 @@
 	if (!(gfp_mask & __GFP_FS))
 	       return;
 
-	while ((nr = shrinker_do_scan(&nr_to_scan, SHRINK_BATCH))) {
-		prune_icache(nr);
-		count_vm_events(SLABS_SCANNED, nr);
-		cond_resched();
-	}
+	nr = ACCESS_ONCE(zone->inode_nr_scan);
+	if (nr < SHRINK_BATCH)
+		return;
+	zone->inode_nr_scan = 0;
+	prune_icache(zone, nr);
+	count_vm_events(SLABS_SCANNED, nr);
 }
 
 static struct shrinker icache_shrinker = {
@@ -1830,6 +1837,7 @@
 void __init inode_init(void)
 {
 	int loop;
+	struct zone *zone;
 
 	/* inode slab cache */
 	inode_cachep = kmem_cache_create("inode_cache",
@@ -1838,6 +1846,12 @@
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
Index: linux-2.6/include/linux/mmzone.h
===================================================================
--- linux-2.6.orig/include/linux/mmzone.h	2010-10-19 14:19:19.000000000 +1100
+++ linux-2.6/include/linux/mmzone.h	2010-10-19 14:38:33.000000000 +1100
@@ -362,6 +362,13 @@
 
 
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


