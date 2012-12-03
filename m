Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754669Ab2LCKkV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 05:40:21 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:36235 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751501Ab2LCKkP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 05:40:15 -0500
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
To: LAK <linux-arm-kernel@lists.infradead.org>, Sekhar Nori <nsekhar@ti.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        Manjunath Hadli <manjunath.hadli@ti.com>,
        Prabhakar Lad <prabhakar.lad@ti.com>
Subject: [PATCH v4 1/2] ARM: davinci: dm355: add support for v4l2 video display
Date: Mon,  3 Dec 2012 16:09:49 +0530
Message-Id: <1354531190-11073-2-git-send-email-prabhakar.lad@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1354531190-11073-1-git-send-email-prabhakar.lad@ti.com>
References: <1354531190-11073-1-git-send-email-prabhakar.lad@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Manjunath Hadli <manjunath.hadli@ti.com>

Create platform devices for various video modules like venc,osd,
vpbe and v4l2 driver for dm355.

Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
Signed-off-by: Lad, Prabhakar <prabhakar.lad@ti.com>
---
 arch/arm/mach-davinci/board-dm355-evm.c |    4 +-
 arch/arm/mach-davinci/davinci.h         |    2 +-
 arch/arm/mach-davinci/dm355.c           |  202 +++++++++++++++++++++++++++++--
 3 files changed, 197 insertions(+), 11 deletions(-)

diff --git a/arch/arm/mach-davinci/board-dm355-evm.c b/arch/arm/mach-davinci/board-dm355-evm.c
index 88ebea8..1e9bd59 100644
--- a/arch/arm/mach-davinci/board-dm355-evm.c
+++ b/arch/arm/mach-davinci/board-dm355-evm.c
@@ -253,8 +253,6 @@ static struct davinci_uart_config uart_config __initdata = {
 
 static void __init dm355_evm_map_io(void)
 {
-	/* setup input configuration for VPFE input devices */
-	dm355_set_vpfe_config(&vpfe_cfg);
 	dm355_init();
 }
 
@@ -344,6 +342,8 @@ static __init void dm355_evm_init(void)
 	davinci_setup_mmc(0, &dm355evm_mmc_config);
 	davinci_setup_mmc(1, &dm355evm_mmc_config);
 
+	dm355_init_video(&vpfe_cfg, NULL);
+
 	dm355_init_spi0(BIT(0), dm355_evm_spi_info,
 			ARRAY_SIZE(dm355_evm_spi_info));
 
diff --git a/arch/arm/mach-davinci/davinci.h b/arch/arm/mach-davinci/davinci.h
index 1c2670f..acfe0bb 100644
--- a/arch/arm/mach-davinci/davinci.h
+++ b/arch/arm/mach-davinci/davinci.h
@@ -74,7 +74,7 @@ void __init dm355_init(void);
 void dm355_init_spi0(unsigned chipselect_mask,
 		const struct spi_board_info *info, unsigned len);
 void __init dm355_init_asp1(u32 evt_enable, struct snd_platform_data *pdata);
-void dm355_set_vpfe_config(struct vpfe_config *cfg);
+int __init dm355_init_video(struct vpfe_config *, struct vpbe_config *);
 
 /* DM365 function declarations */
 void __init dm365_init(void);
diff --git a/arch/arm/mach-davinci/dm355.c b/arch/arm/mach-davinci/dm355.c
index a255434..e5b34cd 100644
--- a/arch/arm/mach-davinci/dm355.c
+++ b/arch/arm/mach-davinci/dm355.c
@@ -36,6 +36,17 @@
 
 #define DM355_UART2_BASE	(IO_PHYS + 0x206000)
 
+#define DM3XX_VDAC_CONFIG_BASE		0x01c4002c
+
+#define DM355_OSD_REG_BASE		0x01c70200
+
+#define DM355_VENC_REG_BASE		0x01c70400
+
+#define DM355_VPSS_CLK_CTRL_ADDR		0x44
+#define DM355_VPSS_MUXSEL_EXTCLK_ENABLE		(~BIT(0) & BIT(1))
+#define DM355_VPSS_VENCCLKEN_ENABLE		BIT(3)
+#define DM355_VPSS_DACCLKEN_ENABLE		BIT(4)
+
 /*
  * Device specific clocks
  */
@@ -744,11 +755,165 @@ static struct platform_device vpfe_capture_dev = {
 	},
 };
 
-void dm355_set_vpfe_config(struct vpfe_config *cfg)
+static struct resource dm355_osd_resources[] = {
+	{
+		.start	= DM355_OSD_REG_BASE,
+		.end	= DM355_OSD_REG_BASE + 0x180,
+		.flags	= IORESOURCE_MEM,
+	},
+};
+
+static struct platform_device dm355_osd_dev = {
+	.name		= DM355_VPBE_OSD_SUBDEV_NAME,
+	.id		= -1,
+	.num_resources	= ARRAY_SIZE(dm355_osd_resources),
+	.resource	= dm355_osd_resources,
+	.dev		= {
+		.dma_mask		= &vpfe_capture_dma_mask,
+		.coherent_dma_mask	= DMA_BIT_MASK(32),
+	},
+};
+
+static struct resource dm355_venc_resources[] = {
+	{
+		.start	= IRQ_VENCINT,
+		.end	= IRQ_VENCINT,
+		.flags	= IORESOURCE_IRQ,
+	},
+	/* venc registers io space */
+	{
+		.start	= DM355_VENC_REG_BASE,
+		.end	= DM355_VENC_REG_BASE + 0x180,
+		.flags	= IORESOURCE_MEM,
+	},
+	/* VDAC config register io space */
+	{
+		.start	= DM3XX_VDAC_CONFIG_BASE,
+		.end	= DM3XX_VDAC_CONFIG_BASE + 4,
+		.flags	= IORESOURCE_MEM,
+	},
+};
+
+static struct resource dm355_v4l2_disp_resources[] = {
+	{
+		.start	= IRQ_VENCINT,
+		.end	= IRQ_VENCINT,
+		.flags	= IORESOURCE_IRQ,
+	},
+	/* venc registers io space */
+	{
+		.start	= DM355_VENC_REG_BASE,
+		.end	= DM355_VENC_REG_BASE + 0x180,
+		.flags	= IORESOURCE_MEM,
+	},
+};
+
+static int dm355_vpbe_setup_pinmux(enum v4l2_mbus_pixelcode if_type,
+			    int field)
 {
-	vpfe_capture_dev.dev.platform_data = cfg;
+	switch (if_type) {
+	case V4L2_MBUS_FMT_SGRBG8_1X8:
+		davinci_cfg_reg(DM355_VOUT_FIELD_G70);
+		break;
+
+	case V4L2_MBUS_FMT_YUYV10_1X20:
+		/*
+		 * This was VPBE_DIGITAL_IF_YCC16. Replace the enum
+		 * accordingly when the right one gets into open source
+		 */
+		if (field)
+			davinci_cfg_reg(DM355_VOUT_FIELD);
+		else
+			davinci_cfg_reg(DM355_VOUT_FIELD_G70);
+		break;
+
+	default:
+		return -EINVAL;
+	}
+
+	davinci_cfg_reg(DM355_VOUT_COUTL_EN);
+	davinci_cfg_reg(DM355_VOUT_COUTH_EN);
+
+	return 0;
 }
 
+static inline u32 dm355_reg_modify(void *reg, u32 val, u32 mask)
+{
+	u32 new_val = (readl(reg) & ~mask) | (val & mask);
+
+	writel(new_val, reg);
+
+	return new_val;
+}
+
+static int dm355_venc_setup_clock(enum vpbe_enc_timings_type type,
+				   unsigned int pclock)
+{
+	void __iomem *vpss_clk_ctrl_reg;
+
+	vpss_clk_ctrl_reg = DAVINCI_SYSMOD_VIRT(DM355_VPSS_CLK_CTRL_ADDR);
+
+	switch (type) {
+	case VPBE_ENC_STD:
+		vpss_enable_clock(VPSS_VENC_CLOCK_SEL, 0);
+		writel(DM355_VPSS_DACCLKEN_ENABLE |
+		       DM355_VPSS_VENCCLKEN_ENABLE, vpss_clk_ctrl_reg);
+		break;
+
+	case VPBE_ENC_CUSTOM_TIMINGS:
+		if (pclock > 27000000)
+			/*
+			 * For HD, use external clock source since we cannot
+			 * support HD mode with internal clocks.
+			 */
+			writel(DM355_VPSS_MUXSEL_EXTCLK_ENABLE,
+			       vpss_clk_ctrl_reg);
+		break;
+
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static struct platform_device dm355_vpbe_display = {
+	.name		= "vpbe-v4l2",
+	.id		= -1,
+	.num_resources	= ARRAY_SIZE(dm355_v4l2_disp_resources),
+	.resource	= dm355_v4l2_disp_resources,
+	.dev		= {
+		.dma_mask		= &vpfe_capture_dma_mask,
+		.coherent_dma_mask	= DMA_BIT_MASK(32),
+	},
+};
+
+struct venc_platform_data dm355_venc_pdata = {
+	.setup_pinmux	= dm355_vpbe_setup_pinmux,
+	.setup_clock	= dm355_venc_setup_clock,
+};
+
+static struct platform_device dm355_venc_dev = {
+	.name		= DM355_VPBE_VENC_SUBDEV_NAME,
+	.id		= -1,
+	.num_resources	= ARRAY_SIZE(dm355_venc_resources),
+	.resource	= dm355_venc_resources,
+	.dev		= {
+		.dma_mask		= &vpfe_capture_dma_mask,
+		.coherent_dma_mask	= DMA_BIT_MASK(32),
+		.platform_data		= (void *)&dm355_venc_pdata,
+	},
+};
+
+static struct platform_device dm355_vpbe_dev = {
+	.name		= "vpbe_controller",
+	.id		= -1,
+	.dev		= {
+		.dma_mask		= &vpfe_capture_dma_mask,
+		.coherent_dma_mask	= DMA_BIT_MASK(32),
+	},
+};
+
 /*----------------------------------------------------------------------*/
 
 static struct map_desc dm355_io_desc[] = {
@@ -874,19 +1039,40 @@ void __init dm355_init(void)
 	davinci_map_sysmod();
 }
 
+int __init dm355_init_video(struct vpfe_config *vpfe_cfg,
+				struct vpbe_config *vpbe_cfg)
+{
+	if (vpfe_cfg || vpbe_cfg)
+		platform_device_register(&dm355_vpss_device);
+
+	if (vpfe_cfg) {
+		/* Add ccdc clock aliases */
+		clk_add_alias("master", dm355_ccdc_dev.name,
+			      "vpss_master", NULL);
+		clk_add_alias("slave", dm355_ccdc_dev.name, "vpss_slave", NULL);
+		vpfe_capture_dev.dev.platform_data = vpfe_cfg;
+		platform_device_register(&dm355_ccdc_dev);
+		platform_device_register(&vpfe_capture_dev);
+	}
+
+	if (vpbe_cfg) {
+		dm355_vpbe_dev.dev.platform_data = vpbe_cfg;
+		platform_device_register(&dm355_osd_dev);
+		platform_device_register(&dm355_venc_dev);
+		platform_device_register(&dm355_vpbe_dev);
+		platform_device_register(&dm355_vpbe_display);
+	}
+
+	return 0;
+}
+
 static int __init dm355_init_devices(void)
 {
 	if (!cpu_is_davinci_dm355())
 		return 0;
 
-	/* Add ccdc clock aliases */
-	clk_add_alias("master", dm355_ccdc_dev.name, "vpss_master", NULL);
-	clk_add_alias("slave", dm355_ccdc_dev.name, "vpss_master", NULL);
 	davinci_cfg_reg(DM355_INT_EDMA_CC);
 	platform_device_register(&dm355_edma_device);
-	platform_device_register(&dm355_vpss_device);
-	platform_device_register(&dm355_ccdc_dev);
-	platform_device_register(&vpfe_capture_dev);
 
 	return 0;
 }
-- 
1.7.4.1

