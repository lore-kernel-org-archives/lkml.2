Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754659Ab2KSSkm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 13:40:42 -0500
Received: from mailserver6.natinst.com ([130.164.80.6]:48649 "EHLO
	spamkiller06.natinst.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754630Ab2KSSkY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 13:40:24 -0500
Message-Id: <9bdc33093c6a5c22b180ef45b486edb575f87da3.1353349191.git.josh.cartwright@ni.com>
In-Reply-To: <cover.1353349191.git.josh.cartwright@ni.com>
References: <cover.1353349191.git.josh.cartwright@ni.com>
From: Josh Cartwright <josh.cartwright@ni.com>
Date: Mon, 19 Nov 2012 11:38:29 -0600
Subject: [PATCH 3/3] ARM: zynq: add support for ARCH_MULTIPLATFORM
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
To: Michal Simek <michal.simek@xilinx.com>, arm@kernel.org
X-MIMETrack: Itemize by SMTP Server on MailServ58-US/AUS/H/NIC(Release 8.5.3FP2 HF169|September
 14, 2012) at 11/19/2012 12:40:08 PM,
	Serialize by Router on MailServ58-US/AUS/H/NIC(Release 8.5.3FP2 HF169|September
 14, 2012) at 11/19/2012 12:40:08 PM,
	Serialize complete at 11/19/2012 12:40:08 PM
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.9.8185,1.0.431,0.0.0000
 definitions=2012-11-19_07:2012-11-19,2012-11-19,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The majority of changes are necessary to remove dependencies on header
files within arch/arm/mach-zynq/include/mach:

  uncompress.h
    - Deleted. It is unused for ARCH_MULTIPLATFORM builds.

  uart.h:
    - Move uart definitions out of uart.h into debug/zynq.S, which is
      now the only user

  zynq_soc.h:
    - Move SCU address definitions into common.c.
    - Other #defines, such as PERIPHERAL_CLOCK_RATE, TTC0_BASE, etc, are
      unused and can be dropped

Signed-off-by: Josh Cartwright <josh.cartwright@ni.com>
---
 arch/arm/Kconfig                             | 14 ++------
 arch/arm/include/debug/zynq.S                | 20 +++++++++--
 arch/arm/mach-zynq/Kconfig                   | 13 +++++++
 arch/arm/mach-zynq/common.c                  |  8 ++---
 arch/arm/mach-zynq/include/mach/uart.h       | 25 --------------
 arch/arm/mach-zynq/include/mach/uncompress.h | 51 ----------------------------
 arch/arm/mach-zynq/include/mach/zynq_soc.h   | 49 --------------------------
 7 files changed, 37 insertions(+), 143 deletions(-)
 create mode 100644 arch/arm/mach-zynq/Kconfig
 delete mode 100644 arch/arm/mach-zynq/include/mach/uart.h
 delete mode 100644 arch/arm/mach-zynq/include/mach/uncompress.h
 delete mode 100644 arch/arm/mach-zynq/include/mach/zynq_soc.h

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index ccfe0ab..28a2048 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -955,18 +955,6 @@ config ARCH_VT8500
 	help
 	  Support for VIA/WonderMedia VT8500/WM85xx System-on-Chip.
 
-config ARCH_ZYNQ
-	bool "Xilinx Zynq ARM Cortex A9 Platform"
-	select ARM_AMBA
-	select ARM_GIC
-	select COMMON_CLK
-	select CPU_V7
-	select GENERIC_CLOCKEVENTS
-	select ICST
-	select MIGHT_HAVE_CACHE_L2X0
-	select USE_OF
-	help
-	  Support for Xilinx Zynq ARM Cortex A9 Platform
 endchoice
 
 menu "Multiple platform selection"
@@ -1128,6 +1116,8 @@ source "arch/arm/plat-versatile/Kconfig"
 
 source "arch/arm/mach-w90x900/Kconfig"
 
+source "arch/arm/mach-zynq/Kconfig"
+
 # Definitions to make life easier
 config ARCH_ACORN
 	bool
diff --git a/arch/arm/include/debug/zynq.S b/arch/arm/include/debug/zynq.S
index 08aed97..f9aa974 100644
--- a/arch/arm/include/debug/zynq.S
+++ b/arch/arm/include/debug/zynq.S
@@ -12,9 +12,25 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  */
+#define UART_CR_OFFSET		0x00  /* Control Register [8:0] */
+#define UART_SR_OFFSET		0x2C  /* Channel Status [11:0] */
+#define UART_FIFO_OFFSET	0x30  /* FIFO [15:0] or [7:0] */
 
-#include <mach/zynq_soc.h>
-#include <mach/uart.h>
+#define UART_SR_TXFULL		0x00000010	/* TX FIFO full */
+#define UART_SR_TXEMPTY		0x00000008	/* TX FIFO empty */
+
+#define UART0_PHYS		0xE0000000
+#define UART1_PHYS		0xE0001000
+#define UART_SIZE		SZ_4K
+#define UART_VIRT		0xF0001000
+
+#if IS_ENABLED(CONFIG_DEBUG_ZYNQ_UART1)
+# define LL_UART_PADDR		UART1_PHYS
+#else
+# define LL_UART_PADDR		UART0_PHYS
+#endif
+
+#define LL_UART_VADDR		UART_VIRT
 
 		.macro	addruart, rp, rv, tmp
 		ldr	\rp, =LL_UART_PADDR	@ physical
diff --git a/arch/arm/mach-zynq/Kconfig b/arch/arm/mach-zynq/Kconfig
new file mode 100644
index 0000000..adb6c0e
--- /dev/null
+++ b/arch/arm/mach-zynq/Kconfig
@@ -0,0 +1,13 @@
+config ARCH_ZYNQ
+	bool "Xilinx Zynq ARM Cortex A9 Platform" if ARCH_MULTI_V7
+	select ARM_AMBA
+	select ARM_GIC
+	select COMMON_CLK
+	select CPU_V7
+	select GENERIC_CLOCKEVENTS
+	select ICST
+	select MIGHT_HAVE_CACHE_L2X0
+	select USE_OF
+	select SPARSE_IRQ
+	help
+	  Support for Xilinx Zynq ARM Cortex A9 Platform
diff --git a/arch/arm/mach-zynq/common.c b/arch/arm/mach-zynq/common.c
index a2f48da..e16d4be 100644
--- a/arch/arm/mach-zynq/common.c
+++ b/arch/arm/mach-zynq/common.c
@@ -30,10 +30,10 @@
 #include <asm/mach/time.h>
 #include <asm/mach-types.h>
 #include <asm/page.h>
+#include <asm/pgtable.h>
 #include <asm/hardware/gic.h>
 #include <asm/hardware/cache-l2x0.h>
 
-#include <mach/zynq_soc.h>
 #include "common.h"
 
 static struct of_device_id zynq_of_bus_ids[] __initdata = {
@@ -68,9 +68,9 @@ static void __init xilinx_irq_init(void)
 	of_irq_init(irq_match);
 }
 
-/* The minimum devices needed to be mapped before the VM system is up and
- * running include the GIC, UART and Timer Counter.
- */
+#define SCU_PERIPH_PHYS		0xF8F00000
+#define SCU_PERIPH_SIZE		SZ_8K
+#define SCU_PERIPH_VIRT		(VMALLOC_END - SCU_PERIPH_SIZE)
 
 static struct map_desc scu_desc __initdata = {
 	.virtual	= SCU_PERIPH_VIRT,
diff --git a/arch/arm/mach-zynq/include/mach/uart.h b/arch/arm/mach-zynq/include/mach/uart.h
deleted file mode 100644
index 5c47c97..0000000
--- a/arch/arm/mach-zynq/include/mach/uart.h
+++ /dev/null
@@ -1,25 +0,0 @@
-/* arch/arm/mach-zynq/include/mach/uart.h
- *
- *  Copyright (C) 2011 Xilinx
- *
- * This software is licensed under the terms of the GNU General Public
- * License version 2, as published by the Free Software Foundation, and
- * may be copied, distributed, and modified under those terms.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- */
-
-#ifndef __MACH_UART_H__
-#define __MACH_UART_H__
-
-#define UART_CR_OFFSET		0x00  /* Control Register [8:0] */
-#define UART_SR_OFFSET		0x2C  /* Channel Status [11:0] */
-#define UART_FIFO_OFFSET	0x30  /* FIFO [15:0] or [7:0] */
-
-#define UART_SR_TXFULL		0x00000010	/* TX FIFO full */
-#define UART_SR_TXEMPTY		0x00000008	/* TX FIFO empty */
-
-#endif
diff --git a/arch/arm/mach-zynq/include/mach/uncompress.h b/arch/arm/mach-zynq/include/mach/uncompress.h
deleted file mode 100644
index af4e844..0000000
--- a/arch/arm/mach-zynq/include/mach/uncompress.h
+++ /dev/null
@@ -1,51 +0,0 @@
-/* arch/arm/mach-zynq/include/mach/uncompress.h
- *
- *  Copyright (C) 2011 Xilinx
- *
- * This software is licensed under the terms of the GNU General Public
- * License version 2, as published by the Free Software Foundation, and
- * may be copied, distributed, and modified under those terms.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- */
-
-#ifndef __MACH_UNCOMPRESS_H__
-#define __MACH_UNCOMPRESS_H__
-
-#include <linux/io.h>
-#include <asm/processor.h>
-#include <mach/zynq_soc.h>
-#include <mach/uart.h>
-
-void arch_decomp_setup(void)
-{
-}
-
-static inline void flush(void)
-{
-	/*
-	 * Wait while the FIFO is not empty
-	 */
-	while (!(__raw_readl(IOMEM(LL_UART_PADDR + UART_SR_OFFSET)) &
-		UART_SR_TXEMPTY))
-		cpu_relax();
-}
-
-#define arch_decomp_wdog()
-
-static void putc(char ch)
-{
-	/*
-	 * Wait for room in the FIFO, then write the char into the FIFO
-	 */
-	while (__raw_readl(IOMEM(LL_UART_PADDR + UART_SR_OFFSET)) &
-		UART_SR_TXFULL)
-		cpu_relax();
-
-	__raw_writel(ch, IOMEM(LL_UART_PADDR + UART_FIFO_OFFSET));
-}
-
-#endif
diff --git a/arch/arm/mach-zynq/include/mach/zynq_soc.h b/arch/arm/mach-zynq/include/mach/zynq_soc.h
deleted file mode 100644
index 2995044..0000000
--- a/arch/arm/mach-zynq/include/mach/zynq_soc.h
+++ /dev/null
@@ -1,49 +0,0 @@
-/* arch/arm/mach-zynq/include/mach/zynq_soc.h
- *
- *  Copyright (C) 2011 Xilinx
- *
- * This software is licensed under the terms of the GNU General Public
- * License version 2, as published by the Free Software Foundation, and
- * may be copied, distributed, and modified under those terms.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- */
-
-#ifndef __MACH_XILINX_SOC_H__
-#define __MACH_XILINX_SOC_H__
-
-#include <asm/pgtable.h>
-
-#define PERIPHERAL_CLOCK_RATE		2500000
-
-/* Static peripheral mappings are mapped at the top of the vmalloc region.  The
- * early uart mapping causes intermediate problems/failure at certain
- * addresses, including the very top of the vmalloc region.  Map it at an
- * address that is known to work.
- */
-#define UART0_PHYS		0xE0000000
-#define UART1_PHYS		0xE0001000
-#define UART_SIZE		SZ_4K
-#define UART_VIRT		0xF0001000
-
-#define SCU_PERIPH_PHYS		0xF8F00000
-#define SCU_PERIPH_SIZE		SZ_8K
-#define SCU_PERIPH_VIRT		(VMALLOC_END - SCU_PERIPH_SIZE)
-
-#if IS_ENABLED(CONFIG_DEBUG_ZYNQ_UART1)
-# define LL_UART_PADDR		UART1_PHYS
-#else
-# define LL_UART_PADDR		UART0_PHYS
-#endif
-
-#define LL_UART_VADDR		UART_VIRT
-
-/* The following are intended for the devices that are mapped early */
-
-#define TTC0_BASE			IOMEM(TTC0_VIRT)
-#define SCU_PERIPH_BASE			IOMEM(SCU_PERIPH_VIRT)
-
-#endif
-- 
1.8.0

