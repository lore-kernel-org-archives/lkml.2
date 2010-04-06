Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756438Ab0DFUxL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 16:53:11 -0400
Received: from flusers.ccur.com ([12.192.68.2]:55303 "EHLO gamx.iccur.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756468Ab0DFUxC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 16:53:02 -0400
X-Greylist: delayed 2801 seconds by postgrey-1.27 at vger.kernel.org; Tue, 06 Apr 2010 16:53:01 EDT
Date: Tue, 6 Apr 2010 16:06:05 -0400
From: Joe Korty <joe.korty@ccur.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 2.6.34-rc3] A nonintrusive SMI sniffer for x86 (resend)
Message-ID: <20100406200605.GA16586@typhoon.ccur.com>
Reply-To: Joe Korty <joe.korty@ccur.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH 2.6.34-rc3] A nonintrusive SMI sniffer for x86.

[ resend -- first send failed due to sendmail config problems ]

This sniffer is designed to have near-zero impact on the normal running of
a system.  It ties into the polling version of idle and into the interrupt
subsystem (principally irq_enter()).  In idle it uses periodic readings
of the TSC to detect unexplained time gaps.  It is assumed that all such
gaps are due to either a normal system interrupt, an NMI, or an SMI.

The sniffer marks all occurances of normal system interrupts and NMI with a
new 'irq happened' flag.  Thus, any time gap detected in idle during which
the 'irq happened' flag has _not_ been set can be assumed to be due to an SMI.

The results are displayed in a new pair of /proc/interrupts lines.  Here is
an example run, courtesy of John Blackwood, who has a system known to suffer
latency problems.

# grep SMI /proc/interrupts
          CPU0    CPU1    CPU2    CPU3
 SMI:       1       1       0       1   system management interrupts while idle
DSMI:    1096    1096       0    1096   duration of most recent SMI, in usecs

Note that the SMI struck most (presumably all) of the CPUs.  This is
expected since motherboards often tie together their CPUs' SMI pins.
The fact the cpu 2 did not register an SMI merely means it was off doing
real work when the SMI struck.

The smi sniffer is not 'on' until compiled in (CONFIG_DEBUG_SMI_SNIFFER=y)
and enabled (poll=smi on the boot command line, or after boot, echo 1
>/proc/sys/kernel/smi_sniffer_enable).  More details may be found in
Documentation/x86/smi-sniffer.txt

[Developed and tested on 2.6.31 then forward-ported to 2.6.34-rc3]

Signed-off-by: Joe Korty <joe.korty@ccur.com>

Index: 2.6.34-rc3/Documentation/kernel-parameters.txt
===================================================================
--- 2.6.34-rc3.orig/Documentation/kernel-parameters.txt	2010-04-05 14:25:10.000000000 -0400
+++ 2.6.34-rc3/Documentation/kernel-parameters.txt	2010-04-05 14:30:06.000000000 -0400
@@ -940,11 +940,15 @@
 			Claim all unknown PCI IDE storage controllers.
 
 	idle=		[X86]
-			Format: idle=poll, idle=mwait, idle=halt, idle=nomwait
-			Poll forces a polling idle loop that can slightly
+			Format: idle=poll, idle=smi, idle=mwait, idle=halt,
+			idle=nomwait
+			idle=poll: forces a polling idle loop that can slightly
 			improve the performance of waking up a idle CPU, but
 			will use a lot of power and make the system run hot.
 			Not recommended.
+			idle=smi: variant of idle=poll that uses the spin-time
+			to detect otherwise undetectable SMIs.  Not available
+			unless CONFIG_DEBUG_SMI_SNIFFER=y.
 			idle=mwait: On systems which support MONITOR/MWAIT but
 			the kernel chose to not use it because it doesn't save
 			as much power as a normal idle loop, use the
Index: 2.6.34-rc3/Documentation/x86/smi-sniffer.txt
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ 2.6.34-rc3/Documentation/x86/smi-sniffer.txt	2010-04-05 14:30:06.000000000 -0400
@@ -0,0 +1,79 @@
+[Original written March, 2010]
+
+			The SMI Sniffer
+
+Background
+----------
+A System Management Mode Interrupt (SMI) is a special kind of NMI-like
+interrupt that goes directly to the BIOS. They are used by motherboard
+manufacturers to, for example, 1) simulate missing hardware in software,
+such as an RTC or emulating a missing PS2 mouse/keyboard using a USB
+mouse/keyboard, 2) to perform critical motherboard duties, such as periodic
+DRAM memory refresh or slowing the cpu down whenever it gets too hot, and 3)
+to work around in software (ie, in the BIOS) deficiencies discovered after
+a board has been manufactured and shipped to customers.
+
+The OS is not involved with nor even informed of these interrupts when
+they occur, and indeed it is difficult for the OS to detect that they have
+occurred at all. The only signature an SMI leaves behind is the time that it
+consumes. These 'time slices', taken randomly out of the running time of a cpu,
+compromise the ability of the OS to provide reasonable latency guarantees to
+the applications running underneath it. For many uses this is unimportant,
+but for real time systems, the occurrence of an SMI during the run of some
+critically-timed piece of code could shatter the correct running of the system.
+
+Since SMI generation is a side effect of motherboard design, the only recourse
+a user has for avoiding them is to search for and acquire motherboards which
+do not use SMIs at all, or which do use them, but in ways their occurrence
+can be avoided by a proper setting up of the system. This can be a fruitful
+approach, as SMI usage indeed varies widely across products.
+
+The SMI sniffer
+---------------
+For a kernel compiled with CONFIG_DEBUG_SMI_SNIFFER=y, a new idle method,
+"smi", will show up in the list of available idle methods.  It can be enabled
+by either adding "idle=smi" to the boot command line, or, if the default idle
+routine is in use, by an "echo 1 >/proc/sys/kernel/smi_sniffer_enable" command.
+
+The sniffer adds a pair of lines to /proc/interrupts.  The "SMI" line shows
+the number of SMIs detected (per-cpu) so far. The "DSMI" line gives the
+duration, in microseconds, of the most recent SMI (for each cpu).
+
+These lines appear only while the sniffer is running. If it is disabled later,
+say with an "echo 0 >/proc/sys/kernel/smi_sniffer_enable", then the lines
+will no longer show up. This is a nice way to verify whether the sniffer is
+actually running or not.
+
+The sniffer does suffer from some defects. It only sniffs out SMIs that last
+15 usecs or longer.  It can only discover SMIs that occur on cpus that are
+idle. It will therefore miss any SMI that occurs while a user application is
+running, while a system call is running, or while a normal system interrupt
+is being processed. It will also miss a few SMIs that interrupt idle: those
+that occur 'too close' to a normal system interrupt, those that occur while
+the sniffer self-calibrates, and those that occur in the interval between
+successive sniffer 125 usec sampling periods.  Therefore one must not regard
+the sniffer as a precision tool for diagnosing SMI problems.
+
+The Method
+----------
+The sniffer divides idle time into 125 usec periods. This is measured out
+by a countdown on the basic need_resched() loop, whose initial value is such
+that when the count reaches zero, we expect to find that 125 usecs has passed.
+
+The actual time is found by sampling the TSC before and after the period. This
+will be the same as the expected time of 125 usec unless an interrupt (SMI
+or normal system interrupt) occurs.  In that case the actual time will be
+longer than 125 usecs by the time it took to process the interrupt.
+
+The OS is modified so that all normal system interrupts, including NMI, mark
+their occurrence via the setting of a per-cpu 'system interrupt occured' flag.
+We can therefore detect SMIs by assuming that if a period significantly longer
+than 125 usecs is seen, and this 'system interrupt happened' flag is not set,
+that it was an SMI that lengthened the period.
+
+Additional Limitations
+----------------------
+The sniffer is sensitive to variable-frequency TSCs and to TSCs which can
+stop-and-go.  Therefore it cannot be compiled in when CONFIG_CPU_FREQ=y.
+For some platforms, much of power management may need to be turned off in
+order to get reliable results.
Index: 2.6.34-rc3/arch/x86/Kconfig.debug
===================================================================
--- 2.6.34-rc3.orig/arch/x86/Kconfig.debug	2010-02-24 13:52:17.000000000 -0500
+++ 2.6.34-rc3/arch/x86/Kconfig.debug	2010-04-05 14:30:06.000000000 -0400
@@ -56,6 +56,32 @@
 	  with klogd/syslogd or the X server. You should normally N here,
 	  unless you want to debug such a crash. You need usb debug device.
 
+config DEBUG_SMI_SNIFFER
+	bool "Check for SMM Interrupts while idling"
+	depends on !CPU_FREQ
+	default n
+	help
+	  If Y is selected then a version of idle that checks for SMM
+	  Interrupts (SMIs) is added to the kernel's list of available
+	  idle methods. It can then be enabled with either an "idle=smi"
+	  boot command arg or, if the default idle method is in use, with an
+	  "echo 1 >/proc/sys/kernel/smi_sniffer_enable" after boot.
+
+	  While in use the sniffer adds lines to /proc/interrupts that
+	  reports, per cpu, the #SMIs detected so far and the duration in
+	  usecs of the most recent SMI.
+
+	  See Documentation/x86/smi-sniffer.txt for additional information.
+
+	  The sniffer adds a small amount of overhead to every interrupt even
+	  when disabled. When in use power consumption increases and there
+	  is as well a slight, variable increase in the context switch time
+	  out of idle.	To get good results, you may also need to disable
+	  much of power management.  Therefore say N unless you want to
+	  examine the SMI usage of some motherboard.
+
+	  If unsure, say N.
+
 config DEBUG_STACKOVERFLOW
 	bool "Check for stack overflows"
 	depends on DEBUG_KERNEL
Index: 2.6.34-rc3/arch/x86/include/asm/hardirq.h
===================================================================
--- 2.6.34-rc3.orig/arch/x86/include/asm/hardirq.h	2010-02-24 13:52:17.000000000 -0500
+++ 2.6.34-rc3/arch/x86/include/asm/hardirq.h	2010-04-05 14:30:06.000000000 -0400
@@ -3,6 +3,7 @@
 
 #include <linux/threads.h>
 #include <linux/irq.h>
+#include <asm/atomic.h>
 
 typedef struct {
 	unsigned int __softirq_pending;
@@ -26,6 +27,11 @@
 #ifdef CONFIG_X86_MCE_THRESHOLD
 	unsigned int irq_threshold_count;
 #endif
+#ifdef CONFIG_DEBUG_SMI_SNIFFER
+	atomic_t intr_occurred;
+	unsigned int smi_count;
+	unsigned int smi_duration;
+#endif
 } ____cacheline_aligned irq_cpustat_t;
 
 DECLARE_PER_CPU_SHARED_ALIGNED(irq_cpustat_t, irq_stat);
@@ -35,6 +41,15 @@
 
 #define __ARCH_IRQ_STAT
 
+#ifdef CONFIG_DEBUG_SMI_SNIFFER
+static inline void smi_sniffer_irq_enter(void)
+{
+	atomic_set(&__get_cpu_var(irq_stat.intr_occurred), 1);
+}
+#else
+static inline void smi_sniffer_irq_enter(void) {}
+#endif
+
 #define inc_irq_stat(member)	percpu_add(irq_stat.member, 1)
 
 #define local_softirq_pending()	percpu_read(irq_stat.__softirq_pending)
Index: 2.6.34-rc3/arch/x86/include/asm/idle.h
===================================================================
--- 2.6.34-rc3.orig/arch/x86/include/asm/idle.h	2010-02-24 13:52:17.000000000 -0500
+++ 2.6.34-rc3/arch/x86/include/asm/idle.h	2010-04-05 14:30:06.000000000 -0400
@@ -17,5 +17,6 @@
 #endif /* CONFIG_X86_64 */
 
 void c1e_remove_cpu(int cpu);
+int smi_sniffer_running(void);
 
 #endif /* _ASM_X86_IDLE_H */
Index: 2.6.34-rc3/arch/x86/include/asm/processor.h
===================================================================
--- 2.6.34-rc3.orig/arch/x86/include/asm/processor.h	2010-02-24 13:52:17.000000000 -0500
+++ 2.6.34-rc3/arch/x86/include/asm/processor.h	2010-04-05 14:30:06.000000000 -0400
@@ -861,6 +861,7 @@
 /* Boot loader type from the setup header: */
 extern int			bootloader_type;
 extern int			bootloader_version;
+extern int			smi_sniffer_enable;
 
 extern char			ignore_fpu_irq;
 
Index: 2.6.34-rc3/arch/x86/kernel/irq.c
===================================================================
--- 2.6.34-rc3.orig/arch/x86/kernel/irq.c	2010-02-24 13:52:17.000000000 -0500
+++ 2.6.34-rc3/arch/x86/kernel/irq.c	2010-04-05 14:30:06.000000000 -0400
@@ -114,6 +114,18 @@
 		seq_printf(p, "%10u ", per_cpu(mce_poll_count, j));
 	seq_printf(p, "  Machine check polls\n");
 #endif
+#ifdef CONFIG_DEBUG_SMI_SNIFFER
+	if (smi_sniffer_running()) {
+		seq_printf(p, "%*s: ", prec, "SMI");
+		for_each_online_cpu(j)
+			seq_printf(p, "%10u ", irq_stats(j)->smi_count);
+		seq_printf(p, "  system management interrupts while idle\n");
+		seq_printf(p, "%*s: ", prec, "DSMI");
+		for_each_online_cpu(j)
+			seq_printf(p, "%10u ", irq_stats(j)->smi_duration);
+		seq_printf(p, "  duration of most recent SMI, in usecs\n");
+	}
+#endif
 	seq_printf(p, "%*s: %10u\n", prec, "ERR", atomic_read(&irq_err_count));
 #if defined(CONFIG_X86_IO_APIC)
 	seq_printf(p, "%*s: %10u\n", prec, "MIS", atomic_read(&irq_mis_count));
Index: 2.6.34-rc3/arch/x86/kernel/process.c
===================================================================
--- 2.6.34-rc3.orig/arch/x86/kernel/process.c	2010-04-05 14:25:14.000000000 -0400
+++ 2.6.34-rc3/arch/x86/kernel/process.c	2010-04-05 14:30:06.000000000 -0400
@@ -364,12 +364,156 @@
 }
 #endif
 
+#ifdef CONFIG_DEBUG_SMI_SNIFFER
+
+/*
+ * The innermost, most basic smi-idle single-period processing.
+ *
+ * Given a max #loops, do the basic need_resched() spin test at most that
+ * many times.  If we break out early due to need_resched(), return 0.  If
+ * we reach the limit, return the #cycles we spent spinning.
+ *
+ * We force this to be un-inlined so that all callers are guaranteed to
+ * execute exactly the same instructions in the same sequence.
+ *
+ * We make this as short and sweet as possible, and also make sure it is
+ * a leaf routine, in order that the loop-part will run entirely out of
+ * registers, even on the register-starved i386.
+ */
+static noinline
+unsigned int __smi_idle_one_period(unsigned int i)
+{
+	unsigned int t1, t2;
+
+	rdtscl(t1);
+	for (; !need_resched() && i; i--)
+		cpu_relax();
+	if (i)
+		return 0; /* need_resched happened */
+	rdtscl(t2);
+	return t2 - t1;
+}
+
+/*
+ * Same as above, but keep trying until we get a good, uninterrupted
+ * timing sample or until need_resched() becomes true.
+ */
+static inline
+unsigned int smi_idle_one_period(unsigned int ilim, irq_cpustat_t *t)
+{
+	unsigned int d;
+
+	while (!need_resched()) {
+		atomic_set(&t->intr_occurred, 0);
+		d = __smi_idle_one_period(ilim);
+		if (!d || atomic_xchg(&t->intr_occurred, 0))
+			continue; /* need_resched or intr occurred */
+		return d;
+	}
+	return 0;
+}
+
+/*
+ * Apply the otherwise unused idle loop spin-time to the detection SMIs.
+ *
+ * We know that any interrupt introduces a time gap which, if it hits
+ * idle, can be detected by time sampling.  If it is a normal system
+ * interrupt then an 'interrupt happened' flag will also have been set.
+ * Therefore a gap for which the 'interrupt happened' flag remains reset
+ * can be assumed to be an SMI.
+ *
+ * In the below code, we use a self-adjusting count (ilim) that makes us
+ * spin for about 125 usecs in the normal, noninterrupting case.  We assume
+ * that an interrupt gap has occurred if, after looping for ilim counts,
+ * the time interval over the loop is at least 15 usecs larger than that.
+ *
+ * This algorithm requires the TSC to not be subject to frequency scaling.
+ */
+#define smi_ilim 61000 /* approximately correct for a 2.4 GHz cpu */
+
+static noinline void smi_idle(void)
+{
+	unsigned int ilim;
+	unsigned int n, a; /* nominal & actual period lengths, in cycles */
+	irq_cpustat_t *t;
+
+	local_irq_enable();
+	if (unlikely(system_state != SYSTEM_RUNNING)) {
+		/* do not run sniffer during boot or shutdown */
+		while (!need_resched())
+			cpu_relax();
+		return;
+	}
+
+	n = cpu_khz >> 3; /* 1 msec in cycles / 8 == 125 usecs in cycles */
+	if (unlikely(!n)) {
+		while (!need_resched())
+			cpu_relax();
+		return;
+	}
+
+	/*
+	 * Find the true limit count needed (ilim). Calculate this from the
+	 * estimated limit (smi_ilim) and from the ratio of the expected
+	 * vs actual execution time.
+	 *
+	 * Fractional integer arithmetic used, 8 bits of fraction.  Equation
+	 * rearranged to minimize the chance of overflow.
+	 */
+	t = &__get_cpu_var(irq_stat);
+	a = smi_idle_one_period(smi_ilim, t);
+	if (!a)
+		return;
+
+	ilim = (((n << 8) / a) * smi_ilim) >> 8;
+
+	/*
+	 * Now that we have an ilim that will cause our idle-loop to
+	 * loop for 125-usecs (when not interrupted), use that to
+	 * execute the basic smi-idle loop over and over, each time
+	 * checking to make sure the actual period length is about
+	 * equal to the nominal length.  If larger, then log the
+	 * difference as an SMI.
+	 */
+	while (!need_resched()) {
+		a = smi_idle_one_period(ilim, t);
+		if (!a)
+			break;
+
+		/* an SMI has to use over 125/8 == 15 usecs to be detected */
+		if (a < ((n >> 3) + n))
+			continue;
+
+		t->smi_duration = 125 * (a - n) / n; /* SMI length in usecs */
+		t->smi_count++;
+	}
+}
+
+#ifdef CONFIG_PROC_FS
+int smi_sniffer_enable __read_mostly;
+#else
+#define smi_sniffer_enable (0)
+#endif
+
+int smi_sniffer_running(void)
+{
+	return pm_idle == smi_idle
+	|| (pm_idle == default_idle && smi_sniffer_enable);
+}
+
+#endif /* CONFIG_DEBUG_SMI_SNIFFER */
+
 /*
  * We use this if we don't have any better
  * idle routine..
  */
 void default_idle(void)
 {
+#ifdef CONFIG_DEBUG_SMI_SNIFFER
+	if (smi_sniffer_enable)
+		smi_idle();
+	else
+#endif
 	if (hlt_use_halt()) {
 		trace_power_start(POWER_CSTATE, 1);
 		current_thread_info()->status &= ~TS_POLLING;
@@ -680,6 +824,11 @@
 		 */
 		idle_nomwait = 1;
 		return 0;
+#ifdef CONFIG_DEBUG_SMI_SNIFFER
+	} else if (!strcmp(str, "smi")) {
+		pr_info("Using SMI-sniffer variant of poll-idle\n");
+		pm_idle = smi_idle;
+#endif
 	} else
 		return -1;
 
Index: 2.6.34-rc3/arch/x86/kernel/smp.c
===================================================================
--- 2.6.34-rc3.orig/arch/x86/kernel/smp.c	2010-02-24 13:52:17.000000000 -0500
+++ 2.6.34-rc3/arch/x86/kernel/smp.c	2010-04-05 14:30:06.000000000 -0400
@@ -197,6 +197,7 @@
 void smp_reschedule_interrupt(struct pt_regs *regs)
 {
 	ack_APIC_irq();
+	smi_sniffer_irq_enter();
 	inc_irq_stat(irq_resched_count);
 	/*
 	 * KVM uses this interrupt to force a cpu out of guest mode
Index: 2.6.34-rc3/arch/x86/mm/tlb.c
===================================================================
--- 2.6.34-rc3.orig/arch/x86/mm/tlb.c	2010-04-05 14:25:14.000000000 -0400
+++ 2.6.34-rc3/arch/x86/mm/tlb.c	2010-04-05 14:30:06.000000000 -0400
@@ -164,6 +164,7 @@
 	cpumask_clear_cpu(cpu, to_cpumask(f->flush_cpumask));
 	smp_mb__after_clear_bit();
 	inc_irq_stat(irq_tlb_count);
+	smi_sniffer_irq_enter();
 }
 
 static void flush_tlb_others_ipi(const struct cpumask *cpumask,
Index: 2.6.34-rc3/kernel/softirq.c
===================================================================
--- 2.6.34-rc3.orig/kernel/softirq.c	2010-02-24 13:52:17.000000000 -0500
+++ 2.6.34-rc3/kernel/softirq.c	2010-04-05 14:30:06.000000000 -0400
@@ -281,6 +281,7 @@
 	if (idle_cpu(cpu) && !in_interrupt()) {
 		__irq_enter();
 		tick_check_idle(cpu);
+		smi_sniffer_irq_enter();
 	} else
 		__irq_enter();
 }
Index: 2.6.34-rc3/kernel/sysctl.c
===================================================================
--- 2.6.34-rc3.orig/kernel/sysctl.c	2010-04-05 14:25:18.000000000 -0400
+++ 2.6.34-rc3/kernel/sysctl.c	2010-04-05 14:30:06.000000000 -0400
@@ -926,6 +926,15 @@
 		.proc_handler	= proc_dointvec,
 	},
 #endif
+#ifdef CONFIG_DEBUG_SMI_SNIFFER
+	{
+		.procname	= "smi_sniffer_enable",
+		.data		= &smi_sniffer_enable,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec,
+	},
+#endif
 /*
  * NOTE: do not add new entries to this table unless you have read
  * Documentation/sysctl/ctl_unnumbered.txt
