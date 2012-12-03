Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753895Ab2LCIWd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 03:22:33 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:58410 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752905Ab2LCIWb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 03:22:31 -0500
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
To: LAK <linux-arm-kernel@lists.infradead.org>, Sekhar Nori <nsekhar@ti.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        Manjunath Hadli <manjunath.hadli@ti.com>,
        Prabhakar Lad <prabhakar.lad@ti.com>
Subject: [PATCH v5 1/2] ARM: davinci: dm365: add support for v4l2 video display
Date: Mon,  3 Dec 2012 13:51:43 +0530
Message-Id: <1354522904-22501-2-git-send-email-prabhakar.lad@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1354522904-22501-1-git-send-email-prabhakar.lad@ti.com>
References: <1354522904-22501-1-git-send-email-prabhakar.lad@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Manjunath Hadli <manjunath.hadli@ti.com>

Create platform devices for various video modules like venc,osd,
vpbe and v4l2 driver for dm365.

Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
Signed-off-by: Lad, Prabhakar <prabhakar.lad@ti.com>
---
 arch/arm/mach-davinci/board-dm365-evm.c |    4 +-
 arch/arm/mach-davinci/davinci.h         |    2 +-
 arch/arm/mach-davinci/dm365.c           |  203 +++++++++++++++++++++++++++++--
 3 files changed, 195 insertions(+), 14 deletions(-)

diff --git a/arch/arm/mach-davinci/board-dm365-evm.c b/arch/arm/mach-davinci/board-dm365-evm.c
index 1b4a8ad..0c3dae6 100644
--- a/arch/arm/mach-davinci/board-dm365-evm.c
+++ b/arch/arm/mach-davinci/board-dm365-evm.c
@@ -564,8 +564,6 @@ static struct davinci_uart_config uart_config __initdata = {
 
 static void __init dm365_evm_map_io(void)
 {
-	/* setup input configuration for VPFE input devices */
-	dm365_set_vpfe_config(&vpfe_cfg);
 	dm365_init();
 }
 
@@ -597,6 +595,8 @@ static __init void dm365_evm_init(void)
 
 	davinci_setup_mmc(0, &dm365evm_mmc_config);
 
+	dm365_init_video(&vpfe_cfg, NULL);
+
 	/* maybe setup mmc1/etc ... _after_ mmc0 */
 	evm_init_cpld();
 
diff --git a/arch/arm/mach-davinci/davinci.h b/arch/arm/mach-davinci/davinci.h
index 12d544b..1c2670f 100644
--- a/arch/arm/mach-davinci/davinci.h
+++ b/arch/arm/mach-davinci/davinci.h
@@ -84,7 +84,7 @@ void __init dm365_init_ks(struct davinci_ks_platform_data *pdata);
 void __init dm365_init_rtc(void);
 void dm365_init_spi0(unsigned chipselect_mask,
 			const struct spi_board_info *info, unsigned len);
-void dm365_set_vpfe_config(struct vpfe_config *cfg);
+int __init dm365_init_video(struct vpfe_config *, struct vpbe_config *);
 
 /* DM644x function declarations */
 void __init dm644x_init(void);
diff --git a/arch/arm/mach-davinci/dm365.c b/arch/arm/mach-davinci/dm365.c
index b680c83..cada153 100644
--- a/arch/arm/mach-davinci/dm365.c
+++ b/arch/arm/mach-davinci/dm365.c
@@ -40,10 +40,16 @@
 
 #define DM365_REF_FREQ		24000000	/* 24 MHz on the DM365 EVM */
 
+#define DM3XX_VDAC_CONFIG		0x01c4002c
+
+#define DM365_RTC_BASE			0x01c69000
+
 /* Base of key scan register bank */
 #define DM365_KEYSCAN_BASE		0x01c69400
 
-#define DM365_RTC_BASE			0x01c69000
+#define DM365_OSD_REG_BASE		0x01c71c00
+
+#define DM365_VENC_REG_BASE		0x01c71e00
 
 #define DAVINCI_DM365_VC_BASE		0x01d0c000
 #define DAVINCI_DMA_VC_TX		2
@@ -56,6 +62,11 @@
 #define DM365_EMAC_CNTRL_RAM_OFFSET	0x1000
 #define DM365_EMAC_CNTRL_RAM_SIZE	0x2000
 
+#define DM365_VPSS_CLK_CTRL_ADDR		0x44
+#define DM365_VPSS_VENCCLKEN_ENABLE		BIT(3)
+#define DM365_VPSS_DACCLKEN_ENABLE		BIT(4)
+#define DM365_VPSS_PLLC2SYSCLK5_ENABLE		(BIT(5) & ~BIT(6))
+
 static struct pll_data pll1_data = {
 	.num		= 1,
 	.phys_base	= DAVINCI_PLL1_BASE,
@@ -1232,6 +1243,186 @@ static struct platform_device dm365_isif_dev = {
 	},
 };
 
+static struct resource dm365_osd_resources[] = {
+	{
+		.start = DM365_OSD_REG_BASE,
+		.end   = DM365_OSD_REG_BASE + 0x100,
+		.flags = IORESOURCE_MEM,
+	},
+};
+
+static u64 dm365_video_dma_mask = DMA_BIT_MASK(32);
+
+static struct platform_device dm365_osd_dev = {
+	.name		= DM365_VPBE_OSD_SUBDEV_NAME,
+	.id		= -1,
+	.num_resources	= ARRAY_SIZE(dm365_osd_resources),
+	.resource	= dm365_osd_resources,
+	.dev		= {
+		.dma_mask		= &dm365_video_dma_mask,
+		.coherent_dma_mask	= DMA_BIT_MASK(32),
+	},
+};
+
+static struct resource dm365_venc_resources[] = {
+	{
+		.start = IRQ_VENCINT,
+		.end   = IRQ_VENCINT,
+		.flags = IORESOURCE_IRQ,
+	},
+	/* venc registers io space */
+	{
+		.start = DM365_VENC_REG_BASE,
+		.end   = DM365_VENC_REG_BASE + 0x180,
+		.flags = IORESOURCE_MEM,
+	},
+	/* vdaccfg registers io space */
+	{
+		.start = DM3XX_VDAC_CONFIG,
+		.end   = DM3XX_VDAC_CONFIG + 4,
+		.flags = IORESOURCE_MEM,
+	},
+};
+
+static struct resource dm365_v4l2_disp_resources[] = {
+	{
+		.start = IRQ_VENCINT,
+		.end   = IRQ_VENCINT,
+		.flags = IORESOURCE_IRQ,
+	},
+	/* venc registers io space */
+	{
+		.start = DM365_VENC_REG_BASE,
+		.end   = DM365_VENC_REG_BASE + 0x180,
+		.flags = IORESOURCE_MEM,
+	},
+};
+
+static int dm365_vpbe_setup_pinmux(enum v4l2_mbus_pixelcode if_type,
+			    int field)
+{
+	switch (if_type) {
+	case V4L2_MBUS_FMT_SGRBG8_1X8:
+		davinci_cfg_reg(DM365_VOUT_FIELD_G81);
+		davinci_cfg_reg(DM365_VOUT_COUTL_EN);
+		davinci_cfg_reg(DM365_VOUT_COUTH_EN);
+		break;
+
+	case V4L2_MBUS_FMT_YUYV10_1X20:
+		if (field)
+			davinci_cfg_reg(DM365_VOUT_FIELD);
+		else
+			davinci_cfg_reg(DM365_VOUT_FIELD_G81);
+		davinci_cfg_reg(DM365_VOUT_COUTL_EN);
+		davinci_cfg_reg(DM365_VOUT_COUTH_EN);
+		break;
+
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int dm365_venc_setup_clock(enum vpbe_enc_timings_type type,
+				  unsigned int pclock)
+{
+	void __iomem *vpss_clkctl_reg;
+	u32 val;
+
+	vpss_clkctl_reg = DAVINCI_SYSMOD_VIRT(DM365_VPSS_CLK_CTRL_ADDR);
+
+	switch (type) {
+	case VPBE_ENC_STD:
+		vpss_enable_clock(VPSS_VENC_CLOCK_SEL, 1);
+		vpss_enable_clock(VPSS_VPBE_CLOCK, 1);
+		val = DM365_VPSS_VENCCLKEN_ENABLE | DM365_VPSS_DACCLKEN_ENABLE;
+		break;
+
+	case VPBE_ENC_CUSTOM_TIMINGS:
+		if (pclock <= 27000000) {
+			vpss_enable_clock(VPSS_VENC_CLOCK_SEL, 1);
+			vpss_enable_clock(VPSS_VPBE_CLOCK, 1);
+			val = DM365_VPSS_VENCCLKEN_ENABLE |
+			      DM365_VPSS_DACCLKEN_ENABLE;
+		} else {
+			/* set sysclk4 to output 74.25 MHz from pll1 */
+			val = DM365_VPSS_PLLC2SYSCLK5_ENABLE |
+			      DM365_VPSS_DACCLKEN_ENABLE |
+			      DM365_VPSS_VENCCLKEN_ENABLE;
+		}
+		break;
+
+	default:
+		return -EINVAL;
+	}
+	writel(val, vpss_clkctl_reg);
+
+	return 0;
+}
+
+static struct platform_device dm365_vpbe_display = {
+	.name		= "vpbe-v4l2",
+	.id		= -1,
+	.num_resources  = ARRAY_SIZE(dm365_v4l2_disp_resources),
+	.resource	= dm365_v4l2_disp_resources,
+	.dev		= {
+		.dma_mask		= &dm365_video_dma_mask,
+		.coherent_dma_mask	= DMA_BIT_MASK(32),
+	},
+};
+
+struct venc_platform_data dm365_venc_pdata = {
+	.setup_pinmux	= dm365_vpbe_setup_pinmux,
+	.setup_clock	= dm365_venc_setup_clock,
+};
+
+static struct platform_device dm365_venc_dev = {
+	.name		= DM365_VPBE_VENC_SUBDEV_NAME,
+	.id		= -1,
+	.num_resources	= ARRAY_SIZE(dm365_venc_resources),
+	.resource	= dm365_venc_resources,
+	.dev		= {
+		.dma_mask		= &dm365_video_dma_mask,
+		.coherent_dma_mask	= DMA_BIT_MASK(32),
+		.platform_data		= (void *)&dm365_venc_pdata,
+	},
+};
+
+static struct platform_device dm365_vpbe_dev = {
+	.name		= "vpbe_controller",
+	.id		= -1,
+	.dev		= {
+		.dma_mask		= &dm365_video_dma_mask,
+		.coherent_dma_mask	= DMA_BIT_MASK(32),
+	},
+};
+
+int __init dm365_init_video(struct vpfe_config *vpfe_cfg,
+				struct vpbe_config *vpbe_cfg)
+{
+	if (vpfe_cfg || vpbe_cfg)
+		platform_device_register(&dm365_vpss_device);
+
+	if (vpfe_cfg) {
+		vpfe_capture_dev.dev.platform_data = vpfe_cfg;
+		/* Add isif clock alias */
+		clk_add_alias("master", dm365_isif_dev.name,
+			      "vpss_master", NULL);
+		platform_device_register(&dm365_isif_dev);
+		platform_device_register(&vpfe_capture_dev);
+	}
+	if (vpbe_cfg) {
+		dm365_vpbe_dev.dev.platform_data = vpbe_cfg;
+		platform_device_register(&dm365_osd_dev);
+		platform_device_register(&dm365_venc_dev);
+		platform_device_register(&dm365_vpbe_dev);
+		platform_device_register(&dm365_vpbe_display);
+	}
+
+	return 0;
+}
+
 static int __init dm365_init_devices(void)
 {
 	if (!cpu_is_davinci_dm365())
@@ -1245,16 +1436,6 @@ static int __init dm365_init_devices(void)
 	clk_add_alias(NULL, dev_name(&dm365_mdio_device.dev),
 		      NULL, &dm365_emac_device.dev);
 
-	/* Add isif clock alias */
-	clk_add_alias("master", dm365_isif_dev.name, "vpss_master", NULL);
-	platform_device_register(&dm365_vpss_device);
-	platform_device_register(&dm365_isif_dev);
-	platform_device_register(&vpfe_capture_dev);
 	return 0;
 }
 postcore_initcall(dm365_init_devices);
-
-void dm365_set_vpfe_config(struct vpfe_config *cfg)
-{
-       vpfe_capture_dev.dev.platform_data = cfg;
-}
-- 
1.7.4.1

