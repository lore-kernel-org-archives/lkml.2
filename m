Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756360Ab1KBSkk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 14:40:40 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:18091 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933388Ab1KBShF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 14:37:05 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6518"; a="133707003"
From: David Brown <davidb@codeaurora.org>
To: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>
Cc: Stephen Boyd <sboyd@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [RFC PATCH 24/34] msm: clock: Support dummy clocks
Date: Wed,  2 Nov 2011 11:36:21 -0700
Message-Id: <1320258991-22325-25-git-send-email-davidb@codeaurora.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1320258991-22325-1-git-send-email-davidb@codeaurora.org>
References: <1320258991-22325-1-git-send-email-davidb@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Boyd <sboyd@codeaurora.org>

Implement a dummy clock driver and macro in the spirit of
CLK_PCOM(). This is useful on targets where a pclk doesn't exist
and we want to keep drivers sane by providing such clocks.

Reviewed-by: Saravana Kannan <skannan@codeaurora.org>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
Signed-off-by: David Brown <davidb@codeaurora.org>
---
 arch/arm/mach-msm/Makefile      |    1 +
 arch/arm/mach-msm/clock-dummy.c |   69 +++++++++++++++++++++++++++++++++++++++
 arch/arm/mach-msm/clock.h       |    9 +++++
 3 files changed, 79 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/mach-msm/clock-dummy.c

diff --git a/arch/arm/mach-msm/Makefile b/arch/arm/mach-msm/Makefile
index f1152ed..fd7f757 100644
--- a/arch/arm/mach-msm/Makefile
+++ b/arch/arm/mach-msm/Makefile
@@ -1,6 +1,7 @@
 obj-y += io.o idle.o timer.o
 obj-y += clock.o
 obj-y += clock-voter.o
+obj-y += clock-dummy.o
 obj-$(CONFIG_DEBUG_FS) += clock-debug.o
 obj-$(CONFIG_ARCH_MSM7X30) += clock-local.o clock-7x30.o
 obj-$(CONFIG_ARCH_MSM8X60) += clock-local.o clock-8x60.o
diff --git a/arch/arm/mach-msm/clock-dummy.c b/arch/arm/mach-msm/clock-dummy.c
new file mode 100644
index 0000000..47a94e3
--- /dev/null
+++ b/arch/arm/mach-msm/clock-dummy.c
@@ -0,0 +1,69 @@
+/* Copyright (c) 2011, Code Aurora Forum. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include "clock.h"
+
+static int dummy_clk_reset(struct clk *clk, enum clk_reset_action action)
+{
+	return 0;
+}
+
+static int dummy_clk_set_rate(struct clk *clk, unsigned rate)
+{
+	return 0;
+}
+
+static int dummy_clk_set_min_rate(struct clk *clk, unsigned rate)
+{
+	return 0;
+}
+
+static int dummy_clk_set_max_rate(struct clk *clk, unsigned rate)
+{
+	return 0;
+}
+
+static int dummy_clk_set_flags(struct clk *clk, unsigned flags)
+{
+	return 0;
+}
+
+static unsigned dummy_clk_get_rate(struct clk *clk)
+{
+	return 0;
+}
+
+static long dummy_clk_round_rate(struct clk *clk, unsigned rate)
+{
+	return rate;
+}
+
+static bool dummy_clk_is_local(struct clk *clk)
+{
+	return true;
+}
+
+static struct clk_ops clk_ops_dummy = {
+	.reset = dummy_clk_reset,
+	.set_rate = dummy_clk_set_rate,
+	.set_min_rate = dummy_clk_set_min_rate,
+	.set_max_rate = dummy_clk_set_max_rate,
+	.set_flags = dummy_clk_set_flags,
+	.get_rate = dummy_clk_get_rate,
+	.round_rate = dummy_clk_round_rate,
+	.is_local = dummy_clk_is_local,
+};
+
+struct clk dummy_clk = {
+	.ops = &clk_ops_dummy,
+	.dbg_name = "dummy_clk",
+};
diff --git a/arch/arm/mach-msm/clock.h b/arch/arm/mach-msm/clock.h
index 32b164c..11cfac8 100644
--- a/arch/arm/mach-msm/clock.h
+++ b/arch/arm/mach-msm/clock.h
@@ -87,5 +87,14 @@ static inline int __init clock_debug_init(void) { return 0; }
 static inline int __init clock_debug_add(struct clk *clock) { return 0; }
 #endif
 
+extern struct clk dummy_clk;
+
+#define CLK_DUMMY(clk_name, clk_id, clk_dev) {	\
+	.con_id = clk_name, \
+	.dev_id = clk_dev, \
+	.clk = &dummy_clk, \
+	}
+
 #define CLK_LOOKUP(con, c, dev) { .con_id = con, .clk = &c, .dev_id = dev }
+
 #endif
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

