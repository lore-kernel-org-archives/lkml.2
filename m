Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753319Ab1HTOvF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Aug 2011 10:51:05 -0400
Received: from mail-iy0-f170.google.com ([209.85.210.170]:49393 "EHLO
	mail-iy0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752034Ab1HTOvC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Aug 2011 10:51:02 -0400
From: Namjae Jeon <linkinjeon@gmail.com>
To: linux-mmc@vger.kernel.org
Cc: cjb@laptop.org, linus.walleij@linaro.org, linux-kernel@vger.kernel.org,
        Namjae Jeon <linkinjeon@gmail.com>
Subject: [PATCH] mmc: Use switch() instead of if/else if in mmc_blk_issue_rq.
Date: Sat, 20 Aug 2011 23:50:39 +0900
Message-Id: <1313851839-32483-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This uses a switch statement instead of if/else if statements.
It will make to improve clarity and scalability, and offer faster execution through compiler optimization than if/else if statements.

Signed-off-by: Namjae Jeon <linkinjeon@gmail.com>
---
 drivers/mmc/card/block.c |   38 +++++++++++++++++++++++---------------
 1 files changed, 23 insertions(+), 15 deletions(-)

diff --git a/drivers/mmc/card/block.c b/drivers/mmc/card/block.c
index 1ff5486..fe9dd89 100644
--- a/drivers/mmc/card/block.c
+++ b/drivers/mmc/card/block.c
@@ -1191,23 +1191,31 @@ static int mmc_blk_issue_rq(struct mmc_queue *mq, struct request *req)
 		goto out;
 	}
 
-	if (req && req->cmd_flags & REQ_DISCARD) {
-		/* complete ongoing async transfer before issuing discard */
-		if (card->host->areq)
-			mmc_blk_issue_rw_rq(mq, NULL);
-		if (req->cmd_flags & REQ_SECURE)
-			ret = mmc_blk_issue_secdiscard_rq(mq, req);
-		else
+	if (req) {
+		switch(req->cmd_flags) {
+		case REQ_DISCARD:
+			/* complete ongoing async transfer before issuing discard */
+			if (card->host->areq)
+				mmc_blk_issue_rw_rq(mq, NULL);
 			ret = mmc_blk_issue_discard_rq(mq, req);
-	} else if (req && req->cmd_flags & REQ_FLUSH) {
-		/* complete ongoing async transfer before issuing flush */
-		if (card->host->areq)
-			mmc_blk_issue_rw_rq(mq, NULL);
-		ret = mmc_blk_issue_flush(mq, req);
-	} else {
+			break;
+		case REQ_DISCARD | REQ_SECURE:
+			/* complete ongoing async transfer before issuing discard */
+			if (card->host->areq)
+				mmc_blk_issue_rw_rq(mq, NULL);
+			ret = mmc_blk_issue_secdiscard_rq(mq, req);
+			break;
+		case REQ_FLUSH:
+			/* complete ongoing async transfer before issuing discard */
+			if (card->host->areq)
+				mmc_blk_issue_rw_rq(mq, NULL);
+			ret = mmc_blk_issue_flush(mq, req);
+			break;
+		}
+	}		
+	else
 		ret = mmc_blk_issue_rw_rq(mq, req);
-	}
-
+			
 out:
 	if (!req)
 		/* release host only when there are no more requests */
-- 
1.7.4.4

