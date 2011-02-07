Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753705Ab1BGUlm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 15:41:42 -0500
Received: from www.tglx.de ([62.245.132.106]:38481 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753133Ab1BGUll (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 15:41:41 -0500
Date: Mon, 7 Feb 2011 21:41:30 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Matthew Garrett <mjg59@srcf.ucam.org>
cc: LKML <linux-kernel@vger.kernel.org>, Feng Tang <feng.tang@intel.com>,
        Alan Cox <alan@linux.intel.com>, Alek Du <alek.du@intel.com>
Subject: Re: [patch 0/3] platform-drivers: x86: Cleanup pmic gpio interrupt
In-Reply-To: <20110207201730.GA21520@srcf.ucam.org>
Message-ID: <alpine.LFD.2.00.1102072120240.31804@localhost6.localdomain6>
References: <20110205104025.559237313@linutronix.de> <20110207201730.GA21520@srcf.ucam.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Feb 2011, Matthew Garrett wrote:

> Applied, thanks.

Btw, there is no real reason to have this as a chained handler. I
guess I need to find some time for educational documentation :)

See below.

Thanks,

	tglx

------->
Subject: platform-drivers: x86: pmic: Use request_irq instead of chained handler
From: Thomas Gleixner <tglx@linutronix.de>
Date: Mon, 07 Feb 2011 21:24:29 +0100

There is no need to install a chained handler for this hardware. This
is a plain x86 IOAPIC interrupt which is handled by the core code
perfectly fine. There is nothing special about demultiplexing these
gpio interrupts which justifies a custom hack. Replace it by a plain
old interrupt handler installed with request_irq. That makes the code
agnostic about the underlying primary interrupt hardware. The overhead
for this is minimal, but it gives us the advantage of accounting,
balancing and to detect interrupt storms. gpio interrupts are not
really that performance critical.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 drivers/platform/x86/intel_pmic_gpio.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

Index: linux-2.6/drivers/platform/x86/intel_pmic_gpio.c
===================================================================
--- linux-2.6.orig/drivers/platform/x86/intel_pmic_gpio.c
+++ linux-2.6/drivers/platform/x86/intel_pmic_gpio.c
@@ -211,9 +211,9 @@ static struct irq_chip pmic_irqchip = {
 	.irq_set_type	= pmic_irq_type,
 };
 
-static void pmic_irq_handler(unsigned irq, struct irq_desc *desc)
+static irqreturn_t pmic_irq_handler(unsigned int irq, void *data)
 {
-	struct pmic_gpio *pg = (struct pmic_gpio *)get_irq_data(irq);
+	struct pmic_gpio *pg = data;
 	u8 intsts = *((u8 *)pg->gpiointr + 4);
 	int gpio;
 
@@ -223,7 +223,6 @@ static void pmic_irq_handler(unsigned ir
 			generic_handle_irq(pg->irq_base + gpio);
 		}
 	}
-	desc->chip->irq_eoi(get_irq_desc_chip_data(desc));
 }
 
 static int __devinit platform_pmic_gpio_probe(struct platform_device *pdev)
@@ -280,8 +279,13 @@ static int __devinit platform_pmic_gpio_
 		printk(KERN_ERR "%s: Can not add pmic gpio chip.\n", __func__);
 		goto err;
 	}
-	set_irq_data(pg->irq, pg);
-	set_irq_chained_handler(pg->irq, pmic_irq_handler);
+
+	retval = request_irq(pg->irq, pmic_irq_handler, 0, "pmic", pg);
+	if (retval) {
+		printk(KERN_WARN "pmic: Interrupt request failed\n");
+		goto err;
+	}
+
 	for (i = 0; i < 8; i++) {
 		set_irq_chip_and_handler_name(i + pg->irq_base, &pmic_irqchip,
 					handle_simple_irq, "demux");
