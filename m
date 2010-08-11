Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755061Ab0HKQrD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 12:47:03 -0400
Received: from mail.logicpd.com ([66.162.60.3]:43783 "EHLO smtp.logicpd.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753463Ab0HKQqX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 12:46:23 -0400
X-Greylist: delayed 850 seconds by postgrey-1.27 at vger.kernel.org; Wed, 11 Aug 2010 12:46:22 EDT
From: Jacob Tanenbaum <Jacob.Tanenbaum@logicpd.com>
To: linux@arm.linux.org.uk
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        rmk@arm.linux.org.uk, tony@atomide.com,
        Jacob Tanenbaum <Jacob.Tanenbaum@logicpd.com>
Subject: [PATCH 4/4] enabling Ethernet support for LogicPD's OMAP3 TORPEDO and SOM dev kits 
Date: Wed, 11 Aug 2010 12:31:37 -0400
Message-Id: <1281544297-18015-4-git-send-email-Jacob.Tanenbaum@logicpd.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1281544297-18015-3-git-send-email-Jacob.Tanenbaum@logicpd.com>
References: <1281544297-18015-1-git-send-email-Jacob.Tanenbaum@logicpd.com>
 <1281544297-18015-2-git-send-email-Jacob.Tanenbaum@logicpd.com>
 <1281544297-18015-3-git-send-email-Jacob.Tanenbaum@logicpd.com>
X-OriginalArrivalTime: 11 Aug 2010 16:32:13.0105 (UTC) FILETIME=[C0A16A10:01CB3972]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

                
                Enable SMSC911x Ethernet driver for LogicPD's OMAP 
		3530 LV SOM and OMAP 35x Torpedo board.

                Tested against: linux-next 81e09f50c93edff607259cbe374a3006c9c5fa74
		Signed-off-by: Jacob Tanenbaum <Jacob.Tanenbaum@logicpd.com>
---
 arch/arm/mach-omap2/board-omap3logic.c |   90 +++++++++++++++++++++++++++++++-
 1 files changed, 89 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-omap2/board-omap3logic.c b/arch/arm/mach-omap2/board-omap3logic.c
index 3358418..694bc27 100644
--- a/arch/arm/mach-omap2/board-omap3logic.c
+++ b/arch/arm/mach-omap2/board-omap3logic.c
@@ -38,14 +38,21 @@
 #include <plat/mux.h>
 #include <plat/board.h>
 #include <plat/common.h>
+#include <plat/gpmc-smsc911x.h>
 #include <plat/gpmc.h>
 #include <plat/timer-gp.h>
 #include <plat/sdrc.h>
+#include <plat/control.h>
+
+#define OMAP3LOGIC_SMSC911X_CS			1
 
 #define OMAP3530_LV_SOM_MMC_GPIO_CD             110
 #define OMAP3530_LV_SOM_MMC_GPIO_WP             126
+#define	OMAP3530_LV_SOM_SMSC911X_GPIO_IRQ	152
+
 #define OMAP3_TORPEDO_MMC_GPIO_CD               127
 #define OMAP3_TORPEDO_MMC_GPIO_WP               (-EINVAL)
+#define OMAP3_TORPEDO_SMSC911X_GPIO_IRQ		129
 
 /* Micron MT46H32M32LF-6 */
 /* FIXME: borrowed from sdram-micron-mt46h32m32lf-6.h because on LogicPD
@@ -190,6 +197,78 @@ static void __init board_mmc_init(void)
 	omap3logic_vmmc1_supply.dev = board_mmc_info[0].dev;
 }
 
+static struct omap_smsc911x_platform_data __initdata board_smsc911x_data = {
+	.cs             = OMAP3LOGIC_SMSC911X_CS,
+	.gpio_irq       = -EINVAL,
+	.gpio_reset     = -EINVAL,
+	.flags          = IORESOURCE_IRQ_LOWLEVEL,
+};
+
+/* TODO/FIXME (comment by Peter Barada, LogicPD):
+ * Fix the PBIAS voltage for Torpedo MMC1 pins that
+ * are used for other needs (IRQs, etc).
+static inline void __init omap3_torpedo_fix_pbias_voltage(void) */
+static void omap3torpedo_fix_pbias_voltage(void)
+{
+	u16 control_pbias_offset = OMAP343X_CONTROL_PBIAS_LITE;
+	static int pbias_fixed = -1;
+	u32 reg;
+
+	if (!pbias_fixed) {
+		/* Set the bias for the pin */
+		reg = omap_ctrl_readl(control_pbias_offset);
+
+		reg &= ~OMAP343X_PBIASLITEPWRDNZ1;
+		omap_ctrl_writel(reg, control_pbias_offset);
+
+		/* 100ms delay required for PBIAS configuration */
+		msleep(100);
+
+		reg |= OMAP343X_PBIASLITEVMODE1;
+		reg |= OMAP343X_PBIASLITEPWRDNZ1;
+		omap_ctrl_writel(reg | 0x300, control_pbias_offset);
+
+		pbias_fixed = 1;
+	}
+}
+
+static inline void __init board_smsc911x_init(void)
+{
+	/* OMAP3530 LV SOM board */
+	if (machine_is_omap3530_lv_som()) {
+		board_smsc911x_data.gpio_irq =
+					OMAP3530_LV_SOM_SMSC911X_GPIO_IRQ;
+		/* board_smsc911x_data.gpio_reset
+			driven by SYS_nRESWARM, no GPIO */
+		/* omap_cfg_reg(AE1_34XX_GPIO152_UP); */
+		omap_mux_init_signal("gpio_152", OMAP_PIN_INPUT);
+
+/* omap_mux_init_signal("sdrc_cke0", OMAP_PIN_OUTPUT);*/
+
+	/* OMAP3 Torpedo board */
+	} else if (machine_is_omap3_torpedo()) {
+		board_smsc911x_data.gpio_irq = OMAP3_TORPEDO_SMSC911X_GPIO_IRQ;
+		/* board_smsc911x_data.gpio_reset driven
+			by SYS_nRESWARM, no GPIO */
+		/*omap_cfg_reg(AE1_34XX_GPIO152_UP);*/
+		omap_mux_init_signal("gpio_129", OMAP_PIN_INPUT);
+		/* TODO/FIXME (comment by Peter Barada, LogicPD):
+		* On Torpedo, LAN9221 IRQ is an MMC1_DATA7 pin
+		* and IRQ1760 IRQ is MMC1_DATA4 pin - need
+		* to update PBIAS to get voltage to the device
+		* so the IRQs works correctly rather than float
+		* and cause an IRQ storm...
+								*/
+		omap3torpedo_fix_pbias_voltage();
+	/* unsupported board */
+	} else {
+		printk(KERN_ERR "%s(): unknown machine type\n", __func__);
+		return;
+	}
+	gpmc_smsc911x_init(&board_smsc911x_data);
+}
+
+
 
 
 static void __init omap3logic_init_irq(void)
@@ -204,14 +283,23 @@ static void __init omap3logic_init_irq(void)
 #endif
 	omap_gpio_init();
 }
-
+#ifdef CONFIG_OMAP_MUX
+static struct omap_board_mux board_mux[] __initdata = {
+	{ .reg_offset = OMAP_MUX_TERMINATOR },
+};
+#else
+#define board_mux       NULL
+#endif
 
 
 static void __init omap3logic_init(void)
 {
+	omap3_mux_init(board_mux, OMAP_PACKAGE_CBB);
 	omap3logic_i2c_init();
 	omap_serial_init();
 	board_mmc_init();
+	board_smsc911x_init();
+
 	/* Ensure SDRC pins are mux'd for self-refresh */
 	omap_mux_init_signal("sdrc_cke0", OMAP_PIN_OUTPUT);
 	omap_mux_init_signal("sdrc_cke1", OMAP_PIN_OUTPUT);
-- 
1.6.0.4

