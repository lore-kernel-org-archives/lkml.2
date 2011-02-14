Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756095Ab1BNQth (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 11:49:37 -0500
Received: from www.tglx.de ([62.245.132.106]:35280 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755541Ab1BNQte (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 11:49:34 -0500
Message-Id: <20110214164634.510293676@linutronix.de>
User-Agent: quilt/0.48-1
Date: Mon, 14 Feb 2011 16:48:44 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Gregory Bean <gbean@codeaurora.org>, Jean Delvare <khali@linux-fr.org>,
        Lennert Buytenhek <buytenh@secretlab.ca>
Subject: [patch] drivers: gpio: sx150x: Do not access I2C from mask/unmask
	functions
Content-Disposition: inline; filename=drivers-gpio-sx150x.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

irq_chip->irq_mask/unmask are called with interrupts disabled and
irq_desc->lock held. So we cannot access i2c from this context. That's
what irq_bus_sync_unlock() is for.

Store the masked information in the chip data structure and update the
i2c bus from the irq_bus_sync_unlock() callback.

This does not need a while(pending) loop because the update to this is
always serialized via the bus lock, so we never have more than one pin
update pending.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Gregory Bean <gbean@codeaurora.org>
Cc: Jean Delvare <khali@linux-fr.org>
Cc: Lennert Buytenhek <buytenh@secretlab.ca>
---
 drivers/gpio/sx150x.c |   54 ++++++++++++++++++++++++++++++++++----------------
 1 file changed, 37 insertions(+), 17 deletions(-)

Index: linux-2.6-tip/drivers/gpio/sx150x.c
===================================================================
--- linux-2.6-tip.orig/drivers/gpio/sx150x.c
+++ linux-2.6-tip/drivers/gpio/sx150x.c
@@ -25,6 +25,8 @@
 #include <linux/workqueue.h>
 #include <linux/i2c/sx150x.h>
 
+#define NO_UPDATE_PENDING	-1
+
 struct sx150x_device_data {
 	u8 reg_pullup;
 	u8 reg_pulldn;
@@ -47,8 +49,11 @@ struct sx150x_chip {
 	const struct sx150x_device_data *dev_cfg;
 	int                              irq_summary;
 	int                              irq_base;
+	int				 irq_update;
 	u32                              irq_sense;
-	unsigned long                    irq_set_type_pending;
+	u32				 irq_masked;
+	u32				 dev_sense;
+	u32				 dev_masked;
 	struct irq_chip                  irq_chip;
 	struct mutex                     lock;
 };
@@ -312,9 +317,8 @@ static void sx150x_irq_mask(struct irq_d
 
 	chip = container_of(ic, struct sx150x_chip, irq_chip);
 	n = d->irq - chip->irq_base;
-
-	sx150x_write_cfg(chip, n, 1, chip->dev_cfg->reg_irq_mask, 1);
-	sx150x_write_cfg(chip, n, 2, chip->dev_cfg->reg_sense, 0);
+	chip->irq_masked |= (1 << n);
+	chip->irq_update = n;
 }
 
 static void sx150x_irq_unmask(struct irq_data *d)
@@ -326,9 +330,8 @@ static void sx150x_irq_unmask(struct irq
 	chip = container_of(ic, struct sx150x_chip, irq_chip);
 	n = d->irq - chip->irq_base;
 
-	sx150x_write_cfg(chip, n, 1, chip->dev_cfg->reg_irq_mask, 0);
-	sx150x_write_cfg(chip, n, 2, chip->dev_cfg->reg_sense,
-			 chip->irq_sense >> (n * 2));
+	chip->irq_masked &= ~(1 << n);
+	chip->irq_update = n;
 }
 
 static int sx150x_irq_set_type(struct irq_data *d, unsigned int flow_type)
@@ -350,7 +353,7 @@ static int sx150x_irq_set_type(struct ir
 
 	chip->irq_sense &= ~(3UL << (n * 2));
 	chip->irq_sense |= val << (n * 2);
-	chip->irq_set_type_pending |= BIT(n);
+	chip->update = n;
 	return 0;
 }
 
@@ -404,15 +407,29 @@ static void sx150x_irq_bus_sync_unlock(s
 
 	chip = container_of(ic, struct sx150x_chip, irq_chip);
 
-	while (chip->irq_set_type_pending) {
-		n = __ffs(chip->irq_set_type_pending);
-		chip->irq_set_type_pending &= ~BIT(n);
-		if (!(irq_to_desc(n + chip->irq_base)->status & IRQ_MASKED))
-			sx150x_write_cfg(chip, n, 2,
-					chip->dev_cfg->reg_sense,
-					chip->irq_sense >> (n * 2));
-	}
+	if (chip->irq_update == NO_UPDATE_PENDING)
+		goto out;
 
+	n = chip->irq_update;
+	chip->irq_update = NO_UPDATE_PENDING;
+
+	/* Avoid updates if nothing changed */
+	if (chip->dev_sense == chip->irq_sense &&
+	    chip->dev_sense == chip->irq_masked)
+		goto out;
+
+	chip->dev_sense = chip->irq_sense;
+	chip->dev_masked = chip->irq_masked;
+
+	if (irq_masked & (1 << n)) {
+		sx150x_write_cfg(chip, n, 1, chip->dev_cfg->reg_irq_mask, 1);
+		sx150x_write_cfg(chip, n, 2, chip->dev_cfg->reg_sense, 0);
+	} else {
+		sx150x_write_cfg(chip, n, 1, chip->dev_cfg->reg_irq_mask, 0);
+		sx150x_write_cfg(chip, n, 2, chip->dev_cfg->reg_sense,
+				 chip->irq_sense >> (n * 2));
+	}
+out:
 	mutex_unlock(&chip->lock);
 }
 
@@ -445,8 +462,11 @@ static void sx150x_init_chip(struct sx15
 	chip->irq_chip.irq_bus_sync_unlock = sx150x_irq_bus_sync_unlock;
 	chip->irq_summary                  = -1;
 	chip->irq_base                     = -1;
+	chip->irq_masked                   = ~0;
 	chip->irq_sense                    = 0;
-	chip->irq_set_type_pending         = 0;
+	chip->dev_masked                   = ~0;
+	chip->dev_sense                    = 0;
+	chip->irq_update		   = NO_UPDATE_PENDING;
 }
 
 static int sx150x_init_io(struct sx150x_chip *chip, u8 base, u16 cfg)


