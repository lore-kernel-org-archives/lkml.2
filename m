Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755969Ab2JEPcJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 11:32:09 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:38332 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755214Ab2JEPcB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 11:32:01 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 01/10] mfd: Prevent STMPE from abusing mfd_add_devices' irq_base parameter
Date: Fri,  5 Oct 2012 16:31:37 +0100
Message-Id: <1349451107-8009-2-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1349451107-8009-1-git-send-email-lee.jones@linaro.org>
References: <1349451107-8009-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Originally IRQ incrementers were provided in some template resource
structures for keypad and touchscreen devices. These were passed as
IORESOURCE_IRQs to MFD core in the usual way. The true device IRQs
were instead added to the irq_base when mfd_add_devices was invoked.
This is clearly an abuse of the call, and does not scale when IRQ
Domains are brought into play. Before we can provide the STMPE with
its own IRQ Domain we must first fix this. This patche keeps most
of the driver's structure, keeping the template strategy. However,
instead of providing the IRQ as an increment to irq_base, we
dynamically populate the IORESOURCE_IRQ with the correct device IRQ.

Cc: Samuel Ortiz <sameo@linux.intel.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mfd/stmpe.c |   25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

diff --git a/drivers/mfd/stmpe.c b/drivers/mfd/stmpe.c
index c94f521..ad13cb0 100644
--- a/drivers/mfd/stmpe.c
+++ b/drivers/mfd/stmpe.c
@@ -310,14 +310,10 @@ static struct mfd_cell stmpe_gpio_cell_noirq = {
 static struct resource stmpe_keypad_resources[] = {
 	{
 		.name	= "KEYPAD",
-		.start	= 0,
-		.end	= 0,
 		.flags	= IORESOURCE_IRQ,
 	},
 	{
 		.name	= "KEYPAD_OVER",
-		.start	= 1,
-		.end	= 1,
 		.flags	= IORESOURCE_IRQ,
 	},
 };
@@ -397,14 +393,10 @@ static struct stmpe_variant_info stmpe801_noirq = {
 static struct resource stmpe_ts_resources[] = {
 	{
 		.name	= "TOUCH_DET",
-		.start	= 0,
-		.end	= 0,
 		.flags	= IORESOURCE_IRQ,
 	},
 	{
 		.name	= "FIFO_TH",
-		.start	= 1,
-		.end	= 1,
 		.flags	= IORESOURCE_IRQ,
 	},
 };
@@ -959,10 +951,10 @@ static int __devinit stmpe_chip_init(struct stmpe *stmpe)
 }
 
 static int __devinit stmpe_add_device(struct stmpe *stmpe,
-				      struct mfd_cell *cell, int irq)
+				      struct mfd_cell *cell)
 {
 	return mfd_add_devices(stmpe->dev, stmpe->pdata->id, cell, 1,
-			       NULL, stmpe->irq_base + irq, NULL);
+			       NULL, stmpe->irq_base, NULL);
 }
 
 static int __devinit stmpe_devices_init(struct stmpe *stmpe)
@@ -970,7 +962,7 @@ static int __devinit stmpe_devices_init(struct stmpe *stmpe)
 	struct stmpe_variant_info *variant = stmpe->variant;
 	unsigned int platform_blocks = stmpe->pdata->blocks;
 	int ret = -EINVAL;
-	int i;
+	int i, j;
 
 	for (i = 0; i < variant->num_blocks; i++) {
 		struct stmpe_variant_block *block = &variant->blocks[i];
@@ -978,8 +970,17 @@ static int __devinit stmpe_devices_init(struct stmpe *stmpe)
 		if (!(platform_blocks & block->block))
 			continue;
 
+		for (j = 0; j < block->cell->num_resources; j++) {
+			struct resource *res =
+				(struct resource *) &block->cell->resources[j];
+
+			/* Dynamically fill in a variant's IRQ. */
+			if (res->flags & IORESOURCE_IRQ)
+				res->start = res->end = block->irq + j;
+		}
+
 		platform_blocks &= ~block->block;
-		ret = stmpe_add_device(stmpe, block->cell, block->irq);
+		ret = stmpe_add_device(stmpe, block->cell);
 		if (ret)
 			return ret;
 	}
-- 
1.7.9.5

