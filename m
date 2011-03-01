Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756728Ab1CASQ1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 13:16:27 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:59213 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756286Ab1CASPw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 13:15:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=yBbQ7xgFABEtjLb+27xXVU80bK/f7Ix3dIUIRFgDCEXafYUqaz66GabAIzSlIctE2g
         Lj5yjvIL+Zoj9KstcbRmrJaOSklvDfzWfx09sEsi1KTdE+EgRG/ViNND4j2zstKqklgr
         9MwjfHnYn6KNNGLKamGq2Rwgt7VXzHT6gSyrc=
From: Pierre Tardy <tardyp@gmail.com>
To: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
        linux-mmc@vger.kernel.org
Cc: Pierre Tardy <tardyp@gmail.com>
Subject: [RFC,PATCHv3 2/3] mmc: sdhci: use ios->clock to know when sdhci is idle
Date: Tue,  1 Mar 2011 19:15:32 +0100
Message-Id: <5def72b6b40c10672753fe04a7ad49b394e70706.1298820826.git.tardyp@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <cover.1298820825.git.tardyp@gmail.com>
References: <cover.1298820825.git.tardyp@gmail.com>
In-Reply-To: <cover.1298820825.git.tardyp@gmail.com>
References: <cover.1298820825.git.tardyp@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
index f167a55..1b5e70b 100644
--- a/drivers/mmc/host/sdhci-pci.c
+++ b/drivers/mmc/host/sdhci-pci.c
@@ -1089,6 +1089,9 @@ static int __devinit sdhci_pci_probe(struct pci_dev *pdev,
 
 		chip->slots[i] = slot;
 	}
+	pm_runtime_set_autosuspend_delay(&pdev->dev, 50);
+	pm_runtime_use_autosuspend(&pdev->dev);
+	pm_suspend_ignore_children(&pdev->dev, 1);
 	pm_runtime_put_noidle(&pdev->dev);
 	return 0;
 
diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index cd79a28..735c3f7 100644
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
1.7.1

