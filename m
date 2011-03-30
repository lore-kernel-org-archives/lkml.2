Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756551Ab1C3XD7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 19:03:59 -0400
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:18424
	"EHLO VA3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756251Ab1C3XD5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 19:03:57 -0400
X-SpamScore: 0
X-BigFish: VS0(zzzz1202hzz8275bh8275dhz2dh2a8h668h63h)
X-Spam-TCS-SCL: 2:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
From: <Dinh.Nguyen@freescale.com>
To: <linux-kernel@vger.kernel.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linux@arm.linux.org.uk>,
        <s.hauer@pengutronix.de>, <u.kleine-koenig@pengutronix.de>,
        <arnaud.patard@rtp-net.org>, <ra5478@freescale.com>,
        <xiao-lizhang@freescale.com>, <festevam@gmail.com>,
        Dinh Nguyen <Dinh.Nguyen@freescale.com>
Subject: [PATCHv8] ARM: mx51: Add support for low power suspend on MX51
Date: Wed, 30 Mar 2011 18:03:30 -0500
Message-ID: <1301526210-21260-1-git-send-email-Dinh.Nguyen@freescale.com>
X-Mailer: git-send-email 1.6.0.4
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dinh Nguyen <Dinh.Nguyen@freescale.com>

Adds initial low power suspend functionality to MX51.
Supports "mem" and "standby" modes.

Tested on mx51-babbage.

Signed-off-by: Dinh Nguyen <Dinh.Nguyen@freescale.com>
---
 arch/arm/mach-mx5/Makefile  |    1 +
 arch/arm/mach-mx5/pm-imx5.c |   74 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 75 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/mach-mx5/pm-imx5.c

diff --git a/arch/arm/mach-mx5/Makefile b/arch/arm/mach-mx5/Makefile
index 0b9338c..d646feb 100644
--- a/arch/arm/mach-mx5/Makefile
+++ b/arch/arm/mach-mx5/Makefile
@@ -6,6 +6,7 @@
 obj-y   := cpu.o mm.o clock-mx51-mx53.o devices.o ehci.o system.o
 obj-$(CONFIG_SOC_IMX50) += mm-mx50.o
 
+obj-$(CONFIG_PM) += pm-imx5.o
 obj-$(CONFIG_CPU_FREQ_IMX)    += cpu_op-mx51.o
 obj-$(CONFIG_MACH_MX51_BABBAGE) += board-mx51_babbage.o
 obj-$(CONFIG_MACH_MX51_3DS) += board-mx51_3ds.o
diff --git a/arch/arm/mach-mx5/pm-imx5.c b/arch/arm/mach-mx5/pm-imx5.c
new file mode 100644
index 0000000..2232d04
--- /dev/null
+++ b/arch/arm/mach-mx5/pm-imx5.c
@@ -0,0 +1,74 @@
+/*
+ *  Copyright (C) 2011 Freescale Semiconductor, Inc. All Rights Reserved.
+ *
+ * The code contained herein is licensed under the GNU General Public
+ * License. You may obtain a copy of the GNU General Public License
+ * Version 2 or later at the following locations:
+ *
+ * http://www.opensource.org/licenses/gpl-license.html
+ * http://www.gnu.org/copyleft/gpl.html
+ */
+#include <linux/suspend.h>
+#include <linux/clk.h>
+#include <linux/io.h>
+#include <linux/err.h>
+#include <asm/cacheflush.h>
+#include <asm/tlbflush.h>
+#include <mach/system.h>
+#include "crm_regs.h"
+
+static struct clk *gpc_dvfs_clk;
+
+static int mx5_suspend_enter(suspend_state_t state)
+{
+	clk_enable(gpc_dvfs_clk);
+	switch (state) {
+	case PM_SUSPEND_MEM:
+		mx5_cpu_lp_set(STOP_POWER_OFF);
+		break;
+	case PM_SUSPEND_STANDBY:
+		mx5_cpu_lp_set(WAIT_UNCLOCKED_POWER_OFF);
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	if (state == PM_SUSPEND_MEM) {
+		local_flush_tlb_all();
+		flush_cache_all();
+
+		/*clear the EMPGC0/1 bits */
+		__raw_writel(0, MXC_SRPG_EMPGC0_SRPGCR);
+		__raw_writel(0, MXC_SRPG_EMPGC1_SRPGCR);
+	}
+	cpu_do_idle();
+	clk_disable(gpc_dvfs_clk);
+
+	return 0;
+}
+
+static int mx5_pm_valid(suspend_state_t state)
+{
+	return (state > PM_SUSPEND_ON && state <= PM_SUSPEND_MAX);
+}
+
+static const struct platform_suspend_ops mx5_suspend_ops = {
+	.valid = mx5_pm_valid,
+	.enter = mx5_suspend_enter,
+};
+
+static int __init mx5_pm_init(void)
+{
+	if (!cpu_is_mx51())
+		return 0;
+
+	gpc_dvfs_clk = clk_get(NULL, "gpc_dvfs");
+
+	if (IS_ERR(gpc_dvfs_clk))
+		printk(KERN_ERR "Cannot enter SRPG suspend -no gpc_dvfs clock!\n");
+	else
+		suspend_set_ops(&mx5_suspend_ops);
+
+	return 0;
+}
+device_initcall(mx5_pm_init);
-- 
1.6.0.4


