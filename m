Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932188Ab2ILQ7d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 12:59:33 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:54598 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760554Ab2ILQ7a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 12:59:30 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6832"; a="235815647"
From: David Brown <davidb@codeaurora.org>
To: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>
Cc: Stephen Boyd <sboyd@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: [PATCH 11/24] ARM: msm: Don't touch GIC registers outside of GIC code
Date: Wed, 12 Sep 2012 09:58:47 -0700
Message-Id: <1347469140-25069-12-git-send-email-davidb@codeaurora.org>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1347469140-25069-1-git-send-email-davidb@codeaurora.org>
References: <1347469140-25069-1-git-send-email-davidb@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Boyd <sboyd@codeaurora.org>

The MSM code has some antiquated register writes to set up the
PPIs to be edge triggered. Now that we have the percpu irq
interface we don't need this code so let's remove it and update
the percpu irq user (msm_timer) to set the irq type.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
Signed-off-by: David Brown <davidb@codeaurora.org>
---
 arch/arm/mach-msm/board-msm8960.c | 13 -------------
 arch/arm/mach-msm/board-msm8x60.c |  3 ---
 arch/arm/mach-msm/platsmp.c       |  8 --------
 arch/arm/mach-msm/timer.c         |  4 ++--
 4 files changed, 2 insertions(+), 26 deletions(-)

diff --git a/arch/arm/mach-msm/board-msm8960.c b/arch/arm/mach-msm/board-msm8960.c
index 65f4a1d..bdafe79 100644
--- a/arch/arm/mach-msm/board-msm8960.c
+++ b/arch/arm/mach-msm/board-msm8960.c
@@ -55,24 +55,11 @@ static void __init msm8960_map_io(void)
 
 static void __init msm8960_init_irq(void)
 {
-	unsigned int i;
 	gic_init(0, GIC_PPI_START, MSM_QGIC_DIST_BASE,
 		 (void *)MSM_QGIC_CPU_BASE);
 
-	/* Edge trigger PPIs except AVS_SVICINT and AVS_SVICINTSWDONE */
-	writel(0xFFFFD7FF, MSM_QGIC_DIST_BASE + GIC_DIST_CONFIG + 4);
-
 	if (machine_is_msm8960_rumi3())
 		writel(0x0000FFFF, MSM_QGIC_DIST_BASE + GIC_DIST_ENABLE_SET);
-
-	/* FIXME: Not installing AVS_SVICINT and AVS_SVICINTSWDONE yet
-	 * as they are configured as level, which does not play nice with
-	 * handle_percpu_irq.
-	 */
-	for (i = GIC_PPI_START; i < GIC_SPI_START; i++) {
-		if (i != AVS_SVICINT && i != AVS_SVICINTSWDONE)
-			irq_set_handler(i, handle_percpu_irq);
-	}
 }
 
 static struct platform_device *sim_devices[] __initdata = {
diff --git a/arch/arm/mach-msm/board-msm8x60.c b/arch/arm/mach-msm/board-msm8x60.c
index ad87207..64ae269 100644
--- a/arch/arm/mach-msm/board-msm8x60.c
+++ b/arch/arm/mach-msm/board-msm8x60.c
@@ -67,9 +67,6 @@ static void __init msm8x60_init_irq(void)
 		of_irq_init(msm_dt_gic_match);
 #endif
 
-	/* Edge trigger PPIs except AVS_SVICINT and AVS_SVICINTSWDONE */
-	writel(0xFFFFD7FF, MSM_QGIC_DIST_BASE + GIC_DIST_CONFIG + 4);
-
 	/* RUMI does not adhere to GIC spec by enabling STIs by default.
 	 * Enable/clear is supposed to be RO for STIs, but is RW on RUMI.
 	 */
diff --git a/arch/arm/mach-msm/platsmp.c b/arch/arm/mach-msm/platsmp.c
index db0117e..b119f99 100644
--- a/arch/arm/mach-msm/platsmp.c
+++ b/arch/arm/mach-msm/platsmp.c
@@ -22,17 +22,12 @@
 #include <asm/mach-types.h>
 #include <asm/smp_plat.h>
 
-#include <mach/msm_iomap.h>
-
 #include "scm-boot.h"
 
 #define VDD_SC1_ARRAY_CLAMP_GFS_CTL 0x15A0
 #define SCSS_CPU1CORE_RESET 0xD80
 #define SCSS_DBG_STATUS_CORE_PWRDUP 0xE64
 
-/* Mask for edge trigger PPIs except AVS_SVICINT and AVS_SVICINTSWDONE */
-#define GIC_PPI_EDGE_MASK 0xFFFFD7FF
-
 extern void msm_secondary_startup(void);
 /*
  * control for which core is the next to come out of the secondary
@@ -50,9 +45,6 @@ static inline int get_core_count(void)
 
 void __cpuinit platform_secondary_init(unsigned int cpu)
 {
-	/* Configure edge-triggered PPIs */
-	writel(GIC_PPI_EDGE_MASK, MSM_QGIC_DIST_BASE + GIC_DIST_CONFIG + 4);
-
 	/*
 	 * if any interrupts are already enabled for the primary
 	 * core (e.g. timer irq), then they will not have been enabled
diff --git a/arch/arm/mach-msm/timer.c b/arch/arm/mach-msm/timer.c
index 004f935..846e1e5 100644
--- a/arch/arm/mach-msm/timer.c
+++ b/arch/arm/mach-msm/timer.c
@@ -151,7 +151,7 @@ static int __cpuinit msm_local_timer_setup(struct clock_event_device *evt)
 
 	*__this_cpu_ptr(msm_evt.percpu_evt) = evt;
 	clockevents_register_device(evt);
-	enable_percpu_irq(evt->irq, 0);
+	enable_percpu_irq(evt->irq, IRQ_TYPE_EDGE_RISING);
 	return 0;
 }
 
@@ -219,7 +219,7 @@ static void __init msm_timer_init(void)
 		res = request_percpu_irq(ce->irq, msm_timer_interrupt,
 					 ce->name, msm_evt.percpu_evt);
 		if (!res) {
-			enable_percpu_irq(ce->irq, 0);
+			enable_percpu_irq(ce->irq, IRQ_TYPE_EDGE_RISING);
 #ifdef CONFIG_LOCAL_TIMERS
 			local_timer_register(&msm_local_timer_ops);
 #endif
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

