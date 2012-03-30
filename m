Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966403Ab2C3VkV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 17:40:21 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:59657 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936184Ab2C3Vbw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:31:52 -0400
X-Sasl-enc: 9czm86F4SaUrLkNJ+s0BAgo/trdzkpxzOXHI+DuR7B7C 1333143111
X-Mailbox-Line: From gregkh@linuxfoundation.org Fri Mar 30 12:48:55 2012
Message-Id: <20120330194855.469020132@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 30 Mar 2012 12:50:50 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Jon Povey <Jon.Povey@racelogic.co.uk>,
        Sekhar Nori <nsekhar@ti.com>, Grant Likely <grant.likely@secretlab.ca>
Subject: [ 145/175] gpio/davinci: fix enabling unbanked GPIO IRQs
In-Reply-To: <20120330195801.GA31806@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sekhar Nori <nsekhar@ti.com>

commit 81b279d80a63628e580c71a31d30a8c3b3047ad4 upstream.

Unbanked GPIO IRQ handling code made a copy of just
the irq_chip structure for GPIO IRQ lines which caused
problems after the generic IRQ chip conversion because
there was no valid irq_chip_type structure with the
right "regs" populated. irq_gc_mask_set_bit() was
therefore accessing random addresses.

Fix it by making a copy of irq_chip_type structure
instead. This will ensure sane register offsets.

Reported-by: Jon Povey <Jon.Povey@racelogic.co.uk>
Tested-by: Jon Povey <Jon.Povey@racelogic.co.uk>
Signed-off-by: Sekhar Nori <nsekhar@ti.com>
Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpio/gpio-davinci.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/drivers/gpio/gpio-davinci.c
+++ b/drivers/gpio/gpio-davinci.c
@@ -386,7 +386,7 @@ static int __init davinci_gpio_irq_setup
 	 * IRQ mux conflicts; gpio_irq_type_unbanked() is only for GPIOs.
 	 */
 	if (soc_info->gpio_unbanked) {
-		static struct irq_chip gpio_irqchip_unbanked;
+		static struct irq_chip_type gpio_unbanked;
 
 		/* pass "bank 0" GPIO IRQs to AINTC */
 		chips[0].chip.to_irq = gpio_to_irq_unbanked;
@@ -394,9 +394,10 @@ static int __init davinci_gpio_irq_setup
 
 		/* AINTC handles mask/unmask; GPIO handles triggering */
 		irq = bank_irq;
-		gpio_irqchip_unbanked = *irq_get_chip(irq);
-		gpio_irqchip_unbanked.name = "GPIO-AINTC";
-		gpio_irqchip_unbanked.irq_set_type = gpio_irq_type_unbanked;
+		gpio_unbanked = *container_of(irq_get_chip(irq),
+					      struct irq_chip_type, chip);
+		gpio_unbanked.chip.name = "GPIO-AINTC";
+		gpio_unbanked.chip.irq_set_type = gpio_irq_type_unbanked;
 
 		/* default trigger: both edges */
 		g = gpio2regs(0);
@@ -405,7 +406,7 @@ static int __init davinci_gpio_irq_setup
 
 		/* set the direct IRQs up to use that irqchip */
 		for (gpio = 0; gpio < soc_info->gpio_unbanked; gpio++, irq++) {
-			irq_set_chip(irq, &gpio_irqchip_unbanked);
+			irq_set_chip(irq, &gpio_unbanked.chip);
 			irq_set_handler_data(irq, &chips[gpio / 32]);
 			irq_set_status_flags(irq, IRQ_TYPE_EDGE_BOTH);
 		}


