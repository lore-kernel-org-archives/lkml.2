Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932547Ab3AIT7O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 14:59:14 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:33175 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932523Ab3AIT7L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 14:59:11 -0500
From: Dave Kleikamp <dave.kleikamp@oracle.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Zach Brown <zab@zabbo.net>,
        "Maxim V. Patlasov" <mpatlasov@parallels.com>,
        Dave Kleikamp <dave.kleikamp@oracle.com>, Ben Myers <bpm@sgi.com>,
        Alex Elder <elder@kernel.org>, xfs@oss.sgi.com
Subject: [PATCH V5 25/30] xfs: add support for read_iter and write_iter
Date: Wed,  9 Jan 2013 13:58:40 -0600
Message-Id: <1357761525-22718-26-git-send-email-dave.kleikamp@oracle.com>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1357761525-22718-1-git-send-email-dave.kleikamp@oracle.com>
References: <1357761525-22718-1-git-send-email-dave.kleikamp@oracle.com>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Cc: Ben Myers <bpm@sgi.com>
Cc: Alex Elder <elder@kernel.org>
Cc: xfs@oss.sgi.com
---
 fs/xfs/xfs_file.c | 51 ++++++++++++++++++++-------------------------------
 1 file changed, 20 insertions(+), 31 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 67284ed..c5d74e8 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -225,10 +225,9 @@ xfs_file_fsync(
 }
 
 STATIC ssize_t
-xfs_file_aio_read(
+xfs_file_read_iter(
 	struct kiocb		*iocb,
-	const struct iovec	*iovp,
-	unsigned long		nr_segs,
+	struct iov_iter		*iter,
 	loff_t			pos)
 {
 	struct file		*file = iocb->ki_filp;
@@ -249,9 +248,7 @@ xfs_file_aio_read(
 	if (file->f_mode & FMODE_NOCMTIME)
 		ioflags |= IO_INVIS;
 
-	ret = generic_segment_checks(iovp, &nr_segs, &size, VERIFY_WRITE);
-	if (ret < 0)
-		return ret;
+	size = iov_iter_count(iter);
 
 	if (unlikely(ioflags & IO_ISDIRECT)) {
 		xfs_buftarg_t	*target =
@@ -304,7 +301,7 @@ xfs_file_aio_read(
 
 	trace_xfs_file_read(ip, size, pos, ioflags);
 
-	ret = generic_file_aio_read(iocb, iovp, nr_segs, pos);
+	ret = generic_file_read_iter(iocb, iter, pos);
 	if (ret > 0)
 		XFS_STATS_ADD(xs_read_bytes, ret);
 
@@ -620,10 +617,9 @@ restart:
 STATIC ssize_t
 xfs_file_dio_aio_write(
 	struct kiocb		*iocb,
-	const struct iovec	*iovp,
-	unsigned long		nr_segs,
+	struct iov_iter		*iter,
 	loff_t			pos,
-	size_t			ocount)
+	size_t			count)
 {
 	struct file		*file = iocb->ki_filp;
 	struct address_space	*mapping = file->f_mapping;
@@ -631,7 +627,6 @@ xfs_file_dio_aio_write(
 	struct xfs_inode	*ip = XFS_I(inode);
 	struct xfs_mount	*mp = ip->i_mount;
 	ssize_t			ret = 0;
-	size_t			count = ocount;
 	int			unaligned_io = 0;
 	int			iolock;
 	struct xfs_buftarg	*target = XFS_IS_REALTIME_INODE(ip) ?
@@ -691,8 +686,8 @@ xfs_file_dio_aio_write(
 	}
 
 	trace_xfs_file_direct_write(ip, count, iocb->ki_pos, 0);
-	ret = generic_file_direct_write(iocb, iovp,
-			&nr_segs, pos, &iocb->ki_pos, count, ocount);
+	ret = generic_file_direct_write_iter(iocb, iter,
+			pos, &iocb->ki_pos, count);
 
 out:
 	xfs_rw_iunlock(ip, iolock);
@@ -705,10 +700,9 @@ out:
 STATIC ssize_t
 xfs_file_buffered_aio_write(
 	struct kiocb		*iocb,
-	const struct iovec	*iovp,
-	unsigned long		nr_segs,
+	struct iov_iter		*iter,
 	loff_t			pos,
-	size_t			ocount)
+	size_t			count)
 {
 	struct file		*file = iocb->ki_filp;
 	struct address_space	*mapping = file->f_mapping;
@@ -717,7 +711,6 @@ xfs_file_buffered_aio_write(
 	ssize_t			ret;
 	int			enospc = 0;
 	int			iolock = XFS_IOLOCK_EXCL;
-	size_t			count = ocount;
 
 	xfs_rw_ilock(ip, iolock);
 
@@ -730,7 +723,7 @@ xfs_file_buffered_aio_write(
 
 write_retry:
 	trace_xfs_file_buffered_write(ip, count, iocb->ki_pos, 0);
-	ret = generic_file_buffered_write(iocb, iovp, nr_segs,
+	ret = generic_file_buffered_write_iter(iocb, iter,
 			pos, &iocb->ki_pos, count, 0);
 
 	/*
@@ -751,10 +744,9 @@ out:
 }
 
 STATIC ssize_t
-xfs_file_aio_write(
+xfs_file_write_iter(
 	struct kiocb		*iocb,
-	const struct iovec	*iovp,
-	unsigned long		nr_segs,
+	struct iov_iter		*iter,
 	loff_t			pos)
 {
 	struct file		*file = iocb->ki_filp;
@@ -762,17 +754,15 @@ xfs_file_aio_write(
 	struct inode		*inode = mapping->host;
 	struct xfs_inode	*ip = XFS_I(inode);
 	ssize_t			ret;
-	size_t			ocount = 0;
+	size_t			count = 0;
 
 	XFS_STATS_INC(xs_write_calls);
 
 	BUG_ON(iocb->ki_pos != pos);
 
-	ret = generic_segment_checks(iovp, &nr_segs, &ocount, VERIFY_READ);
-	if (ret)
-		return ret;
+	count = iov_iter_count(iter);
 
-	if (ocount == 0)
+	if (count == 0)
 		return 0;
 
 	sb_start_write(inode->i_sb);
@@ -783,10 +773,9 @@ xfs_file_aio_write(
 	}
 
 	if (unlikely(file->f_flags & O_DIRECT))
-		ret = xfs_file_dio_aio_write(iocb, iovp, nr_segs, pos, ocount);
+		ret = xfs_file_dio_aio_write(iocb, iter, pos, count);
 	else
-		ret = xfs_file_buffered_aio_write(iocb, iovp, nr_segs, pos,
-						  ocount);
+		ret = xfs_file_buffered_aio_write(iocb, iter, pos, count);
 
 	if (ret > 0) {
 		ssize_t err;
@@ -1416,8 +1405,8 @@ const struct file_operations xfs_file_operations = {
 	.llseek		= xfs_file_llseek,
 	.read		= do_sync_read,
 	.write		= do_sync_write,
-	.aio_read	= xfs_file_aio_read,
-	.aio_write	= xfs_file_aio_write,
+	.read_iter	= xfs_file_read_iter,
+	.write_iter	= xfs_file_write_iter,
 	.splice_read	= xfs_file_splice_read,
 	.splice_write	= xfs_file_splice_write,
 	.unlocked_ioctl	= xfs_file_ioctl,
-- 
1.8.1

