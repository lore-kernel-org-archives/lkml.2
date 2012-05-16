Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030258Ab2EPLND (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 07:13:03 -0400
Received: from na3sys009aog112.obsmtp.com ([74.125.149.207]:46246 "EHLO
	na3sys009aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967293Ab2EPLML (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 07:12:11 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Benoit Cousson <b-cousson@ti.com>,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        peter.ujfalusi@ti.com, Misael Lopez Cruz <misael.lopez@ti.com>,
        Dmitry Torokhov <dtor@mail.ru>
Subject: [PATCH v3 2/4] MFD: twl6040: Allocate IRQ numbers dynamically
Date: Wed, 16 May 2012 14:11:56 +0300
Message-Id: <1337166718-8458-3-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1337166718-8458-1-git-send-email-peter.ujfalusi@ti.com>
References: <1337166718-8458-1-git-send-email-peter.ujfalusi@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use irq_alloc_descs() to get the IRQ number range dynamically instead of
the hardwired use if pdata->irq_base.
The twl6040 only provides interrupts for it's internal components which
means that it is not working as an IRQ expander type of device.
The client drivers will receive their interrupt numbers as resource which
is configured based on the received IRQ range we got from irq_alloc_descs()

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 drivers/mfd/twl6040-core.c |    3 +--
 drivers/mfd/twl6040-irq.c  |   13 +++++++++++--
 2 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/mfd/twl6040-core.c b/drivers/mfd/twl6040-core.c
index 7a92d95..c50fba7 100644
--- a/drivers/mfd/twl6040-core.c
+++ b/drivers/mfd/twl6040-core.c
@@ -515,7 +515,7 @@ static int __devinit twl6040_probe(struct i2c_client *client,
 	}
 
 	/* In order to operate correctly we need valid interrupt config */
-	if (!client->irq || !pdata->irq_base) {
+	if (!client->irq) {
 		dev_err(&client->dev, "Invalid IRQ configuration\n");
 		return -EINVAL;
 	}
@@ -552,7 +552,6 @@ static int __devinit twl6040_probe(struct i2c_client *client,
 
 	twl6040->dev = &client->dev;
 	twl6040->irq = client->irq;
-	twl6040->irq_base = pdata->irq_base;
 
 	mutex_init(&twl6040->mutex);
 	mutex_init(&twl6040->io_mutex);
diff --git a/drivers/mfd/twl6040-irq.c b/drivers/mfd/twl6040-irq.c
index 008022c..914978e 100644
--- a/drivers/mfd/twl6040-irq.c
+++ b/drivers/mfd/twl6040-irq.c
@@ -23,6 +23,7 @@
 
 #include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/err.h>
 #include <linux/irq.h>
 #include <linux/interrupt.h>
 #include <linux/mfd/core.h>
@@ -138,7 +139,7 @@ static irqreturn_t twl6040_irq_thread(int irq, void *data)
 
 int twl6040_irq_init(struct twl6040 *twl6040)
 {
-	int i, nr_irqs, ret;
+	int i, nr_irqs, irq_base, ret;
 	u8 val;
 
 	mutex_init(&twl6040->irq_mutex);
@@ -149,8 +150,16 @@ int twl6040_irq_init(struct twl6040 *twl6040)
 	twl6040_reg_write(twl6040, TWL6040_REG_INTMR, TWL6040_ALLINT_MSK);
 
 	nr_irqs = ARRAY_SIZE(twl6040_irqs);
+
+	irq_base = irq_alloc_descs(-1, 0, nr_irqs, 0);
+	if (IS_ERR_VALUE(irq_base)) {
+		dev_err(twl6040->dev, "Fail to allocate IRQ descs\n");
+		return irq_base;
+	}
+	twl6040->irq_base = irq_base;
+
 	/* Register them with genirq */
-	for (i = twl6040->irq_base; i < twl6040->irq_base + nr_irqs; i++) {
+	for (i = irq_base; i < irq_base + nr_irqs; i++) {
 		irq_set_chip_data(i, twl6040);
 		irq_set_chip_and_handler(i, &twl6040_irq_chip,
 					 handle_level_irq);
-- 
1.7.8.6

