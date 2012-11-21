Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753345Ab2KVSdR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 13:33:17 -0500
Received: from aserp1050.oracle.com ([141.146.126.70]:22556 "EHLO
	aserp1050.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753280Ab2KVSdM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:33:12 -0500
From: Dave Kleikamp <dave.kleikamp@oracle.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Zach Brown <zab@zabbo.net>,
        "Maxim V. Patlasov" <mpatlasov@parallels.com>,
        Dave Kleikamp <dave.kleikamp@oracle.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH v4 18/31] fs: use read_iter and write_iter rather than aio_read and aio_write
Date: Wed, 21 Nov 2012 16:40:58 -0600
Message-Id: <1353537671-26284-19-git-send-email-dave.kleikamp@oracle.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1353537671-26284-1-git-send-email-dave.kleikamp@oracle.com>
References: <1353537671-26284-1-git-send-email-dave.kleikamp@oracle.com>
X-Source-IP: aserp1040.oracle.com [141.146.126.69]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

File systems implementing read_iter & write_iter should not be required
to keep aio_read and aio_write as well. The vfs should always call
read/write_iter if they exist. This will make it easier to remove the
aio_read/write operation in the future.

Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org
---
 fs/aio.c           | 14 +++++++------
 fs/bad_inode.c     | 14 +++++++++++++
 fs/compat.c        |  6 ++++--
 fs/read_write.c    | 58 +++++++++++++++++++++++++++++++++++++++++++++++++-----
 fs/read_write.h    |  4 ++++
 include/linux/fs.h |  6 ++++--
 6 files changed, 87 insertions(+), 15 deletions(-)

diff --git a/fs/aio.c b/fs/aio.c
index 2c03681..08f550a 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -39,6 +39,8 @@
 #include <asm/kmap_types.h>
 #include <asm/uaccess.h>
 
+#include "read_write.h"
+
 #if DEBUG > 1
 #define dprintk		printk
 #else
@@ -1315,10 +1317,10 @@ static ssize_t aio_rw_vect_retry(struct kiocb *iocb)
 
 	if ((iocb->ki_opcode == IOCB_CMD_PREADV) ||
 		(iocb->ki_opcode == IOCB_CMD_PREAD)) {
-		rw_op = file->f_op->aio_read;
+		rw_op = do_aio_read;
 		opcode = IOCB_CMD_PREADV;
 	} else {
-		rw_op = file->f_op->aio_write;
+		rw_op = do_aio_read;
 		opcode = IOCB_CMD_PWRITEV;
 	}
 
@@ -1467,7 +1469,7 @@ static ssize_t aio_setup_iocb(struct kiocb *kiocb, bool compat)
 		if (ret)
 			break;
 		ret = -EINVAL;
-		if (file->f_op->aio_read)
+		if (file->f_op->read_iter || file->f_op->aio_read)
 			kiocb->ki_retry = aio_rw_vect_retry;
 		break;
 	case IOCB_CMD_PWRITE:
@@ -1482,7 +1484,7 @@ static ssize_t aio_setup_iocb(struct kiocb *kiocb, bool compat)
 		if (ret)
 			break;
 		ret = -EINVAL;
-		if (file->f_op->aio_write)
+		if (file->f_op->write_iter || file->f_op->aio_write)
 			kiocb->ki_retry = aio_rw_vect_retry;
 		break;
 	case IOCB_CMD_PREADV:
@@ -1493,7 +1495,7 @@ static ssize_t aio_setup_iocb(struct kiocb *kiocb, bool compat)
 		if (ret)
 			break;
 		ret = -EINVAL;
-		if (file->f_op->aio_read)
+		if (file->f_op->read_iter || file->f_op->aio_read)
 			kiocb->ki_retry = aio_rw_vect_retry;
 		break;
 	case IOCB_CMD_PWRITEV:
@@ -1504,7 +1506,7 @@ static ssize_t aio_setup_iocb(struct kiocb *kiocb, bool compat)
 		if (ret)
 			break;
 		ret = -EINVAL;
-		if (file->f_op->aio_write)
+		if (file->f_op->write_iter || file->f_op->aio_write)
 			kiocb->ki_retry = aio_rw_vect_retry;
 		break;
 	case IOCB_CMD_READ_ITER:
diff --git a/fs/bad_inode.c b/fs/bad_inode.c
index b1342ff..aeee3d5 100644
--- a/fs/bad_inode.c
+++ b/fs/bad_inode.c
@@ -39,12 +39,24 @@ static ssize_t bad_file_aio_read(struct kiocb *iocb, const struct iovec *iov,
 	return -EIO;
 }
 
+static ssize_t bad_file_read_iter(struct kiocb *iocb, struct iov_iter *iter,
+			loff_t pos)
+{
+	return -EIO;
+}
+
 static ssize_t bad_file_aio_write(struct kiocb *iocb, const struct iovec *iov,
 			unsigned long nr_segs, loff_t pos)
 {
 	return -EIO;
 }
 
+static ssize_t bad_file_write_iter(struct kiocb *iocb, struct iov_iter *iter,
+			loff_t pos)
+{
+	return -EIO;
+}
+
 static int bad_file_readdir(struct file *filp, void *dirent, filldir_t filldir)
 {
 	return -EIO;
@@ -151,7 +163,9 @@ static const struct file_operations bad_file_ops =
 	.read		= bad_file_read,
 	.write		= bad_file_write,
 	.aio_read	= bad_file_aio_read,
+	.read_iter	= bad_file_read_iter,
 	.aio_write	= bad_file_aio_write,
+	.write_iter	= bad_file_write_iter,
 	.readdir	= bad_file_readdir,
 	.poll		= bad_file_poll,
 	.unlocked_ioctl	= bad_file_unlocked_ioctl,
diff --git a/fs/compat.c b/fs/compat.c
index 7411d66..545888b 100644
--- a/fs/compat.c
+++ b/fs/compat.c
@@ -1098,10 +1098,12 @@ static ssize_t compat_do_readv_writev(int type, struct file *file,
 	fnv = NULL;
 	if (type == READ) {
 		fn = file->f_op->read;
-		fnv = file->f_op->aio_read;
+		if (file->f_op->aio_read || file->f_op->read_iter)
+			fnv = do_aio_read;
 	} else {
 		fn = (io_fn_t)file->f_op->write;
-		fnv = file->f_op->aio_write;
+		if (file->f_op->aio_write || file->f_op->write_iter)
+			fnv = do_aio_write;
 	}
 
 	if (fnv)
diff --git a/fs/read_write.c b/fs/read_write.c
index 266e172..44d5e9c 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -23,7 +23,7 @@
 const struct file_operations generic_ro_fops = {
 	.llseek		= generic_file_llseek,
 	.read		= do_sync_read,
-	.aio_read	= generic_file_aio_read,
+	.read_iter	= generic_file_read_iter,
 	.mmap		= generic_file_readonly_mmap,
 	.splice_read	= generic_file_splice_read,
 };
@@ -328,6 +328,29 @@ static void wait_on_retry_sync_kiocb(struct kiocb *iocb)
 	__set_current_state(TASK_RUNNING);
 }
 
+ssize_t do_aio_read(struct kiocb *kiocb, const struct iovec *iov,
+		    unsigned long nr_segs, loff_t pos)
+{
+	struct file *file = kiocb->ki_filp;
+
+	if (file->f_op->read_iter) {
+		size_t count;
+		struct iov_iter iter;
+		int ret;
+
+		count = 0;
+		ret = generic_segment_checks(iov, &nr_segs, &count,
+					     VERIFY_WRITE);
+		if (ret)
+			return ret;
+
+		iov_iter_init(&iter, iov, nr_segs, count, 0);
+		return file->f_op->read_iter(kiocb, &iter, pos);
+	}
+
+	return file->f_op->aio_read(kiocb, iov, nr_segs, pos);
+}
+
 ssize_t do_sync_read(struct file *filp, char __user *buf, size_t len, loff_t *ppos)
 {
 	struct iovec iov = { .iov_base = buf, .iov_len = len };
@@ -340,7 +363,7 @@ ssize_t do_sync_read(struct file *filp, char __user *buf, size_t len, loff_t *pp
 	kiocb.ki_nbytes = len;
 
 	for (;;) {
-		ret = filp->f_op->aio_read(&kiocb, &iov, 1, kiocb.ki_pos);
+		ret = do_aio_read(&kiocb, &iov, 1, kiocb.ki_pos);
 		if (ret != -EIOCBRETRY)
 			break;
 		wait_on_retry_sync_kiocb(&kiocb);
@@ -384,6 +407,29 @@ ssize_t vfs_read(struct file *file, char __user *buf, size_t count, loff_t *pos)
 
 EXPORT_SYMBOL(vfs_read);
 
+ssize_t do_aio_write(struct kiocb *kiocb, const struct iovec *iov,
+		     unsigned long nr_segs, loff_t pos)
+{
+	struct file *file = kiocb->ki_filp;
+
+	if (file->f_op->write_iter) {
+		size_t count;
+		struct iov_iter iter;
+		int ret;
+
+		count = 0;
+		ret = generic_segment_checks(iov, &nr_segs, &count,
+					     VERIFY_READ);
+		if (ret)
+			return ret;
+
+		iov_iter_init(&iter, iov, nr_segs, count, 0);
+		return file->f_op->write_iter(kiocb, &iter, pos);
+	}
+
+	return file->f_op->aio_write(kiocb, iov, nr_segs, pos);
+}
+
 ssize_t do_sync_write(struct file *filp, const char __user *buf, size_t len, loff_t *ppos)
 {
 	struct iovec iov = { .iov_base = (void __user *)buf, .iov_len = len };
@@ -396,7 +442,7 @@ ssize_t do_sync_write(struct file *filp, const char __user *buf, size_t len, lof
 	kiocb.ki_nbytes = len;
 
 	for (;;) {
-		ret = filp->f_op->aio_write(&kiocb, &iov, 1, kiocb.ki_pos);
+		ret = do_aio_write(&kiocb, &iov, 1, kiocb.ki_pos);
 		if (ret != -EIOCBRETRY)
 			break;
 		wait_on_retry_sync_kiocb(&kiocb);
@@ -720,10 +766,12 @@ static ssize_t do_readv_writev(int type, struct file *file,
 	fnv = NULL;
 	if (type == READ) {
 		fn = file->f_op->read;
-		fnv = file->f_op->aio_read;
+		if (file->f_op->aio_read || file->f_op->read_iter)
+			fnv = do_aio_read;
 	} else {
 		fn = (io_fn_t)file->f_op->write;
-		fnv = file->f_op->aio_write;
+		if (file->f_op->aio_write || file->f_op->write_iter)
+			fnv = do_aio_write;
 	}
 
 	if (fnv)
diff --git a/fs/read_write.h b/fs/read_write.h
index d3e00ef..4f00eb7 100644
--- a/fs/read_write.h
+++ b/fs/read_write.h
@@ -8,6 +8,10 @@ typedef ssize_t (*io_fn_t)(struct file *, char __user *, size_t, loff_t *);
 typedef ssize_t (*iov_fn_t)(struct kiocb *, const struct iovec *,
 		unsigned long, loff_t);
 
+ssize_t do_aio_read(struct kiocb *kiocb, const struct iovec *iov,
+		unsigned long nr_segs, loff_t pos);
+ssize_t do_aio_write(struct kiocb *kiocb, const struct iovec *iov,
+		unsigned long nr_segs, loff_t pos);
 ssize_t do_sync_readv_writev(struct file *filp, const struct iovec *iov,
 		unsigned long nr_segs, size_t len, loff_t *ppos, iov_fn_t fn);
 ssize_t do_loop_readv_writev(struct file *filp, struct iovec *iov,
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 5871910..e0960bd 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1638,12 +1638,14 @@ struct file_operations {
 
 static inline int file_readable(struct file *filp)
 {
-	return filp && (filp->f_op->read || filp->f_op->aio_read);
+	return filp && (filp->f_op->read || filp->f_op->aio_read ||
+			filp->f_op->read_iter);
 }
 
 static inline int file_writable(struct file *filp)
 {
-	return filp && (filp->f_op->write || filp->f_op->aio_write);
+	return filp && (filp->f_op->write || filp->f_op->aio_write ||
+			filp->f_op->write_iter);
 }
 
 struct inode_operations {
-- 
1.8.0

