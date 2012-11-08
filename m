Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964899Ab2KHVD5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 16:03:57 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:46176 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964832Ab2KHVCZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 16:02:25 -0500
From: Stephen Warren <swarren@wwwdotorg.org>
To: Russell King <linux@arm.linux.org.uk>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, John Stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Subject: [PATCH 07/11] ARM: sa1100: convert timer suspend/resume to clock_event_device
Date: Thu,  8 Nov 2012 14:01:52 -0700
Message-Id: <1352408516-21988-9-git-send-email-swarren@wwwdotorg.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1352408516-21988-1-git-send-email-swarren@wwwdotorg.org>
References: <1352408516-21988-1-git-send-email-swarren@wwwdotorg.org>
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Warren <swarren@nvidia.com>

Move sa1100's timer suspend/resume functions from struct sys_timer
sa1100_timer into struct clock_event_device ckevt_sa1100_osmr0. This
will allow the sys_timer suspend/resume fields to be removed, and
eventually lead to a complete removal of struct sys_timer.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
 arch/arm/mach-sa1100/time.c |   66 +++++++++++++++++++++---------------------
 1 files changed, 33 insertions(+), 33 deletions(-)

diff --git a/arch/arm/mach-sa1100/time.c b/arch/arm/mach-sa1100/time.c
index 80702c9..164f827 100644
--- a/arch/arm/mach-sa1100/time.c
+++ b/arch/arm/mach-sa1100/time.c
@@ -69,12 +69,45 @@ sa1100_osmr0_set_mode(enum clock_event_mode mode, struct clock_event_device *c)
 	}
 }
 
+#ifdef CONFIG_PM
+unsigned long osmr[4], oier;
+
+static void sa1100_timer_suspend(struct clock_event_device *cedev)
+{
+	osmr[0] = readl_relaxed(OSMR0);
+	osmr[1] = readl_relaxed(OSMR1);
+	osmr[2] = readl_relaxed(OSMR2);
+	osmr[3] = readl_relaxed(OSMR3);
+	oier = readl_relaxed(OIER);
+}
+
+static void sa1100_timer_resume(struct clock_event_device *cedev)
+{
+	writel_relaxed(0x0f, OSSR);
+	writel_relaxed(osmr[0], OSMR0);
+	writel_relaxed(osmr[1], OSMR1);
+	writel_relaxed(osmr[2], OSMR2);
+	writel_relaxed(osmr[3], OSMR3);
+	writel_relaxed(oier, OIER);
+
+	/*
+	 * OSMR0 is the system timer: make sure OSCR is sufficiently behind
+	 */
+	writel_relaxed(OSMR0 - LATCH, OSCR);
+}
+#else
+#define sa1100_timer_suspend NULL
+#define sa1100_timer_resume NULL
+#endif
+
 static struct clock_event_device ckevt_sa1100_osmr0 = {
 	.name		= "osmr0",
 	.features	= CLOCK_EVT_FEAT_ONESHOT,
 	.rating		= 200,
 	.set_next_event	= sa1100_osmr0_set_next_event,
 	.set_mode	= sa1100_osmr0_set_mode,
+	.suspend	= sa1100_timer_suspend,
+	.resume		= sa1100_timer_resume,
 };
 
 static struct irqaction sa1100_timer_irq = {
@@ -105,39 +138,6 @@ static void __init sa1100_timer_init(void)
 	clockevents_register_device(&ckevt_sa1100_osmr0);
 }
 
-#ifdef CONFIG_PM
-unsigned long osmr[4], oier;
-
-static void sa1100_timer_suspend(void)
-{
-	osmr[0] = readl_relaxed(OSMR0);
-	osmr[1] = readl_relaxed(OSMR1);
-	osmr[2] = readl_relaxed(OSMR2);
-	osmr[3] = readl_relaxed(OSMR3);
-	oier = readl_relaxed(OIER);
-}
-
-static void sa1100_timer_resume(void)
-{
-	writel_relaxed(0x0f, OSSR);
-	writel_relaxed(osmr[0], OSMR0);
-	writel_relaxed(osmr[1], OSMR1);
-	writel_relaxed(osmr[2], OSMR2);
-	writel_relaxed(osmr[3], OSMR3);
-	writel_relaxed(oier, OIER);
-
-	/*
-	 * OSMR0 is the system timer: make sure OSCR is sufficiently behind
-	 */
-	writel_relaxed(OSMR0 - LATCH, OSCR);
-}
-#else
-#define sa1100_timer_suspend NULL
-#define sa1100_timer_resume NULL
-#endif
-
 struct sys_timer sa1100_timer = {
 	.init		= sa1100_timer_init,
-	.suspend	= sa1100_timer_suspend,
-	.resume		= sa1100_timer_resume,
 };
-- 
1.7.0.4

