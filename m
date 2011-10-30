Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934030Ab1J3Mw3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Oct 2011 08:52:29 -0400
Received: from georges.telenet-ops.be ([195.130.137.68]:43225 "EHLO
	georges.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934007Ab1J3Mst (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Oct 2011 08:48:49 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-m68k@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Greg Ungerer <gerg@uclinux.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Peter De Schrijver <p2@debian.org>
Subject: [PATCH 21/27] m68k/apollo: Convert Apollo to genirq
Date: Sun, 30 Oct 2011 13:48:29 +0100
Message-Id: <1319978915-10933-22-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1319978915-10933-1-git-send-email-geert@linux-m68k.org>
References: <1319978915-10933-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace the custom user vector interrupt handler that calls do_IRQ() and
does an EOI by handle_fasteoi_irq().

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Peter De Schrijver <p2@debian.org>
---
 arch/m68k/Kconfig          |    1 -
 arch/m68k/apollo/dn_ints.c |   25 +++++++++++++++++++++++--
 2 files changed, 23 insertions(+), 3 deletions(-)

diff --git a/arch/m68k/Kconfig b/arch/m68k/Kconfig
index 8ae37a8..f2dc708 100644
--- a/arch/m68k/Kconfig
+++ b/arch/m68k/Kconfig
@@ -87,7 +87,6 @@ config MMU_SUN3
 config USE_GENERIC_HARDIRQS
 	bool "Use genirq"
 	depends on MMU
-	depends on !APOLLO
 	depends on !SUN3X
 	depends on !Q40
 	depends on !SUN3
diff --git a/arch/m68k/apollo/dn_ints.c b/arch/m68k/apollo/dn_ints.c
index 4b76431..fc190b3 100644
--- a/arch/m68k/apollo/dn_ints.c
+++ b/arch/m68k/apollo/dn_ints.c
@@ -1,9 +1,14 @@
 #include <linux/interrupt.h>
-
+#ifdef CONFIG_GENERIC_HARDIRQS
+#include <linux/irq.h>
+#else
 #include <asm/irq.h>
+#endif
+
 #include <asm/traps.h>
 #include <asm/apollohw.h>
 
+#ifndef CONFIG_GENERIC_HARDIRQS
 void dn_process_int(unsigned int irq, struct pt_regs *fp)
 {
 	do_IRQ(irq, fp);
@@ -11,6 +16,7 @@ void dn_process_int(unsigned int irq, struct pt_regs *fp)
 	*(volatile unsigned char *)(pica)=0x20;
 	*(volatile unsigned char *)(picb)=0x20;
 }
+#endif
 
 unsigned int apollo_irq_startup(struct irq_data *data)
 {
@@ -33,16 +39,31 @@ void apollo_irq_shutdown(struct irq_data *data)
 		*(volatile unsigned char *)(picb+1) |= (1 << (irq - 8));
 }
 
+#ifdef CONFIG_GENERIC_HARDIRQS
+void apollo_irq_eoi(struct irq_data *data)
+{
+	*(volatile unsigned char *)(pica) = 0x20;
+	*(volatile unsigned char *)(picb) = 0x20;
+}
+#endif
+
 static struct irq_chip apollo_irq_chip = {
 	.name           = "apollo",
 	.irq_startup    = apollo_irq_startup,
 	.irq_shutdown   = apollo_irq_shutdown,
+#ifdef CONFIG_GENERIC_HARDIRQS
+	.irq_eoi	= apollo_irq_eoi,
+#endif
 };
 
 
 void __init dn_init_IRQ(void)
 {
+#ifdef CONFIG_GENERIC_HARDIRQS
+	m68k_setup_user_interrupt(VEC_USER + 96, 16, NULL);
+#else
 	m68k_setup_user_interrupt(VEC_USER + 96, 16, dn_process_int);
-	m68k_setup_irq_controller(&apollo_irq_chip, handle_simple_irq,
+#endif
+	m68k_setup_irq_controller(&apollo_irq_chip, handle_fasteoi_irq,
 				  IRQ_APOLLO, 16);
 }
-- 
1.7.0.4

