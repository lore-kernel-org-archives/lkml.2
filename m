Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753558Ab0JHFY3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 01:24:29 -0400
Received: from bld-mail14.adl6.internode.on.net ([150.101.137.99]:47883 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752714Ab0JHFWP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 01:22:15 -0400
From: Dave Chinner <david@fromorbit.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 09/18] fs: rework icount to be a locked variable
Date: Fri,  8 Oct 2010 16:21:23 +1100
Message-Id: <1286515292-15882-10-git-send-email-david@fromorbit.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1286515292-15882-1-git-send-email-david@fromorbit.com>
References: <1286515292-15882-1-git-send-email-david@fromorbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

The inode reference count is currently an atomic variable so that it can be
sampled/modified outside the inode_lock. However, the inode_lock is still
needed to synchronise the final reference count and checks against the inode
state.

To avoid needing the protection of the inode lock, protect the inode reference
count with the per-inode i_lock and convert it to a normal variable. To avoid
existing out-of-tree code accidentally compiling against the new method, rename
the i_count field to i_ref. This is relatively straight forward as there
are limited external references to the i_count field remaining.

Based on work originally from Nick Piggin.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/btrfs/inode.c       |    8 ++++-
 fs/inode.c             |   83 ++++++++++++++++++++++++++++++++++++-----------
 fs/nfs/nfs4state.c     |    2 +-
 fs/nilfs2/mdt.c        |    2 +-
 fs/notify/inode_mark.c |   16 ++++++---
 include/linux/fs.h     |    2 +-
 6 files changed, 84 insertions(+), 29 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 2953e9f..9f04478 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1964,8 +1964,14 @@ void btrfs_add_delayed_iput(struct inode *inode)
 	struct btrfs_fs_info *fs_info = BTRFS_I(inode)->root->fs_info;
 	struct delayed_iput *delayed;
 
-	if (atomic_add_unless(&inode->i_count, -1, 1))
+	/* XXX: filesystems should not play refcount games like this */
+	spin_lock(&inode->i_lock);
+	if (inode->i_ref > 1) {
+		inode->i_ref--;
+		spin_unlock(&inode->i_lock);
 		return;
+	}
+	spin_unlock(&inode->i_lock);
 
 	delayed = kmalloc(sizeof(*delayed), GFP_NOFS | __GFP_NOFAIL);
 	delayed->inode = inode;
diff --git a/fs/inode.c b/fs/inode.c
index b1dc6dc..5c8a3ea 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -26,6 +26,13 @@
 #include <linux/posix_acl.h>
 
 /*
+ * Locking rules.
+ *
+ * inode->i_lock protects:
+ *   i_ref
+ */
+
+/*
  * This is needed for the following functions:
  *  - inode_has_buffers
  *  - invalidate_inode_buffers
@@ -64,9 +71,9 @@ static unsigned int i_hash_shift __read_mostly;
  * Each inode can be on two separate lists. One is
  * the hash list of the inode, used for lookups. The
  * other linked list is the "type" list:
- *  "in_use" - valid inode, i_count > 0, i_nlink > 0
+ *  "in_use" - valid inode, i_ref > 0, i_nlink > 0
  *  "dirty"  - as "in_use" but also dirty
- *  "unused" - valid inode, i_count = 0
+ *  "unused" - valid inode, i_ref = 0
  *
  * A "dirty" list is maintained for each super block,
  * allowing for low-overhead inode sync() operations.
@@ -164,7 +171,7 @@ int inode_init_always(struct super_block *sb, struct inode *inode)
 	inode->i_sb = sb;
 	inode->i_blkbits = sb->s_blocksize_bits;
 	inode->i_flags = 0;
-	atomic_set(&inode->i_count, 1);
+	inode->i_ref = 1;
 	inode->i_op = &empty_iops;
 	inode->i_fop = &empty_fops;
 	inode->i_nlink = 1;
@@ -313,31 +320,38 @@ static void init_once(void *foo)
 
 	inode_init_once(inode);
 }
+
+/*
+ * inode_lock must be held
+ */
+void iref_locked(struct inode *inode)
+{
+	inode->i_ref++;
+}
 EXPORT_SYMBOL_GPL(iref_locked);
 
 void iref(struct inode *inode)
 {
 	spin_lock(&inode_lock);
+	spin_lock(&inode->i_lock);
 	iref_locked(inode);
+	spin_unlock(&inode->i_lock);
 	spin_unlock(&inode_lock);
 }
 EXPORT_SYMBOL_GPL(iref);
 
 /*
- * inode_lock must be held
- */
-void iref_locked(struct inode *inode)
-{
-	atomic_inc(&inode->i_count);
-}
-
-/*
  * Nobody outside of core code should really be looking at the inode reference
  * count. Please don't add new users of this function.
  */
 int iref_read(struct inode *inode)
 {
-	return atomic_read(&inode->i_count);
+	int ref;
+
+	spin_lock(&inode->i_lock);
+	ref = inode->i_ref;
+	spin_unlock(&inode->i_lock);
+	return ref;
 }
 EXPORT_SYMBOL_GPL(iref_read);
 
@@ -425,7 +439,9 @@ static int invalidate_list(struct list_head *head, struct list_head *dispose)
 		if (inode->i_state & I_NEW)
 			continue;
 		invalidate_inode_buffers(inode);
-		if (!atomic_read(&inode->i_count)) {
+		spin_lock(&inode->i_lock);
+		if (!inode->i_ref) {
+			spin_unlock(&inode->i_lock);
 			list_move(&inode->i_lru, dispose);
 			list_del_init(&inode->i_io);
 			WARN_ON(inode->i_state & I_NEW);
@@ -433,6 +449,7 @@ static int invalidate_list(struct list_head *head, struct list_head *dispose)
 			percpu_counter_dec(&nr_inodes_unused);
 			continue;
 		}
+		spin_unlock(&inode->i_lock);
 		busy = 1;
 	}
 	return busy;
@@ -470,7 +487,7 @@ static int can_unuse(struct inode *inode)
 		return 0;
 	if (inode_has_buffers(inode))
 		return 0;
-	if (atomic_read(&inode->i_count))
+	if (iref_read(inode))
 		return 0;
 	if (inode->i_data.nrpages)
 		return 0;
@@ -506,19 +523,22 @@ static void prune_icache(int nr_to_scan)
 
 		inode = list_entry(inode_unused.prev, struct inode, i_lru);
 
-		if (atomic_read(&inode->i_count) ||
-		    (inode->i_state & ~I_REFERENCED)) {
+		spin_lock(&inode->i_lock);
+		if (inode->i_ref || (inode->i_state & ~I_REFERENCED)) {
+			spin_unlock(&inode->i_lock);
 			list_del_init(&inode->i_lru);
 			percpu_counter_dec(&nr_inodes_unused);
 			continue;
 		}
 		if (inode->i_state & I_REFERENCED) {
+			spin_unlock(&inode->i_lock);
 			list_move(&inode->i_lru, &inode_unused);
 			inode->i_state &= ~I_REFERENCED;
 			continue;
 		}
 		if (inode_has_buffers(inode) || inode->i_data.nrpages) {
 			iref_locked(inode);
+			spin_unlock(&inode->i_lock);
 			spin_unlock(&inode_lock);
 			if (remove_inode_buffers(inode))
 				reap += invalidate_mapping_pages(&inode->i_data,
@@ -535,7 +555,8 @@ static void prune_icache(int nr_to_scan)
 				list_move(&inode->i_lru, &inode_unused);
 				continue;
 			}
-		}
+		} else
+			spin_unlock(&inode->i_lock);
 		list_move(&inode->i_lru, &freeable);
 		list_del_init(&inode->i_io);
 		WARN_ON(inode->i_state & I_NEW);
@@ -788,7 +809,9 @@ static struct inode *get_new_inode(struct super_block *sb,
 		 * us. Use the old inode instead of the one we just
 		 * allocated.
 		 */
+		spin_lock(&old->i_lock);
 		iref_locked(old);
+		spin_unlock(&old->i_lock);
 		spin_unlock(&inode_lock);
 		destroy_inode(inode);
 		inode = old;
@@ -835,7 +858,9 @@ static struct inode *get_new_inode_fast(struct super_block *sb,
 		 * us. Use the old inode instead of the one we just
 		 * allocated.
 		 */
+		spin_lock(&old->i_lock);
 		iref_locked(old);
+		spin_unlock(&old->i_lock);
 		spin_unlock(&inode_lock);
 		destroy_inode(inode);
 		inode = old;
@@ -887,9 +912,11 @@ EXPORT_SYMBOL(iunique);
 struct inode *igrab(struct inode *inode)
 {
 	spin_lock(&inode_lock);
-	if (!(inode->i_state & (I_FREEING|I_WILL_FREE)))
+	if (!(inode->i_state & (I_FREEING|I_WILL_FREE))) {
+		spin_lock(&inode->i_lock);
 		iref_locked(inode);
-	else
+		spin_unlock(&inode->i_lock);
+	} else
 		/*
 		 * Handle the case where s_op->clear_inode is not been
 		 * called yet, and somebody is calling igrab
@@ -929,7 +956,9 @@ static struct inode *ifind(struct super_block *sb,
 	spin_lock(&inode_lock);
 	inode = find_inode(sb, head, test, data);
 	if (inode) {
+		spin_lock(&inode->i_lock);
 		iref_locked(inode);
+		spin_unlock(&inode->i_lock);
 		spin_unlock(&inode_lock);
 		if (likely(wait))
 			wait_on_inode(inode);
@@ -962,7 +991,9 @@ static struct inode *ifind_fast(struct super_block *sb,
 	spin_lock(&inode_lock);
 	inode = find_inode_fast(sb, head, ino);
 	if (inode) {
+		spin_lock(&inode->i_lock);
 		iref_locked(inode);
+		spin_unlock(&inode->i_lock);
 		spin_unlock(&inode_lock);
 		wait_on_inode(inode);
 		return inode;
@@ -1145,7 +1176,9 @@ int insert_inode_locked(struct inode *inode)
 			spin_unlock(&inode_lock);
 			return 0;
 		}
+		spin_lock(&old->i_lock);
 		iref_locked(old);
+		spin_unlock(&old->i_lock);
 		spin_unlock(&inode_lock);
 		wait_on_inode(old);
 		if (unlikely(!hlist_unhashed(&old->i_hash))) {
@@ -1184,7 +1217,9 @@ int insert_inode_locked4(struct inode *inode, unsigned long hashval,
 			spin_unlock(&inode_lock);
 			return 0;
 		}
+		spin_lock(&old->i_lock);
 		iref_locked(old);
+		spin_unlock(&old->i_lock);
 		spin_unlock(&inode_lock);
 		wait_on_inode(old);
 		if (unlikely(!hlist_unhashed(&old->i_hash))) {
@@ -1324,8 +1359,16 @@ void iput(struct inode *inode)
 	if (inode) {
 		BUG_ON(inode->i_state & I_CLEAR);
 
-		if (atomic_dec_and_lock(&inode->i_count, &inode_lock))
+		spin_lock(&inode_lock);
+		spin_lock(&inode->i_lock);
+		inode->i_ref--;
+		if (inode->i_ref == 0) {
+			spin_unlock(&inode->i_lock);
 			iput_final(inode);
+			return;
+		}
+		spin_unlock(&inode->i_lock);
+		spin_lock(&inode_lock);
 	}
 }
 EXPORT_SYMBOL(iput);
diff --git a/fs/nfs/nfs4state.c b/fs/nfs/nfs4state.c
index 3e2f19b..d7fc5d0 100644
--- a/fs/nfs/nfs4state.c
+++ b/fs/nfs/nfs4state.c
@@ -506,8 +506,8 @@ nfs4_get_open_state(struct inode *inode, struct nfs4_state_owner *owner)
 		state->owner = owner;
 		atomic_inc(&owner->so_count);
 		list_add(&state->inode_states, &nfsi->open_states);
-		state->inode = igrab(inode);
 		spin_unlock(&inode->i_lock);
+		state->inode = igrab(inode);
 		/* Note: The reclaim code dictates that we add stateless
 		 * and read-only stateids to the end of the list */
 		list_add_tail(&state->open_states, &owner->so_states);
diff --git a/fs/nilfs2/mdt.c b/fs/nilfs2/mdt.c
index 2ee524f..435ba11 100644
--- a/fs/nilfs2/mdt.c
+++ b/fs/nilfs2/mdt.c
@@ -480,7 +480,7 @@ nilfs_mdt_new_common(struct the_nilfs *nilfs, struct super_block *sb,
 		inode->i_sb = sb; /* sb may be NULL for some meta data files */
 		inode->i_blkbits = nilfs->ns_blocksize_bits;
 		inode->i_flags = 0;
-		atomic_set(&inode->i_count, 1);
+		inode->i_ref = 1;
 		inode->i_nlink = 1;
 		inode->i_ino = ino;
 		inode->i_mode = S_IFREG;
diff --git a/fs/notify/inode_mark.c b/fs/notify/inode_mark.c
index 6c54e02..2fe319b 100644
--- a/fs/notify/inode_mark.c
+++ b/fs/notify/inode_mark.c
@@ -257,7 +257,8 @@ void fsnotify_unmount_inodes(struct list_head *list)
 		 * actually evict all unreferenced inodes from icache which is
 		 * unnecessarily violent and may in fact be illegal to do.
 		 */
-		if (!iref_read(inode))
+		spin_lock(&inode->i_lock);
+		if (!inode->i_ref)
 			continue;
 
 		need_iput_tmp = need_iput;
@@ -268,12 +269,17 @@ void fsnotify_unmount_inodes(struct list_head *list)
 			iref_locked(inode);
 		else
 			need_iput_tmp = NULL;
+		spin_unlock(&inode->i_lock);
 
 		/* In case the dropping of a reference would nuke next_i. */
-		if ((&next_i->i_sb_list != list) && iref_read(inode) &&
-		    !(next_i->i_state & (I_FREEING | I_WILL_FREE))) {
-			iref_locked(next_i);
-			need_iput = next_i;
+		if (&next_i->i_sb_list != list) {
+			spin_lock(&next_i->i_lock);
+			if (inode->i_ref &&
+			    !(next_i->i_state & (I_FREEING | I_WILL_FREE))) {
+				iref_locked(next_i);
+				need_iput = next_i;
+			}
+			spin_unlock(&next_i->i_lock);
 		}
 
 		/*
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 6f0df2a..1162c10 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -730,7 +730,7 @@ struct inode {
 	struct list_head	i_sb_list;
 	struct list_head	i_dentry;
 	unsigned long		i_ino;
-	atomic_t		i_count;
+	unsigned int		i_ref;
 	unsigned int		i_nlink;
 	uid_t			i_uid;
 	gid_t			i_gid;
-- 
1.7.1

