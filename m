Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031481Ab2I1Tix (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 15:38:53 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:38829 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031417Ab2I1Thw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 15:37:52 -0400
From: Matt Porter <mporter@ti.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Hans J. Koch" <hjk@hansjkoch.de>, Benoit Cousson <b-cousson@ti.com>,
        Paul Walmsley <paul@pwsan.com>, Sekhar Nori <nsekhar@ti.com>
Cc: Tony Lindgren <tony@atomide.com>, Russell King <linux@arm.linux.org.uk>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>
Subject: [PATCH v2 5/7] ARM: davinci: Add support for PRUSS on DA850
Date: Fri, 28 Sep 2012 15:37:50 -0400
Message-Id: <1348861072-14507-6-git-send-email-mporter@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1348861072-14507-1-git-send-email-mporter@ti.com>
References: <1348861072-14507-1-git-send-email-mporter@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds PRUSS clock, registers the L3RAM pool, and registers the
platform device for uio_pruss on DA850.

Signed-off-by: Matt Porter <mporter@ti.com>
---
 arch/arm/mach-davinci/board-da850-evm.c    |   12 +++++
 arch/arm/mach-davinci/da850.c              |    9 ++++
 arch/arm/mach-davinci/devices-da8xx.c      |   66 ++++++++++++++++++++++++++++
 arch/arm/mach-davinci/include/mach/da8xx.h |    3 ++
 4 files changed, 90 insertions(+)

diff --git a/arch/arm/mach-davinci/board-da850-evm.c b/arch/arm/mach-davinci/board-da850-evm.c
index 1295e61..d4f1720 100644
--- a/arch/arm/mach-davinci/board-da850-evm.c
+++ b/arch/arm/mach-davinci/board-da850-evm.c
@@ -29,6 +29,7 @@
 #include <linux/regulator/machine.h>
 #include <linux/regulator/tps6507x.h>
 #include <linux/input/tps6507x-ts.h>
+#include <linux/platform_data/uio_pruss.h>
 #include <linux/spi/spi.h>
 #include <linux/spi/flash.h>
 #include <linux/delay.h>
@@ -42,6 +43,7 @@
 #include <mach/da8xx.h>
 #include <linux/platform_data/mtd-davinci.h>
 #include <mach/mux.h>
+#include <mach/sram.h>
 #include <linux/platform_data/mtd-davinci-aemif.h>
 #include <linux/platform_data/spi-davinci.h>
 
@@ -1253,6 +1255,10 @@ static __init int da850_wl12xx_init(void)
 
 #endif /* CONFIG_DA850_WL12XX */
 
+struct uio_pruss_pdata da8xx_pruss_uio_pdata = {
+	.pintc_base	= 0x4000,
+};
+
 #define DA850EVM_SATA_REFCLKPN_RATE	(100 * 1000 * 1000)
 
 static __init void da850_evm_init(void)
@@ -1339,6 +1345,12 @@ static __init void da850_evm_init(void)
 		pr_warning("da850_evm_init: lcdcntl mux setup failed: %d\n",
 				ret);
 
+	da8xx_pruss_uio_pdata.l3ram_pool = sram_get_l3ram_pool();
+	ret = da8xx_register_pruss_uio(&da8xx_pruss_uio_pdata);
+	if (ret)
+		pr_warning("pruss_uio initialization failed: %d\n",
+				ret);
+
 	/* Handle board specific muxing for LCD here */
 	ret = davinci_cfg_reg_list(da850_evm_lcdc_pins);
 	if (ret)
diff --git a/arch/arm/mach-davinci/da850.c b/arch/arm/mach-davinci/da850.c
index 6676dee..131c175 100644
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
+	CLK(NULL,		"pruss",	&pruss_clk),
 	CLK(NULL,		"uart0",	&uart0_clk),
 	CLK(NULL,		"uart1",	&uart1_clk),
 	CLK(NULL,		"uart2",	&uart2_clk),
@@ -1089,6 +1096,8 @@ static struct davinci_soc_info davinci_soc_info_da850 = {
 	.emac_pdata		= &da8xx_emac_pdata,
 	.sram_dma		= DA8XX_ARM_RAM_BASE,
 	.sram_len		= SZ_8K,
+	.l3ram_dma		= DA8XX_SHARED_RAM_BASE,
+	.l3ram_len		= SZ_128K,
 };
 
 void __init da850_init(void)
diff --git a/arch/arm/mach-davinci/devices-da8xx.c b/arch/arm/mach-davinci/devices-da8xx.c
index bd2f72b..7c2e0d2 100644
--- a/arch/arm/mach-davinci/devices-da8xx.c
+++ b/arch/arm/mach-davinci/devices-da8xx.c
@@ -518,6 +518,72 @@ void __init da8xx_register_mcasp(int id, struct snd_platform_data *pdata)
 	}
 }
 
+#define DA8XX_PRUSS_MEM_BASE		0x01C30000
+
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
+		.coherent_dma_mask = 0xffffffff,
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
index c9ee723..5320e12 100644
--- a/arch/arm/mach-davinci/include/mach/da8xx.h
+++ b/arch/arm/mach-davinci/include/mach/da8xx.h
@@ -25,6 +25,7 @@
 #include <linux/platform_data/mmc-davinci.h>
 #include <linux/platform_data/usb-davinci.h>
 #include <linux/platform_data/spi-davinci.h>
+#include <linux/platform_data/uio_pruss.h>
 
 extern void __iomem *da8xx_syscfg0_base;
 extern void __iomem *da8xx_syscfg1_base;
@@ -69,6 +70,7 @@ extern unsigned int da850_max_speed;
 #define DA8XX_AEMIF_CS3_BASE	0x62000000
 #define DA8XX_AEMIF_CTL_BASE	0x68000000
 #define DA8XX_ARM_RAM_BASE	0xffff0000
+#define DA8XX_SHARED_RAM_BASE	0x80000000
 
 void __init da830_init(void);
 void __init da850_init(void);
@@ -82,6 +84,7 @@ int da8xx_register_watchdog(void);
 int da8xx_register_usb20(unsigned mA, unsigned potpgt);
 int da8xx_register_usb11(struct da8xx_ohci_root_hub *pdata);
 int da8xx_register_emac(void);
+int da8xx_register_pruss_uio(struct uio_pruss_pdata *config);
 int da8xx_register_lcdc(struct da8xx_lcdc_platform_data *pdata);
 int da8xx_register_mmcsd0(struct davinci_mmc_config *config);
 int da850_register_mmcsd1(struct davinci_mmc_config *config);
-- 
1.7.9.5

