Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755875Ab2KHNEg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 08:04:36 -0500
Received: from mga01.intel.com ([192.55.52.88]:24988 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755691Ab2KHNEd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 08:04:33 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,737,1344236400"; 
   d="scan'208";a="244102548"
From: dragos.tatulea@intel.com
To: linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org, cjb@laptop.org
Cc: kirill.shutemov@linux.intel.com, irina.tirdea@intel.com,
        octavian.purdila@intel.com, tony.luck@intel.com, keescook@chromium.org,
        dragos.tatulea@gmail.com, Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCH v2 23/26] mmc: sdhci: panic write: resume suspended host
Date: Thu,  8 Nov 2012 15:06:21 +0200
Message-Id: <1352379984-18381-24-git-send-email-dragos.tatulea@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1352379984-18381-1-git-send-email-dragos.tatulea@intel.com>
References: <1352379984-18381-1-git-send-email-dragos.tatulea@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

Resume host when entering panic mode.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Irina Tirdea <irina.tirdea@intel.com>
---
 drivers/mmc/host/sdhci.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index ab3f5ce..496adc8 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -2231,6 +2231,10 @@ static void sdhci_panic_begin(struct mmc_host *mmc)
 {
 	struct sdhci_host *host = mmc_priv(mmc);
 
+	if (host->runtime_suspended)
+		sdhci_runtime_resume_host(host);
+	else if (mmc->ios.vdd == 0)
+		sdhci_resume_host(host);
 	sdhci_writel(host, 0, SDHCI_SIGNAL_ENABLE);
 }
 
@@ -2741,10 +2745,12 @@ int sdhci_resume_host(struct sdhci_host *host)
 			host->ops->enable_dma(host);
 	}
 
-	ret = request_irq(host->irq, sdhci_irq, IRQF_SHARED,
-			  mmc_hostname(host->mmc), host);
-	if (ret)
-		return ret;
+	if (!mmc_am_panic_task(host->mmc)) {
+		ret = request_irq(host->irq, sdhci_irq, IRQF_SHARED,
+				  mmc_hostname(host->mmc), host);
+		if (ret)
+			return ret;
+	}
 
 	if ((host->mmc->pm_flags & MMC_PM_KEEP_POWER) &&
 	    (host->quirks2 & SDHCI_QUIRK2_HOST_OFF_CARD_ON)) {
-- 
1.7.9.5

