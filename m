Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760745Ab0J2DZT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 23:25:19 -0400
Received: from bld-mail19.adl2.internode.on.net ([150.101.137.104]:55141 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759976Ab0J2DYm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 23:24:42 -0400
From: Dave Chinner <david@fromorbit.com>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4/8] fs: remove inode_lock from iput_final and prune_icache
Date: Fri, 29 Oct 2010 14:23:36 +1100
Message-Id: <1288322620-8566-5-git-send-email-david@fromorbit.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1288322620-8566-1-git-send-email-david@fromorbit.com>
References: <1288322620-8566-1-git-send-email-david@fromorbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Now that inode state changes are protected by the inode->i_lock and
the inode LRU manipulations by the inode_lru_lock, we can remove the
inode_lock from prune_icache and the initial part of iput_final().

instead of using the inode_lock to protect the inode during
iput_final, use the inode->i_lock instead. This protects the inode
against new references being taken while we change the inode state
to I_FREEING, as well as preventing prune_icache from grabbing the
inode while we are manipulating it. Hence we no longer need the
inode_lock in iput_final prior to setting I_FREEING on the inode.

For prune_icache, we no longer need the inode_lock to protect the
LRU list, and the inodes themselves are protected against freeing
races by the inode->i_lock. Hence we can lift the inode_lock from
prune_icache as well.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/inode.c |   17 +++--------------
 1 files changed, 3 insertions(+), 14 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index f00ae32..b6a5dfe 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -618,7 +618,6 @@ static void prune_icache(int nr_to_scan)
 	unsigned long reap = 0;
 
 	down_read(&iprune_sem);
-	spin_lock(&inode_lock);
 	spin_lock(&inode_lru_lock);
 	for (nr_scanned = 0; nr_scanned < nr_to_scan; nr_scanned++) {
 		struct inode *inode;
@@ -644,8 +643,8 @@ static void prune_icache(int nr_to_scan)
 		 */
 		if (atomic_read(&inode->i_count) ||
 		    (inode->i_state & ~I_REFERENCED)) {
-			spin_unlock(&inode->i_lock);
 			list_del_init(&inode->i_lru);
+			spin_unlock(&inode->i_lock);
 			percpu_counter_dec(&nr_inodes_unused);
 			continue;
 		}
@@ -653,20 +652,18 @@ static void prune_icache(int nr_to_scan)
 		/* recently referenced inodes get one more pass */
 		if (inode->i_state & I_REFERENCED) {
 			inode->i_state &= ~I_REFERENCED;
-			spin_unlock(&inode->i_lock);
 			list_move(&inode->i_lru, &inode_lru);
+			spin_unlock(&inode->i_lock);
 			continue;
 		}
 		if (inode_has_buffers(inode) || inode->i_data.nrpages) {
 			__iget(inode);
 			spin_unlock(&inode->i_lock);
 			spin_unlock(&inode_lru_lock);
-			spin_unlock(&inode_lock);
 			if (remove_inode_buffers(inode))
 				reap += invalidate_mapping_pages(&inode->i_data,
 								0, -1);
 			iput(inode);
-			spin_lock(&inode_lock);
 			spin_lock(&inode_lru_lock);
 
 			if (inode != list_entry(inode_lru.next,
@@ -696,7 +693,6 @@ static void prune_icache(int nr_to_scan)
 	else
 		__count_vm_events(PGINODESTEAL, reap);
 	spin_unlock(&inode_lru_lock);
-	spin_unlock(&inode_lock);
 
 	dispose_list(&freeable);
 	up_read(&iprune_sem);
@@ -1054,7 +1050,6 @@ EXPORT_SYMBOL(iunique);
 
 struct inode *igrab(struct inode *inode)
 {
-	spin_lock(&inode_lock);
 	spin_lock(&inode->i_lock);
 	if (!(inode->i_state & (I_FREEING|I_WILL_FREE))) {
 		__iget(inode);
@@ -1068,7 +1063,6 @@ struct inode *igrab(struct inode *inode)
 		 */
 		inode = NULL;
 	}
-	spin_unlock(&inode_lock);
 	return inode;
 }
 EXPORT_SYMBOL(igrab);
@@ -1412,7 +1406,6 @@ static void iput_final(struct inode *inode)
 	const struct super_operations *op = inode->i_sb->s_op;
 	int drop;
 
-	spin_lock(&inode->i_lock);
 	WARN_ON(inode->i_state & I_NEW);
 
 	if (op && op->drop_inode)
@@ -1425,16 +1418,13 @@ static void iput_final(struct inode *inode)
 		if (!(inode->i_state & (I_DIRTY|I_SYNC)))
 			inode_lru_list_add(inode);
 		spin_unlock(&inode->i_lock);
-		spin_unlock(&inode_lock);
 		return;
 	}
 
 	if (!drop) {
 		inode->i_state |= I_WILL_FREE;
 		spin_unlock(&inode->i_lock);
-		spin_unlock(&inode_lock);
 		write_inode_now(inode, 1);
-		spin_lock(&inode_lock);
 		spin_lock(&inode->i_lock);
 		WARN_ON(inode->i_state & I_NEW);
 		inode->i_state &= ~I_WILL_FREE;
@@ -1443,7 +1433,6 @@ static void iput_final(struct inode *inode)
 	inode->i_state |= I_FREEING;
 	inode_lru_list_del(inode);
 	spin_unlock(&inode->i_lock);
-	spin_unlock(&inode_lock);
 
 	evict(inode);
 }
@@ -1462,7 +1451,7 @@ void iput(struct inode *inode)
 	if (inode) {
 		BUG_ON(inode->i_state & I_CLEAR);
 
-		if (atomic_dec_and_lock(&inode->i_count, &inode_lock))
+		if (atomic_dec_and_lock(&inode->i_count, &inode->i_lock))
 			iput_final(inode);
 	}
 }
-- 
1.7.1

