Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760154Ab2D0Lqm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 07:46:42 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:43055 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759914Ab2D0Lqk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 07:46:40 -0400
MIME-Version: 1.0
In-Reply-To: <20120427082203.GB9233@aftab.osrc.amd.com>
References: <fa.CZQqvHf3CBfYWzhSDPNOWxTTD9w@ifi.uio.no>
	<fa.Vmg5vDod2/oKvwyy9BcalhoT+Lo@ifi.uio.no>
	<14969994.2790.1335342903511.JavaMail.geo-discussion-forums@vbbfr18>
	<4F97BA60.4080505@ladisch.de>
	<20120427082203.GB9233@aftab.osrc.amd.com>
Date: Fri, 27 Apr 2012 13:46:39 +0200
Message-ID: <CAPRPZsCHAOvemogn7mWnWfykhANeEx5K=OG9Xt+veDjEWOiDYA@mail.gmail.com>
Subject: Re: Unhandled IRQs on AMD E-450
From: Jeroen Van den Keybus <jeroen.vandenkeybus@gmail.com>
To: Borislav Petkov <borislav.petkov@amd.com>
Cc: Clemens Ladisch <clemens@ladisch.de>, andymatei@gmail.com,
        "Huang, Shane" <Shane.Huang@amd.com>, Borislav Petkov <bp@amd64.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> So why aren't you guys producing a proper patch for people to test?

I have been working on a patch for 3.4-rc2, in which I also
implemented another mechanism to detect a stuck interrupt (using a
level mechanism: an unhandled IRQ increases the level by, say, 10, and
a handled one reduces the level by 1. It is considered stuck when the
level reaches e.g. 100). It also implements proper dmesg reporting. I
also looked for x86'isms as suggested by Alan, but I think there's no
problem.

However, while testing, I noticed that the stuck interrupt detection
fired also on MSI interrupts in the 3.4 kernel under heavy load,
suggesting that these would also be suffering from being unhandled.

The patch also includes Clemens' patch to put the disk IRQ on MSI,
which makes the E450 board actually usable.

I haven't had time to debug the new issue (false stuck irq detection
in 3.4 - not too harmful since the interrupt is reenabled a second
later, but wrong nevertheless). If any of you is willing to help and
have a look into the code, I have attached it below.

(There's also a small patch that accidentally got in there to
reimplement cpu_possible_map, as it was needed by the fglrx driver I'm
using. Please disregard. Or use.)

Another problem is the arming of the timer (mod_timer), which may
cause an incorrect poll interval when a IRQ gets stuck while anotther
one is being polled (either because it's also stuck and polling or
because forced polling is on for that particular one).


Jeroen.



Only in linux-3.4-rc2/arch/x86/include: generated
diff -upr linux-3.4-rc2.orig/drivers/pci/quirks.c
linux-3.4-rc2/drivers/pci/quirks.c
--- linux-3.4-rc2.orig/drivers/pci/quirks.c	2012-04-08 03:30:41.000000000 +0200
+++ linux-3.4-rc2/drivers/pci/quirks.c	2012-04-11 11:33:42.821707398 +0200
@@ -2917,6 +2917,48 @@ static void __devinit disable_igfx_irq(s
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL, 0x0102, disable_igfx_irq);
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL, 0x010a, disable_igfx_irq);

+#if defined(CONFIG_PCI_MSI) && \
+       (defined(CONFIG_SATA_AHCI) || defined(CONFIG_SATA_AHCI_MODULE))
+static void __init sb7x0_ahci_msi_enable(struct pci_dev *dev)
+{
+       u8 rev, ptr;
+       int where;
+       u32 misc_control;
+
+       pci_bus_read_config_byte(dev->bus, PCI_DEVFN(0x14, 0),
+                                PCI_REVISION_ID, &rev);
+       if (rev < 0x3c) /* A14 */
+               return;
+
+       pci_read_config_byte(dev, 0x34, &ptr);
+       if (ptr == 0x70) {
+               where = 0x34;
+       } else {
+               pci_read_config_byte(dev, 0x61, &ptr);
+               if (ptr == 0x70)
+                       where = 0x61;
+               else
+                       return;
+       }
+
+       pci_read_config_byte(dev, 0x51, &ptr);
+       if (ptr != 0x70)
+               return;
+
+       pci_read_config_dword(dev, 0x40, &misc_control);
+       misc_control |= 1;
+       pci_write_config_dword(dev, 0x40, misc_control);
+
+       pci_write_config_byte(dev, where, 0x50);
+
+       misc_control &= ~1;
+       pci_write_config_dword(dev, 0x40, misc_control);
+
+       dev_dbg(&dev->dev, "AHCI: enabled MSI\n");
+}
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_ATI, 0x4391, sb7x0_ahci_msi_enable);
+#endif
+
 static void pci_do_fixups(struct pci_dev *dev, struct pci_fixup *f,
 			  struct pci_fixup *end)
 {
Only in linux-3.4-rc2/drivers/pci: quirks.c.orig
Only in linux-3.4-rc2/include: config
Only in linux-3.4-rc2/include: generated
diff -upr linux-3.4-rc2.orig/include/linux/cpumask.h
linux-3.4-rc2/include/linux/cpumask.h
--- linux-3.4-rc2.orig/include/linux/cpumask.h	2012-04-08
03:30:41.000000000 +0200
+++ linux-3.4-rc2/include/linux/cpumask.h	2012-04-15 21:05:55.733994054 +0200
@@ -764,6 +764,7 @@ static inline const struct cpumask *get_
  *
  */
 #ifndef CONFIG_DISABLE_OBSOLETE_CPUMASK_FUNCTIONS
+#define cpu_possible_map        (*(cpumask_t *)cpu_possible_mask)
 #define cpumask_of_cpu(cpu) (*get_cpu_mask(cpu))

 #define CPU_MASK_LAST_WORD BITMAP_LAST_WORD_MASK(NR_CPUS)
diff -upr linux-3.4-rc2.orig/include/linux/irqdesc.h
linux-3.4-rc2/include/linux/irqdesc.h
--- linux-3.4-rc2.orig/include/linux/irqdesc.h	2012-04-08
03:30:41.000000000 +0200
+++ linux-3.4-rc2/include/linux/irqdesc.h	2012-04-15 15:26:07.776394544 +0200
@@ -14,28 +14,27 @@ struct timer_rand_state;
 struct module;
 /**
  * struct irq_desc - interrupt descriptor
- * @irq_data:		per irq and chip data passed down to chip functions
- * @timer_rand_state:	pointer to timer rand state struct
- * @kstat_irqs:		irq stats per cpu
- * @handle_irq:		highlevel irq-events handler
- * @preflow_handler:	handler called before the flow handler
(currently used by sparc)
- * @action:		the irq action chain
- * @status:		status information
- * @core_internal_state__do_not_mess_with_it: core internal status information
- * @depth:		disable-depth, for nested irq_disable() calls
- * @wake_depth:		enable depth, for multiple irq_set_irq_wake() callers
- * @irq_count:		stats field to detect stalled irqs
- * @last_unhandled:	aging timer for unhandled count
- * @irqs_unhandled:	stats field for spurious unhandled interrupts
- * @lock:		locking for SMP
- * @affinity_hint:	hint to user space for preferred irq affinity
- * @affinity_notify:	context for notification of affinity changes
- * @pending_mask:	pending rebalanced interrupts
- * @threads_oneshot:	bitfield to handle shared oneshot threads
- * @threads_active:	number of irqaction threads currently running
- * @wait_for_threads:	wait queue for sync_irq to wait for threaded handlers
- * @dir:		/proc/irq/ procfs entry
- * @name:		flow handler name for /proc/interrupts output
+ * @irq_data:			per irq and chip data passed down to chip functions
+ * @timer_rand_state:		pointer to timer rand state struct
+ * @kstat_irqs:			irq stats per cpu
+ * @handle_irq:			highlevel irq-events handler
+ * @preflow_handler:		handler called before the flow handler
(currently used by sparc)
+ * @action:			the irq action chain
+ * @status:			status information
+ * @istate:			core internal status information
+ * @depth:			disable-depth, for nested irq_disable() calls
+ * @wake_depth:			enable depth, for multiple irq_set_irq_wake() callers
+ * @irqs_unhandled_level:	stats field for unhandled interrupt
detection and tracking poll cycle count
+ * @irqs_unhandled_count:	stats field for counting unhandled
interrupt detections
+ * @lock:			locking for SMP
+ * @affinity_hint:		hint to user space for preferred irq affinity
+ * @affinity_notify:		context for notification of affinity changes
+ * @pending_mask:		pending rebalanced interrupts
+ * @threads_oneshot:		bitfield to handle shared oneshot threads
+ * @threads_active:		number of irqaction threads currently running
+ * @wait_for_threads:		wait queue for sync_irq to wait for threaded handlers
+ * @dir:			/proc/irq/ procfs entry
+ * @name:			flow handler name for /proc/interrupts output
  */
 struct irq_desc {
 	struct irq_data		irq_data;
@@ -47,12 +46,11 @@ struct irq_desc {
 #endif
 	struct irqaction	*action;	/* IRQ action list */
 	unsigned int		status_use_accessors;
-	unsigned int		core_internal_state__do_not_mess_with_it;
+	unsigned int		istate;
 	unsigned int		depth;		/* nested irq disables */
 	unsigned int		wake_depth;	/* nested wake enables */
-	unsigned int		irq_count;	/* For detecting broken IRQs */
-	unsigned long		last_unhandled;	/* Aging timer for unhandled count */
-	unsigned int		irqs_unhandled;
+	unsigned int		irqs_unhandled_level;
+	unsigned int		irqs_unhandled_count;
 	raw_spinlock_t		lock;
 	struct cpumask		*percpu_enabled;
 #ifdef CONFIG_SMP
Only in linux-3.4-rc2/include/linux: version.h
diff -upr linux-3.4-rc2.orig/kernel/irq/debug.h linux-3.4-rc2/kernel/irq/debug.h
--- linux-3.4-rc2.orig/kernel/irq/debug.h	2012-04-08 03:30:41.000000000 +0200
+++ linux-3.4-rc2/kernel/irq/debug.h	2012-04-15 15:23:36.963893571 +0200
@@ -11,8 +11,8 @@

 static inline void print_irq_desc(unsigned int irq, struct irq_desc *desc)
 {
-	printk("irq %d, desc: %p, depth: %d, count: %d, unhandled: %d\n",
-		irq, desc, desc->depth, desc->irq_count, desc->irqs_unhandled);
+	printk("irq %d, desc: %p, depth: %d, unhandled_level: %d,
unhandled_count: %d\n",
+		irq, desc, desc->depth, desc->irqs_unhandled_level,
desc->irqs_unhandled_count);
 	printk("->handle_irq():  %p, ", desc->handle_irq);
 	print_symbol("%s\n", (unsigned long)desc->handle_irq);
 	printk("->irq_data.chip(): %p, ", desc->irq_data.chip);
diff -upr linux-3.4-rc2.orig/kernel/irq/internals.h
linux-3.4-rc2/kernel/irq/internals.h
--- linux-3.4-rc2.orig/kernel/irq/internals.h	2012-04-08
03:30:41.000000000 +0200
+++ linux-3.4-rc2/kernel/irq/internals.h	2012-04-15 14:02:57.203854533 +0200
@@ -13,8 +13,6 @@
 # define IRQ_BITMAP_BITS	NR_IRQS
 #endif

-#define istate core_internal_state__do_not_mess_with_it
-
 extern bool noirqdebug;

 /*
diff -upr linux-3.4-rc2.orig/kernel/irq/irqdesc.c
linux-3.4-rc2/kernel/irq/irqdesc.c
--- linux-3.4-rc2.orig/kernel/irq/irqdesc.c	2012-04-08 03:30:41.000000000 +0200
+++ linux-3.4-rc2/kernel/irq/irqdesc.c	2012-04-15 15:28:20.552831286 +0200
@@ -84,8 +84,8 @@ static void desc_set_defaults(unsigned i
 	irqd_set(&desc->irq_data, IRQD_IRQ_DISABLED);
 	desc->handle_irq = handle_bad_irq;
 	desc->depth = 1;
-	desc->irq_count = 0;
-	desc->irqs_unhandled = 0;
+	desc->irqs_unhandled_level = 0;
+	desc->irqs_unhandled_count = 0;
 	desc->name = NULL;
 	desc->owner = owner;
 	for_each_possible_cpu(cpu)
diff -upr linux-3.4-rc2.orig/kernel/irq/manage.c
linux-3.4-rc2/kernel/irq/manage.c
--- linux-3.4-rc2.orig/kernel/irq/manage.c	2012-04-08 03:30:41.000000000 +0200
+++ linux-3.4-rc2/kernel/irq/manage.c	2012-04-15 15:29:30.169058703 +0200
@@ -1086,8 +1086,8 @@ __setup_irq(unsigned int irq, struct irq
 	*old_ptr = new;

 	/* Reset broken irq detection when installing new handler */
-	desc->irq_count = 0;
-	desc->irqs_unhandled = 0;
+	desc->irqs_unhandled_level = 0;
+	desc->irqs_unhandled_count = 0;

 	/*
 	 * Check whether we disabled the irq via the spurious handler
diff -upr linux-3.4-rc2.orig/kernel/irq/proc.c linux-3.4-rc2/kernel/irq/proc.c
--- linux-3.4-rc2.orig/kernel/irq/proc.c	2012-04-08 03:30:41.000000000 +0200
+++ linux-3.4-rc2/kernel/irq/proc.c	2012-04-15 15:36:37.734432932 +0200
@@ -248,9 +248,8 @@ static int irq_spurious_proc_show(struct
 {
 	struct irq_desc *desc = irq_to_desc((long) m->private);

-	seq_printf(m, "count %u\n" "unhandled %u\n" "last_unhandled %u ms\n",
-		   desc->irq_count, desc->irqs_unhandled,
-		   jiffies_to_msecs(desc->last_unhandled));
+	seq_printf(m, "unhandled_level %u\n" "unhandled_count %u\n",
+		   desc->irqs_unhandled_level, desc->irqs_unhandled_count);
 	return 0;
 }

diff -upr linux-3.4-rc2.orig/kernel/irq/spurious.c
linux-3.4-rc2/kernel/irq/spurious.c
--- linux-3.4-rc2.orig/kernel/irq/spurious.c	2012-04-08 03:30:41.000000000 +0200
+++ linux-3.4-rc2/kernel/irq/spurious.c	2012-04-15 15:40:33.947176490 +0200
@@ -18,7 +18,12 @@

 static int irqfixup __read_mostly;

-#define POLL_SPURIOUS_IRQ_INTERVAL (HZ/10)
+#define SPURIOUS_IRQ_PENALTY 10
+#define SPURIOUS_IRQ_TRIGGER 100
+#define SPURIOUS_IRQ_REPORT_COUNT 5
+#define SPURIOUS_IRQ_POLL_CYCLES 100
+#define SPURIOUS_IRQ_POLL_INTERVAL (HZ/100)
+
 static void poll_spurious_irqs(unsigned long dummy);
 static DEFINE_TIMER(poll_spurious_irq_timer, poll_spurious_irqs, 0, 0);
 static int irq_poll_cpu;
@@ -141,14 +146,15 @@ out:
 static void poll_spurious_irqs(unsigned long dummy)
 {
 	struct irq_desc *desc;
-	int i;
+	int i, poll_again;

 	if (atomic_inc_return(&irq_poll_active) != 1)
 		goto out;
 	irq_poll_cpu = smp_processor_id();

+	poll_again = 0; /* Will stay false as long as no polling candidate is found */
 	for_each_irq_desc(i, desc) {
-		unsigned int state;
+		unsigned int state, irq;

 		if (!i)
 			 continue;
@@ -158,15 +164,38 @@ static void poll_spurious_irqs(unsigned
 		barrier();
 		if (!(state & IRQS_SPURIOUS_DISABLED))
 			continue;
-
-		local_irq_disable();
-		try_one_irq(i, desc, true);
-		local_irq_enable();
+		
+		/* We end up here with a disabled spurious interrupt.
+		   desc->irqs_unhandled_level now tracks the number of times
+		   the interrupt has been polled */
+
+		irq = desc->irq_data.irq;
+		if (desc->irqs_unhandled_level < SPURIOUS_IRQ_POLL_CYCLES) {
+			if (unlikely(desc->irqs_unhandled_count <= SPURIOUS_IRQ_REPORT_COUNT))
+				if (desc->irqs_unhandled_level == 0)
+					printk(KERN_EMERG "Polling handlers for IRQ %d.\n", irq);
+			local_irq_disable();
+			try_one_irq(i, desc, true);
+			local_irq_enable();
+			desc->irqs_unhandled_level++;
+			poll_again = 1;
+		} else {
+			if (unlikely(desc->irqs_unhandled_count <= SPURIOUS_IRQ_REPORT_COUNT)) {
+				printk(KERN_EMERG "Reenabling IRQ %d.\n", irq);
+				if (desc->irqs_unhandled_count == SPURIOUS_IRQ_REPORT_COUNT)
+					printk(KERN_EMERG "No more stuck interrupt occurrences will be
reported for IRQ %d.\n", irq);
+			}
+			irq_enable(desc); /* Reenable the interrupt line */
+			desc->depth--;
+			desc->istate &= (~IRQS_SPURIOUS_DISABLED);
+			desc->irqs_unhandled_level = 0;
+		}
 	}
+	if (poll_again)
+		mod_timer(&poll_spurious_irq_timer,
+			  jiffies + SPURIOUS_IRQ_POLL_INTERVAL);
 out:
 	atomic_dec(&irq_poll_active);
-	mod_timer(&poll_spurious_irq_timer,
-		  jiffies + POLL_SPURIOUS_IRQ_INTERVAL);
 }

 static inline int bad_action_ret(irqreturn_t action_ret)
@@ -176,14 +205,6 @@ static inline int bad_action_ret(irqretu
 	return 1;
 }

-/*
- * If 99,900 of the previous 100,000 interrupts have not been handled
- * then assume that the IRQ is stuck in some manner. Drop a diagnostic
- * and try to turn the IRQ off.
- *
- * (The other 100-of-100,000 interrupts may have been a correctly
- *  functioning device sharing an IRQ with the failing one)
- */
 static void
 __report_bad_irq(unsigned int irq, struct irq_desc *desc,
 		 irqreturn_t action_ret)
@@ -272,7 +293,6 @@ void note_interrupt(unsigned int irq, st
 	if (desc->istate & IRQS_POLL_INPROGRESS)
 		return;

-	/* we get here again via the threaded handler */
 	if (action_ret == IRQ_WAKE_THREAD)
 		return;

@@ -281,48 +301,36 @@ void note_interrupt(unsigned int irq, st
 		return;
 	}

-	if (unlikely(action_ret == IRQ_NONE)) {
-		/*
-		 * If we are seeing only the odd spurious IRQ caused by
-		 * bus asynchronicity then don't eventually trigger an error,
-		 * otherwise the counter becomes a doomsday timer for otherwise
-		 * working systems
-		 */
-		if (time_after(jiffies, desc->last_unhandled + HZ/10))
-			desc->irqs_unhandled = 1;
-		else
-			desc->irqs_unhandled++;
-		desc->last_unhandled = jiffies;
-	}
-
-	if (unlikely(try_misrouted_irq(irq, desc, action_ret))) {
-		int ok = misrouted_irq(irq);
-		if (action_ret == IRQ_NONE)
-			desc->irqs_unhandled -= ok;
-	}
-
-	desc->irq_count++;
-	if (likely(desc->irq_count < 100000))
-		return;
+	/* Adjust action_ret if an optional poll was successful.
+	   (See inlined try_misrouted_irq() for conditions (depending
+	   on 'irqfixup' and 'irqpoll'), and 'noirqdebug' must not
+	   be set, since we wouldn't be here (note_interrupt())
+	   at all in that case.) */
+	if (unlikely(try_misrouted_irq(irq, desc, action_ret)))
+		if (misrouted_irq(irq))
+			action_ret = IRQ_HANDLED;

-	desc->irq_count = 0;
-	if (unlikely(desc->irqs_unhandled > 99900)) {
-		/*
-		 * The interrupt is stuck
-		 */
-		__report_bad_irq(irq, desc, action_ret);
-		/*
-		 * Now kill the IRQ
-		 */
-		printk(KERN_EMERG "Disabling IRQ #%d\n", irq);
-		desc->istate |= IRQS_SPURIOUS_DISABLED;
-		desc->depth++;
-		irq_disable(desc);
-
-		mod_timer(&poll_spurious_irq_timer,
-			  jiffies + POLL_SPURIOUS_IRQ_INTERVAL);
+	if (unlikely(action_ret == IRQ_NONE)) {
+		desc->irqs_unhandled_level += SPURIOUS_IRQ_PENALTY;
+		if (desc->irqs_unhandled_level >= SPURIOUS_IRQ_TRIGGER) { /* The
interrupt is stuck */
+			desc->irqs_unhandled_count++;
+			if (desc->irqs_unhandled_count <= SPURIOUS_IRQ_REPORT_COUNT) {
+				__report_bad_irq(irq, desc, action_ret);
+				printk(KERN_EMERG "Disabling IRQ %d.\n", irq);
+			}
+			desc->istate |= IRQS_SPURIOUS_DISABLED;
+			desc->depth++;
+			irq_disable(desc);
+			/* TODO: Do a safe access to the timer. Now we may be extending a deadline
+			   for a polling system already running for another interrupt. */
+			mod_timer(&poll_spurious_irq_timer,
+			          jiffies + SPURIOUS_IRQ_POLL_INTERVAL); /* Schedule a poll cycle */
+			desc->irqs_unhandled_level = 0;
+		}
 	}
-	desc->irqs_unhandled = 0;
+	else
+		if (unlikely(desc->irqs_unhandled_level > 0))
+			desc->irqs_unhandled_level--;
 }

 bool noirqdebug __read_mostly;
Only in linux-3.4-rc2/kernel/irq: spurious.c.k32
Only in linux-3.4-rc2/kernel/irq: spurious.c.k32.orig
Only in linux-3.4-rc2/kernel/irq: spurious.c.orig
Only in linux-3.4-rc2/scripts/basic: fixdep
Only in linux-3.4-rc2/scripts: conmakehash
Only in linux-3.4-rc2/scripts/genksyms: genksyms
Only in linux-3.4-rc2/scripts/genksyms: keywords.hash.c
Only in linux-3.4-rc2/scripts/genksyms: lex.lex.c
Only in linux-3.4-rc2/scripts/genksyms: parse.tab.c
Only in linux-3.4-rc2/scripts/genksyms: parse.tab.h
Only in linux-3.4-rc2/scripts: kallsyms
Only in linux-3.4-rc2/scripts/kconfig: conf
Only in linux-3.4-rc2/scripts/kconfig: zconf.hash.c
Only in linux-3.4-rc2/scripts/kconfig: zconf.lex.c
Only in linux-3.4-rc2/scripts/kconfig: zconf.tab.c
Only in linux-3.4-rc2/scripts/mod: elfconfig.h
Only in linux-3.4-rc2/scripts/mod: mk_elfconfig
Only in linux-3.4-rc2/scripts/mod: modpost
Only in linux-3.4-rc2/scripts: recordmcount
Only in linux-3.4-rc2/scripts/selinux/genheaders: genheaders
Only in linux-3.4-rc2/scripts/selinux/mdp: mdp
Only in linux-3.4-rc2/security/tomoyo: builtin-policy.h
Only in linux-3.4-rc2/security/tomoyo: policy
