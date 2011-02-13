Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754469Ab1BMJqL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Feb 2011 04:46:11 -0500
Received: from smtp-out.google.com ([216.239.44.51]:9976 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754102Ab1BMJnS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Feb 2011 04:43:18 -0500
From: Colin Cross <ccross@android.com>
To: linux-tegra@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, konkers@android.com, olof@lixom.net,
        Colin Cross <ccross@android.com>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: [PATCH 07/21] ARM: tegra: clock: Drop CPU dvfs
Date: Sun, 13 Feb 2011 01:40:19 -0800
Message-Id: <1297590033-15035-8-git-send-email-ccross@android.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1297590033-15035-1-git-send-email-ccross@android.com>
References: <1297590033-15035-1-git-send-email-ccross@android.com>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The existing version did not extend well to core dvfs, drop it
for now until the new clk api with clk_prepare and clk_unprepare
is ready and non-atomic clocks are possible.

Signed-off-by: Colin Cross <ccross@android.com>
---
 arch/arm/mach-tegra/Makefile           |    1 -
 arch/arm/mach-tegra/clock.c            |  159 +-------------------------------
 arch/arm/mach-tegra/clock.h            |   24 -----
 arch/arm/mach-tegra/cpu-tegra.c        |    2 +-
 arch/arm/mach-tegra/include/mach/clk.h |    5 -
 arch/arm/mach-tegra/tegra2_clocks.c    |    2 -
 arch/arm/mach-tegra/tegra2_dvfs.c      |   86 -----------------
 arch/arm/mach-tegra/tegra2_dvfs.h      |   20 ----
 8 files changed, 2 insertions(+), 297 deletions(-)
 delete mode 100644 arch/arm/mach-tegra/tegra2_dvfs.c
 delete mode 100644 arch/arm/mach-tegra/tegra2_dvfs.h

diff --git a/arch/arm/mach-tegra/Makefile b/arch/arm/mach-tegra/Makefile
index 6b537de..23de060 100644
--- a/arch/arm/mach-tegra/Makefile
+++ b/arch/arm/mach-tegra/Makefile
@@ -9,7 +9,6 @@ obj-y                                   += powergate.o
 obj-y					+= fuse.o
 obj-$(CONFIG_ARCH_TEGRA_2x_SOC)         += clock.o
 obj-$(CONFIG_ARCH_TEGRA_2x_SOC)         += tegra2_clocks.o
-obj-$(CONFIG_ARCH_TEGRA_2x_SOC)         += tegra2_dvfs.o
 obj-$(CONFIG_ARCH_TEGRA_2x_SOC)		+= pinmux-t2-tables.o
 obj-$(CONFIG_SMP)                       += platsmp.o localtimer.o headsmp.o
 obj-$(CONFIG_HOTPLUG_CPU)               += hotplug.o
diff --git a/arch/arm/mach-tegra/clock.c b/arch/arm/mach-tegra/clock.c
index 79c0bd8..a1193f9 100644
--- a/arch/arm/mach-tegra/clock.c
+++ b/arch/arm/mach-tegra/clock.c
@@ -24,81 +24,14 @@
 #include <linux/debugfs.h>
 #include <linux/slab.h>
 #include <linux/seq_file.h>
-#include <linux/regulator/consumer.h>
 #include <linux/clkdev.h>
 
-#include "clock.h"
 #include "board.h"
-#include "fuse.h"
+#include "clock.h"
 
 static LIST_HEAD(clocks);
 
 static DEFINE_SPINLOCK(clock_lock);
-static DEFINE_MUTEX(dvfs_lock);
-
-static int clk_is_dvfs(struct clk *c)
-{
-	return (c->dvfs != NULL);
-};
-
-static int dvfs_set_rate(struct dvfs *d, unsigned long rate)
-{
-	struct dvfs_table *t;
-
-	if (d->table == NULL)
-		return -ENODEV;
-
-	for (t = d->table; t->rate != 0; t++) {
-		if (rate <= t->rate) {
-			if (!d->reg)
-				return 0;
-
-			return regulator_set_voltage(d->reg,
-				t->millivolts * 1000,
-				d->max_millivolts * 1000);
-		}
-	}
-
-	return -EINVAL;
-}
-
-static void dvfs_init(struct clk *c)
-{
-	int process_id;
-	int i;
-	struct dvfs_table *table;
-
-	process_id = c->dvfs->cpu ? tegra_core_process_id() :
-		tegra_cpu_process_id();
-
-	for (i = 0; i < c->dvfs->process_id_table_length; i++)
-		if (process_id == c->dvfs->process_id_table[i].process_id)
-			c->dvfs->table = c->dvfs->process_id_table[i].table;
-
-	if (c->dvfs->table == NULL) {
-		pr_err("Failed to find dvfs table for clock %s process %d\n",
-			c->name, process_id);
-		return;
-	}
-
-	c->dvfs->max_millivolts = 0;
-	for (table = c->dvfs->table; table->rate != 0; table++)
-		if (c->dvfs->max_millivolts < table->millivolts)
-			c->dvfs->max_millivolts = table->millivolts;
-
-	c->dvfs->reg = regulator_get(NULL, c->dvfs->reg_id);
-
-	if (IS_ERR(c->dvfs->reg)) {
-		pr_err("Failed to get regulator %s for clock %s\n",
-			c->dvfs->reg_id, c->name);
-		c->dvfs->reg = NULL;
-		return;
-	}
-
-	if (c->refcnt > 0)
-		dvfs_set_rate(c->dvfs, c->rate);
-}
-
 struct clk *tegra_get_clock_by_name(const char *name)
 {
 	struct clk *c;
@@ -214,34 +147,11 @@ int clk_enable_locked(struct clk *c)
 	return 0;
 }
 
-int clk_enable_cansleep(struct clk *c)
-{
-	int ret;
-	unsigned long flags;
-
-	mutex_lock(&dvfs_lock);
-
-	if (clk_is_dvfs(c) && c->refcnt > 0)
-		dvfs_set_rate(c->dvfs, c->rate);
-
-	spin_lock_irqsave(&clock_lock, flags);
-	ret = clk_enable_locked(c);
-	spin_unlock_irqrestore(&clock_lock, flags);
-
-	mutex_unlock(&dvfs_lock);
-
-	return ret;
-}
-EXPORT_SYMBOL(clk_enable_cansleep);
-
 int clk_enable(struct clk *c)
 {
 	int ret;
 	unsigned long flags;
 
-	if (clk_is_dvfs(c))
-		BUG();
-
 	spin_lock_irqsave(&clock_lock, flags);
 	ret = clk_enable_locked(c);
 	spin_unlock_irqrestore(&clock_lock, flags);
@@ -268,30 +178,10 @@ void clk_disable_locked(struct clk *c)
 	c->refcnt--;
 }
 
-void clk_disable_cansleep(struct clk *c)
-{
-	unsigned long flags;
-
-	mutex_lock(&dvfs_lock);
-
-	spin_lock_irqsave(&clock_lock, flags);
-	clk_disable_locked(c);
-	spin_unlock_irqrestore(&clock_lock, flags);
-
-	if (clk_is_dvfs(c) && c->refcnt == 0)
-		dvfs_set_rate(c->dvfs, c->rate);
-
-	mutex_unlock(&dvfs_lock);
-}
-EXPORT_SYMBOL(clk_disable_cansleep);
-
 void clk_disable(struct clk *c)
 {
 	unsigned long flags;
 
-	if (clk_is_dvfs(c))
-		BUG();
-
 	spin_lock_irqsave(&clock_lock, flags);
 	clk_disable_locked(c);
 	spin_unlock_irqrestore(&clock_lock, flags);
@@ -356,41 +246,11 @@ int clk_set_rate_locked(struct clk *c, unsigned long rate)
 	return 0;
 }
 
-int clk_set_rate_cansleep(struct clk *c, unsigned long rate)
-{
-	int ret = 0;
-	unsigned long flags;
-
-	mutex_lock(&dvfs_lock);
-
-	if (rate > c->rate)
-		ret = dvfs_set_rate(c->dvfs, rate);
-	if (ret)
-		goto out;
-
-	spin_lock_irqsave(&clock_lock, flags);
-	ret = clk_set_rate_locked(c, rate);
-	spin_unlock_irqrestore(&clock_lock, flags);
-
-	if (ret)
-		goto out;
-
-	ret = dvfs_set_rate(c->dvfs, rate);
-
-out:
-	mutex_unlock(&dvfs_lock);
-	return ret;
-}
-EXPORT_SYMBOL(clk_set_rate_cansleep);
-
 int clk_set_rate(struct clk *c, unsigned long rate)
 {
 	int ret = 0;
 	unsigned long flags;
 
-	if (clk_is_dvfs(c))
-		BUG();
-
 	spin_lock_irqsave(&clock_lock, flags);
 	ret = clk_set_rate_locked(c, rate);
 	spin_unlock_irqrestore(&clock_lock, flags);
@@ -503,23 +363,6 @@ void __init tegra_init_clock(void)
 	tegra2_init_clocks();
 }
 
-int __init tegra_init_dvfs(void)
-{
-	struct clk *c, *safe;
-
-	mutex_lock(&dvfs_lock);
-
-	list_for_each_entry_safe(c, safe, &clocks, node)
-		if (c->dvfs)
-			dvfs_init(c);
-
-	mutex_unlock(&dvfs_lock);
-
-	return 0;
-}
-
-late_initcall(tegra_init_dvfs);
-
 /*
  * Iterate through all clocks, disabling any for which the refcount is 0
  * but the clock init detected the bootloader left the clock on.
diff --git a/arch/arm/mach-tegra/clock.h b/arch/arm/mach-tegra/clock.h
index b76d33d..198f234 100644
--- a/arch/arm/mach-tegra/clock.h
+++ b/arch/arm/mach-tegra/clock.h
@@ -41,28 +41,6 @@
 #define ENABLE_ON_INIT		(1 << 28)
 
 struct clk;
-struct regulator;
-
-struct dvfs_table {
-	unsigned long rate;
-	int millivolts;
-};
-
-struct dvfs_process_id_table {
-	int process_id;
-	struct dvfs_table *table;
-};
-
-struct dvfs {
-	struct regulator *reg;
-	struct dvfs_table *table;
-	int max_millivolts;
-
-	int process_id_table_length;
-	const char *reg_id;
-	bool cpu;
-	struct dvfs_process_id_table process_id_table[];
-};
 
 struct clk_mux_sel {
 	struct clk	*input;
@@ -141,8 +119,6 @@ struct clk {
 	/* Virtual cpu clock */
 	struct clk			*main;
 	struct clk			*backup;
-
-	struct dvfs			*dvfs;
 };
 
 
diff --git a/arch/arm/mach-tegra/cpu-tegra.c b/arch/arm/mach-tegra/cpu-tegra.c
index ad26a9f..cda03f1 100644
--- a/arch/arm/mach-tegra/cpu-tegra.c
+++ b/arch/arm/mach-tegra/cpu-tegra.c
@@ -91,7 +91,7 @@ static int tegra_update_cpu_speed(unsigned long rate)
 	       freqs.old, freqs.new);
 #endif
 
-	ret = clk_set_rate_cansleep(cpu_clk, freqs.new * 1000);
+	ret = clk_set_rate(cpu_clk, freqs.new * 1000);
 	if (ret) {
 		pr_err("cpu-tegra: Failed to set cpu frequency to %d kHz\n",
 			freqs.new);
diff --git a/arch/arm/mach-tegra/include/mach/clk.h b/arch/arm/mach-tegra/include/mach/clk.h
index a217f68..6338652 100644
--- a/arch/arm/mach-tegra/include/mach/clk.h
+++ b/arch/arm/mach-tegra/include/mach/clk.h
@@ -25,9 +25,4 @@ struct clk;
 void tegra_periph_reset_deassert(struct clk *c);
 void tegra_periph_reset_assert(struct clk *c);
 
-int clk_enable_cansleep(struct clk *clk);
-void clk_disable_cansleep(struct clk *clk);
-int clk_set_rate_cansleep(struct clk *clk, unsigned long rate);
-int clk_set_parent_cansleep(struct clk *clk, struct clk *parent);
-
 #endif
diff --git a/arch/arm/mach-tegra/tegra2_clocks.c b/arch/arm/mach-tegra/tegra2_clocks.c
index 36da2e8..e1e0d81f 100644
--- a/arch/arm/mach-tegra/tegra2_clocks.c
+++ b/arch/arm/mach-tegra/tegra2_clocks.c
@@ -31,7 +31,6 @@
 
 #include "clock.h"
 #include "fuse.h"
-#include "tegra2_dvfs.h"
 
 #define RST_DEVICES			0x004
 #define RST_DEVICES_SET			0x300
@@ -1650,7 +1649,6 @@ static struct clk tegra_clk_virtual_cpu = {
 	.backup    = &tegra_pll_p,
 	.ops       = &tegra_cpu_ops,
 	.max_rate  = 1000000000,
-	.dvfs      = &tegra_dvfs_virtual_cpu_dvfs,
 };
 
 static struct clk tegra_clk_hclk = {
diff --git a/arch/arm/mach-tegra/tegra2_dvfs.c b/arch/arm/mach-tegra/tegra2_dvfs.c
deleted file mode 100644
index 5529c23..0000000
--- a/arch/arm/mach-tegra/tegra2_dvfs.c
+++ /dev/null
@@ -1,86 +0,0 @@
-/*
- * arch/arm/mach-tegra/tegra2_dvfs.c
- *
- * Copyright (C) 2010 Google, Inc.
- *
- * Author:
- *	Colin Cross <ccross@google.com>
- *
- * This software is licensed under the terms of the GNU General Public
- * License version 2, as published by the Free Software Foundation, and
- * may be copied, distributed, and modified under those terms.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- */
-
-#include <linux/kernel.h>
-
-#include "clock.h"
-#include "tegra2_dvfs.h"
-
-static struct dvfs_table virtual_cpu_process_0[] = {
-	{314000000,  750},
-	{456000000,  825},
-	{608000000,  900},
-	{760000000,  975},
-	{817000000,  1000},
-	{912000000,  1050},
-	{1000000000, 1100},
-	{0, 0},
-};
-
-static struct dvfs_table virtual_cpu_process_1[] = {
-	{314000000,  750},
-	{456000000,  825},
-	{618000000,  900},
-	{770000000,  975},
-	{827000000,  1000},
-	{922000000,  1050},
-	{1000000000, 1100},
-	{0, 0},
-};
-
-static struct dvfs_table virtual_cpu_process_2[] = {
-	{494000000,  750},
-	{675000000,  825},
-	{817000000,  875},
-	{922000000,  925},
-	{1000000000, 975},
-	{0, 0},
-};
-
-static struct dvfs_table virtual_cpu_process_3[] = {
-	{730000000,  750},
-	{760000000,  775},
-	{845000000,  800},
-	{1000000000, 875},
-	{0, 0},
-};
-
-struct dvfs tegra_dvfs_virtual_cpu_dvfs = {
-	.reg_id = "vdd_cpu",
-	.process_id_table = {
-		{
-			.process_id = 0,
-			.table = virtual_cpu_process_0,
-		},
-		{
-			.process_id = 1,
-			.table = virtual_cpu_process_1,
-		},
-		{
-			.process_id = 2,
-			.table = virtual_cpu_process_2,
-		},
-		{
-			.process_id = 3,
-			.table = virtual_cpu_process_3,
-		},
-	},
-	.process_id_table_length = 4,
-	.cpu = 1,
-};
diff --git a/arch/arm/mach-tegra/tegra2_dvfs.h b/arch/arm/mach-tegra/tegra2_dvfs.h
deleted file mode 100644
index f8c1adb..0000000
--- a/arch/arm/mach-tegra/tegra2_dvfs.h
+++ /dev/null
@@ -1,20 +0,0 @@
-/*
- * arch/arm/mach-tegra/tegra2_dvfs.h
- *
- * Copyright (C) 2010 Google, Inc.
- *
- * Author:
- *	Colin Cross <ccross@google.com>
- *
- * This software is licensed under the terms of the GNU General Public
- * License version 2, as published by the Free Software Foundation, and
- * may be copied, distributed, and modified under those terms.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- */
-
-extern struct dvfs tegra_dvfs_virtual_cpu_dvfs;
-- 
1.7.3.1

