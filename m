Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755570Ab1ALSUZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 13:20:25 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:39077 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755460Ab1ALSUX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 13:20:23 -0500
From: Per Forlin <per.forlin@linaro.org>
To: linux-mmc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org
Cc: Chris Ball <cjb@laptop.org>, Ulf Hansson <ulf.hansson@stericsson.com>
Subject: [FYI 1/4] mmci: fixup broken_blockend variant patch
Date: Wed, 12 Jan 2011 19:19:40 +0100
Message-Id: <1294856383-14187-2-git-send-email-per.forlin@linaro.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1294856383-14187-1-git-send-email-per.forlin@linaro.org>
References: <1294856383-14187-1-git-send-email-per.forlin@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ulf Hansson <ulf.hansson@stericsson.com>

NOT to be mainlined, only sets the base for the double
buffer example implementation. The DMA implemenation for
MMCI is under development.

host->last_blockend flag is now set only for the last
MCI_DATABLOCKEND, the previous code would just react to
any blockend, which was buggy. Consolidate Ux500 and U300
bug flags to a single one and use only the MCI_DATAEND irq
on U300 as well, this is faster anyway.

Also make sure the MCI_DATABLOCKENDMASK is set only when
needed, instead of being set always and then masked off.

Tested successfully on Ux500, U300 and ARM RealView
PB1176.
---
 drivers/mmc/host/mmci.c |   45 ++++++++++++++++++++++-----------------------
 drivers/mmc/host/mmci.h |    4 ++--
 2 files changed, 24 insertions(+), 25 deletions(-)

diff --git a/drivers/mmc/host/mmci.c b/drivers/mmc/host/mmci.c
index 5630228..aafede4 100644
--- a/drivers/mmc/host/mmci.c
+++ b/drivers/mmc/host/mmci.c
@@ -48,8 +48,6 @@ static unsigned int fmax = 515633;
  *		  is asserted (likewise for RX)
  * @broken_blockend: the MCI_DATABLOCKEND is broken on the hardware
  *		and will not work at all.
- * @broken_blockend_dma: the MCI_DATABLOCKEND is broken on the hardware when
- *		using DMA.
  * @sdio: variant supports SDIO
  * @st_clkdiv: true if using a ST-specific clock divider algorithm
  */
@@ -60,7 +58,6 @@ struct variant_data {
 	unsigned int		fifosize;
 	unsigned int		fifohalfsize;
 	bool			broken_blockend;
-	bool			broken_blockend_dma;
 	bool			sdio;
 	bool			st_clkdiv;
 };
@@ -76,7 +73,7 @@ static struct variant_data variant_u300 = {
 	.fifohalfsize		= 8 * 4,
 	.clkreg_enable		= 1 << 13, /* HWFCEN */
 	.datalength_bits	= 16,
-	.broken_blockend_dma	= true,
+	.broken_blockend	= true,
 	.sdio			= true,
 };
 
@@ -199,7 +196,7 @@ static void mmci_init_sg(struct mmci_host *host, struct mmc_data *data)
 static void mmci_start_data(struct mmci_host *host, struct mmc_data *data)
 {
 	struct variant_data *variant = host->variant;
-	unsigned int datactrl, timeout, irqmask;
+	unsigned int datactrl, timeout, irqmask0, irqmask1;
 	unsigned long long clks;
 	void __iomem *base;
 	int blksz_bits;
@@ -210,7 +207,7 @@ static void mmci_start_data(struct mmci_host *host, struct mmc_data *data)
 	host->data = data;
 	host->size = data->blksz * data->blocks;
 	host->data_xfered = 0;
-	host->blockend = false;
+	host->last_blockend = false;
 	host->dataend = false;
 
 	mmci_init_sg(host, data);
@@ -230,20 +227,20 @@ static void mmci_start_data(struct mmci_host *host, struct mmc_data *data)
 	datactrl = MCI_DPSM_ENABLE | blksz_bits << 4;
 	if (data->flags & MMC_DATA_READ) {
 		datactrl |= MCI_DPSM_DIRECTION;
-		irqmask = MCI_RXFIFOHALFFULLMASK;
+		irqmask1 = MCI_RXFIFOHALFFULLMASK;
 
 		/*
 		 * If we have less than a FIFOSIZE of bytes to transfer,
 		 * trigger a PIO interrupt as soon as any data is available.
 		 */
 		if (host->size < variant->fifosize)
-			irqmask |= MCI_RXDATAAVLBLMASK;
+			irqmask1 |= MCI_RXDATAAVLBLMASK;
 	} else {
 		/*
 		 * We don't actually need to include "FIFO empty" here
 		 * since its implicit in "FIFO half empty".
 		 */
-		irqmask = MCI_TXFIFOHALFEMPTYMASK;
+		irqmask1 = MCI_TXFIFOHALFEMPTYMASK;
 	}
 
 	/* The ST Micro variants has a special bit to enable SDIO */
@@ -252,8 +249,14 @@ static void mmci_start_data(struct mmci_host *host, struct mmc_data *data)
 			datactrl |= MCI_ST_DPSM_SDIOEN;
 
 	writel(datactrl, base + MMCIDATACTRL);
-	writel(readl(base + MMCIMASK0) & ~MCI_DATAENDMASK, base + MMCIMASK0);
-	mmci_set_mask1(host, irqmask);
+	irqmask0 = readl(base + MMCIMASK0);
+	if (variant->broken_blockend)
+		irqmask0 &= ~MCI_DATABLOCKENDMASK;
+	else
+		irqmask0 |= MCI_DATABLOCKENDMASK;
+	irqmask0 &= ~MCI_DATAENDMASK;
+	writel(irqmask0, base + MMCIMASK0);
+	mmci_set_mask1(host, irqmask1);
 }
 
 static void
@@ -301,7 +304,7 @@ mmci_data_irq(struct mmci_host *host, struct mmc_data *data,
 			data->error = -EIO;
 
 		/* Force-complete the transaction */
-		host->blockend = true;
+		host->last_blockend = true;
 		host->dataend = true;
 
 		/*
@@ -337,7 +340,7 @@ mmci_data_irq(struct mmci_host *host, struct mmc_data *data,
 	 *
 	 * In the U300, the IRQs can arrive out-of-order,
 	 * e.g. MCI_DATABLOCKEND sometimes arrives after MCI_DATAEND,
-	 * so for this case we use the flags "blockend" and
+	 * so for this case we use the flags "last_blockend" and
 	 * "dataend" to make sure both IRQs have arrived before
 	 * concluding the transaction. (This does not apply
 	 * to the Ux500 which doesn't fire MCI_DATABLOCKEND
@@ -353,7 +356,8 @@ mmci_data_irq(struct mmci_host *host, struct mmc_data *data,
 		 */
 		if (!variant->broken_blockend)
 			host->data_xfered += data->blksz;
-		host->blockend = true;
+		if (host->data_xfered == data->blksz * data->blocks)
+			host->last_blockend = true;
 	}
 
 	if (status & MCI_DATAEND)
@@ -364,11 +368,12 @@ mmci_data_irq(struct mmci_host *host, struct mmc_data *data,
 	 * on others we must sync with the blockend signal since they can
 	 * appear out-of-order.
 	 */
-	if (host->dataend && (host->blockend || variant->broken_blockend)) {
+	if (host->dataend &&
+	    (host->last_blockend || variant->broken_blockend)) {
 		mmci_stop_data(host);
 
 		/* Reset these flags */
-		host->blockend = false;
+		host->last_blockend = false;
 		host->dataend = false;
 
 		/*
@@ -770,7 +775,6 @@ static int __devinit mmci_probe(struct amba_device *dev, struct amba_id *id)
 	struct variant_data *variant = id->data;
 	struct mmci_host *host;
 	struct mmc_host *mmc;
-	unsigned int mask;
 	int ret;
 
 	/* must have platform data */
@@ -951,12 +955,7 @@ static int __devinit mmci_probe(struct amba_device *dev, struct amba_id *id)
 			goto irq0_free;
 	}
 
-	mask = MCI_IRQENABLE;
-	/* Don't use the datablockend flag if it's broken */
-	if (variant->broken_blockend)
-		mask &= ~MCI_DATABLOCKEND;
-
-	writel(mask, host->base + MMCIMASK0);
+	writel(MCI_IRQENABLE, host->base + MMCIMASK0);
 
 	amba_set_drvdata(dev, mmc);
 
diff --git a/drivers/mmc/host/mmci.h b/drivers/mmc/host/mmci.h
index df06f01..7ac8c4d 100644
--- a/drivers/mmc/host/mmci.h
+++ b/drivers/mmc/host/mmci.h
@@ -137,7 +137,7 @@
 #define MCI_IRQENABLE	\
 	(MCI_CMDCRCFAILMASK|MCI_DATACRCFAILMASK|MCI_CMDTIMEOUTMASK|	\
 	MCI_DATATIMEOUTMASK|MCI_TXUNDERRUNMASK|MCI_RXOVERRUNMASK|	\
-	MCI_CMDRESPENDMASK|MCI_CMDSENTMASK|MCI_DATABLOCKENDMASK)
+	MCI_CMDRESPENDMASK|MCI_CMDSENTMASK)
 
 /* These interrupts are directed to IRQ1 when two IRQ lines are available */
 #define MCI_IRQ1MASK \
@@ -177,7 +177,7 @@ struct mmci_host {
 	struct timer_list	timer;
 	unsigned int		oldstat;
 
-	bool			blockend;
+	bool			last_blockend;
 	bool			dataend;
 
 	/* pio stuff */
-- 
1.7.1

