Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753801Ab1EUImf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 May 2011 04:42:35 -0400
Received: from eu1sys200aog117.obsmtp.com ([207.126.144.143]:46017 "EHLO
	eu1sys200aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753584Ab1EUIma (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 May 2011 04:42:30 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Samuel Ortiz <sameo@linux.intel.com>, <linux-kernel@vger.kernel.org>
Cc: Lee Jones <lee.jones@linaro.org>, Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 05/13] mach-ux500: rename PRCMU driver per SoC
Date: Sat, 21 May 2011 10:42:19 +0200
Message-ID: <1305967339-16511-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

This renames the prcmu.c file to prcmu-db8500.c so as to indicate
that it is for this one SoC.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 arch/arm/mach-ux500/Makefile       |    2 +-
 arch/arm/mach-ux500/prcmu-db8500.c |  394 ++++++++++++++++++++++++++++++++++++
 arch/arm/mach-ux500/prcmu.c        |  394 ------------------------------------
 3 files changed, 395 insertions(+), 395 deletions(-)
 create mode 100644 arch/arm/mach-ux500/prcmu-db8500.c
 delete mode 100644 arch/arm/mach-ux500/prcmu.c

diff --git a/arch/arm/mach-ux500/Makefile b/arch/arm/mach-ux500/Makefile
index b549a8f..2a08a10 100644
--- a/arch/arm/mach-ux500/Makefile
+++ b/arch/arm/mach-ux500/Makefile
@@ -5,7 +5,7 @@
 obj-y				:= clock.o cpu.o devices.o devices-common.o \
 				   id.o usb.o
 obj-$(CONFIG_UX500_SOC_DB5500)	+= cpu-db5500.o dma-db5500.o
-obj-$(CONFIG_UX500_SOC_DB8500)	+= cpu-db8500.o devices-db8500.o prcmu.o
+obj-$(CONFIG_UX500_SOC_DB8500)	+= cpu-db8500.o devices-db8500.o prcmu-db8500.o
 obj-$(CONFIG_MACH_U8500)	+= board-mop500.o board-mop500-sdi.o \
 				board-mop500-regulators.o \
 				board-mop500-uib.o board-mop500-stuib.o \
diff --git a/arch/arm/mach-ux500/prcmu-db8500.c b/arch/arm/mach-ux500/prcmu-db8500.c
new file mode 100644
index 0000000..c522d26
--- /dev/null
+++ b/arch/arm/mach-ux500/prcmu-db8500.c
@@ -0,0 +1,394 @@
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
+
+#include <mach/hardware.h>
+#include <mach/prcmu-regs.h>
+#include <mach/prcmu-defs.h>
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
diff --git a/arch/arm/mach-ux500/prcmu.c b/arch/arm/mach-ux500/prcmu.c
deleted file mode 100644
index c522d26..0000000
--- a/arch/arm/mach-ux500/prcmu.c
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
-- 
1.7.3.2

