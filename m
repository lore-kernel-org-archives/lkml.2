Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754017Ab1LMJio (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 04:38:44 -0500
Received: from na3sys009aog104.obsmtp.com ([74.125.149.73]:56724 "HELO
	na3sys009aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750820Ab1LMJij (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 04:38:39 -0500
From: Haojian Zhuang <haojian.zhuang@marvell.com>
To: linus.walleij@linaro.org, swarren@nvidia.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, eric.y.miao@gmail.com,
        linux@arm.linux.org.uk, arnd@arndb.de
Cc: Haojian Zhuang <haojian.zhuang@marvell.com>
Subject: [PATCH V2 2/2] ARM: mmp: enable pinmux in platform driver
Date: Tue, 13 Dec 2011 17:40:53 +0800
Message-Id: <1323769253-22580-3-git-send-email-haojian.zhuang@marvell.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1323769253-22580-1-git-send-email-haojian.zhuang@marvell.com>
References: <1323769253-22580-1-git-send-email-haojian.zhuang@marvell.com>
X-OriginalArrivalTime: 13 Dec 2011 09:38:12.0745 (UTC) FILETIME=[EE9F0790:01CCB97A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Only enable pinmux in brownstone/aspenite/ttc dkb.

Signed-off-by: Haojian Zhuang <haojian.zhuang@marvell.com>
---
 arch/arm/mach-mmp/Kconfig               |    6 ++
 arch/arm/mach-mmp/aspenite.c            |   94 ++++---------------------
 arch/arm/mach-mmp/brownstone.c          |  118 ++++++++++++-------------------
 arch/arm/mach-mmp/include/mach/mmp2.h   |    5 ++
 arch/arm/mach-mmp/include/mach/pxa168.h |    6 ++
 arch/arm/mach-mmp/include/mach/pxa910.h |    6 ++
 arch/arm/mach-mmp/mmp2.c                |    1 +
 arch/arm/mach-mmp/pxa168.c              |    1 +
 arch/arm/mach-mmp/pxa910.c              |    1 +
 arch/arm/mach-mmp/ttc_dkb.c             |   50 +++++--------
 10 files changed, 106 insertions(+), 182 deletions(-)

diff --git a/arch/arm/mach-mmp/Kconfig b/arch/arm/mach-mmp/Kconfig
index 323d4c9..e8499df 100644
--- a/arch/arm/mach-mmp/Kconfig
+++ b/arch/arm/mach-mmp/Kconfig
@@ -89,18 +89,24 @@ endmenu
 config CPU_PXA168
 	bool
 	select CPU_MOHAWK
+	select PINCTRL
+	select PINMUX_PXA168
 	help
 	  Select code specific to PXA168
 
 config CPU_PXA910
 	bool
 	select CPU_MOHAWK
+	select PINCTRL
+	select PINMUX_PXA910
 	help
 	  Select code specific to PXA910
 
 config CPU_MMP2
 	bool
 	select CPU_PJ4
+	select PINCTRL
+	select PINMUX_PXA910
 	help
 	  Select code specific to MMP2. MMP2 is ARMv7 compatible.
 endif
diff --git a/arch/arm/mach-mmp/aspenite.c b/arch/arm/mach-mmp/aspenite.c
index 7a60bbb..a6da47d 100644
--- a/arch/arm/mach-mmp/aspenite.c
+++ b/arch/arm/mach-mmp/aspenite.c
@@ -18,11 +18,11 @@
 #include <linux/mtd/nand.h>
 #include <linux/interrupt.h>
 #include <linux/gpio.h>
+#include <linux/pinctrl/machine.h>
 
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
 #include <mach/addr-map.h>
-#include <mach/mfp-pxa168.h>
 #include <mach/pxa168.h>
 #include <video/pxa168fb.h>
 #include <linux/input.h>
@@ -30,83 +30,11 @@
 
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
+static struct pinmux_map common_pmx_map[] = {
+	PINMUX_MAP_SYS_HOG("uart1", "pxa168-pinmux", "uart1"),
+	PINMUX_MAP_SYS_HOG("ssp1", "pxa168-pinmux", "ssp1"),
+	PINMUX_MAP_SYS_HOG("lcd", "pxa168-pinmux", "lcd"),
+	PINMUX_MAP_SYS_HOG("key", "pxa168-pinmux", "key"),
 };
 
 static struct smc91x_platdata smc91x_info = {
@@ -223,9 +151,14 @@ static struct pxa27x_keypad_platform_data aspenite_keypad_info __initdata = {
 
 static void __init common_init(void)
 {
-	mfp_config(ARRAY_AND_SIZE(common_pin_config));
+	int ret;
+
+	ret = pinmux_register_mappings(ARRAY_AND_SIZE(common_pmx_map));
+	if (ret < 0)
+		goto out;
 
 	/* on-chip devices */
+	pxa168_add_pinmux();
 	pxa168_add_uart(1);
 	pxa168_add_twsi(1, NULL, ARRAY_AND_SIZE(aspenite_i2c_info));
 	pxa168_add_ssp(1);
@@ -235,6 +168,9 @@ static void __init common_init(void)
 
 	/* off-chip devices */
 	platform_device_register(&smc91x_device);
+	return;
+out:
+	BUG();
 }
 
 MACHINE_START(ASPENITE, "PXA168-based Aspenite Development Platform")
diff --git a/arch/arm/mach-mmp/brownstone.c b/arch/arm/mach-mmp/brownstone.c
index 983cfb1..9abee93 100644
--- a/arch/arm/mach-mmp/brownstone.c
+++ b/arch/arm/mach-mmp/brownstone.c
@@ -14,15 +14,15 @@
 #include <linux/kernel.h>
 #include <linux/platform_device.h>
 #include <linux/io.h>
+#include <linux/mfd/max8925.h>
+#include <linux/pinctrl/machine.h>
 #include <linux/regulator/machine.h>
 #include <linux/regulator/max8649.h>
 #include <linux/regulator/fixed.h>
-#include <linux/mfd/max8925.h>
 
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
 #include <mach/addr-map.h>
-#include <mach/mfp-mmp2.h>
 #include <mach/mmp2.h>
 #include <mach/irqs.h>
 
@@ -32,76 +32,40 @@
 
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
+	{
+		.name = "dkin",
+		.ctrl_dev_name = "mmp2-pinmux",
+		.function = "dkin",
+		.group = "dkin-2-pin",
+		.hog_on_boot = true,
+	}, {
+		.name = "uart1",
+		.ctrl_dev_name = "mmp2-pinmux",
+		.function = "uart1",
+		.group = "uart1-4-pin",
+		.hog_on_boot = true,
+	}, {
+		.name = "uart2",
+		.ctrl_dev_name = "mmp2-pinmux",
+		.function = "uart2",
+		.group = "uart2-4-pin",
+		.hog_on_boot = true,
+	},
+	PINMUX_MAP_SYS_HOG("uart3", "mmp2-pinmux", "uart3"),
+	PINMUX_MAP_SYS_HOG("twsi2", "mmp2-pinmux", "twsi2"),
+	PINMUX_MAP_SYS_HOG("twsi3", "mmp2-pinmux", "twsi3"),
+	PINMUX_MAP_SYS_HOG("twsi5", "mmp2-pinmux", "twsi5"),
+	PINMUX_MAP_SYS_HOG("twsi6", "mmp2-pinmux", "twsi6"),
+	PINMUX_MAP_SYS_HOG("sspa1", "mmp2-pinmux", "sspa1"),
+	PINMUX_MAP_SYS_HOG("sspa2", "mmp2-pinmux", "sspa2"),
+	PINMUX_MAP_SYS_HOG("ssp3", "mmp2-pinmux", "ssp3"),
+	PINMUX_MAP_SYS_HOG("mmc1", "mmp2-pinmux", "mmc1"),
+	PINMUX_MAP_SYS_HOG("mmc2", "mmp2-pinmux", "mmc2"),
+	PINMUX_MAP_SYS_HOG("mmc3", "mmp2-pinmux", "mmc3"),
+	PINMUX_MAP_SYS_HOG("pwm3", "mmp2-pinmux", "pwm3"),
+	PINMUX_MAP_SYS_HOG("hdmi", "mmp2-pinmux", "hdmi"),
+	PINMUX_MAP_SYS_HOG("pmic", "mmp2-pinmux", "pmic"),
 };
 
 static struct regulator_consumer_supply max8649_supply[] = {
@@ -197,9 +161,14 @@ static struct sram_platdata mmp2_isram_platdata = {
 
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
 	mmp2_add_twsi(1, NULL, ARRAY_AND_SIZE(brownstone_twsi1_info));
@@ -210,6 +179,9 @@ static void __init brownstone_init(void)
 
 	/* enable 5v regulator */
 	platform_device_register(&brownstone_v_5vp_device);
+	return;
+out:
+	BUG();
 }
 
 MACHINE_START(BROWNSTONE, "Brownstone Development Platform")
diff --git a/arch/arm/mach-mmp/include/mach/mmp2.h b/arch/arm/mach-mmp/include/mach/mmp2.h
index 2f7b2d3..1132f9d 100644
--- a/arch/arm/mach-mmp/include/mach/mmp2.h
+++ b/arch/arm/mach-mmp/include/mach/mmp2.h
@@ -31,6 +31,7 @@ extern struct pxa_device_desc mmp2_device_sdh2;
 extern struct pxa_device_desc mmp2_device_sdh3;
 extern struct pxa_device_desc mmp2_device_asram;
 extern struct pxa_device_desc mmp2_device_isram;
+extern struct pxa_device_desc mmp2_device_pinmux;
 
 static inline int mmp2_add_uart(int id)
 {
@@ -98,5 +99,9 @@ static inline int mmp2_add_isram(struct sram_platdata *data)
 	return pxa_register_device(&mmp2_device_isram, data, sizeof(*data));
 }
 
+static inline int mmp2_add_pinmux(void)
+{
+	return pxa_register_device(&mmp2_device_pinmux, NULL, 0);
+}
 #endif /* __ASM_MACH_MMP2_H */
 
diff --git a/arch/arm/mach-mmp/include/mach/pxa168.h b/arch/arm/mach-mmp/include/mach/pxa168.h
index 7fb568d..db9dfb9 100644
--- a/arch/arm/mach-mmp/include/mach/pxa168.h
+++ b/arch/arm/mach-mmp/include/mach/pxa168.h
@@ -34,6 +34,7 @@ extern struct pxa_device_desc pxa168_device_nand;
 extern struct pxa_device_desc pxa168_device_fb;
 extern struct pxa_device_desc pxa168_device_keypad;
 extern struct pxa_device_desc pxa168_device_eth;
+extern struct pxa_device_desc pxa168_device_pinmux;
 
 struct pxa168_usb_pdata {
 	/* If NULL, default phy init routine for PXA168 would be called */
@@ -132,4 +133,9 @@ static inline int pxa168_add_eth(struct pxa168_eth_platform_data *data)
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
index 91be755..ecdb411 100644
--- a/arch/arm/mach-mmp/include/mach/pxa910.h
+++ b/arch/arm/mach-mmp/include/mach/pxa910.h
@@ -20,6 +20,7 @@ extern struct pxa_device_desc pxa910_device_pwm2;
 extern struct pxa_device_desc pxa910_device_pwm3;
 extern struct pxa_device_desc pxa910_device_pwm4;
 extern struct pxa_device_desc pxa910_device_nand;
+extern struct pxa_device_desc pxa910_device_pinmux;
 
 static inline int pxa910_add_uart(int id)
 {
@@ -76,4 +77,9 @@ static inline int pxa910_add_nand(struct pxa3xx_nand_platform_data *info)
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
index 5dd1d4a..73dc560 100644
--- a/arch/arm/mach-mmp/mmp2.c
+++ b/arch/arm/mach-mmp/mmp2.c
@@ -226,6 +226,7 @@ MMP2_DEVICE(sdh0, "sdhci-pxav3", 0, MMC, 0xd4280000, 0x120);
 MMP2_DEVICE(sdh1, "sdhci-pxav3", 1, MMC2, 0xd4280800, 0x120);
 MMP2_DEVICE(sdh2, "sdhci-pxav3", 2, MMC3, 0xd4281000, 0x120);
 MMP2_DEVICE(sdh3, "sdhci-pxav3", 3, MMC4, 0xd4281800, 0x120);
+MMP2_DEVICE(pinmux, "mmp2-pinmux", -1, NONE, 0xd401e000, 0x300);
 MMP2_DEVICE(asram, "asram", -1, NONE, 0xe0000000, 0x4000);
 /* 0xd1000000 ~ 0xd101ffff is reserved for secure processor */
 MMP2_DEVICE(isram, "isram", -1, NONE, 0xd1020000, 0x18000);
diff --git a/arch/arm/mach-mmp/pxa168.c b/arch/arm/mach-mmp/pxa168.c
index 76ca15c..e08f77c 100644
--- a/arch/arm/mach-mmp/pxa168.c
+++ b/arch/arm/mach-mmp/pxa168.c
@@ -173,6 +173,7 @@ PXA168_DEVICE(ssp5, "pxa168-ssp", 4, SSP5, 0xd4021000, 0x40, 60, 61);
 PXA168_DEVICE(fb, "pxa168-fb", -1, LCD, 0xd420b000, 0x1c8);
 PXA168_DEVICE(keypad, "pxa27x-keypad", -1, KEYPAD, 0xd4012000, 0x4c);
 PXA168_DEVICE(eth, "pxa168-eth", -1, MFU, 0xc0800000, 0x0fff);
+PXA168_DEVICE(pinmux, "pxa168-pinmux", -1, NONE, 0xd401e000, 0x300);
 
 struct resource pxa168_usb_host_resources[] = {
 	/* USB Host conroller register base */
diff --git a/arch/arm/mach-mmp/pxa910.c b/arch/arm/mach-mmp/pxa910.c
index 4ebbfbb..67769e9 100644
--- a/arch/arm/mach-mmp/pxa910.c
+++ b/arch/arm/mach-mmp/pxa910.c
@@ -178,4 +178,5 @@ PXA910_DEVICE(pwm1, "pxa910-pwm", 0, NONE, 0xd401a000, 0x10);
 PXA910_DEVICE(pwm2, "pxa910-pwm", 1, NONE, 0xd401a400, 0x10);
 PXA910_DEVICE(pwm3, "pxa910-pwm", 2, NONE, 0xd401a800, 0x10);
 PXA910_DEVICE(pwm4, "pxa910-pwm", 3, NONE, 0xd401ac00, 0x10);
+PXA910_DEVICE(pinmux, "pxa910-pinmux", -1, NONE, 0xd401e000, 0x300);
 PXA910_DEVICE(nand, "pxa3xx-nand", -1, NAND, 0xd4283000, 0x80, 97, 99);
diff --git a/arch/arm/mach-mmp/ttc_dkb.c b/arch/arm/mach-mmp/ttc_dkb.c
index 176515a..fa421d0 100644
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
 
 #include "common.h"
@@ -39,34 +39,16 @@
  */
 #define TTCDKB_NR_IRQS		(IRQ_BOARD_START + 16 + 16 + 24)
 
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
+static struct pinmux_map pxa910_pmx_map[] = {
+	PINMUX_MAP_SYS_HOG("uart0", "pxa910-pinmux", "uart0"),
+	PINMUX_MAP_SYS_HOG("uart1", "pxa910-pinmux", "uart1"),
+	PINMUX_MAP_SYS_HOG("uart2", "pxa910-pinmux", "uart2"),
+	PINMUX_MAP_SYS_HOG("twsi", "pxa910-pinmux", "twsi"),
+	PINMUX_MAP_SYS_HOG("ssp1", "pxa910-pinmux", "ssp1"),
+	PINMUX_MAP_SYS_HOG("gssp", "pxa910-pinmux", "gssp"),
+	PINMUX_MAP_SYS_HOG("mmc1", "pxa910-pinmux", "mmc1"),
+	PINMUX_MAP_SYS_HOG("mmc2", "pxa910-pinmux", "mmc2"),
+	PINMUX_MAP_SYS_HOG("kp", "pxa910-pinmux", "kp"),
 };
 
 static struct mtd_partition ttc_dkb_onenand_partitions[] = {
@@ -143,14 +125,22 @@ static struct i2c_board_info ttc_dkb_i2c_info[] = {
 
 static void __init ttc_dkb_init(void)
 {
-	mfp_config(ARRAY_AND_SIZE(ttc_dkb_pin_config));
+	int ret;
+
+	ret = pinmux_register_mappings(ARRAY_AND_SIZE(pxa910_pmx_map));
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

