Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756982Ab0GMTMU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 15:12:20 -0400
Received: from ip4-95-82-188-143.cust.nbox.cz ([95.82.188.143]:56991 "EHLO
	localhost.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751042Ab0GMTMS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 15:12:18 -0400
From: Michal Schmidt <mschmidt@redhat.com>
Subject: [PATCH 2/2] x86: remove c1e_mask
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Shaohua Li <shaohua.li@intel.com>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Date: Tue, 13 Jul 2010 21:00:03 +0200
Message-ID: <20100713190003.2866.62404.stgit@localhost.localdomain>
In-Reply-To: <20100713185816.2866.17837.stgit@localhost.localdomain>
References: <20100713185816.2866.17837.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

c1e_mask is redundant. The information about activated timer broadcast for
AMD C1E is kept in the CPU feature flags.

Signed-off-by: Michal Schmidt <mschmidt@redhat.com>
---

 arch/x86/include/asm/cpufeature.h |    2 +-
 arch/x86/include/asm/idle.h       |    2 --
 arch/x86/include/asm/processor.h  |    1 -
 arch/x86/kernel/cpu/common.c      |    1 -
 arch/x86/kernel/process.c         |   25 +++++++++----------------
 arch/x86/kernel/smpboot.c         |    1 -
 6 files changed, 10 insertions(+), 22 deletions(-)

diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index 4681459..d826f48 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -89,7 +89,7 @@
 #define X86_FEATURE_LFENCE_RDTSC (3*32+18) /* "" Lfence synchronizes RDTSC */
 #define X86_FEATURE_11AP	(3*32+19) /* "" Bad local APIC aka 11AP */
 #define X86_FEATURE_NOPL	(3*32+20) /* The NOPL (0F 1F) instructions */
-#define X86_FEATURE_AMDC1E	(3*32+21) /* AMD C1E detected */
+#define X86_FEATURE_AMDC1E	(3*32+21) /* Broken APIC timer in AMD C1E */
 #define X86_FEATURE_XTOPOLOGY	(3*32+22) /* cpu topology enum extensions */
 #define X86_FEATURE_TSC_RELIABLE (3*32+23) /* TSC is known to be reliable */
 #define X86_FEATURE_NONSTOP_TSC	(3*32+24) /* TSC does not stop in C states */
diff --git a/arch/x86/include/asm/idle.h b/arch/x86/include/asm/idle.h
index 38d8737..1ef7da2 100644
--- a/arch/x86/include/asm/idle.h
+++ b/arch/x86/include/asm/idle.h
@@ -16,6 +16,4 @@ static inline void enter_idle(void) { }
 static inline void exit_idle(void) { }
 #endif /* CONFIG_X86_64 */
 
-void c1e_remove_cpu(int cpu);
-
 #endif /* _ASM_X86_IDLE_H */
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 7e5c6a6..c5e29a9 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -757,7 +757,6 @@ static inline void __sti_mwait(unsigned long eax, unsigned long ecx)
 extern void mwait_idle_with_hints(unsigned long eax, unsigned long ecx);
 
 extern void select_idle_routine(const struct cpuinfo_x86 *c);
-extern void init_c1e_mask(void);
 
 extern unsigned long		boot_option_idle_override;
 extern unsigned long		idle_halt;
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 68e4a6f..7be2fbf 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -864,7 +864,6 @@ static void vgetcpu_set_mode(void)
 void __init identify_boot_cpu(void)
 {
 	identify_cpu(&boot_cpu_data);
-	init_c1e_mask();
 #ifdef CONFIG_X86_32
 	sysenter_setup();
 	enable_sep_cpu();
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index f3520a8..cfe109d 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -561,15 +561,8 @@ no_c1e_idle:
 	return 0;
 }
 
-static cpumask_var_t c1e_mask;
 static int c1e_detected;
 
-void c1e_remove_cpu(int cpu)
-{
-	if (c1e_mask != NULL)
-		cpumask_clear_cpu(cpu, c1e_mask);
-}
-
 /*
  * C1E aware idle routine. We check for C1E active in the interrupt
  * pending message MSR. If we detect C1E, then we handle it the same
@@ -596,8 +589,7 @@ static void c1e_idle(void)
 	if (c1e_detected) {
 		int cpu = smp_processor_id();
 
-		if (!cpumask_test_cpu(cpu, c1e_mask)) {
-			cpumask_set_cpu(cpu, c1e_mask);
+		if (!cpu_has(&current_cpu_data, X86_FEATURE_AMDC1E)) {
 			/*
 			 * Force broadcast so ACPI can not interfere.
 			 */
@@ -630,6 +622,14 @@ void __cpuinit select_idle_routine(const struct cpuinfo_x86 *c)
 			" performance may degrade.\n");
 	}
 #endif
+	if (c1e_detected) {
+		/*
+		 * Broadcast can't have been activated on this CPU yet.
+		 * Clear the flag to let c1e_idle() do it.
+		 */
+		clear_cpu_cap(&current_cpu_data, X86_FEATURE_AMDC1E);
+	}
+
 	if (pm_idle)
 		return;
 
@@ -646,13 +646,6 @@ void __cpuinit select_idle_routine(const struct cpuinfo_x86 *c)
 		pm_idle = default_idle;
 }
 
-void __init init_c1e_mask(void)
-{
-	/* If we're using c1e_idle, we need to allocate c1e_mask. */
-	if (pm_idle == c1e_idle)
-		zalloc_cpumask_var(&c1e_mask, GFP_KERNEL);
-}
-
 static int __init idle_setup(char *str)
 {
 	if (!str)
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index c4f33b2..dd647bb 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -1355,7 +1355,6 @@ void play_dead_common(void)
 	idle_task_exit();
 	reset_lazy_tlbstate();
 	irq_ctx_exit(raw_smp_processor_id());
-	c1e_remove_cpu(raw_smp_processor_id());
 
 	mb();
 	/* Ack it */

