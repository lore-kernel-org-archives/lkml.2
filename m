Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753311Ab3AGBey (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2013 20:34:54 -0500
Received: from mail-pa0-f49.google.com ([209.85.220.49]:38619 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752664Ab3AGBeu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2013 20:34:50 -0500
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Russell King <linux@arm.linux.org.uk>,
        Jason Wessel <jason.wessel@windriver.com>,
        John Stultz <john.stultz@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com
Subject: [PATCH 3/3] ARM: versatile: Make able to use UART ports for KGDB FIQ debugger
Date: Sun,  6 Jan 2013 17:23:51 -0800
Message-Id: <1357521831-6053-3-git-send-email-anton.vorontsov@linaro.org>
X-Mailer: git-send-email 1.8.0.2
In-Reply-To: <20130107012242.GA31052@lizard.mcd01528.sjc.wayport.net>
References: <20130107012242.GA31052@lizard.mcd01528.sjc.wayport.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If enabled, kernel will able to enter KGDB upon serial line activity on
UART ports.

Note that even with this patch and CONFIG_KGDB_FIQ is enabled, you still
need to pass kgdb_fiq.enable=1 kernel command line option, otherwise UART
will behave in a normal way.

By default UART0 is used, but this can be changed via kgdb_fiq.uart_num
kernel command line option.

Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
---
 arch/arm/Kconfig                   |  1 +
 arch/arm/mach-versatile/Makefile   |  1 +
 arch/arm/mach-versatile/kgdb_fiq.c | 55 ++++++++++++++++++++++++++++++++++++++
 3 files changed, 57 insertions(+)
 create mode 100644 arch/arm/mach-versatile/kgdb_fiq.c

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index bde27c1..8fea25d 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -338,6 +338,7 @@ config ARCH_VERSATILE
 	select PLAT_VERSATILE_CLCD
 	select PLAT_VERSATILE_CLOCK
 	select VERSATILE_FPGA_IRQ
+	select ARCH_MIGHT_HAVE_KGDB_FIQ
 	help
 	  This enables support for ARM Ltd Versatile board.
 
diff --git a/arch/arm/mach-versatile/Makefile b/arch/arm/mach-versatile/Makefile
index 81fa3fe..bfd761f 100644
--- a/arch/arm/mach-versatile/Makefile
+++ b/arch/arm/mach-versatile/Makefile
@@ -7,3 +7,4 @@ obj-$(CONFIG_ARCH_VERSATILE_PB)		+= versatile_pb.o
 obj-$(CONFIG_MACH_VERSATILE_AB)		+= versatile_ab.o
 obj-$(CONFIG_MACH_VERSATILE_DT)		+= versatile_dt.o
 obj-$(CONFIG_PCI)			+= pci.o
+obj-$(CONFIG_KGDB_FIQ)			+= kgdb_fiq.o
diff --git a/arch/arm/mach-versatile/kgdb_fiq.c b/arch/arm/mach-versatile/kgdb_fiq.c
new file mode 100644
index 0000000..dd92e40
--- /dev/null
+++ b/arch/arm/mach-versatile/kgdb_fiq.c
@@ -0,0 +1,55 @@
+/*
+ * KGDB FIQ board support
+ *
+ * Copyright 2012 Linaro Ltd.
+ *		  Anton Vorontsov <anton.vorontsov@linaro.org>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published
+ * by the Free Software Foundation.
+ */
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/io.h>
+#include <linux/kgdb.h>
+#include <mach/hardware.h>
+#include <mach/platform.h>
+#include <asm/hardware/vic.h>
+
+static void *kgdb_irq_base;
+
+static int kgdb_irq;
+module_param_named(uart_num, kgdb_irq, int, 0600);
+MODULE_PARM_DESC(uart_num, "UART<number> port to use for KGDB FIQ");
+
+static void kgdb_fiq_select(bool on)
+{
+	void __iomem *sel = kgdb_irq_base + VIC_INT_SELECT;
+	u32 msk = 1 << kgdb_irq;
+	u32 val;
+
+	pr_debug("rerouting VIC vector %d to %s\n", kgdb_irq,
+		 on ? "FIQ" : "IRQ");
+
+	val = readl(sel);
+	val &= ~msk;
+	if (on)
+		val |= msk;
+	writel(val, sel);
+}
+
+static bool kgdb_is_fiq_rised(void)
+{
+	return readl(kgdb_irq_base + VIC_FIQ_STATUS) & (1 << kgdb_irq);
+}
+
+static int __init kgdb_fiq_init(void)
+{
+	kgdb_irq_base = __io_address(VERSATILE_VIC_BASE);
+	kgdb_irq += INT_UARTINT0;
+	WARN_ON(kgdb_irq > INT_UARTINT2);
+
+	return kgdb_register_fiq(kgdb_fiq_select, kgdb_is_fiq_rised);
+}
+console_initcall(kgdb_fiq_init);
-- 
1.8.0.2

