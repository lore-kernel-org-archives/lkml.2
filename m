Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754074Ab1IWMsQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 08:48:16 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:51233 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754036Ab1IWMsM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 08:48:12 -0400
thread-index: Acx57wf62NrZzAdcQPqm6OZA/vdHlQ==
Content-Transfer-Encoding: 8BIT
Content-Class: urn:content-classes:message
Importance: normal
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.3790.4657
From: Tero Kristo <t-kristo@ti.com>
To: <linux-omap@vger.kernel.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Paul Walmsley <paul@pwsan.com>, Kevin Hilman <khilman@ti.com>,
        "Avinash.H.M" <avinashhm@ti.com>, "Cousson, Benoit" <b-cousson@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        "Govindraj.R" <govindraj.raja@ti.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCHv9 06/18] mfd: omap-prm: added chain interrupt handler
Date: Fri, 23 Sep 2011 15:46:14 +0300
Message-ID: <1316781986-30642-7-git-send-email-t-kristo@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1316781986-30642-1-git-send-email-t-kristo@ti.com>
References: <1316781986-30642-1-git-send-email-t-kristo@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce a chained interrupt handler mechanism for the PRCM
interrupt, so that individual PRCM event can cleanly be handled by
handlers in separate drivers. We do this by introducing PRCM event
names, which are then matched to the particular PRCM interrupt bit
depending on the specific OMAP SoC being used.

PRCM interrupts have two priority levels, high or normal. High priority
is needed for IO event handling, so that we can be sure that IO events
are processed before other events. This reduces latency for IO event
customers and also prevents incorrect ack sequence on OMAP3.

Signed-off-by: Tero Kristo <t-kristo@ti.com>
Cc: Paul Walmsley <paul@pwsan.com>
Cc: Kevin Hilman <khilman@ti.com>
Cc: Avinash.H.M <avinashhm@ti.com>
Cc: Cousson, Benoit <b-cousson@ti.com>
Cc: Tony Lindgren <tony@atomide.com>
Cc: Govindraj.R <govindraj.raja@ti.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>
---
 drivers/mfd/omap-prm-common.c |  239 +++++++++++++++++++++++++++++++++++++++++
 drivers/mfd/omap-prm.h        |   40 +++++++
 drivers/mfd/omap3xxx-prm.c    |   29 +++++-
 drivers/mfd/omap4xxx-prm.c    |   28 +++++-
 4 files changed, 334 insertions(+), 2 deletions(-)
 create mode 100644 drivers/mfd/omap-prm.h

diff --git a/drivers/mfd/omap-prm-common.c b/drivers/mfd/omap-prm-common.c
index 39b199c8..2886eb2 100644
--- a/drivers/mfd/omap-prm-common.c
+++ b/drivers/mfd/omap-prm-common.c
@@ -15,10 +15,249 @@
 #include <linux/ctype.h>
 #include <linux/module.h>
 #include <linux/io.h>
+#include <linux/irq.h>
+#include <linux/interrupt.h>
 #include <linux/slab.h>
 #include <linux/init.h>
 #include <linux/err.h>
 
+#include "omap-prm.h"
+
+#define OMAP_PRCM_MAX_NR_PENDING_REG 2
+
+struct omap_prm_device {
+	const struct omap_prcm_irq_setup *irq_setup;
+	const struct omap_prcm_irq *irqs;
+	struct irq_chip_generic **irq_chips;
+	int nr_irqs;
+	u32 *saved_mask;
+	u32 *priority_mask;
+	int base_irq;
+	int irq;
+	void __iomem *base;
+};
+
+static struct omap_prm_device prm_dev;
+
+static inline u32 prm_read_reg(int offset)
+{
+	return __raw_readl(prm_dev.base + offset);
+}
+
+static inline void prm_write_reg(u32 value, int offset)
+{
+	__raw_writel(value, prm_dev.base + offset);
+}
+
+static void prm_pending_events(unsigned long *events)
+{
+	u32 mask, st;
+	int i;
+
+	memset(events, 0, prm_dev.irq_setup->nr_regs * sizeof(unsigned long));
+
+	for (i = 0; i < prm_dev.irq_setup->nr_regs; i++) {
+		mask = prm_read_reg(prm_dev.irq_setup->mask + i * 4);
+		st = prm_read_reg(prm_dev.irq_setup->ack + i * 4);
+		events[i] = mask & st;
+	}
+}
+
+/*
+ * Move priority events from events to priority_events array
+ */
+static void prm_events_filter_priority(unsigned long *events,
+	unsigned long *priority_events)
+{
+	int i;
+
+	for (i = 0; i < prm_dev.irq_setup->nr_regs; i++) {
+		priority_events[i] = events[i] & prm_dev.priority_mask[i];
+		events[i] ^= priority_events[i];
+	}
+}
+
+/*
+ * PRCM Interrupt Handler
+ *
+ * This is a common handler for the OMAP PRCM interrupts. Pending
+ * interrupts are detected by a call to prm_pending_events and
+ * dispatched accordingly. Clearing of the wakeup events should be
+ * done by the SoC specific individual handlers.
+ */
+static void prcm_irq_handler(unsigned int irq, struct irq_desc *desc)
+{
+	unsigned long pending[OMAP_PRCM_MAX_NR_PENDING_REG];
+	unsigned long priority_pending[OMAP_PRCM_MAX_NR_PENDING_REG];
+	struct irq_chip *chip = irq_desc_get_chip(desc);
+	unsigned int virtirq;
+	int nr_irqs = prm_dev.irq_setup->nr_regs * 32;
+
+	/*
+	 * Loop until all pending irqs are handled, since
+	 * generic_handle_irq() can cause new irqs to come
+	 */
+	while (1) {
+		prm_pending_events(pending);
+
+		/* No bit set, then all IRQs are handled */
+		if (find_first_bit(pending, nr_irqs) >= nr_irqs)
+			break;
+
+		prm_events_filter_priority(pending, priority_pending);
+
+		/*
+		 * Loop on all currently pending irqs so that new irqs
+		 * cannot starve previously pending irqs
+		 */
+
+		/* Serve priority events first */
+		for_each_set_bit(virtirq, priority_pending, nr_irqs)
+			generic_handle_irq(prm_dev.base_irq + virtirq);
+
+		/* Serve normal events next */
+		for_each_set_bit(virtirq, pending, nr_irqs)
+			generic_handle_irq(prm_dev.base_irq + virtirq);
+	}
+	if (chip->irq_ack)
+		chip->irq_ack(&desc->irq_data);
+	if (chip->irq_eoi)
+		chip->irq_eoi(&desc->irq_data);
+	chip->irq_unmask(&desc->irq_data);
+}
+
+/*
+ * Given a PRCM event name, returns the corresponding IRQ on which the
+ * handler should be registered.
+ */
+int omap_prcm_event_to_irq(const char *name)
+{
+	int i;
+
+	for (i = 0; i < prm_dev.nr_irqs; i++)
+		if (!strcmp(prm_dev.irqs[i].name, name))
+			return prm_dev.base_irq + prm_dev.irqs[i].offset;
+
+	return -ENOENT;
+}
+
+/*
+ * Reverses memory allocated and other steps done by
+ * omap_prcm_register_chain_handler
+ */
+void omap_prcm_irq_cleanup(void)
+{
+	int i;
+
+	if (prm_dev.irq_chips) {
+		for (i = 0; i < prm_dev.irq_setup->nr_regs; i++) {
+			if (prm_dev.irq_chips[i])
+				irq_remove_generic_chip(prm_dev.irq_chips[i],
+					0xffffffff, 0, 0);
+			prm_dev.irq_chips[i] = NULL;
+		}
+		kfree(prm_dev.irq_chips);
+		prm_dev.irq_chips = NULL;
+	}
+
+	kfree(prm_dev.saved_mask);
+	prm_dev.saved_mask = NULL;
+
+	kfree(prm_dev.priority_mask);
+	prm_dev.priority_mask = NULL;
+
+	irq_set_chained_handler(prm_dev.irq, NULL);
+
+	if (prm_dev.base_irq > 0)
+		irq_free_descs(prm_dev.base_irq,
+			prm_dev.irq_setup->nr_regs * 32);
+	prm_dev.base_irq = 0;
+}
+
+/*
+ * Initializes the prcm chain handler based on provided parameters.
+ */
+int omap_prcm_register_chain_handler(int irq, void __iomem *base,
+	const struct omap_prcm_irq_setup *irq_setup,
+	const struct omap_prcm_irq *irqs, int nr_irqs)
+{
+	int nr_regs = irq_setup->nr_regs;
+	u32 mask[OMAP_PRCM_MAX_NR_PENDING_REG];
+	int offset;
+	int max_irq = 0;
+	int i;
+	struct irq_chip_generic *gc;
+	struct irq_chip_type *ct;
+
+	if (nr_regs > OMAP_PRCM_MAX_NR_PENDING_REG) {
+		pr_err("PRCM: nr_regs too large\n");
+		goto err;
+	}
+
+	prm_dev.irq_setup = irq_setup;
+	prm_dev.irqs = irqs;
+	prm_dev.nr_irqs = nr_irqs;
+	prm_dev.irq = irq;
+	prm_dev.base = base;
+
+	prm_dev.irq_chips = kzalloc(sizeof(void *) * nr_regs, GFP_KERNEL);
+	prm_dev.saved_mask = kzalloc(sizeof(u32) * nr_regs, GFP_KERNEL);
+	prm_dev.priority_mask = kzalloc(sizeof(u32) * nr_regs, GFP_KERNEL);
+
+	if (!prm_dev.irq_chips || !prm_dev.saved_mask ||
+	    !prm_dev.priority_mask) {
+		pr_err("PRCM: kzalloc failed\n");
+		goto err;
+	}
+
+	memset(mask, 0, sizeof(mask));
+
+	for (i = 0; i < nr_irqs; i++) {
+		offset = irqs[i].offset;
+		mask[offset >> 5] |= 1 << (offset & 0x1f);
+		if (offset > max_irq)
+			max_irq = offset;
+		if (irqs[i].priority)
+			prm_dev.priority_mask[offset >> 5] |=
+				1 << (offset & 0x1f);
+	}
+
+	irq_set_chained_handler(prm_dev.irq, prcm_irq_handler);
+
+	prm_dev.base_irq = irq_alloc_descs(-1, 0, irq_setup->nr_regs * 32, 0);
+
+	if (prm_dev.base_irq < 0) {
+		pr_err("PRCM: failed to allocate irq descs\n");
+		goto err;
+	}
+
+	for (i = 0; i <= irq_setup->nr_regs; i++) {
+		gc = irq_alloc_generic_chip("PRCM", 1,
+			prm_dev.base_irq + i * 32, base, handle_level_irq);
+
+		if (!gc) {
+			pr_err("PRCM: failed to allocate generic chip\n");
+			goto err;
+		}
+		ct = gc->chip_types;
+		ct->chip.irq_ack = irq_gc_ack_set_bit;
+		ct->chip.irq_mask = irq_gc_mask_clr_bit;
+		ct->chip.irq_unmask = irq_gc_mask_set_bit;
+
+		ct->regs.ack = irq_setup->ack + i * 4;
+		ct->regs.mask = irq_setup->mask + i * 4;
+
+		irq_setup_generic_chip(gc, mask[i], 0, IRQ_NOREQUEST, 0);
+		prm_dev.irq_chips[i] = gc;
+	}
+
+	return 0;
+
+err:
+	omap_prcm_irq_cleanup();
+	return -ENOMEM;
+}
+
 MODULE_AUTHOR("Tero Kristo <t-kristo@ti.com>");
 MODULE_DESCRIPTION("OMAP PRM core driver");
 MODULE_LICENSE("GPL");
diff --git a/drivers/mfd/omap-prm.h b/drivers/mfd/omap-prm.h
new file mode 100644
index 0000000..7ffefe1
--- /dev/null
+++ b/drivers/mfd/omap-prm.h
@@ -0,0 +1,40 @@
+/*
+ * OMAP Power and Reset Management (PRM) driver common definitions
+ *
+ * Copyright (C) 2011 Texas Instruments, Inc.
+ *
+ * Author: Tero Kristo <t-kristo@ti.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#ifndef __DRIVERS_MFD_OMAP_PRM_H__
+#define __DRIVERS_MFD_OMAP_PRM_H__
+
+struct omap_prcm_irq_setup {
+	u32 ack;
+	u32 mask;
+	int nr_regs;
+};
+
+struct omap_prcm_irq {
+	const char *name;
+	unsigned int offset;
+	bool priority;
+};
+
+#define OMAP_PRCM_IRQ(_name, _offset, _priority) {	\
+	.name = _name,					\
+	.offset = _offset,				\
+	.priority = _priority				\
+	}
+
+void omap_prcm_irq_cleanup(void);
+int omap_prcm_register_chain_handler(int irq, void __iomem *base,
+	const struct omap_prcm_irq_setup *irq_setup,
+	const struct omap_prcm_irq *irqs, int nr_irqs);
+
+#endif
diff --git a/drivers/mfd/omap3xxx-prm.c b/drivers/mfd/omap3xxx-prm.c
index 177aced..9be21ee 100644
--- a/drivers/mfd/omap3xxx-prm.c
+++ b/drivers/mfd/omap3xxx-prm.c
@@ -21,11 +21,38 @@
 #include <linux/platform_device.h>
 #include <linux/mfd/omap-prm.h>
 
+#include "omap-prm.h"
+
 #define DRIVER_NAME "prm3xxx"
 
+#define OMAP3_PRM_IRQSTATUS_OFFSET	0x818
+#define OMAP3_PRM_IRQENABLE_OFFSET	0x81c
+
+static const struct omap_prcm_irq_setup omap3_prcm_irq_setup = {
+	.ack		= OMAP3_PRM_IRQSTATUS_OFFSET,
+	.mask		= OMAP3_PRM_IRQENABLE_OFFSET,
+	.nr_regs	= 1,
+};
+
+static const struct omap_prcm_irq omap3_prcm_irqs[] = {
+	OMAP_PRCM_IRQ("wkup",	0,	0),
+	OMAP_PRCM_IRQ("io",	9,	1),
+};
+
 static int __devinit omap3xxx_prm_probe(struct platform_device *pdev)
 {
-	return 0;
+	int ret = 0;
+	struct omap_prm_platform_config *pdata = pdev->dev.platform_data;
+
+	ret = omap_prcm_register_chain_handler(pdata->irq, pdata->base,
+		&omap3_prcm_irq_setup, omap3_prcm_irqs,
+		ARRAY_SIZE(omap3_prcm_irqs));
+
+	if (ret) {
+		pr_err("%s: chain handler register failed: %d\n", __func__,
+			ret);
+	}
+	return ret;
 }
 
 static int __devexit omap3xxx_prm_remove(struct platform_device *pdev)
diff --git a/drivers/mfd/omap4xxx-prm.c b/drivers/mfd/omap4xxx-prm.c
index 9de8f3e..6e134a7 100644
--- a/drivers/mfd/omap4xxx-prm.c
+++ b/drivers/mfd/omap4xxx-prm.c
@@ -21,11 +21,37 @@
 #include <linux/platform_device.h>
 #include <linux/mfd/omap-prm.h>
 
+#include "omap-prm.h"
+
 #define DRIVER_NAME "prm4xxx"
 
+#define OMAP4_PRM_IRQSTATUS_OFFSET	0x10
+#define OMAP4_PRM_IRQENABLE_OFFSET	0x18
+
+static const struct omap_prcm_irq_setup omap4_prcm_irq_setup = {
+	.ack		= OMAP4_PRM_IRQSTATUS_OFFSET,
+	.mask		= OMAP4_PRM_IRQENABLE_OFFSET,
+	.nr_regs	= 2,
+};
+
+static const struct omap_prcm_irq omap4_prcm_irqs[] = {
+	OMAP_PRCM_IRQ("io",	9,	1),
+};
+
 static int __devinit omap4xxx_prm_probe(struct platform_device *pdev)
 {
-	return 0;
+	int ret = 0;
+	struct omap_prm_platform_config *pdata = pdev->dev.platform_data;
+
+	ret = omap_prcm_register_chain_handler(pdata->irq, pdata->base,
+		&omap4_prcm_irq_setup, omap4_prcm_irqs,
+		ARRAY_SIZE(omap4_prcm_irqs));
+
+	if (ret) {
+		pr_err("%s: chain handler register failed: %d\n", __func__,
+			ret);
+	}
+	return ret;
 }
 
 static int __devexit omap4xxx_prm_remove(struct platform_device *pdev)
-- 
1.7.4.1


Texas Instruments Oy, Tekniikantie 12, 02150 Espoo. Y-tunnus: 0115040-6. Kotipaikka: Helsinki
 

