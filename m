Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754579Ab1BIKia (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 05:38:30 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:58149 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754238Ab1BIKi3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 05:38:29 -0500
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 8/8] intel_mid_ssp_spi: Implement slave side quirk
To: spi-devel-general@lists.sourceforge.net, russ.gorby@intel.com,
        grant.likely@secretlab.ca, linux-kernel@vger.kernel.org
Date: Wed, 09 Feb 2011 10:09:38 +0000
Message-ID: <20110209100932.555.57563.stgit@bob.linux.org.uk>
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

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/spi/intel_mid_ssp_spi.c |   32 +++++++++++++++++++++-----------
 1 files changed, 21 insertions(+), 11 deletions(-)


diff --git a/drivers/spi/intel_mid_ssp_spi.c b/drivers/spi/intel_mid_ssp_spi.c
index 8d7a157..91976af 100644
--- a/drivers/spi/intel_mid_ssp_spi.c
+++ b/drivers/spi/intel_mid_ssp_spi.c
@@ -93,15 +93,13 @@ MODULE_LICENSE("GPL");
 
 #define PNWL_CR1_MASTER_ROLE	0
 #define PNWL_CR1_SLAVE_ROLE	(SSCR1_SFRMDIR | SSCR1_SCLKDIR)
-/* MRST SSP must be slave */
-#define PNWL_CR1_ROLE		PNWL_CR1_MASTER_ROLE
-#define PNWL_CR1(spi, chip)	\
+#define PNWL_CR1(spi, chip, role)	\
 	  ((chip->enable_loopback ? SSCR1_LBM : 0) | \
 	  ((spi->mode & SPI_CPHA) ? SSCR1_SPH : 0) | \
 	  ((spi->mode & SPI_CPOL) ? SSCR1_SPO : 0) | \
 	  SSCR1_SCFR | \
 	  chip->threshold | \
-	  PNWL_CR1_ROLE)
+	  role)
 
 
 
@@ -603,7 +601,7 @@ free_rxchan:
 	dma_release_channel(drv_data->rxchan);
 	if (drv_data->quirks & QUIRKS_SRAM_ADDITIONAL_CPY)
 		intel_mid_ssp_spi_unmap_sram(drv_data);
-		
+
 err_exit:
 	dev_err(&drv_data->pdev->dev, "DMA RX Channel Not available");
 	pci_dev_put(drv_data->dmac1);
@@ -1203,6 +1201,7 @@ static int setup(struct spi_device *spi)
 	uint rx_thres = RX_THRESH_DFLT;
 	u32 clk_div;
 	struct driver_data *drv_data = spi_master_get_devdata(spi->master);
+	int role = PNWL_CR1_MASTER_ROLE;
 
 	if (drv_data->pwrstate == PWRSTATE_OFF) {
 		dev_dbg(&drv_data->pdev->dev, "setup: busy, pwrstate:%d",
@@ -1272,15 +1271,20 @@ static int setup(struct spi_device *spi)
 		set_dma_width(drv_data, spi->bits_per_word);
 	}
 
-	chip->speed_hz = spi->max_speed_hz;
-	clk_div = ssp_get_clk_div(chip->speed_hz);
+	if (drv_data->quirks & QUIRKS_SPI_SLAVE_CLOCK_MODE) {
+		role = PNWL_CR1_SLAVE_ROLE;
+		clk_div = 1;
+	} else {
+		chip->speed_hz = spi->max_speed_hz;
+		clk_div = ssp_get_clk_div(chip->speed_hz);
+	}
 
 	chip->threshold = (SSCR1_RxTresh(rx_thres) & SSCR1_RFT) |
 		(SSCR1_TxTresh(tx_thres) & SSCR1_TFT);
 	chip->bits_per_word = spi->bits_per_word;
 
 	chip->cr0 = PNWL_CR0(clk_div, spi->bits_per_word, spi, chip);
-	chip->cr1 = PNWL_CR1(spi, chip);
+	chip->cr1 = PNWL_CR1(spi, chip, role);
 
 	dev_dbg(&spi->dev,
 		"KHz:%d bpw:%d mode:%d dma:%d poll:%d loop:%d cr0:%x cr1:%x",
@@ -1340,13 +1344,11 @@ static int intel_mid_ssp_spi_probe(struct pci_dev *pdev,
 		dev_info(dev, "No Vendor Specific PCI capability");
 		goto err_abort_probe;
 	}
-	if ((SSP_CFG_GET_MODE(ssp_cfg) != SSP_CFG_SPI_MODE_ID) ||
-		SSP_CFG_IS_SPI_SLAVE(ssp_cfg)) {
+	if (SSP_CFG_GET_MODE(ssp_cfg) != SSP_CFG_SPI_MODE_ID) {
 		dev_info(dev, "Unsupported SSP mode (%02xh)",
 			ssp_cfg);
 		goto err_abort_probe;
 	}
-
 	dev_info(&pdev->dev, "found PCI SSP controller(ID: %04xh:%04xh"
 		" cfg: %02xh)", pdev->vendor, pdev->device, ssp_cfg);
 
@@ -1371,6 +1373,14 @@ static int intel_mid_ssp_spi_probe(struct pci_dev *pdev,
 	drv_data->wq = create_workqueue(DRIVER_NAME);
 	INIT_WORK(&drv_data->resume_transfer_work, resume_transfer_work);
 
+	if (SSP_CFG_IS_SPI_SLAVE(ssp_cfg)) {
+		dev_warn(dev, "Slave clock mode is experimental");
+		drv_data->quirks |= QUIRKS_SPI_SLAVE_CLOCK_MODE;
+		if (drv_data->quirks & QUIRKS_PLATFORM_MRST)
+			drv_data->quirks |= QUIRKS_USE_PM_QOS |
+						QUIRKS_SRAM_ADDITIONAL_CPY;
+	}
+
 	master->mode_bits = SPI_CPOL | SPI_CPHA;
 	master->bus_num = SSP_CFG_GET_SPI_BUS_NB(ssp_cfg);
 	master->num_chipselect = 1;

