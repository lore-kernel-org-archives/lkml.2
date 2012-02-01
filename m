Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756239Ab2BAKx6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 05:53:58 -0500
Received: from eu1sys200aog106.obsmtp.com ([207.126.144.121]:57423 "EHLO
	eu1sys200aog106.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756184Ab2BAKwc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 05:52:32 -0500
From: Viresh Kumar <viresh.kumar@st.com>
To: <vinod.koul@intel.com>, <dan.j.williams@intel.com>
Cc: <cjb@laptop.org>, <rmk+kernel@arm.linux.org.uk>,
        <linus.walleij@linaro.org>, <ulf.hansson@stericsson.com>,
        <linux-mmc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <egtvedt@samfundet.no>, <hskinnemoen@gmail.com>,
        <kernel@pengutronix.de>, <perex@perex.cz>,
        <linux-arm-kernel@lists.infradead.org>, <armando.visconti@st.com>,
        <shiraz.hashim@st.com>, <vipin.kumar@st.com>,
        <rajeev-dlh.kumar@st.com>, <deepak.sikri@st.com>,
        <vipulkumar.samar@st.com>, <amit.virdi@st.com>, <viresh.kumar@st.com>,
        <pratyush.anand@st.com>, <bhupesh.sharma@st.com>,
        <viresh.linux@gmail.com>, <bhavna.yadav@st.com>,
        <vincenzo.frascino@st.com>, <mirko.gardi@st.com>
Subject: [PATCH V3 11/12] dmaengine/dw_dmac: Fix dw_dmac user drivers to adapt to slave_config changes
Date: Wed, 1 Feb 2012 16:12:27 +0530
Message-ID: <666b1580550d55eb202d5fb64d7af26eae1e1484.1328091915.git.viresh.kumar@st.com>
X-Mailer: git-send-email 1.7.8.110.g4cb5d
In-Reply-To: <cover.1328091915.git.viresh.kumar@st.com>
References: <cover.1328091915.git.viresh.kumar@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are few existing user drivers of dw_dmac. They will break as soon as we
remove unused fields from struct dw_dma_slave. This patch focuses to fix these
user drivers to use dma_slave_config() routine.

Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
---
 arch/avr32/mach-at32ap/at32ap700x.c             |   13 -------
 arch/avr32/mach-at32ap/include/mach/atmel-mci.h |    7 ----
 drivers/mmc/host/atmel-mci.c                    |   24 +++++++++----
 sound/atmel/abdac.c                             |   18 ++++++++--
 sound/atmel/ac97c.c                             |   41 ++++++++++++++++++----
 5 files changed, 63 insertions(+), 40 deletions(-)

diff --git a/arch/avr32/mach-at32ap/at32ap700x.c b/arch/avr32/mach-at32ap/at32ap700x.c
index 7fbf0dc..d05936b 100644
--- a/arch/avr32/mach-at32ap/at32ap700x.c
+++ b/arch/avr32/mach-at32ap/at32ap700x.c
@@ -1353,7 +1353,6 @@ at32_add_device_mci(unsigned int id, struct mci_platform_data *data)
 		goto fail;
 
 	slave->sdata.dma_dev = &dw_dmac0_device.dev;
-	slave->sdata.reg_width = DW_DMA_SLAVE_WIDTH_32BIT;
 	slave->sdata.cfg_hi = (DWC_CFGH_SRC_PER(0)
 				| DWC_CFGH_DST_PER(1));
 	slave->sdata.cfg_lo &= ~(DWC_CFGL_HS_DST_POL
@@ -2048,27 +2047,19 @@ at32_add_device_ac97c(unsigned int id, struct ac97c_platform_data *data,
 	/* Check if DMA slave interface for capture should be configured. */
 	if (flags & AC97C_CAPTURE) {
 		rx_dws->dma_dev = &dw_dmac0_device.dev;
-		rx_dws->reg_width = DW_DMA_SLAVE_WIDTH_16BIT;
 		rx_dws->cfg_hi = DWC_CFGH_SRC_PER(3);
 		rx_dws->cfg_lo &= ~(DWC_CFGL_HS_DST_POL | DWC_CFGL_HS_SRC_POL);
 		rx_dws->src_master = 0;
 		rx_dws->dst_master = 1;
-		rx_dws->src_msize = DW_DMA_MSIZE_1;
-		rx_dws->dst_msize = DW_DMA_MSIZE_1;
-		rx_dws->fc = DW_DMA_FC_D_P2M;
 	}
 
 	/* Check if DMA slave interface for playback should be configured. */
 	if (flags & AC97C_PLAYBACK) {
 		tx_dws->dma_dev = &dw_dmac0_device.dev;
-		tx_dws->reg_width = DW_DMA_SLAVE_WIDTH_16BIT;
 		tx_dws->cfg_hi = DWC_CFGH_DST_PER(4);
 		tx_dws->cfg_lo &= ~(DWC_CFGL_HS_DST_POL | DWC_CFGL_HS_SRC_POL);
 		tx_dws->src_master = 0;
 		tx_dws->dst_master = 1;
-		tx_dws->src_msize = DW_DMA_MSIZE_1;
-		tx_dws->dst_msize = DW_DMA_MSIZE_1;
-		tx_dws->fc = DW_DMA_FC_D_M2P;
 	}
 
 	if (platform_device_add_data(pdev, data,
@@ -2138,14 +2129,10 @@ at32_add_device_abdac(unsigned int id, struct atmel_abdac_pdata *data)
 	dws = &data->dws;
 
 	dws->dma_dev = &dw_dmac0_device.dev;
-	dws->reg_width = DW_DMA_SLAVE_WIDTH_32BIT;
 	dws->cfg_hi = DWC_CFGH_DST_PER(2);
 	dws->cfg_lo &= ~(DWC_CFGL_HS_DST_POL | DWC_CFGL_HS_SRC_POL);
 	dws->src_master = 0;
 	dws->dst_master = 1;
-	dws->src_msize = DW_DMA_MSIZE_1;
-	dws->dst_msize = DW_DMA_MSIZE_1;
-	dws->fc = DW_DMA_FC_D_M2P;
 
 	if (platform_device_add_data(pdev, data,
 				sizeof(struct atmel_abdac_pdata)))
diff --git a/arch/avr32/mach-at32ap/include/mach/atmel-mci.h b/arch/avr32/mach-at32ap/include/mach/atmel-mci.h
index a9b3896..4bba585 100644
--- a/arch/avr32/mach-at32ap/include/mach/atmel-mci.h
+++ b/arch/avr32/mach-at32ap/include/mach/atmel-mci.h
@@ -14,11 +14,4 @@ struct mci_dma_data {
 #define	slave_data_ptr(s)	(&(s)->sdata)
 #define find_slave_dev(s)	((s)->sdata.dma_dev)
 
-#define	setup_dma_addr(s, t, r)	do {		\
-	if (s) {				\
-		(s)->sdata.tx_reg = (t);	\
-		(s)->sdata.rx_reg = (r);	\
-	}					\
-} while (0)
-
 #endif /* __MACH_ATMEL_MCI_H */
diff --git a/drivers/mmc/host/atmel-mci.c b/drivers/mmc/host/atmel-mci.c
index fcfe1eb..3ba865d 100644
--- a/drivers/mmc/host/atmel-mci.c
+++ b/drivers/mmc/host/atmel-mci.c
@@ -24,6 +24,7 @@
 #include <linux/seq_file.h>
 #include <linux/slab.h>
 #include <linux/stat.h>
+#include <linux/types.h>
 
 #include <linux/mmc/host.h>
 #include <linux/mmc/sdio.h>
@@ -173,6 +174,7 @@ struct atmel_mci {
 
 	struct atmel_mci_dma	dma;
 	struct dma_chan		*data_chan;
+	struct dma_slave_config	dma_conf;
 
 	u32			cmd_status;
 	u32			data_status;
@@ -863,15 +865,16 @@ atmci_prepare_data_dma(struct atmel_mci *host, struct mmc_data *data)
 
 	if (data->flags & MMC_DATA_READ) {
 		direction = DMA_FROM_DEVICE;
-		slave_dirn = DMA_DEV_TO_MEM;
+		host->dma_conf.direction = slave_dirn = DMA_DEV_TO_MEM;
 	} else {
 		direction = DMA_TO_DEVICE;
-		slave_dirn = DMA_MEM_TO_DEV;
+		host->dma_conf.direction = slave_dirn = DMA_MEM_TO_DEV;
 	}
 
 	sglen = dma_map_sg(chan->device->dev, data->sg,
 			data->sg_len, direction);
 
+	dmaengine_slave_config(chan, &host->dma_conf);
 	desc = chan->device->device_prep_slave_sg(chan,
 			data->sg, sglen, slave_dirn,
 			DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
@@ -1957,22 +1960,27 @@ static void atmci_configure_dma(struct atmel_mci *host)
 	if (pdata && find_slave_dev(pdata->dma_slave)) {
 		dma_cap_mask_t mask;
 
-		setup_dma_addr(pdata->dma_slave,
-			       host->mapbase + ATMCI_TDR,
-			       host->mapbase + ATMCI_RDR);
-
 		/* Try to grab a DMA channel */
 		dma_cap_zero(mask);
 		dma_cap_set(DMA_SLAVE, mask);
 		host->dma.chan =
 			dma_request_channel(mask, atmci_filter, pdata->dma_slave);
 	}
-	if (!host->dma.chan)
+	if (!host->dma.chan) {
 		dev_notice(&host->pdev->dev, "DMA not available, using PIO\n");
-	else
+	} else {
 		dev_info(&host->pdev->dev,
 					"Using %s for DMA transfers\n",
 					dma_chan_name(host->dma.chan));
+
+		host->dma_conf.src_addr = host->mapbase + ATMCI_RDR;
+		host->dma_conf.src_addr_width = DMA_SLAVE_BUSWIDTH_4_BYTES;
+		host->dma_conf.src_maxburst = 1;
+		host->dma_conf.dst_addr = host->mapbase + ATMCI_TDR;
+		host->dma_conf.dst_addr_width = DMA_SLAVE_BUSWIDTH_4_BYTES;
+		host->dma_conf.dst_maxburst = 1;
+		host->dma_conf.device_fc = false;
+	}
 }
 
 static inline unsigned int atmci_get_version(struct atmel_mci *host)
diff --git a/sound/atmel/abdac.c b/sound/atmel/abdac.c
index 4fa1dbd..f7c2bb0 100644
--- a/sound/atmel/abdac.c
+++ b/sound/atmel/abdac.c
@@ -16,6 +16,7 @@
 #include <linux/interrupt.h>
 #include <linux/module.h>
 #include <linux/platform_device.h>
+#include <linux/types.h>
 #include <linux/io.h>
 
 #include <sound/core.h>
@@ -467,15 +468,24 @@ static int __devinit atmel_abdac_probe(struct platform_device *pdev)
 	snd_card_set_dev(card, &pdev->dev);
 
 	if (pdata->dws.dma_dev) {
-		struct dw_dma_slave *dws = &pdata->dws;
 		dma_cap_mask_t mask;
 
-		dws->tx_reg = regs->start + DAC_DATA;
-
 		dma_cap_zero(mask);
 		dma_cap_set(DMA_SLAVE, mask);
 
-		dac->dma.chan = dma_request_channel(mask, filter, dws);
+		dac->dma.chan = dma_request_channel(mask, filter, &pdata->dws);
+		if (dac->dma.chan) {
+			struct dma_slave_config dma_conf = {
+				.dst_addr = regs->start + DAC_DATA,
+				.dst_addr_width = DMA_SLAVE_BUSWIDTH_4_BYTES,
+				.src_maxburst = 1,
+				.dst_maxburst = 1,
+				.direction = DMA_MEM_TO_DEV,
+				.device_fc = false,
+			};
+
+			dmaengine_slave_config(dac->dma.chan, &dma_conf);
+		}
 	}
 	if (!pdata->dws.dma_dev || !dac->dma.chan) {
 		dev_dbg(&pdev->dev, "DMA not available\n");
diff --git a/sound/atmel/ac97c.c b/sound/atmel/ac97c.c
index cd9428b..15f47e3 100644
--- a/sound/atmel/ac97c.c
+++ b/sound/atmel/ac97c.c
@@ -20,6 +20,7 @@
 #include <linux/platform_device.h>
 #include <linux/mutex.h>
 #include <linux/gpio.h>
+#include <linux/types.h>
 #include <linux/io.h>
 
 #include <sound/core.h>
@@ -1010,16 +1011,28 @@ static int __devinit atmel_ac97c_probe(struct platform_device *pdev)
 
 	if (cpu_is_at32ap7000()) {
 		if (pdata->rx_dws.dma_dev) {
-			struct dw_dma_slave *dws = &pdata->rx_dws;
 			dma_cap_mask_t mask;
 
-			dws->rx_reg = regs->start + AC97C_CARHR + 2;
-
 			dma_cap_zero(mask);
 			dma_cap_set(DMA_SLAVE, mask);
 
 			chip->dma.rx_chan = dma_request_channel(mask, filter,
-								dws);
+								&pdata->rx_dws);
+			if (chip->dma.rx_chan) {
+				struct dma_slave_config dma_conf = {
+					.src_addr = regs->start + AC97C_CARHR +
+						2,
+					.src_addr_width =
+						DMA_SLAVE_BUSWIDTH_2_BYTES,
+					.src_maxburst = 1,
+					.dst_maxburst = 1,
+					.direction = DMA_DEV_TO_MEM,
+					.device_fc = false,
+				};
+
+				dmaengine_slave_config(chip->dma.rx_chan,
+						&dma_conf);
+			}
 
 			dev_info(&chip->pdev->dev, "using %s for DMA RX\n",
 				dev_name(&chip->dma.rx_chan->dev->device));
@@ -1027,16 +1040,28 @@ static int __devinit atmel_ac97c_probe(struct platform_device *pdev)
 		}
 
 		if (pdata->tx_dws.dma_dev) {
-			struct dw_dma_slave *dws = &pdata->tx_dws;
 			dma_cap_mask_t mask;
 
-			dws->tx_reg = regs->start + AC97C_CATHR + 2;
-
 			dma_cap_zero(mask);
 			dma_cap_set(DMA_SLAVE, mask);
 
 			chip->dma.tx_chan = dma_request_channel(mask, filter,
-								dws);
+								&pdata->tx_dws);
+			if (chip->dma.tx_chan) {
+				struct dma_slave_config dma_conf = {
+					.dst_addr = regs->start + AC97C_CATHR +
+						2,
+					.dst_addr_width =
+						DMA_SLAVE_BUSWIDTH_2_BYTES,
+					.src_maxburst = 1,
+					.dst_maxburst = 1,
+					.direction = DMA_MEM_TO_DEV,
+					.device_fc = false,
+				};
+
+				dmaengine_slave_config(chip->dma.tx_chan,
+						&dma_conf);
+			}
 
 			dev_info(&chip->pdev->dev, "using %s for DMA TX\n",
 				dev_name(&chip->dma.tx_chan->dev->device));
-- 
1.7.8.110.g4cb5d

