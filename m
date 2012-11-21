Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932273Ab2KVTJJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 14:09:09 -0500
Received: from aserp1050.oracle.com ([141.146.126.70]:18701 "EHLO
	aserp1050.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756425Ab2KVTIH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 14:08:07 -0500
From: Dave Kleikamp <dave.kleikamp@oracle.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Zach Brown <zab@zabbo.net>,
        "Maxim V. Patlasov" <mpatlasov@parallels.com>,
        Dave Kleikamp <dave.kleikamp@oracle.com>,
        Steven Whitehouse <swhiteho@redhat.com>, cluster-devel@redhat.com
Subject: [PATCH v4 27/31] gfs2: Convert aio_read/write ops to read/write_iter
Date: Wed, 21 Nov 2012 16:41:07 -0600
Message-Id: <1353537671-26284-28-git-send-email-dave.kleikamp@oracle.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1353537671-26284-1-git-send-email-dave.kleikamp@oracle.com>
References: <1353537671-26284-1-git-send-email-dave.kleikamp@oracle.com>
X-Source-IP: aserp1040.oracle.com [141.146.126.69]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Cc: Steven Whitehouse <swhiteho@redhat.com>
Cc: cluster-devel@redhat.com
---
 fs/gfs2/file.c | 21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff --git a/fs/gfs2/file.c b/fs/gfs2/file.c
index e056b4c..bcea69e 100644
--- a/fs/gfs2/file.c
+++ b/fs/gfs2/file.c
@@ -655,10 +655,9 @@ static int gfs2_fsync(struct file *file, loff_t start, loff_t end,
 }
 
 /**
- * gfs2_file_aio_write - Perform a write to a file
+ * gfs2_file_write_iter - Perform a write to a file
  * @iocb: The io context
- * @iov: The data to write
- * @nr_segs: Number of @iov segments
+ * @iter: The data to write
  * @pos: The file position
  *
  * We have to do a lock/unlock here to refresh the inode size for
@@ -668,11 +667,11 @@ static int gfs2_fsync(struct file *file, loff_t start, loff_t end,
  *
  */
 
-static ssize_t gfs2_file_aio_write(struct kiocb *iocb, const struct iovec *iov,
-				   unsigned long nr_segs, loff_t pos)
+static ssize_t gfs2_file_write_iter(struct kiocb *iocb, struct iov_iter *iter,
+				    loff_t pos)
 {
 	struct file *file = iocb->ki_filp;
-	size_t writesize = iov_length(iov, nr_segs);
+	size_t writesize = iov_iter_count(iter);
 	struct dentry *dentry = file->f_dentry;
 	struct gfs2_inode *ip = GFS2_I(dentry->d_inode);
 	int ret;
@@ -692,7 +691,7 @@ static ssize_t gfs2_file_aio_write(struct kiocb *iocb, const struct iovec *iov,
 		gfs2_glock_dq_uninit(&gh);
 	}
 
-	return generic_file_aio_write(iocb, iov, nr_segs, pos);
+	return generic_file_write_iter(iocb, iter, pos);
 }
 
 static int fallocate_chunk(struct inode *inode, loff_t offset, loff_t len,
@@ -1021,9 +1020,9 @@ static int gfs2_flock(struct file *file, int cmd, struct file_lock *fl)
 const struct file_operations gfs2_file_fops = {
 	.llseek		= gfs2_llseek,
 	.read		= do_sync_read,
-	.aio_read	= generic_file_aio_read,
+	.read_iter	= generic_file_read_iter,
 	.write		= do_sync_write,
-	.aio_write	= gfs2_file_aio_write,
+	.write_iter	= gfs2_file_write_iter,
 	.unlocked_ioctl	= gfs2_ioctl,
 	.mmap		= gfs2_mmap,
 	.open		= gfs2_open,
@@ -1053,9 +1052,9 @@ const struct file_operations gfs2_dir_fops = {
 const struct file_operations gfs2_file_fops_nolock = {
 	.llseek		= gfs2_llseek,
 	.read		= do_sync_read,
-	.aio_read	= generic_file_aio_read,
+	.read_iter	= generic_file_read_iter,
 	.write		= do_sync_write,
-	.aio_write	= gfs2_file_aio_write,
+	.write_iter	= gfs2_file_write_iter,
 	.unlocked_ioctl	= gfs2_ioctl,
 	.mmap		= gfs2_mmap,
 	.open		= gfs2_open,
-- 
1.8.0

