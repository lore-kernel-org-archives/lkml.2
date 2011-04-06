Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755713Ab1DFVCK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 17:02:10 -0400
Received: from linux-sh.org ([111.68.239.195]:43260 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754838Ab1DFVCI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 17:02:08 -0400
Date: Thu, 7 Apr 2011 06:01:44 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] genirq: Support per-IRQ thread disabling.
Message-ID: <20110406210135.GF18426@linux-sh.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds support for disabling threading on a per-IRQ basis via the IRQ
status instead of the IRQ flow, which is necessary for interrupts that
don't follow the natural IRQ flow channels, such as those that are
virtually created.

The new APIs added are simply:

	irq_set_thread()
	irq_set_nothread()

which follow the rest of the IRQ status routines.

Chained handlers also have IRQ_NOTHREAD set on them automatically, making
the lack of threading explicit rather than implicit. Subsequently, the
nothread flag can be viewed through the standard genirq debugging
facilities.

Signed-off-by: Paul Mundt <lethal@linux-sh.org>

---

This is a requirement for forced threading on SH, which needs to mark its
virtual IRQs as NOTHREAD.

 include/linux/irq.h   |   14 +++++++++++++-
 kernel/irq/chip.c     |    1 +
 kernel/irq/debug.h    |    1 +
 kernel/irq/manage.c   |    3 ++-
 kernel/irq/settings.h |   17 +++++++++++++++++
 5 files changed, 34 insertions(+), 2 deletions(-)

diff --git a/include/linux/irq.h b/include/linux/irq.h
index 09a3080..4f7c756 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -59,6 +59,7 @@ typedef	void (*irq_preflow_handler_t)(struct irq_data *data);
  * IRQ_NOPROBE			- Interrupt cannot be probed by autoprobing
  * IRQ_NOREQUEST		- Interrupt cannot be requested via
  *				  request_irq()
+ * IRQ_NOTHREAD			- Interrupt cannot be threaded
  * IRQ_NOAUTOEN			- Interrupt is not automatically enabled in
  *				  request/setup_irq()
  * IRQ_NO_BALANCING		- Interrupt cannot be balanced (affinity set)
@@ -85,6 +86,7 @@ enum {
 	IRQ_NO_BALANCING	= (1 << 13),
 	IRQ_MOVE_PCNTXT		= (1 << 14),
 	IRQ_NESTED_THREAD	= (1 << 15),
+	IRQ_NOTHREAD		= (1 << 16),
 };
 
 #define IRQF_MODIFY_MASK	\
@@ -439,7 +441,7 @@ irq_set_handler(unsigned int irq, irq_flow_handler_t handle)
 /*
  * Set a highlevel chained flow handler for a given IRQ.
  * (a chained handler is automatically enabled and set to
- *  IRQ_NOREQUEST and IRQ_NOPROBE)
+ *  IRQ_NOREQUEST, IRQ_NOPROBE, and IRQ_NOTHREAD)
  */
 static inline void
 irq_set_chained_handler(unsigned int irq, irq_flow_handler_t handle)
@@ -469,6 +471,16 @@ static inline void irq_set_probe(unsigned int irq)
 	irq_modify_status(irq, IRQ_NOPROBE, 0);
 }
 
+static inline void irq_set_nothread(unsigned int irq)
+{
+	irq_modify_status(irq, 0, IRQ_NOTHREAD);
+}
+
+static inline void irq_set_thread(unsigned int irq)
+{
+	irq_modify_status(irq, IRQ_NOTHREAD, 0);
+}
+
 static inline void irq_set_nested_thread(unsigned int irq, bool nest)
 {
 	if (nest)
diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index 1dafc86..df234b7 100644
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -573,6 +573,7 @@ __irq_set_handler(unsigned int irq, irq_flow_handler_t handle, int is_chained,
 	if (handle != handle_bad_irq && is_chained) {
 		irq_settings_set_noprobe(desc);
 		irq_settings_set_norequest(desc);
+		irq_settings_set_nothread(desc);
 		irq_startup(desc);
 	}
 out:
diff --git a/kernel/irq/debug.h b/kernel/irq/debug.h
index 306cba3..97a8bfa 100644
--- a/kernel/irq/debug.h
+++ b/kernel/irq/debug.h
@@ -27,6 +27,7 @@ static inline void print_irq_desc(unsigned int irq, struct irq_desc *desc)
 	P(IRQ_PER_CPU);
 	P(IRQ_NOPROBE);
 	P(IRQ_NOREQUEST);
+	P(IRQ_NOTHREAD);
 	P(IRQ_NOAUTOEN);
 
 	PS(IRQS_AUTODETECT);
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 12a80fd..8706c24 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -900,7 +900,8 @@ __setup_irq(unsigned int irq, struct irq_desc *desc, struct irqaction *new)
 		 */
 		new->handler = irq_nested_primary_handler;
 	} else {
-		irq_setup_forced_threading(new);
+		if (irq_settings_can_thread(desc))
+			irq_setup_forced_threading(new);
 	}
 
 	/*
diff --git a/kernel/irq/settings.h b/kernel/irq/settings.h
index 0d91730..a40c884 100644
--- a/kernel/irq/settings.h
+++ b/kernel/irq/settings.h
@@ -8,6 +8,7 @@ enum {
 	_IRQ_LEVEL		= IRQ_LEVEL,
 	_IRQ_NOPROBE		= IRQ_NOPROBE,
 	_IRQ_NOREQUEST		= IRQ_NOREQUEST,
+	_IRQ_NOTHREAD		= IRQ_NOTHREAD,
 	_IRQ_NOAUTOEN		= IRQ_NOAUTOEN,
 	_IRQ_MOVE_PCNTXT	= IRQ_MOVE_PCNTXT,
 	_IRQ_NO_BALANCING	= IRQ_NO_BALANCING,
@@ -20,6 +21,7 @@ enum {
 #define IRQ_LEVEL		GOT_YOU_MORON
 #define IRQ_NOPROBE		GOT_YOU_MORON
 #define IRQ_NOREQUEST		GOT_YOU_MORON
+#define IRQ_NOTHREAD		GOT_YOU_MORON
 #define IRQ_NOAUTOEN		GOT_YOU_MORON
 #define IRQ_NESTED_THREAD	GOT_YOU_MORON
 #undef IRQF_MODIFY_MASK
@@ -94,6 +96,21 @@ static inline void irq_settings_set_norequest(struct irq_desc *desc)
 	desc->status_use_accessors |= _IRQ_NOREQUEST;
 }
 
+static inline bool irq_settings_can_thread(struct irq_desc *desc)
+{
+	return !(desc->status & _IRQ_NOTHREAD);
+}
+
+static inline void irq_settings_clr_nothread(struct irq_desc *desc)
+{
+	desc->status &= ~_IRQ_NOTHREAD;
+}
+
+static inline void irq_settings_set_nothread(struct irq_desc *desc)
+{
+	desc->status |= _IRQ_NOTHREAD;
+}
+
 static inline bool irq_settings_can_probe(struct irq_desc *desc)
 {
 	return !(desc->status_use_accessors & _IRQ_NOPROBE);
