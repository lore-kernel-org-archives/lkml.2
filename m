Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760875Ab1D3A6h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 20:58:37 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37724 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754619Ab1D3A6f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 20:58:35 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM mailing list <linux-pm@lists.linux-foundation.org>
Subject: [Update][RFC][PATCH 2/2] ARM / shmobile: Support for I/O power domains for SH7372 (v2)
Date: Sat, 30 Apr 2011 02:59:08 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.39-rc5+; KDE/4.6.0; x86_64; ; )
Cc: Greg KH <gregkh@suse.de>, LKML <linux-kernel@vger.kernel.org>,
        Kevin Hilman <khilman@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org
References: <201104290154.12966.rjw@sisk.pl> <201104290155.41434.rjw@sisk.pl>
In-Reply-To: <201104290155.41434.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201104300259.08477.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Use the generic power domains support introduced by the previous
patch to implement support for power domains on SH7372.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---

Hi,

This version of the patch has been modified to make it more
straightforward to add more power domains to SH7372 in the future.

Thanks,
Rafael

---
 arch/arm/mach-shmobile/Makefile              |    4 +
 arch/arm/mach-shmobile/board-mackerel.c      |    3 
 arch/arm/mach-shmobile/include/mach/sh7372.h |   16 ++++
 arch/arm/mach-shmobile/pm-sh7372.c           |   98 +++++++++++++++++++++++++++
 include/linux/platform_device.h              |   22 +++++-
 5 files changed, 142 insertions(+), 1 deletion(-)

Index: linux-2.6/arch/arm/mach-shmobile/board-mackerel.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-shmobile/board-mackerel.c
+++ linux-2.6/arch/arm/mach-shmobile/board-mackerel.c
@@ -1215,6 +1215,9 @@ static void __init mackerel_init(void)
 
 	platform_add_devices(mackerel_devices, ARRAY_SIZE(mackerel_devices));
 
+	sh7372_add_device_to_domain(SH7372_A4LC, &lcdc_device);
+	sh7372_add_device_to_domain(SH7372_A4LC, &hdmi_lcdc_device);
+
 	hdmi_init_pm_clock();
 }
 
Index: linux-2.6/arch/arm/mach-shmobile/pm-sh7372.c
===================================================================
--- /dev/null
+++ linux-2.6/arch/arm/mach-shmobile/pm-sh7372.c
@@ -0,0 +1,98 @@
+/*
+ * arch/arm/mach-shmobile/pm-sh7372.c
+ *
+ * Power domains support code for SH7372
+ *
+ * Copyright (C) 2011 Rafael J. Wysocki <rjw@sisk.pl>, Renesas Electronics Corp.
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License v2.  See the file "COPYING" in the main directory of this archive
+ * for more details.
+ */
+
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/io.h>
+#include <linux/pm_runtime.h>
+#include <linux/platform_device.h>
+
+#include <mach/sh7372.h>
+
+struct sh7372_domain_data {
+	unsigned int bit_shift;
+};
+
+#define SPDCR 0xe6180008
+#define SWUCR 0xe6180014
+#define PSTR 0xe6180080
+
+static int pd_power_down(struct dev_power_domain *domain)
+{
+	struct sh7372_domain_data *dd = domain->platform_data;
+	unsigned int mask = 1 << dd->bit_shift;
+
+	if (__raw_readl(PSTR) & mask) {
+		__raw_writel(mask, SPDCR);
+
+		while (__raw_readl(SPDCR) & mask) {}
+
+		pr_debug("sh7372 power domain down 0x%08x -> PSTR = 0x%08x\n",
+			 mask, __raw_readl(PSTR));
+	}
+
+	return 0;
+}
+
+static int pd_power_up(struct dev_power_domain *domain)
+{
+	struct sh7372_domain_data *dd = domain->platform_data;
+	unsigned int mask = 1 << dd->bit_shift;
+
+	if (!(__raw_readl(PSTR) & mask)) {
+		__raw_writel(mask, SWUCR);
+
+		while (__raw_readl(SWUCR) & mask) {}
+
+		pr_debug("sh7372 power domain up 0x%08x -> PSTR = 0x%08x\n",
+			 mask, __raw_readl(PSTR));
+	}
+
+	return 0;
+}
+
+static void sh7372_init_domain(struct generic_power_domain *domain,
+			       struct sh7372_domain_data *pdata)
+{
+	pm_genpd_init(domain, NULL, false);
+	add_platform_pm_sleep_ops(&domain->domain.ops);
+	domain->domain.platform_data = pdata;
+	domain->stop_device = pm_runtime_clk_suspend;
+	domain->start_device = pm_runtime_clk_resume;
+	domain->power_off = pd_power_down;
+	domain->power_on = pd_power_up;
+}
+
+void sh7372_add_device_to_domain(struct generic_power_domain *domain,
+				 struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+
+	if (!dev->power.subsys_data) {
+		pm_runtime_clk_init(dev);
+		pm_runtime_clk_add(dev, NULL);
+	}
+	pm_genpd_add_device(domain, dev);
+}
+
+static struct sh7372_domain_data sh7372_a4lc_domain_data = {
+	.bit_shift = 1,
+};
+
+struct generic_power_domain sh7372_a4lc_domain;
+
+static int __init sh7372_power_domains_init(void)
+{
+	sh7372_init_domain(&sh7372_a4lc_domain, &sh7372_a4lc_domain_data);
+	return 0;
+}
+core_initcall(sh7372_power_domains_init);
Index: linux-2.6/arch/arm/mach-shmobile/include/mach/sh7372.h
===================================================================
--- linux-2.6.orig/arch/arm/mach-shmobile/include/mach/sh7372.h
+++ linux-2.6/arch/arm/mach-shmobile/include/mach/sh7372.h
@@ -12,6 +12,7 @@
 #define __ASM_SH7372_H__
 
 #include <linux/sh_clk.h>
+#include <linux/pm_domain.h>
 
 /*
  * Pin Function Controller:
@@ -469,4 +470,19 @@ extern struct clk sh7372_fsibck_clk;
 extern struct clk sh7372_fsidiva_clk;
 extern struct clk sh7372_fsidivb_clk;
 
+struct platform_device;
+
+#ifdef CONFIG_PM
+extern struct generic_power_domain sh7372_a4lc_domain;
+#define SH7372_A4LC	(&sh7372_a4lc_domain)
+
+extern void sh7372_add_device_to_domain(struct generic_power_domain *domain,
+					struct platform_device *pdev);
+#else
+#define SH7372_A4LC	NULL
+
+static inline void sh7372_add_device_to_domain(struct generic_power_domain *dom,
+					       struct platform_device *pd) {}
+#endif /* CONFIG_PM */
+
 #endif /* __ASM_SH7372_H__ */
Index: linux-2.6/arch/arm/mach-shmobile/Makefile
===================================================================
--- linux-2.6.orig/arch/arm/mach-shmobile/Makefile
+++ linux-2.6/arch/arm/mach-shmobile/Makefile
@@ -37,6 +37,10 @@ obj-$(CONFIG_MACH_AP4EVB)	+= board-ap4ev
 obj-$(CONFIG_MACH_AG5EVM)	+= board-ag5evm.o
 obj-$(CONFIG_MACH_MACKEREL)	+= board-mackerel.o
 
+# PM objects
+pm-$(CONFIG_ARCH_SH7372)	+= pm-sh7372.o
+
 # Framework support
 obj-$(CONFIG_SMP)		+= $(smp-y)
 obj-$(CONFIG_GENERIC_GPIO)	+= $(pfc-y)
+obj-$(CONFIG_PM)		+= $(pm-y)
Index: linux-2.6/include/linux/platform_device.h
===================================================================
--- linux-2.6.orig/include/linux/platform_device.h
+++ linux-2.6/include/linux/platform_device.h
@@ -258,8 +258,28 @@ extern int platform_pm_restore_noirq(str
 	.thaw_noirq = platform_pm_thaw_noirq, \
 	.poweroff_noirq = platform_pm_poweroff_noirq, \
 	.restore_noirq = platform_pm_restore_noirq,
+
+static inline void add_platform_pm_sleep_ops(struct dev_pm_ops *pm_ops)
+{
+	pm_ops->prepare = platform_pm_prepare;
+	pm_ops->complete = platform_pm_complete;
+	pm_ops->suspend = platform_pm_suspend;
+	pm_ops->resume = platform_pm_resume;
+	pm_ops->freeze = platform_pm_freeze;
+	pm_ops->thaw = platform_pm_thaw;
+	pm_ops->poweroff = platform_pm_poweroff;
+	pm_ops->restore = platform_pm_restore;
+	pm_ops->suspend_noirq = platform_pm_suspend_noirq;
+	pm_ops->resume_noirq = platform_pm_resume_noirq;
+	pm_ops->freeze_noirq = platform_pm_freeze_noirq;
+	pm_ops->thaw_noirq = platform_pm_thaw_noirq;
+	pm_ops->poweroff_noirq = platform_pm_poweroff_noirq;
+	pm_ops->restore_noirq = platform_pm_restore_noirq;
+}
 #else
 #define USE_PLATFORM_PM_SLEEP_OPS
-#endif
+
+static inline void add_platform_pm_sleep_ops(struct dev_pm_ops *pm_ops) {}
+#endif /* CONFIG_PM_SLEEP */
 
 #endif /* _PLATFORM_DEVICE_H_ */
