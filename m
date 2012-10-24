Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964889Ab2JXAf3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 20:35:29 -0400
Received: from mailserver5.natinst.com ([130.164.80.5]:54748 "EHLO
	spamkiller05.natinst.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933676Ab2JXAfZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 20:35:25 -0400
Date: Tue, 23 Oct 2012 19:35:23 -0500
From: Josh Cartwright <josh.cartwright@ni.com>
To: arm@kernel.org, Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        John Linn <john.linn@xilinx.com>,
        Nick Bowler <nbowler@elliptictech.com>
Subject: [PATCH v3 5/5] zynq: move static peripheral mappings
Message-ID: <20121024003523.GF31625@beefymiracle.amer.corp.natinst.com>
MIME-Version: 1.0
In-Reply-To: <20121024003218.GA31625@beefymiracle.amer.corp.natinst.com>
User-Agent: Mutt/1.5.21 (2011-07-01)
X-MIMETrack: Itemize by SMTP Server on MailServ58-US/AUS/H/NIC(Release 8.5.3FP2 HF169|September
 14, 2012) at 10/23/2012 07:35:19 PM,
	Serialize by Router on MailServ58-US/AUS/H/NIC(Release 8.5.3FP2 HF169|September
 14, 2012) at 10/23/2012 07:35:19 PM,
	Serialize complete at 10/23/2012 07:35:19 PM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.7.7855,1.0.431,0.0.0000
 definitions=2012-10-23_09:2012-10-23,2012-10-23,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Shifting them up into the vmalloc region prevents the following warning,
when booting a zynq qemu target with more than 512mb of RAM:

  BUG: mapping for 0xe0000000 at 0xe0000000 out of vmalloc space

In addition, it allows for reuse of these mappings when the proper
drivers issue requests via ioremap().

Signed-off-by: Josh Cartwright <josh.cartwright@ni.com>
Cc: John Linn <john.linn@xilinx.com>
---
 arch/arm/mach-zynq/common.c                |  6 +++---
 arch/arm/mach-zynq/include/mach/zynq_soc.h | 23 +++++++++++++----------
 2 files changed, 16 insertions(+), 13 deletions(-)

diff --git a/arch/arm/mach-zynq/common.c b/arch/arm/mach-zynq/common.c
index ba48f06..ba8d14f 100644
--- a/arch/arm/mach-zynq/common.c
+++ b/arch/arm/mach-zynq/common.c
@@ -73,12 +73,12 @@ static struct map_desc io_desc[] __initdata = {
 	{
 		.virtual	= TTC0_VIRT,
 		.pfn		= __phys_to_pfn(TTC0_PHYS),
-		.length		= SZ_4K,
+		.length		= TTC0_SIZE,
 		.type		= MT_DEVICE,
 	}, {
 		.virtual	= SCU_PERIPH_VIRT,
 		.pfn		= __phys_to_pfn(SCU_PERIPH_PHYS),
-		.length		= SZ_8K,
+		.length		= SCU_PERIPH_SIZE,
 		.type		= MT_DEVICE,
 	},
 
@@ -86,7 +86,7 @@ static struct map_desc io_desc[] __initdata = {
 	{
 		.virtual	= UART0_VIRT,
 		.pfn		= __phys_to_pfn(UART0_PHYS),
-		.length		= SZ_4K,
+		.length		= UART0_SIZE,
 		.type		= MT_DEVICE,
 	},
 #endif
diff --git a/arch/arm/mach-zynq/include/mach/zynq_soc.h b/arch/arm/mach-zynq/include/mach/zynq_soc.h
index 218283a..c6b9b67 100644
--- a/arch/arm/mach-zynq/include/mach/zynq_soc.h
+++ b/arch/arm/mach-zynq/include/mach/zynq_soc.h
@@ -15,27 +15,30 @@
 #ifndef __MACH_XILINX_SOC_H__
 #define __MACH_XILINX_SOC_H__
 
+#include <asm/pgtable.h>
+
 #define PERIPHERAL_CLOCK_RATE		2500000
 
-/* For now, all mappings are flat (physical = virtual)
+/* Static peripheral mappings are mapped at the top of the
+ * vmalloc region
  */
-#define UART0_PHYS			0xE0000000
-#define UART0_VIRT			UART0_PHYS
+#define UART0_PHYS		0xE0000000
+#define UART0_SIZE		SZ_4K
+#define UART0_VIRT		(VMALLOC_END - UART0_SIZE)
 
-#define TTC0_PHYS			0xF8001000
-#define TTC0_VIRT			TTC0_PHYS
+#define TTC0_PHYS		0xF8001000
+#define TTC0_SIZE		SZ_4K
+#define TTC0_VIRT		(UART0_VIRT - TTC0_SIZE)
 
-#define SCU_PERIPH_PHYS			0xF8F00000
-#define SCU_PERIPH_VIRT			SCU_PERIPH_PHYS
+#define SCU_PERIPH_PHYS		0xF8F00000
+#define SCU_PERIPH_SIZE		SZ_8K
+#define SCU_PERIPH_VIRT		(TTC0_VIRT - SCU_PERIPH_SIZE)
 
 /* The following are intended for the devices that are mapped early */
 
 #define TTC0_BASE			IOMEM(TTC0_VIRT)
 #define SCU_PERIPH_BASE			IOMEM(SCU_PERIPH_VIRT)
 
-/*
- * Mandatory for CONFIG_LL_DEBUG, UART is mapped virtual = physical
- */
 #define LL_UART_PADDR	UART0_PHYS
 #define LL_UART_VADDR	UART0_VIRT
 
-- 
1.8.0
