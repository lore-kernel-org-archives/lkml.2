Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754645Ab0KWOL5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 09:11:57 -0500
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:62515 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754407Ab0KWOLy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 09:11:54 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AsoJAMpZ60x5LdQd/2dsb2JhbACVY40Acr1HhUsEil6FEw
Message-Id: <20101123140708.132861329@kernel.dk>
User-Agent: quilt/0.48-1
Date: Wed, 24 Nov 2010 01:06:17 +1100
From: npiggin@kernel.dk
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [patch 7/7] fs: fix or note I_DIRTY handling bugs in filesystems
References: <20101123140610.292941494@kernel.dk>
Content-Disposition: inline; filename=fs-fix-dirty-flags.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Comments?

Index: linux-2.6/drivers/staging/pohmelfs/inode.c
===================================================================
--- linux-2.6.orig/drivers/staging/pohmelfs/inode.c	2010-11-23 22:57:45.000000000 +1100
+++ linux-2.6/drivers/staging/pohmelfs/inode.c	2010-11-23 22:59:47.000000000 +1100
@@ -373,6 +373,7 @@ static int pohmelfs_write_inode_create_c
 		dprintk("%s: parent: %llu, ino: %llu, inode: %p.\n",
 				__func__, parent->ino, n->ino, inode);
 
+		/* XXX: is this race WRT writeback? */
 		if (inode && (inode->i_state & I_DIRTY)) {
 			struct pohmelfs_inode *pi = POHMELFS_I(inode);
 			pohmelfs_write_create_inode(pi);
Index: linux-2.6/fs/gfs2/file.c
===================================================================
--- linux-2.6.orig/fs/gfs2/file.c	2010-11-23 22:54:47.000000000 +1100
+++ linux-2.6/fs/gfs2/file.c	2010-11-24 00:58:42.000000000 +1100
@@ -557,23 +557,43 @@ static int gfs2_close(struct inode *inod
 static int gfs2_fsync(struct file *file, int datasync)
 {
 	struct inode *inode = file->f_mapping->host;
-	int sync_state = inode->i_state & (I_DIRTY_SYNC|I_DIRTY_DATASYNC);
+	unsigned dirty, mask;
 	int ret = 0;
 
-	/* XXX: testing i_state is broken without proper synchronization */
-
 	if (gfs2_is_jdata(GFS2_I(inode))) {
 		gfs2_log_flush(GFS2_SB(inode), GFS2_I(inode)->i_gl);
 		return 0;
 	}
 
-	if (sync_state != 0) {
-		if (!datasync)
-			ret = write_inode_now(inode, 0);
+	spin_lock(&inode_lock);
+	inode_writeback_begin(inode, 1);
+
+	if (datasync)
+		mask = I_DIRTY_DATASYNC;
+	else
+		mask = I_DIRTY_SYNC | I_DIRTY_DATASYNC;
+	dirty = inode->i_state & mask;
+	inode->i_state &= ~mask;
+	if (dirty) {
+		spin_unlock(&inode_lock);
+
+		if (!datasync) {
+			struct writeback_control wbc = {
+				.sync_mode = WB_SYNC_ALL,
+			};
+			ret = inode->i_sb->s_op->write_inode(inode, &wbc);
+		} else {
+			if (gfs2_is_stuffed(GFS2_I(inode)))
+				gfs2_log_flush(GFS2_SB(inode),
+						GFS2_I(inode)->i_gl);
+		}
 
-		if (gfs2_is_stuffed(GFS2_I(inode)))
-			gfs2_log_flush(GFS2_SB(inode), GFS2_I(inode)->i_gl);
+		spin_lock(&inode_lock);
 	}
+	if (ret)
+		inode->i_state |= dirty;
+	inode_writeback_end(inode);
+	spin_unlock(&inode_lock);
 
 	return ret;
 }
Index: linux-2.6/fs/jffs2/fs.c
===================================================================
--- linux-2.6.orig/fs/jffs2/fs.c	2010-11-23 22:54:46.000000000 +1100
+++ linux-2.6/fs/jffs2/fs.c	2010-11-23 22:59:47.000000000 +1100
@@ -361,6 +361,7 @@ void jffs2_dirty_inode(struct inode *ino
 {
 	struct iattr iattr;
 
+	/* XXX: huh? How does this make sense? */
 	if (!(inode->i_state & I_DIRTY_DATASYNC)) {
 		D2(printk(KERN_DEBUG "jffs2_dirty_inode() not calling setattr() for ino #%lu\n", inode->i_ino));
 		return;
Index: linux-2.6/fs/jfs/file.c
===================================================================
--- linux-2.6.orig/fs/jfs/file.c	2010-11-23 22:54:47.000000000 +1100
+++ linux-2.6/fs/jfs/file.c	2010-11-24 00:38:08.000000000 +1100
@@ -19,6 +19,7 @@
 
 #include <linux/mm.h>
 #include <linux/fs.h>
+#include <linux/writeback.h>
 #include <linux/quotaops.h>
 #include "jfs_incore.h"
 #include "jfs_inode.h"
@@ -31,18 +32,34 @@
 int jfs_fsync(struct file *file, int datasync)
 {
 	struct inode *inode = file->f_mapping->host;
-	int rc = 0;
+	unsigned dirty, mask;
+	int err = 0;
 
-	if (!(inode->i_state & I_DIRTY) ||
-	    (datasync && !(inode->i_state & I_DIRTY_DATASYNC))) {
+	spin_lock(&inode_lock);
+	inode_writeback_begin(inode, 1);
+
+	if (datasync)
+		mask = I_DIRTY_DATASYNC;
+	else
+		mask = I_DIRTY_SYNC | I_DIRTY_DATASYNC;
+	dirty = inode->i_state & mask;
+	inode->i_state &= ~mask;
+	spin_unlock(&inode_lock);
+
+	if (!dirty) {
 		/* Make sure committed changes hit the disk */
 		jfs_flush_journal(JFS_SBI(inode->i_sb)->log, 1);
-		return rc;
+	} else {
+		err = jfs_commit_inode(inode, 1);
 	}
 
-	rc |= jfs_commit_inode(inode, 1);
+	spin_lock(&inode_lock);
+	if (err)
+		inode->i_state |= dirty;
+	inode_writeback_end(inode);
+	spin_unlock(&inode_lock);
 
-	return rc ? -EIO : 0;
+	return err ? -EIO : 0;
 }
 
 static int jfs_open(struct inode *inode, struct file *file)
Index: linux-2.6/fs/nfsd/vfs.c
===================================================================
--- linux-2.6.orig/fs/nfsd/vfs.c	2010-11-23 22:57:45.000000000 +1100
+++ linux-2.6/fs/nfsd/vfs.c	2010-11-23 22:59:47.000000000 +1100
@@ -969,10 +969,9 @@ static int wait_for_concurrent_writes(st
 		dprintk("nfsd: write resume %d\n", task_pid_nr(current));
 	}
 
-	if (inode->i_state & I_DIRTY) {
-		dprintk("nfsd: write sync %d\n", task_pid_nr(current));
-		err = vfs_fsync(file, 0);
-	}
+	dprintk("nfsd: write sync %d\n", task_pid_nr(current));
+	err = vfs_fsync(file, 0);
+
 	last_ino = inode->i_ino;
 	last_dev = inode->i_sb->s_dev;
 	return err;
Index: linux-2.6/fs/ocfs2/file.c
===================================================================
--- linux-2.6.orig/fs/ocfs2/file.c	2010-11-23 22:54:47.000000000 +1100
+++ linux-2.6/fs/ocfs2/file.c	2010-11-24 00:33:24.000000000 +1100
@@ -176,12 +176,24 @@ static int ocfs2_sync_file(struct file *
 	journal_t *journal;
 	struct inode *inode = file->f_mapping->host;
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
+	unsigned dirty, mask;
 
 	mlog_entry("(0x%p, %d, 0x%p, '%.*s')\n", file, datasync,
 		   file->f_path.dentry, file->f_path.dentry->d_name.len,
 		   file->f_path.dentry->d_name.name);
 
-	if (datasync && !(inode->i_state & I_DIRTY_DATASYNC)) {
+	spin_lock(&inode_lock);
+	inode_writeback_begin(inode, 1);
+	if (datasync)
+		mask = I_DIRTY_DATASYNC;
+	else
+		mask = I_DIRTY_SYNC | I_DIRTY_DATASYNC;
+	dirty = inode->i_state & mask;
+	inode->i_state &= ~mask;
+	spin_unlock(&inode_lock);
+
+	if (datasync && dirty) {
+
 		/*
 		 * We still have to flush drive's caches to get data to the
 		 * platter
@@ -195,6 +207,12 @@ static int ocfs2_sync_file(struct file *
 	err = jbd2_journal_force_commit(journal);
 
 bail:
+	spin_lock(&inode_lock);
+	if (err)
+		inode->i_state |= dirty;
+	inode_writeback_end(inode);
+	spin_unlock(&inode_lock);
+
 	mlog_exit(err);
 
 	return (err < 0) ? -EIO : 0;
Index: linux-2.6/fs/ubifs/file.c
===================================================================
--- linux-2.6.orig/fs/ubifs/file.c	2010-11-23 22:54:47.000000000 +1100
+++ linux-2.6/fs/ubifs/file.c	2010-11-23 22:59:47.000000000 +1100
@@ -1313,11 +1313,9 @@ int ubifs_fsync(struct file *file, int d
 	 * VFS has already synchronized dirty pages for this inode. Synchronize
 	 * the inode unless this is a 'datasync()' call.
 	 */
-	if (!datasync || (inode->i_state & I_DIRTY_DATASYNC)) {
-		err = inode->i_sb->s_op->write_inode(inode, NULL);
-		if (err)
-			return err;
-	}
+	err = sync_inode_metadata(inode, datasync, 1);
+	if (err)
+		return err;
 
 	/*
 	 * Nodes related to this inode may still sit in a write-buffer. Flush
Index: linux-2.6/fs/ufs/truncate.c
===================================================================
--- linux-2.6.orig/fs/ufs/truncate.c	2010-11-23 22:54:47.000000000 +1100
+++ linux-2.6/fs/ufs/truncate.c	2010-11-23 22:59:47.000000000 +1100
@@ -479,7 +479,7 @@ int ufs_truncate(struct inode *inode, lo
 		retry |= ufs_trunc_tindirect (inode);
 		if (!retry)
 			break;
-		if (IS_SYNC(inode) && (inode->i_state & I_DIRTY))
+		if (IS_SYNC(inode))
 			ufs_sync_inode (inode);
 		blk_run_address_space(inode->i_mapping);
 		yield();
Index: linux-2.6/fs/xfs/linux-2.6/xfs_file.c
===================================================================
--- linux-2.6.orig/fs/xfs/linux-2.6/xfs_file.c	2010-11-23 22:54:47.000000000 +1100
+++ linux-2.6/fs/xfs/linux-2.6/xfs_file.c	2010-11-24 00:08:03.000000000 +1100
@@ -99,6 +99,7 @@ xfs_file_fsync(
 	struct xfs_trans	*tp;
 	int			error = 0;
 	int			log_flushed = 0;
+	unsigned		dirty, mask;
 
 	trace_xfs_file_fsync(ip);
 
@@ -132,9 +133,16 @@ xfs_file_fsync(
 	 * might gets cleared when the inode gets written out via the AIL
 	 * or xfs_iflush_cluster.
 	 */
-	if (((inode->i_state & I_DIRTY_DATASYNC) ||
-	    ((inode->i_state & I_DIRTY_SYNC) && !datasync)) &&
-	    ip->i_update_core) {
+	spin_lock(&inode_lock);
+	inode_writeback_begin(inode, 1);
+	if (datasync)
+		mask = I_DIRTY_DATASYNC;
+	else
+		mask = I_DIRTY_SYNC | I_DIRTY_DATASYNC;
+	dirty = inode->i_state & mask;
+	inode->i_state &= ~mask;
+	spin_unlock(&inode_lock);
+	if (dirty && ip->i_update_core) {
 		/*
 		 * Kick off a transaction to log the inode core to get the
 		 * updates.  The sync transaction will also force the log.
@@ -145,7 +153,7 @@ xfs_file_fsync(
 				XFS_FSYNC_TS_LOG_RES(ip->i_mount), 0, 0, 0);
 		if (error) {
 			xfs_trans_cancel(tp, 0);
-			return -error;
+			goto out;
 		}
 		xfs_ilock(ip, XFS_ILOCK_EXCL);
 
@@ -197,6 +205,13 @@ xfs_file_fsync(
 			xfs_blkdev_issue_flush(ip->i_mount->m_rtdev_targp);
 	}
 
+out:
+	spin_lock(&inode_lock);
+	if (error)
+		inode->i_state |= dirty;
+	inode_writeback_end(inode);
+	spin_unlock(&inode_lock);
+
 	return -error;
 }
 
Index: linux-2.6/fs/inode.c
===================================================================
--- linux-2.6.orig/fs/inode.c	2010-11-23 23:53:57.000000000 +1100
+++ linux-2.6/fs/inode.c	2010-11-23 23:54:06.000000000 +1100
@@ -82,6 +82,7 @@ static struct hlist_head *inode_hashtabl
  * the i_state of an inode while it is in use..
  */
 DEFINE_SPINLOCK(inode_lock);
+EXPORT_SYMBOL(inode_lock);
 
 /*
  * iprune_sem provides exclusion between the kswapd or try_to_free_pages


