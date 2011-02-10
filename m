Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757568Ab1BJXhw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 18:37:52 -0500
Received: from www.tglx.de ([62.245.132.106]:44292 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932153Ab1BJXhm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 18:37:42 -0500
Message-Id: <20110210223258.652746081@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 10 Feb 2011 23:37:35 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: [patch 45/75] genirq: Move IRQ_MASKED to core
References: <20110210222908.661199947@linutronix.de>
Content-Disposition: inline; filename=genirq-move-masked.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Keep status in sync until all users are fixed.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/irq.h    |    2 +-
 kernel/irq/chip.c      |   28 ++++++++++++++++++++--------
 kernel/irq/compat.h    |   11 +++++++++++
 kernel/irq/internals.h |    4 +++-
 kernel/irq/manage.c    |    5 +++--
 kernel/irq/migration.c |    2 +-
 kernel/irq/settings.h  |    2 ++
 7 files changed, 41 insertions(+), 13 deletions(-)

Index: linux-2.6-tip/include/linux/irq.h
===================================================================
--- linux-2.6-tip.orig/include/linux/irq.h
+++ linux-2.6-tip/include/linux/irq.h
@@ -57,11 +57,11 @@ typedef	void (*irq_flow_handler_t)(unsig
 #define IRQ_WAITING		0x00000400	/* DEPRECATED */
 #define IRQ_DISABLED		0x00000800	/* DEPRECATED */
 #define IRQ_PENDING		0x00001000	/* DEPRECATED */
+#define IRQ_MASKED		0x00002000	/* DEPRECATED */
 #endif
 
 
 #define IRQ_LEVEL		0x00004000	/* IRQ level triggered */
-#define IRQ_MASKED		0x00008000	/* IRQ masked - shouldn't be seen again */
 #define IRQ_PER_CPU		0x00010000	/* IRQ is per CPU */
 #define IRQ_NOPROBE		0x00020000	/* IRQ is not valid for probing */
 #define IRQ_NOREQUEST		0x00040000	/* IRQ cannot be requested */
Index: linux-2.6-tip/kernel/irq/chip.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/chip.c
+++ linux-2.6-tip/kernel/irq/chip.c
@@ -202,6 +202,18 @@ static void irq_state_set_disabled(struc
 	irq_compat_set_disabled(desc);
 }
 
+static void irq_state_clr_masked(struct irq_desc *desc)
+{
+	desc->istate &= ~IRQS_MASKED;
+	irq_compat_clr_masked(desc);
+}
+
+static void irq_state_set_masked(struct irq_desc *desc)
+{
+	desc->istate |= IRQS_MASKED;
+	irq_compat_set_masked(desc);
+}
+
 int irq_startup(struct irq_desc *desc)
 {
 	irq_state_clr_disabled(desc);
@@ -209,7 +221,7 @@ int irq_startup(struct irq_desc *desc)
 
 	if (desc->irq_data.chip->irq_startup) {
 		int ret = desc->irq_data.chip->irq_startup(&desc->irq_data);
-		desc->status &= IRQ_MASKED;
+		irq_state_clr_masked(desc);
 		return ret;
 	}
 
@@ -227,7 +239,7 @@ void irq_shutdown(struct irq_desc *desc)
 		desc->irq_data.chip->irq_disable(&desc->irq_data);
 	else
 		desc->irq_data.chip->irq_mask(&desc->irq_data);
-	desc->status |= IRQ_MASKED;
+	irq_state_set_masked(desc);
 }
 
 void irq_enable(struct irq_desc *desc)
@@ -237,7 +249,7 @@ void irq_enable(struct irq_desc *desc)
 		desc->irq_data.chip->irq_enable(&desc->irq_data);
 	else
 		desc->irq_data.chip->irq_unmask(&desc->irq_data);
-	desc->status &= ~IRQ_MASKED;
+	irq_state_clr_masked(desc);
 }
 
 void irq_disable(struct irq_desc *desc)
@@ -245,8 +257,8 @@ void irq_disable(struct irq_desc *desc)
 	irq_state_set_disabled(desc);
 	if (desc->irq_data.chip->irq_disable) {
 		desc->irq_data.chip->irq_disable(&desc->irq_data);
-		desc->status |= IRQ_MASKED;
 	}
+	irq_state_set_masked(desc);
 }
 
 #ifndef CONFIG_GENERIC_HARDIRQS_NO_DEPRECATED
@@ -378,14 +390,14 @@ static inline void mask_ack_irq(struct i
 		if (desc->irq_data.chip->irq_ack)
 			desc->irq_data.chip->irq_ack(&desc->irq_data);
 	}
-	desc->status |= IRQ_MASKED;
+	irq_state_set_masked(desc);
 }
 
 static inline void mask_irq(struct irq_desc *desc)
 {
 	if (desc->irq_data.chip->irq_mask) {
 		desc->irq_data.chip->irq_mask(&desc->irq_data);
-		desc->status |= IRQ_MASKED;
+		irq_state_set_masked(desc);
 	}
 }
 
@@ -393,7 +405,7 @@ static inline void unmask_irq(struct irq
 {
 	if (desc->irq_data.chip->irq_unmask) {
 		desc->irq_data.chip->irq_unmask(&desc->irq_data);
-		desc->status &= ~IRQ_MASKED;
+		irq_state_clr_masked(desc);
 	}
 }
 
@@ -609,7 +621,7 @@ handle_edge_irq(unsigned int irq, struct
 		 */
 		if (unlikely(desc->istate & IRQS_PENDING)) {
 			if (!(desc->istate & IRQS_DISABLED) &&
-			    (desc->status & IRQ_MASKED))
+			    (desc->istate & IRQS_MASKED))
 				unmask_irq(desc);
 		}
 
Index: linux-2.6-tip/kernel/irq/compat.h
===================================================================
--- linux-2.6-tip.orig/kernel/irq/compat.h
+++ linux-2.6-tip/kernel/irq/compat.h
@@ -28,6 +28,15 @@ static inline void irq_compat_clr_pendin
 {
 	desc->status &= ~IRQ_PENDING;
 }
+static inline void irq_compat_set_masked(struct irq_desc *desc)
+{
+	desc->status |= IRQ_MASKED;
+}
+
+static inline void irq_compat_clr_masked(struct irq_desc *desc)
+{
+	desc->status &= ~IRQ_MASKED;
+}
 #else
 static inline void irq_compat_set_progress(struct irq_desc *desc) { }
 static inline void irq_compat_clr_progress(struct irq_desc *desc) { }
@@ -35,5 +44,7 @@ static inline void irq_compat_set_disabl
 static inline void irq_compat_clr_disabled(struct irq_desc *desc) { }
 static inline void irq_compat_set_pending(struct irq_desc *desc) { }
 static inline void irq_compat_clr_pending(struct irq_desc *desc) { }
+static inline void irq_compat_set_masked(struct irq_desc *desc) { }
+static inline void irq_compat_clr_masked(struct irq_desc *desc) { }
 #endif
 
Index: linux-2.6-tip/kernel/irq/internals.h
===================================================================
--- linux-2.6-tip.orig/kernel/irq/internals.h
+++ linux-2.6-tip/kernel/irq/internals.h
@@ -43,6 +43,7 @@ enum {
  * IRQS_WAITING			- irq is waiting
  * IRQS_DISABLED		- irq is disabled
  * IRQS_PENDING			- irq is pending and replayed later
+ * IRQS_MASKED			- irq is masked
  */
 enum {
 	IRQS_AUTODETECT		= 0x00000001,
@@ -55,6 +56,7 @@ enum {
 	IRQS_WAITING		= 0x00000080,
 	IRQS_DISABLED		= 0x00000100,
 	IRQS_PENDING		= 0x00000200,
+	IRQS_MASKED		= 0x00000400,
 };
 
 #define irq_data_to_desc(data)	container_of(data, struct irq_desc, irq_data)
@@ -140,7 +142,6 @@ static inline void print_irq_desc(unsign
 	}
 
 	P(IRQ_LEVEL);
-	P(IRQ_MASKED);
 #ifdef CONFIG_IRQ_PER_CPU
 	P(IRQ_PER_CPU);
 #endif
@@ -154,6 +155,7 @@ static inline void print_irq_desc(unsign
 	PS(IRQS_WAITING);
 	PS(IRQS_DISABLED);
 	PS(IRQS_PENDING);
+	PS(IRQS_MASKED);
 }
 
 #undef P
Index: linux-2.6-tip/kernel/irq/manage.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/manage.c
+++ linux-2.6-tip/kernel/irq/manage.c
@@ -652,8 +652,9 @@ again:
 		goto again;
 	}
 
-	if (!(desc->istate & IRQS_DISABLED) && (desc->status & IRQ_MASKED)) {
-		desc->status &= ~IRQ_MASKED;
+	if (!(desc->istate & IRQS_DISABLED) && (desc->istate & IRQS_MASKED)) {
+		irq_compat_clr_masked(desc);
+		desc->istate &= ~IRQS_MASKED;
 		desc->irq_data.chip->irq_unmask(&desc->irq_data);
 	}
 	raw_spin_unlock_irq(&desc->lock);
Index: linux-2.6-tip/kernel/irq/migration.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/migration.c
+++ linux-2.6-tip/kernel/irq/migration.c
@@ -69,7 +69,7 @@ void move_native_irq(int irq)
 	 * threaded interrupt with ONESHOT set, we can end up with an
 	 * interrupt storm.
 	 */
-	masked = desc->status & IRQ_MASKED;
+	masked = desc->istate & IRQS_MASKED;
 	if (!masked)
 		desc->irq_data.chip->irq_mask(&desc->irq_data);
 	move_masked_irq(irq);
Index: linux-2.6-tip/kernel/irq/settings.h
===================================================================
--- linux-2.6-tip.orig/kernel/irq/settings.h
+++ linux-2.6-tip/kernel/irq/settings.h
@@ -16,3 +16,5 @@ enum {
 #define IRQ_DISABLED		GOT_YOU_MORON
 #undef IRQ_PENDING
 #define IRQ_PENDING		GOT_YOU_MORON
+#undef IRQ_MASKED
+#define IRQ_MASKED		GOT_YOU_MORON


