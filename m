Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752553Ab2HJLo7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2012 07:44:59 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:35521 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750986Ab2HJLo4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2012 07:44:56 -0400
Date: Fri, 10 Aug 2012 19:45:14 +0800
From: "Jianpeng Ma" <majianpeng@gmail.com>
To: axboe <axboe@kernel.dk>
Cc: "Shaohua Li" <shli@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/3] block: avoid unnecessary plug should_sort test.
X-Priority: 3
X-Has-Attach: no
X-Mailer: Foxmail 7.0.1.91[en]
Mime-Version: 1.0
Message-ID: <201208101945119533551@gmail.com>
Content-Type: text/plain;
	charset="gb2312"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q7ABj5g4032413

If request_count >= BLK_MAX_REQUEST_COUNT,then it will exec
blk_flush_plug_list which plug all request.So no need to do plug->should_sort test.

Signed-off-by: Jianpeng Ma <majianpeng@gmail.com>
---
 block/blk-core.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 4b4dbdf..7a3abc6 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1514,17 +1514,16 @@ get_rq:
 		if (list_empty(&plug->list))
 			trace_block_plug(q);
 		else {
-			if (!plug->should_sort) {
+			if (request_count >= BLK_MAX_REQUEST_COUNT) {
+				blk_flush_plug_list(plug, false);
+				trace_block_plug(q);
+			} else if (!plug->should_sort) {
 				struct request *__rq;
 
 				__rq = list_entry_rq(plug->list.prev);
 				if (__rq->q != q)
 					plug->should_sort = 1;
 			}
-			if (request_count >= BLK_MAX_REQUEST_COUNT) {
-				blk_flush_plug_list(plug, false);
-				trace_block_plug(q);
-			}
 		}
 		list_add_tail(&req->queuelist, &plug->list);
 		drive_stat_acct(req, 1);
-- 
1.7.9.5
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
