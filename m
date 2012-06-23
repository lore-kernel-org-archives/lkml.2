Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754634Ab2FWM5A (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2012 08:57:00 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:45497 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754060Ab2FWMz2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2012 08:55:28 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 3/7] mfd: arizona: Interrupt support
Date: Sat, 23 Jun 2012 13:55:14 +0100
Message-Id: <1340456118-22366-3-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1340456118-22366-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <20120623125446.GX4037@opensource.wolfsonmicro.com>
 <1340456118-22366-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Several forthcoming Wolfson devices are based on a common platform
known as Arizona allowing a great deal of reuse of driver code. This
patch adds support for the interrupt controller on Arizona class devices.
Since there are two interrupt domains in the device which share a single
/IRQ pin by default we use two regmap IRQ domains with a trivial demux
interrupt domain used to distribute the interrupts to the two devices.
The devices do support multiple interrupt signals, future work will enable
support for using this feature to avoid the demux.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/arizona-irq.c |  267 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 267 insertions(+)
 create mode 100644 drivers/mfd/arizona-irq.c

diff --git a/drivers/mfd/arizona-irq.c b/drivers/mfd/arizona-irq.c
new file mode 100644
index 0000000..4c78940
--- /dev/null
+++ b/drivers/mfd/arizona-irq.c
@@ -0,0 +1,267 @@
+/*
+ * Arizona interrupt support
+ *
+ * Copyright 2012 Wolfson Microelectronics plc
+ *
+ * Author: Mark Brown <broonie@opensource.wolfsonmicro.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/delay.h>
+#include <linux/gpio.h>
+#include <linux/interrupt.h>
+#include <linux/irq.h>
+#include <linux/irqdomain.h>
+#include <linux/module.h>
+#include <linux/pm_runtime.h>
+#include <linux/regmap.h>
+#include <linux/regulator/consumer.h>
+#include <linux/slab.h>
+
+#include <linux/mfd/arizona/core.h>
+#include <linux/mfd/arizona/registers.h>
+
+#include "arizona.h"
+
+static int arizona_map_irq(struct arizona *arizona, int irq)
+{
+	int ret;
+
+	ret = regmap_irq_get_virq(arizona->aod_irq_chip, irq);
+	if (ret < 0)
+		ret = regmap_irq_get_virq(arizona->irq_chip, irq);
+
+	return ret;
+}
+
+int arizona_request_irq(struct arizona *arizona, int irq, char *name,
+			   irq_handler_t handler, void *data)
+{
+	irq = arizona_map_irq(arizona, irq);
+	if (irq < 0)
+		return irq;
+
+	return request_threaded_irq(irq, NULL, handler, IRQF_ONESHOT,
+				    name, data);
+}
+EXPORT_SYMBOL_GPL(arizona_request_irq);
+
+void arizona_free_irq(struct arizona *arizona, int irq, void *data)
+{
+	irq = arizona_map_irq(arizona, irq);
+	if (irq < 0)
+		return;
+
+	free_irq(irq, data);
+}
+EXPORT_SYMBOL_GPL(arizona_free_irq);
+
+int arizona_set_irq_wake(struct arizona *arizona, int irq, int on)
+{
+	irq = arizona_map_irq(arizona, irq);
+	if (irq < 0)
+		return irq;
+
+	return irq_set_irq_wake(irq, on);
+}
+EXPORT_SYMBOL_GPL(arizona_set_irq_wake);
+
+static irqreturn_t arizona_boot_done(int irq, void *data)
+{
+	struct arizona *arizona = data;
+
+	dev_dbg(arizona->dev, "Boot done\n");
+
+	return IRQ_HANDLED;
+}
+
+static irqreturn_t arizona_ctrlif_err(int irq, void *data)
+{
+	struct arizona *arizona = data;
+
+	/*
+	 * For pretty much all potential sources a register cache sync
+	 * won't help, we've just got a software bug somewhere.
+	 */
+	dev_err(arizona->dev, "Control interface error\n");
+
+	return IRQ_HANDLED;
+}
+
+static irqreturn_t arizona_irq_thread(int irq, void *data)
+{
+	struct arizona *arizona = data;
+	int i, ret;
+
+	ret = pm_runtime_get_sync(arizona->dev);
+	if (ret < 0) {
+		dev_err(arizona->dev, "Failed to resume device: %d\n", ret);
+		return IRQ_NONE;
+	}
+
+	/* Check both domains */
+	for (i = 0; i < 2; i++)
+		handle_nested_irq(irq_find_mapping(arizona->virq, i));
+
+	pm_runtime_mark_last_busy(arizona->dev);
+	pm_runtime_put_autosuspend(arizona->dev);
+
+	return IRQ_HANDLED;
+}
+
+static void arizona_irq_enable(struct irq_data *data)
+{
+}
+
+static void arizona_irq_disable(struct irq_data *data)
+{
+}
+
+static struct irq_chip arizona_irq_chip = {
+	.name			= "arizona",
+	.irq_disable		= arizona_irq_disable,
+	.irq_enable		= arizona_irq_enable,
+};
+
+static int arizona_irq_map(struct irq_domain *h, unsigned int virq,
+			      irq_hw_number_t hw)
+{
+	struct regmap_irq_chip_data *data = h->host_data;
+
+	irq_set_chip_data(virq, data);
+	irq_set_chip_and_handler(virq, &arizona_irq_chip, handle_edge_irq);
+	irq_set_nested_thread(virq, 1);
+
+	/* ARM needs us to explicitly flag the IRQ as valid
+	 * and will set them noprobe when we do so. */
+#ifdef CONFIG_ARM
+	set_irq_flags(virq, IRQF_VALID);
+#else
+	irq_set_noprobe(virq);
+#endif
+
+	return 0;
+}
+
+static struct irq_domain_ops arizona_domain_ops = {
+	.map	= arizona_irq_map,
+	.xlate	= irq_domain_xlate_twocell,
+};
+
+int arizona_irq_init(struct arizona *arizona)
+{
+	int flags = IRQF_ONESHOT;
+	int ret, i;
+	const struct regmap_irq_chip *aod, *irq;
+
+	switch (arizona->type) {
+	case WM5102:
+		aod = &wm5102_aod;
+		irq = &wm5102_irq;
+		break;
+	default:
+		BUG_ON("Unknown Arizona class device" == NULL);
+		return -EINVAL;
+	}
+
+	if (arizona->pdata.irq_active_high) {
+		ret = regmap_update_bits(arizona->regmap, ARIZONA_IRQ_CTRL_1,
+					 ARIZONA_IRQ_POL, 0);
+		if (ret != 0) {
+			dev_err(arizona->dev, "Couldn't set IRQ polarity: %d\n",
+				ret);
+			goto err;
+		}
+
+		flags |= IRQF_TRIGGER_HIGH;
+	} else {
+		flags |= IRQF_TRIGGER_LOW;
+	}
+
+	/* Allocate a virtual IRQ domain to distribute to the regmap domains */
+	arizona->virq = irq_domain_add_linear(NULL, 2, &arizona_domain_ops,
+					      arizona);
+	if (!arizona->virq) {
+		ret = -EINVAL;
+		goto err;
+	}
+
+	ret = regmap_add_irq_chip(arizona->regmap,
+				  irq_create_mapping(arizona->virq, 0),
+				  IRQF_ONESHOT, -1, aod,
+				  &arizona->aod_irq_chip);
+	if (ret != 0) {
+		dev_err(arizona->dev, "Failed to add AOD IRQs: %d\n", ret);
+		goto err_domain;
+	}
+
+	ret = regmap_add_irq_chip(arizona->regmap,
+				  irq_create_mapping(arizona->virq, 1),
+				  IRQF_ONESHOT, -1, irq,
+				  &arizona->irq_chip);
+	if (ret != 0) {
+		dev_err(arizona->dev, "Failed to add AOD IRQs: %d\n", ret);
+		goto err_aod;
+	}
+
+	/* Make sure the boot done IRQ is unmasked for resumes */
+	i = arizona_map_irq(arizona, ARIZONA_IRQ_BOOT_DONE);
+	ret = request_threaded_irq(i, NULL, arizona_boot_done, IRQF_ONESHOT,
+				   "Boot done", arizona);
+	if (ret != 0) {
+		dev_err(arizona->dev, "Failed to request boot done %d: %d\n",
+			arizona->irq, ret);
+		goto err_boot_done;
+	}
+
+	/* Handle control interface errors in the core */
+	i = arizona_map_irq(arizona, ARIZONA_IRQ_CTRLIF_ERR);
+	ret = request_threaded_irq(i, NULL, arizona_ctrlif_err, IRQF_ONESHOT,
+				   "Control interface error", arizona);
+	if (ret != 0) {
+		dev_err(arizona->dev, "Failed to request boot done %d: %d\n",
+			arizona->irq, ret);
+		goto err_ctrlif;
+	}
+
+	ret = request_threaded_irq(arizona->irq, NULL, arizona_irq_thread,
+				   flags, "arizona", arizona);
+
+	if (ret != 0) {
+		dev_err(arizona->dev, "Failed to request IRQ %d: %d\n",
+			arizona->irq, ret);
+		goto err_main_irq;
+	}
+
+	return 0;
+
+err_main_irq:
+	free_irq(arizona_map_irq(arizona, ARIZONA_IRQ_CTRLIF_ERR), arizona);
+err_ctrlif:
+	free_irq(arizona_map_irq(arizona, ARIZONA_IRQ_BOOT_DONE), arizona);
+err_boot_done:
+	regmap_del_irq_chip(irq_create_mapping(arizona->virq, 1),
+			    arizona->irq_chip);
+err_aod:
+	regmap_del_irq_chip(irq_create_mapping(arizona->virq, 0),
+			    arizona->aod_irq_chip);
+err_domain:
+err:
+	return ret;
+}
+
+int arizona_irq_exit(struct arizona *arizona)
+{
+	free_irq(arizona_map_irq(arizona, ARIZONA_IRQ_CTRLIF_ERR), arizona);
+	free_irq(arizona_map_irq(arizona, ARIZONA_IRQ_BOOT_DONE), arizona);
+	regmap_del_irq_chip(irq_create_mapping(arizona->virq, 1),
+			    arizona->irq_chip);
+	regmap_del_irq_chip(irq_create_mapping(arizona->virq, 0),
+			    arizona->aod_irq_chip);
+	free_irq(arizona->irq, arizona);
+
+	return 0;
+}
-- 
1.7.10

