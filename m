Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756959Ab2FDSbZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 14:31:25 -0400
Received: from mga11.intel.com ([192.55.52.93]:2189 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755844Ab2FDS34 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 14:29:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="160493142"
From: "Fenghua Yu" <fenghua.yu@intel.com>
To: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
        "H Peter Anvin" <hpa@zytor.com>,
        "Suresh B Siddha" <suresh.b.siddha@intel.com>,
        "Tony Luck" <tony.luck@intel.com>,
        "Asit K Mallick" <asit.k.mallick@intel.com>,
        "Arjan Dan De Ven" <arjan@linux.intel.com>
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>, "x86" <x86@kernel.org>,
        "linux-pm" <linux-pm@vger.kernel.org>,
        "Fenghua Yu" <fenghua.yu@intel.com>
Subject: [PATCH 3/6] x86/smpboot.c: Wake up offline CPU via mwait or nmi
Date: Mon,  4 Jun 2012 11:17:52 -0700
Message-Id: <1338833876-29721-4-git-send-email-fenghua.yu@intel.com>
X-Mailer: git-send-email 1.7.2
In-Reply-To: <1338833876-29721-1-git-send-email-fenghua.yu@intel.com>
References: <1338833876-29721-1-git-send-email-fenghua.yu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fenghua Yu <fenghua.yu@intel.com>

wakeup_secondary_cpu_via_soft() is defined to wake up offline CPU via mwait if
the CPU is in mwait or via nmi if the CPU is in hlt.

A CPU boots up by INIT, INIT, STARTUP sequence when it boots up for the first
time during boot time or hot plug.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
---
 arch/x86/include/asm/apic.h |    5 +-
 arch/x86/kernel/smpboot.c   |  187 ++++++++++++++++++++++++++++++++++++------
 2 files changed, 164 insertions(+), 28 deletions(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index eaff479..cad00b1 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -425,7 +425,10 @@ extern struct apic *__apicdrivers[], *__apicdrivers_end[];
 #ifdef CONFIG_SMP
 extern atomic_t init_deasserted;
 extern int wakeup_secondary_cpu_via_nmi(int apicid, unsigned long start_eip);
-#endif
+extern int wakeup_secondary_cpu_via_soft(int apicid, unsigned long start_eip);
+#else /* CONFIG_SMP */
+#define wakeup_secondary_cpu_via_soft	NULL
+#endif /* CONFIG_SMP */
 
 #ifdef CONFIG_X86_LOCAL_APIC
 
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index fd019d7..109df30 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -472,13 +472,8 @@ void __inquire_remote_apic(int apicid)
 	}
 }
 
-/*
- * Poke the other CPU in the eye via NMI to wake it up. Remember that the normal
- * INIT, INIT, STARTUP sequence will reset the chip hard for us, and this
- * won't ... remember to clear down the APIC, etc later.
- */
-int __cpuinit
-wakeup_secondary_cpu_via_nmi(int logical_apicid, unsigned long start_eip)
+static int __cpuinit
+_wakeup_secondary_cpu_via_nmi(int apicid, int dest_mode)
 {
 	unsigned long send_status, accept_status = 0;
 	int maxlvt;
@@ -486,7 +481,7 @@ wakeup_secondary_cpu_via_nmi(int logical_apicid, unsigned long start_eip)
 	/* Target chip */
 	/* Boot on the stack */
 	/* Kick the second */
-	apic_icr_write(APIC_DM_NMI | apic->dest_logical, logical_apicid);
+	apic_icr_write(APIC_DM_NMI | dest_mode, apicid);
 
 	pr_debug("Waiting for send to finish...\n");
 	send_status = safe_apic_wait_icr_idle();
@@ -511,6 +506,47 @@ wakeup_secondary_cpu_via_nmi(int logical_apicid, unsigned long start_eip)
 	return (send_status | accept_status);
 }
 
+/*
+ * Poke the other CPU in the eye via NMI to wake it up. Remember that the normal
+ * INIT, INIT, STARTUP sequence will reset the chip hard for us, and this
+ * won't ... remember to clear down the APIC, etc later.
+ */
+int __cpuinit
+wakeup_secondary_cpu_via_nmi_phys(int phys_apicid, unsigned long start_eip)
+{
+	return _wakeup_secondary_cpu_via_nmi(phys_apicid, APIC_DEST_PHYSICAL);
+}
+
+int __cpuinit
+wakeup_secondary_cpu_via_nmi(int logical_apicid, unsigned long start_eip)
+{
+	return _wakeup_secondary_cpu_via_nmi(logical_apicid, APIC_DEST_LOGICAL);
+}
+
+DEFINE_PER_CPU(int, cpu_dead) = { 0 };
+#define CPU_DEAD_TRIGGER	1
+#define CPU_DEAD_MWAIT		2
+#define CPU_DEAD_HLT		4
+
+static int wakeup_secondary_cpu_via_mwait(int cpu)
+{
+	per_cpu(cpu_dead, cpu) |= CPU_DEAD_TRIGGER;
+	return 0;
+}
+
+static int wakeup_cpu_nmi(unsigned int cmd, struct pt_regs *regs)
+{
+	int cpu = smp_processor_id();
+	int *cpu_dead_ptr;
+
+	cpu_dead_ptr = &per_cpu(cpu_dead, cpu);
+	if (!cpu_online(cpu) && (*cpu_dead_ptr & CPU_DEAD_HLT) &&
+	    (*cpu_dead_ptr & CPU_DEAD_TRIGGER))
+		return NMI_HANDLED;
+
+	return NMI_DONE;
+}
+
 static int __cpuinit
 wakeup_secondary_cpu_via_init(int phys_apicid, unsigned long start_eip)
 {
@@ -626,6 +662,52 @@ wakeup_secondary_cpu_via_init(int phys_apicid, unsigned long start_eip)
 	return (send_status | accept_status);
 }
 
+/*
+ * Kick a cpu.
+ *
+ * If the CPU is in mwait, wake it up by mwait method. Otherwise, if the CPU is
+ * in halt, wake it up by NMI. If none of above exists, wake it up by INIT boot
+ * APIC message.
+ *
+ * When the CPU first time boots up, i.e. cpu_dead is 0, it's waken up by INIT
+ * boot APIC message.
+ *
+ * At this point, the CPU should be in a fixed dead state. So we don't consider
+ * racy condition here.
+ */
+int __cpuinit
+wakeup_secondary_cpu_via_soft(int apicid, unsigned long start_eip)
+{
+	int cpu;
+	int boot_error = 0;
+	/* start_ip had better be page-aligned! */
+	unsigned long start_ip = real_mode_header->trampoline_start;
+
+	for (cpu = 0; cpu < nr_cpu_ids; cpu++)
+		if (apicid == apic->cpu_present_to_apicid(cpu))
+			break;
+
+	if (cpu >= nr_cpu_ids)
+		return -EINVAL;
+
+	if (per_cpu(cpu_dead, cpu) & CPU_DEAD_MWAIT) {
+		boot_error = wakeup_secondary_cpu_via_mwait(cpu);
+	} else if (per_cpu(cpu_dead, cpu) & CPU_DEAD_HLT) {
+		int *cpu_dead_ptr;
+
+		cpu_dead_ptr = &per_cpu(cpu_dead, cpu);
+		*cpu_dead_ptr |= CPU_DEAD_TRIGGER;
+
+		boot_error = wakeup_secondary_cpu_via_nmi_phys(apicid,
+								start_ip);
+		if (boot_error)
+			*cpu_dead_ptr &= ~CPU_DEAD_TRIGGER;
+	} else
+		boot_error = wakeup_secondary_cpu_via_init(apicid, start_ip);
+
+	return boot_error;
+}
+
 /* reduce the number of lines printed when booting a large cpu count system */
 static void __cpuinit announce_cpu(int cpu, int apicid)
 {
@@ -778,6 +860,7 @@ static int __cpuinit do_boot_cpu(int apicid, int cpu, struct task_struct *idle)
 		 */
 		smpboot_restore_warm_reset_vector();
 	}
+
 	return boot_error;
 }
 
@@ -977,6 +1060,20 @@ static void __init smp_cpu_index_default(void)
 	}
 }
 
+static bool mwait_supported(void)
+{
+	struct cpuinfo_x86 *c = __this_cpu_ptr(&cpu_info);
+
+	if (!(this_cpu_has(X86_FEATURE_MWAIT) && mwait_usable(c)))
+		return false;
+	if (!this_cpu_has(X86_FEATURE_CLFLSH))
+		return false;
+	if (__this_cpu_read(cpu_info.cpuid_level) < CPUID_MWAIT_LEAF)
+		return false;
+
+	return true;
+}
+
 /*
  * Prepare for SMP bootup.  The MP table or ACPI has been read
  * earlier.  Just do some sanity checking here and enable APIC mode.
@@ -1051,6 +1148,11 @@ void __init native_smp_prepare_cpus(unsigned int max_cpus)
 		uv_system_init();
 
 	set_mtrr_aps_delayed_init();
+
+#ifdef CONFIG_HOTPLUG_CPU
+	if (!mwait_supported())
+		register_nmi_handler(NMI_LOCAL, wakeup_cpu_nmi, 0, "wake_cpu");
+#endif
 out:
 	preempt_enable();
 }
@@ -1111,6 +1213,12 @@ static int __init _setup_possible_cpus(char *str)
 }
 early_param("possible_cpus", _setup_possible_cpus);
 
+static int __init setup_wakeup_cpu_via_init(char *str)
+{
+	apic->wakeup_secondary_cpu = NULL;
+	return 0;
+}
+__setup("wakeup_cpu_via_init", setup_wakeup_cpu_via_init);
 
 /*
  * cpu_possible_mask should be static, it cannot change as cpu's
@@ -1286,6 +1394,28 @@ void play_dead_common(void)
 	local_irq_disable();
 }
 
+static bool wakeup_cpu(int *trigger)
+{
+	unsigned int timeout;
+
+	/*
+	 * Wait up to 1 seconds to check if CPU wakeup trigger is set in
+	 * cpu_dead by either memory write or NMI.
+	 * If there is no CPU wakeup trigger, go back to sleep.
+	 */
+	for (timeout = 0; timeout < 1000000; timeout++) {
+		/*
+		 * Check if CPU0 wakeup NMI is issued and handled.
+		 */
+		if (*trigger & CPU_DEAD_TRIGGER)
+			return true;
+
+		udelay(1);
+	}
+
+	return false;
+}
+
 /*
  * We need to flush the caches before going to sleep, lest we have
  * dirty data in our caches when we come back up.
@@ -1296,14 +1426,9 @@ static inline void mwait_play_dead(void)
 	unsigned int highest_cstate = 0;
 	unsigned int highest_subcstate = 0;
 	int i;
-	void *mwait_ptr;
-	struct cpuinfo_x86 *c = __this_cpu_ptr(&cpu_info);
+	int *cpu_dead_ptr;
 
-	if (!(this_cpu_has(X86_FEATURE_MWAIT) && mwait_usable(c)))
-		return;
-	if (!this_cpu_has(X86_FEATURE_CLFLSH))
-		return;
-	if (__this_cpu_read(cpu_info.cpuid_level) < CPUID_MWAIT_LEAF)
+	if (!mwait_supported())
 		return;
 
 	eax = CPUID_MWAIT_LEAF;
@@ -1328,16 +1453,10 @@ static inline void mwait_play_dead(void)
 			(highest_subcstate - 1);
 	}
 
-	/*
-	 * This should be a memory location in a cache line which is
-	 * unlikely to be touched by other processors.  The actual
-	 * content is immaterial as it is not actually modified in any way.
-	 */
-	mwait_ptr = &current_thread_info()->flags;
-
-	wbinvd();
-
+	cpu_dead_ptr = &per_cpu(cpu_dead, smp_processor_id());
+	*cpu_dead_ptr = CPU_DEAD_MWAIT;
 	while (1) {
+		*cpu_dead_ptr &= ~CPU_DEAD_TRIGGER;
 		/*
 		 * The CLFLUSH is a workaround for erratum AAI65 for
 		 * the Xeon 7400 series.  It's not clear it is actually
@@ -1345,20 +1464,34 @@ static inline void mwait_play_dead(void)
 		 * The WBINVD is insufficient due to the spurious-wakeup
 		 * case where we return around the loop.
 		 */
-		clflush(mwait_ptr);
-		__monitor(mwait_ptr, 0, 0);
+		wbinvd();
+		clflush(cpu_dead_ptr);
+		__monitor(cpu_dead_ptr, 0, 0);
 		mb();
-		__mwait(eax, 0);
+		if ((*cpu_dead_ptr & CPU_DEAD_TRIGGER) == 0)
+			__mwait(eax, 0);
+
+		/* Waken up by another CPU. */
+		if (wakeup_cpu(cpu_dead_ptr))
+			start_cpu();
 	}
 }
 
 static inline void hlt_play_dead(void)
 {
+	int *cpu_dead_ptr;
+
 	if (__this_cpu_read(cpu_info.x86) >= 4)
 		wbinvd();
 
+	cpu_dead_ptr = &per_cpu(cpu_dead, smp_processor_id());
+	*cpu_dead_ptr = CPU_DEAD_HLT;
 	while (1) {
+		*cpu_dead_ptr &= ~CPU_DEAD_TRIGGER;
 		native_halt();
+		/* If NMI wants to wake up me, I'll start. */
+		if (wakeup_cpu(cpu_dead_ptr))
+			start_cpu();
 	}
 }
 
-- 
1.6.0.3

