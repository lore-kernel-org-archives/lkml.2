Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933057Ab1IKMEN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Sep 2011 08:04:13 -0400
Received: from brigitte.telenet-ops.be ([195.130.137.66]:42707 "EHLO
	brigitte.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760115Ab1IKMAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Sep 2011 08:00:04 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-m68k@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 18/28] m68k/amiga: Optimize interrupts using chain handlers
Date: Sun, 11 Sep 2011 13:59:44 +0200
Message-Id: <1315742394-16036-19-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1315742394-16036-1-git-send-email-geert@linux-m68k.org>
References: <1315742394-16036-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
v3: Use handle_simple_irq() instead of handle_level_irq()
    Small updates for rename of m68k_handle_int() to generic_handle_irq()

v2: Added this changeset
---
 arch/m68k/amiga/amiints.c |  104 +++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 104 insertions(+), 0 deletions(-)

diff --git a/arch/m68k/amiga/amiints.c b/arch/m68k/amiga/amiints.c
index c3da534..a8da471 100644
--- a/arch/m68k/amiga/amiints.c
+++ b/arch/m68k/amiga/amiints.c
@@ -48,6 +48,99 @@ static struct irq_chip amiga_irq_chip = {
  * The builtin Amiga hardware interrupt handlers.
  */
 
+#ifdef CONFIG_GENERIC_HARDIRQS
+static void ami_int1(unsigned int irq, struct irq_desc *desc)
+{
+	unsigned short ints = amiga_custom.intreqr & amiga_custom.intenar;
+
+	/* if serial transmit buffer empty, interrupt */
+	if (ints & IF_TBE) {
+		amiga_custom.intreq = IF_TBE;
+		generic_handle_irq(IRQ_AMIGA_TBE);
+	}
+
+	/* if floppy disk transfer complete, interrupt */
+	if (ints & IF_DSKBLK) {
+		amiga_custom.intreq = IF_DSKBLK;
+		generic_handle_irq(IRQ_AMIGA_DSKBLK);
+	}
+
+	/* if software interrupt set, interrupt */
+	if (ints & IF_SOFT) {
+		amiga_custom.intreq = IF_SOFT;
+		generic_handle_irq(IRQ_AMIGA_SOFT);
+	}
+}
+
+static void ami_int3(unsigned int irq, struct irq_desc *desc)
+{
+	unsigned short ints = amiga_custom.intreqr & amiga_custom.intenar;
+
+	/* if a blitter interrupt */
+	if (ints & IF_BLIT) {
+		amiga_custom.intreq = IF_BLIT;
+		generic_handle_irq(IRQ_AMIGA_BLIT);
+	}
+
+	/* if a copper interrupt */
+	if (ints & IF_COPER) {
+		amiga_custom.intreq = IF_COPER;
+		generic_handle_irq(IRQ_AMIGA_COPPER);
+	}
+
+	/* if a vertical blank interrupt */
+	if (ints & IF_VERTB) {
+		amiga_custom.intreq = IF_VERTB;
+		generic_handle_irq(IRQ_AMIGA_VERTB);
+	}
+}
+
+static void ami_int4(unsigned int irq, struct irq_desc *desc)
+{
+	unsigned short ints = amiga_custom.intreqr & amiga_custom.intenar;
+
+	/* if audio 0 interrupt */
+	if (ints & IF_AUD0) {
+		amiga_custom.intreq = IF_AUD0;
+		generic_handle_irq(IRQ_AMIGA_AUD0);
+	}
+
+	/* if audio 1 interrupt */
+	if (ints & IF_AUD1) {
+		amiga_custom.intreq = IF_AUD1;
+		generic_handle_irq(IRQ_AMIGA_AUD1);
+	}
+
+	/* if audio 2 interrupt */
+	if (ints & IF_AUD2) {
+		amiga_custom.intreq = IF_AUD2;
+		generic_handle_irq(IRQ_AMIGA_AUD2);
+	}
+
+	/* if audio 3 interrupt */
+	if (ints & IF_AUD3) {
+		amiga_custom.intreq = IF_AUD3;
+		generic_handle_irq(IRQ_AMIGA_AUD3);
+	}
+}
+
+static void ami_int5(unsigned int irq, struct irq_desc *desc)
+{
+	unsigned short ints = amiga_custom.intreqr & amiga_custom.intenar;
+
+	/* if serial receive buffer full interrupt */
+	if (ints & IF_RBF) {
+		/* acknowledge of IF_RBF must be done by the serial interrupt */
+		generic_handle_irq(IRQ_AMIGA_RBF);
+	}
+
+	/* if a disk sync interrupt */
+	if (ints & IF_DSKSYN) {
+		amiga_custom.intreq = IF_DSKSYN;
+		generic_handle_irq(IRQ_AMIGA_DSKSYN);
+	}
+}
+#else /* !CONFIG_GENERIC_HARDIRQS */
 static irqreturn_t ami_int1(int irq, void *dev_id)
 {
 	unsigned short ints = amiga_custom.intreqr & amiga_custom.intenar;
@@ -143,6 +236,7 @@ static irqreturn_t ami_int5(int irq, void *dev_id)
 	}
 	return IRQ_HANDLED;
 }
+#endif /* !CONFIG_GENERIC_HARDIRQS */
 
 
 /*
@@ -158,6 +252,15 @@ static irqreturn_t ami_int5(int irq, void *dev_id)
 
 void __init amiga_init_IRQ(void)
 {
+#ifdef CONFIG_GENERIC_HARDIRQS
+	m68k_setup_irq_controller(&amiga_irq_chip, handle_simple_irq, IRQ_USER,
+				  AMI_STD_IRQS);
+
+	irq_set_chained_handler(IRQ_AUTO_1, ami_int1);
+	irq_set_chained_handler(IRQ_AUTO_3, ami_int3);
+	irq_set_chained_handler(IRQ_AUTO_4, ami_int4);
+	irq_set_chained_handler(IRQ_AUTO_5, ami_int5);
+#else /* !CONFIG_GENERIC_HARDIRQS */
 	if (request_irq(IRQ_AUTO_1, ami_int1, 0, "int1", NULL))
 		pr_err("Couldn't register int%d\n", 1);
 	if (request_irq(IRQ_AUTO_3, ami_int3, 0, "int3", NULL))
@@ -169,6 +272,7 @@ void __init amiga_init_IRQ(void)
 
 	m68k_setup_irq_controller(&amiga_irq_chip, handle_simple_irq, IRQ_USER,
 				  AMI_STD_IRQS);
+#endif /* !CONFIG_GENERIC_HARDIRQS */
 
 	/* turn off PCMCIA interrupts */
 	if (AMIGAHW_PRESENT(PCMCIA))
-- 
1.7.0.4

