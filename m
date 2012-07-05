Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030214Ab2GEXPw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 19:15:52 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:56057 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933434Ab2GEXPP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 19:15:15 -0400
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Russell King <linux@arm.linux.org.uk>,
        Jason Wessel <jason.wessel@windriver.com>
Cc: =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
        Colin Cross <ccross@android.com>, John Stultz <john.stultz@linaro.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linaro-kernel@lists.linaro.org, patches@linaro.org,
        kernel-team@android.com, kgdb-bugreport@lists.sourceforge.net
Subject: [PATCH 6/6] ARM: versatile: Make able to use UART ports for KGDB FIQ debugger
Date: Thu,  5 Jul 2012 16:12:40 -0700
Message-Id: <1341529960-18370-6-git-send-email-anton.vorontsov@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <20120705231034.GA16931@lizard>
References: <20120705231034.GA16931@lizard>
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
 arch/arm/mach-versatile/Makefile            |    1 +
 arch/arm/mach-versatile/include/mach/irqs.h |    1 +
 arch/arm/mach-versatile/kgdb_fiq.c          |   40 +++++++++++++++++++++++++++
 3 files changed, 42 insertions(+)
 create mode 100644 arch/arm/mach-versatile/kgdb_fiq.c

diff --git a/arch/arm/mach-versatile/Makefile b/arch/arm/mach-versatile/Makefile
index 81fa3fe..bfd761f 100644
--- a/arch/arm/mach-versatile/Makefile
+++ b/arch/arm/mach-versatile/Makefile
@@ -7,3 +7,4 @@ obj-$(CONFIG_ARCH_VERSATILE_PB)		+= versatile_pb.o
 obj-$(CONFIG_MACH_VERSATILE_AB)		+= versatile_ab.o
 obj-$(CONFIG_MACH_VERSATILE_DT)		+= versatile_dt.o
 obj-$(CONFIG_PCI)			+= pci.o
+obj-$(CONFIG_KGDB_FIQ)			+= kgdb_fiq.o
diff --git a/arch/arm/mach-versatile/include/mach/irqs.h b/arch/arm/mach-versatile/include/mach/irqs.h
index bf44c61..fcd2a95 100644
--- a/arch/arm/mach-versatile/include/mach/irqs.h
+++ b/arch/arm/mach-versatile/include/mach/irqs.h
@@ -26,6 +26,7 @@
  *  held within platform.h
  */
 #define IRQ_VIC_START		0
+#define FIQ_START		IRQ_VIC_START
 #define IRQ_WDOGINT		(IRQ_VIC_START + INT_WDOGINT)
 #define IRQ_SOFTINT		(IRQ_VIC_START + INT_SOFTINT)
 #define IRQ_COMMRx		(IRQ_VIC_START + INT_COMMRx)
diff --git a/arch/arm/mach-versatile/kgdb_fiq.c b/arch/arm/mach-versatile/kgdb_fiq.c
new file mode 100644
index 0000000..c82e8ce
--- /dev/null
+++ b/arch/arm/mach-versatile/kgdb_fiq.c
@@ -0,0 +1,40 @@
+/*
+ * KGDB FIQ entry board/IC support
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
+#include <linux/types.h>
+#include <linux/kgdb.h>
+#include <mach/hardware.h>
+#include <mach/platform.h>
+#include <asm/kgdb.h>
+#include <asm/hardware/vic.h>
+
+static int kgdb_fiq;
+module_param_named(uart_num, kgdb_fiq, int, 0600);
+MODULE_PARM_DESC(uart_num, "UART<number> port to use for KGDB FIQ");
+
+static bool is_kgdb_nmi(void)
+{
+	return vic_is_fiq_rised(kgdb_fiq);
+}
+
+void kgdb_arch_enable_nmi(bool on)
+{
+	vic_fiq_select(kgdb_fiq, on);
+}
+
+static int kgdb_fiq_init(void)
+{
+	kgdb_fiq += INT_UARTINT0;
+	kgdb_register_nmi(is_kgdb_nmi);
+	return 0;
+}
+console_initcall(kgdb_fiq_init);
-- 
1.7.10.4

