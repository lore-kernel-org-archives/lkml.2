Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751850Ab2E2NVR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 09:21:17 -0400
Received: from mga09.intel.com ([134.134.136.24]:43952 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750887Ab2E2NVQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 09:21:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="149736340"
From: Sundar Iyer <sundar.iyer@intel.com>
To: tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, arjan.van.de.ven@intel.com,
        sundar.iyer@intel.com, german.monroy@intel.com
Subject: [PATCH v1] x86/irq: handle chained interrupts during IRQ migration
Date: Tue, 29 May 2012 19:10:08 +0530
Message-Id: <1338298808-2265-1-git-send-email-sundar.iyer@intel.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chained interrupt handlers dont have an irqaction and hence are not
handled during migrating interrupts when some cores go offline.

Handle this by introducing a irq_is_chained() check which is based
on the IRQ_NOREQUEST flag being set for such interrupts. fixup_irq()
can then handle such interrupts and not skip them over.

Signed-off-by: Sundar Iyer <sundar.iyer@intel.com>
---
v1: use accessors instead of new variables to identify chained irqs

 arch/x86/kernel/irq.c   |    6 ++++--
 include/linux/irqdesc.h |   10 ++++++++++
 2 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
index 6c0802e..acd7949 100644
--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -249,8 +249,10 @@ void fixup_irqs(void)
 
 		data = irq_desc_get_irq_data(desc);
 		affinity = data->affinity;
-		if (!irq_has_action(irq) || irqd_is_per_cpu(data) ||
-		    cpumask_subset(affinity, cpu_online_mask)) {
+		/* include IRQs who have no action, but are chained */
+		if ((!irq_has_action(irq) && irq_is_chained(irq)) ||
+			irqd_is_per_cpu(data) ||
+			cpumask_subset(affinity, cpu_online_mask)) {
 			raw_spin_unlock(&desc->lock);
 			continue;
 		}
diff --git a/include/linux/irqdesc.h b/include/linux/irqdesc.h
index 2d921b3..7880722 100644
--- a/include/linux/irqdesc.h
+++ b/include/linux/irqdesc.h
@@ -120,6 +120,16 @@ static inline int irq_has_action(unsigned int irq)
 	return desc->action != NULL;
 }
 
+/*
+ * Test to see if the IRQ is chained; it would not be requested and hence
+ * _IRQ_NOREQUEST would be set
+ */
+static inline int irq_is_chained(unsigned int irq)
+{
+	struct irq_desc *desc = irq_to_desc(irq);
+	return !(desc->status_use_accessors & IRQ_NOREQUEST);
+}
+
 /* caller has locked the irq_desc and both params are valid */
 static inline void __irq_set_handler_locked(unsigned int irq,
 					    irq_flow_handler_t handler)
-- 
1.7.1

