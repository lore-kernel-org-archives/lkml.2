Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753292Ab1CUMAc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 08:00:32 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:58679 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752335Ab1CUL7w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 07:59:52 -0400
X-Authenticated: #911537
X-Provags-ID: V01U2FsdGVkX1/SfmICjXHS6qbQrb5W23uMtIt3lY2HW4ua56ua3g
	zFDrqmhecrd0OB
From: Torben Hohn <torbenh@gmx.de>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, linuxpps@ml.enneenne.com,
        Torben Hohn <torbenh@gmx.de>
Subject: [PATCH 4/5] RFC genirq: allow dynamic switching of timestamping irqs
Date: Mon, 21 Mar 2011 12:59:19 +0100
Message-Id: <1300708760-27910-4-git-send-email-torbenh@gmx.de>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1300708760-27910-1-git-send-email-torbenh@gmx.de>
References: <1300708760-27910-1-git-send-email-torbenh@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subsystems might want to dynamically switch irq timestamping,
if some subsystem driver requests timestamps.

This patch adds:
void irq_turn_on_timestamping(unsigned int irq, void *dev_id)
void irq_turn_off_timestamping(unsigned int irq, void *dev_id)

Signed-off-by: Torben Hohn <torbenh@gmx.de>
---
 include/linux/interrupt.h |    3 ++
 kernel/irq/manage.c       |   66 +++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 69 insertions(+), 0 deletions(-)

diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index 906b3b6..cc9ed9c 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -175,6 +175,9 @@ request_any_context_irq(unsigned int irq, irq_handler_t handler,
 static inline void exit_irq_thread(void) { }
 #endif
 
+extern void irq_turn_on_timestamping(unsigned int irq, void *dev_id);
+extern void irq_turn_off_timestamping(unsigned int irq, void *dev_id);
+
 extern void free_irq(unsigned int, void *);
 
 struct device;
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index b60350f..66e9501 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -649,6 +649,72 @@ void exit_irq_thread(void)
 }
 
 /*
+ *	irq_turn_on_timestamping - Turn on timestamping for irq line.
+ *	@irq: Interrupt line
+ *	@dev_id: Device Id for which to turn on timestamping.
+ *	         (must point to a struct timespec)
+ *
+ *	Turning on timestamping nests.
+ */
+void irq_turn_on_timestamping(unsigned int irq, void *dev_id)
+{
+	struct irq_desc *desc = irq_to_desc(irq);
+	unsigned long flags;
+	struct irqaction *act;
+
+	raw_spin_lock_irqsave(&desc->lock, flags);
+	desc->status |= IRQ_TIMESTAMP;
+
+	act = desc->action;
+	while (act) {
+		if (act->dev_id == dev_id) {
+			act->flags |= IRQF_TIMESTAMP;
+			break;
+		}
+		act = act->next;
+	}
+
+	BUG_ON( act==NULL );
+
+	raw_spin_unlock_irqrestore(&desc->lock, flags);
+
+	/* maybe we need to synchronise_irq() here ??? */
+}
+EXPORT_SYMBOL_GPL(irq_turn_on_timestamping);
+
+/*
+ *	irq_turn_off_timestamping - Turn off timestamping for irq line.
+ *	@irq: Interrupt line
+ *	@dev_id: Device Id for which to turn off timestamping.
+ *
+ *	Turning on timestamping nests.
+ */
+void irq_turn_off_timestamping(unsigned int irq, void *dev_id)
+{
+	struct irq_desc *desc = irq_to_desc(irq);
+	unsigned long flags;
+	struct irqaction *act;
+	unsigned long irqf_accu = 0;
+
+	raw_spin_lock_irqsave(&desc->lock, flags);
+
+	act = desc->action;
+	while (act) {
+		if (act->dev_id == dev_id) {
+			act->flags &= ~(IRQF_TIMESTAMP);
+		}
+		irqf_accu |= act->flags;
+		act = act->next;
+	}
+
+	if ((irqf_accu & IRQF_TIMESTAMP) == 0)
+		desc->status &= ~(IRQ_TIMESTAMP);
+
+	raw_spin_unlock_irqrestore(&desc->lock, flags);
+}
+EXPORT_SYMBOL_GPL(irq_turn_off_timestamping);
+
+/*
  * Internal function to register an irqaction - typically used to
  * allocate special interrupts that are part of the architecture.
  */
-- 
1.7.2.3

