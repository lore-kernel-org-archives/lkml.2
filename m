Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755698Ab1EOXi2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 May 2011 19:38:28 -0400
Received: from mail.df.lth.se ([194.47.250.12]:23008 "EHLO mail.df.lth.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755456Ab1EOXiV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 May 2011 19:38:21 -0400
From: Linus Walleij <linus.walleij@linaro.org>
To: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org
Cc: Lee Jones <lee.jones@linaro.org>, Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 09/13] mfd: add DB5500 PRCMU driver
Date: Mon, 16 May 2011 01:38:19 +0200
Message-Id: <1305502699-32708-1-git-send-email-linus.walleij@linaro.org>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds the DB5500 PRCMU driver. Right now this one is pretty
restricted in functionality, exposing a simple interface to send
I2C messages.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 arch/arm/mach-ux500/Kconfig      |    1 +
 arch/arm/mach-ux500/cpu.c        |    3 +
 drivers/mfd/Kconfig              |   10 +
 drivers/mfd/Makefile             |    1 +
 drivers/mfd/db5500-prcmu-regs.h  |  115 ++++++++++
 drivers/mfd/db5500-prcmu.c       |  448 ++++++++++++++++++++++++++++++++++++++
 include/linux/mfd/db5500-prcmu.h |   45 ++++
 7 files changed, 623 insertions(+), 0 deletions(-)
 create mode 100644 drivers/mfd/db5500-prcmu-regs.h
 create mode 100644 drivers/mfd/db5500-prcmu.c
 create mode 100644 include/linux/mfd/db5500-prcmu.h

diff --git a/arch/arm/mach-ux500/Kconfig b/arch/arm/mach-ux500/Kconfig
index 8071d27..365c4c3 100644
--- a/arch/arm/mach-ux500/Kconfig
+++ b/arch/arm/mach-ux500/Kconfig
@@ -12,6 +12,7 @@ menu "Ux500 SoC"
 
 config UX500_SOC_DB5500
 	bool "DB5500"
+	select MFD_DB5500_PRCMU
 
 config UX500_SOC_DB8500
 	bool "DB8500"
diff --git a/arch/arm/mach-ux500/cpu.c b/arch/arm/mach-ux500/cpu.c
index 11360f7..1da23bb 100644
--- a/arch/arm/mach-ux500/cpu.c
+++ b/arch/arm/mach-ux500/cpu.c
@@ -9,6 +9,7 @@
 #include <linux/io.h>
 #include <linux/clk.h>
 #include <linux/mfd/db8500-prcmu.h>
+#include <linux/mfd/db5500-prcmu.h>
 
 #include <asm/cacheflush.h>
 #include <asm/hardware/cache-l2x0.h>
@@ -49,6 +50,8 @@ void __init ux500_init_irq(void)
 	 * Init clocks here so that they are available for system timer
 	 * initialization.
 	 */
+	if (cpu_is_u5500())
+		db5500_prcmu_early_init();
 	if (cpu_is_u8500())
 		prcmu_early_init();
 	clk_init();
diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 7eaeb97..481770a 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -585,6 +585,16 @@ config MFD_DB8500_PRCMU
 	  system controller running an XP70 microprocessor, which is accessed
 	  through a register map.
 
+config MFD_DB5500_PRCMU
+	bool "ST-Ericsson DB5500 Power Reset Control Management Unit"
+	depends on UX500_SOC_DB5500
+	select MFD_CORE
+	help
+	  Select this option to enable support for the DB5500 Power Reset
+	  and Control Management Unit. This is basically an autonomous
+	  system controller running an XP70 microprocessor, which is accessed
+	  through a register map.
+
 config MFD_CS5535
 	tristate "Support for CS5535 and CS5536 southbridge core functions"
 	select MFD_CORE
diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index 814c57a..24aa444 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -79,6 +79,7 @@ obj-$(CONFIG_AB8500_GPADC)	+= ab8500-gpadc.o
 obj-$(CONFIG_MFD_DB8500_PRCMU)	+= db8500-prcmu.o
 # ab8500-i2c need to come after db8500-prcmu (which provides the channel)
 obj-$(CONFIG_AB8500_I2C_CORE)	+= ab8500-i2c.o
+obj-$(CONFIG_MFD_DB5500_PRCMU)	+= db5500-prcmu.o
 obj-$(CONFIG_MFD_TIMBERDALE)    += timberdale.o
 obj-$(CONFIG_PMIC_ADP5520)	+= adp5520.o
 obj-$(CONFIG_LPC_SCH)		+= lpc_sch.o
diff --git a/drivers/mfd/db5500-prcmu-regs.h b/drivers/mfd/db5500-prcmu-regs.h
new file mode 100644
index 0000000..9a8e9e4
--- /dev/null
+++ b/drivers/mfd/db5500-prcmu-regs.h
@@ -0,0 +1,115 @@
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
+#define PRCM_A9_RESETN_CLR	(_PRCMU_BASE + 0x1f4)
+#define PRCM_A9_RESETN_SET	(_PRCMU_BASE + 0x1f0)
+#define PRCM_ARM_LS_CLAMP	(_PRCMU_BASE + 0x30c)
+#define PRCM_SRAM_A9		(_PRCMU_BASE + 0x308)
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
+#define PRCM_PLLDSI_LOCKP          (_PRCMU_BASE + 0x508)
+#define PRCM_LCDCLK_MGT            (_PRCMU_BASE + 0x044)
+#define PRCM_MCDECLK_MGT           (_PRCMU_BASE + 0x064)
+#define PRCM_HDMICLK_MGT           (_PRCMU_BASE + 0x058)
+#define PRCM_TVCLK_MGT             (_PRCMU_BASE + 0x07c)
+#define PRCM_DSI_PLLOUT_SEL        (_PRCMU_BASE + 0x530)
+#define PRCM_DSITVCLK_DIV          (_PRCMU_BASE + 0x52C)
+#define PRCM_PLLDSI_LOCKP          (_PRCMU_BASE + 0x508)
+#define PRCM_APE_RESETN_SET        (_PRCMU_BASE + 0x1E4)
+#define PRCM_APE_RESETN_CLR        (_PRCMU_BASE + 0x1E8)
+#define PRCM_CLKOCR		   (_PRCMU_BASE + 0x1CC)
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
+
+#endif /* __MACH_PRCMU__REGS_H */
diff --git a/drivers/mfd/db5500-prcmu.c b/drivers/mfd/db5500-prcmu.c
new file mode 100644
index 0000000..9dbb3ca
--- /dev/null
+++ b/drivers/mfd/db5500-prcmu.c
@@ -0,0 +1,448 @@
+/*
+ * Copyright (C) ST-Ericsson SA 2010
+ *
+ * License Terms: GNU General Public License v2
+ * Author: Mattias Nilsson <mattias.i.nilsson@stericsson.com>
+ *
+ * U5500 PRCM Unit interface driver
+ */
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/delay.h>
+#include <linux/errno.h>
+#include <linux/err.h>
+#include <linux/spinlock.h>
+#include <linux/io.h>
+#include <linux/slab.h>
+#include <linux/mutex.h>
+#include <linux/completion.h>
+#include <linux/irq.h>
+#include <linux/jiffies.h>
+#include <linux/bitops.h>
+#include <linux/interrupt.h>
+#include <linux/mfd/db5500-prcmu.h>
+#include <mach/hardware.h>
+#include <mach/irqs.h>
+#include <mach/db5500-regs.h>
+#include "db5500-prcmu-regs.h"
+
+#define _PRCM_MB_HEADER (tcdm_base + 0xFE8)
+#define PRCM_REQ_MB0_HEADER (_PRCM_MB_HEADER + 0x0)
+#define PRCM_REQ_MB1_HEADER (_PRCM_MB_HEADER + 0x1)
+#define PRCM_REQ_MB2_HEADER (_PRCM_MB_HEADER + 0x2)
+#define PRCM_REQ_MB3_HEADER (_PRCM_MB_HEADER + 0x3)
+#define PRCM_REQ_MB4_HEADER (_PRCM_MB_HEADER + 0x4)
+#define PRCM_REQ_MB5_HEADER (_PRCM_MB_HEADER + 0x5)
+#define PRCM_REQ_MB6_HEADER (_PRCM_MB_HEADER + 0x6)
+#define PRCM_REQ_MB7_HEADER (_PRCM_MB_HEADER + 0x7)
+#define PRCM_ACK_MB0_HEADER (_PRCM_MB_HEADER + 0x8)
+#define PRCM_ACK_MB1_HEADER (_PRCM_MB_HEADER + 0x9)
+#define PRCM_ACK_MB2_HEADER (_PRCM_MB_HEADER + 0xa)
+#define PRCM_ACK_MB3_HEADER (_PRCM_MB_HEADER + 0xb)
+#define PRCM_ACK_MB4_HEADER (_PRCM_MB_HEADER + 0xc)
+#define PRCM_ACK_MB5_HEADER (_PRCM_MB_HEADER + 0xd)
+#define PRCM_ACK_MB6_HEADER (_PRCM_MB_HEADER + 0xe)
+#define PRCM_ACK_MB7_HEADER (_PRCM_MB_HEADER + 0xf)
+
+/* Req Mailboxes */
+#define PRCM_REQ_MB0 (tcdm_base + 0xFD8)
+#define PRCM_REQ_MB1 (tcdm_base + 0xFCC)
+#define PRCM_REQ_MB2 (tcdm_base + 0xFC4)
+#define PRCM_REQ_MB3 (tcdm_base + 0xFC0)
+#define PRCM_REQ_MB4 (tcdm_base + 0xF98)
+#define PRCM_REQ_MB5 (tcdm_base + 0xF90)
+#define PRCM_REQ_MB6 (tcdm_base + 0xF8C)
+#define PRCM_REQ_MB7 (tcdm_base + 0xF84)
+
+/* Ack Mailboxes */
+#define PRCM_ACK_MB0 (tcdm_base + 0xF38)
+#define PRCM_ACK_MB1 (tcdm_base + 0xF30)
+#define PRCM_ACK_MB2 (tcdm_base + 0xF24)
+#define PRCM_ACK_MB3 (tcdm_base + 0xF20)
+#define PRCM_ACK_MB4 (tcdm_base + 0xF1C)
+#define PRCM_ACK_MB5 (tcdm_base + 0xF14)
+#define PRCM_ACK_MB6 (tcdm_base + 0xF0C)
+#define PRCM_ACK_MB7 (tcdm_base + 0xF08)
+
+enum mb_return_code {
+	RC_SUCCESS,
+	RC_FAIL,
+};
+
+/* Mailbox 0 headers. */
+enum mb0_header {
+	/* request */
+	RMB0H_PWR_STATE_TRANS = 1,
+	RMB0H_WAKE_UP_CFG,
+	RMB0H_RD_WAKE_UP_ACK,
+	/* acknowledge */
+	AMB0H_WAKE_UP = 1,
+};
+
+/* Mailbox 5 headers. */
+enum mb5_header {
+	MB5H_I2C_WRITE = 1,
+	MB5H_I2C_READ,
+};
+
+/* Request mailbox 5 fields. */
+#define PRCM_REQ_MB5_I2C_SLAVE (PRCM_REQ_MB5 + 0)
+#define PRCM_REQ_MB5_I2C_REG (PRCM_REQ_MB5 + 1)
+#define PRCM_REQ_MB5_I2C_SIZE (PRCM_REQ_MB5 + 2)
+#define PRCM_REQ_MB5_I2C_DATA (PRCM_REQ_MB5 + 4)
+
+/* Acknowledge mailbox 5 fields. */
+#define PRCM_ACK_MB5_RETURN_CODE (PRCM_ACK_MB5 + 0)
+#define PRCM_ACK_MB5_I2C_DATA (PRCM_ACK_MB5 + 4)
+
+#define NUM_MB 8
+#define MBOX_BIT BIT
+#define ALL_MBOX_BITS (MBOX_BIT(NUM_MB) - 1)
+
+/*
+* Used by MCDE to setup all necessary PRCMU registers
+*/
+#define PRCMU_RESET_DSIPLL			0x00004000
+#define PRCMU_UNCLAMP_DSIPLL			0x00400800
+
+/* HDMI CLK MGT PLLSW=001 (PLLSOC0), PLLDIV=0x8, = 50 Mhz*/
+#define PRCMU_DSI_CLOCK_SETTING			0x00000128
+/* TVCLK_MGT PLLSW=001 (PLLSOC0) PLLDIV=0x13, = 19.05 MHZ */
+#define PRCMU_DSI_LP_CLOCK_SETTING		0x00000135
+#define PRCMU_PLLDSI_FREQ_SETTING		0x0004013C
+#define PRCMU_DSI_PLLOUT_SEL_SETTING		0x00000002
+#define PRCMU_ENABLE_ESCAPE_CLOCK_DIV		0x03000101
+#define PRCMU_DISABLE_ESCAPE_CLOCK_DIV		0x00000101
+
+#define PRCMU_ENABLE_PLLDSI			0x00000001
+#define PRCMU_DISABLE_PLLDSI			0x00000000
+
+#define PRCMU_DSI_RESET_SW			0x00000003
+
+#define PRCMU_PLLDSI_LOCKP_LOCKED		0x3
+
+/*
+ * mb0_transfer - state needed for mailbox 0 communication.
+ * @lock:		The transaction lock.
+ */
+static struct {
+	spinlock_t lock;
+} mb0_transfer;
+
+/*
+ * mb5_transfer - state needed for mailbox 5 communication.
+ * @lock:	The transaction lock.
+ * @work:	The transaction completion structure.
+ * @ack:	Reply ("acknowledge") data.
+ */
+static struct {
+	struct mutex lock;
+	struct completion work;
+	struct {
+		u8 header;
+		u8 status;
+		u8 value[4];
+	} ack;
+} mb5_transfer;
+
+/* PRCMU TCDM base IO address. */
+static __iomem void *tcdm_base;
+
+/**
+ * db5500_prcmu_abb_read() - Read register value(s) from the ABB.
+ * @slave:	The I2C slave address.
+ * @reg:	The (start) register address.
+ * @value:	The read out value(s).
+ * @size:	The number of registers to read.
+ *
+ * Reads register value(s) from the ABB.
+ * @size has to be <= 4.
+ */
+int db5500_prcmu_abb_read(u8 slave, u8 reg, u8 *value, u8 size)
+{
+	int r;
+
+	if ((size < 1) || (4 < size))
+		return -EINVAL;
+
+	mutex_lock(&mb5_transfer.lock);
+
+	while (readl(PRCM_MBOX_CPU_VAL) & MBOX_BIT(5))
+		cpu_relax();
+	writeb(slave, PRCM_REQ_MB5_I2C_SLAVE);
+	writeb(reg, PRCM_REQ_MB5_I2C_REG);
+	writeb(size, PRCM_REQ_MB5_I2C_SIZE);
+	writeb(MB5H_I2C_READ, PRCM_REQ_MB5_HEADER);
+
+	writel(MBOX_BIT(5), PRCM_MBOX_CPU_SET);
+	wait_for_completion(&mb5_transfer.work);
+
+	r = 0;
+	if ((mb5_transfer.ack.header == MB5H_I2C_READ) &&
+		(mb5_transfer.ack.status == RC_SUCCESS))
+		memcpy(value, mb5_transfer.ack.value, (size_t)size);
+	else
+		r = -EIO;
+
+	mutex_unlock(&mb5_transfer.lock);
+
+	return r;
+}
+
+/**
+ * db5500_prcmu_abb_write() - Write register value(s) to the ABB.
+ * @slave:	The I2C slave address.
+ * @reg:	The (start) register address.
+ * @value:	The value(s) to write.
+ * @size:	The number of registers to write.
+ *
+ * Writes register value(s) to the ABB.
+ * @size has to be <= 4.
+ */
+int db5500_prcmu_abb_write(u8 slave, u8 reg, u8 *value, u8 size)
+{
+	int r;
+
+	if ((size < 1) || (4 < size))
+		return -EINVAL;
+
+	mutex_lock(&mb5_transfer.lock);
+
+	while (readl(PRCM_MBOX_CPU_VAL) & MBOX_BIT(5))
+		cpu_relax();
+	writeb(slave, PRCM_REQ_MB5_I2C_SLAVE);
+	writeb(reg, PRCM_REQ_MB5_I2C_REG);
+	writeb(size, PRCM_REQ_MB5_I2C_SIZE);
+	memcpy_toio(PRCM_REQ_MB5_I2C_DATA, value, size);
+	writeb(MB5H_I2C_WRITE, PRCM_REQ_MB5_HEADER);
+
+	writel(MBOX_BIT(5), PRCM_MBOX_CPU_SET);
+	wait_for_completion(&mb5_transfer.work);
+
+	if ((mb5_transfer.ack.header == MB5H_I2C_WRITE) &&
+		(mb5_transfer.ack.status == RC_SUCCESS))
+		r = 0;
+	else
+		r = -EIO;
+
+	mutex_unlock(&mb5_transfer.lock);
+
+	return r;
+}
+
+int db5500_prcmu_enable_dsipll(void)
+{
+	int i;
+
+	/* Enable DSIPLL_RESETN resets */
+	writel(PRCMU_RESET_DSIPLL, PRCM_APE_RESETN_CLR);
+	/* Unclamp DSIPLL in/out */
+	writel(PRCMU_UNCLAMP_DSIPLL, PRCM_MMIP_LS_CLAMP_CLR);
+	/* Set DSI PLL FREQ */
+	writel(PRCMU_PLLDSI_FREQ_SETTING, PRCM_PLLDSI_FREQ);
+	writel(PRCMU_DSI_PLLOUT_SEL_SETTING,
+		PRCM_DSI_PLLOUT_SEL);
+	/* Enable Escape clocks */
+	writel(PRCMU_ENABLE_ESCAPE_CLOCK_DIV, PRCM_DSITVCLK_DIV);
+
+	/* Start DSI PLL */
+	writel(PRCMU_ENABLE_PLLDSI, PRCM_PLLDSI_ENABLE);
+	/* Reset DSI PLL */
+	writel(PRCMU_DSI_RESET_SW, PRCM_DSI_SW_RESET);
+	for (i = 0; i < 10; i++) {
+		if ((readl(PRCM_PLLDSI_LOCKP) &
+			PRCMU_PLLDSI_LOCKP_LOCKED) == PRCMU_PLLDSI_LOCKP_LOCKED)
+			break;
+		udelay(100);
+	}
+	/* Release DSIPLL_RESETN */
+	writel(PRCMU_RESET_DSIPLL, PRCM_APE_RESETN_SET);
+	return 0;
+}
+
+int db5500_prcmu_disable_dsipll(void)
+{
+	/* Disable dsi pll */
+	writel(PRCMU_DISABLE_PLLDSI, PRCM_PLLDSI_ENABLE);
+	/* Disable  escapeclock */
+	writel(PRCMU_DISABLE_ESCAPE_CLOCK_DIV, PRCM_DSITVCLK_DIV);
+	return 0;
+}
+
+int db5500_prcmu_set_display_clocks(void)
+{
+	/* HDMI and TVCLK Should be handled somewhere else */
+	/* PLLDIV=8, PLLSW=2, CLKEN=1 */
+	writel(PRCMU_DSI_CLOCK_SETTING, PRCM_HDMICLK_MGT);
+	/* PLLDIV=14, PLLSW=2, CLKEN=1 */
+	writel(PRCMU_DSI_LP_CLOCK_SETTING, PRCM_TVCLK_MGT);
+	return 0;
+}
+
+static void ack_dbb_wakeup(void)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&mb0_transfer.lock, flags);
+
+	while (readl(PRCM_MBOX_CPU_VAL) & MBOX_BIT(0))
+		cpu_relax();
+
+	writeb(RMB0H_RD_WAKE_UP_ACK, PRCM_REQ_MB0_HEADER);
+	writel(MBOX_BIT(0), PRCM_MBOX_CPU_SET);
+
+	spin_unlock_irqrestore(&mb0_transfer.lock, flags);
+}
+
+static inline void print_unknown_header_warning(u8 n, u8 header)
+{
+	pr_warning("prcmu: Unknown message header (%d) in mailbox %d.\n",
+		header, n);
+}
+
+static bool read_mailbox_0(void)
+{
+	bool r;
+	u8 header;
+
+	header = readb(PRCM_ACK_MB0_HEADER);
+	switch (header) {
+	case AMB0H_WAKE_UP:
+		r = true;
+		break;
+	default:
+		print_unknown_header_warning(0, header);
+		r = false;
+		break;
+	}
+	writel(MBOX_BIT(0), PRCM_ARM_IT1_CLEAR);
+	return r;
+}
+
+static bool read_mailbox_1(void)
+{
+	writel(MBOX_BIT(1), PRCM_ARM_IT1_CLEAR);
+	return false;
+}
+
+static bool read_mailbox_2(void)
+{
+	writel(MBOX_BIT(2), PRCM_ARM_IT1_CLEAR);
+	return false;
+}
+
+static bool read_mailbox_3(void)
+{
+	writel(MBOX_BIT(3), PRCM_ARM_IT1_CLEAR);
+	return false;
+}
+
+static bool read_mailbox_4(void)
+{
+	writel(MBOX_BIT(4), PRCM_ARM_IT1_CLEAR);
+	return false;
+}
+
+static bool read_mailbox_5(void)
+{
+	u8 header;
+
+	header = readb(PRCM_ACK_MB5_HEADER);
+	switch (header) {
+	case MB5H_I2C_READ:
+		memcpy_fromio(mb5_transfer.ack.value, PRCM_ACK_MB5_I2C_DATA, 4);
+	case MB5H_I2C_WRITE:
+		mb5_transfer.ack.header = header;
+		mb5_transfer.ack.status = readb(PRCM_ACK_MB5_RETURN_CODE);
+		complete(&mb5_transfer.work);
+		break;
+	default:
+		print_unknown_header_warning(5, header);
+		break;
+	}
+	writel(MBOX_BIT(5), PRCM_ARM_IT1_CLEAR);
+	return false;
+}
+
+static bool read_mailbox_6(void)
+{
+	writel(MBOX_BIT(6), PRCM_ARM_IT1_CLEAR);
+	return false;
+}
+
+static bool read_mailbox_7(void)
+{
+	writel(MBOX_BIT(7), PRCM_ARM_IT1_CLEAR);
+	return false;
+}
+
+static bool (* const read_mailbox[NUM_MB])(void) = {
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
+	irqreturn_t r;
+
+	bits = (readl(PRCM_ARM_IT1_VAL) & ALL_MBOX_BITS);
+	if (unlikely(!bits))
+		return IRQ_NONE;
+
+	r = IRQ_HANDLED;
+	for (n = 0; bits; n++) {
+		if (bits & MBOX_BIT(n)) {
+			bits -= MBOX_BIT(n);
+			if (read_mailbox[n]())
+				r = IRQ_WAKE_THREAD;
+		}
+	}
+	return r;
+}
+
+static irqreturn_t prcmu_irq_thread_fn(int irq, void *data)
+{
+	ack_dbb_wakeup();
+	return IRQ_HANDLED;
+}
+
+void __init db5500_prcmu_early_init(void)
+{
+	tcdm_base = __io_address(U5500_PRCMU_TCDM_BASE);
+	spin_lock_init(&mb0_transfer.lock);
+	mutex_init(&mb5_transfer.lock);
+	init_completion(&mb5_transfer.work);
+}
+
+/**
+ * prcmu_fw_init - arch init call for the Linux PRCMU fw init logic
+ *
+ */
+int __init db5500_prcmu_init(void)
+{
+	int r = 0;
+
+	if (ux500_is_svp() || !cpu_is_u5500())
+		return -ENODEV;
+
+	/* Clean up the mailbox interrupts after pre-kernel code. */
+	writel(ALL_MBOX_BITS, PRCM_ARM_IT1_CLEAR);
+
+	r = request_threaded_irq(IRQ_DB5500_PRCMU1, prcmu_irq_handler,
+		prcmu_irq_thread_fn, 0, "prcmu", NULL);
+	if (r < 0) {
+		pr_err("prcmu: Failed to allocate IRQ_DB5500_PRCMU1.\n");
+		return -EBUSY;
+	}
+	return 0;
+}
+
+arch_initcall(db5500_prcmu_init);
diff --git a/include/linux/mfd/db5500-prcmu.h b/include/linux/mfd/db5500-prcmu.h
new file mode 100644
index 0000000..f097798
--- /dev/null
+++ b/include/linux/mfd/db5500-prcmu.h
@@ -0,0 +1,45 @@
+/*
+ * Copyright (C) ST-Ericsson SA 2010
+ *
+ * License Terms: GNU General Public License v2
+ *
+ * U5500 PRCMU API.
+ */
+#ifndef __MACH_PRCMU_U5500_H
+#define __MACH_PRCMU_U5500_H
+
+#ifdef CONFIG_UX500_SOC_DB5500
+
+void db5500_prcmu_early_init(void);
+
+int db5500_prcmu_abb_read(u8 slave, u8 reg, u8 *value, u8 size);
+int db5500_prcmu_abb_write(u8 slave, u8 reg, u8 *value, u8 size);
+
+#else /* !CONFIG_UX500_SOC_DB5500 */
+
+static inline void db5500_prcmu_early_init(void)
+{
+}
+
+static inline int db5500_prcmu_abb_read(u8 slave, u8 reg, u8 *value, u8 size)
+{
+	return -ENOSYS;
+}
+
+static inline int db5500_prcmu_abb_write(u8 slave, u8 reg, u8 *value, u8 size)
+{
+	return -ENOSYS;
+}
+
+#endif /* CONFIG_UX500_SOC_DB5500 */
+
+static inline int db5500_prcmu_config_abb_event_readout(u32 abb_events)
+{
+#ifdef CONFIG_MACH_U5500_SIMULATOR
+	return 0;
+#else
+	return -1;
+#endif
+}
+
+#endif /* __MACH_PRCMU_U5500_H */
-- 
1.7.4.4

