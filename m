Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753840Ab2IRSYn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 14:24:43 -0400
Received: from mail-fa0-f74.google.com ([209.85.161.74]:57305 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753721Ab2IRSYf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 14:24:35 -0400
From: Simon Glass <sjg@chromium.org>
To: LKML <linux-kernel@vger.kernel.org>, linux-arm-kernel@lists.infradead.org
Cc: "kgene.kim" <kgene.kim@samsung.com>, Ben Dooks <ben-linux@fluff.org>,
        Srinivas KANDAGATLA <srinivas.kandagatla@st.com>,
        Simon Glass <sjg@chromium.org>
Subject: [PATCH 7/7] spi: s3c64xx: Write to PACKET_CNT after reset
Date: Tue, 18 Sep 2012 11:21:59 -0700
Message-Id: <1347992519-6904-8-git-send-email-sjg@chromium.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1347992519-6904-1-git-send-email-sjg@chromium.org>
References: <1347992519-6904-1-git-send-email-sjg@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Exynos5 datasheet specifically says that a software reset of SPI
must be performed before writing to the PACKET_CNT register. Also,
the current code sometimes causes an extra transfer or two to be
performed.

Adjust the code slightly to fix this problem.

Test flashrom operation on snow.
See that SPI operation with ChromeOS EC is reliable now.

Signed-off-by: Simon Glass <sjg@chromium.org>
---
 drivers/spi/spi-s3c64xx.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/spi/spi-s3c64xx.c b/drivers/spi/spi-s3c64xx.c
index c34ef8f..3716825 100644
--- a/drivers/spi/spi-s3c64xx.c
+++ b/drivers/spi/spi-s3c64xx.c
@@ -213,7 +213,9 @@ static void flush_fifo(struct s3c64xx_spi_driver_data *sdd)
 	unsigned long loops;
 	u32 val;
 
-	writel(0, regs + S3C64XX_SPI_PACKET_CNT);
+	val = readl(regs + S3C64XX_SPI_CH_CFG);
+	val &= ~(S3C64XX_SPI_CH_RXCH_ON | S3C64XX_SPI_CH_TXCH_ON);
+	writel(val, regs + S3C64XX_SPI_CH_CFG);
 
 	val = readl(regs + S3C64XX_SPI_CH_CFG);
 	val |= S3C64XX_SPI_CH_SW_RST;
@@ -250,9 +252,7 @@ static void flush_fifo(struct s3c64xx_spi_driver_data *sdd)
 	val &= ~(S3C64XX_SPI_MODE_TXDMA_ON | S3C64XX_SPI_MODE_RXDMA_ON);
 	writel(val, regs + S3C64XX_SPI_MODE_CFG);
 
-	val = readl(regs + S3C64XX_SPI_CH_CFG);
-	val &= ~(S3C64XX_SPI_CH_RXCH_ON | S3C64XX_SPI_CH_TXCH_ON);
-	writel(val, regs + S3C64XX_SPI_CH_CFG);
+	writel(0, regs + S3C64XX_SPI_PACKET_CNT);
 }
 
 static void s3c64xx_spi_dmacb(void *data)
-- 
1.7.7.3

