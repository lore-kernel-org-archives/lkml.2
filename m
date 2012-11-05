Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933296Ab2KEVrS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 16:47:18 -0500
Received: from mx.scalarmail.ca ([98.158.95.75]:49463 "EHLO
	ironport-01.sms.scalar.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753394Ab2KEVrQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 16:47:16 -0500
From: Nick Bowler <nbowler@elliptictech.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: arm@kernel.org, Arnd Bergmann <arnd@arndb.de>,
        John Linn <john.linn@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Josh Cartwright <josh.cartwright@ni.com>
Subject: =?UTF-8?q?=5BPATCH=20v3=5D=20ARM=3A=20zynq=3A=20Allow=20UART1=20to=20be=20used=20as=20DEBUG=5FLL=20console=2E?=
Date: Mon,  5 Nov 2012 16:45:49 -0500
Message-Id: <1352151949-18319-1-git-send-email-nbowler@elliptictech.com>
X-Mailer: git-send-email 1.7.8.6
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The main UART on the Xilinx ZC702 board is UART1, located at address
e0001000.  Add a Kconfig option to select this device as the low-level
debugging port.  This allows the really early boot printouts to reach
the USB serial adaptor on this board.

For consistency's sake, add a choice entry for UART0 even though it is
the the default if UART1 is not selected.

Signed-off-by: Nick Bowler <nbowler@elliptictech.com>
Tested-by: Josh Cartwright <josh.cartwright@ni.com>
---
Sorry all for the phenominal delay in sending this out.  Josh, I kept
your Tested-By since this version is Obviously Equivalent™ to v2...

v2: rebase on newest patch series, signoff.
v3: squash in style tweaks suggested by Michal Simek.

 arch/arm/Kconfig.debug                     |   17 +++++++++++++++++
 arch/arm/mach-zynq/common.c                |    6 +++---
 arch/arm/mach-zynq/include/mach/zynq_soc.h |   16 +++++++++++-----
 3 files changed, 31 insertions(+), 8 deletions(-)

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
index 1b8bf0ecbcb0..5ebbd8e6eeee 100644
--- a/arch/arm/mach-zynq/include/mach/zynq_soc.h
+++ b/arch/arm/mach-zynq/include/mach/zynq_soc.h
@@ -25,8 +25,9 @@
  * address that is known to work.
  */
 #define UART0_PHYS		0xE0000000
-#define UART0_SIZE		SZ_4K
-#define UART0_VIRT		0xF0001000
+#define UART1_PHYS		0xE0001000
+#define UART_SIZE		SZ_4K
+#define UART_VIRT		0xF0001000
 
 #define TTC0_PHYS		0xF8001000
 #define TTC0_SIZE		SZ_4K
@@ -36,12 +37,17 @@
 #define SCU_PERIPH_SIZE		SZ_8K
 #define SCU_PERIPH_VIRT		(TTC0_VIRT - SCU_PERIPH_SIZE)
 
+#if IS_ENABLED(CONFIG_DEBUG_ZYNQ_UART1)
+# define LL_UART_PADDR		UART1_PHYS
+#else
+# define LL_UART_PADDR		UART0_PHYS
+#endif
+
+#define LL_UART_VADDR		UART_VIRT
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

