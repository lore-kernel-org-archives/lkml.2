Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760181Ab1IKMAu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Sep 2011 08:00:50 -0400
Received: from georges.telenet-ops.be ([195.130.137.68]:42681 "EHLO
	georges.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760135Ab1IKMAF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Sep 2011 08:00:05 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-m68k@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>,
        Sam Creasey <sammy@sammy.net>
Subject: [PATCH 25/28] m68k/sun3: Convert Sun3/3x to genirq
Date: Sun, 11 Sep 2011 13:59:51 +0200
Message-Id: <1315742394-16036-26-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1315742394-16036-1-git-send-email-geert@linux-m68k.org>
References: <1315742394-16036-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace the custom irq handler that masks the irq and calls do_IRQ(), and
the unmasking in the individual handlers, by handle_level_irq().

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Sam Creasey <sammy@sammy.net>
---
v4: Added this changeset
---
 arch/m68k/Kconfig.mmu     |    2 --
 arch/m68k/sun3/sun3ints.c |   16 ++++++++++++++--
 2 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/arch/m68k/Kconfig.mmu b/arch/m68k/Kconfig.mmu
index b5e331f..fa98287 100644
--- a/arch/m68k/Kconfig.mmu
+++ b/arch/m68k/Kconfig.mmu
@@ -200,9 +200,7 @@ config SUN3
 
 config USE_GENERIC_HARDIRQS
 	bool "Use genirq"
-	depends on !SUN3X
 	depends on !Q40
-	depends on !SUN3
 	select HAVE_GENERIC_HARDIRQS
 	select GENERIC_IRQ_SHOW
 
diff --git a/arch/m68k/sun3/sun3ints.c b/arch/m68k/sun3/sun3ints.c
index 1273eb8..626b601 100644
--- a/arch/m68k/sun3/sun3ints.c
+++ b/arch/m68k/sun3/sun3ints.c
@@ -53,7 +53,9 @@ static irqreturn_t sun3_int7(int irq, void *dev_id)
 {
 	unsigned int cnt;
 
+#ifndef CONFIG_GENERIC_HARDIRQS
 	*sun3_intreg |=  (1 << irq);
+#endif
 	cnt = kstat_irqs_cpu(irq, 0);
 	if (!(cnt % 2000))
 		sun3_leds(led_pattern[cnt % 16000 / 2000]);
@@ -67,7 +69,9 @@ static irqreturn_t sun3_int5(int irq, void *dev_id)
 #ifdef CONFIG_SUN3
 	intersil_clear();
 #endif
+#ifndef CONFIG_GENERIC_HARDIRQS
         *sun3_intreg |=  (1 << irq);
+#endif
 #ifdef CONFIG_SUN3
 	intersil_clear();
 #endif
@@ -85,12 +89,14 @@ static irqreturn_t sun3_vec255(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
+#ifndef CONFIG_GENERIC_HARDIRQS
 static void sun3_inthandle(unsigned int irq, struct pt_regs *fp)
 {
         *sun3_intreg &= ~(1 << irq);
 
 	do_IRQ(irq, fp);
 }
+#endif
 
 static void sun3_irq_enable(struct irq_data *data)
 {
@@ -108,15 +114,21 @@ static struct irq_chip sun3_irq_chip = {
 	.irq_shutdown	= m68k_irq_shutdown,
 	.irq_enable	= sun3_irq_enable,
 	.irq_disable	= sun3_irq_disable,
+#ifdef CONFIG_GENERIC_HARDIRQS
+	.irq_mask	= sun3_irq_disable,
+	.irq_unmask	= sun3_irq_enable,
+#endif
 };
 
 void __init sun3_init_IRQ(void)
 {
 	*sun3_intreg = 1;
 
+#ifndef CONFIG_GENERIC_HARDIRQS
 	m68k_setup_auto_interrupt(sun3_inthandle);
-	m68k_setup_irq_controller(&sun3_irq_chip, handle_simple_irq,
-				  IRQ_AUTO_1, 7);
+#endif
+	m68k_setup_irq_controller(&sun3_irq_chip, handle_level_irq, IRQ_AUTO_1,
+				  7);
 	m68k_setup_user_interrupt(VEC_USER, 128, NULL);
 
 	if (request_irq(IRQ_AUTO_5, sun3_int5, 0, "int5", NULL))
-- 
1.7.0.4

