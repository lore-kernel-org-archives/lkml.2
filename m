Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753548Ab0IMQIS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 12:08:18 -0400
Received: from mailbigip.dreamhost.com ([208.97.132.5]:56933 "EHLO
	homiemail-a6.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752219Ab0IMQIR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 12:08:17 -0400
Subject: [PATCH] serial: max3107: Fix memory leaks when returning on error
From: Davidlohr Bueso <dave@gnu.org>
Reply-To: dave@gnu.org
To: jianwei.yang@intel.com, alan@linux.intel.com, gregkh@suse.de
Cc: linux-serial@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 13 Sep 2010 12:08:11 -0400
Message-ID: <1284394091.2055.5.camel@cowboy>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH] serial: max3107: Fix memory leaks in max3107_probe() when returning on error.

Signed-off-by: Davidlohr Bueso <dave@gnu.org>
---
 drivers/serial/max3107.c |   34 +++++++++++++++++++++++++---------
 1 files changed, 25 insertions(+), 9 deletions(-)

diff --git a/drivers/serial/max3107.c b/drivers/serial/max3107.c
index 67283c1..910870e 100644
--- a/drivers/serial/max3107.c
+++ b/drivers/serial/max3107.c
@@ -986,12 +986,14 @@ int max3107_probe(struct spi_device *spi, struct max3107_plat *pdata)
 	s->rxbuf = kzalloc(sizeof(u16) * (MAX3107_RX_FIFO_SIZE+2), GFP_KERNEL);
 	if (!s->rxbuf) {
 		pr_err("Allocating RX buffer failed\n");
-		return -ENOMEM;
+		retval = -ENOMEM;
+		goto err_free4;
 	}
 	s->rxstr = kzalloc(sizeof(u8) * MAX3107_RX_FIFO_SIZE, GFP_KERNEL);
 	if (!s->rxstr) {
 		pr_err("Allocating RX buffer failed\n");
-		return -ENOMEM;
+		retval = -ENOMEM;
+		goto err_free3;
 	}
 	/* SPI Tx buffer
 	 * SPI transfer buffer
@@ -1002,7 +1004,8 @@ int max3107_probe(struct spi_device *spi, struct max3107_plat *pdata)
 	s->txbuf = kzalloc(sizeof(u16) * MAX3107_TX_FIFO_SIZE + 3, GFP_KERNEL);
 	if (!s->txbuf) {
 		pr_err("Allocating TX buffer failed\n");
-		return -ENOMEM;
+		retval = -ENOMEM;
+		goto err_free2;
 	}
 	/* Initialize shared data lock */
 	spin_lock_init(&s->data_lock);
@@ -1021,13 +1024,15 @@ int max3107_probe(struct spi_device *spi, struct max3107_plat *pdata)
 	buf[0] = MAX3107_REVID_REG;
 	if (max3107_rw(s, (u8 *)buf, (u8 *)buf, 2)) {
 		dev_err(&s->spi->dev, "SPI transfer for REVID read failed\n");
-		return -EIO;
+		retval = -EIO;
+		goto err_free1;
 	}
 	if ((buf[0] & MAX3107_SPI_RX_DATA_MASK) != MAX3107_REVID1 &&
 		(buf[0] & MAX3107_SPI_RX_DATA_MASK) != MAX3107_REVID2) {
 		dev_err(&s->spi->dev, "REVID %x does not match\n",
 				(buf[0] & MAX3107_SPI_RX_DATA_MASK));
-		return -ENODEV;
+		retval = -ENODEV;
+		goto err_free1;
 	}
 
 	/* Disable all interrupts */
@@ -1047,7 +1052,8 @@ int max3107_probe(struct spi_device *spi, struct max3107_plat *pdata)
 	/* Perform SPI transfer */
 	if (max3107_rw(s, (u8 *)buf, NULL, 4)) {
 		dev_err(&s->spi->dev, "SPI transfer for init failed\n");
-		return -EIO;
+		retval = -EIO;
+		goto err_free1;
 	}
 
 	/* Register UART driver */
@@ -1055,7 +1061,7 @@ int max3107_probe(struct spi_device *spi, struct max3107_plat *pdata)
 		retval = uart_register_driver(&max3107_uart_driver);
 		if (retval) {
 			dev_err(&s->spi->dev, "Registering UART driver failed\n");
-			return retval;
+			goto err_free1;
 		}
 		driver_registered = 1;
 	}
@@ -1074,13 +1080,13 @@ int max3107_probe(struct spi_device *spi, struct max3107_plat *pdata)
 	retval = uart_add_one_port(&max3107_uart_driver, &s->port);
 	if (retval < 0) {
 		dev_err(&s->spi->dev, "Adding UART port failed\n");
-		return retval;
+		goto err_free1;
 	}
 
 	if (pdata->configure) {
 		retval = pdata->configure(s);
 		if (retval < 0)
-			return retval;
+			goto err_free1;
 	}
 
 	/* Go to suspend mode */
@@ -1088,6 +1094,16 @@ int max3107_probe(struct spi_device *spi, struct max3107_plat *pdata)
 		pdata->hw_suspend(s, 1);
 
 	return 0;
+
+err_free1:
+	kfree(s->txbuf);
+err_free2:
+	kfree(s->rxstr);
+err_free3:
+	kfree(s->rxbuf);
+err_free4:
+	kfree(s);
+	return retval;
 }
 EXPORT_SYMBOL_GPL(max3107_probe);
 
-- 
1.7.0.4



