Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756946Ab2IUC3l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 22:29:41 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:8103 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756791Ab2IUC1D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 22:27:03 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6841"; a="239432301"
From: Stephen Boyd <sboyd@codeaurora.org>
To: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Saravana Kannan <skannan@codeaurora.org>,
        Mike Turquette <mturquette@linaro.org>
Subject: [PATCH 10/10] ARM: msm: Migrate to common clock framework
Date: Thu, 20 Sep 2012 19:26:58 -0700
Message-Id: <1348194419-11486-11-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.7.12.1.382.gb0576a6
In-Reply-To: <1348194419-11486-1-git-send-email-sboyd@codeaurora.org>
References: <1348194419-11486-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the existing clock code in mach-msm to the common clock
framework. We lose our capability to set the rate of and enable a
clock through debugfs. This is ok though because the debugfs
features are mainly used for testing and development of new clock
code.

To maintain compatibility with the original MSM clock code we
make a wrapper for clk_reset() that calls the struct msm_clk
specific reset function. This is necessary for the usb and sdcc
devices on MSM until a better suited API is made available.

Cc: Saravana Kannan <skannan@codeaurora.org>
Cc: Mike Turquette <mturquette@linaro.org>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 arch/arm/Kconfig                    |   1 +
 arch/arm/mach-msm/Makefile          |   1 -
 arch/arm/mach-msm/clock-debug.c     | 123 ------------------------------
 arch/arm/mach-msm/clock-pcom.c      | 118 ++++++++++++++++++-----------
 arch/arm/mach-msm/clock-pcom.h      |  30 ++++----
 arch/arm/mach-msm/clock.c           | 146 ++----------------------------------
 arch/arm/mach-msm/clock.h           |  46 +++---------
 arch/arm/mach-msm/devices-msm7x00.c |   2 +-
 arch/arm/mach-msm/devices-msm7x30.c |   2 +-
 arch/arm/mach-msm/devices-qsd8x50.c |   2 +-
 10 files changed, 108 insertions(+), 363 deletions(-)
 delete mode 100644 arch/arm/mach-msm/clock-debug.c

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 433e9b8..2809213 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -727,6 +727,7 @@ config ARCH_MSM
 	select GENERIC_CLOCKEVENTS
 	select ARCH_REQUIRE_GPIOLIB
 	select CLKDEV_LOOKUP
+	select COMMON_CLK
 	help
 	  Support for Qualcomm MSM/QSD based systems.  This runs on the
 	  apps processor of the MSM/QSD and depends on a shared memory
diff --git a/arch/arm/mach-msm/Makefile b/arch/arm/mach-msm/Makefile
index 3dbae74..700d77b 100644
--- a/arch/arm/mach-msm/Makefile
+++ b/arch/arm/mach-msm/Makefile
@@ -1,6 +1,5 @@
 obj-y += io.o timer.o
 obj-y += clock.o
-obj-$(CONFIG_DEBUG_FS) += clock-debug.o
 
 obj-$(CONFIG_MSM_VIC) += irq-vic.o
 obj-$(CONFIG_MSM_IOMMU) += devices-iommu.o
diff --git a/arch/arm/mach-msm/clock-debug.c b/arch/arm/mach-msm/clock-debug.c
deleted file mode 100644
index c4b34d7..0000000
--- a/arch/arm/mach-msm/clock-debug.c
+++ /dev/null
@@ -1,123 +0,0 @@
-/*
- * Copyright (C) 2007 Google, Inc.
- * Copyright (c) 2007-2010, Code Aurora Forum. All rights reserved.
- *
- * This software is licensed under the terms of the GNU General Public
- * License version 2, as published by the Free Software Foundation, and
- * may be copied, distributed, and modified under those terms.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.	 See the
- * GNU General Public License for more details.
- *
- */
-
-#include <linux/kernel.h>
-#include <linux/module.h>
-#include <linux/ctype.h>
-#include <linux/debugfs.h>
-#include <linux/clk.h>
-#include "clock.h"
-
-static int clock_debug_rate_set(void *data, u64 val)
-{
-	struct clk *clock = data;
-	int ret;
-
-	ret = clk_set_rate(clock, val);
-	if (ret != 0)
-		printk(KERN_ERR "clk_set%s_rate failed (%d)\n",
-			(clock->flags & CLK_MIN) ? "_min" : "", ret);
-	return ret;
-}
-
-static int clock_debug_rate_get(void *data, u64 *val)
-{
-	struct clk *clock = data;
-	*val = clk_get_rate(clock);
-	return 0;
-}
-
-DEFINE_SIMPLE_ATTRIBUTE(clock_rate_fops, clock_debug_rate_get,
-			clock_debug_rate_set, "%llu\n");
-
-static int clock_debug_enable_set(void *data, u64 val)
-{
-	struct clk *clock = data;
-	int rc = 0;
-
-	if (val)
-		rc = clock->ops->enable(clock->id);
-	else
-		clock->ops->disable(clock->id);
-
-	return rc;
-}
-
-static int clock_debug_enable_get(void *data, u64 *val)
-{
-	struct clk *clock = data;
-
-	*val = clock->ops->is_enabled(clock->id);
-
-	return 0;
-}
-
-DEFINE_SIMPLE_ATTRIBUTE(clock_enable_fops, clock_debug_enable_get,
-			clock_debug_enable_set, "%llu\n");
-
-static int clock_debug_local_get(void *data, u64 *val)
-{
-	struct clk *clock = data;
-
-	*val = clock->ops->is_local(clock->id);
-
-	return 0;
-}
-
-DEFINE_SIMPLE_ATTRIBUTE(clock_local_fops, clock_debug_local_get,
-			NULL, "%llu\n");
-
-static struct dentry *debugfs_base;
-
-int __init clock_debug_init(void)
-{
-	debugfs_base = debugfs_create_dir("clk", NULL);
-	if (!debugfs_base)
-		return -ENOMEM;
-	return 0;
-}
-
-int __init clock_debug_add(struct clk *clock)
-{
-	char temp[50], *ptr;
-	struct dentry *clk_dir;
-
-	if (!debugfs_base)
-		return -ENOMEM;
-
-	strncpy(temp, clock->dbg_name, ARRAY_SIZE(temp)-1);
-	for (ptr = temp; *ptr; ptr++)
-		*ptr = tolower(*ptr);
-
-	clk_dir = debugfs_create_dir(temp, debugfs_base);
-	if (!clk_dir)
-		return -ENOMEM;
-
-	if (!debugfs_create_file("rate", S_IRUGO | S_IWUSR, clk_dir,
-				clock, &clock_rate_fops))
-		goto error;
-
-	if (!debugfs_create_file("enable", S_IRUGO | S_IWUSR, clk_dir,
-				clock, &clock_enable_fops))
-		goto error;
-
-	if (!debugfs_create_file("is_local", S_IRUGO, clk_dir, clock,
-				&clock_local_fops))
-		goto error;
-	return 0;
-error:
-	debugfs_remove_recursive(clk_dir);
-	return -ENOMEM;
-}
diff --git a/arch/arm/mach-msm/clock-pcom.c b/arch/arm/mach-msm/clock-pcom.c
index 7c4c60a..13c9430 100644
--- a/arch/arm/mach-msm/clock-pcom.c
+++ b/arch/arm/mach-msm/clock-pcom.c
@@ -1,6 +1,6 @@
 /*
  * Copyright (C) 2007 Google, Inc.
- * Copyright (c) 2007-2010, Code Aurora Forum. All rights reserved.
+ * Copyright (c) 2007-2012, The Linux Foundation. All rights reserved.
  *
  * This software is licensed under the terms of the GNU General Public
  * License version 2, as published by the Free Software Foundation, and
@@ -13,9 +13,12 @@
  *
  */
 
+#include <linux/kernel.h>
 #include <linux/err.h>
 #include <linux/platform_device.h>
 #include <linux/module.h>
+#include <linux/clk-provider.h>
+#include <linux/clkdev.h>
 
 #include <mach/clk.h>
 
@@ -23,11 +26,20 @@
 #include "clock.h"
 #include "clock-pcom.h"
 
-/*
- * glue for the proc_comm interface
- */
-static int pc_clk_enable(unsigned id)
+struct clk_pcom {
+	unsigned id;
+	unsigned long flags;
+	struct msm_clk msm_clk;
+};
+
+static inline struct clk_pcom *to_clk_pcom(struct clk_hw *hw)
 {
+	return container_of(to_msm_clk(hw), struct clk_pcom, msm_clk);
+}
+
+static int pc_clk_enable(struct clk_hw *hw)
+{
+	unsigned id = to_clk_pcom(hw)->id;
 	int rc = msm_proc_comm(PCOM_CLKCTL_RPC_ENABLE, &id, NULL);
 	if (rc < 0)
 		return rc;
@@ -35,14 +47,16 @@ static int pc_clk_enable(unsigned id)
 		return (int)id < 0 ? -EINVAL : 0;
 }
 
-static void pc_clk_disable(unsigned id)
+static void pc_clk_disable(struct clk_hw *hw)
 {
+	unsigned id = to_clk_pcom(hw)->id;
 	msm_proc_comm(PCOM_CLKCTL_RPC_DISABLE, &id, NULL);
 }
 
-int pc_clk_reset(unsigned id, enum clk_reset_action action)
+static int pc_clk_reset(struct clk_hw *hw, enum clk_reset_action action)
 {
 	int rc;
+	unsigned id = to_clk_pcom(hw)->id;
 
 	if (action == CLK_RESET_ASSERT)
 		rc = msm_proc_comm(PCOM_CLKCTL_RPC_RESET_ASSERT, &id, NULL);
@@ -55,83 +69,99 @@ int pc_clk_reset(unsigned id, enum clk_reset_action action)
 		return (int)id < 0 ? -EINVAL : 0;
 }
 
-static int pc_clk_set_rate(unsigned id, unsigned rate)
+static int pc_clk_set_rate(struct clk_hw *hw, unsigned long new_rate,
+			   unsigned long p_rate)
 {
-	/* The rate _might_ be rounded off to the nearest KHz value by the
+	struct clk_pcom *p = to_clk_pcom(hw);
+	unsigned id = p->id, rate = new_rate;
+	int rc;
+
+	/*
+	 * The rate _might_ be rounded off to the nearest KHz value by the
 	 * remote function. So a return value of 0 doesn't necessarily mean
 	 * that the exact rate was set successfully.
 	 */
-	int rc = msm_proc_comm(PCOM_CLKCTL_RPC_SET_RATE, &id, &rate);
-	if (rc < 0)
-		return rc;
-	else
-		return (int)id < 0 ? -EINVAL : 0;
-}
-
-static int pc_clk_set_min_rate(unsigned id, unsigned rate)
-{
-	int rc = msm_proc_comm(PCOM_CLKCTL_RPC_MIN_RATE, &id, &rate);
-	if (rc < 0)
-		return rc;
+	if (p->flags & CLKFLAG_MIN)
+		rc = msm_proc_comm(PCOM_CLKCTL_RPC_MIN_RATE, &id, &rate);
 	else
-		return (int)id < 0 ? -EINVAL : 0;
-}
-
-static int pc_clk_set_max_rate(unsigned id, unsigned rate)
-{
-	int rc = msm_proc_comm(PCOM_CLKCTL_RPC_MAX_RATE, &id, &rate);
+		rc = msm_proc_comm(PCOM_CLKCTL_RPC_SET_RATE, &id, &rate);
 	if (rc < 0)
 		return rc;
 	else
 		return (int)id < 0 ? -EINVAL : 0;
 }
 
-static unsigned pc_clk_get_rate(unsigned id)
+static unsigned long pc_clk_recalc_rate(struct clk_hw *hw, unsigned long p_rate)
 {
+	unsigned id = to_clk_pcom(hw)->id;
 	if (msm_proc_comm(PCOM_CLKCTL_RPC_RATE, &id, NULL))
 		return 0;
 	else
 		return id;
 }
 
-static unsigned pc_clk_is_enabled(unsigned id)
+static int pc_clk_is_enabled(struct clk_hw *hw)
 {
+	unsigned id = to_clk_pcom(hw)->id;
 	if (msm_proc_comm(PCOM_CLKCTL_RPC_ENABLED, &id, NULL))
 		return 0;
 	else
 		return id;
 }
 
-static long pc_clk_round_rate(unsigned id, unsigned rate)
+static long pc_clk_round_rate(struct clk_hw *hw, unsigned long rate,
+			      unsigned long *p_rate)
 {
-
 	/* Not really supported; pc_clk_set_rate() does rounding on it's own. */
 	return rate;
 }
 
-static bool pc_clk_is_local(unsigned id)
-{
-	return false;
-}
-
-struct clk_ops clk_ops_pcom = {
+static struct clk_ops clk_ops_pcom = {
 	.enable = pc_clk_enable,
 	.disable = pc_clk_disable,
-	.auto_off = pc_clk_disable,
-	.reset = pc_clk_reset,
 	.set_rate = pc_clk_set_rate,
-	.set_min_rate = pc_clk_set_min_rate,
-	.set_max_rate = pc_clk_set_max_rate,
-	.get_rate = pc_clk_get_rate,
+	.recalc_rate = pc_clk_recalc_rate,
 	.is_enabled = pc_clk_is_enabled,
 	.round_rate = pc_clk_round_rate,
-	.is_local = pc_clk_is_local,
 };
 
 static int __devinit msm_clock_pcom_probe(struct platform_device *pdev)
 {
 	struct pcom_clk_pdata *pdata = pdev->dev.platform_data;
-	msm_clock_init(pdata->lookup, pdata->num_lookups);
+	int i, ret;
+
+	for (i = 0; i < pdata->num_lookups; i++) {
+		struct clk_pcom_desc *desc = &pdata->lookup[i];
+		struct clk *c;
+		struct clk_pcom *p;
+		struct clk_hw *hw;
+		struct clk_init_data init;
+
+		p = devm_kzalloc(&pdev->dev, sizeof(*p), GFP_KERNEL);
+		if (!p)
+			return -ENOMEM;
+
+		p->id = desc->id;
+		p->flags = desc->flags;
+		p->msm_clk.reset = pc_clk_reset;
+
+		hw = &p->msm_clk.hw;
+		hw->init = &init;
+
+		init.name = desc->name;
+		init.ops = &clk_ops_pcom;
+		init.num_parents = 0;
+		init.flags = CLK_IS_ROOT;
+
+		if (!(p->flags & CLKFLAG_AUTO_OFF))
+			init.flags |= CLK_IGNORE_UNUSED;
+
+		c = devm_clk_register(&pdev->dev, hw);
+		ret = clk_register_clkdev(c, desc->con, desc->dev);
+		if (ret)
+			return ret;
+	}
+
 	return 0;
 }
 
diff --git a/arch/arm/mach-msm/clock-pcom.h b/arch/arm/mach-msm/clock-pcom.h
index 87406a3..5bb164f 100644
--- a/arch/arm/mach-msm/clock-pcom.h
+++ b/arch/arm/mach-msm/clock-pcom.h
@@ -1,4 +1,5 @@
-/* Copyright (c) 2009, Code Aurora Forum. All rights reserved.
+/*
+ * Copyright (c) 2009-2012, The Linux Foundation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 and
@@ -120,26 +121,25 @@
 
 #define P_NR_CLKS		102
 
-struct clk_ops;
-extern struct clk_ops clk_ops_pcom;
+struct clk_pcom_desc {
+	unsigned id;
+	const char *name;
+	const char *con;
+	const char *dev;
+	unsigned long flags;
+};
 
 struct pcom_clk_pdata {
-	struct clk_lookup *lookup;
+	struct clk_pcom_desc *lookup;
 	u32 num_lookups;
 };
 
-int pc_clk_reset(unsigned id, enum clk_reset_action action);
-
 #define CLK_PCOM(clk_name, clk_id, clk_dev, clk_flags) {	\
-	.con_id = clk_name, \
-	.dev_id = clk_dev, \
-	.clk = &(struct clk){ \
-		.id = P_##clk_id, \
-		.remote_id = P_##clk_id, \
-		.ops = &clk_ops_pcom, \
-		.flags = clk_flags, \
-		.dbg_name = #clk_id, \
-	}, \
+	.id = P_##clk_id,					\
+	.name = #clk_id,					\
+	.con = clk_name,					\
+	.dev = clk_dev,						\
+	.flags = clk_flags,					\
 	}
 
 #endif
diff --git a/arch/arm/mach-msm/clock.c b/arch/arm/mach-msm/clock.c
index 01af7a4..35ea02b 100644
--- a/arch/arm/mach-msm/clock.c
+++ b/arch/arm/mach-msm/clock.c
@@ -1,7 +1,7 @@
 /* arch/arm/mach-msm/clock.c
  *
  * Copyright (C) 2007 Google, Inc.
- * Copyright (c) 2007-2010, Code Aurora Forum. All rights reserved.
+ * Copyright (c) 2007-2012, The Linux Foundation. All rights reserved.
  *
  * This software is licensed under the terms of the GNU General Public
  * License version 2, as published by the Free Software Foundation, and
@@ -14,151 +14,15 @@
  *
  */
 
-#include <linux/kernel.h>
-#include <linux/list.h>
-#include <linux/err.h>
-#include <linux/spinlock.h>
-#include <linux/pm_qos.h>
-#include <linux/mutex.h>
-#include <linux/clk.h>
-#include <linux/string.h>
+#include <linux/clk-provider.h>
 #include <linux/module.h>
-#include <linux/clkdev.h>
 
 #include "clock.h"
 
-static DEFINE_MUTEX(clocks_mutex);
-static DEFINE_SPINLOCK(clocks_lock);
-static LIST_HEAD(clocks);
-
-/*
- * Standard clock functions defined in include/linux/clk.h
- */
-int clk_enable(struct clk *clk)
-{
-	unsigned long flags;
-	spin_lock_irqsave(&clocks_lock, flags);
-	clk->count++;
-	if (clk->count == 1)
-		clk->ops->enable(clk->id);
-	spin_unlock_irqrestore(&clocks_lock, flags);
-	return 0;
-}
-EXPORT_SYMBOL(clk_enable);
-
-void clk_disable(struct clk *clk)
-{
-	unsigned long flags;
-	spin_lock_irqsave(&clocks_lock, flags);
-	BUG_ON(clk->count == 0);
-	clk->count--;
-	if (clk->count == 0)
-		clk->ops->disable(clk->id);
-	spin_unlock_irqrestore(&clocks_lock, flags);
-}
-EXPORT_SYMBOL(clk_disable);
-
 int clk_reset(struct clk *clk, enum clk_reset_action action)
 {
-	return clk->ops->reset(clk->remote_id, action);
+	struct clk_hw *hw = __clk_get_hw(clk);
+	struct msm_clk *m = to_msm_clk(hw);
+	return m->reset(hw, action);
 }
 EXPORT_SYMBOL(clk_reset);
-
-unsigned long clk_get_rate(struct clk *clk)
-{
-	return clk->ops->get_rate(clk->id);
-}
-EXPORT_SYMBOL(clk_get_rate);
-
-int clk_set_rate(struct clk *clk, unsigned long rate)
-{
-	int ret;
-	if (clk->flags & CLKFLAG_MAX) {
-		ret = clk->ops->set_max_rate(clk->id, rate);
-		if (ret)
-			return ret;
-	}
-	if (clk->flags & CLKFLAG_MIN) {
-		ret = clk->ops->set_min_rate(clk->id, rate);
-		if (ret)
-			return ret;
-	}
-
-	if (clk->flags & CLKFLAG_MAX || clk->flags & CLKFLAG_MIN)
-		return ret;
-
-	return clk->ops->set_rate(clk->id, rate);
-}
-EXPORT_SYMBOL(clk_set_rate);
-
-long clk_round_rate(struct clk *clk, unsigned long rate)
-{
-	return clk->ops->round_rate(clk->id, rate);
-}
-EXPORT_SYMBOL(clk_round_rate);
-
-int clk_set_parent(struct clk *clk, struct clk *parent)
-{
-	return -ENOSYS;
-}
-EXPORT_SYMBOL(clk_set_parent);
-
-struct clk *clk_get_parent(struct clk *clk)
-{
-	return ERR_PTR(-ENOSYS);
-}
-EXPORT_SYMBOL(clk_get_parent);
-
-/* EBI1 is the only shared clock that several clients want to vote on as of
- * this commit. If this changes in the future, then it might be better to
- * make clk_min_rate handle the voting or make ebi1_clk_set_min_rate more
- * generic to support different clocks.
- */
-static struct clk *ebi1_clk;
-
-void __devinit msm_clock_init(struct clk_lookup *clock_tbl, size_t num_clocks)
-{
-	unsigned n;
-
-	mutex_lock(&clocks_mutex);
-	for (n = 0; n < num_clocks; n++) {
-		clkdev_add(&clock_tbl[n]);
-		list_add_tail(&clock_tbl[n].clk->list, &clocks);
-	}
-	mutex_unlock(&clocks_mutex);
-
-	ebi1_clk = clk_get(NULL, "ebi1_clk");
-	BUG_ON(ebi1_clk == NULL);
-
-}
-
-/* The bootloader and/or AMSS may have left various clocks enabled.
- * Disable any clocks that belong to us (CLKFLAG_AUTO_OFF) but have
- * not been explicitly enabled by a clk_enable() call.
- */
-static int __init clock_late_init(void)
-{
-	unsigned long flags;
-	struct clk *clk;
-	unsigned count = 0;
-
-	clock_debug_init();
-	mutex_lock(&clocks_mutex);
-	list_for_each_entry(clk, &clocks, list) {
-		clock_debug_add(clk);
-		if (clk->flags & CLKFLAG_AUTO_OFF) {
-			spin_lock_irqsave(&clocks_lock, flags);
-			if (!clk->count) {
-				count++;
-				clk->ops->auto_off(clk->id);
-			}
-			spin_unlock_irqrestore(&clocks_lock, flags);
-		}
-	}
-	mutex_unlock(&clocks_mutex);
-	pr_info("clock_late_init() disabled %d unused clocks\n", count);
-	return 0;
-}
-
-late_initcall(clock_late_init);
-
diff --git a/arch/arm/mach-msm/clock.h b/arch/arm/mach-msm/clock.h
index cc76bfe..42d29dd 100644
--- a/arch/arm/mach-msm/clock.h
+++ b/arch/arm/mach-msm/clock.h
@@ -1,7 +1,7 @@
 /* arch/arm/mach-msm/clock.h
  *
  * Copyright (C) 2007 Google, Inc.
- * Copyright (c) 2007-2010, Code Aurora Forum. All rights reserved.
+ * Copyright (c) 2007-2012, The Linux Foundation. All rights reserved.
  *
  * This software is licensed under the terms of the GNU General Public
  * License version 2, as published by the Free Software Foundation, and
@@ -17,8 +17,7 @@
 #ifndef __ARCH_ARM_MACH_MSM_CLOCK_H
 #define __ARCH_ARM_MACH_MSM_CLOCK_H
 
-#include <linux/init.h>
-#include <linux/list.h>
+#include <linux/clk-provider.h>
 #include <mach/clk.h>
 
 #define CLK_FIRST_AVAILABLE_FLAG	0x00000100
@@ -26,44 +25,19 @@
 #define CLKFLAG_MIN			0x00000400
 #define CLKFLAG_MAX			0x00000800
 
-struct clk_ops {
-	int (*enable)(unsigned id);
-	void (*disable)(unsigned id);
-	void (*auto_off)(unsigned id);
-	int (*reset)(unsigned id, enum clk_reset_action action);
-	int (*set_rate)(unsigned id, unsigned rate);
-	int (*set_min_rate)(unsigned id, unsigned rate);
-	int (*set_max_rate)(unsigned id, unsigned rate);
-	unsigned (*get_rate)(unsigned id);
-	unsigned (*is_enabled)(unsigned id);
-	long (*round_rate)(unsigned id, unsigned rate);
-	bool (*is_local)(unsigned id);
-};
-
-struct clk {
-	uint32_t id;
-	uint32_t remote_id;
-	uint32_t count;
-	uint32_t flags;
-	struct clk_ops *ops;
-	const char *dbg_name;
-	struct list_head list;
-};
-
 #define OFF CLKFLAG_AUTO_OFF
 #define CLK_MIN CLKFLAG_MIN
 #define CLK_MAX CLKFLAG_MAX
 #define CLK_MINMAX (CLK_MIN | CLK_MAX)
 
-#ifdef CONFIG_DEBUG_FS
-int __init clock_debug_init(void);
-int __init clock_debug_add(struct clk *clock);
-#else
-static inline int __init clock_debug_init(void) { return 0; }
-static inline int __init clock_debug_add(struct clk *clock) { return 0; }
-#endif
+struct msm_clk {
+	int (*reset)(struct clk_hw *hw, enum clk_reset_action action);
+	struct clk_hw hw;
+};
 
-struct clk_lookup;
-void msm_clock_init(struct clk_lookup *clock_tbl, size_t num_clocks);
+static inline struct msm_clk *to_msm_clk(struct clk_hw *hw)
+{
+	return container_of(hw, struct msm_clk, hw);
+}
 
 #endif
diff --git a/arch/arm/mach-msm/devices-msm7x00.c b/arch/arm/mach-msm/devices-msm7x00.c
index 2e63a19..bda7ffd 100644
--- a/arch/arm/mach-msm/devices-msm7x00.c
+++ b/arch/arm/mach-msm/devices-msm7x00.c
@@ -394,7 +394,7 @@ struct platform_device msm_device_mdp = {
 	.resource = resources_mdp,
 };
 
-static struct clk_lookup msm_clocks_7x01a[] = {
+static struct clk_pcom_desc msm_clocks_7x01a[] = {
 	CLK_PCOM("adm_clk",	ADM_CLK,	NULL, 0),
 	CLK_PCOM("adsp_clk",	ADSP_CLK,	NULL, 0),
 	CLK_PCOM("ebi1_clk",	EBI1_CLK,	NULL, 0),
diff --git a/arch/arm/mach-msm/devices-msm7x30.c b/arch/arm/mach-msm/devices-msm7x30.c
index a22f067..1b08f0e 100644
--- a/arch/arm/mach-msm/devices-msm7x30.c
+++ b/arch/arm/mach-msm/devices-msm7x30.c
@@ -130,7 +130,7 @@ struct platform_device msm_device_hsusb_host = {
 	},
 };
 
-static struct clk_lookup msm_clocks_7x30[] = {
+static struct clk_pcom_desc msm_clocks_7x30[] = {
 	CLK_PCOM("adm_clk",	ADM_CLK,	NULL, 0),
 	CLK_PCOM("adsp_clk",	ADSP_CLK,	NULL, 0),
 	CLK_PCOM("cam_m_clk",	CAM_M_CLK,	NULL, 0),
diff --git a/arch/arm/mach-msm/devices-qsd8x50.c b/arch/arm/mach-msm/devices-qsd8x50.c
index b6c788e..0f1dec0 100644
--- a/arch/arm/mach-msm/devices-qsd8x50.c
+++ b/arch/arm/mach-msm/devices-qsd8x50.c
@@ -291,7 +291,7 @@ int __init msm_add_sdcc(unsigned int controller,
 	return platform_device_register(pdev);
 }
 
-static struct clk_lookup msm_clocks_8x50[] = {
+static struct clk_pcom_desc msm_clocks_8x50[] = {
 	CLK_PCOM("adm_clk",	ADM_CLK,	NULL, 0),
 	CLK_PCOM("ce_clk",	CE_CLK,		NULL, 0),
 	CLK_PCOM("ebi1_clk",	EBI1_CLK,	NULL, CLK_MIN),
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

