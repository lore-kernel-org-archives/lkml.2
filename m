Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934392Ab1CXXex (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 19:34:53 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:22133 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757338Ab1CXXet (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 19:34:49 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6295"; a="81934576"
From: Stephen Boyd <sboyd@codeaurora.org>
To: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Saravana Kannan <skannan@codeaurora.org>
Subject: [PATCH 1/2] msm: clock: Support dummy clocks
Date: Thu, 24 Mar 2011 16:34:45 -0700
Message-Id: <1301009686-4042-2-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.7.4.1.415.g5e839
In-Reply-To: <1301009686-4042-1-git-send-email-sboyd@codeaurora.org>
References: <1301009686-4042-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement a dummy clock driver and macro in the spirit of
CLK_PCOM(). This is useful on targets where a pclk doesn't exist
and we want to keep drivers sane by providing such clocks.

Change-Id: Iad37f6e5f19052127814934cf7484971fdb4fcda
Reviewed-by: Saravana Kannan <skannan@codeaurora.org>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 arch/arm/mach-msm/Makefile      |    1 +
 arch/arm/mach-msm/clock-dummy.c |   81 +++++++++++++++++++++++++++++++++++++++
 arch/arm/mach-msm/clock.h       |   11 +++++
 3 files changed, 93 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/mach-msm/clock-dummy.c

diff --git a/arch/arm/mach-msm/Makefile b/arch/arm/mach-msm/Makefile
index f641480..e8cc2ee 100644
--- a/arch/arm/mach-msm/Makefile
+++ b/arch/arm/mach-msm/Makefile
@@ -1,5 +1,6 @@
 obj-y += io.o idle.o timer.o
 obj-y += clock.o
+obj-y += clock-dummy.o
 obj-$(CONFIG_DEBUG_FS) += clock-debug.o
 
 obj-$(CONFIG_MSM_VIC) += irq-vic.o
diff --git a/arch/arm/mach-msm/clock-dummy.c b/arch/arm/mach-msm/clock-dummy.c
new file mode 100644
index 0000000..8ae3768
--- /dev/null
+++ b/arch/arm/mach-msm/clock-dummy.c
@@ -0,0 +1,81 @@
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
+static int dummy_clk_enable(unsigned id)
+{
+	return 0;
+}
+
+static void dummy_clk_disable(unsigned id)
+{
+}
+
+static int dummy_clk_reset(unsigned id, enum clk_reset_action action)
+{
+	return 0;
+}
+
+static int dummy_clk_set_rate(unsigned id, unsigned rate)
+{
+	return 0;
+}
+
+static int dummy_clk_set_min_rate(unsigned id, unsigned rate)
+{
+	return 0;
+}
+
+static int dummy_clk_set_max_rate(unsigned id, unsigned rate)
+{
+	return 0;
+}
+
+static int dummy_clk_set_flags(unsigned id, unsigned flags)
+{
+	return 0;
+}
+
+static unsigned dummy_clk_get_rate(unsigned id)
+{
+	return 0;
+}
+
+static unsigned dummy_clk_is_enabled(unsigned id)
+{
+	return 0;
+}
+
+static long dummy_clk_round_rate(unsigned id, unsigned rate)
+{
+	return rate;
+}
+
+static bool dummy_clk_is_local(unsigned id)
+{
+	return true;
+}
+
+struct clk_ops clk_ops_dummy = {
+	.enable = dummy_clk_enable,
+	.disable = dummy_clk_disable,
+	.reset = dummy_clk_reset,
+	.set_rate = dummy_clk_set_rate,
+	.set_min_rate = dummy_clk_set_min_rate,
+	.set_max_rate = dummy_clk_set_max_rate,
+	.set_flags = dummy_clk_set_flags,
+	.get_rate = dummy_clk_get_rate,
+	.is_enabled = dummy_clk_is_enabled,
+	.round_rate = dummy_clk_round_rate,
+	.is_local = dummy_clk_is_local,
+};
diff --git a/arch/arm/mach-msm/clock.h b/arch/arm/mach-msm/clock.h
index 2c007f6..1e62074 100644
--- a/arch/arm/mach-msm/clock.h
+++ b/arch/arm/mach-msm/clock.h
@@ -69,4 +69,15 @@ static inline int __init clock_debug_init(void) { return 0; }
 static inline int __init clock_debug_add(struct clk *clock) { return 0; }
 #endif
 
+extern struct clk_ops clk_ops_dummy;
+
+#define CLK_DUMMY(clk_name, clk_id, clk_dev) {	\
+	.con_id = clk_name, \
+	.dev_id = clk_dev, \
+	.clk = &(struct clk){ \
+		.dbg_name = #clk_id, \
+		.ops = &clk_ops_dummy, \
+	}, \
+	}
+
 #endif
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

