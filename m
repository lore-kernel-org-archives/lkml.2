Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753931Ab0KSMxY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 07:53:24 -0500
Received: from mail.sysgo.com ([195.145.229.155]:56589 "EHLO mail.sysgo.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753493Ab0KSMxX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 07:53:23 -0500
Date: Fri, 19 Nov 2010 13:54:05 +0100
From: Pavel Machek <pma@sysgo.com>
To: kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        eric.y.miao@gmail.com, cko@sysgo.com
Cc: pfilipek@jpembedded.eu
Subject: Re: 19851c58e68 breaks spacecom1 board
Message-ID: <20101119125405.GA29158@pma.sysgo.com>
References: <20101116080311.GA17397@pma.sysgo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101116080311.GA17397@pma.sysgo.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Fix up interrupt numbers on SA1111 companion chip.

Signed-off-by: Pavel Machek <pavel@ucw.cz>

---

This seems to fix the interrupt issue for me... USB now gets some
interrupts. But some SA1111 expert should take a look at this.

diff --git a/arch/arm/common/sa1111.c b/arch/arm/common/sa1111.c
index a52a27c..e47a474 100644
--- a/arch/arm/common/sa1111.c
+++ b/arch/arm/common/sa1111.c
@@ -448,6 +454,7 @@ static struct irq_chip sa1111_high_chip = {
 static void sa1111_setup_irq(struct sa1111 *sachip)
 {
 	void __iomem *irqbase = sachip->base + SA1111_INTC;
+	int irq_base = sachip->irq_base; 
 	unsigned int irq;
 
 	/*
@@ -475,19 +482,19 @@ static void sa1111_setup_irq(struct sa1111 *sachip)
 	sa1111_writel(~0, irqbase + SA1111_INTSTATCLR1);
 
 	for (irq = IRQ_GPAIN0; irq <= SSPROR; irq++) {
-		set_irq_chip(irq, &sa1111_low_chip);
-		set_irq_chip_data(irq, sachip);
-		set_irq_handler(irq, handle_edge_irq);
-		set_irq_flags(irq, IRQF_VALID | IRQF_PROBE);
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
 
 	/*
 	 * Register SA1111 interrupt
 	 */
@@ -782,6 +839,15 @@ __sa1111_probe(struct device *me, struct resource *mem, int irq)
 	else
 		has_devs &= ~(1 << 1);
 
+	for (i = 0; i < ARRAY_SIZE(sa1111_devices); i++) {
+		int j;
+		for (j = 0; j < 6; j++)			
+			if (sa1111_devices[i].irq[j]) {
+				sa1111_devices[i].irq[j] += sachip->irq_base;
+				printk("Adjusting interrupt %d\n", sa1111_devices[i].irq[j]);
+			}
+	}
+
 	for (i = 0; i < ARRAY_SIZE(sa1111_devices); i++)
 		if (has_devs & (1 << i))
 			sa1111_init_one_child(sachip, mem, &sa1111_devices[i]);
@@ -853,8 +919,13 @@ int dma_needs_bounce(struct device *dev, dma_addr_t addr, size_t size)
 	 * SDRAM bank 1 on Neponset). The default configuration selects
 	 * Assabet, so any address in bank 1 is necessarily invalid.
 	 */
+#ifdef CONFIG_MACH_SPACECOM1
+	return ((machine_is_spacecom1()) &&
+		(addr >= 0xa0100000 || (addr + size) >= 0xa0100000));
+#else
 	return ((machine_is_assabet() || machine_is_pfs168()) &&
 		(addr >= 0xc8000000 || (addr + size) >= 0xc8000000));
+#endif
 }
 
 struct sa1111_save_data {
