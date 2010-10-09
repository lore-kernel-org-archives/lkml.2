Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756239Ab0JIIJA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Oct 2010 04:09:00 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:44994 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753285Ab0JIII5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Oct 2010 04:08:57 -0400
Date: Sat, 9 Oct 2010 04:08:54 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 19/18] fs: split __inode_add_to_list
Message-ID: <20101009080854.GA15943@infradead.org>
References: <1286515292-15882-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1286515292-15882-1-git-send-email-david@fromorbit.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__inode_add_to_list does two things that aren't related.  First it adds
the inode to the s_inodes list in the superblock, and second it optionally
adds the inode to the inode hash.  Now that these don't even share the
same lock there is no need to keeps this functionally together.  Split
out an add_to_inode_hash helper from __insert_inode_hash to add an inode
to a pre-calculated hash bucket for use by the various iget version, and
a inode_add_to_sb_list helper from __inode_add_to_list to just add an
inode to the per-sb list.  The inode.c-internal callers of
__inode_add_to_list are converted to a sequence of inode_add_to_sb_list
and __insert_inode_hash (if needed), and the only use of inode_add_to_list
in XFS is replaced with a call to inode_add_to_sb_list and insert_inode_hash.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/fs/inode.c
===================================================================
--- linux-2.6.orig/fs/inode.c	2010-10-08 19:53:56.287013554 +0200
+++ linux-2.6/fs/inode.c	2010-10-08 19:54:50.717254091 +0200
@@ -423,6 +423,13 @@ static unsigned long hash(struct super_b
 	return tmp & I_HASHMASK;
 }
 
+static void add_to_inode_hash(struct inode_hash_bucket *b, struct inode *inode)
+{
+	spin_lock_bucket(b);
+	hlist_bl_add_head(&inode->i_hash, &b->head);
+	spin_unlock_bucket(b);
+}
+
 /**
  *	__insert_inode_hash - hash an inode
  *	@inode: unhashed inode
@@ -433,12 +440,7 @@ static unsigned long hash(struct super_b
  */
 void __insert_inode_hash(struct inode *inode, unsigned long hashval)
 {
-	struct inode_hash_bucket *b;
-
-	b = inode_hashtable + hash(inode->i_sb, hashval);
-	spin_lock_bucket(b);
-	hlist_bl_add_head(&inode->i_hash, &b->head);
-	spin_unlock_bucket(b);
+	add_to_inode_hash(inode_hashtable + hash(inode->i_sb, hashval), inode);
 }
 EXPORT_SYMBOL(__insert_inode_hash);
 
@@ -805,39 +807,19 @@ repeat:
 	return node ? inode : NULL;
 }
 
-static inline void
-__inode_add_to_lists(struct super_block *sb, struct inode_hash_bucket *b,
-			struct inode *inode)
-{
-	spin_lock(&sb->s_inodes_lock);
-	list_add(&inode->i_sb_list, &sb->s_inodes);
-	spin_unlock(&sb->s_inodes_lock);
-	if (b) {
-		spin_lock_bucket(b);
-		hlist_bl_add_head(&inode->i_hash, &b->head);
-		spin_unlock_bucket(b);
-	}
-}
-
 /**
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
+ * inode_add_to_sb_list - add inode to the superblock list of inodes
+ * @inode: inode to add
  */
-void inode_add_to_lists(struct super_block *sb, struct inode *inode)
+void inode_add_to_sb_list(struct inode *inode)
 {
-	struct inode_hash_bucket *b = inode_hashtable + hash(sb, inode->i_ino);
+	struct super_block *sb = inode->i_sb;
 
-	__inode_add_to_lists(sb, b, inode);
+	spin_lock(&sb->s_inodes_lock);
+	list_add(&inode->i_sb_list, &sb->s_inodes);
+	spin_unlock(&sb->s_inodes_lock);
 }
-EXPORT_SYMBOL_GPL(inode_add_to_lists);
+EXPORT_SYMBOL_GPL(inode_add_to_sb_list);
 
 /*
  * Each cpu owns a range of LAST_INO_BATCH numbers.
@@ -896,7 +878,7 @@ struct inode *new_inode(struct super_blo
 	if (inode) {
 		inode->i_ino = last_ino_get();
 		inode->i_state = 0;
-		__inode_add_to_lists(sb, NULL, inode);
+		inode_add_to_sb_list(inode);
 	}
 	return inode;
 }
@@ -962,7 +944,8 @@ static struct inode *get_new_inode(struc
 				goto set_failed;
 
 			inode->i_state = I_NEW;
-			__inode_add_to_lists(sb, b, inode);
+			inode_add_to_sb_list(inode);
+			add_to_inode_hash(b, inode);
 
 			/* Return the locked inode with I_NEW set, the
 			 * caller is responsible for filling in the contents
@@ -1005,7 +988,8 @@ static struct inode *get_new_inode_fast(
 		old = find_inode_fast(sb, b, ino);
 		if (!old) {
 			inode->i_ino = ino;
-			__inode_add_to_lists(sb, b, inode);
+			inode_add_to_sb_list(inode);
+			add_to_inode_hash(b, inode);
 			inode->i_state = I_NEW;
 
 			/* Return the locked inode with I_NEW set, the
Index: linux-2.6/fs/xfs/linux-2.6/xfs_iops.c
===================================================================
--- linux-2.6.orig/fs/xfs/linux-2.6/xfs_iops.c	2010-10-08 19:53:56.299004405 +0200
+++ linux-2.6/fs/xfs/linux-2.6/xfs_iops.c	2010-10-08 19:54:31.258003987 +0200
@@ -795,7 +795,9 @@ xfs_setup_inode(
 
 	inode->i_ino = ip->i_ino;
 	inode->i_state = I_NEW;
-	inode_add_to_lists(ip->i_mount->m_super, inode);
+
+	inode_add_to_sb_list(inode);
+	insert_inode_hash(inode);
 
 	inode->i_mode	= ip->i_d.di_mode;
 	inode->i_nlink	= ip->i_d.di_nlink;
Index: linux-2.6/include/linux/fs.h
===================================================================
--- linux-2.6.orig/include/linux/fs.h	2010-10-08 19:53:56.310012018 +0200
+++ linux-2.6/include/linux/fs.h	2010-10-08 19:54:50.871004265 +0200
@@ -2165,7 +2165,6 @@ extern loff_t vfs_llseek(struct file *fi
 
 extern int inode_init_always(struct super_block *, struct inode *);
 extern void inode_init_once(struct inode *);
-extern void inode_add_to_lists(struct super_block *, struct inode *);
 extern void iput(struct inode *);
 extern struct inode * igrab(struct inode *);
 extern ino_t iunique(struct super_block *, ino_t);
@@ -2199,9 +2198,11 @@ extern int file_remove_suid(struct file
 
 extern void __insert_inode_hash(struct inode *, unsigned long hashval);
 extern void remove_inode_hash(struct inode *);
-static inline void insert_inode_hash(struct inode *inode) {
+static inline void insert_inode_hash(struct inode *inode)
+{
 	__insert_inode_hash(inode, inode->i_ino);
 }
+extern void inode_add_to_sb_list(struct inode *inode);
 
 #ifdef CONFIG_BLOCK
 extern void submit_bio(int, struct bio *);
