Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758647Ab2J2LFY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 07:05:24 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:51657 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758578Ab2J2LFW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 07:05:22 -0400
From: YAMANE Toshiaki <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, YAMANE Toshiaki <yamanetoshi@gmail.com>
Subject: [PATCH 4/7] staging/gdm72xx: Use dev_ printks in gdm_sdio.c
Date: Mon, 29 Oct 2012 20:05:16 +0900
Message-Id: <1351508716-1822-1-git-send-email-yamanetoshi@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1351508627-1713-1-git-send-email-yamanetoshi@gmail.com>
References: <1351508627-1713-1-git-send-email-yamanetoshi@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fixed below checkpatch warnings.
- WARNING: Prefer netdev_err(netdev, ... then dev_err(dev, ... then pr_err(...  to printk(KERN_ERR ...
- WARNING: Prefer netdev_info(netdev, ... then dev_info(dev, ... then pr_info(...  to printk(KERN_INFO ...

Signed-off-by: YAMANE Toshiaki <yamanetoshi@gmail.com>
---
 drivers/staging/gdm72xx/gdm_sdio.c |   29 ++++++++++++++++-------------
 1 file changed, 16 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/gdm72xx/gdm_sdio.c b/drivers/staging/gdm72xx/gdm_sdio.c
index ca38d71..8b8ed98 100644
--- a/drivers/staging/gdm72xx/gdm_sdio.c
+++ b/drivers/staging/gdm72xx/gdm_sdio.c
@@ -157,7 +157,7 @@ static int init_sdio(struct sdiowm_dev *sdev)
 
 	tx->sdu_buf = kmalloc(SDU_TX_BUF_SIZE, GFP_KERNEL);
 	if (tx->sdu_buf == NULL) {
-		printk(KERN_ERR "Failed to allocate SDU tx buffer.\n");
+		dev_err(&sdev->func->dev, "Failed to allocate SDU tx buffer.\n");
 		goto fail;
 	}
 
@@ -186,7 +186,7 @@ static int init_sdio(struct sdiowm_dev *sdev)
 
 	rx->rx_buf = kmalloc(RX_BUF_SIZE, GFP_KERNEL);
 	if (rx->rx_buf == NULL) {
-		printk(KERN_ERR "Failed to allocate rx buffer.\n");
+		dev_err(&sdev->func->dev, "Failed to allocate rx buffer.\n");
 		goto fail;
 	}
 
@@ -246,7 +246,8 @@ static void send_sdio_pkt(struct sdio_func *func, u8 *data, int len)
 		ret = sdio_memcpy_toio(func, 0, data, n);
 		if (ret < 0) {
 			if (ret != -ENOMEDIUM)
-				printk(KERN_ERR "gdmwms: %s error: ret = %d\n",
+				dev_err(&func->dev,
+					"gdmwms: %s error: ret = %d\n",
 					__func__, ret);
 			goto end_io;
 		}
@@ -259,7 +260,8 @@ static void send_sdio_pkt(struct sdio_func *func, u8 *data, int len)
 		ret = sdio_memcpy_toio(func, 0, data + n, remain);
 		if (ret < 0) {
 			if (ret != -ENOMEDIUM)
-				printk(KERN_ERR "gdmwms: %s error: ret = %d\n",
+				dev_err(&func->dev,
+					"gdmwms: %s error: ret = %d\n",
 					__func__, ret);
 			goto end_io;
 		}
@@ -522,13 +524,14 @@ static void gdm_sdio_irq(struct sdio_func *func)
 
 	ret = sdio_memcpy_fromio(func, hdr, 0x0, TYPE_A_LOOKAHEAD_SIZE);
 	if (ret) {
-		printk(KERN_ERR "Cannot read from function %d\n", func->num);
+		dev_err(&func->dev,
+			"Cannot read from function %d\n", func->num);
 		goto done;
 	}
 
 	len = (hdr[2] << 16) | (hdr[1] << 8) | hdr[0];
 	if (len > (RX_BUF_SIZE - TYPE_A_HEADER_SIZE)) {
-		printk(KERN_ERR "Too big Type-A size: %d\n", len);
+		dev_err(&func->dev, "Too big Type-A size: %d\n", len);
 		goto done;
 	}
 
@@ -562,8 +565,8 @@ static void gdm_sdio_irq(struct sdio_func *func)
 		n = blocks * func->cur_blksize;
 		ret = sdio_memcpy_fromio(func, buf, 0x0, n);
 		if (ret) {
-			printk(KERN_ERR "Cannot read from function %d\n",
-				func->num);
+			dev_err(&func->dev,
+				"Cannot read from function %d\n", func->num);
 			goto done;
 		}
 		buf += n;
@@ -573,8 +576,8 @@ static void gdm_sdio_irq(struct sdio_func *func)
 	if (remain) {
 		ret = sdio_memcpy_fromio(func, buf, 0x0, remain);
 		if (ret) {
-			printk(KERN_ERR "Cannot read from function %d\n",
-				func->num);
+			dev_err(&func->dev,
+				"Cannot read from function %d\n", func->num);
 			goto done;
 		}
 	}
@@ -637,9 +640,9 @@ static int sdio_wimax_probe(struct sdio_func *func,
 	struct phy_dev *phy_dev = NULL;
 	struct sdiowm_dev *sdev = NULL;
 
-	printk(KERN_INFO "Found GDM SDIO VID = 0x%04x PID = 0x%04x...\n",
-			func->vendor, func->device);
-	printk(KERN_INFO "GCT WiMax driver version %s\n", DRIVER_VERSION);
+	dev_info(&func->dev, "Found GDM SDIO VID = 0x%04x PID = 0x%04x...\n",
+		 func->vendor, func->device);
+	dev_info(&func->dev, "GCT WiMax driver version %s\n", DRIVER_VERSION);
 
 	sdio_claim_host(func);
 	sdio_enable_func(func);
-- 
1.7.9.5

