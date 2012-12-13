Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755608Ab2LMNWb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 08:22:31 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:45783 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755486Ab2LMNWZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 08:22:25 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com, ulf.hansson@linaro.org,
        Lee Jones <lee.jones@linaro.org>, Chris Ball <cjb@laptop.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [PATCH 1/8] mmc: mmci: Move ios_handler functionality into the driver
Date: Thu, 13 Dec 2012 13:22:03 +0000
Message-Id: <1355404930-5691-2-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355404930-5691-1-git-send-email-lee.jones@linaro.org>
References: <1355404930-5691-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are currently two instances of the ios_handler being used.
Both of which mearly toy with some regulator settings. Now there
is a GPIO regulator API, we can use that instead, and lessen the
per platform burden. By doing this, we also become more Device
Tree compatible.

Cc: Chris Ball <cjb@laptop.org>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
Acked-by: Ulf Hansson <ulf.hansson@stericsson.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mmc/host/mmci.c |   22 ++++++++++++++++++++++
 drivers/mmc/host/mmci.h |    1 +
 2 files changed, 23 insertions(+)

diff --git a/drivers/mmc/host/mmci.c b/drivers/mmc/host/mmci.c
index edc3e9b..d45c931 100644
--- a/drivers/mmc/host/mmci.c
+++ b/drivers/mmc/host/mmci.c
@@ -1091,6 +1091,16 @@ static void mmci_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
 	case MMC_POWER_OFF:
 		if (host->vcc)
 			ret = mmc_regulator_set_ocr(mmc, host->vcc, 0);
+
+		if (host->vqmmc) {
+			if (regulator_is_enabled(host->vqmmc)) {
+				ret = regulator_disable(host->vqmmc);
+				if (ret < 0)
+					dev_warn(mmc_dev(mmc),
+						 "unable to disable vmmc-ios\n");
+			}
+		}
+
 		break;
 	case MMC_POWER_UP:
 		if (host->vcc) {
@@ -1115,6 +1125,14 @@ static void mmci_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
 
 		break;
 	case MMC_POWER_ON:
+		if (host->vqmmc)
+			if (!regulator_is_enabled(host->vqmmc)) {
+				ret = regulator_enable(host->vqmmc);
+				if (ret < 0)
+					dev_warn(mmc_dev(mmc),
+						 "unable to enable vmmc-ios\n");
+			}
+
 		pwr |= MCI_PWR_ON;
 		break;
 	}
@@ -1379,6 +1397,10 @@ static int __devinit mmci_probe(struct amba_device *dev,
 				 "(using regulator instead)\n");
 		}
 	}
+
+	host->vqmmc = regulator_get(&dev->dev, "vqmmc");
+	if (IS_ERR(host->vqmmc))
+		host->vqmmc = NULL;
 #endif
 	/* Fall back to platform data if no regulator is found */
 	if (host->vcc == NULL)
diff --git a/drivers/mmc/host/mmci.h b/drivers/mmc/host/mmci.h
index d437ccf..b87d9e2 100644
--- a/drivers/mmc/host/mmci.h
+++ b/drivers/mmc/host/mmci.h
@@ -194,6 +194,7 @@ struct mmci_host {
 	struct sg_mapping_iter	sg_miter;
 	unsigned int		size;
 	struct regulator	*vcc;
+	struct regulator	*vqmmc;
 
 #ifdef CONFIG_DMA_ENGINE
 	/* DMA stuff */
-- 
1.7.9.5

