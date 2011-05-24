Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755849Ab1EXDTG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 23:19:06 -0400
Received: from mail-px0-f173.google.com ([209.85.212.173]:53668 "EHLO
	mail-px0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754889Ab1EXDTC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 23:19:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=i+4PhczhyJFA3IzEIEz7jmYPC9FR9rAmBCgTZw/4dzN2MUFGV4waopePaiv6/PwF/0
         SqM5xyv9pLPTIHav6/bcbm8ecE6ProZExjCYw5XusPTaAjy2UuWV8in+tcCI9PJA95F7
         xtVLeUVUOyTAPLbnPtjQ+m7j60b5VqvES5Zxc=
From: Namhyung Kim <namhyung@gmail.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] cfq-iosched: reduce bit operations in cfq_choose_req()
Date: Tue, 24 May 2011 12:18:49 +0900
Message-Id: <1306207131-2296-2-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.5.2
In-Reply-To: <1306207131-2296-1-git-send-email-namhyung@gmail.com>
References: <1306207131-2296-1-git-send-email-namhyung@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reduce the number of bit operations in cfq_choose_req() on average
(and worst) cases.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 block/cfq-iosched.c |   14 +++++---------
 1 files changed, 5 insertions(+), 9 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 151a050e692c..a79e62063144 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -665,15 +665,11 @@ cfq_choose_req(struct cfq_data *cfqd, struct request *rq1, struct request *rq2,
 	if (rq2 == NULL)
 		return rq1;
 
-	if (rq_is_sync(rq1) && !rq_is_sync(rq2))
-		return rq1;
-	else if (rq_is_sync(rq2) && !rq_is_sync(rq1))
-		return rq2;
-	if ((rq1->cmd_flags & REQ_META) && !(rq2->cmd_flags & REQ_META))
-		return rq1;
-	else if ((rq2->cmd_flags & REQ_META) &&
-		 !(rq1->cmd_flags & REQ_META))
-		return rq2;
+	if (rq_is_sync(rq1) != rq_is_sync(rq2))
+		return rq_is_sync(rq1) ? rq1 : rq2;
+
+	if ((rq1->cmd_flags ^ rq2->cmd_flags) & REQ_META)
+		return rq1->cmd_flags & REQ_META ? rq1 : rq2;
 
 	s1 = blk_rq_pos(rq1);
 	s2 = blk_rq_pos(rq2);
-- 
1.7.5.2

