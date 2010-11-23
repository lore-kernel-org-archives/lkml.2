Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756606Ab0KWTev (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 14:34:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:29374 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756570Ab0KWTeu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 14:34:50 -0500
From: Don Zickus <dzickus@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: fweisbec@gmail.com, gorcunov@openvz.org,
        LKML <linux-kernel@vger.kernel.org>, yinghai@kernel.org,
        Don Zickus <dzickus@redhat.com>
Subject: [PATCH 2/3] x86, nmi_watchdog:  remove the old nmi_watchdog
Date: Tue, 23 Nov 2010 14:32:04 -0500
Message-Id: <1290540725-2911-3-git-send-email-dzickus@redhat.com>
In-Reply-To: <1290540725-2911-1-git-send-email-dzickus@redhat.com>
References: <1290540725-2911-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that we have a new nmi_watchdog that is more generic and sits on
top of the perf subsystem, we really do not need the old nmi_watchdog
any more.

In addition, the old nmi_watchdog doesn't really work if you are using
the default clocksource, hpet.  The old nmi_watchdog code relied on
local apic interrupts to determine if the cpu is still alive.  With
hpet as the clocksource, these interrupts don't increment any more
and the old nmi_watchdog triggers false postives.

This piece removes the old nmi_watchdog code and stubs out any variables
and functions calls.  The stubs are the same ones used by the new
nmi_watchdog code, so it should be well tested.

v2: fix sparc breakage by undoing linux/nmi.h changes
    clean up documentation and sysctl stuff

Signed-off-by: Don Zickus <dzickus@redhat.com>
---
 Documentation/kernel-parameters.txt |   10 +-
 arch/x86/include/asm/nmi.h          |    4 -
 arch/x86/kernel/apic/Makefile       |    5 +-
 arch/x86/kernel/apic/hw_nmi.c       |   14 +-
 arch/x86/kernel/apic/nmi.c          |  540 -----------------------------------
 arch/x86/kernel/traps.c             |    8 -
 kernel/sysctl.c                     |    9 +-
 kernel/sysctl_binary.c              |    1 -
 kernel/watchdog.c                   |    2 +
 9 files changed, 16 insertions(+), 577 deletions(-)
 delete mode 100644 arch/x86/kernel/apic/nmi.c

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index ed45e98..e48b93f 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1579,20 +1579,12 @@ and is between 256 and 4096 characters. It is defined in the file
 
 	nmi_watchdog=	[KNL,BUGS=X86] Debugging features for SMP kernels
 			Format: [panic,][num]
-			Valid num: 0,1,2
+			Valid num: 0
 			0 - turn nmi_watchdog off
-			1 - use the IO-APIC timer for the NMI watchdog
-			2 - use the local APIC for the NMI watchdog using
-			a performance counter. Note: This will use one
-			performance counter and the local APIC's performance
-			vector.
 			When panic is specified, panic when an NMI watchdog
 			timeout occurs.
 			This is useful when you use a panic=... timeout and
 			need the box quickly up again.
-			Instead of 1 and 2 it is possible to use the following
-			symbolic names: lapic and ioapic
-			Example: nmi_watchdog=2 or nmi_watchdog=panic,lapic
 
 	netpoll.carrier_timeout=
 			[NET] Specifies amount of time (in seconds) that
diff --git a/arch/x86/include/asm/nmi.h b/arch/x86/include/asm/nmi.h
index 932f0f8..33292ec 100644
--- a/arch/x86/include/asm/nmi.h
+++ b/arch/x86/include/asm/nmi.h
@@ -17,9 +17,6 @@ int do_nmi_callback(struct pt_regs *regs, int cpu);
 
 extern void die_nmi(char *str, struct pt_regs *regs, int do_panic);
 extern int check_nmi_watchdog(void);
-#if !defined(CONFIG_LOCKUP_DETECTOR)
-extern int nmi_watchdog_enabled;
-#endif
 extern int avail_to_resrv_perfctr_nmi_bit(unsigned int);
 extern int reserve_perfctr_nmi(unsigned int);
 extern void release_perfctr_nmi(unsigned int);
@@ -30,7 +27,6 @@ extern void setup_apic_nmi_watchdog(void *);
 extern void stop_apic_nmi_watchdog(void *);
 extern void disable_timer_nmi_watchdog(void);
 extern void enable_timer_nmi_watchdog(void);
-extern int nmi_watchdog_tick(struct pt_regs *regs, unsigned reason);
 extern void cpu_nmi_set_wd_enabled(void);
 
 extern atomic_t nmi_active;
diff --git a/arch/x86/kernel/apic/Makefile b/arch/x86/kernel/apic/Makefile
index 910f20b..3966b56 100644
--- a/arch/x86/kernel/apic/Makefile
+++ b/arch/x86/kernel/apic/Makefile
@@ -3,10 +3,7 @@
 #
 
 obj-$(CONFIG_X86_LOCAL_APIC)	+= apic.o apic_noop.o probe_$(BITS).o ipi.o
-ifneq ($(CONFIG_HARDLOCKUP_DETECTOR),y)
-obj-$(CONFIG_X86_LOCAL_APIC)	+= nmi.o
-endif
-obj-$(CONFIG_HARDLOCKUP_DETECTOR)	+= hw_nmi.o
+obj-y				+= hw_nmi.o
 
 obj-$(CONFIG_X86_IO_APIC)	+= io_apic.o
 obj-$(CONFIG_SMP)		+= ipi.o
diff --git a/arch/x86/kernel/apic/hw_nmi.c b/arch/x86/kernel/apic/hw_nmi.c
index e66b16d..4a57e60 100644
--- a/arch/x86/kernel/apic/hw_nmi.c
+++ b/arch/x86/kernel/apic/hw_nmi.c
@@ -20,12 +20,22 @@
 /* For reliability, we're prepared to waste bits here. */
 static DECLARE_BITMAP(backtrace_mask, NR_CPUS) __read_mostly;
 
+#ifdef CONFIG_HARDLOCKUP_DETECTOR
 u64 hw_nmi_get_sample_period(void)
 {
 	return (u64)(cpu_khz) * 1000 * 60;
 }
+#endif
+
+#ifndef CONFIG_HARDLOCKUP_DETECTOR
+void touch_nmi_watchdog(void)
+{
+	touch_softlockup_watchdog();
+}
+EXPORT_SYMBOL(touch_nmi_watchdog);
+#endif
 
-#ifdef ARCH_HAS_NMI_WATCHDOG
+#ifdef arch_trigger_all_cpu_backtrace
 void arch_trigger_all_cpu_backtrace(void)
 {
 	int i;
@@ -95,8 +105,6 @@ early_initcall(register_trigger_all_cpu_backtrace);
 #if defined(CONFIG_X86_LOCAL_APIC)
 unsigned int nmi_watchdog = NMI_NONE;
 EXPORT_SYMBOL(nmi_watchdog);
-void acpi_nmi_enable(void) { return; }
-void acpi_nmi_disable(void) { return; }
 #endif
 atomic_t nmi_active = ATOMIC_INIT(0);           /* oprofile uses this */
 EXPORT_SYMBOL(nmi_active);
diff --git a/arch/x86/kernel/apic/nmi.c b/arch/x86/kernel/apic/nmi.c
deleted file mode 100644
index 7bab143..0000000
--- a/arch/x86/kernel/apic/nmi.c
+++ /dev/null
@@ -1,540 +0,0 @@
-/*
- *  NMI watchdog support on APIC systems
- *
- *  Started by Ingo Molnar <mingo@redhat.com>
- *
- *  Fixes:
- *  Mikael Pettersson	: AMD K7 support for local APIC NMI watchdog.
- *  Mikael Pettersson	: Power Management for local APIC NMI watchdog.
- *  Mikael Pettersson	: Pentium 4 support for local APIC NMI watchdog.
- *  Pavel Machek and
- *  Mikael Pettersson	: PM converted to driver model. Disable/enable API.
- */
-
-#include <asm/apic.h>
-
-#include <linux/nmi.h>
-#include <linux/mm.h>
-#include <linux/delay.h>
-#include <linux/interrupt.h>
-#include <linux/module.h>
-#include <linux/slab.h>
-#include <linux/sysdev.h>
-#include <linux/sysctl.h>
-#include <linux/percpu.h>
-#include <linux/kprobes.h>
-#include <linux/cpumask.h>
-#include <linux/kernel_stat.h>
-#include <linux/kdebug.h>
-#include <linux/smp.h>
-
-#include <asm/i8259.h>
-#include <asm/io_apic.h>
-#include <asm/proto.h>
-#include <asm/timer.h>
-
-#include <asm/mce.h>
-
-#include <asm/mach_traps.h>
-
-int nmi_watchdog_enabled;
-
-/* For reliability, we're prepared to waste bits here. */
-static DECLARE_BITMAP(backtrace_mask, NR_CPUS) __read_mostly;
-
-/* nmi_active:
- * >0: the lapic NMI watchdog is active, but can be disabled
- * <0: the lapic NMI watchdog has not been set up, and cannot
- *     be enabled
- *  0: the lapic NMI watchdog is disabled, but can be enabled
- */
-atomic_t nmi_active = ATOMIC_INIT(0);		/* oprofile uses this */
-EXPORT_SYMBOL(nmi_active);
-
-unsigned int nmi_watchdog = NMI_NONE;
-EXPORT_SYMBOL(nmi_watchdog);
-
-static int panic_on_timeout;
-
-static unsigned int nmi_hz = HZ;
-static DEFINE_PER_CPU(short, wd_enabled);
-static int endflag __initdata;
-
-static inline unsigned int get_nmi_count(int cpu)
-{
-	return per_cpu(irq_stat, cpu).__nmi_count;
-}
-
-static inline int mce_in_progress(void)
-{
-#if defined(CONFIG_X86_MCE)
-	return atomic_read(&mce_entry) > 0;
-#endif
-	return 0;
-}
-
-/*
- * Take the local apic timer and PIT/HPET into account. We don't
- * know which one is active, when we have highres/dyntick on
- */
-static inline unsigned int get_timer_irqs(int cpu)
-{
-	return per_cpu(irq_stat, cpu).apic_timer_irqs +
-		per_cpu(irq_stat, cpu).irq0_irqs;
-}
-
-#ifdef CONFIG_SMP
-/*
- * The performance counters used by NMI_LOCAL_APIC don't trigger when
- * the CPU is idle. To make sure the NMI watchdog really ticks on all
- * CPUs during the test make them busy.
- */
-static __init void nmi_cpu_busy(void *data)
-{
-	local_irq_enable_in_hardirq();
-	/*
-	 * Intentionally don't use cpu_relax here. This is
-	 * to make sure that the performance counter really ticks,
-	 * even if there is a simulator or similar that catches the
-	 * pause instruction. On a real HT machine this is fine because
-	 * all other CPUs are busy with "useless" delay loops and don't
-	 * care if they get somewhat less cycles.
-	 */
-	while (endflag == 0)
-		mb();
-}
-#endif
-
-static void report_broken_nmi(int cpu, unsigned int *prev_nmi_count)
-{
-	printk(KERN_CONT "\n");
-
-	printk(KERN_WARNING
-		"WARNING: CPU#%d: NMI appears to be stuck (%d->%d)!\n",
-			cpu, prev_nmi_count[cpu], get_nmi_count(cpu));
-
-	printk(KERN_WARNING
-		"Please report this to bugzilla.kernel.org,\n");
-	printk(KERN_WARNING
-		"and attach the output of the 'dmesg' command.\n");
-
-	per_cpu(wd_enabled, cpu) = 0;
-	atomic_dec(&nmi_active);
-}
-
-static void __acpi_nmi_disable(void *__unused)
-{
-	apic_write(APIC_LVT0, APIC_DM_NMI | APIC_LVT_MASKED);
-}
-
-int __init check_nmi_watchdog(void)
-{
-	unsigned int *prev_nmi_count;
-	int cpu;
-
-	if (!nmi_watchdog_active() || !atomic_read(&nmi_active))
-		return 0;
-
-	prev_nmi_count = kmalloc(nr_cpu_ids * sizeof(int), GFP_KERNEL);
-	if (!prev_nmi_count)
-		goto error;
-
-	printk(KERN_INFO "Testing NMI watchdog ... ");
-
-#ifdef CONFIG_SMP
-	if (nmi_watchdog == NMI_LOCAL_APIC)
-		smp_call_function(nmi_cpu_busy, (void *)&endflag, 0);
-#endif
-
-	for_each_possible_cpu(cpu)
-		prev_nmi_count[cpu] = get_nmi_count(cpu);
-	local_irq_enable();
-	mdelay((20 * 1000) / nmi_hz); /* wait 20 ticks */
-
-	for_each_online_cpu(cpu) {
-		if (!per_cpu(wd_enabled, cpu))
-			continue;
-		if (get_nmi_count(cpu) - prev_nmi_count[cpu] <= 5)
-			report_broken_nmi(cpu, prev_nmi_count);
-	}
-	endflag = 1;
-	if (!atomic_read(&nmi_active)) {
-		kfree(prev_nmi_count);
-		atomic_set(&nmi_active, -1);
-		goto error;
-	}
-	printk("OK.\n");
-
-	/*
-	 * now that we know it works we can reduce NMI frequency to
-	 * something more reasonable; makes a difference in some configs
-	 */
-	if (nmi_watchdog == NMI_LOCAL_APIC)
-		nmi_hz = lapic_adjust_nmi_hz(1);
-
-	kfree(prev_nmi_count);
-	return 0;
-error:
-	if (nmi_watchdog == NMI_IO_APIC) {
-		if (!timer_through_8259)
-			legacy_pic->mask(0);
-		on_each_cpu(__acpi_nmi_disable, NULL, 1);
-	}
-
-#ifdef CONFIG_X86_32
-	timer_ack = 0;
-#endif
-	return -1;
-}
-
-static int __init setup_nmi_watchdog(char *str)
-{
-	unsigned int nmi;
-
-	if (!strncmp(str, "panic", 5)) {
-		panic_on_timeout = 1;
-		str = strchr(str, ',');
-		if (!str)
-			return 1;
-		++str;
-	}
-
-	if (!strncmp(str, "lapic", 5))
-		nmi_watchdog = NMI_LOCAL_APIC;
-	else if (!strncmp(str, "ioapic", 6))
-		nmi_watchdog = NMI_IO_APIC;
-	else {
-		get_option(&str, &nmi);
-		if (nmi >= NMI_INVALID)
-			return 0;
-		nmi_watchdog = nmi;
-	}
-
-	return 1;
-}
-__setup("nmi_watchdog=", setup_nmi_watchdog);
-
-/*
- * Suspend/resume support
- */
-#ifdef CONFIG_PM
-
-static int nmi_pm_active; /* nmi_active before suspend */
-
-static int lapic_nmi_suspend(struct sys_device *dev, pm_message_t state)
-{
-	/* only CPU0 goes here, other CPUs should be offline */
-	nmi_pm_active = atomic_read(&nmi_active);
-	stop_apic_nmi_watchdog(NULL);
-	BUG_ON(atomic_read(&nmi_active) != 0);
-	return 0;
-}
-
-static int lapic_nmi_resume(struct sys_device *dev)
-{
-	/* only CPU0 goes here, other CPUs should be offline */
-	if (nmi_pm_active > 0) {
-		setup_apic_nmi_watchdog(NULL);
-		touch_nmi_watchdog();
-	}
-	return 0;
-}
-
-static struct sysdev_class nmi_sysclass = {
-	.name		= "lapic_nmi",
-	.resume		= lapic_nmi_resume,
-	.suspend	= lapic_nmi_suspend,
-};
-
-static struct sys_device device_lapic_nmi = {
-	.id	= 0,
-	.cls	= &nmi_sysclass,
-};
-
-static int __init init_lapic_nmi_sysfs(void)
-{
-	int error;
-
-	/*
-	 * should really be a BUG_ON but b/c this is an
-	 * init call, it just doesn't work.  -dcz
-	 */
-	if (nmi_watchdog != NMI_LOCAL_APIC)
-		return 0;
-
-	if (atomic_read(&nmi_active) < 0)
-		return 0;
-
-	error = sysdev_class_register(&nmi_sysclass);
-	if (!error)
-		error = sysdev_register(&device_lapic_nmi);
-	return error;
-}
-
-/* must come after the local APIC's device_initcall() */
-late_initcall(init_lapic_nmi_sysfs);
-
-#endif	/* CONFIG_PM */
-
-static void __acpi_nmi_enable(void *__unused)
-{
-	apic_write(APIC_LVT0, APIC_DM_NMI);
-}
-
-/*
- * Enable timer based NMIs on all CPUs:
- */
-void acpi_nmi_enable(void)
-{
-	if (atomic_read(&nmi_active) && nmi_watchdog == NMI_IO_APIC)
-		on_each_cpu(__acpi_nmi_enable, NULL, 1);
-}
-
-/*
- * Disable timer based NMIs on all CPUs:
- */
-void acpi_nmi_disable(void)
-{
-	if (atomic_read(&nmi_active) && nmi_watchdog == NMI_IO_APIC)
-		on_each_cpu(__acpi_nmi_disable, NULL, 1);
-}
-
-/*
- * This function is called as soon the LAPIC NMI watchdog driver has everything
- * in place and it's ready to check if the NMIs belong to the NMI watchdog
- */
-void cpu_nmi_set_wd_enabled(void)
-{
-	__get_cpu_var(wd_enabled) = 1;
-}
-
-void setup_apic_nmi_watchdog(void *unused)
-{
-	if (__get_cpu_var(wd_enabled))
-		return;
-
-	/* cheap hack to support suspend/resume */
-	/* if cpu0 is not active neither should the other cpus */
-	if (smp_processor_id() != 0 && atomic_read(&nmi_active) <= 0)
-		return;
-
-	switch (nmi_watchdog) {
-	case NMI_LOCAL_APIC:
-		if (lapic_watchdog_init(nmi_hz) < 0) {
-			__get_cpu_var(wd_enabled) = 0;
-			return;
-		}
-		/* FALL THROUGH */
-	case NMI_IO_APIC:
-		__get_cpu_var(wd_enabled) = 1;
-		atomic_inc(&nmi_active);
-	}
-}
-
-void stop_apic_nmi_watchdog(void *unused)
-{
-	/* only support LOCAL and IO APICs for now */
-	if (!nmi_watchdog_active())
-		return;
-	if (__get_cpu_var(wd_enabled) == 0)
-		return;
-	if (nmi_watchdog == NMI_LOCAL_APIC)
-		lapic_watchdog_stop();
-	else
-		__acpi_nmi_disable(NULL);
-	__get_cpu_var(wd_enabled) = 0;
-	atomic_dec(&nmi_active);
-}
-
-/*
- * the best way to detect whether a CPU has a 'hard lockup' problem
- * is to check it's local APIC timer IRQ counts. If they are not
- * changing then that CPU has some problem.
- *
- * as these watchdog NMI IRQs are generated on every CPU, we only
- * have to check the current processor.
- *
- * since NMIs don't listen to _any_ locks, we have to be extremely
- * careful not to rely on unsafe variables. The printk might lock
- * up though, so we have to break up any console locks first ...
- * [when there will be more tty-related locks, break them up here too!]
- */
-
-static DEFINE_PER_CPU(unsigned, last_irq_sum);
-static DEFINE_PER_CPU(long, alert_counter);
-static DEFINE_PER_CPU(int, nmi_touch);
-
-void touch_nmi_watchdog(void)
-{
-	if (nmi_watchdog_active()) {
-		unsigned cpu;
-
-		/*
-		 * Tell other CPUs to reset their alert counters. We cannot
-		 * do it ourselves because the alert count increase is not
-		 * atomic.
-		 */
-		for_each_present_cpu(cpu) {
-			if (per_cpu(nmi_touch, cpu) != 1)
-				per_cpu(nmi_touch, cpu) = 1;
-		}
-	}
-
-	/*
-	 * Tickle the softlockup detector too:
-	 */
-	touch_softlockup_watchdog();
-}
-EXPORT_SYMBOL(touch_nmi_watchdog);
-
-notrace __kprobes int
-nmi_watchdog_tick(struct pt_regs *regs, unsigned reason)
-{
-	/*
-	 * Since current_thread_info()-> is always on the stack, and we
-	 * always switch the stack NMI-atomically, it's safe to use
-	 * smp_processor_id().
-	 */
-	unsigned int sum;
-	int touched = 0;
-	int cpu = smp_processor_id();
-	int rc = 0;
-
-	sum = get_timer_irqs(cpu);
-
-	if (__get_cpu_var(nmi_touch)) {
-		__get_cpu_var(nmi_touch) = 0;
-		touched = 1;
-	}
-
-	/* We can be called before check_nmi_watchdog, hence NULL check. */
-	if (cpumask_test_cpu(cpu, to_cpumask(backtrace_mask))) {
-		static DEFINE_RAW_SPINLOCK(lock); /* Serialise the printks */
-
-		raw_spin_lock(&lock);
-		printk(KERN_WARNING "NMI backtrace for cpu %d\n", cpu);
-		show_regs(regs);
-		dump_stack();
-		raw_spin_unlock(&lock);
-		cpumask_clear_cpu(cpu, to_cpumask(backtrace_mask));
-
-		rc = 1;
-	}
-
-	/* Could check oops_in_progress here too, but it's safer not to */
-	if (mce_in_progress())
-		touched = 1;
-
-	/* if the none of the timers isn't firing, this cpu isn't doing much */
-	if (!touched && __get_cpu_var(last_irq_sum) == sum) {
-		/*
-		 * Ayiee, looks like this CPU is stuck ...
-		 * wait a few IRQs (5 seconds) before doing the oops ...
-		 */
-		__this_cpu_inc(alert_counter);
-		if (__this_cpu_read(alert_counter) == 5 * nmi_hz)
-			/*
-			 * die_nmi will return ONLY if NOTIFY_STOP happens..
-			 */
-			die_nmi("BUG: NMI Watchdog detected LOCKUP",
-				regs, panic_on_timeout);
-	} else {
-		__get_cpu_var(last_irq_sum) = sum;
-		__this_cpu_write(alert_counter, 0);
-	}
-
-	/* see if the nmi watchdog went off */
-	if (!__get_cpu_var(wd_enabled))
-		return rc;
-	switch (nmi_watchdog) {
-	case NMI_LOCAL_APIC:
-		rc |= lapic_wd_event(nmi_hz);
-		break;
-	case NMI_IO_APIC:
-		/*
-		 * don't know how to accurately check for this.
-		 * just assume it was a watchdog timer interrupt
-		 * This matches the old behaviour.
-		 */
-		rc = 1;
-		break;
-	}
-	return rc;
-}
-
-#ifdef CONFIG_SYSCTL
-
-static void enable_ioapic_nmi_watchdog_single(void *unused)
-{
-	__get_cpu_var(wd_enabled) = 1;
-	atomic_inc(&nmi_active);
-	__acpi_nmi_enable(NULL);
-}
-
-static void enable_ioapic_nmi_watchdog(void)
-{
-	on_each_cpu(enable_ioapic_nmi_watchdog_single, NULL, 1);
-	touch_nmi_watchdog();
-}
-
-static void disable_ioapic_nmi_watchdog(void)
-{
-	on_each_cpu(stop_apic_nmi_watchdog, NULL, 1);
-}
-
-/*
- * proc handler for /proc/sys/kernel/nmi
- */
-int proc_nmi_enabled(struct ctl_table *table, int write,
-			void __user *buffer, size_t *length, loff_t *ppos)
-{
-	int old_state;
-
-	nmi_watchdog_enabled = (atomic_read(&nmi_active) > 0) ? 1 : 0;
-	old_state = nmi_watchdog_enabled;
-	proc_dointvec(table, write, buffer, length, ppos);
-	if (!!old_state == !!nmi_watchdog_enabled)
-		return 0;
-
-	if (atomic_read(&nmi_active) < 0 || !nmi_watchdog_active()) {
-		printk(KERN_WARNING
-			"NMI watchdog is permanently disabled\n");
-		return -EIO;
-	}
-
-	if (nmi_watchdog == NMI_LOCAL_APIC) {
-		if (nmi_watchdog_enabled)
-			enable_lapic_nmi_watchdog();
-		else
-			disable_lapic_nmi_watchdog();
-	} else if (nmi_watchdog == NMI_IO_APIC) {
-		if (nmi_watchdog_enabled)
-			enable_ioapic_nmi_watchdog();
-		else
-			disable_ioapic_nmi_watchdog();
-	} else {
-		printk(KERN_WARNING
-			"NMI watchdog doesn't know what hardware to touch\n");
-		return -EIO;
-	}
-	return 0;
-}
-
-#endif /* CONFIG_SYSCTL */
-
-void arch_trigger_all_cpu_backtrace(void)
-{
-	int i;
-
-	cpumask_copy(to_cpumask(backtrace_mask), cpu_online_mask);
-
-	printk(KERN_INFO "sending NMI to all CPUs:\n");
-	apic->send_IPI_all(NMI_VECTOR);
-
-	/* Wait for up to 10 seconds for all CPUs to do the backtrace */
-	for (i = 0; i < 10 * 1000; i++) {
-		if (cpumask_empty(to_cpumask(backtrace_mask)))
-			break;
-		mdelay(1);
-	}
-}
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index 53ea71f..4b331ce 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -407,14 +407,6 @@ static notrace __kprobes void default_do_nmi(struct pt_regs *regs)
 							== NOTIFY_STOP)
 			return;
 
-#ifndef CONFIG_LOCKUP_DETECTOR
-		/*
-		 * Ok, so this is none of the documented NMI sources,
-		 * so it must be the NMI watchdog.
-		 */
-		if (nmi_watchdog_tick(regs, reason))
-			return;
-#endif /* !CONFIG_LOCKUP_DETECTOR */
 #endif
 		unknown_nmi_error(reason, regs);
 
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index c33a1ed..0daad4e 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -737,7 +737,7 @@ static struct ctl_table kern_table[] = {
 		.extra2		= &one,
 	},
 #endif
-#if defined(CONFIG_X86_LOCAL_APIC) && defined(CONFIG_X86) && !defined(CONFIG_LOCKUP_DETECTOR)
+#if defined(CONFIG_X86_LOCAL_APIC) && defined(CONFIG_X86)
 	{
 		.procname       = "unknown_nmi_panic",
 		.data           = &unknown_nmi_panic,
@@ -745,13 +745,6 @@ static struct ctl_table kern_table[] = {
 		.mode           = 0644,
 		.proc_handler   = proc_dointvec,
 	},
-	{
-		.procname       = "nmi_watchdog",
-		.data           = &nmi_watchdog_enabled,
-		.maxlen         = sizeof (int),
-		.mode           = 0644,
-		.proc_handler   = proc_nmi_enabled,
-	},
 #endif
 #if defined(CONFIG_X86)
 	{
diff --git a/kernel/sysctl_binary.c b/kernel/sysctl_binary.c
index 1357c57..4b2545a 100644
--- a/kernel/sysctl_binary.c
+++ b/kernel/sysctl_binary.c
@@ -136,7 +136,6 @@ static const struct bin_table bin_kern_table[] = {
 	{ CTL_INT,	KERN_IA64_UNALIGNED,		"ignore-unaligned-usertrap" },
 	{ CTL_INT,	KERN_COMPAT_LOG,		"compat-log" },
 	{ CTL_INT,	KERN_MAX_LOCK_DEPTH,		"max_lock_depth" },
-	{ CTL_INT,	KERN_NMI_WATCHDOG,		"nmi_watchdog" },
 	{ CTL_INT,	KERN_PANIC_ON_NMI,		"panic_on_unrecovered_nmi" },
 	{}
 };
diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index bafba68..3c5441f 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -57,6 +57,8 @@ static int __init hardlockup_panic_setup(char *str)
 {
 	if (!strncmp(str, "panic", 5))
 		hardlockup_panic = 1;
+	else if (!strncmp(str, "0", 1))
+		no_watchdog = 1;
 	return 1;
 }
 __setup("nmi_watchdog=", hardlockup_panic_setup);
-- 
1.7.3.2

