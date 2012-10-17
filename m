Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755909Ab2JQBU7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 21:20:59 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:50958 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755824Ab2JQBU6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 21:20:58 -0400
Date: Wed, 17 Oct 2012 09:21:33 +0800
From: "Jianpeng Ma" <majianpeng@gmail.com>
To: axboe <axboe@kernel.dk>
Cc: shli <shli@kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH V1] block: Add blk_rq_pos(rq) to sort rq when plushing plug-list.
X-Priority: 3
X-Has-Attach: no
X-Mailer: Foxmail 7.0.1.91[en]
Mime-Version: 1.0
Message-ID: <201210170921302655262@gmail.com>
Content-Type: text/plain;
	charset="gb2312"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q9H1L6Fe001330

My workload is a raid5 which had 16 disks. And used our filesystem to
write using direct-io mode.
I used the blktrace to find those message:
8,16   0     6647     2.453665504  2579  M   W 7493152 + 8 [md0_raid5]
8,16   0     6648     2.453672411  2579  Q   W 7493160 + 8 [md0_raid5]
8,16   0     6649     2.453672606  2579  M   W 7493160 + 8 [md0_raid5]
8,16   0     6650     2.453679255  2579  Q   W 7493168 + 8 [md0_raid5]
8,16   0     6651     2.453679441  2579  M   W 7493168 + 8 [md0_raid5]
8,16   0     6652     2.453685948  2579  Q   W 7493176 + 8 [md0_raid5]
8,16   0     6653     2.453686149  2579  M   W 7493176 + 8 [md0_raid5]
8,16   0     6654     2.453693074  2579  Q   W 7493184 + 8 [md0_raid5]
8,16   0     6655     2.453693254  2579  M   W 7493184 + 8 [md0_raid5]
8,16   0     6656     2.453704290  2579  Q   W 7493192 + 8 [md0_raid5]
8,16   0     6657     2.453704482  2579  M   W 7493192 + 8 [md0_raid5]
8,16   0     6658     2.453715016  2579  Q   W 7493200 + 8 [md0_raid5]
8,16   0     6659     2.453715247  2579  M   W 7493200 + 8 [md0_raid5]
8,16   0     6660     2.453721730  2579  Q   W 7493208 + 8 [md0_raid5]
8,16   0     6661     2.453721974  2579  M   W 7493208 + 8 [md0_raid5]
8,16   0     6662     2.453728202  2579  Q   W 7493216 + 8 [md0_raid5]
8,16   0     6663     2.453728436  2579  M   W 7493216 + 8 [md0_raid5]
8,16   0     6664     2.453734782  2579  Q   W 7493224 + 8 [md0_raid5]
8,16   0     6665     2.453735019  2579  M   W 7493224 + 8 [md0_raid5]
8,16   0     6666     2.453741401  2579  Q   W 7493232 + 8 [md0_raid5]
8,16   0     6667     2.453741632  2579  M   W 7493232 + 8 [md0_raid5]
8,16   0     6668     2.453748148  2579  Q   W 7493240 + 8 [md0_raid5]
8,16   0     6669     2.453748386  2579  M   W 7493240 + 8 [md0_raid5]
8,16   0     6670     2.453851843  2579  I   W 7493144 + 104 [md0_raid5]
8,16   0        0     2.453853661     0  m   N cfq2579 insert_request
8,16   0     6671     2.453854064  2579  I   W 7493120 + 24 [md0_raid5]
8,16   0        0     2.453854439     0  m   N cfq2579 insert_request
8,16   0     6672     2.453854793  2579  U   N [md0_raid5] 2
8,16   0        0     2.453855513     0  m   N cfq2579 Not idling.st->count:1
8,16   0        0     2.453855927     0  m   N cfq2579 dispatch_insert
8,16   0        0     2.453861771     0  m   N cfq2579 dispatched a request
8,16   0        0     2.453862248     0  m   N cfq2579 activate rq,drv=1
8,16   0     6673     2.453862332  2579  D   W 7493120 + 24 [md0_raid5]
8,16   0        0     2.453865957     0  m   N cfq2579 Not idling.st->count:1
8,16   0        0     2.453866269     0  m   N cfq2579 dispatch_insert
8,16   0        0     2.453866707     0  m   N cfq2579 dispatched a request
8,16   0        0     2.453867061     0  m   N cfq2579 activate rq,drv=2
8,16   0     6674     2.453867145  2579  D   W 7493144 + 104 [md0_raid5]
8,16   0     6675     2.454147608     0  C   W 7493120 + 24 [0]
8,16   0        0     2.454149357     0  m   N cfq2579 complete rqnoidle 0
8,16   0     6676     2.454791505     0  C   W 7493144 + 104 [0]
8,16   0        0     2.454794803     0  m   N cfq2579 complete rqnoidle 0
8,16   0        0     2.454795160     0  m   N cfq schedule dispatch

>From above messages,we can find rq[W 7493144 + 104] and rq[W
7493120 + 24] do not merge.
Because the bio order is:
  8,16   0     6638     2.453619407  2579  Q   W 7493144 + 8 [md0_raid5]
  8,16   0     6639     2.453620460  2579  G   W 7493144 + 8 [md0_raid5]
  8,16   0     6640     2.453639311  2579  Q   W 7493120 + 8 [md0_raid5]
  8,16   0     6641     2.453639842  2579  G   W 7493120 + 8 [md0_raid5]
The bio(7493144) first and bio(7493120) later.So the subsequent
bios will be divided into two parts.
When flushing plug-list,because elv_attempt_insert_merge only support
backmerge,not supporting frontmerge.
So rq[7493120 + 24] can't merge with rq[7493144 + 104].

>From my test,i found those situation can count 25% in our system.
Using this patch, there is no this situation.

Signed-off-by: Jianpeng Ma <majianpeng@gmail.com>
CC:Shaohua Li <shli@kernel.org>
---
 block/blk-core.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index a33870b..3c95c4d 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -2868,7 +2868,8 @@ static int plug_rq_cmp(void *priv, struct list_head *a, struct list_head *b)
 	struct request *rqa = container_of(a, struct request, queuelist);
 	struct request *rqb = container_of(b, struct request, queuelist);
 
-	return !(rqa->q <= rqb->q);
+	return !(rqa->q < rqb->q ||
+		(rqa->q == rqb->q && blk_rq_pos(rqa) < blk_rq_pos(rqb)));
 }
 
 /*
-- 
1.7.9.5
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éÝ¶¥Šwÿº{.nÇ+‰·¥Š{±þG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŽŠÝ¢j"ú¶m§ÿÿ¾«þG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
