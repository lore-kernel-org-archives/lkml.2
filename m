Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754240Ab2E1MVg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2012 08:21:36 -0400
Received: from mga11.intel.com ([192.55.52.93]:52974 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752508Ab2E1MVe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2012 08:21:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="171974174"
From: Sundar Iyer <sundar.iyer@intel.com>
To: tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, arjan.van.de.ven@intel.com,
        sundar.iyer@intel.com, german.monroy@intel.com
Subject: [PATCH] x86/irq: handle chained interrupts during IRQ migration
Date: Mon, 28 May 2012 18:10:17 +0530
Message-Id: <1338208817-3673-1-git-send-email-sundar.iyer@intel.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

chained interrupt handlers dont have an irqaction and hence
are not handled during migrating interrupts when some cores
go offline.

Handle this by introducing a new flag is_chained in the irq
descriptor; fixup_irq() can then handle such interrupts and not
skip them over.

Signed-off-by: Sundar Iyer <sundar.iyer@intel.com>
---
 arch/x86/kernel/irq.c   |    5 +++--
 include/linux/irqdesc.h |    8 ++++++++
 kernel/irq/chip.c       |    1 +
 3 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
index 6c0802e..29f2f63 100644
--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -249,8 +249,9 @@ void fixup_irqs(void)
 
 		data = irq_desc_get_irq_data(desc);
 		affinity = data->affinity;
-		if (!irq_has_action(irq) || irqd_is_per_cpu(data) ||
-		    cpumask_subset(affinity, cpu_online_mask)) {
+		if ((!irq_has_action(irq) && !irq_is_chained(irq)) ||
+			irqd_is_per_cpu(data) ||
+			cpumask_subset(affinity, cpu_online_mask)) {
 			raw_spin_unlock(&desc->lock);
 			continue;
 		}
diff --git a/include/linux/irqdesc.h b/include/linux/irqdesc.h
index 2d921b3..0c7b474 100644
--- a/include/linux/irqdesc.h
+++ b/include/linux/irqdesc.h
@@ -50,6 +50,7 @@ struct irq_desc {
 	unsigned int		depth;		/* nested irq disables */
 	unsigned int		wake_depth;	/* nested wake enables */
 	unsigned int		irq_count;	/* For detecting broken IRQs */
+	bool			is_chained;	/* for chained handlers */
 	unsigned long		last_unhandled;	/* Aging timer for unhandled count */
 	unsigned int		irqs_unhandled;
 	raw_spinlock_t		lock;
@@ -120,6 +121,13 @@ static inline int irq_has_action(unsigned int irq)
 	return desc->action != NULL;
 }
 
+/* Test to see if driver has chained irq */
+static inline int irq_is_chained(unsigned int irq)
+{
+	struct irq_desc *desc = irq_to_desc(irq);
+	return desc->is_chained;
+}
+
 /* caller has locked the irq_desc and both params are valid */
 static inline void __irq_set_handler_locked(unsigned int irq,
 					    irq_flow_handler_t handler)
diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index dc5114b..56ad59f 100644
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -576,6 +576,7 @@ __irq_set_handler(unsigned int irq, irq_flow_handler_t handle, int is_chained,
 		irq_settings_set_norequest(desc);
 		irq_settings_set_nothread(desc);
 		irq_startup(desc);
+		desc->is_chained = true;
 	}
 out:
 	irq_put_desc_busunlock(desc, flags);
-- 
1.7.1

