Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753527Ab3AGB6V (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2013 20:58:21 -0500
Received: from newsmtp5.atmel.com ([204.2.163.5]:9379 "EHLO sjogate2.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753391Ab3AGB4w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2013 20:56:52 -0500
From: Wenyou Yang <wenyou.yang@atmel.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, nicolas.ferre@atmel.com,
        plagnioj@jcrosoft.com, richard.genoud@gmail.com, JM.Lin@atmel.com,
        wenyou.yang@atmel.com, grant.likely@secretlab.ca,
        spi-devel-general@lists.sourceforge.net
Subject: [v3 PATCH 09/12] spi/atmel_spi: correct 16 bits transfer with DMA
Date: Mon,  7 Jan 2013 09:50:10 +0800
Message-Id: <1357523413-27209-10-git-send-email-wenyou.yang@atmel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1357523413-27209-1-git-send-email-wenyou.yang@atmel.com>
References: <1357523413-27209-1-git-send-email-wenyou.yang@atmel.com>
X-OriginalArrivalTime: 07 Jan 2013 01:56:38.0756 (UTC) FILETIME=[3B3BEA40:01CDEC7A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Richard Genoud <richard.genoud@gmail.com>

Signed-off-by: Richard Genoud <richard.genoud@gmail.com>
Cc: grant.likely@secretlab.ca
Cc: spi-devel-general@lists.sourceforge.net
---
 drivers/spi/spi-atmel.c |   17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/spi/spi-atmel.c b/drivers/spi/spi-atmel.c
index 5abb276..dd070cd 100644
--- a/drivers/spi/spi-atmel.c
+++ b/drivers/spi/spi-atmel.c
@@ -466,12 +466,18 @@ static inline int atmel_spi_xfer_can_be_chained(struct spi_transfer *xfer)
 }
 
 static int atmel_spi_dma_slave_config(struct atmel_spi *as,
-				struct dma_slave_config *slave_config)
+				struct dma_slave_config *slave_config,
+				u8 bits_per_word)
 {
 	int err = 0;
 
-	slave_config->dst_addr_width = DMA_SLAVE_BUSWIDTH_1_BYTE;
-	slave_config->src_addr_width = DMA_SLAVE_BUSWIDTH_1_BYTE;
+	if (bits_per_word > 8) {
+		slave_config->dst_addr_width = DMA_SLAVE_BUSWIDTH_2_BYTES;
+		slave_config->src_addr_width = DMA_SLAVE_BUSWIDTH_2_BYTES;
+	} else {
+		slave_config->dst_addr_width = DMA_SLAVE_BUSWIDTH_1_BYTE;
+		slave_config->src_addr_width = DMA_SLAVE_BUSWIDTH_1_BYTE;
+	}
 
 	slave_config->dst_addr = (dma_addr_t)as->phybase + SPI_TDR;
 	slave_config->src_addr = (dma_addr_t)as->phybase + SPI_RDR;
@@ -533,7 +539,7 @@ static int __devinit atmel_spi_configure_dma(struct atmel_spi *as)
 		goto error;
 	}
 
-	err = atmel_spi_dma_slave_config(as, &slave_config);
+	err = atmel_spi_dma_slave_config(as, &slave_config, 8);
 	if (err)
 		goto error;
 
@@ -667,10 +673,9 @@ static int atmel_spi_next_xfer_dma_submit(struct spi_master *master,
 
 	*plen = len;
 
-	if (atmel_spi_dma_slave_config(as, &slave_config))
+	if (atmel_spi_dma_slave_config(as, &slave_config, 8))
 		goto err_exit;
 
-
 	/* Send both scatterlists */
 	rxdesc = rxchan->device->device_prep_slave_sg(rxchan,
 					&as->dma.sgrx,
-- 
1.7.9.5

