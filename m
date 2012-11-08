Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964869Ab2KHVCb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 16:02:31 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:33269 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964849Ab2KHVC1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 16:02:27 -0500
From: Stephen Warren <swarren@wwwdotorg.org>
To: Russell King <linux@arm.linux.org.uk>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, John Stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Stephen Warren <swarren@nvidia.com>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 08/11] ARM: ux500: convert timer suspend/resume to clock_event_device
Date: Thu,  8 Nov 2012 14:01:53 -0700
Message-Id: <1352408516-21988-10-git-send-email-swarren@wwwdotorg.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1352408516-21988-1-git-send-email-swarren@wwwdotorg.org>
References: <1352408516-21988-1-git-send-email-swarren@wwwdotorg.org>
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Warren <swarren@nvidia.com>

Move ux500's timer suspend/resume functions from struct sys_timer
ux500_timer into struct clock_event_device nmdk_clkevt. This
will allow the sys_timer suspend/resume fields to be removed, and
eventually lead to a complete removal of struct sys_timer.

Cc: Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>
Cc: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
 arch/arm/mach-ux500/timer.c       |    7 -------
 drivers/clocksource/nomadik-mtu.c |   33 ++++++++++++++++++++-------------
 2 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/arch/arm/mach-ux500/timer.c b/arch/arm/mach-ux500/timer.c
index 875309a..46a7244 100644
--- a/arch/arm/mach-ux500/timer.c
+++ b/arch/arm/mach-ux500/timer.c
@@ -100,13 +100,6 @@ dt_fail:
 	ux500_twd_init();
 }
 
-static void ux500_timer_reset(void)
-{
-	nmdk_clkevt_reset();
-	nmdk_clksrc_reset();
-}
-
 struct sys_timer ux500_timer = {
 	.init		= ux500_timer_init,
-	.resume		= ux500_timer_reset,
 };
diff --git a/drivers/clocksource/nomadik-mtu.c b/drivers/clocksource/nomadik-mtu.c
index 23c780b..a60b077 100644
--- a/drivers/clocksource/nomadik-mtu.c
+++ b/drivers/clocksource/nomadik-mtu.c
@@ -134,12 +134,32 @@ static void nmdk_clkevt_mode(enum clock_event_mode mode,
 	}
 }
 
+void nmdk_clksrc_reset(void)
+{
+	/* Disable */
+	writel(0, mtu_base + MTU_CR(0));
+
+	/* ClockSource: configure load and background-load, and fire it up */
+	writel(nmdk_cycle, mtu_base + MTU_LR(0));
+	writel(nmdk_cycle, mtu_base + MTU_BGLR(0));
+
+	writel(clk_prescale | MTU_CRn_32BITS | MTU_CRn_ENA,
+	       mtu_base + MTU_CR(0));
+}
+
+static void nmdk_clkevt_resume(struct clock_event_device *cedev)
+{
+	nmdk_clkevt_reset();
+	nmdk_clksrc_reset();
+}
+
 static struct clock_event_device nmdk_clkevt = {
 	.name		= "mtu_1",
 	.features	= CLOCK_EVT_FEAT_ONESHOT | CLOCK_EVT_FEAT_PERIODIC,
 	.rating		= 200,
 	.set_mode	= nmdk_clkevt_mode,
 	.set_next_event	= nmdk_clkevt_next,
+	.resume		= nmdk_clkevt_resume,
 };
 
 /*
@@ -161,19 +181,6 @@ static struct irqaction nmdk_timer_irq = {
 	.dev_id		= &nmdk_clkevt,
 };
 
-void nmdk_clksrc_reset(void)
-{
-	/* Disable */
-	writel(0, mtu_base + MTU_CR(0));
-
-	/* ClockSource: configure load and background-load, and fire it up */
-	writel(nmdk_cycle, mtu_base + MTU_LR(0));
-	writel(nmdk_cycle, mtu_base + MTU_BGLR(0));
-
-	writel(clk_prescale | MTU_CRn_32BITS | MTU_CRn_ENA,
-	       mtu_base + MTU_CR(0));
-}
-
 void __init nmdk_timer_init(void __iomem *base, int irq)
 {
 	unsigned long rate;
-- 
1.7.0.4

