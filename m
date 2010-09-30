Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754641Ab0I3XPo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 19:15:44 -0400
Received: from www.tglx.de ([62.245.132.106]:52407 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751348Ab0I3XPl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 19:15:41 -0400
Message-Id: <20100930221739.270853420@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 30 Sep 2010 23:15:17 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-arch@vger.kernel.org, Linus Torvalds <torvalds@osdl.org>,
        Andrew Morton <akpm@linux-foundation.org>, x86@kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mundt <lethal@linux-sh.org>,
        Russell King <linux@arm.linux.org.uk>,
        David Woodhouse <dwmw2@infradead.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Yinghai Lu <yinghai@kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [patch 08/47] genirq: Move core only inlines to kernel/irq
References: <20100930221351.682772535@linutronix.de>
Content-Disposition: inline; filename=genirq-move-core-private-inlines.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Only used by core code. No need to publish those.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/irq.h    |   95 -------------------------------------------------
 kernel/irq/internals.h |   78 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 78 insertions(+), 95 deletions(-)

Index: linux-2.6-tip/include/linux/irq.h
===================================================================
--- linux-2.6-tip.orig/include/linux/irq.h
+++ linux-2.6-tip/include/linux/irq.h
@@ -519,99 +519,4 @@ static inline void set_irq_desc_chip_dat
 
 #endif /* !CONFIG_S390 */
 
-#ifdef CONFIG_SMP
-/**
- * alloc_desc_masks - allocate cpumasks for irq_desc
- * @desc:	pointer to irq_desc struct
- * @node:	node which will be handling the cpumasks
- * @boot:	true if need bootmem
- *
- * Allocates affinity and pending_mask cpumask if required.
- * Returns true if successful (or not required).
- */
-static inline bool alloc_desc_masks(struct irq_desc *desc, int node,
-							bool boot)
-{
-	gfp_t gfp = GFP_ATOMIC;
-
-	if (boot)
-		gfp = GFP_NOWAIT;
-
-#ifdef CONFIG_CPUMASK_OFFSTACK
-	if (!alloc_cpumask_var_node(&desc->affinity, gfp, node))
-		return false;
-
-#ifdef CONFIG_GENERIC_PENDING_IRQ
-	if (!alloc_cpumask_var_node(&desc->pending_mask, gfp, node)) {
-		free_cpumask_var(desc->affinity);
-		return false;
-	}
-#endif
-#endif
-	return true;
-}
-
-static inline void init_desc_masks(struct irq_desc *desc)
-{
-	cpumask_setall(desc->affinity);
-#ifdef CONFIG_GENERIC_PENDING_IRQ
-	cpumask_clear(desc->pending_mask);
-#endif
-}
-
-/**
- * init_copy_desc_masks - copy cpumasks for irq_desc
- * @old_desc:	pointer to old irq_desc struct
- * @new_desc:	pointer to new irq_desc struct
- *
- * Insures affinity and pending_masks are copied to new irq_desc.
- * If !CONFIG_CPUMASKS_OFFSTACK the cpumasks are embedded in the
- * irq_desc struct so the copy is redundant.
- */
-
-static inline void init_copy_desc_masks(struct irq_desc *old_desc,
-					struct irq_desc *new_desc)
-{
-#ifdef CONFIG_CPUMASK_OFFSTACK
-	cpumask_copy(new_desc->affinity, old_desc->affinity);
-
-#ifdef CONFIG_GENERIC_PENDING_IRQ
-	cpumask_copy(new_desc->pending_mask, old_desc->pending_mask);
-#endif
-#endif
-}
-
-static inline void free_desc_masks(struct irq_desc *old_desc,
-				   struct irq_desc *new_desc)
-{
-	free_cpumask_var(old_desc->affinity);
-
-#ifdef CONFIG_GENERIC_PENDING_IRQ
-	free_cpumask_var(old_desc->pending_mask);
-#endif
-}
-
-#else /* !CONFIG_SMP */
-
-static inline bool alloc_desc_masks(struct irq_desc *desc, int node,
-								bool boot)
-{
-	return true;
-}
-
-static inline void init_desc_masks(struct irq_desc *desc)
-{
-}
-
-static inline void init_copy_desc_masks(struct irq_desc *old_desc,
-					struct irq_desc *new_desc)
-{
-}
-
-static inline void free_desc_masks(struct irq_desc *old_desc,
-				   struct irq_desc *new_desc)
-{
-}
-#endif	/* CONFIG_SMP */
-
 #endif /* _LINUX_IRQ_H */
Index: linux-2.6-tip/kernel/irq/internals.h
===================================================================
--- linux-2.6-tip.orig/kernel/irq/internals.h
+++ linux-2.6-tip/kernel/irq/internals.h
@@ -58,6 +58,84 @@ static inline struct irq_desc *irq_data_
 	return container_of(data, struct irq_desc, irq_data);
 }
 
+#ifdef CONFIG_SMP
+/**
+ * alloc_desc_masks - allocate cpumasks for irq_desc
+ * @desc:	pointer to irq_desc struct
+ * @node:	node which will be handling the cpumasks
+ * @boot:	true if need bootmem
+ *
+ * Allocates affinity and pending_mask cpumask if required.
+ * Returns true if successful (or not required).
+ */
+static inline bool alloc_desc_masks(struct irq_desc *desc, int node,
+							bool boot)
+{
+#ifdef CONFIG_CPUMASK_OFFSTACK
+	gfp_t gfp = boot ? GFP_NOWAIT : GFP_ATOMIC;
+
+	if (!alloc_cpumask_var_node(&desc->affinity, gfp, node))
+		return false;
+
+#ifdef CONFIG_GENERIC_PENDING_IRQ
+	if (!alloc_cpumask_var_node(&desc->pending_mask, gfp, node)) {
+		free_cpumask_var(desc->affinity);
+		return false;
+	}
+#endif
+#endif
+	return true;
+}
+
+static inline void init_desc_masks(struct irq_desc *desc)
+{
+	cpumask_setall(desc->affinity);
+#ifdef CONFIG_GENERIC_PENDING_IRQ
+	cpumask_clear(desc->pending_mask);
+#endif
+}
+
+/**
+ * init_copy_desc_masks - copy cpumasks for irq_desc
+ * @old_desc:	pointer to old irq_desc struct
+ * @new_desc:	pointer to new irq_desc struct
+ *
+ * Insures affinity and pending_masks are copied to new irq_desc.
+ * If !CONFIG_CPUMASKS_OFFSTACK the cpumasks are embedded in the
+ * irq_desc struct so the copy is redundant.
+ */
+
+static inline void init_copy_desc_masks(struct irq_desc *old_desc,
+					struct irq_desc *new_desc)
+{
+#ifdef CONFIG_CPUMASK_OFFSTACK
+	cpumask_copy(new_desc->affinity, old_desc->affinity);
+
+#ifdef CONFIG_GENERIC_PENDING_IRQ
+	cpumask_copy(new_desc->pending_mask, old_desc->pending_mask);
+#endif
+#endif
+}
+
+static inline void free_desc_masks(struct irq_desc *old_desc,
+				   struct irq_desc *new_desc)
+{
+	free_cpumask_var(old_desc->affinity);
+#ifdef CONFIG_GENERIC_PENDING_IRQ
+	free_cpumask_var(old_desc->pending_mask);
+#endif
+}
+
+#else /* !CONFIG_SMP */
+static inline bool alloc_desc_masks(struct irq_desc *desc, int node, bool boot)
+{
+	return true;
+}
+static inline void init_desc_masks(struct irq_desc *desc) { }
+static inline void init_copy_desc_masks(struct irq_desc *o, struct irq_desc *n) { }
+static inline void free_desc_masks(struct irq_desc *o, struct irq_desc *n) { }
+#endif	/* CONFIG_SMP */
+
 /*
  * Debugging printout:
  */


