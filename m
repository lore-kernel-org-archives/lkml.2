Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755332Ab2B0VU2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 16:20:28 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:33634 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755300Ab2B0VU0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 16:20:26 -0500
From: Dave Kleikamp <dave.kleikamp@oracle.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Zach Brown <zab@zabbo.net>,
        Dave Kleikamp <dave.kleikamp@oracle.com>
Subject: [RFC PATCH 11/22] dio: add dio_lock_and_flush() helper
Date: Mon, 27 Feb 2012 15:19:25 -0600
Message-Id: <1330377576-3659-12-git-send-email-dave.kleikamp@oracle.com>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1330377576-3659-1-git-send-email-dave.kleikamp@oracle.com>
References: <1330377576-3659-1-git-send-email-dave.kleikamp@oracle.com>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090203.4F4BF399.007B,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zach Brown <zab@zabbo.net>

This creates a helper function which performs locking based on
DIO_LOCKING and flushes dirty pages.  This will be called by another
 entry point like __blockdev_direct_IO() in an upcoming patch.

Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Cc: Zach Brown <zab@zabbo.net>
---
 fs/direct-io.c |   56 +++++++++++++++++++++++++++++++++-----------------------
 1 file changed, 33 insertions(+), 23 deletions(-)

diff --git a/fs/direct-io.c b/fs/direct-io.c
index 1efe4f1..e75b8d7 100644
--- a/fs/direct-io.c
+++ b/fs/direct-io.c
@@ -1158,6 +1158,35 @@ static void sdio_init(struct dio_submit *sdio, struct inode *inode,
 		sdio->pages_in_io = 2;
 }
 
+static int dio_lock_and_flush(struct dio *dio, loff_t offset, loff_t end)
+{
+	struct inode *inode = dio->inode;
+	int ret;
+
+	if (dio->flags & DIO_LOCKING) {
+		/* watch out for a 0 len io from a tricksy fs */
+		if (dio->rw == READ && end > offset) {
+
+			/* will be released by do_blockdev_direct_IO */
+			mutex_lock(&inode->i_mutex);
+
+			ret = filemap_write_and_wait_range(inode->i_mapping,
+							      offset, end - 1);
+			if (ret) {
+				mutex_unlock(&inode->i_mutex);
+				return ret;
+			}
+		}
+	}
+
+	/*
+	 * Will be decremented at I/O completion time.
+	 */
+	atomic_inc(&inode->i_dio_count);
+
+	return 0;
+}
+
 /*
  * This is a library function for use by filesystem drivers.
  *
@@ -1225,31 +1254,12 @@ do_blockdev_direct_IO(int rw, struct kiocb *iocb, struct inode *inode,
 	if (!dio)
 		goto out;
 
-	if (dio->flags & DIO_LOCKING) {
-		if (rw == READ) {
-			struct address_space *mapping =
-					iocb->ki_filp->f_mapping;
-
-			/* will be released by direct_io_worker */
-			mutex_lock(&inode->i_mutex);
-
-			retval = filemap_write_and_wait_range(mapping, offset,
-							      end - 1);
-			if (retval) {
-				mutex_unlock(&inode->i_mutex);
-				kmem_cache_free(dio_cache, dio);
-				goto out;
-			}
-		}
+	retval = dio_lock_and_flush(dio, offset, end);
+	if (retval) {
+		kmem_cache_free(dio_cache, dio);
+		goto out;
 	}
 
-	/*
-	 * Will be decremented at I/O completion time.
-	 */
-	atomic_inc(&inode->i_dio_count);
-
-	retval = 0;
-
 	sdio_init(&sdio, inode, offset, blkbits, get_block, submit_io);
 
 	for (seg = 0; seg < nr_segs; seg++) {
-- 
1.7.9.2

