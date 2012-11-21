Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755740Ab2KVSrp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 13:47:45 -0500
Received: from userp1050.oracle.com ([156.151.31.82]:18845 "EHLO
	userp1050.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932071Ab2KVSrl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:47:41 -0500
From: Dave Kleikamp <dave.kleikamp@oracle.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Zach Brown <zab@zabbo.net>,
        "Maxim V. Patlasov" <mpatlasov@parallels.com>,
        Dave Kleikamp <dave.kleikamp@oracle.com>, Jan Kara <jack@suse.cz>
Subject: [PATCH v4 28/31] udf: convert file ops from aio_read/write to read/write_iter
Date: Wed, 21 Nov 2012 16:41:08 -0600
Message-Id: <1353537671-26284-29-git-send-email-dave.kleikamp@oracle.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1353537671-26284-1-git-send-email-dave.kleikamp@oracle.com>
References: <1353537671-26284-1-git-send-email-dave.kleikamp@oracle.com>
X-Source-IP: userp1040.oracle.com [156.151.31.81]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Cc: Jan Kara <jack@suse.cz>
---
 fs/udf/file.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/udf/file.c b/fs/udf/file.c
index c4164dc..a5d69c0 100644
--- a/fs/udf/file.c
+++ b/fs/udf/file.c
@@ -133,8 +133,8 @@ const struct address_space_operations udf_adinicb_aops = {
 	.direct_IO	= udf_adinicb_direct_IO,
 };
 
-static ssize_t udf_file_aio_write(struct kiocb *iocb, const struct iovec *iov,
-				  unsigned long nr_segs, loff_t ppos)
+static ssize_t udf_file_write_iter(struct kiocb *iocb, struct iov_iter *iter,
+				   loff_t ppos)
 {
 	ssize_t retval;
 	struct file *file = iocb->ki_filp;
@@ -168,7 +168,7 @@ static ssize_t udf_file_aio_write(struct kiocb *iocb, const struct iovec *iov,
 	} else
 		up_write(&iinfo->i_data_sem);
 
-	retval = generic_file_aio_write(iocb, iov, nr_segs, ppos);
+	retval = generic_file_write_iter(iocb, iter, ppos);
 	if (retval > 0)
 		mark_inode_dirty(inode);
 
@@ -242,12 +242,12 @@ static int udf_release_file(struct inode *inode, struct file *filp)
 
 const struct file_operations udf_file_operations = {
 	.read			= do_sync_read,
-	.aio_read		= generic_file_aio_read,
+	.read_iter		= generic_file_read_iter,
 	.unlocked_ioctl		= udf_ioctl,
 	.open			= generic_file_open,
 	.mmap			= generic_file_mmap,
 	.write			= do_sync_write,
-	.aio_write		= udf_file_aio_write,
+	.write_iter		= udf_file_write_iter,
 	.release		= udf_release_file,
 	.fsync			= generic_file_fsync,
 	.splice_read		= generic_file_splice_read,
-- 
1.8.0

