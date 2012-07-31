Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754148Ab2GaOL0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 10:11:26 -0400
Received: from slimlogic.co.uk ([89.16.172.20]:40474 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754070Ab2GaOLY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 10:11:24 -0400
Message-ID: <5017E789.4010701@slimlogic.co.uk>
Date: Tue, 31 Jul 2012 15:11:21 +0100
From: Graeme Gregory <gg@slimlogic.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mundt <lethal@linux-sh.org>
Subject: I2C dummy, regmap, irq domain issue
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have an interesting issue with the combination of i2c dummy devices,
regmap-irq and domains.

I have been adding device tree support to the palmas mfd driver.

The palmas device has 3 i2c addresses it responds to so it has one
normal i2c device and 2 dummy devices to claim the 2nd/3rd addresses
(this is pretty normal).

The registers for the IRQ handling on the chip happen to be in the 2nd
slave address. This means that when I am calling the regmap_add_irq_chip
call it is using a regmap based on the dummy i2c device.

regmap_add_irq_chip(palmas->regmap[slave], palmas->irq,
            IRQF_ONESHOT | IRQF_TRIGGER_LOW, -1, &palmas_irq_chip,
            &palmas->irq_data);

This works however when probing the child devices from the device tree
because I have used a dummy I2C device it fails to find the IRQ domain
created by regmap-irq.

of_platform_populate(node, NULL, NULL, &i2c->dev);

While debugging this issue I changed the regmap_add_irq_chip as per the
diff at end of the email. Is there a cleaner way to solve this within
the DT system?

Graeme

@@ -194,7 +194,7 @@ static struct irq_domain_ops regmap_domain_ops = {
  * register cache.  The chip driver is responsible for restoring the
  * register values used by the IRQ controller over suspend and resume.
  */
-int regmap_add_irq_chip(struct regmap *map, int irq, int irq_flags,
+int regmap_add_irq_chip(struct device *dev, struct regmap *map, int
irq, int irq_flags,
             int irq_base, struct regmap_irq_chip *chip,
             struct regmap_irq_chip_data **data)
 {
@@ -269,11 +269,11 @@ int regmap_add_irq_chip(struct regmap *map, int
irq, int irq_flags,
     }
 
     if (irq_base)
-        d->domain = irq_domain_add_legacy(map->dev->of_node,
+        d->domain = irq_domain_add_legacy(dev->of_node,
                           chip->num_irqs, irq_base, 0,
                           &regmap_domain_ops, d);
     else
-        d->domain = irq_domain_add_linear(map->dev->of_node,
+        d->domain = irq_domain_add_linear(dev->of_node,
                           chip->num_irqs,
                           &regmap_domain_ops, d);
     if (!d->domain) {


