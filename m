Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757352Ab1LNPaK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 10:30:10 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:36263 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754327Ab1LNPaH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 10:30:07 -0500
From: Rob Herring <robherring2@gmail.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org
Cc: Grant Likely <grant.likely@secretlab.ca>, shawn.guo@freescale.com,
        Kukjin Kim <kgene.kim@samsung.com>, Kevin Hilman <khilman@ti.com>,
        Tony Lindgren <tony@atomide.com>, Barry Song <baohua.song@csr.com>,
        Linus Walleij <linus.ml.walleij@gmail.com>,
        Rob Herring <rob.herring@calxeda.com>
Subject: [PATCH 5/9] gpio: pl061: convert to use 0 for no irq
Date: Wed, 14 Dec 2011 09:28:54 -0600
Message-Id: <1323876538-20406-6-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1323876538-20406-1-git-send-email-robherring2@gmail.com>
References: <1323876538-20406-1-git-send-email-robherring2@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <rob.herring@calxeda.com>

We don't want drivers using NO_IRQ, so remove its use. For now, 0 or
-1 means no irq until platforms are converted to use 0.

Signed-off-by: Rob Herring <rob.herring@calxeda.com>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Linus Walleij <linus.ml.walleij@gmail.com>
---
 drivers/gpio/gpio-pl061.c  |    8 ++++----
 include/linux/amba/pl061.h |    2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/gpio/gpio-pl061.c b/drivers/gpio/gpio-pl061.c
index 0f718f9..fe19dec 100644
--- a/drivers/gpio/gpio-pl061.c
+++ b/drivers/gpio/gpio-pl061.c
@@ -53,7 +53,7 @@ struct pl061_gpio {
 	spinlock_t		irq_lock;	/* IRQ registers */
 
 	void __iomem		*base;
-	unsigned		irq_base;
+	int			irq_base;
 	struct gpio_chip	gc;
 };
 
@@ -119,7 +119,7 @@ static int pl061_to_irq(struct gpio_chip *gc, unsigned offset)
 {
 	struct pl061_gpio *chip = container_of(gc, struct pl061_gpio, gc);
 
-	if (chip->irq_base == NO_IRQ)
+	if (chip->irq_base <= 0)
 		return -EINVAL;
 
 	return chip->irq_base + offset;
@@ -250,7 +250,7 @@ static int pl061_probe(struct amba_device *dev, const struct amba_id *id)
 		chip->irq_base = pdata->irq_base;
 	} else if (dev->dev.of_node) {
 		chip->gc.base = -1;
-		chip->irq_base = NO_IRQ;
+		chip->irq_base = 0;
 	} else {
 		ret = -ENODEV;
 		goto free_mem;
@@ -290,7 +290,7 @@ static int pl061_probe(struct amba_device *dev, const struct amba_id *id)
 	 * irq_chip support
 	 */
 
-	if (chip->irq_base == NO_IRQ)
+	if (chip->irq_base <= 0)
 		return 0;
 
 	writeb(0, chip->base + GPIOIE); /* disable irqs */
diff --git a/include/linux/amba/pl061.h b/include/linux/amba/pl061.h
index 2412af9..fb83c04 100644
--- a/include/linux/amba/pl061.h
+++ b/include/linux/amba/pl061.h
@@ -7,7 +7,7 @@ struct pl061_platform_data {
 	unsigned	gpio_base;
 
 	/* number of the first IRQ.
-	 * If the IRQ functionality in not desired this must be set to NO_IRQ.
+	 * If the IRQ functionality in not desired this must be set to 0.
 	 */
 	unsigned	irq_base;
 
-- 
1.7.5.4

