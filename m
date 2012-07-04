Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753655Ab2GDOXu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 10:23:50 -0400
Received: from mx.scalarmail.ca ([98.158.95.75]:57954 "EHLO
	ironport-01.sms.scalar.ca" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753312Ab2GDOXT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 10:23:19 -0400
X-Greylist: delayed 572 seconds by postgrey-1.27 at vger.kernel.org; Wed, 04 Jul 2012 10:23:18 EDT
From: Nick Bowler <nbowler@elliptictech.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Russell King <linux@arm.linux.org.uk>, John Linn <john.linn@xilinx.com>
Subject: [PATCH 1/3] ARM: zynq: Allow UART1 to be used as DEBUG_LL console.
Date: Wed,  4 Jul 2012 10:13:33 -0400
Message-Id: <1341411215-3617-2-git-send-email-nbowler@elliptictech.com>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1341411215-3617-1-git-send-email-nbowler@elliptictech.com>
References: <1341411215-3617-1-git-send-email-nbowler@elliptictech.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The main UART on the Xilinx ZC702 board is UART1, located at address
e0001000.  Add a Kconfig option to select this device as the low-level
debugging port.  This allows the really early boot printouts to reach
the USB serial adaptor on this board.

The board does not boot yet, but now it's actually possible to see error
messages.

For consistency's sake, add a choice entry for UART0 even though it is
the the default if UART1 is not selected.

Signed-off-by: Nick Bowler <nbowler@elliptictech.com>
Cc: John Linn <john.linn@xilinx.com>

---
 arch/arm/Kconfig.debug                     |   17 +++++++++++++++++
 arch/arm/mach-zynq/common.c                |    4 ++--
 arch/arm/mach-zynq/include/mach/zynq_soc.h |   12 ++++++++++--
 3 files changed, 29 insertions(+), 4 deletions(-)

diff --git a/arch/arm/Kconfig.debug b/arch/arm/Kconfig.debug
index 01a1341..9abe3ad 100644
--- a/arch/arm/Kconfig.debug
+++ b/arch/arm/Kconfig.debug
@@ -132,6 +132,23 @@ choice
 		  their output to UART1 serial port on DaVinci TNETV107X
 		  devices.
 
+	config DEBUG_ZYNQ_UART0
+		bool "Kernel low-level debugging on Xilinx Zynq using UART0"
+		depends on ARCH_ZYNQ
+		help
+		  Say Y here if you want the debug print routines to direct
+		  their output to UART0 on the Zynq platform.
+
+	config DEBUG_ZYNQ_UART1
+		bool "Kernel low-level debugging on Xilinx Zynq using UART1"
+		depends on ARCH_ZYNQ
+		help
+		  Say Y here if you want the debug print routines to direct
+		  their output to UART1 on the Zynq platform.
+
+		  If you have a ZC702 board and want early boot messages to
+		  appear on the USB serial adaptor, select this option.
+
 	config DEBUG_DC21285_PORT
 		bool "Kernel low-level debugging messages via footbridge serial port"
 		depends on FOOTBRIDGE
diff --git a/arch/arm/mach-zynq/common.c b/arch/arm/mach-zynq/common.c
index ab5cfdd..12a2984 100644
--- a/arch/arm/mach-zynq/common.c
+++ b/arch/arm/mach-zynq/common.c
@@ -87,8 +87,8 @@ static struct map_desc io_desc[] __initdata = {
 
 #ifdef CONFIG_DEBUG_LL
 	{
-		.virtual	= UART0_VIRT,
-		.pfn		= __phys_to_pfn(UART0_PHYS),
+		.virtual	= LL_UART_VADDR,
+		.pfn		= __phys_to_pfn(LL_UART_PADDR),
 		.length		= SZ_4K,
 		.type		= MT_DEVICE,
 	},
diff --git a/arch/arm/mach-zynq/include/mach/zynq_soc.h b/arch/arm/mach-zynq/include/mach/zynq_soc.h
index d0d3f8f..6f83f1c 100644
--- a/arch/arm/mach-zynq/include/mach/zynq_soc.h
+++ b/arch/arm/mach-zynq/include/mach/zynq_soc.h
@@ -22,6 +22,9 @@
 #define UART0_PHYS			0xE0000000
 #define UART0_VIRT			UART0_PHYS
 
+#define UART1_PHYS			0xE0001000
+#define UART1_VIRT			UART1_PHYS
+
 #define TTC0_PHYS			0xF8001000
 #define TTC0_VIRT			TTC0_PHYS
 
@@ -42,7 +45,12 @@
 /*
  * Mandatory for CONFIG_LL_DEBUG, UART is mapped virtual = physical
  */
-#define LL_UART_PADDR	UART0_PHYS
-#define LL_UART_VADDR	UART0_VIRT
+#ifdef CONFIG_DEBUG_ZYNQ_UART1
+#  define LL_UART_PADDR UART1_PHYS
+#  define LL_UART_VADDR UART1_VIRT
+#else
+#  define LL_UART_PADDR UART0_PHYS
+#  define LL_UART_VADDR UART0_VIRT
+#endif
 
 #endif
-- 
1.7.8.6


