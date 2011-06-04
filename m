Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756795Ab1FDLkX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jun 2011 07:40:23 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:44332 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756647Ab1FDLkT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jun 2011 07:40:19 -0400
From: Shawn Guo <shawn.guo@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: grant.likely@secretlab.ca, arnd@arndb.de, olof@lixom.net,
        kernel@pengutronix.de, linux-arm-kernel@lists.infradead.org,
        patches@linaro.org, Shawn Guo <shawn.guo@linaro.org>
Subject: [PATCH v3 3/5] ARM: mxc: migrate mach-mx5 gpio driver to gpio-mxc
Date: Sat,  4 Jun 2011 19:47:16 +0800
Message-Id: <1307188038-21225-4-git-send-email-shawn.guo@linaro.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1307188038-21225-1-git-send-email-shawn.guo@linaro.org>
References: <1307188038-21225-1-git-send-email-shawn.guo@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It registers platform device for drivers/gpio/gpio-mxc, and migrates
mx50/mx51/mx53 gpio driver to gpio-mxc.

Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
Acked-by: Olof Johansson <olof@lixom.net>
---
 arch/arm/mach-mx5/board-cpuimx51.c              |    2 +
 arch/arm/mach-mx5/board-cpuimx51sd.c            |    2 +
 arch/arm/mach-mx5/board-mx50_rdp.c              |    2 +
 arch/arm/mach-mx5/board-mx51_3ds.c              |    2 +
 arch/arm/mach-mx5/board-mx51_babbage.c          |    2 +
 arch/arm/mach-mx5/board-mx51_efikamx.c          |    2 +
 arch/arm/mach-mx5/board-mx51_efikasb.c          |    2 +
 arch/arm/mach-mx5/board-mx53_evk.c              |    2 +
 arch/arm/mach-mx5/board-mx53_loco.c             |    2 +
 arch/arm/mach-mx5/board-mx53_smd.c              |    2 +
 arch/arm/mach-mx5/devices.c                     |   64 -----------------------
 arch/arm/mach-mx5/mm-mx50.c                     |   21 ++++----
 arch/arm/mach-mx5/mm.c                          |   25 +++++++--
 arch/arm/plat-mxc/devices.c                     |   11 ++++
 arch/arm/plat-mxc/devices/Makefile              |    1 +
 arch/arm/plat-mxc/devices/platform-gpio-mxc.c   |   32 +++++++++++
 arch/arm/plat-mxc/include/mach/common.h         |    6 ++-
 arch/arm/plat-mxc/include/mach/devices-common.h |    2 +
 18 files changed, 100 insertions(+), 82 deletions(-)
 create mode 100644 arch/arm/plat-mxc/devices/platform-gpio-mxc.c

diff --git a/arch/arm/mach-mx5/board-cpuimx51.c b/arch/arm/mach-mx5/board-cpuimx51.c
index 4efa02e..add0d42 100644
--- a/arch/arm/mach-mx5/board-cpuimx51.c
+++ b/arch/arm/mach-mx5/board-cpuimx51.c
@@ -245,6 +245,8 @@ __setup("otg_mode=", eukrea_cpuimx51_otg_mode);
  */
 static void __init eukrea_cpuimx51_init(void)
 {
+	imx51_soc_init();
+
 	mxc_iomux_v3_setup_multiple_pads(eukrea_cpuimx51_pads,
 					ARRAY_SIZE(eukrea_cpuimx51_pads));
 
diff --git a/arch/arm/mach-mx5/board-cpuimx51sd.c b/arch/arm/mach-mx5/board-cpuimx51sd.c
index 5ef25a5..ff096d5 100644
--- a/arch/arm/mach-mx5/board-cpuimx51sd.c
+++ b/arch/arm/mach-mx5/board-cpuimx51sd.c
@@ -264,6 +264,8 @@ static struct platform_device *platform_devices[] __initdata = {
 
 static void __init eukrea_cpuimx51sd_init(void)
 {
+	imx51_soc_init();
+
 	mxc_iomux_v3_setup_multiple_pads(eukrea_cpuimx51sd_pads,
 					ARRAY_SIZE(eukrea_cpuimx51sd_pads));
 
diff --git a/arch/arm/mach-mx5/board-mx50_rdp.c b/arch/arm/mach-mx5/board-mx50_rdp.c
index 11210e1..7de25c6 100644
--- a/arch/arm/mach-mx5/board-mx50_rdp.c
+++ b/arch/arm/mach-mx5/board-mx50_rdp.c
@@ -192,6 +192,8 @@ static const struct imxi2c_platform_data i2c_data __initconst = {
  */
 static void __init mx50_rdp_board_init(void)
 {
+	imx50_soc_init();
+
 	mxc_iomux_v3_setup_multiple_pads(mx50_rdp_pads,
 					ARRAY_SIZE(mx50_rdp_pads));
 
diff --git a/arch/arm/mach-mx5/board-mx51_3ds.c b/arch/arm/mach-mx5/board-mx51_3ds.c
index 63dfbea..3112d15 100644
--- a/arch/arm/mach-mx5/board-mx51_3ds.c
+++ b/arch/arm/mach-mx5/board-mx51_3ds.c
@@ -135,6 +135,8 @@ static struct spi_board_info mx51_3ds_spi_nor_device[] = {
  */
 static void __init mx51_3ds_init(void)
 {
+	imx51_soc_init();
+
 	mxc_iomux_v3_setup_multiple_pads(mx51_3ds_pads,
 					ARRAY_SIZE(mx51_3ds_pads));
 
diff --git a/arch/arm/mach-mx5/board-mx51_babbage.c b/arch/arm/mach-mx5/board-mx51_babbage.c
index c7b3fab..6021dd0 100644
--- a/arch/arm/mach-mx5/board-mx51_babbage.c
+++ b/arch/arm/mach-mx5/board-mx51_babbage.c
@@ -340,6 +340,8 @@ static void __init mx51_babbage_init(void)
 	iomux_v3_cfg_t power_key = _MX51_PAD_EIM_A27__GPIO2_21 |
 		MUX_PAD_CTRL(PAD_CTL_SRE_FAST | PAD_CTL_DSE_HIGH | PAD_CTL_PUS_100K_UP);
 
+	imx51_soc_init();
+
 #if defined(CONFIG_CPU_FREQ_IMX)
 	get_cpu_op = mx51_get_cpu_op;
 #endif
diff --git a/arch/arm/mach-mx5/board-mx51_efikamx.c b/arch/arm/mach-mx5/board-mx51_efikamx.c
index 6e36231..3be603b 100644
--- a/arch/arm/mach-mx5/board-mx51_efikamx.c
+++ b/arch/arm/mach-mx5/board-mx51_efikamx.c
@@ -236,6 +236,8 @@ late_initcall(mx51_efikamx_power_init);
 
 static void __init mx51_efikamx_init(void)
 {
+	imx51_soc_init();
+
 	mxc_iomux_v3_setup_multiple_pads(mx51efikamx_pads,
 					ARRAY_SIZE(mx51efikamx_pads));
 	efika_board_common_init();
diff --git a/arch/arm/mach-mx5/board-mx51_efikasb.c b/arch/arm/mach-mx5/board-mx51_efikasb.c
index 474fc6e..4b2e522 100644
--- a/arch/arm/mach-mx5/board-mx51_efikasb.c
+++ b/arch/arm/mach-mx5/board-mx51_efikasb.c
@@ -248,6 +248,8 @@ static void __init mx51_efikasb_board_id(void)
 
 static void __init efikasb_board_init(void)
 {
+	imx51_soc_init();
+
 	mxc_iomux_v3_setup_multiple_pads(mx51efikasb_pads,
 					ARRAY_SIZE(mx51efikasb_pads));
 	efika_board_common_init();
diff --git a/arch/arm/mach-mx5/board-mx53_evk.c b/arch/arm/mach-mx5/board-mx53_evk.c
index f87d571..0d9218a 100644
--- a/arch/arm/mach-mx5/board-mx53_evk.c
+++ b/arch/arm/mach-mx5/board-mx53_evk.c
@@ -117,6 +117,8 @@ static const struct spi_imx_master mx53_evk_spi_data __initconst = {
 
 static void __init mx53_evk_board_init(void)
 {
+	imx53_soc_init();
+
 	mxc_iomux_v3_setup_multiple_pads(mx53_evk_pads,
 					ARRAY_SIZE(mx53_evk_pads));
 	mx53_evk_init_uart();
diff --git a/arch/arm/mach-mx5/board-mx53_loco.c b/arch/arm/mach-mx5/board-mx53_loco.c
index 1b947e8..359c3e2 100644
--- a/arch/arm/mach-mx5/board-mx53_loco.c
+++ b/arch/arm/mach-mx5/board-mx53_loco.c
@@ -227,6 +227,8 @@ static const struct imxi2c_platform_data mx53_loco_i2c_data __initconst = {
 
 static void __init mx53_loco_board_init(void)
 {
+	imx53_soc_init();
+
 	mxc_iomux_v3_setup_multiple_pads(mx53_loco_pads,
 					ARRAY_SIZE(mx53_loco_pads));
 	imx53_add_imx_uart(0, NULL);
diff --git a/arch/arm/mach-mx5/board-mx53_smd.c b/arch/arm/mach-mx5/board-mx53_smd.c
index 817c089..bc02894 100644
--- a/arch/arm/mach-mx5/board-mx53_smd.c
+++ b/arch/arm/mach-mx5/board-mx53_smd.c
@@ -113,6 +113,8 @@ static const struct imxi2c_platform_data mx53_smd_i2c_data __initconst = {
 
 static void __init mx53_smd_board_init(void)
 {
+	imx53_soc_init();
+
 	mxc_iomux_v3_setup_multiple_pads(mx53_smd_pads,
 					ARRAY_SIZE(mx53_smd_pads));
 	mx53_smd_init_uart();
diff --git a/arch/arm/mach-mx5/devices.c b/arch/arm/mach-mx5/devices.c
index 153ada5..371ca8c 100644
--- a/arch/arm/mach-mx5/devices.c
+++ b/arch/arm/mach-mx5/devices.c
@@ -12,7 +12,6 @@
 
 #include <linux/platform_device.h>
 #include <linux/dma-mapping.h>
-#include <linux/gpio.h>
 #include <mach/hardware.h>
 #include <mach/imx-uart.h>
 #include <mach/irqs.h>
@@ -119,66 +118,3 @@ struct platform_device mxc_usbh2_device = {
 		.coherent_dma_mask = DMA_BIT_MASK(32),
 	},
 };
-
-static struct mxc_gpio_port mxc_gpio_ports[] = {
-	{
-		.chip.label = "gpio-0",
-		.base = MX51_IO_ADDRESS(MX51_GPIO1_BASE_ADDR),
-		.irq = MX51_MXC_INT_GPIO1_LOW,
-		.irq_high = MX51_MXC_INT_GPIO1_HIGH,
-		.virtual_irq_start = MXC_GPIO_IRQ_START
-	},
-	{
-		.chip.label = "gpio-1",
-		.base = MX51_IO_ADDRESS(MX51_GPIO2_BASE_ADDR),
-		.irq = MX51_MXC_INT_GPIO2_LOW,
-		.irq_high = MX51_MXC_INT_GPIO2_HIGH,
-		.virtual_irq_start = MXC_GPIO_IRQ_START + 32 * 1
-	},
-	{
-		.chip.label = "gpio-2",
-		.base = MX51_IO_ADDRESS(MX51_GPIO3_BASE_ADDR),
-		.irq = MX51_MXC_INT_GPIO3_LOW,
-		.irq_high = MX51_MXC_INT_GPIO3_HIGH,
-		.virtual_irq_start = MXC_GPIO_IRQ_START + 32 * 2
-	},
-	{
-		.chip.label = "gpio-3",
-		.base = MX51_IO_ADDRESS(MX51_GPIO4_BASE_ADDR),
-		.irq = MX51_MXC_INT_GPIO4_LOW,
-		.irq_high = MX51_MXC_INT_GPIO4_HIGH,
-		.virtual_irq_start = MXC_GPIO_IRQ_START + 32 * 3
-	},
-	{
-		.chip.label = "gpio-4",
-		.base = MX53_IO_ADDRESS(MX53_GPIO5_BASE_ADDR),
-		.irq = MX53_INT_GPIO5_LOW,
-		.irq_high = MX53_INT_GPIO5_HIGH,
-		.virtual_irq_start = MXC_GPIO_IRQ_START + 32 * 4
-	},
-	{
-		.chip.label = "gpio-5",
-		.base = MX53_IO_ADDRESS(MX53_GPIO6_BASE_ADDR),
-		.irq = MX53_INT_GPIO6_LOW,
-		.irq_high = MX53_INT_GPIO6_HIGH,
-		.virtual_irq_start = MXC_GPIO_IRQ_START + 32 * 5
-	},
-	{
-		.chip.label = "gpio-6",
-		.base = MX53_IO_ADDRESS(MX53_GPIO7_BASE_ADDR),
-		.irq = MX53_INT_GPIO7_LOW,
-		.irq_high = MX53_INT_GPIO7_HIGH,
-		.virtual_irq_start = MXC_GPIO_IRQ_START + 32 * 6
-	},
-};
-
-int __init imx51_register_gpios(void)
-{
-	return mxc_gpio_init(mxc_gpio_ports, 4);
-}
-
-int __init imx53_register_gpios(void)
-{
-	return mxc_gpio_init(mxc_gpio_ports, ARRAY_SIZE(mxc_gpio_ports));
-}
-
diff --git a/arch/arm/mach-mx5/mm-mx50.c b/arch/arm/mach-mx5/mm-mx50.c
index b9c363b..28c3f60 100644
--- a/arch/arm/mach-mx5/mm-mx50.c
+++ b/arch/arm/mach-mx5/mm-mx50.c
@@ -26,7 +26,6 @@
 #include <mach/hardware.h>
 #include <mach/common.h>
 #include <mach/iomux-v3.h>
-#include <mach/gpio.h>
 #include <mach/irqs.h>
 
 /*
@@ -56,17 +55,17 @@ void __init imx50_init_early(void)
 	mxc_arch_reset_init(MX50_IO_ADDRESS(MX50_WDOG_BASE_ADDR));
 }
 
-static struct mxc_gpio_port imx50_gpio_ports[] = {
-	DEFINE_IMX_GPIO_PORT_IRQ_HIGH(MX50, 0, 1, MX50_INT_GPIO1_LOW, MX50_INT_GPIO1_HIGH),
-	DEFINE_IMX_GPIO_PORT_IRQ_HIGH(MX50, 1, 2, MX50_INT_GPIO2_LOW, MX50_INT_GPIO2_HIGH),
-	DEFINE_IMX_GPIO_PORT_IRQ_HIGH(MX50, 2, 3, MX50_INT_GPIO3_LOW, MX50_INT_GPIO3_HIGH),
-	DEFINE_IMX_GPIO_PORT_IRQ_HIGH(MX50, 3, 4, MX50_INT_GPIO3_LOW, MX50_INT_GPIO3_HIGH),
-	DEFINE_IMX_GPIO_PORT_IRQ_HIGH(MX50, 4, 5, MX50_INT_GPIO3_LOW, MX50_INT_GPIO3_HIGH),
-	DEFINE_IMX_GPIO_PORT_IRQ_HIGH(MX50, 5, 6, MX50_INT_GPIO3_LOW, MX50_INT_GPIO3_HIGH),
-};
-
 void __init mx50_init_irq(void)
 {
 	tzic_init_irq(MX50_IO_ADDRESS(MX50_TZIC_BASE_ADDR));
-	mxc_gpio_init(imx50_gpio_ports,	ARRAY_SIZE(imx50_gpio_ports));
+}
+
+void __init imx50_soc_init(void)
+{
+	mxc_register_gpio(0, MX50_GPIO1_BASE_ADDR, SZ_16K, MX50_INT_GPIO1_LOW, MX50_INT_GPIO1_HIGH);
+	mxc_register_gpio(1, MX50_GPIO2_BASE_ADDR, SZ_16K, MX50_INT_GPIO2_LOW, MX50_INT_GPIO2_HIGH);
+	mxc_register_gpio(2, MX50_GPIO3_BASE_ADDR, SZ_16K, MX50_INT_GPIO3_LOW, MX50_INT_GPIO3_HIGH);
+	mxc_register_gpio(3, MX50_GPIO4_BASE_ADDR, SZ_16K, MX50_INT_GPIO4_LOW, MX50_INT_GPIO4_HIGH);
+	mxc_register_gpio(4, MX50_GPIO5_BASE_ADDR, SZ_16K, MX50_INT_GPIO5_LOW, MX50_INT_GPIO5_HIGH);
+	mxc_register_gpio(5, MX50_GPIO6_BASE_ADDR, SZ_16K, MX50_INT_GPIO6_LOW, MX50_INT_GPIO6_HIGH);
 }
diff --git a/arch/arm/mach-mx5/mm.c b/arch/arm/mach-mx5/mm.c
index ff55730..800bb8b2 100644
--- a/arch/arm/mach-mx5/mm.c
+++ b/arch/arm/mach-mx5/mm.c
@@ -69,8 +69,6 @@ void __init imx53_init_early(void)
 	mxc_arch_reset_init(MX53_IO_ADDRESS(MX53_WDOG1_BASE_ADDR));
 }
 
-int imx51_register_gpios(void);
-
 void __init mx51_init_irq(void)
 {
 	unsigned long tzic_addr;
@@ -86,11 +84,8 @@ void __init mx51_init_irq(void)
 		panic("unable to map TZIC interrupt controller\n");
 
 	tzic_init_irq(tzic_virt);
-	imx51_register_gpios();
 }
 
-int imx53_register_gpios(void);
-
 void __init mx53_init_irq(void)
 {
 	unsigned long tzic_addr;
@@ -103,5 +98,23 @@ void __init mx53_init_irq(void)
 		panic("unable to map TZIC interrupt controller\n");
 
 	tzic_init_irq(tzic_virt);
-	imx53_register_gpios();
+}
+
+void __init imx51_soc_init(void)
+{
+	mxc_register_gpio(0, MX51_GPIO1_BASE_ADDR, SZ_16K, MX51_MXC_INT_GPIO1_LOW, MX51_MXC_INT_GPIO1_HIGH);
+	mxc_register_gpio(1, MX51_GPIO2_BASE_ADDR, SZ_16K, MX51_MXC_INT_GPIO2_LOW, MX51_MXC_INT_GPIO2_HIGH);
+	mxc_register_gpio(2, MX51_GPIO3_BASE_ADDR, SZ_16K, MX51_MXC_INT_GPIO3_LOW, MX51_MXC_INT_GPIO3_HIGH);
+	mxc_register_gpio(3, MX51_GPIO4_BASE_ADDR, SZ_16K, MX51_MXC_INT_GPIO4_LOW, MX51_MXC_INT_GPIO4_HIGH);
+}
+
+void __init imx53_soc_init(void)
+{
+	mxc_register_gpio(0, MX53_GPIO1_BASE_ADDR, SZ_16K, MX53_INT_GPIO1_LOW, MX53_INT_GPIO1_HIGH);
+	mxc_register_gpio(1, MX53_GPIO2_BASE_ADDR, SZ_16K, MX53_INT_GPIO2_LOW, MX53_INT_GPIO2_HIGH);
+	mxc_register_gpio(2, MX53_GPIO3_BASE_ADDR, SZ_16K, MX53_INT_GPIO3_LOW, MX53_INT_GPIO3_HIGH);
+	mxc_register_gpio(3, MX53_GPIO4_BASE_ADDR, SZ_16K, MX53_INT_GPIO4_LOW, MX53_INT_GPIO4_HIGH);
+	mxc_register_gpio(4, MX53_GPIO5_BASE_ADDR, SZ_16K, MX53_INT_GPIO5_LOW, MX53_INT_GPIO5_HIGH);
+	mxc_register_gpio(5, MX53_GPIO6_BASE_ADDR, SZ_16K, MX53_INT_GPIO6_LOW, MX53_INT_GPIO6_HIGH);
+	mxc_register_gpio(6, MX53_GPIO7_BASE_ADDR, SZ_16K, MX53_INT_GPIO7_LOW, MX53_INT_GPIO7_HIGH);
 }
diff --git a/arch/arm/plat-mxc/devices.c b/arch/arm/plat-mxc/devices.c
index eee1b60..fb166b2 100644
--- a/arch/arm/plat-mxc/devices.c
+++ b/arch/arm/plat-mxc/devices.c
@@ -89,3 +89,14 @@ err:
 
 	return pdev;
 }
+
+struct device mxc_aips_bus = {
+	.init_name	= "mxc_aips",
+	.parent		= &platform_bus,
+};
+
+static int __init mxc_device_init(void)
+{
+	return device_register(&mxc_aips_bus);
+}
+core_initcall(mxc_device_init);
diff --git a/arch/arm/plat-mxc/devices/Makefile b/arch/arm/plat-mxc/devices/Makefile
index ad2922a..b41bf97 100644
--- a/arch/arm/plat-mxc/devices/Makefile
+++ b/arch/arm/plat-mxc/devices/Makefile
@@ -2,6 +2,7 @@ obj-$(CONFIG_IMX_HAVE_PLATFORM_FEC) += platform-fec.o
 obj-$(CONFIG_IMX_HAVE_PLATFORM_FLEXCAN) += platform-flexcan.o
 obj-$(CONFIG_IMX_HAVE_PLATFORM_FSL_USB2_UDC) += platform-fsl-usb2-udc.o
 obj-$(CONFIG_IMX_HAVE_PLATFORM_GPIO_KEYS) += platform-gpio_keys.o
+obj-y += platform-gpio-mxc.o
 obj-$(CONFIG_IMX_HAVE_PLATFORM_IMX21_HCD) += platform-imx21-hcd.o
 obj-$(CONFIG_IMX_HAVE_PLATFORM_IMX2_WDT) += platform-imx2-wdt.o
 obj-$(CONFIG_IMX_HAVE_PLATFORM_IMXDI_RTC) += platform-imxdi_rtc.o
diff --git a/arch/arm/plat-mxc/devices/platform-gpio-mxc.c b/arch/arm/plat-mxc/devices/platform-gpio-mxc.c
new file mode 100644
index 0000000..cf1b7fd
--- /dev/null
+++ b/arch/arm/plat-mxc/devices/platform-gpio-mxc.c
@@ -0,0 +1,32 @@
+/*
+ * Copyright 2011 Freescale Semiconductor, Inc. All Rights Reserved.
+ * Copyright 2011 Linaro Limited
+ *
+ * This program is free software; you can redistribute it and/or modify it under
+ * the terms of the GNU General Public License version 2 as published by the
+ * Free Software Foundation.
+ */
+#include <mach/devices-common.h>
+
+struct platform_device *__init mxc_register_gpio(int id,
+	resource_size_t iobase, resource_size_t iosize, int irq, int irq_high)
+{
+	struct resource res[] = {
+		{
+			.start = iobase,
+			.end = iobase + iosize - 1,
+			.flags = IORESOURCE_MEM,
+		}, {
+			.start = irq,
+			.end = irq,
+			.flags = IORESOURCE_IRQ,
+		}, {
+			.start = irq_high,
+			.end = irq_high,
+			.flags = IORESOURCE_IRQ,
+		},
+	};
+
+	return platform_device_register_resndata(&mxc_aips_bus,
+			"gpio-mxc", id, res, ARRAY_SIZE(res), NULL, 0);
+}
diff --git a/arch/arm/plat-mxc/include/mach/common.h b/arch/arm/plat-mxc/include/mach/common.h
index da79918..1e1d476 100644
--- a/arch/arm/plat-mxc/include/mach/common.h
+++ b/arch/arm/plat-mxc/include/mach/common.h
@@ -43,6 +43,9 @@ extern void mx35_init_irq(void);
 extern void mx50_init_irq(void);
 extern void mx51_init_irq(void);
 extern void mx53_init_irq(void);
+extern void imx50_soc_init(void);
+extern void imx51_soc_init(void);
+extern void imx53_soc_init(void);
 extern void epit_timer_init(struct clk *timer_clk, void __iomem *base, int irq);
 extern void mxc_timer_init(struct clk *timer_clk, void __iomem *, int);
 extern int mx1_clocks_init(unsigned long fref);
@@ -55,7 +58,8 @@ extern int mx51_clocks_init(unsigned long ckil, unsigned long osc,
 			unsigned long ckih1, unsigned long ckih2);
 extern int mx53_clocks_init(unsigned long ckil, unsigned long osc,
 			unsigned long ckih1, unsigned long ckih2);
-extern int mxc_register_gpios(void);
+extern struct platform_device *mxc_register_gpio(int id,
+	resource_size_t iobase, resource_size_t iosize, int irq, int irq_high);
 extern int mxc_register_device(struct platform_device *pdev, void *data);
 extern void mxc_set_cpu_type(unsigned int type);
 extern void mxc_arch_reset_init(void __iomem *);
diff --git a/arch/arm/plat-mxc/include/mach/devices-common.h b/arch/arm/plat-mxc/include/mach/devices-common.h
index fa84773..03f6266 100644
--- a/arch/arm/plat-mxc/include/mach/devices-common.h
+++ b/arch/arm/plat-mxc/include/mach/devices-common.h
@@ -10,6 +10,8 @@
 #include <linux/platform_device.h>
 #include <linux/init.h>
 
+extern struct device mxc_aips_bus;
+
 struct platform_device *imx_add_platform_device_dmamask(
 		const char *name, int id,
 		const struct resource *res, unsigned int num_resources,
-- 
1.7.4.1

