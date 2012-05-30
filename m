Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932493Ab2E3JKC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 05:10:02 -0400
Received: from mga14.intel.com ([143.182.124.37]:51508 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932381Ab2E3JKB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 05:10:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="149397859"
From: Sundar Iyer <sundar.iyer@intel.com>
To: tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, lethal@linux-sh.org, arjan@linux.intel.com,
        sundar.iyer@intel.com, german.monroy@intel.com
Subject: [PATCH v2] x86/irq: handle chained interrupts during IRQ migration
Date: Wed, 30 May 2012 14:58:57 +0530
Message-Id: <1338370137-18929-1-git-send-email-sundar.iyer@intel.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chained interrupt handlers dont have an irqaction and hence are not
handled during migrating interrupts when some cores go offline.

Handle this by introducing a irq_is_chained() check which is based
on the the very least NOREQUEST, NOPROBE, and NOTHREAD flags being
set for such interrupts. fixup_irq() can then handle such interrupts
and not skip them over.

Change-Id: I011de8bee98c1702a362deb06106845ca7bcad61
Signed-off-by: Sundar Iyer <sundar.iyer@intel.com>
---
v1: use accessors instead of new variables to identify chained irqs
v2: use a mask of NOREQUEST, NOPROBE, and NOTHREAD accessor flags as per Paul M

 arch/x86/kernel/irq.c   |    6 ++++--
 include/linux/irqdesc.h |   11 +++++++++++
 2 files changed, 15 insertions(+), 2 deletions(-)

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
index 2d921b3..8d5eb42 100644
--- a/include/linux/irqdesc.h
+++ b/include/linux/irqdesc.h
@@ -120,6 +120,17 @@ static inline int irq_has_action(unsigned int irq)
 	return desc->action != NULL;
 }
 
+/*
+ * Test to see if the IRQ is chained; it would not be requested and hence
+ * very miinimum _IRQ_NOREQUEST, _IRQ_NOPROBE, _IRQ_NOTHREAD  would be set
+ */
+static inline int irq_is_chained(unsigned int irq)
+{
+	struct irq_desc *desc = irq_to_desc(irq);
+	return !(desc->status_use_accessors &
+			(IRQ_NOREQUEST | IRQ_NOPROBE | IRQ_NOTHREAD));
+}
+
 /* caller has locked the irq_desc and both params are valid */
 static inline void __irq_set_handler_locked(unsigned int irq,
 					    irq_flow_handler_t handler)
-- 
1.7.1

