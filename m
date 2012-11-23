Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756508Ab2KWAfQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 19:35:16 -0500
Received: from mail-oa0-f46.google.com ([209.85.219.46]:58230 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753225Ab2KWAfM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 19:35:12 -0500
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jason Wessel <jason.wessel@windriver.com>,
        John Stultz <john.stultz@linaro.org>, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org, patches@linaro.org,
        kernel-team@android.com, kgdb-bugreport@lists.sourceforge.net
Subject: [PATCH 4/4] ARM: versatile: Make able to use UART ports for KGDB FIQ debugger
Date: Thu, 22 Nov 2012 16:31:39 -0800
Message-Id: <1353630699-2866-4-git-send-email-anton.vorontsov@linaro.org>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <20121123002957.GA31679@lizard.mcd25758.sjc.wayport.net>
References: <20121123002957.GA31679@lizard.mcd25758.sjc.wayport.net>
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
 arch/arm/mach-versatile/kgdb_fiq.c | 31 +++++++++++++++++++++++++++++++
 3 files changed, 33 insertions(+)
 create mode 100644 arch/arm/mach-versatile/kgdb_fiq.c

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 0bfa6cf..a94d9c5 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -337,6 +337,7 @@ config ARCH_VERSATILE
 	select PLAT_VERSATILE_CLCD
 	select PLAT_VERSATILE_CLOCK
 	select PLAT_VERSATILE_FPGA_IRQ
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
index 0000000..3cdf71d
--- /dev/null
+++ b/arch/arm/mach-versatile/kgdb_fiq.c
@@ -0,0 +1,31 @@
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
+#include <linux/kgdb.h>
+#include <mach/hardware.h>
+#include <mach/platform.h>
+#include <asm/hardware/vic.h>
+
+static int kgdb_fiq;
+module_param_named(uart_num, kgdb_fiq, int, 0600);
+MODULE_PARM_DESC(uart_num, "UART<number> port to use for KGDB FIQ");
+
+static int __init kgdb_fiq_init(void)
+{
+	WARN_ON(kgdb_fiq > INT_UARTINT2 - INT_UARTINT0);
+
+	return kgdb_register_fiq(INT_UARTINT0 + kgdb_fiq,
+				 vic_fiq_select,
+				 vic_is_fiq_rised);
+}
+console_initcall(kgdb_fiq_init);
-- 
1.8.0

