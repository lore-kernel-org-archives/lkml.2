Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755880Ab1IRPW3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Sep 2011 11:22:29 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:60702 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754190Ab1IRPW2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Sep 2011 11:22:28 -0400
From: Namjae Jeon <linkinjeon@gmail.com>
To: cjb@laptop.org, linux-mmc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Namjae Jeon <linkinjeon@gmail.com>
Subject: [PATCH] mmc : Use wait_for_completion_timeout() instead of wait_for_completion in case of write.
Date: Mon, 19 Sep 2011 00:21:41 +0900
Message-Id: <1316359301-2263-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

host controller can not rise timeout interrupt in write not read in DMA status. 
because host can just know whether card is finish to program to use busy line. 
If unstable card is keep holding busy line while writing using DMA.
hang problem happen by wait_for_completion. so I think that mmc driver need some exception to avoid this problem.
I suggest to use wait_for_completion_timeout instead of wait_for_completion.

Signed-off-by: Namjae Jeon <linkinjeon@gmail.com>
---
 drivers/mmc/core/core.c |   15 ++++++++++++++-
 1 files changed, 14 insertions(+), 1 deletions(-)

diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
index 557856b..0fe83d3 100644
--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -253,7 +253,20 @@ static void __mmc_start_req(struct mmc_host *host, struct mmc_request *mrq)
 static void mmc_wait_for_req_done(struct mmc_host *host,
 				  struct mmc_request *mrq)
 {
-	wait_for_completion(&mrq->completion);
+	unsigned int timeout_us;
+
+	if ((mrq->data != NULL) && (mrq->data->flags & MMC_DATA_WRITE)) {
+		timeout_us = mrq->data->timeout_ns / 1000;
+		if (mmc_host_clk_rate(host))
+			timeout_us += mrq->data->timeout_clks * 1000 /
+				(mmc_host_clk_rate(host) / 1000);
+		if (!timeout_us)
+			timeout_us = 1000000;
+		if (!wait_for_completion_timeout(&mrq->completion,
+				usecs_to_jiffies(timeout_us)))
+			mrq->cmd->error = -ETIMEDOUT;
+	} else
+		wait_for_completion(&mrq->completion);
 }
 
 /**
-- 
1.7.4.4

