Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754580Ab1A0AVe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 19:21:34 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:62484 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754530Ab1A0AU7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 19:20:59 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6238"; a="71900279"
From: Stephen Boyd <sboyd@codeaurora.org>
To: David Brown <davidb@codeaurora.org>
Cc: Matt Wagantall <mattw@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Saravana Kannan <skannan@codeaurora.org>
Subject: [PATCHv2 3/5] msm: clock: Move debugfs code from clock.c to clock-debug.c
Date: Wed, 26 Jan 2011 16:20:54 -0800
Message-Id: <1296087656-3693-4-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.7.4.rc3
In-Reply-To: <1296087656-3693-1-git-send-email-sboyd@codeaurora.org>
References: <1296087656-3693-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Wagantall <mattw@codeaurora.org>

The clock debugfs code is large enough, and easy enough to separate,
that it deserves its own file which is compiled only when
CONFIG_DEBUG_FS is enabled.

Also, cleanup header file #includes that are no longer required.

Reviewed-by: Saravana Kannan <skannan@codeaurora.org>
Signed-off-by: Matt Wagantall <mattw@codeaurora.org>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 arch/arm/mach-msm/Makefile      |    3 +
 arch/arm/mach-msm/clock-debug.c |  133 +++++++++++++++++++++++++++++++++++++++
 arch/arm/mach-msm/clock.c       |  127 ++-----------------------------------
 arch/arm/mach-msm/clock.h       |    9 +++
 4 files changed, 150 insertions(+), 122 deletions(-)
 create mode 100644 arch/arm/mach-msm/clock-debug.c

diff --git a/arch/arm/mach-msm/Makefile b/arch/arm/mach-msm/Makefile
index 0e5c9dc..c796441 100644
--- a/arch/arm/mach-msm/Makefile
+++ b/arch/arm/mach-msm/Makefile
@@ -1,4 +1,7 @@
 obj-y += io.o idle.o timer.o
+ifdef CONFIG_MSM_PROC_COMM
+obj-$(CONFIG_DEBUG_FS) += clock-debug.o
+endif
 
 obj-$(CONFIG_MSM_VIC) += irq-vic.o
 
diff --git a/arch/arm/mach-msm/clock-debug.c b/arch/arm/mach-msm/clock-debug.c
new file mode 100644
index 0000000..6f603ed
--- /dev/null
+++ b/arch/arm/mach-msm/clock-debug.c
@@ -0,0 +1,133 @@
+/*
+ * Copyright (C) 2007 Google, Inc.
+ * Copyright (c) 2007-2010, Code Aurora Forum. All rights reserved.
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.	 See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/ctype.h>
+#include <linux/debugfs.h>
+#include <linux/clk.h>
+#include "clock.h"
+#include "clock-pcom.h"
+
+static int clock_debug_rate_set(void *data, u64 val)
+{
+	struct clk *clock = data;
+	int ret;
+
+	/* Only increases to max rate will succeed, but that's actually good
+	 * for debugging purposes so we don't check for error. */
+	if (clock->flags & CLK_MAX)
+		clk_set_max_rate(clock, val);
+	if (clock->flags & CLK_MIN)
+		ret = clk_set_min_rate(clock, val);
+	else
+		ret = clk_set_rate(clock, val);
+	if (ret != 0)
+		printk(KERN_ERR "clk_set%s_rate failed (%d)\n",
+			(clock->flags & CLK_MIN) ? "_min" : "", ret);
+	return ret;
+}
+
+static int clock_debug_rate_get(void *data, u64 *val)
+{
+	struct clk *clock = data;
+	*val = clk_get_rate(clock);
+	return 0;
+}
+
+DEFINE_SIMPLE_ATTRIBUTE(clock_rate_fops, clock_debug_rate_get,
+			clock_debug_rate_set, "%llu\n");
+
+static int clock_debug_enable_set(void *data, u64 val)
+{
+	struct clk *clock = data;
+	int rc = 0;
+
+	if (val)
+		rc = clock->ops->enable(clock->id);
+	else
+		clock->ops->disable(clock->id);
+
+	return rc;
+}
+
+static int clock_debug_enable_get(void *data, u64 *val)
+{
+	struct clk *clock = data;
+
+	*val = clock->ops->is_enabled(clock->id);
+
+	return 0;
+}
+
+DEFINE_SIMPLE_ATTRIBUTE(clock_enable_fops, clock_debug_enable_get,
+			clock_debug_enable_set, "%llu\n");
+
+static int clock_debug_local_get(void *data, u64 *val)
+{
+	struct clk *clock = data;
+
+	*val = clock->ops != &clk_ops_pcom;
+
+	return 0;
+}
+
+DEFINE_SIMPLE_ATTRIBUTE(clock_local_fops, clock_debug_local_get,
+			NULL, "%llu\n");
+
+static struct dentry *dent_rate, *dent_enable, *dent_local;
+
+int __init clock_debug_init(void)
+{
+	dent_rate = debugfs_create_dir("clk_rate", 0);
+	if (!dent_rate)
+		goto err;
+
+	dent_enable = debugfs_create_dir("clk_enable", 0);
+	if (!dent_enable)
+		goto err;
+
+	dent_local = debugfs_create_dir("clk_local", NULL);
+	if (!dent_local)
+		goto err;
+
+	return 0;
+err:
+	debugfs_remove(dent_local);
+	debugfs_remove(dent_enable);
+	debugfs_remove(dent_rate);
+	return -ENOMEM;
+}
+
+int __init clock_debug_add(struct clk *clock)
+{
+	char temp[50], *ptr;
+
+	if (!dent_rate || !dent_enable || !dent_local)
+		return -ENOMEM;
+
+	strncpy(temp, clock->dbg_name, ARRAY_SIZE(temp)-1);
+	for (ptr = temp; *ptr; ptr++)
+		*ptr = tolower(*ptr);
+
+	debugfs_create_file(temp, S_IRUGO | S_IWUSR, dent_rate,
+			    clock, &clock_rate_fops);
+	debugfs_create_file(temp, S_IRUGO | S_IWUSR, dent_enable,
+			    clock, &clock_enable_fops);
+	debugfs_create_file(temp, S_IRUGO, dent_local,
+			    clock, &clock_local_fops);
+
+	return 0;
+}
diff --git a/arch/arm/mach-msm/clock.c b/arch/arm/mach-msm/clock.c
index 8f71f8d..8c2b4dd 100644
--- a/arch/arm/mach-msm/clock.c
+++ b/arch/arm/mach-msm/clock.c
@@ -15,16 +15,10 @@
  */
 
 #include <linux/kernel.h>
-#include <linux/init.h>
-#include <linux/module.h>
 #include <linux/list.h>
 #include <linux/err.h>
-#include <linux/clk.h>
 #include <linux/spinlock.h>
-#include <linux/debugfs.h>
-#include <linux/ctype.h>
 #include <linux/pm_qos_params.h>
-#include <mach/clk.h>
 
 #include "clock.h"
 #include "proc_comm.h"
@@ -34,8 +28,6 @@
 static DEFINE_MUTEX(clocks_mutex);
 static DEFINE_SPINLOCK(clocks_lock);
 static LIST_HEAD(clocks);
-struct clk *msm_clocks;
-unsigned msm_num_clocks;
 
 /*
  * Standard clock functions defined in include/linux/clk.h
@@ -183,11 +175,9 @@ void __init msm_clock_init(struct clk *clock_tbl, unsigned num_clocks)
 	unsigned n;
 
 	mutex_lock(&clocks_mutex);
-	msm_clocks = clock_tbl;
-	msm_num_clocks = num_clocks;
-	for (n = 0; n < msm_num_clocks; n++) {
-		set_clock_ops(&msm_clocks[n]);
-		list_add_tail(&msm_clocks[n].list, &clocks);
+	for (n = 0; n < num_clocks; n++) {
+		set_clock_ops(&clock_tbl[n]);
+		list_add_tail(&clock_tbl[n].list, &clocks);
 	}
 	mutex_unlock(&clocks_mutex);
 
@@ -196,115 +186,6 @@ void __init msm_clock_init(struct clk *clock_tbl, unsigned num_clocks)
 
 }
 
-#if defined(CONFIG_DEBUG_FS)
-static struct clk *msm_clock_get_nth(unsigned index)
-{
-	if (index < msm_num_clocks)
-		return msm_clocks + index;
-	else
-		return 0;
-}
-
-static int clock_debug_rate_set(void *data, u64 val)
-{
-	struct clk *clock = data;
-	int ret;
-
-	/* Only increases to max rate will succeed, but that's actually good
-	 * for debugging purposes. So we don't check for error. */
-	if (clock->flags & CLK_MAX)
-		clk_set_max_rate(clock, val);
-	if (clock->flags & CLK_MIN)
-		ret = clk_set_min_rate(clock, val);
-	else
-		ret = clk_set_rate(clock, val);
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
-static int clock_debug_local_get(void *data, u64 *val)
-{
-	struct clk *clock = data;
-
-	*val = clock->ops != &clk_ops_pcom;
-
-	return 0;
-}
-
-DEFINE_SIMPLE_ATTRIBUTE(clock_rate_fops, clock_debug_rate_get,
-			clock_debug_rate_set, "%llu\n");
-DEFINE_SIMPLE_ATTRIBUTE(clock_enable_fops, clock_debug_enable_get,
-			clock_debug_enable_set, "%llu\n");
-DEFINE_SIMPLE_ATTRIBUTE(clock_local_fops, clock_debug_local_get,
-			NULL, "%llu\n");
-
-static int __init clock_debug_init(void)
-{
-	struct dentry *dent_rate, *dent_enable, *dent_local;
-	struct clk *clock;
-	unsigned n = 0;
-	char temp[50], *ptr;
-
-	dent_rate = debugfs_create_dir("clk_rate", 0);
-	if (IS_ERR(dent_rate))
-		return PTR_ERR(dent_rate);
-
-	dent_enable = debugfs_create_dir("clk_enable", 0);
-	if (IS_ERR(dent_enable))
-		return PTR_ERR(dent_enable);
-
-	dent_local = debugfs_create_dir("clk_local", NULL);
-	if (IS_ERR(dent_local))
-		return PTR_ERR(dent_local);
-
-	while ((clock = msm_clock_get_nth(n++)) != 0) {
-		strncpy(temp, clock->dbg_name, ARRAY_SIZE(temp)-1);
-		for (ptr = temp; *ptr; ptr++)
-			*ptr = tolower(*ptr);
-		debugfs_create_file(temp, 0644, dent_rate,
-				    clock, &clock_rate_fops);
-		debugfs_create_file(temp, 0644, dent_enable,
-				    clock, &clock_enable_fops);
-		debugfs_create_file(temp, S_IRUGO, dent_local,
-				    clock, &clock_local_fops);
-	}
-	return 0;
-}
-
-device_initcall(clock_debug_init);
-#endif
-
 /* The bootloader and/or AMSS may have left various clocks enabled.
  * Disable any clocks that belong to us (CLKFLAG_AUTO_OFF) but have
  * not been explicitly enabled by a clk_enable() call.
@@ -315,8 +196,10 @@ static int __init clock_late_init(void)
 	struct clk *clk;
 	unsigned count = 0;
 
+	clock_debug_init();
 	mutex_lock(&clocks_mutex);
 	list_for_each_entry(clk, &clocks, list) {
+		clock_debug_add(clk);
 		if (clk->flags & CLKFLAG_AUTO_OFF) {
 			spin_lock_irqsave(&clocks_lock, flags);
 			if (!clk->count) {
diff --git a/arch/arm/mach-msm/clock.h b/arch/arm/mach-msm/clock.h
index 6a0cade..70216b0 100644
--- a/arch/arm/mach-msm/clock.h
+++ b/arch/arm/mach-msm/clock.h
@@ -17,6 +17,7 @@
 #ifndef __ARCH_ARM_MACH_MSM_CLOCK_H
 #define __ARCH_ARM_MACH_MSM_CLOCK_H
 
+#include <linux/init.h>
 #include <linux/list.h>
 #include <mach/clk.h>
 
@@ -61,4 +62,12 @@ struct clk {
 #define CLK_MAX CLKFLAG_MAX
 #define CLK_MINMAX (CLK_MIN | CLK_MAX)
 
+#ifdef CONFIG_DEBUG_FS
+int __init clock_debug_init(void);
+int __init clock_debug_add(struct clk *clock);
+#else
+static inline int __init clock_debug_init(void) { return 0; }
+static inline int __init clock_debug_add(struct clk *clock) { return 0; }
+#endif
+
 #endif
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

