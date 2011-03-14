Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752546Ab1CNKqz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 06:46:55 -0400
Received: from fw.wantstofly.org ([80.101.37.227]:45195 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750964Ab1CNKqw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 06:46:52 -0400
Date: Mon, 14 Mar 2011 11:46:51 +0100
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org,
        linux-next@vger.kernel.org
Subject: [PATCH] langwell_gpio: fix CONFIG_GENERIC_HARDIRQS_NO_DEPRECATED build
Message-ID: <20110314104651.GZ16649@mail.wantstofly.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When CONFIG_GENERIC_HARDIRQS_NO_DEPRECATED is defined, struct irq_desc
no longer contains a ->chip member pointing to the corresponding struct
irq_chip, leading to the following build error:

	drivers/gpio/langwell_gpio.c: In function 'lnw_irq_handler':
	drivers/gpio/langwell_gpio.c:210: error: 'struct irq_desc' has no member named 'chip'
	drivers/gpio/langwell_gpio.c:211: error: 'struct irq_desc' has no member named 'chip'

Fix this up by using get_irq_desc_chip(desc) to get the irq_chip,
instead of trying to get it via desc->chip directly.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Lennert Buytenhek <buytenh@secretlab.ca>

diff --git a/drivers/gpio/langwell_gpio.c b/drivers/gpio/langwell_gpio.c
index 54d70a4..56eb66a 100644
--- a/drivers/gpio/langwell_gpio.c
+++ b/drivers/gpio/langwell_gpio.c
@@ -191,6 +191,7 @@ static void lnw_irq_handler(unsigned irq, struct irq_desc *desc)
 	u32 base, gpio;
 	void __iomem *gedr;
 	u32 gedr_v;
+	struct irq_chip *chip;
 
 	/* check GPIO controller to check which pin triggered the interrupt */
 	for (base = 0; base < lnw->chip.ngpio; base += 32) {
@@ -207,8 +208,9 @@ static void lnw_irq_handler(unsigned irq, struct irq_desc *desc)
 		writel(gedr_v, gedr);
 	}
 
-	if (desc->chip->irq_eoi)
-		desc->chip->irq_eoi(irq_get_irq_data(irq));
+	chip = get_irq_desc_chip(desc);
+	if (chip->irq_eoi)
+		chip->irq_eoi(irq_get_irq_data(irq));
 	else
 		dev_warn(lnw->chip.dev, "missing EOI handler for irq %d\n", irq);
 
---
