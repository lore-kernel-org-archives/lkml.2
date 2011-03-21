Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754634Ab1CUVq3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 17:46:29 -0400
Received: from mail-db3.bigfish.com ([94.245.120.74]:30700 "EHLO
	DB3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754148Ab1CUVq2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 17:46:28 -0400
X-Greylist: delayed 903 seconds by postgrey-1.27 at vger.kernel.org; Mon, 21 Mar 2011 17:46:27 EDT
X-SpamScore: 0
X-BigFish: VS0(zzzz1202hzz8275bh8275dhz2dh27ah2a8h668h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:error;EFVD:FOP
From: <Dinh.Nguyen@freescale.com>
To: <linux-kernel@vger.kernel.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linux@arm.linux.org.uk>,
        <s.hauer@pengutronix.de>, <u.kleine-koenig@pengutronix.de>,
        <arnaud.patard@rtp-net.org>, <ra5478@freescale.com>,
        <xiao-lizhang@freescale.com>, <festevam@gmail.com>,
        Dinh Nguyen <Dinh.Nguyen@freescale.com>
Subject: [PATCHv5 4/4] ARM: mx51: Add support for low power suspend on MX51
Date: Mon, 21 Mar 2011 16:30:38 -0500
Message-ID: <1300743038-3901-4-git-send-email-Dinh.Nguyen@freescale.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1300743038-3901-3-git-send-email-Dinh.Nguyen@freescale.com>
References: <1300743038-3901-1-git-send-email-Dinh.Nguyen@freescale.com>
 <1300743038-3901-2-git-send-email-Dinh.Nguyen@freescale.com>
 <1300743038-3901-3-git-send-email-Dinh.Nguyen@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Bypass-Agent: EF-1;
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
 arch/arm/mach-mx5/Makefile   |    1 +
 arch/arm/mach-mx5/pm-imx51.c |   74 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 75 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/mach-mx5/pm-imx51.c

diff --git a/arch/arm/mach-mx5/Makefile b/arch/arm/mach-mx5/Makefile
index 0b9338c..787cb80 100644
--- a/arch/arm/mach-mx5/Makefile
+++ b/arch/arm/mach-mx5/Makefile
@@ -6,6 +6,7 @@
 obj-y   := cpu.o mm.o clock-mx51-mx53.o devices.o ehci.o system.o
 obj-$(CONFIG_SOC_IMX50) += mm-mx50.o
 
+obj-$(CONFIG_PM) += pm-imx51.o
 obj-$(CONFIG_CPU_FREQ_IMX)    += cpu_op-mx51.o
 obj-$(CONFIG_MACH_MX51_BABBAGE) += board-mx51_babbage.o
 obj-$(CONFIG_MACH_MX51_3DS) += board-mx51_3ds.o
diff --git a/arch/arm/mach-mx5/pm-imx51.c b/arch/arm/mach-mx5/pm-imx51.c
new file mode 100644
index 0000000..f5164b2
--- /dev/null
+++ b/arch/arm/mach-mx5/pm-imx51.c
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
+#include <asm/cacheflush.h>
+#include <asm/tlbflush.h>
+#include <mach/system.h>
+#include "crm_regs.h"
+
+static struct clk *gpc_dvfs_clk;
+
+static int mx5_suspend_enter(suspend_state_t state)
+{
+	if (gpc_dvfs_clk == NULL)
+		gpc_dvfs_clk = clk_get(NULL, "gpc_dvfs");
+
+	if (gpc_dvfs_clk) {
+		clk_enable(gpc_dvfs_clk);
+		switch (state) {
+		case PM_SUSPEND_MEM:
+			mx5_cpu_lp_set(STOP_POWER_OFF);
+			break;
+		case PM_SUSPEND_STANDBY:
+			mx5_cpu_lp_set(WAIT_UNCLOCKED_POWER_OFF);
+			break;
+		default:
+			return -EINVAL;
+		}
+
+		if (state == PM_SUSPEND_MEM) {
+			local_flush_tlb_all();
+			flush_cache_all();
+
+			/*clear the EMPGC0/1 bits */
+			__raw_writel(0, MXC_SRPG_EMPGC0_SRPGCR);
+			__raw_writel(0, MXC_SRPG_EMPGC1_SRPGCR);
+		}
+		cpu_do_idle();
+		clk_disable(gpc_dvfs_clk);
+	}else {
+		printk(KERN_ERR "Cannot enter SRPG suspend -no gpc_dvfs clock!\n");
+		return -EPERM;
+	}
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
+	if (cpu_is_mx51())
+		suspend_set_ops(&mx5_suspend_ops);
+
+	return 0;
+}
+device_initcall(mx5_pm_init);
-- 
1.6.0.4


