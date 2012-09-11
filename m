Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932452Ab2IKA3i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 20:29:38 -0400
Received: from mail.savoirfairelinux.com ([209.172.62.77]:36250 "EHLO
	mail.savoirfairelinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932106Ab2IKA3g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 20:29:36 -0400
From: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Vivien Didelot <vivien.didelot@savoirfairelinux.com>,
        Russell King <linux@arm.linux.org.uk>, Sekhar Nori <nsekhar@ti.com>,
        Kevin Hilman <khilman@ti.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] ARM: davinci: da8xx_register_spi() should not register SPI board info
Date: Mon, 10 Sep 2012 20:29:13 -0400
Message-Id: <1347323353-19764-1-git-send-email-vivien.didelot@savoirfairelinux.com>
X-Mailer: git-send-email 1.7.11.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Without this patch, da8xx_register_spi() registers the SPI board info,
the SPI controller, and sets its number of chipselect to the size of the
static spi_board_info array. This is bad because a SPI board info may
declare devices for different SPI buses, and because other code can also
call spi_register_board_info() (e.g. a daughter board might provide
additional SPI devices).

This patch removes the spi_register_board_info() call from
da8xx_register_spi(), renames this last one to da8xx_register_spi_bus()
to be more explicit, takes the number of chipselect as a function
parameter, and updates the impacted board-da8{3,5}0-evm.c, and
board-mityomapl138.c files accordingly. It also sets the SPI platform
data static, as it doesn't need to be exported.

Signed-off-by: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
---
 arch/arm/mach-davinci/board-da830-evm.c    |  9 +++++++--
 arch/arm/mach-davinci/board-da850-evm.c    |  9 +++++++--
 arch/arm/mach-davinci/board-mityomapl138.c |  9 +++++++--
 arch/arm/mach-davinci/devices-da8xx.c      | 14 +++-----------
 arch/arm/mach-davinci/include/mach/da8xx.h |  3 +--
 5 files changed, 25 insertions(+), 19 deletions(-)

diff --git a/arch/arm/mach-davinci/board-da830-evm.c b/arch/arm/mach-davinci/board-da830-evm.c
index 11c3db9..adb8d87 100644
--- a/arch/arm/mach-davinci/board-da830-evm.c
+++ b/arch/arm/mach-davinci/board-da830-evm.c
@@ -652,8 +652,13 @@ static __init void da830_evm_init(void)
 	if (ret)
 		pr_warning("da830_evm_init: rtc setup failed: %d\n", ret);
 
-	ret = da8xx_register_spi(0, da830evm_spi_info,
-				 ARRAY_SIZE(da830evm_spi_info));
+	ret = spi_register_board_info(da830evm_spi_info,
+				      ARRAY_SIZE(da830evm_spi_info));
+	if (ret)
+		pr_warning("da830_evm_init: spi info registration failed: %d\n",
+			   ret);
+
+	ret = da8xx_register_spi_bus(0, ARRAY_SIZE(da830evm_spi_info));
 	if (ret)
 		pr_warning("da830_evm_init: spi 0 registration failed: %d\n",
 			   ret);
diff --git a/arch/arm/mach-davinci/board-da850-evm.c b/arch/arm/mach-davinci/board-da850-evm.c
index 6659a90..3b2c9e3 100644
--- a/arch/arm/mach-davinci/board-da850-evm.c
+++ b/arch/arm/mach-davinci/board-da850-evm.c
@@ -1374,8 +1374,13 @@ static __init void da850_evm_init(void)
 		pr_warning("da850_evm_init: suspend registration failed: %d\n",
 				ret);
 
-	ret = da8xx_register_spi(1, da850evm_spi_info,
-				 ARRAY_SIZE(da850evm_spi_info));
+	ret = spi_register_board_info(da850evm_spi_info,
+				      ARRAY_SIZE(da850evm_spi_info));
+	if (ret)
+		pr_warning("da850_evm_init: spi info registration failed: %d\n",
+			   ret);
+
+	ret = da8xx_register_spi_bus(1, ARRAY_SIZE(da850evm_spi_info));
 	if (ret)
 		pr_warning("da850_evm_init: spi 1 registration failed: %d\n",
 				ret);
diff --git a/arch/arm/mach-davinci/board-mityomapl138.c b/arch/arm/mach-davinci/board-mityomapl138.c
index 3cfff55..9f92f11 100644
--- a/arch/arm/mach-davinci/board-mityomapl138.c
+++ b/arch/arm/mach-davinci/board-mityomapl138.c
@@ -529,8 +529,13 @@ static void __init mityomapl138_init(void)
 
 	mityomapl138_setup_nand();
 
-	ret = da8xx_register_spi(1, mityomapl138_spi_flash_info,
-			       ARRAY_SIZE(mityomapl138_spi_flash_info));
+	ret = spi_register_board_info(mityomapl138_spi_flash_info,
+				      ARRAY_SIZE(mityomapl138_spi_flash_info));
+	if (ret)
+		pr_warning("spi info registration failed: %d\n", ret);
+
+	ret = da8xx_register_spi_bus(1,
+				     ARRAY_SIZE(mityomapl138_spi_flash_info));
 	if (ret)
 		pr_warning("spi 1 registration failed: %d\n", ret);
 
diff --git a/arch/arm/mach-davinci/devices-da8xx.c b/arch/arm/mach-davinci/devices-da8xx.c
index d91ab9e..e86117b 100644
--- a/arch/arm/mach-davinci/devices-da8xx.c
+++ b/arch/arm/mach-davinci/devices-da8xx.c
@@ -792,7 +792,7 @@ static struct resource da8xx_spi1_resources[] = {
 	},
 };
 
-struct davinci_spi_platform_data da8xx_spi_pdata[] = {
+static struct davinci_spi_platform_data da8xx_spi_pdata[] = {
 	[0] = {
 		.version	= SPI_VERSION_2,
 		.intr_line	= 1,
@@ -826,20 +826,12 @@ static struct platform_device da8xx_spi_device[] = {
 	},
 };
 
-int __init da8xx_register_spi(int instance, struct spi_board_info *info,
-			      unsigned len)
+int __init da8xx_register_spi_bus(int instance, unsigned num_chipselect)
 {
-	int ret;
-
 	if (instance < 0 || instance > 1)
 		return -EINVAL;
 
-	ret = spi_register_board_info(info, len);
-	if (ret)
-		pr_warning("%s: failed to register board info for spi %d :"
-			   " %d\n", __func__, instance, ret);
-
-	da8xx_spi_pdata[instance].num_chipselect = len;
+	da8xx_spi_pdata[instance].num_chipselect = num_chipselect;
 
 	if (instance == 1 && cpu_is_davinci_da850()) {
 		da8xx_spi1_resources[0].start = DA850_SPI1_BASE;
diff --git a/arch/arm/mach-davinci/include/mach/da8xx.h b/arch/arm/mach-davinci/include/mach/da8xx.h
index 53ee8a2..aa2d665 100644
--- a/arch/arm/mach-davinci/include/mach/da8xx.h
+++ b/arch/arm/mach-davinci/include/mach/da8xx.h
@@ -76,7 +76,7 @@ void __init da850_init(void);
 int da830_register_edma(struct edma_rsv_info *rsv);
 int da850_register_edma(struct edma_rsv_info *rsv[2]);
 int da8xx_register_i2c(int instance, struct davinci_i2c_platform_data *pdata);
-int da8xx_register_spi(int instance, struct spi_board_info *info, unsigned len);
+int da8xx_register_spi_bus(int instance, unsigned num_chipselect);
 int da8xx_register_watchdog(void);
 int da8xx_register_usb20(unsigned mA, unsigned potpgt);
 int da8xx_register_usb11(struct da8xx_ohci_root_hub *pdata);
@@ -96,7 +96,6 @@ extern struct platform_device da8xx_serial_device;
 extern struct emac_platform_data da8xx_emac_pdata;
 extern struct da8xx_lcdc_platform_data sharp_lcd035q3dg01_pdata;
 extern struct da8xx_lcdc_platform_data sharp_lk043t1dg01_pdata;
-extern struct davinci_spi_platform_data da8xx_spi_pdata[];
 
 extern struct platform_device da8xx_emac_device;
 extern struct platform_device da8xx_wdt_device;
-- 
1.7.11.4

