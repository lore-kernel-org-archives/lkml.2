Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752730Ab0INPms (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 11:42:48 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:35572 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750932Ab0INPmr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 11:42:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=D4gx0gtRcFdN5jbhhcsNfd1q/tYhXNMqwnNO49n8lgwg1dMvWjEXF3refmYrDvZyuB
         O4Nd2SCMEECkRDFHhRp0wtBF1syJzyORgFga++UC8ACmX4YJzTLgx5cBVdnh7N+37raC
         6qu+O21iy4KlBN7KzeK6Tx1trpOWv6jVFlKvE=
From: Namhyung Kim <namhyung@gmail.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] block: fix an address space warning in blk-map.c
Date: Wed, 15 Sep 2010 00:42:36 +0900
Message-Id: <1284478956-13664-1-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.2.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change type of 2nd parameter of blk_rq_aligned() into unsigned long
and remove unnecessary casting. Now we can call it with 'uaddr'
instead of 'ubuf' in __blk_rq_map_user() so that it can remove
following warnings from sparse:

 block/blk-map.c:57:31: warning: incorrect type in argument 2 (different address spaces)
 block/blk-map.c:57:31:    expected void *addr
 block/blk-map.c:57:31:    got void [noderef] <asn:1>*ubuf

However blk_rq_map_kern() needs one more local variable to handle it.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 block/blk-map.c        |    5 +++--
 include/linux/blkdev.h |    4 ++--
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/block/blk-map.c b/block/blk-map.c
index c65d759..ac0f7d4 100644
--- a/block/blk-map.c
+++ b/block/blk-map.c
@@ -54,7 +54,7 @@ static int __blk_rq_map_user(struct request_queue *q, struct request *rq,
 	 * direct dma. else, set up kernel bounce buffers
 	 */
 	uaddr = (unsigned long) ubuf;
-	if (blk_rq_aligned(q, ubuf, len) && !map_data)
+	if (blk_rq_aligned(q, uaddr, len) && !map_data)
 		bio = bio_map_user(q, NULL, uaddr, len, reading, gfp_mask);
 	else
 		bio = bio_copy_user(q, map_data, uaddr, len, reading, gfp_mask);
@@ -288,6 +288,7 @@ int blk_rq_map_kern(struct request_queue *q, struct request *rq, void *kbuf,
 		    unsigned int len, gfp_t gfp_mask)
 {
 	int reading = rq_data_dir(rq) == READ;
+	unsigned long addr = (unsigned long) kbuf;
 	int do_copy = 0;
 	struct bio *bio;
 	int ret;
@@ -297,7 +298,7 @@ int blk_rq_map_kern(struct request_queue *q, struct request *rq, void *kbuf,
 	if (!len || !kbuf)
 		return -EINVAL;
 
-	do_copy = !blk_rq_aligned(q, kbuf, len) || object_is_on_stack(kbuf);
+	do_copy = !blk_rq_aligned(q, addr, len) || object_is_on_stack(kbuf);
 	if (do_copy)
 		bio = bio_copy_kern(q, kbuf, len, gfp_mask, reading);
 	else
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 2c54906..71d7c9c 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1093,11 +1093,11 @@ static inline int queue_dma_alignment(struct request_queue *q)
 	return q ? q->dma_alignment : 511;
 }
 
-static inline int blk_rq_aligned(struct request_queue *q, void *addr,
+static inline int blk_rq_aligned(struct request_queue *q, unsigned long addr,
 				 unsigned int len)
 {
 	unsigned int alignment = queue_dma_alignment(q) | q->dma_pad_mask;
-	return !((unsigned long)addr & alignment) && !(len & alignment);
+	return !(addr & alignment) && !(len & alignment);
 }
 
 /* assumes size > 256 */
-- 
1.7.2.2

