Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754316Ab2KGSd7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 13:33:59 -0500
Received: from smtp161.dfw.emailsrvr.com ([67.192.241.161]:38220 "EHLO
	smtp161.dfw.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753695Ab2KGScx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 13:32:53 -0500
From: Mark Langsdorf <mark.langsdorf@calxeda.com>
To: linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org
Cc: Mark Langsdorf <mark.langsdorf@calxeda.com>,
        Rob Herring <rob.herring@calxeda.com>
Subject: [PATCH 4/6 v4] arm highbank: add support for pl320 IPC
Date: Wed,  7 Nov 2012 12:32:44 -0600
Message-Id: <1352313166-28980-5-git-send-email-mark.langsdorf@calxeda.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1352313166-28980-1-git-send-email-mark.langsdorf@calxeda.com>
References: <1351631056-25938-1-git-send-email-mark.langsdorf@calxeda.com>
 <1352313166-28980-1-git-send-email-mark.langsdorf@calxeda.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <rob.herring@calxeda.com>

The pl320 IPC allows for interprocessor communication between the highbank A9
and the EnergyCore Management Engine. The pl320 implements a straightforward
mailbox protocol.

Signed-off-by: Mark Langsdorf <mark.langsdorf@calxeda.com>
Signed-off-by: Rob Herring <rob.herring@calxeda.com>
---
Changes from v3, v2
	None
Changes from v1
        Removed erroneous changes for cpufreq Kconfig

 arch/arm/include/asm/pl320-ipc.h                |  20 ++
 arch/arm/mach-highbank/Makefile                 |   2 +
 arch/arm/mach-highbank/include/mach/pl320-ipc.h |  20 ++
 arch/arm/mach-highbank/pl320-ipc.c              | 232 ++++++++++++++++++++++++
 4 files changed, 274 insertions(+)
 create mode 100644 arch/arm/include/asm/pl320-ipc.h
 create mode 100644 arch/arm/mach-highbank/include/mach/pl320-ipc.h
 create mode 100644 arch/arm/mach-highbank/pl320-ipc.c

diff --git a/arch/arm/include/asm/pl320-ipc.h b/arch/arm/include/asm/pl320-ipc.h
new file mode 100644
index 0000000..a0e58ee
--- /dev/null
+++ b/arch/arm/include/asm/pl320-ipc.h
@@ -0,0 +1,20 @@
+/*
+ * Copyright 2010 Calxeda, Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+int ipc_call_fast(u32 *data);
+int ipc_call_slow(u32 *data);
+
+extern int pl320_ipc_register_notifier(struct notifier_block *nb);
+extern int pl320_ipc_unregister_notifier(struct notifier_block *nb);
diff --git a/arch/arm/mach-highbank/Makefile b/arch/arm/mach-highbank/Makefile
index 3ec8bdd..b894708 100644
--- a/arch/arm/mach-highbank/Makefile
+++ b/arch/arm/mach-highbank/Makefile
@@ -7,3 +7,5 @@ obj-$(CONFIG_DEBUG_HIGHBANK_UART)	+= lluart.o
 obj-$(CONFIG_SMP)			+= platsmp.o
 obj-$(CONFIG_HOTPLUG_CPU)		+= hotplug.o
 obj-$(CONFIG_PM_SLEEP)			+= pm.o
+
+obj-y					+= pl320-ipc.o
diff --git a/arch/arm/mach-highbank/include/mach/pl320-ipc.h b/arch/arm/mach-highbank/include/mach/pl320-ipc.h
new file mode 100644
index 0000000..a0e58ee
--- /dev/null
+++ b/arch/arm/mach-highbank/include/mach/pl320-ipc.h
@@ -0,0 +1,20 @@
+/*
+ * Copyright 2010 Calxeda, Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+int ipc_call_fast(u32 *data);
+int ipc_call_slow(u32 *data);
+
+extern int pl320_ipc_register_notifier(struct notifier_block *nb);
+extern int pl320_ipc_unregister_notifier(struct notifier_block *nb);
diff --git a/arch/arm/mach-highbank/pl320-ipc.c b/arch/arm/mach-highbank/pl320-ipc.c
new file mode 100644
index 0000000..0eb92e4
--- /dev/null
+++ b/arch/arm/mach-highbank/pl320-ipc.c
@@ -0,0 +1,232 @@
+/*
+ * Copyright 2012 Calxeda, Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+#include <linux/types.h>
+#include <linux/err.h>
+#include <linux/delay.h>
+#include <linux/export.h>
+#include <linux/io.h>
+#include <linux/interrupt.h>
+#include <linux/completion.h>
+#include <linux/mutex.h>
+#include <linux/notifier.h>
+#include <linux/spinlock.h>
+#include <linux/device.h>
+#include <linux/amba/bus.h>
+
+#include <asm/pl320-ipc.h>
+
+#define IPCMxSOURCE(m)		((m) * 0x40)
+#define IPCMxDSET(m)		(((m) * 0x40) + 0x004)
+#define IPCMxDCLEAR(m)		(((m) * 0x40) + 0x008)
+#define IPCMxDSTATUS(m)		(((m) * 0x40) + 0x00C)
+#define IPCMxMODE(m)		(((m) * 0x40) + 0x010)
+#define IPCMxMSET(m)		(((m) * 0x40) + 0x014)
+#define IPCMxMCLEAR(m)		(((m) * 0x40) + 0x018)
+#define IPCMxMSTATUS(m)		(((m) * 0x40) + 0x01C)
+#define IPCMxSEND(m)		(((m) * 0x40) + 0x020)
+#define IPCMxDR(m, dr)		(((m) * 0x40) + ((dr) * 4) + 0x024)
+
+#define IPCMMIS(irq)		(((irq) * 8) + 0x800)
+#define IPCMRIS(irq)		(((irq) * 8) + 0x804)
+
+#define MBOX_MASK(n)		(1 << (n))
+#define IPC_FAST_MBOX		0
+#define IPC_SLOW_MBOX		1
+#define IPC_RX_MBOX		2
+
+#define CHAN_MASK(n)		(1 << (n))
+#define A9_SOURCE		1
+#define M3_SOURCE		0
+
+static void __iomem *ipc_base;
+static int ipc_irq;
+static DEFINE_SPINLOCK(ipc_m0_lock);
+static DEFINE_MUTEX(ipc_m1_lock);
+static DECLARE_COMPLETION(ipc_completion);
+static ATOMIC_NOTIFIER_HEAD(ipc_notifier);
+
+static inline void set_destination(int source, int mbox)
+{
+	__raw_writel(CHAN_MASK(source), ipc_base + IPCMxDSET(mbox));
+	__raw_writel(CHAN_MASK(source), ipc_base + IPCMxMSET(mbox));
+}
+
+static inline void clear_destination(int source, int mbox)
+{
+	__raw_writel(CHAN_MASK(source), ipc_base + IPCMxDCLEAR(mbox));
+	__raw_writel(CHAN_MASK(source), ipc_base + IPCMxMCLEAR(mbox));
+}
+
+static void __ipc_send(int mbox, u32 *data)
+{
+	int i;
+	for (i = 0; i < 7; i++)
+		__raw_writel(data[i], ipc_base + IPCMxDR(mbox, i));
+	__raw_writel(0x1, ipc_base + IPCMxSEND(mbox));
+}
+
+static u32 __ipc_rcv(int mbox, u32 *data)
+{
+	int i;
+	for (i = 0; i < 7; i++)
+		data[i] = __raw_readl(ipc_base + IPCMxDR(mbox, i));
+	return data[1];
+}
+
+/* non-blocking implementation from the A9 side, interrupt safe in theory */
+int ipc_call_fast(u32 *data)
+{
+	int timeout, ret;
+
+	spin_lock(&ipc_m0_lock);
+
+	__ipc_send(IPC_FAST_MBOX, data);
+
+	for (timeout = 500; timeout > 0; timeout--) {
+		if (__raw_readl(ipc_base + IPCMxSEND(IPC_FAST_MBOX)) == 0x2)
+			break;
+		udelay(100);
+	}
+	if (timeout == 0) {
+		ret = -ETIMEDOUT;
+		goto out;
+	}
+
+	ret = __ipc_rcv(IPC_FAST_MBOX, data);
+out:
+	__raw_writel(0, ipc_base + IPCMxSEND(IPC_FAST_MBOX));
+	spin_unlock(&ipc_m0_lock);
+	return ret;
+}
+EXPORT_SYMBOL(ipc_call_fast);
+
+/* blocking implmentation from the A9 side, not usuable in interrupts! */
+int ipc_call_slow(u32 *data)
+{
+	int ret;
+
+	mutex_lock(&ipc_m1_lock);
+
+	init_completion(&ipc_completion);
+	__ipc_send(IPC_SLOW_MBOX, data);
+	ret = wait_for_completion_timeout(&ipc_completion,
+					  msecs_to_jiffies(1000));
+	if (ret == 0) {
+		ret = -ETIMEDOUT;
+		goto out;
+	}
+
+	ret = __ipc_rcv(IPC_SLOW_MBOX, data);
+out:
+	mutex_unlock(&ipc_m1_lock);
+	return ret;
+}
+EXPORT_SYMBOL(ipc_call_slow);
+
+irqreturn_t ipc_handler(int irq, void *dev)
+{
+	u32 irq_stat;
+	u32 data[7];
+
+	irq_stat = __raw_readl(ipc_base + IPCMMIS(1));
+	if (irq_stat & MBOX_MASK(IPC_SLOW_MBOX)) {
+		__raw_writel(0, ipc_base + IPCMxSEND(IPC_SLOW_MBOX));
+		complete(&ipc_completion);
+	}
+	if (irq_stat & MBOX_MASK(IPC_RX_MBOX)) {
+		__ipc_rcv(IPC_RX_MBOX, data);
+		atomic_notifier_call_chain(&ipc_notifier, data[0], data + 1);
+		__raw_writel(2, ipc_base + IPCMxSEND(IPC_RX_MBOX));
+	}
+
+	return IRQ_HANDLED;
+}
+
+int pl320_ipc_register_notifier(struct notifier_block *nb)
+{
+	return atomic_notifier_chain_register(&ipc_notifier, nb);
+}
+
+int pl320_ipc_unregister_notifier(struct notifier_block *nb)
+{
+	return atomic_notifier_chain_unregister(&ipc_notifier, nb);
+}
+
+static int __devinit pl320_probe(struct amba_device *adev,
+				const struct amba_id *id)
+{
+	int ret;
+
+	ipc_base = ioremap(adev->res.start, resource_size(&adev->res));
+	if (ipc_base == NULL)
+		return -ENOMEM;
+
+	__raw_writel(0, ipc_base + IPCMxSEND(IPC_FAST_MBOX));
+	__raw_writel(0, ipc_base + IPCMxSEND(IPC_SLOW_MBOX));
+
+	ipc_irq = adev->irq[0];
+	ret = request_irq(ipc_irq, ipc_handler, 0, dev_name(&adev->dev), NULL);
+	if (ret < 0)
+		goto err;
+
+	/* Init fast mailbox */
+	__raw_writel(CHAN_MASK(A9_SOURCE),
+			ipc_base + IPCMxSOURCE(IPC_FAST_MBOX));
+	set_destination(M3_SOURCE, IPC_FAST_MBOX);
+
+	/* Init slow mailbox */
+	__raw_writel(CHAN_MASK(A9_SOURCE),
+			ipc_base + IPCMxSOURCE(IPC_SLOW_MBOX));
+	__raw_writel(CHAN_MASK(M3_SOURCE),
+			ipc_base + IPCMxDSET(IPC_SLOW_MBOX));
+	__raw_writel(CHAN_MASK(M3_SOURCE) | CHAN_MASK(A9_SOURCE),
+		     ipc_base + IPCMxMSET(IPC_SLOW_MBOX));
+
+	/* Init receive mailbox */
+	__raw_writel(CHAN_MASK(M3_SOURCE),
+			ipc_base + IPCMxSOURCE(IPC_RX_MBOX));
+	__raw_writel(CHAN_MASK(A9_SOURCE),
+			ipc_base + IPCMxDSET(IPC_RX_MBOX));
+	__raw_writel(CHAN_MASK(M3_SOURCE) | CHAN_MASK(A9_SOURCE),
+		     ipc_base + IPCMxMSET(IPC_RX_MBOX));
+
+	return 0;
+err:
+	iounmap(ipc_base);
+	return ret;
+}
+
+static struct amba_id pl320_ids[] = {
+	{
+		.id	= 0x00041320,
+		.mask	= 0x000fffff,
+	},
+	{ 0, 0 },
+};
+
+static struct amba_driver pl320_driver = {
+	.drv = {
+		.name	= "pl320",
+	},
+	.id_table	= pl320_ids,
+	.probe		= pl320_probe,
+};
+
+static int __init ipc_init(void)
+{
+	return amba_driver_register(&pl320_driver);
+}
+module_init(ipc_init);
-- 
1.7.11.7

