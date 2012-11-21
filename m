Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756657Ab2KVVKs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 16:10:48 -0500
Received: from userp1050.oracle.com ([156.151.31.82]:24052 "EHLO
	userp1050.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755667Ab2KVSqk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:46:40 -0500
From: Dave Kleikamp <dave.kleikamp@oracle.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Zach Brown <zab@zabbo.net>,
        "Maxim V. Patlasov" <mpatlasov@parallels.com>,
        Asias He <asias@redhat.com>, Dave Kleikamp <dave.kleikamp@oracle.com>
Subject: [PATCH v4 25/31] block_dev: add support for read_iter, write_iter
Date: Wed, 21 Nov 2012 16:41:05 -0600
Message-Id: <1353537671-26284-26-git-send-email-dave.kleikamp@oracle.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1353537671-26284-1-git-send-email-dave.kleikamp@oracle.com>
References: <1353537671-26284-1-git-send-email-dave.kleikamp@oracle.com>
X-Source-IP: userp1040.oracle.com [156.151.31.81]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Asias He <asias@redhat.com>

Use generic_file_read_iter for read_iter. Add blkdev_write_iter which is
based on blkdev_aio_write for write_iter.

Signed-off-by: Asias He <asias@redhat.com>
Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
---
 drivers/char/raw.c |  4 ++--
 fs/block_dev.c     | 18 ++++++++----------
 include/linux/fs.h |  8 ++++----
 3 files changed, 14 insertions(+), 16 deletions(-)

diff --git a/drivers/char/raw.c b/drivers/char/raw.c
index 0bb207e..70eb45a 100644
--- a/drivers/char/raw.c
+++ b/drivers/char/raw.c
@@ -285,9 +285,9 @@ static long raw_ctl_compat_ioctl(struct file *file, unsigned int cmd,
 
 static const struct file_operations raw_fops = {
 	.read		= do_sync_read,
-	.aio_read	= blkdev_aio_read,
+	.read_iter	= blkdev_read_iter,
 	.write		= do_sync_write,
-	.aio_write	= blkdev_aio_write,
+	.write_iter	= blkdev_write_iter,
 	.fsync		= blkdev_fsync,
 	.open		= raw_open,
 	.release	= raw_release,
diff --git a/fs/block_dev.c b/fs/block_dev.c
index 36bff7c..30d05fd9 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -1593,21 +1593,20 @@ static long block_ioctl(struct file *file, unsigned cmd, unsigned long arg)
 	return blkdev_ioctl(bdev, mode, cmd, arg);
 }
 
-ssize_t blkdev_aio_read(struct kiocb *iocb, const struct iovec *iov,
-			unsigned long nr_segs, loff_t pos)
+ssize_t blkdev_read_iter(struct kiocb *iocb, struct iov_iter *iter, loff_t pos)
 {
 	ssize_t ret;
 	struct block_device *bdev = I_BDEV(iocb->ki_filp->f_mapping->host);
 
 	percpu_down_read(&bdev->bd_block_size_semaphore);
 
-	ret = generic_file_aio_read(iocb, iov, nr_segs, pos);
+	ret = generic_file_read_iter(iocb, iter, pos);
 
 	percpu_up_read(&bdev->bd_block_size_semaphore);
 
 	return ret;
 }
-EXPORT_SYMBOL_GPL(blkdev_aio_read);
+EXPORT_SYMBOL_GPL(blkdev_read_iter);
 
 /*
  * Write data to the block device.  Only intended for the block device itself
@@ -1616,8 +1615,7 @@ EXPORT_SYMBOL_GPL(blkdev_aio_read);
  * Does not take i_mutex for the write and thus is not for general purpose
  * use.
  */
-ssize_t blkdev_aio_write(struct kiocb *iocb, const struct iovec *iov,
-			 unsigned long nr_segs, loff_t pos)
+ssize_t blkdev_write_iter(struct kiocb *iocb, struct iov_iter *iter, loff_t pos)
 {
 	struct file *file = iocb->ki_filp;
 	struct block_device *bdev = I_BDEV(file->f_mapping->host);
@@ -1630,7 +1628,7 @@ ssize_t blkdev_aio_write(struct kiocb *iocb, const struct iovec *iov,
 
 	percpu_down_read(&bdev->bd_block_size_semaphore);
 
-	ret = __generic_file_aio_write(iocb, iov, nr_segs, &iocb->ki_pos);
+	ret = __generic_file_write_iter(iocb, iter, &pos);
 	if (ret > 0 || ret == -EIOCBQUEUED) {
 		ssize_t err;
 
@@ -1645,7 +1643,7 @@ ssize_t blkdev_aio_write(struct kiocb *iocb, const struct iovec *iov,
 
 	return ret;
 }
-EXPORT_SYMBOL_GPL(blkdev_aio_write);
+EXPORT_SYMBOL_GPL(blkdev_write_iter);
 
 static int blkdev_mmap(struct file *file, struct vm_area_struct *vma)
 {
@@ -1724,8 +1722,8 @@ const struct file_operations def_blk_fops = {
 	.llseek		= block_llseek,
 	.read		= do_sync_read,
 	.write		= do_sync_write,
-  	.aio_read	= blkdev_aio_read,
-	.aio_write	= blkdev_aio_write,
+	.read_iter	= blkdev_read_iter,
+	.write_iter	= blkdev_write_iter,
 	.mmap		= blkdev_mmap,
 	.fsync		= blkdev_fsync,
 	.unlocked_ioctl	= block_ioctl,
diff --git a/include/linux/fs.h b/include/linux/fs.h
index e0960bd..71b2388 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2490,10 +2490,10 @@ extern int generic_segment_checks(const struct iovec *iov,
 		unsigned long *nr_segs, size_t *count, int access_flags);
 
 /* fs/block_dev.c */
-extern ssize_t blkdev_aio_read(struct kiocb *iocb, const struct iovec *iov,
-			       unsigned long nr_segs, loff_t pos);
-extern ssize_t blkdev_aio_write(struct kiocb *iocb, const struct iovec *iov,
-				unsigned long nr_segs, loff_t pos);
+extern ssize_t blkdev_read_iter(struct kiocb *iocb, struct iov_iter *iter,
+				loff_t pos);
+extern ssize_t blkdev_write_iter(struct kiocb *iocb, struct iov_iter *iter,
+				 loff_t pos);
 extern int blkdev_fsync(struct file *filp, loff_t start, loff_t end,
 			int datasync);
 extern void block_sync_page(struct page *page);
-- 
1.8.0

