Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933222Ab2JWNpt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 09:45:49 -0400
Received: from mga01.intel.com ([192.55.52.88]:56255 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933134Ab2JWNns (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 09:43:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,635,1344236400"; 
   d="scan'208";a="237191314"
From: Irina Tirdea <irina.tirdea@intel.com>
To: Anton Vorontsov <cbouatmailru@gmail.com>, Colin Cross <ccross@android.com>,
        Kees Cook <keescook@chromium.org>, Tony Luck <tony.luck@intel.com>,
        Chris Ball <cjb@laptop.org>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Octavian Purdila <octavian.purdila@intel.com>,
        Irina Tirdea <irina.tirdea@intel.com>
Subject: [PATCH 23/26] mmc: sdhci: panic write: resume suspended host
Date: Tue, 23 Oct 2012 16:48:21 +0300
Message-Id: <1351000104-13015-24-git-send-email-irina.tirdea@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1351000104-13015-1-git-send-email-irina.tirdea@intel.com>
References: <1351000104-13015-1-git-send-email-irina.tirdea@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

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

