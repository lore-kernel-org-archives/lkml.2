Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756288Ab2ADCUO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 21:20:14 -0500
Received: from na3sys009aog125.obsmtp.com ([74.125.149.153]:33195 "HELO
	na3sys009aog125.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754052Ab2ADCUK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 21:20:10 -0500
From: Haojian Zhuang <haojian.zhuang@marvell.com>
To: linus.walleij@linaro.org, swarren@nvidia.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, eric.y.miao@gmail.com,
        linux@arm.linux.org.uk, arnd@arndb.de
Cc: Haojian Zhuang <haojian.zhuang@marvell.com>
Subject: [PATCH v4 2/3] ARM: mmp: enable pinmux in mmp platform
Date: Wed,  4 Jan 2012 10:26:34 +0800
Message-Id: <1325643995-20745-3-git-send-email-haojian.zhuang@marvell.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1325643995-20745-1-git-send-email-haojian.zhuang@marvell.com>
References: <1325643995-20745-1-git-send-email-haojian.zhuang@marvell.com>
X-OriginalArrivalTime: 04 Jan 2012 02:19:31.0186 (UTC) FILETIME=[4AD65D20:01CCCA87]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Configuring pinmux in brownstone, aspenite & ttc dkb platform. The functions
of pins are initialized in platform driver.

Signed-off-by: Haojian Zhuang <haojian.zhuang@marvell.com>
---
 arch/arm/mach-mmp/Kconfig               |    6 ++
 arch/arm/mach-mmp/aspenite.c            |  105 ++++++++-----------------------
 arch/arm/mach-mmp/brownstone.c          |   94 +++++++---------------------
 arch/arm/mach-mmp/include/mach/mmp2.h   |    5 ++
 arch/arm/mach-mmp/include/mach/pxa168.h |    6 ++
 arch/arm/mach-mmp/include/mach/pxa910.h |    6 ++
 arch/arm/mach-mmp/mmp2.c                |    1 +
 arch/arm/mach-mmp/pxa168.c              |    1 +
 arch/arm/mach-mmp/pxa910.c              |    2 +
 arch/arm/mach-mmp/ttc_dkb.c             |   56 +++++++---------
 10 files changed, 101 insertions(+), 181 deletions(-)

diff --git a/arch/arm/mach-mmp/Kconfig b/arch/arm/mach-mmp/Kconfig
index 323d4c9..426331a 100644
--- a/arch/arm/mach-mmp/Kconfig
+++ b/arch/arm/mach-mmp/Kconfig
@@ -89,18 +89,24 @@ endmenu
 config CPU_PXA168
 	bool
 	select CPU_MOHAWK
+	select PINCTRL
+	select PINCTRL_PXA168
 	help
 	  Select code specific to PXA168
 
 config CPU_PXA910
 	bool
 	select CPU_MOHAWK
+	select PINCTRL
+	select PINCTRL_PXA910
 	help
 	  Select code specific to PXA910
 
 config CPU_MMP2
 	bool
 	select CPU_PJ4
+	select PINCTRL
+	select PINCTRL_MMP2
 	help
 	  Select code specific to MMP2. MMP2 is ARMv7 compatible.
 endif
diff --git a/arch/arm/mach-mmp/aspenite.c b/arch/arm/mach-mmp/aspenite.c
index 17cb760..34bd5ba 100644
--- a/arch/arm/mach-mmp/aspenite.c
+++ b/arch/arm/mach-mmp/aspenite.c
@@ -12,6 +12,7 @@
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/platform_device.h>
+#include <linux/pinctrl/machine.h>
 #include <linux/smc91x.h>
 #include <linux/mtd/mtd.h>
 #include <linux/mtd/partitions.h>
@@ -22,7 +23,6 @@
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
 #include <mach/addr-map.h>
-#include <mach/mfp-pxa168.h>
 #include <mach/pxa168.h>
 #include <video/pxa168fb.h>
 #include <linux/input.h>
@@ -30,83 +30,22 @@
 
 #include "common.h"
 
-static unsigned long common_pin_config[] __initdata = {
-	/* Data Flash Interface */
-	GPIO0_DFI_D15,
-	GPIO1_DFI_D14,
-	GPIO2_DFI_D13,
-	GPIO3_DFI_D12,
-	GPIO4_DFI_D11,
-	GPIO5_DFI_D10,
-	GPIO6_DFI_D9,
-	GPIO7_DFI_D8,
-	GPIO8_DFI_D7,
-	GPIO9_DFI_D6,
-	GPIO10_DFI_D5,
-	GPIO11_DFI_D4,
-	GPIO12_DFI_D3,
-	GPIO13_DFI_D2,
-	GPIO14_DFI_D1,
-	GPIO15_DFI_D0,
-
-	/* Static Memory Controller */
-	GPIO18_SMC_nCS0,
-	GPIO34_SMC_nCS1,
-	GPIO23_SMC_nLUA,
-	GPIO25_SMC_nLLA,
-	GPIO28_SMC_RDY,
-	GPIO29_SMC_SCLK,
-	GPIO35_SMC_BE1,
-	GPIO36_SMC_BE2,
-	GPIO27_GPIO,	/* Ethernet IRQ */
-
-	/* UART1 */
-	GPIO107_UART1_RXD,
-	GPIO108_UART1_TXD,
-
-	/* SSP1 */
-	GPIO113_I2S_MCLK,
-	GPIO114_I2S_FRM,
-	GPIO115_I2S_BCLK,
-	GPIO116_I2S_RXD,
-	GPIO117_I2S_TXD,
-
-	/* LCD */
-	GPIO56_LCD_FCLK_RD,
-	GPIO57_LCD_LCLK_A0,
-	GPIO58_LCD_PCLK_WR,
-	GPIO59_LCD_DENA_BIAS,
-	GPIO60_LCD_DD0,
-	GPIO61_LCD_DD1,
-	GPIO62_LCD_DD2,
-	GPIO63_LCD_DD3,
-	GPIO64_LCD_DD4,
-	GPIO65_LCD_DD5,
-	GPIO66_LCD_DD6,
-	GPIO67_LCD_DD7,
-	GPIO68_LCD_DD8,
-	GPIO69_LCD_DD9,
-	GPIO70_LCD_DD10,
-	GPIO71_LCD_DD11,
-	GPIO72_LCD_DD12,
-	GPIO73_LCD_DD13,
-	GPIO74_LCD_DD14,
-	GPIO75_LCD_DD15,
-	GPIO76_LCD_DD16,
-	GPIO77_LCD_DD17,
-	GPIO78_LCD_DD18,
-	GPIO79_LCD_DD19,
-	GPIO80_LCD_DD20,
-	GPIO81_LCD_DD21,
-	GPIO82_LCD_DD22,
-	GPIO83_LCD_DD23,
-
-	/* Keypad */
-	GPIO109_KP_MKIN1,
-	GPIO110_KP_MKIN0,
-	GPIO111_KP_MKOUT7,
-	GPIO112_KP_MKOUT6,
-	GPIO121_KP_MKIN4,
+#define P168_CTRL		"pxa168-pinmux"
+
+static struct pinmux_map aspenite_pmx_map[] = {
+	PINMUX_MAP_SYS_HOG("SSP1 SYSCLK", P168_CTRL, "ac97 sysclk"),
+	PINMUX_MAP_SYS_HOG("SSP1 RX", P168_CTRL, "ssp1 rx"),
+	PINMUX_MAP_SYS_HOG("SSP1 TX", P168_CTRL, "ssp1 tx"),
+	PINMUX_MAP_SYS_HOG("DFIO", P168_CTRL, "dfio"),
+	PINMUX_MAP_SYS_HOG("SMC CS0", P168_CTRL, "smc cs0"),
+	PINMUX_MAP_SYS_HOG("SMC CS1", P168_CTRL, "smc cs1"),
+	PINMUX_MAP_SYS_HOG("SMC RDY", P168_CTRL, "smc rdy"),
+	PINMUX_MAP_SYS_HOG("SMC", P168_CTRL, "smc"),
+	PINMUX_MAP_SYS_HOG("LCD", P168_CTRL, "lcd"),
+	PINMUX_MAP_SYS_HOG("KP MKIN", P168_CTRL, "kpmkin"),
+	PINMUX_MAP_SYS_HOG("KP MKOUT", P168_CTRL, "kpmkout"),
+	PINMUX_MAP_SYS_HOG_GROUP("UART1 RX", P168_CTRL, "uart1 rx", "uart1rx-1"),
+	PINMUX_MAP_SYS_HOG_GROUP("UART1 TX", P168_CTRL, "uart1 tx", "uart1tx-1"),
 };
 
 static struct smc91x_platdata smc91x_info = {
@@ -223,9 +162,14 @@ static struct pxa27x_keypad_platform_data aspenite_keypad_info __initdata = {
 
 static void __init common_init(void)
 {
-	mfp_config(ARRAY_AND_SIZE(common_pin_config));
+	int ret;
+
+	ret = pinmux_register_mappings(ARRAY_AND_SIZE(aspenite_pmx_map));
+	if (ret < 0)
+		goto out;
 
 	/* on-chip devices */
+	pxa168_add_pinmux();
 	pxa168_add_uart(1);
 	pxa168_add_twsi(1, NULL, ARRAY_AND_SIZE(aspenite_i2c_info));
 	pxa168_add_ssp(1);
@@ -236,6 +180,9 @@ static void __init common_init(void)
 
 	/* off-chip devices */
 	platform_device_register(&smc91x_device);
+	return;
+out:
+	BUG();
 }
 
 MACHINE_START(ASPENITE, "PXA168-based Aspenite Development Platform")
diff --git a/arch/arm/mach-mmp/brownstone.c b/arch/arm/mach-mmp/brownstone.c
index d839fe6..eec2062 100644
--- a/arch/arm/mach-mmp/brownstone.c
+++ b/arch/arm/mach-mmp/brownstone.c
@@ -14,6 +14,7 @@
 #include <linux/kernel.h>
 #include <linux/platform_device.h>
 #include <linux/io.h>
+#include <linux/pinctrl/machine.h>
 #include <linux/regulator/machine.h>
 #include <linux/regulator/max8649.h>
 #include <linux/regulator/fixed.h>
@@ -29,79 +30,22 @@
 #include "common.h"
 
 #define BROWNSTONE_NR_IRQS	(IRQ_BOARD_START + 40)
+#define MMP2_CTRL		"mmp2-pinmux"
 
 #define GPIO_5V_ENABLE		(89)
 
-static unsigned long brownstone_pin_config[] __initdata = {
-	/* UART1 */
-	GPIO29_UART1_RXD,
-	GPIO30_UART1_TXD,
-
-	/* UART3 */
-	GPIO51_UART3_RXD,
-	GPIO52_UART3_TXD,
-
-	/* DFI */
-	GPIO168_DFI_D0,
-	GPIO167_DFI_D1,
-	GPIO166_DFI_D2,
-	GPIO165_DFI_D3,
-	GPIO107_DFI_D4,
-	GPIO106_DFI_D5,
-	GPIO105_DFI_D6,
-	GPIO104_DFI_D7,
-	GPIO111_DFI_D8,
-	GPIO164_DFI_D9,
-	GPIO163_DFI_D10,
-	GPIO162_DFI_D11,
-	GPIO161_DFI_D12,
-	GPIO110_DFI_D13,
-	GPIO109_DFI_D14,
-	GPIO108_DFI_D15,
-	GPIO143_ND_nCS0,
-	GPIO144_ND_nCS1,
-	GPIO147_ND_nWE,
-	GPIO148_ND_nRE,
-	GPIO150_ND_ALE,
-	GPIO149_ND_CLE,
-	GPIO112_ND_RDY0,
-	GPIO160_ND_RDY1,
-
-	/* PMIC */
-	PMIC_PMIC_INT | MFP_LPM_EDGE_FALL,
-
-	/* MMC0 */
-	GPIO131_MMC1_DAT3 | MFP_PULL_HIGH,
-	GPIO132_MMC1_DAT2 | MFP_PULL_HIGH,
-	GPIO133_MMC1_DAT1 | MFP_PULL_HIGH,
-	GPIO134_MMC1_DAT0 | MFP_PULL_HIGH,
-	GPIO136_MMC1_CMD | MFP_PULL_HIGH,
-	GPIO139_MMC1_CLK,
-	GPIO140_MMC1_CD | MFP_PULL_LOW,
-	GPIO141_MMC1_WP | MFP_PULL_LOW,
-
-	/* MMC1 */
-	GPIO37_MMC2_DAT3 | MFP_PULL_HIGH,
-	GPIO38_MMC2_DAT2 | MFP_PULL_HIGH,
-	GPIO39_MMC2_DAT1 | MFP_PULL_HIGH,
-	GPIO40_MMC2_DAT0 | MFP_PULL_HIGH,
-	GPIO41_MMC2_CMD | MFP_PULL_HIGH,
-	GPIO42_MMC2_CLK,
-
-	/* MMC2 */
-	GPIO165_MMC3_DAT7 | MFP_PULL_HIGH,
-	GPIO162_MMC3_DAT6 | MFP_PULL_HIGH,
-	GPIO166_MMC3_DAT5 | MFP_PULL_HIGH,
-	GPIO163_MMC3_DAT4 | MFP_PULL_HIGH,
-	GPIO167_MMC3_DAT3 | MFP_PULL_HIGH,
-	GPIO164_MMC3_DAT2 | MFP_PULL_HIGH,
-	GPIO168_MMC3_DAT1 | MFP_PULL_HIGH,
-	GPIO111_MMC3_DAT0 | MFP_PULL_HIGH,
-	GPIO112_MMC3_CMD | MFP_PULL_HIGH,
-	GPIO151_MMC3_CLK,
-
-	/* 5V regulator */
-	GPIO89_GPIO,
+static struct pinmux_map brownstone_pmx_map[] = {
+	PINMUX_MAP_SYS_HOG("TWSI4", MMP2_CTRL, "twsi4"),
+	PINMUX_MAP_SYS_HOG("MMC1", MMP2_CTRL, "mmc1"),
+	PINMUX_MAP_SYS_HOG("MMC2", MMP2_CTRL, "mmc2"),
+	PINMUX_MAP_SYS_HOG("MMC3", MMP2_CTRL, "mmc3"),
+	PINMUX_MAP_SYS_HOG_GROUP("UART1", MMP2_CTRL, "uart1", "uart1 4p1"),
+	PINMUX_MAP_SYS_HOG_GROUP("UART2", MMP2_CTRL, "uart2", "uart2 4p3"),
+	PINMUX_MAP_SYS_HOG_GROUP("UART3", MMP2_CTRL, "uart3", "uart3 2p6"),
+	PINMUX_MAP_SYS_HOG_GROUP("TWSI2", MMP2_CTRL, "twsi2", "twsi2-3"),
+	PINMUX_MAP_SYS_HOG_GROUP("TWSI3", MMP2_CTRL, "twsi3", "twsi3-1"),
+	PINMUX_MAP_SYS_HOG_GROUP("TWSI5", MMP2_CTRL, "twsi5", "twsi5-3"),
+	PINMUX_MAP_SYS_HOG_GROUP("TWSI6", MMP2_CTRL, "twsi6", "twsi6-3"),
 };
 
 static struct regulator_consumer_supply max8649_supply[] = {
@@ -197,9 +141,14 @@ static struct sram_platdata mmp2_isram_platdata = {
 
 static void __init brownstone_init(void)
 {
-	mfp_config(ARRAY_AND_SIZE(brownstone_pin_config));
+	int ret;
+
+	ret = pinmux_register_mappings(ARRAY_AND_SIZE(brownstone_pmx_map));
+	if (ret < 0)
+		goto out;
 
 	/* on-chip devices */
+	mmp2_add_pinmux();
 	mmp2_add_uart(1);
 	mmp2_add_uart(3);
 	platform_device_register(&mmp2_device_gpio);
@@ -211,6 +160,9 @@ static void __init brownstone_init(void)
 
 	/* enable 5v regulator */
 	platform_device_register(&brownstone_v_5vp_device);
+	return;
+out:
+	BUG();
 }
 
 MACHINE_START(BROWNSTONE, "Brownstone Development Platform")
diff --git a/arch/arm/mach-mmp/include/mach/mmp2.h b/arch/arm/mach-mmp/include/mach/mmp2.h
index cba22fe..266c9d2 100644
--- a/arch/arm/mach-mmp/include/mach/mmp2.h
+++ b/arch/arm/mach-mmp/include/mach/mmp2.h
@@ -31,6 +31,7 @@ extern struct pxa_device_desc mmp2_device_sdh2;
 extern struct pxa_device_desc mmp2_device_sdh3;
 extern struct pxa_device_desc mmp2_device_asram;
 extern struct pxa_device_desc mmp2_device_isram;
+extern struct pxa_device_desc mmp2_device_pinmux;
 
 extern struct platform_device mmp2_device_gpio;
 
@@ -100,5 +101,9 @@ static inline int mmp2_add_isram(struct sram_platdata *data)
 	return pxa_register_device(&mmp2_device_isram, data, sizeof(*data));
 }
 
+static inline int mmp2_add_pinmux(void)
+{
+	return pxa_register_device(&mmp2_device_pinmux, NULL, 0);
+}
 #endif /* __ASM_MACH_MMP2_H */
 
diff --git a/arch/arm/mach-mmp/include/mach/pxa168.h b/arch/arm/mach-mmp/include/mach/pxa168.h
index dc03d58..edcedd2 100644
--- a/arch/arm/mach-mmp/include/mach/pxa168.h
+++ b/arch/arm/mach-mmp/include/mach/pxa168.h
@@ -35,6 +35,7 @@ extern struct pxa_device_desc pxa168_device_nand;
 extern struct pxa_device_desc pxa168_device_fb;
 extern struct pxa_device_desc pxa168_device_keypad;
 extern struct pxa_device_desc pxa168_device_eth;
+extern struct pxa_device_desc pxa168_device_pinmux;
 
 struct pxa168_usb_pdata {
 	/* If NULL, default phy init routine for PXA168 would be called */
@@ -135,4 +136,9 @@ static inline int pxa168_add_eth(struct pxa168_eth_platform_data *data)
 {
 	return pxa_register_device(&pxa168_device_eth, data, sizeof(*data));
 }
+
+static inline int pxa168_add_pinmux(void)
+{
+	return pxa_register_device(&pxa168_device_pinmux, NULL, 0);
+}
 #endif /* __ASM_MACH_PXA168_H */
diff --git a/arch/arm/mach-mmp/include/mach/pxa910.h b/arch/arm/mach-mmp/include/mach/pxa910.h
index 4de13ab..491c0a7 100644
--- a/arch/arm/mach-mmp/include/mach/pxa910.h
+++ b/arch/arm/mach-mmp/include/mach/pxa910.h
@@ -20,6 +20,7 @@ extern struct pxa_device_desc pxa910_device_pwm2;
 extern struct pxa_device_desc pxa910_device_pwm3;
 extern struct pxa_device_desc pxa910_device_pwm4;
 extern struct pxa_device_desc pxa910_device_nand;
+extern struct pxa_device_desc pxa910_device_pinmux;
 
 extern struct platform_device pxa910_device_gpio;
 
@@ -78,4 +79,9 @@ static inline int pxa910_add_nand(struct pxa3xx_nand_platform_data *info)
 {
 	return pxa_register_device(&pxa910_device_nand, info, sizeof(*info));
 }
+
+static inline int pxa910_add_pinmux(void)
+{
+	return pxa_register_device(&pxa910_device_pinmux, NULL, 0);
+}
 #endif /* __ASM_MACH_PXA910_H */
diff --git a/arch/arm/mach-mmp/mmp2.c b/arch/arm/mach-mmp/mmp2.c
index 617c60a..7c1e8f3 100644
--- a/arch/arm/mach-mmp/mmp2.c
+++ b/arch/arm/mach-mmp/mmp2.c
@@ -214,6 +214,7 @@ MMP2_DEVICE(sdh3, "sdhci-pxav3", 3, MMC4, 0xd4281800, 0x120);
 MMP2_DEVICE(asram, "asram", -1, NONE, 0xe0000000, 0x4000);
 /* 0xd1000000 ~ 0xd101ffff is reserved for secure processor */
 MMP2_DEVICE(isram, "isram", -1, NONE, 0xd1020000, 0x18000);
+MMP2_DEVICE(pinmux, "mmp2-pinmux", -1, NONE, 0xd401e000, 0x300);
 
 struct resource mmp2_resource_gpio[] = {
 	{
diff --git a/arch/arm/mach-mmp/pxa168.c b/arch/arm/mach-mmp/pxa168.c
index 7bc17ea..2d69bf9 100644
--- a/arch/arm/mach-mmp/pxa168.c
+++ b/arch/arm/mach-mmp/pxa168.c
@@ -158,6 +158,7 @@ PXA168_DEVICE(ssp5, "pxa168-ssp", 4, SSP5, 0xd4021000, 0x40, 60, 61);
 PXA168_DEVICE(fb, "pxa168-fb", -1, LCD, 0xd420b000, 0x1c8);
 PXA168_DEVICE(keypad, "pxa27x-keypad", -1, KEYPAD, 0xd4012000, 0x4c);
 PXA168_DEVICE(eth, "pxa168-eth", -1, MFU, 0xc0800000, 0x0fff);
+PXA168_DEVICE(pinmux, "pxa168-pinmux", -1, NONE, 0xd401e000, 0x300);
 
 struct resource pxa168_resource_gpio[] = {
 	{
diff --git a/arch/arm/mach-mmp/pxa910.c b/arch/arm/mach-mmp/pxa910.c
index 3241a25..75f1f3c 100644
--- a/arch/arm/mach-mmp/pxa910.c
+++ b/arch/arm/mach-mmp/pxa910.c
@@ -163,6 +163,7 @@ PXA910_DEVICE(pwm1, "pxa910-pwm", 0, NONE, 0xd401a000, 0x10);
 PXA910_DEVICE(pwm2, "pxa910-pwm", 1, NONE, 0xd401a400, 0x10);
 PXA910_DEVICE(pwm3, "pxa910-pwm", 2, NONE, 0xd401a800, 0x10);
 PXA910_DEVICE(pwm4, "pxa910-pwm", 3, NONE, 0xd401ac00, 0x10);
+PXA910_DEVICE(pinmux, "pxa910-pinmux", -1, NONE, 0xd401e000, 0x300);
 PXA910_DEVICE(nand, "pxa3xx-nand", -1, NAND, 0xd4283000, 0x80, 97, 99);
 
 struct resource pxa910_resource_gpio[] = {
@@ -173,6 +174,7 @@ struct resource pxa910_resource_gpio[] = {
 	}, {
 		.start	= IRQ_PXA910_AP_GPIO,
 		.end	= IRQ_PXA910_AP_GPIO,
+		.name	= "gpio_mux",
 		.flags	= IORESOURCE_IRQ,
 	},
 };
diff --git a/arch/arm/mach-mmp/ttc_dkb.c b/arch/arm/mach-mmp/ttc_dkb.c
index 5ac5d58..a652ab4 100644
--- a/arch/arm/mach-mmp/ttc_dkb.c
+++ b/arch/arm/mach-mmp/ttc_dkb.c
@@ -17,12 +17,12 @@
 #include <linux/interrupt.h>
 #include <linux/i2c/pca953x.h>
 #include <linux/gpio.h>
+#include <linux/pinctrl/machine.h>
 
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
 #include <asm/mach/flash.h>
 #include <mach/addr-map.h>
-#include <mach/mfp-pxa910.h>
 #include <mach/pxa910.h>
 #include <mach/irqs.h>
 
@@ -39,35 +39,21 @@
  * 24 board interrupts -- 88PM860x PMIC
  */
 #define TTCDKB_NR_IRQS		(IRQ_BOARD_START + 16 + 16 + 24)
-
-static unsigned long ttc_dkb_pin_config[] __initdata = {
-	/* UART2 */
-	GPIO47_UART2_RXD,
-	GPIO48_UART2_TXD,
-
-	/* DFI */
-	DF_IO0_ND_IO0,
-	DF_IO1_ND_IO1,
-	DF_IO2_ND_IO2,
-	DF_IO3_ND_IO3,
-	DF_IO4_ND_IO4,
-	DF_IO5_ND_IO5,
-	DF_IO6_ND_IO6,
-	DF_IO7_ND_IO7,
-	DF_IO8_ND_IO8,
-	DF_IO9_ND_IO9,
-	DF_IO10_ND_IO10,
-	DF_IO11_ND_IO11,
-	DF_IO12_ND_IO12,
-	DF_IO13_ND_IO13,
-	DF_IO14_ND_IO14,
-	DF_IO15_ND_IO15,
-	DF_nCS0_SM_nCS2_nCS0,
-	DF_ALE_SM_WEn_ND_ALE,
-	DF_CLE_SM_OEn_ND_CLE,
-	DF_WEn_DF_WEn,
-	DF_REn_DF_REn,
-	DF_RDY0_DF_RDY0,
+#define P910_CTRL		"pxa910-pinmux"
+
+static struct pinmux_map dkb_pmx_map[] = {
+	PINMUX_MAP_SYS_HOG("UART0", P910_CTRL, "uart0"),
+	PINMUX_MAP_SYS_HOG("GSSP", P910_CTRL, "gssp"),
+	PINMUX_MAP_SYS_HOG("MMC1", P910_CTRL, "mmc1"),
+	PINMUX_MAP_SYS_HOG("MMC2", P910_CTRL, "mmc2"),
+	PINMUX_MAP_SYS_HOG("CAMERA", P910_CTRL, "ccic"),
+	PINMUX_MAP_SYS_HOG("LCD", P910_CTRL, "lcd"),
+	PINMUX_MAP_SYS_HOG_GROUP("UART1", P910_CTRL, "uart1", "uart1 2p1"),
+	PINMUX_MAP_SYS_HOG_GROUP("UART2", P910_CTRL, "uart2", "uart2 2p1"),
+	PINMUX_MAP_SYS_HOG_GROUP("TWSI", P910_CTRL, "twsi", "twsi 2p2"),
+	PINMUX_MAP_SYS_HOG_GROUP("I2S", P910_CTRL, "ssp1", "ssp1 4p1"),
+	PINMUX_MAP_SYS_HOG_GROUP("KPMK", P910_CTRL, "kpmk", "kpmk 11p2"),
+	PINMUX_MAP_SYS_HOG_GROUP("LCDSPI", P910_CTRL, "spi", "spi 4p1"),
 };
 
 static struct mtd_partition ttc_dkb_onenand_partitions[] = {
@@ -145,14 +131,22 @@ static struct i2c_board_info ttc_dkb_i2c_info[] = {
 
 static void __init ttc_dkb_init(void)
 {
-	mfp_config(ARRAY_AND_SIZE(ttc_dkb_pin_config));
+	int ret;
+
+	ret = pinmux_register_mappings(ARRAY_AND_SIZE(dkb_pmx_map));
+	if (ret < 0)
+		goto out;
 
 	/* on-chip devices */
+	pxa910_add_pinmux();
 	pxa910_add_uart(1);
 
 	/* off-chip devices */
 	pxa910_add_twsi(0, NULL, ARRAY_AND_SIZE(ttc_dkb_i2c_info));
 	platform_add_devices(ARRAY_AND_SIZE(ttc_dkb_devices));
+	return;
+out:
+	BUG();
 }
 
 MACHINE_START(TTC_DKB, "PXA910-based TTC_DKB Development Platform")
-- 
1.7.0.4

