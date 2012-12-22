Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752395Ab2LVB6M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 20:58:12 -0500
Received: from mail-ia0-f175.google.com ([209.85.210.175]:57975 "EHLO
	mail-ia0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752303Ab2LVB6J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 20:58:09 -0500
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>, Bing Zhao <bzhao@marvell.com>,
        linux-wireless@vger.kernel.org
Subject: [PATCH 07/25] mwifiex: don't use [delayed_]work_pending()
Date: Fri, 21 Dec 2012 17:56:57 -0800
Message-Id: <1356141435-17340-8-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.0.2
In-Reply-To: <1356141435-17340-1-git-send-email-tj@kernel.org>
References: <1356141435-17340-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Drop work_pending() test from mwifiex_sdio_card_reset().  As
work_pending() becomes %false before sdio_card_reset_worker() starts
executing, it doesn't really protect anything.  reset_host may change
between mmc_remove_host() and mmc_add_host().  Make
sdio_card_reset_worker() cache the target mmc_host so that it isn't
affected by mwifiex_sdio_card_reset() racing with it.

Only compile tested.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Bing Zhao <bzhao@marvell.com>
Cc: linux-wireless@vger.kernel.org
---
Please let me know how this patch should be routed.  I can take it
through the workqueue tree if necessary.

Thanks.

 drivers/net/wireless/mwifiex/sdio.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/sdio.c b/drivers/net/wireless/mwifiex/sdio.c
index 5a1c1d0..f2874c3 100644
--- a/drivers/net/wireless/mwifiex/sdio.c
+++ b/drivers/net/wireless/mwifiex/sdio.c
@@ -1752,6 +1752,8 @@ mwifiex_update_mp_end_port(struct mwifiex_adapter *adapter, u16 port)
 static struct mmc_host *reset_host;
 static void sdio_card_reset_worker(struct work_struct *work)
 {
+	struct mmc_host *target = reset_host;
+
 	/* The actual reset operation must be run outside of driver thread.
 	 * This is because mmc_remove_host() will cause the device to be
 	 * instantly destroyed, and the driver then needs to end its thread,
@@ -1761,10 +1763,10 @@ static void sdio_card_reset_worker(struct work_struct *work)
 	 */
 
 	pr_err("Resetting card...\n");
-	mmc_remove_host(reset_host);
+	mmc_remove_host(target);
 	/* 20ms delay is based on experiment with sdhci controller */
 	mdelay(20);
-	mmc_add_host(reset_host);
+	mmc_add_host(target);
 }
 static DECLARE_WORK(card_reset_work, sdio_card_reset_worker);
 
@@ -1773,9 +1775,6 @@ static void mwifiex_sdio_card_reset(struct mwifiex_adapter *adapter)
 {
 	struct sdio_mmc_card *card = adapter->card;
 
-	if (work_pending(&card_reset_work))
-		return;
-
 	reset_host = card->func->card->host;
 	schedule_work(&card_reset_work);
 }
-- 
1.8.0.2

