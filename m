Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755927Ab2CXKjw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2012 06:39:52 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:56609 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755201Ab2CXKjv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2012 06:39:51 -0400
Date: Sat, 24 Mar 2012 14:38:43 +0400
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Mike Frysinger <vapier@gentoo.org>
Cc: Bob Liu <lliubbo@gmail.com>, Sonic Zhang <sonic.zhang@analog.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org
Subject: [PATCH] blackfin: dnp5370: Fix some SPI-related build errors
Message-ID: <20120324103843.GA30295@lizard>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some SPI #ifdef magic was wrong, and so the build stopped like this
(using DNP5370_defconfig):

arch/blackfin/mach-bf537/boards/dnp5370.c: In function 'dnp5370_init':
arch/blackfin/mach-bf537/boards/dnp5370.c:392: error: 'bfin_spi_board_info' undeclared (first use in this function)
arch/blackfin/mach-bf537/boards/dnp5370.c:392: error: (Each undeclared identifier is reported only once
arch/blackfin/mach-bf537/boards/dnp5370.c:392: error: for each function it appears in.)
arch/blackfin/mach-bf537/boards/dnp5370.c:392: warning: type defaults to 'int' in declaration of 'type name'
arch/blackfin/mach-bf537/boards/dnp5370.c:392: warning: type defaults to 'int' in declaration of 'type name'
arch/blackfin/mach-bf537/boards/dnp5370.c:392: error: negative width in bit-field '<anonymous>'
arch/blackfin/mach-bf537/boards/dnp5370.c:393: warning: type defaults to 'int' in declaration of 'type name'
arch/blackfin/mach-bf537/boards/dnp5370.c:393: warning: type defaults to 'int' in declaration of 'type name'
arch/blackfin/mach-bf537/boards/dnp5370.c:393: error: negative width in bit-field '<anonymous>'

This patch fixes the issues by properly placing bfin_spi_board_info.

Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
---
 arch/blackfin/mach-bf537/boards/dnp5370.c |   56 +++++++++++++++--------------
 1 file changed, 29 insertions(+), 27 deletions(-)

diff --git a/arch/blackfin/mach-bf537/boards/dnp5370.c b/arch/blackfin/mach-bf537/boards/dnp5370.c
index 11dadeb..e7fb430 100644
--- a/arch/blackfin/mach-bf537/boards/dnp5370.c
+++ b/arch/blackfin/mach-bf537/boards/dnp5370.c
@@ -164,33 +164,6 @@ static struct bfin5xx_spi_chip spi_dataflash_chip_info = {
 };
 #endif
 
-static struct spi_board_info bfin_spi_board_info[] __initdata = {
-/* SD/MMC card reader at SPI bus */
-#if defined(CONFIG_MMC_SPI) || defined(CONFIG_MMC_SPI_MODULE)
-	{
-		.modalias	 = "mmc_spi",
-		.max_speed_hz    = 20000000,
-		.bus_num	 = 0,
-		.chip_select     = 1,
-		.controller_data = &mmc_spi_chip_info,
-		.mode	         = SPI_MODE_3,
-	},
-#endif
-
-/* 8 Megabyte Atmel NOR flash chip at SPI bus */
-#if defined(CONFIG_MTD_DATAFLASH) || defined(CONFIG_MTD_DATAFLASH_MODULE)
-	{
-	.modalias        = "mtd_dataflash",
-	.max_speed_hz    = 16700000,
-	.bus_num         = 0,
-	.chip_select     = 2,
-	.platform_data   = &bfin_spi_dataflash_data,
-	.controller_data = &spi_dataflash_chip_info,
-	.mode            = SPI_MODE_3, /* SPI_CPHA and SPI_CPOL */
-	},
-#endif
-};
-
 /* SPI controller data */
 /* SPI (0) */
 static struct resource bfin_spi0_resource[] = {
@@ -228,6 +201,35 @@ static struct platform_device spi_bfin_master_device = {
 };
 #endif
 
+static struct spi_board_info bfin_spi_board_info[] __initdata = {
+#if defined(CONFIG_SPI_BFIN5XX) || defined(CONFIG_SPI_BFIN5XX_MODULE)
+/* SD/MMC card reader at SPI bus */
+#if defined(CONFIG_MMC_SPI) || defined(CONFIG_MMC_SPI_MODULE)
+	{
+		.modalias	 = "mmc_spi",
+		.max_speed_hz    = 20000000,
+		.bus_num	 = 0,
+		.chip_select     = 1,
+		.controller_data = &mmc_spi_chip_info,
+		.mode	         = SPI_MODE_3,
+	},
+#endif
+
+/* 8 Megabyte Atmel NOR flash chip at SPI bus */
+#if defined(CONFIG_MTD_DATAFLASH) || defined(CONFIG_MTD_DATAFLASH_MODULE)
+	{
+	.modalias        = "mtd_dataflash",
+	.max_speed_hz    = 16700000,
+	.bus_num         = 0,
+	.chip_select     = 2,
+	.platform_data   = &bfin_spi_dataflash_data,
+	.controller_data = &spi_dataflash_chip_info,
+	.mode            = SPI_MODE_3, /* SPI_CPHA and SPI_CPOL */
+	},
+#endif
+#endif /* defined(CONFIG_SPI_BFIN5XX) || defined(CONFIG_SPI_BFIN5XX_MODULE) */
+};
+
 #if defined(CONFIG_SERIAL_BFIN) || defined(CONFIG_SERIAL_BFIN_MODULE)
 #ifdef CONFIG_SERIAL_BFIN_UART0
 static struct resource bfin_uart0_resources[] = {
-- 
1.7.9.2
