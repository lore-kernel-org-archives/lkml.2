Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965331Ab2JXUDs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 16:03:48 -0400
Received: from mailserver5.natinst.com ([130.164.80.5]:45393 "EHLO
	spamkiller05.natinst.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933694Ab2JXUDq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 16:03:46 -0400
Date: Wed, 24 Oct 2012 15:03:37 -0500
From: Josh Cartwright <josh.cartwright@ni.com>
To: arm@kernel.org, Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        John Linn <john.linn@xilinx.com>,
        Nick Bowler <nbowler@elliptictech.com>,
        Michal Simek <michal.simek@xilinx.com>
Subject: [PATCH v4 2/5] zynq: use pl310 device tree bindings
Message-ID: <20121024200337.GC6713@beefymiracle.amer.corp.natinst.com>
MIME-Version: 1.0
In-Reply-To: <20121024200222.GA6713@beefymiracle.amer.corp.natinst.com>
User-Agent: Mutt/1.5.21 (2011-07-01)
X-MIMETrack: Itemize by SMTP Server on MailServ58-US/AUS/H/NIC(Release 8.5.3FP2 HF169|September
 14, 2012) at 10/24/2012 03:03:33 PM,
	Serialize by Router on MailServ58-US/AUS/H/NIC(Release 8.5.3FP2 HF169|September
 14, 2012) at 10/24/2012 03:03:36 PM,
	Serialize complete at 10/24/2012 03:03:36 PM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.7.7855,1.0.431,0.0.0000
 definitions=2012-10-24_05:2012-10-24,2012-10-24,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Zynq has a PL310 L2 cache controller.  Convert in-tree uses to using
the device tree.

Signed-off-by: Josh Cartwright <josh.cartwright@ni.com>
Cc: John Linn <john.linn@xilinx.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/arm/boot/dts/zynq-ep107.dts           | 9 +++++++++
 arch/arm/mach-zynq/common.c                | 9 +--------
 arch/arm/mach-zynq/include/mach/zynq_soc.h | 4 ----
 3 files changed, 10 insertions(+), 12 deletions(-)

diff --git a/arch/arm/boot/dts/zynq-ep107.dts b/arch/arm/boot/dts/zynq-ep107.dts
index 7bfff4a..87204d7 100644
--- a/arch/arm/boot/dts/zynq-ep107.dts
+++ b/arch/arm/boot/dts/zynq-ep107.dts
@@ -44,6 +44,15 @@
 			      <0xF8F00100 0x100>;
 		};
 
+		L2: cache-controller {
+			compatible = "arm,pl310-cache";
+			reg = <0xF8F02000 0x1000>;
+			arm,data-latency = <2 3 2>;
+			arm,tag-latency = <2 3 2>;
+			cache-unified;
+			cache-level = <2>;
+		};
+
 		uart0: uart@e0000000 {
 			compatible = "xlnx,xuartps";
 			reg = <0xE0000000 0x1000>;
diff --git a/arch/arm/mach-zynq/common.c b/arch/arm/mach-zynq/common.c
index d73963b..056091a 100644
--- a/arch/arm/mach-zynq/common.c
+++ b/arch/arm/mach-zynq/common.c
@@ -45,12 +45,10 @@ static struct of_device_id zynq_of_bus_ids[] __initdata = {
  */
 static void __init xilinx_init_machine(void)
 {
-#ifdef CONFIG_CACHE_L2X0
 	/*
 	 * 64KB way size, 8-way associativity, parity disabled
 	 */
-	l2x0_init(PL310_L2CC_BASE, 0x02060000, 0xF0F0FFFF);
-#endif
+	l2x0_of_init(0x02060000, 0xF0F0FFFF);
 
 	of_platform_bus_probe(NULL, zynq_of_bus_ids, NULL);
 }
@@ -83,11 +81,6 @@ static struct map_desc io_desc[] __initdata = {
 		.pfn		= __phys_to_pfn(SCU_PERIPH_PHYS),
 		.length		= SZ_8K,
 		.type		= MT_DEVICE,
-	}, {
-		.virtual	= PL310_L2CC_VIRT,
-		.pfn		= __phys_to_pfn(PL310_L2CC_PHYS),
-		.length		= SZ_4K,
-		.type		= MT_DEVICE,
 	},
 
 #ifdef CONFIG_DEBUG_LL
diff --git a/arch/arm/mach-zynq/include/mach/zynq_soc.h b/arch/arm/mach-zynq/include/mach/zynq_soc.h
index 3d1c6a6..218283a 100644
--- a/arch/arm/mach-zynq/include/mach/zynq_soc.h
+++ b/arch/arm/mach-zynq/include/mach/zynq_soc.h
@@ -25,9 +25,6 @@
 #define TTC0_PHYS			0xF8001000
 #define TTC0_VIRT			TTC0_PHYS
 
-#define PL310_L2CC_PHYS			0xF8F02000
-#define PL310_L2CC_VIRT			PL310_L2CC_PHYS
-
 #define SCU_PERIPH_PHYS			0xF8F00000
 #define SCU_PERIPH_VIRT			SCU_PERIPH_PHYS
 
@@ -35,7 +32,6 @@
 
 #define TTC0_BASE			IOMEM(TTC0_VIRT)
 #define SCU_PERIPH_BASE			IOMEM(SCU_PERIPH_VIRT)
-#define PL310_L2CC_BASE			IOMEM(PL310_L2CC_VIRT)
 
 /*
  * Mandatory for CONFIG_LL_DEBUG, UART is mapped virtual = physical
-- 
1.8.0

