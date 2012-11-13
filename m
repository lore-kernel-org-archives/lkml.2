Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932630Ab2KNCgy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 21:36:54 -0500
Received: from mga14.intel.com ([143.182.124.37]:53055 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932532Ab2KNCdp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 21:33:45 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,247,1352102400"; 
   d="scan'208";a="217413946"
From: "Fenghua Yu" <fenghua.yu@intel.com>
To: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
        "H Peter Anvin" <hpa@zytor.com>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "Asit K Mallick" <asit.k.mallick@intel.com>,
        "Tony Luck" <tony.luck@intel.com>,
        "Arjan Dan De Ven" <arjan@linux.intel.com>,
        "Suresh B Siddha" <suresh.b.siddha@intel.com>,
        "Len Brown" <len.brown@intel.com>,
        "Srivatssa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        "Randy Dunlap" <rdunlap@xenotime.net>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        "Chen Gong" <gong.chen@linux.intel.com>,
        "linux-kernel" <linux-kernel@vger.kernel.org>,
        "linux-pm" <linux-pm@vger.kernel.org>, "x86" <x86@kernel.org>
Cc: "Fenghua Yu" <fenghua.yu@intel.com>
Subject: [PATCH v10 09/14] x86, hotplug: Wake up CPU0 via NMI instead of INIT, SIPI, SIPI
Date: Tue, 13 Nov 2012 11:32:46 -0800
Message-Id: <1352835171-3958-10-git-send-email-fenghua.yu@intel.com>
X-Mailer: git-send-email 1.7.2
In-Reply-To: <1352835171-3958-1-git-send-email-fenghua.yu@intel.com>
References: <1352835171-3958-1-git-send-email-fenghua.yu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fenghua Yu <fenghua.yu@intel.com>

Instead of waiting for STARTUP after INITs, BSP will execute the BIOS boot-strap
code which is not a desired behavior for waking up BSP. To avoid the boot-strap
code, wake up CPU0 by NMI instead.

This works to wake up soft offlined CPU0 only. If CPU0 is hard offlined (i.e.
physically hot removed and then hot added), NMI won't wake it up. We'll change
this code in the future to wake up hard offlined CPU0 if real platform and
request are available.

AP is still waken up as before by INIT, SIPI, SIPI sequence.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
---
 arch/x86/include/asm/cpu.h |    1 +
 arch/x86/kernel/smpboot.c  |  113 +++++++++++++++++++++++++++++++++++++++++---
 2 files changed, 107 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/cpu.h b/arch/x86/include/asm/cpu.h
index 4564c8e..a119572 100644
--- a/arch/x86/include/asm/cpu.h
+++ b/arch/x86/include/asm/cpu.h
@@ -28,6 +28,7 @@ struct x86_cpu {
 #ifdef CONFIG_HOTPLUG_CPU
 extern int arch_register_cpu(int num);
 extern void arch_unregister_cpu(int);
+extern void __cpuinit start_cpu0(void);
 #endif
 
 DECLARE_PER_CPU(int, cpu_state);
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index c297907..31854bc 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
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
@@ -492,7 +498,7 @@ void __inquire_remote_apic(int apicid)
  * won't ... remember to clear down the APIC, etc later.
  */
 int __cpuinit
-wakeup_secondary_cpu_via_nmi(int logical_apicid, unsigned long start_eip)
+wakeup_secondary_cpu_via_nmi(int apicid, unsigned long start_eip)
 {
 	unsigned long send_status, accept_status = 0;
 	int maxlvt;
@@ -500,7 +506,7 @@ wakeup_secondary_cpu_via_nmi(int logical_apicid, unsigned long start_eip)
 	/* Target chip */
 	/* Boot on the stack */
 	/* Kick the second */
-	apic_icr_write(APIC_DM_NMI | apic->dest_logical, logical_apicid);
+	apic_icr_write(APIC_DM_NMI | apic->dest_logical, apicid);
 
 	pr_debug("Waiting for send to finish...\n");
 	send_status = safe_apic_wait_icr_idle();
@@ -660,6 +666,63 @@ static void __cpuinit announce_cpu(int cpu, int apicid)
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
@@ -675,6 +738,7 @@ static int __cpuinit do_boot_cpu(int apicid, int cpu, struct task_struct *idle)
 
 	unsigned long boot_error = 0;
 	int timeout;
+	int cpu0_nmi_registered = 0;
 
 	/* Just in case we booted with a single CPU. */
 	alternatives_enable_smp();
@@ -722,13 +786,16 @@ static int __cpuinit do_boot_cpu(int apicid, int cpu, struct task_struct *idle)
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
@@ -793,6 +860,13 @@ static int __cpuinit do_boot_cpu(int apicid, int cpu, struct task_struct *idle)
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
 
@@ -1037,6 +1111,11 @@ void __init native_smp_prepare_cpus(unsigned int max_cpus)
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
@@ -1264,6 +1343,16 @@ void play_dead_common(void)
 	local_irq_disable();
 }
 
+static bool wakeup_cpu0(void)
+{
+	unsigned int timeout;
+
+	if (smp_processor_id() == 0 && enable_start_cpu0)
+		return true;
+
+	return false;
+}
+
 /*
  * We need to flush the caches before going to sleep, lest we have
  * dirty data in our caches when we come back up.
@@ -1327,6 +1416,11 @@ static inline void mwait_play_dead(void)
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
 
@@ -1337,6 +1431,11 @@ static inline void hlt_play_dead(void)
 
 	while (1) {
 		native_halt();
+		/*
+		 * If NMI wants to wake up CPU0, start CPU0.
+		 */
+		if (wakeup_cpu0())
+			start_cpu0();
 	}
 }
 
-- 
1.7.2

