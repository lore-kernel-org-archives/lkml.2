Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753177Ab2HJLpp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2012 07:45:45 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:52770 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751255Ab2HJLpn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2012 07:45:43 -0400
Date: Fri, 10 Aug 2012 19:46:01 +0800
From: "Jianpeng Ma" <majianpeng@gmail.com>
To: axboe <axboe@kernel.dk>
Cc: shli <shli@kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/3] block: Fix not tracing all device plug-operation.
X-Priority: 3
X-Has-Attach: no
X-Mailer: Foxmail 7.0.1.91[en]
Mime-Version: 1.0
Message-ID: <201208101945571256852@gmail.com>
Content-Type: text/plain;
	charset="gb2312"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q7ABjo51032417

If process handled two or more devices,there will not be trace some
devices plug-operation.

Signed-off-by: Jianpeng Ma <majianpeng@gmail.com>
---
 block/blk-core.c |   16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 7a3abc6..034f186 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1521,11 +1521,25 @@ get_rq:
 				struct request *__rq;
 
 				__rq = list_entry_rq(plug->list.prev);
-				if (__rq->q != q)
+				if (__rq->q != q) {
 					plug->should_sort = 1;
+					trace_block_plug(q);
+				}
+			} else {
+				struct request *__rq;
+				list_for_each_entry_reverse(__rq, &plug->list,
+					queuelist) {
+					if (__rq->q == q) {
+						list_add_tail(&req->queuelist,
+							&__rq->queuelist);
+						goto stat_acct;
+					}
+				}
+				trace_block_plug(q);
 			}
 		}
 		list_add_tail(&req->queuelist, &plug->list);
+stat_acct:
 		drive_stat_acct(req, 1);
 	} else {
 		spin_lock_irq(q->queue_lock);
-- 
1.7.9.5
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
