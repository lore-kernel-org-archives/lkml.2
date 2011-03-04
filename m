Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760201Ab1CDXaf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 18:30:35 -0500
Received: from am1ehsobe002.messaging.microsoft.com ([213.199.154.205]:18669
	"EHLO AM1EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759644Ab1CDXad (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 18:30:33 -0500
X-SpamScore: 0
X-BigFish: VS0(zzzz1202hzz8275bh8275dhz2dh2a8h668h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:az33egw01.freescale.net;RD:az33egw01.freescale.net;EFVD:NLI
From: <Dinh.Nguyen@freescale.com>
To: <linux-kernel@vger.kernel.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linux@arm.linux.org.uk>,
        <s.hauer@pengutronix.de>, <u.kleine-koenig@pengutronix.de>,
        <xiao-lizhang@freescale.com>, <Ranjani.Vaidyanathan@freescale.com>,
        Dinh Nguyen <Dinh.Nguyen@freescale.com>
Subject: [PATCHv2 2/2] ARM: mx51: Add support for low power suspend on MX51
Date: Fri, 4 Mar 2011 17:29:59 -0600
Message-ID: <1299281399-32304-2-git-send-email-Dinh.Nguyen@freescale.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1299281399-32304-1-git-send-email-Dinh.Nguyen@freescale.com>
References: <1299281399-32304-1-git-send-email-Dinh.Nguyen@freescale.com>
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
 arch/arm/mach-mx5/Makefile   |    1 +
 arch/arm/mach-mx5/pm-imx51.c |   62 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 63 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/mach-mx5/pm-imx51.c

diff --git a/arch/arm/mach-mx5/Makefile b/arch/arm/mach-mx5/Makefile
index 1106acd..2f6258e 100644
--- a/arch/arm/mach-mx5/Makefile
+++ b/arch/arm/mach-mx5/Makefile
@@ -6,6 +6,7 @@
 obj-y   := cpu.o mm.o clock-mx51-mx53.o devices.o system.o
 obj-$(CONFIG_SOC_IMX50) += mm-mx50.o
 
+obj-$(CONFIG_PM) += pm-imx51.o
 obj-$(CONFIG_CPU_FREQ_IMX)    += cpu_op-mx51.o
 obj-$(CONFIG_MACH_MX51_BABBAGE) += board-mx51_babbage.o
 obj-$(CONFIG_MACH_MX51_3DS) += board-mx51_3ds.o
diff --git a/arch/arm/mach-mx5/pm-imx51.c b/arch/arm/mach-mx5/pm-imx51.c
new file mode 100644
index 0000000..6bb76e2
--- /dev/null
+++ b/arch/arm/mach-mx5/pm-imx51.c
@@ -0,0 +1,62 @@
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
+#include <asm/mach/map.h>
+#include <asm/cacheflush.h>
+#include <asm/tlb.h>
+#include <mach/system.h>
+#include "crm_regs.h"
+
+static int mx5_suspend_enter(suspend_state_t state)
+{
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
+
+	cpu_do_idle();
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


