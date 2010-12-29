Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753371Ab0L2PBO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Dec 2010 10:01:14 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:42887 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752694Ab0L2PBN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Dec 2010 10:01:13 -0500
Date: Wed, 29 Dec 2010 10:01:09 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Nick Piggin <npiggin@kernel.dk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, mfasheh@suse.com,
        joel.becker@oracle.com, swhiteho@redhat.com
Subject: Re: [patch 7/8] fs: fix or note I_DIRTY handling bugs in filesystems
Message-ID: <20101229150108.GA13358@infradead.org>
References: <20101218014634.943276411@kernel.dk>
 <20101218015117.652706340@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101218015117.652706340@kernel.dk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As mentioned last round I think the exporting of inode_lock and pusing
of the I_DIRTY* complexities into the filesystems can be avoided.  See
the patch below, which compiles and passes xfstests for xfs, but
otherwise isn't quite done yet.  The only code change vs the opencoded
variant in the patch is that we do a useless inode_lock roundtrip
for a non-dirty inode on gfs2, which is I think is acceptable,
especially once we have the lock split anyway.

The other thing I don't like yet is passing the datasync flag - the
callback shouldn't care about what we were called with, but rather
about which bits it needs to sync out - which the dirty flag already
tells us about.

IMHO the behaviour in ocfs2 and gfs2 that relies on it is plain wrong:

 - ocfs2 really should always force the journal if any bit we care about
   in the inode is dirty, and only do the pure cache flush is nothing
   we care about is dirty (similar to the more complex code in XFS)
 - gfs2 seems really weird.  Doesn't it need to do any log force
   if an inode has a pending transaction?  Currently it only does for
   stuffed inodes, and if datasync was set, which seems weird.  Also
   I can't see why we'd never want to call into ->write_inode to write
   out the inode for the datasync case - except for not catching
   timestamp updates fdatasync really isn't any different from fsync.


Index: linux-2.6/fs/fs-writeback.c
===================================================================
--- linux-2.6.orig/fs/fs-writeback.c	2010-12-29 15:45:37.153003373 +0100
+++ linux-2.6/fs/fs-writeback.c	2010-12-29 15:46:13.566021881 +0100
@@ -315,7 +315,7 @@ static void inode_wait_for_writeback(str
  * If inode_writeback_begin returns 1, it must be followed by a call to
  * inode_writeback_end.
  */
-int inode_writeback_begin(struct inode *inode, int wait)
+static int inode_writeback_begin(struct inode *inode, int wait)
 {
 	assert_spin_locked(&inode_lock);
 	if (!atomic_read(&inode->i_count))
@@ -356,7 +356,7 @@ EXPORT_SYMBOL(inode_writeback_begin);
  * inode_writeback_end must follow a successful call to inode_writeback_begin
  * after we have finished submitting writeback to the inode.
  */
-int inode_writeback_end(struct inode *inode)
+static int inode_writeback_end(struct inode *inode)
 {
 	int ret = 1;
 
@@ -1362,3 +1362,45 @@ out:
 	return ret;
 }
 EXPORT_SYMBOL(sync_inode_metadata);
+
+/**
+ * fsync_helper - helper to implement writeback-coherent fsync
+ * @inode:	inode to sync
+ * @datasync:	only synchronize essential metadata if true
+ * @sync_inode:	actual fsync implementation
+ *
+ * This function should be used by all filesystems implementing that
+ * use VFS writeback and implement a complex fsync method that does not
+ * use sync_inode_metadata().  It ensures correct participation in the
+ * writeback locking protocol, and leaves all real work to the @sync_inode
+ * callback.  Note that the callback is also called if the inode wasn't
+ * found to be dirty - it's dirty argument contains the exact dirty bits
+ * found in the inode before releasing the inode lock.
+ */
+int fsync_helper(struct inode *inode, int datasync,
+	int (*sync_inode)(struct inode *inode, int datasync, int dirty))
+{
+	unsigned dirty, mask;
+	int ret = 0;
+
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
+	ret = sync_inode(inode, datasync, dirty);
+
+	spin_lock(&inode_lock);
+	if (ret)
+		inode->i_state |= dirty;
+	inode_writeback_end(inode);
+	spin_unlock(&inode_lock);
+	return ret;
+}
+EXPORT_SYMBOL(fsync_helper);
Index: linux-2.6/fs/gfs2/file.c
===================================================================
--- linux-2.6.orig/fs/gfs2/file.c	2010-12-29 15:45:37.159003932 +0100
+++ linux-2.6/fs/gfs2/file.c	2010-12-29 15:46:13.566021881 +0100
@@ -535,6 +535,21 @@ static int gfs2_close(struct inode *inod
 	return 0;
 }
 
+static int gfs2_fsync_int(struct inode *inode, int datasync, int dirty)
+{
+	if (!dirty)
+		return 0;
+	else if (!datasync) {
+		struct writeback_control wbc = {
+			.sync_mode = WB_SYNC_ALL,
+		};
+		return inode->i_sb->s_op->write_inode(inode, &wbc);
+	} else if (gfs2_is_stuffed(GFS2_I(inode)))
+		gfs2_log_flush(GFS2_SB(inode), GFS2_I(inode)->i_gl);
+
+	return 0;
+}
+
 /**
  * gfs2_fsync - sync the dirty data for a file (across the cluster)
  * @file: the file that points to the dentry (we ignore this)
@@ -546,56 +561,18 @@ static int gfs2_close(struct inode *inod
  * is set. For stuffed inodes we must flush the log in order to
  * ensure that all data is on disk.
  *
- * The call to write_inode_now() is there to write back metadata and
- * the inode itself. It does also try and write the data, but thats
- * (hopefully) a no-op due to the VFS having already called filemap_fdatawrite()
- * for us.
- *
  * Returns: errno
  */
-
 static int gfs2_fsync(struct file *file, int datasync)
 {
 	struct inode *inode = file->f_mapping->host;
-	unsigned dirty, mask;
-	int ret = 0;
 
 	if (gfs2_is_jdata(GFS2_I(inode))) {
 		gfs2_log_flush(GFS2_SB(inode), GFS2_I(inode)->i_gl);
 		return 0;
 	}
 
-	spin_lock(&inode_lock);
-	inode_writeback_begin(inode, 1);
-
-	if (datasync)
-		mask = I_DIRTY_DATASYNC;
-	else
-		mask = I_DIRTY_SYNC | I_DIRTY_DATASYNC;
-	dirty = inode->i_state & mask;
-	inode->i_state &= ~mask;
-	if (dirty) {
-		spin_unlock(&inode_lock);
-
-		if (!datasync) {
-			struct writeback_control wbc = {
-				.sync_mode = WB_SYNC_ALL,
-			};
-			ret = inode->i_sb->s_op->write_inode(inode, &wbc);
-		} else {
-			if (gfs2_is_stuffed(GFS2_I(inode)))
-				gfs2_log_flush(GFS2_SB(inode),
-						GFS2_I(inode)->i_gl);
-		}
-
-		spin_lock(&inode_lock);
-	}
-	if (ret)
-		inode->i_state |= dirty;
-	inode_writeback_end(inode);
-	spin_unlock(&inode_lock);
-
-	return ret;
+	return fsync_helper(inode, datasync, gfs2_fsync_int);
 }
 
 /**
Index: linux-2.6/fs/jfs/file.c
===================================================================
--- linux-2.6.orig/fs/jfs/file.c	2010-12-29 15:45:37.166004630 +0100
+++ linux-2.6/fs/jfs/file.c	2010-12-29 15:46:43.278255573 +0100
@@ -29,37 +29,20 @@
 #include "jfs_acl.h"
 #include "jfs_debug.h"
 
-int jfs_fsync(struct file *file, int datasync)
+static int jfs_fsync_int(struct inode *inode, int datasync, int dirty)
 {
-	struct inode *inode = file->f_mapping->host;
-	unsigned dirty, mask;
-	int err = 0;
-
-	spin_lock(&inode_lock);
-	inode_writeback_begin(inode, 1);
-
-	if (datasync)
-		mask = I_DIRTY_DATASYNC;
-	else
-		mask = I_DIRTY_SYNC | I_DIRTY_DATASYNC;
-	dirty = inode->i_state & mask;
-	inode->i_state &= ~mask;
-	spin_unlock(&inode_lock);
-
 	if (!dirty) {
 		/* Make sure committed changes hit the disk */
 		jfs_flush_journal(JFS_SBI(inode->i_sb)->log, 1);
-	} else {
-		err = jfs_commit_inode(inode, 1);
+		return 0;
 	}
 
-	spin_lock(&inode_lock);
-	if (err)
-		inode->i_state |= dirty;
-	inode_writeback_end(inode);
-	spin_unlock(&inode_lock);
+	return jfs_commit_inode(inode, 1) ? -EIO : 0;
+}
 
-	return err ? -EIO : 0;
+int jfs_fsync(struct file *file, int datasync)
+{
+	return fsync_helper(file->f_mapping->host, datasync, jfs_fsync_int);
 }
 
 static int jfs_open(struct inode *inode, struct file *file)
Index: linux-2.6/include/linux/fs.h
===================================================================
--- linux-2.6.orig/include/linux/fs.h	2010-12-29 15:45:37.204004211 +0100
+++ linux-2.6/include/linux/fs.h	2010-12-29 15:46:13.573272824 +0100
@@ -1766,8 +1766,8 @@ static inline void file_accessed(struct
 
 int sync_inode(struct inode *inode, struct writeback_control *wbc);
 int sync_inode_metadata(struct inode *inode, int datasync, int wait);
-int inode_writeback_begin(struct inode *inode, int wait);
-int inode_writeback_end(struct inode *inode);
+int fsync_helper(struct inode *inode, int datasync,
+	int (*sync_inode)(struct inode *inode, int datasync, int dirty));
 
 struct file_system_type {
 	const char *name;
Index: linux-2.6/fs/ocfs2/file.c
===================================================================
--- linux-2.6.orig/fs/ocfs2/file.c	2010-12-29 15:45:37.174003862 +0100
+++ linux-2.6/fs/ocfs2/file.c	2010-12-29 15:46:54.843005610 +0100
@@ -170,52 +170,26 @@ static int ocfs2_dir_release(struct inod
 	return 0;
 }
 
-static int ocfs2_sync_file(struct file *file, int datasync)
+static int ocfs2_fsync_int(struct inode *inode, int datasync, int dirty)
 {
-	int err = 0;
-	journal_t *journal;
-	struct inode *inode = file->f_mapping->host;
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
-	unsigned dirty, mask;
-
-	mlog_entry("(0x%p, %d, 0x%p, '%.*s')\n", file, datasync,
-		   file->f_path.dentry, file->f_path.dentry->d_name.len,
-		   file->f_path.dentry->d_name.name);
-
-	spin_lock(&inode_lock);
-	inode_writeback_begin(inode, 1);
-	if (datasync)
-		mask = I_DIRTY_DATASYNC;
-	else
-		mask = I_DIRTY_SYNC | I_DIRTY_DATASYNC;
-	dirty = inode->i_state & mask;
-	inode->i_state &= ~mask;
-	spin_unlock(&inode_lock);
 
 	if (datasync && dirty) {
-
 		/*
 		 * We still have to flush drive's caches to get data to the
 		 * platter
 		 */
 		if (osb->s_mount_opt & OCFS2_MOUNT_BARRIER)
 			blkdev_issue_flush(inode->i_sb->s_bdev, GFP_KERNEL, NULL);
-		goto bail;
+		return 0;
 	}
 
-	journal = osb->journal->j_journal;
-	err = jbd2_journal_force_commit(journal);
-
-bail:
-	spin_lock(&inode_lock);
-	if (err)
-		inode->i_state |= dirty;
-	inode_writeback_end(inode);
-	spin_unlock(&inode_lock);
-
-	mlog_exit(err);
+	return jbd2_journal_force_commit(osb->journal->j_journal) ? -EIO : 0;
+}
 
-	return (err < 0) ? -EIO : 0;
+static int ocfs2_sync_file(struct file *file, int datasync)
+{
+	return fsync_helper(file->f_mapping->host, datasync, ocfs2_fsync_int);
 }
 
 int ocfs2_should_update_atime(struct inode *inode,
Index: linux-2.6/fs/xfs/linux-2.6/xfs_file.c
===================================================================
--- linux-2.6.orig/fs/xfs/linux-2.6/xfs_file.c	2010-12-29 15:45:37.182003862 +0100
+++ linux-2.6/fs/xfs/linux-2.6/xfs_file.c	2010-12-29 15:47:55.253005677 +0100
@@ -90,16 +90,15 @@ xfs_iozero(
 }
 
 STATIC int
-xfs_file_fsync(
-	struct file		*file,
-	int			datasync)
+xfs_fsync_int(
+	struct inode		*inode,
+	int			datasync,
+	int			dirty)
 {
-	struct inode		*inode = file->f_mapping->host;
 	struct xfs_inode	*ip = XFS_I(inode);
 	struct xfs_trans	*tp;
 	int			error = 0;
 	int			log_flushed = 0;
-	unsigned		dirty, mask;
 
 	trace_xfs_file_fsync(ip);
 
@@ -111,25 +110,6 @@ xfs_file_fsync(
 	xfs_ioend_wait(ip);
 
 	/*
-	 * First check if the VFS inode is marked dirty.  All the dirtying
-	 * of non-transactional updates no goes through mark_inode_dirty*,
-	 * which allows us to distinguish beteeen pure timestamp updates
-	 * and i_size updates which need to be caught for fdatasync.
-	 * After that also theck for the dirty state in the XFS inode, which
-	 * might gets cleared when the inode gets written out via the AIL
-	 * or xfs_iflush_cluster.
-	 */
-	spin_lock(&inode_lock);
-	inode_writeback_begin(inode, 1);
-	if (datasync)
-		mask = I_DIRTY_DATASYNC;
-	else
-		mask = I_DIRTY_SYNC | I_DIRTY_DATASYNC;
-	dirty = inode->i_state & mask;
-	inode->i_state &= ~mask;
-	spin_unlock(&inode_lock);
-
-	/*
 	 * We always need to make sure that the required inode state is safe on
 	 * disk.  The inode might be clean but we still might need to force the
 	 * log because of committed transactions that haven't hit the disk yet.
@@ -143,6 +123,15 @@ xfs_file_fsync(
 	 */
 	xfs_ilock(ip, XFS_ILOCK_SHARED);
 
+	/*
+	 * First check if the VFS inode is marked dirty.  All the dirtying
+	 * of non-transactional updates no goes through mark_inode_dirty*,
+	 * which allows us to distinguish beteeen pure timestamp updates
+	 * and i_size updates which need to be caught for fdatasync.
+	 * After that also theck for the dirty state in the XFS inode, which
+	 * might gets cleared when the inode gets written out via the AIL
+	 * or xfs_iflush_cluster.
+	 */
 	if (dirty && ip->i_update_core) {
 		/*
 		 * Kick off a transaction to log the inode core to get the
@@ -207,15 +196,17 @@ xfs_file_fsync(
 	}
 
 out:
-	spin_lock(&inode_lock);
-	if (error)
-		inode->i_state |= dirty;
-	inode_writeback_end(inode);
-	spin_unlock(&inode_lock);
-
 	return -error;
 }
 
+STATIC int
+xfs_file_fsync(
+	struct file		*file,
+	int			datasync)
+{
+	return fsync_helper(file->f_mapping->host, datasync, xfs_fsync_int);
+}
+
 STATIC ssize_t
 xfs_file_aio_read(
 	struct kiocb		*iocb,
Index: linux-2.6/fs/inode.c
===================================================================
--- linux-2.6.orig/fs/inode.c	2010-12-29 15:45:37.190004281 +0100
+++ linux-2.6/fs/inode.c	2010-12-29 15:46:13.581004071 +0100
@@ -82,7 +82,6 @@ static struct hlist_head *inode_hashtabl
  * the i_state of an inode while it is in use..
  */
 DEFINE_SPINLOCK(inode_lock);
-EXPORT_SYMBOL(inode_lock);
 
 /*
  * iprune_sem provides exclusion between the kswapd or try_to_free_pages
