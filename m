Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756550Ab0JUAwP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 20:52:15 -0400
Received: from bld-mail19.adl2.internode.on.net ([150.101.137.104]:38515 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756383Ab0JUAut (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 20:50:49 -0400
From: Dave Chinner <david@fromorbit.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 12/21] fs: remove inode_add_to_list/__inode_add_to_list
Date: Thu, 21 Oct 2010 11:49:37 +1100
Message-Id: <1287622186-1935-13-git-send-email-david@fromorbit.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1287622186-1935-1-git-send-email-david@fromorbit.com>
References: <1287622186-1935-1-git-send-email-david@fromorbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

Split up inode_add_to_list/__inode_add_to_list.  Locking for the two
lists will be split soon so these helpers really don't buy us much
anymore.

The __ prefixes for the sb list helpers will go away soon, but until
inode_lock is gone we'll need them to distinguish between the locked
and unlocked variants.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/inode.c                  |   70 +++++++++++++++++++-----------------------
 fs/xfs/linux-2.6/xfs_iops.c |    4 ++-
 include/linux/fs.h          |    5 ++-
 3 files changed, 38 insertions(+), 41 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index 6b97eb7..301dff5 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -359,6 +359,28 @@ void inode_lru_list_del(struct inode *inode)
 	}
 }
 
+static inline void __inode_sb_list_add(struct inode *inode)
+{
+	list_add(&inode->i_sb_list, &inode->i_sb->s_inodes);
+}
+
+/**
+ * inode_sb_list_add - add inode to the superblock list of inodes
+ * @inode: inode to add
+ */
+void inode_sb_list_add(struct inode *inode)
+{
+	spin_lock(&inode_lock);
+	__inode_sb_list_add(inode);
+	spin_unlock(&inode_lock);
+}
+EXPORT_SYMBOL_GPL(inode_sb_list_add);
+
+static inline void __inode_sb_list_del(struct inode *inode)
+{
+	list_del_init(&inode->i_sb_list);
+}
+
 static unsigned long hash(struct super_block *sb, unsigned long hashval)
 {
 	unsigned long tmp;
@@ -379,9 +401,10 @@ static unsigned long hash(struct super_block *sb, unsigned long hashval)
  */
 void __insert_inode_hash(struct inode *inode, unsigned long hashval)
 {
-	struct hlist_head *head = inode_hashtable + hash(inode->i_sb, hashval);
+	struct hlist_head *b = inode_hashtable + hash(inode->i_sb, hashval);
+
 	spin_lock(&inode_lock);
-	hlist_add_head(&inode->i_hash, head);
+	hlist_add_head(&inode->i_hash, b);
 	spin_unlock(&inode_lock);
 }
 EXPORT_SYMBOL(__insert_inode_hash);
@@ -460,7 +483,7 @@ static void dispose_list(struct list_head *head)
 
 		spin_lock(&inode_lock);
 		__remove_inode_hash(inode);
-		list_del_init(&inode->i_sb_list);
+		__inode_sb_list_del(inode);
 		spin_unlock(&inode_lock);
 
 		wake_up_inode(inode);
@@ -715,37 +738,6 @@ repeat:
 	return NULL;
 }
 
-static inline void
-__inode_add_to_lists(struct super_block *sb, struct hlist_head *head,
-			struct inode *inode)
-{
-	list_add(&inode->i_sb_list, &sb->s_inodes);
-	if (head)
-		hlist_add_head(&inode->i_hash, head);
-}
-
-/**
- * inode_add_to_lists - add a new inode to relevant lists
- * @sb: superblock inode belongs to
- * @inode: inode to mark in use
- *
- * When an inode is allocated it needs to be accounted for, added to the in use
- * list, the owning superblock and the inode hash. This needs to be done under
- * the inode_lock, so export a function to do this rather than the inode lock
- * itself. We calculate the hash list to add to here so it is all internal
- * which requires the caller to have already set up the inode number in the
- * inode to add.
- */
-void inode_add_to_lists(struct super_block *sb, struct inode *inode)
-{
-	struct hlist_head *head = inode_hashtable + hash(sb, inode->i_ino);
-
-	spin_lock(&inode_lock);
-	__inode_add_to_lists(sb, head, inode);
-	spin_unlock(&inode_lock);
-}
-EXPORT_SYMBOL_GPL(inode_add_to_lists);
-
 /**
  *	new_inode 	- obtain an inode
  *	@sb: superblock
@@ -773,7 +765,7 @@ struct inode *new_inode(struct super_block *sb)
 	inode = alloc_inode(sb);
 	if (inode) {
 		spin_lock(&inode_lock);
-		__inode_add_to_lists(sb, NULL, inode);
+		__inode_sb_list_add(inode);
 		inode->i_ino = ++last_ino;
 		inode->i_state = 0;
 		spin_unlock(&inode_lock);
@@ -842,7 +834,8 @@ static struct inode *get_new_inode(struct super_block *sb,
 			if (set(inode, data))
 				goto set_failed;
 
-			__inode_add_to_lists(sb, head, inode);
+			hlist_add_head(&inode->i_hash, head);
+			__inode_sb_list_add(inode);
 			inode->i_state = I_NEW;
 			spin_unlock(&inode_lock);
 
@@ -888,7 +881,8 @@ static struct inode *get_new_inode_fast(struct super_block *sb,
 		old = find_inode_fast(sb, head, ino);
 		if (!old) {
 			inode->i_ino = ino;
-			__inode_add_to_lists(sb, head, inode);
+			hlist_add_head(&inode->i_hash, head);
+			__inode_sb_list_add(inode);
 			inode->i_state = I_NEW;
 			spin_unlock(&inode_lock);
 
@@ -1357,7 +1351,7 @@ static void iput_final(struct inode *inode)
 	 */
 	inode_lru_list_del(inode);
 
-	list_del_init(&inode->i_sb_list);
+	__inode_sb_list_del(inode);
 	spin_unlock(&inode_lock);
 	evict(inode);
 	remove_inode_hash(inode);
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
index c720d65..baf8d32 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2163,7 +2163,6 @@ extern loff_t vfs_llseek(struct file *file, loff_t offset, int origin);
 
 extern int inode_init_always(struct super_block *, struct inode *);
 extern void inode_init_once(struct inode *);
-extern void inode_add_to_lists(struct super_block *, struct inode *);
 extern void iput(struct inode *);
 extern struct inode * igrab(struct inode *);
 extern ino_t iunique(struct super_block *, ino_t);
@@ -2195,9 +2194,11 @@ extern int file_remove_suid(struct file *);
 
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

