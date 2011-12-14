Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757265Ab1LNP35 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 10:29:57 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:36263 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756915Ab1LNP3y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 10:29:54 -0500
From: Rob Herring <robherring2@gmail.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org
Cc: Grant Likely <grant.likely@secretlab.ca>, shawn.guo@freescale.com,
        Kukjin Kim <kgene.kim@samsung.com>, Kevin Hilman <khilman@ti.com>,
        Tony Lindgren <tony@atomide.com>, Barry Song <baohua.song@csr.com>,
        Linus Walleij <linus.ml.walleij@gmail.com>,
        Rob Herring <rob.herring@calxeda.com>
Subject: [PATCH 4/9] gpio: pl061: use chained_irq_* functions in irq handler
Date: Wed, 14 Dec 2011 09:28:53 -0600
Message-Id: <1323876538-20406-5-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1323876538-20406-1-git-send-email-robherring2@gmail.com>
References: <1323876538-20406-1-git-send-email-robherring2@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <rob.herring@calxeda.com>

Use chained_irq_enter/exit helper functions instead of direct pointer
accesses. This is needed for generic irq chip conversion.

Signed-off-by: Rob Herring <rob.herring@calxeda.com>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Linus Walleij <linus.ml.walleij@gmail.com>
---
 drivers/gpio/gpio-pl061.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/gpio/gpio-pl061.c b/drivers/gpio/gpio-pl061.c
index 4102f63..0f718f9 100644
--- a/drivers/gpio/gpio-pl061.c
+++ b/drivers/gpio/gpio-pl061.c
@@ -23,6 +23,7 @@
 #include <linux/amba/bus.h>
 #include <linux/amba/pl061.h>
 #include <linux/slab.h>
+#include <asm/mach/irq.h>
 
 #define GPIODIR 0x400
 #define GPIOIS  0x404
@@ -211,8 +212,9 @@ static void pl061_irq_handler(unsigned irq, struct irq_desc *desc)
 	struct list_head *chip_list = irq_get_handler_data(irq);
 	struct list_head *ptr;
 	struct pl061_gpio *chip;
+	struct irq_chip *irqchip = irq_desc_get_chip(desc);
 
-	desc->irq_data.chip->irq_ack(&desc->irq_data);
+	chained_irq_enter(irqchip, desc);
 	list_for_each(ptr, chip_list) {
 		unsigned long pending;
 		int offset;
@@ -227,7 +229,7 @@ static void pl061_irq_handler(unsigned irq, struct irq_desc *desc)
 		for_each_set_bit(offset, &pending, PL061_GPIO_NR)
 			generic_handle_irq(pl061_to_irq(&chip->gc, offset));
 	}
-	desc->irq_data.chip->irq_unmask(&desc->irq_data);
+	chained_irq_exit(irqchip, desc);
 }
 
 static int pl061_probe(struct amba_device *dev, const struct amba_id *id)
-- 
1.7.5.4

