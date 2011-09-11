Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760208Ab1IKMBy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Sep 2011 08:01:54 -0400
Received: from brigitte.telenet-ops.be ([195.130.137.66]:42720 "EHLO
	brigitte.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760125Ab1IKMAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Sep 2011 08:00:04 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-m68k@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>,
        Peter De Schrijver <p2@debian.org>
Subject: [PATCH 23/28] m68k/apollo: Convert Apollo to genirq
Date: Sun, 11 Sep 2011 13:59:49 +0200
Message-Id: <1315742394-16036-24-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1315742394-16036-1-git-send-email-geert@linux-m68k.org>
References: <1315742394-16036-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace the custom user vector interrupt handler that calls do_IRQ() and
does an EOI by handle_fasteoi_irq().

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Peter De Schrijver <p2@debian.org>
---
v4: Added this changeset
---
 arch/m68k/Kconfig.mmu      |    1 -
 arch/m68k/apollo/dn_ints.c |   25 +++++++++++++++++++++++--
 2 files changed, 23 insertions(+), 3 deletions(-)

diff --git a/arch/m68k/Kconfig.mmu b/arch/m68k/Kconfig.mmu
index 258d92b..b5e331f 100644
--- a/arch/m68k/Kconfig.mmu
+++ b/arch/m68k/Kconfig.mmu
@@ -200,7 +200,6 @@ config SUN3
 
 config USE_GENERIC_HARDIRQS
 	bool "Use genirq"
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

