Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752147Ab1HYGkT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 02:40:19 -0400
Received: from oproxy5-pub.bluehost.com ([67.222.38.55]:36094 "HELO
	oproxy5-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751087Ab1HYGkP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 02:40:15 -0400
From: Tao Ma <tm@tao.ma>
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <jaxboe@fusionio.com>
Subject: [PATCH] block: Warn if tag is greater than real_max_depth.
Date: Thu, 25 Aug 2011 14:40:03 +0800
Message-Id: <1314254403-4137-1-git-send-email-tm@tao.ma>
X-Mailer: git-send-email 1.7.4.1
X-Identified-User: {1390:box585.bluehost.com:colyli:tao.ma} {sentby:smtp auth 182.92.247.2 authed with tm@tao.ma}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tao Ma <boyu.mt@taobao.com>

In case tag depth is reduced, it is max_depth not real_max_depth.
So we should allow a request with tag >= max_depth, but for a
tag >= real_max_depth, there really should be some problem.

Cc: Jens Axboe <jaxboe@fusionio.com>
Signed-off-by: Tao Ma <boyu.mt@taobao.com>
---
 block/blk-tag.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/block/blk-tag.c b/block/blk-tag.c
index ece65fc..e74d6d1 100644
--- a/block/blk-tag.c
+++ b/block/blk-tag.c
@@ -286,12 +286,14 @@ void blk_queue_end_tag(struct request_queue *q, struct request *rq)
 
 	BUG_ON(tag == -1);
 
-	if (unlikely(tag >= bqt->real_max_depth))
+	if (unlikely(tag >= bqt->max_depth)) {
 		/*
 		 * This can happen after tag depth has been reduced.
-		 * FIXME: how about a warning or info message here?
+		 * But tag shouldn't be larger than real_max_depth.
 		 */
+		WARN_ON(tag >= bqt->real_max_depth);
 		return;
+	}
 
 	list_del_init(&rq->queuelist);
 	rq->cmd_flags &= ~REQ_QUEUED;
-- 
1.7.1

