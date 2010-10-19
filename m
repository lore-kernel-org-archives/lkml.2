Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933726Ab0JSD40 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 23:56:26 -0400
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:28449 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933694Ab0JSD4Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 23:56:24 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AnEFAJyxvEx5LcB2gWdsb2JhbACUbYx6FgEBFiIiwxaFSQSKSoUA
Message-Id: <20101019034656.515395530@kernel.dk>
User-Agent: quilt/0.48-1
Date: Tue, 19 Oct 2010 14:42:26 +1100
From: npiggin@kernel.dk
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [patch 10/35] fs: icache atomic inodes_stat
References: <20101019034216.319085068@kernel.dk>
Content-Disposition: inline; filename=fs-inode_lock-scale-5.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Protect inodes_stat statistics with atomic ops rather than inode_lock.
Also move nr_inodes statistic into low level inode init and teardown
functions in anticipation of future patches which skip putting some
inodes (eg. sockets) onto sb list.

Signed-off-by: Nick Piggin <npiggin@kernel.dk>

---
 fs/fs-writeback.c  |    6 ++++--
 fs/inode.c         |   28 +++++++++++++---------------
 include/linux/fs.h |   11 ++++++++---
 3 files changed, 25 insertions(+), 20 deletions(-)

Index: linux-2.6/fs/fs-writeback.c
===================================================================
--- linux-2.6.orig/fs/fs-writeback.c	2010-10-19 14:37:09.000000000 +1100
+++ linux-2.6/fs/fs-writeback.c	2010-10-19 14:37:31.000000000 +1100
@@ -772,7 +772,8 @@
 	wb->last_old_flush = jiffies;
 	nr_pages = global_page_state(NR_FILE_DIRTY) +
 			global_page_state(NR_UNSTABLE_NFS) +
-			(inodes_stat.nr_inodes - inodes_stat.nr_unused);
+			(atomic_read(&inodes_stat.nr_inodes) -
+			atomic_read(&inodes_stat.nr_unused));
 
 	if (nr_pages) {
 		struct wb_writeback_work work = {
@@ -1156,7 +1157,8 @@
 	WARN_ON(!rwsem_is_locked(&sb->s_umount));
 
 	work.nr_pages = nr_dirty + nr_unstable +
-			(inodes_stat.nr_inodes - inodes_stat.nr_unused);
+			(atomic_read(&inodes_stat.nr_inodes) -
+			atomic_read(&inodes_stat.nr_unused));
 
 	bdi_queue_work(sb->s_bdi, &work);
 	wait_for_completion(&done);
Index: linux-2.6/fs/inode.c
===================================================================
--- linux-2.6.orig/fs/inode.c	2010-10-19 14:37:09.000000000 +1100
+++ linux-2.6/fs/inode.c	2010-10-19 14:37:56.000000000 +1100
@@ -122,7 +122,10 @@
 /*
  * Statistics gathering..
  */
-struct inodes_stat_t inodes_stat;
+struct inodes_stat_t inodes_stat = {
+	.nr_inodes = ATOMIC_INIT(0),
+	.nr_unused = ATOMIC_INIT(0),
+};
 
 static struct kmem_cache *inode_cachep __read_mostly;
 
@@ -213,6 +216,8 @@
 	inode->i_fsnotify_mask = 0;
 #endif
 
+	atomic_inc(&inodes_stat.nr_inodes);
+
 	return 0;
 out:
 	return -ENOMEM;
@@ -253,6 +258,7 @@
 	if (inode->i_default_acl && inode->i_default_acl != ACL_NOT_CACHED)
 		posix_acl_release(inode->i_default_acl);
 #endif
+	atomic_dec(&inodes_stat.nr_inodes);
 }
 EXPORT_SYMBOL(__destroy_inode);
 
@@ -313,7 +319,7 @@
 		list_move(&inode->i_list, &inode_in_use);
 		spin_unlock(&wb_inode_list_lock);
 	}
-	inodes_stat.nr_unused--;
+	atomic_dec(&inodes_stat.nr_unused);
 }
 
 void end_writeback(struct inode *inode)
@@ -354,8 +360,6 @@
  */
 static void dispose_list(struct list_head *head)
 {
-	int nr_disposed = 0;
-
 	while (!list_empty(head)) {
 		struct inode *inode;
 
@@ -375,11 +379,7 @@
 
 		wake_up_inode(inode);
 		destroy_inode(inode);
-		nr_disposed++;
 	}
-	spin_lock(&inode_lock);
-	inodes_stat.nr_inodes -= nr_disposed;
-	spin_unlock(&inode_lock);
 }
 
 /*
@@ -428,7 +428,7 @@
 		busy = 1;
 	}
 	/* only unused inodes may be cached with i_count zero */
-	inodes_stat.nr_unused -= count;
+	atomic_sub(count, &inodes_stat.nr_unused);
 	return busy;
 }
 
@@ -545,7 +545,7 @@
 		spin_unlock(&inode->i_lock);
 		nr_pruned++;
 	}
-	inodes_stat.nr_unused -= nr_pruned;
+	atomic_sub(nr_pruned, &inodes_stat.nr_unused);
 	if (current_is_kswapd())
 		__count_vm_events(KSWAPD_INODESTEAL, reap);
 	else
@@ -574,7 +574,7 @@
 	unsigned long nr;
 
 	shrinker_add_scan(&nr_to_scan, scanned, global,
-			inodes_stat.nr_unused,
+			atomic_read(&inodes_stat.nr_unused),
 			SHRINK_DEFAULT_SEEKS * 100 / sysctl_vfs_cache_pressure);
 	/*
 	 * Nasty deadlock avoidance.  We may hold various FS locks,
@@ -680,7 +680,6 @@
 __inode_add_to_lists(struct super_block *sb, struct hlist_head *head,
 			struct inode *inode)
 {
-	inodes_stat.nr_inodes++;
 	spin_lock(&sb_inode_list_lock);
 	list_add(&inode->i_sb_list, &sb->s_inodes);
 	spin_unlock(&sb_inode_list_lock);
@@ -1344,7 +1343,7 @@
 			list_move(&inode->i_list, &inode_unused);
 			spin_unlock(&wb_inode_list_lock);
 		}
-		inodes_stat.nr_unused++;
+		atomic_inc(&inodes_stat.nr_unused);
 		if (sb->s_flags & MS_ACTIVE) {
 			spin_unlock(&inode->i_lock);
 			spin_unlock(&sb_inode_list_lock);
@@ -1362,10 +1361,10 @@
 		spin_lock(&inode->i_lock);
 		WARN_ON(inode->i_state & I_NEW);
 		inode->i_state &= ~I_WILL_FREE;
-		inodes_stat.nr_unused--;
 		spin_lock(&inode_hash_lock);
 		hlist_del_init(&inode->i_hash);
 		spin_unlock(&inode_hash_lock);
+		atomic_dec(&inodes_stat.nr_unused);
 	}
 	spin_lock(&wb_inode_list_lock);
 	list_del_init(&inode->i_list);
@@ -1374,7 +1373,6 @@
 	spin_unlock(&sb_inode_list_lock);
 	WARN_ON(inode->i_state & I_NEW);
 	inode->i_state |= I_FREEING;
-	inodes_stat.nr_inodes--;
 	spin_unlock(&inode->i_lock);
 	spin_unlock(&inode_lock);
 	evict(inode);
Index: linux-2.6/include/linux/fs.h
===================================================================
--- linux-2.6.orig/include/linux/fs.h	2010-10-19 14:37:09.000000000 +1100
+++ linux-2.6/include/linux/fs.h	2010-10-19 14:37:31.000000000 +1100
@@ -40,12 +40,17 @@
 };
 
 struct inodes_stat_t {
-	int nr_inodes;
-	int nr_unused;
+	/*
+	 * Using atomics here is a hack which should just happen to
+	 * work on all architectures today. Not a big deal though,
+	 * because it goes away and gets fixed properly later in the
+	 * inode scaling series.
+	 */
+	atomic_t nr_inodes;
+	atomic_t nr_unused;
 	int dummy[5];		/* padding for sysctl ABI compatibility */
 };
 
-
 #define NR_FILE  8192	/* this can well be larger on a larger system */
 
 #define MAY_EXEC 1


