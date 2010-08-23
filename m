Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752584Ab0HWQlH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 12:41:07 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:45677 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751556Ab0HWQlF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 12:41:05 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: David Brownell <dbrownell@users.sourceforge.net>,
        Grant Likely <grant.likely@secretlab.ca>
Cc: spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] spi/spi_s3c64xx: Warn if PIO transfers time out
Date: Mon, 23 Aug 2010 17:40:56 +0100
Message-Id: <1282581656-26137-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When using PIO we have a timeout for the TX and RX FIFOs to ensure that
the data actually gets transferred. Warn if we hit that timeout - it
should never happen, but this makes sure we'll find out if it does.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/spi/spi_s3c64xx.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/spi/spi_s3c64xx.c b/drivers/spi/spi_s3c64xx.c
index 7e627f7..f72e1c0 100644
--- a/drivers/spi/spi_s3c64xx.c
+++ b/drivers/spi/spi_s3c64xx.c
@@ -200,6 +200,9 @@ static void flush_fifo(struct s3c64xx_spi_driver_data *sdd)
 		val = readl(regs + S3C64XX_SPI_STATUS);
 	} while (TX_FIFO_LVL(val, sci) && loops--);
 
+	if (loops == 0)
+		dev_warn(&sdd->pdev->dev, "Timed out flushing TX FIFO\n");
+
 	/* Flush RxFIFO*/
 	loops = msecs_to_loops(1);
 	do {
@@ -210,6 +213,9 @@ static void flush_fifo(struct s3c64xx_spi_driver_data *sdd)
 			break;
 	} while (loops--);
 
+	if (loops == 0)
+		dev_warn(&sdd->pdev->dev, "Timed out flushing RX FIFO\n");
+
 	val = readl(regs + S3C64XX_SPI_CH_CFG);
 	val &= ~S3C64XX_SPI_CH_SW_RST;
 	writel(val, regs + S3C64XX_SPI_CH_CFG);
-- 
1.7.1

