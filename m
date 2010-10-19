Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933440Ab0JSD4Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 23:56:16 -0400
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:28449 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758024Ab0JSD4K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 23:56:10 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AnEFAJyxvEx5LcB2gWdsb2JhbACUbYx6FgEBFiIiwxaFSQSKSg
Message-Id: <20101019034655.866685321@kernel.dk>
User-Agent: quilt/0.48-1
Date: Tue, 19 Oct 2010 14:42:20 +1100
From: npiggin@kernel.dk
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: linux-mm@kvack.org
Subject: [patch 04/35] vfs: convert inode and dentry caches to per-zone shrinker
References: <20101019034216.319085068@kernel.dk>
Content-Disposition: inline; filename=vfs-zone-shrinker.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert inode and dentry caches to per-zone shrinker API in preparation
for doing proper per-zone cache LRU lists. These two caches tend to be
the most important in the system after the pagecache lrus, so making these
per-zone will help to fix up the funny quirks in vmscan code that tries
to reconcile the whole zone-driven scanning with the global slab reclaim.

Cc: linux-mm@kvack.org
Signed-off-by: Nick Piggin <npiggin@kernel.dk>

---
 fs/dcache.c |   31 ++++++++++++++++++++-----------
 fs/inode.c  |   39 ++++++++++++++++++++++++---------------
 2 files changed, 44 insertions(+), 26 deletions(-)

Index: linux-2.6/fs/dcache.c
===================================================================
--- linux-2.6.orig/fs/dcache.c	2010-10-19 14:35:42.000000000 +1100
+++ linux-2.6/fs/dcache.c	2010-10-19 14:36:53.000000000 +1100
@@ -534,7 +534,7 @@
  *
  * This function may fail to free any resources if all the dentries are in use.
  */
-static void prune_dcache(int count)
+static void prune_dcache(unsigned long count)
 {
 	struct super_block *sb, *p = NULL;
 	int w_count;
@@ -887,7 +887,8 @@
 EXPORT_SYMBOL(shrink_dcache_parent);
 
 /*
- * Scan `nr' dentries and return the number which remain.
+ * shrink_dcache_memory scans and reclaims unused dentries. This function
+ * is defined according to the shrinker API described in linux/mm.h.
  *
  * We need to avoid reentering the filesystem if the caller is performing a
  * GFP_NOFS allocation attempt.  One example deadlock is:
@@ -895,22 +896,30 @@
  * ext2_new_block->getblk->GFP->shrink_dcache_memory->prune_dcache->
  * prune_one_dentry->dput->dentry_iput->iput->inode->i_sb->s_op->put_inode->
  * ext2_discard_prealloc->ext2_free_blocks->lock_super->DEADLOCK.
- *
- * In this case we return -1 to tell the caller that we baled.
  */
-static int shrink_dcache_memory(struct shrinker *shrink, int nr, gfp_t gfp_mask)
+static void shrink_dcache_memory(struct shrinker *shrink,
+		struct zone *zone, unsigned long scanned,
+		unsigned long total, unsigned long global,
+		unsigned long flags, gfp_t gfp_mask)
 {
-	if (nr) {
-		if (!(gfp_mask & __GFP_FS))
-			return -1;
+	static unsigned long nr_to_scan;
+	unsigned long nr;
+
+	shrinker_add_scan(&nr_to_scan, scanned, global,
+			dentry_stat.nr_unused,
+			SHRINK_DEFAULT_SEEKS * 100 / sysctl_vfs_cache_pressure);
+	if (!(gfp_mask & __GFP_FS))
+	       return;
+
+	while ((nr = shrinker_do_scan(&nr_to_scan, SHRINK_BATCH))) {
 		prune_dcache(nr);
+		count_vm_events(SLABS_SCANNED, nr);
+		cond_resched();
 	}
-	return (dentry_stat.nr_unused / 100) * sysctl_vfs_cache_pressure;
 }
 
 static struct shrinker dcache_shrinker = {
-	.shrink = shrink_dcache_memory,
-	.seeks = DEFAULT_SEEKS,
+	.shrink_zone = shrink_dcache_memory,
 };
 
 /**
Index: linux-2.6/fs/inode.c
===================================================================
--- linux-2.6.orig/fs/inode.c	2010-10-19 14:35:42.000000000 +1100
+++ linux-2.6/fs/inode.c	2010-10-19 14:37:05.000000000 +1100
@@ -445,7 +445,7 @@
  * If the inode has metadata buffers attached to mapping->private_list then
  * try to remove them.
  */
-static void prune_icache(int nr_to_scan)
+static void prune_icache(unsigned long nr_to_scan)
 {
 	LIST_HEAD(freeable);
 	int nr_pruned = 0;
@@ -503,27 +503,36 @@
  * not open and the dcache references to those inodes have already been
  * reclaimed.
  *
- * This function is passed the number of inodes to scan, and it returns the
- * total number of remaining possibly-reclaimable inodes.
+ * This function is defined according to shrinker API described in linux/mm.h.
  */
-static int shrink_icache_memory(struct shrinker *shrink, int nr, gfp_t gfp_mask)
+static void shrink_icache_memory(struct shrinker *shrink,
+		struct zone *zone, unsigned long scanned,
+		unsigned long total, unsigned long global,
+		unsigned long flags, gfp_t gfp_mask)
 {
-	if (nr) {
-		/*
-		 * Nasty deadlock avoidance.  We may hold various FS locks,
-		 * and we don't want to recurse into the FS that called us
-		 * in clear_inode() and friends..
-		 */
-		if (!(gfp_mask & __GFP_FS))
-			return -1;
+	static unsigned long nr_to_scan;
+	unsigned long nr;
+
+	shrinker_add_scan(&nr_to_scan, scanned, global,
+			inodes_stat.nr_unused,
+			SHRINK_DEFAULT_SEEKS * 100 / sysctl_vfs_cache_pressure);
+	/*
+	 * Nasty deadlock avoidance.  We may hold various FS locks,
+	 * and we don't want to recurse into the FS that called us
+	 * in clear_inode() and friends..
+	 */
+	if (!(gfp_mask & __GFP_FS))
+	       return;
+
+	while ((nr = shrinker_do_scan(&nr_to_scan, SHRINK_BATCH))) {
 		prune_icache(nr);
+		count_vm_events(SLABS_SCANNED, nr);
+		cond_resched();
 	}
-	return (inodes_stat.nr_unused / 100) * sysctl_vfs_cache_pressure;
 }
 
 static struct shrinker icache_shrinker = {
-	.shrink = shrink_icache_memory,
-	.seeks = DEFAULT_SEEKS,
+	.shrink_zone = shrink_icache_memory,
 };
 
 static void __wait_on_freeing_inode(struct inode *inode);


