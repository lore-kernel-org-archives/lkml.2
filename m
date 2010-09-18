Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757511Ab0IRThx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 15:37:53 -0400
Received: from kroah.org ([198.145.64.141]:43229 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756667Ab0IRTOw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 15:14:52 -0400
X-Mailbox-Line: From gregkh@clark.site Sat Sep 18 12:12:58 2010
Message-Id: <20100918191258.885972009@clark.site>
User-Agent: quilt/0.48-11.2
Date: Sat, 18 Sep 2010 12:11:57 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Christoph Hellwig <hch@lst.de>, Alex Elder <aelder@sgi.com>,
        Chuck Ebbert <cebbert@redhat.com>
Subject: [019/129] direct-io: move aio_complete into ->end_io
In-Reply-To: <20100918191317.GA11386@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Christoph Hellwig <hch@infradead.org>

commit 40e2e97316af6e62affab7a392e792494b8d9dde upstream.

Filesystems with unwritten extent support must not complete an AIO request
until the transaction to convert the extent has been commited.  That means
the aio_complete calls needs to be moved into the ->end_io callback so
that the filesystem can control when to call it exactly.

This makes a bit of a mess out of dio_complete and the ->end_io callback
prototype even more complicated.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Alex Elder <aelder@sgi.com>
Cc: Chuck Ebbert <cebbert@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/direct-io.c              |   26 ++++++++++++++------------
 fs/ext4/inode.c             |   10 +++++++---
 fs/ocfs2/aops.c             |    7 ++++++-
 fs/xfs/linux-2.6/xfs_aops.c |    7 ++++++-
 fs/xfs/linux-2.6/xfs_aops.h |    2 ++
 include/linux/fs.h          |    3 ++-
 6 files changed, 37 insertions(+), 18 deletions(-)

--- a/fs/direct-io.c
+++ b/fs/direct-io.c
@@ -218,7 +218,7 @@ static struct page *dio_get_page(struct
  * filesystems can use it to hold additional state between get_block calls and
  * dio_complete.
  */
-static int dio_complete(struct dio *dio, loff_t offset, int ret)
+static int dio_complete(struct dio *dio, loff_t offset, int ret, bool is_async)
 {
 	ssize_t transferred = 0;
 
@@ -239,14 +239,6 @@ static int dio_complete(struct dio *dio,
 			transferred = dio->i_size - offset;
 	}
 
-	if (dio->end_io && dio->result)
-		dio->end_io(dio->iocb, offset, transferred,
-			    dio->map_bh.b_private);
-
-	if (dio->flags & DIO_LOCKING)
-		/* lockdep: non-owner release */
-		up_read_non_owner(&dio->inode->i_alloc_sem);
-
 	if (ret == 0)
 		ret = dio->page_errors;
 	if (ret == 0)
@@ -254,6 +246,17 @@ static int dio_complete(struct dio *dio,
 	if (ret == 0)
 		ret = transferred;
 
+	if (dio->end_io && dio->result) {
+		dio->end_io(dio->iocb, offset, transferred,
+			    dio->map_bh.b_private, ret, is_async);
+	} else if (is_async) {
+		aio_complete(dio->iocb, ret, 0);
+	}
+
+	if (dio->flags & DIO_LOCKING)
+		/* lockdep: non-owner release */
+		up_read_non_owner(&dio->inode->i_alloc_sem);
+
 	return ret;
 }
 
@@ -277,8 +280,7 @@ static void dio_bio_end_aio(struct bio *
 	spin_unlock_irqrestore(&dio->bio_lock, flags);
 
 	if (remaining == 0) {
-		int ret = dio_complete(dio, dio->iocb->ki_pos, 0);
-		aio_complete(dio->iocb, ret, 0);
+		dio_complete(dio, dio->iocb->ki_pos, 0, true);
 		kfree(dio);
 	}
 }
@@ -1126,7 +1128,7 @@ direct_io_worker(int rw, struct kiocb *i
 	spin_unlock_irqrestore(&dio->bio_lock, flags);
 
 	if (ret2 == 0) {
-		ret = dio_complete(dio, offset, ret);
+		ret = dio_complete(dio, offset, ret, false);
 		kfree(dio);
 	} else
 		BUG_ON(ret != -EIOCBQUEUED);
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3775,7 +3775,8 @@ static ext4_io_end_t *ext4_init_io_end (
 }
 
 static void ext4_end_io_dio(struct kiocb *iocb, loff_t offset,
-			    ssize_t size, void *private)
+			    ssize_t size, void *private, int ret,
+			    bool is_async)
 {
         ext4_io_end_t *io_end = iocb->private;
 	struct workqueue_struct *wq;
@@ -3784,7 +3785,7 @@ static void ext4_end_io_dio(struct kiocb
 
 	/* if not async direct IO or dio with 0 bytes write, just return */
 	if (!io_end || !size)
-		return;
+		goto out;
 
 	ext_debug("ext4_end_io_dio(): io_end 0x%p"
 		  "for inode %lu, iocb 0x%p, offset %llu, size %llu\n",
@@ -3795,7 +3796,7 @@ static void ext4_end_io_dio(struct kiocb
 	if (io_end->flag != EXT4_IO_UNWRITTEN){
 		ext4_free_io_end(io_end);
 		iocb->private = NULL;
-		return;
+		goto out;
 	}
 
 	io_end->offset = offset;
@@ -3812,6 +3813,9 @@ static void ext4_end_io_dio(struct kiocb
 	list_add_tail(&io_end->list, &ei->i_completed_io_list);
 	spin_unlock_irqrestore(&ei->i_completed_io_lock, flags);
 	iocb->private = NULL;
+out:
+	if (is_async)
+		aio_complete(iocb, ret, 0);
 }
 
 static void ext4_end_io_buffer_write(struct buffer_head *bh, int uptodate)
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -578,7 +578,9 @@ bail:
 static void ocfs2_dio_end_io(struct kiocb *iocb,
 			     loff_t offset,
 			     ssize_t bytes,
-			     void *private)
+			     void *private,
+			     int ret,
+			     bool is_async)
 {
 	struct inode *inode = iocb->ki_filp->f_path.dentry->d_inode;
 	int level;
@@ -592,6 +594,9 @@ static void ocfs2_dio_end_io(struct kioc
 	if (!level)
 		up_read(&inode->i_alloc_sem);
 	ocfs2_rw_unlock(inode, level);
+
+	if (is_async)
+		aio_complete(iocb, ret, 0);
 }
 
 /*
--- a/fs/xfs/linux-2.6/xfs_aops.c
+++ b/fs/xfs/linux-2.6/xfs_aops.c
@@ -1599,7 +1599,9 @@ xfs_end_io_direct(
 	struct kiocb	*iocb,
 	loff_t		offset,
 	ssize_t		size,
-	void		*private)
+	void		*private,
+	int		ret,
+	bool		is_async)
 {
 	xfs_ioend_t	*ioend = iocb->private;
 
@@ -1645,6 +1647,9 @@ xfs_end_io_direct(
 	 * against double-freeing.
 	 */
 	iocb->private = NULL;
+
+	if (is_async)
+		aio_complete(iocb, ret, 0);
 }
 
 STATIC ssize_t
--- a/fs/xfs/linux-2.6/xfs_aops.h
+++ b/fs/xfs/linux-2.6/xfs_aops.h
@@ -37,6 +37,8 @@ typedef struct xfs_ioend {
 	size_t			io_size;	/* size of the extent */
 	xfs_off_t		io_offset;	/* offset in the file */
 	struct work_struct	io_work;	/* xfsdatad work queue */
+	struct kiocb		*io_iocb;
+	int			io_result;
 } xfs_ioend_t;
 
 extern const struct address_space_operations xfs_address_space_operations;
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -416,7 +416,8 @@ struct buffer_head;
 typedef int (get_block_t)(struct inode *inode, sector_t iblock,
 			struct buffer_head *bh_result, int create);
 typedef void (dio_iodone_t)(struct kiocb *iocb, loff_t offset,
-			ssize_t bytes, void *private);
+			ssize_t bytes, void *private, int ret,
+			bool is_async);
 
 /*
  * Attribute flags.  These should be or-ed together to figure out what


