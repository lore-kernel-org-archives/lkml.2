Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934126Ab1J3Mvi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Oct 2011 08:51:38 -0400
Received: from gerard.telenet-ops.be ([195.130.132.48]:36236 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933995Ab1J3Mst (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Oct 2011 08:48:49 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-m68k@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Greg Ungerer <gerg@uclinux.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Sam Creasey <sammy@sammy.net>
Subject: [PATCH 23/27] m68k/sun3: Convert Sun3/3x to genirq
Date: Sun, 30 Oct 2011 13:48:31 +0100
Message-Id: <1319978915-10933-24-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1319978915-10933-1-git-send-email-geert@linux-m68k.org>
References: <1319978915-10933-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace the custom irq handler that masks the irq and calls do_IRQ(), and
the unmasking in the individual handlers, by handle_level_irq().

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Sam Creasey <sammy@sammy.net>
---
 arch/m68k/Kconfig         |    2 --
 arch/m68k/sun3/sun3ints.c |   16 ++++++++++++++--
 2 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/arch/m68k/Kconfig b/arch/m68k/Kconfig
index f2dc708..290f9c8 100644
--- a/arch/m68k/Kconfig
+++ b/arch/m68k/Kconfig
@@ -87,9 +87,7 @@ config MMU_SUN3
 config USE_GENERIC_HARDIRQS
 	bool "Use genirq"
 	depends on MMU
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

