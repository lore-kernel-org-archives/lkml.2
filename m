Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755112Ab0DDAuZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Apr 2010 20:50:25 -0400
Received: from ozlabs.org ([203.10.76.45]:34619 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754659Ab0DDAuT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Apr 2010 20:50:19 -0400
Date: Sun, 4 Apr 2010 10:45:23 +1000
From: Anton Blanchard <anton@samba.org>
To: Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@lst.de>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Jens Axboe <jens.axboe@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] raw: fsync method is now required
Message-ID: <20100404004523.GL5594@kryten>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Commit 148f948ba877f4d3cdef036b1ff6d9f68986706a (vfs: Introduce new helpers for syncing after writing to O_SYNC file or IS_SYNC inode) broke the raw driver.

We now call through generic_file_aio_write -> generic_write_sync ->
vfs_fsync_range. vfs_fsync_range has:

        if (!fop || !fop->fsync) {
                ret = -EINVAL;
                goto out;
        }

But drivers/char/raw.c doesn't set an fsync method. 

We have two options: fix it or remove the raw driver completely. I'm happy
to do either, the fact this has been broken for so long suggests it is
rarely used.

The patch below adds an fsync method to the raw driver. My knowledge of the
block layer is pretty sketchy so this could do with a once over.

If we instead decide to remove the raw driver, this patch might still be
useful as a backport to 2.6.33 and 2.6.32.

Signed-off-by: Anton Blanchard <anton@samba.org>
---

Index: linux-2.6/drivers/char/raw.c
===================================================================
--- linux-2.6.orig/drivers/char/raw.c	2010-03-19 11:46:30.000000000 +1100
+++ linux-2.6/drivers/char/raw.c	2010-04-04 10:34:36.000000000 +1000
@@ -247,6 +247,7 @@ static const struct file_operations raw_
 	.aio_read = 	generic_file_aio_read,
 	.write	=	do_sync_write,
 	.aio_write =	blkdev_aio_write,
+	.fsync	=	block_fsync,
 	.open	=	raw_open,
 	.release=	raw_release,
 	.ioctl	=	raw_ioctl,
Index: linux-2.6/fs/block_dev.c
===================================================================
--- linux-2.6.orig/fs/block_dev.c	2010-04-04 08:33:10.000000000 +1000
+++ linux-2.6/fs/block_dev.c	2010-04-04 10:34:36.000000000 +1000
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
Index: linux-2.6/include/linux/fs.h
===================================================================
--- linux-2.6.orig/include/linux/fs.h	2010-04-04 08:33:15.000000000 +1000
+++ linux-2.6/include/linux/fs.h	2010-04-04 10:34:36.000000000 +1000
@@ -2212,6 +2212,7 @@ extern int generic_segment_checks(const 
 /* fs/block_dev.c */
 extern ssize_t blkdev_aio_write(struct kiocb *iocb, const struct iovec *iov,
 				unsigned long nr_segs, loff_t pos);
+extern int block_fsync(struct file *filp, struct dentry *dentry, int datasync);
 
 /* fs/splice.c */
 extern ssize_t generic_file_splice_read(struct file *, loff_t *,
