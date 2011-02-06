Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753529Ab1BFSDa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 13:03:30 -0500
Received: from mga01.intel.com ([192.55.52.88]:50627 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753488Ab1BFSD2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 13:03:28 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,434,1291622400"; 
   d="scan'208";a="884836443"
From: Pierre Tardy <pierre.tardy@intel.com>
To: linux-pm@lists.linux-foundation.org, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Pierre Tardy <tardyp@gmail.com>
Subject: [PATCH v2 3/3] sdhci:v2:use ios->clock to know when sdhci is idle
Date: Sun,  6 Feb 2011 19:02:50 +0100
Message-Id: <430729a58c5efc725455e1985b1facca8f784c92.1297014479.git.pierre.tardy@intel.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <cover.1297014479.git.pierre.tardy@intel.com>
References: <cover.1297014479.git.pierre.tardy@intel.com>
In-Reply-To: <cover.1297014479.git.pierre.tardy@intel.com>
References: <cover.1297014479.git.pierre.tardy@intel.com>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pierre Tardy <tardyp@gmail.com>

This allows sdhci to detect its own activity and to autosuspend
when not used

inspired from  mmci: handle clock frequency 0 properly
>From Linus Walleij <linus.walleij@stericsson.com>
author of mmc aggressive clock gating fw.

The idea of using mmc clock gating fw in order to power gate the
sdhci is simple (it still need some other get/set because set_ios() is
not cause first before any other acticity):
Whenever the mmc fw tells we dont need the MMC clock, we dont need
the sdhci power as well.

This does not mean that the child (card) is
suspended. In case of a Wifi SDIO card, the card will be suspended
and resumed according to the ifconfig up/down status.
Even if the Wifi interface is up, user might not use the network.
Sdhci can be powered off during those period. It is up to the HW
implementation to implement smart enough power gating to still
support enough always-on circuitry allowing to detect sdio
interrupts.

Acked-by: Linus Walleij <linus.walleij@stericsson.com>

Signed-off-by: Pierre Tardy <tardyp@gmail.com>
---
 drivers/mmc/host/sdhci-pci.c |    3 +++
 drivers/mmc/host/sdhci.c     |   29 +++++++++++++++++++++++++++++
 include/linux/mmc/sdhci.h    |    1 +
 3 files changed, 33 insertions(+), 0 deletions(-)

diff --git a/drivers/mmc/host/sdhci-pci.c b/drivers/mmc/host/sdhci-pci.c
index 22581a1..9d23f4c 100644
--- a/drivers/mmc/host/sdhci-pci.c
+++ b/drivers/mmc/host/sdhci-pci.c
@@ -1086,6 +1086,9 @@ static int __devinit sdhci_pci_probe(struct pci_dev *pdev,
 	}
 	pm_runtime_enable(&pdev->dev);
 	pm_runtime_allow(&pdev->dev);
+	pm_runtime_set_autosuspend_delay(&pdev->dev, 50);
+	pm_runtime_use_autosuspend(&pdev->dev);
+	pm_suspend_ignore_children(&pdev->dev, 1);
 
 	return 0;
 
diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index 3e65d94..655617c 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -20,6 +20,7 @@
 #include <linux/slab.h>
 #include <linux/scatterlist.h>
 #include <linux/regulator/consumer.h>
+#include <linux/pm_runtime.h>
 
 #include <linux/leds.h>
 
@@ -1161,6 +1162,7 @@ static void sdhci_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
 {
 	struct sdhci_host *host;
 	unsigned long flags;
+	unsigned int lastclock;
 	u8 ctrl;
 
 	host = mmc_priv(mmc);
@@ -1171,6 +1173,27 @@ static void sdhci_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
 		goto out;
 
 	/*
+	 * get/put runtime_pm usage counter at ios->clock transitions
+	 * We need to do it before any other chip access, as sdhci could
+	 * be power gated
+	 */
+	lastclock = host->iosclock;
+	host->iosclock = ios->clock;
+	if (lastclock == 0 && ios->clock != 0) {
+		spin_unlock_irqrestore(&host->lock, flags);
+		pm_runtime_get_sync(host->mmc->parent);
+		spin_lock_irqsave(&host->lock, flags);
+	} else if (lastclock != 0 && ios->clock == 0) {
+		spin_unlock_irqrestore(&host->lock, flags);
+		pm_runtime_mark_last_busy(host->mmc->parent);
+		pm_runtime_put_autosuspend(host->mmc->parent);
+		spin_lock_irqsave(&host->lock, flags);
+	}
+	/* no need to configure the rest.. */
+	if (host->iosclock == 0)
+		goto out;
+
+	/*
 	 * Reset the chip on each power off.
 	 * Should clear out any weird states.
 	 */
@@ -1244,6 +1267,8 @@ static int sdhci_get_ro(struct mmc_host *mmc)
 	int is_readonly;
 
 	host = mmc_priv(mmc);
+	/* this function is called before set_ios... */
+	pm_runtime_get_sync(mmc->parent);
 
 	spin_lock_irqsave(&host->lock, flags);
 
@@ -1257,6 +1282,7 @@ static int sdhci_get_ro(struct mmc_host *mmc)
 
 	spin_unlock_irqrestore(&host->lock, flags);
 
+	pm_runtime_put_autosuspend(mmc->parent);
 	/* This quirk needs to be replaced by a callback-function later */
 	return host->quirks & SDHCI_QUIRK_INVERTED_WRITE_PROTECT ?
 		!is_readonly : is_readonly;
@@ -1268,6 +1294,7 @@ static void sdhci_enable_sdio_irq(struct mmc_host *mmc, int enable)
 	unsigned long flags;
 
 	host = mmc_priv(mmc);
+	pm_runtime_get_sync(mmc->parent);
 
 	spin_lock_irqsave(&host->lock, flags);
 
@@ -1282,6 +1309,7 @@ out:
 	mmiowb();
 
 	spin_unlock_irqrestore(&host->lock, flags);
+	pm_runtime_put_autosuspend(mmc->parent);
 }
 
 static const struct mmc_host_ops sdhci_ops = {
@@ -1766,6 +1794,7 @@ struct sdhci_host *sdhci_alloc_host(struct device *dev,
 
 	host = mmc_priv(mmc);
 	host->mmc = mmc;
+	host->iosclock = 0;
 
 	return host;
 }
diff --git a/include/linux/mmc/sdhci.h b/include/linux/mmc/sdhci.h
index 83bd9f7..a38d040 100644
--- a/include/linux/mmc/sdhci.h
+++ b/include/linux/mmc/sdhci.h
@@ -116,6 +116,7 @@ struct sdhci_host {
 	unsigned int timeout_clk;	/* Timeout freq (KHz) */
 
 	unsigned int clock;	/* Current clock (MHz) */
+	unsigned int iosclock;	/* Last clock asked via set_ios  */
 	u8 pwr;			/* Current voltage */
 
 	struct mmc_request *mrq;	/* Current request */
-- 
1.7.2.3

---------------------------------------------------------------------
Intel Corporation SAS (French simplified joint stock company)
Registered headquarters: "Les Montalets"- 2, rue de Paris, 
92196 Meudon Cedex, France
Registration Number:  302 456 199 R.C.S. NANTERRE
Capital: 4,572,000 Euros

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

