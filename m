Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753606Ab1DBHCf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Apr 2011 03:02:35 -0400
Received: from vms173009pub.verizon.net ([206.46.173.9]:59186 "EHLO
	vms173009pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753587Ab1DBHCB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Apr 2011 03:02:01 -0400
From: Len Brown <lenb@kernel.org>
To: linux-pm@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Len Brown <len.brown@intel.com>,
        x86@kernel.org
Subject: [PATCH 18/18] 2.6.40: x86 idle: remove deprecated mwait_idle()
Date: Sat, 02 Apr 2011 02:23:00 -0400
Message-id: <d29645381f953dd00b853ae69e2347b1c5274465.1301724243.git.len.brown@intel.com>
X-Mailer: git-send-email 1.7.5.rc0
In-reply-to: <1301725380-10579-1-git-send-email-lenb@kernel.org>
References: <alpine.LFD.2.02.1104010020280.2797@x980>
 <1301725380-10579-1-git-send-email-lenb@kernel.org>
In-reply-to: <c82cf78992a66bfa7f0c82aeb20ba6922127463b.1301724243.git.len.brown@intel.com>
References: <c82cf78992a66bfa7f0c82aeb20ba6922127463b.1301724243.git.len.brown@intel.com>
X-Patchwork-Hint: ignore
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Len Brown <len.brown@intel.com>

For ACPI mode, mwait_with_hints() in cstate.c is used instead of
mwait_idle().

For INTEL_IDLE mode, the mwait in intel_idle() is used instead of
mwait_idle().

So mwait_idle() is used only on hardware that supports MWAIT,
but is running a !ACPI && !INTEL_IDLE kernel.
Such a system will run HLT instead of MWAIT after this change.

cc: x86@kernel.org
Acked-by: Andreas Herrmann <andreas.herrmann3@amd.com>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 Documentation/feature-removal-schedule.txt |    7 -----
 Documentation/kernel-parameters.txt        |    7 +----
 arch/x86/include/asm/processor.h           |    2 +-
 arch/x86/kernel/process.c                  |   35 +---------------------------
 drivers/acpi/processor_idle.c              |    1 -
 5 files changed, 3 insertions(+), 49 deletions(-)

diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index 9b84b1a..f55ba2c 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -6,13 +6,6 @@ be removed from this file.
 
 ----------------------------
 
-What:	x86 "idle=mwait" cmdline param
-When:	2.6.40
-Why:	simplify x86 idle code
-Who:	Len Brown <len.brown@intel.com>
-
-----------------------------
-
 What:	PRISM54
 When:	2.6.34
 
diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index a9db94e..52c956a 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -920,16 +920,11 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			Claim all unknown PCI IDE storage controllers.
 
 	idle=		[X86]
-			Format: idle=poll, idle=mwait, idle=halt, idle=nomwait
+			Format: idle=poll, idle=halt, idle=nomwait
 			Poll forces a polling idle loop that can slightly
 			improve the performance of waking up a idle CPU, but
 			will use a lot of power and make the system run hot.
 			Not recommended.
-			idle=mwait: On systems which support MONITOR/MWAIT but
-			the kernel chose to not use it because it doesn't save
-			as much power as a normal idle loop, use the
-			MONITOR/MWAIT idle loop anyways. Performance should be
-			the same as idle=poll.
 			idle=halt: Halt is forced to be used for CPU idle.
 			In such case C2/C3 won't be used again.
 			idle=nomwait: Disable mwait for CPU C-states
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 10cdee8..3424009 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -752,7 +752,7 @@ extern unsigned long		boot_option_idle_override;
 extern bool			amd_e400_detected;
 
 enum idle_boot_override {IDLE_NO_OVERRIDE=0, IDLE_HALT, IDLE_NOMWAIT,
-			 IDLE_POLL, IDLE_FORCE_MWAIT};
+			 IDLE_POLL};
 
 extern void enable_sep_cpu(void);
 extern int sysenter_setup(void);
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 8daa323..4ab4bba 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -399,27 +399,6 @@ void cpu_idle_wait(void)
 }
 EXPORT_SYMBOL_GPL(cpu_idle_wait);
 
-/* Default MONITOR/MWAIT with no hints, used for default C1 state */
-static void mwait_idle(void)
-{
-	if (!need_resched()) {
-		trace_power_start(POWER_CSTATE, 1, smp_processor_id());
-		trace_cpu_idle(1, smp_processor_id());
-		if (cpu_has(__this_cpu_ptr(&cpu_info), X86_FEATURE_CLFLUSH_MONITOR))
-			clflush((void *)&current_thread_info()->flags);
-
-		__monitor((void *)&current_thread_info()->flags, 0, 0);
-		smp_mb();
-		if (!need_resched())
-			__sti_mwait(0, 0);
-		else
-			local_irq_enable();
-		trace_power_end(smp_processor_id());
-		trace_cpu_idle(PWR_EVENT_EXIT, smp_processor_id());
-	} else
-		local_irq_enable();
-}
-
 /*
  * On SMP it's slightly faster (but much more power-consuming!)
  * to poll the ->work.need_resched flag instead of waiting for the
@@ -457,9 +436,6 @@ int mwait_usable(const struct cpuinfo_x86 *c)
 {
 	u32 eax, ebx, ecx, edx;
 
-	if (boot_option_idle_override == IDLE_FORCE_MWAIT)
-		return 1;
-
 	if (c->cpuid_level < MWAIT_INFO)
 		return 0;
 
@@ -548,13 +524,7 @@ void __cpuinit select_idle_routine(const struct cpuinfo_x86 *c)
 	if (pm_idle)
 		return;
 
-	if (cpu_has(c, X86_FEATURE_MWAIT) && mwait_usable(c)) {
-		/*
-		 * One CPU supports mwait => All CPUs supports mwait
-		 */
-		printk(KERN_INFO "using mwait in idle threads.\n");
-		pm_idle = mwait_idle;
-	} else if (cpu_has_amd_erratum(amd_erratum_400)) {
+	if (cpu_has_amd_erratum(amd_erratum_400)) {
 		/* E400: APIC timer interrupt does not wake up CPU from C1e */
 		printk(KERN_INFO "using E400 aware idle routine\n");
 		pm_idle = amd_e400_idle;
@@ -578,9 +548,6 @@ static int __init idle_setup(char *str)
 		printk("using polling idle threads.\n");
 		pm_idle = poll_idle;
 		boot_option_idle_override = IDLE_POLL;
-	} else if (!strcmp(str, "mwait")) {
-		boot_option_idle_override = IDLE_FORCE_MWAIT;
-		WARN_ONCE(1, "\idle=mwait\" will be removed in 2.6.40\"\n");
 	} else if (!strcmp(str, "halt")) {
 		/*
 		 * When the boot option of idle=halt is added, halt is
diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
index 53d9f10..954a9d3 100644
--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -82,7 +82,6 @@ module_param(latency_factor, uint, 0644);
 static int disabled_by_idle_boot_param(void)
 {
 	return boot_option_idle_override == IDLE_POLL ||
-		boot_option_idle_override == IDLE_FORCE_MWAIT ||
 		boot_option_idle_override == IDLE_HALT;
 }
 
-- 
1.7.5.rc0

