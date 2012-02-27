Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755539Ab2B0VXT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 16:23:19 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:33632 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755296Ab2B0VUZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 16:20:25 -0500
From: Dave Kleikamp <dave.kleikamp@oracle.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Zach Brown <zab@zabbo.net>,
        Dave Kleikamp <dave.kleikamp@oracle.com>
Subject: [RFC PATCH 10/22] dio: add sdio_init() helper function
Date: Mon, 27 Feb 2012 15:19:24 -0600
Message-Id: <1330377576-3659-11-git-send-email-dave.kleikamp@oracle.com>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1330377576-3659-1-git-send-email-dave.kleikamp@oracle.com>
References: <1330377576-3659-1-git-send-email-dave.kleikamp@oracle.com>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090205.4F4BF399.0053,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zach Brown <zab@zabbo.net>

This adds a helper function which initializes the sdio structure.
We'll be calling this from another entry point in an upcoming patch.

Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Cc: Zach Brown <zab@zabbo.net>
---
 fs/direct-io.c |   37 ++++++++++++++++++++++---------------
 1 file changed, 22 insertions(+), 15 deletions(-)

diff --git a/fs/direct-io.c b/fs/direct-io.c
index 1fbb4ab..1efe4f1 100644
--- a/fs/direct-io.c
+++ b/fs/direct-io.c
@@ -1137,6 +1137,27 @@ static struct dio *dio_alloc_init(int flags, int rw, struct kiocb *iocb,
 	return dio;
 }
 
+static void sdio_init(struct dio_submit *sdio, struct inode *inode,
+		      loff_t offset, unsigned blkbits, get_block_t get_block,
+		      dio_submit_t *submit_io)
+{
+	sdio->blkbits = blkbits;
+	sdio->blkfactor = inode->i_blkbits - blkbits;
+	sdio->block_in_file = offset >> blkbits;
+
+	sdio->get_block = get_block;
+	sdio->submit_io = submit_io;
+	sdio->final_block_in_bio = -1;
+	sdio->next_block_for_io = -1;
+
+	/*
+	 * In case of non-aligned buffers, we may need 2 more
+	 * pages since we need to zero out first and last block.
+	 */
+	if (unlikely(sdio->blkfactor))
+		sdio->pages_in_io = 2;
+}
+
 /*
  * This is a library function for use by filesystem drivers.
  *
@@ -1229,21 +1250,7 @@ do_blockdev_direct_IO(int rw, struct kiocb *iocb, struct inode *inode,
 
 	retval = 0;
 
-	sdio.blkbits = blkbits;
-	sdio.blkfactor = inode->i_blkbits - blkbits;
-	sdio.block_in_file = offset >> blkbits;
-
-	sdio.get_block = get_block;
-	sdio.submit_io = submit_io;
-	sdio.final_block_in_bio = -1;
-	sdio.next_block_for_io = -1;
-
-	/*
-	 * In case of non-aligned buffers, we may need 2 more
-	 * pages since we need to zero out first and last block.
-	 */
-	if (unlikely(sdio.blkfactor))
-		sdio.pages_in_io = 2;
+	sdio_init(&sdio, inode, offset, blkbits, get_block, submit_io);
 
 	for (seg = 0; seg < nr_segs; seg++) {
 		user_addr = (unsigned long)iov[seg].iov_base;
-- 
1.7.9.2

