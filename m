Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754645Ab2KSSk0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 13:40:26 -0500
Received: from mailserver5.natinst.com ([130.164.80.5]:50242 "EHLO
	spamkiller05.natinst.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754629Ab2KSSkW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 13:40:22 -0500
Message-Id: <8aa73cfc61db3e516713e31a79ed38b03cf77e96.1353349191.git.josh.cartwright@ni.com>
In-Reply-To: <cover.1353349191.git.josh.cartwright@ni.com>
References: <cover.1353349191.git.josh.cartwright@ni.com>
From: Josh Cartwright <josh.cartwright@ni.com>
Date: Mon, 19 Nov 2012 10:16:01 -0600
Subject: [PATCH 2/3] ARM: zynq: make use of debug_ll_io_init()
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
To: Michal Simek <michal.simek@xilinx.com>, arm@kernel.org
X-MIMETrack: Itemize by SMTP Server on MailServ59-US/AUS/H/NIC(Release 8.5.3FP2 HF169|September
 14, 2012) at 11/19/2012 12:40:08 PM,
	Serialize by Router on MailServ59-US/AUS/H/NIC(Release 8.5.3FP2 HF169|September
 14, 2012) at 11/19/2012 12:40:08 PM,
	Serialize complete at 11/19/2012 12:40:08 PM
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.9.8185,1.0.431,0.0.0000
 definitions=2012-11-19_07:2012-11-19,2012-11-19,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert low-level debugging routines to make use of debug_ll_io_init().
This is part of the preparation for ARCH_MULTIPLATFORM support for Zynq.

Signed-off-by: Josh Cartwright <josh.cartwright@ni.com>
---
 arch/arm/Kconfig.debug                             |  1 +
 .../mach/debug-macro.S => include/debug/zynq.S}    |  3 +--
 arch/arm/mach-zynq/common.c                        | 25 ++++++----------------
 3 files changed, 9 insertions(+), 20 deletions(-)
 rename arch/arm/{mach-zynq/include/mach/debug-macro.S => include/debug/zynq.S} (94%)

diff --git a/arch/arm/Kconfig.debug b/arch/arm/Kconfig.debug
index 7754d51..d6bdad2 100644
--- a/arch/arm/Kconfig.debug
+++ b/arch/arm/Kconfig.debug
@@ -435,6 +435,7 @@ config DEBUG_LL_INCLUDE
 	default "debug/socfpga.S" if DEBUG_SOCFPGA_UART
 	default "debug/vexpress.S" if DEBUG_VEXPRESS_UART0_DETECT || \
 		DEBUG_VEXPRESS_UART0_CA9 || DEBUG_VEXPRESS_UART0_RS1
+	default "debug/zynq.S" if DEBUG_ZYNQ_UART0 || DEBUG_ZYNQ_UART1
 	default "mach/debug-macro.S"
 
 config EARLY_PRINTK
diff --git a/arch/arm/mach-zynq/include/mach/debug-macro.S b/arch/arm/include/debug/zynq.S
similarity index 94%
rename from arch/arm/mach-zynq/include/mach/debug-macro.S
rename to arch/arm/include/debug/zynq.S
index 3ab0be1..08aed97 100644
--- a/arch/arm/mach-zynq/include/mach/debug-macro.S
+++ b/arch/arm/include/debug/zynq.S
@@ -1,5 +1,4 @@
-/* arch/arm/mach-zynq/include/mach/debug-macro.S
- *
+/*
  * Debugging macro include header
  *
  *  Copyright (C) 2011 Xilinx
diff --git a/arch/arm/mach-zynq/common.c b/arch/arm/mach-zynq/common.c
index 2202f67..a2f48da 100644
--- a/arch/arm/mach-zynq/common.c
+++ b/arch/arm/mach-zynq/common.c
@@ -72,23 +72,11 @@ static void __init xilinx_irq_init(void)
  * running include the GIC, UART and Timer Counter.
  */
 
-static struct map_desc io_desc[] __initdata = {
-	{
-		.virtual	= SCU_PERIPH_VIRT,
-		.pfn		= __phys_to_pfn(SCU_PERIPH_PHYS),
-		.length		= SCU_PERIPH_SIZE,
-		.type		= MT_DEVICE,
-	},
-
-#ifdef CONFIG_DEBUG_LL
-	{
-		.virtual	= LL_UART_VADDR,
-		.pfn		= __phys_to_pfn(LL_UART_PADDR),
-		.length		= UART_SIZE,
-		.type		= MT_DEVICE,
-	},
-#endif
-
+static struct map_desc scu_desc __initdata = {
+	.virtual	= SCU_PERIPH_VIRT,
+	.pfn		= __phys_to_pfn(SCU_PERIPH_PHYS),
+	.length		= SCU_PERIPH_SIZE,
+	.type		= MT_DEVICE,
 };
 
 static void __init xilinx_zynq_timer_init(void)
@@ -117,7 +105,8 @@ static struct sys_timer xttcpss_sys_timer = {
  */
 static void __init xilinx_map_io(void)
 {
-	iotable_init(io_desc, ARRAY_SIZE(io_desc));
+	debug_ll_io_init();
+	iotable_init(&scu_desc, 1);
 }
 
 static const char *xilinx_dt_match[] = {
-- 
1.8.0


