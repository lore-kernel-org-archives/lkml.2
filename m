Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752809Ab1BPQMP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 11:12:15 -0500
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:21599
	"EHLO VA3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751699Ab1BPQML (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 11:12:11 -0500
X-SpamScore: 3
X-BigFish: VPS3(zzc8kzz1202hzz8275bhz2dh95h668h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
From: John Linn <john.linn@xilinx.com>
To: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux@arm.linux.org.uk>, <catalin.marinas@arm.com>,
        <glikely@secretlab.ca>, <arnd@arndb.de>
CC: John Linn <john.linn@xilinx.com>
Subject: [PATCH V3 1/4] ARM: Xilinx: Adding Xilinx board support
Date: Wed, 16 Feb 2011 09:11:53 -0700
X-Mailer: git-send-email 1.5.6.6
In-Reply-To: <1297872716-13353-1-git-send-email-john.linn@xilinx.com>
References: <1297872716-13353-1-git-send-email-john.linn@xilinx.com>
X-RCIS-Action: ALLOW
MIME-Version: 1.0
Content-Type: text/plain
Message-ID: <ad969bd6-87bb-4910-a04a-d680e90d69af@VA3EHSMHS009.ehs.local>
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 1st board support is minimal to get a system up and running
on the Xilinx platform.

Signed-off-by: John Linn <john.linn@xilinx.com>
---

V3 Changes

Updates based on Russell Kings' comments
	Changed headers to update the license info and remove
	the address

	Changed the name of functions to include "xilinx" in 
	common.c and common.h

Changed the Kconfig and Makefile to use MACH_XILINX which
matches the machine registered.

V2 Changes

Updates based on Russell King's comments	
	minor cleanups
	cleaned up physical/virtual addresses in early i/o table		

Updated based on Jamie Iles's comment
	added clk_get_rate() function
	now using platform_add_devices() from platform code

 arch/arm/mach-xilinx/Kconfig       |   14 +++++
 arch/arm/mach-xilinx/Makefile      |    7 ++
 arch/arm/mach-xilinx/Makefile.boot |    3 +
 arch/arm/mach-xilinx/board_ep107.c |   82 ++++++++++++++++++++++++++
 arch/arm/mach-xilinx/common.c      |  113 ++++++++++++++++++++++++++++++++++++
 arch/arm/mach-xilinx/common.h      |   30 ++++++++++
 6 files changed, 249 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/mach-xilinx/Kconfig
 create mode 100644 arch/arm/mach-xilinx/Makefile
 create mode 100644 arch/arm/mach-xilinx/Makefile.boot
 create mode 100644 arch/arm/mach-xilinx/board_ep107.c
 create mode 100644 arch/arm/mach-xilinx/common.c
 create mode 100644 arch/arm/mach-xilinx/common.h

diff --git a/arch/arm/mach-xilinx/Kconfig b/arch/arm/mach-xilinx/Kconfig
new file mode 100644
index 0000000..61532af
--- /dev/null
+++ b/arch/arm/mach-xilinx/Kconfig
@@ -0,0 +1,14 @@
+if ARCH_XILINX
+
+choice
+        prompt "Board Selection"
+	default MACH_XILINX
+
+config MACH_XILINX
+	bool "Xilinx EP107 Board"
+	help
+	  Select if you are using a Xilinx EP107 board.
+
+endchoice
+
+endif
diff --git a/arch/arm/mach-xilinx/Makefile b/arch/arm/mach-xilinx/Makefile
new file mode 100644
index 0000000..76e9e55
--- /dev/null
+++ b/arch/arm/mach-xilinx/Makefile
@@ -0,0 +1,7 @@
+#
+# Makefile for the linux kernel.
+#
+
+# Common support
+obj-y 				:= common.o
+obj-$(CONFIG_MACH_XILINX)	+= board_ep107.o
diff --git a/arch/arm/mach-xilinx/Makefile.boot b/arch/arm/mach-xilinx/Makefile.boot
new file mode 100644
index 0000000..67039c3
--- /dev/null
+++ b/arch/arm/mach-xilinx/Makefile.boot
@@ -0,0 +1,3 @@
+   zreladdr-y	:= 0x00008000
+params_phys-y	:= 0x00000100
+initrd_phys-y	:= 0x00800000
diff --git a/arch/arm/mach-xilinx/board_ep107.c b/arch/arm/mach-xilinx/board_ep107.c
new file mode 100644
index 0000000..a1635b5
--- /dev/null
+++ b/arch/arm/mach-xilinx/board_ep107.c
@@ -0,0 +1,82 @@
+/* arch/arm/mach-xilinx/board_ep107.c
+ *
+ * This file contains code specific to the Xilinx EP107 board.
+ *
+ *  Copyright (C) 2011 Xilinx
+ *
+ * based on /arch/arm/mach-realview/core.c
+ *
+ *  Copyright (C) 1999 - 2003 ARM Limited
+ *  Copyright (C) 2000 Deep Blue Solutions Ltd
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/platform_device.h>
+#include <asm/mach-types.h>
+#include <asm/mach/arch.h>
+#include <mach/xilinx_soc.h>
+#include <mach/irqs.h>
+#include <linux/clkdev.h>
+#include "common.h"
+
+/*
+ * Fixed clocks for now
+ */
+
+static struct clk ref50_clk = {
+	.rate	= 50000000,
+};
+
+/* Create all the platform devices for the board */
+
+static struct resource uart0[] = {
+	{
+		.start = UART0_PHYS,
+		.end = UART0_PHYS + 0xFFF,
+		.flags = IORESOURCE_MEM,
+	}, {
+		.start = IRQ_UART0,
+		.end = IRQ_UART0,
+		.flags = IORESOURCE_IRQ,
+	},
+};
+
+static struct platform_device uart_device0 = {
+	.name = "xuartpss",
+	.id = 0,
+	.dev = {
+		.platform_data = &ref50_clk.rate,
+	},
+	.resource = uart0,
+	.num_resources = ARRAY_SIZE(uart0),
+};
+
+static struct platform_device *xilinx_pdevices[] __initdata = {
+	&uart_device0,
+};
+
+/**
+ * board_ep107_init - Board specific initialization for the Xilinx EP107 board.
+ *
+ **/
+static void __init board_ep107_init(void)
+{
+	xilinx_system_init();
+	platform_add_devices(&xilinx_pdevices[0], ARRAY_SIZE(xilinx_pdevices));
+}
+
+MACHINE_START(XILINX_EP107, "Xilinx EP107")
+	.boot_params    = PHYS_OFFSET + 0x00000100,
+	.map_io         = xilinx_map_io,
+	.init_irq       = xilinx_irq_init,
+	.init_machine   = board_ep107_init,
+	.timer          = &xttcpss_sys_timer,
+MACHINE_END
diff --git a/arch/arm/mach-xilinx/common.c b/arch/arm/mach-xilinx/common.c
new file mode 100644
index 0000000..564b707
--- /dev/null
+++ b/arch/arm/mach-xilinx/common.c
@@ -0,0 +1,113 @@
+/* arch/arm/mach-xilinx/common.c
+ *
+ * This file contains common code that is intended to be used across
+ * boards so that it's not replicated.
+ *
+ *  Copyright (C) 2011 Xilinx
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/cpumask.h>
+#include <linux/platform_device.h>
+#include <linux/clk.h>
+
+#include <asm/mach/map.h>
+#include <asm/page.h>
+#include <asm/hardware/gic.h>
+#include <asm/hardware/cache-l2x0.h>
+
+#include <mach/xilinx_soc.h>
+#include <mach/clkdev.h>
+
+/*
+ * Clock function infrastructure.
+ */
+int clk_enable(struct clk *clk)
+{
+	return 0;
+}
+
+void clk_disable(struct clk *clk)
+{
+}
+
+unsigned long clk_get_rate(struct clk *clk)
+{
+	return clk->rate;
+}
+
+/**
+ * system_init - System specific initialization, intended to be called from
+ *			board specific initialization.
+ *
+ **/
+void __init xilinx_system_init(void)
+{
+#ifdef CONFIG_CACHE_L2X0
+	/*
+	 * 64KB way size, 8-way associativity, parity disabled
+	 */
+	l2x0_init(PL310_L2CC_BASE, 0x02060000, 0xF0F0FFFF);
+#endif
+}
+
+/**
+ * irq_init - Interrupt controller initialization for the GIC.
+ *
+ **/
+void __init xilinx_irq_init(void)
+{
+	gic_init(0, 29, SCU_GIC_DIST_BASE, SCU_GIC_CPU_BASE);
+}
+
+/* The minimum devices needed to be mapped before the VM system is up and
+ * running include the GIC, UART and Timer Counter.
+ */
+
+static struct map_desc io_desc[] __initdata = {
+	{
+		.virtual	= TTC0_VIRT,
+		.pfn		= __phys_to_pfn(TTC0_PHYS),
+		.length		= SZ_4K,
+		.type		= MT_DEVICE,
+	}, {
+		.virtual	= SCU_PERIPH_VIRT,
+		.pfn		= __phys_to_pfn(SCU_PERIPH_PHYS),
+		.length		= SZ_8K,
+		.type		= MT_DEVICE,
+	}, {
+		.virtual	= PL310_L2CC_VIRT,
+		.pfn		= __phys_to_pfn(PL310_L2CC_PHYS),
+		.length		= SZ_4K,
+		.type		= MT_DEVICE,
+	},
+
+#ifdef CONFIG_DEBUG_LL
+	{
+		.virtual	= UART0_VIRT,
+		.pfn		= __phys_to_pfn(UART0_PHYS),
+		.length		= SZ_4K,
+		.type		= MT_DEVICE,
+	},
+#endif
+
+};
+
+/**
+ * map_io - Create memory mappings needed for early I/O.
+ *
+ **/
+void __init xilinx_map_io(void)
+{
+	iotable_init(io_desc, ARRAY_SIZE(io_desc));
+}
diff --git a/arch/arm/mach-xilinx/common.h b/arch/arm/mach-xilinx/common.h
new file mode 100644
index 0000000..9a7cf65
--- /dev/null
+++ b/arch/arm/mach-xilinx/common.h
@@ -0,0 +1,30 @@
+/* arch/arm/mach-xilinx/common.h
+ *
+ * This file contains common function prototypes to avoid externs
+ * in the c files.
+ *
+ *  Copyright (C) 2011 Xilinx
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef __MACH_XILINX_COMMON_H__
+#define __MACH_XILINX_COMMON_H__
+
+#include <linux/init.h>
+#include <linux/platform_device.h>
+
+void __init xilinx_system_init(void);
+void __init xilinx_irq_init(void);
+void __init xilinx_map_io(void);
+
+extern struct sys_timer xttcpss_sys_timer;
+
+#endif
-- 
1.6.2.1



This email and any attachments are intended for the sole use of the named recipient(s) and contain(s) confidential information that may be proprietary, privileged or copyrighted under applicable law. If you are not the intended recipient, do not read, copy, or forward this email message or any attachments. Delete this email message and any attachments immediately.


