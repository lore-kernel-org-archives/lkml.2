Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964881Ab2KHVEQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 16:04:16 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:34675 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964813Ab2KHVCV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 16:02:21 -0500
From: Stephen Warren <swarren@wwwdotorg.org>
To: Russell King <linux@arm.linux.org.uk>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, John Stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Stephen Warren <swarren@nvidia.com>,
        Andrew Victor <linux@maxim.org.za>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
Subject: [PATCH 05/11] ARM: at91: convert timer suspend/resume to clock_event_device
Date: Thu,  8 Nov 2012 14:01:50 -0700
Message-Id: <1352408516-21988-7-git-send-email-swarren@wwwdotorg.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1352408516-21988-1-git-send-email-swarren@wwwdotorg.org>
References: <1352408516-21988-1-git-send-email-swarren@wwwdotorg.org>
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Warren <swarren@nvidia.com>

Move at91's timer suspend/resume functions from struct sys_timer
at91sam926x_timer into struct clock_event_device pit_clkevt. This
will allow the sys_timer suspend/resume fields to be removed, and
eventually lead to a complete removal of struct sys_timer.

Cc: Andrew Victor <linux@maxim.org.za>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
 arch/arm/mach-at91/at91sam926x_time.c |   47 ++++++++++++++++++--------------
 1 files changed, 26 insertions(+), 21 deletions(-)

diff --git a/arch/arm/mach-at91/at91sam926x_time.c b/arch/arm/mach-at91/at91sam926x_time.c
index ffc0957..2794882 100644
--- a/arch/arm/mach-at91/at91sam926x_time.c
+++ b/arch/arm/mach-at91/at91sam926x_time.c
@@ -94,12 +94,38 @@ pit_clkevt_mode(enum clock_event_mode mode, struct clock_event_device *dev)
 	}
 }
 
+static void at91sam926x_pit_suspend(struct clock_event_device *cedev)
+{
+	/* Disable timer */
+	pit_write(AT91_PIT_MR, 0);
+}
+
+static void at91sam926x_pit_reset(void)
+{
+	/* Disable timer and irqs */
+	pit_write(AT91_PIT_MR, 0);
+
+	/* Clear any pending interrupts, wait for PIT to stop counting */
+	while (PIT_CPIV(pit_read(AT91_PIT_PIVR)) != 0)
+		cpu_relax();
+
+	/* Start PIT but don't enable IRQ */
+	pit_write(AT91_PIT_MR, (pit_cycle - 1) | AT91_PIT_PITEN);
+}
+
+static void at91sam926x_pit_resume(struct clock_event_device *cedev)
+{
+	at91sam926x_pit_reset();
+}
+
 static struct clock_event_device pit_clkevt = {
 	.name		= "pit",
 	.features	= CLOCK_EVT_FEAT_PERIODIC,
 	.shift		= 32,
 	.rating		= 100,
 	.set_mode	= pit_clkevt_mode,
+	.suspend	= at91sam926x_pit_suspend,
+	.resume		= at91sam926x_pit_resume,
 };
 
 
@@ -140,19 +166,6 @@ static struct irqaction at91sam926x_pit_irq = {
 	.irq		= NR_IRQS_LEGACY + AT91_ID_SYS,
 };
 
-static void at91sam926x_pit_reset(void)
-{
-	/* Disable timer and irqs */
-	pit_write(AT91_PIT_MR, 0);
-
-	/* Clear any pending interrupts, wait for PIT to stop counting */
-	while (PIT_CPIV(pit_read(AT91_PIT_PIVR)) != 0)
-		cpu_relax();
-
-	/* Start PIT but don't enable IRQ */
-	pit_write(AT91_PIT_MR, (pit_cycle - 1) | AT91_PIT_PITEN);
-}
-
 #ifdef CONFIG_OF
 static struct of_device_id pit_timer_ids[] = {
 	{ .compatible = "atmel,at91sam9260-pit" },
@@ -240,12 +253,6 @@ static void __init at91sam926x_pit_init(void)
 	clockevents_register_device(&pit_clkevt);
 }
 
-static void at91sam926x_pit_suspend(void)
-{
-	/* Disable timer */
-	pit_write(AT91_PIT_MR, 0);
-}
-
 void __init at91sam926x_ioremap_pit(u32 addr)
 {
 #if defined(CONFIG_OF)
@@ -265,6 +272,4 @@ void __init at91sam926x_ioremap_pit(u32 addr)
 
 struct sys_timer at91sam926x_timer = {
 	.init		= at91sam926x_pit_init,
-	.suspend	= at91sam926x_pit_suspend,
-	.resume		= at91sam926x_pit_reset,
 };
-- 
1.7.0.4

