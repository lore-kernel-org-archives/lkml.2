Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755451Ab2HJMg6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2012 08:36:58 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53250 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751396Ab2HJMg4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2012 08:36:56 -0400
Date: Fri, 10 Aug 2012 20:37:14 +0800
From: "Jianpeng Ma" <majianpeng@gmail.com>
To: viro <viro@ZenIV.linux.org.uk>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [RFC PATCH] fs/direct-io.c: Add REQ_NOIDLE for last bio .
X-Priority: 3
X-Has-Attach: no
X-Mailer: Foxmail 7.0.1.91[en]
Mime-Version: 1.0
Message-ID: <201208102037120467864@gmail.com>
Content-Type: text/plain;
	charset="gb2312"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q7ACb5Rw032544

For last bio of dio, there are no bio will come.So set REQ_NOIDLE.

Signed-off-by: Jianpeng Ma <majianpeng@gmail.com>
---
 fs/direct-io.c |   15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/fs/direct-io.c b/fs/direct-io.c
index 1faf4cb..7c6958f 100644
--- a/fs/direct-io.c
+++ b/fs/direct-io.c
@@ -127,6 +127,7 @@ struct dio {
 	int page_errors;		/* errno from get_user_pages() */
 	int is_async;			/* is IO async ? */
 	int io_error;			/* IO error in completion path */
+	sector_t end_sector;		/* the last sector for this dio */
 	unsigned long refcount;		/* direct_io_worker() and bios */
 	struct bio *bio_list;		/* singly linked via bi_private */
 	struct task_struct *waiter;	/* waiting task (NULL if none) */
@@ -369,21 +370,28 @@ static inline void dio_bio_submit(struct dio *dio, struct dio_submit *sdio)
 {
 	struct bio *bio = sdio->bio;
 	unsigned long flags;
-
+	int rw = dio->rw;
 	bio->bi_private = dio;
 
 	spin_lock_irqsave(&dio->bio_lock, flags);
 	dio->refcount++;
 	spin_unlock_irqrestore(&dio->bio_lock, flags);
 
+	/*
+	 * If bio is the last for dio,so no bio can arrive for low-level
+	 * unless this dio completed.
+	 */
+	if (bio->bi_sector + bio_sectors(bio) >= dio->end_sector)
+		rw |= REQ_NOIDLE;
+
 	if (dio->is_async && dio->rw == READ)
 		bio_set_pages_dirty(bio);
 
 	if (sdio->submit_io)
-		sdio->submit_io(dio->rw, bio, dio->inode,
+		sdio->submit_io(rw, bio, dio->inode,
 			       sdio->logical_offset_in_bio);
 	else
-		submit_bio(dio->rw, bio);
+		submit_bio(rw, bio);
 
 	sdio->bio = NULL;
 	sdio->boundary = 0;
@@ -1147,6 +1155,7 @@ do_blockdev_direct_IO(int rw, struct kiocb *iocb, struct inode *inode,
 
 	dio->inode = inode;
 	dio->rw = rw;
+	dio->end_sector = end >> 9;
 	sdio.blkbits = blkbits;
 	sdio.blkfactor = inode->i_blkbits - blkbits;
 	sdio.block_in_file = offset >> blkbits;
-- 
1.7.9.5
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
