Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753803Ab0JPIQn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 04:16:43 -0400
Received: from bld-mail15.adl6.internode.on.net ([150.101.137.100]:50233 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753437Ab0JPIPL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 04:15:11 -0400
From: Dave Chinner <david@fromorbit.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 18/19] fs: split __inode_add_to_list
Date: Sat, 16 Oct 2010 19:14:12 +1100
Message-Id: <1287216853-17634-19-git-send-email-david@fromorbit.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1287216853-17634-1-git-send-email-david@fromorbit.com>
References: <1287216853-17634-1-git-send-email-david@fromorbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

__inode_add_to_list does two things that aren't related.  First it adds
the inode to the s_inodes list in the superblock, and second it optionally
adds the inode to the inode hash.  Now that these don't even share the
same lock there is no need to keeps this functionally together.  Split
out an add_to_inode_hash helper from __insert_inode_hash to add an inode
to a pre-calculated hash bucket for use by the various iget version, and
a inode_sb_list_add helper from __inode_add_to_list to just add an
inode to the per-sb list.  The inode.c-internal callers of
__inode_add_to_list are converted to a sequence of inode_sb_list_add
and __insert_inode_hash (if needed), and the only use of inode_add_to_list
in XFS is replaced with a call to inode_sb_list_add and insert_inode_hash.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/inode.c                  |   91 +++++++++++++++++++------------------------
 fs/xfs/linux-2.6/xfs_iops.c |    4 +-
 include/linux/fs.h          |    5 +-
 3 files changed, 46 insertions(+), 54 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index bea1657..3bd45fb 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -384,6 +384,29 @@ void inode_lru_list_del(struct inode *inode)
 	spin_unlock(&inode_lru_lock);
 }
 
+/**
+ * inode_sb_list_add - add inode to the superblock list of inodes
+ * @inode: inode to add
+ */
+void inode_sb_list_add(struct inode *inode)
+{
+	struct super_block *sb = inode->i_sb;
+
+	spin_lock(&sb->s_inodes_lock);
+	list_add(&inode->i_sb_list, &sb->s_inodes);
+	spin_unlock(&sb->s_inodes_lock);
+}
+EXPORT_SYMBOL_GPL(inode_sb_list_add);
+
+static void inode_sb_list_del(struct inode *inode)
+{
+	struct super_block *sb = inode->i_sb;
+
+	spin_lock(&sb->s_inodes_lock);
+	list_del_init(&inode->i_sb_list);
+	spin_unlock(&sb->s_inodes_lock);
+}
+
 static unsigned long hash(struct super_block *sb, unsigned long hashval)
 {
 	unsigned long tmp;
@@ -394,6 +417,13 @@ static unsigned long hash(struct super_block *sb, unsigned long hashval)
 	return tmp & I_HASHMASK;
 }
 
+static void inode_hash_list_add(struct hlist_bl_head *b, struct inode *inode)
+{
+	hlist_bl_lock(b);
+	hlist_bl_add_head(&inode->i_hash, b);
+	hlist_bl_unlock(b);
+}
+
 /**
  *	__insert_inode_hash - hash an inode
  *	@inode: unhashed inode
@@ -407,9 +437,7 @@ void __insert_inode_hash(struct inode *inode, unsigned long hashval)
 	struct hlist_bl_head *b;
 
 	b = inode_hashtable + hash(inode->i_sb, hashval);
-	hlist_bl_lock(b);
-	hlist_bl_add_head(&inode->i_hash, b);
-	hlist_bl_unlock(b);
+	inode_hash_list_add(b, inode);
 }
 EXPORT_SYMBOL(__insert_inode_hash);
 
@@ -468,28 +496,21 @@ static void evict(struct inode *inode)
  *
  * An inode must already be marked I_FREEING so that we avoid the inode being
  * moved back onto lists if we race with other code that manipulates the lists
- * (e.g. writeback_single_inode). The caller
+ * (e.g. writeback_single_inode). I_FREEING will prevent the other threads from
+ * manipulting the lists.
  */
 static void dispose_one_inode(struct inode *inode)
 {
 	BUG_ON(!(inode->i_state & I_FREEING));
 
-	/*
-	 * move the inode off the IO lists and LRU once
-	 * I_FREEING is set so that it won't get moved back on
-	 * there if it is dirty.
-	 */
 	if (!list_empty(&inode->i_wb_list))
 		inode_wb_list_del(inode);
 
 	if (!list_empty(&inode->i_lru))
 		inode_lru_list_del(inode);
 
-	if (!list_empty(&inode->i_sb_list)) {
-		spin_lock(&inode->i_sb->s_inodes_lock);
-		list_del_init(&inode->i_sb_list);
-		spin_unlock(&inode->i_sb->s_inodes_lock);
-	}
+	if (!list_empty(&inode->i_sb_list))
+		inode_sb_list_del(inode);
 
 	evict(inode);
 
@@ -796,40 +817,6 @@ repeat:
 	return node ? inode : NULL;
 }
 
-static inline void
-__inode_add_to_lists(struct super_block *sb, struct hlist_bl_head *b,
-			struct inode *inode)
-{
-	spin_lock(&sb->s_inodes_lock);
-	list_add(&inode->i_sb_list, &sb->s_inodes);
-	spin_unlock(&sb->s_inodes_lock);
-	if (b) {
-		hlist_bl_lock(b);
-		hlist_bl_add_head(&inode->i_hash, b);
-		hlist_bl_unlock(b);
-	}
-}
-
-/**
- * inode_add_to_lists - add a new inode to relevant lists
- * @sb: superblock inode belongs to
- * @inode: inode to mark in use
- *
- * When an inode is allocated it needs to be accounted for, added to the in use
- * list, the owning superblock and the inode hash.
- *
- * We calculate the hash list to add to here so it is all internal
- * which requires the caller to have already set up the inode number in the
- * inode to add.
- */
-void inode_add_to_lists(struct super_block *sb, struct inode *inode)
-{
-	struct hlist_bl_head *b = inode_hashtable + hash(sb, inode->i_ino);
-
-	__inode_add_to_lists(sb, b, inode);
-}
-EXPORT_SYMBOL_GPL(inode_add_to_lists);
-
 /*
  * Each cpu owns a range of LAST_INO_BATCH numbers.
  * 'shared_last_ino' is dirtied only once out of LAST_INO_BATCH allocations,
@@ -891,7 +878,7 @@ struct inode *new_inode(struct super_block *sb)
 		 */
 		inode->i_ino = get_next_ino();
 		inode->i_state = 0;
-		__inode_add_to_lists(sb, NULL, inode);
+		inode_sb_list_add(inode);
 	}
 	return inode;
 }
@@ -961,7 +948,8 @@ static struct inode *get_new_inode(struct super_block *sb,
 			 * visible to the outside world.
 			 */
 			inode->i_state = I_NEW;
-			__inode_add_to_lists(sb, b, inode);
+			inode_sb_list_add(inode);
+			inode_hash_list_add(b, inode);
 
 			/* Return the locked inode with I_NEW set, the
 			 * caller is responsible for filling in the contents
@@ -1009,7 +997,8 @@ static struct inode *get_new_inode_fast(struct super_block *sb,
 			 */
 			inode->i_ino = ino;
 			inode->i_state = I_NEW;
-			__inode_add_to_lists(sb, b, inode);
+			inode_sb_list_add(inode);
+			inode_hash_list_add(b, inode);
 
 			/* Return the locked inode with I_NEW set, the
 			 * caller is responsible for filling in the contents
diff --git a/fs/xfs/linux-2.6/xfs_iops.c b/fs/xfs/linux-2.6/xfs_iops.c
index b7ec465..3c7cea3 100644
--- a/fs/xfs/linux-2.6/xfs_iops.c
+++ b/fs/xfs/linux-2.6/xfs_iops.c
@@ -795,7 +795,9 @@ xfs_setup_inode(
 
 	inode->i_ino = ip->i_ino;
 	inode->i_state = I_NEW;
-	inode_add_to_lists(ip->i_mount->m_super, inode);
+
+	inode_sb_list_add(inode);
+	insert_inode_hash(inode);
 
 	inode->i_mode	= ip->i_d.di_mode;
 	inode->i_nlink	= ip->i_d.di_nlink;
diff --git a/include/linux/fs.h b/include/linux/fs.h
index da15124..abdb756 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2170,7 +2170,6 @@ extern loff_t vfs_llseek(struct file *file, loff_t offset, int origin);
 
 extern int inode_init_always(struct super_block *, struct inode *);
 extern void inode_init_once(struct inode *);
-extern void inode_add_to_lists(struct super_block *, struct inode *);
 extern void iput(struct inode *);
 extern struct inode * igrab(struct inode *);
 extern ino_t iunique(struct super_block *, ino_t);
@@ -2202,9 +2201,11 @@ extern int file_remove_suid(struct file *);
 
 extern void __insert_inode_hash(struct inode *, unsigned long hashval);
 extern void remove_inode_hash(struct inode *);
-static inline void insert_inode_hash(struct inode *inode) {
+static inline void insert_inode_hash(struct inode *inode)
+{
 	__insert_inode_hash(inode, inode->i_ino);
 }
+extern void inode_sb_list_add(struct inode *inode);
 
 #ifdef CONFIG_BLOCK
 extern void submit_bio(int, struct bio *);
-- 
1.7.1

