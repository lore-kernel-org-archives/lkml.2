Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753183Ab2AZRIy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 12:08:54 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:2907 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751354Ab2AZRIw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 12:08:52 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 26 Jan 2012 09:08:46 -0800
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
Cc: Colin Cross <ccross@android.com>, Olof Johansson <olof@lixom.net>,
        Stephen Warren <swarren@nvidia.com>,
        Russell King <linux@arm.linux.org.uk>, Gary King <gking@nvidia.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v1 8/8] ARM: tegra: support for secondary cores on Tegra30
Date: Thu, 26 Jan 2012 19:07:13 +0200
Message-Id: <1327597641-7519-9-git-send-email-pdeschrijver@nvidia.com>
X-Mailer: git-send-email 1.7.7.rc0.72.g4b5ea.dirty
In-Reply-To: <1327597641-7519-1-git-send-email-pdeschrijver@nvidia.com>
References: <1327597641-7519-1-git-send-email-pdeschrijver@nvidia.com>
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for bringing up secondary cores on Tegra30. On Tegra30 secondary
CPU cores are powergated, so we need to turn on the domains before we can bring
the CPU cores online. Bringing secondary cores online happens early during the
ssytem boot, so we call powergating initialization from platform early_init
function.

Based on work by:

Scott Williams <scwilliams@nvidia.com>
Colin Cross <ccross@android.com>
Alex Frid <afrid@nvidia.com>

Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
---
 arch/arm/mach-tegra/headsmp.S |   32 +++++++++++++++++++++++++
 arch/arm/mach-tegra/platsmp.c |   52 ++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 83 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-tegra/headsmp.S b/arch/arm/mach-tegra/headsmp.S
index bb13e22..925c4a0 100644
--- a/arch/arm/mach-tegra/headsmp.S
+++ b/arch/arm/mach-tegra/headsmp.S
@@ -188,6 +188,38 @@ __die:
 	str	r1, [r7, #0x340]		@ CLK_RST_CPU_CMPLX_SET
 #endif
 1:
+#ifdef CONFIG_ARCH_TEGRA_3x_SOC
+	mov32	r6, TEGRA_FLOW_CTRL_BASE
+
+	cmp	r10, #0
+	moveq	r1, #FLOW_CTRL_HALT_CPU0_EVENTS
+	moveq	r2, #FLOW_CTRL_CPU0_CSR
+	movne	r1, r10, lsl #3
+	addne	r2, r1, #(FLOW_CTRL_CPU1_CSR-8)
+	addne	r1, r1, #(FLOW_CTRL_HALT_CPU1_EVENTS-8)
+
+	/* Clear CPU "event" and "interrupt" flags and power gate
+	   it when halting but not before it is in the "WFI" state. */
+	ldr	r0, [r6, +r2]
+	orr	r0, r0, #FLOW_CTRL_CSR_INTR_FLAG | FLOW_CTRL_CSR_EVENT_FLAG
+	orr	r0, r0, #FLOW_CTRL_CSR_ENABLE
+	str	r0, [r6, +r2]
+
+	/* Unconditionally halt this CPU */
+	mov	r0, #FLOW_CTRL_WAITEVENT
+	str	r0, [r6, +r1]
+	ldr	r0, [r6, +r1]			@ memory barrier
+
+	dsb
+	isb
+	wfi					@ CPU should be power gated here
+
+	/* If the CPU didn't power gate above just kill it's clock. */
+
+	mov	r0, r11, lsl #8
+	str	r0, [r7, #348]			@ CLK_CPU_CMPLX_SET
+#endif
+
 	/* If the CPU still isn't dead, just spin here. */
 	b	.
 ENDPROC(__tegra_cpu_reset_handler)
diff --git a/arch/arm/mach-tegra/platsmp.c b/arch/arm/mach-tegra/platsmp.c
index fa1178d..672a751 100644
--- a/arch/arm/mach-tegra/platsmp.c
+++ b/arch/arm/mach-tegra/platsmp.c
@@ -24,7 +24,9 @@
 #include <asm/mach-types.h>
 #include <asm/smp_scu.h>
 
+#include <mach/clk.h>
 #include <mach/iomap.h>
+#include <mach/powergate.h>
 
 #include "chipid.h"
 #include "flowctrl.h"
@@ -42,6 +44,8 @@ static void __iomem *scu_base = IO_ADDRESS(TEGRA_ARM_PERIF_BASE);
 	(IO_ADDRESS(TEGRA_CLK_RESET_BASE) + 0x340)
 #define CLK_RST_CONTROLLER_RST_CPU_CMPLX_CLR \
 	(IO_ADDRESS(TEGRA_CLK_RESET_BASE) + 0x344)
+#define CLK_RST_CONTROLLER_CLK_CPU_CMPLX_CLR \
+	(IO_ADDRESS(TEGRA_CLK_RESET_BASE) + 0x34c)
 
 #define CPU_CLOCK(cpu)	(0x1<<(8+cpu))
 #define CPU_RESET(cpu)	(0x1111ul<<(cpu))
@@ -73,11 +77,54 @@ static int tegra20_power_up_cpu(unsigned int cpu)
 	return 0;
 }
 
+static int tegra30_power_up_cpu(unsigned int cpu)
+{
+	u32 reg;
+	int ret, pwrgateid;
+	unsigned long timeout;
+
+	pwrgateid = tegra_cpu_powergate_id(cpu);
+	if (pwrgateid < 0)
+		return pwrgateid;
+
+	/* If this is the first boot, toggle powergates directly. */
+	if (!tegra_powergate_is_powered(pwrgateid)) {
+		ret = tegra_powergate_power_on(pwrgateid);
+		if (ret)
+			return ret;
+
+		/* Wait for the power to come up. */
+		timeout = jiffies + 10*HZ;
+		do {
+			if (tegra_powergate_is_powered(pwrgateid))
+				goto remove_clamps;
+			udelay(10);
+		} while (time_before(jiffies, timeout));
+		return -ETIMEDOUT;
+	}
+
+remove_clamps:
+	/* CPU partition is powered. Enable the CPU clock. */
+	writel(CPU_CLOCK(cpu), CLK_RST_CONTROLLER_CLK_CPU_CMPLX_CLR);
+	reg = readl(CLK_RST_CONTROLLER_CLK_CPU_CMPLX_CLR);
+	udelay(10);
+
+	/* Remove I/O clamps. */
+	ret = tegra_powergate_remove_clamping(pwrgateid);
+	udelay(10);
+
+	/* Clear flow controller CSR. */
+	flowctrl_write_cpu_csr(cpu, 0);
+
+	return 0;
+}
+
 int __cpuinit boot_secondary(unsigned int cpu, struct task_struct *idle)
 {
 	int status;
 
-	/* Force the CPU into reset. The CPU must remain in reset when the
+	/*
+	 * Force the CPU into reset. The CPU must remain in reset when the
 	 * flow controller state is cleared (which will cause the flow
 	 * controller to stop driving reset if the CPU has been power-gated
 	 * via the flow controller). This will have no effect on first boot
@@ -98,6 +145,9 @@ int __cpuinit boot_secondary(unsigned int cpu, struct task_struct *idle)
 	case TEGRA20:
 		status = tegra20_power_up_cpu(cpu);
 		break;
+	case TEGRA30:
+		status = tegra30_power_up_cpu(cpu);
+		break;
 	default:
 		status = -EINVAL;
 		break;
-- 
1.7.7.rc0.72.g4b5ea.dirty

