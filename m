Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753895Ab2IRSYr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 14:24:47 -0400
Received: from mail-ey0-f202.google.com ([209.85.215.202]:48912 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753704Ab2IRSYf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 14:24:35 -0400
From: Simon Glass <sjg@chromium.org>
To: LKML <linux-kernel@vger.kernel.org>, linux-arm-kernel@lists.infradead.org
Cc: "kgene.kim" <kgene.kim@samsung.com>, Ben Dooks <ben-linux@fluff.org>,
        Srinivas KANDAGATLA <srinivas.kandagatla@st.com>,
        Simon Glass <sjg@chromium.org>
Subject: [PATCH 3/7] spi: s3c64xx: Add support for ISP SPI ports
Date: Tue, 18 Sep 2012 11:21:55 -0700
Message-Id: <1347992519-6904-4-git-send-email-sjg@chromium.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1347992519-6904-1-git-send-email-sjg@chromium.org>
References: <1347992519-6904-1-git-send-email-sjg@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ISP has two SPI ports which can be used for general SPI activities.
Add support for these for:

- clocks and clock gating
- SPI FIFO size for these ports
- support for 'samsung,pd' node in SPI so we can mark these ports as
    dependent on the ISP power domain

Signed-off-by: Simon Glass <sjg@chromium.org>
---
 arch/arm/mach-exynos/clock-exynos5.c           |   69 ++++++++++++++++++++++++
 arch/arm/mach-exynos/include/mach/map.h        |    2 +
 arch/arm/mach-exynos/include/mach/regs-clock.h |    1 +
 arch/arm/mach-exynos/mach-exynos5-dt.c         |    4 ++
 drivers/spi/spi-s3c64xx.c                      |   13 ++++-
 5 files changed, 87 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-exynos/clock-exynos5.c b/arch/arm/mach-exynos/clock-exynos5.c
index 774533c..f40eaaf 100644
--- a/arch/arm/mach-exynos/clock-exynos5.c
+++ b/arch/arm/mach-exynos/clock-exynos5.c
@@ -186,6 +186,11 @@ static int exynos5_clk_ip_peris_ctrl(struct clk *clk, int enable)
 	return s5p_gatectrl(EXYNOS5_CLKGATE_IP_PERIS, clk, enable);
 }
 
+static int exynos5_clksrc_mask_isp_ctrl(struct clk *clk, int enable)
+{
+	return s5p_gatectrl(EXYNOS5_SCLK_SRC_MASK_ISP, clk, enable);
+}
+
 static int exynos5_clk_ip_gscl_ctrl(struct clk *clk, int enable)
 {
 	return s5p_gatectrl(EXYNOS5_CLKGATE_IP_GSCL, clk, enable);
@@ -764,6 +769,18 @@ static struct clk exynos5_init_clocks_off[] = {
 		.enable		= exynos5_clk_ip_peric_ctrl,
 		.ctrlbit	= (1 << 18),
 	}, {
+		.name		= "spi",
+		.devname	= "exynos4210-spi.3",
+		.parent		= &exynos5_clk_aclk_66.clk,
+		.enable		= exynos5_clk_ip_isp1_ctrl,
+		.ctrlbit	= (1 << 12),
+	}, {
+		.name		= "spi",
+		.devname	= "exynos4210-spi.4",
+		.parent		= &exynos5_clk_aclk_66.clk,
+		.enable		= exynos5_clk_ip_isp1_ctrl,
+		.ctrlbit	= (1 << 13),
+	}, {
 		.name		= SYSMMU_CLOCK_NAME,
 		.devname	= SYSMMU_CLOCK_DEVNAME(mfc_l, 0),
 		.enable		= &exynos5_clk_ip_mfc_ctrl,
@@ -1120,6 +1137,50 @@ static struct clksrc_clk exynos5_clk_sclk_spi2 = {
 	.reg_div = { .reg = EXYNOS5_CLKDIV_PERIC2, .shift = 8, .size = 8 },
 };
 
+static struct clksrc_clk exynos5_clk_mdout_spi3 = {
+	.clk	= {
+		.name		= "sclk_spi_mdout",
+		.devname	= "exynos4210-spi.3",
+	},
+	.sources = &exynos5_clkset_group,
+	.reg_src = { .reg = EXYNOS5_SCLK_SRC_ISP, .shift = 0, .size = 4 },
+	.reg_div = { .reg = EXYNOS5_SCLK_DIV_ISP, .shift = 0, .size = 4 },
+
+};
+
+static struct clksrc_clk exynos5_clk_sclk_spi3 = {
+	.clk	= {
+		.name		= "sclk_spi",
+		.devname	= "exynos4210-spi.3",
+		.parent		= &exynos5_clk_mdout_spi3.clk,
+		.enable		= exynos5_clksrc_mask_isp_ctrl,
+		.ctrlbit	= (1 << 0),
+	},
+	.reg_div = { .reg = EXYNOS5_SCLK_DIV_ISP, .shift = 4, .size = 8 },
+};
+
+static struct clksrc_clk exynos5_clk_mdout_spi4 = {
+	.clk	= {
+		.name		= "sclk_spi_mdout",
+		.devname	= "exynos4210-spi.4",
+	},
+	.sources = &exynos5_clkset_group,
+	.reg_src = { .reg = EXYNOS5_SCLK_SRC_ISP, .shift = 4, .size = 4 },
+	.reg_div = { .reg = EXYNOS5_SCLK_DIV_ISP, .shift = 12, .size = 4 },
+
+};
+
+static struct clksrc_clk exynos5_clk_sclk_spi4 = {
+	.clk	= {
+		.name		= "sclk_spi",
+		.devname	= "exynos4210-spi.4",
+		.parent		= &exynos5_clk_mdout_spi4.clk,
+		.enable		= exynos5_clksrc_mask_isp_ctrl,
+		.ctrlbit	= (1 << 4),
+	},
+	.reg_div = { .reg = EXYNOS5_SCLK_DIV_ISP, .shift = 16, .size = 8 },
+};
+
 static struct clksrc_clk exynos5_clksrcs[] = {
 	{
 		.clk	= {
@@ -1237,9 +1298,13 @@ static struct clksrc_clk *exynos5_sysclks[] = {
 	&exynos5_clk_sclk_spi0,
 	&exynos5_clk_sclk_spi1,
 	&exynos5_clk_sclk_spi2,
+	&exynos5_clk_sclk_spi3,
+	&exynos5_clk_sclk_spi4,
 	&exynos5_clk_mdout_spi0,
 	&exynos5_clk_mdout_spi1,
 	&exynos5_clk_mdout_spi2,
+	&exynos5_clk_mdout_spi3,
+	&exynos5_clk_mdout_spi4,
 };
 
 static struct clk *exynos5_clk_cdev[] = {
@@ -1271,6 +1336,10 @@ static struct clk_lookup exynos5_clk_lookup[] = {
 	CLKDEV_INIT("exynos4210-spi.0", "spi_busclk0", &exynos5_clk_sclk_spi0.clk),
 	CLKDEV_INIT("exynos4210-spi.1", "spi_busclk0", &exynos5_clk_sclk_spi1.clk),
 	CLKDEV_INIT("exynos4210-spi.2", "spi_busclk0", &exynos5_clk_sclk_spi2.clk),
+	CLKDEV_INIT("exynos4210-spi.3", "spi_busclk0",
+		    &exynos5_clk_sclk_spi3.clk),
+	CLKDEV_INIT("exynos4210-spi.4", "spi_busclk0",
+		    &exynos5_clk_sclk_spi4.clk),
 	CLKDEV_INIT("dma-pl330.0", "apb_pclk", &exynos5_clk_pdma0),
 	CLKDEV_INIT("dma-pl330.1", "apb_pclk", &exynos5_clk_pdma1),
 	CLKDEV_INIT("dma-pl330.2", "apb_pclk", &exynos5_clk_mdma1),
diff --git a/arch/arm/mach-exynos/include/mach/map.h b/arch/arm/mach-exynos/include/mach/map.h
index c72b675..4d46a5f 100644
--- a/arch/arm/mach-exynos/include/mach/map.h
+++ b/arch/arm/mach-exynos/include/mach/map.h
@@ -157,6 +157,8 @@
 #define EXYNOS5_PA_SPI0			0x12D20000
 #define EXYNOS5_PA_SPI1			0x12D30000
 #define EXYNOS5_PA_SPI2			0x12D40000
+#define EXYNOS5_PA_SPI3			0x131A0000
+#define EXYNOS5_PA_SPI4			0x131B0000
 
 #define EXYNOS4_PA_GPIO1		0x11400000
 #define EXYNOS4_PA_GPIO2		0x11000000
diff --git a/arch/arm/mach-exynos/include/mach/regs-clock.h b/arch/arm/mach-exynos/include/mach/regs-clock.h
index 8c9b38c..d03f83d 100644
--- a/arch/arm/mach-exynos/include/mach/regs-clock.h
+++ b/arch/arm/mach-exynos/include/mach/regs-clock.h
@@ -301,6 +301,7 @@
 #define EXYNOS5_CLKSRC_MASK_FSYS		EXYNOS_CLKREG(0x10340)
 #define EXYNOS5_CLKSRC_MASK_PERIC0		EXYNOS_CLKREG(0x10350)
 #define EXYNOS5_CLKSRC_MASK_PERIC1		EXYNOS_CLKREG(0x10354)
+#define EXYNOS5_SCLK_SRC_MASK_ISP		EXYNOS_CLKREG(0x10370)
 
 #define EXYNOS5_CLKDIV_TOP0			EXYNOS_CLKREG(0x10510)
 #define EXYNOS5_CLKDIV_TOP1			EXYNOS_CLKREG(0x10514)
diff --git a/arch/arm/mach-exynos/mach-exynos5-dt.c b/arch/arm/mach-exynos/mach-exynos5-dt.c
index ef770bc..76c5126 100644
--- a/arch/arm/mach-exynos/mach-exynos5-dt.c
+++ b/arch/arm/mach-exynos/mach-exynos5-dt.c
@@ -53,6 +53,10 @@ static const struct of_dev_auxdata exynos5250_auxdata_lookup[] __initconst = {
 				"exynos4210-spi.1", NULL),
 	OF_DEV_AUXDATA("samsung,exynos4210-spi", EXYNOS5_PA_SPI2,
 				"exynos4210-spi.2", NULL),
+	OF_DEV_AUXDATA("samsung,exynos4210-spi", EXYNOS5_PA_SPI3,
+				"exynos4210-spi.3", NULL),
+	OF_DEV_AUXDATA("samsung,exynos4210-spi", EXYNOS5_PA_SPI4,
+				"exynos4210-spi.4", NULL),
 	OF_DEV_AUXDATA("arm,pl330", EXYNOS5_PA_PDMA0, "dma-pl330.0", NULL),
 	OF_DEV_AUXDATA("arm,pl330", EXYNOS5_PA_PDMA1, "dma-pl330.1", NULL),
 	OF_DEV_AUXDATA("arm,pl330", EXYNOS5_PA_MDMA1, "dma-pl330.2", NULL),
diff --git a/drivers/spi/spi-s3c64xx.c b/drivers/spi/spi-s3c64xx.c
index 3152659..95a1bfc 100644
--- a/drivers/spi/spi-s3c64xx.c
+++ b/drivers/spi/spi-s3c64xx.c
@@ -30,11 +30,12 @@
 #include <linux/gpio.h>
 #include <linux/of.h>
 #include <linux/of_gpio.h>
+#include <linux/pm_domain.h>
 
 #include <mach/dma.h>
 #include <plat/s3c64xx-spi.h>
 
-#define MAX_SPI_PORTS		3
+#define MAX_SPI_PORTS		5
 
 /* Registers and bit-fields */
 
@@ -1345,6 +1346,14 @@ static int __init s3c64xx_spi_probe(struct platform_device *pdev)
 		goto err8;
 	}
 
+#ifdef CONFIG_PM
+	if (pdev->dev.of_node) {
+		if (pm_genpd_of_add_device_by_name(pdev->dev.of_node,
+				&pdev->dev, "samsung,pd"))
+			dev_err(&pdev->dev, "failed to add to genpd\n");
+	}
+#endif
+
 	dev_dbg(&pdev->dev, "Samsung SoC SPI Driver loaded for Bus SPI-%d "
 					"with %d Slaves attached\n",
 					sdd->port_id, master->num_chipselect);
@@ -1513,7 +1522,7 @@ struct s3c64xx_spi_port_config s5pv210_spi_port_config = {
 };
 
 struct s3c64xx_spi_port_config exynos4_spi_port_config = {
-	.fifo_lvl_mask	= { 0x1ff, 0x7F, 0x7F },
+	.fifo_lvl_mask	= { 0x1ff, 0x7F, 0x7F, 0x1ff, 0x1ff },
 	.rx_lvl_offset	= 15,
 	.tx_st_done	= 25,
 	.high_speed	= true,
-- 
1.7.7.3

