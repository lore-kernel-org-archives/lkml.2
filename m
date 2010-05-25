Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934116Ab0EYUNT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 16:13:19 -0400
Received: from www.tglx.de ([62.245.132.106]:54067 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933472Ab0EYUNQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 16:13:16 -0400
Date: Tue, 25 May 2010 22:12:58 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Chris Metcalf <cmetcalf@tilera.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] arch/tile: new multi-core architecture for Linux
In-Reply-To: <201005200543.o4K5hFRF006079@farm-0002.internal.tilera.com>
Message-ID: <alpine.LFD.2.00.1005252129441.2948@localhost.localdomain>
References: <201005200543.o4K5hFRF006079@farm-0002.internal.tilera.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris,

On Thu, 20 May 2010, Chris Metcalf wrote:

> We are using the http://www.tilera.com/scm/ web site to push
> Tilera-modified sources back up to the community.  At the moment, the
> arch/tile hierarchy is there (as a bzipped tarball) as well as a copy
> of the patch appended to this email.  In addition, our gcc, binutils,

it would be very helpful for review if you could split your patches
into different topics and send a patch series. Though I grabbed the
all in one patch and looked at irq.c and time.c. Comments inlined
below.

--- /dev/null
+++ b/arch/tile/kernel/irq.c

+struct tile_irq_desc {
+	void (*handler)(void *);
+	void *dev_id;
+};
+
+struct tile_irq_desc tile_irq_desc[NR_IRQS] __cacheline_aligned;
+
+/**
+ * tile_request_irq() - Allocate an interrupt handling instance.
+ * @handler: the device driver interrupt handler to be called.
+ * @dev_id: a cookie passed back to the handler function.
+ * @index: index into the interrupt handler table to set. It's
+ *              derived from the interrupt bit mask allocated by the HV.
+ *
+ * Each device should call this function to register its interrupt
+ * handler. dev_id must be globally unique. Normally the address of the
+ * device data structure is used as the cookie.

  Why are you implementing your private interrupt handling
  infrastructure ? What's wrong with the generic interrupt handling
  code ? Why is each device driver forced to call tile_request_irq()
  which makes it incompatible to the rest of the kernel and therefor
  unshareable ?

+ */
+void tile_request_irq(void (*handler)(void *), void *dev_id, int index)
+{
+	struct tile_irq_desc *irq_desc;
+
+	BUG_ON(!handler);
+	BUG_ON(index < 0 || index >= NR_IRQS);
+
+	irq_desc = tile_irq_desc + index;
+	irq_desc->handler = handler;
+	irq_desc->dev_id = dev_id;
+}
+EXPORT_SYMBOL(tile_request_irq);
+
+void tile_free_irq(int index)
+{
+	struct tile_irq_desc *irq_desc;
+
+	BUG_ON(index < 0 || index >= NR_IRQS);
+
+	irq_desc = tile_irq_desc + index;
+	irq_desc->handler = NULL;
+	irq_desc->dev_id = NULL;
+}
+EXPORT_SYMBOL(tile_free_irq);

  That code lacks any kind of protection and serialization.

+	for (count = 0; pending_dev_intr_mask; ++count) {
+		if (pending_dev_intr_mask & 0x1) {
+			struct tile_irq_desc *desc = &tile_irq_desc[count];
+			if (desc->handler == NULL) {
+				printk(KERN_ERR "Ignoring hv dev interrupt %d;"
+				       " handler not registered!\n", count);
+			} else {
+				desc->handler(desc->dev_id);

  You check desc->handler, but you happily call the handler while
  dev_id might be still NULL. See above.

+/*
+From struct irq_chip (same as hv_interrupt_type):
+	const char	name;
+	unsigned int	startup - has default, calls enable
+	void		shutdown - has default, calls disable
+	void		enable - has default, calls unmask
+	void		disable - has default, calls mask
+	void		ack - required
+	void		mask - required
+	void		mask_ack - optional - calls mask,ack
+	void		unmask - required - optional for some?
+	void		eoi - required for for fasteoi, percpu
+	void		end - not used
+	void		set_affinity
+	int		retrigger - optional
+	int		set_type - optional
+	int		set_wake - optional
+	void		release - optional
+*/

  Please do not replicate the comments from include/linux/irq.h as
  they are subject to change.

+/*
+ * Generic, controller-independent functions:
+ */
+
+int show_interrupts(struct seq_file *p, void *v)
+{
+	int i = *(loff_t *) v, j;
+	struct irqaction *action;
+	unsigned long flags;
+
+	if (i == 0) {
+		seq_printf(p, "           ");
+		for (j = 0; j < NR_CPUS; j++)
+			if (cpu_online(j))
+				seq_printf(p, "CPU%-8d", j);
+		seq_putc(p, '\n');
+	}
+
+	if (i < NR_IRQS) {
+		raw_spin_lock_irqsave(&irq_desc[i].lock, flags);
+		action = irq_desc[i].action;
+		if (!action)
+			goto skip;
+		seq_printf(p, "%3d: ", i);
+#ifndef CONFIG_SMP
+		seq_printf(p, "%10u ", kstat_irqs(i));
+#else
+		for_each_online_cpu(j)
+			seq_printf(p, "%10u ", kstat_irqs_cpu(i, j));
+#endif
+		seq_printf(p, " %14s", irq_desc[i].chip->typename);
+		seq_printf(p, "  %s", action->name);
+
+		for (action = action->next; action; action = action->next)
+			seq_printf(p, ", %s", action->name);
+
+		seq_putc(p, '\n');
+skip:
+		raw_spin_unlock_irqrestore(&irq_desc[i].lock, flags);
+	}
+	return 0;

  So that prints which interrupts ? Now you refer to the generic code,
  while above you require that tile specific one. -ENOSENSE.

+}
+/*
+ * This is used with the handle_level_irq handler for legacy
+ * interrupts.
+ *
+ * These functions can probably be reused with edge sensitive
+ * interrupts.
+ */
+static struct irq_chip chip_irq_legacy = {
+	.typename = "TILE-LEGACY",
+	.mask_ack = chip_mask_ack_level,
+	.disable = chip_disable_interrupt,
+	.eoi = NULL,

  No need for NULL initialization

+	.unmask = chip_unmask_level,
+};
+
+static struct irq_chip chip_irq_edge = {
+	.typename = "TILE-EDGE",
+	.mask = chip_mask_edge,
+	.eoi = NULL,

 Ditto

+	.ack = chip_ack_edge,
+	.unmask = chip_unmask_edge,
+};
+
+/*
+ * Handler for PCI IRQs.  This acts as a shim between the IRQ
+ * framework at the top of this file and the conventional linux framework.
+ * Invoked from tile_dev_intr() as a handler, with interrupts disabled.

  Why do you need this shim layer at all ?

+ */
+static void tile_irq_shim(void *dev)
+{
+	int hv_irq = (int)(unsigned long)dev;
+
+
+
+	generic_handle_irq(hv_irq);
+}

--- /dev/null
+++ b/arch/tile/kernel/time.c

+/* How many cycles per second we are running at. */
+static cycles_t cycles_per_sec __write_once;
+static u32 cyc2ns_mult __write_once;
+#define cyc2ns_shift 30

  Please do not use fixed shift values. Use the generic functions to
  calculate the optimal shift/mult pairs instead. 

+cycles_t get_clock_rate() { return cycles_per_sec; }

  Eek. Please use proper coding style.

+
+/*
+ * Called very early from setup_arch() to set cycles_per_sec.
+ * Also called, if required, by sched_clock(), which can be even
+ * earlier if built with CONFIG_LOCKDEP (during lockdep_init).
+ * We initialize it early so we can use it to set up loops_per_jiffy.
+ */
+void setup_clock(void)
+{
+	u64 mult;
+
+	if (cyc2ns_mult)
+		return;
+	cycles_per_sec = hv_sysconf(HV_SYSCONF_CPU_SPEED);
+
+	/*
+	 * Compute cyc2ns_mult, as used in sched_clock().
+	 * For efficiency of multiplication we want this to be a
+	 * 32-bit value, so we validate that here.  We want as large a
+	 * shift value as possible for precision, but too large a
+	 * shift would make cyc2ns_mult more than 32 bits.  We pick a
+	 * constant value that works well with our typical
+	 * frequencies, though we could in principle compute the most
+	 * precise value dynamically instead.  We can't make the shift
+	 * greater than 32 without fixing the algorithm.
+	 */
+	mult = (1000000000ULL << cyc2ns_shift) / cycles_per_sec;
+	cyc2ns_mult = (u32) mult;
+	BUILD_BUG_ON(cyc2ns_shift > 32);
+	BUG_ON(mult != cyc2ns_mult);

  See above.

+}
+
+#if CHIP_HAS_SPLIT_CYCLE()

  That should be a CONFIG_TILE_HAS_SPLIT_CYCLE and not a function like
  macro define somewhere in a header file.

+cycles_t get_cycles()
+{
+	return get_cycle_count();
+}
+#endif
+
+cycles_t clocksource_get_cycles(struct clocksource *cs)
+{
+	return get_cycles();
+}
+
+static struct clocksource cycle_counter_clocksource = {
+	.name = "cycle counter",
+	.rating = 300,
+	.read = clocksource_get_cycles,
+	.mask = CLOCKSOURCE_MASK(64),
+	.flags = CLOCK_SOURCE_IS_CONTINUOUS,
+};
+
+/* Called fairly late in init/main.c, but before we go smp. */
+void __init time_init(void)
+{
+	struct clocksource *src = &cycle_counter_clocksource;
+
+	/* Pick an arbitrary time to start us up. */
+	xtime.tv_sec = mktime(1970, 1, 1, 0, 0, 0);
+	xtime.tv_nsec = 0;

  Please do not touch xtime. The core code sets it to 1970 already.

+	/* Initialize and register the clock source. */
+	src->shift = 20;  /* arbitrary */
+	src->mult = (1000000000ULL << src->shift) / cycles_per_sec;

  See above.

+	clocksource_register(src);
+
+	/* Start up the tile-timer interrupt source on the boot cpu. */
+	setup_tile_timer();
+}
+
+
+/*
+ * Provide support for effectively turning the timer interrupt on and
+ * off via the interrupt mask.  Make sure not to unmask it while we are
+ * running the timer interrupt handler, to avoid recursive timer
+ * interrupts; these may be OK in some cases, but it's generally cleaner
+ * to reset the kernel stack before starting the next timer interrupt.

  Which would already be guaranteed by the generic interrupt code ....
  The clockevent callbacks are already called with interrupts
  disabled, so why all this magic ?

+ */
+
+/* Track some status about the timer interrupt. */
+struct timer_status {
+	int enabled;   /* currently meant to be enabled? */
+	int in_intr;   /* currently in the interrupt handler? */
+};
+static DEFINE_PER_CPU(struct timer_status, timer_status);
+
+/* Enable the timer interrupt, unless we're in the handler. */
+static void enable_timer_intr(void)
+{
+	struct timer_status *status = &__get_cpu_var(timer_status);
+	status->enabled = 1;
+	if (status->in_intr)
+		return;
+	raw_local_irq_unmask_now(INT_TILE_TIMER);
+}
+
+/* Disable the timer interrupt. */
+static void disable_timer_intr(void)
+{
+	struct timer_status *status = &__get_cpu_var(timer_status);
+	status->enabled = 0;
+	raw_local_irq_mask_now(INT_TILE_TIMER);
+}
+
+/* Mark the start of processing for the timer interrupt. */
+static void start_timer_intr(void)
+{
+	struct timer_status *status = &__get_cpu_var(timer_status);
+	status->in_intr = 1;
+	disable_timer_intr();
+}
+
+/* Mark end of processing for the timer interrupt, unmasking if necessary. */
+static void end_timer_intr(void)
+{
+	struct timer_status *status = &__get_cpu_var(timer_status);
+	status->in_intr = 0;
+	if (status->enabled)
+		enable_timer_intr();
+}
+
+
+/*
+ * Define the tile timer clock event device.  The timer is driven by
+ * the TILE_TIMER_CONTROL register, which consists of a 31-bit down
+ * counter, plus bit 31, which signifies that the counter has wrapped
+ * from zero to (2**31) - 1.  The INT_TILE_TIMER interrupt will be
+ * raised as long as bit 31 is set.
+ */
+
+#define MAX_TICK 0x7fffffff   /* we have 31 bits of countdown timer */
+
+static int tile_timer_set_next_event(unsigned long ticks,
+				     struct clock_event_device *evt)
+{
+	BUG_ON(ticks > MAX_TICK);
+	__insn_mtspr(SPR_TILE_TIMER_CONTROL, ticks);
+	enable_timer_intr();
+	return 0;
+}
+
+/*
+ * Whenever anyone tries to change modes, we just mask interrupts
+ * and wait for the next event to get set.
+ */
+static void tile_timer_set_mode(enum clock_event_mode mode,
+				struct clock_event_device *evt)
+{
+	disable_timer_intr();
+}
+
+static DEFINE_PER_CPU(struct clock_event_device, tile_timer) = {
+	.name = "tile timer",
+	.features = CLOCK_EVT_FEAT_ONESHOT,
+	.min_delta_ns = 1000,  /* at least 1000 cycles to fire the interrupt */

  That's not cycles. That's nano seconds ! And please avoid tail comments.

+	.rating = 100,
+	.irq = -1,
+	.set_next_event = tile_timer_set_next_event,
+	.set_mode = tile_timer_set_mode,
+};
+
+void __cpuinit setup_tile_timer(void)
+{
+	struct clock_event_device *evt = &__get_cpu_var(tile_timer);
+
+	/* Fill in fields that are speed-specific. */
+	evt->shift = 20;  /* arbitrary */
+	evt->mult = (cycles_per_sec << evt->shift) / 1000000000ULL;

  See above.	

+	evt->max_delta_ns = (MAX_TICK * 1000000000ULL) / cycles_per_sec;

  There is a generic function for this as well. Please use it.

+	/* Mark as being for this cpu only. */
+	evt->cpumask = cpumask_of(smp_processor_id());
+
+	/* Start out with timer not firing. */
+	disable_timer_intr();
+
+	/* Register tile timer. */
+	clockevents_register_device(evt);
+}
+
+/* Called from the interrupt vector. */
+void do_timer_interrupt(struct pt_regs *regs, int fault_num)
+{
+	struct pt_regs *old_regs = set_irq_regs(regs);
+	struct clock_event_device *evt = &__get_cpu_var(tile_timer);
+
+	/* Mask timer interrupts in case someone enable interrupts later. */
+	start_timer_intr();

  Nothing enables interrupts in the timer interrupt handler code path.

+	/* Track time spent here in an interrupt context */
+	irq_enter();
+
+	/* Track interrupt count. */
+	__get_cpu_var(irq_stat).irq_timer_count++;
+
+	/* Call the generic timer handler */
+	evt->event_handler(evt);
+
+	/*
+	 * Track time spent against the current process again and
+	 * process any softirqs if they are waiting.
+	 */
+	irq_exit();
+
+	/*
+	 * Enable the timer interrupt (if requested) with irqs disabled,
+	 * so we don't get recursive timer interrupts.
+	 */
+	local_irq_disable();

  The code above does _NOT_ reenable interrupts. And if it would, then
  you would break irq_exit() assumptions as well.

+	end_timer_intr();
+
+	set_irq_regs(old_regs);
+}
+
+/*
+ * Scheduler clock - returns current time in nanosec units.
+ *
+ * The normal algorithm computes (cycles * cyc2ns_mult) >> cyc2ns_shift.
+ * We can make it potentially more efficient and with a better range
+ * by writing "cycles" as two 32-bit components, "(H << 32) + L" and
+ * then factoring.  Here we use M = cyc2ns_mult and S = cyc2ns_shift.
+ *
+ *   (((H << 32) + L) * M) >> S =
+ *    (((H << 32) * M) >> S) + ((L * M) >> S) =
+ *    ((H * M) << (32 - S)) + ((L * M) >> S)
+ */
+unsigned long long sched_clock(void)
+{
+	u64 cycles;
+	u32 cyc_hi, cyc_lo;
+
+	if (unlikely(cyc2ns_mult == 0))
+		setup_clock();

  Please initialize stuff _before_ it is called the first time and not
  at some arbitrary point conditionally in a hotpath.

+
+	cycles = get_cycles();
+	cyc_hi = (u32) (cycles >> 32);
+	cyc_lo = (u32) (cycles);
+
+	/* Compiler could optimize the 32x32 -> 64 multiplies here. */
+	return ((cyc_hi * (u64)cyc2ns_mult) << (32 - cyc2ns_shift)) +
+		((cyc_lo * (u64)cyc2ns_mult) >> cyc2ns_shift);
+}
+
+int setup_profiling_timer(unsigned int multiplier)
+{
+	return -EINVAL;
+}

Thanks,

	tglx
