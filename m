Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753766Ab2LYJ1F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Dec 2012 04:27:05 -0500
Received: from mail-pb0-f45.google.com ([209.85.160.45]:47771 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753119Ab2LYJ1D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Dec 2012 04:27:03 -0500
Date: Tue, 25 Dec 2012 17:27:03 +0800
From: majianpeng <majianpeng@gmail.com>
To: axboe <axboe@kernel.dk>
Cc: "Shaohua Li" <shli@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Reply-To: majianpeng <majianpeng@gmail.com>
Subject: [PATCH] block: Remove should_sort judgement when flush blk_plug.
X-Priority: 3
X-GUID: 97EBCE0F-3CA6-4BCF-9DD9-E0397118C64F
X-Has-Attach: no
X-Mailer: Foxmail 7.0.1.90[en]
Mime-Version: 1.0
Message-ID: <201212251726591128681@gmail.com>
Content-Type: text/plain;
	charset="gb2312"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id qBP9RJkL013896

In commit 975927b942c932,it add blk_rq_pos to sort rq when flushing.
Although this commit was used for the situation which blk_plug handled
multi devices on the same time like md device.
I think there must be some situations like this but only single
device.
So remove the should_sort judgement.
Because the parameter should_sort is only for this purpose,it can delete
should_sort from blk_plug.

CC: Shaohua Li <shli@kernel.org>
Signed-off-by: Jianpeng Ma <majianpeng@gmail.com>
---
 block/blk-core.c       |   13 +------------
 include/linux/blkdev.h |    1 -
 2 files changed, 1 insertion(+), 13 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index c973249..aca5d82 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1548,13 +1548,6 @@ get_rq:
 		if (list_empty(&plug->list))
 			trace_block_plug(q);
 		else {
-			if (!plug->should_sort) {
-				struct request *__rq;
-
-				__rq = list_entry_rq(plug->list.prev);
-				if (__rq->q != q)
-					plug->should_sort = 1;
-			}
 			if (request_count >= BLK_MAX_REQUEST_COUNT) {
 				blk_flush_plug_list(plug, false);
 				trace_block_plug(q);
@@ -2888,7 +2881,6 @@ void blk_start_plug(struct blk_plug *plug)
 	plug->magic = PLUG_MAGIC;
 	INIT_LIST_HEAD(&plug->list);
 	INIT_LIST_HEAD(&plug->cb_list);
-	plug->should_sort = 0;
 
 	/*
 	 * If this is a nested plug, don't actually assign it. It will be
@@ -2990,10 +2982,7 @@ void blk_flush_plug_list(struct blk_plug *plug, bool from_schedule)
 
 	list_splice_init(&plug->list, &list);
 
-	if (plug->should_sort) {
-		list_sort(NULL, &list, plug_rq_cmp);
-		plug->should_sort = 0;
-	}
+	list_sort(NULL, &list, plug_rq_cmp);
 
 	q = NULL;
 	depth = 0;
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index f94bc83..dbe7427 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -974,7 +974,6 @@ struct blk_plug {
 	unsigned long magic; /* detect uninitialized use-cases */
 	struct list_head list; /* requests */
 	struct list_head cb_list; /* md requires an unplug callback */
-	unsigned int should_sort; /* list to be sorted before flushing? */
 };
 #define BLK_MAX_REQUEST_COUNT 16
 
-- 
1.7.9.5
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
