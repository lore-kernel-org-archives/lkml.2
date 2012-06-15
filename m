Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753413Ab2FOHEK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 03:04:10 -0400
Received: from mail.df.lth.se ([194.47.250.12]:52003 "EHLO mail.df.lth.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751361Ab2FOHEE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 03:04:04 -0400
From: Linus Walleij <linus.walleij@linaro.org>
To: linux-arm-kernel@lists.infradead.org, arm@kernel.org,
        linux-kernel@vger.kernel.org
Cc: Russell King <linux@arm.linux.org.uk>, Mike Turquette <mturquette@ti.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 3/3 v2] ARM: integrator: convert to common clock
Date: Fri, 15 Jun 2012 09:04:01 +0200
Message-Id: <1339743841-27814-1-git-send-email-linus.walleij@linaro.org>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This converts the Integrator platform to use common clock
and the ICST driver. Since from this point not all ARM
reference platforms use the clock, we define
CONFIG_PLAT_VERSATILE_CLOCK and select it for all platforms
except the Integrator.

Open issue: I could not use the .init_early() field of the
machine descriptor to initialize the clocks, but had to
move them to .init_irq(), so presumably .init_early() is
so early that common clock is not up, and .init_machine()
is too late since it's needed for the clockevent/clocksource
initialization. Any suggestions on how to solve this is
very welcome.

Cc: Russell King <linux@arm.linux.org.uk>
Cc: Mike Turquette <mturquette@ti.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
ChangeLog v1->v2:
- Move the Integrator clock code down to the versatile subdir
  along with the ICST driver.
- Reflect changed name to _register for ICST clock
---
 arch/arm/Kconfig                               |    8 +-
 arch/arm/mach-integrator/core.c                |   45 ----------
 arch/arm/mach-integrator/include/mach/clkdev.h |   26 ------
 arch/arm/mach-integrator/integrator_ap.c       |    8 +-
 arch/arm/mach-integrator/integrator_cp.c       |   63 +-------------
 arch/arm/plat-versatile/Kconfig                |    3 +
 arch/arm/plat-versatile/Makefile               |    2 +-
 drivers/clk/versatile/Makefile                 |    1 +
 drivers/clk/versatile/clk-integrator.c         |  111 ++++++++++++++++++++++++
 include/linux/platform_data/clk-integrator.h   |    1 +
 10 files changed, 132 insertions(+), 136 deletions(-)
 delete mode 100644 arch/arm/mach-integrator/include/mach/clkdev.h
 create mode 100644 drivers/clk/versatile/clk-integrator.c
 create mode 100644 include/linux/platform_data/clk-integrator.h

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index b649c59..71ec01a 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -255,10 +255,11 @@ config ARCH_INTEGRATOR
 	bool "ARM Ltd. Integrator family"
 	select ARM_AMBA
 	select ARCH_HAS_CPUFREQ
-	select CLKDEV_LOOKUP
-	select HAVE_MACH_CLKDEV
+	select COMMON_CLK
+	select CLK_VERSATILE
 	select HAVE_TCM
 	select ICST
+	select CLK_ICST
 	select GENERIC_CLOCKEVENTS
 	select PLAT_VERSATILE
 	select PLAT_VERSATILE_FPGA_IRQ
@@ -278,6 +279,7 @@ config ARCH_REALVIEW
 	select GENERIC_CLOCKEVENTS
 	select ARCH_WANT_OPTIONAL_GPIOLIB
 	select PLAT_VERSATILE
+	select PLAT_VERSATILE_CLOCK
 	select PLAT_VERSATILE_CLCD
 	select ARM_TIMER_SP804
 	select GPIO_PL061 if GPIOLIB
@@ -295,6 +297,7 @@ config ARCH_VERSATILE
 	select GENERIC_CLOCKEVENTS
 	select ARCH_WANT_OPTIONAL_GPIOLIB
 	select PLAT_VERSATILE
+	select PLAT_VERSATILE_CLOCK
 	select PLAT_VERSATILE_CLCD
 	select PLAT_VERSATILE_FPGA_IRQ
 	select ARM_TIMER_SP804
@@ -314,6 +317,7 @@ config ARCH_VEXPRESS
 	select ICST
 	select NO_IOPORT
 	select PLAT_VERSATILE
+	select PLAT_VERSATILE_CLOCK
 	select PLAT_VERSATILE_CLCD
 	help
 	  This enables support for the ARM Ltd Versatile Express boards.
diff --git a/arch/arm/mach-integrator/core.c b/arch/arm/mach-integrator/core.c
index 2a20bba..ebf680b 100644
--- a/arch/arm/mach-integrator/core.c
+++ b/arch/arm/mach-integrator/core.c
@@ -21,7 +21,6 @@
 #include <linux/amba/bus.h>
 #include <linux/amba/serial.h>
 #include <linux/io.h>
-#include <linux/clkdev.h>
 
 #include <mach/hardware.h>
 #include <mach/platform.h>
@@ -61,50 +60,6 @@ static struct amba_device *amba_devs[] __initdata = {
 	&kmi1_device,
 };
 
-/*
- * These are fixed clocks.
- */
-static struct clk clk24mhz = {
-	.rate	= 24000000,
-};
-
-static struct clk uartclk = {
-	.rate	= 14745600,
-};
-
-static struct clk dummy_apb_pclk;
-
-static struct clk_lookup lookups[] = {
-	{	/* Bus clock */
-		.con_id		= "apb_pclk",
-		.clk		= &dummy_apb_pclk,
-	}, {
-		/* Integrator/AP timer frequency */
-		.dev_id		= "ap_timer",
-		.clk		= &clk24mhz,
-	}, {	/* UART0 */
-		.dev_id		= "uart0",
-		.clk		= &uartclk,
-	}, {	/* UART1 */
-		.dev_id		= "uart1",
-		.clk		= &uartclk,
-	}, {	/* KMI0 */
-		.dev_id		= "kmi0",
-		.clk		= &clk24mhz,
-	}, {	/* KMI1 */
-		.dev_id		= "kmi1",
-		.clk		= &clk24mhz,
-	}, {	/* MMCI - IntegratorCP */
-		.dev_id		= "mmci",
-		.clk		= &uartclk,
-	}
-};
-
-void __init integrator_init_early(void)
-{
-	clkdev_add_table(lookups, ARRAY_SIZE(lookups));
-}
-
 static int __init integrator_init(void)
 {
 	int i;
diff --git a/arch/arm/mach-integrator/include/mach/clkdev.h b/arch/arm/mach-integrator/include/mach/clkdev.h
deleted file mode 100644
index bfe0767..0000000
--- a/arch/arm/mach-integrator/include/mach/clkdev.h
+++ /dev/null
@@ -1,26 +0,0 @@
-#ifndef __ASM_MACH_CLKDEV_H
-#define __ASM_MACH_CLKDEV_H
-
-#include <linux/module.h>
-#include <plat/clock.h>
-
-struct clk {
-	unsigned long		rate;
-	const struct clk_ops	*ops;
-	struct module		*owner;
-	const struct icst_params *params;
-	void __iomem		*vcoreg;
-	void			*data;
-};
-
-static inline int __clk_get(struct clk *clk)
-{
-	return try_module_get(clk->owner);
-}
-
-static inline void __clk_put(struct clk *clk)
-{
-	module_put(clk->owner);
-}
-
-#endif
diff --git a/arch/arm/mach-integrator/integrator_ap.c b/arch/arm/mach-integrator/integrator_ap.c
index c857501..7b1055c 100644
--- a/arch/arm/mach-integrator/integrator_ap.c
+++ b/arch/arm/mach-integrator/integrator_ap.c
@@ -33,6 +33,7 @@
 #include <linux/io.h>
 #include <linux/mtd/physmap.h>
 #include <linux/clk.h>
+#include <linux/platform_data/clk-integrator.h>
 #include <video/vga.h>
 
 #include <mach/hardware.h>
@@ -174,6 +175,7 @@ static void __init ap_init_irq(void)
 
 	fpga_irq_init(VA_IC_BASE, "SC", IRQ_PIC_START,
 		-1, INTEGRATOR_SC_VALID_INT, NULL);
+	integrator_clk_init(false);
 }
 
 #ifdef CONFIG_PM
@@ -440,6 +442,10 @@ static void integrator_clockevent_init(unsigned long inrate)
 					0xffffU);
 }
 
+void __init ap_init_early(void)
+{
+}
+
 /*
  * Set up timer(s).
  */
@@ -471,7 +477,7 @@ MACHINE_START(INTEGRATOR, "ARM-Integrator")
 	.reserve	= integrator_reserve,
 	.map_io		= ap_map_io,
 	.nr_irqs	= NR_IRQS_INTEGRATOR_AP,
-	.init_early	= integrator_init_early,
+	.init_early	= ap_init_early,
 	.init_irq	= ap_init_irq,
 	.handle_irq	= fpga_handle_irq,
 	.timer		= &ap_timer,
diff --git a/arch/arm/mach-integrator/integrator_cp.c b/arch/arm/mach-integrator/integrator_cp.c
index a8c6480..82d5c83 100644
--- a/arch/arm/mach-integrator/integrator_cp.c
+++ b/arch/arm/mach-integrator/integrator_cp.c
@@ -21,8 +21,8 @@
 #include <linux/amba/mmci.h>
 #include <linux/io.h>
 #include <linux/gfp.h>
-#include <linux/clkdev.h>
 #include <linux/mtd/physmap.h>
+#include <linux/platform_data/clk-integrator.h>
 
 #include <mach/hardware.h>
 #include <mach/platform.h>
@@ -171,65 +171,10 @@ static void __init intcp_init_irq(void)
 
 	fpga_irq_init(INTCP_VA_SIC_BASE, "SIC", IRQ_SIC_START,
 		      IRQ_CP_CPPLDINT, sic_mask, NULL);
+	integrator_clk_init(true);
 }
 
 /*
- * Clock handling
- */
-#define CM_LOCK		(__io_address(INTEGRATOR_HDR_BASE)+INTEGRATOR_HDR_LOCK_OFFSET)
-#define CM_AUXOSC	(__io_address(INTEGRATOR_HDR_BASE)+0x1c)
-
-static const struct icst_params cp_auxvco_params = {
-	.ref		= 24000000,
-	.vco_max	= ICST525_VCO_MAX_5V,
-	.vco_min	= ICST525_VCO_MIN,
-	.vd_min 	= 8,
-	.vd_max 	= 263,
-	.rd_min 	= 3,
-	.rd_max 	= 65,
-	.s2div		= icst525_s2div,
-	.idx2s		= icst525_idx2s,
-};
-
-static void cp_auxvco_set(struct clk *clk, struct icst_vco vco)
-{
-	u32 val;
-
-	val = readl(clk->vcoreg) & ~0x7ffff;
-	val |= vco.v | (vco.r << 9) | (vco.s << 16);
-
-	writel(0xa05f, CM_LOCK);
-	writel(val, clk->vcoreg);
-	writel(0, CM_LOCK);
-}
-
-static const struct clk_ops cp_auxclk_ops = {
-	.round	= icst_clk_round,
-	.set	= icst_clk_set,
-	.setvco	= cp_auxvco_set,
-};
-
-static struct clk cp_auxclk = {
-	.ops	= &cp_auxclk_ops,
-	.params	= &cp_auxvco_params,
-	.vcoreg	= CM_AUXOSC,
-};
-
-static struct clk sp804_clk = {
-	.rate	= 1000000,
-};
-
-static struct clk_lookup cp_lookups[] = {
-	{	/* CLCD */
-		.dev_id		= "clcd",
-		.clk		= &cp_auxclk,
-	}, {	/* SP804 timers */
-		.dev_id		= "sp804",
-		.clk		= &sp804_clk,
-	},
-};
-
-/*
  * Flash handling.
  */
 static int intcp_flash_init(struct platform_device *dev)
@@ -406,10 +351,6 @@ static struct amba_device *amba_devs[] __initdata = {
 
 static void __init intcp_init_early(void)
 {
-	clkdev_add_table(cp_lookups, ARRAY_SIZE(cp_lookups));
-
-	integrator_init_early();
-
 #ifdef CONFIG_PLAT_VERSATILE_SCHED_CLOCK
 	versatile_sched_clock_init(REFCOUNTER, 24000000);
 #endif
diff --git a/arch/arm/plat-versatile/Kconfig b/arch/arm/plat-versatile/Kconfig
index 81ee7cc..8d5c10a 100644
--- a/arch/arm/plat-versatile/Kconfig
+++ b/arch/arm/plat-versatile/Kconfig
@@ -1,5 +1,8 @@
 if PLAT_VERSATILE
 
+config PLAT_VERSATILE_CLOCK
+	bool
+
 config PLAT_VERSATILE_CLCD
 	bool
 
diff --git a/arch/arm/plat-versatile/Makefile b/arch/arm/plat-versatile/Makefile
index a5cb194..272769a8 100644
--- a/arch/arm/plat-versatile/Makefile
+++ b/arch/arm/plat-versatile/Makefile
@@ -1,4 +1,4 @@
-obj-y	:= clock.o
+obj-$(CONFIG_PLAT_VERSATILE_CLOCK) += clock.o
 obj-$(CONFIG_PLAT_VERSATILE_CLCD) += clcd.o
 obj-$(CONFIG_PLAT_VERSATILE_FPGA_IRQ) += fpga-irq.o
 obj-$(CONFIG_PLAT_VERSATILE_LEDS) += leds.o
diff --git a/drivers/clk/versatile/Makefile b/drivers/clk/versatile/Makefile
index c70e18e..ac47173 100644
--- a/drivers/clk/versatile/Makefile
+++ b/drivers/clk/versatile/Makefile
@@ -1,2 +1,3 @@
 # Makefile for Versatile-specific clocks
 obj-$(CONFIG_CLK_ICST)		+= clk-icst.o
+obj-$(CONFIG_ARCH_INTEGRATOR)	+= clk-integrator.o
diff --git a/drivers/clk/versatile/clk-integrator.c b/drivers/clk/versatile/clk-integrator.c
new file mode 100644
index 0000000..a505392
--- /dev/null
+++ b/drivers/clk/versatile/clk-integrator.c
@@ -0,0 +1,111 @@
+#include <linux/clk.h>
+#include <linux/clkdev.h>
+#include <linux/err.h>
+#include <linux/io.h>
+#include <linux/clk-provider.h>
+
+#include <mach/hardware.h>
+#include <mach/platform.h>
+
+#include "clk-icst.h"
+
+/*
+ * Implementation of the ARM Integrator/AP and Integrator/CP clock tree.
+ * Inspired by portions of:
+ * plat-versatile/clock.c and plat-versatile/include/plat/clock.h
+ */
+#define CM_LOCK		(__io_address(INTEGRATOR_HDR_BASE)+INTEGRATOR_HDR_LOCK_OFFSET)
+#define CM_AUXOSC	(__io_address(INTEGRATOR_HDR_BASE)+0x1c)
+
+/**
+ * cp_auxvco_get() - get ICST VCO settings for the Integrator/CP
+ * @vco: ICST VCO parameters to update with hardware status
+ */
+static struct icst_vco cp_auxvco_get(void)
+{
+	u32 val;
+	struct icst_vco vco;
+
+	val = readl(CM_AUXOSC);
+	vco.v = val & 0x1ff;
+	vco.r = (val >> 9) & 0x7f;
+	vco.s = (val >> 16) & 03;
+	return vco;
+}
+
+/**
+ * cp_auxvco_set() - commit changes to Integrator/CP ICST VCO
+ * @vco: ICST VCO parameters to commit
+ */
+static void cp_auxvco_set(struct icst_vco vco)
+{
+	u32 val;
+
+	val = readl(CM_AUXOSC) & ~0x7ffff;
+	val |= vco.v | (vco.r << 9) | (vco.s << 16);
+
+	/* This magic unlocks the CM VCO so it can be controlled */
+	writel(0xa05f, CM_LOCK);
+	writel(val, CM_AUXOSC);
+	/* This locks the CM again */
+	writel(0, CM_LOCK);
+}
+
+static const struct icst_params cp_auxvco_params = {
+	.ref		= 24000000,
+	.vco_max	= ICST525_VCO_MAX_5V,
+	.vco_min	= ICST525_VCO_MIN,
+	.vd_min 	= 8,
+	.vd_max 	= 263,
+	.rd_min 	= 3,
+	.rd_max 	= 65,
+	.s2div		= icst525_s2div,
+	.idx2s		= icst525_idx2s,
+};
+
+static const struct clk_icst_desc __initdata cp_icst_desc = {
+	.params = &cp_auxvco_params,
+	.getvco = cp_auxvco_get,
+	.setvco = cp_auxvco_set,
+};
+
+/*
+ * integrator_clk_init() - set up the integrator clock tree
+ * @is_cp: pass true if it's the Integrator/CP else AP is assumed
+ */
+void __init integrator_clk_init(bool is_cp)
+{
+	struct clk *clk;
+
+	/* APB clock dummy */
+	clk = clk_register_fixed_rate(NULL, "apb_pclk", NULL, CLK_IS_ROOT, 0);
+	clk_register_clkdev(clk, "apb_pclk", NULL);
+
+	/* UART reference clock */
+	clk = clk_register_fixed_rate(NULL, "uartclk", NULL, CLK_IS_ROOT,
+				14745600);
+	clk_register_clkdev(clk, NULL, "uart0");
+	clk_register_clkdev(clk, NULL, "uart1");
+	if (is_cp)
+		clk_register_clkdev(clk, NULL, "mmci");
+
+	/* 24 MHz clock */
+	clk = clk_register_fixed_rate(NULL, "clk24mhz", NULL, CLK_IS_ROOT,
+				24000000);
+	clk_register_clkdev(clk, NULL, "kmi0");
+	clk_register_clkdev(clk, NULL, "kmi1");
+	if (!is_cp)
+		clk_register_clkdev(clk, NULL, "ap_timer");
+
+	if (!is_cp)
+		return;
+
+	/* 1 MHz clock */
+	clk = clk_register_fixed_rate(NULL, "clk1mhz", NULL, CLK_IS_ROOT,
+				1000000);
+	clk_register_clkdev(clk, NULL, "sp804");
+
+	/* ICST VCO clock used on the Integrator/CP CLCD */
+	clk = icst_clk_register(NULL, &cp_icst_desc);
+	clk_register_clkdev(clk, NULL, "clcd");
+}
diff --git a/include/linux/platform_data/clk-integrator.h b/include/linux/platform_data/clk-integrator.h
new file mode 100644
index 0000000..83fe9c2
--- /dev/null
+++ b/include/linux/platform_data/clk-integrator.h
@@ -0,0 +1 @@
+void integrator_clk_init(bool is_cp);
-- 
1.7.10.2

