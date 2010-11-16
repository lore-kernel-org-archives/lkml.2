Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759498Ab0KPICh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 03:02:37 -0500
Received: from mail.sysgo.com ([195.145.229.155]:38985 "EHLO mail.sysgo.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759476Ab0KPICg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 03:02:36 -0500
Date: Tue, 16 Nov 2010 09:03:11 +0100
From: Pavel Machek <pma@sysgo.com>
To: kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        eric.y.miao@gmail.com, cko@sysgo.com
Subject: 19851c58e68 breaks spacecom1 board
Message-ID: <20101116080311.GA17397@pma.sysgo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

I'm working here with spacecom1 board... you probably do not want to
know about. Unfortunately, the board does not work with 2.6.34, and I
believe identified the offending patch...

commit 19851c58e680f71d087b79b53edbf814193e1d33
Author: Eric Miao <eric.y.miao@gmail.com>
Date:   Sat Dec 26 16:23:02 2009 +0800

    [ARM] sa1111: allow cascaded IRQs to be used by platforms
    
    Signed-off-by: Eric Miao <eric.y.miao@gmail.com>

Now, what happens is this:

--- a/arch/arm/common/sa1111.c
+++ b/arch/arm/common/sa1111.c
@@ -35,6 +35,58 @@
 
 #include <asm/hardware/sa1111.h>
 
+/* SA1111 IRQs */
+#define IRQ_GPAIN0             (0)

....
--- a/arch/arm/mach-pxa/include/mach/irqs.h
+++ b/arch/arm/mach-pxa/include/mach/irqs.h
@@ -135,58 +135,6 @@
 #define IRQ_BOARD_END          (IRQ_BOARD_START + 16)
 #endif
 
-#define IRQ_SA1111_START       (IRQ_BOARD_END)
-#define IRQ_GPAIN0             (IRQ_BOARD_END + 0)
...

So, in 2.6.34, irq_base needs to be added to IRQ_GPAIN0 and
similar. Unfortunately, it is not added at least in some users,
registering sa1111 interrupts over those at zero, breaking everything.

I have to do something like this to get my board back to boot.

Signed-off-by: Pavel Machek <pma@sysgo.com>

(but you probably don't want to apply the patch just like that).

diff --git a/arch/arm/common/sa1111.c b/arch/arm/common/sa1111.c
index f81543a..f1c0552 100644
--- a/arch/arm/common/sa1111.c
+++ b/arch/arm/common/sa1111.c
@@ -448,9 +448,9 @@ static struct irq_chip sa1111_high_chip = {
 static void sa1111_setup_irq(struct sa1111 *sachip)
 {
 	void __iomem *irqbase = sachip->base + SA1111_INTC;
+	int irq_base = sachip->irq_base; 
 	unsigned int irq;
 
-#if 0
 	/*
 	 * We're guaranteed that this region hasn't been taken.
 	 */
@@ -476,26 +476,28 @@ static void sa1111_setup_irq(struct sa1111 *sachip)
 	sa1111_writel(~0, irqbase + SA1111_INTSTATCLR1);
 
 	for (irq = IRQ_GPAIN0; irq <= SSPROR; irq++) {
-		set_irq_chip(irq, &sa1111_low_chip);
-		set_irq_chip_data(irq, sachip);
-		set_irq_handler(irq, handle_edge_irq);
-		set_irq_flags(irq, IRQF_VALID | IRQF_PROBE);
+		printk("Setting up irq %d (irq_base %d)\n", irq, sachip->irq_base);
+		set_irq_chip(irq + irq_base, &sa1111_low_chip);
+		set_irq_chip_data(irq + irq_base, sachip);
+		set_irq_handler(irq + irq_base, handle_edge_irq);
+		set_irq_flags(irq + irq_base, IRQF_VALID | IRQF_PROBE);
 	}
 
 	for (irq = AUDXMTDMADONEA; irq <= IRQ_S1_BVD1_STSCHG; irq++) {
-		set_irq_chip(irq, &sa1111_high_chip);
-		set_irq_chip_data(irq, sachip);
-		set_irq_handler(irq, handle_edge_irq);
-		set_irq_flags(irq, IRQF_VALID | IRQF_PROBE);
+		set_irq_chip(irq + irq_base, &sa1111_high_chip);
+		set_irq_chip_data(irq + irq_base, sachip);
+		set_irq_handler(irq + irq_base, handle_edge_irq);
+		set_irq_flags(irq + irq_base, IRQF_VALID | IRQF_PROBE);
 	}
 
+	printk("Registering sa1111 irq: %d\n", sachip->irq);
+
 	/*
 	 * Register SA1111 interrupt
 	 */
 	set_irq_type(sachip->irq, IRQ_TYPE_EDGE_RISING);
 	set_irq_data(sachip->irq, sachip);
 	set_irq_chained_handler(sachip->irq, sa1111_irq_handler);
-#endif
 }
 
 /*
@@ -708,6 +710,7 @@ __sa1111_probe(struct device *me, struct resource *mem, int irq)
 
 	sachip->phys = mem->start;
 	sachip->irq = irq;
+	sachip->irq_base = IRQ_BOARD_END;
 
 	/*
 	 * Map the whole region.  This also maps the



