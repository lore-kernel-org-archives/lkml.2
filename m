Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753605Ab3AGB5y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2013 20:57:54 -0500
Received: from newsmtp5.atmel.com ([204.2.163.5]:3230 "EHLO sjogate2.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753258Ab3AGB4y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2013 20:56:54 -0500
From: Wenyou Yang <wenyou.yang@atmel.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, nicolas.ferre@atmel.com,
        plagnioj@jcrosoft.com, richard.genoud@gmail.com, JM.Lin@atmel.com,
        wenyou.yang@atmel.com, grant.likely@secretlab.ca,
        spi-devel-general@lists.sourceforge.net
Subject: [v3 PATCH 08/12] spi/atmel_spi: correct 16 bits transfers using PIO
Date: Mon,  7 Jan 2013 09:50:09 +0800
Message-Id: <1357523413-27209-9-git-send-email-wenyou.yang@atmel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1357523413-27209-1-git-send-email-wenyou.yang@atmel.com>
References: <1357523413-27209-1-git-send-email-wenyou.yang@atmel.com>
X-OriginalArrivalTime: 07 Jan 2013 01:56:34.0678 (UTC) FILETIME=[38CDA960:01CDEC7A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Richard Genoud <richard.genoud@gmail.com>

Signed-off-by: Richard Genoud <richard.genoud@gmail.com>
Cc: grant.likely@secretlab.ca
Cc: spi-devel-general@lists.sourceforge.net
---
 drivers/spi/spi-atmel.c |   46 +++++++++++++++++++++++++++++++++++++---------
 1 file changed, 37 insertions(+), 9 deletions(-)

diff --git a/drivers/spi/spi-atmel.c b/drivers/spi/spi-atmel.c
index 8131aa1..5abb276 100644
--- a/drivers/spi/spi-atmel.c
+++ b/drivers/spi/spi-atmel.c
@@ -599,13 +599,17 @@ static void atmel_spi_next_xfer_pio(struct spi_master *master,
 	}
 
 	if (xfer->tx_buf)
-		spi_writel(as, TDR, *(u8 *)(xfer->tx_buf));
+		if (xfer->bits_per_word > 8)
+			spi_writel(as, TDR, *(u16 *)(xfer->tx_buf));
+		else
+			spi_writel(as, TDR, *(u8 *)(xfer->tx_buf));
 	else
 		spi_writel(as, TDR, 0);
 
 	dev_dbg(master->dev.parent,
-		"  start pio xfer %p: len %u tx %p rx %p\n",
-		xfer, xfer->len, xfer->tx_buf, xfer->rx_buf);
+		"  start pio xfer %p: len %u tx %p rx %p bitpw %d\n",
+		xfer, xfer->len, xfer->tx_buf, xfer->rx_buf,
+		xfer->bits_per_word);
 
 	/* Enable relevant interrupts */
 	spi_writel(as, IER, SPI_BIT(RDRF) | SPI_BIT(OVRES));
@@ -1023,21 +1027,39 @@ atmel_spi_pump_pio_data(struct atmel_spi *as, struct spi_transfer *xfer)
 {
 	u8		*txp;
 	u8		*rxp;
+	u16		*txp16;
+	u16		*rxp16;
 	unsigned long	xfer_pos = xfer->len - as->current_remaining_bytes;
 
 	if (xfer->rx_buf) {
-		rxp = ((u8 *)xfer->rx_buf) + xfer_pos;
-		*rxp = spi_readl(as, RDR);
+		if (xfer->bits_per_word > 8) {
+			rxp16 = (u16 *)(((u8 *)xfer->rx_buf) + xfer_pos);
+			*rxp16 = spi_readl(as, RDR);
+		} else {
+			rxp = ((u8 *)xfer->rx_buf) + xfer_pos;
+			*rxp = spi_readl(as, RDR);
+		}
 	} else {
 		spi_readl(as, RDR);
 	}
-
-	as->current_remaining_bytes--;
+	if (xfer->bits_per_word > 8) {
+		as->current_remaining_bytes -= 2;
+		if (as->current_remaining_bytes < 0)
+			as->current_remaining_bytes = 0;
+	} else {
+		as->current_remaining_bytes--;
+	}
 
 	if (as->current_remaining_bytes) {
 		if (xfer->tx_buf) {
-			txp = ((u8 *)xfer->tx_buf) + xfer_pos + 1;
-			spi_writel(as, TDR, *txp);
+			if (xfer->bits_per_word > 8) {
+				txp16 = (u16 *)(((u8 *)xfer->tx_buf)
+							+ xfer_pos + 2);
+				spi_writel(as, TDR, *txp16);
+			} else {
+				txp = ((u8 *)xfer->tx_buf) + xfer_pos + 1;
+				spi_writel(as, TDR, *txp);
+			}
 		} else {
 			spi_writel(as, TDR, 0);
 		}
@@ -1459,6 +1481,12 @@ static int atmel_spi_transfer(struct spi_device *spi, struct spi_message *msg)
 				return -ENOPROTOOPT;
 			}
 		}
+		if (xfer->bits_per_word > 8) {
+			if (xfer->len % 2) {
+				dev_dbg(&spi->dev, "buffer len should be 16 bits aligned\n");
+				return -EINVAL;
+			}
+		}
 
 		/* FIXME implement these protocol options!! */
 		if (xfer->speed_hz) {
-- 
1.7.9.5

