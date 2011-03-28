Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755309Ab1C1TAx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 15:00:53 -0400
Received: from www.linutronix.de ([62.245.132.108]:56698 "EHLO linutronix.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753090Ab1C1TAv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 15:00:51 -0400
Date: Mon, 28 Mar 2011 21:00:48 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: [GIT pull] irq updates for .39
Message-ID: <alpine.LFD.2.00.1103282050100.2774@localhost6.localdomain6>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest irq-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git irq-fixes-for-linus

This is hopefully the last set of updates to the genirq code. It's
mostly helper functions which are necessary to cleanup the arch and
driver instances of irq chips and demux handlers fully.

The arm ns9xxx patch has been acked by Uwe.

The original cell patch has been ignored, so I put the cell private
handler into the core under a ifdef section which is selected by
cell. It's fully equivalent, but less code and allows me to remove the
old handle_IRQ_event() interface. I never liked the camel case :)

I really want to be able to remove the whole compat and deprecated
stuff now as the crap seems to come back faster than I can clean it
up. I've sent out patches to all archs which are not yet fully cleaned
up and I'm working to get the maintainers convinced to get through
with this for .39. The remaining queue of all arch/driver updates plus
the cleanup of the core code is going to remove another 1200 lines of
code on top of the already removed 800+.

Thanks,

	tglx

------------------>
David Daney (3):
      genirq: Reserve the irq when calling irq_set_chip()
      genirq: Add chip hooks for taking CPUs on/off line.
      genirq: Split irq_set_affinity() so it can be called with lock held.

Randy Dunlap (1):
      genirq: Fix new kernel-doc warnings

Thomas Gleixner (10):
      genirq: Add irq disabled flag to irq_data state
      genirq: Add chip flag for restricting cpu_on/offline calls
      genirq: Move INPROGRESS, MASKED and DISABLED state flags to irq_data
      genirq: Provide edge_eoi flow handler
      powerpc: cell: Use the core flow handler
      arm: Ns9xxx: Remove private irq flow handler
      genirq: Remove handle_IRQ_event
      genirq: Provide setter inline for IRQD_IRQ_INPROGRESS
      genirq: Add setter for AFFINITY_SET in irq_data state
      genirq: Fix typo and remove unused variable


 arch/arm/mach-ns9xxx/irq.c              |   58 +-----------
 arch/powerpc/platforms/cell/Kconfig     |    1 +
 arch/powerpc/platforms/cell/interrupt.c |   50 +----------
 include/linux/irq.h                     |   59 +++++++++++-
 kernel/irq/Kconfig                      |    4 +
 kernel/irq/chip.c                       |  152 ++++++++++++++++++++++++++----
 kernel/irq/debug.h                      |   10 ++-
 kernel/irq/handle.c                     |   16 +---
 kernel/irq/internals.h                  |    6 -
 kernel/irq/irqdesc.c                    |    3 +-
 kernel/irq/manage.c                     |   78 +++++++++-------
 kernel/irq/migration.c                  |    5 +-
 kernel/irq/spurious.c                   |   10 +-
 13 files changed, 257 insertions(+), 195 deletions(-)

diff --git a/arch/arm/mach-ns9xxx/irq.c b/arch/arm/mach-ns9xxx/irq.c
index 389fa5c..bf0fd48 100644
--- a/arch/arm/mach-ns9xxx/irq.c
+++ b/arch/arm/mach-ns9xxx/irq.c
@@ -31,17 +31,11 @@ static void ns9xxx_mask_irq(struct irq_data *d)
 	__raw_writel(ic, SYS_IC(prio / 4));
 }
 
-static void ns9xxx_ack_irq(struct irq_data *d)
+static void ns9xxx_eoi_irq(struct irq_data *d)
 {
 	__raw_writel(0, SYS_ISRADDR);
 }
 
-static void ns9xxx_maskack_irq(struct irq_data *d)
-{
-	ns9xxx_mask_irq(d);
-	ns9xxx_ack_irq(d);
-}
-
 static void ns9xxx_unmask_irq(struct irq_data *d)
 {
 	/* XXX: better use cpp symbols */
@@ -52,56 +46,11 @@ static void ns9xxx_unmask_irq(struct irq_data *d)
 }
 
 static struct irq_chip ns9xxx_chip = {
-	.irq_ack	= ns9xxx_ack_irq,
+	.irq_eoi	= ns9xxx_eoi_irq,
 	.irq_mask	= ns9xxx_mask_irq,
-	.irq_mask_ack	= ns9xxx_maskack_irq,
 	.irq_unmask	= ns9xxx_unmask_irq,
 };
 
-#if 0
-#define handle_irq handle_level_irq
-#else
-static void handle_prio_irq(unsigned int irq, struct irq_desc *desc)
-{
-	struct irqaction *action;
-	irqreturn_t action_ret;
-
-	raw_spin_lock(&desc->lock);
-
-	BUG_ON(desc->status & IRQ_INPROGRESS);
-
-	desc->status &= ~(IRQ_REPLAY | IRQ_WAITING);
-	kstat_incr_irqs_this_cpu(irq, desc);
-
-	action = desc->action;
-	if (unlikely(!action || (desc->status & IRQ_DISABLED)))
-		goto out_mask;
-
-	desc->status |= IRQ_INPROGRESS;
-	raw_spin_unlock(&desc->lock);
-
-	action_ret = handle_IRQ_event(irq, action);
-
-	/* XXX: There is no direct way to access noirqdebug, so check
-	 * unconditionally for spurious irqs...
-	 * Maybe this function should go to kernel/irq/chip.c? */
-	note_interrupt(irq, desc, action_ret);
-
-	raw_spin_lock(&desc->lock);
-	desc->status &= ~IRQ_INPROGRESS;
-
-	if (desc->status & IRQ_DISABLED)
-out_mask:
-		desc->irq_data.chip->irq_mask(&desc->irq_data);
-
-	/* ack unconditionally to unmask lower prio irqs */
-	desc->irq_data.chip->irq_ack(&desc->irq_data);
-
-	raw_spin_unlock(&desc->lock);
-}
-#define handle_irq handle_prio_irq
-#endif
-
 void __init ns9xxx_init_irq(void)
 {
 	int i;
@@ -119,7 +68,8 @@ void __init ns9xxx_init_irq(void)
 
 	for (i = 0; i <= 31; ++i) {
 		set_irq_chip(i, &ns9xxx_chip);
-		set_irq_handler(i, handle_irq);
+		set_irq_handler(i, handle_fasteoi_irq);
 		set_irq_flags(i, IRQF_VALID);
+		irq_set_status_flags(i, IRQ_LEVEL);
 	}
 }
diff --git a/arch/powerpc/platforms/cell/Kconfig b/arch/powerpc/platforms/cell/Kconfig
index 48cd7d2..81239eb 100644
--- a/arch/powerpc/platforms/cell/Kconfig
+++ b/arch/powerpc/platforms/cell/Kconfig
@@ -9,6 +9,7 @@ config PPC_CELL_COMMON
 	select PPC_INDIRECT_IO
 	select PPC_NATIVE
 	select PPC_RTAS
+	select IRQ_EDGE_EOI_HANDLER
 
 config PPC_CELL_NATIVE
 	bool
diff --git a/arch/powerpc/platforms/cell/interrupt.c b/arch/powerpc/platforms/cell/interrupt.c
index 624d26e..ec9fc7d 100644
--- a/arch/powerpc/platforms/cell/interrupt.c
+++ b/arch/powerpc/platforms/cell/interrupt.c
@@ -235,54 +235,6 @@ static int iic_host_match(struct irq_host *h, struct device_node *node)
 				    "IBM,CBEA-Internal-Interrupt-Controller");
 }
 
-extern int noirqdebug;
-
-static void handle_iic_irq(unsigned int irq, struct irq_desc *desc)
-{
-	struct irq_chip *chip = get_irq_desc_chip(desc);
-
-	raw_spin_lock(&desc->lock);
-
-	desc->status &= ~(IRQ_REPLAY | IRQ_WAITING);
-
-	/*
-	 * If we're currently running this IRQ, or its disabled,
-	 * we shouldn't process the IRQ. Mark it pending, handle
-	 * the necessary masking and go out
-	 */
-	if (unlikely((desc->status & (IRQ_INPROGRESS | IRQ_DISABLED)) ||
-		    !desc->action)) {
-		desc->status |= IRQ_PENDING;
-		goto out_eoi;
-	}
-
-	kstat_incr_irqs_this_cpu(irq, desc);
-
-	/* Mark the IRQ currently in progress.*/
-	desc->status |= IRQ_INPROGRESS;
-
-	do {
-		struct irqaction *action = desc->action;
-		irqreturn_t action_ret;
-
-		if (unlikely(!action))
-			goto out_eoi;
-
-		desc->status &= ~IRQ_PENDING;
-		raw_spin_unlock(&desc->lock);
-		action_ret = handle_IRQ_event(irq, action);
-		if (!noirqdebug)
-			note_interrupt(irq, desc, action_ret);
-		raw_spin_lock(&desc->lock);
-
-	} while ((desc->status & (IRQ_PENDING | IRQ_DISABLED)) == IRQ_PENDING);
-
-	desc->status &= ~IRQ_INPROGRESS;
-out_eoi:
-	chip->irq_eoi(&desc->irq_data);
-	raw_spin_unlock(&desc->lock);
-}
-
 static int iic_host_map(struct irq_host *h, unsigned int virq,
 			irq_hw_number_t hw)
 {
@@ -295,7 +247,7 @@ static int iic_host_map(struct irq_host *h, unsigned int virq,
 					 handle_iic_irq);
 		break;
 	default:
-		set_irq_chip_and_handler(virq, &iic_chip, handle_iic_irq);
+		set_irq_chip_and_handler(virq, &iic_chip, handle_edge_eoi_irq);
 	}
 	return 0;
 }
diff --git a/include/linux/irq.h b/include/linux/irq.h
index 5d876c9..b3741c8 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -135,7 +135,7 @@ struct msi_desc;
  * struct irq_data - per irq and irq chip data passed down to chip functions
  * @irq:		interrupt number
  * @node:		node index useful for balancing
- * @state_use_accessor: status information for irq chip functions.
+ * @state_use_accessors: status information for irq chip functions.
  *			Use accessor functions to deal with it
  * @chip:		low level interrupt hardware access
  * @handler_data:	per-IRQ data for the irq_chip methods
@@ -174,6 +174,9 @@ struct irq_data {
  *				  from suspend
  * IRDQ_MOVE_PCNTXT		- Interrupt can be moved in process
  *				  context
+ * IRQD_IRQ_DISABLED		- Disabled state of the interrupt
+ * IRQD_IRQ_MASKED		- Masked state of the interrupt
+ * IRQD_IRQ_INPROGRESS		- In progress state of the interrupt
  */
 enum {
 	IRQD_TRIGGER_MASK		= 0xf,
@@ -184,6 +187,9 @@ enum {
 	IRQD_LEVEL			= (1 << 13),
 	IRQD_WAKEUP_STATE		= (1 << 14),
 	IRQD_MOVE_PCNTXT		= (1 << 15),
+	IRQD_IRQ_DISABLED		= (1 << 16),
+	IRQD_IRQ_MASKED			= (1 << 17),
+	IRQD_IRQ_INPROGRESS		= (1 << 18),
 };
 
 static inline bool irqd_is_setaffinity_pending(struct irq_data *d)
@@ -206,6 +212,11 @@ static inline bool irqd_affinity_was_set(struct irq_data *d)
 	return d->state_use_accessors & IRQD_AFFINITY_SET;
 }
 
+static inline void irqd_mark_affinity_was_set(struct irq_data *d)
+{
+	d->state_use_accessors |= IRQD_AFFINITY_SET;
+}
+
 static inline u32 irqd_get_trigger_type(struct irq_data *d)
 {
 	return d->state_use_accessors & IRQD_TRIGGER_MASK;
@@ -235,6 +246,36 @@ static inline bool irqd_can_move_in_process_context(struct irq_data *d)
 	return d->state_use_accessors & IRQD_MOVE_PCNTXT;
 }
 
+static inline bool irqd_irq_disabled(struct irq_data *d)
+{
+	return d->state_use_accessors & IRQD_IRQ_DISABLED;
+}
+
+static inline bool irqd_irq_masked(struct irq_data *d)
+{
+	return d->state_use_accessors & IRQD_IRQ_MASKED;
+}
+
+static inline bool irqd_irq_inprogress(struct irq_data *d)
+{
+	return d->state_use_accessors & IRQD_IRQ_INPROGRESS;
+}
+
+/*
+ * Functions for chained handlers which can be enabled/disabled by the
+ * standard disable_irq/enable_irq calls. Must be called with
+ * irq_desc->lock held.
+ */
+static inline void irqd_set_chained_irq_inprogress(struct irq_data *d)
+{
+	d->state_use_accessors |= IRQD_IRQ_INPROGRESS;
+}
+
+static inline void irqd_clr_chained_irq_inprogress(struct irq_data *d)
+{
+	d->state_use_accessors &= ~IRQD_IRQ_INPROGRESS;
+}
+
 /**
  * struct irq_chip - hardware interrupt chip descriptor
  *
@@ -271,6 +312,8 @@ static inline bool irqd_can_move_in_process_context(struct irq_data *d)
  * @irq_set_wake:	enable/disable power-management wake-on of an IRQ
  * @irq_bus_lock:	function to lock access to slow bus (i2c) chips
  * @irq_bus_sync_unlock:function to sync and unlock slow bus (i2c) chips
+ * @irq_cpu_online:	configure an interrupt source for a secondary CPU
+ * @irq_cpu_offline:	un-configure an interrupt source for a secondary CPU
  * @irq_print_chip:	optional to print special chip info in show_interrupts
  * @flags:		chip specific flags
  *
@@ -319,6 +362,9 @@ struct irq_chip {
 	void		(*irq_bus_lock)(struct irq_data *data);
 	void		(*irq_bus_sync_unlock)(struct irq_data *data);
 
+	void		(*irq_cpu_online)(struct irq_data *data);
+	void		(*irq_cpu_offline)(struct irq_data *data);
+
 	void		(*irq_print_chip)(struct irq_data *data, struct seq_file *p);
 
 	unsigned long	flags;
@@ -335,11 +381,14 @@ struct irq_chip {
  * IRQCHIP_SET_TYPE_MASKED:	Mask before calling chip.irq_set_type()
  * IRQCHIP_EOI_IF_HANDLED:	Only issue irq_eoi() when irq was handled
  * IRQCHIP_MASK_ON_SUSPEND:	Mask non wake irqs in the suspend path
+ * IRQCHIP_ONOFFLINE_ENABLED:	Only call irq_on/off_line callbacks
+ *				when irq enabled
  */
 enum {
 	IRQCHIP_SET_TYPE_MASKED		= (1 <<  0),
 	IRQCHIP_EOI_IF_HANDLED		= (1 <<  1),
 	IRQCHIP_MASK_ON_SUSPEND		= (1 <<  2),
+	IRQCHIP_ONOFFLINE_ENABLED	= (1 <<  3),
 };
 
 /* This include will go away once we isolated irq_desc usage to core code */
@@ -364,6 +413,10 @@ struct irqaction;
 extern int setup_irq(unsigned int irq, struct irqaction *new);
 extern void remove_irq(unsigned int irq, struct irqaction *act);
 
+extern void irq_cpu_online(void);
+extern void irq_cpu_offline(void);
+extern int __irq_set_affinity_locked(struct irq_data *data,  const struct cpumask *cpumask);
+
 #ifdef CONFIG_GENERIC_HARDIRQS
 
 #if defined(CONFIG_SMP) && defined(CONFIG_GENERIC_PENDING_IRQ)
@@ -380,9 +433,6 @@ static inline void irq_move_masked_irq(struct irq_data *data) { }
 
 extern int no_irq_affinity;
 
-/* Handle irq action chains: */
-extern irqreturn_t handle_IRQ_event(unsigned int irq, struct irqaction *action);
-
 /*
  * Built-in IRQ handlers for various IRQ types,
  * callable via desc->handle_irq()
@@ -390,6 +440,7 @@ extern irqreturn_t handle_IRQ_event(unsigned int irq, struct irqaction *action);
 extern void handle_level_irq(unsigned int irq, struct irq_desc *desc);
 extern void handle_fasteoi_irq(unsigned int irq, struct irq_desc *desc);
 extern void handle_edge_irq(unsigned int irq, struct irq_desc *desc);
+extern void handle_edge_eoi_irq(unsigned int irq, struct irq_desc *desc);
 extern void handle_simple_irq(unsigned int irq, struct irq_desc *desc);
 extern void handle_percpu_irq(unsigned int irq, struct irq_desc *desc);
 extern void handle_bad_irq(unsigned int irq, struct irq_desc *desc);
diff --git a/kernel/irq/Kconfig b/kernel/irq/Kconfig
index 00f2c03..72606ba 100644
--- a/kernel/irq/Kconfig
+++ b/kernel/irq/Kconfig
@@ -51,6 +51,10 @@ config HARDIRQS_SW_RESEND
 config IRQ_PREFLOW_FASTEOI
        bool
 
+# Edge style eoi based handler (cell)
+config IRQ_EDGE_EOI_HANDLER
+       bool
+
 # Support forced irq threading
 config IRQ_FORCED_THREADING
        bool
diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index c9c0601..451d1e8 100644
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -37,6 +37,12 @@ int irq_set_chip(unsigned int irq, struct irq_chip *chip)
 	irq_chip_set_defaults(chip);
 	desc->irq_data.chip = chip;
 	irq_put_desc_unlock(desc, flags);
+	/*
+	 * For !CONFIG_SPARSE_IRQ make the irq show up in
+	 * allocated_irqs. For the CONFIG_SPARSE_IRQ case, it is
+	 * already marked, and this call is harmless.
+	 */
+	irq_reserve_irq(irq);
 	return 0;
 }
 EXPORT_SYMBOL(irq_set_chip);
@@ -134,25 +140,25 @@ EXPORT_SYMBOL_GPL(irq_get_irq_data);
 
 static void irq_state_clr_disabled(struct irq_desc *desc)
 {
-	desc->istate &= ~IRQS_DISABLED;
+	irqd_clear(&desc->irq_data, IRQD_IRQ_DISABLED);
 	irq_compat_clr_disabled(desc);
 }
 
 static void irq_state_set_disabled(struct irq_desc *desc)
 {
-	desc->istate |= IRQS_DISABLED;
+	irqd_set(&desc->irq_data, IRQD_IRQ_DISABLED);
 	irq_compat_set_disabled(desc);
 }
 
 static void irq_state_clr_masked(struct irq_desc *desc)
 {
-	desc->istate &= ~IRQS_MASKED;
+	irqd_clear(&desc->irq_data, IRQD_IRQ_MASKED);
 	irq_compat_clr_masked(desc);
 }
 
 static void irq_state_set_masked(struct irq_desc *desc)
 {
-	desc->istate |= IRQS_MASKED;
+	irqd_set(&desc->irq_data, IRQD_IRQ_MASKED);
 	irq_compat_set_masked(desc);
 }
 
@@ -372,11 +378,11 @@ void handle_nested_irq(unsigned int irq)
 	kstat_incr_irqs_this_cpu(irq, desc);
 
 	action = desc->action;
-	if (unlikely(!action || (desc->istate & IRQS_DISABLED)))
+	if (unlikely(!action || irqd_irq_disabled(&desc->irq_data)))
 		goto out_unlock;
 
 	irq_compat_set_progress(desc);
-	desc->istate |= IRQS_INPROGRESS;
+	irqd_set(&desc->irq_data, IRQD_IRQ_INPROGRESS);
 	raw_spin_unlock_irq(&desc->lock);
 
 	action_ret = action->thread_fn(action->irq, action->dev_id);
@@ -384,7 +390,7 @@ void handle_nested_irq(unsigned int irq)
 		note_interrupt(irq, desc, action_ret);
 
 	raw_spin_lock_irq(&desc->lock);
-	desc->istate &= ~IRQS_INPROGRESS;
+	irqd_clear(&desc->irq_data, IRQD_IRQ_INPROGRESS);
 	irq_compat_clr_progress(desc);
 
 out_unlock:
@@ -416,14 +422,14 @@ handle_simple_irq(unsigned int irq, struct irq_desc *desc)
 {
 	raw_spin_lock(&desc->lock);
 
-	if (unlikely(desc->istate & IRQS_INPROGRESS))
+	if (unlikely(irqd_irq_inprogress(&desc->irq_data)))
 		if (!irq_check_poll(desc))
 			goto out_unlock;
 
 	desc->istate &= ~(IRQS_REPLAY | IRQS_WAITING);
 	kstat_incr_irqs_this_cpu(irq, desc);
 
-	if (unlikely(!desc->action || (desc->istate & IRQS_DISABLED)))
+	if (unlikely(!desc->action || irqd_irq_disabled(&desc->irq_data)))
 		goto out_unlock;
 
 	handle_irq_event(desc);
@@ -448,7 +454,7 @@ handle_level_irq(unsigned int irq, struct irq_desc *desc)
 	raw_spin_lock(&desc->lock);
 	mask_ack_irq(desc);
 
-	if (unlikely(desc->istate & IRQS_INPROGRESS))
+	if (unlikely(irqd_irq_inprogress(&desc->irq_data)))
 		if (!irq_check_poll(desc))
 			goto out_unlock;
 
@@ -459,12 +465,12 @@ handle_level_irq(unsigned int irq, struct irq_desc *desc)
 	 * If its disabled or no action available
 	 * keep it masked and get out of here
 	 */
-	if (unlikely(!desc->action || (desc->istate & IRQS_DISABLED)))
+	if (unlikely(!desc->action || irqd_irq_disabled(&desc->irq_data)))
 		goto out_unlock;
 
 	handle_irq_event(desc);
 
-	if (!(desc->istate & (IRQS_DISABLED | IRQS_ONESHOT)))
+	if (!irqd_irq_disabled(&desc->irq_data) && !(desc->istate & IRQS_ONESHOT))
 		unmask_irq(desc);
 out_unlock:
 	raw_spin_unlock(&desc->lock);
@@ -496,7 +502,7 @@ handle_fasteoi_irq(unsigned int irq, struct irq_desc *desc)
 {
 	raw_spin_lock(&desc->lock);
 
-	if (unlikely(desc->istate & IRQS_INPROGRESS))
+	if (unlikely(irqd_irq_inprogress(&desc->irq_data)))
 		if (!irq_check_poll(desc))
 			goto out;
 
@@ -507,7 +513,7 @@ handle_fasteoi_irq(unsigned int irq, struct irq_desc *desc)
 	 * If its disabled or no action available
 	 * then mask it and get out of here:
 	 */
-	if (unlikely(!desc->action || (desc->istate & IRQS_DISABLED))) {
+	if (unlikely(!desc->action || irqd_irq_disabled(&desc->irq_data))) {
 		irq_compat_set_pending(desc);
 		desc->istate |= IRQS_PENDING;
 		mask_irq(desc);
@@ -558,8 +564,8 @@ handle_edge_irq(unsigned int irq, struct irq_desc *desc)
 	 * we shouldn't process the IRQ. Mark it pending, handle
 	 * the necessary masking and go out
 	 */
-	if (unlikely((desc->istate & (IRQS_DISABLED | IRQS_INPROGRESS) ||
-		      !desc->action))) {
+	if (unlikely(irqd_irq_disabled(&desc->irq_data) ||
+		     irqd_irq_inprogress(&desc->irq_data) || !desc->action)) {
 		if (!irq_check_poll(desc)) {
 			irq_compat_set_pending(desc);
 			desc->istate |= IRQS_PENDING;
@@ -584,20 +590,65 @@ handle_edge_irq(unsigned int irq, struct irq_desc *desc)
 		 * Renable it, if it was not disabled in meantime.
 		 */
 		if (unlikely(desc->istate & IRQS_PENDING)) {
-			if (!(desc->istate & IRQS_DISABLED) &&
-			    (desc->istate & IRQS_MASKED))
+			if (!irqd_irq_disabled(&desc->irq_data) &&
+			    irqd_irq_masked(&desc->irq_data))
 				unmask_irq(desc);
 		}
 
 		handle_irq_event(desc);
 
 	} while ((desc->istate & IRQS_PENDING) &&
-		 !(desc->istate & IRQS_DISABLED));
+		 !irqd_irq_disabled(&desc->irq_data));
 
 out_unlock:
 	raw_spin_unlock(&desc->lock);
 }
 
+#ifdef CONFIG_IRQ_EDGE_EOI_HANDLER
+/**
+ *	handle_edge_eoi_irq - edge eoi type IRQ handler
+ *	@irq:	the interrupt number
+ *	@desc:	the interrupt description structure for this irq
+ *
+ * Similar as the above handle_edge_irq, but using eoi and w/o the
+ * mask/unmask logic.
+ */
+void handle_edge_eoi_irq(unsigned int irq, struct irq_desc *desc)
+{
+	struct irq_chip *chip = irq_desc_get_chip(desc);
+
+	raw_spin_lock(&desc->lock);
+
+	desc->istate &= ~(IRQS_REPLAY | IRQS_WAITING);
+	/*
+	 * If we're currently running this IRQ, or its disabled,
+	 * we shouldn't process the IRQ. Mark it pending, handle
+	 * the necessary masking and go out
+	 */
+	if (unlikely(irqd_irq_disabled(&desc->irq_data) ||
+		     irqd_irq_inprogress(&desc->irq_data) || !desc->action)) {
+		if (!irq_check_poll(desc)) {
+			desc->istate |= IRQS_PENDING;
+			goto out_eoi;
+		}
+	}
+	kstat_incr_irqs_this_cpu(irq, desc);
+
+	do {
+		if (unlikely(!desc->action))
+			goto out_eoi;
+
+		handle_irq_event(desc);
+
+	} while ((desc->istate & IRQS_PENDING) &&
+		 !irqd_irq_disabled(&desc->irq_data));
+
+out_unlock:
+	chip->irq_eoi(&desc->irq_data);
+	raw_spin_unlock(&desc->lock);
+}
+#endif
+
 /**
  *	handle_percpu_irq - Per CPU local irq handler
  *	@irq:	the interrupt number
@@ -642,8 +693,7 @@ __irq_set_handler(unsigned int irq, irq_flow_handler_t handle, int is_chained,
 	if (handle == handle_bad_irq) {
 		if (desc->irq_data.chip != &no_irq_chip)
 			mask_ack_irq(desc);
-		irq_compat_set_disabled(desc);
-		desc->istate |= IRQS_DISABLED;
+		irq_state_set_disabled(desc);
 		desc->depth = 1;
 	}
 	desc->handle_irq = handle;
@@ -689,3 +739,63 @@ void irq_modify_status(unsigned int irq, unsigned long clr, unsigned long set)
 
 	irq_put_desc_unlock(desc, flags);
 }
+
+/**
+ *	irq_cpu_online - Invoke all irq_cpu_online functions.
+ *
+ *	Iterate through all irqs and invoke the chip.irq_cpu_online()
+ *	for each.
+ */
+void irq_cpu_online(void)
+{
+	struct irq_desc *desc;
+	struct irq_chip *chip;
+	unsigned long flags;
+	unsigned int irq;
+
+	for_each_active_irq(irq) {
+		desc = irq_to_desc(irq);
+		if (!desc)
+			continue;
+
+		raw_spin_lock_irqsave(&desc->lock, flags);
+
+		chip = irq_data_get_irq_chip(&desc->irq_data);
+		if (chip && chip->irq_cpu_online &&
+		    (!(chip->flags & IRQCHIP_ONOFFLINE_ENABLED) ||
+		     !irqd_irq_disabled(&desc->irq_data)))
+			chip->irq_cpu_online(&desc->irq_data);
+
+		raw_spin_unlock_irqrestore(&desc->lock, flags);
+	}
+}
+
+/**
+ *	irq_cpu_offline - Invoke all irq_cpu_offline functions.
+ *
+ *	Iterate through all irqs and invoke the chip.irq_cpu_offline()
+ *	for each.
+ */
+void irq_cpu_offline(void)
+{
+	struct irq_desc *desc;
+	struct irq_chip *chip;
+	unsigned long flags;
+	unsigned int irq;
+
+	for_each_active_irq(irq) {
+		desc = irq_to_desc(irq);
+		if (!desc)
+			continue;
+
+		raw_spin_lock_irqsave(&desc->lock, flags);
+
+		chip = irq_data_get_irq_chip(&desc->irq_data);
+		if (chip && chip->irq_cpu_offline &&
+		    (!(chip->flags & IRQCHIP_ONOFFLINE_ENABLED) ||
+		     !irqd_irq_disabled(&desc->irq_data)))
+			chip->irq_cpu_offline(&desc->irq_data);
+
+		raw_spin_unlock_irqrestore(&desc->lock, flags);
+	}
+}
diff --git a/kernel/irq/debug.h b/kernel/irq/debug.h
index d1a33b7..a0bd875 100644
--- a/kernel/irq/debug.h
+++ b/kernel/irq/debug.h
@@ -6,6 +6,8 @@
 
 #define P(f) if (desc->status & f) printk("%14s set\n", #f)
 #define PS(f) if (desc->istate & f) printk("%14s set\n", #f)
+/* FIXME */
+#define PD(f) do { } while (0)
 
 static inline void print_irq_desc(unsigned int irq, struct irq_desc *desc)
 {
@@ -28,13 +30,15 @@ static inline void print_irq_desc(unsigned int irq, struct irq_desc *desc)
 	P(IRQ_NOAUTOEN);
 
 	PS(IRQS_AUTODETECT);
-	PS(IRQS_INPROGRESS);
 	PS(IRQS_REPLAY);
 	PS(IRQS_WAITING);
-	PS(IRQS_DISABLED);
 	PS(IRQS_PENDING);
-	PS(IRQS_MASKED);
+
+	PD(IRQS_INPROGRESS);
+	PD(IRQS_DISABLED);
+	PD(IRQS_MASKED);
 }
 
 #undef P
 #undef PS
+#undef PD
diff --git a/kernel/irq/handle.c b/kernel/irq/handle.c
index 517561f..1a2fb77 100644
--- a/kernel/irq/handle.c
+++ b/kernel/irq/handle.c
@@ -178,25 +178,13 @@ irqreturn_t handle_irq_event(struct irq_desc *desc)
 	irq_compat_clr_pending(desc);
 	desc->istate &= ~IRQS_PENDING;
 	irq_compat_set_progress(desc);
-	desc->istate |= IRQS_INPROGRESS;
+	irqd_set(&desc->irq_data, IRQD_IRQ_INPROGRESS);
 	raw_spin_unlock(&desc->lock);
 
 	ret = handle_irq_event_percpu(desc, action);
 
 	raw_spin_lock(&desc->lock);
-	desc->istate &= ~IRQS_INPROGRESS;
+	irqd_clear(&desc->irq_data, IRQD_IRQ_INPROGRESS);
 	irq_compat_clr_progress(desc);
 	return ret;
 }
-
-/**
- * handle_IRQ_event - irq action chain handler
- * @irq:	the interrupt number
- * @action:	the interrupt action chain for this irq
- *
- * Handles the action chain of an irq event
- */
-irqreturn_t handle_IRQ_event(unsigned int irq, struct irqaction *action)
-{
-	return handle_irq_event_percpu(irq_to_desc(irq), action);
-}
diff --git a/kernel/irq/internals.h b/kernel/irq/internals.h
index 6c6ec9a..6b8b971 100644
--- a/kernel/irq/internals.h
+++ b/kernel/irq/internals.h
@@ -44,26 +44,20 @@ enum {
  * IRQS_SPURIOUS_DISABLED	- was disabled due to spurious interrupt
  *				  detection
  * IRQS_POLL_INPROGRESS		- polling in progress
- * IRQS_INPROGRESS		- Interrupt in progress
  * IRQS_ONESHOT			- irq is not unmasked in primary handler
  * IRQS_REPLAY			- irq is replayed
  * IRQS_WAITING			- irq is waiting
- * IRQS_DISABLED		- irq is disabled
  * IRQS_PENDING			- irq is pending and replayed later
- * IRQS_MASKED			- irq is masked
  * IRQS_SUSPENDED		- irq is suspended
  */
 enum {
 	IRQS_AUTODETECT		= 0x00000001,
 	IRQS_SPURIOUS_DISABLED	= 0x00000002,
 	IRQS_POLL_INPROGRESS	= 0x00000008,
-	IRQS_INPROGRESS		= 0x00000010,
 	IRQS_ONESHOT		= 0x00000020,
 	IRQS_REPLAY		= 0x00000040,
 	IRQS_WAITING		= 0x00000080,
-	IRQS_DISABLED		= 0x00000100,
 	IRQS_PENDING		= 0x00000200,
-	IRQS_MASKED		= 0x00000400,
 	IRQS_SUSPENDED		= 0x00000800,
 };
 
diff --git a/kernel/irq/irqdesc.c b/kernel/irq/irqdesc.c
index 6fb014f..2c039c9 100644
--- a/kernel/irq/irqdesc.c
+++ b/kernel/irq/irqdesc.c
@@ -80,7 +80,7 @@ static void desc_set_defaults(unsigned int irq, struct irq_desc *desc, int node)
 	desc->irq_data.handler_data = NULL;
 	desc->irq_data.msi_desc = NULL;
 	irq_settings_clr_and_set(desc, ~0, _IRQ_DEFAULT_INIT_FLAGS);
-	desc->istate = IRQS_DISABLED;
+	irqd_set(&desc->irq_data, IRQD_IRQ_DISABLED);
 	desc->handle_irq = handle_bad_irq;
 	desc->depth = 1;
 	desc->irq_count = 0;
@@ -238,7 +238,6 @@ int __init early_irq_init(void)
 
 struct irq_desc irq_desc[NR_IRQS] __cacheline_aligned_in_smp = {
 	[0 ... NR_IRQS-1] = {
-		.istate		= IRQS_DISABLED,
 		.handle_irq	= handle_bad_irq,
 		.depth		= 1,
 		.lock		= __RAW_SPIN_LOCK_UNLOCKED(irq_desc->lock),
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 0a2aa73..805c6a0 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -41,7 +41,7 @@ early_param("threadirqs", setup_forced_irqthreads);
 void synchronize_irq(unsigned int irq)
 {
 	struct irq_desc *desc = irq_to_desc(irq);
-	unsigned int state;
+	bool inprogress;
 
 	if (!desc)
 		return;
@@ -53,16 +53,16 @@ void synchronize_irq(unsigned int irq)
 		 * Wait until we're out of the critical section.  This might
 		 * give the wrong answer due to the lack of memory barriers.
 		 */
-		while (desc->istate & IRQS_INPROGRESS)
+		while (irqd_irq_inprogress(&desc->irq_data))
 			cpu_relax();
 
 		/* Ok, that indicated we're done: double-check carefully. */
 		raw_spin_lock_irqsave(&desc->lock, flags);
-		state = desc->istate;
+		inprogress = irqd_irq_inprogress(&desc->irq_data);
 		raw_spin_unlock_irqrestore(&desc->lock, flags);
 
 		/* Oops, that failed? */
-	} while (state & IRQS_INPROGRESS);
+	} while (inprogress);
 
 	/*
 	 * We made sure that no hardirq handler is running. Now verify
@@ -139,35 +139,26 @@ static inline void
 irq_get_pending(struct cpumask *mask, struct irq_desc *desc) { }
 #endif
 
-/**
- *	irq_set_affinity - Set the irq affinity of a given irq
- *	@irq:		Interrupt to set affinity
- *	@cpumask:	cpumask
- *
- */
-int irq_set_affinity(unsigned int irq, const struct cpumask *mask)
+int __irq_set_affinity_locked(struct irq_data *data, const struct cpumask *mask)
 {
-	struct irq_desc *desc = irq_to_desc(irq);
-	struct irq_chip *chip = desc->irq_data.chip;
-	unsigned long flags;
+	struct irq_chip *chip = irq_data_get_irq_chip(data);
+	struct irq_desc *desc = irq_data_to_desc(data);
 	int ret = 0;
 
-	if (!chip->irq_set_affinity)
+	if (!chip || !chip->irq_set_affinity)
 		return -EINVAL;
 
-	raw_spin_lock_irqsave(&desc->lock, flags);
-
-	if (irq_can_move_pcntxt(desc)) {
-		ret = chip->irq_set_affinity(&desc->irq_data, mask, false);
+	if (irqd_can_move_in_process_context(data)) {
+		ret = chip->irq_set_affinity(data, mask, false);
 		switch (ret) {
 		case IRQ_SET_MASK_OK:
-			cpumask_copy(desc->irq_data.affinity, mask);
+			cpumask_copy(data->affinity, mask);
 		case IRQ_SET_MASK_OK_NOCOPY:
 			irq_set_thread_affinity(desc);
 			ret = 0;
 		}
 	} else {
-		irqd_set_move_pending(&desc->irq_data);
+		irqd_set_move_pending(data);
 		irq_copy_pending(desc, mask);
 	}
 
@@ -176,7 +167,28 @@ int irq_set_affinity(unsigned int irq, const struct cpumask *mask)
 		schedule_work(&desc->affinity_notify->work);
 	}
 	irq_compat_set_affinity(desc);
-	irqd_set(&desc->irq_data, IRQD_AFFINITY_SET);
+	irqd_set(data, IRQD_AFFINITY_SET);
+
+	return ret;
+}
+
+/**
+ *	irq_set_affinity - Set the irq affinity of a given irq
+ *	@irq:		Interrupt to set affinity
+ *	@mask:		cpumask
+ *
+ */
+int irq_set_affinity(unsigned int irq, const struct cpumask *mask)
+{
+	struct irq_desc *desc = irq_to_desc(irq);
+	unsigned long flags;
+	int ret;
+
+	if (!desc)
+		return -EINVAL;
+
+	raw_spin_lock_irqsave(&desc->lock, flags);
+	ret =  __irq_set_affinity_locked(irq_desc_get_irq_data(desc), mask);
 	raw_spin_unlock_irqrestore(&desc->lock, flags);
 	return ret;
 }
@@ -551,9 +563,9 @@ int __irq_set_trigger(struct irq_desc *desc, unsigned int irq,
 	flags &= IRQ_TYPE_SENSE_MASK;
 
 	if (chip->flags & IRQCHIP_SET_TYPE_MASKED) {
-		if (!(desc->istate & IRQS_MASKED))
+		if (!irqd_irq_masked(&desc->irq_data))
 			mask_irq(desc);
-		if (!(desc->istate & IRQS_DISABLED))
+		if (!irqd_irq_disabled(&desc->irq_data))
 			unmask = 1;
 	}
 
@@ -651,7 +663,7 @@ again:
 	 * irq_wake_thread(). See the comment there which explains the
 	 * serialization.
 	 */
-	if (unlikely(desc->istate & IRQS_INPROGRESS)) {
+	if (unlikely(irqd_irq_inprogress(&desc->irq_data))) {
 		raw_spin_unlock_irq(&desc->lock);
 		chip_bus_sync_unlock(desc);
 		cpu_relax();
@@ -668,12 +680,10 @@ again:
 
 	desc->threads_oneshot &= ~action->thread_mask;
 
-	if (!desc->threads_oneshot && !(desc->istate & IRQS_DISABLED) &&
-	    (desc->istate & IRQS_MASKED)) {
-		irq_compat_clr_masked(desc);
-		desc->istate &= ~IRQS_MASKED;
-		desc->irq_data.chip->irq_unmask(&desc->irq_data);
-	}
+	if (!desc->threads_oneshot && !irqd_irq_disabled(&desc->irq_data) &&
+	    irqd_irq_masked(&desc->irq_data))
+		unmask_irq(desc);
+
 out_unlock:
 	raw_spin_unlock_irq(&desc->lock);
 	chip_bus_sync_unlock(desc);
@@ -767,7 +777,7 @@ static int irq_thread(void *data)
 		atomic_inc(&desc->threads_active);
 
 		raw_spin_lock_irq(&desc->lock);
-		if (unlikely(desc->istate & IRQS_DISABLED)) {
+		if (unlikely(irqd_irq_disabled(&desc->irq_data))) {
 			/*
 			 * CHECKME: We might need a dedicated
 			 * IRQ_THREAD_PENDING flag here, which
@@ -985,8 +995,8 @@ __setup_irq(unsigned int irq, struct irq_desc *desc, struct irqaction *new)
 		}
 
 		desc->istate &= ~(IRQS_AUTODETECT | IRQS_SPURIOUS_DISABLED | \
-				  IRQS_INPROGRESS | IRQS_ONESHOT | \
-				  IRQS_WAITING);
+				  IRQS_ONESHOT | IRQS_WAITING);
+		irqd_clear(&desc->irq_data, IRQD_IRQ_INPROGRESS);
 
 		if (new->flags & IRQF_PERCPU) {
 			irqd_set(&desc->irq_data, IRQD_PER_CPU);
diff --git a/kernel/irq/migration.c b/kernel/irq/migration.c
index ec4806d..e33d9c8 100644
--- a/kernel/irq/migration.c
+++ b/kernel/irq/migration.c
@@ -60,13 +60,12 @@ void move_masked_irq(int irq)
 
 void irq_move_irq(struct irq_data *idata)
 {
-	struct irq_desc *desc = irq_data_to_desc(idata);
 	bool masked;
 
 	if (likely(!irqd_is_setaffinity_pending(idata)))
 		return;
 
-	if (unlikely(desc->istate & IRQS_DISABLED))
+	if (unlikely(irqd_irq_disabled(idata)))
 		return;
 
 	/*
@@ -74,7 +73,7 @@ void irq_move_irq(struct irq_data *idata)
 	 * threaded interrupt with ONESHOT set, we can end up with an
 	 * interrupt storm.
 	 */
-	masked = desc->istate & IRQS_MASKED;
+	masked = irqd_irq_masked(idata);
 	if (!masked)
 		idata->chip->irq_mask(idata);
 	irq_move_masked_irq(idata);
diff --git a/kernel/irq/spurious.c b/kernel/irq/spurious.c
index dd586eb..83f4799 100644
--- a/kernel/irq/spurious.c
+++ b/kernel/irq/spurious.c
@@ -45,12 +45,12 @@ bool irq_wait_for_poll(struct irq_desc *desc)
 #ifdef CONFIG_SMP
 	do {
 		raw_spin_unlock(&desc->lock);
-		while (desc->istate & IRQS_INPROGRESS)
+		while (irqd_irq_inprogress(&desc->irq_data))
 			cpu_relax();
 		raw_spin_lock(&desc->lock);
-	} while (desc->istate & IRQS_INPROGRESS);
+	} while (irqd_irq_inprogress(&desc->irq_data));
 	/* Might have been disabled in meantime */
-	return !(desc->istate & IRQS_DISABLED) && desc->action;
+	return !irqd_irq_disabled(&desc->irq_data) && desc->action;
 #else
 	return false;
 #endif
@@ -75,7 +75,7 @@ static int try_one_irq(int irq, struct irq_desc *desc, bool force)
 	 * Do not poll disabled interrupts unless the spurious
 	 * disabled poller asks explicitely.
 	 */
-	if ((desc->istate & IRQS_DISABLED) && !force)
+	if (irqd_irq_disabled(&desc->irq_data) && !force)
 		goto out;
 
 	/*
@@ -88,7 +88,7 @@ static int try_one_irq(int irq, struct irq_desc *desc, bool force)
 		goto out;
 
 	/* Already running on another processor */
-	if (desc->istate & IRQS_INPROGRESS) {
+	if (irqd_irq_inprogress(&desc->irq_data)) {
 		/*
 		 * Already running: If it is shared get the other
 		 * CPU to go looking for our mystery interrupt too
