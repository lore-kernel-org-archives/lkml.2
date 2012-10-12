Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945937Ab2JLPPm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 11:15:42 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:49130 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422771Ab2JLPPe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 11:15:34 -0400
From: Rob Herring <robherring2@gmail.com>
To: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc: jonathan@jonmasters.org, eric.dumazet@gmail.com,
        Mark Langsdorf <mark.langsdorf@calxeda.com>,
        Rob Herring <rob.herring@calxeda.com>
Subject: [PATCH 3/6] net: calxedaxgmac: use relaxed i/o accessors in rx and tx paths
Date: Fri, 12 Oct 2012 10:15:05 -0500
Message-Id: <1350054908-30646-4-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1350054908-30646-1-git-send-email-robherring2@gmail.com>
References: <1350054908-30646-1-git-send-email-robherring2@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <rob.herring@calxeda.com>

The standard readl/writel accessors involve a spinlock and cache sync
operation on ARM platforms with an outer cache. Only DMA triggering
accesses need this, so use the relaxed variants instead.

Signed-off-by: Rob Herring <rob.herring@calxeda.com>
---
 drivers/net/ethernet/calxeda/Kconfig |    2 +-
 drivers/net/ethernet/calxeda/xgmac.c |   12 ++++++------
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/calxeda/Kconfig b/drivers/net/ethernet/calxeda/Kconfig
index aba435c..6a4ddf6 100644
--- a/drivers/net/ethernet/calxeda/Kconfig
+++ b/drivers/net/ethernet/calxeda/Kconfig
@@ -1,6 +1,6 @@
 config NET_CALXEDA_XGMAC
 	tristate "Calxeda 1G/10G XGMAC Ethernet driver"
-	depends on HAS_IOMEM
+	depends on HAS_IOMEM && ARM
 	select CRC32
 	help
 	  This is the driver for the XGMAC Ethernet IP block found on Calxeda
diff --git a/drivers/net/ethernet/calxeda/xgmac.c b/drivers/net/ethernet/calxeda/xgmac.c
index 728fcef..117839e 100644
--- a/drivers/net/ethernet/calxeda/xgmac.c
+++ b/drivers/net/ethernet/calxeda/xgmac.c
@@ -1203,7 +1203,7 @@ static int xgmac_poll(struct napi_struct *napi, int budget)
 
 	if (work_done < budget) {
 		napi_complete(napi);
-		writel(DMA_INTR_DEFAULT_MASK, priv->base + XGMAC_DMA_INTR_ENA);
+		writel_relaxed(DMA_INTR_DEFAULT_MASK, priv->base + XGMAC_DMA_INTR_ENA);
 	}
 	return work_done;
 }
@@ -1348,7 +1348,7 @@ static irqreturn_t xgmac_pmt_interrupt(int irq, void *dev_id)
 	struct xgmac_priv *priv = netdev_priv(dev);
 	void __iomem *ioaddr = priv->base;
 
-	intr_status = readl(ioaddr + XGMAC_INT_STAT);
+	intr_status = readl_relaxed(ioaddr + XGMAC_INT_STAT);
 	if (intr_status & XGMAC_INT_STAT_PMT) {
 		netdev_dbg(priv->dev, "received Magic frame\n");
 		/* clear the PMT bits 5 and 6 by reading the PMT */
@@ -1366,9 +1366,9 @@ static irqreturn_t xgmac_interrupt(int irq, void *dev_id)
 	struct xgmac_extra_stats *x = &priv->xstats;
 
 	/* read the status register (CSR5) */
-	intr_status = readl(priv->base + XGMAC_DMA_STATUS);
-	intr_status &= readl(priv->base + XGMAC_DMA_INTR_ENA);
-	writel(intr_status, priv->base + XGMAC_DMA_STATUS);
+	intr_status = readl_relaxed(priv->base + XGMAC_DMA_STATUS);
+	intr_status &= readl_relaxed(priv->base + XGMAC_DMA_INTR_ENA);
+	writel_relaxed(intr_status, priv->base + XGMAC_DMA_STATUS);
 
 	/* It displays the DMA process states (CSR5 register) */
 	/* ABNORMAL interrupts */
@@ -1404,7 +1404,7 @@ static irqreturn_t xgmac_interrupt(int irq, void *dev_id)
 
 	/* TX/RX NORMAL interrupts */
 	if (intr_status & (DMA_STATUS_RI | DMA_STATUS_TU)) {
-		writel(DMA_INTR_ABNORMAL, priv->base + XGMAC_DMA_INTR_ENA);
+		writel_relaxed(DMA_INTR_ABNORMAL, priv->base + XGMAC_DMA_INTR_ENA);
 		napi_schedule(&priv->napi);
 	}
 
-- 
1.7.9.5

