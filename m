Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755459Ab1CQTdM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 15:33:12 -0400
Received: from www.tglx.de ([62.245.132.106]:44817 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754065Ab1CQTdK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 15:33:10 -0400
Message-Id: <20110317192449.744944033@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 17 Mar 2011 19:32:55 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Grant Likely <grant.likely@secretlab.ca>, Feng Tang <feng.tang@intel.com>,
        Alek Du <alek.du@intel.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [patch 4/5] gpio: langwell: Simplify demux loop
References: <20110317192247.722047296@linutronix.de>
Content-Disposition: inline; filename=gpio-langwell-simplify-loop.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use __ffs() to find the pending interrupt source instead of looping 32
times.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Feng Tang <feng.tang@intel.com>
Cc: Alek Du <alek.du@intel.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>

---
 drivers/gpio/langwell_gpio.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

Index: linux-2.6-tip/drivers/gpio/langwell_gpio.c
===================================================================
--- linux-2.6-tip.orig/drivers/gpio/langwell_gpio.c
+++ linux-2.6-tip/drivers/gpio/langwell_gpio.c
@@ -191,19 +191,20 @@ static void lnw_irq_handler(unsigned irq
 	struct lnw_gpio *lnw = irq_data_get_irq_handler_data(data);
 	struct irq_chip *chip = irq_data_get_irq_chip(data);
 	u32 base, gpio, gedr_v;
+	unsigned long pending;
 	void __iomem *gedr;
 
 	/* check GPIO controller to check which pin triggered the interrupt */
 	for (base = 0; base < lnw->chip.ngpio; base += 32) {
 		gedr = gpio_reg(&lnw->chip, base, GEDR);
-		gedr_v = readl(gedr);
+		gedr_v = pending = readl(gedr);
 		if (!gedr_v)
 			continue;
-		for (gpio = base; gpio < base + 32; gpio++)
-			if (gedr_v & BIT(gpio % 32)) {
-				pr_debug("pin %d triggered\n", gpio);
-				generic_handle_irq(lnw->irq_base + gpio);
-			}
+		while (pending) {
+			gpio = __ffs(pending) - 1;
+			pending &= ~BIT(gpio);
+			generic_handle_irq(lnw->irq_base + base + gpio);
+		}
 		/* clear the edge detect status bit */
 		writel(gedr_v, gedr);
 	}


