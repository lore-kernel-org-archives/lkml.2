Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756761Ab1BKOhm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 09:37:42 -0500
Received: from mail-pv0-f174.google.com ([74.125.83.174]:64273 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756679Ab1BKOhk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 09:37:40 -0500
From: Subhasish Ghosh <subhasish@mistralsolutions.com>
To: davinci-linux-open-source@linux.davincidsp.com
Cc: linux-arm-kernel@lists.infradead.org, m-watkins@ti.com, nsekhar@ti.com,
        sachi@mistralsolutions.com,
        Subhasish Ghosh <subhasish@mistralsolutions.com>,
        Kevin Hilman <khilman@deeprootsystems.com> (supporter:TI DAVINCI
	MACHIN...,commit_signer:16/18=89%),
        Russell King <linux@arm.linux.org.uk> (maintainer:ARM PORT),
        Michael Williamson <michael.williamson@criticallink.com> (commit_signer:5/18=28%),
        Cyril Chemparathy <cyril@ti.com> (commit_signer:3/18=17%),
        Sergei Shtylyov <sshtylyov@ru.mvista.com> (commit_signer:3/18=17%),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v2 02/13] da850: pruss platform specific additions.
Date: Fri, 11 Feb 2011 20:21:21 +0530
Message-Id: <1297435892-28278-3-git-send-email-subhasish@mistralsolutions.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1297435892-28278-1-git-send-email-subhasish@mistralsolutions.com>
References: <1297435892-28278-1-git-send-email-subhasish@mistralsolutions.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the platform device and assignes the platform resources
for the PRUSS mfd driver.

Signed-off-by: Subhasish Ghosh <subhasish@mistralsolutions.com>
---
 arch/arm/mach-davinci/da850.c              |    7 +++
 arch/arm/mach-davinci/devices-da8xx.c      |   65 ++++++++++++++++++++++++++++
 arch/arm/mach-davinci/include/mach/da8xx.h |    2 +
 3 files changed, 74 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-davinci/da850.c b/arch/arm/mach-davinci/da850.c
index 8a4de97..a098263 100644
--- a/arch/arm/mach-davinci/da850.c
+++ b/arch/arm/mach-davinci/da850.c
@@ -238,6 +238,12 @@ static struct clk tptc2_clk = {
 	.flags		= ALWAYS_ENABLED,
 };
 
+static struct clk pruss_clk = {
+	.name		= "pruss",
+	.parent		= &pll0_sysclk2,
+	.lpsc		= DA8XX_LPSC0_PRUSS,
+};
+
 static struct clk uart0_clk = {
 	.name		= "uart0",
 	.parent		= &pll0_sysclk2,
@@ -387,6 +393,7 @@ static struct clk_lookup da850_clks[] = {
 	CLK(NULL,		"tpcc1",	&tpcc1_clk),
 	CLK(NULL,		"tptc2",	&tptc2_clk),
 	CLK(NULL,		"uart0",	&uart0_clk),
+	CLK(NULL,		"pruss",	&pruss_clk),
 	CLK(NULL,		"uart1",	&uart1_clk),
 	CLK(NULL,		"uart2",	&uart2_clk),
 	CLK(NULL,		"aintc",	&aintc_clk),
diff --git a/arch/arm/mach-davinci/devices-da8xx.c b/arch/arm/mach-davinci/devices-da8xx.c
index beda8a4..e15de72 100644
--- a/arch/arm/mach-davinci/devices-da8xx.c
+++ b/arch/arm/mach-davinci/devices-da8xx.c
@@ -20,6 +20,7 @@
 #include <mach/time.h>
 #include <mach/da8xx.h>
 #include <mach/cpuidle.h>
+#include <linux/mfd/pruss/da8xx_pru.h>
 
 #include "clock.h"
 
@@ -499,6 +500,70 @@ void __init da8xx_register_mcasp(int id, struct snd_platform_data *pdata)
 	}
 }
 
+#define DA8XX_PRUSS_MEM_BASE		0x01C30000
+
+static struct resource da8xx_pruss_resources[] = {
+	{
+		.name	= "da8xx_pruss",
+		.start	= DA8XX_PRUSS_MEM_BASE,
+		.end	= DA8XX_PRUSS_MEM_BASE + 0xFFFF,
+		.flags	= IORESOURCE_MEM,
+	},
+	{
+		.start	= IRQ_DA8XX_EVTOUT0,
+		.end	= IRQ_DA8XX_EVTOUT0,
+		.flags	= IORESOURCE_IRQ,
+	},
+	{
+		.start	= IRQ_DA8XX_EVTOUT1,
+		.end	= IRQ_DA8XX_EVTOUT1,
+		.flags	= IORESOURCE_IRQ,
+	},
+	{
+		.start	= IRQ_DA8XX_EVTOUT2,
+		.end	= IRQ_DA8XX_EVTOUT2,
+		.flags	= IORESOURCE_IRQ,
+	},
+	{
+		.start	= IRQ_DA8XX_EVTOUT3,
+		.end	= IRQ_DA8XX_EVTOUT3,
+		.flags	= IORESOURCE_IRQ,
+	},
+	{
+		.start	= IRQ_DA8XX_EVTOUT4,
+		.end	= IRQ_DA8XX_EVTOUT4,
+		.flags	= IORESOURCE_IRQ,
+	},
+	{
+		.start	= IRQ_DA8XX_EVTOUT5,
+		.end	= IRQ_DA8XX_EVTOUT5,
+		.flags	= IORESOURCE_IRQ,
+	},
+	{
+		.start	= IRQ_DA8XX_EVTOUT6,
+		.end	= IRQ_DA8XX_EVTOUT6,
+		.flags	= IORESOURCE_IRQ,
+	},
+	{
+		.start	= IRQ_DA8XX_EVTOUT7,
+		.end	= IRQ_DA8XX_EVTOUT7,
+		.flags	= IORESOURCE_IRQ,
+	},
+};
+
+struct platform_device da8xx_pruss_dev = {
+	.name		= "da8xx_pruss",
+	.id		= -1,
+	.num_resources	= ARRAY_SIZE(da8xx_pruss_resources),
+	.resource	= da8xx_pruss_resources,
+};
+
+int __init da8xx_register_pruss(struct da8xx_pruss_devices *pruss_device)
+{
+	da8xx_pruss_dev.dev.platform_data = pruss_device;
+	return platform_device_register(&da8xx_pruss_dev);
+}
+
 static const struct display_panel disp_panel = {
 	QVGA,
 	16,
diff --git a/arch/arm/mach-davinci/include/mach/da8xx.h b/arch/arm/mach-davinci/include/mach/da8xx.h
index c3c3339..2c400d4 100644
--- a/arch/arm/mach-davinci/include/mach/da8xx.h
+++ b/arch/arm/mach-davinci/include/mach/da8xx.h
@@ -15,6 +15,7 @@
 
 #include <linux/platform_device.h>
 #include <linux/davinci_emac.h>
+#include <linux/mfd/pruss/da8xx_pru.h>
 
 #include <mach/serial.h>
 #include <mach/edma.h>
@@ -82,6 +83,7 @@ int da8xx_register_watchdog(void);
 int da8xx_register_usb20(unsigned mA, unsigned potpgt);
 int da8xx_register_usb11(struct da8xx_ohci_root_hub *pdata);
 int da8xx_register_emac(void);
+int da8xx_register_pruss(struct da8xx_pruss_devices *);
 int da8xx_register_lcdc(struct da8xx_lcdc_platform_data *pdata);
 int da8xx_register_mmcsd0(struct davinci_mmc_config *config);
 int da850_register_mmcsd1(struct davinci_mmc_config *config);
-- 
1.7.2.3

