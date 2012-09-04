Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757196Ab2IDOG1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 10:06:27 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:59926 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757178Ab2IDOGY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 10:06:24 -0400
Message-ID: <1346767579.3160.4.camel@phoenix>
Subject: [PATCH] gpio: sx150x: Use irq_data_get_irq_chip_data() at
 appropriate places
From: Axel Lin <axel.lin@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>
Cc: Gregory Bean <gbean@codeaurora.org>, linux-kernel@vger.kernel.org
Date: Tue, 04 Sep 2012 22:06:19 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/gpio/gpio-sx150x.c |   24 ++++++------------------
 1 file changed, 6 insertions(+), 18 deletions(-)

diff --git a/drivers/gpio/gpio-sx150x.c b/drivers/gpio/gpio-sx150x.c
index a4f7353..eb3e215 100644
--- a/drivers/gpio/gpio-sx150x.c
+++ b/drivers/gpio/gpio-sx150x.c
@@ -311,11 +311,9 @@ static int sx150x_gpio_to_irq(struct gpio_chip *gc, unsigned offset)
 
 static void sx150x_irq_mask(struct irq_data *d)
 {
-	struct irq_chip *ic = irq_data_get_irq_chip(d);
-	struct sx150x_chip *chip;
+	struct sx150x_chip *chip = irq_data_get_irq_chip_data(d);
 	unsigned n;
 
-	chip = container_of(ic, struct sx150x_chip, irq_chip);
 	n = d->irq - chip->irq_base;
 	chip->irq_masked |= (1 << n);
 	chip->irq_update = n;
@@ -323,27 +321,22 @@ static void sx150x_irq_mask(struct irq_data *d)
 
 static void sx150x_irq_unmask(struct irq_data *d)
 {
-	struct irq_chip *ic = irq_data_get_irq_chip(d);
-	struct sx150x_chip *chip;
+	struct sx150x_chip *chip = irq_data_get_irq_chip_data(d);
 	unsigned n;
 
-	chip = container_of(ic, struct sx150x_chip, irq_chip);
 	n = d->irq - chip->irq_base;
-
 	chip->irq_masked &= ~(1 << n);
 	chip->irq_update = n;
 }
 
 static int sx150x_irq_set_type(struct irq_data *d, unsigned int flow_type)
 {
-	struct irq_chip *ic = irq_data_get_irq_chip(d);
-	struct sx150x_chip *chip;
+	struct sx150x_chip *chip = irq_data_get_irq_chip_data(d);
 	unsigned n, val = 0;
 
 	if (flow_type & (IRQ_TYPE_LEVEL_HIGH | IRQ_TYPE_LEVEL_LOW))
 		return -EINVAL;
 
-	chip = container_of(ic, struct sx150x_chip, irq_chip);
 	n = d->irq - chip->irq_base;
 
 	if (flow_type & IRQ_TYPE_EDGE_RISING)
@@ -391,22 +384,16 @@ static irqreturn_t sx150x_irq_thread_fn(int irq, void *dev_id)
 
 static void sx150x_irq_bus_lock(struct irq_data *d)
 {
-	struct irq_chip *ic = irq_data_get_irq_chip(d);
-	struct sx150x_chip *chip;
-
-	chip = container_of(ic, struct sx150x_chip, irq_chip);
+	struct sx150x_chip *chip = irq_data_get_irq_chip_data(d);
 
 	mutex_lock(&chip->lock);
 }
 
 static void sx150x_irq_bus_sync_unlock(struct irq_data *d)
 {
-	struct irq_chip *ic = irq_data_get_irq_chip(d);
-	struct sx150x_chip *chip;
+	struct sx150x_chip *chip = irq_data_get_irq_chip_data(d);
 	unsigned n;
 
-	chip = container_of(ic, struct sx150x_chip, irq_chip);
-
 	if (chip->irq_update == NO_UPDATE_PENDING)
 		goto out;
 
@@ -551,6 +538,7 @@ static int sx150x_install_irq_chip(struct sx150x_chip *chip,
 
 	for (n = 0; n < chip->dev_cfg->ngpios; ++n) {
 		irq = irq_base + n;
+		irq_set_chip_data(irq, chip);
 		irq_set_chip_and_handler(irq, &chip->irq_chip, handle_edge_irq);
 		irq_set_nested_thread(irq, 1);
 #ifdef CONFIG_ARM
-- 
1.7.9.5



