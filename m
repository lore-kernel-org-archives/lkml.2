Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758242Ab1CaPM7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 11:12:59 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:39765 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757842Ab1CaPM6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 11:12:58 -0400
From: Jamie Iles <jamie@jamieiles.com>
To: linux-kernel@vger.kernel.org
Cc: Jamie Iles <jamie@jamieiles.com>, John Stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH] clocksource: clocksource/clockevent driver for Synopsys dw_apb_timer
Date: Thu, 31 Mar 2011 16:12:52 +0100
Message-Id: <1301584372-26261-1-git-send-email-jamie@jamieiles.com>
X-Mailer: git-send-email 1.7.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a driver for the Synopsys DesignWare APB timer block
found in some ARM systems.  This uses the timers with an IRQ as a
clockevents device and a timer without an IRQ as a clocksource
device.

Cc: John Stultz <johnstul@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Jamie Iles <jamie@jamieiles.com>
---
 arch/arm/Kconfig             |    3 +
 drivers/clocksource/Makefile |    1 +
 drivers/clocksource/dw_apb.c |  298 ++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 302 insertions(+), 0 deletions(-)
 create mode 100644 drivers/clocksource/dw_apb.c

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 7c0effb..8988034 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -1316,6 +1316,9 @@ menu "Kernel Features"
 
 source "kernel/time/Kconfig"
 
+config DWAPB_TIMER
+	bool
+
 config SMP
 	bool "Symmetric Multi-Processing (EXPERIMENTAL)"
 	depends on EXPERIMENTAL
diff --git a/drivers/clocksource/Makefile b/drivers/clocksource/Makefile
index be61ece..5961052 100644
--- a/drivers/clocksource/Makefile
+++ b/drivers/clocksource/Makefile
@@ -6,3 +6,4 @@ obj-$(CONFIG_CS5535_CLOCK_EVENT_SRC)	+= cs5535-clockevt.o
 obj-$(CONFIG_SH_TIMER_CMT)	+= sh_cmt.o
 obj-$(CONFIG_SH_TIMER_MTU2)	+= sh_mtu2.o
 obj-$(CONFIG_SH_TIMER_TMU)	+= sh_tmu.o
+obj-$(CONFIG_DWAPB_TIMER)	+= dw_apb.o
diff --git a/drivers/clocksource/dw_apb.c b/drivers/clocksource/dw_apb.c
new file mode 100644
index 0000000..776eb34
--- /dev/null
+++ b/drivers/clocksource/dw_apb.c
@@ -0,0 +1,298 @@
+/*
+ * Copyright (c) 2011 Picochip Ltd., Jamie Iles
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * Support for the Synopsys DesignWare APB Timers.
+ */
+#include <linux/clk.h>
+#include <linux/err.h>
+#include <linux/clockchips.h>
+#include <linux/clocksource.h>
+#include <linux/interrupt.h>
+#include <linux/io.h>
+#include <linux/irq.h>
+#include <linux/platform_device.h>
+#include <linux/slab.h>
+
+#define DW_APB_TIMER_LOAD_COUNT_REG_OFFSET	0x00
+#define DW_APB_TIMER_CURRENT_VAL_REG_OFFSET	0x04
+#define DW_APB_TIMER_CONTROL_REG_OFFSET		0x08
+#define DW_APB_TIMER_EOI_REG_OFFSET		0x0c
+#define DW_APB_TIMER_ENABLE			0x00000001
+#define DW_APB_TIMER_MODE			0x00000002
+#define DW_APB_TIMER_INTERRUPT_MASK		0x00000004
+#define DW_APB_TIMER_MIN_RANGE			4
+
+struct dw_apb_event_device {
+	struct clock_event_device	dev;
+	void __iomem			*base;
+	struct clk			*clk;
+	struct irqaction		irqaction;
+};
+
+struct dw_apb_source_device {
+	struct clocksource		dev;
+	void __iomem			*base;
+	struct clk			*clk;
+};
+
+static inline struct dw_apb_source_device *
+to_dw_apb_source_device(struct clocksource *dev)
+{
+	return container_of(dev, struct dw_apb_source_device, dev);
+}
+
+static inline struct dw_apb_event_device *
+to_dw_apb_event_device(struct clock_event_device *dev)
+{
+	return container_of(dev, struct dw_apb_event_device, dev);
+}
+
+static void dw_apb_timer_set_mode(enum clock_event_mode mode,
+				  struct clock_event_device *clk)
+{
+	struct dw_apb_event_device *dwclk = to_dw_apb_event_device(clk);
+	unsigned long load_count = DIV_ROUND_UP(clk_get_rate(dwclk->clk), HZ);
+
+	switch (mode) {
+	case CLOCK_EVT_MODE_PERIODIC:
+		/*
+		 * By default, use the kernel tick rate. The reload value can
+		 * be changed with the timer_set_next_event() function.
+		 */
+		writel(load_count,
+		       dwclk->base + DW_APB_TIMER_LOAD_COUNT_REG_OFFSET);
+		writel(DW_APB_TIMER_ENABLE | DW_APB_TIMER_MODE,
+		       dwclk->base + DW_APB_TIMER_CONTROL_REG_OFFSET);
+		break;
+
+	case CLOCK_EVT_MODE_ONESHOT:
+	case CLOCK_EVT_MODE_UNUSED:
+	case CLOCK_EVT_MODE_SHUTDOWN:
+	default:
+		writel(0, dwclk->base + DW_APB_TIMER_CONTROL_REG_OFFSET);
+		break;
+	}
+}
+
+static int dw_apb_timer_set_next_event(unsigned long evt,
+				       struct clock_event_device *clk)
+{
+	struct dw_apb_event_device *dwclk = to_dw_apb_event_device(clk);
+
+	writel(0, dwclk->base + DW_APB_TIMER_CONTROL_REG_OFFSET);
+	writel(evt, dwclk->base + DW_APB_TIMER_LOAD_COUNT_REG_OFFSET);
+	writel(DW_APB_TIMER_ENABLE | DW_APB_TIMER_MODE,
+	       dwclk->base + DW_APB_TIMER_CONTROL_REG_OFFSET);
+
+	return 0;
+}
+
+static irqreturn_t dw_apb_event_irq(int irq, void *dev_id)
+{
+	struct dw_apb_event_device *dwclk = to_dw_apb_event_device(dev_id);
+
+	readl(dwclk->base + DW_APB_TIMER_EOI_REG_OFFSET);
+	dwclk->dev.event_handler(&dwclk->dev);
+
+	return IRQ_HANDLED;
+}
+
+static int dw_apb_event_probe(struct platform_device *pdev, int irq)
+{
+	int err;
+	struct resource *mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	struct dw_apb_event_device *dwclk = kzalloc(sizeof(*dwclk), GFP_KERNEL);
+
+	if (!dwclk)
+		return -ENOMEM;
+
+	if (!request_mem_region(mem->start, resource_size(mem),
+				"dw_apb_timer")) {
+		err = -ENOMEM;
+		goto out_free;
+	}
+
+	dwclk->base = ioremap(mem->start, resource_size(mem));
+	if (!dwclk->base) {
+		dev_err(&pdev->dev, "failed to remap i/o memory\n");
+		err = -ENOMEM;
+		goto out_release_mem;
+	}
+
+	dwclk->clk = clk_get(&pdev->dev, NULL);
+	if (IS_ERR(dwclk->clk)) {
+		dev_err(&pdev->dev, "no clk\n");
+		err = PTR_ERR(dwclk->clk);
+		goto out_unmap;
+	}
+
+	err = clk_enable(dwclk->clk);
+	if (err) {
+		dev_err(&pdev->dev, "failed to enable clk\n");
+		goto out_put_clk;
+	}
+
+	if (irq < 0) {
+		dev_err(&pdev->dev, "no IRQ for timer\n");
+		err = irq;
+		goto out_disable_clk;
+	}
+	clockevents_calc_mult_shift(&dwclk->dev, CLOCK_TICK_RATE,
+				    DW_APB_TIMER_MIN_RANGE);
+	dwclk->dev.max_delta_ns		= clockevent_delta2ns(0xfffffffe,
+							      &dwclk->dev);
+	dwclk->dev.min_delta_ns		= 50000;
+	dwclk->dev.cpumask		= cpumask_of(0);
+	dwclk->dev.features		= CLOCK_EVT_FEAT_PERIODIC |
+					  CLOCK_EVT_FEAT_ONESHOT,
+	dwclk->dev.set_next_event	= dw_apb_timer_set_next_event,
+	dwclk->dev.set_mode		= dw_apb_timer_set_mode,
+	dwclk->dev.name			= "dw_apb_timer";
+
+	/* Start with the timer disabled and the interrupt enabled. */
+	writel(0, dwclk->base + DW_APB_TIMER_CONTROL_REG_OFFSET);
+
+	dwclk->irqaction.name		= dev_name(&pdev->dev);
+	dwclk->irqaction.handler	= dw_apb_event_irq;
+	dwclk->irqaction.dev_id		= dwclk;
+	dwclk->irqaction.irq		= irq;
+	dwclk->irqaction.flags		= IRQF_TIMER | IRQF_IRQPOLL |
+					  IRQF_NOBALANCING;
+	err = setup_irq(dwclk->irqaction.irq, &dwclk->irqaction);
+	if (err) {
+		dev_err(&pdev->dev, "failed to request timer irq\n");
+		goto out_disable_clk;
+	}
+
+	clockevents_register_device(&dwclk->dev);
+
+	return 0;
+
+out_disable_clk:
+	clk_disable(dwclk->clk);
+out_put_clk:
+	clk_put(dwclk->clk);
+out_unmap:
+	iounmap(dwclk->base);
+out_release_mem:
+	release_mem_region(mem->start, resource_size(mem));
+out_free:
+	kfree(dwclk);
+
+	return err;
+}
+
+static cycle_t dw_apb_source_read(struct clocksource *cs)
+{
+	struct dw_apb_source_device *dwclk = to_dw_apb_source_device(cs);
+
+	return ~readl(dwclk->base + DW_APB_TIMER_CURRENT_VAL_REG_OFFSET);
+}
+
+static int dw_apb_source_probe(struct platform_device *pdev)
+{
+	struct resource *mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	int err;
+	struct dw_apb_source_device *dwclk = kzalloc(sizeof(*dwclk),
+						     GFP_KERNEL);
+
+	if (!dwclk)
+		return -ENOMEM;
+
+	if (!request_mem_region(mem->start, resource_size(mem),
+				"dw_apb_timer")) {
+		err = -ENOMEM;
+		goto out_free;
+	}
+
+	dwclk->base = ioremap(mem->start, resource_size(mem));
+	if (!dwclk->base) {
+		dev_err(&pdev->dev, "failed to remap i/o memory\n");
+		err = -ENOMEM;
+		goto out_release_mem;
+	}
+
+	dwclk->clk = clk_get(&pdev->dev, NULL);
+	if (IS_ERR(dwclk->clk)) {
+		dev_err(&pdev->dev, "no clk\n");
+		err = PTR_ERR(dwclk->clk);
+		goto out_unmap;
+	}
+
+	err = clk_enable(dwclk->clk);
+	if (err) {
+		dev_err(&pdev->dev, "failed to enable clk\n");
+		goto out_put_clk;
+	}
+
+	dwclk->dev.read		= dw_apb_source_read;
+	dwclk->dev.name		= "dw_apb_timer";
+	dwclk->dev.rating	= 300;
+	dwclk->dev.mask		= CLOCKSOURCE_MASK(32);
+	dwclk->dev.flags	= CLOCK_SOURCE_IS_CONTINUOUS;
+	writel(~0, dwclk->base + DW_APB_TIMER_LOAD_COUNT_REG_OFFSET);
+	writel(DW_APB_TIMER_ENABLE,
+	       dwclk->base + DW_APB_TIMER_CONTROL_REG_OFFSET);
+	clocksource_register_hz(&dwclk->dev, clk_get_rate(dwclk->clk));
+
+	return 0;
+
+out_put_clk:
+	clk_put(dwclk->clk);
+out_unmap:
+	iounmap(dwclk->base);
+out_release_mem:
+	release_mem_region(mem->start, resource_size(mem));
+out_free:
+	kfree(dwclk);
+
+	return err;
+}
+
+static int __devinit dw_apb_timer_probe(struct platform_device *pdev)
+{
+	int irq = platform_get_irq(pdev, 0);
+
+	/*
+	 * If the timer has an interrupt defined then we use it as a
+	 * clockevents device otherwise we use it as a clocksource device.
+	 */
+	return irq >= 0 ? dw_apb_event_probe(pdev, irq) :
+		dw_apb_source_probe(pdev);
+}
+
+static int __devexit dw_apb_timer_remove(struct platform_device *pdev)
+{
+	return -EBUSY;
+}
+
+static struct platform_driver dw_apb_timer_driver = {
+	.probe		= dw_apb_timer_probe,
+	.remove		= __devexit_p(dw_apb_timer_remove),
+	.driver		= {
+		.owner	= THIS_MODULE,
+		.name	= "dw_apb_timer",
+	},
+};
+early_platform_init("earlytimer", &dw_apb_timer_driver);
+
+
+static int __init dw_apb_timers_init(void)
+{
+	return platform_driver_register(&dw_apb_timer_driver);
+}
+module_init(dw_apb_timers_init);
+
+static void __exit dw_apb_timers_exit(void)
+{
+	platform_driver_unregister(&dw_apb_timer_driver);
+}
+module_exit(dw_apb_timers_exit);
+
+MODULE_AUTHOR("Jamie Iles");
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("Timer driver for Synopsys DesignWare APB timers");
-- 
1.7.4

