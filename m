Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754445Ab1LLWDQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 17:03:16 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:55086 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754339Ab1LLWC1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 17:02:27 -0500
From: Grant Likely <grant.likely@secretlab.ca>
To: linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Cc: Mike Turquette <mturquette@ti.com>, Sascha Hauer <kernel@pengutronix.de>,
        Rob Herring <rob.herring@calxeda.com>,
        Shawn Guo <shawn.guo@freescale.com>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: [RFC v2 9/9] arm/highbank: Use clock binding common support code
Date: Mon, 12 Dec 2011 15:02:09 -0700
Message-Id: <1323727329-4989-9-git-send-email-grant.likely@secretlab.ca>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1323727329-4989-1-git-send-email-grant.likely@secretlab.ca>
References: <1323727329-4989-1-git-send-email-grant.likely@secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the Calxeda Highbank platform use the common DT clock
binding support code for setting up timers and fixed clocks.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
Cc: Rob Herring <rob.herring@calxeda.com>
---
 arch/arm/Kconfig                             |    1 +
 arch/arm/boot/dts/highbank.dts               |   32 ++++++++++++++++++++++++-
 arch/arm/mach-highbank/clock.c               |   19 ---------------
 arch/arm/mach-highbank/core.h                |    1 -
 arch/arm/mach-highbank/highbank.c            |   13 +---------
 arch/arm/mach-highbank/include/mach/clkdev.h |   11 +++++++++
 6 files changed, 44 insertions(+), 33 deletions(-)
 create mode 100644 arch/arm/mach-highbank/include/mach/clkdev.h

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index e084b7e..33c2958 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -341,6 +341,7 @@ config ARCH_HIGHBANK
 	select ARM_GIC
 	select ARM_TIMER_SP804
 	select CLKDEV_LOOKUP
+	select HAVE_MACH_CLKDEV
 	select CPU_V7
 	select GENERIC_CLOCKEVENTS
 	select HAVE_ARM_SCU
diff --git a/arch/arm/boot/dts/highbank.dts b/arch/arm/boot/dts/highbank.dts
index aeb1a75..a60e41d 100644
--- a/arch/arm/boot/dts/highbank.dts
+++ b/arch/arm/boot/dts/highbank.dts
@@ -25,6 +25,10 @@
 	#address-cells = <1>;
 	#size-cells = <1>;
 
+	clocks = <&pclk>;
+	clock-names = "apb_pclk";
+	clock-ranges;
+
 	cpus {
 		#address-cells = <1>;
 		#size-cells = <0>;
@@ -54,6 +58,20 @@
 		};
 	};
 
+	clocks {
+		eclk: eclk {
+			compatible = "fixed-clock";
+			#clock-cells = <0>;
+			clock-frequency = <200000000>;
+		};
+
+		pclk: pclk {
+			compatible = "fixed-clock";
+			#clock-cells = <0>;
+			clock-frequency = <150000000>;
+		};
+	};
+
 	memory {
 		name = "memory";
 		device_type = "memory";
@@ -70,6 +88,7 @@
 		compatible = "simple-bus";
 		interrupt-parent = <&intc>;
 		ranges;
+		clock-ranges;
 
 		timer@fff10600 {
 			compatible = "arm,smp-twd";
@@ -117,6 +136,7 @@
 			compatible = "calxeda,hb-sdhci";
 			reg = <0xffe0e000 0x1000>;
 			interrupts = <0 90 4>;
+			clocks = <&eclk>;
 		};
 
 		ipc@fff20000 {
@@ -157,10 +177,18 @@
 			interrupts = <0 17 4>;
 		};
 
-		timer {
+		timer@fff34000 {
+			compatible = "arm,sp804", "arm,primecell";
+			reg = <0xfff34000 0x20>;
+			interrupts = <0 18 4>;
+			linux,clockevents-device;
+		};
+
+		timer@fff34020 {
 			compatible = "arm,sp804", "arm,primecell";
-			reg = <0xfff34000 0x1000>;
+			reg = <0xfff34020 0x20>;
 			interrupts = <0 18 4>;
+			linux,clock-source;
 		};
 
 		rtc@fff35000 {
diff --git a/arch/arm/mach-highbank/clock.c b/arch/arm/mach-highbank/clock.c
index c25a2ae..96f4599 100644
--- a/arch/arm/mach-highbank/clock.c
+++ b/arch/arm/mach-highbank/clock.c
@@ -19,10 +19,6 @@
 #include <linux/clk.h>
 #include <linux/clkdev.h>
 
-struct clk {
-	unsigned long rate;
-};
-
 int clk_enable(struct clk *clk)
 {
 	return 0;
@@ -45,18 +41,3 @@ int clk_set_rate(struct clk *clk, unsigned long rate)
 {
 	return 0;
 }
-
-static struct clk eclk = { .rate = 200000000 };
-static struct clk pclk = { .rate = 150000000 };
-
-static struct clk_lookup lookups[] = {
-	{ .clk = &pclk, .con_id = "apb_pclk", },
-	{ .clk = &pclk, .dev_id = "sp804", },
-	{ .clk = &eclk, .dev_id = "ffe0e000.sdhci", },
-	{ .clk = &pclk, .dev_id = "fff36000.serial", },
-};
-
-void __init highbank_clocks_init(void)
-{
-	clkdev_add_table(lookups, ARRAY_SIZE(lookups));
-}
diff --git a/arch/arm/mach-highbank/core.h b/arch/arm/mach-highbank/core.h
index 7e33fc9..490f430 100644
--- a/arch/arm/mach-highbank/core.h
+++ b/arch/arm/mach-highbank/core.h
@@ -1,5 +1,4 @@
 extern void highbank_set_cpu_jump(int cpu, void *jump_addr);
-extern void highbank_clocks_init(void);
 extern void __iomem *scu_base_addr;
 #ifdef CONFIG_DEBUG_HIGHBANK_UART
 extern void highbank_lluart_map_io(void);
diff --git a/arch/arm/mach-highbank/highbank.c b/arch/arm/mach-highbank/highbank.c
index 88660d5..13a3b15 100644
--- a/arch/arm/mach-highbank/highbank.c
+++ b/arch/arm/mach-highbank/highbank.c
@@ -95,24 +95,15 @@ static void __init highbank_init_irq(void)
 
 static void __init highbank_timer_init(void)
 {
-	int irq;
 	struct device_node *np;
-	void __iomem *timer_base;
 
 	/* Map system registers */
 	np = of_find_compatible_node(NULL, NULL, "calxeda,hb-sregs");
 	sregs_base = of_iomap(np, 0);
 	WARN_ON(!sregs_base);
 
-	np = of_find_compatible_node(NULL, NULL, "arm,sp804");
-	timer_base = of_iomap(np, 0);
-	WARN_ON(!timer_base);
-	irq = irq_of_parse_and_map(np, 0);
-
-	highbank_clocks_init();
-
-	sp804_clocksource_init(timer_base + 0x20, "timer1");
-	sp804_clockevents_init(timer_base, irq, "timer0");
+	for_each_compatible_node(np, NULL, "arm,sp804")
+		sp804_dt_setup(np);
 }
 
 static struct sys_timer highbank_timer = {
diff --git a/arch/arm/mach-highbank/include/mach/clkdev.h b/arch/arm/mach-highbank/include/mach/clkdev.h
new file mode 100644
index 0000000..0fe8f0e
--- /dev/null
+++ b/arch/arm/mach-highbank/include/mach/clkdev.h
@@ -0,0 +1,11 @@
+#ifndef __ASM_MACH_CLKDEV_H
+#define __ASM_MACH_CLKDEV_H
+
+struct clk {
+	unsigned long rate;
+};
+
+#define __clk_get(clk)	({ 1; })
+#define __clk_put(clk)	do { } while (0)
+
+#endif
-- 
1.7.5.4

