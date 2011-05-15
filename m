Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753898Ab1EOXeR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 May 2011 19:34:17 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:53455 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753007Ab1EOXeO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 May 2011 19:34:14 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM mailing list <linux-pm@lists.linux-foundation.org>
Subject: [PATCH 4/6] ARM / shmobile: Support for I/O power domains for SH7372 (v5)
Date: Mon, 16 May 2011 01:32:39 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.39-rc7+; KDE/4.6.0; x86_64; ; )
Cc: Greg KH <gregkh@suse.de>, LKML <linux-kernel@vger.kernel.org>,
        Kevin Hilman <khilman@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org,
        MyungJoo Ham <myungjoo.ham@gmail.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Alan Stern <stern@rowland.harvard.edu>
References: <201104290154.12966.rjw@sisk.pl> <201105082320.57185.rjw@sisk.pl> <201105160117.46927.rjw@sisk.pl>
In-Reply-To: <201105160117.46927.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201105160132.39572.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Use the generic power domains support introduced by the previous
patch to implement support for power domains on SH7372.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 arch/arm/mach-shmobile/Kconfig               |    1 
 arch/arm/mach-shmobile/Makefile              |    4 +
 arch/arm/mach-shmobile/board-mackerel.c      |    3 
 arch/arm/mach-shmobile/include/mach/sh7372.h |   16 ++++
 arch/arm/mach-shmobile/pm-sh7372.c           |   97 +++++++++++++++++++++++++++
 5 files changed, 121 insertions(+)

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
@@ -0,0 +1,97 @@
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
@@ -40,6 +40,10 @@ obj-$(CONFIG_MACH_AP4EVB)	+= board-ap4ev
 obj-$(CONFIG_MACH_AG5EVM)	+= board-ag5evm.o
 obj-$(CONFIG_MACH_MACKEREL)	+= board-mackerel.o
 
+# PM objects
+pm-$(CONFIG_ARCH_SH7372)	+= pm-sh7372.o
+
 # Framework support
 obj-$(CONFIG_SMP)		+= $(smp-y)
 obj-$(CONFIG_GENERIC_GPIO)	+= $(pfc-y)
+obj-$(CONFIG_PM)		+= $(pm-y)
Index: linux-2.6/arch/arm/mach-shmobile/Kconfig
===================================================================
--- linux-2.6.orig/arch/arm/mach-shmobile/Kconfig
+++ linux-2.6/arch/arm/mach-shmobile/Kconfig
@@ -19,6 +19,7 @@ config ARCH_SH7372
 	select CPU_V7
 	select SH_CLK_CPG
 	select ARCH_WANT_OPTIONAL_GPIOLIB
+	select PM_GENERIC_DOMAINS
 
 config ARCH_SH73A0
 	bool "SH-Mobile AG5 (R8A73A00)"

