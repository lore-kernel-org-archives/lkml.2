Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760310Ab0JZUTg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 16:19:36 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:53574 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760262Ab0JZUT2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 16:19:28 -0400
From: Cyril Chemparathy <cyril@ti.com>
To: davinci-linux-open-source@linux.davincidsp.com,
        spi-devel-general@lists.sourceforge.net,
        broonie@opensource.wolfsonmicro.com, lrg@slimlogic.co.uk,
        dbrownell@users.sourceforge.net, grant.likely@secretlab.ca,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        rpurdie@rpsys.net
Cc: Cyril Chemparathy <cyril@ti.com>
Subject: [PATCH v4 02/12] davinci: add tnetv107x ssp platform device
Date: Tue, 26 Oct 2010 16:18:18 -0400
Message-Id: <1288124308-14999-3-git-send-email-cyril@ti.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1288124308-14999-1-git-send-email-cyril@ti.com>
References: <1288124308-14999-1-git-send-email-cyril@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds an SSP platform device definition for the tnetv107x soc family.
The clock lookup entry has also been updated to match.

Signed-off-by: Cyril Chemparathy <cyril@ti.com>
---
 arch/arm/mach-davinci/devices-tnetv107x.c      |   25 ++++++++++++++++++++++++
 arch/arm/mach-davinci/include/mach/tnetv107x.h |    2 +
 arch/arm/mach-davinci/tnetv107x.c              |    2 +-
 3 files changed, 28 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-davinci/devices-tnetv107x.c b/arch/arm/mach-davinci/devices-tnetv107x.c
index 85503de..6162cae 100644
--- a/arch/arm/mach-davinci/devices-tnetv107x.c
+++ b/arch/arm/mach-davinci/devices-tnetv107x.c
@@ -35,6 +35,7 @@
 #define TNETV107X_SDIO0_BASE			0x08088700
 #define TNETV107X_SDIO1_BASE			0x08088800
 #define TNETV107X_KEYPAD_BASE			0x08088a00
+#define TNETV107X_SSP_BASE			0x08088c00
 #define TNETV107X_ASYNC_EMIF_CNTRL_BASE		0x08200000
 #define TNETV107X_ASYNC_EMIF_DATA_CE0_BASE	0x30000000
 #define TNETV107X_ASYNC_EMIF_DATA_CE1_BASE	0x40000000
@@ -342,6 +343,25 @@ static struct platform_device tsc_device = {
 	.resource	= tsc_resources,
 };
 
+static struct resource ssp_resources[] = {
+	{
+		.start	= TNETV107X_SSP_BASE,
+		.end	= TNETV107X_SSP_BASE + 0x1ff,
+		.flags	= IORESOURCE_MEM,
+	},
+	{
+		.start	= IRQ_TNETV107X_SSP,
+		.flags	= IORESOURCE_IRQ,
+	},
+};
+
+static struct platform_device ssp_device = {
+	.name		= "ti-ssp",
+	.id		= -1,
+	.num_resources	= ARRAY_SIZE(ssp_resources),
+	.resource	= ssp_resources,
+};
+
 void __init tnetv107x_devices_init(struct tnetv107x_device_info *info)
 {
 	int i, error;
@@ -380,4 +400,9 @@ void __init tnetv107x_devices_init(struct tnetv107x_device_info *info)
 		keypad_device.dev.platform_data = info->keypad_config;
 		platform_device_register(&keypad_device);
 	}
+
+	if (info->ssp_config) {
+		ssp_device.dev.platform_data = info->ssp_config;
+		platform_device_register(&ssp_device);
+	}
 }
diff --git a/arch/arm/mach-davinci/include/mach/tnetv107x.h b/arch/arm/mach-davinci/include/mach/tnetv107x.h
index 5a681d8..c1df563 100644
--- a/arch/arm/mach-davinci/include/mach/tnetv107x.h
+++ b/arch/arm/mach-davinci/include/mach/tnetv107x.h
@@ -38,12 +38,14 @@
 #include <mach/mmc.h>
 #include <mach/nand.h>
 #include <mach/serial.h>
+#include <mach/ti_ssp.h>
 
 struct tnetv107x_device_info {
 	struct davinci_uart_config	*serial_config;
 	struct davinci_mmc_config	*mmc_config[2];  /* 2 controllers */
 	struct davinci_nand_pdata	*nand_config[4]; /* 4 chipsels */
 	struct matrix_keypad_platform_data *keypad_config;
+	struct ti_ssp_data		*ssp_config;
 };
 
 extern struct platform_device tnetv107x_wdt_device;
diff --git a/arch/arm/mach-davinci/tnetv107x.c b/arch/arm/mach-davinci/tnetv107x.c
index 6fcdece..1b28fdd 100644
--- a/arch/arm/mach-davinci/tnetv107x.c
+++ b/arch/arm/mach-davinci/tnetv107x.c
@@ -278,7 +278,7 @@ static struct clk_lookup clks[] = {
 	CLK(NULL,		"timer1",		&clk_timer1),
 	CLK("tnetv107x_wdt.0",	NULL,			&clk_wdt_arm),
 	CLK(NULL,		"clk_wdt_dsp",		&clk_wdt_dsp),
-	CLK("ti-ssp.0",		NULL,			&clk_ssp),
+	CLK("ti-ssp",		NULL,			&clk_ssp),
 	CLK(NULL,		"clk_tdm0",		&clk_tdm0),
 	CLK(NULL,		"clk_vlynq",		&clk_vlynq),
 	CLK(NULL,		"clk_mcdma",		&clk_mcdma),
-- 
1.7.0.4

