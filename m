Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758168Ab2EJQaz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 12:30:55 -0400
Received: from mga09.intel.com ([134.134.136.24]:5033 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753053Ab2EJQ2Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 12:28:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="142389154"
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
        "Chen Gong" <gong.chen@linux.intel.com>,
        "linux-kernel" <linux-kernel@vger.kernel.org>,
        "linux-pm" <linux-pm@vger.kernel.org>, "x86" <x86@kernel.org>
Cc: "Fenghua Yu" <fenghua.yu@intel.com>
Subject: [PATCH v6 08/12] x86/smpboot.c: Wake up CPU0 via NMI instead of INITs
Date: Thu, 10 May 2012 09:16:50 -0700
Message-Id: <1336666614-21090-9-git-send-email-fenghua.yu@intel.com>
X-Mailer: git-send-email 1.7.2
In-Reply-To: <1336666614-21090-1-git-send-email-fenghua.yu@intel.com>
References: <1336666614-21090-1-git-send-email-fenghua.yu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fenghua Yu <fenghua.yu@intel.com>

Instead of waiting for STARTUP after INITs, BSP will execute
the BIOS boot-strap code which is not a desired behavior for
waking up BSP. To avoid the boot-strap code, wake up CPU0 by
NMI instead.

This works to wake up soft offlined CPU0 only. If CPU0 is hard offlined (i.e.
physically hot removed and then hot added), NMI won't wake it up. We'll change
this code in the future to wake up hard offlined CPU0 if real platform and
request are available.

AP is still waken up as before by INIT, INIT, STARTUP sequence.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
---
 arch/x86/include/asm/cpu.h |    1 +
 arch/x86/kernel/smpboot.c  |  112 +++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 107 insertions(+), 6 deletions(-)

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
index fa3822e..fba37ad 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -134,15 +134,17 @@ static void __cpuinit smp_callin(void)
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
@@ -231,6 +233,8 @@ static void __cpuinit smp_callin(void)
 	cpumask_set_cpu(cpuid, cpu_callin_mask);
 }
 
+static int cpu0_logical_apicid;
+static int enable_start_cpu0;
 /*
  * Activate a secondary processor.
  */
@@ -246,6 +250,8 @@ notrace static void __cpuinit start_secondary(void *unused)
 	preempt_disable();
 	smp_callin();
 
+	enable_start_cpu0 = 0;
+
 #ifdef CONFIG_X86_32
 	/* switch away from the initial page table */
 	load_cr3(swapper_pg_dir);
@@ -472,7 +478,7 @@ void __inquire_remote_apic(int apicid)
  * won't ... remember to clear down the APIC, etc later.
  */
 int __cpuinit
-wakeup_secondary_cpu_via_nmi(int logical_apicid, unsigned long start_eip)
+wakeup_secondary_cpu_via_nmi(int apicid, unsigned long start_eip)
 {
 	unsigned long send_status, accept_status = 0;
 	int maxlvt;
@@ -480,7 +486,7 @@ wakeup_secondary_cpu_via_nmi(int logical_apicid, unsigned long start_eip)
 	/* Target chip */
 	/* Boot on the stack */
 	/* Kick the second */
-	apic_icr_write(APIC_DM_NMI | apic->dest_logical, logical_apicid);
+	apic_icr_write(APIC_DM_NMI | apic->dest_logical, apicid);
 
 	pr_debug("Waiting for send to finish...\n");
 	send_status = safe_apic_wait_icr_idle();
@@ -640,6 +646,17 @@ static void __cpuinit announce_cpu(int cpu, int apicid)
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
 /*
  * NOTE - on most systems this is a PHYSICAL apic ID, but on multiquad
  * (ie clustered apic addressing mode), this is a LOGICAL apic ID.
@@ -651,6 +668,7 @@ static int __cpuinit do_boot_cpu(int apicid, int cpu, struct task_struct *idle)
 	unsigned long boot_error = 0;
 	unsigned long start_ip;
 	int timeout;
+	int cpu0_nmi_registered = 0;
 
 	alternatives_smp_switch(1);
 
@@ -705,8 +723,47 @@ static int __cpuinit do_boot_cpu(int apicid, int cpu, struct task_struct *idle)
 	 */
 	if (apic->wakeup_secondary_cpu)
 		boot_error = apic->wakeup_secondary_cpu(apicid, start_ip);
-	else
-		boot_error = wakeup_secondary_cpu_via_init(apicid, start_ip);
+	else {
+		if (cpu)
+			/*
+			 * Wake up AP by INIT, INIT, STARTUP sequence.
+			 */
+			boot_error = wakeup_secondary_cpu_via_init(apicid,
+								   start_ip);
+		else {
+			/*
+			 * Instead of waiting for STARTUP after INITs, BSP will
+			 * execute the BIOS boot-strap code which is not a
+			 * desired behavior for waking up BSP. To avoid the
+			 * boot-strap code, wake up CPU0 by NMI instead.
+			 *
+			 * This works to wake up soft offlined CPU0 only. If
+			 * CPU0 is hard offlined (i.e. physically hot removed
+			 * and then hot added), NMI won't wake it up. We'll
+			 * change this code in the future to wake up hard
+			 * offlined CPU0 if real platform and request are
+			 * available.
+			 */
+			int id;
+
+			enable_start_cpu0 = 1;
+			/*
+			 * Register a NMI handler to help wake up CPU0.
+			 */
+			boot_error = register_nmi_handler(NMI_LOCAL,
+					 wakeup_cpu0_nmi, 0, "wake_cpu0");
+
+			if (!boot_error) {
+				cpu0_nmi_registered = 1;
+				if (apic->dest_logical == APIC_DEST_LOGICAL)
+					id = cpu0_logical_apicid;
+				else
+					id = apicid;
+				boot_error = wakeup_secondary_cpu_via_nmi(id,
+								start_ip);
+			}
+		}
+	}
 
 	if (!boot_error) {
 		/*
@@ -772,6 +829,13 @@ static int __cpuinit do_boot_cpu(int apicid, int cpu, struct task_struct *idle)
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
 
@@ -1021,6 +1085,8 @@ void __init native_smp_prepare_cpus(unsigned int max_cpus)
 	 */
 	setup_local_APIC();
 
+	cpu0_logical_apicid = GET_APIC_LOGICAL_ID(apic_read(APIC_LDR));
+
 	/*
 	 * Enable IO APIC before setting up error vector
 	 */
@@ -1301,6 +1367,30 @@ void play_dead_common(void)
 	local_irq_disable();
 }
 
+static bool wakeup_cpu0(void)
+{
+	unsigned int timeout;
+
+	if (smp_processor_id())
+		return false;
+
+	/*
+	 * Wait up to 3 seconds to check if CPU0 wakeup NMI is handled.
+	 * If there is no CPU0 wakeup NMI, go back to sleep.
+	 */
+	for (timeout = 0; timeout < 30000; timeout++) {
+		/*
+		 * Check if CPU0 wakeup NMI is issued and handled.
+		 */
+		if (enable_start_cpu0)
+			return true;
+
+		udelay(100);
+	}
+
+	return false;
+}
+
 /*
  * We need to flush the caches before going to sleep, lest we have
  * dirty data in our caches when we come back up.
@@ -1364,6 +1454,11 @@ static inline void mwait_play_dead(void)
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
 
@@ -1374,6 +1469,11 @@ static inline void hlt_play_dead(void)
 
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
1.6.0.3

