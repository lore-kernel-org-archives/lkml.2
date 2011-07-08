Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752625Ab1GHEQz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 00:16:55 -0400
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:33066 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751210Ab1GHEPX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 00:15:23 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlwHAIiCFk55LCkBgWdsb2JhbABTmE2OdBUBARYmJc0NhjgEl0mDI4g2
From: Dave Chinner <david@fromorbit.com>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: [PATCH 11/14] inode: remove iprune_sem
Date: Fri,  8 Jul 2011 14:14:43 +1000
Message-Id: <1310098486-6453-12-git-send-email-david@fromorbit.com>
X-Mailer: git-send-email 1.7.5.1
In-Reply-To: <1310098486-6453-1-git-send-email-david@fromorbit.com>
References: <1310098486-6453-1-git-send-email-david@fromorbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Now that we have per-sb shrinkers with a lifecycle that is a subset
of the superblock lifecycle and can reliably detect a filesystem
being unmounted, there is not longer any race condition for the
iprune_sem to protect against. Hence we can remove it.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/inode.c |   21 ---------------------
 1 files changed, 0 insertions(+), 21 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index d8a562e..529bb0b 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -68,17 +68,6 @@ __cacheline_aligned_in_smp DEFINE_SPINLOCK(inode_sb_list_lock);
 __cacheline_aligned_in_smp DEFINE_SPINLOCK(inode_wb_list_lock);
 
 /*
- * iprune_sem provides exclusion between the icache shrinking and the
- * umount path.
- *
- * We don't actually need it to protect anything in the umount path,
- * but only need to cycle through it to make sure any inode that
- * prune_icache_sb took off the LRU list has been fully torn down by the
- * time we are past evict_inodes.
- */
-static DECLARE_RWSEM(iprune_sem);
-
-/*
  * Empty aops. Can be used for the cases where the user does not
  * define any of the address_space operations.
  */
@@ -535,14 +524,6 @@ void evict_inodes(struct super_block *sb)
 	spin_unlock(&inode_sb_list_lock);
 
 	dispose_list(&dispose);
-
-	/*
-	 * Cycle through iprune_sem to make sure any inode that prune_icache_sb
-	 * moved off the list before we took the lock has been fully torn
-	 * down.
-	 */
-	down_write(&iprune_sem);
-	up_write(&iprune_sem);
 }
 
 /**
@@ -628,7 +609,6 @@ void prune_icache_sb(struct super_block *sb, int nr_to_scan)
 	int nr_scanned;
 	unsigned long reap = 0;
 
-	down_read(&iprune_sem);
 	spin_lock(&sb->s_inode_lru_lock);
 	for (nr_scanned = nr_to_scan; nr_scanned >= 0; nr_scanned--) {
 		struct inode *inode;
@@ -704,7 +684,6 @@ void prune_icache_sb(struct super_block *sb, int nr_to_scan)
 	spin_unlock(&sb->s_inode_lru_lock);
 
 	dispose_list(&freeable);
-	up_read(&iprune_sem);
 }
 
 static void __wait_on_freeing_inode(struct inode *inode);
-- 
1.7.5.1

