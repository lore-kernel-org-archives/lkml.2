Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755532Ab1BWRi2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 12:38:28 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:20035 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752460Ab1BWRhr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 12:37:47 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6266"; a="76004350"
From: Stephen Boyd <sboyd@codeaurora.org>
To: David Brown <davidb@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Saravana Kannan <skannan@codeaurora.org>
Subject: [PATCH 1/2] msm: clock: Remove references to clk_ops_pcom
Date: Wed, 23 Feb 2011 09:37:41 -0800
Message-Id: <1298482662-27298-2-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.7.4.1.55.gdca3d
In-Reply-To: <1298482662-27298-1-git-send-email-sboyd@codeaurora.org>
References: <1298482662-27298-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not all devices use proc_comm and determining if a clock is local
vs. remote is fragile when done by comparing clk_ops pointers.
Instead, implement an is_local() function for all clk_ops to
determine if the clock is local. Doing this allows us to remove
the last references to clk_ops_pcom from clock.c and compile it
for targets with CONFIG_MSM_PROC_COMM=n.

We don't need to set the clk_ops at runtime until 7x30 local
clock detection comes in. Right now it's just complicating things
so just set the ops pointer statically.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 arch/arm/mach-msm/Makefile      |    6 +---
 arch/arm/mach-msm/clock-7x30.h  |    1 +
 arch/arm/mach-msm/clock-debug.c |    3 +-
 arch/arm/mach-msm/clock-dummy.c |   54 ---------------------------------------
 arch/arm/mach-msm/clock-pcom.c  |    6 ++++
 arch/arm/mach-msm/clock.c       |   17 +-----------
 arch/arm/mach-msm/clock.h       |    1 +
 7 files changed, 11 insertions(+), 77 deletions(-)
 delete mode 100644 arch/arm/mach-msm/clock-dummy.c

diff --git a/arch/arm/mach-msm/Makefile b/arch/arm/mach-msm/Makefile
index 2099c97..9519fd2 100644
--- a/arch/arm/mach-msm/Makefile
+++ b/arch/arm/mach-msm/Makefile
@@ -1,7 +1,6 @@
 obj-y += io.o idle.o timer.o
-ifdef CONFIG_MSM_PROC_COMM
+obj-y += clock.o
 obj-$(CONFIG_DEBUG_FS) += clock-debug.o
-endif
 
 obj-$(CONFIG_MSM_VIC) += irq-vic.o
 obj-$(CONFIG_MSM_IOMMU) += iommu.o iommu_dev.o devices-iommu.o
@@ -9,11 +8,8 @@ obj-$(CONFIG_MSM_IOMMU) += iommu.o iommu_dev.o devices-iommu.o
 obj-$(CONFIG_ARCH_MSM7X00A) += dma.o irq.o acpuclock-arm11.o
 obj-$(CONFIG_ARCH_MSM7X30) += dma.o
 obj-$(CONFIG_ARCH_QSD8X50) += dma.o sirc.o
-obj-$(CONFIG_ARCH_MSM8X60) += clock-dummy.o
-obj-$(CONFIG_ARCH_MSM8960) += clock-dummy.o
 
 obj-$(CONFIG_MSM_PROC_COMM) += proc_comm.o clock-pcom.o vreg.o
-obj-$(CONFIG_MSM_PROC_COMM) += clock.o
 
 obj-$(CONFIG_MSM_SMD) += smd.o smd_debug.o
 obj-$(CONFIG_MSM_SMD) += last_radio_log.o
diff --git a/arch/arm/mach-msm/clock-7x30.h b/arch/arm/mach-msm/clock-7x30.h
index e16f72f..43c8e27 100644
--- a/arch/arm/mach-msm/clock-7x30.h
+++ b/arch/arm/mach-msm/clock-7x30.h
@@ -162,6 +162,7 @@ extern int internal_pwr_rail_ctl_auto(unsigned rail_id, bool enable);
 	.flags = clk_flags, \
 	.dev = clk_dev, \
 	.dbg_name = #l_id, \
+	.ops = &clk_ops_pcom, \
 	}
 
 #endif
diff --git a/arch/arm/mach-msm/clock-debug.c b/arch/arm/mach-msm/clock-debug.c
index b67b9e82..4886404 100644
--- a/arch/arm/mach-msm/clock-debug.c
+++ b/arch/arm/mach-msm/clock-debug.c
@@ -19,7 +19,6 @@
 #include <linux/debugfs.h>
 #include <linux/clk.h>
 #include "clock.h"
-#include "clock-pcom.h"
 
 static int clock_debug_rate_set(void *data, u64 val)
 {
@@ -79,7 +78,7 @@ static int clock_debug_local_get(void *data, u64 *val)
 {
 	struct clk *clock = data;
 
-	*val = clock->ops != &clk_ops_pcom;
+	*val = clock->ops->is_local(clock->id);
 
 	return 0;
 }
diff --git a/arch/arm/mach-msm/clock-dummy.c b/arch/arm/mach-msm/clock-dummy.c
deleted file mode 100644
index 1250d22..0000000
--- a/arch/arm/mach-msm/clock-dummy.c
+++ /dev/null
@@ -1,54 +0,0 @@
-/* Copyright (c) 2010, Code Aurora Forum. All rights reserved.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 and
- * only version 2 as published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
- * 02110-1301, USA.
- *
- */
-#include <linux/clk.h>
-#include <linux/err.h>
-#include <linux/module.h>
-
-struct clk *clk_get(struct device *dev, const char *id)
-{
-	return ERR_PTR(-ENOENT);
-}
-EXPORT_SYMBOL(clk_get);
-
-int clk_enable(struct clk *clk)
-{
-	return -ENOENT;
-}
-EXPORT_SYMBOL(clk_enable);
-
-void clk_disable(struct clk *clk)
-{
-}
-EXPORT_SYMBOL(clk_disable);
-
-unsigned long clk_get_rate(struct clk *clk)
-{
-	return 0;
-}
-EXPORT_SYMBOL(clk_get_rate);
-
-int clk_set_rate(struct clk *clk, unsigned long rate)
-{
-	return -ENOENT;
-}
-EXPORT_SYMBOL(clk_set_rate);
-
-void clk_put(struct clk *clk)
-{
-}
-EXPORT_SYMBOL(clk_put);
diff --git a/arch/arm/mach-msm/clock-pcom.c b/arch/arm/mach-msm/clock-pcom.c
index 8c4e867..63b7113 100644
--- a/arch/arm/mach-msm/clock-pcom.c
+++ b/arch/arm/mach-msm/clock-pcom.c
@@ -117,6 +117,11 @@ long pc_clk_round_rate(unsigned id, unsigned rate)
 	return rate;
 }
 
+static bool pc_clk_is_local(unsigned id)
+{
+	return false;
+}
+
 struct clk_ops clk_ops_pcom = {
 	.enable = pc_clk_enable,
 	.disable = pc_clk_disable,
@@ -129,4 +134,5 @@ struct clk_ops clk_ops_pcom = {
 	.get_rate = pc_clk_get_rate,
 	.is_enabled = pc_clk_is_enabled,
 	.round_rate = pc_clk_round_rate,
+	.is_local = pc_clk_is_local,
 };
diff --git a/arch/arm/mach-msm/clock.c b/arch/arm/mach-msm/clock.c
index 8c2b4dd..e00f6a0 100644
--- a/arch/arm/mach-msm/clock.c
+++ b/arch/arm/mach-msm/clock.c
@@ -21,9 +21,6 @@
 #include <linux/pm_qos_params.h>
 
 #include "clock.h"
-#include "proc_comm.h"
-#include "clock-7x30.h"
-#include "clock-pcom.h"
 
 static DEFINE_MUTEX(clocks_mutex);
 static DEFINE_SPINLOCK(clocks_lock);
@@ -84,8 +81,6 @@ EXPORT_SYMBOL(clk_disable);
 
 int clk_reset(struct clk *clk, enum clk_reset_action action)
 {
-	if (!clk->ops->reset)
-		clk->ops->reset = &pc_clk_reset;
 	return clk->ops->reset(clk->remote_id, action);
 }
 EXPORT_SYMBOL(clk_reset);
@@ -162,23 +157,13 @@ EXPORT_SYMBOL(clk_set_flags);
  */
 static struct clk *ebi1_clk;
 
-static void __init set_clock_ops(struct clk *clk)
-{
-	if (!clk->ops) {
-		clk->ops = &clk_ops_pcom;
-		clk->id = clk->remote_id;
-	}
-}
-
 void __init msm_clock_init(struct clk *clock_tbl, unsigned num_clocks)
 {
 	unsigned n;
 
 	mutex_lock(&clocks_mutex);
-	for (n = 0; n < num_clocks; n++) {
-		set_clock_ops(&clock_tbl[n]);
+	for (n = 0; n < num_clocks; n++)
 		list_add_tail(&clock_tbl[n].list, &clocks);
-	}
 	mutex_unlock(&clocks_mutex);
 
 	ebi1_clk = clk_get(NULL, "ebi1_clk");
diff --git a/arch/arm/mach-msm/clock.h b/arch/arm/mach-msm/clock.h
index 70216b0..8d302c7 100644
--- a/arch/arm/mach-msm/clock.h
+++ b/arch/arm/mach-msm/clock.h
@@ -43,6 +43,7 @@ struct clk_ops {
 	unsigned (*get_rate)(unsigned id);
 	unsigned (*is_enabled)(unsigned id);
 	long (*round_rate)(unsigned id, unsigned rate);
+	bool (*is_local)(unsigned id);
 };
 
 struct clk {
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

