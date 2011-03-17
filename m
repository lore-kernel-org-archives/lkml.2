Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755509Ab1CQTdh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 15:33:37 -0400
Received: from www.tglx.de ([62.245.132.106]:44837 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755359Ab1CQTdf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 15:33:35 -0400
Message-Id: <20110317192449.543350238@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 17 Mar 2011 19:32:49 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Grant Likely <grant.likely@secretlab.ca>, Feng Tang <feng.tang@intel.com>,
        Alek Du <alek.du@intel.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 2/5] gpio-langwell-fix-crap.patch
References: <20110317192247.722047296@linutronix.de>
Content-Disposition: inline; filename=gpio-langwell-fix-crap.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 0766d20fd (langwell_gpio: modify EOI handling following change
of kernel irq subsystem)  changes

 -   desc->chip->eoi(irq);
 +
 +   if (desc->chip->irq_eoi)
 +           desc->chip->irq_eoi(irq_get_irq_data(irq));
 +   else
 +           dev_warn(pg->chip.dev, "missing EOI handler for irq %d\n", irq);

With the following explanation:

 "Latest kernel has many changes in IRQ subsystem and its interfaces,
  like adding irq_eoi" for struct irq_chip, this patch will make it
  support both the new and old interface."

This is completely bogus.

 #1) The changelog does not match the patch at all

 #2) This driver relies on the assumption that it sits behind an eoi
     capable interrupt line. If the implementation of the underlying
     chip changes from eoi to irq_eoi then this driver has to follow
     that change and not add a total bogosity.

 #3) Just mechanically changing eoi to irq_eoi without checking the
     background of that change is sloppy at best.

Remove the sillyness and retrieve the interrupt data from irq_desc
directly. No need to go through a sparse irq lookup.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Feng Tang <feng.tang@intel.com>
Cc: Alek Du <alek.du@intel.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 drivers/gpio/langwell_gpio.c |   13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

Index: linux-2.6-tip/drivers/gpio/langwell_gpio.c
===================================================================
--- linux-2.6-tip.orig/drivers/gpio/langwell_gpio.c
+++ linux-2.6-tip/drivers/gpio/langwell_gpio.c
@@ -187,10 +187,11 @@ MODULE_DEVICE_TABLE(pci, lnw_gpio_ids);
 
 static void lnw_irq_handler(unsigned irq, struct irq_desc *desc)
 {
-	struct lnw_gpio *lnw = get_irq_data(irq);
-	u32 base, gpio;
+	struct irq_data *data = irq_desc_get_irq_data(desc);
+	struct lnw_gpio *lnw = irq_data_get_irq_handler_data(data);
+	struct irq_chip *chip = irq_data_get_irq_chip(data);
+	u32 base, gpio, gedr_v;
 	void __iomem *gedr;
-	u32 gedr_v;
 
 	/* check GPIO controller to check which pin triggered the interrupt */
 	for (base = 0; base < lnw->chip.ngpio; base += 32) {
@@ -207,11 +208,7 @@ static void lnw_irq_handler(unsigned irq
 		writel(gedr_v, gedr);
 	}
 
-	if (desc->chip->irq_eoi)
-		desc->chip->irq_eoi(irq_get_irq_data(irq));
-	else
-		dev_warn(lnw->chip.dev, "missing EOI handler for irq %d\n", irq);
-
+	chip->irq_eoi(data);
 }
 
 static int __devinit lnw_gpio_probe(struct pci_dev *pdev,


