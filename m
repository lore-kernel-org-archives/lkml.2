Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753289Ab0LVNUu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 08:20:50 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:42544 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751863Ab0LVNUs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 08:20:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=AFi1tmJMl6f4aukYHZf3rHhvS5hRwvheilCj5IN/L1k2G83uAbYiR1M2ihCMGXWxCO
         iIYCCrL94Y58Yrgf8gT6ftLtKkPcyhjQn9vuZfIllJBEt+agD/19emE2ysPg5zxkSx9Z
         kdx66Fo9bGx4hDwmOssKXPCNm1BIdfMJLfqDg=
From: Pierre Tardy <tardyp@gmail.com>
To: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Pierre Tardy <tardyp@gmail.com>, Chris Ball <cjb@laptop.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alan Cox <alan@linux.intel.com>, Takashi Iwai <tiwai@suse.de>,
        Maxim Levitsky <maximlevitsky@gmail.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Ohad Ben-Cohen <ohad@wizery.com>, Yunpeng Gao <yunpeng.gao@intel.com>
Subject: [RFC] sdhci: use ios->clock to know when sdhci is idle
Date: Wed, 22 Dec 2010 14:13:41 +0100
Message-Id: <1293023621-3077-1-git-send-email-tardyp@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This allows sdhci to detect its own activity and to autosuspend
when not used

inspired from  mmci: handle clock frequency 0 properly
>From Linus Walleij <linus.walleij@stericsson.com>
author of mmc aggressive clock gating fw.

The idea of using mmc clock gating fw in order to power gate the
sdhci is simple (hope no too simplistic):
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

This patch goes on top of Yunpeng's patch available on patchwork:
378052 [v2,2/3] mmc: enable runtime PM support of sdhci host controller

CC: Chris Ball <cjb@laptop.org>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: Alan Cox <alan@linux.intel.com>
CC: Takashi Iwai <tiwai@suse.de>
CC: Maxim Levitsky <maximlevitsky@gmail.com>
CC: Linus Walleij <linus.walleij@stericsson.com>
CC: Ohad Ben-Cohen <ohad@wizery.com>
CC: Yunpeng Gao <yunpeng.gao@intel.com>

Signed-off-by: Pierre Tardy <tardyp@gmail.com>
---
 drivers/mmc/host/sdhci.c  |   20 ++++++++++++++++++++
 include/linux/mmc/sdhci.h |    1 +
 2 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index a298fb0..a648330 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -1161,6 +1161,7 @@ static void sdhci_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
 {
 	struct sdhci_host *host;
 	unsigned long flags;
+        unsigned int lastclock;
 	u8 ctrl;
 
 	host = mmc_priv(mmc);
@@ -1171,6 +1172,24 @@ static void sdhci_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
 		goto out;
 
 	/*
+	 * get/put runtime_pm usage counter at ios->clock transitions
+         * We need to do it before any other chip access, as sdhci could
+         * be power gated
+	 */
+        lastclock = host->iosclock;
+        host->iosclock = ios->clock;
+	if (lastclock == 0 && ios->clock != 0) {
+		spin_unlock_irqrestore(&host->lock, flags);
+		pm_runtime_get_sync(&host->parent.dev);
+		spin_lock_irqsave(&host->lock, flags);
+	} else if (lastclock != 0 && ios->clock == 0) {
+		spin_unlock_irqrestore(&host->lock, flags);
+		pm_runtime_put_autosuspend(&host->parent.dev);
+		spin_lock_irqsave(&host->lock, flags);
+		/* no need to configure the rest.. */
+		goto out;
+	}
+	/*
 	 * Reset the chip on each power off.
 	 * Should clear out any weird states.
 	 */
@@ -1779,6 +1798,7 @@ struct sdhci_host *sdhci_alloc_host(struct device *dev,
 
 	host = mmc_priv(mmc);
 	host->mmc = mmc;
+	host->iosclock = 0;
 
 	return host;
 }
diff --git a/include/linux/mmc/sdhci.h b/include/linux/mmc/sdhci.h
index 0d953f5..78c1528 100644
--- a/include/linux/mmc/sdhci.h
+++ b/include/linux/mmc/sdhci.h
@@ -114,6 +114,7 @@ struct sdhci_host {
 	unsigned int timeout_clk;	/* Timeout freq (KHz) */
 
 	unsigned int clock;	/* Current clock (MHz) */
+	unsigned int iosclock;	/* Last clock asked via set_ios  */
 	u8 pwr;			/* Current voltage */
 
 	struct mmc_request *mrq;	/* Current request */
-- 
1.7.1

