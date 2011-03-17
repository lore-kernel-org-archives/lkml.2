Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755476Ab1CQTdP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 15:33:15 -0400
Received: from www.tglx.de ([62.245.132.106]:44819 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755437Ab1CQTdM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 15:33:12 -0400
Message-Id: <20110317192449.845775901@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 17 Mar 2011 19:32:58 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Grant Likely <grant.likely@secretlab.ca>, Feng Tang <feng.tang@intel.com>,
        Alek Du <alek.du@intel.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [patch 5/5] [RFC] gpio: langwell: Clear edge bit before handling
References: <20110317192247.722047296@linutronix.de>
Content-Disposition: inline;
	filename=gpio-langwell-clear-edge-bit-before-handler.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I don't have the specs for this beast, but it looks a lot like the PXA
GPIO block. Though I bet it's the same IP and the driver should have
reused the PXA code.

Acknowleding the edge detect status after handling one or more gpio
interrupts looks wrong. We might lose an edge which came in while we
handled the previous one.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Feng Tang <feng.tang@intel.com>
Cc: Alek Du <alek.du@intel.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>

---
 drivers/gpio/langwell_gpio.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

Index: linux-2.6-tip/drivers/gpio/langwell_gpio.c
===================================================================
--- linux-2.6-tip.orig/drivers/gpio/langwell_gpio.c
+++ linux-2.6-tip/drivers/gpio/langwell_gpio.c
@@ -190,23 +190,22 @@ static void lnw_irq_handler(unsigned irq
 	struct irq_data *data = irq_desc_get_irq_data(desc);
 	struct lnw_gpio *lnw = irq_data_get_irq_handler_data(data);
 	struct irq_chip *chip = irq_data_get_irq_chip(data);
-	u32 base, gpio, gedr_v;
+	u32 base, gpio, mask;
 	unsigned long pending;
 	void __iomem *gedr;
 
 	/* check GPIO controller to check which pin triggered the interrupt */
 	for (base = 0; base < lnw->chip.ngpio; base += 32) {
 		gedr = gpio_reg(&lnw->chip, base, GEDR);
-		gedr_v = pending = readl(gedr);
-		if (!gedr_v)
-			continue;
+		pending = readl(gedr);
 		while (pending) {
 			gpio = __ffs(pending) - 1;
-			pending &= ~BIT(gpio);
+			mask = BIT(gpio);
+			pending &= ~mask;
+			/* Clear before handling so we can't lose an edge */
+			writel(mask, gedr);
 			generic_handle_irq(lnw->irq_base + base + gpio);
 		}
-		/* clear the edge detect status bit */
-		writel(gedr_v, gedr);
 	}
 
 	chip->irq_eoi(data);


