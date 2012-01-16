Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752356Ab2APGmd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 01:42:33 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:46412 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750763Ab2APGmc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 01:42:32 -0500
From: Dmitry Antipov <dmitry.antipov@linaro.org>
To: Chris Ball <cjb@laptop.org>
Cc: patches@linaro.org, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Dmitry Antipov <dmitry.antipov@linaro.org>
Subject: [PATCH] mmc: change mmc_delay() to use usleep_range()
Date: Mon, 16 Jan 2012 10:43:20 +0400
Message-Id: <1326696200-514-1-git-send-email-dmitry.antipov@linaro.org>
X-Mailer: git-send-email 1.7.7.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the usleep_range() to simplify mmc_delay() and give some more
accuracy to it - but with an exception of mmc_card_sleepawake():
for the hosts with very small (<100us) sleep/awake timeout, it's
value is rounded up to 100us so usleep_range() always makes sense.
---
 drivers/mmc/core/core.h    |    8 ++------
 drivers/mmc/core/mmc_ops.c |    9 ++++++---
 2 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/mmc/core/core.h b/drivers/mmc/core/core.h
index 3bdafbc..fbd2cba 100644
--- a/drivers/mmc/core/core.h
+++ b/drivers/mmc/core/core.h
@@ -48,12 +48,8 @@ void mmc_power_off(struct mmc_host *host);
 
 static inline void mmc_delay(unsigned int ms)
 {
-	if (ms < 1000 / HZ) {
-		cond_resched();
-		mdelay(ms);
-	} else {
-		msleep(ms);
-	}
+	unsigned long us = ms * USEC_PER_MSEC;
+	usleep_range(us, us + 1000);
 }
 
 void mmc_rescan(struct work_struct *work);
diff --git a/drivers/mmc/core/mmc_ops.c b/drivers/mmc/core/mmc_ops.c
index 4d41fa9..457443a 100644
--- a/drivers/mmc/core/mmc_ops.c
+++ b/drivers/mmc/core/mmc_ops.c
@@ -82,9 +82,12 @@ int mmc_card_sleepawake(struct mmc_host *host, int sleep)
 	 * SEND_STATUS command to poll the status because that command (and most
 	 * others) is invalid while the card sleeps.
 	 */
-	if (!(host->caps & MMC_CAP_WAIT_WHILE_BUSY))
-		mmc_delay(DIV_ROUND_UP(card->ext_csd.sa_timeout, 10000));
-
+	if (!(host->caps & MMC_CAP_WAIT_WHILE_BUSY)) {
+		/* JEDEC MMCA 4.41 specifies the timeout value is in 200ns..838.86ms
+		   range, which is rounded it up to 100us here. */
+		unsigned long us = DIV_ROUND_UP(card->ext_csd.sa_timeout, 1000);
+		usleep_range(us, us + 100);
+	}
 	if (!sleep)
 		err = mmc_select_card(card);
 
-- 
1.7.7.5

