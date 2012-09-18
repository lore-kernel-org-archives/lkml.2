Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753774Ab2IRSYg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 14:24:36 -0400
Received: from mail-qc0-f202.google.com ([209.85.216.202]:58352 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753620Ab2IRSYe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 14:24:34 -0400
From: Simon Glass <sjg@chromium.org>
To: LKML <linux-kernel@vger.kernel.org>, linux-arm-kernel@lists.infradead.org
Cc: "kgene.kim" <kgene.kim@samsung.com>, Ben Dooks <ben-linux@fluff.org>,
        Srinivas KANDAGATLA <srinivas.kandagatla@st.com>,
        Simon Glass <sjg@chromium.org>
Subject: [PATCH 2/7] spi: s3c64xx: Fix enum dma_data_direction warning
Date: Tue, 18 Sep 2012 11:21:54 -0700
Message-Id: <1347992519-6904-3-git-send-email-sjg@chromium.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1347992519-6904-1-git-send-email-sjg@chromium.org>
References: <1347992519-6904-1-git-send-email-sjg@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While the effect is harmless, the SPI driver is actually using the wrong
enum and this generates warnings:

drivers/spi/spi-s3c64xx.c: In function 's3c64xx_spi_dmacb':
drivers/spi/spi-s3c64xx.c:268:21: warning: comparison between 'enum dma_data_direction' and 'enum dma_transfer_direction' [-Wenum-compare]
drivers/spi/spi-s3c64xx.c:277:21: warning: comparison between 'enum dma_data_direction' and 'enum dma_transfer_direction' [-Wenum-compare]
drivers/spi/spi-s3c64xx.c: In function 'prepare_dma':
drivers/spi/spi-s3c64xx.c:296:21: warning: comparison between 'enum dma_data_direction' and 'enum dma_transfer_direction' [-Wenum-compare]

Signed-off-by: Simon Glass <sjg@chromium.org>
---
 drivers/spi/spi-s3c64xx.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/spi/spi-s3c64xx.c b/drivers/spi/spi-s3c64xx.c
index 646a765..3152659 100644
--- a/drivers/spi/spi-s3c64xx.c
+++ b/drivers/spi/spi-s3c64xx.c
@@ -260,7 +260,7 @@ static void s3c64xx_spi_dmacb(void *data)
 	struct s3c64xx_spi_dma_data *dma = data;
 	unsigned long flags;
 
-	if (dma->direction == DMA_DEV_TO_MEM)
+	if (dma->direction == DMA_FROM_DEVICE)
 		sdd = container_of(data,
 			struct s3c64xx_spi_driver_data, rx_dma);
 	else
@@ -269,7 +269,7 @@ static void s3c64xx_spi_dmacb(void *data)
 
 	spin_lock_irqsave(&sdd->lock, flags);
 
-	if (dma->direction == DMA_DEV_TO_MEM) {
+	if (dma->direction == DMA_FROM_DEVICE) {
 		sdd->state &= ~RXBUSY;
 		if (!(sdd->state & TXBUSY))
 			complete(&sdd->xfer_completion);
@@ -289,7 +289,7 @@ static void prepare_dma(struct s3c64xx_spi_dma_data *dma,
 	struct samsung_dma_prep info;
 	struct samsung_dma_config config;
 
-	if (dma->direction == DMA_DEV_TO_MEM) {
+	if (dma->direction == DMA_FROM_DEVICE) {
 		sdd = container_of((void *)dma,
 			struct s3c64xx_spi_driver_data, rx_dma);
 		config.direction = sdd->rx_dma.direction;
-- 
1.7.7.3

