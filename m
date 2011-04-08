Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932164Ab1DHOeF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 10:34:05 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:32832 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757190Ab1DHOdv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 10:33:51 -0400
From: Jamie Iles <jamie@jamieiles.com>
To: linux-kernel@vger.kernel.org
Cc: johnstul@us.ibm.com, tglx@linutronix.de, jacob.jun.pan@linux.intel.com,
        Jamie Iles <jamie@jamieiles.com>
Subject: [PATCHv2 2/2] clocksource: platform driver for APB timers
Date: Fri,  8 Apr 2011 15:33:38 +0100
Message-Id: <1302273218-7263-3-git-send-email-jamie@jamieiles.com>
X-Mailer: git-send-email 1.7.4.2
In-Reply-To: <1302273218-7263-1-git-send-email-jamie@jamieiles.com>
References: <1302273218-7263-1-git-send-email-jamie@jamieiles.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a platform driver for the APB timers that can be used for embedded
systems such as ARM SoC.  This uses early_platform so that the timers
can be used early in the boot sequence.

Cc: John Stultz <johnstul@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Jamie Iles <jamie@jamieiles.com>
---
 drivers/clocksource/Kconfig                 |    5 +
 drivers/clocksource/Makefile                |    1 +
 drivers/clocksource/dw_apb_timer_platform.c |  173 +++++++++++++++++++++++++++
 3 files changed, 179 insertions(+), 0 deletions(-)
 create mode 100644 drivers/clocksource/dw_apb_timer_platform.c

diff --git a/drivers/clocksource/Kconfig b/drivers/clocksource/Kconfig
index 09081ab..fa53da8 100644
--- a/drivers/clocksource/Kconfig
+++ b/drivers/clocksource/Kconfig
@@ -4,3 +4,8 @@
 
 config DW_APB_TIMER
 	bool
+
+config DW_APB_TIMER_PLATFORM
+	depends on HAVE_CLK
+	select DW_APB_TIMER
+	bool
diff --git a/drivers/clocksource/Makefile b/drivers/clocksource/Makefile
index c3785c3..9e2de99 100644
--- a/drivers/clocksource/Makefile
+++ b/drivers/clocksource/Makefile
@@ -7,3 +7,4 @@ obj-$(CONFIG_SH_TIMER_CMT)	+= sh_cmt.o
 obj-$(CONFIG_SH_TIMER_MTU2)	+= sh_mtu2.o
 obj-$(CONFIG_SH_TIMER_TMU)	+= sh_tmu.o
 obj-$(CONFIG_DW_APB_TIMER)	+= dw_apb_timer.o
+obj-$(CONFIG_DW_APB_TIMER_PLATFORM) += dw_apb_timer_platform.o
diff --git a/drivers/clocksource/dw_apb_timer_platform.c b/drivers/clocksource/dw_apb_timer_platform.c
new file mode 100644
index 0000000..22b5fcd
--- /dev/null
+++ b/drivers/clocksource/dw_apb_timer_platform.c
@@ -0,0 +1,173 @@
+/*
+ * Copyright (c) 2011 Picochip Ltd., Jamie Iles
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * Platform driver support for Synopsys DesignWare APB timers.
+ */
+#include <linux/clk.h>
+#include <linux/dw_apb_timer.h>
+#include <linux/err.h>
+#include <linux/clockchips.h>
+#include <linux/clocksource.h>
+#include <linux/interrupt.h>
+#include <linux/io.h>
+#include <linux/irq.h>
+#include <linux/platform_device.h>
+#include <linux/slab.h>
+
+static int dw_apb_event_probe(struct platform_device *pdev, int irq)
+{
+	int err;
+	struct resource *mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	struct dw_apb_clock_event_device *dwclk;
+	void __iomem *base;
+	struct clk *clk;
+
+	if (!request_mem_region(mem->start, resource_size(mem),
+				"dw_apb_timer"))
+		return -ENOMEM;
+
+	base = ioremap(mem->start, resource_size(mem));
+	if (!base) {
+		dev_err(&pdev->dev, "failed to remap i/o memory\n");
+		err = -ENOMEM;
+		goto out_release_mem;
+	}
+
+	clk = clk_get(&pdev->dev, NULL);
+	if (IS_ERR(clk)) {
+		dev_err(&pdev->dev, "no clk\n");
+		err = PTR_ERR(clk);
+		goto out_unmap;
+	}
+
+	err = clk_enable(clk);
+	if (err) {
+		dev_err(&pdev->dev, "failed to enable clk\n");
+		goto out_put_clk;
+	}
+
+	dwclk = dw_apb_clockevent_init(0, "dw_apb_timer_plat0", 300, base,
+				       irq, clk_get_rate(clk));
+	if (!dwclk) {
+		err = -ENODEV;
+		goto out_disable_clk;
+	}
+
+	dw_apb_clockevent_register(dwclk);
+
+	return 0;
+
+out_disable_clk:
+	clk_disable(clk);
+out_put_clk:
+	clk_put(clk);
+out_unmap:
+	iounmap(base);
+out_release_mem:
+	release_mem_region(mem->start, resource_size(mem));
+
+	return err;
+}
+
+static int dw_apb_source_probe(struct platform_device *pdev)
+{
+	struct resource *mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	int err;
+	void __iomem *base;
+	struct clk *clk;
+	struct dw_apb_clocksource *dwclk;
+
+	if (!request_mem_region(mem->start, resource_size(mem),
+				"dw_apb_timer"))
+		return -ENOMEM;
+
+	base = ioremap(mem->start, resource_size(mem));
+	if (!base) {
+		dev_err(&pdev->dev, "failed to remap i/o memory\n");
+		err = -ENOMEM;
+		goto out_release_mem;
+	}
+
+	clk = clk_get(&pdev->dev, NULL);
+	if (IS_ERR(clk)) {
+		dev_err(&pdev->dev, "no clk\n");
+		err = PTR_ERR(clk);
+		goto out_unmap;
+	}
+
+	err = clk_enable(clk);
+	if (err) {
+		dev_err(&pdev->dev, "failed to enable clk\n");
+		goto out_put_clk;
+	}
+
+	dwclk = dw_apb_clocksource_init(300, "dw_apb_plat0", base,
+					clk_get_rate(clk));
+	if (!dwclk) {
+		err = -ENODEV;
+		goto out_disable_clk;
+	}
+	dw_apb_clocksource_start(dwclk);
+	dw_apb_clocksource_register(dwclk);
+
+	return 0;
+
+out_disable_clk:
+	clk_disable(clk);
+out_put_clk:
+	clk_put(clk);
+out_unmap:
+	iounmap(base);
+out_release_mem:
+	release_mem_region(mem->start, resource_size(mem));
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
1.7.4.2

