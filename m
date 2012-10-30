Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757284Ab2J3Jao (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 05:30:44 -0400
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:47412 "EHLO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756562Ab2J3JaX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 05:30:23 -0400
From: yongd <yongd@marvell.com>
To: Chris Ball <cjb@laptop.org>, Anton Vorontsov <anton.vorontsov@linaro.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Shawn Guo <shawn.guo@linaro.org>, Wolfram Sang <w.sang@pengutronix.de>,
        Daniel Drake <dsd@laptop.org>, Sascha Hauer <s.hauer@pengutronix.de>,
        Wilson Callan <wilson.callan@savantsystems.com>,
        Ben Dooks <ben-linux@fluff.org>
Cc: zhangfei.gao@marvell.com, kevin.liu@marvell.com, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, yongd <yongd@marvell.com>
Subject: [PATCH V2 1/3] mmc: esdhc: enable polling to detect card by itself
Date: Tue, 30 Oct 2012 17:30:01 +0800
Message-Id: <1351589403-26398-2-git-send-email-yongd@marvell.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1351589403-26398-1-git-send-email-yongd@marvell.com>
References: <1351589403-26398-1-git-send-email-yongd@marvell.com>
X-OriginalArrivalTime: 30 Oct 2012 09:30:12.0269 (UTC) FILETIME=[293FB5D0:01CDB681]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the current code logic, sdhci_add_host() will enable the polling
method (set MMC_CAP_NEEDS_POLL) for a removable card (MMC_CAP_
NONREMOVABLE is not set) whose host's internal card detection method
is disabled for some reason (SDHCI_QUIRK_BROKEN_CARD_DETECTION is set).

However, this is improper since we can have some other card detection
methods besides host internal card detection and polling method. For
example, if the card detection type is ESDHC_CD_GPIO (external gpio pin
for CD), we should keep SDHCI_QUIRK_BROKEN_CARD_DETECTION set, or host
internal card detection interrupt will still be enabled. So, here comes
the 1st change in this patch to keep SDHCI_QUIRK_BROKEN_CARD_DETECTION
set for ESDHC_CD_GPIO type. But, after the 1st change, just as above
said, sdhci_add_host() will still enable polling for such a card.This
is redundant.

On the other hand, for the card with ESDHC_CD_NONE detection type(no CD,
neither controller nor gpio, so use polling), we currently rely on
sdhci_add_host() to enable polling for us.

Here propose the 2nd change in this patch for such an embarrassing case.
1st, this patch will de-couple polling enabling with sdhci_add_host() by
doing this in host driver itself, just as some other vendors. 2nd, one
more patch will remove such improper MMC_CAP_NEEDS_POLL enabling in
sdhci_add_host().

Change-Id: Ia7525009d8fd188e3f0169f225e4a76ff9e94b47
Signed-off-by: yongd <yongd@marvell.com>
---
 drivers/mmc/host/sdhci-esdhc-imx.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/mmc/host/sdhci-esdhc-imx.c b/drivers/mmc/host/sdhci-esdhc-imx.c
index effc2ac..ff201a5 100644
--- a/drivers/mmc/host/sdhci-esdhc-imx.c
+++ b/drivers/mmc/host/sdhci-esdhc-imx.c
@@ -557,7 +557,7 @@ static int __devinit sdhci_esdhc_imx_probe(struct platform_device *pdev)
 			dev_err(mmc_dev(host->mmc), "request irq error\n");
 			goto no_card_detect_irq;
 		}
-		/* fall through */
+		break;
 
 	case ESDHC_CD_CONTROLLER:
 		/* we have a working card_detect back */
@@ -569,6 +569,7 @@ static int __devinit sdhci_esdhc_imx_probe(struct platform_device *pdev)
 		break;
 
 	case ESDHC_CD_NONE:
+		host->mmc->caps = MMC_CAP_NEEDS_POLL;
 		break;
 	}
 
-- 
1.7.9.5

