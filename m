Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758882Ab1FWCAy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 22:00:54 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:58820 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758782Ab1FWCAt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 22:00:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=esjE9Ajxndh0FXFOLenV0VY3ITAbrU4W3Njgmu/GEwsImxwdNKND9bd2HXSKXVToFR
         L+J0IJ35ZXK6SODWbs8ezO4dTfMdN78wkeb2MDryMW6i0ySa5r2lrnOpH3xxdbb7uGAL
         SAIPUZSnBuO5MPSH9A6RlXGsaUht4i0nfbmcU=
From: dirk.brandewie@gmail.com
To: linux-kernel@vger.kernel.org, spi-devel-general@lists.sourceforge.net
Cc: Dirk Brandewie <dirk.brandewie@gmail.com>
Subject: [PATCH 03/11] spi-dw: change MRST prefix to generic prefix
Date: Wed, 22 Jun 2011 19:00:05 -0700
Message-Id: <1308794413-11069-4-git-send-email-dirk.brandewie@gmail.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1308794413-11069-1-git-send-email-dirk.brandewie@gmail.com>
References: <1308794413-11069-1-git-send-email-dirk.brandewie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dirk Brandewie <dirk.brandewie@gmail.com>

The designware SPI core is now used in multiple SOC's.  Make the
prefix more generic and match other naming changes.

Signed-off-by: Dirk Brandewie <dirk.brandewie@gmail.com>
---
 drivers/spi/spi-dw.c       |   10 +++++-----
 drivers/spi/spi-dw.h       |    3 +--
 include/linux/spi/spi-dw.h |    4 ++--
 3 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/spi/spi-dw.c b/drivers/spi/spi-dw.c
index fb09a9d..3d98e4c 100644
--- a/drivers/spi/spi-dw.c
+++ b/drivers/spi/spi-dw.c
@@ -131,7 +131,7 @@ static const struct file_operations spi_dw_regs_ops = {
 
 static int spi_dw_debugfs_init(struct spi_dw *dws)
 {
-	dws->debugfs = debugfs_create_dir("mrst_spi", NULL);
+	dws->debugfs = debugfs_create_dir("spi-dw", NULL);
 	if (!dws->debugfs)
 		return -ENOMEM;
 
@@ -283,7 +283,7 @@ static void spi_dw_giveback(struct spi_dw *dws)
 					transfer_list);
 
 	if (!last_transfer->cs_change && dws->cs_control)
-		dws->cs_control(MRST_SPI_DEASSERT);
+		dws->cs_control(SPI_DW_DEASSERT);
 
 	msg->state = NULL;
 	if (msg->complete)
@@ -443,7 +443,7 @@ static void spi_dw_pump_transfers(unsigned long data)
 		if (transfer->speed_hz != speed) {
 			speed = transfer->speed_hz;
 			if (speed > dws->max_freq) {
-				printk(KERN_ERR "MRST SPI0: unsupported"
+				printk(KERN_ERR "DW SPI: unsupported"
 					"freq: %dHz\n", speed);
 				message->status = -EIO;
 				goto early_exit;
@@ -466,7 +466,7 @@ static void spi_dw_pump_transfers(unsigned long data)
 			dws->n_bytes = dws->dma_width = bits >> 3;
 			break;
 		default:
-			printk(KERN_ERR "MRST SPI0: unsupported bits:"
+			printk(KERN_ERR "DW SPI: unsupported bits:"
 				"%db\n", bits);
 			message->status = -EIO;
 			goto early_exit;
@@ -669,7 +669,7 @@ static int spi_dw_setup(struct spi_device *spi)
 		chip->n_bytes = 2;
 		chip->dma_width = 2;
 	} else {
-		/* Never take >16b case for MRST SPIC */
+		/* Never take >16b case for DW SPIC */
 		dev_err(&spi->dev, "invalid wordsize\n");
 		return -EINVAL;
 	}
diff --git a/drivers/spi/spi-dw.h b/drivers/spi/spi-dw.h
index 83b9a59..0148356 100644
--- a/drivers/spi/spi-dw.h
+++ b/drivers/spi/spi-dw.h
@@ -50,7 +50,6 @@
 /* TX RX interrupt level threshold, max can be 256 */
 #define SPI_INT_THRESHOLD		32
 
-
 struct spi_dw_reg {
 	u32	ctrl0;
 	u32	ctrl1;
@@ -181,7 +180,7 @@ static inline void spi_dw_chip_sel(struct spi_dw *dws, u16 cs)
 		return;
 
 	if (dws->cs_control)
-		dws->cs_control(1);
+		dws->cs_control(SPI_DW_ASSERT);
 
 	dw_writel(dws, ser, 1 << cs);
 }
diff --git a/include/linux/spi/spi-dw.h b/include/linux/spi/spi-dw.h
index 787b154..4fb72d9 100644
--- a/include/linux/spi/spi-dw.h
+++ b/include/linux/spi/spi-dw.h
@@ -24,8 +24,8 @@ enum spi_dw_ssi_type {
 	SSI_NS_MICROWIRE,
 };
 
-#define MRST_SPI_DEASSERT	0
-#define MRST_SPI_ASSERT		1
+#define SPI_DW_DEASSERT		0
+#define SPI_DW_ASSERT		1
 
 /*
  * Each SPI slave device to work with dw_api controller should
-- 
1.7.3.4

