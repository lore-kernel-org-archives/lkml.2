Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932207Ab2ITOmm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 10:42:42 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:52363 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932154Ab2ITOmg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 10:42:36 -0400
From: Matt Porter <mporter@ti.com>
To: Tony Lindgren <tony@atomide.com>, Sekhar Nori <nsekhar@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Benoit Cousson <b-cousson@ti.com>,
        Russell King <linux@arm.linux.org.uk>,
        Vinod Koul <vinod.koul@intel.com>, Rob Landley <rob@landley.net>,
        Chris Ball <cjb@laptop.org>
Cc: Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Documentation List <linux-doc@vger.kernel.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Linux SPI Devel List 
	<spi-devel-general@lists.sourceforge.net>,
        Arnd Bergmann <arnd@arndb.de>, Dan Williams <djbw@fb.com>,
        Rob Herring <rob.herring@calxeda.com>
Subject: [RFC PATCH 10/13] spi: omap2-mcspi: dma_request_slave_channel() support for DT platforms
Date: Thu, 20 Sep 2012 10:43:43 -0400
Message-Id: <1348152226-13588-11-git-send-email-mporter@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1348152226-13588-1-git-send-email-mporter@ti.com>
References: <1348152226-13588-1-git-send-email-mporter@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For platforms with DT populated, use dma_request_slave_channel()
to acquire the DMA channel. For !DT platforms, we fall back to
explicitly passing the omap_dma_filter_fn() to dma_request_channel().
Once all platforms boot from DT, the dma_request_channel() path can
be dropped.

Signed-off-by: Matt Porter <mporter@ti.com>
---
 drivers/spi/spi-omap2-mcspi.c |   68 +++++++++++++++++++++++++++++------------
 1 file changed, 48 insertions(+), 20 deletions(-)

diff --git a/drivers/spi/spi-omap2-mcspi.c b/drivers/spi/spi-omap2-mcspi.c
index 9502566..1cf1072 100644
--- a/drivers/spi/spi-omap2-mcspi.c
+++ b/drivers/spi/spi-omap2-mcspi.c
@@ -104,6 +104,9 @@ struct omap2_mcspi_dma {
 
 	struct completion dma_tx_completion;
 	struct completion dma_rx_completion;
+
+	char dma_rx_ch_name[14];
+	char dma_tx_ch_name[14];
 };
 
 /* use PIO for small transfers, avoiding DMA setup/teardown overhead and
@@ -798,14 +801,26 @@ static int omap2_mcspi_request_dma(struct spi_device *spi)
 	dma_cap_zero(mask);
 	dma_cap_set(DMA_SLAVE, mask);
 	sig = mcspi_dma->dma_rx_sync_dev;
-	mcspi_dma->dma_rx = dma_request_channel(mask, omap_dma_filter_fn, &sig);
+	if (spi->dev.of_node)
+		mcspi_dma->dma_rx =
+			dma_request_slave_channel(&master->dev,
+						  mcspi_dma->dma_rx_ch_name);
+	else
+		mcspi_dma->dma_rx =
+			dma_request_channel(mask, omap_dma_filter_fn, &sig);
 	if (!mcspi_dma->dma_rx) {
 		dev_err(&spi->dev, "no RX DMA engine channel for McSPI\n");
 		return -EAGAIN;
 	}
 
 	sig = mcspi_dma->dma_tx_sync_dev;
-	mcspi_dma->dma_tx = dma_request_channel(mask, omap_dma_filter_fn, &sig);
+	if (spi->dev.of_node)
+		mcspi_dma->dma_tx =
+			dma_request_slave_channel(&master->dev,
+						  mcspi_dma->dma_tx_ch_name);
+	else
+		mcspi_dma->dma_tx =
+			dma_request_channel(mask, omap_dma_filter_fn, &sig);
 	if (!mcspi_dma->dma_tx) {
 		dev_err(&spi->dev, "no TX DMA engine channel for McSPI\n");
 		dma_release_channel(mcspi_dma->dma_rx);
@@ -1194,29 +1209,42 @@ static int __devinit omap2_mcspi_probe(struct platform_device *pdev)
 		goto free_master;
 
 	for (i = 0; i < master->num_chipselect; i++) {
-		char dma_ch_name[14];
+		char *dma_rx_ch_name = mcspi->dma_channels[i].dma_rx_ch_name;
+		char *dma_tx_ch_name = mcspi->dma_channels[i].dma_tx_ch_name;
 		struct resource *dma_res;
 
-		sprintf(dma_ch_name, "rx%d", i);
-		dma_res = platform_get_resource_byname(pdev, IORESOURCE_DMA,
-							dma_ch_name);
-		if (!dma_res) {
-			dev_dbg(&pdev->dev, "cannot get DMA RX channel\n");
-			status = -ENODEV;
-			break;
-		}
+		sprintf(dma_rx_ch_name, "rx%d", i);
+		if (!pdev->dev.of_node) {
+			dma_res =
+				platform_get_resource_byname(pdev,
+							     IORESOURCE_DMA,
+							     dma_rx_ch_name);
+			if (!dma_res) {
+				dev_dbg(&pdev->dev,
+					"cannot get DMA RX channel\n");
+				status = -ENODEV;
+				break;
+			}
 
-		mcspi->dma_channels[i].dma_rx_sync_dev = dma_res->start;
-		sprintf(dma_ch_name, "tx%d", i);
-		dma_res = platform_get_resource_byname(pdev, IORESOURCE_DMA,
-							dma_ch_name);
-		if (!dma_res) {
-			dev_dbg(&pdev->dev, "cannot get DMA TX channel\n");
-			status = -ENODEV;
-			break;
+			mcspi->dma_channels[i].dma_rx_sync_dev =
+				dma_res->start;
 		}
+		sprintf(dma_tx_ch_name, "tx%d", i);
+		if (!pdev->dev.of_node) {
+			dma_res =
+				platform_get_resource_byname(pdev,
+							     IORESOURCE_DMA,
+							     dma_tx_ch_name);
+			if (!dma_res) {
+				dev_dbg(&pdev->dev,
+					"cannot get DMA TX channel\n");
+				status = -ENODEV;
+				break;
+			}
 
-		mcspi->dma_channels[i].dma_tx_sync_dev = dma_res->start;
+			mcspi->dma_channels[i].dma_tx_sync_dev =
+				dma_res->start;
+		}
 	}
 
 	if (status < 0)
-- 
1.7.9.5

