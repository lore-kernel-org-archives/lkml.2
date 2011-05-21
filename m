Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754225Ab1EUIoK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 May 2011 04:44:10 -0400
Received: from eu1sys200aog108.obsmtp.com ([207.126.144.125]:53060 "EHLO
	eu1sys200aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752970Ab1EUInD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 May 2011 04:43:03 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Samuel Ortiz <sameo@linux.intel.com>, <linux-kernel@vger.kernel.org>
Cc: Lee Jones <lee.jones@linaro.org>, Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 07/13] mach-ux500: move the DB8500 PRCMU driver to MFD
Date: Sat, 21 May 2011 10:42:34 +0200
Message-ID: <1305967354-16577-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

We have decided that this function arbiter fits better in the MFD
subsystem. Since we need to concatenate the split header files we move
it basically like this:

mv mach-ux500/prcmu-db8500.c drivers/mfd/db8500-prcmu.c
mv mach-ux500/include/mach/prcmu-defs.h include/linux/mfd/db8500-prcmu.h
mv mach-ux500/include/mach/prcmu-regs.h drivers/mfd/db8500-prcmu-regs.h
mach-ux500/include/mach/prcmu.h >> include/linux/mfd/db8500-prcmu.h
rm arch/arm/mach-ux500/include/mach/prcmu.h

Then we update different #include statements and Makefile orders etc
to make the PRCMU driver compile, link and boot in the new place
without really changing any code.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 arch/arm/mach-ux500/Kconfig                   |    1 +
 arch/arm/mach-ux500/Makefile                  |    2 +-
 arch/arm/mach-ux500/cpu.c                     |    2 +-
 arch/arm/mach-ux500/cpufreq.c                 |    3 +-
 arch/arm/mach-ux500/include/mach/prcmu-defs.h |   30 --
 arch/arm/mach-ux500/include/mach/prcmu-regs.h |   94 ------
 arch/arm/mach-ux500/include/mach/prcmu.h      |   28 --
 arch/arm/mach-ux500/prcmu-db8500.c            |  394 ------------------------
 drivers/mfd/Kconfig                           |   12 +-
 drivers/mfd/Makefile                          |    4 +-
 drivers/mfd/ab8500-i2c.c                      |    3 +-
 drivers/mfd/db8500-prcmu-regs.h               |   94 ++++++
 drivers/mfd/db8500-prcmu.c                    |  395 +++++++++++++++++++++++++
 include/linux/mfd/db8500-prcmu.h              |   58 ++++
 14 files changed, 566 insertions(+), 554 deletions(-)
 delete mode 100644 arch/arm/mach-ux500/include/mach/prcmu-defs.h
 delete mode 100644 arch/arm/mach-ux500/include/mach/prcmu-regs.h
 delete mode 100644 arch/arm/mach-ux500/include/mach/prcmu.h
 delete mode 100644 arch/arm/mach-ux500/prcmu-db8500.c
 create mode 100644 drivers/mfd/db8500-prcmu-regs.h
 create mode 100644 drivers/mfd/db8500-prcmu.c
 create mode 100644 include/linux/mfd/db8500-prcmu.h

diff --git a/arch/arm/mach-ux500/Kconfig b/arch/arm/mach-ux500/Kconfig
index 5862601..8071d27 100644
--- a/arch/arm/mach-ux500/Kconfig
+++ b/arch/arm/mach-ux500/Kconfig
@@ -15,6 +15,7 @@ config UX500_SOC_DB5500
 
 config UX500_SOC_DB8500
 	bool "DB8500"
+	select MFD_DB8500_PRCMU
 
 endmenu
 
diff --git a/arch/arm/mach-ux500/Makefile b/arch/arm/mach-ux500/Makefile
index 2a08a10..7a1d43e 100644
--- a/arch/arm/mach-ux500/Makefile
+++ b/arch/arm/mach-ux500/Makefile
@@ -5,7 +5,7 @@
 obj-y				:= clock.o cpu.o devices.o devices-common.o \
 				   id.o usb.o
 obj-$(CONFIG_UX500_SOC_DB5500)	+= cpu-db5500.o dma-db5500.o
-obj-$(CONFIG_UX500_SOC_DB8500)	+= cpu-db8500.o devices-db8500.o prcmu-db8500.o
+obj-$(CONFIG_UX500_SOC_DB8500)	+= cpu-db8500.o devices-db8500.o
 obj-$(CONFIG_MACH_U8500)	+= board-mop500.o board-mop500-sdi.o \
 				board-mop500-regulators.o \
 				board-mop500-uib.o board-mop500-stuib.o \
diff --git a/arch/arm/mach-ux500/cpu.c b/arch/arm/mach-ux500/cpu.c
index 0190e0e..11360f7 100644
--- a/arch/arm/mach-ux500/cpu.c
+++ b/arch/arm/mach-ux500/cpu.c
@@ -8,6 +8,7 @@
 #include <linux/platform_device.h>
 #include <linux/io.h>
 #include <linux/clk.h>
+#include <linux/mfd/db8500-prcmu.h>
 
 #include <asm/cacheflush.h>
 #include <asm/hardware/cache-l2x0.h>
@@ -19,7 +20,6 @@
 #include <mach/hardware.h>
 #include <mach/setup.h>
 #include <mach/devices.h>
-#include <mach/prcmu.h>
 
 #include "clock.h"
 
diff --git a/arch/arm/mach-ux500/cpufreq.c b/arch/arm/mach-ux500/cpufreq.c
index 5c5b747..d196939 100644
--- a/arch/arm/mach-ux500/cpufreq.c
+++ b/arch/arm/mach-ux500/cpufreq.c
@@ -17,10 +17,9 @@
 #include <linux/kernel.h>
 #include <linux/cpufreq.h>
 #include <linux/delay.h>
+#include <linux/mfd/db8500-prcmu.h>
 
 #include <mach/hardware.h>
-#include <mach/prcmu.h>
-#include <mach/prcmu-defs.h>
 
 #define DRIVER_NAME "cpufreq-u8500"
 #define CPUFREQ_NAME "u8500"
diff --git a/arch/arm/mach-ux500/include/mach/prcmu-defs.h b/arch/arm/mach-ux500/include/mach/prcmu-defs.h
deleted file mode 100644
index 848ba64..0000000
--- a/arch/arm/mach-ux500/include/mach/prcmu-defs.h
+++ /dev/null
@@ -1,30 +0,0 @@
-/*
- * Copyright (C) STMicroelectronics 2009
- * Copyright (C) ST-Ericsson SA 2010
- *
- * Author: Sundar Iyer <sundar.iyer@stericsson.com>
- * Author: Martin Persson <martin.persson@stericsson.com>
- *
- * License Terms: GNU General Public License v2
- *
- * PRCM Unit definitions
- */
-
-#ifndef __MACH_PRCMU_DEFS_H
-#define __MACH_PRCMU_DEFS_H
-
-enum prcmu_cpu_opp {
-	CPU_OPP_INIT	  = 0x00,
-	CPU_OPP_NO_CHANGE = 0x01,
-	CPU_OPP_100	  = 0x02,
-	CPU_OPP_50	  = 0x03,
-	CPU_OPP_MAX	  = 0x04,
-	CPU_OPP_EXT_CLK	  = 0x07
-};
-enum prcmu_ape_opp {
-	APE_OPP_NO_CHANGE = 0x00,
-	APE_OPP_100	  = 0x02,
-	APE_OPP_50	  = 0x03,
-};
-
-#endif /* __MACH_PRCMU_DEFS_H */
diff --git a/arch/arm/mach-ux500/include/mach/prcmu-regs.h b/arch/arm/mach-ux500/include/mach/prcmu-regs.h
deleted file mode 100644
index c1226da..0000000
--- a/arch/arm/mach-ux500/include/mach/prcmu-regs.h
+++ /dev/null
@@ -1,94 +0,0 @@
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
-#define PRCM_ARM_CHGCLKREQ	(_PRCMU_BASE + 0x114)
-#define PRCM_PLLARM_ENABLE	(_PRCMU_BASE + 0x98)
-#define PRCM_ARMCLKFIX_MGT	(_PRCMU_BASE + 0x0)
-#define PRCM_A9_RESETN_CLR	(_PRCMU_BASE + 0x1f4)
-#define PRCM_A9_RESETN_SET	(_PRCMU_BASE + 0x1f0)
-#define PRCM_ARM_LS_CLAMP	(_PRCMU_BASE + 0x30c)
-#define PRCM_SRAM_A9		(_PRCMU_BASE + 0x308)
-
-/* ARM WFI Standby signal register */
-#define PRCM_ARM_WFI_STANDBY    (_PRCMU_BASE + 0x130)
-#define PRCMU_IOCR              (_PRCMU_BASE + 0x310)
-
-/* CPU mailbox registers */
-#define PRCM_MBOX_CPU_VAL	(_PRCMU_BASE + 0x0fc)
-#define PRCM_MBOX_CPU_SET	(_PRCMU_BASE + 0x100)
-#define PRCM_MBOX_CPU_CLR	(_PRCMU_BASE + 0x104)
-
-/* Dual A9 core interrupt management unit registers */
-#define PRCM_A9_MASK_REQ	(_PRCMU_BASE + 0x328)
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
-#define PRCM_LCDCLK_MGT            (_PRCMU_BASE + 0x044)
-#define PRCM_MCDECLK_MGT           (_PRCMU_BASE + 0x064)
-#define PRCM_HDMICLK_MGT           (_PRCMU_BASE + 0x058)
-#define PRCM_TVCLK_MGT             (_PRCMU_BASE + 0x07c)
-#define PRCM_DSI_PLLOUT_SEL        (_PRCMU_BASE + 0x530)
-#define PRCM_DSITVCLK_DIV          (_PRCMU_BASE + 0x52C)
-#define PRCM_APE_RESETN_SET        (_PRCMU_BASE + 0x1E4)
-#define PRCM_APE_RESETN_CLR        (_PRCMU_BASE + 0x1E8)
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
-
-#endif /* __MACH_PRCMU_REGS_H */
diff --git a/arch/arm/mach-ux500/include/mach/prcmu.h b/arch/arm/mach-ux500/include/mach/prcmu.h
deleted file mode 100644
index c49e456..0000000
--- a/arch/arm/mach-ux500/include/mach/prcmu.h
+++ /dev/null
@@ -1,28 +0,0 @@
-/*
- * Copyright (C) STMicroelectronics 2009
- * Copyright (C) ST-Ericsson SA 2010
- *
- * Author: Kumar Sanghvi <kumar.sanghvi@stericsson.com>
- * Author: Sundar Iyer <sundar.iyer@stericsson.com>
- * Author: Mattias Nilsson <mattias.i.nilsson@stericsson.com>
- *
- * License Terms: GNU General Public License v2
- *
- * PRCM Unit f/w API
- */
-#ifndef __MACH_PRCMU_H
-#define __MACH_PRCMU_H
-#include <mach/prcmu-defs.h>
-
-void __init prcmu_early_init(void);
-int prcmu_abb_read(u8 slave, u8 reg, u8 *value, u8 size);
-int prcmu_abb_write(u8 slave, u8 reg, u8 *value, u8 size);
-int prcmu_set_ape_opp(enum prcmu_ape_opp opp);
-int prcmu_set_cpu_opp(enum prcmu_cpu_opp opp);
-int prcmu_set_ape_cpu_opps(enum prcmu_ape_opp ape_opp,
-			   enum prcmu_cpu_opp cpu_opp);
-int prcmu_get_ape_opp(void);
-int prcmu_get_cpu_opp(void);
-bool prcmu_has_arm_maxopp(void);
-
-#endif /* __MACH_PRCMU_H */
diff --git a/arch/arm/mach-ux500/prcmu-db8500.c b/arch/arm/mach-ux500/prcmu-db8500.c
deleted file mode 100644
index c522d26..0000000
--- a/arch/arm/mach-ux500/prcmu-db8500.c
+++ /dev/null
@@ -1,394 +0,0 @@
-/*
- * Copyright (C) STMicroelectronics 2009
- * Copyright (C) ST-Ericsson SA 2010
- *
- * License Terms: GNU General Public License v2
- * Author: Kumar Sanghvi <kumar.sanghvi@stericsson.com>
- * Author: Sundar Iyer <sundar.iyer@stericsson.com>
- * Author: Mattias Nilsson <mattias.i.nilsson@stericsson.com>
- *
- * U8500 PRCM Unit interface driver
- *
- */
-#include <linux/kernel.h>
-#include <linux/module.h>
-#include <linux/errno.h>
-#include <linux/err.h>
-#include <linux/io.h>
-#include <linux/mutex.h>
-#include <linux/completion.h>
-#include <linux/jiffies.h>
-#include <linux/bitops.h>
-#include <linux/interrupt.h>
-
-#include <mach/hardware.h>
-#include <mach/prcmu-regs.h>
-#include <mach/prcmu-defs.h>
-
-/* Global var to runtime determine TCDM base for v2 or v1 */
-static __iomem void *tcdm_base;
-
-#define _MBOX_HEADER		(tcdm_base + 0xFE8)
-#define MBOX_HEADER_REQ_MB0	(_MBOX_HEADER + 0x0)
-
-#define REQ_MB1 (tcdm_base + 0xFD0)
-#define REQ_MB5 (tcdm_base + 0xE44)
-
-#define REQ_MB1_ARMOPP		(REQ_MB1 + 0x0)
-#define REQ_MB1_APEOPP		(REQ_MB1 + 0x1)
-#define REQ_MB1_BOOSTOPP	(REQ_MB1 + 0x2)
-
-#define ACK_MB1 (tcdm_base + 0xE04)
-#define ACK_MB5 (tcdm_base + 0xDF4)
-
-#define ACK_MB1_CURR_ARMOPP		(ACK_MB1 + 0x0)
-#define ACK_MB1_CURR_APEOPP		(ACK_MB1 + 0x1)
-
-#define REQ_MB5_I2C_SLAVE_OP (REQ_MB5)
-#define REQ_MB5_I2C_HW_BITS (REQ_MB5 + 1)
-#define REQ_MB5_I2C_REG (REQ_MB5 + 2)
-#define REQ_MB5_I2C_VAL (REQ_MB5 + 3)
-
-#define ACK_MB5_I2C_STATUS (ACK_MB5 + 1)
-#define ACK_MB5_I2C_VAL (ACK_MB5 + 3)
-
-#define PRCM_AVS_VARM_MAX_OPP		(tcdm_base + 0x2E4)
-#define PRCM_AVS_ISMODEENABLE		7
-#define PRCM_AVS_ISMODEENABLE_MASK	(1 << PRCM_AVS_ISMODEENABLE)
-
-#define I2C_WRITE(slave) \
-	(((slave) << 1) | (cpu_is_u8500v2() ? BIT(6) : 0))
-#define I2C_READ(slave) \
-	(((slave) << 1) | (cpu_is_u8500v2() ? BIT(6) : 0) | BIT(0))
-#define I2C_STOP_EN BIT(3)
-
-enum mb1_h {
-	MB1H_ARM_OPP = 1,
-	MB1H_APE_OPP,
-	MB1H_ARM_APE_OPP,
-};
-
-static struct {
-	struct mutex lock;
-	struct completion work;
-	struct {
-		u8 arm_opp;
-		u8 ape_opp;
-		u8 arm_status;
-		u8 ape_status;
-	} ack;
-} mb1_transfer;
-
-enum ack_mb5_status {
-	I2C_WR_OK = 0x01,
-	I2C_RD_OK = 0x02,
-};
-
-#define MBOX_BIT BIT
-#define NUM_MBOX 8
-
-static struct {
-	struct mutex lock;
-	struct completion work;
-	bool failed;
-	struct {
-		u8 status;
-		u8 value;
-	} ack;
-} mb5_transfer;
-
-/**
- * prcmu_abb_read() - Read register value(s) from the ABB.
- * @slave:	The I2C slave address.
- * @reg:	The (start) register address.
- * @value:	The read out value(s).
- * @size:	The number of registers to read.
- *
- * Reads register value(s) from the ABB.
- * @size has to be 1 for the current firmware version.
- */
-int prcmu_abb_read(u8 slave, u8 reg, u8 *value, u8 size)
-{
-	int r;
-
-	if (size != 1)
-		return -EINVAL;
-
-	r = mutex_lock_interruptible(&mb5_transfer.lock);
-	if (r)
-		return r;
-
-	while (readl(PRCM_MBOX_CPU_VAL) & MBOX_BIT(5))
-		cpu_relax();
-
-	writeb(I2C_READ(slave), REQ_MB5_I2C_SLAVE_OP);
-	writeb(I2C_STOP_EN, REQ_MB5_I2C_HW_BITS);
-	writeb(reg, REQ_MB5_I2C_REG);
-
-	writel(MBOX_BIT(5), PRCM_MBOX_CPU_SET);
-	if (!wait_for_completion_timeout(&mb5_transfer.work,
-			msecs_to_jiffies(500))) {
-		pr_err("prcmu: prcmu_abb_read timed out.\n");
-		r = -EIO;
-		goto unlock_and_return;
-	}
-	r = ((mb5_transfer.ack.status == I2C_RD_OK) ? 0 : -EIO);
-	if (!r)
-		*value = mb5_transfer.ack.value;
-
-unlock_and_return:
-	mutex_unlock(&mb5_transfer.lock);
-	return r;
-}
-EXPORT_SYMBOL(prcmu_abb_read);
-
-/**
- * prcmu_abb_write() - Write register value(s) to the ABB.
- * @slave:	The I2C slave address.
- * @reg:	The (start) register address.
- * @value:	The value(s) to write.
- * @size:	The number of registers to write.
- *
- * Reads register value(s) from the ABB.
- * @size has to be 1 for the current firmware version.
- */
-int prcmu_abb_write(u8 slave, u8 reg, u8 *value, u8 size)
-{
-	int r;
-
-	if (size != 1)
-		return -EINVAL;
-
-	r = mutex_lock_interruptible(&mb5_transfer.lock);
-	if (r)
-		return r;
-
-
-	while (readl(PRCM_MBOX_CPU_VAL) & MBOX_BIT(5))
-		cpu_relax();
-
-	writeb(I2C_WRITE(slave), REQ_MB5_I2C_SLAVE_OP);
-	writeb(I2C_STOP_EN, REQ_MB5_I2C_HW_BITS);
-	writeb(reg, REQ_MB5_I2C_REG);
-	writeb(*value, REQ_MB5_I2C_VAL);
-
-	writel(MBOX_BIT(5), PRCM_MBOX_CPU_SET);
-	if (!wait_for_completion_timeout(&mb5_transfer.work,
-			msecs_to_jiffies(500))) {
-		pr_err("prcmu: prcmu_abb_write timed out.\n");
-		r = -EIO;
-		goto unlock_and_return;
-	}
-	r = ((mb5_transfer.ack.status == I2C_WR_OK) ? 0 : -EIO);
-
-unlock_and_return:
-	mutex_unlock(&mb5_transfer.lock);
-	return r;
-}
-EXPORT_SYMBOL(prcmu_abb_write);
-
-static int set_ape_cpu_opps(u8 header, enum prcmu_ape_opp ape_opp,
-			    enum prcmu_cpu_opp cpu_opp)
-{
-	bool do_ape;
-	bool do_arm;
-	int err = 0;
-
-	do_ape = ((header == MB1H_APE_OPP) || (header == MB1H_ARM_APE_OPP));
-	do_arm = ((header == MB1H_ARM_OPP) || (header == MB1H_ARM_APE_OPP));
-
-	mutex_lock(&mb1_transfer.lock);
-
-	while (readl(PRCM_MBOX_CPU_VAL) & MBOX_BIT(1))
-		cpu_relax();
-
-	writeb(0, MBOX_HEADER_REQ_MB0);
-	writeb(cpu_opp, REQ_MB1_ARMOPP);
-	writeb(ape_opp, REQ_MB1_APEOPP);
-	writeb(0, REQ_MB1_BOOSTOPP);
-	writel(MBOX_BIT(1), PRCM_MBOX_CPU_SET);
-	wait_for_completion(&mb1_transfer.work);
-	if ((do_ape) && (mb1_transfer.ack.ape_status != 0))
-		err = -EIO;
-	if ((do_arm) && (mb1_transfer.ack.arm_status != 0))
-		err = -EIO;
-
-	mutex_unlock(&mb1_transfer.lock);
-
-	return err;
-}
-
-/**
- * prcmu_set_ape_opp() - Set the OPP of the APE.
- * @opp:	The OPP to set.
- *
- * This function sets the OPP of the APE.
- */
-int prcmu_set_ape_opp(enum prcmu_ape_opp opp)
-{
-	return set_ape_cpu_opps(MB1H_APE_OPP, opp, APE_OPP_NO_CHANGE);
-}
-EXPORT_SYMBOL(prcmu_set_ape_opp);
-
-/**
- * prcmu_set_cpu_opp() - Set the OPP of the CPU.
- * @opp:	The OPP to set.
- *
- * This function sets the OPP of the CPU.
- */
-int prcmu_set_cpu_opp(enum prcmu_cpu_opp opp)
-{
-	return set_ape_cpu_opps(MB1H_ARM_OPP, CPU_OPP_NO_CHANGE, opp);
-}
-EXPORT_SYMBOL(prcmu_set_cpu_opp);
-
-/**
- * prcmu_set_ape_cpu_opps() - Set the OPPs of the APE and the CPU.
- * @ape_opp:	The APE OPP to set.
- * @cpu_opp:	The CPU OPP to set.
- *
- * This function sets the OPPs of the APE and the CPU.
- */
-int prcmu_set_ape_cpu_opps(enum prcmu_ape_opp ape_opp,
-			   enum prcmu_cpu_opp cpu_opp)
-{
-	return set_ape_cpu_opps(MB1H_ARM_APE_OPP, ape_opp, cpu_opp);
-}
-EXPORT_SYMBOL(prcmu_set_ape_cpu_opps);
-
-/**
- * prcmu_get_ape_opp() - Get the OPP of the APE.
- *
- * This function gets the OPP of the APE.
- */
-enum prcmu_ape_opp prcmu_get_ape_opp(void)
-{
-	return readb(ACK_MB1_CURR_APEOPP);
-}
-EXPORT_SYMBOL(prcmu_get_ape_opp);
-
-/**
- * prcmu_get_cpu_opp() - Get the OPP of the CPU.
- *
- * This function gets the OPP of the CPU. The OPP is specified in %%.
- * PRCMU_OPP_EXT is a special OPP value, not specified in %%.
- */
-int prcmu_get_cpu_opp(void)
-{
-	return readb(ACK_MB1_CURR_ARMOPP);
-}
-EXPORT_SYMBOL(prcmu_get_cpu_opp);
-
-bool prcmu_has_arm_maxopp(void)
-{
-	return (readb(PRCM_AVS_VARM_MAX_OPP) & PRCM_AVS_ISMODEENABLE_MASK)
-		== PRCM_AVS_ISMODEENABLE_MASK;
-}
-
-static void read_mailbox_0(void)
-{
-	writel(MBOX_BIT(0), PRCM_ARM_IT1_CLEAR);
-}
-
-static void read_mailbox_1(void)
-{
-	mb1_transfer.ack.arm_opp = readb(ACK_MB1_CURR_ARMOPP);
-	mb1_transfer.ack.ape_opp = readb(ACK_MB1_CURR_APEOPP);
-	complete(&mb1_transfer.work);
-	writel(MBOX_BIT(1), PRCM_ARM_IT1_CLEAR);
-}
-
-static void read_mailbox_2(void)
-{
-	writel(MBOX_BIT(2), PRCM_ARM_IT1_CLEAR);
-}
-
-static void read_mailbox_3(void)
-{
-	writel(MBOX_BIT(3), PRCM_ARM_IT1_CLEAR);
-}
-
-static void read_mailbox_4(void)
-{
-	writel(MBOX_BIT(4), PRCM_ARM_IT1_CLEAR);
-}
-
-static void read_mailbox_5(void)
-{
-	mb5_transfer.ack.status = readb(ACK_MB5_I2C_STATUS);
-	mb5_transfer.ack.value = readb(ACK_MB5_I2C_VAL);
-	complete(&mb5_transfer.work);
-	writel(MBOX_BIT(5), PRCM_ARM_IT1_CLEAR);
-}
-
-static void read_mailbox_6(void)
-{
-	writel(MBOX_BIT(6), PRCM_ARM_IT1_CLEAR);
-}
-
-static void read_mailbox_7(void)
-{
-	writel(MBOX_BIT(7), PRCM_ARM_IT1_CLEAR);
-}
-
-static void (* const read_mailbox[NUM_MBOX])(void) = {
-	read_mailbox_0,
-	read_mailbox_1,
-	read_mailbox_2,
-	read_mailbox_3,
-	read_mailbox_4,
-	read_mailbox_5,
-	read_mailbox_6,
-	read_mailbox_7
-};
-
-static irqreturn_t prcmu_irq_handler(int irq, void *data)
-{
-	u32 bits;
-	u8 n;
-
-	bits = (readl(PRCM_ARM_IT1_VAL) & (MBOX_BIT(NUM_MBOX) - 1));
-	if (unlikely(!bits))
-		return IRQ_NONE;
-
-	for (n = 0; bits; n++) {
-		if (bits & MBOX_BIT(n)) {
-			bits -= MBOX_BIT(n);
-			read_mailbox[n]();
-		}
-	}
-	return IRQ_HANDLED;
-}
-
-void __init prcmu_early_init(void)
-{
-	if (cpu_is_u8500v11() || cpu_is_u8500ed()) {
-		tcdm_base = __io_address(U8500_PRCMU_TCDM_BASE_V1);
-	} else if (cpu_is_u8500v2()) {
-		tcdm_base = __io_address(U8500_PRCMU_TCDM_BASE);
-	} else {
-		pr_err("prcmu: Unsupported chip version\n");
-		BUG();
-	}
-}
-
-static int __init prcmu_init(void)
-{
-	if (cpu_is_u8500ed()) {
-		pr_err("prcmu: Unsupported chip version\n");
-		return 0;
-	}
-
-	mutex_init(&mb1_transfer.lock);
-	init_completion(&mb1_transfer.work);
-	mutex_init(&mb5_transfer.lock);
-	init_completion(&mb5_transfer.work);
-
-	/* Clean up the mailbox interrupts after pre-kernel code. */
-	writel((MBOX_BIT(NUM_MBOX) - 1), PRCM_ARM_IT1_CLEAR);
-
-	return request_irq(IRQ_DB8500_PRCMU1, prcmu_irq_handler, 0,
-			   "prcmu", NULL);
-}
-
-arch_initcall(prcmu_init);
diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 3ed3ff0..7eaeb97 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -538,7 +538,7 @@ config AB8500_CORE
 
 config AB8500_I2C_CORE
 	bool "AB8500 register access via PRCMU I2C"
-	depends on AB8500_CORE && UX500_SOC_DB8500
+	depends on AB8500_CORE && MFD_DB8500_PRCMU
 	default y
 	help
 	  This enables register access to the AB8500 chip via PRCMU I2C.
@@ -575,6 +575,16 @@ config AB3550_CORE
 	  LEDs, vibrator, system power and temperature, power management
 	  and ALSA sound.
 
+config MFD_DB8500_PRCMU
+	bool "ST-Ericsson DB8500 Power Reset Control Management Unit"
+	depends on UX500_SOC_DB8500
+	select MFD_CORE
+	help
+	  Select this option to enable support for the DB8500 Power Reset
+	  and Control Management Unit. This is basically an autonomous
+	  system controller running an XP70 microprocessor, which is accessed
+	  through a register map.
+
 config MFD_CS5535
 	tristate "Support for CS5535 and CS5536 southbridge core functions"
 	select MFD_CORE
diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index 419caa9..814c57a 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -74,9 +74,11 @@ obj-$(CONFIG_AB3100_CORE)	+= ab3100-core.o
 obj-$(CONFIG_AB3100_OTP)	+= ab3100-otp.o
 obj-$(CONFIG_AB3550_CORE)	+= ab3550-core.o
 obj-$(CONFIG_AB8500_CORE)	+= ab8500-core.o ab8500-sysctrl.o
-obj-$(CONFIG_AB8500_I2C_CORE)	+= ab8500-i2c.o
 obj-$(CONFIG_AB8500_DEBUG)	+= ab8500-debugfs.o
 obj-$(CONFIG_AB8500_GPADC)	+= ab8500-gpadc.o
+obj-$(CONFIG_MFD_DB8500_PRCMU)	+= db8500-prcmu.o
+# ab8500-i2c need to come after db8500-prcmu (which provides the channel)
+obj-$(CONFIG_AB8500_I2C_CORE)	+= ab8500-i2c.o
 obj-$(CONFIG_MFD_TIMBERDALE)    += timberdale.o
 obj-$(CONFIG_PMIC_ADP5520)	+= adp5520.o
 obj-$(CONFIG_LPC_SCH)		+= lpc_sch.o
diff --git a/drivers/mfd/ab8500-i2c.c b/drivers/mfd/ab8500-i2c.c
index 821e6b8..9be541c 100644
--- a/drivers/mfd/ab8500-i2c.c
+++ b/drivers/mfd/ab8500-i2c.c
@@ -11,8 +11,7 @@
 #include <linux/module.h>
 #include <linux/platform_device.h>
 #include <linux/mfd/ab8500.h>
-
-#include <mach/prcmu.h>
+#include <linux/mfd/db8500-prcmu.h>
 
 static int ab8500_i2c_write(struct ab8500 *ab8500, u16 addr, u8 data)
 {
diff --git a/drivers/mfd/db8500-prcmu-regs.h b/drivers/mfd/db8500-prcmu-regs.h
new file mode 100644
index 0000000..c1226da
--- /dev/null
+++ b/drivers/mfd/db8500-prcmu-regs.h
@@ -0,0 +1,94 @@
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
+#ifndef __MACH_PRCMU_REGS_H
+#define __MACH_PRCMU_REGS_H
+
+#include <mach/hardware.h>
+
+#define PRCM_ARM_PLLDIVPS	(_PRCMU_BASE + 0x118)
+#define PRCM_ARM_CHGCLKREQ	(_PRCMU_BASE + 0x114)
+#define PRCM_PLLARM_ENABLE	(_PRCMU_BASE + 0x98)
+#define PRCM_ARMCLKFIX_MGT	(_PRCMU_BASE + 0x0)
+#define PRCM_A9_RESETN_CLR	(_PRCMU_BASE + 0x1f4)
+#define PRCM_A9_RESETN_SET	(_PRCMU_BASE + 0x1f0)
+#define PRCM_ARM_LS_CLAMP	(_PRCMU_BASE + 0x30c)
+#define PRCM_SRAM_A9		(_PRCMU_BASE + 0x308)
+
+/* ARM WFI Standby signal register */
+#define PRCM_ARM_WFI_STANDBY    (_PRCMU_BASE + 0x130)
+#define PRCMU_IOCR              (_PRCMU_BASE + 0x310)
+
+/* CPU mailbox registers */
+#define PRCM_MBOX_CPU_VAL	(_PRCMU_BASE + 0x0fc)
+#define PRCM_MBOX_CPU_SET	(_PRCMU_BASE + 0x100)
+#define PRCM_MBOX_CPU_CLR	(_PRCMU_BASE + 0x104)
+
+/* Dual A9 core interrupt management unit registers */
+#define PRCM_A9_MASK_REQ	(_PRCMU_BASE + 0x328)
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
+#define ARM_WAKEUP_MODEM	0x1
+
+#define PRCM_ARM_IT1_CLEAR	(_PRCMU_BASE + 0x48C)
+#define PRCM_ARM_IT1_VAL	(_PRCMU_BASE + 0x494)
+#define PRCM_HOLD_EVT		(_PRCMU_BASE + 0x174)
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
+#define PRCM_LCDCLK_MGT            (_PRCMU_BASE + 0x044)
+#define PRCM_MCDECLK_MGT           (_PRCMU_BASE + 0x064)
+#define PRCM_HDMICLK_MGT           (_PRCMU_BASE + 0x058)
+#define PRCM_TVCLK_MGT             (_PRCMU_BASE + 0x07c)
+#define PRCM_DSI_PLLOUT_SEL        (_PRCMU_BASE + 0x530)
+#define PRCM_DSITVCLK_DIV          (_PRCMU_BASE + 0x52C)
+#define PRCM_APE_RESETN_SET        (_PRCMU_BASE + 0x1E4)
+#define PRCM_APE_RESETN_CLR        (_PRCMU_BASE + 0x1E8)
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
+
+#endif /* __MACH_PRCMU_REGS_H */
diff --git a/drivers/mfd/db8500-prcmu.c b/drivers/mfd/db8500-prcmu.c
new file mode 100644
index 0000000..31f18c8
--- /dev/null
+++ b/drivers/mfd/db8500-prcmu.c
@@ -0,0 +1,395 @@
+/*
+ * Copyright (C) STMicroelectronics 2009
+ * Copyright (C) ST-Ericsson SA 2010
+ *
+ * License Terms: GNU General Public License v2
+ * Author: Kumar Sanghvi <kumar.sanghvi@stericsson.com>
+ * Author: Sundar Iyer <sundar.iyer@stericsson.com>
+ * Author: Mattias Nilsson <mattias.i.nilsson@stericsson.com>
+ *
+ * U8500 PRCM Unit interface driver
+ *
+ */
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/errno.h>
+#include <linux/err.h>
+#include <linux/io.h>
+#include <linux/mutex.h>
+#include <linux/completion.h>
+#include <linux/jiffies.h>
+#include <linux/bitops.h>
+#include <linux/interrupt.h>
+#include <linux/mfd/db8500-prcmu.h>
+
+#include <mach/hardware.h>
+
+#include "db8500-prcmu-regs.h"
+
+/* Global var to runtime determine TCDM base for v2 or v1 */
+static __iomem void *tcdm_base;
+
+#define _MBOX_HEADER		(tcdm_base + 0xFE8)
+#define MBOX_HEADER_REQ_MB0	(_MBOX_HEADER + 0x0)
+
+#define REQ_MB1 (tcdm_base + 0xFD0)
+#define REQ_MB5 (tcdm_base + 0xE44)
+
+#define REQ_MB1_ARMOPP		(REQ_MB1 + 0x0)
+#define REQ_MB1_APEOPP		(REQ_MB1 + 0x1)
+#define REQ_MB1_BOOSTOPP	(REQ_MB1 + 0x2)
+
+#define ACK_MB1 (tcdm_base + 0xE04)
+#define ACK_MB5 (tcdm_base + 0xDF4)
+
+#define ACK_MB1_CURR_ARMOPP		(ACK_MB1 + 0x0)
+#define ACK_MB1_CURR_APEOPP		(ACK_MB1 + 0x1)
+
+#define REQ_MB5_I2C_SLAVE_OP (REQ_MB5)
+#define REQ_MB5_I2C_HW_BITS (REQ_MB5 + 1)
+#define REQ_MB5_I2C_REG (REQ_MB5 + 2)
+#define REQ_MB5_I2C_VAL (REQ_MB5 + 3)
+
+#define ACK_MB5_I2C_STATUS (ACK_MB5 + 1)
+#define ACK_MB5_I2C_VAL (ACK_MB5 + 3)
+
+#define PRCM_AVS_VARM_MAX_OPP		(tcdm_base + 0x2E4)
+#define PRCM_AVS_ISMODEENABLE		7
+#define PRCM_AVS_ISMODEENABLE_MASK	(1 << PRCM_AVS_ISMODEENABLE)
+
+#define I2C_WRITE(slave) \
+	(((slave) << 1) | (cpu_is_u8500v2() ? BIT(6) : 0))
+#define I2C_READ(slave) \
+	(((slave) << 1) | (cpu_is_u8500v2() ? BIT(6) : 0) | BIT(0))
+#define I2C_STOP_EN BIT(3)
+
+enum mb1_h {
+	MB1H_ARM_OPP = 1,
+	MB1H_APE_OPP,
+	MB1H_ARM_APE_OPP,
+};
+
+static struct {
+	struct mutex lock;
+	struct completion work;
+	struct {
+		u8 arm_opp;
+		u8 ape_opp;
+		u8 arm_status;
+		u8 ape_status;
+	} ack;
+} mb1_transfer;
+
+enum ack_mb5_status {
+	I2C_WR_OK = 0x01,
+	I2C_RD_OK = 0x02,
+};
+
+#define MBOX_BIT BIT
+#define NUM_MBOX 8
+
+static struct {
+	struct mutex lock;
+	struct completion work;
+	bool failed;
+	struct {
+		u8 status;
+		u8 value;
+	} ack;
+} mb5_transfer;
+
+/**
+ * prcmu_abb_read() - Read register value(s) from the ABB.
+ * @slave:	The I2C slave address.
+ * @reg:	The (start) register address.
+ * @value:	The read out value(s).
+ * @size:	The number of registers to read.
+ *
+ * Reads register value(s) from the ABB.
+ * @size has to be 1 for the current firmware version.
+ */
+int prcmu_abb_read(u8 slave, u8 reg, u8 *value, u8 size)
+{
+	int r;
+
+	if (size != 1)
+		return -EINVAL;
+
+	r = mutex_lock_interruptible(&mb5_transfer.lock);
+	if (r)
+		return r;
+
+	while (readl(PRCM_MBOX_CPU_VAL) & MBOX_BIT(5))
+		cpu_relax();
+
+	writeb(I2C_READ(slave), REQ_MB5_I2C_SLAVE_OP);
+	writeb(I2C_STOP_EN, REQ_MB5_I2C_HW_BITS);
+	writeb(reg, REQ_MB5_I2C_REG);
+
+	writel(MBOX_BIT(5), PRCM_MBOX_CPU_SET);
+	if (!wait_for_completion_timeout(&mb5_transfer.work,
+			msecs_to_jiffies(500))) {
+		pr_err("prcmu: prcmu_abb_read timed out.\n");
+		r = -EIO;
+		goto unlock_and_return;
+	}
+	r = ((mb5_transfer.ack.status == I2C_RD_OK) ? 0 : -EIO);
+	if (!r)
+		*value = mb5_transfer.ack.value;
+
+unlock_and_return:
+	mutex_unlock(&mb5_transfer.lock);
+	return r;
+}
+EXPORT_SYMBOL(prcmu_abb_read);
+
+/**
+ * prcmu_abb_write() - Write register value(s) to the ABB.
+ * @slave:	The I2C slave address.
+ * @reg:	The (start) register address.
+ * @value:	The value(s) to write.
+ * @size:	The number of registers to write.
+ *
+ * Reads register value(s) from the ABB.
+ * @size has to be 1 for the current firmware version.
+ */
+int prcmu_abb_write(u8 slave, u8 reg, u8 *value, u8 size)
+{
+	int r;
+
+	if (size != 1)
+		return -EINVAL;
+
+	r = mutex_lock_interruptible(&mb5_transfer.lock);
+	if (r)
+		return r;
+
+
+	while (readl(PRCM_MBOX_CPU_VAL) & MBOX_BIT(5))
+		cpu_relax();
+
+	writeb(I2C_WRITE(slave), REQ_MB5_I2C_SLAVE_OP);
+	writeb(I2C_STOP_EN, REQ_MB5_I2C_HW_BITS);
+	writeb(reg, REQ_MB5_I2C_REG);
+	writeb(*value, REQ_MB5_I2C_VAL);
+
+	writel(MBOX_BIT(5), PRCM_MBOX_CPU_SET);
+	if (!wait_for_completion_timeout(&mb5_transfer.work,
+			msecs_to_jiffies(500))) {
+		pr_err("prcmu: prcmu_abb_write timed out.\n");
+		r = -EIO;
+		goto unlock_and_return;
+	}
+	r = ((mb5_transfer.ack.status == I2C_WR_OK) ? 0 : -EIO);
+
+unlock_and_return:
+	mutex_unlock(&mb5_transfer.lock);
+	return r;
+}
+EXPORT_SYMBOL(prcmu_abb_write);
+
+static int set_ape_cpu_opps(u8 header, enum prcmu_ape_opp ape_opp,
+			    enum prcmu_cpu_opp cpu_opp)
+{
+	bool do_ape;
+	bool do_arm;
+	int err = 0;
+
+	do_ape = ((header == MB1H_APE_OPP) || (header == MB1H_ARM_APE_OPP));
+	do_arm = ((header == MB1H_ARM_OPP) || (header == MB1H_ARM_APE_OPP));
+
+	mutex_lock(&mb1_transfer.lock);
+
+	while (readl(PRCM_MBOX_CPU_VAL) & MBOX_BIT(1))
+		cpu_relax();
+
+	writeb(0, MBOX_HEADER_REQ_MB0);
+	writeb(cpu_opp, REQ_MB1_ARMOPP);
+	writeb(ape_opp, REQ_MB1_APEOPP);
+	writeb(0, REQ_MB1_BOOSTOPP);
+	writel(MBOX_BIT(1), PRCM_MBOX_CPU_SET);
+	wait_for_completion(&mb1_transfer.work);
+	if ((do_ape) && (mb1_transfer.ack.ape_status != 0))
+		err = -EIO;
+	if ((do_arm) && (mb1_transfer.ack.arm_status != 0))
+		err = -EIO;
+
+	mutex_unlock(&mb1_transfer.lock);
+
+	return err;
+}
+
+/**
+ * prcmu_set_ape_opp() - Set the OPP of the APE.
+ * @opp:	The OPP to set.
+ *
+ * This function sets the OPP of the APE.
+ */
+int prcmu_set_ape_opp(enum prcmu_ape_opp opp)
+{
+	return set_ape_cpu_opps(MB1H_APE_OPP, opp, APE_OPP_NO_CHANGE);
+}
+EXPORT_SYMBOL(prcmu_set_ape_opp);
+
+/**
+ * prcmu_set_cpu_opp() - Set the OPP of the CPU.
+ * @opp:	The OPP to set.
+ *
+ * This function sets the OPP of the CPU.
+ */
+int prcmu_set_cpu_opp(enum prcmu_cpu_opp opp)
+{
+	return set_ape_cpu_opps(MB1H_ARM_OPP, CPU_OPP_NO_CHANGE, opp);
+}
+EXPORT_SYMBOL(prcmu_set_cpu_opp);
+
+/**
+ * prcmu_set_ape_cpu_opps() - Set the OPPs of the APE and the CPU.
+ * @ape_opp:	The APE OPP to set.
+ * @cpu_opp:	The CPU OPP to set.
+ *
+ * This function sets the OPPs of the APE and the CPU.
+ */
+int prcmu_set_ape_cpu_opps(enum prcmu_ape_opp ape_opp,
+			   enum prcmu_cpu_opp cpu_opp)
+{
+	return set_ape_cpu_opps(MB1H_ARM_APE_OPP, ape_opp, cpu_opp);
+}
+EXPORT_SYMBOL(prcmu_set_ape_cpu_opps);
+
+/**
+ * prcmu_get_ape_opp() - Get the OPP of the APE.
+ *
+ * This function gets the OPP of the APE.
+ */
+enum prcmu_ape_opp prcmu_get_ape_opp(void)
+{
+	return readb(ACK_MB1_CURR_APEOPP);
+}
+EXPORT_SYMBOL(prcmu_get_ape_opp);
+
+/**
+ * prcmu_get_cpu_opp() - Get the OPP of the CPU.
+ *
+ * This function gets the OPP of the CPU. The OPP is specified in %%.
+ * PRCMU_OPP_EXT is a special OPP value, not specified in %%.
+ */
+int prcmu_get_cpu_opp(void)
+{
+	return readb(ACK_MB1_CURR_ARMOPP);
+}
+EXPORT_SYMBOL(prcmu_get_cpu_opp);
+
+bool prcmu_has_arm_maxopp(void)
+{
+	return (readb(PRCM_AVS_VARM_MAX_OPP) & PRCM_AVS_ISMODEENABLE_MASK)
+		== PRCM_AVS_ISMODEENABLE_MASK;
+}
+
+static void read_mailbox_0(void)
+{
+	writel(MBOX_BIT(0), PRCM_ARM_IT1_CLEAR);
+}
+
+static void read_mailbox_1(void)
+{
+	mb1_transfer.ack.arm_opp = readb(ACK_MB1_CURR_ARMOPP);
+	mb1_transfer.ack.ape_opp = readb(ACK_MB1_CURR_APEOPP);
+	complete(&mb1_transfer.work);
+	writel(MBOX_BIT(1), PRCM_ARM_IT1_CLEAR);
+}
+
+static void read_mailbox_2(void)
+{
+	writel(MBOX_BIT(2), PRCM_ARM_IT1_CLEAR);
+}
+
+static void read_mailbox_3(void)
+{
+	writel(MBOX_BIT(3), PRCM_ARM_IT1_CLEAR);
+}
+
+static void read_mailbox_4(void)
+{
+	writel(MBOX_BIT(4), PRCM_ARM_IT1_CLEAR);
+}
+
+static void read_mailbox_5(void)
+{
+	mb5_transfer.ack.status = readb(ACK_MB5_I2C_STATUS);
+	mb5_transfer.ack.value = readb(ACK_MB5_I2C_VAL);
+	complete(&mb5_transfer.work);
+	writel(MBOX_BIT(5), PRCM_ARM_IT1_CLEAR);
+}
+
+static void read_mailbox_6(void)
+{
+	writel(MBOX_BIT(6), PRCM_ARM_IT1_CLEAR);
+}
+
+static void read_mailbox_7(void)
+{
+	writel(MBOX_BIT(7), PRCM_ARM_IT1_CLEAR);
+}
+
+static void (* const read_mailbox[NUM_MBOX])(void) = {
+	read_mailbox_0,
+	read_mailbox_1,
+	read_mailbox_2,
+	read_mailbox_3,
+	read_mailbox_4,
+	read_mailbox_5,
+	read_mailbox_6,
+	read_mailbox_7
+};
+
+static irqreturn_t prcmu_irq_handler(int irq, void *data)
+{
+	u32 bits;
+	u8 n;
+
+	bits = (readl(PRCM_ARM_IT1_VAL) & (MBOX_BIT(NUM_MBOX) - 1));
+	if (unlikely(!bits))
+		return IRQ_NONE;
+
+	for (n = 0; bits; n++) {
+		if (bits & MBOX_BIT(n)) {
+			bits -= MBOX_BIT(n);
+			read_mailbox[n]();
+		}
+	}
+	return IRQ_HANDLED;
+}
+
+void __init prcmu_early_init(void)
+{
+	if (cpu_is_u8500v11() || cpu_is_u8500ed()) {
+		tcdm_base = __io_address(U8500_PRCMU_TCDM_BASE_V1);
+	} else if (cpu_is_u8500v2()) {
+		tcdm_base = __io_address(U8500_PRCMU_TCDM_BASE);
+	} else {
+		pr_err("prcmu: Unsupported chip version\n");
+		BUG();
+	}
+}
+
+static int __init prcmu_init(void)
+{
+	if (cpu_is_u8500ed()) {
+		pr_err("prcmu: Unsupported chip version\n");
+		return 0;
+	}
+
+	mutex_init(&mb1_transfer.lock);
+	init_completion(&mb1_transfer.work);
+	mutex_init(&mb5_transfer.lock);
+	init_completion(&mb5_transfer.work);
+
+	/* Clean up the mailbox interrupts after pre-kernel code. */
+	writel((MBOX_BIT(NUM_MBOX) - 1), PRCM_ARM_IT1_CLEAR);
+
+	return request_irq(IRQ_DB8500_PRCMU1, prcmu_irq_handler, 0,
+			   "prcmu", NULL);
+}
+
+arch_initcall(prcmu_init);
diff --git a/include/linux/mfd/db8500-prcmu.h b/include/linux/mfd/db8500-prcmu.h
new file mode 100644
index 0000000..d591d79
--- /dev/null
+++ b/include/linux/mfd/db8500-prcmu.h
@@ -0,0 +1,58 @@
+/*
+ * Copyright (C) STMicroelectronics 2009
+ * Copyright (C) ST-Ericsson SA 2010
+ *
+ * Author: Sundar Iyer <sundar.iyer@stericsson.com>
+ * Author: Martin Persson <martin.persson@stericsson.com>
+ *
+ * License Terms: GNU General Public License v2
+ *
+ * PRCM Unit definitions
+ */
+
+#ifndef __MACH_PRCMU_DEFS_H
+#define __MACH_PRCMU_DEFS_H
+
+enum prcmu_cpu_opp {
+	CPU_OPP_INIT	  = 0x00,
+	CPU_OPP_NO_CHANGE = 0x01,
+	CPU_OPP_100	  = 0x02,
+	CPU_OPP_50	  = 0x03,
+	CPU_OPP_MAX	  = 0x04,
+	CPU_OPP_EXT_CLK	  = 0x07
+};
+enum prcmu_ape_opp {
+	APE_OPP_NO_CHANGE = 0x00,
+	APE_OPP_100	  = 0x02,
+	APE_OPP_50	  = 0x03,
+};
+
+#endif /* __MACH_PRCMU_DEFS_H */
+
+/*
+ * Copyright (C) STMicroelectronics 2009
+ * Copyright (C) ST-Ericsson SA 2010
+ *
+ * Author: Kumar Sanghvi <kumar.sanghvi@stericsson.com>
+ * Author: Sundar Iyer <sundar.iyer@stericsson.com>
+ * Author: Mattias Nilsson <mattias.i.nilsson@stericsson.com>
+ *
+ * License Terms: GNU General Public License v2
+ *
+ * PRCM Unit f/w API
+ */
+#ifndef __MACH_PRCMU_H
+#define __MACH_PRCMU_H
+
+void __init prcmu_early_init(void);
+int prcmu_abb_read(u8 slave, u8 reg, u8 *value, u8 size);
+int prcmu_abb_write(u8 slave, u8 reg, u8 *value, u8 size);
+int prcmu_set_ape_opp(enum prcmu_ape_opp opp);
+int prcmu_set_cpu_opp(enum prcmu_cpu_opp opp);
+int prcmu_set_ape_cpu_opps(enum prcmu_ape_opp ape_opp,
+			   enum prcmu_cpu_opp cpu_opp);
+enum prcmu_ape_opp prcmu_get_ape_opp(void);
+int prcmu_get_cpu_opp(void);
+bool prcmu_has_arm_maxopp(void);
+
+#endif /* __MACH_PRCMU_H */
-- 
1.7.3.2

