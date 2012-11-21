Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965093Ab2KVThn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 14:37:43 -0500
Received: from userp1050.oracle.com ([156.151.31.82]:25123 "EHLO
	userp1050.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756413Ab2KVThe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 14:37:34 -0500
From: Dave Kleikamp <dave.kleikamp@oracle.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Zach Brown <zab@zabbo.net>,
        "Maxim V. Patlasov" <mpatlasov@parallels.com>,
        Dave Kleikamp <dave.kleikamp@oracle.com>
Subject: [PATCH v4 16/31] loop: use aio to perform io on the underlying file
Date: Wed, 21 Nov 2012 16:40:56 -0600
Message-Id: <1353537671-26284-17-git-send-email-dave.kleikamp@oracle.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1353537671-26284-1-git-send-email-dave.kleikamp@oracle.com>
References: <1353537671-26284-1-git-send-email-dave.kleikamp@oracle.com>
X-Source-IP: userp1040.oracle.com [156.151.31.81]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zach Brown <zab@zabbo.net>

This uses the new kernel aio interface to process loopback IO by
submitting concurrent direct aio.  Previously loop's IO was serialized
by synchronous processing in a thread.

The aio operations specify the memory for the IO with the bio_vec arrays
directly instead of mappings of the pages.

The use of aio operations is enabled when the backing file supports the
read_iter and write_iter methods.  These methods must only be added when
O_DIRECT on bio_vecs is supported.

Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Cc: Zach Brown <zab@zabbo.net>
---
 drivers/block/loop.c      | 136 +++++++++++++++++++++++++++++++++++-----------
 include/uapi/linux/loop.h |   1 +
 2 files changed, 104 insertions(+), 33 deletions(-)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index 54046e5..a2555c1 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -76,6 +76,7 @@
 #include <linux/sysfs.h>
 #include <linux/miscdevice.h>
 #include <linux/falloc.h>
+#include <linux/aio.h>
 
 #include <asm/uaccess.h>
 
@@ -213,6 +214,48 @@ lo_do_transfer(struct loop_device *lo, int cmd,
 	return lo->transfer(lo, cmd, rpage, roffs, lpage, loffs, size, rblock);
 }
 
+#ifdef CONFIG_AIO
+static void lo_rw_aio_complete(u64 data, long res)
+{
+	struct bio *bio = (struct bio *)(uintptr_t)data;
+
+	if (res > 0)
+		res = 0;
+	else if (res < 0)
+		res = -EIO;
+
+	bio_endio(bio, res);
+}
+
+static int lo_rw_aio(struct loop_device *lo, struct bio *bio)
+{
+	struct file *file = lo->lo_backing_file;
+	struct kiocb *iocb;
+	unsigned short op;
+	struct iov_iter iter;
+	struct bio_vec *bvec;
+	size_t nr_segs;
+	loff_t pos = ((loff_t) bio->bi_sector << 9) + lo->lo_offset;
+
+	iocb = aio_kernel_alloc(GFP_NOIO);
+	if (!iocb)
+		return -ENOMEM;
+
+	if (bio_rw(bio) & WRITE)
+		op = IOCB_CMD_WRITE_ITER;
+	else
+		op = IOCB_CMD_READ_ITER;
+
+	bvec = bio_iovec_idx(bio, bio->bi_idx);
+	nr_segs = bio_segments(bio);
+	iov_iter_init_bvec(&iter, bvec, nr_segs, bvec_length(bvec, nr_segs), 0);
+	aio_kernel_init_iter(iocb, file, op, &iter, pos);
+	aio_kernel_init_callback(iocb, lo_rw_aio_complete, (u64)(uintptr_t)bio);
+
+	return aio_kernel_submit(iocb);
+}
+#endif /* CONFIG_AIO */
+
 /**
  * __do_lo_send_write - helper for writing data to a loop device
  *
@@ -413,37 +456,6 @@ static int do_bio_filebacked(struct loop_device *lo, struct bio *bio)
 	if (bio_rw(bio) == WRITE) {
 		struct file *file = lo->lo_backing_file;
 
-		if (bio->bi_rw & REQ_FLUSH) {
-			ret = vfs_fsync(file, 0);
-			if (unlikely(ret && ret != -EINVAL)) {
-				ret = -EIO;
-				goto out;
-			}
-		}
-
-		/*
-		 * We use punch hole to reclaim the free space used by the
-		 * image a.k.a. discard. However we do not support discard if
-		 * encryption is enabled, because it may give an attacker
-		 * useful information.
-		 */
-		if (bio->bi_rw & REQ_DISCARD) {
-			struct file *file = lo->lo_backing_file;
-			int mode = FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE;
-
-			if ((!file->f_op->fallocate) ||
-			    lo->lo_encrypt_key_size) {
-				ret = -EOPNOTSUPP;
-				goto out;
-			}
-			ret = file->f_op->fallocate(file, mode, pos,
-						    bio->bi_size);
-			if (unlikely(ret && ret != -EINVAL &&
-				     ret != -EOPNOTSUPP))
-				ret = -EIO;
-			goto out;
-		}
-
 		ret = lo_send(lo, bio, pos);
 
 		if ((bio->bi_rw & REQ_FUA) && !ret) {
@@ -454,7 +466,29 @@ static int do_bio_filebacked(struct loop_device *lo, struct bio *bio)
 	} else
 		ret = lo_receive(lo, bio, lo->lo_blocksize, pos);
 
-out:
+	return ret;
+}
+
+static int lo_discard(struct loop_device *lo, struct bio *bio)
+{
+	struct file *file = lo->lo_backing_file;
+	int mode = FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE;
+	loff_t pos = ((loff_t) bio->bi_sector << 9) + lo->lo_offset;
+	int ret;
+
+	/*
+	 * We use punch hole to reclaim the free space used by the
+	 * image a.k.a. discard. However we do not support discard if
+	 * encryption is enabled, because it may give an attacker
+	 * useful information.
+	 */
+
+	if ((!file->f_op->fallocate) || lo->lo_encrypt_key_size)
+		return -EOPNOTSUPP;
+
+	ret = file->f_op->fallocate(file, mode, pos, bio->bi_size);
+	if (unlikely(ret && ret != -EINVAL && ret != -EOPNOTSUPP))
+		ret = -EIO;
 	return ret;
 }
 
@@ -512,7 +546,29 @@ static inline void loop_handle_bio(struct loop_device *lo, struct bio *bio)
 		do_loop_switch(lo, bio->bi_private);
 		bio_put(bio);
 	} else {
-		int ret = do_bio_filebacked(lo, bio);
+		int ret;
+
+		if (bio_rw(bio) == WRITE) {
+			if (bio->bi_rw & REQ_FLUSH) {
+				ret = vfs_fsync(lo->lo_backing_file, 1);
+				if (unlikely(ret && ret != -EINVAL))
+					goto out;
+			}
+			if (bio->bi_rw & REQ_DISCARD) {
+				ret = lo_discard(lo, bio);
+				goto out;
+			}
+		}
+#ifdef CONFIG_AIO
+		if (lo->lo_flags & LO_FLAGS_USE_AIO &&
+		    lo->transfer == transfer_none) {
+			ret = lo_rw_aio(lo, bio);
+			if (ret == 0)
+				return;
+		} else
+#endif
+			ret = do_bio_filebacked(lo, bio);
+out:
 		bio_endio(bio, ret);
 	}
 }
@@ -534,6 +590,12 @@ static int loop_thread(void *data)
 	struct loop_device *lo = data;
 	struct bio *bio;
 
+	/*
+	 * In cases where the underlying filesystem calls balance_dirty_pages()
+	 * we want less throttling to avoid lock ups trying to write dirty
+	 * pages through the loop device
+	 */
+	current->flags |= PF_LESS_THROTTLE;
 	set_user_nice(current, -20);
 
 	while (!kthread_should_stop() || !bio_list_empty(&lo->lo_bio_list)) {
@@ -854,6 +916,14 @@ static int loop_set_fd(struct loop_device *lo, fmode_t mode,
 	    !file->f_op->write)
 		lo_flags |= LO_FLAGS_READ_ONLY;
 
+#ifdef CONFIG_AIO
+	if (file->f_op->write_iter && file->f_op->read_iter &&
+	    mapping->a_ops->direct_IO) {
+		file->f_flags |= O_DIRECT;
+		lo_flags |= LO_FLAGS_USE_AIO;
+	}
+#endif
+
 	lo_blocksize = S_ISBLK(inode->i_mode) ?
 		inode->i_bdev->bd_block_size : PAGE_SIZE;
 
diff --git a/include/uapi/linux/loop.h b/include/uapi/linux/loop.h
index e0cecd2..6edc6b6 100644
--- a/include/uapi/linux/loop.h
+++ b/include/uapi/linux/loop.h
@@ -21,6 +21,7 @@ enum {
 	LO_FLAGS_READ_ONLY	= 1,
 	LO_FLAGS_AUTOCLEAR	= 4,
 	LO_FLAGS_PARTSCAN	= 8,
+	LO_FLAGS_USE_AIO	= 16,
 };
 
 #include <asm/posix_types.h>	/* for __kernel_old_dev_t */
-- 
1.8.0

