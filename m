Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757534Ab0IGPiD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 11:38:03 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33966 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757773Ab0IGPh7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 11:37:59 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Grant Likely <grant.likely@secretlab.ca>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Jassi Brar <jassi.brar@samsung.com>
Cc: spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 1/2] spi/spi_s3c64xx: Fix timeout handling in wait_for_xfer()
Date: Tue,  7 Sep 2010 16:37:51 +0100
Message-Id: <1283873872-8633-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In wait_for_xfer() for PIO transfer we are using val as both a
counter variable to track the number of spins we've waited for
completion and the value we read from the controller, causing
us to fail to ever actually notice the timeout. Fix this by using
a separate value to hold the register readback.

Also warn when we hit the timeout.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/spi/spi_s3c64xx.c |   11 +++++++----
 1 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/spi/spi_s3c64xx.c b/drivers/spi/spi_s3c64xx.c
index 6e48ea9..03b28e4 100644
--- a/drivers/spi/spi_s3c64xx.c
+++ b/drivers/spi/spi_s3c64xx.c
@@ -321,7 +321,7 @@ static int wait_for_xfer(struct s3c64xx_spi_driver_data *sdd,
 {
 	struct s3c64xx_spi_info *sci = sdd->cntrlr_info;
 	void __iomem *regs = sdd->regs;
-	unsigned long val;
+	unsigned long val, reg;
 	int ms;
 
 	/* millisecs to xfer 'len' bytes @ 'cur_speed' */
@@ -333,13 +333,16 @@ static int wait_for_xfer(struct s3c64xx_spi_driver_data *sdd,
 		val = wait_for_completion_timeout(&sdd->xfer_completion, val);
 	} else {
 		val = msecs_to_loops(ms);
+
 		do {
-			val = readl(regs + S3C64XX_SPI_STATUS);
-		} while (RX_FIFO_LVL(val, sci) < xfer->len && --val);
+			reg = readl(regs + S3C64XX_SPI_STATUS);
+		} while (RX_FIFO_LVL(reg, sci) < xfer->len && --val);
 	}
 
-	if (!val)
+	if (!val) {
+		dev_warn(&sdd->pdev->dev, "Transfer timeout\n");
 		return -EIO;
+	}
 
 	if (dma_mode) {
 		u32 status;
-- 
1.7.1

