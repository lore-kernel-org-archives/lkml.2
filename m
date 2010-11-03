Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753593Ab0KCWs7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 18:48:59 -0400
Received: from db3ehsobe003.messaging.microsoft.com ([213.199.154.141]:31923
	"EHLO DB3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753546Ab0KCWs4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 18:48:56 -0400
X-SpamScore: 0
X-BigFish: VS0(zzzz1202hzz8275bh8275dhz2dh2a8h61h)
X-Spam-TCS-SCL: 0:0
From: <Dinh.Nguyen@freescale.com>
To: <linux-kernel@vger.kernel.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linux@arm.linux.org.uk>,
        <s.hauer@pengutronix.de>, <u.kleine-koenig@pengutronix.de>,
        <valentin.longchamp@epfl.ch>, <daniel@caiaq.de>,
        <grant.likely@secretlab.ca>, <amit.kucheria@canonical.com>,
        Dinh Nguyen <Dinh.Nguyen@freescale.com>
Subject: [PATCH] ARM: imx: Add support for low power suspend on MX51.
Date: Wed, 3 Nov 2010 17:52:09 -0500
Message-ID: <1288824729-11481-1-git-send-email-Dinh.Nguyen@freescale.com>
X-Mailer: git-send-email 1.6.0.4
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: de01egw01.freescale.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dinh Nguyen <Dinh.Nguyen@freescale.com>

Adds initial low power suspend functionality to MX51.
Supports "mem" and "standby" modes.

Signed-off-by: Dinh Nguyen <Dinh.Nguyen@freescale.com>
---
 arch/arm/mach-mx5/Makefile           |    2 +-
 arch/arm/mach-mx5/pm.c               |   92 ++++++++++++++++++++++++++++++++++
 arch/arm/plat-mxc/include/mach/mxc.h |    6 ++
 3 files changed, 99 insertions(+), 1 deletions(-)
 create mode 100644 arch/arm/mach-mx5/pm.c

diff --git a/arch/arm/mach-mx5/Makefile b/arch/arm/mach-mx5/Makefile
index 462f177..aefc9a1 100644
--- a/arch/arm/mach-mx5/Makefile
+++ b/arch/arm/mach-mx5/Makefile
@@ -3,7 +3,7 @@
 #
 
 # Object file lists.
-obj-y   := cpu.o mm.o clock-mx51.o devices.o
+obj-y   := cpu.o mm.o clock-mx51.o devices.o pm.o
 
 obj-$(CONFIG_CPU_FREQ_IMX)    += cpu_op-mx51.o
 obj-$(CONFIG_MACH_MX51_BABBAGE) += board-mx51_babbage.o
diff --git a/arch/arm/mach-mx5/pm.c b/arch/arm/mach-mx5/pm.c
new file mode 100644
index 0000000..a32640e
--- /dev/null
+++ b/arch/arm/mach-mx5/pm.c
@@ -0,0 +1,92 @@
+/*
+ *  Copyright (C) 2010 Freescale Semiconductor, Inc. All Rights Reserved.
+ *
+ * The code contained herein is licensed under the GNU General Public
+ * License. You may obtain a copy of the GNU General Public License
+ * Version 2 or later at the following locations:
+ *
+ * http://www.opensource.org/licenses/gpl-license.html
+ * http://www.gnu.org/copyleft/gpl.html
+ */
+#include <linux/kernel.h>
+#include <linux/suspend.h>
+#include <linux/io.h>
+#include <asm/cacheflush.h>
+#include <asm/tlb.h>
+#include <asm/mach/map.h>
+#include <mach/system.h>
+#include "crm_regs.h"
+
+/* set cpu low power mode before WFI instruction */
+static void mxc_cpu_lp_set(enum mxc_cpu_pwr_mode mode)
+{
+	u32 plat_lpc, arm_srpgcr, ccm_clpcr;
+
+	/* always allow platform to issue a deep sleep mode request */
+	plat_lpc = __raw_readl(MXC_CORTEXA8_PLAT_LPC) &
+		~(MXC_CORTEXA8_PLAT_LPC_DSM);
+	ccm_clpcr = __raw_readl(MXC_CCM_CLPCR) & ~(MXC_CCM_CLPCR_LPM_MASK);
+	arm_srpgcr = __raw_readl(MXC_SRPG_ARM_SRPGCR) & ~(MXC_SRPGCR_PCR);
+
+	switch (mode) {
+	case WAIT_UNCLOCKED_POWER_OFF:
+	case STOP_POWER_OFF:
+		plat_lpc |= MXC_CORTEXA8_PLAT_LPC_DSM
+		    | MXC_CORTEXA8_PLAT_LPC_DBG_DSM;
+		if (mode == WAIT_UNCLOCKED_POWER_OFF) {
+			ccm_clpcr |= (0x1 << MXC_CCM_CLPCR_LPM_OFFSET);
+			ccm_clpcr &= ~MXC_CCM_CLPCR_VSTBY;
+			ccm_clpcr &= ~MXC_CCM_CLPCR_SBYOS;
+		} else {
+			ccm_clpcr |= (0x2 << MXC_CCM_CLPCR_LPM_OFFSET);
+			ccm_clpcr |= (0x3 << MXC_CCM_CLPCR_STBY_COUNT_OFFSET);
+			ccm_clpcr |= MXC_CCM_CLPCR_VSTBY;
+			ccm_clpcr |= MXC_CCM_CLPCR_SBYOS;
+		}
+		arm_srpgcr |= MXC_SRPGCR_PCR;
+		break;
+	default:
+		printk(KERN_WARNING "UNKNOWN cpu power mode: %d\n", mode);
+		return;
+	}
+
+	__raw_writel(plat_lpc, MXC_CORTEXA8_PLAT_LPC);
+	__raw_writel(ccm_clpcr, MXC_CCM_CLPCR);
+	__raw_writel(arm_srpgcr, MXC_SRPG_ARM_SRPGCR);
+}
+
+static int mx5_suspend_enter(suspend_state_t state)
+{
+	switch (state) {
+	case PM_SUSPEND_MEM:
+		mxc_cpu_lp_set(STOP_POWER_OFF);
+		break;
+	case PM_SUSPEND_STANDBY:
+		mxc_cpu_lp_set(WAIT_UNCLOCKED_POWER_OFF);
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	if (tzic_enable_wake(0) != 0)
+		return -EAGAIN;
+	cpu_do_idle();
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
+	suspend_set_ops(&mx5_suspend_ops);
+	return 0;
+}
+device_initcall(mx5_pm_init);
diff --git a/arch/arm/plat-mxc/include/mach/mxc.h b/arch/arm/plat-mxc/include/mach/mxc.h
index a42c720..ece13fc 100644
--- a/arch/arm/plat-mxc/include/mach/mxc.h
+++ b/arch/arm/plat-mxc/include/mach/mxc.h
@@ -37,6 +37,12 @@
 
 #ifndef __ASSEMBLY__
 extern unsigned int __mxc_cpu_type;
+
+enum mxc_cpu_pwr_mode {
+	WAIT_UNCLOCKED_POWER_OFF,	/* WAIT + SRPG */
+	STOP_POWER_OFF,		/* STOP + SRPG */
+};
+int tzic_enable_wake(int is_idle);
 #endif
 
 #ifdef CONFIG_ARCH_MX1
-- 
1.6.0.4


