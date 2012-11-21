Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932400Ab2KVTJH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 14:09:07 -0500
Received: from aserp1050.oracle.com ([141.146.126.70]:18768 "EHLO
	aserp1050.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932273Ab2KVTJD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 14:09:03 -0500
From: Dave Kleikamp <dave.kleikamp@oracle.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Zach Brown <zab@zabbo.net>,
        "Maxim V. Patlasov" <mpatlasov@parallels.com>,
        Dave Kleikamp <dave.kleikamp@oracle.com>
Subject: [PATCH v4 14/31] aio: add aio support for iov_iter arguments
Date: Wed, 21 Nov 2012 16:40:54 -0600
Message-Id: <1353537671-26284-15-git-send-email-dave.kleikamp@oracle.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1353537671-26284-1-git-send-email-dave.kleikamp@oracle.com>
References: <1353537671-26284-1-git-send-email-dave.kleikamp@oracle.com>
X-Source-IP: aserp1040.oracle.com [141.146.126.69]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zach Brown <zab@zabbo.net>

This adds iocb cmds which specify that memory is held in iov_iter
structures.  This lets kernel callers specify memory that can be
expressed in an iov_iter, which includes pages in bio_vec arrays.

Only kernel callers can provide an iov_iter so it doesn't make a lot of
sense to expose the IOCB_CMD values for this as part of the user space
ABI.

But kernel callers should also be able to perform the usual aio
operations which suggests using the the existing operation namespace and
support code.

Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Cc: Zach Brown <zab@zabbo.net>
---
 fs/aio.c                     | 64 ++++++++++++++++++++++++++++++++++++++++++++
 include/linux/aio.h          |  3 +++
 include/uapi/linux/aio_abi.h |  2 ++
 3 files changed, 69 insertions(+)

diff --git a/fs/aio.c b/fs/aio.c
index 9a1a6fc..2c03681 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -1424,6 +1424,26 @@ static ssize_t aio_setup_single_vector(int type, struct file * file, struct kioc
 	return 0;
 }
 
+static ssize_t aio_read_iter(struct kiocb *iocb)
+{
+	struct file *file = iocb->ki_filp;
+	ssize_t ret = -EINVAL;
+
+	if (file->f_op->read_iter)
+		ret = file->f_op->read_iter(iocb, iocb->ki_iter, iocb->ki_pos);
+	return ret;
+}
+
+static ssize_t aio_write_iter(struct kiocb *iocb)
+{
+	struct file *file = iocb->ki_filp;
+	ssize_t ret = -EINVAL;
+
+	if (file->f_op->write_iter)
+		ret = file->f_op->write_iter(iocb, iocb->ki_iter, iocb->ki_pos);
+	return ret;
+}
+
 /*
  * aio_setup_iocb:
  *	Performs the initial checks and aio retry method
@@ -1487,6 +1507,34 @@ static ssize_t aio_setup_iocb(struct kiocb *kiocb, bool compat)
 		if (file->f_op->aio_write)
 			kiocb->ki_retry = aio_rw_vect_retry;
 		break;
+	case IOCB_CMD_READ_ITER:
+		ret = -EINVAL;
+		if (unlikely(!is_kernel_kiocb(kiocb)))
+			break;
+		ret = -EBADF;
+		if (unlikely(!(file->f_mode & FMODE_READ)))
+			break;
+		ret = security_file_permission(file, MAY_READ);
+		if (unlikely(ret))
+			break;
+		ret = -EINVAL;
+		if (file->f_op->read_iter)
+			kiocb->ki_retry = aio_read_iter;
+		break;
+	case IOCB_CMD_WRITE_ITER:
+		ret = -EINVAL;
+		if (unlikely(!is_kernel_kiocb(kiocb)))
+			break;
+		ret = -EBADF;
+		if (unlikely(!(file->f_mode & FMODE_WRITE)))
+			break;
+		ret = security_file_permission(file, MAY_WRITE);
+		if (unlikely(ret))
+			break;
+		ret = -EINVAL;
+		if (file->f_op->write_iter)
+			kiocb->ki_retry = aio_write_iter;
+		break;
 	case IOCB_CMD_FDSYNC:
 		ret = -EINVAL;
 		if (file->f_op->aio_fsync)
@@ -1553,6 +1601,22 @@ void aio_kernel_init_rw(struct kiocb *iocb, struct file *filp,
 }
 EXPORT_SYMBOL_GPL(aio_kernel_init_rw);
 
+/*
+ * The iter count must be set before calling here.  Some filesystems uses
+ * iocb->ki_left as an indicator of the size of an IO.
+ */
+void aio_kernel_init_iter(struct kiocb *iocb, struct file *filp,
+			  unsigned short op, struct iov_iter *iter, loff_t off)
+{
+	iocb->ki_filp = filp;
+	iocb->ki_iter = iter;
+	iocb->ki_opcode = op;
+	iocb->ki_pos = off;
+	iocb->ki_nbytes = iov_iter_count(iter);
+	iocb->ki_left = iocb->ki_nbytes;
+}
+EXPORT_SYMBOL_GPL(aio_kernel_init_iter);
+
 void aio_kernel_init_callback(struct kiocb *iocb,
 			      void (*complete)(u64 user_data, long res),
 			      u64 user_data)
diff --git a/include/linux/aio.h b/include/linux/aio.h
index f9e0292..2598e6c 100644
--- a/include/linux/aio.h
+++ b/include/linux/aio.h
@@ -126,6 +126,7 @@ struct kiocb {
 	 * this is the underlying eventfd context to deliver events to.
 	 */
 	struct eventfd_ctx	*ki_eventfd;
+	struct iov_iter		*ki_iter;
 };
 
 static inline bool is_sync_kiocb(struct kiocb *kiocb)
@@ -229,6 +230,8 @@ struct kiocb *aio_kernel_alloc(gfp_t gfp);
 void aio_kernel_free(struct kiocb *iocb);
 void aio_kernel_init_rw(struct kiocb *iocb, struct file *filp,
 			unsigned short op, void *ptr, size_t nr, loff_t off);
+void aio_kernel_init_iter(struct kiocb *iocb, struct file *filp,
+			  unsigned short op, struct iov_iter *iter, loff_t off);
 void aio_kernel_init_callback(struct kiocb *iocb,
 			      void (*complete)(u64 user_data, long res),
 			      u64 user_data);
diff --git a/include/uapi/linux/aio_abi.h b/include/uapi/linux/aio_abi.h
index 86fa7a7..bd39bb2 100644
--- a/include/uapi/linux/aio_abi.h
+++ b/include/uapi/linux/aio_abi.h
@@ -44,6 +44,8 @@ enum {
 	IOCB_CMD_NOOP = 6,
 	IOCB_CMD_PREADV = 7,
 	IOCB_CMD_PWRITEV = 8,
+	IOCB_CMD_READ_ITER = 9,
+	IOCB_CMD_WRITE_ITER = 10,
 };
 
 /*
-- 
1.8.0

