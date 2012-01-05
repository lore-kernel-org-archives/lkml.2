Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932557Ab2AEOuE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 09:50:04 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:53895 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932474Ab2AEOuC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 09:50:02 -0500
Date: Thu, 5 Jan 2012 15:47:57 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/debug changes for v3.3
Message-ID: <20120105144757.GA6043@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
	0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-debug-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-debug-for-linus


out-of-topic modifications in x86-debug-for-linus:
--------------------------------------------------
include/linux/kernel.h             # 55af779: x86: Panic on detection of stack 
kernel/sysctl.c                    # 55af779: x86: Panic on detection of stack 

 Thanks,

	Ingo

------------------>
Dan Carpenter (1):
      x86, NMI: Add to_cpumask() to silence compile warning

Don Zickus (5):
      x86, reboot: Use NMI instead of REBOOT_VECTOR to stop cpus
      x86, NMI: Add NMI IPI selftest
      x86, NMI: Add knob to disable using NMI IPIs to stop cpus
      x86, NMI: NMI-selftest should handle the UP case properly
      x86, NMI: NMI selftest depends on the local apic

Ingo Molnar (1):
      x86: Fix the 32-bit stackoverflow-debug build

Mitsuo Hayasaka (4):
      x86: Check stack overflow in detail
      x86: Panic on detection of stack overflow
      x86: Clean up the range of stack overflow checking
      x86: Add stack top margin for stack overflow checking


 Documentation/kernel-parameters.txt |    4 +
 Documentation/sysctl/kernel.txt     |   14 +++
 arch/x86/Kconfig.debug              |   19 ++++-
 arch/x86/include/asm/smp.h          |    6 +
 arch/x86/kernel/Makefile            |    1 +
 arch/x86/kernel/irq_32.c            |    5 +
 arch/x86/kernel/irq_64.c            |   35 ++++++-
 arch/x86/kernel/nmi_selftest.c      |  180 +++++++++++++++++++++++++++++++++++
 arch/x86/kernel/smp.c               |   72 ++++++++++++++-
 arch/x86/kernel/smpboot.c           |    1 +
 include/linux/kernel.h              |    1 +
 kernel/sysctl.c                     |    9 ++
 12 files changed, 337 insertions(+), 10 deletions(-)
 create mode 100644 arch/x86/kernel/nmi_selftest.c

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index a0c5c5f..b4339e5 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1796,6 +1796,10 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 	nomfgpt		[X86-32] Disable Multi-Function General Purpose
 			Timer usage (for AMD Geode machines).
 
+	nonmi_ipi	[X86] Disable using NMI IPIs during panic/reboot to
+			shutdown the other cpus.  Instead use the REBOOT_VECTOR
+			irq.
+
 	nopat		[X86] Disable PAT (page attribute table extension of
 			pagetables) support.
 
diff --git a/Documentation/sysctl/kernel.txt b/Documentation/sysctl/kernel.txt
index 1f24636..6d8cd8b 100644
--- a/Documentation/sysctl/kernel.txt
+++ b/Documentation/sysctl/kernel.txt
@@ -49,6 +49,7 @@ show up in /proc/sys/kernel:
 - panic
 - panic_on_oops
 - panic_on_unrecovered_nmi
+- panic_on_stackoverflow
 - pid_max
 - powersave-nap               [ PPC only ]
 - printk
@@ -393,6 +394,19 @@ Controls the kernel's behaviour when an oops or BUG is encountered.
 
 ==============================================================
 
+panic_on_stackoverflow:
+
+Controls the kernel's behavior when detecting the overflows of
+kernel, IRQ and exception stacks except a user stack.
+This file shows up if CONFIG_DEBUG_STACKOVERFLOW is enabled.
+
+0: try to continue operation.
+
+1: panic immediately.
+
+==============================================================
+
+
 pid_max:
 
 PID allocation wrap value.  When the kernel's next PID value
diff --git a/arch/x86/Kconfig.debug b/arch/x86/Kconfig.debug
index bf56e17..aa4158f 100644
--- a/arch/x86/Kconfig.debug
+++ b/arch/x86/Kconfig.debug
@@ -63,8 +63,11 @@ config DEBUG_STACKOVERFLOW
 	bool "Check for stack overflows"
 	depends on DEBUG_KERNEL
 	---help---
-	  This option will cause messages to be printed if free stack space
-	  drops below a certain limit.
+	  Say Y here if you want to check the overflows of kernel, IRQ
+	  and exception stacks. This option will cause messages of the
+	  stacks in detail when free stack space drops below a certain
+	  limit.
+	  If in doubt, say "N".
 
 config X86_PTDUMP
 	bool "Export kernel pagetable layout to userspace via debugfs"
@@ -284,4 +287,16 @@ config DEBUG_STRICT_USER_COPY_CHECKS
 
 	  If unsure, or if you run an older (pre 4.4) gcc, say N.
 
+config DEBUG_NMI_SELFTEST
+	bool "NMI Selftest"
+	depends on DEBUG_KERNEL && X86_LOCAL_APIC
+	---help---
+	  Enabling this option turns on a quick NMI selftest to verify
+	  that the NMI behaves correctly.
+
+	  This might help diagnose strange hangs that rely on NMI to
+	  function properly.
+
+	  If unsure, say N.
+
 endmenu
diff --git a/arch/x86/include/asm/smp.h b/arch/x86/include/asm/smp.h
index 73b11bc..0434c40 100644
--- a/arch/x86/include/asm/smp.h
+++ b/arch/x86/include/asm/smp.h
@@ -225,5 +225,11 @@ extern int hard_smp_processor_id(void);
 
 #endif /* CONFIG_X86_LOCAL_APIC */
 
+#ifdef CONFIG_DEBUG_NMI_SELFTEST
+extern void nmi_selftest(void);
+#else
+#define nmi_selftest() do { } while (0)
+#endif
+
 #endif /* __ASSEMBLY__ */
 #endif /* _ASM_X86_SMP_H */
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 8baca3c..02b2f05 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -80,6 +80,7 @@ obj-$(CONFIG_APB_TIMER)		+= apb_timer.o
 obj-$(CONFIG_AMD_NB)		+= amd_nb.o
 obj-$(CONFIG_DEBUG_RODATA_TEST)	+= test_rodata.o
 obj-$(CONFIG_DEBUG_NX_TEST)	+= test_nx.o
+obj-$(CONFIG_DEBUG_NMI_SELFTEST) += nmi_selftest.o
 
 obj-$(CONFIG_KVM_GUEST)		+= kvm.o
 obj-$(CONFIG_KVM_CLOCK)		+= kvmclock.o
diff --git a/arch/x86/kernel/irq_32.c b/arch/x86/kernel/irq_32.c
index 7209070..40fc861 100644
--- a/arch/x86/kernel/irq_32.c
+++ b/arch/x86/kernel/irq_32.c
@@ -28,6 +28,9 @@ DEFINE_PER_CPU(struct pt_regs *, irq_regs);
 EXPORT_PER_CPU_SYMBOL(irq_regs);
 
 #ifdef CONFIG_DEBUG_STACKOVERFLOW
+
+int sysctl_panic_on_stackoverflow __read_mostly;
+
 /* Debugging check for stack overflow: is there less than 1KB free? */
 static int check_stack_overflow(void)
 {
@@ -43,6 +46,8 @@ static void print_stack_overflow(void)
 {
 	printk(KERN_WARNING "low stack detected by irq handler\n");
 	dump_stack();
+	if (sysctl_panic_on_stackoverflow)
+		panic("low stack detected by irq handler - check messages\n");
 }
 
 #else
diff --git a/arch/x86/kernel/irq_64.c b/arch/x86/kernel/irq_64.c
index 69bca46..d04d3ec 100644
--- a/arch/x86/kernel/irq_64.c
+++ b/arch/x86/kernel/irq_64.c
@@ -26,6 +26,8 @@ EXPORT_PER_CPU_SYMBOL(irq_stat);
 DEFINE_PER_CPU(struct pt_regs *, irq_regs);
 EXPORT_PER_CPU_SYMBOL(irq_regs);
 
+int sysctl_panic_on_stackoverflow;
+
 /*
  * Probabilistic stack overflow check:
  *
@@ -36,18 +38,39 @@ EXPORT_PER_CPU_SYMBOL(irq_regs);
 static inline void stack_overflow_check(struct pt_regs *regs)
 {
 #ifdef CONFIG_DEBUG_STACKOVERFLOW
+#define STACK_TOP_MARGIN	128
+	struct orig_ist *oist;
+	u64 irq_stack_top, irq_stack_bottom;
+	u64 estack_top, estack_bottom;
 	u64 curbase = (u64)task_stack_page(current);
 
 	if (user_mode_vm(regs))
 		return;
 
-	WARN_ONCE(regs->sp >= curbase &&
-		  regs->sp <= curbase + THREAD_SIZE &&
-		  regs->sp <  curbase + sizeof(struct thread_info) +
-					sizeof(struct pt_regs) + 128,
+	if (regs->sp >= curbase + sizeof(struct thread_info) +
+				  sizeof(struct pt_regs) + STACK_TOP_MARGIN &&
+	    regs->sp <= curbase + THREAD_SIZE)
+		return;
+
+	irq_stack_top = (u64)__get_cpu_var(irq_stack_union.irq_stack) +
+			STACK_TOP_MARGIN;
+	irq_stack_bottom = (u64)__get_cpu_var(irq_stack_ptr);
+	if (regs->sp >= irq_stack_top && regs->sp <= irq_stack_bottom)
+		return;
+
+	oist = &__get_cpu_var(orig_ist);
+	estack_top = (u64)oist->ist[0] - EXCEPTION_STKSZ + STACK_TOP_MARGIN;
+	estack_bottom = (u64)oist->ist[N_EXCEPTION_STACKS - 1];
+	if (regs->sp >= estack_top && regs->sp <= estack_bottom)
+		return;
+
+	WARN_ONCE(1, "do_IRQ(): %s has overflown the kernel stack (cur:%Lx,sp:%lx,irq stk top-bottom:%Lx-%Lx,exception stk top-bottom:%Lx-%Lx)\n",
+		current->comm, curbase, regs->sp,
+		irq_stack_top, irq_stack_bottom,
+		estack_top, estack_bottom);
 
-		  "do_IRQ: %s near stack overflow (cur:%Lx,sp:%lx)\n",
-			current->comm, curbase, regs->sp);
+	if (sysctl_panic_on_stackoverflow)
+		panic("low stack detected by irq handler - check messages\n");
 #endif
 }
 
diff --git a/arch/x86/kernel/nmi_selftest.c b/arch/x86/kernel/nmi_selftest.c
new file mode 100644
index 0000000..0d01a8e
--- /dev/null
+++ b/arch/x86/kernel/nmi_selftest.c
@@ -0,0 +1,180 @@
+/*
+ * arch/x86/kernel/nmi-selftest.c
+ *
+ * Testsuite for NMI: IPIs
+ *
+ * Started by Don Zickus:
+ * (using lib/locking-selftest.c as a guide)
+ *
+ *   Copyright (C) 2011 Red Hat, Inc., Don Zickus <dzickus@redhat.com>
+ */
+
+#include <linux/smp.h>
+#include <linux/cpumask.h>
+#include <linux/delay.h>
+
+#include <asm/apic.h>
+#include <asm/nmi.h>
+
+#define SUCCESS		0
+#define FAILURE		1
+#define TIMEOUT		2
+
+static int nmi_fail;
+
+/* check to see if NMI IPIs work on this machine */
+static DECLARE_BITMAP(nmi_ipi_mask, NR_CPUS) __read_mostly;
+
+static int testcase_total;
+static int testcase_successes;
+static int expected_testcase_failures;
+static int unexpected_testcase_failures;
+static int unexpected_testcase_unknowns;
+
+static int nmi_unk_cb(unsigned int val, struct pt_regs *regs)
+{
+	unexpected_testcase_unknowns++;
+	return NMI_HANDLED;
+}
+
+static void init_nmi_testsuite(void)
+{
+	/* trap all the unknown NMIs we may generate */
+	register_nmi_handler(NMI_UNKNOWN, nmi_unk_cb, 0, "nmi_selftest_unk");
+}
+
+static void cleanup_nmi_testsuite(void)
+{
+	unregister_nmi_handler(NMI_UNKNOWN, "nmi_selftest_unk");
+}
+
+static int test_nmi_ipi_callback(unsigned int val, struct pt_regs *regs)
+{
+        int cpu = raw_smp_processor_id();
+
+        if (cpumask_test_and_clear_cpu(cpu, to_cpumask(nmi_ipi_mask)))
+                return NMI_HANDLED;
+
+        return NMI_DONE;
+}
+
+static void test_nmi_ipi(struct cpumask *mask)
+{
+	unsigned long timeout;
+
+	if (register_nmi_handler(NMI_LOCAL, test_nmi_ipi_callback,
+				 NMI_FLAG_FIRST, "nmi_selftest")) {
+		nmi_fail = FAILURE;
+		return;
+	}
+
+	/* sync above data before sending NMI */
+	wmb();
+
+	apic->send_IPI_mask(mask, NMI_VECTOR);
+
+	/* Don't wait longer than a second */
+	timeout = USEC_PER_SEC;
+	while (!cpumask_empty(mask) && timeout--)
+	        udelay(1);
+
+	/* What happens if we timeout, do we still unregister?? */
+	unregister_nmi_handler(NMI_LOCAL, "nmi_selftest");
+
+	if (!timeout)
+		nmi_fail = TIMEOUT;
+	return;
+}
+
+static void remote_ipi(void)
+{
+	cpumask_copy(to_cpumask(nmi_ipi_mask), cpu_online_mask);
+	cpumask_clear_cpu(smp_processor_id(), to_cpumask(nmi_ipi_mask));
+	if (!cpumask_empty(to_cpumask(nmi_ipi_mask)))
+		test_nmi_ipi(to_cpumask(nmi_ipi_mask));
+}
+
+static void local_ipi(void)
+{
+	cpumask_clear(to_cpumask(nmi_ipi_mask));
+	cpumask_set_cpu(smp_processor_id(), to_cpumask(nmi_ipi_mask));
+	test_nmi_ipi(to_cpumask(nmi_ipi_mask));
+}
+
+static void reset_nmi(void)
+{
+	nmi_fail = 0;
+}
+
+static void dotest(void (*testcase_fn)(void), int expected)
+{
+	testcase_fn();
+	/*
+	 * Filter out expected failures:
+	 */
+	if (nmi_fail != expected) {
+		unexpected_testcase_failures++;
+
+		if (nmi_fail == FAILURE)
+			printk("FAILED |");
+		else if (nmi_fail == TIMEOUT)
+			printk("TIMEOUT|");
+		else
+			printk("ERROR  |");
+		dump_stack();
+	} else {
+		testcase_successes++;
+		printk("  ok  |");
+	}
+	testcase_total++;
+
+	reset_nmi();
+}
+
+static inline void print_testname(const char *testname)
+{
+	printk("%12s:", testname);
+}
+
+void nmi_selftest(void)
+{
+	init_nmi_testsuite();
+
+        /*
+	 * Run the testsuite:
+	 */
+	printk("----------------\n");
+	printk("| NMI testsuite:\n");
+	printk("--------------------\n");
+
+	print_testname("remote IPI");
+	dotest(remote_ipi, SUCCESS);
+	printk("\n");
+	print_testname("local IPI");
+	dotest(local_ipi, SUCCESS);
+	printk("\n");
+
+	cleanup_nmi_testsuite();
+
+	if (unexpected_testcase_failures) {
+		printk("--------------------\n");
+		printk("BUG: %3d unexpected failures (out of %3d) - debugging disabled! |\n",
+			unexpected_testcase_failures, testcase_total);
+		printk("-----------------------------------------------------------------\n");
+	} else if (expected_testcase_failures && testcase_successes) {
+		printk("--------------------\n");
+		printk("%3d out of %3d testcases failed, as expected. |\n",
+			expected_testcase_failures, testcase_total);
+		printk("----------------------------------------------------\n");
+	} else if (expected_testcase_failures && !testcase_successes) {
+		printk("--------------------\n");
+		printk("All %3d testcases failed, as expected. |\n",
+			expected_testcase_failures);
+		printk("----------------------------------------\n");
+	} else {
+		printk("--------------------\n");
+		printk("Good, all %3d testcases passed! |\n",
+			testcase_successes);
+		printk("---------------------------------\n");
+	}
+}
diff --git a/arch/x86/kernel/smp.c b/arch/x86/kernel/smp.c
index 16204dc..113acda 100644
--- a/arch/x86/kernel/smp.c
+++ b/arch/x86/kernel/smp.c
@@ -29,6 +29,7 @@
 #include <asm/mmu_context.h>
 #include <asm/proto.h>
 #include <asm/apic.h>
+#include <asm/nmi.h>
 /*
  *	Some notes on x86 processor bugs affecting SMP operation:
  *
@@ -148,6 +149,60 @@ void native_send_call_func_ipi(const struct cpumask *mask)
 	free_cpumask_var(allbutself);
 }
 
+static atomic_t stopping_cpu = ATOMIC_INIT(-1);
+
+static int smp_stop_nmi_callback(unsigned int val, struct pt_regs *regs)
+{
+	/* We are registered on stopping cpu too, avoid spurious NMI */
+	if (raw_smp_processor_id() == atomic_read(&stopping_cpu))
+		return NMI_HANDLED;
+
+	stop_this_cpu(NULL);
+
+	return NMI_HANDLED;
+}
+
+static void native_nmi_stop_other_cpus(int wait)
+{
+	unsigned long flags;
+	unsigned long timeout;
+
+	if (reboot_force)
+		return;
+
+	/*
+	 * Use an own vector here because smp_call_function
+	 * does lots of things not suitable in a panic situation.
+	 */
+	if (num_online_cpus() > 1) {
+		/* did someone beat us here? */
+		if (atomic_cmpxchg(&stopping_cpu, -1, safe_smp_processor_id() != -1))
+			return;
+
+		if (register_nmi_handler(NMI_LOCAL, smp_stop_nmi_callback,
+					 NMI_FLAG_FIRST, "smp_stop"))
+			/* Note: we ignore failures here */
+			return;
+
+		/* sync above data before sending NMI */
+		wmb();
+
+		apic->send_IPI_allbutself(NMI_VECTOR);
+
+		/*
+		 * Don't wait longer than a second if the caller
+		 * didn't ask us to wait.
+		 */
+		timeout = USEC_PER_SEC;
+		while (num_online_cpus() > 1 && (wait || timeout--))
+			udelay(1);
+	}
+
+	local_irq_save(flags);
+	disable_local_APIC();
+	local_irq_restore(flags);
+}
+
 /*
  * this function calls the 'stop' function on all other CPUs in the system.
  */
@@ -160,7 +215,7 @@ asmlinkage void smp_reboot_interrupt(void)
 	irq_exit();
 }
 
-static void native_stop_other_cpus(int wait)
+static void native_irq_stop_other_cpus(int wait)
 {
 	unsigned long flags;
 	unsigned long timeout;
@@ -194,6 +249,11 @@ static void native_stop_other_cpus(int wait)
 	local_irq_restore(flags);
 }
 
+static void native_smp_disable_nmi_ipi(void)
+{
+	smp_ops.stop_other_cpus = native_irq_stop_other_cpus;
+}
+
 /*
  * Reschedule call back.
  */
@@ -225,12 +285,20 @@ void smp_call_function_single_interrupt(struct pt_regs *regs)
 	irq_exit();
 }
 
+static int __init nonmi_ipi_setup(char *str)
+{
+        native_smp_disable_nmi_ipi();
+        return 1;
+}
+
+__setup("nonmi_ipi", nonmi_ipi_setup);
+
 struct smp_ops smp_ops = {
 	.smp_prepare_boot_cpu	= native_smp_prepare_boot_cpu,
 	.smp_prepare_cpus	= native_smp_prepare_cpus,
 	.smp_cpus_done		= native_smp_cpus_done,
 
-	.stop_other_cpus	= native_stop_other_cpus,
+	.stop_other_cpus	= native_nmi_stop_other_cpus,
 	.smp_send_reschedule	= native_smp_send_reschedule,
 
 	.cpu_up			= native_cpu_up,
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 9f548cb..1927781 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -1142,6 +1142,7 @@ void __init native_smp_cpus_done(unsigned int max_cpus)
 {
 	pr_debug("Boot done.\n");
 
+	nmi_selftest();
 	impress_friends();
 #ifdef CONFIG_X86_IO_APIC
 	setup_ioapic_dest();
diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index e8b1597..ff83683 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -341,6 +341,7 @@ extern int panic_timeout;
 extern int panic_on_oops;
 extern int panic_on_unrecovered_nmi;
 extern int panic_on_io_nmi;
+extern int sysctl_panic_on_stackoverflow;
 extern const char *print_tainted(void);
 extern void add_taint(unsigned flag);
 extern int test_taint(unsigned flag);
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index ae27196..f487f25 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -803,6 +803,15 @@ static struct ctl_table kern_table[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec,
 	},
+#ifdef CONFIG_DEBUG_STACKOVERFLOW
+	{
+		.procname	= "panic_on_stackoverflow",
+		.data		= &sysctl_panic_on_stackoverflow,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec,
+	},
+#endif
 	{
 		.procname	= "bootloader_type",
 		.data		= &bootloader_type,
