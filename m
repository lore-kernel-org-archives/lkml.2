Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752532Ab1BEKqs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Feb 2011 05:46:48 -0500
Received: from www.tglx.de ([62.245.132.106]:32873 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751795Ab1BEKqr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Feb 2011 05:46:47 -0500
Message-Id: <20110205104221.145251327@linutronix.de>
User-Agent: quilt/0.48-1
Date: Sat, 05 Feb 2011 10:46:28 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Feng Tang <feng.tang@intel.com>, Matthew Garrett <mjg@redhat.com>,
        Alan Cox <alan@linux.intel.com>, Alek Du <alek.du@intel.com>
Subject: [patch 1/3] platform-drivers: x86: pmic: Fix up bogus irq hackery
References: <20110205104025.559237313@linutronix.de>
Content-Disposition: inline; filename=drivers-x86-remove-bogus-irq-hack.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 456dc301([PATCH] intel_pmic_gpio: modify EOI handling following
change of kernel irq subsystem) changes 

-	desc->chip->eoi(irq);
+
+	if (desc->chip->irq_eoi)
+		desc->chip->irq_eoi(irq_get_irq_data(irq));
+	else
+		dev_warn(pg->chip.dev, "missing EOI handler for irq %d\n", irq);

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

Remove the sillyness and retrieve the interrupt data from irq_desc
directly. No need to got through circles to look it up.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Feng Tang <feng.tang@intel.com>
Cc: Matthew Garrett <mjg@redhat.com>
Cc: Alan Cox <alan@linux.intel.com>
Cc: Alek Du <alek.du@intel.com>
---
 drivers/platform/x86/intel_pmic_gpio.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

Index: linux-2.6/drivers/platform/x86/intel_pmic_gpio.c
===================================================================
--- linux-2.6.orig/drivers/platform/x86/intel_pmic_gpio.c
+++ linux-2.6/drivers/platform/x86/intel_pmic_gpio.c
@@ -244,11 +244,7 @@ static void pmic_irq_handler(unsigned ir
 			generic_handle_irq(pg->irq_base + gpio);
 		}
 	}
-
-	if (desc->chip->irq_eoi)
-		desc->chip->irq_eoi(irq_get_irq_data(irq));
-	else
-		dev_warn(pg->chip.dev, "missing EOI handler for irq %d\n", irq);
+	desc->chip->irq_eoi(get_irq_desc_chip_data(desc));
 }
 
 static int __devinit platform_pmic_gpio_probe(struct platform_device *pdev)


