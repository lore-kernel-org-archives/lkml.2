Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752001Ab2JYWsU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 18:48:20 -0400
Received: from mx.scalarmail.ca ([98.158.95.75]:64737 "EHLO
	ironport-01.sms.scalar.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750894Ab2JYWsS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 18:48:18 -0400
From: Nick Bowler <nbowler@elliptictech.com>
To: Josh Cartwright <josh.cartwright@ni.com>
Cc: arm@kernel.org, Arnd Bergmann <arnd@arndb.de>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        John Linn <john.linn@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>
Subject: [PATCH] ARM: zynq: Allow UART1 to be used as DEBUG_LL console.
Date: Thu, 25 Oct 2012 18:47:34 -0400
Message-Id: <1351205254-2409-1-git-send-email-nbowler@elliptictech.com>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <20121025224108.GA30705@elliptictech.com>
References: <20121025224108.GA30705@elliptictech.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The main UART on the Xilinx ZC702 board is UART1, located at address
e0001000.  Add a Kconfig option to select this device as the low-level
debugging port.  This allows the really early boot printouts to reach
the USB serial adaptor on this board.

For consistency's sake, add a choice entry for UART0 even though it is
the the default if UART1 is not selected.

As there are currently known issues related to the UART virtual
mappings, this is KNOWN BROKEN, not to be merged yet!

Not-Yet-Signed-off-by: Nick Bowler <nbowler@elliptictech.com>
---
 arch/arm/Kconfig.debug                     |   17 +++++++++++++++++
 arch/arm/mach-zynq/common.c                |    6 +++---
 arch/arm/mach-zynq/include/mach/zynq_soc.h |   18 ++++++++++++------
 3 files changed, 32 insertions(+), 9 deletions(-)

diff --git a/arch/arm/Kconfig.debug b/arch/arm/Kconfig.debug
index b0f3857b3a4c..7754d51f2b19 100644
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
index ba8d14f78d4d..93b91059faab 100644
--- a/arch/arm/mach-zynq/common.c
+++ b/arch/arm/mach-zynq/common.c
@@ -84,9 +84,9 @@ static struct map_desc io_desc[] __initdata = {
 
 #ifdef CONFIG_DEBUG_LL
 	{
-		.virtual	= UART0_VIRT,
-		.pfn		= __phys_to_pfn(UART0_PHYS),
-		.length		= UART0_SIZE,
+		.virtual	= LL_UART_VADDR,
+		.pfn		= __phys_to_pfn(LL_UART_PADDR),
+		.length		= UART_SIZE,
 		.type		= MT_DEVICE,
 	},
 #endif
diff --git a/arch/arm/mach-zynq/include/mach/zynq_soc.h b/arch/arm/mach-zynq/include/mach/zynq_soc.h
index c6b9b67bf7c7..cab72bfd183c 100644
--- a/arch/arm/mach-zynq/include/mach/zynq_soc.h
+++ b/arch/arm/mach-zynq/include/mach/zynq_soc.h
@@ -23,23 +23,29 @@
  * vmalloc region
  */
 #define UART0_PHYS		0xE0000000
-#define UART0_SIZE		SZ_4K
-#define UART0_VIRT		(VMALLOC_END - UART0_SIZE)
+#define UART1_PHYS		0xE0001000
+#define UART_SIZE		SZ_4K
+#define UART_VIRT		(VMALLOC_END - UART_SIZE)
 
 #define TTC0_PHYS		0xF8001000
 #define TTC0_SIZE		SZ_4K
-#define TTC0_VIRT		(UART0_VIRT - TTC0_SIZE)
+#define TTC0_VIRT		(UART_VIRT - TTC0_SIZE)
 
 #define SCU_PERIPH_PHYS		0xF8F00000
 #define SCU_PERIPH_SIZE		SZ_8K
 #define SCU_PERIPH_VIRT		(TTC0_VIRT - SCU_PERIPH_SIZE)
 
+#if IS_ENABLED(CONFIG_DEBUG_ZYNQ_UART1)
+#	define LL_UART_PADDR	UART1_PHYS
+#	define LL_UART_VADDR	UART_VIRT
+#else
+#	define LL_UART_PADDR	UART0_PHYS
+#	define LL_UART_VADDR	UART_VIRT
+#endif
+
 /* The following are intended for the devices that are mapped early */
 
 #define TTC0_BASE			IOMEM(TTC0_VIRT)
 #define SCU_PERIPH_BASE			IOMEM(SCU_PERIPH_VIRT)
 
-#define LL_UART_PADDR	UART0_PHYS
-#define LL_UART_VADDR	UART0_VIRT
-
 #endif
-- 
1.7.8.6

