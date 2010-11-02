Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752937Ab0KBAFq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 20:05:46 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:33653 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751069Ab0KBAFm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 20:05:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=D5THZ4X36SqF0vUV/XVJY6pOHNho7KrjJV/veoXo8sjDf12HpdyAMWwRtIKiqkKZTQ
         fhfAem5pVQh2p49LuJnMXe6LS9z+0GmvuopLUWnpag1FKhfFL90UfR9F2UUtZ3bFpKcI
         xErm6O+ITMGUuKgGsFJKsLWOFS31q8+IchbL4=
Subject: [PATCH] mxcmmc: Add the ability to bind a regulator to manage the
 MMC card voltage
From: Alberto Panizzo <maramaopercheseimorto@gmail.com>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Daniel Mack <daniel@caiaq.de>, Andrew Morton <akpm@linux-foundation.org>,
        Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Eric =?ISO-8859-1?Q?B=E9nard?= <eric@eukrea.com>,
        Fabio Estevam <fabioestevam@yahoo.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-mmc <linux-mmc@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 02 Nov 2010 01:05:37 +0100
Message-ID: <1288656337.29881.13.camel@realization>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This implementation is based on the pxamci.c driver and it will
be used to support the mx31_3ds machine.

Signed-off-by: Alberto Panizzo <maramaopercheseimorto@gmail.com>
---

This patch is based on the pengutronix for-rmk branch and apply to the
linus tre, version:2.6.37-rc1

..cc the lists, sorry for the double mail.

 drivers/mmc/host/mxcmmc.c |   48 +++++++++++++++++++++++++++++++++++++++-----
 1 files changed, 42 insertions(+), 6 deletions(-)

diff --git a/drivers/mmc/host/mxcmmc.c b/drivers/mmc/host/mxcmmc.c
index 350f78e..e4637fc 100644
--- a/drivers/mmc/host/mxcmmc.c
+++ b/drivers/mmc/host/mxcmmc.c
@@ -31,6 +31,7 @@
 #include <linux/clk.h>
 #include <linux/io.h>
 #include <linux/gpio.h>
+#include <linux/regulator/consumer.h>
 
 #include <asm/dma.h>
 #include <asm/irq.h>
@@ -141,10 +142,45 @@ struct mxcmci_host {
 
 	struct work_struct	datawork;
 	spinlock_t		lock;
+
+	struct regulator	*vcc;
 };
 
 static void mxcmci_set_clk_rate(struct mxcmci_host *host, unsigned int clk_ios);
 
+static inline void mxcmci_init_ocr(struct mxcmci_host *host)
+{
+#ifdef CONFIG_REGULATOR
+	host->vcc = regulator_get(mmc_dev(host->mmc), "vmmc");
+
+	if (IS_ERR(host->vcc)) {
+		host->vcc = NULL;
+	} else {
+		host->mmc->ocr_avail = mmc_regulator_get_ocrmask(host->vcc);
+		if (host->pdata && host->pdata->ocr_avail)
+			dev_warn(mmc_dev(host->mmc),
+				"pdata->ocr_avail will not be used\n");
+	}
+#endif
+	if (host->vcc == NULL) {
+		/* fall-back to platform data */
+		if (host->pdata && host->pdata->ocr_avail)
+			host->mmc->ocr_avail = host->pdata->ocr_avail;
+		else
+			host->mmc->ocr_avail = MMC_VDD_32_33 | MMC_VDD_33_34;
+	}
+}
+
+static inline void mxcmci_set_power(struct mxcmci_host *host, unsigned int vdd)
+{
+#ifdef CONFIG_REGULATOR
+	if (host->vcc)
+		mmc_regulator_set_ocr(host->vcc, vdd);
+#endif
+	if (host->pdata && host->pdata->setpower)
+		host->pdata->setpower(mmc_dev(host->mmc), vdd);
+}
+
 static inline int mxcmci_use_dma(struct mxcmci_host *host)
 {
 	return host->do_dma;
@@ -680,9 +716,9 @@ static void mxcmci_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
 		host->cmdat &= ~CMD_DAT_CONT_BUS_WIDTH_4;
 
 	if (host->power_mode != ios->power_mode) {
-		if (host->pdata && host->pdata->setpower)
-			host->pdata->setpower(mmc_dev(mmc), ios->vdd);
+		mxcmci_set_power(host, ios->vdd);
 		host->power_mode = ios->power_mode;
+
 		if (ios->power_mode == MMC_POWER_ON)
 			host->cmdat |= CMD_DAT_CONT_INIT;
 	}
@@ -808,10 +844,7 @@ static int mxcmci_probe(struct platform_device *pdev)
 	host->pdata = pdev->dev.platform_data;
 	spin_lock_init(&host->lock);
 
-	if (host->pdata && host->pdata->ocr_avail)
-		mmc->ocr_avail = host->pdata->ocr_avail;
-	else
-		mmc->ocr_avail = MMC_VDD_32_33 | MMC_VDD_33_34;
+	mxcmci_init_ocr(host);
 
 	if (host->pdata && host->pdata->dat3_card_detect)
 		host->default_irq_mask =
@@ -916,6 +949,9 @@ static int mxcmci_remove(struct platform_device *pdev)
 
 	mmc_remove_host(mmc);
 
+	if (host->vcc)
+		regulator_put(host->vcc);
+
 	if (host->pdata && host->pdata->exit)
 		host->pdata->exit(&pdev->dev, mmc);
 
-- 
1.6.3.3




