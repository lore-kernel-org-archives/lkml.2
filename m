Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755605Ab2HHCF0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 22:05:26 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53271 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754641Ab2HHCFZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 22:05:25 -0400
Date: Wed, 8 Aug 2012 10:05:33 +0800
From: "Jianpeng Ma" <majianpeng@gmail.com>
To: axboe <axboe@kernel.dk>
Cc: "Shaohua Li" <shli@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [RFC PATCH] block:Fix some problems about handling plug in blk_queue_bio().
X-Priority: 3
X-Has-Attach: no
X-Mailer: Foxmail 7.0.1.91[en]
Mime-Version: 1.0
Message-ID: <201208081005308597351@gmail.com>
Content-Type: text/plain;
	charset="gb2312"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q7825hLv018940

I think there are three problems about handling plug in blk_queue_bio():
1:if request_count >= BLK_MAX_REQUEST_COUNT, avoid unnecessary plug->should_sort judge.
2:Only two device can trace plug.
3:When exec blk_flush_plug_list,it use list_sort which has
O(nlog(n)) complexity. When insert and sort, it only O(n) complexity.

Signed-off-by: Jianpeng Ma <majianpeng@gmail.com>
---
 block/blk-core.c |   32 +++++++++++++++-----------------
 1 file changed, 15 insertions(+), 17 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 4b4dbdf..e7759f8 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1514,20 +1514,31 @@ get_rq:
 		if (list_empty(&plug->list))
 			trace_block_plug(q);
 		else {
-			if (!plug->should_sort) {
+			if (request_count >= BLK_MAX_REQUEST_COUNT) {
+				blk_flush_plug_list(plug, false);
+				trace_block_plug(q);
+			} else	if (!plug->should_sort) {
 				struct request *__rq;
 
 				__rq = list_entry_rq(plug->list.prev);
 				if (__rq->q != q)
 					plug->should_sort = 1;
-			}
-			if (request_count >= BLK_MAX_REQUEST_COUNT) {
-				blk_flush_plug_list(plug, false);
+			} else  {
+				struct request *rq;
+
+				list_for_each_entry_reverse(rq, &plug->list, queuelist) {
+					if (rq->q == q) {
+						list_add(&req->queuelist, &rq->queuelist);
+						goto stat_acct;
+					}
+				}
 				trace_block_plug(q);
 			}
 		}
 		list_add_tail(&req->queuelist, &plug->list);
+stat_acct:
 		drive_stat_acct(req, 1);
+
 	} else {
 		spin_lock_irq(q->queue_lock);
 		add_acct_request(q, req, where);
@@ -2866,14 +2877,6 @@ void blk_start_plug(struct blk_plug *plug)
 }
 EXPORT_SYMBOL(blk_start_plug);
 
-static int plug_rq_cmp(void *priv, struct list_head *a, struct list_head *b)
-{
-	struct request *rqa = container_of(a, struct request, queuelist);
-	struct request *rqb = container_of(b, struct request, queuelist);
-
-	return !(rqa->q <= rqb->q);
-}
-
 /*
  * If 'from_schedule' is true, then postpone the dispatch of requests
  * until a safe kblockd context. We due this to avoid accidental big
@@ -2967,11 +2970,6 @@ void blk_flush_plug_list(struct blk_plug *plug, bool from_schedule)
 
 	list_splice_init(&plug->list, &list);
 
-	if (plug->should_sort) {
-		list_sort(NULL, &list, plug_rq_cmp);
-		plug->should_sort = 0;
-	}
-
 	q = NULL;
 	depth = 0;
 
-- 
1.7.9.5
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
