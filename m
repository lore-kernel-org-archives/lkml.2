Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760807Ab2C3PVk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 11:21:40 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:59801 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759933Ab2C3PUT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 11:20:19 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Jiang Liu <jiang.liu@huawei.com>, Jiang Liu <liuj97@gmail.com>,
        Keping Chen <chenkeping@huawei.com>, linux-kernel@vger.kernel.org
Subject: [PATCH v3 2/4] IRQ: introduce irq_do_set_affinity() to reduce duplicated code
Date: Fri, 30 Mar 2012 23:11:34 +0800
Message-Id: <1333120296-13563-3-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1333120296-13563-1-git-send-email-jiang.liu@huawei.com>
References: <1333120296-13563-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce function irq_do_set_affinity() to reduce duplicated code.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
---
 kernel/irq/internals.h |    3 +++
 kernel/irq/manage.c    |   39 ++++++++++++++++++++++-----------------
 kernel/irq/migration.c |   12 ++----------
 3 files changed, 27 insertions(+), 27 deletions(-)

diff --git a/kernel/irq/internals.h b/kernel/irq/internals.h
index 8e5c56b..001fa5b 100644
--- a/kernel/irq/internals.h
+++ b/kernel/irq/internals.h
@@ -101,6 +101,9 @@ extern int irq_select_affinity_usr(unsigned int irq, struct cpumask *mask);
 
 extern void irq_set_thread_affinity(struct irq_desc *desc);
 
+extern int irq_do_set_affinity(struct irq_data *data,
+			       const struct cpumask *dest, bool force);
+
 /* Inline functions for support of irq chips on slow busses */
 static inline void chip_bus_lock(struct irq_desc *desc)
 {
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index b0ccd1a..d2724a0 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -139,6 +139,25 @@ static inline void
 irq_get_pending(struct cpumask *mask, struct irq_desc *desc) { }
 #endif
 
+int irq_do_set_affinity(struct irq_data *data, const struct cpumask *mask,
+			bool force)
+{
+	struct irq_desc *desc = irq_data_to_desc(data);
+	struct irq_chip *chip = irq_data_get_irq_chip(data);
+	int ret;
+
+	ret = chip->irq_set_affinity(data, mask, false);
+	switch (ret) {
+	case IRQ_SET_MASK_OK:
+		cpumask_copy(data->affinity, mask);
+	case IRQ_SET_MASK_OK_NOCOPY:
+		irq_set_thread_affinity(desc);
+		ret = 0;
+	}
+
+	return ret;
+}
+
 int __irq_set_affinity_locked(struct irq_data *data, const struct cpumask *mask)
 {
 	struct irq_chip *chip = irq_data_get_irq_chip(data);
@@ -149,14 +168,7 @@ int __irq_set_affinity_locked(struct irq_data *data, const struct cpumask *mask)
 		return -EINVAL;
 
 	if (irq_can_move_pcntxt(data)) {
-		ret = chip->irq_set_affinity(data, mask, false);
-		switch (ret) {
-		case IRQ_SET_MASK_OK:
-			cpumask_copy(data->affinity, mask);
-		case IRQ_SET_MASK_OK_NOCOPY:
-			irq_set_thread_affinity(desc);
-			ret = 0;
-		}
+		ret = irq_do_set_affinity(data, mask, false);
 	} else {
 		irqd_set_move_pending(data);
 		irq_copy_pending(desc, mask);
@@ -280,9 +292,7 @@ EXPORT_SYMBOL_GPL(irq_set_affinity_notifier);
 static int
 setup_affinity(unsigned int irq, struct irq_desc *desc, struct cpumask *mask)
 {
-	struct irq_chip *chip = irq_desc_get_chip(desc);
 	struct cpumask *set = irq_default_affinity;
-	int ret;
 
 	/* Excludes PER_CPU and NO_BALANCE interrupts */
 	if (!irq_can_set_affinity(irq))
@@ -301,13 +311,8 @@ setup_affinity(unsigned int irq, struct irq_desc *desc, struct cpumask *mask)
 	}
 
 	cpumask_and(mask, cpu_online_mask, set);
-	ret = chip->irq_set_affinity(&desc->irq_data, mask, false);
-	switch (ret) {
-	case IRQ_SET_MASK_OK:
-		cpumask_copy(desc->irq_data.affinity, mask);
-	case IRQ_SET_MASK_OK_NOCOPY:
-		irq_set_thread_affinity(desc);
-	}
+	irq_do_set_affinity(&desc->irq_data, mask, false);
+
 	return 0;
 }
 #else
diff --git a/kernel/irq/migration.c b/kernel/irq/migration.c
index c3c8975..ef04dab 100644
--- a/kernel/irq/migration.c
+++ b/kernel/irq/migration.c
@@ -43,16 +43,8 @@ void irq_move_masked_irq(struct irq_data *idata)
 	 * masking the irqs.
 	 */
 	if (likely(cpumask_any_and(desc->pending_mask, cpu_online_mask)
-		   < nr_cpu_ids)) {
-		int ret = chip->irq_set_affinity(&desc->irq_data,
-						 desc->pending_mask, false);
-		switch (ret) {
-		case IRQ_SET_MASK_OK:
-			cpumask_copy(desc->irq_data.affinity, desc->pending_mask);
-		case IRQ_SET_MASK_OK_NOCOPY:
-			irq_set_thread_affinity(desc);
-		}
-	}
+		   < nr_cpu_ids))
+		irq_do_set_affinity(&desc->irq_data, desc->pending_mask, false);
 
 	cpumask_clear(desc->pending_mask);
 }
-- 
1.7.5.4

