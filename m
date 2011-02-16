Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755633Ab1BPHp5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 02:45:57 -0500
Received: from mprc.pku.edu.cn ([162.105.203.9]:57486 "EHLO mprc.pku.edu.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751873Ab1BPHpx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 02:45:53 -0500
From: "Guan Xuetao" <gxt@mprc.pku.edu.cn>
To: <linux-kernel@vger.kernel.org>, <linux-arch@vger.kernel.org>
Cc: "Arnd Bergmann" <arnd@arndb.de>, "'Greg KH'" <greg@kroah.com>
Subject: [PATCH 01/12] unicore32 additional architecture files: pm related files
Date: Wed, 16 Feb 2011 15:45:43 +0800
Message-ID: <014301cbcdad$83f15a60$8bd40f20$@mprc.pku.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AcvNrXpPQSbpdLfSQzOPyiewPYAzQg==
Content-Language: zh-cn
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Message-Id: <9ee362f0c0ec9dfec91d0788314ae91f555554c3.1297842537.git.gxt@mprc.pku.edu.cn>
In-Reply-To: <cover.1297842537.git.gxt@mprc.pku.edu.cn>
References: <cover.1297842537.git.gxt@mprc.pku.edu.cn>
From: GuanXuetao <gxt@mprc.pku.edu.cn>
Date: Sat, 15 Jan 2011 18:20:58 +0800

This patch adds pm related files, including hibernate and sleep supports.

Signed-off-by: Guan Xuetao <gxt@mprc.pku.edu.cn>
Acked-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/unicore32/include/asm/suspend.h  |   30 +++
 arch/unicore32/include/mach/pm.h      |   43 ++++
 arch/unicore32/kernel/clock.c         |  388 +++++++++++++++++++++++++++++++++
 arch/unicore32/kernel/cpu-ucv2.c      |   93 ++++++++
 arch/unicore32/kernel/hibernate.c     |  160 ++++++++++++++
 arch/unicore32/kernel/hibernate_asm.S |  117 ++++++++++
 arch/unicore32/kernel/pm.c            |  123 +++++++++++
 arch/unicore32/kernel/sleep.S         |  202 +++++++++++++++++
 8 files changed, 1156 insertions(+), 0 deletions(-)
 create mode 100644 arch/unicore32/include/asm/suspend.h
 create mode 100644 arch/unicore32/include/mach/pm.h
 create mode 100644 arch/unicore32/kernel/clock.c
 create mode 100644 arch/unicore32/kernel/cpu-ucv2.c
 create mode 100644 arch/unicore32/kernel/hibernate.c
 create mode 100644 arch/unicore32/kernel/hibernate_asm.S
 create mode 100644 arch/unicore32/kernel/pm.c
 create mode 100644 arch/unicore32/kernel/sleep.S

diff --git a/arch/unicore32/include/asm/suspend.h b/arch/unicore32/include/asm/suspend.h
new file mode 100644
index 0000000..88a9c0f
--- /dev/null
+++ b/arch/unicore32/include/asm/suspend.h
@@ -0,0 +1,30 @@
+/*
+ * linux/arch/unicore32/include/asm/suspend.h
+ *
+ * Code specific to PKUnity SoC and UniCore ISA
+ *
+ * Copyright (C) 2001-2010 GUAN Xue-tao
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef __UNICORE_SUSPEND_H__
+#define __UNICORE_SUSPEND_H__
+
+#ifndef __ASSEMBLY__
+static inline int arch_prepare_suspend(void) { return 0; }
+
+#include <asm/ptrace.h>
+
+struct swsusp_arch_regs {
+	struct cpu_context_save	cpu_context;	/* cpu context */
+#ifdef CONFIG_UNICORE_FPU_F64
+	struct fp_state		fpstate __attribute__((aligned(8)));
+#endif
+};
+#endif
+
+#endif /* __UNICORE_SUSPEND_H__ */
+
diff --git a/arch/unicore32/include/mach/pm.h b/arch/unicore32/include/mach/pm.h
new file mode 100644
index 0000000..4dcd34a
--- /dev/null
+++ b/arch/unicore32/include/mach/pm.h
@@ -0,0 +1,43 @@
+/*
+ * linux/arch/unicore/include/mach/pm.h
+ *
+ * Code specific to PKUnity SoC and UniCore ISA
+ *
+ * Copyright (C) 2001-2010 GUAN Xue-tao
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#ifndef __PUV3_PM_H__
+#define __PUV3_PM_H__
+
+#include <linux/suspend.h>
+
+struct puv3_cpu_pm_fns {
+	int	save_count;
+	void	(*save)(unsigned long *);
+	void	(*restore)(unsigned long *);
+	int	(*valid)(suspend_state_t state);
+	void	(*enter)(suspend_state_t state);
+	int	(*prepare)(void);
+	void	(*finish)(void);
+};
+
+extern struct puv3_cpu_pm_fns *puv3_cpu_pm_fns;
+
+/* sleep.S */
+extern void puv3_cpu_suspend(unsigned int);
+
+extern void puv3_cpu_resume(void);
+
+extern int puv3_pm_enter(suspend_state_t state);
+
+/* Defined in hibernate_asm.S */
+extern int restore_image(pgd_t *resume_pg_dir, struct pbe *restore_pblist);
+
+/* References to section boundaries */
+extern const void __nosave_begin, __nosave_end;
+
+extern struct pbe *restore_pblist;
+#endif
diff --git a/arch/unicore32/kernel/clock.c b/arch/unicore32/kernel/clock.c
new file mode 100644
index 0000000..34c96c6
--- /dev/null
+++ b/arch/unicore32/kernel/clock.c
@@ -0,0 +1,388 @@
+/*
+ * linux/arch/unicore32/kernel/clock.c
+ *
+ * Code specific to PKUnity SoC and UniCore ISA
+ *
+ *	Maintained by GUAN Xue-tao <gxt@mprc.pku.edu.cn>
+ *	Copyright (C) 2001-2010 Guan Xuetao
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/device.h>
+#include <linux/list.h>
+#include <linux/errno.h>
+#include <linux/err.h>
+#include <linux/string.h>
+#include <linux/clk.h>
+#include <linux/mutex.h>
+#include <linux/delay.h>
+
+#include <mach/hardware.h>
+
+/*
+ * Very simple clock implementation
+ */
+struct clk {
+	struct list_head	node;
+	unsigned long		rate;
+	const char		*name;
+};
+
+static struct clk clk_ost_clk = {
+	.name		= "OST_CLK",
+	.rate		= CLOCK_TICK_RATE,
+};
+
+static struct clk clk_mclk_clk = {
+	.name		= "MAIN_CLK",
+};
+
+static struct clk clk_bclk32_clk = {
+	.name		= "BUS32_CLK",
+};
+
+static struct clk clk_ddr_clk = {
+	.name		= "DDR_CLK",
+};
+
+static struct clk clk_vga_clk = {
+	.name		= "VGA_CLK",
+};
+
+static LIST_HEAD(clocks);
+static DEFINE_MUTEX(clocks_mutex);
+
+struct clk *clk_get(struct device *dev, const char *id)
+{
+	struct clk *p, *clk = ERR_PTR(-ENOENT);
+
+	mutex_lock(&clocks_mutex);
+	list_for_each_entry(p, &clocks, node) {
+		if (strcmp(id, p->name) == 0) {
+			clk = p;
+			break;
+		}
+	}
+	mutex_unlock(&clocks_mutex);
+
+	return clk;
+}
+EXPORT_SYMBOL(clk_get);
+
+void clk_put(struct clk *clk)
+{
+}
+EXPORT_SYMBOL(clk_put);
+
+int clk_enable(struct clk *clk)
+{
+	return 0;
+}
+EXPORT_SYMBOL(clk_enable);
+
+void clk_disable(struct clk *clk)
+{
+}
+EXPORT_SYMBOL(clk_disable);
+
+unsigned long clk_get_rate(struct clk *clk)
+{
+	return clk->rate;
+}
+EXPORT_SYMBOL(clk_get_rate);
+
+struct {
+	unsigned long rate;
+	unsigned long cfg;
+	unsigned long div;
+} vga_clk_table[] = {
+	{.rate =  25175000, .cfg = 0x00002001, .div = 0x9},
+	{.rate =  31500000, .cfg = 0x00002001, .div = 0x7},
+	{.rate =  40000000, .cfg = 0x00003801, .div = 0x9},
+	{.rate =  49500000, .cfg = 0x00003801, .div = 0x7},
+	{.rate =  65000000, .cfg = 0x00002c01, .div = 0x4},
+	{.rate =  78750000, .cfg = 0x00002400, .div = 0x7},
+	{.rate = 108000000, .cfg = 0x00002c01, .div = 0x2},
+	{.rate = 106500000, .cfg = 0x00003c01, .div = 0x3},
+	{.rate =  50650000, .cfg = 0x00106400, .div = 0x9},
+	{.rate =  61500000, .cfg = 0x00106400, .div = 0xa},
+	{.rate =  85500000, .cfg = 0x00002800, .div = 0x6},
+};
+
+struct {
+	unsigned long mrate;
+	unsigned long prate;
+} mclk_clk_table[] = {
+	{.mrate = 500000000, .prate = 0x00109801},
+	{.mrate = 525000000, .prate = 0x00104C00},
+	{.mrate = 550000000, .prate = 0x00105000},
+	{.mrate = 575000000, .prate = 0x00105400},
+	{.mrate = 600000000, .prate = 0x00105800},
+	{.mrate = 625000000, .prate = 0x00105C00},
+	{.mrate = 650000000, .prate = 0x00106000},
+	{.mrate = 675000000, .prate = 0x00106400},
+	{.mrate = 700000000, .prate = 0x00106800},
+	{.mrate = 725000000, .prate = 0x00106C00},
+	{.mrate = 750000000, .prate = 0x00107000},
+	{.mrate = 775000000, .prate = 0x00107400},
+	{.mrate = 800000000, .prate = 0x00107800},
+};
+
+int clk_set_rate(struct clk *clk, unsigned long rate)
+{
+	if (clk == &clk_vga_clk) {
+		unsigned long pll_vgacfg, pll_vgadiv;
+		int ret, i;
+
+		/* lookup vga_clk_table */
+		ret = -EINVAL;
+		for (i = 0; i < ARRAY_SIZE(vga_clk_table); i++) {
+			if (rate == vga_clk_table[i].rate) {
+				pll_vgacfg = vga_clk_table[i].cfg;
+				pll_vgadiv = vga_clk_table[i].div;
+				ret = 0;
+				break;
+			}
+		}
+
+		if (ret)
+			return ret;
+
+		if (PM_PLLVGACFG == pll_vgacfg)
+			return 0;
+
+		/* set pll vga cfg reg. */
+		PM_PLLVGACFG = pll_vgacfg;
+
+		PM_PMCR = PM_PMCR_CFBVGA;
+		while ((PM_PLLDFCDONE & PM_PLLDFCDONE_VGADFC)
+				!= PM_PLLDFCDONE_VGADFC)
+			udelay(100); /* about 1ms */
+
+		/* set div cfg reg. */
+		PM_PCGR |= PM_PCGR_VGACLK;
+
+		PM_DIVCFG = (PM_DIVCFG & ~PM_DIVCFG_VGACLK_MASK)
+				| PM_DIVCFG_VGACLK(pll_vgadiv);
+
+		PM_SWRESET |= PM_SWRESET_VGADIV;
+		while ((PM_SWRESET & PM_SWRESET_VGADIV) == PM_SWRESET_VGADIV)
+			udelay(100); /* 65536 bclk32, about 320us */
+
+		PM_PCGR &= ~PM_PCGR_VGACLK;
+	}
+#ifdef CONFIG_CPU_FREQ
+	if (clk == &clk_mclk_clk) {
+		u32 pll_rate, divstatus = PM_DIVSTATUS;
+		int ret, i;
+
+		/* lookup mclk_clk_table */
+		ret = -EINVAL;
+		for (i = 0; i < ARRAY_SIZE(mclk_clk_table); i++) {
+			if (rate == mclk_clk_table[i].mrate) {
+				pll_rate = mclk_clk_table[i].prate;
+				clk_mclk_clk.rate = mclk_clk_table[i].mrate;
+				ret = 0;
+				break;
+			}
+		}
+
+		if (ret)
+			return ret;
+
+		if (clk_mclk_clk.rate)
+			clk_bclk32_clk.rate = clk_mclk_clk.rate
+				/ (((divstatus & 0x0000f000) >> 12) + 1);
+
+		/* set pll sys cfg reg. */
+		PM_PLLSYSCFG = pll_rate;
+
+		PM_PMCR = PM_PMCR_CFBSYS;
+		while ((PM_PLLDFCDONE & PM_PLLDFCDONE_SYSDFC)
+				!= PM_PLLDFCDONE_SYSDFC)
+			udelay(100);
+			/* about 1ms */
+	}
+#endif
+	return 0;
+}
+EXPORT_SYMBOL(clk_set_rate);
+
+int clk_register(struct clk *clk)
+{
+	mutex_lock(&clocks_mutex);
+	list_add(&clk->node, &clocks);
+	mutex_unlock(&clocks_mutex);
+	printk(KERN_DEFAULT "PKUnity PM: %s %lu.%02luM\n", clk->name,
+		(clk->rate)/1000000, (clk->rate)/10000 % 100);
+	return 0;
+}
+EXPORT_SYMBOL(clk_register);
+
+void clk_unregister(struct clk *clk)
+{
+	mutex_lock(&clocks_mutex);
+	list_del(&clk->node);
+	mutex_unlock(&clocks_mutex);
+}
+EXPORT_SYMBOL(clk_unregister);
+
+struct {
+	unsigned long prate;
+	unsigned long rate;
+} pllrate_table[] = {
+	{.prate = 0x00002001, .rate = 250000000},
+	{.prate = 0x00104801, .rate = 250000000},
+	{.prate = 0x00104C01, .rate = 262500000},
+	{.prate = 0x00002401, .rate = 275000000},
+	{.prate = 0x00105001, .rate = 275000000},
+	{.prate = 0x00105401, .rate = 287500000},
+	{.prate = 0x00002801, .rate = 300000000},
+	{.prate = 0x00105801, .rate = 300000000},
+	{.prate = 0x00105C01, .rate = 312500000},
+	{.prate = 0x00002C01, .rate = 325000000},
+	{.prate = 0x00106001, .rate = 325000000},
+	{.prate = 0x00106401, .rate = 337500000},
+	{.prate = 0x00003001, .rate = 350000000},
+	{.prate = 0x00106801, .rate = 350000000},
+	{.prate = 0x00106C01, .rate = 362500000},
+	{.prate = 0x00003401, .rate = 375000000},
+	{.prate = 0x00107001, .rate = 375000000},
+	{.prate = 0x00107401, .rate = 387500000},
+	{.prate = 0x00003801, .rate = 400000000},
+	{.prate = 0x00107801, .rate = 400000000},
+	{.prate = 0x00107C01, .rate = 412500000},
+	{.prate = 0x00003C01, .rate = 425000000},
+	{.prate = 0x00108001, .rate = 425000000},
+	{.prate = 0x00108401, .rate = 437500000},
+	{.prate = 0x00004001, .rate = 450000000},
+	{.prate = 0x00108801, .rate = 450000000},
+	{.prate = 0x00108C01, .rate = 462500000},
+	{.prate = 0x00004401, .rate = 475000000},
+	{.prate = 0x00109001, .rate = 475000000},
+	{.prate = 0x00109401, .rate = 487500000},
+	{.prate = 0x00004801, .rate = 500000000},
+	{.prate = 0x00109801, .rate = 500000000},
+	{.prate = 0x00104C00, .rate = 525000000},
+	{.prate = 0x00002400, .rate = 550000000},
+	{.prate = 0x00105000, .rate = 550000000},
+	{.prate = 0x00105400, .rate = 575000000},
+	{.prate = 0x00002800, .rate = 600000000},
+	{.prate = 0x00105800, .rate = 600000000},
+	{.prate = 0x00105C00, .rate = 625000000},
+	{.prate = 0x00002C00, .rate = 650000000},
+	{.prate = 0x00106000, .rate = 650000000},
+	{.prate = 0x00106400, .rate = 675000000},
+	{.prate = 0x00003000, .rate = 700000000},
+	{.prate = 0x00106800, .rate = 700000000},
+	{.prate = 0x00106C00, .rate = 725000000},
+	{.prate = 0x00003400, .rate = 750000000},
+	{.prate = 0x00107000, .rate = 750000000},
+	{.prate = 0x00107400, .rate = 775000000},
+	{.prate = 0x00003800, .rate = 800000000},
+	{.prate = 0x00107800, .rate = 800000000},
+	{.prate = 0x00107C00, .rate = 825000000},
+	{.prate = 0x00003C00, .rate = 850000000},
+	{.prate = 0x00108000, .rate = 850000000},
+	{.prate = 0x00108400, .rate = 875000000},
+	{.prate = 0x00004000, .rate = 900000000},
+	{.prate = 0x00108800, .rate = 900000000},
+	{.prate = 0x00108C00, .rate = 925000000},
+	{.prate = 0x00004400, .rate = 950000000},
+	{.prate = 0x00109000, .rate = 950000000},
+	{.prate = 0x00109400, .rate = 975000000},
+	{.prate = 0x00004800, .rate = 1000000000},
+	{.prate = 0x00109800, .rate = 1000000000},
+};
+
+struct {
+	unsigned long prate;
+	unsigned long drate;
+} pddr_table[] = {
+	{.prate = 0x00100800, .drate = 44236800},
+	{.prate = 0x00100C00, .drate = 66355200},
+	{.prate = 0x00101000, .drate = 88473600},
+	{.prate = 0x00101400, .drate = 110592000},
+	{.prate = 0x00101800, .drate = 132710400},
+	{.prate = 0x00101C01, .drate = 154828800},
+	{.prate = 0x00102001, .drate = 176947200},
+	{.prate = 0x00102401, .drate = 199065600},
+	{.prate = 0x00102801, .drate = 221184000},
+	{.prate = 0x00102C01, .drate = 243302400},
+	{.prate = 0x00103001, .drate = 265420800},
+	{.prate = 0x00103401, .drate = 287539200},
+	{.prate = 0x00103801, .drate = 309657600},
+	{.prate = 0x00103C01, .drate = 331776000},
+	{.prate = 0x00104001, .drate = 353894400},
+};
+
+static int __init clk_init(void)
+{
+#ifdef CONFIG_PUV3_PM
+	u32 pllrate, divstatus = PM_DIVSTATUS;
+	u32 pcgr_val = PM_PCGR;
+	int i;
+
+	pcgr_val |= PM_PCGR_BCLKMME | PM_PCGR_BCLKH264E | PM_PCGR_BCLKH264D
+			| PM_PCGR_HECLK | PM_PCGR_HDCLK;
+	PM_PCGR = pcgr_val;
+
+	pllrate = PM_PLLSYSSTATUS;
+
+	/* lookup pmclk_table */
+	clk_mclk_clk.rate = 0;
+	for (i = 0; i < ARRAY_SIZE(pllrate_table); i++) {
+		if (pllrate == pllrate_table[i].prate) {
+			clk_mclk_clk.rate = pllrate_table[i].rate;
+			break;
+		}
+	}
+
+	if (clk_mclk_clk.rate)
+		clk_bclk32_clk.rate = clk_mclk_clk.rate /
+			(((divstatus & 0x0000f000) >> 12) + 1);
+
+	pllrate = PM_PLLDDRSTATUS;
+
+	/* lookup pddr_table */
+	clk_ddr_clk.rate = 0;
+	for (i = 0; i < ARRAY_SIZE(pddr_table); i++) {
+		if (pllrate == pddr_table[i].prate) {
+			clk_ddr_clk.rate = pddr_table[i].drate;
+			break;
+		}
+	}
+
+	pllrate = PM_PLLVGASTATUS;
+
+	/* lookup pvga_table */
+	clk_vga_clk.rate = 0;
+	for (i = 0; i < ARRAY_SIZE(pllrate_table); i++) {
+		if (pllrate == pllrate_table[i].prate) {
+			clk_vga_clk.rate = pllrate_table[i].rate;
+			break;
+		}
+	}
+
+	if (clk_vga_clk.rate)
+		clk_vga_clk.rate = clk_vga_clk.rate /
+			(((divstatus & 0x00f00000) >> 20) + 1);
+
+	clk_register(&clk_vga_clk);
+#endif
+#ifdef CONFIG_ARCH_FPGA
+	clk_ddr_clk.rate = 33000000;
+	clk_mclk_clk.rate = 33000000;
+	clk_bclk32_clk.rate = 33000000;
+#endif
+	clk_register(&clk_ddr_clk);
+	clk_register(&clk_mclk_clk);
+	clk_register(&clk_bclk32_clk);
+	clk_register(&clk_ost_clk);
+	return 0;
+}
+arch_initcall(clk_init);
diff --git a/arch/unicore32/kernel/cpu-ucv2.c b/arch/unicore32/kernel/cpu-ucv2.c
new file mode 100644
index 0000000..4a99f62
--- /dev/null
+++ b/arch/unicore32/kernel/cpu-ucv2.c
@@ -0,0 +1,93 @@
+/*
+ * linux/arch/unicore32/kernel/cpu-ucv2.c: clock scaling for the UniCore-II
+ *
+ * Code specific to PKUnity SoC and UniCore ISA
+ *
+ *	Maintained by GUAN Xue-tao <gxt@mprc.pku.edu.cn>
+ *	Copyright (C) 2001-2010 Guan Xuetao
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/kernel.h>
+#include <linux/types.h>
+#include <linux/init.h>
+#include <linux/clk.h>
+#include <linux/cpufreq.h>
+
+#include <mach/hardware.h>
+
+static struct cpufreq_driver ucv2_driver;
+
+/* make sure that only the "userspace" governor is run
+ * -- anything else wouldn't make sense on this platform, anyway.
+ */
+int ucv2_verify_speed(struct cpufreq_policy *policy)
+{
+	if (policy->cpu)
+		return -EINVAL;
+
+	cpufreq_verify_within_limits(policy,
+			policy->cpuinfo.min_freq, policy->cpuinfo.max_freq);
+
+	return 0;
+}
+
+static unsigned int ucv2_getspeed(unsigned int cpu)
+{
+	struct clk *mclk = clk_get(NULL, "MAIN_CLK");
+
+	if (cpu)
+		return 0;
+	return clk_get_rate(mclk)/1000;
+}
+
+static int ucv2_target(struct cpufreq_policy *policy,
+			 unsigned int target_freq,
+			 unsigned int relation)
+{
+	unsigned int cur = ucv2_getspeed(0);
+	struct cpufreq_freqs freqs;
+	struct clk *mclk = clk_get(NULL, "MAIN_CLK");
+
+	cpufreq_notify_transition(&freqs, CPUFREQ_PRECHANGE);
+
+	if (!clk_set_rate(mclk, target_freq * 1000)) {
+		freqs.old = cur;
+		freqs.new = target_freq;
+		freqs.cpu = 0;
+	}
+
+	cpufreq_notify_transition(&freqs, CPUFREQ_POSTCHANGE);
+
+	return 0;
+}
+
+static int __init ucv2_cpu_init(struct cpufreq_policy *policy)
+{
+	if (policy->cpu != 0)
+		return -EINVAL;
+	policy->cur = ucv2_getspeed(0);
+	policy->min = policy->cpuinfo.min_freq = 250000;
+	policy->max = policy->cpuinfo.max_freq = 1000000;
+	policy->cpuinfo.transition_latency = CPUFREQ_ETERNAL;
+	return 0;
+}
+
+static struct cpufreq_driver ucv2_driver = {
+	.flags		= CPUFREQ_STICKY,
+	.verify		= ucv2_verify_speed,
+	.target		= ucv2_target,
+	.get		= ucv2_getspeed,
+	.init		= ucv2_cpu_init,
+	.name		= "UniCore-II",
+};
+
+static int __init ucv2_cpufreq_init(void)
+{
+	return cpufreq_register_driver(&ucv2_driver);
+}
+
+arch_initcall(ucv2_cpufreq_init);
diff --git a/arch/unicore32/kernel/hibernate.c b/arch/unicore32/kernel/hibernate.c
new file mode 100644
index 0000000..7d0f0b7
--- /dev/null
+++ b/arch/unicore32/kernel/hibernate.c
@@ -0,0 +1,160 @@
+/*
+ *  linux/arch/unicore32/kernel/hibernate.c
+ *
+ * Code specific to PKUnity SoC and UniCore ISA
+ *
+ *	Maintained by GUAN Xue-tao <gxt@mprc.pku.edu.cn>
+ *	Copyright (C) 2001-2010 Guan Xuetao
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/gfp.h>
+#include <linux/suspend.h>
+#include <linux/bootmem.h>
+
+#include <asm/system.h>
+#include <asm/page.h>
+#include <asm/pgtable.h>
+#include <asm/pgalloc.h>
+#include <asm/suspend.h>
+
+#include "mach/pm.h"
+
+/* Pointer to the temporary resume page tables */
+pgd_t *resume_pg_dir;
+
+struct swsusp_arch_regs swsusp_arch_regs_cpu0;
+
+/*
+ * Create a middle page table on a resume-safe page and put a pointer to it in
+ * the given global directory entry.  This only returns the gd entry
+ * in non-PAE compilation mode, since the middle layer is folded.
+ */
+static pmd_t *resume_one_md_table_init(pgd_t *pgd)
+{
+	pud_t *pud;
+	pmd_t *pmd_table;
+
+	pud = pud_offset(pgd, 0);
+	pmd_table = pmd_offset(pud, 0);
+
+	return pmd_table;
+}
+
+/*
+ * Create a page table on a resume-safe page and place a pointer to it in
+ * a middle page directory entry.
+ */
+static pte_t *resume_one_page_table_init(pmd_t *pmd)
+{
+	if (pmd_none(*pmd)) {
+		pte_t *page_table = (pte_t *)get_safe_page(GFP_ATOMIC);
+		if (!page_table)
+			return NULL;
+
+		set_pmd(pmd, __pmd(__pa(page_table) | _PAGE_KERNEL_TABLE));
+
+		BUG_ON(page_table != pte_offset_kernel(pmd, 0));
+
+		return page_table;
+	}
+
+	return pte_offset_kernel(pmd, 0);
+}
+
+/*
+ * This maps the physical memory to kernel virtual address space, a total
+ * of max_low_pfn pages, by creating page tables starting from address
+ * PAGE_OFFSET.  The page tables are allocated out of resume-safe pages.
+ */
+static int resume_physical_mapping_init(pgd_t *pgd_base)
+{
+	unsigned long pfn;
+	pgd_t *pgd;
+	pmd_t *pmd;
+	pte_t *pte;
+	int pgd_idx, pmd_idx;
+
+	pgd_idx = pgd_index(PAGE_OFFSET);
+	pgd = pgd_base + pgd_idx;
+	pfn = 0;
+
+	for (; pgd_idx < PTRS_PER_PGD; pgd++, pgd_idx++) {
+		pmd = resume_one_md_table_init(pgd);
+		if (!pmd)
+			return -ENOMEM;
+
+		if (pfn >= max_low_pfn)
+			continue;
+
+		for (pmd_idx = 0; pmd_idx < PTRS_PER_PMD; pmd++, pmd_idx++) {
+			pte_t *max_pte;
+
+			if (pfn >= max_low_pfn)
+				break;
+
+			/* Map with normal page tables.
+			 * NOTE: We can mark everything as executable here
+			 */
+			pte = resume_one_page_table_init(pmd);
+			if (!pte)
+				return -ENOMEM;
+
+			max_pte = pte + PTRS_PER_PTE;
+			for (; pte < max_pte; pte++, pfn++) {
+				if (pfn >= max_low_pfn)
+					break;
+
+				set_pte(pte, pfn_pte(pfn, PAGE_KERNEL_EXEC));
+			}
+		}
+	}
+
+	return 0;
+}
+
+static inline void resume_init_first_level_page_table(pgd_t *pg_dir)
+{
+}
+
+int swsusp_arch_resume(void)
+{
+	int error;
+
+	resume_pg_dir = (pgd_t *)get_safe_page(GFP_ATOMIC);
+	if (!resume_pg_dir)
+		return -ENOMEM;
+
+	resume_init_first_level_page_table(resume_pg_dir);
+	error = resume_physical_mapping_init(resume_pg_dir);
+	if (error)
+		return error;
+
+	/* We have got enough memory and from now on we cannot recover */
+	restore_image(resume_pg_dir, restore_pblist);
+	return 0;
+}
+
+/*
+ *	pfn_is_nosave - check if given pfn is in the 'nosave' section
+ */
+
+int pfn_is_nosave(unsigned long pfn)
+{
+	unsigned long begin_pfn = __pa(&__nosave_begin) >> PAGE_SHIFT;
+	unsigned long end_pfn = PAGE_ALIGN(__pa(&__nosave_end)) >> PAGE_SHIFT;
+
+	return (pfn >= begin_pfn) && (pfn < end_pfn);
+}
+
+void save_processor_state(void)
+{
+}
+
+void restore_processor_state(void)
+{
+	local_flush_tlb_all();
+}
diff --git a/arch/unicore32/kernel/hibernate_asm.S b/arch/unicore32/kernel/hibernate_asm.S
new file mode 100644
index 0000000..cc3c652
--- /dev/null
+++ b/arch/unicore32/kernel/hibernate_asm.S
@@ -0,0 +1,117 @@
+/*
+ * linux/arch/unicore32/kernel/hibernate_asm.S
+ *
+ * Code specific to PKUnity SoC and UniCore ISA
+ *
+ *	Maintained by GUAN Xue-tao <gxt@mprc.pku.edu.cn>
+ *	Copyright (C) 2001-2010 Guan Xuetao
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/sys.h>
+#include <linux/errno.h>
+#include <linux/linkage.h>
+#include <generated/asm-offsets.h>
+#include <asm/page.h>
+#include <asm/pgtable.h>
+#include <asm/assembler.h>
+
+@ restore_image(pgd_t *resume_pg_dir, struct pbe *restore_pblist)
+@ r0: resume_pg_dir
+@ r1: restore_pblist
+@ copy restore_pblist pages
+@ restore registers from swsusp_arch_regs_cpu0
+@
+ENTRY(restore_image)
+	sub	r0, r0, #PAGE_OFFSET
+	mov	r5, #0
+	movc	p0.c6, r5, #6	@invalidate ITLB & DTLB
+	movc	p0.c2, r0, #0
+	nop
+	nop
+	nop
+	nop
+	nop
+	nop
+	nop
+
+	.p2align 4,,7
+101:
+	csub.a	r1, #0
+	beq	109f
+
+	ldw	r6, [r1+], #PBE_ADDRESS
+	ldw	r7, [r1+], #PBE_ORIN_ADDRESS
+
+	movl	ip, #128
+102:	ldm.w	(r8 - r15), [r6]+
+	stm.w	(r8 - r15), [r7]+
+	sub.a	ip, ip, #1
+	bne	102b
+
+	ldw	r1, [r1+], #PBE_NEXT
+	b	101b
+
+	.p2align 4,,7
+109:
+	/* go back to the original page tables */
+	ldw	r0, =swapper_pg_dir
+	sub	r0, r0, #PAGE_OFFSET
+	mov	r5, #0
+	movc	p0.c6, r5, #6
+	movc	p0.c2, r0, #0
+	nop
+	nop
+	nop
+	nop
+	nop
+	nop
+	nop
+
+#ifdef	CONFIG_UNICORE_FPU_F64
+	ldw	ip, 1f
+	add	ip, ip, #SWSUSP_FPSTATE
+	lfm.w	(f0  - f7 ), [ip]+
+	lfm.w	(f8  - f15), [ip]+
+	lfm.w	(f16 - f23), [ip]+
+	lfm.w	(f24 - f31), [ip]+
+	ldw	r4, [ip]
+	ctf	r4, s31
+#endif
+	mov	r0, #0x0
+	ldw	ip, 1f
+	add	ip, ip, #SWSUSP_CPU
+	ldm.w	(r4 - r15), [ip]+
+	ldm	(r16 - r27, sp, pc), [ip]+	@ Load all regs saved previously
+
+	.align	2
+1:	.long	swsusp_arch_regs_cpu0
+
+
+@ swsusp_arch_suspend()
+@ - prepare pc for resume, return from function without swsusp_save on resume
+@ - save registers in swsusp_arch_regs_cpu0
+@ - call swsusp_save write suspend image
+
+ENTRY(swsusp_arch_suspend)
+	ldw	ip, 1f
+	add	ip, ip, #SWSUSP_CPU
+	stm.w	(r4 - r15), [ip]+
+	stm.w	(r16 - r27, sp, lr), [ip]+
+
+#ifdef	CONFIG_UNICORE_FPU_F64
+	ldw	ip, 1f
+	add	ip, ip, #SWSUSP_FPSTATE
+	sfm.w	(f0  - f7 ), [ip]+
+	sfm.w	(f8  - f15), [ip]+
+	sfm.w	(f16 - f23), [ip]+
+	sfm.w	(f24 - f31), [ip]+
+	cff	r4, s31
+	stw	r4, [ip]
+#endif
+	b	swsusp_save			@ no return
+
+1:	.long	swsusp_arch_regs_cpu0
diff --git a/arch/unicore32/kernel/pm.c b/arch/unicore32/kernel/pm.c
new file mode 100644
index 0000000..784bc2d
--- /dev/null
+++ b/arch/unicore32/kernel/pm.c
@@ -0,0 +1,123 @@
+/*
+ * linux/arch/unicore32/kernel/pm.c
+ *
+ * Code specific to PKUnity SoC and UniCore ISA
+ *
+ *	Maintained by GUAN Xue-tao <gxt@mprc.pku.edu.cn>
+ *	Copyright (C) 2001-2010 Guan Xuetao
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/suspend.h>
+#include <linux/errno.h>
+#include <linux/slab.h>
+#include <linux/io.h>
+
+#include <mach/hardware.h>
+#include <mach/pm.h>
+
+#include "setup.h"
+
+struct puv3_cpu_pm_fns *puv3_cpu_pm_fns;
+static unsigned long *sleep_save;
+
+int puv3_pm_enter(suspend_state_t state)
+{
+	unsigned long sleep_save_checksum = 0, checksum = 0;
+	int i;
+
+	/* skip registers saving for standby */
+	if (state != PM_SUSPEND_STANDBY) {
+		puv3_cpu_pm_fns->save(sleep_save);
+		/* before sleeping, calculate and save a checksum */
+		for (i = 0; i < puv3_cpu_pm_fns->save_count - 1; i++)
+			sleep_save_checksum += sleep_save[i];
+	}
+
+	/* *** go zzz *** */
+	puv3_cpu_pm_fns->enter(state);
+	cpu_init();
+#ifdef CONFIG_INPUT_KEYBOARD
+	puv3_ps2_init();
+#endif
+#ifdef CONFIG_PCI
+	pci_puv3_preinit();
+#endif
+	if (state != PM_SUSPEND_STANDBY) {
+		/* after sleeping, validate the checksum */
+		for (i = 0; i < puv3_cpu_pm_fns->save_count - 1; i++)
+			checksum += sleep_save[i];
+
+		/* if invalid, display message and wait for a hardware reset */
+		if (checksum != sleep_save_checksum) {
+			while (1)
+				puv3_cpu_pm_fns->enter(state);
+		}
+		puv3_cpu_pm_fns->restore(sleep_save);
+	}
+
+	pr_debug("*** made it back from resume\n");
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(puv3_pm_enter);
+
+unsigned long sleep_phys_sp(void *sp)
+{
+	return virt_to_phys(sp);
+}
+
+static int puv3_pm_valid(suspend_state_t state)
+{
+	if (puv3_cpu_pm_fns)
+		return puv3_cpu_pm_fns->valid(state);
+
+	return -EINVAL;
+}
+
+static int puv3_pm_prepare(void)
+{
+	int ret = 0;
+
+	if (puv3_cpu_pm_fns && puv3_cpu_pm_fns->prepare)
+		ret = puv3_cpu_pm_fns->prepare();
+
+	return ret;
+}
+
+static void puv3_pm_finish(void)
+{
+	if (puv3_cpu_pm_fns && puv3_cpu_pm_fns->finish)
+		puv3_cpu_pm_fns->finish();
+}
+
+static struct platform_suspend_ops puv3_pm_ops = {
+	.valid		= puv3_pm_valid,
+	.enter		= puv3_pm_enter,
+	.prepare	= puv3_pm_prepare,
+	.finish		= puv3_pm_finish,
+};
+
+static int __init puv3_pm_init(void)
+{
+	if (!puv3_cpu_pm_fns) {
+		printk(KERN_ERR "no valid puv3_cpu_pm_fns defined\n");
+		return -EINVAL;
+	}
+
+	sleep_save = kmalloc(puv3_cpu_pm_fns->save_count
+				* sizeof(unsigned long), GFP_KERNEL);
+	if (!sleep_save) {
+		printk(KERN_ERR "failed to alloc memory for pm save\n");
+		return -ENOMEM;
+	}
+
+	suspend_set_ops(&puv3_pm_ops);
+	return 0;
+}
+
+device_initcall(puv3_pm_init);
diff --git a/arch/unicore32/kernel/sleep.S b/arch/unicore32/kernel/sleep.S
new file mode 100644
index 0000000..f7c3fc8
--- /dev/null
+++ b/arch/unicore32/kernel/sleep.S
@@ -0,0 +1,202 @@
+/*
+ * linux/arch/unicore32/kernel/sleep.S
+ *
+ * Code specific to PKUnity SoC and UniCore ISA
+ *
+ *	Maintained by GUAN Xue-tao <gxt@mprc.pku.edu.cn>
+ *	Copyright (C) 2001-2010 Guan Xuetao
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/linkage.h>
+#include <asm/assembler.h>
+#include <mach/hardware.h>
+
+		.text
+
+pkunity_cpu_save_cp:
+
+	@ get coprocessor registers
+
+	movc	r3, p0.c7, #0			@ PID
+	movc	r4, p0.c2, #0			@ translation table base addr
+	movc	r5, p0.c1, #0			@ control reg
+
+
+	@ store them plus current virtual stack ptr on stack
+	mov	r6, sp
+	stm.w	(r3 - r6), [sp-]
+
+	mov	pc, lr
+
+pkunity_cpu_save_sp:
+	@ preserve phys address of stack
+	mov	r0, sp
+	stw.w	lr, [sp+], #-4
+	b.l	sleep_phys_sp
+	ldw	r1, =sleep_save_sp
+	stw	r0, [r1]
+	ldw.w	pc, [sp]+, #4
+
+/*
+ * puv3_cpu_suspend()
+ *
+ * Forces CPU into sleep state.
+ *
+ * r0 = value for PWRMODE M field for desired sleep state
+ */
+
+ENTRY(puv3_cpu_suspend)
+	stm.w	(r16 - r27, lr), [sp-]		@ save registers on stack
+	stm.w	(r4 - r15), [sp-]		@ save registers on stack
+
+#ifdef	CONFIG_UNICORE_FPU_F64
+	sfm.w	(f0  - f7 ), [sp-]
+	sfm.w	(f8  - f15), [sp-]
+	sfm.w	(f16 - f23), [sp-]
+	sfm.w	(f24 - f31), [sp-]
+	cff	r4, s31
+	stm.w	(r4), [sp-]
+#endif
+	b.l	pkunity_cpu_save_cp
+
+	b.l	pkunity_cpu_save_sp
+
+	@ clean data cache
+	mov	r1, #0
+	movc	p0.c5, r1, #14
+	nop
+	nop
+	nop
+	nop
+
+
+
+	@ DDR2 BaseAddr
+	ldw	r0, =io_p2v(PKUNITY_DDR2CTRL_BASE)
+
+	@ PM BaseAddr
+	ldw	r1, =io_p2v(PKUNITY_PM_BASE)
+
+	@ set PLL_SYS_CFG reg, 275
+	movl	r6, #0x00002401
+	stw	r6, [r1+], #0x18
+	@ set PLL_DDR_CFG reg, 66MHz
+	movl	r6, #0x00100c00
+	stw	r6, [r1+], #0x1c
+
+	@ set wake up source
+	movl	r8, #0x800001ff		@ epip4d
+	stw	r8, [r1+], #0xc
+
+	@ set PGSR
+	movl	r5, #0x40000
+	stw	r5, [r1+], #0x10
+
+	@ prepare DDR2 refresh settings
+	ldw	r5, [r0+], #0x24
+	or	r5, r5, #0x00000001
+
+	@ prepare PMCR for PLL changing
+	movl	r6, #0xc
+
+	@ prepare for closing PLL
+	movl	r7, #0x1
+
+	@ prepare sleep mode
+	mov	r8, #0x1
+
+@	movl	r0, 0x11111111
+@	put_word_ocd r0
+	b	pkunity_cpu_do_suspend
+
+	.ltorg
+	.align	5
+pkunity_cpu_do_suspend:
+	b	101f
+	@ put DDR2 into self-refresh
+100:	stw	r5, [r0+], #0x24
+	@ change PLL
+	stw	r6, [r1]
+	b	1f
+
+	.ltorg
+	.align	5
+101:	b	102f
+	@ wait for PLL changing complete
+1:	ldw	r6, [r1+], #0x44
+	csub.a	r6, #0x1
+	bne	1b
+	b	2f
+
+	.ltorg
+	.align	5
+102:	b	100b
+	@ close PLL
+2:	stw	r7, [r1+], #0x4
+	@ enter sleep mode
+	stw	r8, [r1]
+3:	b	3b
+
+
+
+
+/*
+ * puv3_cpu_resume()
+ *
+ * entry point from bootloader into kernel during resume
+ *
+ * Note: Yes, part of the following code is located into the .data section.
+ *       This is to allow sleep_save_sp to be accessed with a relative load
+ *       while we can't rely on any MMU translation.  We could have put
+ *       sleep_save_sp in the .text section as well, but some setups might
+ *       insist on it to be truly read-only.
+ */
+
+	.data
+	.align 5
+ENTRY(puv3_cpu_resume)
+@	movl	r0, 0x20202020
+@	put_word_ocd r0
+
+	ldw	r0, sleep_save_sp		@ stack phys addr
+	ldw	r2, =resume_after_mmu		@ its absolute virtual address
+	ldm	(r3 - r6), [r0]+		@ CP regs + virt stack ptr
+	mov	sp, r6				@ CP regs + virt stack ptr
+
+	mov	r1, #0
+	movc	p0.c6, r1, #6			@ invalidate I & D TLBs
+	movc	p0.c5, r1, #28			@ invalidate I & D caches, BTB
+
+	movc	p0.c7, r3, #0			@ PID
+	movc	p0.c2, r4, #0			@ translation table base addr
+	movc	p0.c1, r5, #0			@ control reg, turn on mmu
+	nop
+	jump	r2
+	nop
+	nop
+	nop
+	nop
+	nop
+
+sleep_save_sp:
+	.word	0				@ preserve stack phys ptr here
+
+	.text
+resume_after_mmu:
+@	movl	r0, 0x30303030
+@	put_word_ocd r0
+
+#ifdef	CONFIG_UNICORE_FPU_F64
+	lfm.w	(f0  - f7 ), [sp]+
+	lfm.w	(f8  - f15), [sp]+
+	lfm.w	(f16 - f23), [sp]+
+	lfm.w	(f24 - f31), [sp]+
+	ldm.w	(r4), [sp]+
+	ctf	r4, s31
+#endif
+	ldm.w	(r4 - r15), [sp]+		@ restore registers from stack
+	ldm.w	(r16 - r27, pc), [sp]+		@ return to caller
-- 
1.6.2.2


