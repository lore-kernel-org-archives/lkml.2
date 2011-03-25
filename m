Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757447Ab1CYBG7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 21:06:59 -0400
Received: from mail3.caviumnetworks.com ([12.108.191.235]:11486 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755356Ab1CYBGy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 21:06:54 -0400
From: David Daney <ddaney@caviumnetworks.com>
To: tglx@linutronix.de, linux-mips@linux-mips.org
Cc: linux-kernel@vger.kernel.org, David Daney <ddaney@caviumnetworks.com>
Subject: [PATCH v2 1/3] genirq: Add chip hooks for taking CPUs on/off line.
Date: Thu, 24 Mar 2011 18:06:36 -0700
Message-Id: <1301015198-25535-2-git-send-email-ddaney@caviumnetworks.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1301015198-25535-1-git-send-email-ddaney@caviumnetworks.com>
References: <1301015198-25535-1-git-send-email-ddaney@caviumnetworks.com>
X-OriginalArrivalTime: 25 Mar 2011 01:06:54.0358 (UTC) FILETIME=[EE3C6B60:01CBEA88]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: David Daney <ddaney@caviumnetworks.com>
---
 include/linux/irq.h |    8 ++++++
 kernel/irq/chip.c   |   62 +++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 70 insertions(+), 0 deletions(-)

diff --git a/include/linux/irq.h b/include/linux/irq.h
index 1d3577f..f517b25 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -270,6 +270,8 @@ static inline bool irqd_can_move_in_process_context(struct irq_data *d)
  * @irq_set_wake:	enable/disable power-management wake-on of an IRQ
  * @irq_bus_lock:	function to lock access to slow bus (i2c) chips
  * @irq_bus_sync_unlock:function to sync and unlock slow bus (i2c) chips
+ * @irq_cpu_online:	configure an interrupt source for a secondary CPU
+ * @irq_cpu_offline:	un-configure an interrupt source for a secondary CPU
  * @flags:		chip specific flags
  *
  * @release:		release function solely used by UML
@@ -317,6 +319,9 @@ struct irq_chip {
 	void		(*irq_bus_lock)(struct irq_data *data);
 	void		(*irq_bus_sync_unlock)(struct irq_data *data);
 
+	void		(*irq_cpu_online)(struct irq_data *data, bool enabled);
+	void		(*irq_cpu_offline)(struct irq_data *data, bool enabled);
+
 	unsigned long	flags;
 
 	/* Currently used only by UML, might disappear one day.*/
@@ -360,6 +365,9 @@ struct irqaction;
 extern int setup_irq(unsigned int irq, struct irqaction *new);
 extern void remove_irq(unsigned int irq, struct irqaction *act);
 
+extern void irq_cpu_online(void);
+extern void irq_cpu_offline(void);
+
 #ifdef CONFIG_GENERIC_HARDIRQS
 
 #if defined(CONFIG_SMP) && defined(CONFIG_GENERIC_PENDING_IRQ)
diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index c9c0601..d122acb 100644
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -689,3 +689,65 @@ void irq_modify_status(unsigned int irq, unsigned long clr, unsigned long set)
 
 	irq_put_desc_unlock(desc, flags);
 }
+
+/**
+ *	irq_cpu_online - Invoke all irq_cpu_online functions.
+ *
+ *	Iterate through all irqs and invoke the chip.irq_cpu_online()
+ *	for each.
+ */
+void irq_cpu_online(void)
+{
+	struct irq_desc *desc;
+	struct irq_chip *chip;
+	unsigned int irq;
+	unsigned long flags;
+
+	for (irq = 0; irq < nr_irqs; irq++) {
+		desc = irq_to_desc(irq);
+		if (!desc)
+			continue;
+
+		raw_spin_lock_irqsave(&desc->lock, flags);
+
+		chip = irq_data_get_irq_chip(&desc->irq_data);
+
+		if (chip && chip->irq_cpu_online) {
+			bool enabled = !(desc->istate & IRQS_DISABLED);
+			chip->irq_cpu_online(&desc->irq_data, enabled);
+		}
+
+		raw_spin_unlock_irqrestore(&desc->lock, flags);
+	}
+}
+
+/**
+ *	irq_cpu_offline - Invoke all irq_cpu_offline functions.
+ *
+ *	Iterate through all irqs and invoke the chip.irq_cpu_offline()
+ *	for each.
+ */
+void irq_cpu_offline(void)
+{
+	struct irq_desc *desc;
+	struct irq_chip *chip;
+	unsigned int irq;
+	unsigned long flags;
+
+	for (irq = 0; irq < nr_irqs; irq++) {
+		desc = irq_to_desc(irq);
+		if (!desc)
+			continue;
+
+		raw_spin_lock_irqsave(&desc->lock, flags);
+
+		chip = irq_data_get_irq_chip(&desc->irq_data);
+
+		if (chip && chip->irq_cpu_offline) {
+			bool enabled = !(desc->istate & IRQS_DISABLED);
+			chip->irq_cpu_offline(&desc->irq_data, enabled);
+		}
+
+		raw_spin_unlock_irqrestore(&desc->lock, flags);
+	}
+}
-- 
1.7.2.3

