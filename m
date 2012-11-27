Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756337Ab2K0UG3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 15:06:29 -0500
Received: from smtp111.dfw.emailsrvr.com ([67.192.241.111]:52891 "EHLO
	smtp111.dfw.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755522Ab2K0UEf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 15:04:35 -0500
From: Mark Langsdorf <mark.langsdorf@calxeda.com>
To: linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Mark Langsdorf <mark.langsdorf@calxeda.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Omar Ramirez Luna <omar.luna@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 4/6 v6] arm highbank: add support for pl320 IPC
Date: Tue, 27 Nov 2012 14:04:30 -0600
Message-Id: <1354046672-7392-5-git-send-email-mark.langsdorf@calxeda.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1354046672-7392-1-git-send-email-mark.langsdorf@calxeda.com>
References: <1351631056-25938-1-git-send-email-mark.langsdorf@calxeda.com>
 <1354046672-7392-1-git-send-email-mark.langsdorf@calxeda.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <rob.herring@calxeda.com>

The pl320 IPC allows for interprocessor communication between the highbank A9
and the EnergyCore Management Engine. The pl320 implements a straightforward
mailbox protocol.

This patch depends on Omar Ramirez Luna's <omar.luna@linaro.org>
mailbox driver patch series.

Signed-off-by: Mark Langsdorf <mark.langsdorf@calxeda.com>
Signed-off-by: Rob Herring <rob.herring@calxeda.com>
Cc: Omar Ramirez Luna <omar.luna@linaro.org>
Cc: Arnd Bergmann <arnd@arndb.de>
---
Changes from v5
	Renamed ipc_transmit() to pl320_ipc_transmit().
	Properly exported pl320_ipc_{un}register_notifier().
Changes from v4
        Moved pl320-ipc.c from arch/arm/mach-highbank to drivers/mailbox.
        Moved header information to include/linux/mailbox.h.
        Added Kconfig options to reflect the new code location.
        Change drivers/mailbox/Makefile to build the omap mailboxes only 
        when they are configured.
        Removed ipc_call_fast and renamed ipc_call_slow ipc_transmit.
Changes from v3, v2
        None.
Changes from v1
        Removed erroneous changes for cpufreq Kconfig.


 arch/arm/mach-highbank/Kconfig |   2 +
 drivers/mailbox/Kconfig        |   9 ++
 drivers/mailbox/Makefile       |   4 +
 drivers/mailbox/pl320-ipc.c    | 199 +++++++++++++++++++++++++++++++++++++++++
 include/linux/mailbox.h        |  19 +++-
 5 files changed, 232 insertions(+), 1 deletion(-)
 create mode 100644 drivers/mailbox/Makefile
 create mode 100644 drivers/mailbox/pl320-ipc.c

diff --git a/arch/arm/mach-highbank/Kconfig b/arch/arm/mach-highbank/Kconfig
index 0e1d0a4..2896881 100644
--- a/arch/arm/mach-highbank/Kconfig
+++ b/arch/arm/mach-highbank/Kconfig
@@ -11,5 +11,7 @@ config ARCH_HIGHBANK
 	select GENERIC_CLOCKEVENTS
 	select HAVE_ARM_SCU
 	select HAVE_SMP
+	select MAILBOX
+	select PL320_MBOX
 	select SPARSE_IRQ
 	select USE_OF
diff --git a/drivers/mailbox/Kconfig b/drivers/mailbox/Kconfig
index be8cac0..e89fdb4 100644
--- a/drivers/mailbox/Kconfig
+++ b/drivers/mailbox/Kconfig
@@ -34,4 +34,13 @@ config OMAP_MBOX_KFIFO_SIZE
 	  This can also be changed at runtime (via the mbox_kfifo_size
 	  module parameter).
 
+config PL320_MBOX
+	bool "ARM PL320 Mailbox"
+	help
+	  An implementation of the ARM PL320 Interprocessor Communication
+	  Mailbox (IPCM), tailored for the Calxeda Highbank. It is used to
+	  send short messages between Highbank's A9 cores and the EnergyCore
+	  Management Engine, primarily for cpufreq. Say Y here if you want
+	  to use the PL320 IPCM support.
+
 endif
diff --git a/drivers/mailbox/Makefile b/drivers/mailbox/Makefile
new file mode 100644
index 0000000..c9f14c3
--- /dev/null
+++ b/drivers/mailbox/Makefile
@@ -0,0 +1,4 @@
+obj-$(CONFIG_OMAP1_MBOX)	+= mailbox.o mailbox-omap1.o
+obj-$(CONFIG_OMAP2PLUS_MBOX)	+= mailbox.o mailbox-omap2.o
+obj-$(CONFIG_PL320_MBOX)	+= pl320-ipc.o
+
diff --git a/drivers/mailbox/pl320-ipc.c b/drivers/mailbox/pl320-ipc.c
new file mode 100644
index 0000000..1a9d8e4
--- /dev/null
+++ b/drivers/mailbox/pl320-ipc.c
@@ -0,0 +1,199 @@
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
+#include <linux/mailbox.h>
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
+#define IPC_TX_MBOX		1
+#define IPC_RX_MBOX		2
+
+#define CHAN_MASK(n)		(1 << (n))
+#define A9_SOURCE		1
+#define M3_SOURCE		0
+
+static void __iomem *ipc_base;
+static int ipc_irq;
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
+/* blocking implmentation from the A9 side, not usuable in interrupts! */
+int pl320_ipc_transmit(u32 *data)
+{
+	int ret;
+
+	mutex_lock(&ipc_m1_lock);
+
+	init_completion(&ipc_completion);
+	__ipc_send(IPC_TX_MBOX, data);
+	ret = wait_for_completion_timeout(&ipc_completion,
+					  msecs_to_jiffies(1000));
+	if (ret == 0) {
+		ret = -ETIMEDOUT;
+		goto out;
+	}
+
+	ret = __ipc_rcv(IPC_TX_MBOX, data);
+out:
+	mutex_unlock(&ipc_m1_lock);
+	return ret;
+}
+EXPORT_SYMBOL(pl320_ipc_transmit);
+
+irqreturn_t ipc_handler(int irq, void *dev)
+{
+	u32 irq_stat;
+	u32 data[7];
+
+	irq_stat = __raw_readl(ipc_base + IPCMMIS(1));
+	if (irq_stat & MBOX_MASK(IPC_TX_MBOX)) {
+		__raw_writel(0, ipc_base + IPCMxSEND(IPC_TX_MBOX));
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
+EXPORT_SYMBOL(pl320_ipc_register_notifier);
+
+int pl320_ipc_unregister_notifier(struct notifier_block *nb)
+{
+	return atomic_notifier_chain_unregister(&ipc_notifier, nb);
+}
+EXPORT_SYMBOL(pl320_ipc_unregister_notifier);
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
+	__raw_writel(0, ipc_base + IPCMxSEND(IPC_TX_MBOX));
+
+	ipc_irq = adev->irq[0];
+	ret = request_irq(ipc_irq, ipc_handler, 0, dev_name(&adev->dev), NULL);
+	if (ret < 0)
+		goto err;
+
+	/* Init slow mailbox */
+	__raw_writel(CHAN_MASK(A9_SOURCE),
+			ipc_base + IPCMxSOURCE(IPC_TX_MBOX));
+	__raw_writel(CHAN_MASK(M3_SOURCE),
+			ipc_base + IPCMxDSET(IPC_TX_MBOX));
+	__raw_writel(CHAN_MASK(M3_SOURCE) | CHAN_MASK(A9_SOURCE),
+		     ipc_base + IPCMxMSET(IPC_TX_MBOX));
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
diff --git a/include/linux/mailbox.h b/include/linux/mailbox.h
index e8e4131..e7829e5 100644
--- a/include/linux/mailbox.h
+++ b/include/linux/mailbox.h
@@ -1,4 +1,16 @@
-/* mailbox.h */
+/*
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
 
 typedef u32 mbox_msg_t;
 struct omap_mbox;
@@ -20,3 +32,8 @@ void omap_mbox_save_ctx(struct omap_mbox *mbox);
 void omap_mbox_restore_ctx(struct omap_mbox *mbox);
 void omap_mbox_enable_irq(struct omap_mbox *mbox, omap_mbox_irq_t irq);
 void omap_mbox_disable_irq(struct omap_mbox *mbox, omap_mbox_irq_t irq);
+
+int pl320_ipc_transmit(u32 *data);
+int pl320_ipc_register_notifier(struct notifier_block *nb);
+int pl320_ipc_unregister_notifier(struct notifier_block *nb);
+
-- 
1.7.11.7

