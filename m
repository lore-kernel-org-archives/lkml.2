Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932391Ab0DVU1c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 16:27:32 -0400
Received: from kroah.org ([198.145.64.141]:59556 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757851Ab0DVT76 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 15:59:58 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Thu Apr 22 12:54:07 2010
Message-Id: <20100422195407.836386830@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Thu, 22 Apr 2010 12:53:28 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Anton Blanchard <anton@samba.org>, Christoph Hellwig <hch@lst.de>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: [031/139] raw: fsync method is now required
In-Reply-To: <20100422195715.GA25490@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Anton Blanchard <anton@samba.org>

commit 55ab3a1ff843e3f0e24d2da44e71bffa5d853010 upstream.

Commit 148f948ba877f4d3cdef036b1ff6d9f68986706a (vfs: Introduce new
helpers for syncing after writing to O_SYNC file or IS_SYNC inode) broke
the raw driver.

We now call through generic_file_aio_write -> generic_write_sync ->
vfs_fsync_range.  vfs_fsync_range has:

        if (!fop || !fop->fsync) {
                ret = -EINVAL;
                goto out;
        }

But drivers/char/raw.c doesn't set an fsync method.

We have two options: fix it or remove the raw driver completely.  I'm
happy to do either, the fact this has been broken for so long suggests it
is rarely used.

The patch below adds an fsync method to the raw driver.  My knowledge of
the block layer is pretty sketchy so this could do with a once over.

If we instead decide to remove the raw driver, this patch might still be
useful as a backport to 2.6.33 and 2.6.32.

Signed-off-by: Anton Blanchard <anton@samba.org>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Jens Axboe <jens.axboe@oracle.com>
Reviewed-by: Jeff Moyer <jmoyer@redhat.com>
Tested-by: Jeff Moyer <jmoyer@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/char/raw.c |    1 +
 fs/block_dev.c     |    3 ++-
 include/linux/fs.h |    1 +
 3 files changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/char/raw.c
+++ b/drivers/char/raw.c
@@ -247,6 +247,7 @@ static const struct file_operations raw_
 	.aio_read = 	generic_file_aio_read,
 	.write	=	do_sync_write,
 	.aio_write =	blkdev_aio_write,
+	.fsync	=	block_fsync,
 	.open	=	raw_open,
 	.release=	raw_release,
 	.ioctl	=	raw_ioctl,
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -404,7 +404,7 @@ static loff_t block_llseek(struct file *
  *	NULL first argument is nfsd_sync_dir() and that's not a directory.
  */
  
-static int block_fsync(struct file *filp, struct dentry *dentry, int datasync)
+int block_fsync(struct file *filp, struct dentry *dentry, int datasync)
 {
 	struct block_device *bdev = I_BDEV(filp->f_mapping->host);
 	int error;
@@ -418,6 +418,7 @@ static int block_fsync(struct file *filp
 		error = 0;
 	return error;
 }
+EXPORT_SYMBOL(block_fsync);
 
 /*
  * pseudo-fs
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2214,6 +2214,7 @@ extern int generic_segment_checks(const
 /* fs/block_dev.c */
 extern ssize_t blkdev_aio_write(struct kiocb *iocb, const struct iovec *iov,
 				unsigned long nr_segs, loff_t pos);
+extern int block_fsync(struct file *filp, struct dentry *dentry, int datasync);
 
 /* fs/splice.c */
 extern ssize_t generic_file_splice_read(struct file *, loff_t *,


