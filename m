Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757195Ab0JDU3r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 16:29:47 -0400
Received: from hera.kernel.org ([140.211.167.34]:53236 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757000Ab0JDU3p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 16:29:45 -0400
Date: Mon, 4 Oct 2010 20:29:13 GMT
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        peterz@infradead.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20100927121841.645542300@linutronix.de>
References: <20100927121841.645542300@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/core] genirq: Create irq_data
Message-ID: <tip-ff7dcd44dd446db2c3e13bdedf2d52b8e0127f16@git.kernel.org>
Git-Commit-ID: ff7dcd44dd446db2c3e13bdedf2d52b8e0127f16
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 04 Oct 2010 20:29:14 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ff7dcd44dd446db2c3e13bdedf2d52b8e0127f16
Gitweb:     http://git.kernel.org/tip/ff7dcd44dd446db2c3e13bdedf2d52b8e0127f16
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Mon, 27 Sep 2010 12:44:25 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 4 Oct 2010 12:27:16 +0200

genirq: Create irq_data

Low level chip functions need access to irq_desc->handler_data,
irq_desc->chip_data and irq_desc->msi_desc. We hand down the irq
number to the low level functions, so they need to lookup irq_desc.
With sparse irq this means a radix tree lookup.

We could hand down irq_desc itself, but low level chip functions have
no need to fiddle with it directly and we want to restrict access to
irq_desc further.

Preparatory patch for new chip functions.

Note, that the ugly anon union/struct is there to avoid a full tree
wide clean up for now. This is not going to last 3 years like __do_IRQ()

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
LKML-Reference: <20100927121841.645542300@linutronix.de>
Reviewed-by: H. Peter Anvin <hpa@zytor.com>
Reviewed-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/irq.h |   90 +++++++++++++++++++++++++++++++++++---------------
 kernel/irq/handle.c |   39 +++++++++++-----------
 2 files changed, 82 insertions(+), 47 deletions(-)

diff --git a/include/linux/irq.h b/include/linux/irq.h
index 06273a2..363c76f 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -84,6 +84,37 @@ struct proc_dir_entry;
 struct msi_desc;
 
 /**
+ * struct irq_data - per irq and irq chip data passed down to chip functions
+ * @irq:		interrupt number
+ * @node:		node index useful for balancing
+ * @chip:		low level interrupt hardware access
+ * @handler_data:	per-IRQ data for the irq_chip methods
+ * @chip_data:		platform-specific per-chip private data for the chip
+ *			methods, to allow shared chip implementations
+ * @msi_desc:		MSI descriptor
+ * @affinity:		IRQ affinity on SMP
+ * @irq_2_iommu:	iommu with this irq
+ *
+ * The fields here need to overlay the ones in irq_desc until we
+ * cleaned up the direct references and switched everything over to
+ * irq_data.
+ */
+struct irq_data {
+	unsigned int		irq;
+	unsigned int		node;
+	struct irq_chip		*chip;
+	void			*handler_data;
+	void			*chip_data;
+	struct msi_desc		*msi_desc;
+#ifdef CONFIG_SMP
+	cpumask_var_t		affinity;
+#endif
+#ifdef CONFIG_INTR_REMAP
+	struct irq_2_iommu      *irq_2_iommu;
+#endif
+};
+
+/**
  * struct irq_chip - hardware interrupt chip descriptor
  *
  * @name:		name for /proc/interrupts
@@ -140,16 +171,10 @@ struct timer_rand_state;
 struct irq_2_iommu;
 /**
  * struct irq_desc - interrupt descriptor
- * @irq:		interrupt number for this descriptor
+ * @irq_data:		per irq and chip data passed down to chip functions
  * @timer_rand_state:	pointer to timer rand state struct
  * @kstat_irqs:		irq stats per cpu
- * @irq_2_iommu:	iommu with this irq
  * @handle_irq:		highlevel irq-events handler [if NULL, __do_IRQ()]
- * @chip:		low level interrupt hardware access
- * @msi_desc:		MSI descriptor
- * @handler_data:	per-IRQ data for the irq_chip methods
- * @chip_data:		platform-specific per-chip private data for the chip
- *			methods, to allow shared chip implementations
  * @action:		the irq action chain
  * @status:		status information
  * @depth:		disable-depth, for nested irq_disable() calls
@@ -158,8 +183,6 @@ struct irq_2_iommu;
  * @last_unhandled:	aging timer for unhandled count
  * @irqs_unhandled:	stats field for spurious unhandled interrupts
  * @lock:		locking for SMP
- * @affinity:		IRQ affinity on SMP
- * @node:		node index useful for balancing
  * @pending_mask:	pending rebalanced interrupts
  * @threads_active:	number of irqaction threads currently running
  * @wait_for_threads:	wait queue for sync_irq to wait for threaded handlers
@@ -167,17 +190,32 @@ struct irq_2_iommu;
  * @name:		flow handler name for /proc/interrupts output
  */
 struct irq_desc {
-	unsigned int		irq;
-	struct timer_rand_state *timer_rand_state;
-	unsigned int            *kstat_irqs;
+
+	/*
+	 * This union will go away, once we fixed the direct access to
+	 * irq_desc all over the place. The direct fields are a 1:1
+	 * overlay of irq_data.
+	 */
+	union {
+		struct irq_data		irq_data;
+		struct {
+			unsigned int		irq;
+			unsigned int		node;
+			struct irq_chip		*chip;
+			void			*handler_data;
+			void			*chip_data;
+			struct msi_desc		*msi_desc;
+#ifdef CONFIG_SMP
+			cpumask_var_t		affinity;
+#endif
 #ifdef CONFIG_INTR_REMAP
-	struct irq_2_iommu      *irq_2_iommu;
+			struct irq_2_iommu      *irq_2_iommu;
 #endif
+		};
+	};
+	struct timer_rand_state *timer_rand_state;
+	unsigned int            *kstat_irqs;
 	irq_flow_handler_t	handle_irq;
-	struct irq_chip		*chip;
-	struct msi_desc		*msi_desc;
-	void			*handler_data;
-	void			*chip_data;
 	struct irqaction	*action;	/* IRQ action list */
 	unsigned int		status;		/* IRQ status */
 
@@ -188,9 +226,7 @@ struct irq_desc {
 	unsigned int		irqs_unhandled;
 	raw_spinlock_t		lock;
 #ifdef CONFIG_SMP
-	cpumask_var_t		affinity;
 	const struct cpumask	*affinity_hint;
-	unsigned int		node;
 #ifdef CONFIG_GENERIC_PENDING_IRQ
 	cpumask_var_t		pending_mask;
 #endif
@@ -406,15 +442,15 @@ extern int set_irq_chip_data(unsigned int irq, void *data);
 extern int set_irq_type(unsigned int irq, unsigned int type);
 extern int set_irq_msi(unsigned int irq, struct msi_desc *entry);
 
-#define get_irq_chip(irq)	(irq_to_desc(irq)->chip)
-#define get_irq_chip_data(irq)	(irq_to_desc(irq)->chip_data)
-#define get_irq_data(irq)	(irq_to_desc(irq)->handler_data)
-#define get_irq_msi(irq)	(irq_to_desc(irq)->msi_desc)
+#define get_irq_chip(irq)	(irq_to_desc(irq)->irq_data.chip)
+#define get_irq_chip_data(irq)	(irq_to_desc(irq)->irq_data.chip_data)
+#define get_irq_data(irq)	(irq_to_desc(irq)->irq_data.handler_data)
+#define get_irq_msi(irq)	(irq_to_desc(irq)->irq_data.msi_desc)
 
-#define get_irq_desc_chip(desc)		((desc)->chip)
-#define get_irq_desc_chip_data(desc)	((desc)->chip_data)
-#define get_irq_desc_data(desc)		((desc)->handler_data)
-#define get_irq_desc_msi(desc)		((desc)->msi_desc)
+#define get_irq_desc_chip(desc)		((desc)->irq_data.chip)
+#define get_irq_desc_chip_data(desc)	((desc)->irq_data.chip_data)
+#define get_irq_desc_data(desc)		((desc)->irq_data.handler_data)
+#define get_irq_desc_msi(desc)		((desc)->irq_data.msi_desc)
 
 #endif /* CONFIG_GENERIC_HARDIRQS */
 
diff --git a/kernel/irq/handle.c b/kernel/irq/handle.c
index 27e5c69..099d4fc 100644
--- a/kernel/irq/handle.c
+++ b/kernel/irq/handle.c
@@ -75,12 +75,10 @@ EXPORT_SYMBOL_GPL(nr_irqs);
 #ifdef CONFIG_SPARSE_IRQ
 
 static struct irq_desc irq_desc_init = {
-	.irq	    = -1,
-	.status	    = IRQ_DISABLED,
-	.chip	    = &no_irq_chip,
-	.handle_irq = handle_bad_irq,
-	.depth      = 1,
-	.lock       = __RAW_SPIN_LOCK_UNLOCKED(irq_desc_init.lock),
+	.status		= IRQ_DISABLED,
+	.handle_irq	= handle_bad_irq,
+	.depth		= 1,
+	.lock		= __RAW_SPIN_LOCK_UNLOCKED(irq_desc_init.lock),
 };
 
 void __ref init_kstat_irqs(struct irq_desc *desc, int node, int nr)
@@ -105,7 +103,7 @@ static void init_one_irq_desc(int irq, struct irq_desc *desc, int node)
 	memcpy(desc, &irq_desc_init, sizeof(struct irq_desc));
 
 	raw_spin_lock_init(&desc->lock);
-	desc->irq = irq;
+	desc->irq_data.irq = irq;
 #ifdef CONFIG_SMP
 	desc->node = node;
 #endif
@@ -151,12 +149,10 @@ void replace_irq_desc(unsigned int irq, struct irq_desc *desc)
 
 static struct irq_desc irq_desc_legacy[NR_IRQS_LEGACY] __cacheline_aligned_in_smp = {
 	[0 ... NR_IRQS_LEGACY-1] = {
-		.irq	    = -1,
-		.status	    = IRQ_DISABLED,
-		.chip	    = &no_irq_chip,
-		.handle_irq = handle_bad_irq,
-		.depth	    = 1,
-		.lock	    = __RAW_SPIN_LOCK_UNLOCKED(irq_desc_init.lock),
+		.status		= IRQ_DISABLED,
+		.handle_irq	= handle_bad_irq,
+		.depth		= 1,
+		.lock		= __RAW_SPIN_LOCK_UNLOCKED(irq_desc_init.lock),
 	}
 };
 
@@ -183,8 +179,11 @@ int __init early_irq_init(void)
 	kstat_irqs_legacy = kzalloc_node(NR_IRQS_LEGACY * nr_cpu_ids *
 					  sizeof(int), GFP_NOWAIT, node);
 
+	irq_desc_init.irq_data.chip = &no_irq_chip;
+
 	for (i = 0; i < legacy_count; i++) {
-		desc[i].irq = i;
+		desc[i].irq_data.irq = i;
+		desc[i].irq_data.chip = &no_irq_chip;
 #ifdef CONFIG_SMP
 		desc[i].node = node;
 #endif
@@ -241,11 +240,10 @@ out_unlock:
 
 struct irq_desc irq_desc[NR_IRQS] __cacheline_aligned_in_smp = {
 	[0 ... NR_IRQS-1] = {
-		.status = IRQ_DISABLED,
-		.chip = &no_irq_chip,
-		.handle_irq = handle_bad_irq,
-		.depth = 1,
-		.lock = __RAW_SPIN_LOCK_UNLOCKED(irq_desc->lock),
+		.status		= IRQ_DISABLED,
+		.handle_irq	= handle_bad_irq,
+		.depth		= 1,
+		.lock		= __RAW_SPIN_LOCK_UNLOCKED(irq_desc->lock),
 	}
 };
 
@@ -264,7 +262,8 @@ int __init early_irq_init(void)
 	count = ARRAY_SIZE(irq_desc);
 
 	for (i = 0; i < count; i++) {
-		desc[i].irq = i;
+		desc[i].irq_data.irq = i;
+		desc[i].irq_data.chip = &no_irq_chip;
 		alloc_desc_masks(&desc[i], 0, true);
 		init_desc_masks(&desc[i]);
 		desc[i].kstat_irqs = kstat_irqs_all[i];
