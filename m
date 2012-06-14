Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754189Ab2FNIbv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 04:31:51 -0400
Received: from na3sys009aog134.obsmtp.com ([74.125.149.83]:49981 "HELO
	na3sys009aog134.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752034Ab2FNIbs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 04:31:48 -0400
X-Greylist: delayed 6825 seconds by postgrey-1.27 at vger.kernel.org; Thu, 14 Jun 2012 04:31:45 EDT
From: Ning Jiang <ning.n.jiang@gmail.com>
To: tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, Ning Jiang <ning.n.jiang@gmail.com>
Subject: [PATCH 1/2] genirq: Introduce parent and children concept for IRQ
Date: Thu, 14 Jun 2012 16:31:36 +0800
Message-Id: <1339662697-4600-1-git-send-email-ning.n.jiang@gmail.com>
X-Mailer: git-send-email 1.7.1
X-OriginalArrivalTime: 14 Jun 2012 08:27:24.0473 (UTC) FILETIME=[86762A90:01CD4A07]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For chained and nested irq, there exists parent and children relation
in nature. Especially for nested irq, its handler function is executed
in the parent thread context.  If we need to resend a nested interrupt,
we have to trace all the way back to its ancestor and trigger ancestor's
irq flow handler.  If we retrigger the nested interrupt directly, we'll
get warning message in irq_nested_primary_handler(). Introduce parent
and children concept so that we can get the parent irq number in such
condition.

Signed-off-by: Ning Jiang <ning.n.jiang@gmail.com>
---
 include/linux/irq.h  |   14 ++++++++++++++
 kernel/irq/chip.c    |   16 ++++++++++++++++
 kernel/irq/irqdesc.c |    2 ++
 3 files changed, 32 insertions(+), 0 deletions(-)

diff --git a/include/linux/irq.h b/include/linux/irq.h
index 45593d0..e043d1a 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -146,6 +146,8 @@ struct irq_domain;
 struct irq_data {
 	unsigned int		irq;
 	unsigned long		hwirq;
+	unsigned int		parent_irq;
+	unsigned int		has_children;
 	unsigned int		node;
 	unsigned int		state_use_accessors;
 	struct irq_chip		*chip;
@@ -523,6 +525,7 @@ static inline void dynamic_irq_init(unsigned int irq)
 }
 
 /* Set/get chip/data for an IRQ: */
+extern int irq_set_parent_irq(unsigned int irq, unsigned int parent_irq);
 extern int irq_set_chip(unsigned int irq, struct irq_chip *chip);
 extern int irq_set_handler_data(unsigned int irq, void *data);
 extern int irq_set_chip_data(unsigned int irq, void *data);
@@ -530,6 +533,17 @@ extern int irq_set_irq_type(unsigned int irq, unsigned int type);
 extern int irq_set_msi_desc(unsigned int irq, struct msi_desc *entry);
 extern struct irq_data *irq_get_irq_data(unsigned int irq);
 
+static inline unsigned int irq_get_parent_irq(unsigned int irq)
+{
+	struct irq_data *d = irq_get_irq_data(irq);
+	return d ? d->parent_irq : NO_IRQ;
+}
+
+static inline unsigned int irq_data_get_parent_irq(struct irq_data *d)
+{
+	return d->parent_irq;
+}
+
 static inline struct irq_chip *irq_get_chip(unsigned int irq)
 {
 	struct irq_data *d = irq_get_irq_data(irq);
diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index 6cec1a2..a382fef 100644
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -20,6 +20,22 @@
 
 #include "internals.h"
 
+int irq_set_parent_irq(unsigned int irq, unsigned int parent_irq)
+{
+	unsigned long flags, flags_parent;
+	struct irq_desc *desc = irq_get_desc_lock(irq, &flags, 0);
+	struct irq_desc *desc_parent = irq_get_desc_lock(parent_irq, &flags_parent, 0);
+
+	if (!desc || !desc_parent || (parent_irq == NO_IRQ))
+		return -EINVAL;
+	desc->irq_data.parent_irq = parent_irq;
+	desc_parent->irq_data.has_children = true;
+	irq_put_desc_unlock(desc_parent, flags_parent);
+	irq_put_desc_unlock(desc, flags);
+	return 0;
+}
+EXPORT_SYMBOL(irq_set_parent_irq);
+
 /**
  *	irq_set_chip - set the irq chip for an irq
  *	@irq:	irq number
diff --git a/kernel/irq/irqdesc.c b/kernel/irq/irqdesc.c
index 192a302..bf60ba9 100644
--- a/kernel/irq/irqdesc.c
+++ b/kernel/irq/irqdesc.c
@@ -76,6 +76,8 @@ static void desc_set_defaults(unsigned int irq, struct irq_desc *desc, int node,
 	int cpu;
 
 	desc->irq_data.irq = irq;
+	desc->irq_data.parent_irq = NO_IRQ;
+	desc->irq_data.has_children = false;
 	desc->irq_data.chip = &no_irq_chip;
 	desc->irq_data.chip_data = NULL;
 	desc->irq_data.handler_data = NULL;
-- 
1.7.1

