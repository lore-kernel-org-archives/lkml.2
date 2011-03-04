Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751326Ab1CDGRJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 01:17:09 -0500
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:48839 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750809Ab1CDGRH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 01:17:07 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=tao.ma;
	h=Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:X-Identified-User;
	b=Bb7CdyyswBf23ZBw4D7NZBfSGU18eL0xTSW3A11XtRa56XReFi3RYdh+mXyeBGG1s/xzsTHHYlooxGqwzyFuAw2bpb17IFf/069ZI0dAai0XdG2wDpGA83jHG9FkELgu;
From: Tao Ma <tm@tao.ma>
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <jaxboe@fusionio.com>
Subject: [PATCH] blktrace: Use rq->cmd_flags directly in blk_add_trace_rq.
Date: Fri,  4 Mar 2011 14:15:58 +0800
Message-Id: <1299219358-17507-1-git-send-email-tm@tao.ma>
X-Mailer: git-send-email 1.7.1
X-Identified-User: {1390:box585.bluehost.com:colyli:tao.ma} {sentby:smtp auth 114.251.86.0 authed with tm@tao.ma}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tao Ma <boyu.mt@taobao.com>

In blk_add_trace_rq, we only chose the minor 2 bits from
request's cmd_flags and did some check for discard.
so most of other flags(e.g, REQ_SYNC) are missing.

For example, with a sync write after blkparse we get:
  8,16   1        1     0.001776503  7509  A  WS 1349632 + 1024 <- (8,17) 1347584
  8,16   1        2     0.001776813  7509  Q  WS 1349632 + 1024 [dd]
  8,16   1        3     0.001780395  7509  G  WS 1349632 + 1024 [dd]
  8,16   1        5     0.001783186  7509  I   W 1349632 + 1024 [dd]
  8,16   1       11     0.001816987  7509  D   W 1349632 + 1024 [dd]
  8,16   0        2     0.006218192     0  C   W 1349632 + 1024 [0]

Since now we have integrated the flags of both bio and request,
it is safe to pass rq->cmd_flags directly to __blk_add_trace.

With this patch, after a sync write we get:
  8,16   1        1     0.001776900  5425  A  WS 1189888 + 1024 <- (8,17) 1187840
  8,16   1        2     0.001777179  5425  Q  WS 1189888 + 1024 [dd]
  8,16   1        3     0.001780797  5425  G  WS 1189888 + 1024 [dd]
  8,16   1        5     0.001783402  5425  I  WS 1189888 + 1024 [dd]
  8,16   1       11     0.001817468  5425  D  WS 1189888 + 1024 [dd]
  8,16   0        2     0.005640709     0  C  WS 1189888 + 1024 [0]

Cc: Jens Axboe <jaxboe@fusionio.com>
Signed-off-by: Tao Ma <boyu.mt@taobao.com>
---
 kernel/trace/blktrace.c |   15 ++++-----------
 1 files changed, 4 insertions(+), 11 deletions(-)

diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
index cbafed7..7aa40f8 100644
--- a/kernel/trace/blktrace.c
+++ b/kernel/trace/blktrace.c
@@ -703,28 +703,21 @@ void blk_trace_shutdown(struct request_queue *q)
  *
  **/
 static void blk_add_trace_rq(struct request_queue *q, struct request *rq,
-				    u32 what)
+			     u32 what)
 {
 	struct blk_trace *bt = q->blk_trace;
-	int rw = rq->cmd_flags & 0x03;
 
 	if (likely(!bt))
 		return;
 
-	if (rq->cmd_flags & REQ_DISCARD)
-		rw |= REQ_DISCARD;
-
-	if (rq->cmd_flags & REQ_SECURE)
-		rw |= REQ_SECURE;
-
 	if (rq->cmd_type == REQ_TYPE_BLOCK_PC) {
 		what |= BLK_TC_ACT(BLK_TC_PC);
-		__blk_add_trace(bt, 0, blk_rq_bytes(rq), rw,
+		__blk_add_trace(bt, 0, blk_rq_bytes(rq), rq->cmd_flags,
 				what, rq->errors, rq->cmd_len, rq->cmd);
 	} else  {
 		what |= BLK_TC_ACT(BLK_TC_FS);
-		__blk_add_trace(bt, blk_rq_pos(rq), blk_rq_bytes(rq), rw,
-				what, rq->errors, 0, NULL);
+		__blk_add_trace(bt, blk_rq_pos(rq), blk_rq_bytes(rq),
+				rq->cmd_flags, what, rq->errors, 0, NULL);
 	}
 }
 
-- 
1.6.3.GIT

