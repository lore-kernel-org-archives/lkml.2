Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753827Ab2H0RN4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 13:13:56 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34479 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753482Ab2H0RNy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 13:13:54 -0400
Date: Mon, 27 Aug 2012 10:13:42 -0700
From: tip-bot for Fenghua Yu <fenghua.yu@intel.com>
Message-ID: <tip-ef664ed66136b2aec73d0d37d3198f557818c718@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        fenghua.yu@intel.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        fenghua.yu@intel.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1345916488-8355-9-git-send-email-fenghua.yu@intel.com>
References: <1345916488-8355-9-git-send-email-fenghua.yu@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/bsp-hotplug] x86, hotplug:
  Wake up CPU0 via NMI instead of INIT, SIPI, SIPI
Git-Commit-ID: ef664ed66136b2aec73d0d37d3198f557818c718
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 27 Aug 2012 10:13:48 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ef664ed66136b2aec73d0d37d3198f557818c718
Gitweb:     http://git.kernel.org/tip/ef664ed66136b2aec73d0d37d3198f557818c718
Author:     Fenghua Yu <fenghua.yu@intel.com>
AuthorDate: Sat, 25 Aug 2012 10:41:24 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Sat, 25 Aug 2012 19:26:33 -0700

x86, hotplug: Wake up CPU0 via NMI instead of INIT, SIPI, SIPI

Instead of waiting for STARTUP after INITs, BSP will execute the BIOS boot-strap
code which is not a desired behavior for waking up BSP. To avoid the boot-strap
code, wake up CPU0 by NMI instead.

This works to wake up soft offlined CPU0 only. If CPU0 is hard offlined (i.e.
physically hot removed and then hot added), NMI won't wake it up. We'll change
this code in the future to wake up hard offlined CPU0 if real platform and
request are available.

AP is still waken up as before by INIT, SIPI, SIPI sequence.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
Link: http://lkml.kernel.org/r/1345916488-8355-9-git-send-email-fenghua.yu@intel.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
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
index 58439fe..ee59026 100644
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
@@ -660,6 +666,17 @@ static void __cpuinit announce_cpu(int cpu, int apicid)
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
@@ -675,6 +692,7 @@ static int __cpuinit do_boot_cpu(int apicid, int cpu, struct task_struct *idle)
 
 	unsigned long boot_error = 0;
 	int timeout;
+	int cpu0_nmi_registered = 0;
 
 	alternatives_smp_switch(1);
 
@@ -726,8 +744,47 @@ static int __cpuinit do_boot_cpu(int apicid, int cpu, struct task_struct *idle)
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
@@ -792,6 +849,13 @@ static int __cpuinit do_boot_cpu(int apicid, int cpu, struct task_struct *idle)
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
 
@@ -1036,6 +1100,8 @@ void __init native_smp_prepare_cpus(unsigned int max_cpus)
 	 */
 	setup_local_APIC();
 
+	cpu0_logical_apicid = GET_APIC_LOGICAL_ID(apic_read(APIC_LDR));
+
 	/*
 	 * Enable IO APIC before setting up error vector
 	 */
@@ -1280,6 +1346,30 @@ void play_dead_common(void)
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
@@ -1343,6 +1433,11 @@ static inline void mwait_play_dead(void)
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
 
@@ -1353,6 +1448,11 @@ static inline void hlt_play_dead(void)
 
 	while (1) {
 		native_halt();
+		/*
+		 * If NMI wants to wake up CPU0, start CPU0.
+		 */
+		if (wakeup_cpu0())
+			start_cpu0();
 	}
 }
 
