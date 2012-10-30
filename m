Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757248Ab2J3Jdh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 05:33:37 -0400
Received: from na3sys009aog109.obsmtp.com ([74.125.149.201]:56419 "EHLO
	na3sys009aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754860Ab2J3Jd1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 05:33:27 -0400
From: yongd <yongd@marvell.com>
To: Chris Ball <cjb@laptop.org>, Anton Vorontsov <anton.vorontsov@linaro.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Shawn Guo <shawn.guo@linaro.org>, Wolfram Sang <w.sang@pengutronix.de>,
        Daniel Drake <dsd@laptop.org>, Sascha Hauer <s.hauer@pengutronix.de>,
        Wilson Callan <wilson.callan@savantsystems.com>,
        Ben Dooks <ben-linux@fluff.org>
Cc: zhangfei.gao@marvell.com, kevin.liu@marvell.com, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, yongd <yongd@marvell.com>
Subject: [PATCH V2 3/3] mmc: remove MMC_CAP_NEEDS_POLL setting in sdhci_add_host
Date: Tue, 30 Oct 2012 17:33:06 +0800
Message-Id: <1351589586-29210-1-git-send-email-yongd@marvell.com>
X-Mailer: git-send-email 1.7.9.5
X-OriginalArrivalTime: 30 Oct 2012 09:33:04.0722 (UTC) FILETIME=[9009F320:01CDB681]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the current code logic, sdhci_add_host() will enable the polling
method (set MMC_CAP_NEEDS_POLL) for a removable card (MMC_CAP_
NONREMOVABLE is not set) whose host's internal card detection method
is disabled for some reason (SDHCI_QUIRK_BROKEN_CARD_DETECTION is set).

However, this is improper since we can have some other card detection
methods besides host internal card detection and the polling method.
For example, we might use an external GPIO pin's interrupt to detect
a removable SD card, so we shall set SDHCI_QUIRK_BROKEN_CARD_DETECTION
since we don't use the internal card detection, and not set MMC_CAP_
NONREMOVABLE since the SD card is physically removable. As a result,
with the current code, the polling method will also be enabled.
Apparently, this is redundant and not what we want.

And the better one to decide whether we use polling or not should be
the host driver itself. Actually, some host driver has already been
like this. Eg, in drivers/mmc/host/Au1xmmc.c, polling will be enabled
only after the board-specific card detection can't be set up successfully.

Change-Id: I27774488a7b9191d7bc39699fd7d62ee21bbf157
Signed-off-by: yongd <yongd@marvell.com>
---
 drivers/mmc/host/sdhci.c |    4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index f05a377..b327275 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -2843,10 +2843,6 @@ int sdhci_add_host(struct sdhci_host *host)
 	if (caps[0] & SDHCI_CAN_DO_HISPD)
 		mmc->caps |= MMC_CAP_SD_HIGHSPEED | MMC_CAP_MMC_HIGHSPEED;
 
-	if ((host->quirks & SDHCI_QUIRK_BROKEN_CARD_DETECTION) &&
-	    !(host->mmc->caps & MMC_CAP_NONREMOVABLE))
-		mmc->caps |= MMC_CAP_NEEDS_POLL;
-
 	/* If vqmmc regulator and no 1.8V signalling, then there's no UHS */
 	host->vqmmc = regulator_get(mmc_dev(mmc), "vqmmc");
 	if (IS_ERR(host->vqmmc)) {
-- 
1.7.9.5

