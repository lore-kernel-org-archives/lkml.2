Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757153Ab2KVTgd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 14:36:33 -0500
Received: from aserp1050.oracle.com ([141.146.126.70]:33640 "EHLO
	aserp1050.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754426Ab2KVTga (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 14:36:30 -0500
From: Dave Kleikamp <dave.kleikamp@oracle.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Zach Brown <zab@zabbo.net>,
        "Maxim V. Patlasov" <mpatlasov@parallels.com>,
        Dave Kleikamp <dave.kleikamp@oracle.com>
Subject: [PATCH v4 17/31] fs: create file_readable() and file_writable() functions
Date: Wed, 21 Nov 2012 16:40:57 -0600
Message-Id: <1353537671-26284-18-git-send-email-dave.kleikamp@oracle.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1353537671-26284-1-git-send-email-dave.kleikamp@oracle.com>
References: <1353537671-26284-1-git-send-email-dave.kleikamp@oracle.com>
X-Source-IP: aserp1040.oracle.com [141.146.126.69]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Create functions to simplify if file_ops contain either a read
or aio_read op, or likewise write or aio_write. We will be adding
read_iter and write_iter and don't need to be complicating the code
in multiple places.

Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
---
 drivers/mtd/nand/nandsim.c           |  4 ++--
 drivers/staging/ccg/storage_common.c |  4 ++--
 drivers/usb/gadget/storage_common.c  |  4 ++--
 fs/compat.c                          |  4 ++--
 fs/read_write.c                      |  8 ++++----
 include/linux/fs.h                   | 10 ++++++++++
 6 files changed, 22 insertions(+), 12 deletions(-)

diff --git a/drivers/mtd/nand/nandsim.c b/drivers/mtd/nand/nandsim.c
index a932c48..7f88863 100644
--- a/drivers/mtd/nand/nandsim.c
+++ b/drivers/mtd/nand/nandsim.c
@@ -462,12 +462,12 @@ static int alloc_device(struct nandsim *ns)
 		cfile = filp_open(cache_file, O_CREAT | O_RDWR | O_LARGEFILE, 0600);
 		if (IS_ERR(cfile))
 			return PTR_ERR(cfile);
-		if (!cfile->f_op || (!cfile->f_op->read && !cfile->f_op->aio_read)) {
+		if (!file_readable(cfile)) {
 			NS_ERR("alloc_device: cache file not readable\n");
 			err = -EINVAL;
 			goto err_close;
 		}
-		if (!cfile->f_op->write && !cfile->f_op->aio_write) {
+		if (!file_writable(cfile)) {
 			NS_ERR("alloc_device: cache file not writeable\n");
 			err = -EINVAL;
 			goto err_close;
diff --git a/drivers/staging/ccg/storage_common.c b/drivers/staging/ccg/storage_common.c
index 8d9bcd8..d431eff 100644
--- a/drivers/staging/ccg/storage_common.c
+++ b/drivers/staging/ccg/storage_common.c
@@ -666,11 +666,11 @@ static int fsg_lun_open(struct fsg_lun *curlun, const char *filename)
 	 * If we can't read the file, it's no good.
 	 * If we can't write the file, use it read-only.
 	 */
-	if (!(filp->f_op->read || filp->f_op->aio_read)) {
+	if (!file_readable(filp)) {
 		LINFO(curlun, "file not readable: %s\n", filename);
 		goto out;
 	}
-	if (!(filp->f_op->write || filp->f_op->aio_write))
+	if (!file_writable(filp))
 		ro = 1;
 
 	size = i_size_read(inode->i_mapping->host);
diff --git a/drivers/usb/gadget/storage_common.c b/drivers/usb/gadget/storage_common.c
index 8d9bcd8..d431eff 100644
--- a/drivers/usb/gadget/storage_common.c
+++ b/drivers/usb/gadget/storage_common.c
@@ -666,11 +666,11 @@ static int fsg_lun_open(struct fsg_lun *curlun, const char *filename)
 	 * If we can't read the file, it's no good.
 	 * If we can't write the file, use it read-only.
 	 */
-	if (!(filp->f_op->read || filp->f_op->aio_read)) {
+	if (!file_readable(filp)) {
 		LINFO(curlun, "file not readable: %s\n", filename);
 		goto out;
 	}
-	if (!(filp->f_op->write || filp->f_op->aio_write))
+	if (!file_writable(filp))
 		ro = 1;
 
 	size = i_size_read(inode->i_mapping->host);
diff --git a/fs/compat.c b/fs/compat.c
index 015e1e1..7411d66 100644
--- a/fs/compat.c
+++ b/fs/compat.c
@@ -1132,7 +1132,7 @@ static size_t compat_readv(struct file *file,
 		goto out;
 
 	ret = -EINVAL;
-	if (!file->f_op || (!file->f_op->aio_read && !file->f_op->read))
+	if (!file_readable(file))
 		goto out;
 
 	ret = compat_do_readv_writev(READ, file, vec, vlen, pos);
@@ -1198,7 +1198,7 @@ static size_t compat_writev(struct file *file,
 		goto out;
 
 	ret = -EINVAL;
-	if (!file->f_op || (!file->f_op->aio_write && !file->f_op->write))
+	if (!file_writable(file))
 		goto out;
 
 	ret = compat_do_readv_writev(WRITE, file, vec, vlen, pos);
diff --git a/fs/read_write.c b/fs/read_write.c
index d065348..266e172 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -360,7 +360,7 @@ ssize_t vfs_read(struct file *file, char __user *buf, size_t count, loff_t *pos)
 
 	if (!(file->f_mode & FMODE_READ))
 		return -EBADF;
-	if (!file->f_op || (!file->f_op->read && !file->f_op->aio_read))
+	if (!file_readable(file))
 		return -EINVAL;
 	if (unlikely(!access_ok(VERIFY_WRITE, buf, count)))
 		return -EFAULT;
@@ -416,7 +416,7 @@ ssize_t vfs_write(struct file *file, const char __user *buf, size_t count, loff_
 
 	if (!(file->f_mode & FMODE_WRITE))
 		return -EBADF;
-	if (!file->f_op || (!file->f_op->write && !file->f_op->aio_write))
+	if (!file_writable(file))
 		return -EINVAL;
 	if (unlikely(!access_ok(VERIFY_READ, buf, count)))
 		return -EFAULT;
@@ -749,7 +749,7 @@ ssize_t vfs_readv(struct file *file, const struct iovec __user *vec,
 {
 	if (!(file->f_mode & FMODE_READ))
 		return -EBADF;
-	if (!file->f_op || (!file->f_op->aio_read && !file->f_op->read))
+	if (!file_readable(file))
 		return -EINVAL;
 
 	return do_readv_writev(READ, file, vec, vlen, pos);
@@ -762,7 +762,7 @@ ssize_t vfs_writev(struct file *file, const struct iovec __user *vec,
 {
 	if (!(file->f_mode & FMODE_WRITE))
 		return -EBADF;
-	if (!file->f_op || (!file->f_op->aio_write && !file->f_op->write))
+	if (!file_writable(file))
 		return -EINVAL;
 
 	return do_readv_writev(WRITE, file, vec, vlen, pos);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 3d04570..5871910 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1636,6 +1636,16 @@ struct file_operations {
 			  loff_t len);
 };
 
+static inline int file_readable(struct file *filp)
+{
+	return filp && (filp->f_op->read || filp->f_op->aio_read);
+}
+
+static inline int file_writable(struct file *filp)
+{
+	return filp && (filp->f_op->write || filp->f_op->aio_write);
+}
+
 struct inode_operations {
 	struct dentry * (*lookup) (struct inode *,struct dentry *, unsigned int);
 	void * (*follow_link) (struct dentry *, struct nameidata *);
-- 
1.8.0

