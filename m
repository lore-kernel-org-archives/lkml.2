Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934418Ab2C3PrU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 11:47:20 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:46961 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933922Ab2C3Pob (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 11:44:31 -0400
From: Dave Kleikamp <dave.kleikamp@oracle.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Zach Brown <zab@zabbo.net>,
        Dave Kleikamp <dave.kleikamp@oracle.com>
Subject: [RFC PATCH v2 15/21] loop: use aio to perform io on the underlying file
Date: Fri, 30 Mar 2012 10:43:42 -0500
Message-Id: <1333122228-13633-16-git-send-email-dave.kleikamp@oracle.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1333122228-13633-1-git-send-email-dave.kleikamp@oracle.com>
References: <1333122228-13633-1-git-send-email-dave.kleikamp@oracle.com>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090207.4F75D4DE.00B6,ss=1,re=0.000,fgs=0
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
 drivers/block/loop.c |   55 +++++++++++++++++++++++++++++++++++++++++++++++++-
 include/linux/loop.h |    1 +
 2 files changed, 55 insertions(+), 1 deletion(-)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index cd50435..cdc34e1 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -76,6 +76,7 @@
 #include <linux/sysfs.h>
 #include <linux/miscdevice.h>
 #include <linux/falloc.h>
+#include <linux/aio.h>
 
 #include <asm/uaccess.h>
 
@@ -213,6 +214,46 @@ lo_do_transfer(struct loop_device *lo, int cmd,
 	return lo->transfer(lo, cmd, rpage, roffs, lpage, loffs, size, rblock);
 }
 
+void lo_rw_aio_complete(u64 data, long res)
+{
+	struct bio *bio = (struct bio *)data;
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
+	aio_kernel_init_callback(iocb, lo_rw_aio_complete, (u64)bio);
+
+	return aio_kernel_submit(iocb);
+}
+
 /**
  * __do_lo_send_write - helper for writing data to a loop device
  *
@@ -512,7 +553,14 @@ static inline void loop_handle_bio(struct loop_device *lo, struct bio *bio)
 		do_loop_switch(lo, bio->bi_private);
 		bio_put(bio);
 	} else {
-		int ret = do_bio_filebacked(lo, bio);
+		int ret;
+		if (lo->lo_flags & LO_FLAGS_USE_AIO &&
+		    lo->transfer == transfer_none) {
+			ret = lo_rw_aio(lo, bio);
+			if (ret == 0)
+				return;
+		} else
+			ret = do_bio_filebacked(lo, bio);
 		bio_endio(bio, ret);
 	}
 }
@@ -854,6 +902,11 @@ static int loop_set_fd(struct loop_device *lo, fmode_t mode,
 	    !file->f_op->write)
 		lo_flags |= LO_FLAGS_READ_ONLY;
 
+	if (file->f_op->write_iter && file->f_op->read_iter) {
+		file->f_flags |= O_DIRECT;
+		lo_flags |= LO_FLAGS_USE_AIO;
+	}
+
 	lo_blocksize = S_ISBLK(inode->i_mode) ?
 		inode->i_bdev->bd_block_size : PAGE_SIZE;
 
diff --git a/include/linux/loop.h b/include/linux/loop.h
index 11a41a8..5163fd3 100644
--- a/include/linux/loop.h
+++ b/include/linux/loop.h
@@ -75,6 +75,7 @@ enum {
 	LO_FLAGS_READ_ONLY	= 1,
 	LO_FLAGS_AUTOCLEAR	= 4,
 	LO_FLAGS_PARTSCAN	= 8,
+	LO_FLAGS_USE_AIO	= 16,
 };
 
 #include <asm/posix_types.h>	/* for __kernel_old_dev_t */
-- 
1.7.9.5

