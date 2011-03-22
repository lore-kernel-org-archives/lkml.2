Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755455Ab1CVLXt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 07:23:49 -0400
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:23856 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754471Ab1CVLXo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 07:23:44 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApkEAK8jiE15LK5JgWdsb2JhbAClQxUBARYmJcQUhWQEkmc
From: Dave Chinner <david@fromorbit.com>
To: viro@ZenIV.linux.org.uk
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH 4/8] fs: remove inode_lock from iput_final and prune_icache
Date: Tue, 22 Mar 2011 22:23:39 +1100
Message-Id: <1300793023-3775-5-git-send-email-david@fromorbit.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1300793023-3775-1-git-send-email-david@fromorbit.com>
References: <1300793023-3775-1-git-send-email-david@fromorbit.com>
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
 Documentation/filesystems/Locking |    2 +-
 Documentation/filesystems/porting |   16 +++++++++++-----
 Documentation/filesystems/vfs.txt |    2 +-
 fs/inode.c                        |   17 +++--------------
 fs/logfs/inode.c                  |    2 +-
 5 files changed, 17 insertions(+), 22 deletions(-)

diff --git a/Documentation/filesystems/Locking b/Documentation/filesystems/Locking
index 2e994ef..61b31ac 100644
--- a/Documentation/filesystems/Locking
+++ b/Documentation/filesystems/Locking
@@ -128,7 +128,7 @@ alloc_inode:
 destroy_inode:
 dirty_inode:				(must not sleep)
 write_inode:
-drop_inode:				!!!inode_lock!!!
+drop_inode:				!!!inode->i_lock!!!
 evict_inode:
 put_super:		write
 write_super:		read
diff --git a/Documentation/filesystems/porting b/Documentation/filesystems/porting
index 0c986c9..6e29954 100644
--- a/Documentation/filesystems/porting
+++ b/Documentation/filesystems/porting
@@ -298,11 +298,14 @@ be used instead.  It gets called whenever the inode is evicted, whether it has
 remaining links or not.  Caller does *not* evict the pagecache or inode-associated
 metadata buffers; getting rid of those is responsibility of method, as it had
 been for ->delete_inode().
-	->drop_inode() returns int now; it's called on final iput() with inode_lock
-held and it returns true if filesystems wants the inode to be dropped.  As before,
-generic_drop_inode() is still the default and it's been updated appropriately.
-generic_delete_inode() is also alive and it consists simply of return 1.  Note that
-all actual eviction work is done by caller after ->drop_inode() returns.
+
+	->drop_inode() returns int now; it's called on final iput() with
+inode->i_lock held and it returns true if filesystems wants the inode to be
+dropped.  As before, generic_drop_inode() is still the default and it's been
+updated appropriately.  generic_delete_inode() is also alive and it consists
+simply of return 1.  Note that all actual eviction work is done by caller after
+->drop_inode() returns.
+
 	clear_inode() is gone; use end_writeback() instead.  As before, it must
 be called exactly once on each call of ->evict_inode() (as it used to be for
 each call of ->delete_inode()).  Unlike before, if you are using inode-associated
@@ -397,6 +400,9 @@ a file off.
 
 --
 [mandatory]
+
+--
+[mandatory]
 	->get_sb() is gone.  Switch to use of ->mount().  Typically it's just
 a matter of switching from calling get_sb_... to mount_... and changing the
 function type.  If you were doing it manually, just switch from setting ->mnt_root
diff --git a/Documentation/filesystems/vfs.txt b/Documentation/filesystems/vfs.txt
index 306f0ae..80815ed 100644
--- a/Documentation/filesystems/vfs.txt
+++ b/Documentation/filesystems/vfs.txt
@@ -254,7 +254,7 @@ or bottom half).
 	should be synchronous or not, not all filesystems check this flag.
 
   drop_inode: called when the last access to the inode is dropped,
-	with the inode_lock spinlock held.
+	with the inode->i_lock spinlock held.
 
 	This method should be either NULL (normal UNIX filesystem
 	semantics) or "generic_delete_inode" (for filesystems that do not
diff --git a/fs/inode.c b/fs/inode.c
index f6e6e37..5ecd880 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -649,7 +649,6 @@ static void prune_icache(int nr_to_scan)
 	unsigned long reap = 0;
 
 	down_read(&iprune_sem);
-	spin_lock(&inode_lock);
 	spin_lock(&inode_lru_lock);
 	for (nr_scanned = 0; nr_scanned < nr_to_scan; nr_scanned++) {
 		struct inode *inode;
@@ -675,8 +674,8 @@ static void prune_icache(int nr_to_scan)
 		 */
 		if (atomic_read(&inode->i_count) ||
 		    (inode->i_state & ~I_REFERENCED)) {
-			spin_unlock(&inode->i_lock);
 			list_del_init(&inode->i_lru);
+			spin_unlock(&inode->i_lock);
 			inodes_stat.nr_unused--;
 			continue;
 		}
@@ -684,20 +683,18 @@ static void prune_icache(int nr_to_scan)
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
@@ -723,7 +720,6 @@ static void prune_icache(int nr_to_scan)
 	else
 		__count_vm_events(PGINODESTEAL, reap);
 	spin_unlock(&inode_lru_lock);
-	spin_unlock(&inode_lock);
 
 	dispose_list(&freeable);
 	up_read(&iprune_sem);
@@ -1081,7 +1077,6 @@ EXPORT_SYMBOL(iunique);
 
 struct inode *igrab(struct inode *inode)
 {
-	spin_lock(&inode_lock);
 	spin_lock(&inode->i_lock);
 	if (!(inode->i_state & (I_FREEING|I_WILL_FREE))) {
 		__iget(inode);
@@ -1095,7 +1090,6 @@ struct inode *igrab(struct inode *inode)
 		 */
 		inode = NULL;
 	}
-	spin_unlock(&inode_lock);
 	return inode;
 }
 EXPORT_SYMBOL(igrab);
@@ -1438,7 +1432,6 @@ static void iput_final(struct inode *inode)
 	const struct super_operations *op = inode->i_sb->s_op;
 	int drop;
 
-	spin_lock(&inode->i_lock);
 	WARN_ON(inode->i_state & I_NEW);
 
 	if (op && op->drop_inode)
@@ -1451,16 +1444,13 @@ static void iput_final(struct inode *inode)
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
@@ -1469,7 +1459,6 @@ static void iput_final(struct inode *inode)
 	inode->i_state |= I_FREEING;
 	inode_lru_list_del(inode);
 	spin_unlock(&inode->i_lock);
-	spin_unlock(&inode_lock);
 
 	evict(inode);
 }
@@ -1488,7 +1477,7 @@ void iput(struct inode *inode)
 	if (inode) {
 		BUG_ON(inode->i_state & I_CLEAR);
 
-		if (atomic_dec_and_lock(&inode->i_count, &inode_lock))
+		if (atomic_dec_and_lock(&inode->i_count, &inode->i_lock))
 			iput_final(inode);
 	}
 }
diff --git a/fs/logfs/inode.c b/fs/logfs/inode.c
index 03b8c24..edfea7a 100644
--- a/fs/logfs/inode.c
+++ b/fs/logfs/inode.c
@@ -293,7 +293,7 @@ static int logfs_write_inode(struct inode *inode, struct writeback_control *wbc)
 	return ret;
 }
 
-/* called with inode_lock held */
+/* called with inode->i_lock held */
 static int logfs_drop_inode(struct inode *inode)
 {
 	struct logfs_super *super = logfs_super(inode->i_sb);
-- 
1.7.2.3

