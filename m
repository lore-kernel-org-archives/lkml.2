Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755992Ab1FUHX0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 03:23:26 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:59375 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755855Ab1FUHWU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 03:22:20 -0400
From: Ohad Ben-Cohen <ohad@wizery.com>
To: <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Cc: <akpm@linux-foundation.org>, Brian Swetland <swetland@google.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        davinci-linux-open-source 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Rusty Russell <rusty@rustcorp.com.au>, Mark Grosen <mgrosen@ti.com>,
        Ohad Ben-Cohen <ohad@wizery.com>
Subject: [RFC 6/8] davinci: da850: add remoteproc dsp device
Date: Tue, 21 Jun 2011 10:18:32 +0300
Message-Id: <1308640714-17961-7-git-send-email-ohad@wizery.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1308640714-17961-1-git-send-email-ohad@wizery.com>
References: <1308640714-17961-1-git-send-email-ohad@wizery.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Grosen <mgrosen@ti.com>

Add davinci remoteproc device for the da850's C674x dsp remote
processor, and support it on the da850-evm and omapl138-hawk boards.

Signed-off-by: Mark Grosen <mgrosen@ti.com>
Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
---
It'd be nice to split this patch to the different components it changes,
but it's probably not so important at this early stage.

 arch/arm/mach-davinci/board-da850-evm.c     |    4 ++++
 arch/arm/mach-davinci/board-omapl138-hawk.c |    4 ++++
 arch/arm/mach-davinci/da850.c               |   14 ++++++++++++++
 arch/arm/mach-davinci/devices-da8xx.c       |   15 +++++++++++++++
 arch/arm/mach-davinci/include/mach/da8xx.h  |    1 +
 5 files changed, 38 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-davinci/board-da850-evm.c b/arch/arm/mach-davinci/board-da850-evm.c
index a7b41bf..6b35f0a 100644
--- a/arch/arm/mach-davinci/board-da850-evm.c
+++ b/arch/arm/mach-davinci/board-da850-evm.c
@@ -1176,6 +1176,10 @@ static __init void da850_evm_init(void)
 	i2c_register_board_info(1, da850_evm_i2c_devices,
 			ARRAY_SIZE(da850_evm_i2c_devices));
 
+	ret = da850_register_rproc();
+	if (ret)
+		pr_warning("dsp/rproc registration failed: %d\n", ret);
+
 	/*
 	 * shut down uart 0 and 1; they are not used on the board and
 	 * accessing them causes endless "too much work in irq53" messages
diff --git a/arch/arm/mach-davinci/board-omapl138-hawk.c b/arch/arm/mach-davinci/board-omapl138-hawk.c
index 67c38d0..52c8434 100644
--- a/arch/arm/mach-davinci/board-omapl138-hawk.c
+++ b/arch/arm/mach-davinci/board-omapl138-hawk.c
@@ -319,6 +319,10 @@ static __init void omapl138_hawk_init(void)
 		pr_warning("omapl138_hawk_init: "
 			"watchdog registration failed: %d\n",
 			ret);
+
+	ret = da850_register_rproc();
+	if (ret)
+		pr_warning("dsp/rproc registration failed: %d\n", ret);
 }
 
 #ifdef CONFIG_SERIAL_8250_CONSOLE
diff --git a/arch/arm/mach-davinci/da850.c b/arch/arm/mach-davinci/da850.c
index 133aac4..9280b1e 100644
--- a/arch/arm/mach-davinci/da850.c
+++ b/arch/arm/mach-davinci/da850.c
@@ -74,6 +74,13 @@ static struct clk pll0_aux_clk = {
 	.flags		= CLK_PLL | PRE_PLL,
 };
 
+static struct clk pll0_sysclk1 = {
+	.name		= "pll0_sysclk1",
+	.parent		= &pll0_clk,
+	.flags		= CLK_PLL,
+	.div_reg	= PLLDIV1,
+};
+
 static struct clk pll0_sysclk2 = {
 	.name		= "pll0_sysclk2",
 	.parent		= &pll0_clk,
@@ -373,6 +380,12 @@ static struct clk spi1_clk = {
 	.flags		= DA850_CLK_ASYNC3,
 };
 
+static struct clk dsp_clk = {
+	.name		= "dsp",
+	.parent		= &pll0_sysclk1,
+	.lpsc		= DA8XX_LPSC0_GEM,
+};
+
 static struct clk_lookup da850_clks[] = {
 	CLK(NULL,		"ref",		&ref_clk),
 	CLK(NULL,		"pll0",		&pll0_clk),
@@ -419,6 +432,7 @@ static struct clk_lookup da850_clks[] = {
 	CLK(NULL,		"usb20",	&usb20_clk),
 	CLK("spi_davinci.0",	NULL,		&spi0_clk),
 	CLK("spi_davinci.1",	NULL,		&spi1_clk),
+	CLK(NULL,		"dsp",		&dsp_clk),
 	CLK(NULL,		NULL,		NULL),
 };
 
diff --git a/arch/arm/mach-davinci/devices-da8xx.c b/arch/arm/mach-davinci/devices-da8xx.c
index fc4e98e..3becfd1 100644
--- a/arch/arm/mach-davinci/devices-da8xx.c
+++ b/arch/arm/mach-davinci/devices-da8xx.c
@@ -20,6 +20,7 @@
 #include <mach/time.h>
 #include <mach/da8xx.h>
 #include <mach/cpuidle.h>
+#include <mach/remoteproc.h>
 
 #include "clock.h"
 
@@ -647,6 +648,20 @@ int __init da850_register_mmcsd1(struct davinci_mmc_config *config)
 	da850_mmcsd1_device.dev.platform_data = config;
 	return platform_device_register(&da850_mmcsd1_device);
 }
+
+int __init da850_register_rproc(void)
+{
+	struct platform_device *rproc;
+	struct davinci_rproc_pdata rproc_pdata = {
+		.name		= "dsp",
+		.firmware	= "davinci-dsp.bin",
+		.clk_name	= "dsp",
+	};
+
+	rproc = platform_device_register_data(NULL, "davinci-rproc", 0,
+					    &rproc_pdata, sizeof(rproc_pdata));
+	return PTR_RET(rproc);
+};
 #endif
 
 static struct resource da8xx_rtc_resources[] = {
diff --git a/arch/arm/mach-davinci/include/mach/da8xx.h b/arch/arm/mach-davinci/include/mach/da8xx.h
index ad64da7..a6f024f 100644
--- a/arch/arm/mach-davinci/include/mach/da8xx.h
+++ b/arch/arm/mach-davinci/include/mach/da8xx.h
@@ -74,6 +74,7 @@ void __init da850_init(void);
 
 int da830_register_edma(struct edma_rsv_info *rsv);
 int da850_register_edma(struct edma_rsv_info *rsv[2]);
+int da850_register_rproc(void);
 int da8xx_register_i2c(int instance, struct davinci_i2c_platform_data *pdata);
 int da8xx_register_spi(int instance, struct spi_board_info *info, unsigned len);
 int da8xx_register_watchdog(void);
-- 
1.7.1

