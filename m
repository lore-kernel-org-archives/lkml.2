Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759256Ab2EXUzI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 16:55:08 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59647 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751513Ab2EXUzF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 16:55:05 -0400
Date: Thu, 24 May 2012 13:53:26 -0700
From: tip-bot for Jiang Liu <liuj97@gmail.com>
Message-ID: <tip-818b0f3bfb236ae66cac3ff38e86b9e47f24b7aa@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        chenkeping@huawei.com, jiang.liu@huawei.com, liuj97@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, liuj97@gmail.com, jiang.liu@huawei.com,
        chenkeping@huawei.com
In-Reply-To: <1333120296-13563-3-git-send-email-jiang.liu@huawei.com>
References: <1333120296-13563-3-git-send-email-jiang.liu@huawei.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/core] genirq: Introduce irq_do_set_affinity()
  to reduce duplicated code
Git-Commit-ID: 818b0f3bfb236ae66cac3ff38e86b9e47f24b7aa
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 24 May 2012 13:53:33 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  818b0f3bfb236ae66cac3ff38e86b9e47f24b7aa
Gitweb:     http://git.kernel.org/tip/818b0f3bfb236ae66cac3ff38e86b9e47f24b7aa
Author:     Jiang Liu <liuj97@gmail.com>
AuthorDate: Fri, 30 Mar 2012 23:11:34 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 24 May 2012 22:36:40 +0200

genirq: Introduce irq_do_set_affinity() to reduce duplicated code

All invocations of chip->irq_set_affinity() are doing the same return
value checks. Let them all use a common function.

[ tglx: removed the silly likely while at it ]

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Jiang Liu <liuj97@gmail.com>
Cc: Keping Chen <chenkeping@huawei.com>
Link: http://lkml.kernel.org/r/1333120296-13563-3-git-send-email-jiang.liu@huawei.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/irq/internals.h |    3 +++
 kernel/irq/manage.c    |   39 ++++++++++++++++++++++-----------------
 kernel/irq/migration.c |   13 ++-----------
 3 files changed, 27 insertions(+), 28 deletions(-)

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
index bb32326..a1b9033 100644
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
@@ -280,9 +292,8 @@ EXPORT_SYMBOL_GPL(irq_set_affinity_notifier);
 static int
 setup_affinity(unsigned int irq, struct irq_desc *desc, struct cpumask *mask)
 {
-	struct irq_chip *chip = irq_desc_get_chip(desc);
 	struct cpumask *set = irq_default_affinity;
-	int ret, node = desc->irq_data.node;
+	int node = desc->irq_data.node;
 
 	/* Excludes PER_CPU and NO_BALANCE interrupts */
 	if (!irq_can_set_affinity(irq))
@@ -308,13 +319,7 @@ setup_affinity(unsigned int irq, struct irq_desc *desc, struct cpumask *mask)
 		if (cpumask_intersects(mask, nodemask))
 			cpumask_and(mask, mask, nodemask);
 	}
-	ret = chip->irq_set_affinity(&desc->irq_data, mask, false);
-	switch (ret) {
-	case IRQ_SET_MASK_OK:
-		cpumask_copy(desc->irq_data.affinity, mask);
-	case IRQ_SET_MASK_OK_NOCOPY:
-		irq_set_thread_affinity(desc);
-	}
+	irq_do_set_affinity(&desc->irq_data, mask, false);
 	return 0;
 }
 #else
diff --git a/kernel/irq/migration.c b/kernel/irq/migration.c
index c3c8975..ca3f4aa 100644
--- a/kernel/irq/migration.c
+++ b/kernel/irq/migration.c
@@ -42,17 +42,8 @@ void irq_move_masked_irq(struct irq_data *idata)
 	 * For correct operation this depends on the caller
 	 * masking the irqs.
 	 */
-	if (likely(cpumask_any_and(desc->pending_mask, cpu_online_mask)
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
+	if (cpumask_any_and(desc->pending_mask, cpu_online_mask) < nr_cpu_ids)
+		irq_do_set_affinity(&desc->irq_data, desc->pending_mask, false);
 
 	cpumask_clear(desc->pending_mask);
 }
