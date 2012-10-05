Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757090Ab2JERE3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 13:04:29 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:61589 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757019Ab2JEREY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 13:04:24 -0400
From: Matt Porter <mporter@ti.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Hans J. Koch" <hjk@hansjkoch.de>, Sekhar Nori <nsekhar@ti.com>
Cc: Russell King <linux@arm.linux.org.uk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Ben Gardiner <bengardiner@nanometrics.ca>
Subject: [PATCH v4 5/7] ARM: davinci: add DA850 PRUSS support
Date: Fri,  5 Oct 2012 13:04:44 -0400
Message-Id: <1349456686-22736-6-git-send-email-mporter@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1349456686-22736-1-git-send-email-mporter@ti.com>
References: <1349456686-22736-1-git-send-email-mporter@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds PRUSS clock support and registration helper for the
pruss_uio device.

Signed-off-by: Matt Porter <mporter@ti.com>
---
 arch/arm/mach-davinci/da850.c              |    7 +++
 arch/arm/mach-davinci/devices-da8xx.c      |   65 ++++++++++++++++++++++++++++
 arch/arm/mach-davinci/include/mach/da8xx.h |    2 +
 3 files changed, 74 insertions(+)

diff --git a/arch/arm/mach-davinci/da850.c b/arch/arm/mach-davinci/da850.c
index d8d69de..ebd7d6a 100644
--- a/arch/arm/mach-davinci/da850.c
+++ b/arch/arm/mach-davinci/da850.c
@@ -212,6 +212,12 @@ static struct clk tptc2_clk = {
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
@@ -378,6 +384,7 @@ static struct clk_lookup da850_clks[] = {
 	CLK(NULL,		"tptc1",	&tptc1_clk),
 	CLK(NULL,		"tpcc1",	&tpcc1_clk),
 	CLK(NULL,		"tptc2",	&tptc2_clk),
+	CLK("pruss_uio",	"pruss",	&pruss_clk),
 	CLK(NULL,		"uart0",	&uart0_clk),
 	CLK(NULL,		"uart1",	&uart1_clk),
 	CLK(NULL,		"uart2",	&uart2_clk),
diff --git a/arch/arm/mach-davinci/devices-da8xx.c b/arch/arm/mach-davinci/devices-da8xx.c
index bd2f72b..995ad08 100644
--- a/arch/arm/mach-davinci/devices-da8xx.c
+++ b/arch/arm/mach-davinci/devices-da8xx.c
@@ -32,6 +32,7 @@
 #define DA8XX_WDOG_BASE			0x01c21000 /* DA8XX_TIMER64P1_BASE */
 #define DA8XX_I2C0_BASE			0x01c22000
 #define DA8XX_RTC_BASE			0x01c23000
+#define DA8XX_PRUSS_MEM_BASE		0x01c30000
 #define DA8XX_MMCSD0_BASE		0x01c40000
 #define DA8XX_SPI0_BASE			0x01c41000
 #define DA830_SPI1_BASE			0x01e12000
@@ -518,6 +519,70 @@ void __init da8xx_register_mcasp(int id, struct snd_platform_data *pdata)
 	}
 }
 
+static struct resource da8xx_pruss_resources[] = {
+	{
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
+static struct platform_device da8xx_pruss_uio_dev = {
+	.name		= "pruss_uio",
+	.id		= -1,
+	.num_resources	= ARRAY_SIZE(da8xx_pruss_resources),
+	.resource	= da8xx_pruss_resources,
+	.dev	 =	{
+		.coherent_dma_mask = DMA_BIT_MASK(32),
+	}
+};
+
+int __init da8xx_register_pruss_uio(struct uio_pruss_pdata *config)
+{
+	da8xx_pruss_uio_dev.dev.platform_data = config;
+	return platform_device_register(&da8xx_pruss_uio_dev);
+}
+
 static const struct display_panel disp_panel = {
 	QVGA,
 	16,
diff --git a/arch/arm/mach-davinci/include/mach/da8xx.h b/arch/arm/mach-davinci/include/mach/da8xx.h
index 20553cf..138e618 100644
--- a/arch/arm/mach-davinci/include/mach/da8xx.h
+++ b/arch/arm/mach-davinci/include/mach/da8xx.h
@@ -25,6 +25,7 @@
 #include <linux/platform_data/mmc-davinci.h>
 #include <linux/platform_data/usb-davinci.h>
 #include <linux/platform_data/spi-davinci.h>
+#include <linux/platform_data/uio_pruss.h>
 
 extern void __iomem *da8xx_syscfg0_base;
 extern void __iomem *da8xx_syscfg1_base;
@@ -83,6 +84,7 @@ int da8xx_register_watchdog(void);
 int da8xx_register_usb20(unsigned mA, unsigned potpgt);
 int da8xx_register_usb11(struct da8xx_ohci_root_hub *pdata);
 int da8xx_register_emac(void);
+int da8xx_register_pruss_uio(struct uio_pruss_pdata *config);
 int da8xx_register_lcdc(struct da8xx_lcdc_platform_data *pdata);
 int da8xx_register_mmcsd0(struct davinci_mmc_config *config);
 int da850_register_mmcsd1(struct davinci_mmc_config *config);
-- 
1.7.9.5

