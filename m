Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753693Ab2IRScg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 14:32:36 -0400
Received: from mail-we0-f202.google.com ([74.125.82.202]:47470 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750877Ab2IRScf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 14:32:35 -0400
From: Simon Glass <sjg@chromium.org>
To: LKML <linux-kernel@vger.kernel.org>, linux-arm-kernel@lists.infradead.org
Cc: "kgene.kim" <kgene.kim@samsung.com>, Ben Dooks <ben-linux@fluff.org>,
        Srinivas KANDAGATLA <srinivas.kandagatla@st.com>,
        Simon Glass <sjg@chromium.org>
Subject: [PATCH 4/7] spi: s3c64xx: Use jiffies instead of loops for timeout
Date: Tue, 18 Sep 2012 11:21:56 -0700
Message-Id: <1347992519-6904-5-git-send-email-sjg@chromium.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1347992519-6904-1-git-send-email-sjg@chromium.org>
References: <1347992519-6904-1-git-send-email-sjg@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current timeout uses loops, but does not actually use an empty loop. In
fact it checks SPI registers which are pretty slow to read. As a result the
timeout ends up being several seconds most of the time.

Change this to use jiffies instead.

Signed-off-by: Simon Glass <sjg@chromium.org>
---
 drivers/spi/spi-s3c64xx.c |   37 ++++++++++++++++++++++---------------
 1 files changed, 22 insertions(+), 15 deletions(-)

diff --git a/drivers/spi/spi-s3c64xx.c b/drivers/spi/spi-s3c64xx.c
index 95a1bfc..db79d87 100644
--- a/drivers/spi/spi-s3c64xx.c
+++ b/drivers/spi/spi-s3c64xx.c
@@ -427,6 +427,7 @@ static inline void enable_cs(struct s3c64xx_spi_driver_data *sdd,
 static int wait_for_xfer(struct s3c64xx_spi_driver_data *sdd,
 				struct spi_transfer *xfer, int dma_mode)
 {
+	struct device *dev = &sdd->pdev->dev;
 	void __iomem *regs = sdd->regs;
 	unsigned long val;
 	int ms;
@@ -439,16 +440,21 @@ static int wait_for_xfer(struct s3c64xx_spi_driver_data *sdd,
 		val = msecs_to_jiffies(ms) + 10;
 		val = wait_for_completion_timeout(&sdd->xfer_completion, val);
 	} else {
+		ulong deadline;
 		u32 status;
-		val = msecs_to_loops(ms);
+
+		deadline = jiffies + msecs_to_jiffies(ms);
 		do {
 			status = readl(regs + S3C64XX_SPI_STATUS);
-		} while (RX_FIFO_LVL(status, sdd) < xfer->len && --val);
+			if (time_after(jiffies, deadline)) {
+				dev_warn(dev, "RX timeout level=%d, need=%d\n",
+					RX_FIFO_LVL(status, sdd), xfer->len);
+				return -EIO;
+			}
+			cpu_relax();
+		} while (RX_FIFO_LVL(status, sdd) < xfer->len);
 	}
 
-	if (!val)
-		return -EIO;
-
 	if (dma_mode) {
 		u32 status;
 
@@ -460,17 +466,18 @@ static int wait_for_xfer(struct s3c64xx_spi_driver_data *sdd,
 		 * Xfer involved Rx(with or without Tx).
 		 */
 		if (xfer->rx_buf == NULL) {
-			val = msecs_to_loops(10);
-			status = readl(regs + S3C64XX_SPI_STATUS);
-			while ((TX_FIFO_LVL(status, sdd)
-				|| !S3C64XX_SPI_ST_TX_DONE(status, sdd))
-					&& --val) {
-				cpu_relax();
-				status = readl(regs + S3C64XX_SPI_STATUS);
-			}
+			ulong deadline;
 
-			if (!val)
-				return -EIO;
+			deadline = jiffies + msecs_to_jiffies(10);
+			do {
+				status = readl(regs + S3C64XX_SPI_STATUS);
+				if (time_after(jiffies, deadline)) {
+					dev_warn(dev, "TX timeout level=%d\n",
+						TX_FIFO_LVL(status, sdd));
+					return -EIO;
+				}
+			} while (TX_FIFO_LVL(status, sdd) ||
+					!S3C64XX_SPI_ST_TX_DONE(status, sdd));
 		}
 	} else {
 		/* If it was only Tx */
-- 
1.7.7.3

