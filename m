Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756612Ab0IJJID (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 05:08:03 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:24803 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754579Ab0IJJIC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 05:08:02 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        avictor.za@gmail.com
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH] AT91: at91sam9261ek board: remove warnings related to use of SPI or SD/MMC
Date: Fri, 10 Sep 2010 12:13:49 +0200
Message-Id: <1284113629-13768-2-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1284113629-13768-1-git-send-email-nicolas.ferre@atmel.com>
References: <1284113629-13768-1-git-send-email-nicolas.ferre@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The sd/mmc data structure is not used if SPI is selected. The configuration
of PIO on the board prevent from using both interfaces at the same time
(board dependent).
Remove the warnings at compilation time adding a preprocessor condition.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 arch/arm/mach-at91/board-sam9261ek.c |   30 +++++++++++++++++++-----------
 1 files changed, 19 insertions(+), 11 deletions(-)

diff --git a/arch/arm/mach-at91/board-sam9261ek.c b/arch/arm/mach-at91/board-sam9261ek.c
index b4307ab..19d4d2c 100644
--- a/arch/arm/mach-at91/board-sam9261ek.c
+++ b/arch/arm/mach-at91/board-sam9261ek.c
@@ -169,17 +169,6 @@ static struct at91_udc_data __initdata ek_udc_data = {
 
 
 /*
- * MCI (SD/MMC)
- */
-static struct at91_mmc_data __initdata ek_mmc_data = {
-	.wire4		= 1,
-//	.det_pin	= ... not connected
-//	.wp_pin		= ... not connected
-//	.vcc_pin	= ... not connected
-};
-
-
-/*
  * NAND flash
  */
 static struct mtd_partition __initdata ek_nand_partition[] = {
@@ -247,6 +236,10 @@ static void __init ek_add_device_nand(void)
 	at91_add_device_nand(&ek_nand_data);
 }
 
+/*
+ * SPI related devices
+ */
+#if defined(CONFIG_SPI_ATMEL) || defined(CONFIG_SPI_ATMEL_MODULE)
 
 /*
  * ADS7846 Touchscreen
@@ -357,6 +350,21 @@ static struct spi_board_info ek_spi_devices[] = {
 #endif
 };
 
+#else /* CONFIG_SPI_ATMEL_* */
+
+/*
+ * MCI (SD/MMC)
+ * spi0 and mmc/sd share the same PIO pins: cannot be used at the same time
+ */
+static struct at91_mmc_data __initdata ek_mmc_data = {
+	.wire4		= 1,
+//	.det_pin	= ... not connected
+//	.wp_pin		= ... not connected
+//	.vcc_pin	= ... not connected
+};
+
+#endif /* CONFIG_SPI_ATMEL_* */
+
 
 /*
  * LCD Controller
-- 
1.5.6.5

