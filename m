Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932574Ab0JVSVw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 14:21:52 -0400
Received: from kroah.org ([198.145.64.141]:41909 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932561Ab0JVSVu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 14:21:50 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Davidlohr Bueso <dave@gnu.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 23/49] serial: max3107: Fix memory leaks when returning on error
Date: Fri, 22 Oct 2010 11:21:02 -0700
Message-Id: <1287771688-14805-23-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20101022175112.GC13489@kroah.com>
References: <20101022175112.GC13489@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Davidlohr Bueso <dave@gnu.org>

Fix memory leaks in max3107_probe() when returning on error.

Signed-off-by: Davidlohr Bueso <dave@gnu.org>
Acked-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
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
1.7.2

