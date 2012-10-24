Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965289Ab2JXUDP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 16:03:15 -0400
Received: from mailserver5.natinst.com ([130.164.80.5]:45098 "EHLO
	spamkiller05.natinst.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933694Ab2JXUDN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 16:03:13 -0400
Date: Wed, 24 Oct 2012 15:03:10 -0500
From: Josh Cartwright <josh.cartwright@ni.com>
To: arm@kernel.org, Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        John Linn <john.linn@xilinx.com>,
        Nick Bowler <nbowler@elliptictech.com>,
        Michal Simek <michal.simek@xilinx.com>
Subject: [PATCH v4 1/5] zynq: use GIC device tree bindings
Message-ID: <20121024200310.GB6713@beefymiracle.amer.corp.natinst.com>
MIME-Version: 1.0
In-Reply-To: <20121024200222.GA6713@beefymiracle.amer.corp.natinst.com>
User-Agent: Mutt/1.5.21 (2011-07-01)
X-MIMETrack: Itemize by SMTP Server on MailServ58-US/AUS/H/NIC(Release 8.5.3FP2 HF169|September
 14, 2012) at 10/24/2012 03:03:06 PM,
	Serialize by Router on MailServ58-US/AUS/H/NIC(Release 8.5.3FP2 HF169|September
 14, 2012) at 10/24/2012 03:03:06 PM,
	Serialize complete at 10/24/2012 03:03:06 PM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.7.7855,1.0.431,0.0.0000
 definitions=2012-10-24_05:2012-10-24,2012-10-24,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Zynq uses the cortex-a9-gic.  This eliminates the need to hardcode
register addresses.

Signed-off-by: Josh Cartwright <josh.cartwright@ni.com>
Cc: John Linn <john.linn@xilinx.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/arm/boot/dts/zynq-ep107.dts           | 8 +++++---
 arch/arm/mach-zynq/common.c                | 7 ++++++-
 arch/arm/mach-zynq/include/mach/zynq_soc.h | 2 --
 3 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/arch/arm/boot/dts/zynq-ep107.dts b/arch/arm/boot/dts/zynq-ep107.dts
index 37ca192..7bfff4a 100644
--- a/arch/arm/boot/dts/zynq-ep107.dts
+++ b/arch/arm/boot/dts/zynq-ep107.dts
@@ -36,10 +36,12 @@
 		ranges;
 
 		intc: interrupt-controller@f8f01000 {
+			compatible = "arm,cortex-a9-gic";
+			#interrupt-cells = <3>;
+			#address-cells = <1>;
 			interrupt-controller;
-			compatible = "arm,gic";
-			reg = <0xF8F01000 0x1000>;
-			#interrupt-cells = <2>;
+			reg = <0xF8F01000 0x1000>,
+			      <0xF8F00100 0x100>;
 		};
 
 		uart0: uart@e0000000 {
diff --git a/arch/arm/mach-zynq/common.c b/arch/arm/mach-zynq/common.c
index ab5cfdd..d73963b 100644
--- a/arch/arm/mach-zynq/common.c
+++ b/arch/arm/mach-zynq/common.c
@@ -55,12 +55,17 @@ static void __init xilinx_init_machine(void)
 	of_platform_bus_probe(NULL, zynq_of_bus_ids, NULL);
 }
 
+static struct of_device_id irq_match[] __initdata = {
+	{ .compatible = "arm,cortex-a9-gic", .data = gic_of_init, },
+	{ }
+};
+
 /**
  * xilinx_irq_init() - Interrupt controller initialization for the GIC.
  */
 static void __init xilinx_irq_init(void)
 {
-	gic_init(0, 29, SCU_GIC_DIST_BASE, SCU_GIC_CPU_BASE);
+	of_irq_init(irq_match);
 }
 
 /* The minimum devices needed to be mapped before the VM system is up and
diff --git a/arch/arm/mach-zynq/include/mach/zynq_soc.h b/arch/arm/mach-zynq/include/mach/zynq_soc.h
index d0d3f8f..3d1c6a6 100644
--- a/arch/arm/mach-zynq/include/mach/zynq_soc.h
+++ b/arch/arm/mach-zynq/include/mach/zynq_soc.h
@@ -35,8 +35,6 @@
 
 #define TTC0_BASE			IOMEM(TTC0_VIRT)
 #define SCU_PERIPH_BASE			IOMEM(SCU_PERIPH_VIRT)
-#define SCU_GIC_CPU_BASE		(SCU_PERIPH_BASE + 0x100)
-#define SCU_GIC_DIST_BASE		(SCU_PERIPH_BASE + 0x1000)
 #define PL310_L2CC_BASE			IOMEM(PL310_L2CC_VIRT)
 
 /*
-- 
1.8.0

