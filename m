Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755606Ab2B0VXY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 16:23:24 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:30097 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755291Ab2B0VUZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 16:20:25 -0500
From: Dave Kleikamp <dave.kleikamp@oracle.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Zach Brown <zab@zabbo.net>,
        Dave Kleikamp <dave.kleikamp@oracle.com>
Subject: [RFC PATCH 09/22] dio: add dio_alloc_init() helper function
Date: Mon, 27 Feb 2012 15:19:23 -0600
Message-Id: <1330377576-3659-10-git-send-email-dave.kleikamp@oracle.com>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1330377576-3659-1-git-send-email-dave.kleikamp@oracle.com>
References: <1330377576-3659-1-git-send-email-dave.kleikamp@oracle.com>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-CT-RefId: str=0001.0A090204.4F4BF399.001D,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zach Brown <zab@zabbo.net>

This adds a helper function which allocates and initializes the dio
structure.  We'll be calling this from another entry point like
__blockdev_direct_IO() in an upcoming patch.

Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Cc: Zach Brown <zab@zabbo.net>
---
 fs/direct-io.c |   68 ++++++++++++++++++++++++++++++++++----------------------
 1 file changed, 42 insertions(+), 26 deletions(-)

diff --git a/fs/direct-io.c b/fs/direct-io.c
index 21a1412..1fbb4ab 100644
--- a/fs/direct-io.c
+++ b/fs/direct-io.c
@@ -1096,6 +1096,47 @@ static int dio_aligned(unsigned long offset, unsigned *blkbits,
 	return 1;
 }
 
+static struct dio *dio_alloc_init(int flags, int rw, struct kiocb *iocb,
+				  struct inode *inode, dio_iodone_t end_io,
+				  loff_t end)
+{
+	struct dio *dio;
+
+	dio = kmem_cache_alloc(dio_cache, GFP_KERNEL);
+	if (!dio)
+		return NULL;
+
+	/*
+	 * Believe it or not, zeroing out the page array caused a .5%
+	 * performance regression in a database benchmark.  So, we take
+	 * care to only zero out what's needed.
+	 */
+	memset(dio, 0, offsetof(struct dio, pages));
+
+	dio->flags = flags;
+	/*
+	 * For file extending writes updating i_size before data
+	 * writeouts complete can expose uninitialized blocks. So
+	 * even for AIO, we need to wait for i/o to complete before
+	 * returning in this case.
+	 */
+	dio->is_async = !is_sync_kiocb(iocb) && !((rw & WRITE) &&
+		(end > i_size_read(inode)));
+
+	dio->inode = inode;
+	dio->rw = rw;
+
+	dio->end_io = end_io;
+
+	dio->iocb = iocb;
+	dio->i_size = i_size_read(inode);
+
+	spin_lock_init(&dio->bio_lock);
+	dio->refcount = 1;
+
+	return dio;
+}
+
 /*
  * This is a library function for use by filesystem drivers.
  *
@@ -1158,18 +1199,11 @@ do_blockdev_direct_IO(int rw, struct kiocb *iocb, struct inode *inode,
 	if (rw == READ && end == offset)
 		return 0;
 
-	dio = kmem_cache_alloc(dio_cache, GFP_KERNEL);
+	dio = dio_alloc_init(flags, rw, iocb, inode, end_io, end);
 	retval = -ENOMEM;
 	if (!dio)
 		goto out;
-	/*
-	 * Believe it or not, zeroing out the page array caused a .5%
-	 * performance regression in a database benchmark.  So, we take
-	 * care to only zero out what's needed.
-	 */
-	memset(dio, 0, offsetof(struct dio, pages));
 
-	dio->flags = flags;
 	if (dio->flags & DIO_LOCKING) {
 		if (rw == READ) {
 			struct address_space *mapping =
@@ -1193,35 +1227,17 @@ do_blockdev_direct_IO(int rw, struct kiocb *iocb, struct inode *inode,
 	 */
 	atomic_inc(&inode->i_dio_count);
 
-	/*
-	 * For file extending writes updating i_size before data
-	 * writeouts complete can expose uninitialized blocks. So
-	 * even for AIO, we need to wait for i/o to complete before
-	 * returning in this case.
-	 */
-	dio->is_async = !is_sync_kiocb(iocb) && !((rw & WRITE) &&
-		(end > i_size_read(inode)));
-
 	retval = 0;
 
-	dio->inode = inode;
-	dio->rw = rw;
 	sdio.blkbits = blkbits;
 	sdio.blkfactor = inode->i_blkbits - blkbits;
 	sdio.block_in_file = offset >> blkbits;
 
 	sdio.get_block = get_block;
-	dio->end_io = end_io;
 	sdio.submit_io = submit_io;
 	sdio.final_block_in_bio = -1;
 	sdio.next_block_for_io = -1;
 
-	dio->iocb = iocb;
-	dio->i_size = i_size_read(inode);
-
-	spin_lock_init(&dio->bio_lock);
-	dio->refcount = 1;
-
 	/*
 	 * In case of non-aligned buffers, we may need 2 more
 	 * pages since we need to zero out first and last block.
-- 
1.7.9.2

