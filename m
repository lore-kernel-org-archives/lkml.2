Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757463Ab1CYBHH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 21:07:07 -0400
Received: from mail3.caviumnetworks.com ([12.108.191.235]:11499 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755356Ab1CYBHC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 21:07:02 -0400
From: David Daney <ddaney@caviumnetworks.com>
To: tglx@linutronix.de, linux-mips@linux-mips.org
Cc: linux-kernel@vger.kernel.org, David Daney <ddaney@caviumnetworks.com>
Subject: [PATCH v2 2/3] genirq: Split irq_set_affinity() so it can be called with lock held.
Date: Thu, 24 Mar 2011 18:06:37 -0700
Message-Id: <1301015198-25535-3-git-send-email-ddaney@caviumnetworks.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1301015198-25535-1-git-send-email-ddaney@caviumnetworks.com>
References: <1301015198-25535-1-git-send-email-ddaney@caviumnetworks.com>
X-OriginalArrivalTime: 25 Mar 2011 01:07:01.0421 (UTC) FILETIME=[F27225D0:01CBEA88]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The .irq_cpu_online() and .irq_cpu_offline() functions may need to
adjust affinity, but they are called with the descriptor lock held.
Create __irq_set_affinity() which is called with the lock held.  Make
irq_set_affinity() just a wrapper that acquires the lock.

Signed-off-by: David Daney <ddaney@caviumnetworks.com>
---
 include/linux/interrupt.h |    2 ++
 kernel/irq/manage.c       |   40 ++++++++++++++++++++++++++--------------
 2 files changed, 28 insertions(+), 14 deletions(-)

diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index 59b72ca..44548f8 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -229,6 +229,8 @@ static inline int check_wakeup_irqs(void) { return 0; }
 extern cpumask_var_t irq_default_affinity;
 
 extern int irq_set_affinity(unsigned int irq, const struct cpumask *cpumask);
+extern int __irq_set_affinity(struct irq_desc *desc,
+			      const struct cpumask *cpumask);
 extern int irq_can_set_affinity(unsigned int irq);
 extern int irq_select_affinity(unsigned int irq);
 
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 0a2aa73..b7ba026 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -139,24 +139,12 @@ static inline void
 irq_get_pending(struct cpumask *mask, struct irq_desc *desc) { }
 #endif
 
-/**
- *	irq_set_affinity - Set the irq affinity of a given irq
- *	@irq:		Interrupt to set affinity
- *	@cpumask:	cpumask
- *
- */
-int irq_set_affinity(unsigned int irq, const struct cpumask *mask)
+
+int __irq_set_affinity(struct irq_desc *desc, const struct cpumask *mask)
 {
-	struct irq_desc *desc = irq_to_desc(irq);
 	struct irq_chip *chip = desc->irq_data.chip;
-	unsigned long flags;
 	int ret = 0;
 
-	if (!chip->irq_set_affinity)
-		return -EINVAL;
-
-	raw_spin_lock_irqsave(&desc->lock, flags);
-
 	if (irq_can_move_pcntxt(desc)) {
 		ret = chip->irq_set_affinity(&desc->irq_data, mask, false);
 		switch (ret) {
@@ -177,6 +165,30 @@ int irq_set_affinity(unsigned int irq, const struct cpumask *mask)
 	}
 	irq_compat_set_affinity(desc);
 	irqd_set(&desc->irq_data, IRQD_AFFINITY_SET);
+
+	return ret;
+}
+
+/**
+ *	irq_set_affinity - Set the irq affinity of a given irq
+ *	@irq:		Interrupt to set affinity
+ *	@cpumask:	cpumask
+ *
+ */
+int irq_set_affinity(unsigned int irq, const struct cpumask *mask)
+{
+	struct irq_desc *desc = irq_to_desc(irq);
+	struct irq_chip *chip = desc->irq_data.chip;
+	unsigned long flags;
+	int ret;
+
+	if (!chip->irq_set_affinity)
+		return -EINVAL;
+
+	raw_spin_lock_irqsave(&desc->lock, flags);
+
+	ret =  __irq_set_affinity(desc, mask);
+
 	raw_spin_unlock_irqrestore(&desc->lock, flags);
 	return ret;
 }
-- 
1.7.2.3

