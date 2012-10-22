Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753570Ab2JVPdU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 11:33:20 -0400
Received: from userp1050.oracle.com ([156.151.31.82]:19255 "EHLO
	userp1050.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750798Ab2JVPdS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 11:33:18 -0400
X-Greylist: delayed 1055 seconds by postgrey-1.27 at vger.kernel.org; Mon, 22 Oct 2012 11:33:18 EDT
From: Dave Kleikamp <dave.kleikamp@oracle.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Zach Brown <zab@zabbo.net>,
        "Maxim V. Patlasov" <mpatlasov@parallels.com>,
        Asias He <asias@redhat.com>, Dave Kleikamp <dave.kleikamp@oracle.com>
Subject: [PATCH 22/22] block_dev: add support for read_iter, write_iter
Date: Mon, 22 Oct 2012 10:15:22 -0500
Message-Id: <1350918922-6096-23-git-send-email-dave.kleikamp@oracle.com>
X-Mailer: git-send-email 1.7.12.4
In-Reply-To: <1350918922-6096-1-git-send-email-dave.kleikamp@oracle.com>
References: <1350918922-6096-1-git-send-email-dave.kleikamp@oracle.com>
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
 fs/block_dev.c | 36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/fs/block_dev.c b/fs/block_dev.c
index ba3ed89..1a3aef9 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -1593,6 +1593,21 @@ static long block_ioctl(struct file *file, unsigned cmd, unsigned long arg)
 	return blkdev_ioctl(bdev, mode, cmd, arg);
 }
 
+static ssize_t blkdev_read_iter(struct kiocb *iocb, struct iov_iter *iter,
+				loff_t pos)
+{
+	ssize_t ret;
+	struct block_device *bdev = I_BDEV(iocb->ki_filp->f_mapping->host);
+
+	percpu_down_read(&bdev->bd_block_size_semaphore);
+
+	ret = generic_file_read_iter(iocb, iter, pos);
+
+	percpu_up_read(&bdev->bd_block_size_semaphore);
+
+	return ret;
+}
+
 ssize_t blkdev_aio_read(struct kiocb *iocb, const struct iovec *iov,
 			unsigned long nr_segs, loff_t pos)
 {
@@ -1609,6 +1624,25 @@ ssize_t blkdev_aio_read(struct kiocb *iocb, const struct iovec *iov,
 }
 EXPORT_SYMBOL_GPL(blkdev_aio_read);
 
+ssize_t blkdev_write_iter(struct kiocb *iocb, struct iov_iter *iter, loff_t pos)
+{
+	struct file *file = iocb->ki_filp;
+	ssize_t ret;
+
+	BUG_ON(iocb->ki_pos != pos);
+
+	ret = __generic_file_write_iter(iocb, iter, &pos);
+	if (ret > 0 || ret == -EIOCBQUEUED) {
+		ssize_t err;
+
+		err = generic_write_sync(file, pos, ret);
+		if (err < 0 && ret > 0)
+			ret = err;
+	}
+	return ret;
+}
+EXPORT_SYMBOL_GPL(blkdev_write_iter);
+
 /*
  * Write data to the block device.  Only intended for the block device itself
  * and the raw driver which basically is a fake block device.
@@ -1693,6 +1727,8 @@ const struct file_operations def_blk_fops = {
 	.write		= do_sync_write,
   	.aio_read	= blkdev_aio_read,
 	.aio_write	= blkdev_aio_write,
+	.read_iter	= blkdev_read_iter,
+	.write_iter	= blkdev_write_iter,
 	.mmap		= blkdev_mmap,
 	.fsync		= blkdev_fsync,
 	.unlocked_ioctl	= block_ioctl,
-- 
1.7.12.3

