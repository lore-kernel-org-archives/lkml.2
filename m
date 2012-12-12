Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751896Ab2LLIxX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 03:53:23 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:60532 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751160Ab2LLIxW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 03:53:22 -0500
From: Felipe Balbi <balbi@ti.com>
To: <spi-devel-general@lists.sourceforge.net>, <rob@landley.net>,
        <rob.herring@calxeda.com>
CC: <grant.likely@secretlab.ca>, <devicetree-discuss@lists.ozlabs.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>, Felipe Balbi <balbi@ti.com>
Subject: [PATCH 1/2] spi: omap2: disable DMA requests before complete()
Date: Wed, 12 Dec 2012 10:45:59 +0200
Message-ID: <1355301960-21523-1-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No actual errors have been found for completing
before disabling DMA request lines, but it just
looks more semantically correct that on our DMA
callback we quiesce the whole thing before stating
transfer is finished.

Signed-off-by: Felipe Balbi <balbi@ti.com>
---
 drivers/spi/spi-omap2-mcspi.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/spi/spi-omap2-mcspi.c b/drivers/spi/spi-omap2-mcspi.c
index b610f52..68446db 100644
--- a/drivers/spi/spi-omap2-mcspi.c
+++ b/drivers/spi/spi-omap2-mcspi.c
@@ -298,10 +298,10 @@ static void omap2_mcspi_rx_callback(void *data)
 	struct omap2_mcspi *mcspi = spi_master_get_devdata(spi->master);
 	struct omap2_mcspi_dma *mcspi_dma = &mcspi->dma_channels[spi->chip_select];
 
-	complete(&mcspi_dma->dma_rx_completion);
-
 	/* We must disable the DMA RX request */
 	omap2_mcspi_set_dma_req(spi, 1, 0);
+
+	complete(&mcspi_dma->dma_rx_completion);
 }
 
 static void omap2_mcspi_tx_callback(void *data)
@@ -310,10 +310,10 @@ static void omap2_mcspi_tx_callback(void *data)
 	struct omap2_mcspi *mcspi = spi_master_get_devdata(spi->master);
 	struct omap2_mcspi_dma *mcspi_dma = &mcspi->dma_channels[spi->chip_select];
 
-	complete(&mcspi_dma->dma_tx_completion);
-
 	/* We must disable the DMA TX request */
 	omap2_mcspi_set_dma_req(spi, 0, 0);
+
+	complete(&mcspi_dma->dma_tx_completion);
 }
 
 static void omap2_mcspi_tx_dma(struct spi_device *spi,
-- 
1.8.1.rc1.5.g7e0651a

