Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932501Ab2AMPIx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 10:08:53 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:42186 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932215Ab2AMPIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 10:08:50 -0500
From: Dmitry Antipov <dmitry.antipov@linaro.org>
To: Chris Ball <cjb@laptop.org>
Cc: patches@linaro.org, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Dmitry Antipov <dmitry.antipov@linaro.org>
Subject: [PATCH] mmc: change mmc_delay() to use usleep_range()
Date: Fri, 13 Jan 2012 19:09:30 +0400
Message-Id: <1326467370-21026-1-git-send-email-dmitry.antipov@linaro.org>
X-Mailer: git-send-email 1.7.7.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the usleep_range() to simplify mmc_delay() and give some more
accuracy to it - but with an exception of mmc_card_sleepawake():
since sleep/awake timeout varies in a wide range, different
delay methods should be used.

Signed-off-by: Dmitry Antipov <dmitry.antipov@linaro.org>
---
 drivers/mmc/core/core.h    |    8 ++------
 drivers/mmc/core/mmc_ops.c |   12 +++++++++---
 2 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/mmc/core/core.h b/drivers/mmc/core/core.h
index 14664f1..a77851e 100644
--- a/drivers/mmc/core/core.h
+++ b/drivers/mmc/core/core.h
@@ -47,12 +47,8 @@ void mmc_power_off(struct mmc_host *host);
 
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
index 4d41fa9..38d53ac 100644
--- a/drivers/mmc/core/mmc_ops.c
+++ b/drivers/mmc/core/mmc_ops.c
@@ -82,9 +82,15 @@ int mmc_card_sleepawake(struct mmc_host *host, int sleep)
 	 * SEND_STATUS command to poll the status because that command (and most
 	 * others) is invalid while the card sleeps.
 	 */
-	if (!(host->caps & MMC_CAP_WAIT_WHILE_BUSY))
-		mmc_delay(DIV_ROUND_UP(card->ext_csd.sa_timeout, 10000));
-
+	if (!(host->caps & MMC_CAP_WAIT_WHILE_BUSY)) {
+		/* JEDEC MMCA 4.41 specifies the timeout value is in 200ns..838.86ms
+		   range. Round it up to 1us and use an appropriate delay method. */
+		unsigned long us = DIV_ROUND_UP(card->ext_csd.sa_timeout, 10);
+		if (us < 10)
+			udelay(us);
+		else
+			usleep_range(us, us + 100);
+	}
 	if (!sleep)
 		err = mmc_select_card(card);
 
-- 
1.7.7.5

