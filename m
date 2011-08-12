Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752975Ab1HLI25 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 04:28:57 -0400
Received: from eu1sys200aog114.obsmtp.com ([207.126.144.137]:45078 "EHLO
	eu1sys200aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752887Ab1HLI2s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 04:28:48 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Samuel Ortiz <sameo@linux.intel.com>, <linux-kernel@vger.kernel.org>
Cc: Lee Jones <lee.jones@linaro.org>,
        Mattias Nilsson <mattias.i.nilsson@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 05/23] mfd/dbx500-prcmu: move to the new API
Date: Fri, 12 Aug 2011 10:28:10 +0200
Message-ID: <1313137690-30749-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mattias Nilsson <mattias.i.nilsson@stericsson.com>

Now that we have a shared API between the DB8500 and DB5500
PRCMU's, switch to using this neutral API instead. We delete the
parts of db8500-prcmu.h that is now PRCMU-neutral, and calls will
be diverted to respective driver. Common registers are in
dbx500-prcmu-regs.h and common accessors and defines in
<linux/mfd/dbx500-prcmu.h> This way we get a a lot more
abstraction and code reuse.

Signed-off-by: Mattias Nilsson <mattias.i.nilsson@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 arch/arm/mach-ux500/cpu.c        |    2 +-
 drivers/cpufreq/db8500-cpufreq.c |    2 +-
 drivers/mfd/db5500-prcmu-regs.h  |  115 ------------
 drivers/mfd/db5500-prcmu.c       |   22 ++--
 drivers/mfd/db8500-prcmu-regs.h  |  204 ---------------------
 drivers/mfd/db8500-prcmu.c       |   46 +++---
 drivers/mfd/dbx500-prcmu-regs.h  |  204 +++++++++++++++++++++
 drivers/regulator/db8500-prcmu.c |    2 +-
 include/linux/mfd/db5500-prcmu.h |  102 +++++++++--
 include/linux/mfd/db8500-prcmu.h |  368 +++++++++-----------------------------
 include/linux/mfd/dbx500-prcmu.h |    8 +-
 11 files changed, 415 insertions(+), 660 deletions(-)
 delete mode 100644 drivers/mfd/db5500-prcmu-regs.h
 delete mode 100644 drivers/mfd/db8500-prcmu-regs.h
 create mode 100644 drivers/mfd/dbx500-prcmu-regs.h

diff --git a/arch/arm/mach-ux500/cpu.c b/arch/arm/mach-ux500/cpu.c
index 1da23bb..bb56539 100644
--- a/arch/arm/mach-ux500/cpu.c
+++ b/arch/arm/mach-ux500/cpu.c
@@ -53,7 +53,7 @@ void __init ux500_init_irq(void)
 	if (cpu_is_u5500())
 		db5500_prcmu_early_init();
 	if (cpu_is_u8500())
-		prcmu_early_init();
+		db8500_prcmu_early_init();
 	clk_init();
 }
 
diff --git a/drivers/cpufreq/db8500-cpufreq.c b/drivers/cpufreq/db8500-cpufreq.c
index d90456a..8e89dcf 100644
--- a/drivers/cpufreq/db8500-cpufreq.c
+++ b/drivers/cpufreq/db8500-cpufreq.c
@@ -12,7 +12,7 @@
 #include <linux/cpufreq.h>
 #include <linux/delay.h>
 #include <linux/slab.h>
-#include <linux/mfd/db8500-prcmu.h>
+#include <linux/mfd/dbx500-prcmu.h>
 #include <mach/id.h>
 
 static struct cpufreq_frequency_table freq_table[] = {
diff --git a/drivers/mfd/db5500-prcmu-regs.h b/drivers/mfd/db5500-prcmu-regs.h
deleted file mode 100644
index 9a8e9e4..0000000
--- a/drivers/mfd/db5500-prcmu-regs.h
+++ /dev/null
@@ -1,115 +0,0 @@
-/*
- * Copyright (C) STMicroelectronics 2009
- * Copyright (C) ST-Ericsson SA 2010
- *
- * Author: Kumar Sanghvi <kumar.sanghvi@stericsson.com>
- * Author: Sundar Iyer <sundar.iyer@stericsson.com>
- *
- * License Terms: GNU General Public License v2
- *
- * PRCM Unit registers
- */
-
-#ifndef __MACH_PRCMU_REGS_H
-#define __MACH_PRCMU_REGS_H
-
-#include <mach/hardware.h>
-
-#define PRCM_ARM_PLLDIVPS	(_PRCMU_BASE + 0x118)
-#define PRCM_ARM_PLLDIVPS_ARM_BRM_RATE		0x3f
-#define PRCM_ARM_PLLDIVPS_MAX_MASK		0xf
-
-#define PRCM_PLLARM_LOCKP       (_PRCMU_BASE + 0x0a8)
-#define PRCM_PLLARM_LOCKP_PRCM_PLLARM_LOCKP3	0x2
-
-#define PRCM_ARM_CHGCLKREQ	(_PRCMU_BASE + 0x114)
-#define PRCM_ARM_CHGCLKREQ_PRCM_ARM_CHGCLKREQ	0x1
-
-#define PRCM_PLLARM_ENABLE	(_PRCMU_BASE + 0x98)
-#define PRCM_PLLARM_ENABLE_PRCM_PLLARM_ENABLE	0x1
-#define PRCM_PLLARM_ENABLE_PRCM_PLLARM_COUNTON	0x100
-
-#define PRCM_ARMCLKFIX_MGT	(_PRCMU_BASE + 0x0)
-#define PRCM_A9_RESETN_CLR	(_PRCMU_BASE + 0x1f4)
-#define PRCM_A9_RESETN_SET	(_PRCMU_BASE + 0x1f0)
-#define PRCM_ARM_LS_CLAMP	(_PRCMU_BASE + 0x30c)
-#define PRCM_SRAM_A9		(_PRCMU_BASE + 0x308)
-
-/* ARM WFI Standby signal register */
-#define PRCM_ARM_WFI_STANDBY    (_PRCMU_BASE + 0x130)
-#define PRCM_IOCR		(_PRCMU_BASE + 0x310)
-#define PRCM_IOCR_IOFORCE			0x1
-
-/* CPU mailbox registers */
-#define PRCM_MBOX_CPU_VAL	(_PRCMU_BASE + 0x0fc)
-#define PRCM_MBOX_CPU_SET	(_PRCMU_BASE + 0x100)
-#define PRCM_MBOX_CPU_CLR	(_PRCMU_BASE + 0x104)
-
-/* Dual A9 core interrupt management unit registers */
-#define PRCM_A9_MASK_REQ	(_PRCMU_BASE + 0x328)
-#define PRCM_A9_MASK_REQ_PRCM_A9_MASK_REQ	0x1
-
-#define PRCM_A9_MASK_ACK	(_PRCMU_BASE + 0x32c)
-#define PRCM_ARMITMSK31TO0	(_PRCMU_BASE + 0x11c)
-#define PRCM_ARMITMSK63TO32	(_PRCMU_BASE + 0x120)
-#define PRCM_ARMITMSK95TO64	(_PRCMU_BASE + 0x124)
-#define PRCM_ARMITMSK127TO96	(_PRCMU_BASE + 0x128)
-#define PRCM_POWER_STATE_VAL	(_PRCMU_BASE + 0x25C)
-#define PRCM_ARMITVAL31TO0	(_PRCMU_BASE + 0x260)
-#define PRCM_ARMITVAL63TO32	(_PRCMU_BASE + 0x264)
-#define PRCM_ARMITVAL95TO64	(_PRCMU_BASE + 0x268)
-#define PRCM_ARMITVAL127TO96	(_PRCMU_BASE + 0x26C)
-
-#define PRCM_HOSTACCESS_REQ	(_PRCMU_BASE + 0x334)
-#define ARM_WAKEUP_MODEM	0x1
-
-#define PRCM_ARM_IT1_CLEAR	(_PRCMU_BASE + 0x48C)
-#define PRCM_ARM_IT1_VAL	(_PRCMU_BASE + 0x494)
-#define PRCM_HOLD_EVT		(_PRCMU_BASE + 0x174)
-
-#define PRCM_ITSTATUS0		(_PRCMU_BASE + 0x148)
-#define PRCM_ITSTATUS1		(_PRCMU_BASE + 0x150)
-#define PRCM_ITSTATUS2		(_PRCMU_BASE + 0x158)
-#define PRCM_ITSTATUS3		(_PRCMU_BASE + 0x160)
-#define PRCM_ITSTATUS4		(_PRCMU_BASE + 0x168)
-#define PRCM_ITSTATUS5		(_PRCMU_BASE + 0x484)
-#define PRCM_ITCLEAR5		(_PRCMU_BASE + 0x488)
-#define PRCM_ARMIT_MASKXP70_IT	(_PRCMU_BASE + 0x1018)
-
-/* System reset register */
-#define PRCM_APE_SOFTRST	(_PRCMU_BASE + 0x228)
-
-/* Level shifter and clamp control registers */
-#define PRCM_MMIP_LS_CLAMP_SET     (_PRCMU_BASE + 0x420)
-#define PRCM_MMIP_LS_CLAMP_CLR     (_PRCMU_BASE + 0x424)
-
-/* PRCMU clock/PLL/reset registers */
-#define PRCM_PLLDSI_FREQ           (_PRCMU_BASE + 0x500)
-#define PRCM_PLLDSI_ENABLE         (_PRCMU_BASE + 0x504)
-#define PRCM_PLLDSI_LOCKP          (_PRCMU_BASE + 0x508)
-#define PRCM_LCDCLK_MGT            (_PRCMU_BASE + 0x044)
-#define PRCM_MCDECLK_MGT           (_PRCMU_BASE + 0x064)
-#define PRCM_HDMICLK_MGT           (_PRCMU_BASE + 0x058)
-#define PRCM_TVCLK_MGT             (_PRCMU_BASE + 0x07c)
-#define PRCM_DSI_PLLOUT_SEL        (_PRCMU_BASE + 0x530)
-#define PRCM_DSITVCLK_DIV          (_PRCMU_BASE + 0x52C)
-#define PRCM_PLLDSI_LOCKP          (_PRCMU_BASE + 0x508)
-#define PRCM_APE_RESETN_SET        (_PRCMU_BASE + 0x1E4)
-#define PRCM_APE_RESETN_CLR        (_PRCMU_BASE + 0x1E8)
-#define PRCM_CLKOCR		   (_PRCMU_BASE + 0x1CC)
-
-/* ePOD and memory power signal control registers */
-#define PRCM_EPOD_C_SET            (_PRCMU_BASE + 0x410)
-#define PRCM_SRAM_LS_SLEEP         (_PRCMU_BASE + 0x304)
-
-/* Debug power control unit registers */
-#define PRCM_POWER_STATE_SET       (_PRCMU_BASE + 0x254)
-
-/* Miscellaneous unit registers */
-#define PRCM_DSI_SW_RESET          (_PRCMU_BASE + 0x324)
-#define PRCM_GPIOCR                (_PRCMU_BASE + 0x138)
-#define PRCM_GPIOCR_DBG_STM_MOD_CMD1            0x800
-#define PRCM_GPIOCR_DBG_UARTMOD_CMD0            0x1
-
-
-#endif /* __MACH_PRCMU__REGS_H */
diff --git a/drivers/mfd/db5500-prcmu.c b/drivers/mfd/db5500-prcmu.c
index 9dbb3ca..dc21587 100644
--- a/drivers/mfd/db5500-prcmu.c
+++ b/drivers/mfd/db5500-prcmu.c
@@ -20,11 +20,11 @@
 #include <linux/jiffies.h>
 #include <linux/bitops.h>
 #include <linux/interrupt.h>
-#include <linux/mfd/db5500-prcmu.h>
+#include <linux/mfd/dbx500-prcmu.h>
 #include <mach/hardware.h>
 #include <mach/irqs.h>
 #include <mach/db5500-regs.h>
-#include "db5500-prcmu-regs.h"
+#include "dbx500-prcmu-regs.h"
 
 #define _PRCM_MB_HEADER (tcdm_base + 0xFE8)
 #define PRCM_REQ_MB0_HEADER (_PRCM_MB_HEADER + 0x0)
@@ -315,31 +315,31 @@ static bool read_mailbox_0(void)
 		r = false;
 		break;
 	}
-	writel(MBOX_BIT(0), PRCM_ARM_IT1_CLEAR);
+	writel(MBOX_BIT(0), PRCM_ARM_IT1_CLR);
 	return r;
 }
 
 static bool read_mailbox_1(void)
 {
-	writel(MBOX_BIT(1), PRCM_ARM_IT1_CLEAR);
+	writel(MBOX_BIT(1), PRCM_ARM_IT1_CLR);
 	return false;
 }
 
 static bool read_mailbox_2(void)
 {
-	writel(MBOX_BIT(2), PRCM_ARM_IT1_CLEAR);
+	writel(MBOX_BIT(2), PRCM_ARM_IT1_CLR);
 	return false;
 }
 
 static bool read_mailbox_3(void)
 {
-	writel(MBOX_BIT(3), PRCM_ARM_IT1_CLEAR);
+	writel(MBOX_BIT(3), PRCM_ARM_IT1_CLR);
 	return false;
 }
 
 static bool read_mailbox_4(void)
 {
-	writel(MBOX_BIT(4), PRCM_ARM_IT1_CLEAR);
+	writel(MBOX_BIT(4), PRCM_ARM_IT1_CLR);
 	return false;
 }
 
@@ -360,19 +360,19 @@ static bool read_mailbox_5(void)
 		print_unknown_header_warning(5, header);
 		break;
 	}
-	writel(MBOX_BIT(5), PRCM_ARM_IT1_CLEAR);
+	writel(MBOX_BIT(5), PRCM_ARM_IT1_CLR);
 	return false;
 }
 
 static bool read_mailbox_6(void)
 {
-	writel(MBOX_BIT(6), PRCM_ARM_IT1_CLEAR);
+	writel(MBOX_BIT(6), PRCM_ARM_IT1_CLR);
 	return false;
 }
 
 static bool read_mailbox_7(void)
 {
-	writel(MBOX_BIT(7), PRCM_ARM_IT1_CLEAR);
+	writel(MBOX_BIT(7), PRCM_ARM_IT1_CLR);
 	return false;
 }
 
@@ -434,7 +434,7 @@ int __init db5500_prcmu_init(void)
 		return -ENODEV;
 
 	/* Clean up the mailbox interrupts after pre-kernel code. */
-	writel(ALL_MBOX_BITS, PRCM_ARM_IT1_CLEAR);
+	writel(ALL_MBOX_BITS, PRCM_ARM_IT1_CLR);
 
 	r = request_threaded_irq(IRQ_DB5500_PRCMU1, prcmu_irq_handler,
 		prcmu_irq_thread_fn, 0, "prcmu", NULL);
diff --git a/drivers/mfd/db8500-prcmu-regs.h b/drivers/mfd/db8500-prcmu-regs.h
deleted file mode 100644
index ec22e9f..0000000
--- a/drivers/mfd/db8500-prcmu-regs.h
+++ /dev/null
@@ -1,204 +0,0 @@
-/*
- * Copyright (C) STMicroelectronics 2009
- * Copyright (C) ST-Ericsson SA 2010
- *
- * Author: Kumar Sanghvi <kumar.sanghvi@stericsson.com>
- * Author: Sundar Iyer <sundar.iyer@stericsson.com>
- *
- * License Terms: GNU General Public License v2
- *
- * PRCM Unit registers
- */
-
-#ifndef __DB8500_PRCMU_REGS_H
-#define __DB8500_PRCMU_REGS_H
-
-#include <mach/hardware.h>
-
-#define BITS(_start, _end) ((BIT(_end) - BIT(_start)) + BIT(_end))
-
-#define PRCM_SVACLK_MGT_OFF		0x008
-#define PRCM_SIACLK_MGT_OFF		0x00C
-#define PRCM_SGACLK_MGT_OFF		0x014
-#define PRCM_UARTCLK_MGT_OFF		0x018
-#define PRCM_MSP02CLK_MGT_OFF		0x01C
-#define PRCM_I2CCLK_MGT_OFF		0x020
-#define PRCM_SDMMCCLK_MGT_OFF		0x024
-#define PRCM_SLIMCLK_MGT_OFF		0x028
-#define PRCM_PER1CLK_MGT_OFF		0x02C
-#define PRCM_PER2CLK_MGT_OFF		0x030
-#define PRCM_PER3CLK_MGT_OFF		0x034
-#define PRCM_PER5CLK_MGT_OFF		0x038
-#define PRCM_PER6CLK_MGT_OFF		0x03C
-#define PRCM_PER7CLK_MGT_OFF		0x040
-#define PRCM_PWMCLK_MGT_OFF		0x044 /* for DB5500 */
-#define PRCM_IRDACLK_MGT_OFF		0x048 /* for DB5500 */
-#define PRCM_IRRCCLK_MGT_OFF		0x04C /* for DB5500 */
-#define PRCM_LCDCLK_MGT_OFF		0x044
-#define PRCM_BMLCLK_MGT_OFF		0x04C
-#define PRCM_HSITXCLK_MGT_OFF		0x050
-#define PRCM_HSIRXCLK_MGT_OFF		0x054
-#define PRCM_HDMICLK_MGT_OFF		0x058
-#define PRCM_APEATCLK_MGT_OFF		0x05C
-#define PRCM_APETRACECLK_MGT_OFF	0x060
-#define PRCM_MCDECLK_MGT_OFF		0x064
-#define PRCM_IPI2CCLK_MGT_OFF		0x068
-#define PRCM_DSIALTCLK_MGT_OFF		0x06C
-#define PRCM_DMACLK_MGT_OFF		0x074
-#define PRCM_B2R2CLK_MGT_OFF		0x078
-#define PRCM_TVCLK_MGT_OFF		0x07C
-#define PRCM_UNIPROCLK_MGT_OFF		0x278
-#define PRCM_SSPCLK_MGT_OFF		0x280
-#define PRCM_RNGCLK_MGT_OFF		0x284
-#define PRCM_UICCCLK_MGT_OFF		0x27C
-#define PRCM_MSP1CLK_MGT_OFF		0x288
-
-#define PRCM_ARM_PLLDIVPS	(_PRCMU_BASE + 0x118)
-#define PRCM_ARM_PLLDIVPS_ARM_BRM_RATE		0x3f
-#define PRCM_ARM_PLLDIVPS_MAX_MASK		0xf
-
-#define PRCM_PLLARM_LOCKP       (_PRCMU_BASE + 0x0a8)
-#define PRCM_PLLARM_LOCKP_PRCM_PLLARM_LOCKP3	0x2
-
-#define PRCM_ARM_CHGCLKREQ	(_PRCMU_BASE + 0x114)
-#define PRCM_ARM_CHGCLKREQ_PRCM_ARM_CHGCLKREQ	0x1
-
-#define PRCM_PLLARM_ENABLE	(_PRCMU_BASE + 0x98)
-#define PRCM_PLLARM_ENABLE_PRCM_PLLARM_ENABLE	0x1
-#define PRCM_PLLARM_ENABLE_PRCM_PLLARM_COUNTON	0x100
-
-#define PRCM_ARMCLKFIX_MGT	(_PRCMU_BASE + 0x0)
-#define PRCM_A9PL_FORCE_CLKEN	(_PRCMU_BASE + 0x19C)
-#define PRCM_A9_RESETN_CLR	(_PRCMU_BASE + 0x1f4)
-#define PRCM_A9_RESETN_SET	(_PRCMU_BASE + 0x1f0)
-#define PRCM_ARM_LS_CLAMP	(_PRCMU_BASE + 0x30c)
-#define PRCM_SRAM_A9		(_PRCMU_BASE + 0x308)
-
-#define PRCM_A9PL_FORCE_CLKEN_PRCM_A9PL_FORCE_CLKEN BIT(0)
-#define PRCM_A9PL_FORCE_CLKEN_PRCM_A9AXI_FORCE_CLKEN BIT(1)
-
-/* ARM WFI Standby signal register */
-#define PRCM_ARM_WFI_STANDBY    (_PRCMU_BASE + 0x130)
-#define PRCM_IOCR		(_PRCMU_BASE + 0x310)
-#define PRCM_IOCR_IOFORCE			0x1
-
-/* CPU mailbox registers */
-#define PRCM_MBOX_CPU_VAL	(_PRCMU_BASE + 0x0fc)
-#define PRCM_MBOX_CPU_SET	(_PRCMU_BASE + 0x100)
-#define PRCM_MBOX_CPU_CLR	(_PRCMU_BASE + 0x104)
-
-/* Dual A9 core interrupt management unit registers */
-#define PRCM_A9_MASK_REQ	(_PRCMU_BASE + 0x328)
-#define PRCM_A9_MASK_REQ_PRCM_A9_MASK_REQ	0x1
-
-#define PRCM_A9_MASK_ACK	(_PRCMU_BASE + 0x32c)
-#define PRCM_ARMITMSK31TO0	(_PRCMU_BASE + 0x11c)
-#define PRCM_ARMITMSK63TO32	(_PRCMU_BASE + 0x120)
-#define PRCM_ARMITMSK95TO64	(_PRCMU_BASE + 0x124)
-#define PRCM_ARMITMSK127TO96	(_PRCMU_BASE + 0x128)
-#define PRCM_POWER_STATE_VAL	(_PRCMU_BASE + 0x25C)
-#define PRCM_ARMITVAL31TO0	(_PRCMU_BASE + 0x260)
-#define PRCM_ARMITVAL63TO32	(_PRCMU_BASE + 0x264)
-#define PRCM_ARMITVAL95TO64	(_PRCMU_BASE + 0x268)
-#define PRCM_ARMITVAL127TO96	(_PRCMU_BASE + 0x26C)
-
-#define PRCM_HOSTACCESS_REQ	(_PRCMU_BASE + 0x334)
-#define PRCM_HOSTACCESS_REQ_HOSTACCESS_REQ 0x1
-#define ARM_WAKEUP_MODEM	0x1
-
-#define PRCM_ARM_IT1_CLR	(_PRCMU_BASE + 0x48C)
-#define PRCM_ARM_IT1_VAL	(_PRCMU_BASE + 0x494)
-#define PRCM_HOLD_EVT		(_PRCMU_BASE + 0x174)
-
-#define PRCM_MOD_AWAKE_STATUS	(_PRCMU_BASE + 0x4A0)
-#define PRCM_MOD_AWAKE_STATUS_PRCM_MOD_COREPD_AWAKE	BIT(0)
-#define PRCM_MOD_AWAKE_STATUS_PRCM_MOD_AAPD_AWAKE	BIT(1)
-#define PRCM_MOD_AWAKE_STATUS_PRCM_MOD_VMODEM_OFF_ISO	BIT(2)
-
-#define PRCM_ITSTATUS0		(_PRCMU_BASE + 0x148)
-#define PRCM_ITSTATUS1		(_PRCMU_BASE + 0x150)
-#define PRCM_ITSTATUS2		(_PRCMU_BASE + 0x158)
-#define PRCM_ITSTATUS3		(_PRCMU_BASE + 0x160)
-#define PRCM_ITSTATUS4		(_PRCMU_BASE + 0x168)
-#define PRCM_ITSTATUS5		(_PRCMU_BASE + 0x484)
-#define PRCM_ITCLEAR5		(_PRCMU_BASE + 0x488)
-#define PRCM_ARMIT_MASKXP70_IT	(_PRCMU_BASE + 0x1018)
-
-/* System reset register */
-#define PRCM_APE_SOFTRST	(_PRCMU_BASE + 0x228)
-
-/* Level shifter and clamp control registers */
-#define PRCM_MMIP_LS_CLAMP_SET     (_PRCMU_BASE + 0x420)
-#define PRCM_MMIP_LS_CLAMP_CLR     (_PRCMU_BASE + 0x424)
-
-/* PRCMU clock/PLL/reset registers */
-#define PRCM_PLLDSI_FREQ           (_PRCMU_BASE + 0x500)
-#define PRCM_PLLDSI_ENABLE         (_PRCMU_BASE + 0x504)
-#define PRCM_PLLDSI_LOCKP          (_PRCMU_BASE + 0x508)
-#define PRCM_LCDCLK_MGT            (_PRCMU_BASE + PRCM_LCDCLK_MGT_OFF)
-#define PRCM_MCDECLK_MGT           (_PRCMU_BASE + PRCM_MCDECLK_MGT_OFF)
-#define PRCM_HDMICLK_MGT           (_PRCMU_BASE + PRCM_HDMICLK_MGT_OFF)
-#define PRCM_TVCLK_MGT             (_PRCMU_BASE + PRCM_TVCLK_MGT_OFF)
-#define PRCM_DSI_PLLOUT_SEL        (_PRCMU_BASE + 0x530)
-#define PRCM_DSITVCLK_DIV          (_PRCMU_BASE + 0x52C)
-#define PRCM_PLLDSI_LOCKP          (_PRCMU_BASE + 0x508)
-#define PRCM_APE_RESETN_SET        (_PRCMU_BASE + 0x1E4)
-#define PRCM_APE_RESETN_CLR        (_PRCMU_BASE + 0x1E8)
-
-#define PRCM_CLKOCR		   (_PRCMU_BASE + 0x1CC)
-#define PRCM_CLKOCR_CLKOUT0_REF_CLK	(1 << 0)
-#define PRCM_CLKOCR_CLKOUT0_MASK	BITS(0, 13)
-#define PRCM_CLKOCR_CLKOUT1_REF_CLK	(1 << 16)
-#define PRCM_CLKOCR_CLKOUT1_MASK	BITS(16, 29)
-
-/* ePOD and memory power signal control registers */
-#define PRCM_EPOD_C_SET            (_PRCMU_BASE + 0x410)
-#define PRCM_SRAM_LS_SLEEP         (_PRCMU_BASE + 0x304)
-
-/* Debug power control unit registers */
-#define PRCM_POWER_STATE_SET       (_PRCMU_BASE + 0x254)
-
-/* Miscellaneous unit registers */
-#define PRCM_DSI_SW_RESET          (_PRCMU_BASE + 0x324)
-#define PRCM_GPIOCR                (_PRCMU_BASE + 0x138)
-#define PRCM_GPIOCR_DBG_STM_MOD_CMD1            0x800
-#define PRCM_GPIOCR_DBG_UARTMOD_CMD0            0x1
-
-/* PRCMU HW semaphore */
-#define PRCM_SEM                   (_PRCMU_BASE + 0x400)
-#define PRCM_SEM_PRCM_SEM BIT(0)
-
-#define PRCM_TCR                   (_PRCMU_BASE + 0x1C8)
-#define PRCM_TCR_TENSEL_MASK       BITS(0, 7)
-#define PRCM_TCR_STOP_TIMERS       BIT(16)
-#define PRCM_TCR_DOZE_MODE         BIT(17)
-
-#define PRCM_CLKOCR_CLKODIV0_SHIFT	0
-#define PRCM_CLKOCR_CLKODIV0_MASK	BITS(0, 5)
-#define PRCM_CLKOCR_CLKOSEL0_SHIFT	6
-#define PRCM_CLKOCR_CLKOSEL0_MASK	BITS(6, 8)
-#define PRCM_CLKOCR_CLKODIV1_SHIFT	16
-#define PRCM_CLKOCR_CLKODIV1_MASK	BITS(16, 21)
-#define PRCM_CLKOCR_CLKOSEL1_SHIFT	22
-#define PRCM_CLKOCR_CLKOSEL1_MASK	BITS(22, 24)
-#define PRCM_CLKOCR_CLK1TYPE		BIT(28)
-
-#define PRCM_CLK_MGT_CLKPLLDIV_MASK	BITS(0, 4)
-#define PRCM_CLK_MGT_CLKPLLSW_MASK	BITS(5, 7)
-#define PRCM_CLK_MGT_CLKEN		BIT(8)
-
-/* GPIOCR register */
-#define PRCM_GPIOCR_SPI2_SELECT BIT(23)
-
-#define PRCM_DDR_SUBSYS_APE_MINBW	(_PRCMU_BASE + 0x438)
-#define PRCM_CGATING_BYPASS		(_PRCMU_BASE + 0x134)
-#define PRCM_CGATING_BYPASS_ICN2	BIT(6)
-
-/* Miscellaneous unit registers */
-#define PRCM_RESOUTN_SET		(_PRCMU_BASE + 0x214)
-#define PRCM_RESOUTN_CLR		(_PRCMU_BASE + 0x218)
-
-/* System reset register */
-#define PRCM_APE_SOFTRST		(_PRCMU_BASE + 0x228)
-
-#endif /* __DB8500_PRCMU_REGS_H */
diff --git a/drivers/mfd/db8500-prcmu.c b/drivers/mfd/db8500-prcmu.c
index e2c4a26..cea8145 100644
--- a/drivers/mfd/db8500-prcmu.c
+++ b/drivers/mfd/db8500-prcmu.c
@@ -27,14 +27,14 @@
 #include <linux/platform_device.h>
 #include <linux/uaccess.h>
 #include <linux/mfd/core.h>
-#include <linux/mfd/db8500-prcmu.h>
+#include <linux/mfd/dbx500-prcmu.h>
 #include <linux/regulator/db8500-prcmu.h>
 #include <linux/regulator/machine.h>
 #include <mach/hardware.h>
 #include <mach/irqs.h>
 #include <mach/db8500-regs.h>
 #include <mach/id.h>
-#include "db8500-prcmu-regs.h"
+#include "dbx500-prcmu-regs.h"
 
 /* Offset for the firmware version within the TCPM */
 #define PRCMU_FW_VERSION_OFFSET 0xA4
@@ -507,7 +507,7 @@ static struct {
 } prcmu_version;
 
 
-int prcmu_enable_dsipll(void)
+int db8500_prcmu_enable_dsipll(void)
 {
 	int i;
 	unsigned int plldsifreq;
@@ -542,7 +542,7 @@ int prcmu_enable_dsipll(void)
 	return 0;
 }
 
-int prcmu_disable_dsipll(void)
+int db8500_prcmu_disable_dsipll(void)
 {
 	/* Disable dsi pll */
 	writel(PRCMU_DISABLE_PLLDSI, PRCM_PLLDSI_ENABLE);
@@ -551,7 +551,7 @@ int prcmu_disable_dsipll(void)
 	return 0;
 }
 
-int prcmu_set_display_clocks(void)
+int db8500_prcmu_set_display_clocks(void)
 {
 	unsigned long flags;
 	unsigned int dsiclk;
@@ -734,7 +734,7 @@ unlock_and_return:
 	return r;
 }
 
-int prcmu_set_power_state(u8 state, bool keep_ulp_clk, bool keep_ap_pll)
+int db8500_prcmu_set_power_state(u8 state, bool keep_ulp_clk, bool keep_ap_pll)
 {
 	unsigned long flags;
 
@@ -791,7 +791,7 @@ static void config_wakeups(void)
 	last_abb_events = abb_events;
 }
 
-void prcmu_enable_wakeups(u32 wakeups)
+void db8500_prcmu_enable_wakeups(u32 wakeups)
 {
 	unsigned long flags;
 	u32 bits;
@@ -812,7 +812,7 @@ void prcmu_enable_wakeups(u32 wakeups)
 	spin_unlock_irqrestore(&mb0_transfer.lock, flags);
 }
 
-void prcmu_config_abb_event_readout(u32 abb_events)
+void db8500_prcmu_config_abb_event_readout(u32 abb_events)
 {
 	unsigned long flags;
 
@@ -824,7 +824,7 @@ void prcmu_config_abb_event_readout(u32 abb_events)
 	spin_unlock_irqrestore(&mb0_transfer.lock, flags);
 }
 
-void prcmu_get_abb_event_buffer(void __iomem **buf)
+void db8500_prcmu_get_abb_event_buffer(void __iomem **buf)
 {
 	if (readb(tcdm_base + PRCM_ACK_MB0_READ_POINTER) & 1)
 		*buf = (tcdm_base + PRCM_ACK_MB0_WAKEUP_1_4500);
@@ -833,13 +833,13 @@ void prcmu_get_abb_event_buffer(void __iomem **buf)
 }
 
 /**
- * prcmu_set_arm_opp - set the appropriate ARM OPP
+ * db8500_prcmu_set_arm_opp - set the appropriate ARM OPP
  * @opp: The new ARM operating point to which transition is to be made
  * Returns: 0 on success, non-zero on failure
  *
  * This function sets the the operating point of the ARM.
  */
-int prcmu_set_arm_opp(u8 opp)
+int db8500_prcmu_set_arm_opp(u8 opp)
 {
 	int r;
 
@@ -870,11 +870,11 @@ int prcmu_set_arm_opp(u8 opp)
 }
 
 /**
- * prcmu_get_arm_opp - get the current ARM OPP
+ * db8500_prcmu_get_arm_opp - get the current ARM OPP
  *
  * Returns: the current ARM OPP
  */
-int prcmu_get_arm_opp(void)
+int db8500_prcmu_get_arm_opp(void)
 {
 	return readb(tcdm_base + PRCM_ACK_MB1_CURRENT_ARM_OPP);
 }
@@ -1024,14 +1024,14 @@ int prcmu_release_usb_wakeup_state(void)
 }
 
 /**
- * prcmu_set_epod - set the state of a EPOD (power domain)
+ * db8500_prcmu_set_epod - set the state of a EPOD (power domain)
  * @epod_id: The EPOD to set
  * @epod_state: The new EPOD state
  *
  * This function sets the state of a EPOD (power domain). It may not be called
  * from interrupt context.
  */
-int prcmu_set_epod(u16 epod_id, u8 epod_state)
+int db8500_prcmu_set_epod(u16 epod_id, u8 epod_state)
 {
 	int r = 0;
 	bool ram_retention = false;
@@ -1221,14 +1221,14 @@ static int request_reg_clock(u8 clock, bool enable)
 }
 
 /**
- * prcmu_request_clock() - Request for a clock to be enabled or disabled.
+ * db8500_prcmu_request_clock() - Request for a clock to be enabled or disabled.
  * @clock:      The clock for which the request is made.
  * @enable:     Whether the clock should be enabled (true) or disabled (false).
  *
  * This function should only be used by the clock implementation.
  * Do not use it from any other place!
  */
-int prcmu_request_clock(u8 clock, bool enable)
+int db8500_prcmu_request_clock(u8 clock, bool enable)
 {
 	if (clock < PRCMU_NUM_REG_CLOCKS)
 		return request_reg_clock(clock, enable);
@@ -1240,7 +1240,7 @@ int prcmu_request_clock(u8 clock, bool enable)
 		return -EINVAL;
 }
 
-int prcmu_config_esram0_deep_sleep(u8 state)
+int db8500_prcmu_config_esram0_deep_sleep(u8 state)
 {
 	if ((state > ESRAM0_DEEP_SLEEP_STATE_RET) ||
 	    (state < ESRAM0_DEEP_SLEEP_STATE_OFF))
@@ -1515,18 +1515,18 @@ unlock_and_return:
 	mutex_unlock(&mb0_transfer.ac_wake_lock);
 }
 
-bool prcmu_is_ac_wake_requested(void)
+bool db8500_prcmu_is_ac_wake_requested(void)
 {
 	return (atomic_read(&ac_wake_req_state) != 0);
 }
 
 /**
- * prcmu_system_reset - System reset
+ * db8500_prcmu_system_reset - System reset
  *
- * Saves the reset reason code and then sets the APE_SOFRST register which
+ * Saves the reset reason code and then sets the APE_SOFTRST register which
  * fires interrupt to fw
  */
-void prcmu_system_reset(u16 reset_code)
+void db8500_prcmu_system_reset(u16 reset_code)
 {
 	writew(reset_code, (tcdm_base + PRCM_SW_RST_REASON));
 	writel(1, PRCM_APE_SOFTRST);
@@ -1782,7 +1782,7 @@ static struct irq_chip prcmu_irq_chip = {
 	.irq_unmask	= prcmu_irq_unmask,
 };
 
-void __init prcmu_early_init(void)
+void __init db8500_prcmu_early_init(void)
 {
 	unsigned int i;
 
diff --git a/drivers/mfd/dbx500-prcmu-regs.h b/drivers/mfd/dbx500-prcmu-regs.h
new file mode 100644
index 0000000..ec22e9f
--- /dev/null
+++ b/drivers/mfd/dbx500-prcmu-regs.h
@@ -0,0 +1,204 @@
+/*
+ * Copyright (C) STMicroelectronics 2009
+ * Copyright (C) ST-Ericsson SA 2010
+ *
+ * Author: Kumar Sanghvi <kumar.sanghvi@stericsson.com>
+ * Author: Sundar Iyer <sundar.iyer@stericsson.com>
+ *
+ * License Terms: GNU General Public License v2
+ *
+ * PRCM Unit registers
+ */
+
+#ifndef __DB8500_PRCMU_REGS_H
+#define __DB8500_PRCMU_REGS_H
+
+#include <mach/hardware.h>
+
+#define BITS(_start, _end) ((BIT(_end) - BIT(_start)) + BIT(_end))
+
+#define PRCM_SVACLK_MGT_OFF		0x008
+#define PRCM_SIACLK_MGT_OFF		0x00C
+#define PRCM_SGACLK_MGT_OFF		0x014
+#define PRCM_UARTCLK_MGT_OFF		0x018
+#define PRCM_MSP02CLK_MGT_OFF		0x01C
+#define PRCM_I2CCLK_MGT_OFF		0x020
+#define PRCM_SDMMCCLK_MGT_OFF		0x024
+#define PRCM_SLIMCLK_MGT_OFF		0x028
+#define PRCM_PER1CLK_MGT_OFF		0x02C
+#define PRCM_PER2CLK_MGT_OFF		0x030
+#define PRCM_PER3CLK_MGT_OFF		0x034
+#define PRCM_PER5CLK_MGT_OFF		0x038
+#define PRCM_PER6CLK_MGT_OFF		0x03C
+#define PRCM_PER7CLK_MGT_OFF		0x040
+#define PRCM_PWMCLK_MGT_OFF		0x044 /* for DB5500 */
+#define PRCM_IRDACLK_MGT_OFF		0x048 /* for DB5500 */
+#define PRCM_IRRCCLK_MGT_OFF		0x04C /* for DB5500 */
+#define PRCM_LCDCLK_MGT_OFF		0x044
+#define PRCM_BMLCLK_MGT_OFF		0x04C
+#define PRCM_HSITXCLK_MGT_OFF		0x050
+#define PRCM_HSIRXCLK_MGT_OFF		0x054
+#define PRCM_HDMICLK_MGT_OFF		0x058
+#define PRCM_APEATCLK_MGT_OFF		0x05C
+#define PRCM_APETRACECLK_MGT_OFF	0x060
+#define PRCM_MCDECLK_MGT_OFF		0x064
+#define PRCM_IPI2CCLK_MGT_OFF		0x068
+#define PRCM_DSIALTCLK_MGT_OFF		0x06C
+#define PRCM_DMACLK_MGT_OFF		0x074
+#define PRCM_B2R2CLK_MGT_OFF		0x078
+#define PRCM_TVCLK_MGT_OFF		0x07C
+#define PRCM_UNIPROCLK_MGT_OFF		0x278
+#define PRCM_SSPCLK_MGT_OFF		0x280
+#define PRCM_RNGCLK_MGT_OFF		0x284
+#define PRCM_UICCCLK_MGT_OFF		0x27C
+#define PRCM_MSP1CLK_MGT_OFF		0x288
+
+#define PRCM_ARM_PLLDIVPS	(_PRCMU_BASE + 0x118)
+#define PRCM_ARM_PLLDIVPS_ARM_BRM_RATE		0x3f
+#define PRCM_ARM_PLLDIVPS_MAX_MASK		0xf
+
+#define PRCM_PLLARM_LOCKP       (_PRCMU_BASE + 0x0a8)
+#define PRCM_PLLARM_LOCKP_PRCM_PLLARM_LOCKP3	0x2
+
+#define PRCM_ARM_CHGCLKREQ	(_PRCMU_BASE + 0x114)
+#define PRCM_ARM_CHGCLKREQ_PRCM_ARM_CHGCLKREQ	0x1
+
+#define PRCM_PLLARM_ENABLE	(_PRCMU_BASE + 0x98)
+#define PRCM_PLLARM_ENABLE_PRCM_PLLARM_ENABLE	0x1
+#define PRCM_PLLARM_ENABLE_PRCM_PLLARM_COUNTON	0x100
+
+#define PRCM_ARMCLKFIX_MGT	(_PRCMU_BASE + 0x0)
+#define PRCM_A9PL_FORCE_CLKEN	(_PRCMU_BASE + 0x19C)
+#define PRCM_A9_RESETN_CLR	(_PRCMU_BASE + 0x1f4)
+#define PRCM_A9_RESETN_SET	(_PRCMU_BASE + 0x1f0)
+#define PRCM_ARM_LS_CLAMP	(_PRCMU_BASE + 0x30c)
+#define PRCM_SRAM_A9		(_PRCMU_BASE + 0x308)
+
+#define PRCM_A9PL_FORCE_CLKEN_PRCM_A9PL_FORCE_CLKEN BIT(0)
+#define PRCM_A9PL_FORCE_CLKEN_PRCM_A9AXI_FORCE_CLKEN BIT(1)
+
+/* ARM WFI Standby signal register */
+#define PRCM_ARM_WFI_STANDBY    (_PRCMU_BASE + 0x130)
+#define PRCM_IOCR		(_PRCMU_BASE + 0x310)
+#define PRCM_IOCR_IOFORCE			0x1
+
+/* CPU mailbox registers */
+#define PRCM_MBOX_CPU_VAL	(_PRCMU_BASE + 0x0fc)
+#define PRCM_MBOX_CPU_SET	(_PRCMU_BASE + 0x100)
+#define PRCM_MBOX_CPU_CLR	(_PRCMU_BASE + 0x104)
+
+/* Dual A9 core interrupt management unit registers */
+#define PRCM_A9_MASK_REQ	(_PRCMU_BASE + 0x328)
+#define PRCM_A9_MASK_REQ_PRCM_A9_MASK_REQ	0x1
+
+#define PRCM_A9_MASK_ACK	(_PRCMU_BASE + 0x32c)
+#define PRCM_ARMITMSK31TO0	(_PRCMU_BASE + 0x11c)
+#define PRCM_ARMITMSK63TO32	(_PRCMU_BASE + 0x120)
+#define PRCM_ARMITMSK95TO64	(_PRCMU_BASE + 0x124)
+#define PRCM_ARMITMSK127TO96	(_PRCMU_BASE + 0x128)
+#define PRCM_POWER_STATE_VAL	(_PRCMU_BASE + 0x25C)
+#define PRCM_ARMITVAL31TO0	(_PRCMU_BASE + 0x260)
+#define PRCM_ARMITVAL63TO32	(_PRCMU_BASE + 0x264)
+#define PRCM_ARMITVAL95TO64	(_PRCMU_BASE + 0x268)
+#define PRCM_ARMITVAL127TO96	(_PRCMU_BASE + 0x26C)
+
+#define PRCM_HOSTACCESS_REQ	(_PRCMU_BASE + 0x334)
+#define PRCM_HOSTACCESS_REQ_HOSTACCESS_REQ 0x1
+#define ARM_WAKEUP_MODEM	0x1
+
+#define PRCM_ARM_IT1_CLR	(_PRCMU_BASE + 0x48C)
+#define PRCM_ARM_IT1_VAL	(_PRCMU_BASE + 0x494)
+#define PRCM_HOLD_EVT		(_PRCMU_BASE + 0x174)
+
+#define PRCM_MOD_AWAKE_STATUS	(_PRCMU_BASE + 0x4A0)
+#define PRCM_MOD_AWAKE_STATUS_PRCM_MOD_COREPD_AWAKE	BIT(0)
+#define PRCM_MOD_AWAKE_STATUS_PRCM_MOD_AAPD_AWAKE	BIT(1)
+#define PRCM_MOD_AWAKE_STATUS_PRCM_MOD_VMODEM_OFF_ISO	BIT(2)
+
+#define PRCM_ITSTATUS0		(_PRCMU_BASE + 0x148)
+#define PRCM_ITSTATUS1		(_PRCMU_BASE + 0x150)
+#define PRCM_ITSTATUS2		(_PRCMU_BASE + 0x158)
+#define PRCM_ITSTATUS3		(_PRCMU_BASE + 0x160)
+#define PRCM_ITSTATUS4		(_PRCMU_BASE + 0x168)
+#define PRCM_ITSTATUS5		(_PRCMU_BASE + 0x484)
+#define PRCM_ITCLEAR5		(_PRCMU_BASE + 0x488)
+#define PRCM_ARMIT_MASKXP70_IT	(_PRCMU_BASE + 0x1018)
+
+/* System reset register */
+#define PRCM_APE_SOFTRST	(_PRCMU_BASE + 0x228)
+
+/* Level shifter and clamp control registers */
+#define PRCM_MMIP_LS_CLAMP_SET     (_PRCMU_BASE + 0x420)
+#define PRCM_MMIP_LS_CLAMP_CLR     (_PRCMU_BASE + 0x424)
+
+/* PRCMU clock/PLL/reset registers */
+#define PRCM_PLLDSI_FREQ           (_PRCMU_BASE + 0x500)
+#define PRCM_PLLDSI_ENABLE         (_PRCMU_BASE + 0x504)
+#define PRCM_PLLDSI_LOCKP          (_PRCMU_BASE + 0x508)
+#define PRCM_LCDCLK_MGT            (_PRCMU_BASE + PRCM_LCDCLK_MGT_OFF)
+#define PRCM_MCDECLK_MGT           (_PRCMU_BASE + PRCM_MCDECLK_MGT_OFF)
+#define PRCM_HDMICLK_MGT           (_PRCMU_BASE + PRCM_HDMICLK_MGT_OFF)
+#define PRCM_TVCLK_MGT             (_PRCMU_BASE + PRCM_TVCLK_MGT_OFF)
+#define PRCM_DSI_PLLOUT_SEL        (_PRCMU_BASE + 0x530)
+#define PRCM_DSITVCLK_DIV          (_PRCMU_BASE + 0x52C)
+#define PRCM_PLLDSI_LOCKP          (_PRCMU_BASE + 0x508)
+#define PRCM_APE_RESETN_SET        (_PRCMU_BASE + 0x1E4)
+#define PRCM_APE_RESETN_CLR        (_PRCMU_BASE + 0x1E8)
+
+#define PRCM_CLKOCR		   (_PRCMU_BASE + 0x1CC)
+#define PRCM_CLKOCR_CLKOUT0_REF_CLK	(1 << 0)
+#define PRCM_CLKOCR_CLKOUT0_MASK	BITS(0, 13)
+#define PRCM_CLKOCR_CLKOUT1_REF_CLK	(1 << 16)
+#define PRCM_CLKOCR_CLKOUT1_MASK	BITS(16, 29)
+
+/* ePOD and memory power signal control registers */
+#define PRCM_EPOD_C_SET            (_PRCMU_BASE + 0x410)
+#define PRCM_SRAM_LS_SLEEP         (_PRCMU_BASE + 0x304)
+
+/* Debug power control unit registers */
+#define PRCM_POWER_STATE_SET       (_PRCMU_BASE + 0x254)
+
+/* Miscellaneous unit registers */
+#define PRCM_DSI_SW_RESET          (_PRCMU_BASE + 0x324)
+#define PRCM_GPIOCR                (_PRCMU_BASE + 0x138)
+#define PRCM_GPIOCR_DBG_STM_MOD_CMD1            0x800
+#define PRCM_GPIOCR_DBG_UARTMOD_CMD0            0x1
+
+/* PRCMU HW semaphore */
+#define PRCM_SEM                   (_PRCMU_BASE + 0x400)
+#define PRCM_SEM_PRCM_SEM BIT(0)
+
+#define PRCM_TCR                   (_PRCMU_BASE + 0x1C8)
+#define PRCM_TCR_TENSEL_MASK       BITS(0, 7)
+#define PRCM_TCR_STOP_TIMERS       BIT(16)
+#define PRCM_TCR_DOZE_MODE         BIT(17)
+
+#define PRCM_CLKOCR_CLKODIV0_SHIFT	0
+#define PRCM_CLKOCR_CLKODIV0_MASK	BITS(0, 5)
+#define PRCM_CLKOCR_CLKOSEL0_SHIFT	6
+#define PRCM_CLKOCR_CLKOSEL0_MASK	BITS(6, 8)
+#define PRCM_CLKOCR_CLKODIV1_SHIFT	16
+#define PRCM_CLKOCR_CLKODIV1_MASK	BITS(16, 21)
+#define PRCM_CLKOCR_CLKOSEL1_SHIFT	22
+#define PRCM_CLKOCR_CLKOSEL1_MASK	BITS(22, 24)
+#define PRCM_CLKOCR_CLK1TYPE		BIT(28)
+
+#define PRCM_CLK_MGT_CLKPLLDIV_MASK	BITS(0, 4)
+#define PRCM_CLK_MGT_CLKPLLSW_MASK	BITS(5, 7)
+#define PRCM_CLK_MGT_CLKEN		BIT(8)
+
+/* GPIOCR register */
+#define PRCM_GPIOCR_SPI2_SELECT BIT(23)
+
+#define PRCM_DDR_SUBSYS_APE_MINBW	(_PRCMU_BASE + 0x438)
+#define PRCM_CGATING_BYPASS		(_PRCMU_BASE + 0x134)
+#define PRCM_CGATING_BYPASS_ICN2	BIT(6)
+
+/* Miscellaneous unit registers */
+#define PRCM_RESOUTN_SET		(_PRCMU_BASE + 0x214)
+#define PRCM_RESOUTN_CLR		(_PRCMU_BASE + 0x218)
+
+/* System reset register */
+#define PRCM_APE_SOFTRST		(_PRCMU_BASE + 0x228)
+
+#endif /* __DB8500_PRCMU_REGS_H */
diff --git a/drivers/regulator/db8500-prcmu.c b/drivers/regulator/db8500-prcmu.c
index 2bb8f45..2d014a1 100644
--- a/drivers/regulator/db8500-prcmu.c
+++ b/drivers/regulator/db8500-prcmu.c
@@ -13,7 +13,7 @@
 #include <linux/err.h>
 #include <linux/spinlock.h>
 #include <linux/platform_device.h>
-#include <linux/mfd/db8500-prcmu.h>
+#include <linux/mfd/dbx500-prcmu.h>
 #include <linux/regulator/driver.h>
 #include <linux/regulator/machine.h>
 #include <linux/regulator/db8500-prcmu.h>
diff --git a/include/linux/mfd/db5500-prcmu.h b/include/linux/mfd/db5500-prcmu.h
index f097798..9890687 100644
--- a/include/linux/mfd/db5500-prcmu.h
+++ b/include/linux/mfd/db5500-prcmu.h
@@ -5,21 +5,35 @@
  *
  * U5500 PRCMU API.
  */
-#ifndef __MACH_PRCMU_U5500_H
-#define __MACH_PRCMU_U5500_H
+#ifndef __MFD_DB5500_PRCMU_H
+#define __MFD_DB5500_PRCMU_H
 
-#ifdef CONFIG_UX500_SOC_DB5500
+#ifdef CONFIG_MFD_DB5500_PRCMU
 
 void db5500_prcmu_early_init(void);
-
+int db5500_prcmu_set_epod(u16 epod_id, u8 epod_state);
+int db5500_prcmu_set_display_clocks(void);
+int db5500_prcmu_disable_dsipll(void);
+int db5500_prcmu_enable_dsipll(void);
 int db5500_prcmu_abb_read(u8 slave, u8 reg, u8 *value, u8 size);
 int db5500_prcmu_abb_write(u8 slave, u8 reg, u8 *value, u8 size);
+void db5500_prcmu_enable_wakeups(u32 wakeups);
+int db5500_prcmu_request_clock(u8 clock, bool enable);
+void db5500_prcmu_config_abb_event_readout(u32 abb_events);
+void db5500_prcmu_get_abb_event_buffer(void __iomem **buf);
+int prcmu_resetout(u8 resoutn, u8 state);
+int db5500_prcmu_set_power_state(u8 state, bool keep_ulp_clk,
+	bool keep_ap_pll);
+int db5500_prcmu_config_esram0_deep_sleep(u8 state);
+void db5500_prcmu_system_reset(u16 reset_code);
+u16 db5500_prcmu_get_reset_code(void);
+bool db5500_prcmu_is_ac_wake_requested(void);
+int db5500_prcmu_set_arm_opp(u8 opp);
+int db5500_prcmu_get_arm_opp(void);
 
 #else /* !CONFIG_UX500_SOC_DB5500 */
 
-static inline void db5500_prcmu_early_init(void)
-{
-}
+static inline void db5500_prcmu_early_init(void) {}
 
 static inline int db5500_prcmu_abb_read(u8 slave, u8 reg, u8 *value, u8 size)
 {
@@ -31,15 +45,75 @@ static inline int db5500_prcmu_abb_write(u8 slave, u8 reg, u8 *value, u8 size)
 	return -ENOSYS;
 }
 
-#endif /* CONFIG_UX500_SOC_DB5500 */
+static inline int db5500_prcmu_request_clock(u8 clock, bool enable)
+{
+	return 0;
+}
+
+static inline int db5500_prcmu_set_display_clocks(void)
+{
+	return 0;
+}
+
+static inline int db5500_prcmu_disable_dsipll(void)
+{
+	return 0;
+}
+
+static inline int db5500_prcmu_enable_dsipll(void)
+{
+	return 0;
+}
 
-static inline int db5500_prcmu_config_abb_event_readout(u32 abb_events)
+static inline int db5500_prcmu_config_esram0_deep_sleep(u8 state)
 {
-#ifdef CONFIG_MACH_U5500_SIMULATOR
 	return 0;
-#else
-	return -1;
-#endif
 }
 
-#endif /* __MACH_PRCMU_U5500_H */
+static inline void db5500_prcmu_enable_wakeups(u32 wakeups) {}
+
+static inline int prcmu_resetout(u8 resoutn, u8 state)
+{
+	return 0;
+}
+
+static inline int db5500_prcmu_set_epod(u16 epod_id, u8 epod_state)
+{
+	return 0;
+}
+
+static inline void db5500_prcmu_get_abb_event_buffer(void __iomem **buf) {}
+static inline void db5500_prcmu_config_abb_event_readout(u32 abb_events) {}
+
+static inline int db5500_prcmu_set_power_state(u8 state, bool keep_ulp_clk,
+	bool keep_ap_pll)
+{
+	return 0;
+}
+
+static inline void db5500_prcmu_system_reset(u16 reset_code) {}
+
+static inline u16 db5500_prcmu_get_reset_code(void)
+{
+	return 0;
+}
+
+static inline bool db5500_prcmu_is_ac_wake_requested(void)
+{
+	return 0;
+}
+
+static inline int db5500_prcmu_set_arm_opp(u8 opp)
+{
+	return 0;
+}
+
+static inline int db5500_prcmu_get_arm_opp(void)
+{
+	return 0;
+}
+
+
+#endif /* CONFIG_MFD_DB5500_PRCMU */
+
+#endif /* __MFD_DB5500_PRCMU_H */
diff --git a/include/linux/mfd/db8500-prcmu.h b/include/linux/mfd/db8500-prcmu.h
index 917dbcab..60d27f7 100644
--- a/include/linux/mfd/db8500-prcmu.h
+++ b/include/linux/mfd/db8500-prcmu.h
@@ -11,7 +11,6 @@
 #define __MFD_DB8500_PRCMU_H
 
 #include <linux/interrupt.h>
-#include <linux/notifier.h>
 
 /* This portion previously known as <mach/prcmu-fw-defs_v1.h> */
 
@@ -133,7 +132,7 @@ enum ap_pwrst {
  * @APEXECUTE_TO_APIDLE: Power state transition from ApExecute to ApIdle
  */
 enum ap_pwrst_trans {
-	NO_TRANSITION			= 0x00,
+	PRCMU_AP_NO_CHANGE		= 0x00,
 	APEXECUTE_TO_APSLEEP		= 0x01,
 	APIDLE_TO_APSLEEP		= 0x02, /* To be removed */
 	PRCMU_AP_SLEEP			= 0x01,
@@ -146,54 +145,6 @@ enum ap_pwrst_trans {
 };
 
 /**
- * enum ddr_pwrst - DDR power states definition
- * @DDR_PWR_STATE_UNCHANGED: SDRAM and DDR controller state is unchanged
- * @DDR_PWR_STATE_ON:
- * @DDR_PWR_STATE_OFFLOWLAT:
- * @DDR_PWR_STATE_OFFHIGHLAT:
- */
-enum ddr_pwrst {
-	DDR_PWR_STATE_UNCHANGED     = 0x00,
-	DDR_PWR_STATE_ON            = 0x01,
-	DDR_PWR_STATE_OFFLOWLAT     = 0x02,
-	DDR_PWR_STATE_OFFHIGHLAT    = 0x03
-};
-
-/**
- * enum arm_opp - ARM OPP states definition
- * @ARM_OPP_INIT:
- * @ARM_NO_CHANGE: The ARM operating point is unchanged
- * @ARM_100_OPP: The new ARM operating point is arm100opp
- * @ARM_50_OPP: The new ARM operating point is arm50opp
- * @ARM_MAX_OPP: Operating point is "max" (more than 100)
- * @ARM_MAX_FREQ100OPP: Set max opp if available, else 100
- * @ARM_EXTCLK: The new ARM operating point is armExtClk
- */
-enum arm_opp {
-	ARM_OPP_INIT = 0x00,
-	ARM_NO_CHANGE = 0x01,
-	ARM_100_OPP = 0x02,
-	ARM_50_OPP = 0x03,
-	ARM_MAX_OPP = 0x04,
-	ARM_MAX_FREQ100OPP = 0x05,
-	ARM_EXTCLK = 0x07
-};
-
-/**
- * enum ape_opp - APE OPP states definition
- * @APE_OPP_INIT:
- * @APE_NO_CHANGE: The APE operating point is unchanged
- * @APE_100_OPP: The new APE operating point is ape100opp
- * @APE_50_OPP: 50%
- */
-enum ape_opp {
-	APE_OPP_INIT = 0x00,
-	APE_NO_CHANGE = 0x01,
-	APE_100_OPP = 0x02,
-	APE_50_OPP = 0x03
-};
-
-/**
  * enum hw_acc_state - State definition for hardware accelerator
  * @HW_NO_CHANGE: The hardware accelerator state must remain unchanged
  * @HW_OFF: The hardware accelerator must be switched off
@@ -469,26 +420,6 @@ enum auto_enable {
 
 /* End of file previously known as prcmu-fw-defs_v1.h */
 
-/* PRCMU Wakeup defines */
-enum prcmu_wakeup_index {
-	PRCMU_WAKEUP_INDEX_RTC,
-	PRCMU_WAKEUP_INDEX_RTT0,
-	PRCMU_WAKEUP_INDEX_RTT1,
-	PRCMU_WAKEUP_INDEX_HSI0,
-	PRCMU_WAKEUP_INDEX_HSI1,
-	PRCMU_WAKEUP_INDEX_USB,
-	PRCMU_WAKEUP_INDEX_ABB,
-	PRCMU_WAKEUP_INDEX_ABB_FIFO,
-	PRCMU_WAKEUP_INDEX_ARM,
-	NUM_PRCMU_WAKEUP_INDICES
-};
-#define PRCMU_WAKEUP(_name) (BIT(PRCMU_WAKEUP_INDEX_##_name))
-
-/* PRCMU QoS APE OPP class */
-#define PRCMU_QOS_APE_OPP 1
-#define PRCMU_QOS_DDR_OPP 2
-#define PRCMU_QOS_DEFAULT_VALUE -1
-
 /**
  * enum hw_acc_dev - enum for hw accelerators
  * @HW_ACC_SVAMMDSP: for SVAMMDSP
@@ -527,64 +458,6 @@ enum hw_acc_dev {
 };
 
 /*
- * Ids for all EPODs (power domains)
- * - EPOD_ID_SVAMMDSP: power domain for SVA MMDSP
- * - EPOD_ID_SVAPIPE: power domain for SVA pipe
- * - EPOD_ID_SIAMMDSP: power domain for SIA MMDSP
- * - EPOD_ID_SIAPIPE: power domain for SIA pipe
- * - EPOD_ID_SGA: power domain for SGA
- * - EPOD_ID_B2R2_MCDE: power domain for B2R2 and MCDE
- * - EPOD_ID_ESRAM12: power domain for ESRAM 1 and 2
- * - EPOD_ID_ESRAM34: power domain for ESRAM 3 and 4
- * - NUM_EPOD_ID: number of power domains
- */
-#define EPOD_ID_SVAMMDSP	0
-#define EPOD_ID_SVAPIPE		1
-#define EPOD_ID_SIAMMDSP	2
-#define EPOD_ID_SIAPIPE		3
-#define EPOD_ID_SGA		4
-#define EPOD_ID_B2R2_MCDE	5
-#define EPOD_ID_ESRAM12		6
-#define EPOD_ID_ESRAM34		7
-#define NUM_EPOD_ID		8
-
-/*
- * state definition for EPOD (power domain)
- * - EPOD_STATE_NO_CHANGE: The EPOD should remain unchanged
- * - EPOD_STATE_OFF: The EPOD is switched off
- * - EPOD_STATE_RAMRET: The EPOD is switched off with its internal RAM in
- *                         retention
- * - EPOD_STATE_ON_CLK_OFF: The EPOD is switched on, clock is still off
- * - EPOD_STATE_ON: Same as above, but with clock enabled
- */
-#define EPOD_STATE_NO_CHANGE	0x00
-#define EPOD_STATE_OFF		0x01
-#define EPOD_STATE_RAMRET	0x02
-#define EPOD_STATE_ON_CLK_OFF	0x03
-#define EPOD_STATE_ON		0x04
-
-/*
- * CLKOUT sources
- */
-#define PRCMU_CLKSRC_CLK38M		0x00
-#define PRCMU_CLKSRC_ACLK		0x01
-#define PRCMU_CLKSRC_SYSCLK		0x02
-#define PRCMU_CLKSRC_LCDCLK		0x03
-#define PRCMU_CLKSRC_SDMMCCLK		0x04
-#define PRCMU_CLKSRC_TVCLK		0x05
-#define PRCMU_CLKSRC_TIMCLK		0x06
-#define PRCMU_CLKSRC_CLK009		0x07
-/* These are only valid for CLKOUT1: */
-#define PRCMU_CLKSRC_SIAMMDSPCLK	0x40
-#define PRCMU_CLKSRC_I2CCLK		0x41
-#define PRCMU_CLKSRC_MSP02CLK		0x42
-#define PRCMU_CLKSRC_ARMPLL_OBSCLK	0x43
-#define PRCMU_CLKSRC_HSIRXCLK		0x44
-#define PRCMU_CLKSRC_HSITXCLK		0x45
-#define PRCMU_CLKSRC_ARMCLKFIX		0x46
-#define PRCMU_CLKSRC_HDMICLK		0x47
-
-/*
  * Definitions for autonomous power management configuration.
  */
 
@@ -620,88 +493,12 @@ struct prcmu_auto_pm_config {
 	u8 sva_policy;
 };
 
-/**
- * enum ddr_opp - DDR OPP states definition
- * @DDR_100_OPP: The new DDR operating point is ddr100opp
- * @DDR_50_OPP: The new DDR operating point is ddr50opp
- * @DDR_25_OPP: The new DDR operating point is ddr25opp
- */
-enum ddr_opp {
-	DDR_100_OPP = 0x00,
-	DDR_50_OPP = 0x01,
-	DDR_25_OPP = 0x02,
-};
-
-/*
- * Clock identifiers.
- */
-enum prcmu_clock {
-	PRCMU_SGACLK,
-	PRCMU_UARTCLK,
-	PRCMU_MSP02CLK,
-	PRCMU_MSP1CLK,
-	PRCMU_I2CCLK,
-	PRCMU_SDMMCCLK,
-	PRCMU_SLIMCLK,
-	PRCMU_PER1CLK,
-	PRCMU_PER2CLK,
-	PRCMU_PER3CLK,
-	PRCMU_PER5CLK,
-	PRCMU_PER6CLK,
-	PRCMU_PER7CLK,
-	PRCMU_LCDCLK,
-	PRCMU_BMLCLK,
-	PRCMU_HSITXCLK,
-	PRCMU_HSIRXCLK,
-	PRCMU_HDMICLK,
-	PRCMU_APEATCLK,
-	PRCMU_APETRACECLK,
-	PRCMU_MCDECLK,
-	PRCMU_IPI2CCLK,
-	PRCMU_DSIALTCLK,
-	PRCMU_DMACLK,
-	PRCMU_B2R2CLK,
-	PRCMU_TVCLK,
-	PRCMU_SSPCLK,
-	PRCMU_RNGCLK,
-	PRCMU_UICCCLK,
-	PRCMU_NUM_REG_CLOCKS,
-	PRCMU_SYSCLK = PRCMU_NUM_REG_CLOCKS,
-	PRCMU_TIMCLK,
-};
-
-/*
- * Definitions for controlling ESRAM0 in deep sleep.
- */
-#define ESRAM0_DEEP_SLEEP_STATE_OFF 1
-#define ESRAM0_DEEP_SLEEP_STATE_RET 2
-
-#ifdef CONFIG_MFD_DB8500_PRCMU
-void __init prcmu_early_init(void);
-int prcmu_set_display_clocks(void);
-int prcmu_disable_dsipll(void);
-int prcmu_enable_dsipll(void);
-#else
-static inline void __init prcmu_early_init(void) {}
-#endif
-
 #ifdef CONFIG_MFD_DB8500_PRCMU
 
+void db8500_prcmu_early_init(void);
 int prcmu_set_rc_a2p(enum romcode_write);
 enum romcode_read prcmu_get_rc_p2a(void);
 enum ap_pwrst prcmu_get_xp70_current_state(void);
-int prcmu_set_power_state(u8 state, bool keep_ulp_clk, bool keep_ap_pll);
-
-void prcmu_enable_wakeups(u32 wakeups);
-static inline void prcmu_disable_wakeups(void)
-{
-	prcmu_enable_wakeups(0);
-}
-
-void prcmu_config_abb_event_readout(u32 abb_events);
-void prcmu_get_abb_event_buffer(void __iomem **buf);
-int prcmu_set_arm_opp(u8 opp);
-int prcmu_get_arm_opp(void);
 bool prcmu_has_arm_maxopp(void);
 bool prcmu_is_u8400(void);
 int prcmu_set_ape_opp(u8 opp);
@@ -710,19 +507,14 @@ int prcmu_request_ape_opp_100_voltage(bool enable);
 int prcmu_release_usb_wakeup_state(void);
 int prcmu_set_ddr_opp(u8 opp);
 int prcmu_get_ddr_opp(void);
-unsigned long prcmu_qos_get_cpufreq_opp_delay(void);
-void prcmu_qos_set_cpufreq_opp_delay(unsigned long);
 /* NOTE! Use regulator framework instead */
 int prcmu_set_hwacc(u16 hw_acc_dev, u8 state);
-int prcmu_set_epod(u16 epod_id, u8 epod_state);
 void prcmu_configure_auto_pm(struct prcmu_auto_pm_config *sleep,
 	struct prcmu_auto_pm_config *idle);
 bool prcmu_is_auto_pm_enabled(void);
 
 int prcmu_config_clkout(u8 clkout, u8 source, u8 div);
-int prcmu_request_clock(u8 clock, bool enable);
 int prcmu_set_clock_divider(u8 clock, u8 divider);
-int prcmu_config_esram0_deep_sleep(u8 state);
 int prcmu_config_hotdog(u8 threshold);
 int prcmu_config_hotmon(u8 low, u8 high);
 int prcmu_start_temp_sense(u16 cycles32k);
@@ -732,14 +524,36 @@ int prcmu_abb_write(u8 slave, u8 reg, u8 *value, u8 size);
 
 void prcmu_ac_wake_req(void);
 void prcmu_ac_sleep_req(void);
-void prcmu_system_reset(u16 reset_code);
 void prcmu_modem_reset(void);
-bool prcmu_is_ac_wake_requested(void);
 void prcmu_enable_spi2(void);
 void prcmu_disable_spi2(void);
 
+int prcmu_config_a9wdog(u8 num, bool sleep_auto_off);
+int prcmu_enable_a9wdog(u8 id);
+int prcmu_disable_a9wdog(u8 id);
+int prcmu_kick_a9wdog(u8 id);
+int prcmu_load_a9wdog(u8 id, u32 val);
+
+void db8500_prcmu_system_reset(u16 reset_code);
+int db8500_prcmu_set_power_state(u8 state, bool keep_ulp_clk, bool keep_ap_pll);
+void db8500_prcmu_enable_wakeups(u32 wakeups);
+int db8500_prcmu_set_epod(u16 epod_id, u8 epod_state);
+int db8500_prcmu_request_clock(u8 clock, bool enable);
+int db8500_prcmu_set_display_clocks(void);
+int db8500_prcmu_disable_dsipll(void);
+int db8500_prcmu_enable_dsipll(void);
+void db8500_prcmu_config_abb_event_readout(u32 abb_events);
+void db8500_prcmu_get_abb_event_buffer(void __iomem **buf);
+int db8500_prcmu_config_esram0_deep_sleep(u8 state);
+u16 db8500_prcmu_get_reset_code(void);
+bool db8500_prcmu_is_ac_wake_requested(void);
+int db8500_prcmu_set_arm_opp(u8 opp);
+int db8500_prcmu_get_arm_opp(void);
+
 #else /* !CONFIG_MFD_DB8500_PRCMU */
 
+static inline void db8500_prcmu_early_init(void) {}
+
 static inline int prcmu_set_rc_a2p(enum romcode_write code)
 {
 	return 0;
@@ -755,34 +569,12 @@ static inline enum ap_pwrst prcmu_get_xp70_current_state(void)
 	return AP_EXECUTE;
 }
 
-static inline int prcmu_set_power_state(u8 state, bool keep_ulp_clk,
-	bool keep_ap_pll)
-{
-	return 0;
-}
-
-static inline void prcmu_enable_wakeups(u32 wakeups) {}
-
-static inline void prcmu_disable_wakeups(void) {}
-
-static inline void prcmu_config_abb_event_readout(u32 abb_events) {}
-
-static inline int prcmu_set_arm_opp(u8 opp)
-{
-	return 0;
-}
-
-static inline int prcmu_get_arm_opp(void)
-{
-	return ARM_100_OPP;
-}
-
-static bool prcmu_has_arm_maxopp(void)
+static inline bool prcmu_has_arm_maxopp(void)
 {
 	return false;
 }
 
-static bool prcmu_is_u8400(void)
+static inline bool prcmu_is_u8400(void)
 {
 	return false;
 }
@@ -817,13 +609,6 @@ static inline int prcmu_get_ddr_opp(void)
 	return DDR_100_OPP;
 }
 
-static inline unsigned long prcmu_qos_get_cpufreq_opp_delay(void)
-{
-	return 0;
-}
-
-static inline void prcmu_qos_set_cpufreq_opp_delay(unsigned long n) {}
-
 static inline int prcmu_set_hwacc(u16 hw_acc_dev, u8 state)
 {
 	return 0;
@@ -844,21 +629,11 @@ static inline int prcmu_config_clkout(u8 clkout, u8 source, u8 div)
 	return 0;
 }
 
-static inline int prcmu_request_clock(u8 clock, bool enable)
-{
-	return 0;
-}
-
 static inline int prcmu_set_clock_divider(u8 clock, u8 divider)
 {
 	return 0;
 }
 
-int prcmu_config_esram0_deep_sleep(u8 state)
-{
-	return 0;
-}
-
 static inline int prcmu_config_hotdog(u8 threshold)
 {
 	return 0;
@@ -893,86 +668,107 @@ static inline void prcmu_ac_wake_req(void) {}
 
 static inline void prcmu_ac_sleep_req(void) {}
 
-static inline void prcmu_system_reset(u16 reset_code) {}
-
 static inline void prcmu_modem_reset(void) {}
 
-static inline bool prcmu_is_ac_wake_requested(void)
+static inline int prcmu_enable_spi2(void)
 {
-	return false;
+	return 0;
 }
 
-#ifndef CONFIG_UX500_SOC_DB5500
-static inline int prcmu_set_display_clocks(void)
+static inline int prcmu_disable_spi2(void)
 {
 	return 0;
 }
 
-static inline int prcmu_disable_dsipll(void)
+static inline void db8500_prcmu_system_reset(u16 reset_code) {}
+
+static inline int db8500_prcmu_set_power_state(u8 state, bool keep_ulp_clk,
+	bool keep_ap_pll)
 {
 	return 0;
 }
 
-static inline int prcmu_enable_dsipll(void)
+static inline void db8500_prcmu_enable_wakeups(u32 wakeups) {}
+
+static inline int db8500_prcmu_set_epod(u16 epod_id, u8 epod_state)
 {
 	return 0;
 }
-#endif
 
-static inline int prcmu_enable_spi2(void)
+static inline int db8500_prcmu_request_clock(u8 clock, bool enable)
 {
 	return 0;
 }
 
-static inline int prcmu_disable_spi2(void)
+static inline int db8500_prcmu_set_display_clocks(void)
 {
 	return 0;
 }
 
-#endif /* !CONFIG_MFD_DB8500_PRCMU */
+static inline int db8500_prcmu_disable_dsipll(void)
+{
+	return 0;
+}
+
+static inline int db8500_prcmu_enable_dsipll(void)
+{
+	return 0;
+}
+
+static inline int db8500_prcmu_config_esram0_deep_sleep(u8 state)
+{
+	return 0;
+}
+
+static inline void db8500_prcmu_config_abb_event_readout(u32 abb_events) {}
 
-#ifdef CONFIG_UX500_PRCMU_QOS_POWER
-int prcmu_qos_requirement(int pm_qos_class);
-int prcmu_qos_add_requirement(int pm_qos_class, char *name, s32 value);
-int prcmu_qos_update_requirement(int pm_qos_class, char *name, s32 new_value);
-void prcmu_qos_remove_requirement(int pm_qos_class, char *name);
-int prcmu_qos_add_notifier(int prcmu_qos_class,
-			   struct notifier_block *notifier);
-int prcmu_qos_remove_notifier(int prcmu_qos_class,
-			      struct notifier_block *notifier);
-#else
-static inline int prcmu_qos_requirement(int prcmu_qos_class)
+static inline void db8500_prcmu_get_abb_event_buffer(void __iomem **buf) {}
+
+static inline u16 db8500_prcmu_get_reset_code(void)
 {
 	return 0;
 }
 
-static inline int prcmu_qos_add_requirement(int prcmu_qos_class,
-					    char *name, s32 value)
+static inline int prcmu_config_a9wdog(u8 num, bool sleep_auto_off)
 {
 	return 0;
 }
 
-static inline int prcmu_qos_update_requirement(int prcmu_qos_class,
-					       char *name, s32 new_value)
+static inline int prcmu_enable_a9wdog(u8 id)
 {
 	return 0;
 }
 
-static inline void prcmu_qos_remove_requirement(int prcmu_qos_class, char *name)
+static inline int prcmu_disable_a9wdog(u8 id)
 {
+	return 0;
 }
 
-static inline int prcmu_qos_add_notifier(int prcmu_qos_class,
-					 struct notifier_block *notifier)
+static inline int prcmu_kick_a9wdog(u8 id)
 {
 	return 0;
 }
-static inline int prcmu_qos_remove_notifier(int prcmu_qos_class,
-					    struct notifier_block *notifier)
+
+static inline int prcmu_load_a9wdog(u8 id, u32 val)
 {
 	return 0;
 }
 
-#endif
+static inline bool db8500_prcmu_is_ac_wake_requested(void)
+{
+	return 0;
+}
+
+static inline int db8500_prcmu_set_arm_opp(u8 opp)
+{
+	return 0;
+}
+
+static inline int db8500_prcmu_get_arm_opp(void)
+{
+	return 0;
+}
+
+#endif /* !CONFIG_MFD_DB8500_PRCMU */
 
 #endif /* __MFD_DB8500_PRCMU_H */
diff --git a/include/linux/mfd/dbx500-prcmu.h b/include/linux/mfd/dbx500-prcmu.h
index 6c7584d..bac942f 100644
--- a/include/linux/mfd/dbx500-prcmu.h
+++ b/include/linux/mfd/dbx500-prcmu.h
@@ -240,7 +240,7 @@ static inline int prcmu_set_power_state(u8 state, bool keep_ulp_clk,
 static inline int prcmu_set_epod(u16 epod_id, u8 epod_state)
 {
 	if (machine_is_u5500())
-		return db5500_prcmu_set_epod(epod_id, epod_state);
+		return -EINVAL;
 	else
 		return db8500_prcmu_set_epod(epod_id, epod_state);
 }
@@ -295,7 +295,7 @@ int prcmu_get_ddr_opp(void);
 static inline int prcmu_set_arm_opp(u8 opp)
 {
 	if (machine_is_u5500())
-		return db5500_prcmu_set_arm_opp(opp);
+		return -EINVAL;
 	else
 		return db8500_prcmu_set_arm_opp(opp);
 }
@@ -303,7 +303,7 @@ static inline int prcmu_set_arm_opp(u8 opp)
 static inline int prcmu_get_arm_opp(void)
 {
 	if (machine_is_u5500())
-		return db5500_prcmu_get_arm_opp();
+		return -EINVAL;
 	else
 		return db8500_prcmu_get_arm_opp();
 }
@@ -362,7 +362,7 @@ static inline int prcmu_enable_dsipll(void)
 static inline int prcmu_config_esram0_deep_sleep(u8 state)
 {
 	if (machine_is_u5500())
-		return db5500_prcmu_config_esram0_deep_sleep(state);
+		return -EINVAL;
 	else
 		return db8500_prcmu_config_esram0_deep_sleep(state);
 }
-- 
1.7.3.2

