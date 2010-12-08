Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754918Ab0LHNQ6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 08:16:58 -0500
Received: from hera.kernel.org ([140.211.167.34]:50520 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753862Ab0LHNQ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 08:16:56 -0500
Message-ID: <4CFF8520.4020704@kernel.org>
Date: Wed, 08 Dec 2010 14:16:16 +0100
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.9) Gecko/20100915 Lightning/1.0b2 Thunderbird/3.1.4
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: akpm@linux-foundation.org, Yinghai Lu <yinghai@kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Pekka Enberg <penberg@cs.helsinki.fi>,
        linux-kernel@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [PATCH] x86: Replace uses of current_cpu_data with this_cpu ops
References: <20101206171618.302060721@linux.com> <20101206171638.595205962@linux.com> <4CFE41F8.7040400@kernel.org> <4CFE4294.30001@kernel.org> <alpine.DEB.2.00.1012070846050.25976@router.home> <4CFE4BE0.9040203@kernel.org> <alpine.DEB.2.00.1012070906290.26552@router.home> <4CFE4E05.7070902@kernel.org> <alpine.DEB.2.00.1012071020040.26552@router.home>
In-Reply-To: <alpine.DEB.2.00.1012071020040.26552@router.home>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 08 Dec 2010 13:15:42 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 9e9b27bff0e2441512ec27d3a90b252ecdc6ec3e Mon Sep 17 00:00:00 2001
From: Christoph Lameter <cl@linux.com>
Date: Wed, 8 Dec 2010 14:11:07 +0100

Replace all uses of current_cpu_data with this_cpu operations on the
per cpu structure cpu_info.  The scala accesses are replaced with the
matching this_cpu ops which results in smaller and more efficient
code.

In the long run, it might be a good idea to remove cpu_data() macro
too and use per_cpu macro directly.

tj: updated description

Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Christoph Lameter <cl@linux.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
---
Comitted with updated description.  Thanks.

 arch/x86/include/asm/processor.h          |    3 +--
 arch/x86/kernel/apic/apic.c               |    2 +-
 arch/x86/kernel/cpu/amd.c                 |    2 +-
 arch/x86/kernel/cpu/cpufreq/powernow-k8.c |    2 +-
 arch/x86/kernel/cpu/intel_cacheinfo.c     |    4 ++--
 arch/x86/kernel/cpu/mcheck/mce.c          |   14 +++++++-------
 arch/x86/kernel/cpu/mcheck/mce_intel.c    |    2 +-
 arch/x86/kernel/process.c                 |    4 ++--
 arch/x86/kernel/smpboot.c                 |   12 ++++++------
 arch/x86/oprofile/op_model_ppro.c         |    8 ++++----
 drivers/staging/lirc/lirc_serial.c        |    4 ++--
 11 files changed, 28 insertions(+), 29 deletions(-)

diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index cae9c3c..c6efecf 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -141,10 +141,9 @@ extern __u32			cpu_caps_set[NCAPINTS];
 #ifdef CONFIG_SMP
 DECLARE_PER_CPU_SHARED_ALIGNED(struct cpuinfo_x86, cpu_info);
 #define cpu_data(cpu)		per_cpu(cpu_info, cpu)
-#define current_cpu_data	__get_cpu_var(cpu_info)
 #else
+#define cpu_info		boot_cpu_data
 #define cpu_data(cpu)		boot_cpu_data
-#define current_cpu_data	boot_cpu_data
 #endif

 extern const struct seq_operations cpuinfo_op;
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 3f838d5..8accfe3 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -516,7 +516,7 @@ static void __cpuinit setup_APIC_timer(void)
 {
 	struct clock_event_device *levt = &__get_cpu_var(lapic_events);

-	if (cpu_has(&current_cpu_data, X86_FEATURE_ARAT)) {
+	if (cpu_has(__this_cpu_ptr(&cpu_info), X86_FEATURE_ARAT)) {
 		lapic_clockevent.features &= ~CLOCK_EVT_FEAT_C3STOP;
 		/* Make LAPIC timer preferrable over percpu HPET */
 		lapic_clockevent.rating = 150;
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 9e093f8..7c7bedb 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -668,7 +668,7 @@ EXPORT_SYMBOL_GPL(amd_erratum_383);

 bool cpu_has_amd_erratum(const int *erratum)
 {
-	struct cpuinfo_x86 *cpu = &current_cpu_data;
+	struct cpuinfo_x86 *cpu = __this_cpu_ptr(&cpu_info);
 	int osvw_id = *erratum++;
 	u32 range;
 	u32 ms;
diff --git a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c b/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
index 42a3604..35c7e65 100644
--- a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
+++ b/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
@@ -521,7 +521,7 @@ static void check_supported_cpu(void *_rc)

 	*rc = -ENODEV;

-	if (current_cpu_data.x86_vendor != X86_VENDOR_AMD)
+	if (__this_cpu_read(cpu_info.x86_vendor) != X86_VENDOR_AMD)
 		return;

 	eax = cpuid_eax(CPUID_PROCESSOR_SIGNATURE);
diff --git a/arch/x86/kernel/cpu/intel_cacheinfo.c b/arch/x86/kernel/cpu/intel_cacheinfo.c
index 17ad033..453c616 100644
--- a/arch/x86/kernel/cpu/intel_cacheinfo.c
+++ b/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -266,7 +266,7 @@ amd_cpuid4(int leaf, union _cpuid4_leaf_eax *eax,
 		line_size = l2.line_size;
 		lines_per_tag = l2.lines_per_tag;
 		/* cpu_data has errata corrections for K7 applied */
-		size_in_kb = current_cpu_data.x86_cache_size;
+		size_in_kb = __this_cpu_read(cpu_info.x86_cache_size);
 		break;
 	case 3:
 		if (!l3.val)
@@ -288,7 +288,7 @@ amd_cpuid4(int leaf, union _cpuid4_leaf_eax *eax,
 	eax->split.type = types[leaf];
 	eax->split.level = levels[leaf];
 	eax->split.num_threads_sharing = 0;
-	eax->split.num_cores_on_die = current_cpu_data.x86_max_cores - 1;
+	eax->split.num_cores_on_die = __this_cpu_read(cpu_info.x86_max_cores) - 1;


 	if (assoc == 0xffff)
diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 0c746af..d916183 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -1159,7 +1159,7 @@ static void mce_start_timer(unsigned long data)

 	WARN_ON(smp_processor_id() != data);

-	if (mce_available(&current_cpu_data)) {
+	if (mce_available(__this_cpu_ptr(&cpu_info))) {
 		machine_check_poll(MCP_TIMESTAMP,
 				&__get_cpu_var(mce_poll_banks));
 	}
@@ -1767,7 +1767,7 @@ static int mce_shutdown(struct sys_device *dev)
 static int mce_resume(struct sys_device *dev)
 {
 	__mcheck_cpu_init_generic();
-	__mcheck_cpu_init_vendor(&current_cpu_data);
+	__mcheck_cpu_init_vendor(__this_cpu_ptr(&cpu_info));

 	return 0;
 }
@@ -1775,7 +1775,7 @@ static int mce_resume(struct sys_device *dev)
 static void mce_cpu_restart(void *data)
 {
 	del_timer_sync(&__get_cpu_var(mce_timer));
-	if (!mce_available(&current_cpu_data))
+	if (!mce_available(__this_cpu_ptr(&cpu_info)))
 		return;
 	__mcheck_cpu_init_generic();
 	__mcheck_cpu_init_timer();
@@ -1790,7 +1790,7 @@ static void mce_restart(void)
 /* Toggle features for corrected errors */
 static void mce_disable_ce(void *all)
 {
-	if (!mce_available(&current_cpu_data))
+	if (!mce_available(__this_cpu_ptr(&cpu_info)))
 		return;
 	if (all)
 		del_timer_sync(&__get_cpu_var(mce_timer));
@@ -1799,7 +1799,7 @@ static void mce_disable_ce(void *all)

 static void mce_enable_ce(void *all)
 {
-	if (!mce_available(&current_cpu_data))
+	if (!mce_available(__this_cpu_ptr(&cpu_info)))
 		return;
 	cmci_reenable();
 	cmci_recheck();
@@ -2022,7 +2022,7 @@ static void __cpuinit mce_disable_cpu(void *h)
 	unsigned long action = *(unsigned long *)h;
 	int i;

-	if (!mce_available(&current_cpu_data))
+	if (!mce_available(__this_cpu_ptr(&cpu_info)))
 		return;

 	if (!(action & CPU_TASKS_FROZEN))
@@ -2040,7 +2040,7 @@ static void __cpuinit mce_reenable_cpu(void *h)
 	unsigned long action = *(unsigned long *)h;
 	int i;

-	if (!mce_available(&current_cpu_data))
+	if (!mce_available(__this_cpu_ptr(&cpu_info)))
 		return;

 	if (!(action & CPU_TASKS_FROZEN))
diff --git a/arch/x86/kernel/cpu/mcheck/mce_intel.c b/arch/x86/kernel/cpu/mcheck/mce_intel.c
index 6fcd093..8694ef5 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_intel.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_intel.c
@@ -130,7 +130,7 @@ void cmci_recheck(void)
 	unsigned long flags;
 	int banks;

-	if (!mce_available(&current_cpu_data) || !cmci_supported(&banks))
+	if (!mce_available(__this_cpu_ptr(&cpu_info)) || !cmci_supported(&banks))
 		return;
 	local_irq_save(flags);
 	machine_check_poll(MCP_TIMESTAMP, &__get_cpu_var(mce_banks_owned));
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 57d1868..dae1c07 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -445,7 +445,7 @@ void mwait_idle_with_hints(unsigned long ax, unsigned long cx)
 {
 	trace_power_start(POWER_CSTATE, (ax>>4)+1, smp_processor_id());
 	if (!need_resched()) {
-		if (cpu_has(&current_cpu_data, X86_FEATURE_CLFLUSH_MONITOR))
+		if (cpu_has(__this_cpu_ptr(&cpu_info), X86_FEATURE_CLFLUSH_MONITOR))
 			clflush((void *)&current_thread_info()->flags);

 		__monitor((void *)&current_thread_info()->flags, 0, 0);
@@ -460,7 +460,7 @@ static void mwait_idle(void)
 {
 	if (!need_resched()) {
 		trace_power_start(POWER_CSTATE, 1, smp_processor_id());
-		if (cpu_has(&current_cpu_data, X86_FEATURE_CLFLUSH_MONITOR))
+		if (cpu_has(__this_cpu_ptr(&cpu_info), X86_FEATURE_CLFLUSH_MONITOR))
 			clflush((void *)&current_thread_info()->flags);

 		__monitor((void *)&current_thread_info()->flags, 0, 0);
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index ff4e5a1..0720071 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -430,7 +430,7 @@ void __cpuinit set_cpu_sibling_map(int cpu)

 	cpumask_set_cpu(cpu, c->llc_shared_map);

-	if (current_cpu_data.x86_max_cores == 1) {
+	if (__this_cpu_read(cpu_info.x86_max_cores) == 1) {
 		cpumask_copy(cpu_core_mask(cpu), cpu_sibling_mask(cpu));
 		c->booted_cores = 1;
 		return;
@@ -1094,7 +1094,7 @@ void __init native_smp_prepare_cpus(unsigned int max_cpus)

 	preempt_disable();
 	smp_cpu_index_default();
-	current_cpu_data = boot_cpu_data;
+	memcpy(__this_cpu_ptr(&cpu_info), &boot_cpu_data, sizeof(cpu_info));
 	cpumask_copy(cpu_callin_mask, cpumask_of(0));
 	mb();
 	/*
@@ -1397,11 +1397,11 @@ static inline void mwait_play_dead(void)
 	int i;
 	void *mwait_ptr;

-	if (!cpu_has(&current_cpu_data, X86_FEATURE_MWAIT))
+	if (!cpu_has(__this_cpu_ptr(&cpu_info), X86_FEATURE_MWAIT))
 		return;
-	if (!cpu_has(&current_cpu_data, X86_FEATURE_CLFLSH))
+	if (!cpu_has(__this_cpu_ptr(&cpu_info), X86_FEATURE_CLFLSH))
 		return;
-	if (current_cpu_data.cpuid_level < CPUID_MWAIT_LEAF)
+	if (__this_cpu_read(cpu_info.cpuid_level) < CPUID_MWAIT_LEAF)
 		return;

 	eax = CPUID_MWAIT_LEAF;
@@ -1452,7 +1452,7 @@ static inline void mwait_play_dead(void)

 static inline void hlt_play_dead(void)
 {
-	if (current_cpu_data.x86 >= 4)
+	if (__this_cpu_read(cpu_info.x86) >= 4)
 		wbinvd();

 	while (1) {
diff --git a/arch/x86/oprofile/op_model_ppro.c b/arch/x86/oprofile/op_model_ppro.c
index d769cda..94b7450 100644
--- a/arch/x86/oprofile/op_model_ppro.c
+++ b/arch/x86/oprofile/op_model_ppro.c
@@ -95,8 +95,8 @@ static void ppro_setup_ctrs(struct op_x86_model_spec const *model,
 		 * counter width:
 		 */
 		if (!(eax.split.version_id == 0 &&
-			current_cpu_data.x86 == 6 &&
-				current_cpu_data.x86_model == 15)) {
+			__this_cpu_read(cpu_info.x86) == 6 &&
+				__this_cpu_read(cpu_info.x86_model) == 15)) {

 			if (counter_width < eax.split.bit_width)
 				counter_width = eax.split.bit_width;
@@ -235,8 +235,8 @@ static void arch_perfmon_setup_counters(void)
 	eax.full = cpuid_eax(0xa);

 	/* Workaround for BIOS bugs in 6/15. Taken from perfmon2 */
-	if (eax.split.version_id == 0 && current_cpu_data.x86 == 6 &&
-		current_cpu_data.x86_model == 15) {
+	if (eax.split.version_id == 0 && __this_cpu_read(cpu_info.x86) == 6 &&
+		__this_cpu_read(cpu_info.x86_model) == 15) {
 		eax.split.version_id = 2;
 		eax.split.num_counters = 2;
 		eax.split.bit_width = 40;
diff --git a/drivers/staging/lirc/lirc_serial.c b/drivers/staging/lirc/lirc_serial.c
index 971844b..9bcf149 100644
--- a/drivers/staging/lirc/lirc_serial.c
+++ b/drivers/staging/lirc/lirc_serial.c
@@ -377,7 +377,7 @@ static int init_timing_params(unsigned int new_duty_cycle,
 	duty_cycle = new_duty_cycle;
 	freq = new_freq;

-	loops_per_sec = current_cpu_data.loops_per_jiffy;
+	loops_per_sec = __this_cpu_read(cpu.info.loops_per_jiffy);
 	loops_per_sec *= HZ;

 	/* How many clocks in a microsecond?, avoiding long long divide */
@@ -398,7 +398,7 @@ static int init_timing_params(unsigned int new_duty_cycle,
 	dprintk("in init_timing_params, freq=%d, duty_cycle=%d, "
 		"clk/jiffy=%ld, pulse=%ld, space=%ld, "
 		"conv_us_to_clocks=%ld\n",
-		freq, duty_cycle, current_cpu_data.loops_per_jiffy,
+		freq, duty_cycle, __this_cpu_read(cpu_info.loops_per_jiffy),
 		pulse_width, space_width, conv_us_to_clocks);
 	return 0;
 }
-- 
1.7.1

