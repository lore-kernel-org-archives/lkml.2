Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756219Ab1CBRSa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 12:18:30 -0500
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:39661
	"EHLO VA3EHSOBE007.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755898Ab1CBRS3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 12:18:29 -0500
X-SpamScore: 0
X-BigFish: VS0(zzzz1202hzz8275bh8275dhz2dh2a8h668h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:az33egw01.freescale.net;RD:az33egw01.freescale.net;EFVD:NLI
From: <Dinh.Nguyen@freescale.com>
To: <linux-kernel@vger.kernel.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linux@arm.linux.org.uk>,
        <s.hauer@pengutronix.de>, <u.kleine-koenig@pengutronix.de>,
        <xiao-lizhang@freescale.com>, Dinh Nguyen <Dinh.Nguyen@freescale.com>
Subject: [PATCHv1] ARM: imx: Add support for low power suspend on MX51.
Date: Wed, 2 Mar 2011 11:17:58 -0600
Message-ID: <1299086278-12131-1-git-send-email-Dinh.Nguyen@freescale.com>
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

Signed-off-by: Dinh Nguyen <Dinh.Nguyen@freescale.com>
---
 arch/arm/mach-mx5/Makefile           |    1 +
 arch/arm/mach-mx5/pm.c               |   75 ++++++++++++++++++++++++++++++++++
 arch/arm/plat-mxc/include/mach/mxc.h |    1 +
 3 files changed, 77 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/mach-mx5/pm.c

diff --git a/arch/arm/mach-mx5/Makefile b/arch/arm/mach-mx5/Makefile
index 4f63048..7f9435d 100644
--- a/arch/arm/mach-mx5/Makefile
+++ b/arch/arm/mach-mx5/Makefile
@@ -6,6 +6,7 @@
 obj-y   := cpu.o mm.o clock-mx51-mx53.o devices.o ehci.o
 obj-$(CONFIG_SOC_IMX50) += mm-mx50.o
 
+obj-$(CONFIG_PM) += pm.o
 obj-$(CONFIG_CPU_FREQ_IMX)    += cpu_op-mx51.o
 obj-$(CONFIG_MACH_MX51_BABBAGE) += board-mx51_babbage.o
 obj-$(CONFIG_MACH_MX51_3DS) += board-mx51_3ds.o
diff --git a/arch/arm/mach-mx5/pm.c b/arch/arm/mach-mx5/pm.c
new file mode 100644
index 0000000..137d204
--- /dev/null
+++ b/arch/arm/mach-mx5/pm.c
@@ -0,0 +1,75 @@
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
+#include <mach/system.h>
+#include "crm_regs.h"
+
+static int mx5_suspend_enter(suspend_state_t state)
+{
+	u32 plat_lpc, arm_srpgcr, ccm_clpcr;
+
+	/* always allow platform to issue a deep sleep mode request */
+	plat_lpc = __raw_readl(MXC_CORTEXA8_PLAT_LPC) &
+	    ~(MXC_CORTEXA8_PLAT_LPC_DSM);
+	ccm_clpcr = __raw_readl(MXC_CCM_CLPCR) & ~(MXC_CCM_CLPCR_LPM_MASK);
+	arm_srpgcr = __raw_readl(MXC_SRPG_ARM_SRPGCR) & ~(MXC_SRPGCR_PCR);
+
+	switch (state) {
+	case PM_SUSPEND_MEM:
+		ccm_clpcr |= (0x2 << MXC_CCM_CLPCR_LPM_OFFSET);
+		ccm_clpcr |= (0x3 << MXC_CCM_CLPCR_STBY_COUNT_OFFSET);
+		ccm_clpcr |= MXC_CCM_CLPCR_VSTBY;
+		ccm_clpcr |= MXC_CCM_CLPCR_SBYOS;
+		break;
+	case PM_SUSPEND_STANDBY:
+		ccm_clpcr |= (0x1 << MXC_CCM_CLPCR_LPM_OFFSET);
+		ccm_clpcr &= ~MXC_CCM_CLPCR_VSTBY;
+		ccm_clpcr &= ~MXC_CCM_CLPCR_SBYOS;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	plat_lpc |= MXC_CORTEXA8_PLAT_LPC_DSM
+		    | MXC_CORTEXA8_PLAT_LPC_DBG_DSM;
+	arm_srpgcr |= MXC_SRPGCR_PCR;
+
+	__raw_writel(plat_lpc, MXC_CORTEXA8_PLAT_LPC);
+	__raw_writel(ccm_clpcr, MXC_CCM_CLPCR);
+	__raw_writel(arm_srpgcr, MXC_SRPG_ARM_SRPGCR);
+	__raw_writel(arm_srpgcr, MXC_SRPG_NEON_SRPGCR);
+
+	if (tzic_enable_wake(0) != 0)
+		return -EAGAIN;
+
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
+	if (cpu_is_mx51())
+		suspend_set_ops(&mx5_suspend_ops);
+
+	return 0;
+}
+device_initcall(mx5_pm_init);
diff --git a/arch/arm/plat-mxc/include/mach/mxc.h b/arch/arm/plat-mxc/include/mach/mxc.h
index 04c7a26..a72839f 100644
--- a/arch/arm/plat-mxc/include/mach/mxc.h
+++ b/arch/arm/plat-mxc/include/mach/mxc.h
@@ -53,6 +53,7 @@
 
 #ifndef __ASSEMBLY__
 extern unsigned int __mxc_cpu_type;
+int tzic_enable_wake(int is_idle);
 #endif
 
 #ifdef CONFIG_ARCH_MX1
-- 
1.6.0.4


