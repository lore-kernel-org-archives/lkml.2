Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753476Ab2HTCvT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2012 22:51:19 -0400
Received: from na3sys009aog102.obsmtp.com ([74.125.149.69]:44591 "EHLO
	na3sys009aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751824Ab2HTCuw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2012 22:50:52 -0400
From: Chao Xie <xiechao.mail@gmail.com>
To: haojian.zhuang@gmail.com, mturquette@linaro.org, viresh.linux@gmail.com,
        s.hauer@pengutronix.de, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, chao.xie@marvell.com,
        arnd@arndb.de
Cc: Chao Xie <xiechao.mail@gmail.com>
Subject: [PATCH V5 1/5] clk: mmp: add mmp specific clocks
Date: Mon, 20 Aug 2012 10:55:11 +0800
Message-Id: <1345431315-8037-2-git-send-email-xiechao.mail@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1345431315-8037-1-git-send-email-xiechao.mail@gmail.com>
References: <1345431315-8037-1-git-send-email-xiechao.mail@gmail.com>
X-OriginalArrivalTime: 20 Aug 2012 02:50:33.0962 (UTC) FILETIME=[91BC2CA0:01CD7E7E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chao Xie <chao.xie@marvell.com>

add mmp specific clocks including apbc cloks, apmu clocks,
and pll2, fraction clocks

Signed-off-by: Chao Xie <xiechao.mail@gmail.com>
---
 drivers/clk/Makefile       |    3 +
 drivers/clk/mmp/Makefile   |    5 ++
 drivers/clk/mmp/clk-apbc.c |  152 +++++++++++++++++++++++++++++++++++++++++++
 drivers/clk/mmp/clk-apmu.c |   97 ++++++++++++++++++++++++++++
 drivers/clk/mmp/clk-frac.c |  153 ++++++++++++++++++++++++++++++++++++++++++++
 drivers/clk/mmp/clk.h      |   35 ++++++++++
 6 files changed, 445 insertions(+), 0 deletions(-)
 create mode 100644 drivers/clk/mmp/Makefile
 create mode 100644 drivers/clk/mmp/clk-apbc.c
 create mode 100644 drivers/clk/mmp/clk-apmu.c
 create mode 100644 drivers/clk/mmp/clk-frac.c
 create mode 100644 drivers/clk/mmp/clk.h

diff --git a/drivers/clk/Makefile b/drivers/clk/Makefile
index 5869ea3..58590c8 100644
--- a/drivers/clk/Makefile
+++ b/drivers/clk/Makefile
@@ -10,6 +10,9 @@ obj-$(CONFIG_ARCH_SOCFPGA)	+= socfpga/
 obj-$(CONFIG_PLAT_SPEAR)	+= spear/
 obj-$(CONFIG_ARCH_U300)		+= clk-u300.o
 obj-$(CONFIG_ARCH_INTEGRATOR)	+= versatile/
+ifeq ($(CONFIG_COMMON_CLK), y)
+obj-$(CONFIG_ARCH_MMP)		+= mmp/
+endif
 
 # Chip specific
 obj-$(CONFIG_COMMON_CLK_WM831X) += clk-wm831x.o
diff --git a/drivers/clk/mmp/Makefile b/drivers/clk/mmp/Makefile
new file mode 100644
index 0000000..b5bc88c
--- /dev/null
+++ b/drivers/clk/mmp/Makefile
@@ -0,0 +1,5 @@
+#
+# Makefile for mmp specific clk
+#
+
+obj-y += clk-apbc.o clk-apmu.o clk-frac.o
diff --git a/drivers/clk/mmp/clk-apbc.c b/drivers/clk/mmp/clk-apbc.c
new file mode 100644
index 0000000..d14120e
--- /dev/null
+++ b/drivers/clk/mmp/clk-apbc.c
@@ -0,0 +1,152 @@
+/*
+ * mmp APB clock operation source file
+ *
+ * Copyright (C) 2012 Marvell
+ * Chao Xie <xiechao.mail@gmail.com>
+ *
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2. This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+
+#include <linux/kernel.h>
+#include <linux/clk.h>
+#include <linux/io.h>
+#include <linux/err.h>
+#include <linux/delay.h>
+#include <linux/slab.h>
+
+#include "clk.h"
+
+/* Common APB clock register bit definitions */
+#define APBC_APBCLK	(1 << 0)  /* APB Bus Clock Enable */
+#define APBC_FNCLK	(1 << 1)  /* Functional Clock Enable */
+#define APBC_RST	(1 << 2)  /* Reset Generation */
+#define APBC_POWER	(1 << 7)  /* Reset Generation */
+
+#define to_clk_apbc(hw) container_of(hw, struct clk_apbc, hw)
+struct clk_apbc {
+	struct clk_hw		hw;
+	void __iomem		*base;
+	unsigned int		delay;
+	unsigned int		flags;
+	spinlock_t		*lock;
+};
+
+static int clk_apbc_prepare(struct clk_hw *hw)
+{
+	struct clk_apbc *apbc = to_clk_apbc(hw);
+	unsigned int data;
+	unsigned long flags = 0;
+
+	/*
+	 * It may share same register as MUX clock,
+	 * and it will impact FNCLK enable. Spinlock is needed
+	 */
+	if (apbc->lock)
+		spin_lock_irqsave(apbc->lock, flags);
+
+	data = readl_relaxed(apbc->base);
+	if (apbc->flags & APBC_POWER_CTRL)
+		data |= APBC_POWER;
+	data |= APBC_FNCLK;
+	writel_relaxed(data, apbc->base);
+
+	if (apbc->lock)
+		spin_unlock_irqrestore(apbc->lock, flags);
+
+	udelay(apbc->delay);
+
+	if (apbc->lock)
+		spin_lock_irqsave(apbc->lock, flags);
+
+	data = readl_relaxed(apbc->base);
+	data |= APBC_APBCLK;
+	writel_relaxed(data, apbc->base);
+
+	if (apbc->lock)
+		spin_unlock_irqrestore(apbc->lock, flags);
+
+	udelay(apbc->delay);
+
+	if (!(apbc->flags & APBC_NO_BUS_CTRL)) {
+		if (apbc->lock)
+			spin_lock_irqsave(apbc->lock, flags);
+
+		data = readl_relaxed(apbc->base);
+		data &= ~APBC_RST;
+		writel_relaxed(data, apbc->base);
+
+		if (apbc->lock)
+			spin_unlock_irqrestore(apbc->lock, flags);
+	}
+
+	return 0;
+}
+
+static void clk_apbc_unprepare(struct clk_hw *hw)
+{
+	struct clk_apbc *apbc = to_clk_apbc(hw);
+	unsigned long data;
+	unsigned long flags = 0;
+
+	if (apbc->lock)
+		spin_lock_irqsave(apbc->lock, flags);
+
+	data = readl_relaxed(apbc->base);
+	if (apbc->flags & APBC_POWER_CTRL)
+		data &= ~APBC_POWER;
+	data &= ~APBC_FNCLK;
+	writel_relaxed(data, apbc->base);
+
+	if (apbc->lock)
+		spin_unlock_irqrestore(apbc->lock, flags);
+
+	udelay(10);
+
+	if (apbc->lock)
+		spin_lock_irqsave(apbc->lock, flags);
+
+	data = readl_relaxed(apbc->base);
+	data &= ~APBC_APBCLK;
+	writel_relaxed(data, apbc->base);
+
+	if (apbc->lock)
+		spin_unlock_irqrestore(apbc->lock, flags);
+}
+
+struct clk_ops clk_apbc_ops = {
+	.prepare = clk_apbc_prepare,
+	.unprepare = clk_apbc_unprepare,
+};
+
+struct clk *mmp_clk_register_apbc(const char *name, const char *parent_name,
+		void __iomem *base, unsigned int delay,
+		unsigned int apbc_flags, spinlock_t *lock)
+{
+	struct clk_apbc *apbc;
+	struct clk *clk;
+	struct clk_init_data init;
+
+	apbc = kzalloc(sizeof(*apbc), GFP_KERNEL);
+	if (!apbc)
+		return NULL;
+
+	init.name = name;
+	init.ops = &clk_apbc_ops;
+	init.flags = CLK_SET_RATE_PARENT;
+	init.parent_names = (parent_name ? &parent_name : NULL);
+	init.num_parents = (parent_name ? 1 : 0);
+
+	apbc->base = base;
+	apbc->delay = delay;
+	apbc->flags = apbc_flags;
+	apbc->lock = lock;
+	apbc->hw.init = &init;
+
+	clk = clk_register(NULL, &apbc->hw);
+	if (IS_ERR(clk))
+		kfree(apbc);
+
+	return clk;
+}
diff --git a/drivers/clk/mmp/clk-apmu.c b/drivers/clk/mmp/clk-apmu.c
new file mode 100644
index 0000000..abe182b
--- /dev/null
+++ b/drivers/clk/mmp/clk-apmu.c
@@ -0,0 +1,97 @@
+/*
+ * mmp AXI peripharal clock operation source file
+ *
+ * Copyright (C) 2012 Marvell
+ * Chao Xie <xiechao.mail@gmail.com>
+ *
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2. This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+
+#include <linux/kernel.h>
+#include <linux/clk.h>
+#include <linux/io.h>
+#include <linux/err.h>
+#include <linux/delay.h>
+#include <linux/slab.h>
+
+#include "clk.h"
+
+#define to_clk_apmu(clk) (container_of(clk, struct clk_apmu, clk))
+struct clk_apmu {
+	struct clk_hw   hw;
+	void __iomem    *base;
+	u32		rst_mask;
+	u32		enable_mask;
+	spinlock_t	*lock;
+};
+
+static int clk_apmu_enable(struct clk_hw *hw)
+{
+	struct clk_apmu *apmu = to_clk_apmu(hw);
+	unsigned long data;
+	unsigned long flags = 0;
+
+	if (apmu->lock)
+		spin_lock_irqsave(apmu->lock, flags);
+
+	data = readl_relaxed(apmu->base) | apmu->enable_mask;
+	writel_relaxed(data, apmu->base);
+
+	if (apmu->lock)
+		spin_unlock_irqrestore(apmu->lock, flags);
+
+	return 0;
+}
+
+static void clk_apmu_disable(struct clk_hw *hw)
+{
+	struct clk_apmu *apmu = to_clk_apmu(hw);
+	unsigned long data;
+	unsigned long flags = 0;
+
+	if (apmu->lock)
+		spin_lock_irqsave(apmu->lock, flags);
+
+	data = readl_relaxed(apmu->base) & ~apmu->enable_mask;
+	writel_relaxed(data, apmu->base);
+
+	if (apmu->lock)
+		spin_unlock_irqrestore(apmu->lock, flags);
+}
+
+struct clk_ops clk_apmu_ops = {
+	.enable = clk_apmu_enable,
+	.disable = clk_apmu_disable,
+};
+
+struct clk *mmp_clk_register_apmu(const char *name, const char *parent_name,
+		void __iomem *base, u32 enable_mask, spinlock_t *lock)
+{
+	struct clk_apmu *apmu;
+	struct clk *clk;
+	struct clk_init_data init;
+
+	apmu = kzalloc(sizeof(*apmu), GFP_KERNEL);
+	if (!apmu)
+		return NULL;
+
+	init.name = name;
+	init.ops = &clk_apmu_ops;
+	init.flags = CLK_SET_RATE_PARENT;
+	init.parent_names = (parent_name ? &parent_name : NULL);
+	init.num_parents = (parent_name ? 1 : 0);
+
+	apmu->base = base;
+	apmu->enable_mask = enable_mask;
+	apmu->lock = lock;
+	apmu->hw.init = &init;
+
+	clk = clk_register(NULL, &apmu->hw);
+
+	if (IS_ERR(clk))
+		kfree(apmu);
+
+	return clk;
+}
diff --git a/drivers/clk/mmp/clk-frac.c b/drivers/clk/mmp/clk-frac.c
new file mode 100644
index 0000000..80c1dd1
--- /dev/null
+++ b/drivers/clk/mmp/clk-frac.c
@@ -0,0 +1,153 @@
+/*
+ * mmp factor clock operation source file
+ *
+ * Copyright (C) 2012 Marvell
+ * Chao Xie <xiechao.mail@gmail.com>
+ *
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2. This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+
+#include <linux/clk-provider.h>
+#include <linux/slab.h>
+#include <linux/io.h>
+#include <linux/err.h>
+
+#include "clk.h"
+/*
+ * It is M/N clock
+ *
+ * Fout from synthesizer can be given from two equations:
+ * numerator/denominator = Fin / (Fout * factor)
+ */
+
+#define to_clk_factor(hw) container_of(hw, struct clk_factor, hw)
+struct clk_factor {
+	struct clk_hw		hw;
+	void __iomem		*base;
+	struct clk_factor_masks	*masks;
+	struct clk_factor_tbl	*ftbl;
+	unsigned int		ftbl_cnt;
+};
+
+static long clk_factor_round_rate(struct clk_hw *hw, unsigned long drate,
+		unsigned long *prate)
+{
+	struct clk_factor *factor = to_clk_factor(hw);
+	unsigned long rate = 0, prev_rate;
+	int i;
+
+	for (i = 0; i < factor->ftbl_cnt; i++) {
+		prev_rate = rate;
+		rate = (((*prate / 10000) * factor->ftbl[i].num) /
+			(factor->ftbl[i].den * factor->masks->factor)) * 10000;
+		if (rate > drate)
+			break;
+	}
+	if (i == 0)
+		return rate;
+	else
+		return prev_rate;
+}
+
+static unsigned long clk_factor_recalc_rate(struct clk_hw *hw,
+		unsigned long parent_rate)
+{
+	struct clk_factor *factor = to_clk_factor(hw);
+	struct clk_factor_masks *masks = factor->masks;
+	unsigned int val, num, den;
+
+	val = readl_relaxed(factor->base);
+
+	/* calculate numerator */
+	num = (val >> masks->num_shift) & masks->num_mask;
+
+	/* calculate denominator */
+	den = (val >> masks->den_shift) & masks->num_mask;
+
+	if (!den)
+		return 0;
+
+	return (((parent_rate / 10000)  * den) /
+			(num * factor->masks->factor)) * 10000;
+}
+
+/* Configures new clock rate*/
+static int clk_factor_set_rate(struct clk_hw *hw, unsigned long drate,
+				unsigned long prate)
+{
+	struct clk_factor *factor = to_clk_factor(hw);
+	struct clk_factor_masks *masks = factor->masks;
+	int i;
+	unsigned long val;
+	unsigned long prev_rate, rate = 0;
+
+	for (i = 0; i < factor->ftbl_cnt; i++) {
+		prev_rate = rate;
+		rate = (((prate / 10000) * factor->ftbl[i].num) /
+			(factor->ftbl[i].den * factor->masks->factor)) * 10000;
+		if (rate > drate)
+			break;
+	}
+	if (i > 0)
+		i--;
+
+	val = readl_relaxed(factor->base);
+
+	val &= ~(masks->num_mask << masks->num_shift);
+	val |= (factor->ftbl[i].num & masks->num_mask) << masks->num_shift;
+
+	val &= ~(masks->den_mask << masks->den_shift);
+	val |= (factor->ftbl[i].den & masks->den_mask) << masks->den_shift;
+
+	writel_relaxed(val, factor->base);
+
+	return 0;
+}
+
+static struct clk_ops clk_factor_ops = {
+	.recalc_rate = clk_factor_recalc_rate,
+	.round_rate = clk_factor_round_rate,
+	.set_rate = clk_factor_set_rate,
+};
+
+struct clk *mmp_clk_register_factor(const char *name, const char *parent_name,
+		unsigned long flags, void __iomem *base,
+		struct clk_factor_masks *masks, struct clk_factor_tbl *ftbl,
+		unsigned int ftbl_cnt)
+{
+	struct clk_factor *factor;
+	struct clk_init_data init;
+	struct clk *clk;
+
+	if (!masks) {
+		pr_err("%s: must pass a clk_factor_mask\n", __func__);
+		return ERR_PTR(-EINVAL);
+	}
+
+	factor = kzalloc(sizeof(*factor), GFP_KERNEL);
+	if (!factor) {
+		pr_err("%s: could not allocate factor  clk\n", __func__);
+		return ERR_PTR(-ENOMEM);
+	}
+
+	/* struct clk_aux assignments */
+	factor->base = base;
+	factor->masks = masks;
+	factor->ftbl = ftbl;
+	factor->ftbl_cnt = ftbl_cnt;
+	factor->hw.init = &init;
+
+	init.name = name;
+	init.ops = &clk_factor_ops;
+	init.flags = flags;
+	init.parent_names = &parent_name;
+	init.num_parents = 1;
+
+	clk = clk_register(NULL, &factor->hw);
+	if (IS_ERR_OR_NULL(clk))
+		kfree(factor);
+
+	return clk;
+}
diff --git a/drivers/clk/mmp/clk.h b/drivers/clk/mmp/clk.h
new file mode 100644
index 0000000..ab86dd4
--- /dev/null
+++ b/drivers/clk/mmp/clk.h
@@ -0,0 +1,35 @@
+#ifndef __MACH_MMP_CLK_H
+#define __MACH_MMP_CLK_H
+
+#include <linux/clk-provider.h>
+#include <linux/clkdev.h>
+
+#define APBC_NO_BUS_CTRL	BIT(0)
+#define APBC_POWER_CTRL		BIT(1)
+
+struct clk_factor_masks {
+	unsigned int	factor;
+	unsigned int	num_mask;
+	unsigned int	den_mask;
+	unsigned int	num_shift;
+	unsigned int	den_shift;
+};
+
+struct clk_factor_tbl {
+	unsigned int num;
+	unsigned int den;
+};
+
+extern struct clk *mmp_clk_register_pll2(const char *name,
+		const char *parent_name, unsigned long flags);
+extern struct clk *mmp_clk_register_apbc(const char *name,
+		const char *parent_name, void __iomem *base,
+		unsigned int delay, unsigned int apbc_flags, spinlock_t *lock);
+extern struct clk *mmp_clk_register_apmu(const char *name,
+		const char *parent_name, void __iomem *base, u32 enable_mask,
+		spinlock_t *lock);
+extern struct clk *mmp_clk_register_factor(const char *name,
+		const char *parent_name, unsigned long flags,
+		void __iomem *base, struct clk_factor_masks *masks,
+		struct clk_factor_tbl *ftbl, unsigned int ftbl_cnt);
+#endif
-- 
1.7.0.4

