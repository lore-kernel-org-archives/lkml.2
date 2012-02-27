Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755359Ab2B0VUc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 16:20:32 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:30104 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755301Ab2B0VU0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 16:20:26 -0500
From: Dave Kleikamp <dave.kleikamp@oracle.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Zach Brown <zab@zabbo.net>,
        Dave Kleikamp <dave.kleikamp@oracle.com>
Subject: [RFC PATCH 12/22] dio: add dio_post_submission() helper function
Date: Mon, 27 Feb 2012 15:19:26 -0600
Message-Id: <1330377576-3659-13-git-send-email-dave.kleikamp@oracle.com>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1330377576-3659-1-git-send-email-dave.kleikamp@oracle.com>
References: <1330377576-3659-1-git-send-email-dave.kleikamp@oracle.com>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-CT-RefId: str=0001.0A090209.4F4BF399.00C9,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zach Brown <zab@zabbo.net>

This creates a function that contains all the code that is executed
after IO is submitted.  It takes code from the end of
do_blockdev_direct_IO().  This will be called by another entry point
that will be added in an upcoming patch.

Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Cc: Zach Brown <zab@zabbo.net>
---
 fs/direct-io.c |  127 ++++++++++++++++++++++++++++++--------------------------
 1 file changed, 68 insertions(+), 59 deletions(-)

diff --git a/fs/direct-io.c b/fs/direct-io.c
index e75b8d7..20bb84c 100644
--- a/fs/direct-io.c
+++ b/fs/direct-io.c
@@ -1187,6 +1187,73 @@ static int dio_lock_and_flush(struct dio *dio, loff_t offset, loff_t end)
 	return 0;
 }
 
+static ssize_t dio_post_submission(int rw, loff_t offset, struct dio *dio,
+				   struct dio_submit *sdio,
+				   struct buffer_head *map_bh, ssize_t ret)
+{
+	if (ret == -ENOTBLK) {
+		/*
+		 * The remaining part of the request will be
+		 * be handled by buffered I/O when we return
+		 */
+		ret = 0;
+	}
+	/*
+	 * There may be some unwritten disk at the end of a part-written
+	 * fs-block-sized block.  Go zero that now.
+	 */
+	dio_zero_block(dio, sdio, 1, map_bh);
+
+	if (sdio->cur_page) {
+		ssize_t ret2;
+
+		ret2 = dio_send_cur_page(dio, sdio, map_bh);
+		if (ret == 0)
+			ret = ret2;
+		page_cache_release(sdio->cur_page);
+		sdio->cur_page = NULL;
+	}
+	if (sdio->bio)
+		dio_bio_submit(dio, sdio);
+
+	/*
+	 * It is possible that, we return short IO due to end of file.
+	 * In that case, we need to release all the pages we got hold on.
+	 */
+	dio_cleanup(dio, sdio);
+
+	/*
+	 * All block lookups have been performed. For READ requests
+	 * we can let i_mutex go now that its achieved its purpose
+	 * of protecting us from looking up uninitialized blocks.
+	 */
+	if (rw == READ && (dio->flags & DIO_LOCKING))
+		mutex_unlock(&dio->inode->i_mutex);
+
+	/*
+	 * The only time we want to leave bios in flight is when a successful
+	 * partial aio read or full aio write have been setup.  In that case
+	 * bio completion will call aio_complete.  The only time it's safe to
+	 * call aio_complete is when we return -EIOCBQUEUED, so we key on that.
+	 * This had *better* be the only place that raises -EIOCBQUEUED.
+	 */
+	BUG_ON(ret == -EIOCBQUEUED);
+	if (dio->is_async && ret == 0 && dio->result &&
+	    ((rw & READ) || (dio->result == sdio->size)))
+		ret = -EIOCBQUEUED;
+
+	if (ret != -EIOCBQUEUED)
+		dio_await_completion(dio);
+
+	if (drop_refcount(dio) == 0) {
+		ret = dio_complete(dio, offset, ret, false);
+		kmem_cache_free(dio_cache, dio);
+	} else
+		BUG_ON(ret != -EIOCBQUEUED);
+
+	return ret;
+}
+
 /*
  * This is a library function for use by filesystem drivers.
  *
@@ -1302,65 +1369,7 @@ do_blockdev_direct_IO(int rw, struct kiocb *iocb, struct inode *inode,
 		}
 	} /* end iovec loop */
 
-	if (retval == -ENOTBLK) {
-		/*
-		 * The remaining part of the request will be
-		 * be handled by buffered I/O when we return
-		 */
-		retval = 0;
-	}
-	/*
-	 * There may be some unwritten disk at the end of a part-written
-	 * fs-block-sized block.  Go zero that now.
-	 */
-	dio_zero_block(dio, &sdio, 1, &map_bh);
-
-	if (sdio.cur_page) {
-		ssize_t ret2;
-
-		ret2 = dio_send_cur_page(dio, &sdio, &map_bh);
-		if (retval == 0)
-			retval = ret2;
-		page_cache_release(sdio.cur_page);
-		sdio.cur_page = NULL;
-	}
-	if (sdio.bio)
-		dio_bio_submit(dio, &sdio);
-
-	/*
-	 * It is possible that, we return short IO due to end of file.
-	 * In that case, we need to release all the pages we got hold on.
-	 */
-	dio_cleanup(dio, &sdio);
-
-	/*
-	 * All block lookups have been performed. For READ requests
-	 * we can let i_mutex go now that its achieved its purpose
-	 * of protecting us from looking up uninitialized blocks.
-	 */
-	if (rw == READ && (dio->flags & DIO_LOCKING))
-		mutex_unlock(&dio->inode->i_mutex);
-
-	/*
-	 * The only time we want to leave bios in flight is when a successful
-	 * partial aio read or full aio write have been setup.  In that case
-	 * bio completion will call aio_complete.  The only time it's safe to
-	 * call aio_complete is when we return -EIOCBQUEUED, so we key on that.
-	 * This had *better* be the only place that raises -EIOCBQUEUED.
-	 */
-	BUG_ON(retval == -EIOCBQUEUED);
-	if (dio->is_async && retval == 0 && dio->result &&
-	    ((rw & READ) || (dio->result == sdio.size)))
-		retval = -EIOCBQUEUED;
-
-	if (retval != -EIOCBQUEUED)
-		dio_await_completion(dio);
-
-	if (drop_refcount(dio) == 0) {
-		retval = dio_complete(dio, offset, retval, false);
-		kmem_cache_free(dio_cache, dio);
-	} else
-		BUG_ON(retval != -EIOCBQUEUED);
+	retval = dio_post_submission(rw, offset, dio, &sdio, &map_bh, retval);
 
 out:
 	return retval;
-- 
1.7.9.2

