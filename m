Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754428Ab1LLWCq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 17:02:46 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:64127 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754235Ab1LLWCl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 17:02:41 -0500
From: Grant Likely <grant.likely@secretlab.ca>
To: linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Cc: Mike Turquette <mturquette@ti.com>, Sascha Hauer <kernel@pengutronix.de>,
        Rob Herring <rob.herring@calxeda.com>,
        Shawn Guo <shawn.guo@freescale.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Russell King <linux@arm.linux.org.uk>
Subject: [RFC v2 8/9] dt/arm: versatile add clock parsing
Date: Mon, 12 Dec 2011 15:02:08 -0700
Message-Id: <1323727329-4989-8-git-send-email-grant.likely@secretlab.ca>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1323727329-4989-1-git-send-email-grant.likely@secretlab.ca>
References: <1323727329-4989-1-git-send-email-grant.likely@secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Mike Turquette <mturquette@ti.com>
---
 arch/arm/boot/dts/versatile-ab.dts     |   79 ++++++++++++++++++++++++++++++++
 arch/arm/mach-versatile/core.c         |   39 +--------------
 arch/arm/mach-versatile/versatile_dt.c |   39 +++++++++++++++-
 3 files changed, 119 insertions(+), 38 deletions(-)

diff --git a/arch/arm/boot/dts/versatile-ab.dts b/arch/arm/boot/dts/versatile-ab.dts
index 0b32925..d29fc2b 100644
--- a/arch/arm/boot/dts/versatile-ab.dts
+++ b/arch/arm/boot/dts/versatile-ab.dts
@@ -8,6 +8,10 @@
 	#size-cells = <1>;
 	interrupt-parent = <&vic>;
 
+	clocks = <&ref24_clk>;
+	clock-names = "apb_pclk";
+	clock-ranges;
+
 	aliases {
 		serial0 = &uart0;
 		serial1 = &uart1;
@@ -19,6 +23,42 @@
 		reg = <0x0 0x08000000>;
 	};
 
+	clocks {
+		ref24_clk: ref24clk {
+			compatible = "fixed-clock";
+			#clock-cells = <0>;
+			clock-frequency = <24000000>;
+		};
+
+		tim_clk: timclk {
+			compatible = "fixed-clock";
+			#clock-cells = <0>;
+			clock-frequency = <1000000>;
+		};
+
+		ref_clk: refclk {
+			compatible = "fixed-clock";
+			#clock-cells = <0>;
+			clock-frequency = <32000>;
+		};
+	};
+
+	sys@10000000 {
+		compatible = "arm,versatile-sys-regs";
+		reg = <0x10000000 0x100>;
+
+		osc4_clk: clock {
+			compatible = "idt,ics307";
+			#clock-cells = <1>;
+			idt,ref-clock-freq = <24000000>;
+			idt,vco-div-range = <12 519>;
+			idt,ref-div-range = <3 129>;
+
+			arm,reg-vco-offset = <0x1c>;
+			arm,reg-lock-offset = <0x20>;
+		};
+	};
+
 	flash@34000000 {
 		compatible = "arm,versatile-flash";
 		reg = <0x34000000 0x4000000>;
@@ -53,6 +93,7 @@
 		#address-cells = <1>;
 		#size-cells = <1>;
 		ranges;
+		clock-ranges;
 
 		vic: intc@10140000 {
 			compatible = "arm,versatile-vic";
@@ -108,6 +149,8 @@
 			compatible = "arm,pl110", "arm,primecell";
 			reg = <0x10120000 0x1000>;
 			interrupts = <16>;
+			clocks = <&osc4_clk 0>;
+			clock-names = "apb_pclk";
 		};
 
 		sctl@101e0000 {
@@ -121,6 +164,36 @@
 			interrupts = <0>;
 		};
 
+		timer@101e2000 {
+			compatible = "arm,sp804";
+			reg = <0x101e2000 0x1000>;
+			clocks = <&tim_clk>;
+			interrupts = <4>;
+			linux,clockevents-device;
+		};
+
+		timer@101e2020 {
+			compatible = "arm,sp804";
+			reg = <0x101e2020 0x1000>;
+			clocks = <&tim_clk>;
+			interrupts = <4>;
+		};
+
+		timer@101e3000 {
+			compatible = "arm,sp804";
+			reg = <0x101e3000 0x1000>;
+			clocks = <&tim_clk>;
+			interrupts = <5>;
+			linux,clock-source;
+		};
+
+		timer@101e3020 {
+			compatible = "arm,sp804";
+			reg = <0x101e3020 0x1000>;
+			clocks = <&tim_clk>;
+			interrupts = <5>;
+		};
+
 		gpio0: gpio@101e4000 {
 			compatible = "arm,pl061", "arm,primecell";
 			reg = <0x101e4000 0x1000>;
@@ -165,6 +238,8 @@
 			#size-cells = <1>;
 			ranges = <0 0x10000000 0x10000>;
 
+			clock-ranges;
+
 			aaci@4000 {
 				compatible = "arm,primecell";
 				reg = <0x4000 0x1000>;
@@ -180,12 +255,16 @@
 				reg = <0x6000 0x1000>;
 				interrupt-parent = <&sic>;
 				interrupts = <3>;
+				clocks = <&ref24_clk>;
+				clock-names = "KMIREFCLK";
 			};
 			kmi@7000 {
 				compatible = "arm,pl050", "arm,primecell";
 				reg = <0x7000 0x1000>;
 				interrupt-parent = <&sic>;
 				interrupts = <4>;
+				clocks = <&ref24_clk>;
+				clock-names = "KMIREFCLK";
 			};
 		};
 	};
diff --git a/arch/arm/mach-versatile/core.c b/arch/arm/mach-versatile/core.c
index 47f4531..7b4e00a 100644
--- a/arch/arm/mach-versatile/core.c
+++ b/arch/arm/mach-versatile/core.c
@@ -26,6 +26,7 @@
 #include <linux/interrupt.h>
 #include <linux/irqdomain.h>
 #include <linux/of_address.h>
+#include <linux/of_clk.h>
 #include <linux/of_platform.h>
 #include <linux/amba/bus.h>
 #include <linux/amba/clcd.h>
@@ -647,44 +648,11 @@ static struct amba_device *amba_devs[] __initdata = {
 /*
  * Lookup table for attaching a specific name and platform_data pointer to
  * devices as they get created by of_platform_populate().  Ideally this table
- * would not exist, but the current clock implementation depends on some devices
- * having a specific name.
+ * would not exist, but some devices still need platform data.
  */
 struct of_dev_auxdata versatile_auxdata_lookup[] __initdata = {
-	OF_DEV_AUXDATA("arm,primecell", VERSATILE_MMCI0_BASE, "fpga:05", NULL),
-	OF_DEV_AUXDATA("arm,primecell", VERSATILE_KMI0_BASE, "fpga:06", NULL),
-	OF_DEV_AUXDATA("arm,primecell", VERSATILE_KMI1_BASE, "fpga:07", NULL),
-	OF_DEV_AUXDATA("arm,primecell", VERSATILE_UART3_BASE, "fpga:09", NULL),
-	OF_DEV_AUXDATA("arm,primecell", VERSATILE_MMCI1_BASE, "fpga:0b", NULL),
-
-	OF_DEV_AUXDATA("arm,primecell", VERSATILE_CLCD_BASE, "dev:20", &clcd_plat_data),
-	OF_DEV_AUXDATA("arm,primecell", VERSATILE_UART0_BASE, "dev:f1", NULL),
-	OF_DEV_AUXDATA("arm,primecell", VERSATILE_UART1_BASE, "dev:f2", NULL),
-	OF_DEV_AUXDATA("arm,primecell", VERSATILE_UART2_BASE, "dev:f3", NULL),
-	OF_DEV_AUXDATA("arm,primecell", VERSATILE_SSP_BASE, "dev:f4", NULL),
 
-#if 0
-	/*
-	 * These entries are unnecessary because no clocks referencing
-	 * them.  I've left them in for now as place holders in case
-	 * any of them need to be added back, but they should be
-	 * removed before actually committing this patch.  --gcl
-	 */
-	OF_DEV_AUXDATA("arm,primecell", VERSATILE_AACI_BASE, "fpga:04", NULL),
-	OF_DEV_AUXDATA("arm,primecell", VERSATILE_SCI1_BASE, "fpga:0a", NULL),
-	OF_DEV_AUXDATA("arm,primecell", VERSATILE_SMC_BASE, "dev:00", NULL),
-	OF_DEV_AUXDATA("arm,primecell", VERSATILE_MPMC_BASE, "dev:10", NULL),
-	OF_DEV_AUXDATA("arm,primecell", VERSATILE_DMAC_BASE, "dev:30", NULL),
-
-	OF_DEV_AUXDATA("arm,primecell", VERSATILE_SCTL_BASE, "dev:e0", NULL),
-	OF_DEV_AUXDATA("arm,primecell", VERSATILE_WATCHDOG_BASE, "dev:e1", NULL),
-	OF_DEV_AUXDATA("arm,primecell", VERSATILE_GPIO0_BASE, "dev:e4", NULL),
-	OF_DEV_AUXDATA("arm,primecell", VERSATILE_GPIO1_BASE, "dev:e5", NULL),
-	OF_DEV_AUXDATA("arm,primecell", VERSATILE_GPIO2_BASE, "dev:e6", NULL),
-	OF_DEV_AUXDATA("arm,primecell", VERSATILE_GPIO3_BASE, "dev:e7", NULL),
-	OF_DEV_AUXDATA("arm,primecell", VERSATILE_RTC_BASE, "dev:e8", NULL),
-	OF_DEV_AUXDATA("arm,primecell", VERSATILE_SCI_BASE, "dev:f0", NULL),
-#endif
+	OF_DEV_AUXDATA("arm,primecell", VERSATILE_CLCD_BASE, NULL, &clcd_plat_data),
 	{}
 };
 #endif
@@ -799,4 +767,3 @@ static void __init versatile_timer_init(void)
 struct sys_timer versatile_timer = {
 	.init		= versatile_timer_init,
 };
-
diff --git a/arch/arm/mach-versatile/versatile_dt.c b/arch/arm/mach-versatile/versatile_dt.c
index 54e037c..26c9705 100644
--- a/arch/arm/mach-versatile/versatile_dt.c
+++ b/arch/arm/mach-versatile/versatile_dt.c
@@ -21,14 +21,49 @@
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
 
+#include <linux/io.h>
 #include <linux/init.h>
 #include <linux/of_irq.h>
 #include <linux/of_platform.h>
+#include <linux/of_clk.h>
+#include <linux/slab.h>
+
+#include <plat/sched_clock.h>
+#include <mach/hardware.h>
+#include <mach/clkdev.h>
+#include <asm/irq.h>
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
 
 #include "core.h"
 
+static void __init versatile_dt_init_early(void)
+{
+	void __iomem *sys = __io_address(VERSATILE_SYS_BASE);
+	u32 val;
+
+	/*
+	 * TODO: DT generalization of early init code; the ARM Versatile,
+	 * Realview, Integrator, and VExpress boards are pretty similar here.
+	 * All call versatile_sched_clock_init(), and need to configure the
+	 * correct clock input to the sp804 timers
+	 */
+	versatile_sched_clock_init(sys + VERSATILE_SYS_24MHz_OFFSET, 24000000);
+
+	/*
+	 * set clock frequency to the sp804 timers:
+	 * VERSATILE_REFCLK is 32KHz
+	 * VERSATILE_TIMCLK is 1MHz
+	 */
+	sys = __io_address(VERSATILE_SCTL_BASE);
+	val = readl(sys);
+	val |= (VERSATILE_TIMCLK << VERSATILE_TIMER1_EnSel);
+	val |= (VERSATILE_TIMCLK << VERSATILE_TIMER2_EnSel);
+	val |= (VERSATILE_TIMCLK << VERSATILE_TIMER3_EnSel);
+	val |= (VERSATILE_TIMCLK << VERSATILE_TIMER4_EnSel);
+	writel(val, sys);
+}
+
 static void __init versatile_dt_init(void)
 {
 	of_platform_populate(NULL, of_default_bus_match_table,
@@ -43,9 +78,9 @@ static const char *versatile_dt_match[] __initconst = {
 
 DT_MACHINE_START(VERSATILE_PB, "ARM-Versatile (Device Tree Support)")
 	.map_io		= versatile_map_io,
-	.init_early	= versatile_init_early,
+	.init_early	= versatile_dt_init_early,
 	.init_irq	= versatile_init_irq,
-	.timer		= &versatile_timer,
+	.timer		= &versatile_dt_timer,
 	.init_machine	= versatile_dt_init,
 	.dt_compat	= versatile_dt_match,
 MACHINE_END
-- 
1.7.5.4

