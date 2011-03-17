Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753204Ab1CQJjo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 05:39:44 -0400
Received: from eu1sys200aog116.obsmtp.com ([207.126.144.141]:56784 "EHLO
	eu1sys200aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752535Ab1CQJjl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 05:39:41 -0400
From: <philippe.langlais@stericsson.com>
To: <linux-kernel@vger.kernel.org>
Cc: <rostedt@goodmis.org>, <STEricsson_nomadik_linux@list.st.com>,
        <pierre.peiffer@stericsson.com>, <lee.jones@linaro.org>,
        Philippe Langlais <philippe.langlais@linaro.org>
Subject: [PATCH 2/3] mach-ux500: MIPI System Trace Module platform dependent driver part
Date: Thu, 17 Mar 2011 10:36:53 +0100
Message-ID: <1300354614-24056-3-git-send-email-philippe.langlais@stericsson.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1300354614-24056-1-git-send-email-philippe.langlais@stericsson.com>
References: <1300354614-24056-1-git-send-email-philippe.langlais@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Philippe Langlais <philippe.langlais@linaro.org>

U5500 is not yet supported.

Signed-off-by: Pierre Peiffer <pierre.peiffer@stericsson.com>
Signed-off-by: Philippe Langlais <philippe.langlais@linaro.org>
---
 arch/arm/mach-ux500/cpu-db5500.c               |    4 +
 arch/arm/mach-ux500/cpu-db8500.c               |    4 +
 arch/arm/mach-ux500/devices-db8500.c           |  181 ++++++++++++++++++++++++
 arch/arm/mach-ux500/include/mach/db5500-regs.h |    2 +
 arch/arm/mach-ux500/include/mach/devices.h     |    1 +
 arch/arm/mach-ux500/include/mach/prcmu-regs.h  |    4 +
 6 files changed, 196 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-ux500/cpu-db5500.c b/arch/arm/mach-ux500/cpu-db5500.c
index c9dc2ef..951ac20 100644
--- a/arch/arm/mach-ux500/cpu-db5500.c
+++ b/arch/arm/mach-ux500/cpu-db5500.c
@@ -214,6 +214,10 @@ static int usb_db5500_tx_dma_cfg[] = {
 
 void __init u5500_init_devices(void)
 {
+#ifdef CONFIG_STM_TRACE
+	/* Early init for STM tracing */
+	platform_device_register(&ux500_stm_device);
+#endif
 	db5500_add_gpios();
 	db5500_dma_init();
 	db5500_add_rtc();
diff --git a/arch/arm/mach-ux500/cpu-db8500.c b/arch/arm/mach-ux500/cpu-db8500.c
index 516126c..2618206 100644
--- a/arch/arm/mach-ux500/cpu-db8500.c
+++ b/arch/arm/mach-ux500/cpu-db8500.c
@@ -183,6 +183,10 @@ static int usb_db8500_tx_dma_cfg[] = {
  */
 void __init u8500_init_devices(void)
 {
+#ifdef CONFIG_STM_TRACE
+	/* Early init for STM tracing */
+	platform_device_register(&ux500_stm_device);
+#endif
 	if (cpu_is_u8500ed())
 		dma40_u8500ed_fixup();
 
diff --git a/arch/arm/mach-ux500/devices-db8500.c b/arch/arm/mach-ux500/devices-db8500.c
index 73b1740..40330c7 100644
--- a/arch/arm/mach-ux500/devices-db8500.c
+++ b/arch/arm/mach-ux500/devices-db8500.c
@@ -2,6 +2,10 @@
  * Copyright (C) ST-Ericsson SA 2010
  *
  * Author: Rabin Vincent <rabin.vincent@stericsson.com> for ST-Ericsson
+ *
+ * Author: Pierre Peiffer <pierre.peiffer@stericsson.com> for ST-Ericsson.
+ * for the System Trace Module part.
+ *
  * License terms: GNU General Public License (GPL) version 2
  */
 
@@ -12,11 +16,18 @@
 #include <linux/gpio.h>
 #include <linux/amba/bus.h>
 #include <linux/amba/pl022.h>
+#include <plat/pincfg.h>
 
 #include <plat/ste_dma40.h>
 
+#include <mach/devices.h>
 #include <mach/hardware.h>
 #include <mach/setup.h>
+#include <mach/prcmu-regs.h>
+
+#include <trace/stm.h>
+
+#include "pins-db8500.h"
 
 #include "ste-dma40-db8500.h"
 
@@ -195,3 +206,173 @@ struct platform_device u8500_ske_keypad_device = {
 	.num_resources = ARRAY_SIZE(keypad_resources),
 	.resource = keypad_resources,
 };
+
+#ifdef CONFIG_STM_TRACE
+static pin_cfg_t mop500_stm_mipi34_pins[] = {
+	GPIO70_STMAPE_CLK,
+	GPIO71_STMAPE_DAT3,
+	GPIO72_STMAPE_DAT2,
+	GPIO73_STMAPE_DAT1,
+	GPIO74_STMAPE_DAT0,
+	GPIO75_U2_RXD,
+	GPIO76_U2_TXD,
+};
+
+static pin_cfg_t mop500_stm_mipi60_pins[] = {
+	GPIO153_U2_RXD,
+	GPIO154_U2_TXD,
+	GPIO155_STMAPE_CLK,
+	GPIO156_STMAPE_DAT3,
+	GPIO157_STMAPE_DAT2,
+	GPIO158_STMAPE_DAT1,
+	GPIO159_STMAPE_DAT0,
+};
+
+static pin_cfg_t mop500_ske_pins[] = {
+	GPIO153_KP_I7,
+	GPIO154_KP_I6,
+	GPIO155_KP_I5,
+	GPIO156_KP_I4,
+	GPIO157_KP_O7,
+	GPIO158_KP_O6,
+	GPIO159_KP_O5,
+};
+
+static int stm_ste_disable_ape_on_mipi60(void)
+{
+	int retval;
+
+	retval = nmk_config_pins_sleep(ARRAY_AND_SIZE(mop500_stm_mipi60_pins));
+	if (retval)
+		pr_err("STM: Failed to disable MIPI60\n");
+	else {
+		retval = nmk_config_pins(ARRAY_AND_SIZE(mop500_ske_pins));
+		if (retval)
+			pr_err("STM: Failed to enable SKE gpio\n");
+	}
+	return retval;
+}
+
+/*
+ * Manage STM output pins connection (MIP34/MIPI60 connectors)
+ */
+static int stm_ste_connection(enum stm_connection_type con_type)
+{
+	int retval = -EINVAL;
+	u32 gpiocr = readl(PRCM_GPIOCR);
+
+	if (con_type != STM_DISCONNECT) {
+		/*  Always enable MIPI34 GPIO pins */
+		retval = nmk_config_pins(
+				ARRAY_AND_SIZE(mop500_stm_mipi34_pins));
+		if (retval) {
+			pr_err("STM: Failed to enable MIPI34\n");
+			return retval;
+		}
+	}
+
+	switch (con_type) {
+	case STM_DEFAULT_CONNECTION:
+	case STM_STE_MODEM_ON_MIPI34_NONE_ON_MIPI60:
+		/* Enable altC3 on GPIO70-74 (STMMOD) & GPIO75-76 (UARTMOD) */
+		gpiocr |= (PRCM_GPIOCR_DBG_STM_MOD_CMD1
+				| PRCM_GPIOCR_DBG_UARTMOD_CMD0);
+		writel(gpiocr, PRCM_GPIOCR);
+		retval = stm_ste_disable_ape_on_mipi60();
+		break;
+
+	case STM_STE_APE_ON_MIPI34_NONE_ON_MIPI60:
+		/* Disable altC3 on GPIO70-74 (STMMOD) & GPIO75-76 (UARTMOD) */
+		gpiocr &= ~(PRCM_GPIOCR_DBG_STM_MOD_CMD1
+				| PRCM_GPIOCR_DBG_UARTMOD_CMD0);
+		writel(gpiocr, PRCM_GPIOCR);
+		retval = stm_ste_disable_ape_on_mipi60();
+		break;
+
+	case STM_STE_MODEM_ON_MIPI34_APE_ON_MIPI60:
+		/* Enable altC3 on GPIO70-74 (STMMOD) and GPIO75-76 (UARTMOD) */
+		gpiocr |= (PRCM_GPIOCR_DBG_STM_MOD_CMD1
+				| PRCM_GPIOCR_DBG_UARTMOD_CMD0);
+		writel(gpiocr, PRCM_GPIOCR);
+
+		/* Enable APE on MIPI60 */
+		retval = nmk_config_pins_sleep(ARRAY_AND_SIZE(mop500_ske_pins));
+		if (retval)
+			pr_err("STM: Failed to disable SKE GPIO\n");
+		else {
+			retval = nmk_config_pins(
+					ARRAY_AND_SIZE(mop500_stm_mipi60_pins));
+			if (retval)
+				pr_err("STM: Failed to enable MIPI60\n");
+		}
+		break;
+
+	case STM_DISCONNECT:
+		retval = nmk_config_pins_sleep(
+				ARRAY_AND_SIZE(mop500_stm_mipi34_pins));
+		if (retval)
+			pr_err("STM: Failed to disable MIPI34\n");
+
+		retval = stm_ste_disable_ape_on_mipi60();
+		break;
+
+	default:
+		pr_err("STM: bad connection type\n");
+		break;
+	}
+	return retval;
+}
+
+/* Possible STM sources (masters) on ux500 */
+enum stm_master {
+	STM_ARM0 =	0,
+	STM_ARM1 =	1,
+	STM_SVA =	2,
+	STM_SIA =	3,
+	STM_SIA_XP70 =	4,
+	STM_PRCMU =	5,
+	STM_MCSBAG =	9
+};
+
+#define STM_ENABLE_ARM0		BIT(STM_ARM0)
+#define STM_ENABLE_ARM1		BIT(STM_ARM1)
+#define STM_ENABLE_SVA		BIT(STM_SVA)
+#define STM_ENABLE_SIA		BIT(STM_SIA)
+#define STM_ENABLE_SIA_XP70	BIT(STM_SIA_XP70)
+#define STM_ENABLE_PRCMU	BIT(STM_PRCMU)
+#define STM_ENABLE_MCSBAG	BIT(STM_MCSBAG)
+
+/*
+ * These are the channels used by NMF and some external softwares
+ * expect the NMF traces to be output on these channels
+ * For legacy reason, we need to reserve them.
+ */
+static const s16 stm_channels_reserved[] = {
+	100,	/* NMF MPCEE channel */
+	101,	/* NMF CM channel */
+	151,	/* NMF HOSTEE channel */
+};
+
+/* On Ux500 we 2 consecutive STMs therefore 512 channels available */
+static struct stm_platform_data stm_pdata = {
+	.regs_phys_base       = U8500_STM_REG_BASE,
+	.channels_phys_base   = U8500_STM_BASE,
+	.id_mask              = 0x000fffff,   /* Ignore revisions differences */
+	.channels_reserved    = stm_channels_reserved,
+	.channels_reserved_sz = ARRAY_SIZE(stm_channels_reserved),
+	/* Enable all except MCSBAG */
+	.masters_enabled      = STM_ENABLE_ARM0 | STM_ENABLE_ARM1 |
+				STM_ENABLE_SVA | STM_ENABLE_PRCMU |
+				STM_ENABLE_SIA | STM_ENABLE_SIA_XP70,
+	/* Provide function for MIPI34/MIPI60 STM connection */
+	.stm_connection       = stm_ste_connection,
+};
+
+struct platform_device ux500_stm_device = {
+	.name = "stm",
+	.id = -1,
+	.dev = {
+		.platform_data = &stm_pdata,
+	},
+};
+#endif /* CONFIG_UX500_STM */
diff --git a/arch/arm/mach-ux500/include/mach/db5500-regs.h b/arch/arm/mach-ux500/include/mach/db5500-regs.h
index bd88c1e..d7db70d 100644
--- a/arch/arm/mach-ux500/include/mach/db5500-regs.h
+++ b/arch/arm/mach-ux500/include/mach/db5500-regs.h
@@ -17,6 +17,8 @@
 #define U5500_GIC_DIST_BASE	0xA0411000
 #define U5500_GIC_CPU_BASE	0xA0410100
 #define U5500_DMA_BASE		0x90030000
+#define U5500_STM_BASE		0x90020000
+#define U5500_STM_REG_BASE	(U5500_STM_BASE + 0xF000)
 #define U5500_MCDE_BASE		0xA0400000
 #define U5500_MODEM_BASE	0xB0000000
 #define U5500_L2CC_BASE		0xA0412000
diff --git a/arch/arm/mach-ux500/include/mach/devices.h b/arch/arm/mach-ux500/include/mach/devices.h
index 020b636..c246312 100644
--- a/arch/arm/mach-ux500/include/mach/devices.h
+++ b/arch/arm/mach-ux500/include/mach/devices.h
@@ -13,6 +13,7 @@ struct amba_device;
 extern struct platform_device u5500_gpio_devs[];
 extern struct platform_device u8500_gpio_devs[];
 
+extern struct platform_device ux500_stm_device;
 extern struct amba_device ux500_pl031_device;
 
 extern struct platform_device u8500_dma40_device;
diff --git a/arch/arm/mach-ux500/include/mach/prcmu-regs.h b/arch/arm/mach-ux500/include/mach/prcmu-regs.h
index 455467e..8d232ed 100644
--- a/arch/arm/mach-ux500/include/mach/prcmu-regs.h
+++ b/arch/arm/mach-ux500/include/mach/prcmu-regs.h
@@ -92,5 +92,9 @@
 
 /* Miscellaneous unit registers */
 #define PRCM_DSI_SW_RESET          (_PRCMU_BASE + 0x324)
+#define PRCM_GPIOCR                (_PRCMU_BASE + 0x138)
+#define PRCM_GPIOCR_DBG_STM_MOD_CMD1            0x800
+#define PRCM_GPIOCR_DBG_UARTMOD_CMD0            0x1
+
 
 #endif /* __MACH_PRCMU_REGS_H */
-- 
1.7.3.1

