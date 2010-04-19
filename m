Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753533Ab0DSJA7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 05:00:59 -0400
Received: from mail.atmel.fr ([81.80.104.162]:63696 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752997Ab0DSJA6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 05:00:58 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: haavard.skinnemoen@atmel.com, linux-arm-kernel@lists.infradead.org,
       akpm@linux-foundation.org, linux-mmc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, kernel@avr32linux.org,
       Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH] MMC: atmel-mci: enable SD high speed support
Date: Mon, 19 Apr 2010 12:12:32 +0200
Message-Id: <1271671952-29204-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable high speed support for atmel-mci driver. This support is dependent of
the revision of the IP and, of course, the capacity of the SD card used.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 drivers/mmc/host/atmel-mci.c |   22 +++++++++++++++++++---
 1 files changed, 19 insertions(+), 3 deletions(-)

diff --git a/drivers/mmc/host/atmel-mci.c b/drivers/mmc/host/atmel-mci.c
index 88be37d..4338750 100644
--- a/drivers/mmc/host/atmel-mci.c
+++ b/drivers/mmc/host/atmel-mci.c
@@ -951,10 +951,21 @@ static void atmci_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
 		if (mci_has_rwproof())
 			host->mode_reg |= (MCI_MR_WRPROOF | MCI_MR_RDPROOF);
 
-		if (list_empty(&host->queue))
+		if (atmci_is_mci2()) {
+			/* setup High Speed mode in relation with card capacity */
+			if (ios->timing == MMC_TIMING_SD_HS)
+				host->cfg_reg |= MCI_CFG_HSMODE;
+			else
+				host->cfg_reg &= ~MCI_CFG_HSMODE;
+		}
+
+		if (list_empty(&host->queue)) {
 			mci_writel(host, MR, host->mode_reg);
-		else
+			if (atmci_is_mci2())
+				mci_writel(host, CFG, host->cfg_reg);
+		} else {
 			host->need_clock_update = true;
+		}
 
 		spin_unlock_bh(&host->lock);
 	} else {
@@ -1051,8 +1062,11 @@ static void atmci_request_end(struct atmel_mci *host, struct mmc_request *mrq)
 	 * necessary if set_ios() is called when a different slot is
 	 * busy transfering data.
 	 */
-	if (host->need_clock_update)
+	if (host->need_clock_update) {
 		mci_writel(host, MR, host->mode_reg);
+		if (atmci_is_mci2())
+			mci_writel(host, CFG, host->cfg_reg);
+	}
 
 	host->cur_slot->mrq = NULL;
 	host->mrq = NULL;
@@ -1563,6 +1577,8 @@ static int __init atmci_init_slot(struct atmel_mci *host,
 	mmc->f_min = DIV_ROUND_UP(host->bus_hz, 512);
 	mmc->f_max = host->bus_hz / 2;
 	mmc->ocr_avail	= MMC_VDD_32_33 | MMC_VDD_33_34;
+	if (atmci_is_mci2())
+		mmc->caps |= MMC_CAP_SD_HIGHSPEED;
 	if (slot_data->bus_width >= 4)
 		mmc->caps |= MMC_CAP_4_BIT_DATA;
 
-- 
1.5.6.5

