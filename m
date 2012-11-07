Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754365Ab2KGJul (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 04:50:41 -0500
Received: from us01smtp2.synopsys.com ([198.182.44.80]:58063 "EHLO
	kiruna.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754151Ab2KGJsz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 04:48:55 -0500
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, arnd@arndb.de,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: [RFC PATCH v1 25/31] ARC: [plat-arcfpga] Hooking up platform to ARC UART
Date: Wed,  7 Nov 2012 10:47:48 +0100
Message-Id: <1352281674-2186-26-git-send-email-vgupta@synopsys.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1352281674-2186-1-git-send-email-vgupta@synopsys.com>
References: <1352281674-2186-1-git-send-email-vgupta@synopsys.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
---
 arch/arc/include/asm/irq.h                  |    1 +
 arch/arc/plat-arcfpga/include/plat/irq.h    |   27 +++++++
 arch/arc/plat-arcfpga/include/plat/memmap.h |   31 ++++++++
 arch/arc/plat-arcfpga/platform.c            |  105 +++++++++++++++++++++++++++
 4 files changed, 164 insertions(+), 0 deletions(-)
 create mode 100644 arch/arc/plat-arcfpga/include/plat/irq.h
 create mode 100644 arch/arc/plat-arcfpga/include/plat/memmap.h

diff --git a/arch/arc/include/asm/irq.h b/arch/arc/include/asm/irq.h
index 633416c..8e771f6 100644
--- a/arch/arc/include/asm/irq.h
+++ b/arch/arc/include/asm/irq.h
@@ -13,6 +13,7 @@
 #define TIMER0_IRQ      3
 #define TIMER1_IRQ      4
 
+#include <plat/irq.h>		/* Board Specific IRQ assignments */
 #include <asm-generic/irq.h>
 
 extern void __init arc_init_IRQ(void);
diff --git a/arch/arc/plat-arcfpga/include/plat/irq.h b/arch/arc/plat-arcfpga/include/plat/irq.h
new file mode 100644
index 0000000..b34e087
--- /dev/null
+++ b/arch/arc/plat-arcfpga/include/plat/irq.h
@@ -0,0 +1,27 @@
+/*
+ * Copyright (C) 2004, 2007-2010, 2011-2012 Synopsys, Inc. (www.synopsys.com)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * vineetg: Feb 2009
+ *  -For AA4 board, IRQ assignments to peripherals
+ */
+
+#ifndef __PLAT_IRQ_H
+#define __PLAT_IRQ_H
+
+#define NR_IRQS		16
+
+#define UART0_IRQ	5
+#define UART1_IRQ	10
+#define UART2_IRQ	11
+
+#define VMAC_IRQ	6
+
+#define IDE_IRQ		13
+#define PCI_IRQ		14
+#define PS2_IRQ		15
+
+#endif
diff --git a/arch/arc/plat-arcfpga/include/plat/memmap.h b/arch/arc/plat-arcfpga/include/plat/memmap.h
new file mode 100644
index 0000000..1663f33
--- /dev/null
+++ b/arch/arc/plat-arcfpga/include/plat/memmap.h
@@ -0,0 +1,31 @@
+/*
+ * Copyright (C) 2004, 2007-2010, 2011-2012 Synopsys, Inc. (www.synopsys.com)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * vineetg: Feb 2009
+ *  -For AA4 board, System Memory Map for Peripherals etc
+ */
+
+#ifndef __PLAT_MEMMAP_H
+#define __PLAT_MEMMAP_H
+
+#define UART0_BASE              0xC0FC1000
+#define UART1_BASE              0xC0FC1100
+
+#define VMAC_REG_BASEADDR       0xC0FC2000
+
+#define IDE_CONTROLLER_BASE     0xC0FC9000
+
+#define AHB_PCI_HOST_BRG_BASE   0xC0FD0000
+
+#define PGU_BASEADDR            0xC0FC8000
+#define VLCK_ADDR               0xC0FCF028
+
+#define BVCI_LAT_UNIT_BASE      0xC0FED000
+
+#define PS2_BASE_ADDR		0xC0FCC000
+
+#endif
diff --git a/arch/arc/plat-arcfpga/platform.c b/arch/arc/plat-arcfpga/platform.c
index 7b5dcab..3243091 100644
--- a/arch/arc/plat-arcfpga/platform.c
+++ b/arch/arc/plat-arcfpga/platform.c
@@ -10,7 +10,99 @@
 
 #include <linux/types.h>
 #include <linux/init.h>
+#include <linux/device.h>
 #include <linux/platform_device.h>
+#include <linux/console.h>
+#include <asm/setup.h>
+#include <asm/irq.h>
+#include <plat/memmap.h>
+
+/*----------------------- Platform Devices -----------------------------*/
+
+#if defined(CONFIG_SERIAL_ARC) || defined(CONFIG_SERIAL_ARC_MODULE)
+
+static unsigned long arc_uart_info[] = {
+	CONFIG_ARC_SERIAL_BAUD,	/* uart->baud */
+	CONFIG_ARC_PLAT_CLK,	/* uart->port.uartclk */
+	-1,			/* uart->is_emulated (runtime @running_on_hw) */
+	0
+};
+
+#define ARC_UART_DEV(n)					\
+							\
+static struct resource arc_uart##n##_res[] = {		\
+	{						\
+		.start = UART##n##_BASE,			\
+		.end   = UART##n##_BASE + 0xFF,		\
+		.flags = IORESOURCE_MEM,		\
+	},						\
+	{						\
+		.start = UART##n##_IRQ,			\
+		.end   = UART##n##_IRQ,			\
+		.flags = IORESOURCE_IRQ,		\
+	},						\
+};							\
+							\
+static struct platform_device arc_uart##n##_dev = {	\
+	.name = "arc-uart",				\
+	.id = n,					\
+	.num_resources = ARRAY_SIZE(arc_uart##n##_res),	\
+	.resource = arc_uart##n##_res,			\
+	.dev = {					\
+		.platform_data = &arc_uart_info,	\
+	},						\
+}
+
+ARC_UART_DEV(0);
+#if CONFIG_SERIAL_ARC_NR_PORTS > 1
+ARC_UART_DEV(1);
+#endif
+
+static struct platform_device *fpga_early_devs[] __initdata = {
+#if defined(CONFIG_SERIAL_ARC_CONSOLE)
+	&arc_uart0_dev,
+#endif
+};
+
+static void arc_fpga_serial_init(void)
+{
+	/* To let driver workaround ISS bug: baudh Reg can't be set to 0 */
+	arc_uart_info[2] = !running_on_hw;
+
+	early_platform_add_devices(fpga_early_devs,
+				   ARRAY_SIZE(fpga_early_devs));
+
+	/*
+	 * ARC console driver registers itself as an early platform driver
+	 * of class "earlyprintk".
+	 * Install it here, followed by probe of devices.
+	 * The installation here doesn't require earlyprintk in command line
+	 * To do so however, replace the lines below with
+	 *	parse_early_param();
+	 *	early_platform_driver_probe("earlyprintk", 1, 1);
+	 *						      ^^
+	 */
+	early_platform_driver_register_all("earlyprintk");
+	early_platform_driver_probe("earlyprintk", 1, 0);
+
+	/*
+	 * This is to make sure that arc uart would be preferred console
+	 * despite one/more of following:
+	 *   -command line lacked "console=ttyARC0" or
+	 *   -CONFIG_VT_CONSOLE was enabled (for no reason whatsoever)
+	 * Note that this needs to be done after above early console is reg,
+	 * otherwise the early console never gets a chance to run.
+	 */
+	add_preferred_console("ttyARC", 0, "115200");
+}
+
+#else
+
+static void arc_fpga_serial_init(void)
+{
+}
+
+#endif	/* CONFIG_SERIAL_ARC */
 
 /*
  * Early Platform Initialization called from setup_arch()
@@ -18,12 +110,25 @@
 void __init arc_platform_early_init(void)
 {
 	pr_info("[plat-arcfpga]: registering early dev resources\n");
+
+	arc_fpga_serial_init();
 }
 
+static struct platform_device *fpga_devs[] __initdata = {
+#if defined(CONFIG_SERIAL_ARC) || defined(CONFIG_SERIAL_ARC_MODULE)
+	&arc_uart0_dev,
+#if CONFIG_SERIAL_ARC_NR_PORTS > 1
+	&arc_uart1_dev,
+#endif
+#endif
+};
+
 int __init fpga_plat_init(void)
 {
 	pr_info("[plat-arcfpga]: registering device resources\n");
 
+	platform_add_devices(fpga_devs, ARRAY_SIZE(fpga_devs));
+
 	return 0;
 }
 arch_initcall(fpga_plat_init);
-- 
1.7.4.1

