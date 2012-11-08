Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964851Ab2KHVC1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 16:02:27 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:48404 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964789Ab2KHVCX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 16:02:23 -0500
From: Stephen Warren <swarren@wwwdotorg.org>
To: Russell King <linux@arm.linux.org.uk>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, John Stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Stephen Warren <swarren@nvidia.com>,
        Eric Miao <eric.y.miao@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Haojian Zhuang <haojian.zhuang@gmail.com>
Subject: [PATCH 06/11] ARM: pxa: convert timer suspend/resume to clock_event_device
Date: Thu,  8 Nov 2012 14:01:51 -0700
Message-Id: <1352408516-21988-8-git-send-email-swarren@wwwdotorg.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1352408516-21988-1-git-send-email-swarren@wwwdotorg.org>
References: <1352408516-21988-1-git-send-email-swarren@wwwdotorg.org>
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Warren <swarren@nvidia.com>

Move PXA's timer suspend/resume functions from struct sys_timer
pxa_timer into struct clock_event_device ckevt_pxa_osmr0. This
will allow the sys_timer suspend/resume fields to be removed, and
eventually lead to a complete removal of struct sys_timer.

Cc: Eric Miao <eric.y.miao@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Haojian Zhuang <haojian.zhuang@gmail.com>
Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
 arch/arm/mach-pxa/time.c |   76 +++++++++++++++++++++++-----------------------
 1 files changed, 38 insertions(+), 38 deletions(-)

diff --git a/arch/arm/mach-pxa/time.c b/arch/arm/mach-pxa/time.c
index 4bc47d6..ce58bc9 100644
--- a/arch/arm/mach-pxa/time.c
+++ b/arch/arm/mach-pxa/time.c
@@ -89,12 +89,50 @@ pxa_osmr0_set_mode(enum clock_event_mode mode, struct clock_event_device *dev)
 	}
 }
 
+#ifdef CONFIG_PM
+static unsigned long osmr[4], oier, oscr;
+
+static void pxa_timer_suspend(struct clock_event_device *cedev)
+{
+	osmr[0] = readl_relaxed(OSMR0);
+	osmr[1] = readl_relaxed(OSMR1);
+	osmr[2] = readl_relaxed(OSMR2);
+	osmr[3] = readl_relaxed(OSMR3);
+	oier = readl_relaxed(OIER);
+	oscr = readl_relaxed(OSCR);
+}
+
+static void pxa_timer_resume(struct clock_event_device *cedev)
+{
+	/*
+	 * Ensure that we have at least MIN_OSCR_DELTA between match
+	 * register 0 and the OSCR, to guarantee that we will receive
+	 * the one-shot timer interrupt.  We adjust OSMR0 in preference
+	 * to OSCR to guarantee that OSCR is monotonically incrementing.
+	 */
+	if (osmr[0] - oscr < MIN_OSCR_DELTA)
+		osmr[0] += MIN_OSCR_DELTA;
+
+	writel_relaxed(osmr[0], OSMR0);
+	writel_relaxed(osmr[1], OSMR1);
+	writel_relaxed(osmr[2], OSMR2);
+	writel_relaxed(osmr[3], OSMR3);
+	writel_relaxed(oier, OIER);
+	writel_relaxed(oscr, OSCR);
+}
+#else
+#define pxa_timer_suspend NULL
+#define pxa_timer_resume NULL
+#endif
+
 static struct clock_event_device ckevt_pxa_osmr0 = {
 	.name		= "osmr0",
 	.features	= CLOCK_EVT_FEAT_ONESHOT,
 	.rating		= 200,
 	.set_next_event	= pxa_osmr0_set_next_event,
 	.set_mode	= pxa_osmr0_set_mode,
+	.suspend	= pxa_timer_suspend,
+	.resume		= pxa_timer_resume,
 };
 
 static struct irqaction pxa_ost0_irq = {
@@ -127,44 +165,6 @@ static void __init pxa_timer_init(void)
 	clockevents_register_device(&ckevt_pxa_osmr0);
 }
 
-#ifdef CONFIG_PM
-static unsigned long osmr[4], oier, oscr;
-
-static void pxa_timer_suspend(void)
-{
-	osmr[0] = readl_relaxed(OSMR0);
-	osmr[1] = readl_relaxed(OSMR1);
-	osmr[2] = readl_relaxed(OSMR2);
-	osmr[3] = readl_relaxed(OSMR3);
-	oier = readl_relaxed(OIER);
-	oscr = readl_relaxed(OSCR);
-}
-
-static void pxa_timer_resume(void)
-{
-	/*
-	 * Ensure that we have at least MIN_OSCR_DELTA between match
-	 * register 0 and the OSCR, to guarantee that we will receive
-	 * the one-shot timer interrupt.  We adjust OSMR0 in preference
-	 * to OSCR to guarantee that OSCR is monotonically incrementing.
-	 */
-	if (osmr[0] - oscr < MIN_OSCR_DELTA)
-		osmr[0] += MIN_OSCR_DELTA;
-
-	writel_relaxed(osmr[0], OSMR0);
-	writel_relaxed(osmr[1], OSMR1);
-	writel_relaxed(osmr[2], OSMR2);
-	writel_relaxed(osmr[3], OSMR3);
-	writel_relaxed(oier, OIER);
-	writel_relaxed(oscr, OSCR);
-}
-#else
-#define pxa_timer_suspend NULL
-#define pxa_timer_resume NULL
-#endif
-
 struct sys_timer pxa_timer = {
 	.init		= pxa_timer_init,
-	.suspend	= pxa_timer_suspend,
-	.resume		= pxa_timer_resume,
 };
-- 
1.7.0.4

