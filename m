Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753094Ab2LKKib (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 05:38:31 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:58607 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752034Ab2LKKi2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 05:38:28 -0500
Date: Tue, 11 Dec 2012 11:38:22 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86 generic hotplug changes for v3.8
Message-ID: <20121211103822.GA25566@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-bsp-hotplug-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-bsp-hotplug-for-linus

   HEAD: a71c8bc5dfefbbf80ef90739791554ef7ea4401b x86, topology: Debug CPU0 hotplug

This tree enables CPU#0 (the boot processor) to be 
onlined/offlined on x86, just like any other CPU. Enabled on 
Intel CPUs for now.

Allowing this required the identification and fixing of latent 
CPU#0 assumptions (such as CPU#0 initializations, etc.) in the 
x86 architecture code, plus the identification of barriers to 
BSP-offlining, such as active PIC interrupts which can only be 
serviced on the BSP.

It's behind a default-off option, and there's a debug option 
that allows the automatic testing of this feature.

The motivation of this feature is to allow and prepare for true 
CPU-hotplug hardware support: recent changes to MCE support 
enable us to detect a deteriorating but not yet hard-failing 
L1/L2 cache on a CPU that could be soft-unplugged - or a failing 
L3 cache on a multi-socket system.

Note that true hardware hot-plug is not yet fully enabled by 
this, because that requires a special platform wakeup sequence 
to be sent to the freshly powered up CPU#0. Future patches for 
this are planned, once such a platform exists. Chicken and egg 
...

out-of-topic modifications in x86-bsp-hotplug-for-linus:
--------------------------------------------------------
kernel/cpu.c                       # 6e32d47: kernel/cpu.c: Add comment for pri

 Thanks,

	Ingo

------------------>
Fenghua Yu (14):
      doc: Add x86 CPU0 online/offline feature
      x86, Kconfig: Add config switch for CPU0 hotplug
      x86, topology: Don't offline CPU0 if any PIC irq can not be migrated out of it
      x86, hotplug: Support functions for CPU0 online/offline
      x86, hotplug, suspend: Online CPU0 for suspend or hibernate
      kernel/cpu.c: Add comment for priority in cpu_hotplug_pm_callback
      x86-64, hotplug: Add start_cpu0() entry point to head_64.S
      x86-32, hotplug: Add start_cpu0() entry point to head_32.S
      x86, hotplug: Wake up CPU0 via NMI instead of INIT, SIPI, SIPI
      x86, hotplug: During CPU0 online, enable x2apic, set_numa_node.
      x86, hotplug: The first online processor saves the MTRR state
      x86, hotplug: Handle retrigger irq by the first available CPU
      x86/i387.c: Initialize thread xstate only on CPU0 only once
      x86, topology: Debug CPU0 hotplug


 Documentation/cpu-hotplug.txt       |  24 ++++++
 Documentation/kernel-parameters.txt |  14 ++++
 arch/x86/Kconfig                    |  44 +++++++++++
 arch/x86/include/asm/cpu.h          |   4 +
 arch/x86/include/asm/smp.h          |   1 +
 arch/x86/kernel/apic/io_apic.c      |   4 +-
 arch/x86/kernel/cpu/common.c        |   5 +-
 arch/x86/kernel/cpu/mtrr/main.c     |   9 ++-
 arch/x86/kernel/head_32.S           |  13 ++++
 arch/x86/kernel/head_64.S           |  16 ++++
 arch/x86/kernel/i387.c              |   6 +-
 arch/x86/kernel/smpboot.c           | 149 +++++++++++++++++++++++++++++-------
 arch/x86/kernel/topology.c          | 101 ++++++++++++++++++++++--
 arch/x86/power/cpu.c                |  82 ++++++++++++++++++++
 kernel/cpu.c                        |   5 ++
 15 files changed, 436 insertions(+), 41 deletions(-)

diff --git a/Documentation/cpu-hotplug.txt b/Documentation/cpu-hotplug.txt
index 66ef8f3..9f40135 100644
--- a/Documentation/cpu-hotplug.txt
+++ b/Documentation/cpu-hotplug.txt
@@ -207,6 +207,30 @@ by making it not-removable.
 
 In such cases you will also notice that the online file is missing under cpu0.
 
+Q: Is CPU0 removable on X86?
+A: Yes. If kernel is compiled with CONFIG_BOOTPARAM_HOTPLUG_CPU0=y, CPU0 is
+removable by default. Otherwise, CPU0 is also removable by kernel option
+cpu0_hotplug.
+
+But some features depend on CPU0. Two known dependencies are:
+
+1. Resume from hibernate/suspend depends on CPU0. Hibernate/suspend will fail if
+CPU0 is offline and you need to online CPU0 before hibernate/suspend can
+continue.
+2. PIC interrupts also depend on CPU0. CPU0 can't be removed if a PIC interrupt
+is detected.
+
+It's said poweroff/reboot may depend on CPU0 on some machines although I haven't
+seen any poweroff/reboot failure so far after CPU0 is offline on a few tested
+machines.
+
+Please let me know if you know or see any other dependencies of CPU0.
+
+If the dependencies are under your control, you can turn on CPU0 hotplug feature
+either by CONFIG_BOOTPARAM_HOTPLUG_CPU0 or by kernel parameter cpu0_hotplug.
+
+--Fenghua Yu <fenghua.yu@intel.com>
+
 Q: How do i find out if a particular CPU is not removable?
 A: Depending on the implementation, some architectures may show this by the
 absence of the "online" file. This is done if it can be determined ahead of
diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 9776f06..f7cbe1d 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1984,6 +1984,20 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 
 	nox2apic	[X86-64,APIC] Do not enable x2APIC mode.
 
+	cpu0_hotplug	[X86] Turn on CPU0 hotplug feature when
+			CONFIG_BOOTPARAM_HOTPLUG_CPU0 is off.
+			Some features depend on CPU0. Known dependencies are:
+			1. Resume from suspend/hibernate depends on CPU0.
+			Suspend/hibernate will fail if CPU0 is offline and you
+			need to online CPU0 before suspend/hibernate.
+			2. PIC interrupts also depend on CPU0. CPU0 can't be
+			removed if a PIC interrupt is detected.
+			It's said poweroff/reboot may depend on CPU0 on some
+			machines although I haven't seen such issues so far
+			after CPU0 is offline on a few tested machines.
+			If the dependencies are under your control, you can
+			turn on cpu0_hotplug.
+
 	nptcg=		[IA-64] Override max number of concurrent global TLB
 			purges which is reported from either PAL_VM_SUMMARY or
 			SAL PALO.
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 46c3bff..b6cfa5f 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1698,6 +1698,50 @@ config HOTPLUG_CPU
 	    automatically on SMP systems. )
 	  Say N if you want to disable CPU hotplug.
 
+config BOOTPARAM_HOTPLUG_CPU0
+	bool "Set default setting of cpu0_hotpluggable"
+	default n
+	depends on HOTPLUG_CPU && EXPERIMENTAL
+	---help---
+	  Set whether default state of cpu0_hotpluggable is on or off.
+
+	  Say Y here to enable CPU0 hotplug by default. If this switch
+	  is turned on, there is no need to give cpu0_hotplug kernel
+	  parameter and the CPU0 hotplug feature is enabled by default.
+
+	  Please note: there are two known CPU0 dependencies if you want
+	  to enable the CPU0 hotplug feature either by this switch or by
+	  cpu0_hotplug kernel parameter.
+
+	  First, resume from hibernate or suspend always starts from CPU0.
+	  So hibernate and suspend are prevented if CPU0 is offline.
+
+	  Second dependency is PIC interrupts always go to CPU0. CPU0 can not
+	  offline if any interrupt can not migrate out of CPU0. There may
+	  be other CPU0 dependencies.
+
+	  Please make sure the dependencies are under your control before
+	  you enable this feature.
+
+	  Say N if you don't want to enable CPU0 hotplug feature by default.
+	  You still can enable the CPU0 hotplug feature at boot by kernel
+	  parameter cpu0_hotplug.
+
+config DEBUG_HOTPLUG_CPU0
+	def_bool n
+	prompt "Debug CPU0 hotplug"
+	depends on HOTPLUG_CPU && EXPERIMENTAL
+	---help---
+	  Enabling this option offlines CPU0 (if CPU0 can be offlined) as
+	  soon as possible and boots up userspace with CPU0 offlined. User
+	  can online CPU0 back after boot time.
+
+	  To debug CPU0 hotplug, you need to enable CPU0 offline/online
+	  feature by either turning on CONFIG_BOOTPARAM_HOTPLUG_CPU0 during
+	  compilation or giving cpu0_hotplug kernel parameter at boot.
+
+	  If unsure, say N.
+
 config COMPAT_VDSO
 	def_bool y
 	prompt "Compat VDSO support"
diff --git a/arch/x86/include/asm/cpu.h b/arch/x86/include/asm/cpu.h
index 4564c8e..5f9a124 100644
--- a/arch/x86/include/asm/cpu.h
+++ b/arch/x86/include/asm/cpu.h
@@ -28,6 +28,10 @@ struct x86_cpu {
 #ifdef CONFIG_HOTPLUG_CPU
 extern int arch_register_cpu(int num);
 extern void arch_unregister_cpu(int);
+extern void __cpuinit start_cpu0(void);
+#ifdef CONFIG_DEBUG_HOTPLUG_CPU0
+extern int _debug_hotplug_cpu(int cpu, int action);
+#endif
 #endif
 
 DECLARE_PER_CPU(int, cpu_state);
diff --git a/arch/x86/include/asm/smp.h b/arch/x86/include/asm/smp.h
index 4f19a15..b073aae 100644
--- a/arch/x86/include/asm/smp.h
+++ b/arch/x86/include/asm/smp.h
@@ -166,6 +166,7 @@ void native_send_call_func_ipi(const struct cpumask *mask);
 void native_send_call_func_single_ipi(int cpu);
 void x86_idle_thread_init(unsigned int cpu, struct task_struct *idle);
 
+void smp_store_boot_cpu_info(void);
 void smp_store_cpu_info(int id);
 #define cpu_physical_id(cpu)	per_cpu(x86_cpu_to_apicid, cpu)
 
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 1817fa9..f78fc2b 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -2199,9 +2199,11 @@ static int ioapic_retrigger_irq(struct irq_data *data)
 {
 	struct irq_cfg *cfg = data->chip_data;
 	unsigned long flags;
+	int cpu;
 
 	raw_spin_lock_irqsave(&vector_lock, flags);
-	apic->send_IPI_mask(cpumask_of(cpumask_first(cfg->domain)), cfg->vector);
+	cpu = cpumask_first_and(cfg->domain, cpu_online_mask);
+	apic->send_IPI_mask(cpumask_of(cpu), cfg->vector);
 	raw_spin_unlock_irqrestore(&vector_lock, flags);
 
 	return 1;
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 7505f7b..ca165ac 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1237,7 +1237,7 @@ void __cpuinit cpu_init(void)
 	oist = &per_cpu(orig_ist, cpu);
 
 #ifdef CONFIG_NUMA
-	if (cpu != 0 && this_cpu_read(numa_node) == 0 &&
+	if (this_cpu_read(numa_node) == 0 &&
 	    early_cpu_to_node(cpu) != NUMA_NO_NODE)
 		set_numa_node(early_cpu_to_node(cpu));
 #endif
@@ -1269,8 +1269,7 @@ void __cpuinit cpu_init(void)
 	barrier();
 
 	x86_configure_nx();
-	if (cpu != 0)
-		enable_x2apic();
+	enable_x2apic();
 
 	/*
 	 * set up and load the per-CPU TSS
diff --git a/arch/x86/kernel/cpu/mtrr/main.c b/arch/x86/kernel/cpu/mtrr/main.c
index 6b96110..e4c1a41 100644
--- a/arch/x86/kernel/cpu/mtrr/main.c
+++ b/arch/x86/kernel/cpu/mtrr/main.c
@@ -695,11 +695,16 @@ void mtrr_ap_init(void)
 }
 
 /**
- * Save current fixed-range MTRR state of the BSP
+ * Save current fixed-range MTRR state of the first cpu in cpu_online_mask.
  */
 void mtrr_save_state(void)
 {
-	smp_call_function_single(0, mtrr_save_fixed_ranges, NULL, 1);
+	int first_cpu;
+
+	get_online_cpus();
+	first_cpu = cpumask_first(cpu_online_mask);
+	smp_call_function_single(first_cpu, mtrr_save_fixed_ranges, NULL, 1);
+	put_online_cpus();
 }
 
 void set_mtrr_aps_delayed_init(void)
diff --git a/arch/x86/kernel/head_32.S b/arch/x86/kernel/head_32.S
index 957a47a..a013e73 100644
--- a/arch/x86/kernel/head_32.S
+++ b/arch/x86/kernel/head_32.S
@@ -266,6 +266,19 @@ num_subarch_entries = (. - subarch_entries) / 4
 	jmp default_entry
 #endif /* CONFIG_PARAVIRT */
 
+#ifdef CONFIG_HOTPLUG_CPU
+/*
+ * Boot CPU0 entry point. It's called from play_dead(). Everything has been set
+ * up already except stack. We just set up stack here. Then call
+ * start_secondary().
+ */
+ENTRY(start_cpu0)
+	movl stack_start, %ecx
+	movl %ecx, %esp
+	jmp  *(initial_code)
+ENDPROC(start_cpu0)
+#endif
+
 /*
  * Non-boot CPU entry point; entered from trampoline.S
  * We can't lgdt here, because lgdt itself uses a data segment, but
diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
index 94bf9cc..980053c 100644
--- a/arch/x86/kernel/head_64.S
+++ b/arch/x86/kernel/head_64.S
@@ -252,6 +252,22 @@ ENTRY(secondary_startup_64)
 	pushq	%rax		# target address in negative space
 	lretq
 
+#ifdef CONFIG_HOTPLUG_CPU
+/*
+ * Boot CPU0 entry point. It's called from play_dead(). Everything has been set
+ * up already except stack. We just set up stack here. Then call
+ * start_secondary().
+ */
+ENTRY(start_cpu0)
+	movq stack_start(%rip),%rsp
+	movq	initial_code(%rip),%rax
+	pushq	$0		# fake return address to stop unwinder
+	pushq	$__KERNEL_CS	# set correct cs
+	pushq	%rax		# target address in negative space
+	lretq
+ENDPROC(start_cpu0)
+#endif
+
 	/* SMP bootup changes these two */
 	__REFDATA
 	.align	8
diff --git a/arch/x86/kernel/i387.c b/arch/x86/kernel/i387.c
index 675a050..245a71d 100644
--- a/arch/x86/kernel/i387.c
+++ b/arch/x86/kernel/i387.c
@@ -175,7 +175,11 @@ void __cpuinit fpu_init(void)
 		cr0 |= X86_CR0_EM;
 	write_cr0(cr0);
 
-	if (!smp_processor_id())
+	/*
+	 * init_thread_xstate is only called once to avoid overriding
+	 * xstate_size during boot time or during CPU hotplug.
+	 */
+	if (xstate_size == 0)
 		init_thread_xstate();
 
 	mxcsr_feature_mask_init();
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index c80a33b..ef53e66 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -125,8 +125,8 @@ EXPORT_PER_CPU_SYMBOL(cpu_info);
 atomic_t init_deasserted;
 
 /*
- * Report back to the Boot Processor.
- * Running on AP.
+ * Report back to the Boot Processor during boot time or to the caller processor
+ * during CPU online.
  */
 static void __cpuinit smp_callin(void)
 {
@@ -138,15 +138,17 @@ static void __cpuinit smp_callin(void)
 	 * we may get here before an INIT-deassert IPI reaches
 	 * our local APIC.  We have to wait for the IPI or we'll
 	 * lock up on an APIC access.
+	 *
+	 * Since CPU0 is not wakened up by INIT, it doesn't wait for the IPI.
 	 */
-	if (apic->wait_for_init_deassert)
+	cpuid = smp_processor_id();
+	if (apic->wait_for_init_deassert && cpuid != 0)
 		apic->wait_for_init_deassert(&init_deasserted);
 
 	/*
 	 * (This works even if the APIC is not enabled.)
 	 */
 	phys_id = read_apic_id();
-	cpuid = smp_processor_id();
 	if (cpumask_test_cpu(cpuid, cpu_callin_mask)) {
 		panic("%s: phys CPU#%d, CPU#%d already present??\n", __func__,
 					phys_id, cpuid);
@@ -228,6 +230,8 @@ static void __cpuinit smp_callin(void)
 	cpumask_set_cpu(cpuid, cpu_callin_mask);
 }
 
+static int cpu0_logical_apicid;
+static int enable_start_cpu0;
 /*
  * Activate a secondary processor.
  */
@@ -243,6 +247,8 @@ notrace static void __cpuinit start_secondary(void *unused)
 	preempt_disable();
 	smp_callin();
 
+	enable_start_cpu0 = 0;
+
 #ifdef CONFIG_X86_32
 	/* switch away from the initial page table */
 	load_cr3(swapper_pg_dir);
@@ -279,19 +285,30 @@ notrace static void __cpuinit start_secondary(void *unused)
 	cpu_idle();
 }
 
+void __init smp_store_boot_cpu_info(void)
+{
+	int id = 0; /* CPU 0 */
+	struct cpuinfo_x86 *c = &cpu_data(id);
+
+	*c = boot_cpu_data;
+	c->cpu_index = id;
+}
+
 /*
  * The bootstrap kernel entry code has set these up. Save them for
  * a given CPU
  */
-
 void __cpuinit smp_store_cpu_info(int id)
 {
 	struct cpuinfo_x86 *c = &cpu_data(id);
 
 	*c = boot_cpu_data;
 	c->cpu_index = id;
-	if (id != 0)
-		identify_secondary_cpu(c);
+	/*
+	 * During boot time, CPU0 has this setup already. Save the info when
+	 * bringing up AP or offlined CPU0.
+	 */
+	identify_secondary_cpu(c);
 }
 
 static bool __cpuinit
@@ -481,7 +498,7 @@ void __inquire_remote_apic(int apicid)
  * won't ... remember to clear down the APIC, etc later.
  */
 int __cpuinit
-wakeup_secondary_cpu_via_nmi(int logical_apicid, unsigned long start_eip)
+wakeup_secondary_cpu_via_nmi(int apicid, unsigned long start_eip)
 {
 	unsigned long send_status, accept_status = 0;
 	int maxlvt;
@@ -489,7 +506,7 @@ wakeup_secondary_cpu_via_nmi(int logical_apicid, unsigned long start_eip)
 	/* Target chip */
 	/* Boot on the stack */
 	/* Kick the second */
-	apic_icr_write(APIC_DM_NMI | apic->dest_logical, logical_apicid);
+	apic_icr_write(APIC_DM_NMI | apic->dest_logical, apicid);
 
 	pr_debug("Waiting for send to finish...\n");
 	send_status = safe_apic_wait_icr_idle();
@@ -649,6 +666,63 @@ static void __cpuinit announce_cpu(int cpu, int apicid)
 			node, cpu, apicid);
 }
 
+static int wakeup_cpu0_nmi(unsigned int cmd, struct pt_regs *regs)
+{
+	int cpu;
+
+	cpu = smp_processor_id();
+	if (cpu == 0 && !cpu_online(cpu) && enable_start_cpu0)
+		return NMI_HANDLED;
+
+	return NMI_DONE;
+}
+
+/*
+ * Wake up AP by INIT, INIT, STARTUP sequence.
+ *
+ * Instead of waiting for STARTUP after INITs, BSP will execute the BIOS
+ * boot-strap code which is not a desired behavior for waking up BSP. To
+ * void the boot-strap code, wake up CPU0 by NMI instead.
+ *
+ * This works to wake up soft offlined CPU0 only. If CPU0 is hard offlined
+ * (i.e. physically hot removed and then hot added), NMI won't wake it up.
+ * We'll change this code in the future to wake up hard offlined CPU0 if
+ * real platform and request are available.
+ */
+static int __cpuinit
+wakeup_cpu_via_init_nmi(int cpu, unsigned long start_ip, int apicid,
+	       int *cpu0_nmi_registered)
+{
+	int id;
+	int boot_error;
+
+	/*
+	 * Wake up AP by INIT, INIT, STARTUP sequence.
+	 */
+	if (cpu)
+		return wakeup_secondary_cpu_via_init(apicid, start_ip);
+
+	/*
+	 * Wake up BSP by nmi.
+	 *
+	 * Register a NMI handler to help wake up CPU0.
+	 */
+	boot_error = register_nmi_handler(NMI_LOCAL,
+					  wakeup_cpu0_nmi, 0, "wake_cpu0");
+
+	if (!boot_error) {
+		enable_start_cpu0 = 1;
+		*cpu0_nmi_registered = 1;
+		if (apic->dest_logical == APIC_DEST_LOGICAL)
+			id = cpu0_logical_apicid;
+		else
+			id = apicid;
+		boot_error = wakeup_secondary_cpu_via_nmi(id, start_ip);
+	}
+
+	return boot_error;
+}
+
 /*
  * NOTE - on most systems this is a PHYSICAL apic ID, but on multiquad
  * (ie clustered apic addressing mode), this is a LOGICAL apic ID.
@@ -664,6 +738,7 @@ static int __cpuinit do_boot_cpu(int apicid, int cpu, struct task_struct *idle)
 
 	unsigned long boot_error = 0;
 	int timeout;
+	int cpu0_nmi_registered = 0;
 
 	/* Just in case we booted with a single CPU. */
 	alternatives_enable_smp();
@@ -711,13 +786,16 @@ static int __cpuinit do_boot_cpu(int apicid, int cpu, struct task_struct *idle)
 	}
 
 	/*
-	 * Kick the secondary CPU. Use the method in the APIC driver
-	 * if it's defined - or use an INIT boot APIC message otherwise:
+	 * Wake up a CPU in difference cases:
+	 * - Use the method in the APIC driver if it's defined
+	 * Otherwise,
+	 * - Use an INIT boot APIC message for APs or NMI for BSP.
 	 */
 	if (apic->wakeup_secondary_cpu)
 		boot_error = apic->wakeup_secondary_cpu(apicid, start_ip);
 	else
-		boot_error = wakeup_secondary_cpu_via_init(apicid, start_ip);
+		boot_error = wakeup_cpu_via_init_nmi(cpu, start_ip, apicid,
+						     &cpu0_nmi_registered);
 
 	if (!boot_error) {
 		/*
@@ -782,6 +860,13 @@ static int __cpuinit do_boot_cpu(int apicid, int cpu, struct task_struct *idle)
 		 */
 		smpboot_restore_warm_reset_vector();
 	}
+	/*
+	 * Clean up the nmi handler. Do this after the callin and callout sync
+	 * to avoid impact of possible long unregister time.
+	 */
+	if (cpu0_nmi_registered)
+		unregister_nmi_handler(NMI_LOCAL, "wake_cpu0");
+
 	return boot_error;
 }
 
@@ -795,7 +880,7 @@ int __cpuinit native_cpu_up(unsigned int cpu, struct task_struct *tidle)
 
 	pr_debug("++++++++++++++++++++=_---CPU UP  %u\n", cpu);
 
-	if (apicid == BAD_APICID || apicid == boot_cpu_physical_apicid ||
+	if (apicid == BAD_APICID ||
 	    !physid_isset(apicid, phys_cpu_present_map) ||
 	    !apic->apic_id_valid(apicid)) {
 		pr_err("%s: bad cpu %d\n", __func__, cpu);
@@ -990,7 +1075,7 @@ void __init native_smp_prepare_cpus(unsigned int max_cpus)
 	/*
 	 * Setup boot CPU information
 	 */
-	smp_store_cpu_info(0); /* Final full version of the data */
+	smp_store_boot_cpu_info(); /* Final full version of the data */
 	cpumask_copy(cpu_callin_mask, cpumask_of(0));
 	mb();
 
@@ -1026,6 +1111,11 @@ void __init native_smp_prepare_cpus(unsigned int max_cpus)
 	 */
 	setup_local_APIC();
 
+	if (x2apic_mode)
+		cpu0_logical_apicid = apic_read(APIC_LDR);
+	else
+		cpu0_logical_apicid = GET_APIC_LOGICAL_ID(apic_read(APIC_LDR));
+
 	/*
 	 * Enable IO APIC before setting up error vector
 	 */
@@ -1214,19 +1304,6 @@ void cpu_disable_common(void)
 
 int native_cpu_disable(void)
 {
-	int cpu = smp_processor_id();
-
-	/*
-	 * Perhaps use cpufreq to drop frequency, but that could go
-	 * into generic code.
-	 *
-	 * We won't take down the boot processor on i386 due to some
-	 * interrupts only being able to be serviced by the BSP.
-	 * Especially so if we're not using an IOAPIC	-zwane
-	 */
-	if (cpu == 0)
-		return -EBUSY;
-
 	clear_local_APIC();
 
 	cpu_disable_common();
@@ -1266,6 +1343,14 @@ void play_dead_common(void)
 	local_irq_disable();
 }
 
+static bool wakeup_cpu0(void)
+{
+	if (smp_processor_id() == 0 && enable_start_cpu0)
+		return true;
+
+	return false;
+}
+
 /*
  * We need to flush the caches before going to sleep, lest we have
  * dirty data in our caches when we come back up.
@@ -1329,6 +1414,11 @@ static inline void mwait_play_dead(void)
 		__monitor(mwait_ptr, 0, 0);
 		mb();
 		__mwait(eax, 0);
+		/*
+		 * If NMI wants to wake up CPU0, start CPU0.
+		 */
+		if (wakeup_cpu0())
+			start_cpu0();
 	}
 }
 
@@ -1339,6 +1429,11 @@ static inline void hlt_play_dead(void)
 
 	while (1) {
 		native_halt();
+		/*
+		 * If NMI wants to wake up CPU0, start CPU0.
+		 */
+		if (wakeup_cpu0())
+			start_cpu0();
 	}
 }
 
diff --git a/arch/x86/kernel/topology.c b/arch/x86/kernel/topology.c
index 76ee977..6e60b5f 100644
--- a/arch/x86/kernel/topology.c
+++ b/arch/x86/kernel/topology.c
@@ -30,23 +30,110 @@
 #include <linux/mmzone.h>
 #include <linux/init.h>
 #include <linux/smp.h>
+#include <linux/irq.h>
 #include <asm/cpu.h>
 
 static DEFINE_PER_CPU(struct x86_cpu, cpu_devices);
 
 #ifdef CONFIG_HOTPLUG_CPU
+
+#ifdef CONFIG_BOOTPARAM_HOTPLUG_CPU0
+static int cpu0_hotpluggable = 1;
+#else
+static int cpu0_hotpluggable;
+static int __init enable_cpu0_hotplug(char *str)
+{
+	cpu0_hotpluggable = 1;
+	return 1;
+}
+
+__setup("cpu0_hotplug", enable_cpu0_hotplug);
+#endif
+
+#ifdef CONFIG_DEBUG_HOTPLUG_CPU0
+/*
+ * This function offlines a CPU as early as possible and allows userspace to
+ * boot up without the CPU. The CPU can be onlined back by user after boot.
+ *
+ * This is only called for debugging CPU offline/online feature.
+ */
+int __ref _debug_hotplug_cpu(int cpu, int action)
+{
+	struct device *dev = get_cpu_device(cpu);
+	int ret;
+
+	if (!cpu_is_hotpluggable(cpu))
+		return -EINVAL;
+
+	cpu_hotplug_driver_lock();
+
+	switch (action) {
+	case 0:
+		ret = cpu_down(cpu);
+		if (!ret) {
+			pr_info("CPU %u is now offline\n", cpu);
+			kobject_uevent(&dev->kobj, KOBJ_OFFLINE);
+		} else
+			pr_debug("Can't offline CPU%d.\n", cpu);
+		break;
+	case 1:
+		ret = cpu_up(cpu);
+		if (!ret)
+			kobject_uevent(&dev->kobj, KOBJ_ONLINE);
+		else
+			pr_debug("Can't online CPU%d.\n", cpu);
+		break;
+	default:
+		ret = -EINVAL;
+	}
+
+	cpu_hotplug_driver_unlock();
+
+	return ret;
+}
+
+static int __init debug_hotplug_cpu(void)
+{
+	_debug_hotplug_cpu(0, 0);
+	return 0;
+}
+
+late_initcall_sync(debug_hotplug_cpu);
+#endif /* CONFIG_DEBUG_HOTPLUG_CPU0 */
+
 int __ref arch_register_cpu(int num)
 {
+	struct cpuinfo_x86 *c = &cpu_data(num);
+
+	/*
+	 * Currently CPU0 is only hotpluggable on Intel platforms. Other
+	 * vendors can add hotplug support later.
+	 */
+	if (c->x86_vendor != X86_VENDOR_INTEL)
+		cpu0_hotpluggable = 0;
+
 	/*
-	 * CPU0 cannot be offlined due to several
-	 * restrictions and assumptions in kernel. This basically
-	 * doesn't add a control file, one cannot attempt to offline
-	 * BSP.
+	 * Two known BSP/CPU0 dependencies: Resume from suspend/hibernate
+	 * depends on BSP. PIC interrupts depend on BSP.
 	 *
-	 * Also certain PCI quirks require not to enable hotplug control
-	 * for all CPU's.
+	 * If the BSP depencies are under control, one can tell kernel to
+	 * enable BSP hotplug. This basically adds a control file and
+	 * one can attempt to offline BSP.
 	 */
-	if (num)
+	if (num == 0 && cpu0_hotpluggable) {
+		unsigned int irq;
+		/*
+		 * We won't take down the boot processor on i386 if some
+		 * interrupts only are able to be serviced by the BSP in PIC.
+		 */
+		for_each_active_irq(irq) {
+			if (!IO_APIC_IRQ(irq) && irq_has_action(irq)) {
+				cpu0_hotpluggable = 0;
+				break;
+			}
+		}
+	}
+	if (num || cpu0_hotpluggable)
 		per_cpu(cpu_devices, num).cpu.hotpluggable = 1;
 
 	return register_cpu(&per_cpu(cpu_devices, num).cpu, num);
diff --git a/arch/x86/power/cpu.c b/arch/x86/power/cpu.c
index 218cdb1..120cee1 100644
--- a/arch/x86/power/cpu.c
+++ b/arch/x86/power/cpu.c
@@ -21,6 +21,7 @@
 #include <asm/suspend.h>
 #include <asm/debugreg.h>
 #include <asm/fpu-internal.h> /* pcntxt_mask */
+#include <asm/cpu.h>
 
 #ifdef CONFIG_X86_32
 static struct saved_context saved_context;
@@ -237,3 +238,84 @@ void restore_processor_state(void)
 #ifdef CONFIG_X86_32
 EXPORT_SYMBOL(restore_processor_state);
 #endif
+
+/*
+ * When bsp_check() is called in hibernate and suspend, cpu hotplug
+ * is disabled already. So it's unnessary to handle race condition between
+ * cpumask query and cpu hotplug.
+ */
+static int bsp_check(void)
+{
+	if (cpumask_first(cpu_online_mask) != 0) {
+		pr_warn("CPU0 is offline.\n");
+		return -ENODEV;
+	}
+
+	return 0;
+}
+
+static int bsp_pm_callback(struct notifier_block *nb, unsigned long action,
+			   void *ptr)
+{
+	int ret = 0;
+
+	switch (action) {
+	case PM_SUSPEND_PREPARE:
+	case PM_HIBERNATION_PREPARE:
+		ret = bsp_check();
+		break;
+#ifdef CONFIG_DEBUG_HOTPLUG_CPU0
+	case PM_RESTORE_PREPARE:
+		/*
+		 * When system resumes from hibernation, online CPU0 because
+		 * 1. it's required for resume and
+		 * 2. the CPU was online before hibernation
+		 */
+		if (!cpu_online(0))
+			_debug_hotplug_cpu(0, 1);
+		break;
+	case PM_POST_RESTORE:
+		/*
+		 * When a resume really happens, this code won't be called.
+		 *
+		 * This code is called only when user space hibernation software
+		 * prepares for snapshot device during boot time. So we just
+		 * call _debug_hotplug_cpu() to restore to CPU0's state prior to
+		 * preparing the snapshot device.
+		 *
+		 * This works for normal boot case in our CPU0 hotplug debug
+		 * mode, i.e. CPU0 is offline and user mode hibernation
+		 * software initializes during boot time.
+		 *
+		 * If CPU0 is online and user application accesses snapshot
+		 * device after boot time, this will offline CPU0 and user may
+		 * see different CPU0 state before and after accessing
+		 * the snapshot device. But hopefully this is not a case when
+		 * user debugging CPU0 hotplug. Even if users hit this case,
+		 * they can easily online CPU0 back.
+		 *
+		 * To simplify this debug code, we only consider normal boot
+		 * case. Otherwise we need to remember CPU0's state and restore
+		 * to that state and resolve racy conditions etc.
+		 */
+		_debug_hotplug_cpu(0, 0);
+		break;
+#endif
+	default:
+		break;
+	}
+	return notifier_from_errno(ret);
+}
+
+static int __init bsp_pm_check_init(void)
+{
+	/*
+	 * Set this bsp_pm_callback as lower priority than
+	 * cpu_hotplug_pm_callback. So cpu_hotplug_pm_callback will be called
+	 * earlier to disable cpu hotplug before bsp online check.
+	 */
+	pm_notifier(bsp_pm_callback, -INT_MAX);
+	return 0;
+}
+
+core_initcall(bsp_pm_check_init);
diff --git a/kernel/cpu.c b/kernel/cpu.c
index 42bd331..a2491a2 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -601,6 +601,11 @@ cpu_hotplug_pm_callback(struct notifier_block *nb,
 
 static int __init cpu_hotplug_pm_sync_init(void)
 {
+	/*
+	 * cpu_hotplug_pm_callback has higher priority than x86
+	 * bsp_pm_callback which depends on cpu_hotplug_pm_callback
+	 * to disable cpu hotplug to avoid cpu hotplug race.
+	 */
 	pm_notifier(cpu_hotplug_pm_callback, 0);
 	return 0;
 }
