Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755265Ab1KWMz3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 07:55:29 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:56496 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751659Ab1KWMz1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 07:55:27 -0500
MIME-Version: 1.0
Date: Wed, 23 Nov 2011 07:55:25 -0500
X-Google-Sender-Auth: LvEwwQ-xS0CARMTVF1AcI8JUtaw
Message-ID: <CAOvdn6VeSzv63PYYWy1TEgYVSdT5Pz5wMzK2TJwZTg3PL2A-oA@mail.gmail.com>
Subject: kdb on a pvops xen kernel, with hvc
From: Ben Guthro <ben@guthro.net>
To: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org,
        Anton Blanchard <anton@samba.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've been attempting to get kdb working with a pvops kernel, and the
hvc driver - without much success.

Chageset  762e77ae7dd055d0b77e0ad34d87db7416df109e by Anton Blanchard
seemed to indicate
that support for this was added back in July, but I'm having some
issues that I'm hoping someone here
could point me in the right direction.

Below is my work in progress patch (with apologies about the excessive
trace debugging included)

However, I am having the following problem (that I'm clearly lacking
some understanding about tty
infrastructure) -

When the hvc_poll_get_char() function is called from kdb, there seems
to be no tty mapped to the
driver... I see in the dmesg log that my debug printk indicated that
it was removed from the driver.

Any pointers on why this might be would be, so I can go debug it,
would be greatly appreciated



/btg



This is against a 2.6.38 based kernel...but nothing here should be
specific to that kernel.



diff --git a/arch/x86/kernel/kgdb.c b/arch/x86/kernel/kgdb.c
index a413000..de7236b 100644
--- a/arch/x86/kernel/kgdb.c
+++ b/arch/x86/kernel/kgdb.c
@@ -515,8 +515,11 @@ static int __kgdb_notify(struct die_args *args,
unsigned long cmd)
 {
 	struct pt_regs *regs = args->regs;

+	printk(KERN_CRIT "kgdb: %s:%d\n", __func__, __LINE__);
+
 	switch (cmd) {
 	case DIE_NMI:
+		printk(KERN_CRIT "kgdb: DIE_NMI %s:%d\n", __func__, __LINE__);
 		if (atomic_read(&kgdb_active) != -1) {
 			/* KGDB CPU roundup */
 			kgdb_nmicallback(raw_smp_processor_id(), regs);
@@ -527,6 +530,7 @@ static int __kgdb_notify(struct die_args *args,
unsigned long cmd)
 		return NOTIFY_DONE;

 	case DIE_NMIUNKNOWN:
+		printk(KERN_CRIT "kgdb: DIE_NMIUNKNOWN %s:%d\n", __func__, __LINE__);
 		if (was_in_debug_nmi[raw_smp_processor_id()]) {
 			was_in_debug_nmi[raw_smp_processor_id()] = 0;
 			return NOTIFY_STOP;
@@ -534,6 +538,7 @@ static int __kgdb_notify(struct die_args *args,
unsigned long cmd)
 		return NOTIFY_DONE;

 	case DIE_NMIWATCHDOG:
+		printk(KERN_CRIT "kgdb: DIE_NMIWATCHDOG %s:%d\n", __func__, __LINE__);
 		if (atomic_read(&kgdb_active) != -1) {
 			/* KGDB CPU roundup: */
 			kgdb_nmicallback(raw_smp_processor_id(), regs);
@@ -543,6 +548,7 @@ static int __kgdb_notify(struct die_args *args,
unsigned long cmd)
 		break;

 	case DIE_DEBUG:
+		printk(KERN_CRIT "kgdb: DIE_DEBUG %s:%d\n", __func__, __LINE__);
 		if (atomic_read(&kgdb_cpu_doing_single_step) != -1) {
 			if (user_mode(regs))
 				return single_step_cont(regs, args);
@@ -554,6 +560,7 @@ static int __kgdb_notify(struct die_args *args,
unsigned long cmd)
 			return NOTIFY_DONE;
 		/* fall through */
 	default:
+		printk(KERN_CRIT "kgdb: default %s:%d\n", __func__, __LINE__);
 		if (user_mode(regs))
 			return NOTIFY_DONE;
 	}
@@ -578,6 +585,8 @@ int kgdb_ll_trap(int cmd, const char *str,

 	};

+	printk(KERN_CRIT "kgdb: %s:%d\n", __func__, __LINE__);
+
 	if (!kgdb_io_module_registered)
 		return NOTIFY_DONE;

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index d5e0e0a..b0763eb 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -40,6 +40,7 @@
 #include <xen/interface/memory.h>
 #include <xen/features.h>
 #include <xen/page.h>
+#include <xen/events.h>
 #include <xen/hvm.h>
 #include <xen/hvc-console.h>

@@ -760,6 +761,15 @@ static u32 xen_safe_apic_wait_icr_idle(void)
         return 0;
 }

+extern void xen_send_IPI_mask(const struct cpumask *mask,
+			      int vector);
+extern void xen_send_IPI_mask_allbutself(const struct cpumask *mask,
+				int vector);
+extern void xen_send_IPI_allbutself(int vector);
+extern void physflat_send_IPI_allbutself(int vector);
+extern void xen_send_IPI_all(int vector);
+extern void xen_send_IPI_self(int vector);
+
 static void set_xen_basic_apic_ops(void)
 {
 	apic->read = xen_apic_read;
@@ -768,6 +778,12 @@ static void set_xen_basic_apic_ops(void)
 	apic->icr_write = xen_apic_icr_write;
 	apic->wait_icr_idle = xen_apic_wait_icr_idle;
 	apic->safe_wait_icr_idle = xen_safe_apic_wait_icr_idle;
+
+	apic->send_IPI_allbutself = xen_send_IPI_allbutself;
+	apic->send_IPI_mask_allbutself = xen_send_IPI_mask_allbutself;
+	apic->send_IPI_mask = xen_send_IPI_mask;
+	apic->send_IPI_all = xen_send_IPI_all;
+	apic->send_IPI_self = xen_send_IPI_self;
 }

 #endif
diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
index 3061244..77863bb 100644
--- a/arch/x86/xen/smp.c
+++ b/arch/x86/xen/smp.c
@@ -436,8 +436,8 @@ static void xen_smp_send_reschedule(int cpu)
 	xen_send_IPI_one(cpu, XEN_RESCHEDULE_VECTOR);
 }

-static void xen_send_IPI_mask(const struct cpumask *mask,
-			      enum ipi_vector vector)
+void xen_send_IPI_mask(const struct cpumask *mask,
+			      int vector)
 {
 	unsigned cpu;

@@ -466,6 +466,46 @@ static void xen_smp_send_call_function_single_ipi(int cpu)
 			  XEN_CALL_FUNCTION_SINGLE_VECTOR);
 }

+void xen_send_IPI_all(int vector)
+{
+	printk(KERN_CRIT "kgdb: %s:%d\n", __func__, __LINE__);
+	xen_send_IPI_mask(cpu_online_mask, vector);
+}
+
+void xen_send_IPI_self(int vector)
+{
+	printk(KERN_CRIT "kgdb: %s:%d\n", __func__, __LINE__);
+	xen_send_IPI_one(smp_processor_id(), vector);
+}
+
+void xen_send_IPI_mask_allbutself(const struct cpumask *mask,
+				int vector)
+{
+	unsigned cpu;
+	unsigned int this_cpu = smp_processor_id();
+
+	if (!(num_online_cpus() > 1))
+		return;
+
+	printk(KERN_CRIT "kgdb: %s:%d\n", __func__, __LINE__);
+	for_each_cpu_and(cpu, mask, cpu_online_mask) {
+		if (this_cpu == cpu)
+			continue;
+		
+		printk(KERN_CRIT "kgdb: %s:%d Sending IPI for CPU %d\n",
+			__func__, __LINE__, cpu);
+		/* xen_send_IPI_one(cpu, vector); */
+		xen_smp_send_call_function_single_ipi(cpu);
+	}
+}
+
+void xen_send_IPI_allbutself(int vector)
+{
+	printk(KERN_CRIT "kgdb: %s:%d\n", __func__, __LINE__);
+	xen_send_IPI_mask_allbutself(cpu_online_mask, vector);
+}
+
+
 static irqreturn_t xen_call_function_interrupt(int irq, void *dev_id)
 {
 	irq_enter();
diff --git a/drivers/tty/hvc/hvc_console.c b/drivers/tty/hvc/hvc_console.c
index 58ca7ce..f93fdad 100644
--- a/drivers/tty/hvc/hvc_console.c
+++ b/drivers/tty/hvc/hvc_console.c
@@ -40,6 +40,7 @@
 #include <linux/freezer.h>
 #include <linux/slab.h>
 #include <linux/serial_core.h>
+#include <linux/ratelimit.h>

 #include <asm/uaccess.h>

@@ -755,10 +756,25 @@ int hvc_poll_init(struct tty_driver *driver, int
line, char *options)
 static int hvc_poll_get_char(struct tty_driver *driver, int line)
 {
 	struct tty_struct *tty = driver->ttys[0];
-	struct hvc_struct *hp = tty->driver_data;
+	struct hvc_struct *hp;
 	int n;
 	char ch;

+	if (!tty) {
+		printk_ratelimited(KERN_CRIT "kgdb: %s:%d invalid driver data %s\n",
+				__func__, __LINE__, driver->name);
+		return -1;
+	}
+
+
+	hp = tty->driver_data;
+	if (!hp || !hp->ops) {
+		printk_ratelimited(KERN_CRIT "kgdb: %s:%d invalid hp, or hp->ops\n",
+				__func__, __LINE__);
+		return -1;
+	}
+	
+
 	n = hp->ops->get_chars(hp->vtermno, &ch, 1);

 	if (n == 0)
diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index 0065da4..8caa6fa 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -365,6 +365,8 @@ struct tty_driver *tty_find_polling_driver(char
*name, int *line)
 		    p->ops->poll_init && !p->ops->poll_init(p, tty_line, stp)) {
 			res = tty_driver_kref_get(p);
 			*line = tty_line;
+			printk(KERN_CRIT "kgdb: %s:%d Found tty %s line %d\n",
+				__func__, __LINE__, res->name, tty_line);
 			break;
 		}
 	}
@@ -1279,9 +1281,12 @@ static int tty_driver_install_tty(struct
tty_driver *driver,
 	if (tty_init_termios(tty) == 0) {
 		tty_driver_kref_get(driver);
 		tty->count++;
+		printk(KERN_CRIT "kgdb: Installing tty %s %d\n", driver->name, idx);
 		driver->ttys[idx] = tty;
 		return 0;
 	}
+
+	printk(KERN_CRIT "kgdb: Failed to init %s\n", driver->name);
 	return -ENOMEM;
 }

@@ -1298,6 +1303,7 @@ static int tty_driver_install_tty(struct
tty_driver *driver,
 static void tty_driver_remove_tty(struct tty_driver *driver,
 						struct tty_struct *tty)
 {
+	printk(KERN_CRIT "kgdb: Removing tty %s %d\n", driver->name, tty->count);
 	if (driver->ops->remove)
 		driver->ops->remove(driver, tty);
 	else
@@ -3064,6 +3070,7 @@ int tty_register_driver(struct tty_driver *driver)
 	}

 	if (p) {
+		printk(KERN_ERR "kgdb: setting up ttys for %s\n", driver->name);
 		driver->ttys = (struct tty_struct **)p;
 		driver->termios = (struct ktermios **)(p + driver->num);
 	} else {
diff --git a/kernel/debug/debug_core.c b/kernel/debug/debug_core.c
index cefd4a1..a773f91 100644
--- a/kernel/debug/debug_core.c
+++ b/kernel/debug/debug_core.c
@@ -54,6 +54,10 @@
 #include <asm/atomic.h>
 #include <asm/system.h>

+#ifdef CONFIG_XEN
+#include <asm/xen/hypercall.h>
+#endif
+
 #include "debug_core.h"

 static int kgdb_break_asap;
@@ -405,8 +409,10 @@ static int kgdb_reenter_check(struct kgdb_state *ks)
 {
 	unsigned long addr;

-	if (atomic_read(&kgdb_active) != raw_smp_processor_id())
+	if (atomic_read(&kgdb_active) != raw_smp_processor_id()) {
+		printk(KERN_CRIT "KGDB: bailing %d != %d\n", kgdb_active,
raw_smp_processor_id());
 		return 0;
+	}

 	/* Panic on recursive debugger calls: */
 	exception_level++;
@@ -468,6 +474,7 @@ static int kgdb_cpu_enter(struct kgdb_state *ks,
struct pt_regs *regs,
 	kgdb_info[ks->cpu].enter_kgdb++;
 	kgdb_info[ks->cpu].exception_state |= exception_state;

+	printk(KERN_CRIT "kgdb: %s:%d cpuid: %d\n", __func__, __LINE__,
raw_smp_processor_id());
 	if (exception_state == DCPU_WANT_MASTER)
 		atomic_inc(&masters_in_kgdb);
 	else
@@ -477,6 +484,7 @@ static int kgdb_cpu_enter(struct kgdb_state *ks,
struct pt_regs *regs,
 		arch_kgdb_ops.disable_hw_break(regs);

 acquirelock:
+	printk(KERN_CRIT "kgdb: %s:%d\n", __func__, __LINE__);
 	/*
 	 * Interrupts will be restored by the 'trap return' code, except when
 	 * single stepping.
@@ -502,8 +510,10 @@ acquirelock:
 	 * CPU will loop if it is a slave or request to become a kgdb
 	 * master cpu and acquire the kgdb_active lock:
 	 */
+	printk(KERN_CRIT "kgdb: %s:%d\n", __func__, __LINE__);
 	while (1) {
 cpu_loop:
+		printk(KERN_CRIT "kgdb: %s:%d\n", __func__, __LINE__);
 		if (kgdb_info[cpu].exception_state & DCPU_NEXT_MASTER) {
 			kgdb_info[cpu].exception_state &= ~DCPU_NEXT_MASTER;
 			goto cpu_master_loop;
@@ -517,6 +527,7 @@ cpu_loop:
 				goto return_normal;
 		} else {
 return_normal:
+			printk(KERN_CRIT "kgdb: %s:%d\n", __func__, __LINE__);
 			/* Return to normal operation by executing any
 			 * hw breakpoint fixup.
 			 */
@@ -536,6 +547,7 @@ return_normal:
 		cpu_relax();
 	}

+	printk(KERN_CRIT "kgdb: %s:%d\n", __func__, __LINE__);
 	/*
 	 * For single stepping, try to only enter on the processor
 	 * that was single stepping.  To gaurd against a deadlock, the
@@ -553,6 +565,7 @@ return_normal:
 		goto acquirelock;
 	}

+	printk(KERN_CRIT "kgdb: %s:%d\n", __func__, __LINE__);
 	if (!kgdb_io_ready(1)) {
 		kgdb_info[cpu].ret_state = 1;
 		goto kgdb_restore; /* No I/O connection, resume the system */
@@ -561,10 +574,12 @@ return_normal:
 	/*
 	 * Don't enter if we have hit a removed breakpoint.
 	 */
+	printk(KERN_CRIT "kgdb: %s:%d\n", __func__, __LINE__);
 	if (kgdb_skipexception(ks->ex_vector, ks->linux_regs))
 		goto kgdb_restore;

 	/* Call the I/O driver's pre_exception routine */
+	printk(KERN_CRIT "kgdb: %s:%d\n", __func__, __LINE__);
 	if (dbg_io_ops->pre_exception)
 		dbg_io_ops->pre_exception();

@@ -572,21 +587,30 @@ return_normal:
 	 * Get the passive CPU lock which will hold all the non-primary
 	 * CPU in a spin state while the debugger is active
 	 */
+	printk(KERN_CRIT "kgdb: %s:%d\n", __func__, __LINE__);
 	if (!kgdb_single_step)
 		raw_spin_lock(&dbg_slave_lock);

 #ifdef CONFIG_SMP
+	printk(KERN_CRIT "kgdb: %s:%d\n", __func__, __LINE__);
 	/* Signal the other CPUs to enter kgdb_wait() */
 	if ((!kgdb_single_step) && kgdb_do_roundup)
 		kgdb_roundup_cpus(flags);
 #endif

+#if 0
 	/*
 	 * Wait for the other CPUs to be notified and be waiting for us:
 	 */
+	printk(KERN_CRIT "kgdb: %s:%d\n", __func__, __LINE__);
 	while (kgdb_do_roundup && (atomic_read(&masters_in_kgdb) +
-				atomic_read(&slaves_in_kgdb)) != online_cpus)
+				atomic_read(&slaves_in_kgdb)) != online_cpus) {
+#ifdef CONFIG_XEN
+		HYPERVISOR_sched_op(SCHEDOP_yield, NULL);
+#endif
 		cpu_relax();
+	}
+#endif

 	/*
 	 * At this point the primary processor is completely
@@ -602,6 +626,7 @@ return_normal:

 	while (1) {
 cpu_master_loop:
+		printk(KERN_CRIT "kgdb: %s:%d\n", __func__, __LINE__);
 		if (dbg_kdb_mode) {
 			kgdb_connected = 1;
 			error = kdb_stub(ks);
@@ -624,6 +649,7 @@ cpu_master_loop:
 		}
 	}

+	printk(KERN_CRIT "kgdb: %s:%d\n", __func__, __LINE__);
 	/* Call the I/O driver's post_exception routine */
 	if (dbg_io_ops->post_exception)
 		dbg_io_ops->post_exception();
@@ -636,6 +662,7 @@ cpu_master_loop:
 	}

 kgdb_restore:
+	printk(KERN_CRIT "kgdb: %s:%d\n", __func__, __LINE__);
 	if (atomic_read(&kgdb_cpu_doing_single_step) != -1) {
 		int sstep_cpu = atomic_read(&kgdb_cpu_doing_single_step);
 		if (kgdb_info[sstep_cpu].task)
@@ -659,6 +686,7 @@ kgdb_restore:
 	dbg_touch_watchdogs();
 	local_irq_restore(flags);

+	printk(KERN_CRIT "kgdb: %s:%d\n", __func__, __LINE__);
 	return kgdb_info[cpu].ret_state;
 }

@@ -675,6 +703,8 @@ kgdb_handle_exception(int evector, int signo, int
ecode, struct pt_regs *regs)
 	struct kgdb_state kgdb_var;
 	struct kgdb_state *ks = &kgdb_var;

+	printk(KERN_CRIT "kgdb: %s:%d cpu:%d\n", __func__, __LINE__,
raw_smp_processor_id());
+
 	ks->cpu			= raw_smp_processor_id();
 	ks->ex_vector		= evector;
 	ks->signo		= signo;
@@ -696,6 +726,7 @@ int kgdb_nmicallback(int cpu, void *regs)
 	struct kgdb_state kgdb_var;
 	struct kgdb_state *ks = &kgdb_var;

+	printk(KERN_CRIT "kgdb: %s:%d cpu:%d\n", __func__, __LINE__,
raw_smp_processor_id());
 	memset(ks, 0, sizeof(struct kgdb_state));
 	ks->cpu			= cpu;
 	ks->linux_regs		= regs;
@@ -954,11 +985,17 @@ int dbg_io_get_char(void)
  */
 void kgdb_breakpoint(void)
 {
+	printk(KERN_CRIT "kgdb: %s:%d\n", __func__, __LINE__);
 	atomic_inc(&kgdb_setting_breakpoint);
+	printk(KERN_CRIT "kgdb: %s:%d\n", __func__, __LINE__);
 	wmb(); /* Sync point before breakpoint */
+	printk(KERN_CRIT "kgdb: %s:%d\n", __func__, __LINE__);
 	arch_kgdb_breakpoint();
+	printk(KERN_CRIT "kgdb: %s:%d\n", __func__, __LINE__);
 	wmb(); /* Sync point after breakpoint */
+	printk(KERN_CRIT "kgdb: %s:%d\n", __func__, __LINE__);
 	atomic_dec(&kgdb_setting_breakpoint);
+	printk(KERN_CRIT "kgdb: %s exiting\n", __func__);
 }
 EXPORT_SYMBOL_GPL(kgdb_breakpoint);
