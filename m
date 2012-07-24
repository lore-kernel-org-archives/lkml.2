Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755327Ab2GXOmx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 10:42:53 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:43625 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755205Ab2GXOmv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 10:42:51 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 1/2] regmap: irq: Enable devices for runtime PM while handling interrupts
Date: Tue, 24 Jul 2012 15:42:44 +0100
Message-Id: <1343140966-18641-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some devices need to have a runtime PM reference while handling interrupts
to ensure that the register I/O is available. Support this with a flag in
the chip.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/base/regmap/regmap-irq.c |   25 +++++++++++++++++++++++++
 include/linux/regmap.h           |    2 ++
 2 files changed, 27 insertions(+)

diff --git a/drivers/base/regmap/regmap-irq.c b/drivers/base/regmap/regmap-irq.c
index a897346..51b3cb1 100644
--- a/drivers/base/regmap/regmap-irq.c
+++ b/drivers/base/regmap/regmap-irq.c
@@ -16,6 +16,7 @@
 #include <linux/irq.h>
 #include <linux/interrupt.h>
 #include <linux/irqdomain.h>
+#include <linux/pm_runtime.h>
 #include <linux/slab.h>
 
 #include "internal.h"
@@ -60,6 +61,13 @@ static void regmap_irq_sync_unlock(struct irq_data *data)
 	struct regmap *map = d->map;
 	int i, ret;
 
+	if (d->chip->runtime_pm) {
+		ret = pm_runtime_get_sync(map->dev);
+		if (ret < 0)
+			dev_err(map->dev, "IRQ sync failed to resume: %d\n",
+				ret);
+	}
+
 	/*
 	 * If there's been a change in the mask write it back to the
 	 * hardware.  We rely on the use of the regmap core cache to
@@ -75,6 +83,9 @@ static void regmap_irq_sync_unlock(struct irq_data *data)
 				d->chip->mask_base + (i * map->reg_stride));
 	}
 
+	if (d->chip->runtime_pm)
+		pm_runtime_put(map->dev);
+
 	/* If we've changed our wakeup count propagate it to the parent */
 	if (d->wake_count < 0)
 		for (i = d->wake_count; i < 0; i++)
@@ -145,6 +156,15 @@ static irqreturn_t regmap_irq_thread(int irq, void *d)
 	int ret, i;
 	bool handled = false;
 
+	if (chip->runtime_pm) {
+		ret = pm_runtime_get_sync(map->dev);
+		if (ret < 0) {
+			dev_err(map->dev, "IRQ thread failed to resume: %d\n",
+				ret);
+			return IRQ_NONE;
+		}
+	}
+
 	/*
 	 * Ignore masked IRQs and ack if we need to; we ack early so
 	 * there is no race between handling and acknowleding the
@@ -160,6 +180,8 @@ static irqreturn_t regmap_irq_thread(int irq, void *d)
 		if (ret != 0) {
 			dev_err(map->dev, "Failed to read IRQ status: %d\n",
 					ret);
+			if (chip->runtime_pm)
+				pm_runtime_put(map->dev);
 			return IRQ_NONE;
 		}
 
@@ -185,6 +207,9 @@ static irqreturn_t regmap_irq_thread(int irq, void *d)
 		}
 	}
 
+	if (chip->runtime_pm)
+		pm_runtime_put(map->dev);
+
 	if (handled)
 		return IRQ_HANDLED;
 	else
diff --git a/include/linux/regmap.h b/include/linux/regmap.h
index 7f7e00d..9c4c9c67 100644
--- a/include/linux/regmap.h
+++ b/include/linux/regmap.h
@@ -285,6 +285,7 @@ struct regmap_irq {
  * @ack_base:    Base ack address.  If zero then the chip is clear on read.
  * @wake_base:   Base address for wake enables.  If zero unsupported.
  * @irq_reg_stride:  Stride to use for chips where registers are not contiguous.
+ * @runtime_pm:  Hold a runtime PM lock on the device when accessing it.
  *
  * @num_regs:    Number of registers in each control bank.
  * @irqs:        Descriptors for individual IRQs.  Interrupt numbers are
@@ -299,6 +300,7 @@ struct regmap_irq_chip {
 	unsigned int ack_base;
 	unsigned int wake_base;
 	unsigned int irq_reg_stride;
+	bool runtime_pm;
 
 	int num_regs;
 
-- 
1.7.10.4

