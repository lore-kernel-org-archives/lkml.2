Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757170Ab2J3Jal (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 05:30:41 -0400
Received: from na3sys009aog107.obsmtp.com ([74.125.149.197]:41034 "EHLO
	na3sys009aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756993Ab2J3Jaj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 05:30:39 -0400
From: yongd <yongd@marvell.com>
To: Chris Ball <cjb@laptop.org>, Anton Vorontsov <anton.vorontsov@linaro.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Shawn Guo <shawn.guo@linaro.org>, Wolfram Sang <w.sang@pengutronix.de>,
        Daniel Drake <dsd@laptop.org>, Sascha Hauer <s.hauer@pengutronix.de>,
        Wilson Callan <wilson.callan@savantsystems.com>,
        Ben Dooks <ben-linux@fluff.org>
Cc: zhangfei.gao@marvell.com, kevin.liu@marvell.com, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, yongd <yongd@marvell.com>
Subject: [PATCH V2 2/3] mmc: sdhci-s3c: enable polling to detect card by itself
Date: Tue, 30 Oct 2012 17:30:02 +0800
Message-Id: <1351589403-26398-3-git-send-email-yongd@marvell.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1351589403-26398-1-git-send-email-yongd@marvell.com>
References: <1351589403-26398-1-git-send-email-yongd@marvell.com>
X-OriginalArrivalTime: 30 Oct 2012 09:30:17.0910 (UTC) FILETIME=[2C9C7560:01CDB681]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SDHCI_QUIRK_BROKEN_CARD_DETECTION is used to disable host internal
card detection method. So it should be set for all card detection types
except S3C_SDHCI_CD_INTERNAL, or host internal card detection interrupts
will be redundantly enabled. So, the 1st change of this patch expands such
flag setting.

Moreover, we need move further after the above change.

In the current code logic, sdhci_add_host() will enable the polling method
(set MMC_CAP_NEEDS_POLL) for a removable card (MMC_CAP_NONREMOVABLE is not
set) whose host's internal card detection method is disabled.

Apparently, this is arbitrary since we can have some other detection types.
As a result, sdhci_add_host() will redundantly enable polling for a card with
S3C_SDHCI_CD_GPIO/S3C_SDHCI_CD_EXTERNAL type.

So, we plan to remove such improper setting in sdhci_add_host(). But
before this, this 2nd change of this patch is a MUST, which enables polling
in host driver itself for S3C_SDHCI_CD_NONE type. Currently, we rely on the
above improper logic for this.

Change-Id: I28bd6765e6c6a9dd6c288ff4ca6ecf7268a2d8ed
Signed-off-by: yongd <yongd@marvell.com>
---
 drivers/mmc/host/sdhci-s3c.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/mmc/host/sdhci-s3c.c b/drivers/mmc/host/sdhci-s3c.c
index a093e2e..a669616 100644
--- a/drivers/mmc/host/sdhci-s3c.c
+++ b/drivers/mmc/host/sdhci-s3c.c
@@ -683,10 +683,12 @@ static int __devinit sdhci_s3c_probe(struct platform_device *pdev)
 	/* Samsung SoCs need BROKEN_ADMA_ZEROLEN_DESC */
 	host->quirks |= SDHCI_QUIRK_BROKEN_ADMA_ZEROLEN_DESC;
 
-	if (pdata->cd_type == S3C_SDHCI_CD_NONE ||
-	    pdata->cd_type == S3C_SDHCI_CD_PERMANENT)
+	if (pdata->cd_type != S3C_SDHCI_CD_INTERNAL)
 		host->quirks |= SDHCI_QUIRK_BROKEN_CARD_DETECTION;
 
+	if (pdata->cd_type == S3C_SDHCI_CD_NONE)
+		host->mmc->caps = MMC_CAP_NEEDS_POLL;
+
 	if (pdata->cd_type == S3C_SDHCI_CD_PERMANENT)
 		host->mmc->caps = MMC_CAP_NONREMOVABLE;
 
-- 
1.7.9.5

