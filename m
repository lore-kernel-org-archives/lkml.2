Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756135Ab0KRToN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 14:44:13 -0500
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:36389
	"EHLO VA3EHSOBE008.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751145Ab0KRToL convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 14:44:11 -0500
X-SpamScore: -24
X-BigFish: VS-24(zz542N1432N4015L9371Pzz1202hzz8275bh8275dhz2dh2a8h668h67dh685h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:az33egw02.freescale.net;RD:az33egw02.freescale.net;EFVD:NLI
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-Language: en-US
X-OriginalArrivalTime: 18 Nov 2010 19:45:07.0066 (UTC) FILETIME=[1A24F5A0:01CB8759]
Accept-Language: en-US
acceptlanguage: en-US
X-MS-Has-Attach: 
Content-Class: urn:content-classes:message
Subject: RE: [PATCHv3] ARM: imx: Add support for low power suspend on MX51.
Date: Thu, 18 Nov 2010 12:45:04 -0700
Message-ID: <56132A77AB93C141BF06E6B96CA6CFEACBB0@039-SN1MPN1-005.039d.mgd.msft.net>
In-Reply-To: <1289419604-4103-1-git-send-email-Dinh.Nguyen@freescale.com>
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCHv3] ARM: imx: Add support for low power suspend on MX51.
Thread-Index: AcuBElKptOnPSxXeQRSkTs6YEtEiPwGRqGVQ
References: <1289419604-4103-1-git-send-email-Dinh.Nguyen@freescale.com>
From: Nguyen Dinh-R00091 <R00091@freescale.com>
To: Nguyen Dinh-R00091 <R00091@freescale.com>, <linux-kernel@vger.kernel.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linux@arm.linux.org.uk>,
        <s.hauer@pengutronix.de>, <u.kleine-koenig@pengutronix.de>,
        <amit.kucheria@canonical.com>, <eric@eukrea.com>
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sascha/Uwe,

I was wondering if you had time to digest this patch?

Thanks,
Dinh

>-----Original Message-----
>From: Nguyen Dinh-R00091
>Sent: Wednesday, November 10, 2010 2:07 PM
>To: linux-kernel@vger.kernel.org
>Cc: linux-arm-kernel@lists.infradead.org; linux@arm.linux.org.uk;
s.hauer@pengutronix.de; u.kleine-
>koenig@pengutronix.de; amit.kucheria@canonical.com; eric@eukrea.com;
Nguyen Dinh-R00091
>Subject: [PATCHv3] ARM: imx: Add support for low power suspend on MX51.
>
>From: Dinh Nguyen <Dinh.Nguyen@freescale.com>
>
>Adds initial low power suspend functionality to MX51.
>Supports "mem" and "standby" modes.
>
>Signed-off-by: Dinh Nguyen <Dinh.Nguyen@freescale.com>
>---
> arch/arm/mach-mx5/Makefile           |    1 +
> arch/arm/mach-mx5/pm.c               |   70
++++++++++++++++++++++++++++++++++
> arch/arm/plat-mxc/include/mach/mxc.h |    1 +
> 3 files changed, 72 insertions(+), 0 deletions(-)
> create mode 100644 arch/arm/mach-mx5/pm.c
>
>diff --git a/arch/arm/mach-mx5/Makefile b/arch/arm/mach-mx5/Makefile
>index 462f177..25b44d1 100644
>--- a/arch/arm/mach-mx5/Makefile
>+++ b/arch/arm/mach-mx5/Makefile
>@@ -5,6 +5,7 @@
> # Object file lists.
> obj-y   := cpu.o mm.o clock-mx51.o devices.o
>
>+obj-$(CONFIG_PM) += pm.o
> obj-$(CONFIG_CPU_FREQ_IMX)    += cpu_op-mx51.o
> obj-$(CONFIG_MACH_MX51_BABBAGE) += board-mx51_babbage.o
> obj-$(CONFIG_MACH_MX51_3DS) += board-mx51_3ds.o
>diff --git a/arch/arm/mach-mx5/pm.c b/arch/arm/mach-mx5/pm.c
>new file mode 100644
>index 0000000..417cce1
>--- /dev/null
>+++ b/arch/arm/mach-mx5/pm.c
>@@ -0,0 +1,70 @@
>+/*
>+ *  Copyright (C) 2010 Freescale Semiconductor, Inc. All Rights
Reserved.
>+ *
>+ * The code contained herein is licensed under the GNU General Public
>+ * License. You may obtain a copy of the GNU General Public License
>+ * Version 2 or later at the following locations:
>+ *
>+ * http://www.opensource.org/licenses/gpl-license.html
>+ * http://www.gnu.org/copyleft/gpl.html
>+ */
>+#include <linux/suspend.h>
>+#include <asm/mach/map.h>
>+#include <mach/system.h>
>+#include "crm_regs.h"
>+
>+static int mx5_suspend_enter(suspend_state_t state)
>+{
>+	u32 plat_lpc, arm_srpgcr, ccm_clpcr;
>+
>+	/* always allow platform to issue a deep sleep mode request */
>+	ccm_clpcr = __raw_readl(MXC_CCM_CLPCR) &
~(MXC_CCM_CLPCR_LPM_MASK);
>+
>+	switch (state) {
>+	case PM_SUSPEND_MEM:
>+		ccm_clpcr |= (0x2 << MXC_CCM_CLPCR_LPM_OFFSET);
>+		ccm_clpcr |= (0x3 << MXC_CCM_CLPCR_STBY_COUNT_OFFSET);
>+		ccm_clpcr |= MXC_CCM_CLPCR_VSTBY;
>+		ccm_clpcr |= MXC_CCM_CLPCR_SBYOS;
>+		break;
>+	case PM_SUSPEND_STANDBY:
>+		ccm_clpcr |= (0x1 << MXC_CCM_CLPCR_LPM_OFFSET);
>+		ccm_clpcr &= ~MXC_CCM_CLPCR_VSTBY;
>+		ccm_clpcr &= ~MXC_CCM_CLPCR_SBYOS;
>+		break;
>+	default:
>+		return -EINVAL;
>+	}
>+
>+	plat_lpc |= MXC_CORTEXA8_PLAT_LPC_DSM
>+		    | MXC_CORTEXA8_PLAT_LPC_DBG_DSM;
>+	arm_srpgcr |= MXC_SRPGCR_PCR;
>+
>+	__raw_writel(plat_lpc, MXC_CORTEXA8_PLAT_LPC);
>+	__raw_writel(arm_srpgcr, MXC_SRPG_ARM_SRPGCR);
>+	__raw_writel(ccm_clpcr, MXC_CCM_CLPCR);
>+
>+	if (tzic_enable_wake(0) != 0)
>+		return -EAGAIN;
>+
>+	cpu_do_idle();
>+	return 0;
>+}
>+
>+static int mx5_pm_valid(suspend_state_t state)
>+{
>+	return (state > PM_SUSPEND_ON && state <= PM_SUSPEND_MAX);
>+}
>+
>+static const struct platform_suspend_ops mx5_suspend_ops = {
>+	.valid = mx5_pm_valid,
>+	.enter = mx5_suspend_enter,
>+};
>+
>+static int __init mx5_pm_init(void)
>+{
>+	if (cpu_is_mx51())
>+		suspend_set_ops(&mx5_suspend_ops);
>+	return 0;
>+}
>+device_initcall(mx5_pm_init);
>diff --git a/arch/arm/plat-mxc/include/mach/mxc.h
b/arch/arm/plat-mxc/include/mach/mxc.h
>index a42c720..dafacfd 100644
>--- a/arch/arm/plat-mxc/include/mach/mxc.h
>+++ b/arch/arm/plat-mxc/include/mach/mxc.h
>@@ -37,6 +37,7 @@
>
> #ifndef __ASSEMBLY__
> extern unsigned int __mxc_cpu_type;
>+int tzic_enable_wake(int is_idle);
> #endif
>
> #ifdef CONFIG_ARCH_MX1
>--
>1.6.0.4



