Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752170Ab2DPI2L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 04:28:11 -0400
Received: from eu1sys200aog112.obsmtp.com ([207.126.144.133]:41938 "EHLO
	eu1sys200aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750953Ab2DPI2I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 04:28:08 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Samuel Ortiz <sameo@linux.intel.com>, <linux-kernel@vger.kernel.org>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        Rabin Vincent <rabin.vincent@stericsson.com>,
        Jonas Aberg <jonas.aberg@stericsson.com>,
        Per Forlin <per.forlin@stericsson.com>,
        Ulf Hansson <ulf.hansson@stericsson.com>
Subject: [PATCH 1/2] mfd/db5500-prcmu: delete DB5500 PRCMU support
Date: Mon, 16 Apr 2012 10:27:34 +0200
Message-ID: <1334564854-6102-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.9.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

This platform has been obsoleted and was only available inside of
ST-Ericsson, no users of this code are left in the world. This
deletes the core U5500 support entirely in the same manner as the
obsoleted U8500 silicon was previously deleted.

Cc: Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>
Cc: Rabin Vincent <rabin.vincent@stericsson.com>
Cc: Jonas Aberg <jonas.aberg@stericsson.com>
Cc: Per Forlin <per.forlin@stericsson.com>
Cc: Ulf Hansson <ulf.hansson@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/mfd/Kconfig              |   10 -
 drivers/mfd/Makefile             |    1 -
 drivers/mfd/db5500-prcmu.c       |  451 --------------------------------------
 include/linux/mfd/db5500-prcmu.h |  119 ----------
 include/linux/mfd/dbx500-prcmu.h |  242 ++++----------------
 5 files changed, 43 insertions(+), 780 deletions(-)
 delete mode 100644 drivers/mfd/db5500-prcmu.c
 delete mode 100644 include/linux/mfd/db5500-prcmu.h

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 29f463c..d339a1f 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -704,16 +704,6 @@ config MFD_DB8500_PRCMU
 	  system controller running an XP70 microprocessor, which is accessed
 	  through a register map.
 
-config MFD_DB5500_PRCMU
-	bool "ST-Ericsson DB5500 Power Reset Control Management Unit"
-	depends on UX500_SOC_DB5500
-	select MFD_CORE
-	help
-	  Select this option to enable support for the DB5500 Power Reset
-	  and Control Management Unit. This is basically an autonomous
-	  system controller running an XP70 microprocessor, which is accessed
-	  through a register map.
-
 config MFD_CS5535
 	tristate "Support for CS5535 and CS5536 southbridge core functions"
 	select MFD_CORE
diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index 05fa538..2f53081 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -95,7 +95,6 @@ obj-$(CONFIG_AB8500_GPADC)	+= ab8500-gpadc.o
 obj-$(CONFIG_MFD_DB8500_PRCMU)	+= db8500-prcmu.o
 # ab8500-i2c need to come after db8500-prcmu (which provides the channel)
 obj-$(CONFIG_AB8500_I2C_CORE)	+= ab8500-i2c.o
-obj-$(CONFIG_MFD_DB5500_PRCMU)	+= db5500-prcmu.o
 obj-$(CONFIG_MFD_TIMBERDALE)    += timberdale.o
 obj-$(CONFIG_PMIC_ADP5520)	+= adp5520.o
 obj-$(CONFIG_LPC_SCH)		+= lpc_sch.o
diff --git a/drivers/mfd/db5500-prcmu.c b/drivers/mfd/db5500-prcmu.c
deleted file mode 100644
index bb115b2..0000000
--- a/drivers/mfd/db5500-prcmu.c
+++ /dev/null
@@ -1,451 +0,0 @@
-/*
- * Copyright (C) ST-Ericsson SA 2010
- *
- * License Terms: GNU General Public License v2
- * Author: Mattias Nilsson <mattias.i.nilsson@stericsson.com>
- *
- * U5500 PRCM Unit interface driver
- */
-#include <linux/module.h>
-#include <linux/kernel.h>
-#include <linux/delay.h>
-#include <linux/errno.h>
-#include <linux/err.h>
-#include <linux/spinlock.h>
-#include <linux/io.h>
-#include <linux/slab.h>
-#include <linux/mutex.h>
-#include <linux/completion.h>
-#include <linux/irq.h>
-#include <linux/jiffies.h>
-#include <linux/bitops.h>
-#include <linux/interrupt.h>
-#include <linux/mfd/dbx500-prcmu.h>
-#include <mach/hardware.h>
-#include <mach/irqs.h>
-#include <mach/db5500-regs.h>
-#include "dbx500-prcmu-regs.h"
-
-#define _PRCM_MB_HEADER (tcdm_base + 0xFE8)
-#define PRCM_REQ_MB0_HEADER (_PRCM_MB_HEADER + 0x0)
-#define PRCM_REQ_MB1_HEADER (_PRCM_MB_HEADER + 0x1)
-#define PRCM_REQ_MB2_HEADER (_PRCM_MB_HEADER + 0x2)
-#define PRCM_REQ_MB3_HEADER (_PRCM_MB_HEADER + 0x3)
-#define PRCM_REQ_MB4_HEADER (_PRCM_MB_HEADER + 0x4)
-#define PRCM_REQ_MB5_HEADER (_PRCM_MB_HEADER + 0x5)
-#define PRCM_REQ_MB6_HEADER (_PRCM_MB_HEADER + 0x6)
-#define PRCM_REQ_MB7_HEADER (_PRCM_MB_HEADER + 0x7)
-#define PRCM_ACK_MB0_HEADER (_PRCM_MB_HEADER + 0x8)
-#define PRCM_ACK_MB1_HEADER (_PRCM_MB_HEADER + 0x9)
-#define PRCM_ACK_MB2_HEADER (_PRCM_MB_HEADER + 0xa)
-#define PRCM_ACK_MB3_HEADER (_PRCM_MB_HEADER + 0xb)
-#define PRCM_ACK_MB4_HEADER (_PRCM_MB_HEADER + 0xc)
-#define PRCM_ACK_MB5_HEADER (_PRCM_MB_HEADER + 0xd)
-#define PRCM_ACK_MB6_HEADER (_PRCM_MB_HEADER + 0xe)
-#define PRCM_ACK_MB7_HEADER (_PRCM_MB_HEADER + 0xf)
-
-/* Req Mailboxes */
-#define PRCM_REQ_MB0 (tcdm_base + 0xFD8)
-#define PRCM_REQ_MB1 (tcdm_base + 0xFCC)
-#define PRCM_REQ_MB2 (tcdm_base + 0xFC4)
-#define PRCM_REQ_MB3 (tcdm_base + 0xFC0)
-#define PRCM_REQ_MB4 (tcdm_base + 0xF98)
-#define PRCM_REQ_MB5 (tcdm_base + 0xF90)
-#define PRCM_REQ_MB6 (tcdm_base + 0xF8C)
-#define PRCM_REQ_MB7 (tcdm_base + 0xF84)
-
-/* Ack Mailboxes */
-#define PRCM_ACK_MB0 (tcdm_base + 0xF38)
-#define PRCM_ACK_MB1 (tcdm_base + 0xF30)
-#define PRCM_ACK_MB2 (tcdm_base + 0xF24)
-#define PRCM_ACK_MB3 (tcdm_base + 0xF20)
-#define PRCM_ACK_MB4 (tcdm_base + 0xF1C)
-#define PRCM_ACK_MB5 (tcdm_base + 0xF14)
-#define PRCM_ACK_MB6 (tcdm_base + 0xF0C)
-#define PRCM_ACK_MB7 (tcdm_base + 0xF08)
-
-enum mb_return_code {
-	RC_SUCCESS,
-	RC_FAIL,
-};
-
-/* Mailbox 0 headers. */
-enum mb0_header {
-	/* request */
-	RMB0H_PWR_STATE_TRANS = 1,
-	RMB0H_WAKE_UP_CFG,
-	RMB0H_RD_WAKE_UP_ACK,
-	/* acknowledge */
-	AMB0H_WAKE_UP = 1,
-};
-
-/* Mailbox 5 headers. */
-enum mb5_header {
-	MB5H_I2C_WRITE = 1,
-	MB5H_I2C_READ,
-};
-
-/* Request mailbox 5 fields. */
-#define PRCM_REQ_MB5_I2C_SLAVE (PRCM_REQ_MB5 + 0)
-#define PRCM_REQ_MB5_I2C_REG (PRCM_REQ_MB5 + 1)
-#define PRCM_REQ_MB5_I2C_SIZE (PRCM_REQ_MB5 + 2)
-#define PRCM_REQ_MB5_I2C_DATA (PRCM_REQ_MB5 + 4)
-
-/* Acknowledge mailbox 5 fields. */
-#define PRCM_ACK_MB5_RETURN_CODE (PRCM_ACK_MB5 + 0)
-#define PRCM_ACK_MB5_I2C_DATA (PRCM_ACK_MB5 + 4)
-
-#define NUM_MB 8
-#define MBOX_BIT BIT
-#define ALL_MBOX_BITS (MBOX_BIT(NUM_MB) - 1)
-
-/*
-* Used by MCDE to setup all necessary PRCMU registers
-*/
-#define PRCMU_RESET_DSIPLL			0x00004000
-#define PRCMU_UNCLAMP_DSIPLL			0x00400800
-
-/* HDMI CLK MGT PLLSW=001 (PLLSOC0), PLLDIV=0x8, = 50 Mhz*/
-#define PRCMU_DSI_CLOCK_SETTING			0x00000128
-/* TVCLK_MGT PLLSW=001 (PLLSOC0) PLLDIV=0x13, = 19.05 MHZ */
-#define PRCMU_DSI_LP_CLOCK_SETTING		0x00000135
-#define PRCMU_PLLDSI_FREQ_SETTING		0x00020121
-#define PRCMU_DSI_PLLOUT_SEL_SETTING		0x00000002
-#define PRCMU_ENABLE_ESCAPE_CLOCK_DIV		0x03000201
-#define PRCMU_DISABLE_ESCAPE_CLOCK_DIV		0x00000101
-
-#define PRCMU_ENABLE_PLLDSI			0x00000001
-#define PRCMU_DISABLE_PLLDSI			0x00000000
-
-#define PRCMU_DSI_RESET_SW			0x00000003
-#define PRCMU_RESOUTN0_PIN			0x00000001
-#define PRCMU_RESOUTN1_PIN			0x00000002
-#define PRCMU_RESOUTN2_PIN			0x00000004
-
-#define PRCMU_PLLDSI_LOCKP_LOCKED		0x3
-
-/*
- * mb0_transfer - state needed for mailbox 0 communication.
- * @lock:		The transaction lock.
- */
-static struct {
-	spinlock_t lock;
-} mb0_transfer;
-
-/*
- * mb5_transfer - state needed for mailbox 5 communication.
- * @lock:	The transaction lock.
- * @work:	The transaction completion structure.
- * @ack:	Reply ("acknowledge") data.
- */
-static struct {
-	struct mutex lock;
-	struct completion work;
-	struct {
-		u8 header;
-		u8 status;
-		u8 value[4];
-	} ack;
-} mb5_transfer;
-
-/* PRCMU TCDM base IO address. */
-static __iomem void *tcdm_base;
-
-/**
- * db5500_prcmu_abb_read() - Read register value(s) from the ABB.
- * @slave:	The I2C slave address.
- * @reg:	The (start) register address.
- * @value:	The read out value(s).
- * @size:	The number of registers to read.
- *
- * Reads register value(s) from the ABB.
- * @size has to be <= 4.
- */
-int db5500_prcmu_abb_read(u8 slave, u8 reg, u8 *value, u8 size)
-{
-	int r;
-
-	if ((size < 1) || (4 < size))
-		return -EINVAL;
-
-	mutex_lock(&mb5_transfer.lock);
-
-	while (readl(PRCM_MBOX_CPU_VAL) & MBOX_BIT(5))
-		cpu_relax();
-	writeb(slave, PRCM_REQ_MB5_I2C_SLAVE);
-	writeb(reg, PRCM_REQ_MB5_I2C_REG);
-	writeb(size, PRCM_REQ_MB5_I2C_SIZE);
-	writeb(MB5H_I2C_READ, PRCM_REQ_MB5_HEADER);
-
-	writel(MBOX_BIT(5), PRCM_MBOX_CPU_SET);
-	wait_for_completion(&mb5_transfer.work);
-
-	r = 0;
-	if ((mb5_transfer.ack.header == MB5H_I2C_READ) &&
-		(mb5_transfer.ack.status == RC_SUCCESS))
-		memcpy(value, mb5_transfer.ack.value, (size_t)size);
-	else
-		r = -EIO;
-
-	mutex_unlock(&mb5_transfer.lock);
-
-	return r;
-}
-
-/**
- * db5500_prcmu_abb_write() - Write register value(s) to the ABB.
- * @slave:	The I2C slave address.
- * @reg:	The (start) register address.
- * @value:	The value(s) to write.
- * @size:	The number of registers to write.
- *
- * Writes register value(s) to the ABB.
- * @size has to be <= 4.
- */
-int db5500_prcmu_abb_write(u8 slave, u8 reg, u8 *value, u8 size)
-{
-	int r;
-
-	if ((size < 1) || (4 < size))
-		return -EINVAL;
-
-	mutex_lock(&mb5_transfer.lock);
-
-	while (readl(PRCM_MBOX_CPU_VAL) & MBOX_BIT(5))
-		cpu_relax();
-	writeb(slave, PRCM_REQ_MB5_I2C_SLAVE);
-	writeb(reg, PRCM_REQ_MB5_I2C_REG);
-	writeb(size, PRCM_REQ_MB5_I2C_SIZE);
-	memcpy_toio(PRCM_REQ_MB5_I2C_DATA, value, size);
-	writeb(MB5H_I2C_WRITE, PRCM_REQ_MB5_HEADER);
-
-	writel(MBOX_BIT(5), PRCM_MBOX_CPU_SET);
-	wait_for_completion(&mb5_transfer.work);
-
-	if ((mb5_transfer.ack.header == MB5H_I2C_WRITE) &&
-		(mb5_transfer.ack.status == RC_SUCCESS))
-		r = 0;
-	else
-		r = -EIO;
-
-	mutex_unlock(&mb5_transfer.lock);
-
-	return r;
-}
-
-int db5500_prcmu_enable_dsipll(void)
-{
-	int i;
-
-	/* Enable DSIPLL_RESETN resets */
-	writel(PRCMU_RESET_DSIPLL, PRCM_APE_RESETN_CLR);
-	/* Unclamp DSIPLL in/out */
-	writel(PRCMU_UNCLAMP_DSIPLL, PRCM_MMIP_LS_CLAMP_CLR);
-	/* Set DSI PLL FREQ */
-	writel(PRCMU_PLLDSI_FREQ_SETTING, PRCM_PLLDSI_FREQ);
-	writel(PRCMU_DSI_PLLOUT_SEL_SETTING,
-		PRCM_DSI_PLLOUT_SEL);
-	/* Enable Escape clocks */
-	writel(PRCMU_ENABLE_ESCAPE_CLOCK_DIV, PRCM_DSITVCLK_DIV);
-
-	/* Start DSI PLL */
-	writel(PRCMU_ENABLE_PLLDSI, PRCM_PLLDSI_ENABLE);
-	/* Reset DSI PLL */
-	writel(PRCMU_DSI_RESET_SW, PRCM_DSI_SW_RESET);
-	for (i = 0; i < 10; i++) {
-		if ((readl(PRCM_PLLDSI_LOCKP) &
-			PRCMU_PLLDSI_LOCKP_LOCKED) == PRCMU_PLLDSI_LOCKP_LOCKED)
-			break;
-		udelay(100);
-	}
-	/* Release DSIPLL_RESETN */
-	writel(PRCMU_RESET_DSIPLL, PRCM_APE_RESETN_SET);
-	return 0;
-}
-
-int db5500_prcmu_disable_dsipll(void)
-{
-	/* Disable dsi pll */
-	writel(PRCMU_DISABLE_PLLDSI, PRCM_PLLDSI_ENABLE);
-	/* Disable  escapeclock */
-	writel(PRCMU_DISABLE_ESCAPE_CLOCK_DIV, PRCM_DSITVCLK_DIV);
-	return 0;
-}
-
-int db5500_prcmu_set_display_clocks(void)
-{
-	/* HDMI and TVCLK Should be handled somewhere else */
-	/* PLLDIV=8, PLLSW=2, CLKEN=1 */
-	writel(PRCMU_DSI_CLOCK_SETTING, PRCM_HDMICLK_MGT);
-	/* PLLDIV=14, PLLSW=2, CLKEN=1 */
-	writel(PRCMU_DSI_LP_CLOCK_SETTING, PRCM_TVCLK_MGT);
-	return 0;
-}
-
-static void ack_dbb_wakeup(void)
-{
-	unsigned long flags;
-
-	spin_lock_irqsave(&mb0_transfer.lock, flags);
-
-	while (readl(PRCM_MBOX_CPU_VAL) & MBOX_BIT(0))
-		cpu_relax();
-
-	writeb(RMB0H_RD_WAKE_UP_ACK, PRCM_REQ_MB0_HEADER);
-	writel(MBOX_BIT(0), PRCM_MBOX_CPU_SET);
-
-	spin_unlock_irqrestore(&mb0_transfer.lock, flags);
-}
-
-static inline void print_unknown_header_warning(u8 n, u8 header)
-{
-	pr_warning("prcmu: Unknown message header (%d) in mailbox %d.\n",
-		header, n);
-}
-
-static bool read_mailbox_0(void)
-{
-	bool r;
-	u8 header;
-
-	header = readb(PRCM_ACK_MB0_HEADER);
-	switch (header) {
-	case AMB0H_WAKE_UP:
-		r = true;
-		break;
-	default:
-		print_unknown_header_warning(0, header);
-		r = false;
-		break;
-	}
-	writel(MBOX_BIT(0), PRCM_ARM_IT1_CLR);
-	return r;
-}
-
-static bool read_mailbox_1(void)
-{
-	writel(MBOX_BIT(1), PRCM_ARM_IT1_CLR);
-	return false;
-}
-
-static bool read_mailbox_2(void)
-{
-	writel(MBOX_BIT(2), PRCM_ARM_IT1_CLR);
-	return false;
-}
-
-static bool read_mailbox_3(void)
-{
-	writel(MBOX_BIT(3), PRCM_ARM_IT1_CLR);
-	return false;
-}
-
-static bool read_mailbox_4(void)
-{
-	writel(MBOX_BIT(4), PRCM_ARM_IT1_CLR);
-	return false;
-}
-
-static bool read_mailbox_5(void)
-{
-	u8 header;
-
-	header = readb(PRCM_ACK_MB5_HEADER);
-	switch (header) {
-	case MB5H_I2C_READ:
-		memcpy_fromio(mb5_transfer.ack.value, PRCM_ACK_MB5_I2C_DATA, 4);
-	case MB5H_I2C_WRITE:
-		mb5_transfer.ack.header = header;
-		mb5_transfer.ack.status = readb(PRCM_ACK_MB5_RETURN_CODE);
-		complete(&mb5_transfer.work);
-		break;
-	default:
-		print_unknown_header_warning(5, header);
-		break;
-	}
-	writel(MBOX_BIT(5), PRCM_ARM_IT1_CLR);
-	return false;
-}
-
-static bool read_mailbox_6(void)
-{
-	writel(MBOX_BIT(6), PRCM_ARM_IT1_CLR);
-	return false;
-}
-
-static bool read_mailbox_7(void)
-{
-	writel(MBOX_BIT(7), PRCM_ARM_IT1_CLR);
-	return false;
-}
-
-static bool (* const read_mailbox[NUM_MB])(void) = {
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
-	irqreturn_t r;
-
-	bits = (readl(PRCM_ARM_IT1_VAL) & ALL_MBOX_BITS);
-	if (unlikely(!bits))
-		return IRQ_NONE;
-
-	r = IRQ_HANDLED;
-	for (n = 0; bits; n++) {
-		if (bits & MBOX_BIT(n)) {
-			bits -= MBOX_BIT(n);
-			if (read_mailbox[n]())
-				r = IRQ_WAKE_THREAD;
-		}
-	}
-	return r;
-}
-
-static irqreturn_t prcmu_irq_thread_fn(int irq, void *data)
-{
-	ack_dbb_wakeup();
-	return IRQ_HANDLED;
-}
-
-void __init db5500_prcmu_early_init(void)
-{
-	tcdm_base = __io_address(U5500_PRCMU_TCDM_BASE);
-	spin_lock_init(&mb0_transfer.lock);
-	mutex_init(&mb5_transfer.lock);
-	init_completion(&mb5_transfer.work);
-}
-
-/**
- * prcmu_fw_init - arch init call for the Linux PRCMU fw init logic
- *
- */
-int __init db5500_prcmu_init(void)
-{
-	int r = 0;
-
-	if (ux500_is_svp() || !cpu_is_u5500())
-		return -ENODEV;
-
-	/* Clean up the mailbox interrupts after pre-kernel code. */
-	writel(ALL_MBOX_BITS, PRCM_ARM_IT1_CLR);
-
-	r = request_threaded_irq(IRQ_DB5500_PRCMU1, prcmu_irq_handler,
-		prcmu_irq_thread_fn, 0, "prcmu", NULL);
-	if (r < 0) {
-		pr_err("prcmu: Failed to allocate IRQ_DB5500_PRCMU1.\n");
-		return -EBUSY;
-	}
-	return 0;
-}
-
-arch_initcall(db5500_prcmu_init);
diff --git a/include/linux/mfd/db5500-prcmu.h b/include/linux/mfd/db5500-prcmu.h
deleted file mode 100644
index 9890687..0000000
--- a/include/linux/mfd/db5500-prcmu.h
+++ /dev/null
@@ -1,119 +0,0 @@
-/*
- * Copyright (C) ST-Ericsson SA 2010
- *
- * License Terms: GNU General Public License v2
- *
- * U5500 PRCMU API.
- */
-#ifndef __MFD_DB5500_PRCMU_H
-#define __MFD_DB5500_PRCMU_H
-
-#ifdef CONFIG_MFD_DB5500_PRCMU
-
-void db5500_prcmu_early_init(void);
-int db5500_prcmu_set_epod(u16 epod_id, u8 epod_state);
-int db5500_prcmu_set_display_clocks(void);
-int db5500_prcmu_disable_dsipll(void);
-int db5500_prcmu_enable_dsipll(void);
-int db5500_prcmu_abb_read(u8 slave, u8 reg, u8 *value, u8 size);
-int db5500_prcmu_abb_write(u8 slave, u8 reg, u8 *value, u8 size);
-void db5500_prcmu_enable_wakeups(u32 wakeups);
-int db5500_prcmu_request_clock(u8 clock, bool enable);
-void db5500_prcmu_config_abb_event_readout(u32 abb_events);
-void db5500_prcmu_get_abb_event_buffer(void __iomem **buf);
-int prcmu_resetout(u8 resoutn, u8 state);
-int db5500_prcmu_set_power_state(u8 state, bool keep_ulp_clk,
-	bool keep_ap_pll);
-int db5500_prcmu_config_esram0_deep_sleep(u8 state);
-void db5500_prcmu_system_reset(u16 reset_code);
-u16 db5500_prcmu_get_reset_code(void);
-bool db5500_prcmu_is_ac_wake_requested(void);
-int db5500_prcmu_set_arm_opp(u8 opp);
-int db5500_prcmu_get_arm_opp(void);
-
-#else /* !CONFIG_UX500_SOC_DB5500 */
-
-static inline void db5500_prcmu_early_init(void) {}
-
-static inline int db5500_prcmu_abb_read(u8 slave, u8 reg, u8 *value, u8 size)
-{
-	return -ENOSYS;
-}
-
-static inline int db5500_prcmu_abb_write(u8 slave, u8 reg, u8 *value, u8 size)
-{
-	return -ENOSYS;
-}
-
-static inline int db5500_prcmu_request_clock(u8 clock, bool enable)
-{
-	return 0;
-}
-
-static inline int db5500_prcmu_set_display_clocks(void)
-{
-	return 0;
-}
-
-static inline int db5500_prcmu_disable_dsipll(void)
-{
-	return 0;
-}
-
-static inline int db5500_prcmu_enable_dsipll(void)
-{
-	return 0;
-}
-
-static inline int db5500_prcmu_config_esram0_deep_sleep(u8 state)
-{
-	return 0;
-}
-
-static inline void db5500_prcmu_enable_wakeups(u32 wakeups) {}
-
-static inline int prcmu_resetout(u8 resoutn, u8 state)
-{
-	return 0;
-}
-
-static inline int db5500_prcmu_set_epod(u16 epod_id, u8 epod_state)
-{
-	return 0;
-}
-
-static inline void db5500_prcmu_get_abb_event_buffer(void __iomem **buf) {}
-static inline void db5500_prcmu_config_abb_event_readout(u32 abb_events) {}
-
-static inline int db5500_prcmu_set_power_state(u8 state, bool keep_ulp_clk,
-	bool keep_ap_pll)
-{
-	return 0;
-}
-
-static inline void db5500_prcmu_system_reset(u16 reset_code) {}
-
-static inline u16 db5500_prcmu_get_reset_code(void)
-{
-	return 0;
-}
-
-static inline bool db5500_prcmu_is_ac_wake_requested(void)
-{
-	return 0;
-}
-
-static inline int db5500_prcmu_set_arm_opp(u8 opp)
-{
-	return 0;
-}
-
-static inline int db5500_prcmu_get_arm_opp(void)
-{
-	return 0;
-}
-
-
-#endif /* CONFIG_MFD_DB5500_PRCMU */
-
-#endif /* __MFD_DB5500_PRCMU_H */
diff --git a/include/linux/mfd/dbx500-prcmu.h b/include/linux/mfd/dbx500-prcmu.h
index d7674eb..5a13f93 100644
--- a/include/linux/mfd/dbx500-prcmu.h
+++ b/include/linux/mfd/dbx500-prcmu.h
@@ -55,17 +55,6 @@ enum prcmu_wakeup_index {
 #define NUM_EPOD_ID		8
 
 /*
- * DB5500 EPODs
- */
-#define DB5500_EPOD_ID_BASE 0x0100
-#define DB5500_EPOD_ID_SGA (DB5500_EPOD_ID_BASE + 0)
-#define DB5500_EPOD_ID_HVA (DB5500_EPOD_ID_BASE + 1)
-#define DB5500_EPOD_ID_SIA (DB5500_EPOD_ID_BASE + 2)
-#define DB5500_EPOD_ID_DISP (DB5500_EPOD_ID_BASE + 3)
-#define DB5500_EPOD_ID_ESRAM12 (DB5500_EPOD_ID_BASE + 6)
-#define DB5500_NUM_EPOD_ID 7
-
-/*
  * state definition for EPOD (power domain)
  * - EPOD_STATE_NO_CHANGE: The EPOD should remain unchanged
  * - EPOD_STATE_OFF: The EPOD is switched off
@@ -80,29 +69,6 @@ enum prcmu_wakeup_index {
 #define EPOD_STATE_ON_CLK_OFF	0x03
 #define EPOD_STATE_ON		0x04
 
-/* DB5500 CLKOUT IDs */
-enum {
-	DB5500_CLKOUT0 = 0,
-	DB5500_CLKOUT1,
-};
-
-/* DB5500 CLKOUTx sources */
-enum {
-	DB5500_CLKOUT_REF_CLK_SEL0,
-	DB5500_CLKOUT_RTC_CLK0_SEL0,
-	DB5500_CLKOUT_ULP_CLK_SEL0,
-	DB5500_CLKOUT_STATIC0,
-	DB5500_CLKOUT_REFCLK,
-	DB5500_CLKOUT_ULPCLK,
-	DB5500_CLKOUT_ARMCLK,
-	DB5500_CLKOUT_SYSACC0CLK,
-	DB5500_CLKOUT_SOC0PLLCLK,
-	DB5500_CLKOUT_SOC1PLLCLK,
-	DB5500_CLKOUT_DDRPLLCLK,
-	DB5500_CLKOUT_TVCLK,
-	DB5500_CLKOUT_IRDACLK,
-};
-
 /*
  * CLKOUT sources
  */
@@ -248,101 +214,66 @@ enum ddr_pwrst {
 };
 
 #include <linux/mfd/db8500-prcmu.h>
-#include <linux/mfd/db5500-prcmu.h>
 
-#if defined(CONFIG_UX500_SOC_DB8500) || defined(CONFIG_UX500_SOC_DB5500)
+#if defined(CONFIG_UX500_SOC_DB8500)
 
 #include <mach/id.h>
 
 static inline void __init prcmu_early_init(void)
 {
-	if (cpu_is_u5500())
-		return db5500_prcmu_early_init();
-	else
-		return db8500_prcmu_early_init();
+	return db8500_prcmu_early_init();
 }
 
 static inline int prcmu_set_power_state(u8 state, bool keep_ulp_clk,
 		bool keep_ap_pll)
 {
-	if (cpu_is_u5500())
-		return db5500_prcmu_set_power_state(state, keep_ulp_clk,
-			keep_ap_pll);
-	else
-		return db8500_prcmu_set_power_state(state, keep_ulp_clk,
-			keep_ap_pll);
+	return db8500_prcmu_set_power_state(state, keep_ulp_clk,
+		keep_ap_pll);
 }
 
 static inline u8 prcmu_get_power_state_result(void)
 {
-	if (cpu_is_u5500())
-		return -EINVAL;
-	else
-		return db8500_prcmu_get_power_state_result();
+	return db8500_prcmu_get_power_state_result();
 }
 
 static inline int prcmu_gic_decouple(void)
 {
-	if (cpu_is_u5500())
-		return -EINVAL;
-	else
-		return db8500_prcmu_gic_decouple();
+	return db8500_prcmu_gic_decouple();
 }
 
 static inline int prcmu_gic_recouple(void)
 {
-	if (cpu_is_u5500())
-		return -EINVAL;
-	else
-		return db8500_prcmu_gic_recouple();
+	return db8500_prcmu_gic_recouple();
 }
 
 static inline bool prcmu_gic_pending_irq(void)
 {
-	if (cpu_is_u5500())
-		return -EINVAL;
-	else
-		return db8500_prcmu_gic_pending_irq();
+	return db8500_prcmu_gic_pending_irq();
 }
 
 static inline bool prcmu_is_cpu_in_wfi(int cpu)
 {
-	if (cpu_is_u5500())
-		return -EINVAL;
-	else
-		return db8500_prcmu_is_cpu_in_wfi(cpu);
+	return db8500_prcmu_is_cpu_in_wfi(cpu);
 }
 
 static inline int prcmu_copy_gic_settings(void)
 {
-	if (cpu_is_u5500())
-		return -EINVAL;
-	else
-		return db8500_prcmu_copy_gic_settings();
+	return db8500_prcmu_copy_gic_settings();
 }
 
 static inline bool prcmu_pending_irq(void)
 {
-        if (cpu_is_u5500())
-                return -EINVAL;
-        else
-                return db8500_prcmu_pending_irq();
+	return db8500_prcmu_pending_irq();
 }
 
 static inline int prcmu_set_epod(u16 epod_id, u8 epod_state)
 {
-	if (cpu_is_u5500())
-		return -EINVAL;
-	else
-		return db8500_prcmu_set_epod(epod_id, epod_state);
+	return db8500_prcmu_set_epod(epod_id, epod_state);
 }
 
 static inline void prcmu_enable_wakeups(u32 wakeups)
 {
-	if (cpu_is_u5500())
-		db5500_prcmu_enable_wakeups(wakeups);
-	else
-		db8500_prcmu_enable_wakeups(wakeups);
+	db8500_prcmu_enable_wakeups(wakeups);
 }
 
 static inline void prcmu_disable_wakeups(void)
@@ -352,18 +283,12 @@ static inline void prcmu_disable_wakeups(void)
 
 static inline void prcmu_config_abb_event_readout(u32 abb_events)
 {
-	if (cpu_is_u5500())
-		db5500_prcmu_config_abb_event_readout(abb_events);
-	else
-		db8500_prcmu_config_abb_event_readout(abb_events);
+	db8500_prcmu_config_abb_event_readout(abb_events);
 }
 
 static inline void prcmu_get_abb_event_buffer(void __iomem **buf)
 {
-	if (cpu_is_u5500())
-		db5500_prcmu_get_abb_event_buffer(buf);
-	else
-		db8500_prcmu_get_abb_event_buffer(buf);
+	db8500_prcmu_get_abb_event_buffer(buf);
 }
 
 int prcmu_abb_read(u8 slave, u8 reg, u8 *value, u8 size);
@@ -374,10 +299,7 @@ int prcmu_config_clkout(u8 clkout, u8 source, u8 div);
 
 static inline int prcmu_request_clock(u8 clock, bool enable)
 {
-	if (cpu_is_u5500())
-		return db5500_prcmu_request_clock(clock, enable);
-	else
-		return db8500_prcmu_request_clock(clock, enable);
+	return db8500_prcmu_request_clock(clock, enable);
 }
 
 unsigned long prcmu_clock_rate(u8 clock);
@@ -386,211 +308,133 @@ int prcmu_set_clock_rate(u8 clock, unsigned long rate);
 
 static inline int prcmu_set_ddr_opp(u8 opp)
 {
-	if (cpu_is_u5500())
-		return -EINVAL;
-	else
-		return db8500_prcmu_set_ddr_opp(opp);
+	return db8500_prcmu_set_ddr_opp(opp);
 }
 static inline int prcmu_get_ddr_opp(void)
 {
-	if (cpu_is_u5500())
-		return -EINVAL;
-	else
-		return db8500_prcmu_get_ddr_opp();
+	return db8500_prcmu_get_ddr_opp();
 }
 
 static inline int prcmu_set_arm_opp(u8 opp)
 {
-	if (cpu_is_u5500())
-		return -EINVAL;
-	else
-		return db8500_prcmu_set_arm_opp(opp);
+	return db8500_prcmu_set_arm_opp(opp);
 }
 
 static inline int prcmu_get_arm_opp(void)
 {
-	if (cpu_is_u5500())
-		return -EINVAL;
-	else
-		return db8500_prcmu_get_arm_opp();
+	return db8500_prcmu_get_arm_opp();
 }
 
 static inline int prcmu_set_ape_opp(u8 opp)
 {
-	if (cpu_is_u5500())
-		return -EINVAL;
-	else
-		return db8500_prcmu_set_ape_opp(opp);
+	return db8500_prcmu_set_ape_opp(opp);
 }
 
 static inline int prcmu_get_ape_opp(void)
 {
-	if (cpu_is_u5500())
-		return -EINVAL;
-	else
-		return db8500_prcmu_get_ape_opp();
+	return db8500_prcmu_get_ape_opp();
 }
 
 static inline void prcmu_system_reset(u16 reset_code)
 {
-	if (cpu_is_u5500())
-		return db5500_prcmu_system_reset(reset_code);
-	else
-		return db8500_prcmu_system_reset(reset_code);
+	return db8500_prcmu_system_reset(reset_code);
 }
 
 static inline u16 prcmu_get_reset_code(void)
 {
-	if (cpu_is_u5500())
-		return db5500_prcmu_get_reset_code();
-	else
-		return db8500_prcmu_get_reset_code();
+	return db8500_prcmu_get_reset_code();
 }
 
 void prcmu_ac_wake_req(void);
 void prcmu_ac_sleep_req(void);
 static inline void prcmu_modem_reset(void)
 {
-	if (cpu_is_u5500())
-		return;
-	else
-		return db8500_prcmu_modem_reset();
+	return db8500_prcmu_modem_reset();
 }
 
 static inline bool prcmu_is_ac_wake_requested(void)
 {
-	if (cpu_is_u5500())
-		return db5500_prcmu_is_ac_wake_requested();
-	else
-		return db8500_prcmu_is_ac_wake_requested();
+	return db8500_prcmu_is_ac_wake_requested();
 }
 
 static inline int prcmu_set_display_clocks(void)
 {
-	if (cpu_is_u5500())
-		return db5500_prcmu_set_display_clocks();
-	else
-		return db8500_prcmu_set_display_clocks();
+	return db8500_prcmu_set_display_clocks();
 }
 
 static inline int prcmu_disable_dsipll(void)
 {
-	if (cpu_is_u5500())
-		return db5500_prcmu_disable_dsipll();
-	else
-		return db8500_prcmu_disable_dsipll();
+	return db8500_prcmu_disable_dsipll();
 }
 
 static inline int prcmu_enable_dsipll(void)
 {
-	if (cpu_is_u5500())
-		return db5500_prcmu_enable_dsipll();
-	else
-		return db8500_prcmu_enable_dsipll();
+	return db8500_prcmu_enable_dsipll();
 }
 
 static inline int prcmu_config_esram0_deep_sleep(u8 state)
 {
-	if (cpu_is_u5500())
-		return -EINVAL;
-	else
-		return db8500_prcmu_config_esram0_deep_sleep(state);
+	return db8500_prcmu_config_esram0_deep_sleep(state);
 }
 
 static inline int prcmu_config_hotdog(u8 threshold)
 {
-	if (cpu_is_u5500())
-		return -EINVAL;
-	else
-		return db8500_prcmu_config_hotdog(threshold);
+	return db8500_prcmu_config_hotdog(threshold);
 }
 
 static inline int prcmu_config_hotmon(u8 low, u8 high)
 {
-	if (cpu_is_u5500())
-		return -EINVAL;
-	else
-		return db8500_prcmu_config_hotmon(low, high);
+	return db8500_prcmu_config_hotmon(low, high);
 }
 
 static inline int prcmu_start_temp_sense(u16 cycles32k)
 {
-	if (cpu_is_u5500())
-		return  -EINVAL;
-	else
-		return  db8500_prcmu_start_temp_sense(cycles32k);
+	return  db8500_prcmu_start_temp_sense(cycles32k);
 }
 
 static inline int prcmu_stop_temp_sense(void)
 {
-	if (cpu_is_u5500())
-		return  -EINVAL;
-	else
-		return  db8500_prcmu_stop_temp_sense();
+	return  db8500_prcmu_stop_temp_sense();
 }
 
 static inline u32 prcmu_read(unsigned int reg)
 {
-	if (cpu_is_u5500())
-		return -EINVAL;
-	else
-		return db8500_prcmu_read(reg);
+	return db8500_prcmu_read(reg);
 }
 
 static inline void prcmu_write(unsigned int reg, u32 value)
 {
-	if (cpu_is_u5500())
-		return;
-	else
-		db8500_prcmu_write(reg, value);
+	db8500_prcmu_write(reg, value);
 }
 
 static inline void prcmu_write_masked(unsigned int reg, u32 mask, u32 value)
 {
-	if (cpu_is_u5500())
-		return;
-	else
-		db8500_prcmu_write_masked(reg, mask, value);
+	db8500_prcmu_write_masked(reg, mask, value);
 }
 
 static inline int prcmu_enable_a9wdog(u8 id)
 {
-	if (cpu_is_u5500())
-		return -EINVAL;
-	else
-		return db8500_prcmu_enable_a9wdog(id);
+	return db8500_prcmu_enable_a9wdog(id);
 }
 
 static inline int prcmu_disable_a9wdog(u8 id)
 {
-	if (cpu_is_u5500())
-		return -EINVAL;
-	else
-		return db8500_prcmu_disable_a9wdog(id);
+	return db8500_prcmu_disable_a9wdog(id);
 }
 
 static inline int prcmu_kick_a9wdog(u8 id)
 {
-	if (cpu_is_u5500())
-		return -EINVAL;
-	else
-		return db8500_prcmu_kick_a9wdog(id);
+	return db8500_prcmu_kick_a9wdog(id);
 }
 
 static inline int prcmu_load_a9wdog(u8 id, u32 timeout)
 {
-	if (cpu_is_u5500())
-		return -EINVAL;
-	else
-		return db8500_prcmu_load_a9wdog(id, timeout);
+	return db8500_prcmu_load_a9wdog(id, timeout);
 }
 
 static inline int prcmu_config_a9wdog(u8 num, bool sleep_auto_off)
 {
-	if (cpu_is_u5500())
-		return -EINVAL;
-	else
-		return db8500_prcmu_config_a9wdog(num, sleep_auto_off);
+	return db8500_prcmu_config_a9wdog(num, sleep_auto_off);
 }
 #else
 
@@ -768,7 +612,7 @@ static inline void prcmu_clear(unsigned int reg, u32 bits)
 	prcmu_write_masked(reg, bits, 0);
 }
 
-#if defined(CONFIG_UX500_SOC_DB8500) || defined(CONFIG_UX500_SOC_DB5500)
+#if defined(CONFIG_UX500_SOC_DB8500)
 
 /**
  * prcmu_enable_spi2 - Enables pin muxing for SPI2 on OtherAlternateC1.
-- 
1.7.9.2

