Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965128Ab2KVTRG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 14:17:06 -0500
Received: from aserp1050.oracle.com ([141.146.126.70]:27996 "EHLO
	aserp1050.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965071Ab2KVTQ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 14:16:58 -0500
From: Dave Kleikamp <dave.kleikamp@oracle.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Zach Brown <zab@zabbo.net>,
        "Maxim V. Patlasov" <mpatlasov@parallels.com>,
        Dave Kleikamp <dave.kleikamp@oracle.com>,
        Tyler Hicks <tyhicks@canonical.com>,
        Dustin Kirkland <dustin.kirkland@gazzang.com>,
        ecryptfs@vger.kernel.org
Subject: [PATCH v4 30/31] ecrpytfs: Convert aio_read/write ops to read/write_iter
Date: Wed, 21 Nov 2012 16:41:10 -0600
Message-Id: <1353537671-26284-31-git-send-email-dave.kleikamp@oracle.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1353537671-26284-1-git-send-email-dave.kleikamp@oracle.com>
References: <1353537671-26284-1-git-send-email-dave.kleikamp@oracle.com>
X-Source-IP: aserp1040.oracle.com [141.146.126.69]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Cc: Tyler Hicks <tyhicks@canonical.com>
Cc: Dustin Kirkland <dustin.kirkland@gazzang.com>
Cc: ecryptfs@vger.kernel.org
---
 fs/ecryptfs/file.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/fs/ecryptfs/file.c b/fs/ecryptfs/file.c
index d45ba45..5aaa180 100644
--- a/fs/ecryptfs/file.c
+++ b/fs/ecryptfs/file.c
@@ -36,22 +36,21 @@
 /**
  * ecryptfs_read_update_atime
  *
- * generic_file_read updates the atime of upper layer inode.  But, it
+ * generic_file_read_iter updates the atime of upper layer inode.  But, it
  * doesn't give us a chance to update the atime of the lower layer
- * inode.  This function is a wrapper to generic_file_read.  It
- * updates the atime of the lower level inode if generic_file_read
+ * inode.  This function is a wrapper to generic_file_read_iter.  It
+ * updates the atime of the lower level inode if generic_file_read_iter
  * returns without any errors. This is to be used only for file reads.
  * The function to be used for directory reads is ecryptfs_read.
  */
 static ssize_t ecryptfs_read_update_atime(struct kiocb *iocb,
-				const struct iovec *iov,
-				unsigned long nr_segs, loff_t pos)
+				struct iov_iter *iter, loff_t pos)
 {
 	ssize_t rc;
 	struct path lower;
 	struct file *file = iocb->ki_filp;
 
-	rc = generic_file_aio_read(iocb, iov, nr_segs, pos);
+	rc = generic_file_read_iter(iocb, iter, pos);
 	/*
 	 * Even though this is a async interface, we need to wait
 	 * for IO to finish to update atime
@@ -357,9 +356,9 @@ const struct file_operations ecryptfs_dir_fops = {
 const struct file_operations ecryptfs_main_fops = {
 	.llseek = generic_file_llseek,
 	.read = do_sync_read,
-	.aio_read = ecryptfs_read_update_atime,
+	.read_iter = ecryptfs_read_update_atime,
 	.write = do_sync_write,
-	.aio_write = generic_file_aio_write,
+	.write_iter = generic_file_write_iter,
 	.readdir = ecryptfs_readdir,
 	.unlocked_ioctl = ecryptfs_unlocked_ioctl,
 #ifdef CONFIG_COMPAT
-- 
1.8.0

