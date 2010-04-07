Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757868Ab0DGXNw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 19:13:52 -0400
Received: from mail.df.lth.se ([194.47.250.12]:65488 "EHLO df.lth.se"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757581Ab0DGXNr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 19:13:47 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: akpm@linux-foundation.org,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       Grant Likely <grant.likely@secretlab.ca>,
       Dan Williams <dan.j.williams@intel.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-mmc@vger.kernel.org,
       STEricsson_nomadik_linux@list.st.com, linux-kernel@vger.kernel.org,
       Linus Walleij <linus.walleij@stericsson.com>
Subject: [PATCH 07/11] ARM: add PrimeCell generic DMA to MMCI/PL180 v5
Date: Thu,  8 Apr 2010 01:13:15 +0200
Message-Id: <1270681995-6281-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.6.2.rc1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This extends the MMCI/PL180 driver with generic DMA engine support
using the PrimeCell DMA engine interface.

Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
---
 drivers/mmc/host/mmci.c   |  290 ++++++++++++++++++++++++++++++++++++++-------
 drivers/mmc/host/mmci.h   |    7 +-
 include/linux/amba/mmci.h |   16 +++
 3 files changed, 268 insertions(+), 45 deletions(-)

diff --git a/drivers/mmc/host/mmci.c b/drivers/mmc/host/mmci.c
index ff115d9..37ab678 100644
--- a/drivers/mmc/host/mmci.c
+++ b/drivers/mmc/host/mmci.c
@@ -2,7 +2,7 @@
  *  linux/drivers/mmc/host/mmci.c - ARM PrimeCell MMCI PL180/1 driver
  *
  *  Copyright (C) 2003 Deep Blue Solutions, Ltd, All Rights Reserved.
- *  Copyright (C) 2010 ST-Ericsson AB.
+ *  Copyright (C) 2010 ST-Ericsson SA
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -23,8 +23,11 @@
 #include <linux/clk.h>
 #include <linux/scatterlist.h>
 #include <linux/gpio.h>
-#include <linux/amba/mmci.h>
 #include <linux/regulator/consumer.h>
+#include <linux/dmaengine.h>
+#include <linux/dma-mapping.h>
+#include <linux/amba/dma.h>
+#include <linux/amba/mmci.h>
 
 #include <asm/cacheflush.h>
 #include <asm/div64.h>
@@ -98,12 +101,209 @@ static void mmci_stop_data(struct mmci_host *host)
 	host->data = NULL;
 }
 
+static void
+mmci_start_command(struct mmci_host *host, struct mmc_command *cmd, u32 c)
+{
+	void __iomem *base = host->base;
+
+	dev_dbg(mmc_dev(host->mmc), "op %02x arg %08x flags %08x\n",
+		cmd->opcode, cmd->arg, cmd->flags);
+
+	if (readl(base + MMCICOMMAND) & MCI_CPSM_ENABLE) {
+		writel(0, base + MMCICOMMAND);
+		udelay(1);
+	}
+
+	c |= cmd->opcode | MCI_CPSM_ENABLE;
+	if (cmd->flags & MMC_RSP_PRESENT) {
+		if (cmd->flags & MMC_RSP_136)
+			c |= MCI_CPSM_LONGRSP;
+		c |= MCI_CPSM_RESPONSE;
+	}
+	if (/*interrupt*/0)
+		c |= MCI_CPSM_INTERRUPT;
+
+	host->cmd = cmd;
+
+	writel(cmd->arg, base + MMCIARGUMENT);
+	writel(c, base + MMCICOMMAND);
+}
+
+/*
+ * All the DMA operation mode stuff goes inside this ifdef.
+ * This assumes that you have a generic DMA device interface,
+ * no custom DMA interfaces are supported.
+ */
+#ifdef CONFIG_DMADEVICES
+static void __devinit mmci_setup_dma(struct mmci_host *host)
+{
+	struct mmci_platform_data *plat = host->plat;
+	dma_cap_mask_t mask;
+
+	/* Try to acquire a generic DMA engine slave channel */
+	dma_cap_zero(mask);
+	dma_cap_set(DMA_SLAVE, mask);
+	/*
+	 * If only an RX channel is specified, the driver will
+	 * attempt to use it bidirectionally, however if it is
+	 * is specified but cannot be located, DMA will be disabled.
+	 */
+	host->dma_rx_channel = dma_request_channel(mask,
+						plat->dma_filter,
+						plat->dma_rx_param);
+	if (plat->dma_tx_param) {
+		host->dma_tx_channel = dma_request_channel(mask,
+							   plat->dma_filter,
+							   plat->dma_tx_param);
+		if (!host->dma_tx_channel) {
+			dma_release_channel(host->dma_rx_channel);
+			host->dma_rx_channel = NULL;
+		}
+	} else {
+		host->dma_tx_channel = host->dma_rx_channel;
+	}
+}
+
+static void __devexit mmci_disable_dma(struct mmci_host *host)
+{
+	if (host->dma_rx_channel)
+		dma_release_channel(host->dma_rx_channel);
+	if (host->dma_tx_channel)
+		dma_release_channel(host->dma_tx_channel);
+}
+
+static void mmci_dma_data_end(struct mmci_host *host)
+{
+	struct mmc_data *data = host->data;
+
+	dma_unmap_sg(mmc_dev(host->mmc), data->sg, data->sg_len,
+		     (data->flags & MMC_DATA_WRITE)
+		     ? DMA_TO_DEVICE : DMA_FROM_DEVICE);
+}
+
+static void mmci_dma_data_error(struct mmci_host *host)
+{
+	struct mmc_data *data = host->data;
+	struct dma_chan *chan;
+
+	dev_err(mmc_dev(host->mmc), "error during DMA transfer!\n");
+	if (data->flags & MMC_DATA_READ)
+		chan = host->dma_rx_channel;
+	else
+		chan = host->dma_tx_channel;
+	dma_unmap_sg(mmc_dev(host->mmc), data->sg, data->sg_len,
+		     (data->flags & MMC_DATA_WRITE)
+		     ? DMA_TO_DEVICE : DMA_FROM_DEVICE);
+	chan->device->device_control(chan, DMA_TERMINATE_ALL);
+}
+
+/*
+ * This one gets called repeatedly to copy data using
+ * DMA until there is no more data left to copy.
+ */
+static int mmci_dma_start_data(struct mmci_host *host, unsigned int datactrl)
+{
+	struct amba_dma_channel_config rx_conf = {
+		.addr = host->phybase + MMCIFIFO,
+		.addr_width = 4,
+		.direction = DMA_FROM_DEVICE,
+		.maxburst = 8,
+	};
+	struct amba_dma_channel_config tx_conf = {
+		.addr = host->phybase + MMCIFIFO,
+		.addr_width = 4,
+		.direction = DMA_TO_DEVICE,
+		.maxburst = 8,
+	};
+	struct mmc_data *data = host->data;
+	enum dma_data_direction direction;
+	struct dma_chan *chan;
+	struct dma_async_tx_descriptor *desc;
+	struct scatterlist *sg;
+	unsigned int sglen;
+	int i;
+
+	datactrl |= MCI_DPSM_DMAENABLE;
+	if (data->flags & MMC_DATA_READ) {
+		direction = DMA_FROM_DEVICE;
+		chan = host->dma_rx_channel;
+		dma_set_ambaconfig(chan, &rx_conf);
+	} else {
+		direction = DMA_TO_DEVICE;
+		chan = host->dma_tx_channel;
+		dma_set_ambaconfig(chan, &tx_conf);
+	}
+
+	/* Check for weird stuff in the sg list */
+	for_each_sg(data->sg, sg, data->sg_len, i) {
+		if (sg->offset & 3 || sg->length & 3)
+			return -EINVAL;
+	}
+
+	sglen = dma_map_sg(mmc_dev(host->mmc), data->sg,
+			   data->sg_len, direction);
+	if (sglen != data->sg_len)
+		goto unmap_exit;
+
+	desc = chan->device->device_prep_slave_sg(chan,
+					data->sg, data->sg_len, direction,
+					DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
+	if (!desc)
+		goto unmap_exit;
+
+	host->dma_desc = desc;
+	dev_vdbg(mmc_dev(host->mmc), "Submit MMCI DMA job, sglen %d "
+		 "blksz %04x blks %04x flags %08x\n",
+		 sglen, data->blksz, data->blocks, data->flags);
+	desc->tx_submit(desc);
+	chan->device->device_issue_pending(chan);
+
+	/* Trigger the DMA transfer */
+	writel(datactrl, host->base + MMCIDATACTRL);
+	/*
+	 * Let the MMCI say when the data is ended and it's time
+	 * to fire next DMA request. When that happens, MMCI will
+	 * call mmci_data_end()
+	 */
+	writel(readl(host->base + MMCIMASK0) | MCI_DATAENDMASK,
+	       host->base + MMCIMASK0);
+	return 0;
+
+unmap_exit:
+	dma_unmap_sg(mmc_dev(host->mmc), data->sg, sglen, direction);
+	return -ENOMEM;
+}
+#else
+/* Blank functions if the DMA engine is not available */
+static inline void mmci_setup_dma(struct mmci_host *host)
+{
+}
+
+static inline void mmci_disable_dma(struct mmci_host *host)
+{
+}
+
+static inline void mmci_dma_data_end(struct mmci_host *host)
+{
+}
+
+static inline void mmci_dma_data_error(struct mmci_host *host)
+{
+}
+
+static inline int mmci_dma_start_data(struct mmci_host *host, unsigned int datactrl)
+{
+	return -ENOSYS;
+}
+#endif
+
 static void mmci_start_data(struct mmci_host *host, struct mmc_data *data)
 {
 	unsigned int datactrl, timeout, irqmask;
 	unsigned long long clks;
 	void __iomem *base;
 	int blksz_bits;
+	int ret;
 
 	dev_dbg(mmc_dev(host->mmc), "blksz %04x blks %04x flags %08x\n",
 		data->blksz, data->blocks, data->flags);
@@ -112,8 +312,6 @@ static void mmci_start_data(struct mmci_host *host, struct mmc_data *data)
 	host->size = data->blksz;
 	host->data_xfered = 0;
 
-	mmci_init_sg(host, data);
-
 	clks = (unsigned long long)data->timeout_ns * host->cclk;
 	do_div(clks, 1000000000UL);
 
@@ -127,13 +325,30 @@ static void mmci_start_data(struct mmci_host *host, struct mmc_data *data)
 	BUG_ON(1 << blksz_bits != data->blksz);
 
 	datactrl = MCI_DPSM_ENABLE | blksz_bits << 4;
-	if (data->flags & MMC_DATA_READ) {
+
+	if (data->flags & MMC_DATA_READ)
 		datactrl |= MCI_DPSM_DIRECTION;
+
+	if (host->dma_rx_channel) {
+		/*
+		 * Attempt to use DMA operation mode, if this
+		 * should fail, fall back to PIO mode
+		 */
+		ret = mmci_dma_start_data(host, datactrl);
+		if (!ret)
+			return;
+	}
+
+	/* IRQ mode, map the SG list for CPU reading/writing */
+	mmci_init_sg(host, data);
+
+	if (data->flags & MMC_DATA_READ) {
 		irqmask = MCI_RXFIFOHALFFULLMASK;
 
 		/*
-		 * If we have less than a FIFOSIZE of bytes to transfer,
-		 * trigger a PIO interrupt as soon as any data is available.
+		 * If we have less than a FIFOSIZE of bytes to
+		 * transfer, trigger a PIO interrupt as soon as any
+		 * data is available.
 		 */
 		if (host->size < MCI_FIFOSIZE)
 			irqmask |= MCI_RXDATAAVLBLMASK;
@@ -146,39 +361,12 @@ static void mmci_start_data(struct mmci_host *host, struct mmc_data *data)
 	}
 
 	writel(datactrl, base + MMCIDATACTRL);
+	/* No interrupt when data ends */
 	writel(readl(base + MMCIMASK0) & ~MCI_DATAENDMASK, base + MMCIMASK0);
 	writel(irqmask, base + MMCIMASK1);
 }
 
 static void
-mmci_start_command(struct mmci_host *host, struct mmc_command *cmd, u32 c)
-{
-	void __iomem *base = host->base;
-
-	dev_dbg(mmc_dev(host->mmc), "op %02x arg %08x flags %08x\n",
-	    cmd->opcode, cmd->arg, cmd->flags);
-
-	if (readl(base + MMCICOMMAND) & MCI_CPSM_ENABLE) {
-		writel(0, base + MMCICOMMAND);
-		udelay(1);
-	}
-
-	c |= cmd->opcode | MCI_CPSM_ENABLE;
-	if (cmd->flags & MMC_RSP_PRESENT) {
-		if (cmd->flags & MMC_RSP_136)
-			c |= MCI_CPSM_LONGRSP;
-		c |= MCI_CPSM_RESPONSE;
-	}
-	if (/*interrupt*/0)
-		c |= MCI_CPSM_INTERRUPT;
-
-	host->cmd = cmd;
-
-	writel(cmd->arg, base + MMCIARGUMENT);
-	writel(c, base + MMCICOMMAND);
-}
-
-static void
 mmci_data_irq(struct mmci_host *host, struct mmc_data *data,
 	      unsigned int status)
 {
@@ -206,14 +394,19 @@ mmci_data_irq(struct mmci_host *host, struct mmc_data *data,
 			data->error = -EIO;
 		status |= MCI_DATAEND;
 
-		/*
-		 * We hit an error condition.  Ensure that any data
-		 * partially written to a page is properly coherent.
-		 */
-		if (host->sg_len && data->flags & MMC_DATA_READ)
-			flush_dcache_page(sg_page(host->sg_ptr));
+		if (host->dma_rx_channel) {
+			mmci_dma_data_error(host);
+		} else {
+			/*
+			 * We hit an error condition.  Ensure that any data
+			 * partially written to a page is properly coherent.
+			 */
+			if (host->sg_len && data->flags & MMC_DATA_READ)
+				flush_dcache_page(sg_page(host->sg_ptr));
+		}
 	}
 	if (status & MCI_DATAEND) {
+		mmci_dma_data_end(host);
 		mmci_stop_data(host);
 
 		if (!data->stop) {
@@ -623,6 +816,7 @@ static int __devinit mmci_probe(struct amba_device *dev, struct amba_id *id)
 		dev_dbg(mmc_dev(mmc), "eventual mclk rate: %u Hz\n",
 			host->mclk);
 	}
+	host->phybase = dev->res.start;
 	host->base = ioremap(dev->res.start, resource_size(&dev->res));
 	if (!host->base) {
 		ret = -ENOMEM;
@@ -723,6 +917,8 @@ static int __devinit mmci_probe(struct amba_device *dev, struct amba_id *id)
 			goto err_gpio_wp;
 	}
 
+	mmci_setup_dma(host);
+
 	ret = request_irq(dev->irq[0], mmci_irq, IRQF_SHARED, DRIVER_NAME " (cmd)", host);
 	if (ret)
 		goto unmap;
@@ -738,9 +934,13 @@ static int __devinit mmci_probe(struct amba_device *dev, struct amba_id *id)
 
 	mmc_add_host(mmc);
 
-	dev_info(&dev->dev, "%s: MMCI rev %x cfg %02x at 0x%016llx irq %d,%d\n",
-		mmc_hostname(mmc), amba_rev(dev), amba_config(dev),
-		(unsigned long long)dev->res.start, dev->irq[0], dev->irq[1]);
+	dev_info(&dev->dev, "%s: MMCI/PL180 manf %x rev %x cfg %02x at 0x%016llx\n",
+		 mmc_hostname(mmc), amba_manf(dev), amba_rev(dev), amba_config(dev),
+		 (unsigned long long)dev->res.start);
+	dev_info(&dev->dev, "IRQ %d, %d (pio), DMA RX %s, DMA TX %s\n",
+		 dev->irq[0], dev->irq[1],
+		 host->dma_rx_channel ? dma_chan_name(host->dma_rx_channel) : "NOT USED",
+		 host->dma_tx_channel ? dma_chan_name(host->dma_tx_channel) : "NOT USED");
 
 	init_timer(&host->timer);
 	host->timer.data = (unsigned long)host;
@@ -751,6 +951,7 @@ static int __devinit mmci_probe(struct amba_device *dev, struct amba_id *id)
 	return 0;
 
  irq0_free:
+	mmci_disable_dma(host);
 	free_irq(dev->irq[0], host);
  unmap:
 	if (host->gpio_wp != -ENOSYS)
@@ -791,6 +992,7 @@ static int __devexit mmci_remove(struct amba_device *dev)
 		writel(0, host->base + MMCICOMMAND);
 		writel(0, host->base + MMCIDATACTRL);
 
+		mmci_disable_dma(host);
 		free_irq(dev->irq[0], host);
 		free_irq(dev->irq[1], host);
 
diff --git a/drivers/mmc/host/mmci.h b/drivers/mmc/host/mmci.h
index d77062e..d58ab0a 100644
--- a/drivers/mmc/host/mmci.h
+++ b/drivers/mmc/host/mmci.h
@@ -139,7 +139,6 @@
  * The size of the FIFO in bytes.
  */
 #define MCI_FIFOSIZE	(16*4)
-	
 #define MCI_FIFOHALFSIZE (MCI_FIFOSIZE / 2)
 
 #define NR_SG		16
@@ -147,6 +146,7 @@
 struct clk;
 
 struct mmci_host {
+	phys_addr_t		phybase;
 	void __iomem		*base;
 	struct mmc_request	*mrq;
 	struct mmc_command	*cmd;
@@ -177,7 +177,12 @@ struct mmci_host {
 	struct scatterlist	*sg_ptr;
 	unsigned int		sg_off;
 	unsigned int		size;
+
 	struct regulator	*vcc;
+	/* DMA stuff */
+	struct dma_chan		*dma_rx_channel;
+	struct dma_chan		*dma_tx_channel;
+	struct dma_async_tx_descriptor *dma_desc;
 };
 
 static inline void mmci_init_sg(struct mmci_host *host, struct mmc_data *data)
diff --git a/include/linux/amba/mmci.h b/include/linux/amba/mmci.h
index 7e466fe..f2ca60f 100644
--- a/include/linux/amba/mmci.h
+++ b/include/linux/amba/mmci.h
@@ -6,6 +6,8 @@
 
 #include <linux/mmc/host.h>
 
+/* Just some dummy forwarding */
+struct dma_chan;
 /**
  * struct mmci_platform_data - platform configuration for the MMCI
  * (also known as PL180) block.
@@ -25,6 +27,17 @@
  * @gpio_cd: read this GPIO pin to detect card insertion
  * @capabilities: the capabilities of the block as implemented in
  * this platform, signify anything MMC_CAP_* from mmc/host.h
+ * @dma_filter: function used to select an apropriate RX and TX
+ * DMA channel to be used for DMA, if and only if you're deploying the
+ * generic DMA engine
+ * @dma_rx_param: parameter passed to the DMA allocation
+ * filter in order to select an apropriate RX channel. If
+ * there is a bidirectional RX+TX channel, then just specify
+ * this and leave dma_tx_param set to NULL
+ * @dma_tx_param: parameter passed to the DMA allocation
+ * filter in order to select an apropriate TX channel. If this
+ * is NULL the driver will attempt to use the RX channel as a
+ * bidirectional channel
  */
 struct mmci_platform_data {
 	unsigned int f_max;
@@ -34,6 +47,9 @@ struct mmci_platform_data {
 	int	gpio_wp;
 	int	gpio_cd;
 	unsigned long capabilities;
+	bool (*dma_filter)(struct dma_chan *chan, void *filter_param);
+	void *dma_rx_param;
+	void *dma_tx_param;
 };
 
 #endif
-- 
1.6.3.3

