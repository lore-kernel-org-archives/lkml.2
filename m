Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752566Ab2LDH7o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 02:59:44 -0500
Received: from newsmtp5.atmel.com ([204.2.163.5]:63385 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751204Ab2LDH7m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 02:59:42 -0500
From: Wenyou Yang <wenyou.yang@atmel.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, nicolas.ferre@atmel.com,
        plagnioj@jcrosoft.com, richard.genoud@gmail.com, JM.Lin@atmel.com,
        wenyou.yang@atmel.com, grant.likely@secretlab.ca,
        spi-devel-general@lists.sourceforge.net
Subject: [v2 PATCH 10/14] spi/atmel_spi: correct 16 bits transfers using PIO
Date: Tue,  4 Dec 2012 15:53:56 +0800
Message-Id: <1354607640-13229-11-git-send-email-wenyou.yang@atmel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1354607640-13229-1-git-send-email-wenyou.yang@atmel.com>
References: <1354607640-13229-1-git-send-email-wenyou.yang@atmel.com>
X-OriginalArrivalTime: 04 Dec 2012 07:59:21.0452 (UTC) FILETIME=[44C44AC0:01CDD1F5]
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
index 7f624b6..9616fab 100644
--- a/drivers/spi/spi-atmel.c
+++ b/drivers/spi/spi-atmel.c
@@ -573,13 +573,17 @@ static void atmel_spi_next_xfer_pio(struct spi_master *master,
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
@@ -997,21 +1001,39 @@ atmel_spi_pump_pio_data(struct atmel_spi *as, struct spi_transfer *xfer)
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
@@ -1431,6 +1453,12 @@ static int atmel_spi_transfer(struct spi_device *spi, struct spi_message *msg)
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

