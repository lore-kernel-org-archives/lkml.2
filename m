Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752301Ab1CJPMz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 10:12:55 -0500
Received: from db3ehsobe002.messaging.microsoft.com ([213.199.154.140]:22878
	"EHLO DB3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751788Ab1CJPMy convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 10:12:54 -0500
X-SpamScore: -24
X-BigFish: VS-24(zz542N1432N4015L9371Pzz1202hzz8275bh8275dhz2dh2a8h668h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
From: Nguyen Dinh-R00091 <R00091@freescale.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "u.kleine-koenig@pengutronix.de" <u.kleine-koenig@pengutronix.de>,
        Zhang Lily-R58066 <R58066@freescale.com>,
        Vaidyanathan Ranjani-RA5478 <RA5478@freescale.com>
Subject: RE: [PATCHv2 1/2] ARM: mx51: Implement code to allow mx51 to enter
 WFI
Thread-Topic: [PATCHv2 1/2] ARM: mx51: Implement code to allow mx51 to enter
 WFI
Thread-Index: AQHL2sQV2wru9FbG9kebNQISz1Arp5QmtSKA
Date: Thu, 10 Mar 2011 15:12:42 +0000
Message-ID: <56132A77AB93C141BF06E6B96CA6CFEA19CF8A@039-SN1MPN1-004.039d.mgd.msft.net>
References: <1299281399-32304-1-git-send-email-Dinh.Nguyen@freescale.com>
In-Reply-To: <1299281399-32304-1-git-send-email-Dinh.Nguyen@freescale.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.81.68.39]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Uwe/Sascha,

Just wondering if you had a chance to review this patch series?

Thanks,
Dinh

>-----Original Message-----
>From: Nguyen Dinh-R00091
>Sent: Friday, March 04, 2011 5:30 PM
>To: linux-kernel@vger.kernel.org
>Cc: linux-arm-kernel@lists.infradead.org; linux@arm.linux.org.uk; s.hauer@pengutronix.de; u.kleine-
>koenig@pengutronix.de; Zhang Lily-R58066; Vaidyanathan Ranjani-RA5478; Nguyen Dinh-R00091
>Subject: [PATCHv2 1/2] ARM: mx51: Implement code to allow mx51 to enter WFI
>
>From: Dinh Nguyen <Dinh.Nguyen@freescale.com>
>
>Implement code for MX51 that allows the SoC to enter WFI when
>arch_idle is called.
>
>This patch is also necessary for correctly suspending the system.
>
>Signed-off-by: Dinh Nguyen <Dinh.Nguyen@freescale.com>
>---
> arch/arm/mach-mx5/Makefile              |    2 +-
> arch/arm/mach-mx5/system.c              |   84 +++++++++++++++++++++++++++++++
> arch/arm/plat-mxc/include/mach/mxc.h    |    9 +++
> arch/arm/plat-mxc/include/mach/system.h |    6 ++-
> 4 files changed, 99 insertions(+), 2 deletions(-)
> create mode 100644 arch/arm/mach-mx5/system.c
>
>diff --git a/arch/arm/mach-mx5/Makefile b/arch/arm/mach-mx5/Makefile
>index 0d43be9..1106acd 100644
>--- a/arch/arm/mach-mx5/Makefile
>+++ b/arch/arm/mach-mx5/Makefile
>@@ -3,7 +3,7 @@
> #
>
> # Object file lists.
>-obj-y   := cpu.o mm.o clock-mx51-mx53.o devices.o
>+obj-y   := cpu.o mm.o clock-mx51-mx53.o devices.o system.o
> obj-$(CONFIG_SOC_IMX50) += mm-mx50.o
>
> obj-$(CONFIG_CPU_FREQ_IMX)    += cpu_op-mx51.o
>diff --git a/arch/arm/mach-mx5/system.c b/arch/arm/mach-mx5/system.c
>new file mode 100644
>index 0000000..06d306b
>--- /dev/null
>+++ b/arch/arm/mach-mx5/system.c
>@@ -0,0 +1,84 @@
>+/*
>+ * Copyright (C) 2011 Freescale Semiconductor, Inc. All Rights Reserved.
>+ */
>+
>+/*
>+ * The code contained herein is licensed under the GNU General Public
>+ * License. You may obtain a copy of the GNU General Public License
>+ * Version 2 or later at the following locations:
>+ *
>+ * http://www.opensource.org/licenses/gpl-license.html
>+ * http://www.gnu.org/copyleft/gpl.html
>+ */
>+#include <linux/platform_device.h>
>+#include <asm/io.h>
>+#include <mach/hardware.h>
>+#include "crm_regs.h"
>+
>+/* set cpu low power mode before WFI instruction. This function is called mx5 because
>+ it can be used for mx50, mx51, and mx53.*/
>+void mx5_cpu_lp_set(enum mxc_cpu_pwr_mode mode)
>+{
>+	u32 plat_lpc, arm_srpgcr, ccm_clpcr;
>+	u32 empgc0, empgc1;
>+	int stop_mode = 0;
>+
>+	/* always allow platform to issue a deep sleep mode request */
>+	plat_lpc = __raw_readl(MXC_CORTEXA8_PLAT_LPC) &
>+	    ~(MXC_CORTEXA8_PLAT_LPC_DSM);
>+	ccm_clpcr = __raw_readl(MXC_CCM_CLPCR) & ~(MXC_CCM_CLPCR_LPM_MASK);
>+	arm_srpgcr = __raw_readl(MXC_SRPG_ARM_SRPGCR) & ~(MXC_SRPGCR_PCR);
>+	empgc0 = __raw_readl(MXC_SRPG_EMPGC0_SRPGCR) & ~(MXC_SRPGCR_PCR);
>+	empgc1 = __raw_readl(MXC_SRPG_EMPGC1_SRPGCR) & ~(MXC_SRPGCR_PCR);
>+
>+	switch (mode) {
>+	case WAIT_CLOCKED:
>+		break;
>+	case WAIT_UNCLOCKED:
>+		ccm_clpcr |= 0x1 << MXC_CCM_CLPCR_LPM_OFFSET;
>+		break;
>+	case WAIT_UNCLOCKED_POWER_OFF:
>+	case STOP_POWER_OFF:
>+		plat_lpc |= MXC_CORTEXA8_PLAT_LPC_DSM
>+			    | MXC_CORTEXA8_PLAT_LPC_DBG_DSM;
>+		if (mode == WAIT_UNCLOCKED_POWER_OFF) {
>+			ccm_clpcr |= 0x1 << MXC_CCM_CLPCR_LPM_OFFSET;
>+			ccm_clpcr &= ~MXC_CCM_CLPCR_VSTBY;
>+			ccm_clpcr &= ~MXC_CCM_CLPCR_SBYOS;
>+			stop_mode = 0;
>+		} else {
>+			ccm_clpcr |= 0x2 << MXC_CCM_CLPCR_LPM_OFFSET;
>+			ccm_clpcr |= 0x3 << MXC_CCM_CLPCR_STBY_COUNT_OFFSET;
>+			ccm_clpcr |= MXC_CCM_CLPCR_VSTBY;
>+			ccm_clpcr |= MXC_CCM_CLPCR_SBYOS;
>+			stop_mode = 1;
>+		}
>+
>+		arm_srpgcr |= MXC_SRPGCR_PCR;
>+		if (stop_mode) {
>+			empgc0 |= MXC_SRPGCR_PCR;
>+			empgc1 |= MXC_SRPGCR_PCR;
>+		}
>+
>+		if (tzic_enable_wake(1) != 0)
>+			return;
>+		break;
>+	case STOP_POWER_ON:
>+		ccm_clpcr |= 0x2 << MXC_CCM_CLPCR_LPM_OFFSET;
>+		break;
>+	default:
>+		printk(KERN_WARNING "UNKNOWN cpu power mode: %d\n", mode);
>+		return;
>+	}
>+
>+	__raw_writel(plat_lpc, MXC_CORTEXA8_PLAT_LPC);
>+	__raw_writel(ccm_clpcr, MXC_CCM_CLPCR);
>+	__raw_writel(arm_srpgcr, MXC_SRPG_ARM_SRPGCR);
>+	/* Enable NEON SRPG for all but MX50TO1.0. */
>+	__raw_writel(arm_srpgcr, MXC_SRPG_NEON_SRPGCR);
>+	if (stop_mode) {
>+		__raw_writel(empgc0, MXC_SRPG_EMPGC0_SRPGCR);
>+		__raw_writel(empgc1, MXC_SRPG_EMPGC1_SRPGCR);
>+	}
>+}
>+
>diff --git a/arch/arm/plat-mxc/include/mach/mxc.h b/arch/arm/plat-mxc/include/mach/mxc.h
>index 04c7a26..8a8970d 100644
>--- a/arch/arm/plat-mxc/include/mach/mxc.h
>+++ b/arch/arm/plat-mxc/include/mach/mxc.h
>@@ -181,6 +181,15 @@ struct cpu_op {
> 	u32 cpu_rate;
> };
>
>+int tzic_enable_wake(int is_idle);
>+enum mxc_cpu_pwr_mode {
>+	WAIT_CLOCKED,		/* wfi only */
>+	WAIT_UNCLOCKED,		/* WAIT */
>+	WAIT_UNCLOCKED_POWER_OFF,	/* WAIT + SRPG */
>+	STOP_POWER_ON,		/* just STOP */
>+	STOP_POWER_OFF,		/* STOP + SRPG */
>+};
>+
> extern struct cpu_op *(*get_cpu_op)(int *op);
> #endif
>
>diff --git a/arch/arm/plat-mxc/include/mach/system.h b/arch/arm/plat-mxc/include/mach/system.h
>index 95be51b..35283a4 100644
>--- a/arch/arm/plat-mxc/include/mach/system.h
>+++ b/arch/arm/plat-mxc/include/mach/system.h
>@@ -20,6 +20,8 @@
> #include <mach/hardware.h>
> #include <mach/common.h>
>
>+extern void mx5_cpu_lp_set(enum mxc_cpu_pwr_mode mode);
>+
> static inline void arch_idle(void)
> {
> #ifdef CONFIG_ARCH_MXC91231
>@@ -54,7 +56,9 @@ static inline void arch_idle(void)
> 			"orr %0, %0, #0x00000004\n"
> 			"mcr p15, 0, %0, c1, c0, 0\n"
> 			: "=r" (reg));
>-	} else
>+	} else if (cpu_is_mx51())
>+		mx5_cpu_lp_set(WAIT_UNCLOCKED_POWER_OFF);
>+	else
> 		cpu_do_idle();
> }
>
>--
>1.6.0.4


