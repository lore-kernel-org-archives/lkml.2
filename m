Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760038Ab1EOLgW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 May 2011 07:36:22 -0400
Received: from londo.lunn.ch ([80.238.139.98]:59525 "EHLO londo.lunn.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759980Ab1EOLgS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 May 2011 07:36:18 -0400
From: Andrew Lunn <andrew@lunn.ch>
To: kernel@wantstofly.org, nico@fluxnic.net
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        saeed.bishara@gmail.com, Andrew Lunn <andrew@lunn.ch>
Subject: [PATCHv2 15/15] [dove] Consolidate mpp code with platform mpp.
Date: Sun, 15 May 2011 13:32:54 +0200
Message-Id: <1305459174-25517-16-git-send-email-andrew@lunn.ch>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1305459174-25517-1-git-send-email-andrew@lunn.ch>
References: <1305459174-25517-1-git-send-email-andrew@lunn.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 arch/arm/mach-dove/mpp.c  |  134 ++++++-----------
 arch/arm/mach-dove/mpp.h  |  362 +++++++++++++++++++++------------------------
 arch/arm/plat-orion/mpp.c |    5 +-
 3 files changed, 213 insertions(+), 288 deletions(-)

diff --git a/arch/arm/mach-dove/mpp.c b/arch/arm/mach-dove/mpp.c
index c66c763..51e0e41 100644
--- a/arch/arm/mach-dove/mpp.c
+++ b/arch/arm/mach-dove/mpp.c
@@ -11,24 +11,17 @@
 #include <linux/kernel.h>
 #include <linux/gpio.h>
 #include <linux/io.h>
-
+#include <plat/mpp.h>
 #include <mach/dove.h>
-
 #include "mpp.h"
 
-#define MPP_NR_REGS 4
-#define MPP_CTRL(i)	((i) == 3 ?				\
-			 DOVE_MPP_CTRL4_VIRT_BASE :		\
-			 DOVE_MPP_VIRT_BASE + (i) * 4)
-#define PMU_SIG_REGS 2
-#define PMU_SIG_CTRL(i)	(DOVE_PMU_SIG_CTRL + (i) * 4)
-
 struct dove_mpp_grp {
 	int start;
 	int end;
 };
 
-static struct dove_mpp_grp dove_mpp_grp[] = {
+/* Map a group to a range of GPIO pins in that group */
+static const struct dove_mpp_grp dove_mpp_grp[] = {
 	[MPP_24_39] = {
 		.start	= 24,
 		.end	= 39,
@@ -38,8 +31,8 @@ static struct dove_mpp_grp dove_mpp_grp[] = {
 		.end	= 45,
 	},
 	[MPP_46_51] = {
-		.start	= 40,
-		.end	= 45,
+		.start	= 46,
+		.end	= 51,
 	},
 	[MPP_58_61] = {
 		.start	= 58,
@@ -51,6 +44,8 @@ static struct dove_mpp_grp dove_mpp_grp[] = {
 	},
 };
 
+/* Enable gpio for a range of pins. mode should be a combination of
+   GPIO_OUTPUT_OK | GPIO_INPUT_OK */
 static void dove_mpp_gpio_mode(int start, int end, int gpio_mode)
 {
 	int i;
@@ -59,24 +54,17 @@ static void dove_mpp_gpio_mode(int start, int end, int gpio_mode)
 		orion_gpio_set_valid(i, gpio_mode);
 }
 
+/* Dump all the extra MPP registers. The platform code will dump the
+   registers for pins 0-23. */
 static void dove_mpp_dump_regs(void)
 {
-#ifdef DEBUG
-	int i;
+	pr_debug("PMU_CTRL4_CTRL: %08x\n",
+		 readl(DOVE_MPP_CTRL4_VIRT_BASE));
 
-	pr_debug("MPP_CTRL regs:");
-	for (i = 0; i < MPP_NR_REGS; i++)
-		printk(" %08x", readl(MPP_CTRL(i)));
-	printk("\n");
+	pr_debug("PMU_MPP_GENERAL_CTRL: %08x\n",
+		 readl(DOVE_PMU_MPP_GENERAL_CTRL));
 
-	pr_debug("PMU_SIG_CTRL regs:");
-	for (i = 0; i < PMU_SIG_REGS; i++)
-		printk(" %08x", readl(PMU_SIG_CTRL(i)));
-	printk("\n");
-
-	pr_debug("PMU_MPP_GENERAL_CTRL: %08x\n", readl(DOVE_PMU_MPP_GENERAL_CTRL));
 	pr_debug("MPP_GENERAL: %08x\n", readl(DOVE_MPP_GENERAL_VIRT_BASE));
-#endif
 }
 
 static void dove_mpp_cfg_nfc(int sel)
@@ -92,7 +80,7 @@ static void dove_mpp_cfg_nfc(int sel)
 
 static void dove_mpp_cfg_au1(int sel)
 {
-	u32 mpp_ctrl4		= readl(DOVE_MPP_CTRL4_VIRT_BASE);
+	u32 mpp_ctrl4 = readl(DOVE_MPP_CTRL4_VIRT_BASE);
 	u32 ssp_ctrl1 = readl(DOVE_SSP_CTRL_STATUS_1);
 	u32 mpp_gen_ctrl = readl(DOVE_MPP_GENERAL_VIRT_BASE);
 	u32 global_cfg_2 = readl(DOVE_GLOBAL_CONFIG_2);
@@ -128,82 +116,46 @@ static void dove_mpp_cfg_au1(int sel)
 	writel(global_cfg_2, DOVE_GLOBAL_CONFIG_2);
 }
 
-static void dove_mpp_conf_grp(int num, int sel, u32 *mpp_ctrl)
-{
-	int start = dove_mpp_grp[num].start;
-	int end = dove_mpp_grp[num].end;
-	int gpio_mode = sel ? GPIO_OUTPUT_OK | GPIO_INPUT_OK : 0;
-
-	*mpp_ctrl &= ~(0x1 << num);
-	*mpp_ctrl |= sel << num;
-
-	dove_mpp_gpio_mode(start, end, gpio_mode);
-}
-
-void __init dove_mpp_conf(unsigned int *mpp_list)
+/* Configure the group registers, enabling GPIO if sel indicates the
+   pin is to be used for GPIO */
+static void dove_mpp_conf_grp(unsigned int *mpp_grp_list)
 {
-	u32 mpp_ctrl[MPP_NR_REGS];
-	u32 pmu_mpp_ctrl = 0;
-	u32 pmu_sig_ctrl[PMU_SIG_REGS];
-	int i;
-
-	for (i = 0; i < MPP_NR_REGS; i++)
-		mpp_ctrl[i] = readl(MPP_CTRL(i));
-
-	for (i = 0; i < PMU_SIG_REGS; i++)
-		pmu_sig_ctrl[i] = readl(PMU_SIG_CTRL(i));
-
-	pmu_mpp_ctrl = readl(DOVE_PMU_MPP_GENERAL_CTRL);
+	u32 mpp_ctrl4 = readl(DOVE_MPP_CTRL4_VIRT_BASE);
+	int gpio_mode;
 
-	dove_mpp_dump_regs();
-
-	for ( ; *mpp_list != MPP_END; mpp_list++) {
-		unsigned int num = MPP_NUM(*mpp_list);
-		unsigned int sel = MPP_SEL(*mpp_list);
-		int shift, gpio_mode;
-
-		if (num > MPP_MAX) {
-			pr_err("dove: invalid MPP number (%u)\n", num);
-			continue;
-		}
-
-		if (*mpp_list & MPP_NFC_MASK) {
-			dove_mpp_cfg_nfc(sel);
-			continue;
-		}
+	for ( ; *mpp_grp_list; mpp_grp_list++) {
+		unsigned int num = MPP_NUM(*mpp_grp_list);
+		unsigned int sel = MPP_SEL(*mpp_grp_list);
 
-		if (*mpp_list & MPP_AU1_MASK) {
-			dove_mpp_cfg_au1(sel);
+		if (num > MPP_GRP_MAX) {
+			pr_err("dove: invalid MPP GRP number (%u)\n", num);
 			continue;
 		}
 
-		if (*mpp_list & MPP_GRP_MASK) {
-			dove_mpp_conf_grp(num, sel, &mpp_ctrl[3]);
-			continue;
-		}
-
-		shift = (num & 7) << 2;
-		if (*mpp_list & MPP_PMU_MASK) {
-			pmu_mpp_ctrl |= (0x1 << num);
-			pmu_sig_ctrl[num / 8] &= ~(0xf << shift);
-			pmu_sig_ctrl[num / 8] |= 0xf << shift;
-			gpio_mode = 0;
-		} else {
-			mpp_ctrl[num / 8] &= ~(0xf << shift);
-			mpp_ctrl[num / 8] |= sel << shift;
-			gpio_mode = GPIO_OUTPUT_OK | GPIO_INPUT_OK;
-		}
+		mpp_ctrl4 &= ~(0x1 << num);
+		mpp_ctrl4 |= sel << num;
 
-		orion_gpio_set_valid(num, gpio_mode);
+		gpio_mode = sel ? GPIO_OUTPUT_OK | GPIO_INPUT_OK : 0;
+		dove_mpp_gpio_mode(dove_mpp_grp[num].start,
+				   dove_mpp_grp[num].end, gpio_mode);
 	}
+	writel(mpp_ctrl4, DOVE_MPP_CTRL4_VIRT_BASE);
+}
 
-	for (i = 0; i < MPP_NR_REGS; i++)
-		writel(mpp_ctrl[i], MPP_CTRL(i));
+/* Configure the various MPP pins on Dove */
+void __init dove_mpp_conf(unsigned int *mpp_list,
+			  unsigned int *mpp_grp_list,
+			  unsigned int grp_au1_52_57,
+			  unsigned int grp_nfc_64_71)
+{
+	dove_mpp_dump_regs();
 
-	for (i = 0; i < PMU_SIG_REGS; i++)
-		writel(pmu_sig_ctrl[i], PMU_SIG_CTRL(i));
+	/* Use platform code for pins 0-23 */
+	orion_mpp_conf(mpp_list, 0, MPP_MAX, DOVE_MPP_VIRT_BASE);
 
-	writel(pmu_mpp_ctrl, DOVE_PMU_MPP_GENERAL_CTRL);
+	dove_mpp_conf_grp(mpp_grp_list);
+	dove_mpp_cfg_au1(grp_au1_52_57);
+	dove_mpp_cfg_nfc(grp_nfc_64_71);
 
 	dove_mpp_dump_regs();
 }
diff --git a/arch/arm/mach-dove/mpp.h b/arch/arm/mach-dove/mpp.h
index 2a43ce4..fbec7c5 100644
--- a/arch/arm/mach-dove/mpp.h
+++ b/arch/arm/mach-dove/mpp.h
@@ -1,178 +1,150 @@
 #ifndef __ARCH_DOVE_MPP_CODED_H
 #define __ARCH_DOVE_MPP_CODED_H
 
-#define MPP(_num, _mode, _pmu, _grp, _au1, _nfc) (	\
-/* MPP/group number */		((_num) & 0xff) |		\
-/* MPP select value */		(((_mode) & 0xf) << 8) |	\
-/* MPP PMU */			((!!(_pmu)) << 12) |		\
-/* group flag */		((!!(_grp)) << 13) |		\
-/* AU1 flag */			((!!(_au1)) << 14) |		\
-/* NFCE flag */			((!!(_nfc)) << 15))
-
-#define MPP_MAX	71
-
-#define MPP_NUM(x)    ((x) & 0xff)
-#define MPP_SEL(x)    (((x) >> 8) & 0xf)
-
-#define MPP_PMU_MASK		MPP(0, 0x0, 1, 0, 0, 0)
-#define MPP_GRP_MASK		MPP(0, 0x0, 0, 1, 0, 0)
-#define MPP_AU1_MASK		MPP(0, 0x0, 0, 0, 1, 0)
-#define MPP_NFC_MASK		MPP(0, 0x0, 0, 0, 0, 1)
-
-#define MPP_END			MPP(0xff, 0xf, 1, 1, 1, 1)
-
-#define MPP_PMU_DRIVE_0		0x1
-#define MPP_PMU_DRIVE_1		0x2
-#define MPP_PMU_SDI		0x3
-#define MPP_PMU_CPU_PWRDWN	0x4
-#define MPP_PMU_STBY_PWRDWN	0x5
-#define MPP_PMU_CORE_PWR_GOOD	0x8
-#define MPP_PMU_BAT_FAULT	0xa
-#define MPP_PMU_EXT0_WU		0xb
-#define MPP_PMU_EXT1_WU		0xc
-#define MPP_PMU_EXT2_WU		0xd
-#define MPP_PMU_BLINK		0xe
-#define MPP_PMU(_num, _mode)	MPP((_num), MPP_PMU_##_mode, 1, 0, 0, 0)
-
-#define MPP_PIN(_num, _mode)	MPP((_num), (_mode), 0, 0, 0, 0)
-#define MPP_GRP(_grp, _mode)	MPP((_grp), (_mode), 0, 1, 0, 0)
-#define MPP_GRP_AU1(_mode)	MPP(0, (_mode), 0, 0, 1, 0)
-#define MPP_GRP_NFC(_mode)	MPP(0, (_mode), 0, 0, 0, 1)
-
-#define MPP0_GPIO0		MPP_PIN(0, 0x0)
-#define MPP0_UA2_RTSn		MPP_PIN(0, 0x2)
-#define MPP0_SDIO0_CD		MPP_PIN(0, 0x3)
-#define MPP0_LCD0_PWM		MPP_PIN(0, 0xf)
-
-#define MPP1_GPIO1		MPP_PIN(1, 0x0)
-#define MPP1_UA2_CTSn		MPP_PIN(1, 0x2)
-#define MPP1_SDIO0_WP		MPP_PIN(1, 0x3)
-#define MPP1_LCD1_PWM		MPP_PIN(1, 0xf)
-
-#define MPP2_GPIO2		MPP_PIN(2, 0x0)
-#define MPP2_SATA_PRESENT	MPP_PIN(2, 0x1)
-#define MPP2_UA2_TXD		MPP_PIN(2, 0x2)
-#define MPP2_SDIO0_BUS_POWER	MPP_PIN(2, 0x3)
-#define MPP2_UA_RTSn1		MPP_PIN(2, 0x4)
-
-#define MPP3_GPIO3		MPP_PIN(3, 0x0)
-#define MPP3_SATA_ACT		MPP_PIN(3, 0x1)
-#define MPP3_UA2_RXD		MPP_PIN(3, 0x2)
-#define MPP3_SDIO0_LED_CTRL	MPP_PIN(3, 0x3)
-#define MPP3_UA_CTSn1		MPP_PIN(3, 0x4)
-#define MPP3_SPI_LCD_CS1	MPP_PIN(3, 0xf)
-
-#define MPP4_GPIO4		MPP_PIN(4, 0x0)
-#define MPP4_UA3_RTSn		MPP_PIN(4, 0x2)
-#define MPP4_SDIO1_CD		MPP_PIN(4, 0x3)
-#define MPP4_SPI_1_MISO		MPP_PIN(4, 0x4)
-
-#define MPP5_GPIO5		MPP_PIN(5, 0x0)
-#define MPP5_UA3_CTSn		MPP_PIN(5, 0x2)
-#define MPP5_SDIO1_WP		MPP_PIN(5, 0x3)
-#define MPP5_SPI_1_CS		MPP_PIN(5, 0x4)
-
-#define MPP6_GPIO6		MPP_PIN(6, 0x0)
-#define MPP6_UA3_TXD		MPP_PIN(6, 0x2)
-#define MPP6_SDIO1_BUS_POWER	MPP_PIN(6, 0x3)
-#define MPP6_SPI_1_MOSI		MPP_PIN(6, 0x4)
-
-#define MPP7_GPIO7		MPP_PIN(7, 0x0)
-#define MPP7_UA3_RXD		MPP_PIN(7, 0x2)
-#define MPP7_SDIO1_LED_CTRL	MPP_PIN(7, 0x3)
-#define MPP7_SPI_1_SCK		MPP_PIN(7, 0x4)
-
-#define MPP8_GPIO8		MPP_PIN(8, 0x0)
-#define MPP8_WD_RST_OUT		MPP_PIN(8, 0x1)
-
-#define MPP9_GPIO9		MPP_PIN(9, 0x0)
-#define MPP9_PEX1_CLKREQn	MPP_PIN(9, 0x5)
-
-#define MPP10_GPIO10		MPP_PIN(10, 0x0)
-#define MPP10_SSP_SCLK		MPP_PIN(10, 0x5)
-
-#define MPP11_GPIO11		MPP_PIN(11, 0x0)
-#define MPP11_SATA_PRESENT	MPP_PIN(11, 0x1)
-#define MPP11_SATA_ACT		MPP_PIN(11, 0x2)
-#define MPP11_SDIO0_LED_CTRL	MPP_PIN(11, 0x3)
-#define MPP11_SDIO1_LED_CTRL	MPP_PIN(11, 0x4)
-#define MPP11_PEX0_CLKREQn	MPP_PIN(11, 0x5)
-
-#define MPP12_GPIO12		MPP_PIN(12, 0x0)
-#define MPP12_SATA_ACT		MPP_PIN(12, 0x1)
-#define MPP12_UA2_RTSn		MPP_PIN(12, 0x2)
-#define MPP12_AD0_I2S_EXT_MCLK	MPP_PIN(12, 0x3)
-#define MPP12_SDIO1_CD		MPP_PIN(12, 0x4)
-
-#define MPP13_GPIO13		MPP_PIN(13, 0x0)
-#define MPP13_UA2_CTSn		MPP_PIN(13, 0x2)
-#define MPP13_AD1_I2S_EXT_MCLK	MPP_PIN(13, 0x3)
-#define MPP13_SDIO1WP		MPP_PIN(13, 0x4)
-#define MPP13_SSP_EXTCLK	MPP_PIN(13, 0x5)
-
-#define MPP14_GPIO14		MPP_PIN(14, 0x0)
-#define MPP14_UA2_TXD		MPP_PIN(14, 0x2)
-#define MPP14_SDIO1_BUS_POWER	MPP_PIN(14, 0x4)
-#define MPP14_SSP_RXD		MPP_PIN(14, 0x5)
-
-#define MPP15_GPIO15		MPP_PIN(15, 0x0)
-#define MPP15_UA2_RXD		MPP_PIN(15, 0x2)
-#define MPP15_SDIO1_LED_CTRL	MPP_PIN(15, 0x4)
-#define MPP15_SSP_SFRM		MPP_PIN(15, 0x5)
-
-#define MPP16_GPIO16		MPP_PIN(16, 0x0)
-#define MPP16_UA3_RTSn		MPP_PIN(16, 0x2)
-#define MPP16_SDIO0_CD		MPP_PIN(16, 0x3)
-#define MPP16_SPI_LCD_CS1	MPP_PIN(16, 0x4)
-#define MPP16_AC97_SDATA_IN1	MPP_PIN(16, 0x5)
-
-#define MPP17_GPIO17		MPP_PIN(17, 0x0)
-#define MPP17_AC97_SYSCLK_OUT	MPP_PIN(17, 0x1)
-#define MPP17_UA3_CTSn		MPP_PIN(17, 0x2)
-#define MPP17_SDIO0_WP		MPP_PIN(17, 0x3)
-#define MPP17_TW_SDA2		MPP_PIN(17, 0x4)
-#define MPP17_AC97_SDATA_IN2	MPP_PIN(17, 0x5)
-
-#define MPP18_GPIO18		MPP_PIN(18, 0x0)
-#define MPP18_UA3_TXD		MPP_PIN(18, 0x2)
-#define MPP18_SDIO0_BUS_POWER	MPP_PIN(18, 0x3)
-#define MPP18_LCD0_PWM		MPP_PIN(18, 0x4)
-#define MPP18_AC_SDATA_IN3	MPP_PIN(18, 0x5)
-
-#define MPP19_GPIO19		MPP_PIN(19, 0x0)
-#define MPP19_UA3_RXD		MPP_PIN(19, 0x2)
-#define MPP19_SDIO0_LED_CTRL	MPP_PIN(19, 0x3)
-#define MPP19_TW_SCK2		MPP_PIN(19, 0x4)
-
-#define MPP20_GPIO20		MPP_PIN(20, 0x0)
-#define MPP20_AC97_SYSCLK_OUT	MPP_PIN(20, 0x1)
-#define MPP20_SPI_LCD_MISO	MPP_PIN(20, 0x2)
-#define MPP20_SDIO1_CD		MPP_PIN(20, 0x3)
-#define MPP20_SDIO0_CD		MPP_PIN(20, 0x5)
-#define MPP20_SPI_1_MISO	MPP_PIN(20, 0x6)
-
-#define MPP21_GPIO21		MPP_PIN(21, 0x0)
-#define MPP21_UA1_RTSn		MPP_PIN(21, 0x1)
-#define MPP21_SPI_LCD_CS0	MPP_PIN(21, 0x2)
-#define MPP21_SDIO1_WP		MPP_PIN(21, 0x3)
-#define MPP21_SSP_SFRM		MPP_PIN(21, 0x4)
-#define MPP21_SDIO0_WP		MPP_PIN(21, 0x5)
-#define MPP21_SPI_1_CS		MPP_PIN(21, 0x6)
-
-#define MPP22_GPIO22		MPP_PIN(22, 0x0)
-#define MPP22_UA1_CTSn		MPP_PIN(22, 0x1)
-#define MPP22_SPI_LCD_MOSI	MPP_PIN(22, 0x2)
-#define MPP22_SDIO1_BUS_POWER	MPP_PIN(22, 0x3)
-#define MPP22_SSP_TXD		MPP_PIN(22, 0x4)
-#define MPP22_SDIO0_BUS_POWER	MPP_PIN(22, 0x5)
-#define MPP22_SPI_1_MOSI	MPP_PIN(22, 0x6)
-
-#define MPP23_GPIO23		MPP_PIN(23, 0x0)
-#define MPP23_SPI_LCD_SCK	MPP_PIN(23, 0x2)
-#define MPP23_SDIO1_LED_CTRL	MPP_PIN(23, 0x3)
-#define MPP23_SSP_SCLK		MPP_PIN(23, 0x4)
-#define MPP23_SDIO0_LED_CTRL	MPP_PIN(23, 0x5)
-#define MPP23_SPI_1_SCK		MPP_PIN(23, 0x6)
+#define MPP(_num, _sel, _in, _out) ( \
+	/* MPP number */		((_num) & 0xff) | \
+	/* MPP select value */		(((_sel) & 0xf) << 8) | \
+	/* may be input signal */	((!!(_in)) << 12) | \
+	/* may be output signal */	((!!(_out)) << 13))
+
+#define MPP0_GPIO0		MPP(0, 0x0, 1, 1)
+#define MPP0_UA2_RTSn		MPP(0, 0x2, 0, 0)
+#define MPP0_SDIO0_CD		MPP(0, 0x3, 0, 0)
+#define MPP0_LCD0_PWM		MPP(0, 0xf, 0, 0)
+
+#define MPP1_GPIO1		MPP(1, 0x0, 1, 1)
+#define MPP1_UA2_CTSn		MPP(1, 0x2, 0, 0)
+#define MPP1_SDIO0_WP		MPP(1, 0x3, 0, 0)
+#define MPP1_LCD1_PWM		MPP(1, 0xf, 0, 0)
+
+#define MPP2_GPIO2		MPP(2, 0x0, 1, 1)
+#define MPP2_SATA_PRESENT	MPP(2, 0x1, 0, 0)
+#define MPP2_UA2_TXD		MPP(2, 0x2, 0, 0)
+#define MPP2_SDIO0_BUS_POWER	MPP(2, 0x3, 0, 0)
+#define MPP2_UA_RTSn1		MPP(2, 0x4, 0, 0)
+
+#define MPP3_GPIO3		MPP(3, 0x0, 1, 1)
+#define MPP3_SATA_ACT		MPP(3, 0x1, 0, 0)
+#define MPP3_UA2_RXD		MPP(3, 0x2, 0, 0)
+#define MPP3_SDIO0_LED_CTRL	MPP(3, 0x3, 0, 0)
+#define MPP3_UA_CTSn1		MPP(3, 0x4, 0, 0)
+#define MPP3_SPI_LCD_CS1	MPP(3, 0xf, 0, 0)
+
+#define MPP4_GPIO4		MPP(4, 0x0, 1, 1)
+#define MPP4_UA3_RTSn		MPP(4, 0x2, 0, 0)
+#define MPP4_SDIO1_CD		MPP(4, 0x3, 0, 0)
+#define MPP4_SPI_1_MISO		MPP(4, 0x4, 0, 0)
+
+#define MPP5_GPIO5		MPP(5, 0x0, 1, 1)
+#define MPP5_UA3_CTSn		MPP(5, 0x2, 0, 0)
+#define MPP5_SDIO1_WP		MPP(5, 0x3, 0, 0)
+#define MPP5_SPI_1_CS		MPP(5, 0x4, 0, 0)
+
+#define MPP6_GPIO6		MPP(6, 0x0, 1, 1)
+#define MPP6_UA3_TXD		MPP(6, 0x2, 0, 0)
+#define MPP6_SDIO1_BUS_POWER	MPP(6, 0x3, 0, 0)
+#define MPP6_SPI_1_MOSI		MPP(6, 0x4, 0, 0)
+
+#define MPP7_GPIO7		MPP(7, 0x0, 1, 1)
+#define MPP7_UA3_RXD		MPP(7, 0x2, 0, 0)
+#define MPP7_SDIO1_LED_CTRL	MPP(7, 0x3, 0, 0)
+#define MPP7_SPI_1_SCK		MPP(7, 0x4, 0, 0)
+
+#define MPP8_GPIO8		MPP(8, 0x0, 1, 1)
+#define MPP8_WD_RST_OUT		MPP(8, 0x1, 0, 0)
+
+#define MPP9_GPIO9		MPP(9, 0x0, 1, 1)
+#define MPP9_PEX1_CLKREQn	MPP(9, 0x5, 0, 0)
+
+#define MPP10_GPIO10		MPP(10, 0x0, 1, 1)
+#define MPP10_SSP_SCLK		MPP(10, 0x5, 0, 0)
+
+#define MPP11_GPIO11		MPP(11, 0x0, 1, 1)
+#define MPP11_SATA_PRESENT	MPP(11, 0x1, 0, 0)
+#define MPP11_SATA_ACT		MPP(11, 0x2, 0, 0)
+#define MPP11_SDIO0_LED_CTRL	MPP(11, 0x3, 0, 0)
+#define MPP11_SDIO1_LED_CTRL	MPP(11, 0x4, 0, 0)
+#define MPP11_PEX0_CLKREQn	MPP(11, 0x5, 0, 0)
+
+#define MPP12_GPIO12		MPP(12, 0x0, 1, 1)
+#define MPP12_SATA_ACT		MPP(12, 0x1, 0, 0)
+#define MPP12_UA2_RTSn		MPP(12, 0x2, 0, 0)
+#define MPP12_AD0_I2S_EXT_MCLK	MPP(12, 0x3, 0, 0)
+#define MPP12_SDIO1_CD		MPP(12, 0x4, 0, 0)
+
+#define MPP13_GPIO13		MPP(13, 0x0, 1, 1)
+#define MPP13_UA2_CTSn		MPP(13, 0x2, 0, 0)
+#define MPP13_AD1_I2S_EXT_MCLK	MPP(13, 0x3, 0, 0)
+#define MPP13_SDIO1WP		MPP(13, 0x4, 0, 0)
+#define MPP13_SSP_EXTCLK	MPP(13, 0x5, 0, 0)
+
+#define MPP14_GPIO14		MPP(14, 0x0, 1, 1)
+#define MPP14_UA2_TXD		MPP(14, 0x2, 0, 0)
+#define MPP14_SDIO1_BUS_POWER	MPP(14, 0x4, 0, 0)
+#define MPP14_SSP_RXD		MPP(14, 0x5, 0, 0)
+
+#define MPP15_GPIO15		MPP(15, 0x0, 1, 1)
+#define MPP15_UA2_RXD		MPP(15, 0x2, 0, 0)
+#define MPP15_SDIO1_LED_CTRL	MPP(15, 0x4, 0, 0)
+#define MPP15_SSP_SFRM		MPP(15, 0x5, 0, 0)
+
+#define MPP16_GPIO16		MPP(16, 0x0, 1, 1)
+#define MPP16_UA3_RTSn		MPP(16, 0x2, 0, 0)
+#define MPP16_SDIO0_CD		MPP(16, 0x3, 0, 0)
+#define MPP16_SPI_LCD_CS1	MPP(16, 0x4, 0, 0)
+#define MPP16_AC97_SDATA_IN1	MPP(16, 0x5, 0, 0)
+
+#define MPP17_GPIO17		MPP(17, 0x0, 1, 1)
+#define MPP17_AC97_SYSCLK_OUT	MPP(17, 0x1, 0, 0)
+#define MPP17_UA3_CTSn		MPP(17, 0x2, 0, 0)
+#define MPP17_SDIO0_WP		MPP(17, 0x3, 0, 0)
+#define MPP17_TW_SDA2		MPP(17, 0x4, 0, 0)
+#define MPP17_AC97_SDATA_IN2	MPP(17, 0x5, 0, 0)
+
+#define MPP18_GPIO18		MPP(18, 0x0, 1, 1)
+#define MPP18_UA3_TXD		MPP(18, 0x2, 0, 0)
+#define MPP18_SDIO0_BUS_POWER	MPP(18, 0x3, 0, 0)
+#define MPP18_LCD0_PWM		MPP(18, 0x4, 0, 0)
+#define MPP18_AC_SDATA_IN3	MPP(18, 0x5, 0, 0)
+
+#define MPP19_GPIO19		MPP(19, 0x0, 1, 1)
+#define MPP19_UA3_RXD		MPP(19, 0x2, 0, 0)
+#define MPP19_SDIO0_LED_CTRL	MPP(19, 0x3, 0, 0)
+#define MPP19_TW_SCK2		MPP(19, 0x4, 0, 0)
+
+#define MPP20_GPIO20		MPP(20, 0x0, 1, 1)
+#define MPP20_AC97_SYSCLK_OUT	MPP(20, 0x1, 0, 0)
+#define MPP20_SPI_LCD_MISO	MPP(20, 0x2, 0, 0)
+#define MPP20_SDIO1_CD		MPP(20, 0x3, 0, 0)
+#define MPP20_SDIO0_CD		MPP(20, 0x5, 0, 0)
+#define MPP20_SPI_1_MISO	MPP(20, 0x6, 0, 0)
+
+#define MPP21_GPIO21		MPP(21, 0x0, 1, 1)
+#define MPP21_UA1_RTSn		MPP(21, 0x1, 0, 0)
+#define MPP21_SPI_LCD_CS0	MPP(21, 0x2, 0, 0)
+#define MPP21_SDIO1_WP		MPP(21, 0x3, 0, 0)
+#define MPP21_SSP_SFRM		MPP(21, 0x4, 0, 0)
+#define MPP21_SDIO0_WP		MPP(21, 0x5, 0, 0)
+#define MPP21_SPI_1_CS		MPP(21, 0x6, 0, 0)
+
+#define MPP22_GPIO22		MPP(22, 0x0, 1, 1)
+#define MPP22_UA1_CTSn		MPP(22, 0x1, 0, 0)
+#define MPP22_SPI_LCD_MOSI	MPP(22, 0x2, 0, 0)
+#define MPP22_SDIO1_BUS_POWER	MPP(22, 0x3, 0, 0)
+#define MPP22_SSP_TXD		MPP(22, 0x4, 0, 0)
+#define MPP22_SDIO0_BUS_POWER	MPP(22, 0x5, 0, 0)
+#define MPP22_SPI_1_MOSI	MPP(22, 0x6, 0, 0)
+
+#define MPP23_GPIO23		MPP(23, 0x0, 1, 1)
+#define MPP23_SPI_LCD_SCK	MPP(23, 0x2, 0, 0)
+#define MPP23_SDIO1_LED_CTRL	MPP(23, 0x3, 0, 0)
+#define MPP23_SSP_SCLK		MPP(23, 0x4, 0, 0)
+#define MPP23_SDIO0_LED_CTRL	MPP(23, 0x5, 0, 0)
+#define MPP23_SPI_1_SCK		MPP(23, 0x6, 0, 0)
+
+#define MPP_MAX			23
+
+#define MPP_GRP(_grp, _mode)	MPP((_grp), (_mode), 0, 0)
 
 /* for MPP groups _num is a group index */
 enum dove_mpp_grp_idx {
@@ -181,40 +153,44 @@ enum dove_mpp_grp_idx {
 	MPP_46_51 = 1,
 	MPP_58_61 = 5,
 	MPP_62_63 = 4,
+	MPP_GRP_MAX = 5,
 };
 
-#define MPP24_39_GPIO		MPP_GRP(MPP_24_39, 0x1)
-#define MPP24_39_CAM		MPP_GRP(MPP_24_39, 0x0)
+#define MPP_GRP_24_39_GPIO		MPP_GRP(MPP_24_39, 0x1)
+#define MPP_GRP_24_39_CAM		MPP_GRP(MPP_24_39, 0x0)
 
-#define MPP40_45_GPIO		MPP_GRP(MPP_40_45, 0x1)
-#define MPP40_45_SD0		MPP_GRP(MPP_40_45, 0x0)
+#define MPP_GRP_40_45_GPIO		MPP_GRP(MPP_40_45, 0x1)
+#define MPP_GRP_40_45_SD0		MPP_GRP(MPP_40_45, 0x0)
 
-#define MPP46_51_GPIO		MPP_GRP(MPP_46_51, 0x1)
-#define MPP46_51_SD1		MPP_GRP(MPP_46_51, 0x0)
+#define MPP_GRP_46_51_GPIO		MPP_GRP(MPP_46_51, 0x1)
+#define MPP_GRP_46_51_SD1		MPP_GRP(MPP_46_51, 0x0)
 
-#define MPP58_61_GPIO		MPP_GRP(MPP_58_61, 0x1)
-#define MPP58_61_SPI		MPP_GRP(MPP_58_61, 0x0)
+#define MPP_GRP_58_61_GPIO		MPP_GRP(MPP_58_61, 0x1)
+#define MPP_GRP_58_61_SPI		MPP_GRP(MPP_58_61, 0x0)
 
-#define MPP62_63_GPIO		MPP_GRP(MPP_62_63, 0x1)
-#define MPP62_63_UA1		MPP_GRP(MPP_62_63, 0x0)
+#define MPP_GRP_62_63_GPIO		MPP_GRP(MPP_62_63, 0x1)
+#define MPP_GRP_62_63_UA1		MPP_GRP(MPP_62_63, 0x0)
 
 /* The MPP[64:71] control differs from other groups */
-#define MPP64_71_GPO		MPP_GRP_NFC(0x1)
-#define MPP64_71_NFC		MPP_GRP_NFC(0x0)
+#define MPP_GRP_NFC_64_71_GPO		0x1
+#define MPP_GRP_NFC_64_71_NFC		0x0
 
 /*
  * The MPP[52:57] functionality is encoded by 4 bits in different
  * registers. The _num field in this case encodes those bits in
  * correspodence with Table 135 of 88AP510 Functional specification
  */
-#define MPP52_57_AU1		MPP_GRP_AU1(0x0)
-#define MPP52_57_AU1_GPIO57	MPP_GRP_AU1(0x2)
-#define MPP52_57_GPIO		MPP_GRP_AU1(0xa)
-#define MPP52_57_TW_GPIO	MPP_GRP_AU1(0xb)
-#define MPP52_57_AU1_SSP	MPP_GRP_AU1(0xc)
-#define MPP52_57_SSP_GPIO	MPP_GRP_AU1(0xe)
-#define MPP52_57_SSP_TW		MPP_GRP_AU1(0xf)
-
-void dove_mpp_conf(unsigned int *mpp_list);
+#define MPP_GRP_AU1_52_57_AU1		0x0
+#define MPP_GRP_AU1_52_57_AU1_GPIO57	0x2
+#define MPP_GRP_AU1_52_57_GPIO		0xa
+#define MPP_GRP_AU1_52_57_TW_GPIO	0xb
+#define MPP_GRP_AU1_52_57_AU1_SSP	0xc
+#define MPP_GRP_AU1_52_57_SSP_GPIO	0xe
+#define MPP_GRP_AU1_52_57_SSP_TW	0xf
+
+void dove_mpp_conf(unsigned int *mpp_list,
+		   unsigned int *mpp_grp_list,
+		   unsigned int grp_au1_52_57,
+		   unsigned int grp_nfc_64_71);
 
 #endif	/* __ARCH_DOVE_MPP_CODED_H */
diff --git a/arch/arm/plat-orion/mpp.c b/arch/arm/plat-orion/mpp.c
index 248c022..9155343 100644
--- a/arch/arm/plat-orion/mpp.c
+++ b/arch/arm/plat-orion/mpp.c
@@ -31,9 +31,6 @@ void __init orion_mpp_conf(unsigned int *mpp_list, unsigned int variant_mask,
 	u32 mpp_ctrl[mpp_nr_regs];
 	int i;
 
-	if (!variant_mask)
-		return;
-
 	printk(KERN_DEBUG "initial MPP regs:");
 	for (i = 0; i < mpp_nr_regs; i++) {
 		mpp_ctrl[i] = readl(mpp_ctrl_addr(i, dev_bus));
@@ -51,7 +48,7 @@ void __init orion_mpp_conf(unsigned int *mpp_list, unsigned int variant_mask,
 					"number (%u)\n", num);
 			continue;
 		}
-		if (!(*mpp_list & variant_mask)) {
+		if (variant_mask & !(*mpp_list & variant_mask)) {
 			printk(KERN_WARNING
 			       "orion_mpp_conf: requested MPP%u config "
 			       "unavailable on this hardware\n", num);
-- 
1.7.4.4

