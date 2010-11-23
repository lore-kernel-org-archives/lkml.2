Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754724Ab0KWOMa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 09:12:30 -0500
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:2581 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754388Ab0KWOLx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 09:11:53 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AsoJAMpZ60x5LdQd/2dsb2JhbACVY40Acr1HhUsEil4
Message-Id: <20101123140708.058372884@kernel.dk>
User-Agent: quilt/0.48-1
Date: Wed, 24 Nov 2010 01:06:16 +1100
From: npiggin@kernel.dk
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [patch 6/7] fs: fsync optimisations
References: <20101123140610.292941494@kernel.dk>
Content-Disposition: inline; filename=fs-datasync-opt.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Optimise fsync by adding a datasync parameter to sync_inode_metadata to
DTRT with writing back the inode (->write_inode in theory should have a
datasync parameter too perhaps, but that's for another time).

Also, implement the metadata sync optimally rather than reusing the
normal data writeback path. This means less useless moving the inode around the
writeback lists, and less dropping and retaking of inode_lock, and avoiding
the data writeback call with nr_pages == 0.

Signed-off-by: Nick Piggin <npiggin@kernel.dk>

Index: linux-2.6/drivers/staging/pohmelfs/inode.c
===================================================================
--- linux-2.6.orig/drivers/staging/pohmelfs/inode.c	2010-11-23 22:56:51.000000000 +1100
+++ linux-2.6/drivers/staging/pohmelfs/inode.c	2010-11-23 22:57:45.000000000 +1100
@@ -883,7 +883,7 @@ static int pohmelfs_fsync(struct file *f
 {
 	struct inode *inode = file->f_mapping->host;
 
-	return sync_inode_metadata(inode, 1);
+	return sync_inode_metadata(inode, datasync, 1);
 }
 
 ssize_t pohmelfs_write(struct file *file, const char __user *buf,
Index: linux-2.6/fs/exofs/file.c
===================================================================
--- linux-2.6.orig/fs/exofs/file.c	2010-11-23 22:56:51.000000000 +1100
+++ linux-2.6/fs/exofs/file.c	2010-11-23 22:57:45.000000000 +1100
@@ -48,7 +48,7 @@ static int exofs_file_fsync(struct file
 	struct inode *inode = filp->f_mapping->host;
 	struct super_block *sb;
 
-	ret = sync_inode_metadata(inode, 1);
+	ret = sync_inode_metadata(inode, datasync, 1);
 
 	/* This is a good place to write the sb */
 	/* TODO: Sechedule an sb-sync on create */
Index: linux-2.6/fs/ext2/dir.c
===================================================================
--- linux-2.6.orig/fs/ext2/dir.c	2010-11-23 22:56:51.000000000 +1100
+++ linux-2.6/fs/ext2/dir.c	2010-11-23 22:57:45.000000000 +1100
@@ -98,7 +98,7 @@ static int ext2_commit_chunk(struct page
 	if (IS_DIRSYNC(dir)) {
 		err = write_one_page(page, 1);
 		if (!err)
-			err = sync_inode_metadata(dir, 1);
+			err = sync_inode_metadata(dir, 0, 1);
 	} else {
 		unlock_page(page);
 	}
Index: linux-2.6/fs/ext2/inode.c
===================================================================
--- linux-2.6.orig/fs/ext2/inode.c	2010-11-23 22:57:43.000000000 +1100
+++ linux-2.6/fs/ext2/inode.c	2010-11-23 22:57:45.000000000 +1100
@@ -1203,7 +1203,7 @@ static int ext2_setsize(struct inode *in
 	inode->i_mtime = inode->i_ctime = CURRENT_TIME_SEC;
 	if (inode_needs_sync(inode)) {
 		sync_mapping_buffers(inode->i_mapping);
-		sync_inode_metadata(inode, 1);
+		sync_inode_metadata(inode, 0, 1);
 	} else {
 		mark_inode_dirty(inode);
 	}
Index: linux-2.6/fs/ext2/xattr.c
===================================================================
--- linux-2.6.orig/fs/ext2/xattr.c	2010-11-23 22:56:51.000000000 +1100
+++ linux-2.6/fs/ext2/xattr.c	2010-11-23 22:57:45.000000000 +1100
@@ -699,7 +699,7 @@ ext2_xattr_set2(struct inode *inode, str
 	EXT2_I(inode)->i_file_acl = new_bh ? new_bh->b_blocknr : 0;
 	inode->i_ctime = CURRENT_TIME_SEC;
 	if (IS_SYNC(inode)) {
-		error = sync_inode_metadata(inode, 1);
+		error = sync_inode_metadata(inode, 0, 1);
 		/* In case sync failed due to ENOSPC the inode was actually
 		 * written (only some dirty data were not) so we just proceed
 		 * as if nothing happened and cleanup the unused block */
Index: linux-2.6/fs/fs-writeback.c
===================================================================
--- linux-2.6.orig/fs/fs-writeback.c	2010-11-23 22:57:40.000000000 +1100
+++ linux-2.6/fs/fs-writeback.c	2010-11-23 22:59:41.000000000 +1100
@@ -1307,7 +1307,7 @@ int sync_inode(struct inode *inode, stru
 EXPORT_SYMBOL(sync_inode);
 
 /**
- * sync_inode - write an inode to disk
+ * sync_inode_metadata - write an inode to disk
  * @inode: the inode to sync
  * @wait: wait for I/O to complete.
  *
@@ -1315,13 +1315,49 @@ EXPORT_SYMBOL(sync_inode);
  *
  * Note: only writes the actual inode, no associated data or other metadata.
  */
-int sync_inode_metadata(struct inode *inode, int wait)
+int sync_inode_metadata(struct inode *inode, int datasync, int wait)
 {
+	struct address_space *mapping = inode->i_mapping;
 	struct writeback_control wbc = {
 		.sync_mode = wait ? WB_SYNC_ALL : WB_SYNC_NONE,
 		.nr_to_write = 0, /* metadata-only */
 	};
+	unsigned dirty, mask;
+	int ret = 0;
 
-	return sync_inode(inode, &wbc);
+	/*
+	 * This is a similar implementation to writeback_single_inode.
+	 * Keep them in sync.
+	 */
+	spin_lock(&inode_lock);
+	if (!inode_writeback_begin(inode, wait))
+		goto out;
+
+	if (datasync)
+		mask = I_DIRTY_DATASYNC;
+	else
+		mask = I_DIRTY_SYNC | I_DIRTY_DATASYNC;
+	dirty = inode->i_state & mask;
+	if (!dirty)
+		goto out;
+	/*
+	 * Generic write_inode doesn't distinguish between sync and datasync,
+	 * so even a datasync can clear the sync state. Filesystems which
+	 * distiguish these cases must only clear 'mask' in their metadata
+	 * sync code.
+	 */
+	inode->i_state &= ~(I_DIRTY_SYNC | I_DIRTY_DATASYNC);
+
+	spin_unlock(&inode_lock);
+	ret = write_inode(inode, &wbc);
+	spin_lock(&inode_lock);
+	if (ret)
+		inode->i_state |= dirty; /* couldn't write out inode */
+
+	inode_writeback_end(inode);
+
+out:
+	spin_unlock(&inode_lock);
+	return ret;
 }
 EXPORT_SYMBOL(sync_inode_metadata);
Index: linux-2.6/fs/libfs.c
===================================================================
--- linux-2.6.orig/fs/libfs.c	2010-11-23 22:56:51.000000000 +1100
+++ linux-2.6/fs/libfs.c	2010-11-23 22:57:45.000000000 +1100
@@ -895,7 +895,7 @@ int generic_file_fsync(struct file *file
 	int ret;
 
 	ret = sync_mapping_buffers(inode->i_mapping);
-	err = sync_inode_metadata(inode, 1);
+	err = sync_inode_metadata(inode, datasync, 1);
 	if (ret == 0)
 		ret = err;
 	return ret;
Index: linux-2.6/fs/nfsd/vfs.c
===================================================================
--- linux-2.6.orig/fs/nfsd/vfs.c	2010-11-23 22:56:51.000000000 +1100
+++ linux-2.6/fs/nfsd/vfs.c	2010-11-23 22:57:45.000000000 +1100
@@ -287,7 +287,7 @@ commit_metadata(struct svc_fh *fhp)
 
 	if (export_ops->commit_metadata)
 		return export_ops->commit_metadata(inode);
-	return sync_inode_metadata(inode, 1);
+	return sync_inode_metadata(inode, 0, 1);
 }
 
 /*
Index: linux-2.6/include/linux/fs.h
===================================================================
--- linux-2.6.orig/include/linux/fs.h	2010-11-23 22:56:51.000000000 +1100
+++ linux-2.6/include/linux/fs.h	2010-11-23 22:57:45.000000000 +1100
@@ -1764,7 +1764,7 @@ static inline void file_accessed(struct
 }
 
 int sync_inode(struct inode *inode, struct writeback_control *wbc);
-int sync_inode_metadata(struct inode *inode, int wait);
+int sync_inode_metadata(struct inode *inode, int datasync, int wait);
 int inode_writeback_begin(struct inode *inode, int wait);
 int inode_writeback_end(struct inode *inode);
 


