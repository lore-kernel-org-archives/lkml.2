Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759594Ab2HKBbp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2012 21:31:45 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53246 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755618Ab2HKBbn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2012 21:31:43 -0400
Date: Sat, 11 Aug 2012 09:32:02 +0800
From: "Jianpeng Ma" <majianpeng@gmail.com>
To: axboe <axboe@kernel.dk>
Cc: "Shaohua Li" <shli@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/3 V1] block: Fix not tracing all device plug-operation.
X-Priority: 3
X-Has-Attach: no
X-Mailer: Foxmail 7.0.1.91[en]
Mime-Version: 1.0
Message-ID: <201208110931595001851@gmail.com>
Content-Type: text/plain;
	charset="gb2312"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q7B1Vopv002496

If process handled two or more devices,there will not be trace some
devices plug-operation.

V0-->V1
Fix a bug when insert a req to plug-list which already had the same request-queue, it should
used list_add not list_add_tail.

Signed-off-by: Jianpeng Ma <majianpeng@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
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
+						list_add(&req->queuelist,
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
