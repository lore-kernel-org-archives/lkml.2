Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759947Ab2CNIwW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 04:52:22 -0400
Received: from webbox1416.server-home.net ([77.236.96.61]:55824 "EHLO
	webbox1416.server-home.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759530Ab2CNIwP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 04:52:15 -0400
From: Alexander Stein <alexander.stein@systec-electronic.com>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Chris Ball <cjb@laptop.org>, Jesse Barnes <jbarnes@virtuousgeek.org>,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org,
        Alexander Stein <alexander.stein@systec-electronic.com>
Subject: [PATCH v2] mmc: sdhci: check interrupt flags in ISR again
Date: Wed, 14 Mar 2012 09:52:10 +0100
Message-Id: <1331715130-8505-1-git-send-email-alexander.stein@systec-electronic.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <4F60532E.4070103@intel.com>
References: <4F60532E.4070103@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When using MSI it is possible that a new MSI is sent while an earlier
MSI is currently handled. In this case SDHCI_INT_STATUS only contains
SDHCI_INT_RESPONSE and the ISR would not be called again. But at the end
of the ISR SDHCI_INT_DATA_END is now also pending which would be ignored.

Fix this by rereading the interrupt flags in the ISR until no interrupt
we care is pending.

Signed-off-by: Alexander Stein <alexander.stein@systec-electronic.com>
---
Changes in v2:
* rearranged code a bit and added a maximum loop counter as suggested
  by Adrian

 drivers/mmc/host/sdhci.c |   19 ++++++++++++-------
 1 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index 8d66706..4fe4461 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -2267,8 +2267,8 @@ static irqreturn_t sdhci_irq(int irq, void *dev_id)
 {
 	irqreturn_t result;
 	struct sdhci_host *host = dev_id;
-	u32 intmask;
-	int cardint = 0;
+	u32 intmask, unexpected = 0;
+	int cardint = 0, max_loops = 16;
 
 	spin_lock(&host->lock);
 
@@ -2286,6 +2286,7 @@ static irqreturn_t sdhci_irq(int irq, void *dev_id)
 		goto out;
 	}
 
+again:
 	DBG("*** %s got interrupt: 0x%08x\n",
 		mmc_hostname(host->mmc), intmask);
 
@@ -2344,19 +2345,23 @@ static irqreturn_t sdhci_irq(int irq, void *dev_id)
 	intmask &= ~SDHCI_INT_CARD_INT;
 
 	if (intmask) {
-		pr_err("%s: Unexpected interrupt 0x%08x.\n",
-			mmc_hostname(host->mmc), intmask);
-		sdhci_dumpregs(host);
-
+		unexpected |= intmask;
 		sdhci_writel(host, intmask, SDHCI_INT_STATUS);
 	}
 
 	result = IRQ_HANDLED;
 
-	mmiowb();
+	intmask = sdhci_readl(host, SDHCI_INT_STATUS);
+	if (intmask && --max_loops)
+		goto again;
 out:
 	spin_unlock(&host->lock);
 
+	if (unexpected) {
+		pr_err("%s: Unexpected interrupt 0x%08x.\n",
+			   mmc_hostname(host->mmc), unexpected);
+		sdhci_dumpregs(host);
+	}
 	/*
 	 * We have to delay this as it calls back into the driver.
 	 */
-- 
1.7.3.4

