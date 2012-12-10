Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753470Ab2LJI4k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 03:56:40 -0500
Received: from mail-wg0-f46.google.com ([74.125.82.46]:34359 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753314Ab2LJI4h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 03:56:37 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com, ulf.hansson@linaro.org,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 12/12] ARM: ux500: Remove traces of the ios_handler from platform code
Date: Mon, 10 Dec 2012 08:56:01 +0000
Message-Id: <1355129761-8088-13-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355129761-8088-1-git-send-email-lee.jones@linaro.org>
References: <1355129761-8088-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now MMCI on/off functionality is using the regulator framework
from the MMCI driver, there is no need to keep the ios_handler
laying around, duplicating functionality. So we're removing it.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/mach-ux500/board-mop500-sdi.c |   52 --------------------------------
 1 file changed, 52 deletions(-)

diff --git a/arch/arm/mach-ux500/board-mop500-sdi.c b/arch/arm/mach-ux500/board-mop500-sdi.c
index 9c8e4a9..5a798d6 100644
--- a/arch/arm/mach-ux500/board-mop500-sdi.c
+++ b/arch/arm/mach-ux500/board-mop500-sdi.c
@@ -31,35 +31,6 @@
  * SDI 0 (MicroSD slot)
  */
 
-/* GPIO pins used by the sdi0 level shifter */
-static int sdi0_en = -1;
-static int sdi0_vsel = -1;
-
-static int mop500_sdi0_ios_handler(struct device *dev, struct mmc_ios *ios)
-{
-	switch (ios->power_mode) {
-	case MMC_POWER_UP:
-	case MMC_POWER_ON:
-		/*
-		 * Level shifter voltage should depend on vdd to when deciding
-		 * on either 1.8V or 2.9V. Once the decision has been made the
-		 * level shifter must be disabled and re-enabled with a changed
-		 * select signal in order to switch the voltage. Since there is
-		 * no framework support yet for indicating 1.8V in vdd, use the
-		 * default 2.9V.
-		 */
-		gpio_direction_output(sdi0_vsel, 0);
-		gpio_direction_output(sdi0_en, 1);
-		break;
-	case MMC_POWER_OFF:
-		gpio_direction_output(sdi0_vsel, 0);
-		gpio_direction_output(sdi0_en, 0);
-		break;
-	}
-
-	return 0;
-}
-
 #ifdef CONFIG_STE_DMA40
 struct stedma40_chan_cfg mop500_sdi0_dma_cfg_rx = {
 	.mode = STEDMA40_MODE_LOGICAL,
@@ -81,7 +52,6 @@ static struct stedma40_chan_cfg mop500_sdi0_dma_cfg_tx = {
 #endif
 
 struct mmci_platform_data mop500_sdi0_data = {
-	.ios_handler	= mop500_sdi0_ios_handler,
 	.ocr_mask	= MMC_VDD_29_30,
 	.f_max		= 50000000,
 	.capabilities	= MMC_CAP_4_BIT_DATA |
@@ -101,22 +71,6 @@ struct mmci_platform_data mop500_sdi0_data = {
 
 static void sdi0_configure(struct device *parent)
 {
-	int ret;
-
-	ret = gpio_request(sdi0_en, "level shifter enable");
-	if (!ret)
-		ret = gpio_request(sdi0_vsel,
-				   "level shifter 1v8-3v select");
-
-	if (ret) {
-		pr_warning("unable to config sdi0 gpios for level shifter.\n");
-		return;
-	}
-
-	/* Select the default 2.9V and enable level shifter */
-	gpio_direction_output(sdi0_vsel, 0);
-	gpio_direction_output(sdi0_en, 1);
-
 	/* Add the device, force v2 to subrevision 1 */
 	db8500_add_sdi0(parent, &mop500_sdi0_data, U8500_SDI_V2_PERIPHID);
 }
@@ -124,8 +78,6 @@ static void sdi0_configure(struct device *parent)
 void mop500_sdi_tc35892_init(struct device *parent)
 {
 	mop500_sdi0_data.gpio_cd = GPIO_SDMMC_CD;
-	sdi0_en = GPIO_SDMMC_EN;
-	sdi0_vsel = GPIO_SDMMC_1V8_3V_SEL;
 	sdi0_configure(parent);
 }
 
@@ -264,8 +216,6 @@ void __init snowball_sdi_init(struct device *parent)
 	/* External Micro SD slot */
 	mop500_sdi0_data.gpio_cd = SNOWBALL_SDMMC_CD_GPIO;
 	mop500_sdi0_data.cd_invert = true;
-	sdi0_en = SNOWBALL_SDMMC_EN_GPIO;
-	sdi0_vsel = SNOWBALL_SDMMC_1V8_3V_GPIO;
 	sdi0_configure(parent);
 }
 
@@ -277,8 +227,6 @@ void __init hrefv60_sdi_init(struct device *parent)
 	db8500_add_sdi4(parent, &mop500_sdi4_data, U8500_SDI_V2_PERIPHID);
 	/* External Micro SD slot */
 	mop500_sdi0_data.gpio_cd = HREFV60_SDMMC_CD_GPIO;
-	sdi0_en = HREFV60_SDMMC_EN_GPIO;
-	sdi0_vsel = HREFV60_SDMMC_1V8_3V_GPIO;
 	sdi0_configure(parent);
 	/* WLAN SDIO channel */
 	db8500_add_sdi1(parent, &mop500_sdi1_data, U8500_SDI_V2_PERIPHID);
-- 
1.7.9.5

