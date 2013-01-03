Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753174Ab3ACDZd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 22:25:33 -0500
Received: from server.prisktech.co.nz ([115.188.14.127]:55481 "EHLO
	server.prisktech.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752865Ab3ACDZT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 22:25:19 -0500
From: Tony Prisk <linux@prisktech.co.nz>
To: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        vt8500-wm8505-linux-kernel@googlegroups.com,
        Tony Prisk <linux@prisktech.co.nz>, John Stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 1/2] timer: vt8500: Move system timer to clocksource
Date: Thu,  3 Jan 2013 16:25:09 +1300
Message-Id: <1357183510-8476-2-git-send-email-linux@prisktech.co.nz>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1357183510-8476-1-git-send-email-linux@prisktech.co.nz>
References: <1357183510-8476-1-git-send-email-linux@prisktech.co.nz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move mach-vt8500/timer.c to drivers/clocksource/vt8500_timer.c
and make necessary changes to Kconfig and Makefile.

vt8500_timer is moved from vt8500.c to clocksource/vt8500_timer.c
and added to common.h for reference from the board descriptor.

Signed-off-by: Tony Prisk <linux@prisktech.co.nz>
---
CC: John Stultz <johnstul@us.ibm.com>
CC: Thomas Gleixner <tglx@linutronix.de>

 arch/arm/mach-vt8500/Kconfig       |    1 +
 arch/arm/mach-vt8500/Makefile      |    2 +-
 arch/arm/mach-vt8500/common.h      |    5 +-
 arch/arm/mach-vt8500/timer.c       |  184 -----------------------------------
 arch/arm/mach-vt8500/vt8500.c      |    4 -
 drivers/clocksource/Kconfig        |    3 +
 drivers/clocksource/Makefile       |    1 +
 drivers/clocksource/vt8500_timer.c |  187 ++++++++++++++++++++++++++++++++++++
 8 files changed, 197 insertions(+), 190 deletions(-)
 delete mode 100644 arch/arm/mach-vt8500/timer.c
 create mode 100644 drivers/clocksource/vt8500_timer.c

diff --git a/arch/arm/mach-vt8500/Kconfig b/arch/arm/mach-vt8500/Kconfig
index 2ed0b7d..570a801 100644
--- a/arch/arm/mach-vt8500/Kconfig
+++ b/arch/arm/mach-vt8500/Kconfig
@@ -8,5 +8,6 @@ config ARCH_VT8500
 	select GENERIC_CLOCKEVENTS
 	select GENERIC_GPIO
 	select HAVE_CLK
+	select VT8500_TIMER
 	help
 	  Support for VIA/WonderMedia VT8500/WM85xx System-on-Chip.
diff --git a/arch/arm/mach-vt8500/Makefile b/arch/arm/mach-vt8500/Makefile
index e035251..92ceb24 100644
--- a/arch/arm/mach-vt8500/Makefile
+++ b/arch/arm/mach-vt8500/Makefile
@@ -1 +1 @@
-obj-$(CONFIG_ARCH_VT8500) += irq.o timer.o vt8500.o
+obj-$(CONFIG_ARCH_VT8500) += irq.o vt8500.o
diff --git a/arch/arm/mach-vt8500/common.h b/arch/arm/mach-vt8500/common.h
index 6f2b843..5d37a4f 100644
--- a/arch/arm/mach-vt8500/common.h
+++ b/arch/arm/mach-vt8500/common.h
@@ -18,7 +18,6 @@
 
 #include <linux/of.h>
 
-void __init vt8500_timer_init(void);
 int __init vt8500_irq_init(struct device_node *node,
 				struct device_node *parent);
 
@@ -28,4 +27,8 @@ void __init vtwm_clk_init(void __iomem *pmc_base);
 /* defined in irq.c */
 asmlinkage void vt8500_handle_irq(struct pt_regs *regs);
 
+/* defined in drivers/clocksource/vt8500_timer.c */
+extern struct sys_timer vt8500_timer;
+void __init vt8500_timer_init(void);
+
 #endif
diff --git a/arch/arm/mach-vt8500/timer.c b/arch/arm/mach-vt8500/timer.c
deleted file mode 100644
index 3dd21a4..0000000
--- a/arch/arm/mach-vt8500/timer.c
+++ /dev/null
@@ -1,184 +0,0 @@
-/*
- *  arch/arm/mach-vt8500/timer.c
- *
- *  Copyright (C) 2012 Tony Prisk <linux@prisktech.co.nz>
- *  Copyright (C) 2010 Alexey Charkov <alchark@gmail.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
- */
-
-/*
- * This file is copied and modified from the original timer.c provided by
- * Alexey Charkov. Minor changes have been made for Device Tree Support.
- */
-
-#include <linux/io.h>
-#include <linux/irq.h>
-#include <linux/interrupt.h>
-#include <linux/clocksource.h>
-#include <linux/clockchips.h>
-#include <linux/delay.h>
-#include <asm/mach/time.h>
-
-#include <linux/of.h>
-#include <linux/of_address.h>
-#include <linux/of_irq.h>
-
-#define VT8500_TIMER_OFFSET	0x0100
-#define VT8500_TIMER_HZ		3000000
-#define TIMER_MATCH_VAL		0x0000
-#define TIMER_COUNT_VAL		0x0010
-#define TIMER_STATUS_VAL	0x0014
-#define TIMER_IER_VAL		0x001c		/* interrupt enable */
-#define TIMER_CTRL_VAL		0x0020
-#define TIMER_AS_VAL		0x0024		/* access status */
-#define TIMER_COUNT_R_ACTIVE	(1 << 5)	/* not ready for read */
-#define TIMER_COUNT_W_ACTIVE	(1 << 4)	/* not ready for write */
-#define TIMER_MATCH_W_ACTIVE	(1 << 0)	/* not ready for write */
-
-#define msecs_to_loops(t) (loops_per_jiffy / 1000 * HZ * t)
-
-static void __iomem *regbase;
-
-static cycle_t vt8500_timer_read(struct clocksource *cs)
-{
-	int loops = msecs_to_loops(10);
-	writel(3, regbase + TIMER_CTRL_VAL);
-	while ((readl((regbase + TIMER_AS_VAL)) & TIMER_COUNT_R_ACTIVE)
-						&& --loops)
-		cpu_relax();
-	return readl(regbase + TIMER_COUNT_VAL);
-}
-
-static struct clocksource clocksource = {
-	.name           = "vt8500_timer",
-	.rating         = 200,
-	.read           = vt8500_timer_read,
-	.mask           = CLOCKSOURCE_MASK(32),
-	.flags          = CLOCK_SOURCE_IS_CONTINUOUS,
-};
-
-static int vt8500_timer_set_next_event(unsigned long cycles,
-				    struct clock_event_device *evt)
-{
-	int loops = msecs_to_loops(10);
-	cycle_t alarm = clocksource.read(&clocksource) + cycles;
-	while ((readl(regbase + TIMER_AS_VAL) & TIMER_MATCH_W_ACTIVE)
-						&& --loops)
-		cpu_relax();
-	writel((unsigned long)alarm, regbase + TIMER_MATCH_VAL);
-
-	if ((signed)(alarm - clocksource.read(&clocksource)) <= 16)
-		return -ETIME;
-
-	writel(1, regbase + TIMER_IER_VAL);
-
-	return 0;
-}
-
-static void vt8500_timer_set_mode(enum clock_event_mode mode,
-			      struct clock_event_device *evt)
-{
-	switch (mode) {
-	case CLOCK_EVT_MODE_RESUME:
-	case CLOCK_EVT_MODE_PERIODIC:
-		break;
-	case CLOCK_EVT_MODE_ONESHOT:
-	case CLOCK_EVT_MODE_UNUSED:
-	case CLOCK_EVT_MODE_SHUTDOWN:
-		writel(readl(regbase + TIMER_CTRL_VAL) | 1,
-			regbase + TIMER_CTRL_VAL);
-		writel(0, regbase + TIMER_IER_VAL);
-		break;
-	}
-}
-
-static struct clock_event_device clockevent = {
-	.name           = "vt8500_timer",
-	.features       = CLOCK_EVT_FEAT_ONESHOT,
-	.rating         = 200,
-	.set_next_event = vt8500_timer_set_next_event,
-	.set_mode       = vt8500_timer_set_mode,
-};
-
-static irqreturn_t vt8500_timer_interrupt(int irq, void *dev_id)
-{
-	struct clock_event_device *evt = dev_id;
-	writel(0xf, regbase + TIMER_STATUS_VAL);
-	evt->event_handler(evt);
-
-	return IRQ_HANDLED;
-}
-
-static struct irqaction irq = {
-	.name    = "vt8500_timer",
-	.flags   = IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL,
-	.handler = vt8500_timer_interrupt,
-	.dev_id  = &clockevent,
-};
-
-static struct of_device_id vt8500_timer_ids[] = {
-	{ .compatible = "via,vt8500-timer" },
-	{ }
-};
-
-void __init vt8500_timer_init(void)
-{
-	struct device_node *np;
-	int timer_irq;
-
-	np = of_find_matching_node(NULL, vt8500_timer_ids);
-	if (!np) {
-		pr_err("%s: Timer description missing from Device Tree\n",
-								__func__);
-		return;
-	}
-	regbase = of_iomap(np, 0);
-	if (!regbase) {
-		pr_err("%s: Missing iobase description in Device Tree\n",
-								__func__);
-		of_node_put(np);
-		return;
-	}
-	timer_irq = irq_of_parse_and_map(np, 0);
-	if (!timer_irq) {
-		pr_err("%s: Missing irq description in Device Tree\n",
-								__func__);
-		of_node_put(np);
-		return;
-	}
-
-	writel(1, regbase + TIMER_CTRL_VAL);
-	writel(0xf, regbase + TIMER_STATUS_VAL);
-	writel(~0, regbase + TIMER_MATCH_VAL);
-
-	if (clocksource_register_hz(&clocksource, VT8500_TIMER_HZ))
-		pr_err("%s: vt8500_timer_init: clocksource_register failed for %s\n",
-					__func__, clocksource.name);
-
-	clockevents_calc_mult_shift(&clockevent, VT8500_TIMER_HZ, 4);
-
-	/* copy-pasted from mach-msm; no idea */
-	clockevent.max_delta_ns =
-		clockevent_delta2ns(0xf0000000, &clockevent);
-	clockevent.min_delta_ns = clockevent_delta2ns(4, &clockevent);
-	clockevent.cpumask = cpumask_of(0);
-
-	if (setup_irq(timer_irq, &irq))
-		pr_err("%s: setup_irq failed for %s\n", __func__,
-							clockevent.name);
-	clockevents_register_device(&clockevent);
-}
-
diff --git a/arch/arm/mach-vt8500/vt8500.c b/arch/arm/mach-vt8500/vt8500.c
index 3c66d48..ed1c02b 100644
--- a/arch/arm/mach-vt8500/vt8500.c
+++ b/arch/arm/mach-vt8500/vt8500.c
@@ -175,10 +175,6 @@ static void __init vt8500_init_irq(void)
 	of_irq_init(vt8500_irq_match);
 };
 
-static struct sys_timer vt8500_timer = {
-	.init = vt8500_timer_init,
-};
-
 static const char * const vt8500_dt_compat[] = {
 	"via,vt8500",
 	"wm,wm8650",
diff --git a/drivers/clocksource/Kconfig b/drivers/clocksource/Kconfig
index 7fdcbd3..67883ce 100644
--- a/drivers/clocksource/Kconfig
+++ b/drivers/clocksource/Kconfig
@@ -25,6 +25,9 @@ config ARMADA_370_XP_TIMER
 config SUNXI_TIMER
 	bool
 
+config VT8500_TIMER
+	bool
+
 config CLKSRC_NOMADIK_MTU
 	bool
 	depends on (ARCH_NOMADIK || ARCH_U8500)
diff --git a/drivers/clocksource/Makefile b/drivers/clocksource/Makefile
index f93453d..c778d01 100644
--- a/drivers/clocksource/Makefile
+++ b/drivers/clocksource/Makefile
@@ -16,5 +16,6 @@ obj-$(CONFIG_CLKSRC_DBX500_PRCMU)	+= clksrc-dbx500-prcmu.o
 obj-$(CONFIG_ARMADA_370_XP_TIMER)	+= time-armada-370-xp.o
 obj-$(CONFIG_ARCH_BCM2835)	+= bcm2835_timer.o
 obj-$(CONFIG_SUNXI_TIMER)	+= sunxi_timer.o
+obj-$(CONFIG_VT8500_TIMER)	+= vt8500_timer.o
 
 obj-$(CONFIG_CLKSRC_ARM_GENERIC)	+= arm_generic.o
diff --git a/drivers/clocksource/vt8500_timer.c b/drivers/clocksource/vt8500_timer.c
new file mode 100644
index 0000000..acb565a
--- /dev/null
+++ b/drivers/clocksource/vt8500_timer.c
@@ -0,0 +1,187 @@
+/*
+ *  arch/arm/mach-vt8500/timer.c
+ *
+ *  Copyright (C) 2012 Tony Prisk <linux@prisktech.co.nz>
+ *  Copyright (C) 2010 Alexey Charkov <alchark@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+
+/*
+ * This file is copied and modified from the original timer.c provided by
+ * Alexey Charkov. Minor changes have been made for Device Tree Support.
+ */
+
+#include <linux/io.h>
+#include <linux/irq.h>
+#include <linux/interrupt.h>
+#include <linux/clocksource.h>
+#include <linux/clockchips.h>
+#include <linux/delay.h>
+#include <asm/mach/time.h>
+
+#include <linux/of.h>
+#include <linux/of_address.h>
+#include <linux/of_irq.h>
+
+#define VT8500_TIMER_OFFSET	0x0100
+#define VT8500_TIMER_HZ		3000000
+#define TIMER_MATCH_VAL		0x0000
+#define TIMER_COUNT_VAL		0x0010
+#define TIMER_STATUS_VAL	0x0014
+#define TIMER_IER_VAL		0x001c		/* interrupt enable */
+#define TIMER_CTRL_VAL		0x0020
+#define TIMER_AS_VAL		0x0024		/* access status */
+#define TIMER_COUNT_R_ACTIVE	(1 << 5)	/* not ready for read */
+#define TIMER_COUNT_W_ACTIVE	(1 << 4)	/* not ready for write */
+#define TIMER_MATCH_W_ACTIVE	(1 << 0)	/* not ready for write */
+
+#define msecs_to_loops(t) (loops_per_jiffy / 1000 * HZ * t)
+
+static void __iomem *regbase;
+
+static cycle_t vt8500_timer_read(struct clocksource *cs)
+{
+	int loops = msecs_to_loops(10);
+	writel(3, regbase + TIMER_CTRL_VAL);
+	while ((readl((regbase + TIMER_AS_VAL)) & TIMER_COUNT_R_ACTIVE)
+						&& --loops)
+		cpu_relax();
+	return readl(regbase + TIMER_COUNT_VAL);
+}
+
+static struct clocksource clocksource = {
+	.name           = "vt8500_timer",
+	.rating         = 200,
+	.read           = vt8500_timer_read,
+	.mask           = CLOCKSOURCE_MASK(32),
+	.flags          = CLOCK_SOURCE_IS_CONTINUOUS,
+};
+
+static int vt8500_timer_set_next_event(unsigned long cycles,
+				    struct clock_event_device *evt)
+{
+	int loops = msecs_to_loops(10);
+	cycle_t alarm = clocksource.read(&clocksource) + cycles;
+	while ((readl(regbase + TIMER_AS_VAL) & TIMER_MATCH_W_ACTIVE)
+						&& --loops)
+		cpu_relax();
+	writel((unsigned long)alarm, regbase + TIMER_MATCH_VAL);
+
+	if ((signed)(alarm - clocksource.read(&clocksource)) <= 16)
+		return -ETIME;
+
+	writel(1, regbase + TIMER_IER_VAL);
+
+	return 0;
+}
+
+static void vt8500_timer_set_mode(enum clock_event_mode mode,
+			      struct clock_event_device *evt)
+{
+	switch (mode) {
+	case CLOCK_EVT_MODE_RESUME:
+	case CLOCK_EVT_MODE_PERIODIC:
+		break;
+	case CLOCK_EVT_MODE_ONESHOT:
+	case CLOCK_EVT_MODE_UNUSED:
+	case CLOCK_EVT_MODE_SHUTDOWN:
+		writel(readl(regbase + TIMER_CTRL_VAL) | 1,
+			regbase + TIMER_CTRL_VAL);
+		writel(0, regbase + TIMER_IER_VAL);
+		break;
+	}
+}
+
+static struct clock_event_device clockevent = {
+	.name           = "vt8500_timer",
+	.features       = CLOCK_EVT_FEAT_ONESHOT,
+	.rating         = 200,
+	.set_next_event = vt8500_timer_set_next_event,
+	.set_mode       = vt8500_timer_set_mode,
+};
+
+static irqreturn_t vt8500_timer_interrupt(int irq, void *dev_id)
+{
+	struct clock_event_device *evt = dev_id;
+	writel(0xf, regbase + TIMER_STATUS_VAL);
+	evt->event_handler(evt);
+
+	return IRQ_HANDLED;
+}
+
+static struct irqaction irq = {
+	.name    = "vt8500_timer",
+	.flags   = IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL,
+	.handler = vt8500_timer_interrupt,
+	.dev_id  = &clockevent,
+};
+
+static struct of_device_id vt8500_timer_ids[] = {
+	{ .compatible = "via,vt8500-timer" },
+	{ }
+};
+
+static void __init vt8500_timer_init(void)
+{
+	struct device_node *np;
+	int timer_irq;
+
+	np = of_find_matching_node(NULL, vt8500_timer_ids);
+	if (!np) {
+		pr_err("%s: Timer description missing from Device Tree\n",
+								__func__);
+		return;
+	}
+	regbase = of_iomap(np, 0);
+	if (!regbase) {
+		pr_err("%s: Missing iobase description in Device Tree\n",
+								__func__);
+		of_node_put(np);
+		return;
+	}
+	timer_irq = irq_of_parse_and_map(np, 0);
+	if (!timer_irq) {
+		pr_err("%s: Missing irq description in Device Tree\n",
+								__func__);
+		of_node_put(np);
+		return;
+	}
+
+	writel(1, regbase + TIMER_CTRL_VAL);
+	writel(0xf, regbase + TIMER_STATUS_VAL);
+	writel(~0, regbase + TIMER_MATCH_VAL);
+
+	if (clocksource_register_hz(&clocksource, VT8500_TIMER_HZ))
+		pr_err("%s: vt8500_timer_init: clocksource_register failed for %s\n",
+					__func__, clocksource.name);
+
+	clockevents_calc_mult_shift(&clockevent, VT8500_TIMER_HZ, 4);
+
+	/* copy-pasted from mach-msm; no idea */
+	clockevent.max_delta_ns =
+		clockevent_delta2ns(0xf0000000, &clockevent);
+	clockevent.min_delta_ns = clockevent_delta2ns(4, &clockevent);
+	clockevent.cpumask = cpumask_of(0);
+
+	if (setup_irq(timer_irq, &irq))
+		pr_err("%s: setup_irq failed for %s\n", __func__,
+							clockevent.name);
+	clockevents_register_device(&clockevent);
+}
+
+struct sys_timer vt8500_timer = {
+	.init = vt8500_timer_init,
+};
-- 
1.7.9.5

