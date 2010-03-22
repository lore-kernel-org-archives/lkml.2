Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753946Ab0CVBjo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Mar 2010 21:39:44 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:28408 "EHLO
	rcsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753891Ab0CVBjk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Mar 2010 21:39:40 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 08/10] genericirq: add set_irq_desc_chip/data ...
Date: Sun, 21 Mar 2010 18:36:08 -0700
Message-Id: <1269221770-9667-9-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1269221770-9667-1-git-send-email-yinghai@kernel.org>
References: <1269221770-9667-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4BA6CA3A.0076,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

with set_irq_chip/data...

to take desc instead of irq

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/kernel/apic/io_apic.c |    4 +-
 include/linux/irq.h            |   10 +++-
 include/linux/irqnr.h          |    1 +
 kernel/irq/chip.c              |  127 +++++++++++++++++++++++-----------------
 4 files changed, 85 insertions(+), 57 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index f908af5..432bea1 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -3302,7 +3302,7 @@ unsigned int create_irq_nr(unsigned int irq_want, int node)
 	raw_spin_unlock_irqrestore(&vector_lock, flags);
 
 	if (irq > 0)
-		dynamic_irq_init_keep_chip_data(irq);
+		dynamic_irq_init_keep_chip_data(irq_to_desc(irq));
 
 	return irq;
 }
@@ -3328,7 +3328,7 @@ void destroy_irq(unsigned int irq)
 	struct irq_desc *desc;
 	struct irq_cfg *cfg;
 
-	dynamic_irq_cleanup_keep_chip_data(irq);
+	dynamic_irq_cleanup_keep_chip_data(irq_to_desc(irq));
 
 	free_irte(irq);
 	raw_spin_lock_irqsave(&vector_lock, flags);
diff --git a/include/linux/irq.h b/include/linux/irq.h
index 36ea6ac..1f5d112 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -420,9 +420,9 @@ static inline int irq_has_action(unsigned int irq)
 
 /* Dynamic irq helper functions */
 extern void dynamic_irq_init(unsigned int irq);
-void dynamic_irq_init_keep_chip_data(unsigned int irq);
+void dynamic_irq_init_keep_chip_data(struct irq_desc *desc);
 extern void dynamic_irq_cleanup(unsigned int irq);
-void dynamic_irq_cleanup_keep_chip_data(unsigned int irq);
+void dynamic_irq_cleanup_keep_chip_data(struct irq_desc *desc);
 
 /* Set/get chip/data for an IRQ: */
 extern int set_irq_chip(unsigned int irq, struct irq_chip *chip);
@@ -431,6 +431,12 @@ extern int set_irq_chip_data(unsigned int irq, void *data);
 extern int set_irq_type(unsigned int irq, unsigned int type);
 extern int set_irq_msi(unsigned int irq, struct msi_desc *entry);
 
+int set_irq_desc_chip(struct irq_desc *desc, struct irq_chip *chip);
+int set_irq_desc_data(struct irq_desc *desc, void *data);
+int set_irq_desc_chip_data(struct irq_desc *desc, void *data);
+int set_irq_desc_type(struct irq_desc *desc, unsigned int type);
+int set_irq_desc_msi(struct irq_desc *desc, struct msi_desc *entry);
+
 #define get_irq_chip(irq)	(irq_to_desc(irq)->chip)
 #define get_irq_chip_data(irq)	(irq_to_desc(irq)->chip_data)
 #define get_irq_data(irq)	(irq_to_desc(irq)->handler_data)
diff --git a/include/linux/irqnr.h b/include/linux/irqnr.h
index 7bf89bc..dee8f2b 100644
--- a/include/linux/irqnr.h
+++ b/include/linux/irqnr.h
@@ -43,6 +43,7 @@ extern struct irq_desc *irq_to_desc(unsigned int irq);
 
 #ifdef CONFIG_SMP
 #define irq_node(irq)	(irq_to_desc(irq)->node)
+#define irq_desc_node(desc) ((desc)->node)
 #else
 #define irq_node(irq)	0
 #endif
diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index 190360d..6725334 100644
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -18,17 +18,10 @@
 
 #include "internals.h"
 
-static void dynamic_irq_init_x(unsigned int irq, bool keep_chip_data)
+static void dynamic_irq_init_x(struct irq_desc *desc, bool keep_chip_data)
 {
-	struct irq_desc *desc;
 	unsigned long flags;
 
-	desc = irq_to_desc(irq);
-	if (!desc) {
-		WARN(1, KERN_ERR "Trying to initialize invalid IRQ%d\n", irq);
-		return;
-	}
-
 	/* Ensure we don't have left over values from a previous use of this irq */
 	raw_spin_lock_irqsave(&desc->lock, flags);
 	desc->status = IRQ_DISABLED;
@@ -57,7 +50,15 @@ static void dynamic_irq_init_x(unsigned int irq, bool keep_chip_data)
  */
 void dynamic_irq_init(unsigned int irq)
 {
-	dynamic_irq_init_x(irq, false);
+	struct irq_desc *desc;
+
+	desc = irq_to_desc(irq);
+	if (!desc) {
+		WARN(1, KERN_ERR "Trying to initialize invalid IRQ%d\n", irq);
+		return;
+	}
+
+	dynamic_irq_init_x(desc, false);
 }
 
 /**
@@ -66,26 +67,20 @@ void dynamic_irq_init(unsigned int irq)
  *
  *	does not set irq_to_desc(irq)->chip_data to NULL
  */
-void dynamic_irq_init_keep_chip_data(unsigned int irq)
+void dynamic_irq_init_keep_chip_data(struct irq_desc *desc)
 {
-	dynamic_irq_init_x(irq, true);
+	dynamic_irq_init_x(desc, true);
 }
 
-static void dynamic_irq_cleanup_x(unsigned int irq, bool keep_chip_data)
+static void dynamic_irq_cleanup_x(struct irq_desc *desc, bool keep_chip_data)
 {
-	struct irq_desc *desc = irq_to_desc(irq);
 	unsigned long flags;
 
-	if (!desc) {
-		WARN(1, KERN_ERR "Trying to cleanup invalid IRQ%d\n", irq);
-		return;
-	}
-
 	raw_spin_lock_irqsave(&desc->lock, flags);
 	if (desc->action) {
 		raw_spin_unlock_irqrestore(&desc->lock, flags);
 		WARN(1, KERN_ERR "Destroying IRQ%d without calling free_irq\n",
-			irq);
+			desc->irq);
 		return;
 	}
 	desc->msi_desc = NULL;
@@ -105,7 +100,14 @@ static void dynamic_irq_cleanup_x(unsigned int irq, bool keep_chip_data)
  */
 void dynamic_irq_cleanup(unsigned int irq)
 {
-	dynamic_irq_cleanup_x(irq, false);
+	struct irq_desc *desc = irq_to_desc(irq);
+
+	if (!desc) {
+		WARN(1, KERN_ERR "Trying to cleanup invalid IRQ%d\n", irq);
+		return;
+	}
+
+	dynamic_irq_cleanup_x(desc, false);
 }
 
 /**
@@ -114,9 +116,9 @@ void dynamic_irq_cleanup(unsigned int irq)
  *
  *	does not set irq_to_desc(irq)->chip_data to NULL
  */
-void dynamic_irq_cleanup_keep_chip_data(unsigned int irq)
+void dynamic_irq_cleanup_keep_chip_data(struct irq_desc *desc)
 {
-	dynamic_irq_cleanup_x(irq, true);
+	dynamic_irq_cleanup_x(desc, true);
 }
 
 
@@ -152,26 +154,31 @@ EXPORT_SYMBOL(set_irq_chip);
  *	@irq:	irq number
  *	@type:	IRQ_TYPE_{LEVEL,EDGE}_* value - see include/linux/irq.h
  */
-int set_irq_type(unsigned int irq, unsigned int type)
+int set_irq_desc_type(struct irq_desc *desc, unsigned int type)
 {
-	struct irq_desc *desc = irq_to_desc(irq);
 	unsigned long flags;
 	int ret = -ENXIO;
 
-	if (!desc) {
-		printk(KERN_ERR "Trying to set irq type for IRQ%d\n", irq);
-		return -ENODEV;
-	}
-
 	type &= IRQ_TYPE_SENSE_MASK;
 	if (type == IRQ_TYPE_NONE)
 		return 0;
 
 	raw_spin_lock_irqsave(&desc->lock, flags);
-	ret = __irq_set_trigger(desc, irq, type);
+	ret = __irq_set_trigger(desc, desc->irq, type);
 	raw_spin_unlock_irqrestore(&desc->lock, flags);
 	return ret;
 }
+int set_irq_type(unsigned int irq, unsigned int type)
+{
+	struct irq_desc *desc = irq_to_desc(irq);
+
+	if (!desc) {
+		printk(KERN_ERR "Trying to set irq type for IRQ%d\n", irq);
+		return -ENODEV;
+	}
+
+	return set_irq_desc_type(desc, type);
+}
 EXPORT_SYMBOL(set_irq_type);
 
 /**
@@ -181,10 +188,18 @@ EXPORT_SYMBOL(set_irq_type);
  *
  *	Set the hardware irq controller data for an irq
  */
+int set_irq_desc_data(struct irq_desc *desc, void *data)
+{
+	unsigned long flags;
+
+	raw_spin_lock_irqsave(&desc->lock, flags);
+	desc->handler_data = data;
+	raw_spin_unlock_irqrestore(&desc->lock, flags);
+	return 0;
+}
 int set_irq_data(unsigned int irq, void *data)
 {
 	struct irq_desc *desc = irq_to_desc(irq);
-	unsigned long flags;
 
 	if (!desc) {
 		printk(KERN_ERR
@@ -192,10 +207,7 @@ int set_irq_data(unsigned int irq, void *data)
 		return -EINVAL;
 	}
 
-	raw_spin_lock_irqsave(&desc->lock, flags);
-	desc->handler_data = data;
-	raw_spin_unlock_irqrestore(&desc->lock, flags);
-	return 0;
+	return set_irq_desc_data(desc, data);
 }
 EXPORT_SYMBOL(set_irq_data);
 
@@ -206,24 +218,28 @@ EXPORT_SYMBOL(set_irq_data);
  *
  *	Set the MSI descriptor entry for an irq
  */
-int set_irq_msi(unsigned int irq, struct msi_desc *entry)
+int set_irq_desc_msi(struct irq_desc *desc, struct msi_desc *entry)
 {
-	struct irq_desc *desc = irq_to_desc(irq);
 	unsigned long flags;
 
-	if (!desc) {
-		printk(KERN_ERR
-		       "Trying to install msi data for IRQ%d\n", irq);
-		return -EINVAL;
-	}
-
 	raw_spin_lock_irqsave(&desc->lock, flags);
 	desc->msi_desc = entry;
 	if (entry)
-		entry->irq = irq;
+		entry->irq = desc->irq;
 	raw_spin_unlock_irqrestore(&desc->lock, flags);
 	return 0;
 }
+int set_irq_msi(unsigned int irq, struct msi_desc *entry)
+{
+	struct irq_desc *desc = irq_to_desc(irq);
+	if (!desc) {
+		printk(KERN_ERR
+		       "Trying to install msi data for IRQ%d\n", desc->irq);
+		return -EINVAL;
+	}
+
+	return set_irq_desc_msi(desc, entry);
+}
 
 /**
  *	set_irq_chip_data - set irq chip data for an irq
@@ -232,19 +248,12 @@ int set_irq_msi(unsigned int irq, struct msi_desc *entry)
  *
  *	Set the hardware irq chip data for an irq
  */
-int set_irq_chip_data(unsigned int irq, void *data)
+int set_irq_desc_chip_data(struct irq_desc *desc, void *data)
 {
-	struct irq_desc *desc = irq_to_desc(irq);
 	unsigned long flags;
 
-	if (!desc) {
-		printk(KERN_ERR
-		       "Trying to install chip data for IRQ%d\n", irq);
-		return -EINVAL;
-	}
-
 	if (!desc->chip) {
-		printk(KERN_ERR "BUG: bad set_irq_chip_data(IRQ#%d)\n", irq);
+		printk(KERN_ERR "BUG: bad set_irq_chip_data(IRQ#%d)\n", desc->irq);
 		return -EINVAL;
 	}
 
@@ -254,6 +263,18 @@ int set_irq_chip_data(unsigned int irq, void *data)
 
 	return 0;
 }
+int set_irq_chip_data(unsigned int irq, void *data)
+{
+	struct irq_desc *desc = irq_to_desc(irq);
+
+	if (!desc) {
+		printk(KERN_ERR
+		       "Trying to install chip data for IRQ%d\n", irq);
+		return -EINVAL;
+	}
+
+	return set_irq_desc_chip_data(desc, data);
+}
 EXPORT_SYMBOL(set_irq_chip_data);
 
 /**
-- 
1.6.4.2

