Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754079Ab3AGKl0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 05:41:26 -0500
Received: from mga02.intel.com ([134.134.136.20]:24661 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753590Ab3AGKlP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 05:41:15 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,423,1355126400"; 
   d="scan'208";a="242919362"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: grant.likely@secretlab.ca, linus.walleij@linaro.org, eric.y.miao@gmail.com,
        linux@arm.linux.org.uk, haojian.zhuang@gmail.com,
        broonie@opensource.wolfsonmicro.com, chao.bi@intel.com,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 05/11] spi/pxa2xx: make clock rate configurable from platform data
Date: Mon,  7 Jan 2013 12:44:34 +0200
Message-Id: <1357555480-24022-6-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 1.7.9.1
In-Reply-To: <1357555480-24022-1-git-send-email-mika.westerberg@linux.intel.com>
References: <1357555480-24022-1-git-send-email-mika.westerberg@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the architecture doesn't support clk framework (like x86) we need a way to
pass the SSP clock rate to the driver. This patch adds a field in the platform
data 'fixed_clk_rate' that allows passing the rate.

Also include clk.h to make sure that the clk_* functions are properly stubbed
out on architectures where clk framework is not available.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 drivers/spi/spi-pxa2xx-pci.c   |    1 +
 drivers/spi/spi-pxa2xx.c       |   28 +++++++++++++++++++---------
 include/linux/spi/pxa2xx_spi.h |   19 +------------------
 3 files changed, 21 insertions(+), 27 deletions(-)

diff --git a/drivers/spi/spi-pxa2xx-pci.c b/drivers/spi/spi-pxa2xx-pci.c
index 364964d..4de98f4 100644
--- a/drivers/spi/spi-pxa2xx-pci.c
+++ b/drivers/spi/spi-pxa2xx-pci.c
@@ -27,6 +27,7 @@ static int ce4100_spi_probe(struct pci_dev *dev,
 
 	memset(&spi_pdata, 0, sizeof(spi_pdata));
 	spi_pdata.num_chipselect = dev->devfn;
+	spi_pdata.fixed_clk_rate = 3686400;
 
 	ssp = &spi_pdata.ssp;
 	ssp->phys_base = pci_resource_start(dev, 0);
diff --git a/drivers/spi/spi-pxa2xx.c b/drivers/spi/spi-pxa2xx.c
index 17bd136..3dedebd 100644
--- a/drivers/spi/spi-pxa2xx.c
+++ b/drivers/spi/spi-pxa2xx.c
@@ -30,6 +30,7 @@
 #include <linux/delay.h>
 #include <linux/gpio.h>
 #include <linux/slab.h>
+#include <linux/clk.h>
 
 #include <asm/io.h>
 #include <asm/irq.h>
@@ -891,11 +892,22 @@ static int set_dma_burst_and_threshold(struct chip_data *chip,
 	return retval;
 }
 
-static unsigned int ssp_get_clk_div(struct ssp_device *ssp, int rate)
+static unsigned long pxa2xx_spi_clk_rate(struct driver_data *drv_data)
 {
-	unsigned long ssp_clk = clk_get_rate(ssp->clk);
+	const struct pxa2xx_spi_master *pdata = drv_data->master_info;
 
-	if (ssp->type == PXA25x_SSP || ssp->type == CE4100_SSP)
+	return pdata->fixed_clk_rate ? pdata->fixed_clk_rate
+				     : clk_get_rate(drv_data->ssp->clk);
+}
+
+static unsigned int ssp_get_clk_div(struct driver_data *drv_data, unsigned rate)
+{
+	unsigned long ssp_clk = pxa2xx_spi_clk_rate(drv_data);
+
+	rate = min_t(unsigned, ssp_clk, rate);
+
+	if (drv_data->ssp->type == PXA25x_SSP ||
+	    drv_data->ssp->type == CE4100_SSP)
 		return ((ssp_clk / (2 * rate) - 1) & 0xff) << 8;
 	else
 		return ((ssp_clk / rate - 1) & 0xfff) << 8;
@@ -908,7 +920,6 @@ static void pump_transfers(unsigned long data)
 	struct spi_transfer *transfer = NULL;
 	struct spi_transfer *previous = NULL;
 	struct chip_data *chip = NULL;
-	struct ssp_device *ssp = drv_data->ssp;
 	void __iomem *reg = drv_data->ioaddr;
 	u32 clk_div = 0;
 	u8 bits = 0;
@@ -1005,7 +1016,7 @@ static void pump_transfers(unsigned long data)
 		if (transfer->bits_per_word)
 			bits = transfer->bits_per_word;
 
-		clk_div = ssp_get_clk_div(ssp, speed);
+		clk_div = ssp_get_clk_div(drv_data, speed);
 
 		if (bits <= 8) {
 			drv_data->n_bytes = 1;
@@ -1214,7 +1225,6 @@ static int setup(struct spi_device *spi)
 	struct pxa2xx_spi_chip *chip_info = NULL;
 	struct chip_data *chip;
 	struct driver_data *drv_data = spi_master_get_devdata(spi->master);
-	struct ssp_device *ssp = drv_data->ssp;
 	unsigned int clk_div;
 	uint tx_thres = TX_THRESH_DFLT;
 	uint rx_thres = RX_THRESH_DFLT;
@@ -1296,7 +1306,7 @@ static int setup(struct spi_device *spi)
 		}
 	}
 
-	clk_div = ssp_get_clk_div(ssp, spi->max_speed_hz);
+	clk_div = ssp_get_clk_div(drv_data, spi->max_speed_hz);
 	chip->speed_hz = spi->max_speed_hz;
 
 	chip->cr0 = clk_div
@@ -1312,12 +1322,12 @@ static int setup(struct spi_device *spi)
 	/* NOTE:  PXA25x_SSP _could_ use external clocking ... */
 	if (!pxa25x_ssp_comp(drv_data))
 		dev_dbg(&spi->dev, "%ld Hz actual, %s\n",
-			clk_get_rate(ssp->clk)
+			pxa2xx_spi_clk_rate(drv_data)
 				/ (1 + ((chip->cr0 & SSCR0_SCR(0xfff)) >> 8)),
 			chip->enable_dma ? "DMA" : "PIO");
 	else
 		dev_dbg(&spi->dev, "%ld Hz actual, %s\n",
-			clk_get_rate(ssp->clk) / 2
+			pxa2xx_spi_clk_rate(drv_data) / 2
 				/ (1 + ((chip->cr0 & SSCR0_SCR(0x0ff)) >> 8)),
 			chip->enable_dma ? "DMA" : "PIO");
 
diff --git a/include/linux/spi/pxa2xx_spi.h b/include/linux/spi/pxa2xx_spi.h
index 6b99f09..83b73f5 100644
--- a/include/linux/spi/pxa2xx_spi.h
+++ b/include/linux/spi/pxa2xx_spi.h
@@ -31,6 +31,7 @@ struct pxa2xx_spi_master {
 
 	/* For non-PXA arches */
 	struct ssp_device ssp;
+	unsigned long fixed_clk_rate;
 };
 
 /* spi_board_info.controller_data for SPI slave devices,
@@ -133,23 +134,5 @@ static inline void pxa_free_dma(int dma_ch)
 {
 }
 
-/*
- * The CE4100 does not have the clk framework implemented and SPI clock can
- * not be switched on/off or the divider changed.
- */
-static inline void clk_disable(struct clk *clk)
-{
-}
-
-static inline int clk_enable(struct clk *clk)
-{
-	return 0;
-}
-
-static inline unsigned long clk_get_rate(struct clk *clk)
-{
-	return 3686400;
-}
-
 #endif
 #endif
-- 
1.7.10.4

