Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754400Ab1BIKhT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 05:37:19 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:58129 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754048Ab1BIKhR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 05:37:17 -0500
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 4/8] intel_mid_ssp_spi: Add the uglies needed for Moorestown
 master mode
To: spi-devel-general@lists.sourceforge.net, russ.gorby@intel.com,
        grant.likely@secretlab.ca, linux-kernel@vger.kernel.org
Date: Wed, 09 Feb 2011 10:08:27 +0000
Message-ID: <20110209100813.555.41982.stgit@bob.linux.org.uk>
In-Reply-To: <20110209100231.555.90520.stgit@bob.linux.org.uk>
References: <20110209100231.555.90520.stgit@bob.linux.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

We need to support the bitbanging quirk - triggered only on Moorestown so
should have no impact on any Medfield code paths, and not poke around syscfg
which is for Medfield, so if the Moorestown quirk is set skip that.

Also fix a leak of syscfg in the Medfield path

Merged from earlier work making the driver generic by Mathieu SOULARD
<mathieux.soulard@intel.com>

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/spi/intel_mid_ssp_spi.c     |  107 +++++++++++++++++++++++++++++++----
 drivers/spi/intel_mid_ssp_spi_def.h |    3 +
 2 files changed, 98 insertions(+), 12 deletions(-)


diff --git a/drivers/spi/intel_mid_ssp_spi.c b/drivers/spi/intel_mid_ssp_spi.c
index a7548e7..6435adc 100644
--- a/drivers/spi/intel_mid_ssp_spi.c
+++ b/drivers/spi/intel_mid_ssp_spi.c
@@ -140,6 +140,7 @@ struct driver_data {
 	void __iomem *ioaddr;
 	u32 iolen;
 	int irq;
+	void __iomem *I2C_ioaddr;	/* For Moorestown fixups */
 
 	/* SSP masks*/
 	u32 dma_cr1;
@@ -851,6 +852,68 @@ static void resume_transfer_work(struct work_struct *work)
 	transfer(msg->spi, msg);
 }
 
+static void start_bitbanging(struct driver_data *drv_data)
+{
+	u32 sssr;
+	u32 count = 0;
+	u32 cr0;
+	void __iomem *i2c_reg = drv_data->I2C_ioaddr;
+	struct device *dev = &drv_data->pdev->dev;
+	void __iomem *reg = drv_data->ioaddr;
+	struct chip_data *chip = spi_get_ctldata(drv_data->cur_msg->spi);
+	cr0 = chip->cr0;
+
+	if (ioread32(reg + SSSR) & SSSR_NOT_SYNC)
+		dev_warn(dev, "SSP clock desynchronized.\n");
+	if (!(ioread32(reg + SSCR0) & SSCR0_SSE))
+		dev_warn(dev, "in SSCR0, SSP disabled.\n");
+
+	dev_dbg(dev, "SSP not ready, start CLK sync\n");
+
+	iowrite32(cr0 & ~SSCR0_SSE, reg + SSCR0);
+	iowrite32(0x02010007, reg + SSPSP);
+	iowrite32(chip->timeout, reg + SSTO);
+	iowrite32(cr0, reg + SSCR0);
+
+	/*
+	*  This routine uses the DFx block to override the SSP inputs
+	*  and outputs allowing us to bit bang SSPSCLK. On Langwell,
+	*  we have to generate the clock to clear busy.
+	*/
+	iowrite32(0x3, i2c_reg + 4);
+	udelay(10);
+	iowrite32(0x01070034, i2c_reg);
+	udelay(10);
+	iowrite32(0x00000099, i2c_reg + 4);
+	udelay(10);
+	iowrite32(0x01070038, i2c_reg);
+	udelay(10);
+	sssr = ioread32(reg + SSSR);
+
+	/* Bit bang the clock until CSS clears */
+	while ((sssr & 0x400000) && count < 10000) {
+		iowrite32(0x2, i2c_reg + 4);
+		udelay(10);
+		iowrite32(0x01070034, i2c_reg);
+		udelay(10);
+		iowrite32(0x3, i2c_reg + 4);
+		udelay(10);
+		iowrite32(0x01070034, i2c_reg);
+		udelay(10);
+		sssr = ioread32(reg + SSSR);
+		count++;
+	}
+	if (count >= 10000)
+		dev_err(dev, "ERROR in %s : infinite loop \
+			on bit banging. Aborting\n", __func__);
+
+	dev_dbg(dev, "---Bit bang count=%d\n", count);
+
+	iowrite32(0x0, i2c_reg + 4);
+	udelay(10);
+	iowrite32(0x01070038, i2c_reg);
+}
+
 static int transfer(struct spi_device *spi, struct spi_message *msg)
 {
 	struct driver_data *drv_data = spi_master_get_devdata(spi->master);
@@ -978,8 +1041,10 @@ static int transfer(struct spi_device *spi, struct spi_message *msg)
 		iowrite32(cr0 & ~SSCR0_SSE, reg + SSCR0);
 		/* first set CR1 without interrupt and service enables */
 		iowrite32(cr1 & SSCR1_CHANGE_MASK, reg + SSCR1);
-		/* restart the SSP */
-		iowrite32(cr0, reg + SSCR0);
+		if (drv_data->quirks & QUIRKS_BIT_BANGING)
+			start_bitbanging(drv_data);
+		else /* restart the SSP */
+			iowrite32(cr0, reg + SSCR0);
 	}
 
 	/* after chip select, release the data by enabling service
@@ -1202,6 +1267,16 @@ static int intel_mid_ssp_spi_probe(struct pci_dev *pdev,
 		status = -ENOMEM;
 		goto err_free_2;
 	}
+
+	if (drv_data->quirks & QUIRKS_BIT_BANGING) {
+		drv_data->I2C_ioaddr = ioremap_nocache(I2C_BASE_ADDR, 0x10);
+		if (!drv_data->I2C_ioaddr) {
+			status = -ENOMEM;
+			goto err_free_3;
+		}
+	}
+
+
 	dev_dbg(dev, "paddr = : %08lx", drv_data->paddr);
 	dev_dbg(dev, "ioaddr = : %p", drv_data->ioaddr);
 	dev_dbg(dev, "attaching to IRQ: %04x", pdev->irq);
@@ -1213,19 +1288,21 @@ static int intel_mid_ssp_spi_probe(struct pci_dev *pdev,
 		"intel_mid_ssp_spi", drv_data);
 	if (status < 0) {
 		dev_err(dev, "can not get IRQ %d", drv_data->irq);
-		goto err_free_3;
+		goto err_free_4;
 	}
 
 	/* get base address of DMA selector. */
-	syscfg = drv_data->paddr - SYSCFG;
-	syscfg_ioaddr = ioremap_nocache(syscfg, 0x10);
-	if (!syscfg_ioaddr) {
-		status = -ENOMEM;
-		goto err_free_3;
+	if (!(drv_data->quirks & QUIRKS_PLATFORM_MRST)) {
+		syscfg = drv_data->paddr - SYSCFG;
+		syscfg_ioaddr = ioremap_nocache(syscfg, 0x10);
+		if (!syscfg_ioaddr) {
+			status = -ENOMEM;
+			goto err_free_4;
+		}
+		iowrite32(ioread32(syscfg_ioaddr) | 2, syscfg_ioaddr);
+		iounmap(syscfg_ioaddr);
 	}
 
-	iowrite32(ioread32(syscfg_ioaddr) | 2, syscfg_ioaddr);
-
 	drv_data->int_cr1 = SSCR1_TIE | SSCR1_RIE | SSCR1_TINTE;
 	drv_data->dma_cr1 = SSCR1_TSRE | SSCR1_RSRE | SSCR1_TRAIL;
 	drv_data->clear_sr = SSSR_ROR | SSSR_TINT;
@@ -1250,7 +1327,7 @@ static int intel_mid_ssp_spi_probe(struct pci_dev *pdev,
 	status = spi_register_master(master);
 	if (status != 0) {
 		dev_err(dev, "problem registering driver");
-		goto err_free_4;
+		goto err_free_5;
 	}
 
 	pci_set_drvdata(pdev, drv_data);
@@ -1262,8 +1339,11 @@ static int intel_mid_ssp_spi_probe(struct pci_dev *pdev,
 
 	return status;
 
-err_free_4:
+err_free_5:
 	free_irq(drv_data->irq, drv_data);
+err_free_4:
+	if (drv_data->quirks & QUIRKS_BIT_BANGING)
+		iounmap(drv_data->I2C_ioaddr);
 err_free_3:
 	iounmap(drv_data->ioaddr);
 err_free_2:
@@ -1291,6 +1371,9 @@ static void __devexit intel_mid_ssp_spi_remove(struct pci_dev *pdev)
 
 	free_irq(drv_data->irq, drv_data);
 
+	if (drv_data->I2C_ioaddr)
+		iounmap(drv_data->I2C_ioaddr);
+
 	iounmap(drv_data->ioaddr);
 
 	pci_release_region(pdev, 0);
diff --git a/drivers/spi/intel_mid_ssp_spi_def.h b/drivers/spi/intel_mid_ssp_spi_def.h
index 4610d62..88d872b 100644
--- a/drivers/spi/intel_mid_ssp_spi_def.h
+++ b/drivers/spi/intel_mid_ssp_spi_def.h
@@ -64,6 +64,7 @@
 #define SSSR_ROR    (1 << 7) /* Receive FIFO Overrun */
 #define SSSR_TFL     (0x0f00) /* Transmit FIFO Level (mask) */
 #define SSSR_RFL     (0xf000) /* Receive FIFO Level (mask) */
+#define SSSR_NOT_SYNC (1 << 22)	/* Sync flag */
 
 #define SSCR0_TIM    (1 << 23)		 /* Transmit FIFO Under Run Int Mask */
 #define SSCR0_RIM    (1 << 22)		 /* Receive FIFO Over Run int Mask */
@@ -124,6 +125,8 @@
 /* adid field offset is 6 inside the vendor specific capability */
 #define VNDR_CAPABILITY_ADID_OFFSET	6
 
+#define I2C_BASE_ADDR			0xFF12B000
+
 /* spi_board_info.controller_data for SPI slave devices,
  * copied to spi_device.platform_data ... mostly for dma tuning
  */

