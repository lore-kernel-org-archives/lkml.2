Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757032Ab0GNNI7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 09:08:59 -0400
Received: from imap.ru.mvista.com ([213.79.90.228]:18738 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756743Ab0GNNIF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 09:08:05 -0400
Date: Wed, 14 Jul 2010 17:08:03 +0400
From: Anton Vorontsov <avorontsov@mvista.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Wolfram Sang <w.sang@pengutronix.de>,
        Albert Herranz <albert_herranz@yahoo.es>,
        Matt Fleming <matt@console-pimps.org>, Ben Dooks <ben-linux@fluff.org>,
        Pierre Ossman <pierre@ossman.eu>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: [PATCH 4/8] sdhci: Use threaded IRQ handler
Message-ID: <20100714130803.GD517@oksana.dev.rtsoft.ru>
References: <20100714130728.GA27339@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20100714130728.GA27339@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We only need atomic context to disable SDHCI interrupts, after that
we can run in a kernel thread.

Note that irq handler still grabs an irqsave spinlock, we'll deal
with it in a subsequent patch.

Signed-off-by: Anton Vorontsov <avorontsov@mvista.com>
---
 drivers/mmc/host/sdhci.c |   47 +++++++++++++++++++++++++++------------------
 1 files changed, 28 insertions(+), 19 deletions(-)

diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index 9ec245c..0358b35 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -1506,9 +1506,8 @@ static void sdhci_data_irq(struct sdhci_host *host, u32 intmask)
 	}
 }
 
-static irqreturn_t sdhci_irq(int irq, void *dev_id)
+static irqreturn_t sdhci_irq_thread(int irq, void *dev_id)
 {
-	irqreturn_t result;
 	struct sdhci_host* host = dev_id;
 	u32 intmask;
 	int cardint = 0;
@@ -1516,17 +1515,8 @@ static irqreturn_t sdhci_irq(int irq, void *dev_id)
 	spin_lock(&host->lock);
 
 	intmask = sdhci_readl(host, SDHCI_INT_STATUS);
-
-	if (!intmask || intmask == 0xffffffff) {
-		result = IRQ_NONE;
-		goto out;
-	}
-
 	sdhci_writel(host, intmask, SDHCI_INT_STATUS);
 
-	DBG("*** %s got interrupt: 0x%08x\n",
-		mmc_hostname(host->mmc), intmask);
-
 	if (intmask & (SDHCI_INT_CARD_INSERT | SDHCI_INT_CARD_REMOVE))
 		schedule_work(&host->card_detect_work);
 
@@ -1559,10 +1549,8 @@ static irqreturn_t sdhci_irq(int irq, void *dev_id)
 		sdhci_dumpregs(host);
 	}
 
-	result = IRQ_HANDLED;
-
 	mmiowb();
-out:
+
 	spin_unlock(&host->lock);
 
 	/*
@@ -1571,7 +1559,28 @@ out:
 	if (cardint)
 		mmc_signal_sdio_irq(host->mmc);
 
-	return result;
+	/* Restore interrupts */
+	intmask = sdhci_readl(host, SDHCI_INT_ENABLE);
+	sdhci_writel(host, intmask, SDHCI_SIGNAL_ENABLE);
+
+	return IRQ_HANDLED;
+}
+
+static irqreturn_t sdhci_irq(int irq, void *dev_id)
+{
+	struct sdhci_host *host = dev_id;
+	u32 intmask = sdhci_readl(host, SDHCI_INT_STATUS);
+
+	if (!intmask || intmask == 0xffffffff)
+		return IRQ_NONE;
+
+	/* Disable interrupts */
+	sdhci_writel(host, 0, SDHCI_SIGNAL_ENABLE);
+
+	DBG("*** %s got interrupt: 0x%08x\n",
+		mmc_hostname(host->mmc), intmask);
+
+	return IRQ_WAKE_THREAD;
 }
 
 /*****************************************************************************\
@@ -1608,8 +1617,8 @@ int sdhci_resume_host(struct sdhci_host *host)
 			host->ops->enable_dma(host);
 	}
 
-	ret = request_irq(host->irq, sdhci_irq, IRQF_SHARED,
-			  mmc_hostname(host->mmc), host);
+	ret = request_threaded_irq(host->irq, sdhci_irq, sdhci_irq_thread,
+			  IRQF_SHARED, mmc_hostname(host->mmc), host);
 	if (ret)
 		return ret;
 
@@ -1868,8 +1877,8 @@ int sdhci_add_host(struct sdhci_host *host)
 
 	INIT_DELAYED_WORK(&host->timeout_work, sdhci_timeout_work);
 
-	ret = request_irq(host->irq, sdhci_irq, IRQF_SHARED,
-		mmc_hostname(mmc), host);
+	ret = request_threaded_irq(host->irq, sdhci_irq, sdhci_irq_thread,
+			  IRQF_SHARED, mmc_hostname(host->mmc), host);
 	if (ret)
 		return ret;
 
-- 
1.7.0.5

