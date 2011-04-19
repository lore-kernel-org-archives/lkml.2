Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753638Ab1DSI1k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 04:27:40 -0400
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:33499 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751377Ab1DSI1i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 04:27:38 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=tao.ma;
	h=Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:X-Identified-User;
	b=tIRbPFfoGzGxPMhJd9b6lrdxygHHTbQrn+nnbwo5rizPIJWxIdqtkOgChZLXhC7NihrGAyUCT944uaunco+WkymeFCwN5c3pid40WdXGwCaPQRsfPio0O/Mn24Q7H9an;
From: Tao Ma <tm@tao.ma>
To: linux-kernel@vger.kernel.org
Cc: axboe@kernel.dk
Subject: [PATCH] block: Remove the extra check in queue_requests_store.
Date: Tue, 19 Apr 2011 16:26:57 +0800
Message-Id: <1303201617-18122-1-git-send-email-tm@tao.ma>
X-Mailer: git-send-email 1.7.1
X-Identified-User: {1390:box585.bluehost.com:colyli:tao.ma} {sentby:smtp auth 114.251.86.0 authed with tm@tao.ma}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tao Ma <boyu.mt@taobao.com>

In queue_requests_store, the code looks like
	if (rl->count[BLK_RW_SYNC] >= q->nr_requests) {
		blk_set_queue_full(q, BLK_RW_SYNC);
	} else if (rl->count[BLK_RW_SYNC]+1 <= q->nr_requests) {
		blk_clear_queue_full(q, BLK_RW_SYNC);
		wake_up(&rl->wait[BLK_RW_SYNC]);
	}
If we don't satify the situation of "if", we can get that
rl->count[BLK_RW_SYNC} < q->nr_quests. It is the same as
rl->count[BLK_RW_SYNC]+1 <= q->nr_requests.
All the "else" should satisfy the "else if" check so it isn't
needed actually.

Signed-off-by: Tao Ma <boyu.mt@taobao.com>
---
 block/blk-sysfs.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index 6d73512..644e2d3 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -66,14 +66,14 @@ queue_requests_store(struct request_queue *q, const char *page, size_t count)
 
 	if (rl->count[BLK_RW_SYNC] >= q->nr_requests) {
 		blk_set_queue_full(q, BLK_RW_SYNC);
-	} else if (rl->count[BLK_RW_SYNC]+1 <= q->nr_requests) {
+	} else {
 		blk_clear_queue_full(q, BLK_RW_SYNC);
 		wake_up(&rl->wait[BLK_RW_SYNC]);
 	}
 
 	if (rl->count[BLK_RW_ASYNC] >= q->nr_requests) {
 		blk_set_queue_full(q, BLK_RW_ASYNC);
-	} else if (rl->count[BLK_RW_ASYNC]+1 <= q->nr_requests) {
+	} else {
 		blk_clear_queue_full(q, BLK_RW_ASYNC);
 		wake_up(&rl->wait[BLK_RW_ASYNC]);
 	}
-- 
1.6.3.GIT

