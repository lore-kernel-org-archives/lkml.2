Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754974Ab0LGQVS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 11:21:18 -0500
Received: from smtp101.prem.mail.ac4.yahoo.com ([76.13.13.40]:29324 "HELO
	smtp101.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753632Ab0LGQVR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 11:21:17 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: cUpMr54VM1m7PwzIak2JfOHnSj0ofIxcm9oT3P1kah1N5Yf
 XNBWVI11OAzHAmX0iXEgt4Ny9v8.L6HExZJSlu4vFVDjxH.3xIT_q7nOwg3F
 Az45OYw5th5NpzliN3w3uYHppCSW8BQGH5ES_rMwfs9BKERHX25PMJeyAY2z
 bp5fHtBTsXMad8PPqXv7W3zpjgj7ye0lPeshhq0IlA8YZX5z3AuYSw8uWirJ
 ltK9M5vipSGXR5GmF7juY5WqG_v3Zlhhb9Npx83dP7rMZd1icO29L7an2j6X
 Ybm_SqxFCBXr997qTAWUx
X-Yahoo-Newman-Property: ymail-3
Date: Tue, 7 Dec 2010 10:21:12 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Tejun Heo <tj@kernel.org>
cc: akpm@linux-foundation.org, Yinghai Lu <yinghai@kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Pekka Enberg <penberg@cs.helsinki.fi>,
        linux-kernel@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [Use cpuops V1 04/11] x86: Use this_cpu_ops for current_cpu_data
 accesses
In-Reply-To: <4CFE4E05.7070902@kernel.org>
Message-ID: <alpine.DEB.2.00.1012071020040.26552@router.home>
References: <20101206171618.302060721@linux.com> <20101206171638.595205962@linux.com> <4CFE41F8.7040400@kernel.org> <4CFE4294.30001@kernel.org> <alpine.DEB.2.00.1012070846050.25976@router.home> <4CFE4BE0.9040203@kernel.org> <alpine.DEB.2.00.1012070906290.26552@router.home>
 <4CFE4E05.7070902@kernel.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 7 Dec 2010, Tejun Heo wrote:

> > Hmmm... Ok 21 occurrences. So two patches: Conversion and then
> > this_cpu_ops. Or one doing both?
>
> Two steps is better probably.  Thank you.

Well the first one would have been difficult without the second one. So
lets have it in one step. Compiles and runs under kvm with NUMA and UP.


Subject: x86: Replace uses of current_cpu_data with this_cpu ops

Replace all uses of current_cpu_data with this_cpu operations on the per
cpu structure cpu_info.

Signed-off-by: Christoph Lameter <cl@linux.com>


---
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

Index: linux-2.6/arch/x86/include/asm/processor.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/processor.h	2010-12-07 09:53:55.000000000 -0600
+++ linux-2.6/arch/x86/include/asm/processor.h	2010-12-07 09:55:04.000000000 -0600
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
Index: linux-2.6/arch/x86/kernel/apic/apic.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/apic/apic.c	2010-12-07 09:55:31.000000000 -0600
+++ linux-2.6/arch/x86/kernel/apic/apic.c	2010-12-07 09:56:18.000000000 -0600
@@ -516,7 +516,7 @@ static void __cpuinit setup_APIC_timer(v
 {
 	struct clock_event_device *levt = &__get_cpu_var(lapic_events);

-	if (cpu_has(&current_cpu_data, X86_FEATURE_ARAT)) {
+	if (cpu_has(__this_cpu_ptr(&cpu_info), X86_FEATURE_ARAT)) {
 		lapic_clockevent.features &= ~CLOCK_EVT_FEAT_C3STOP;
 		/* Make LAPIC timer preferrable over percpu HPET */
 		lapic_clockevent.rating = 150;
Index: linux-2.6/arch/x86/kernel/cpu/amd.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/amd.c	2010-12-07 09:56:33.000000000 -0600
+++ linux-2.6/arch/x86/kernel/cpu/amd.c	2010-12-07 09:56:49.000000000 -0600
@@ -668,7 +668,7 @@ EXPORT_SYMBOL_GPL(amd_erratum_383);

 bool cpu_has_amd_erratum(const int *erratum)
 {
-	struct cpuinfo_x86 *cpu = &current_cpu_data;
+	struct cpuinfo_x86 *cpu = __this_cpu_ptr(&cpu_info);
 	int osvw_id = *erratum++;
 	u32 range;
 	u32 ms;
Index: linux-2.6/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/cpufreq/powernow-k8.c	2010-12-07 09:57:08.000000000 -0600
+++ linux-2.6/arch/x86/kernel/cpu/cpufreq/powernow-k8.c	2010-12-07 09:57:39.000000000 -0600
@@ -521,7 +521,7 @@ static void check_supported_cpu(void *_r

 	*rc = -ENODEV;

-	if (current_cpu_data.x86_vendor != X86_VENDOR_AMD)
+	if (__this_cpu_read(cpu_info.x86_vendor) != X86_VENDOR_AMD)
 		return;

 	eax = cpuid_eax(CPUID_PROCESSOR_SIGNATURE);
Index: linux-2.6/arch/x86/kernel/cpu/intel_cacheinfo.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/intel_cacheinfo.c	2010-12-07 09:57:53.000000000 -0600
+++ linux-2.6/arch/x86/kernel/cpu/intel_cacheinfo.c	2010-12-07 09:58:25.000000000 -0600
@@ -266,7 +266,7 @@ amd_cpuid4(int leaf, union _cpuid4_leaf_
 		line_size = l2.line_size;
 		lines_per_tag = l2.lines_per_tag;
 		/* cpu_data has errata corrections for K7 applied */
-		size_in_kb = current_cpu_data.x86_cache_size;
+		size_in_kb = __this_cpu_read(cpu_info.x86_cache_size);
 		break;
 	case 3:
 		if (!l3.val)
@@ -288,7 +288,7 @@ amd_cpuid4(int leaf, union _cpuid4_leaf_
 	eax->split.type = types[leaf];
 	eax->split.level = levels[leaf];
 	eax->split.num_threads_sharing = 0;
-	eax->split.num_cores_on_die = current_cpu_data.x86_max_cores - 1;
+	eax->split.num_cores_on_die = __this_cpu_read(cpu_info.x86_max_cores) - 1;


 	if (assoc == 0xffff)
Index: linux-2.6/arch/x86/kernel/cpu/mcheck/mce.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/mcheck/mce.c	2010-12-07 09:58:35.000000000 -0600
+++ linux-2.6/arch/x86/kernel/cpu/mcheck/mce.c	2010-12-07 10:17:12.000000000 -0600
@@ -1159,7 +1159,7 @@ static void mce_start_timer(unsigned lon

 	WARN_ON(smp_processor_id() != data);

-	if (mce_available(&current_cpu_data)) {
+	if (mce_available(__this_cpu_ptr(&cpu_info))) {
 		machine_check_poll(MCP_TIMESTAMP,
 				&__get_cpu_var(mce_poll_banks));
 	}
@@ -1767,7 +1767,7 @@ static int mce_shutdown(struct sys_devic
 static int mce_resume(struct sys_device *dev)
 {
 	__mcheck_cpu_init_generic();
-	__mcheck_cpu_init_vendor(&current_cpu_data);
+	__mcheck_cpu_init_vendor(__this_cpu_ptr(&cpu_info));

 	return 0;
 }
@@ -1775,7 +1775,7 @@ static int mce_resume(struct sys_device
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
@@ -2022,7 +2022,7 @@ static void __cpuinit mce_disable_cpu(vo
 	unsigned long action = *(unsigned long *)h;
 	int i;

-	if (!mce_available(&current_cpu_data))
+	if (!mce_available(__this_cpu_ptr(&cpu_info)))
 		return;

 	if (!(action & CPU_TASKS_FROZEN))
@@ -2040,7 +2040,7 @@ static void __cpuinit mce_reenable_cpu(v
 	unsigned long action = *(unsigned long *)h;
 	int i;

-	if (!mce_available(&current_cpu_data))
+	if (!mce_available(__this_cpu_ptr(&cpu_info)))
 		return;

 	if (!(action & CPU_TASKS_FROZEN))
Index: linux-2.6/arch/x86/kernel/cpu/mcheck/mce_intel.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/mcheck/mce_intel.c	2010-12-07 10:00:15.000000000 -0600
+++ linux-2.6/arch/x86/kernel/cpu/mcheck/mce_intel.c	2010-12-07 10:00:30.000000000 -0600
@@ -130,7 +130,7 @@ void cmci_recheck(void)
 	unsigned long flags;
 	int banks;

-	if (!mce_available(&current_cpu_data) || !cmci_supported(&banks))
+	if (!mce_available(__this_cpu_ptr(&cpu_info)) || !cmci_supported(&banks))
 		return;
 	local_irq_save(flags);
 	machine_check_poll(MCP_TIMESTAMP, &__get_cpu_var(mce_banks_owned));
Index: linux-2.6/arch/x86/kernel/process.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/process.c	2010-12-07 10:00:43.000000000 -0600
+++ linux-2.6/arch/x86/kernel/process.c	2010-12-07 10:01:08.000000000 -0600
@@ -445,7 +445,7 @@ void mwait_idle_with_hints(unsigned long
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
Index: linux-2.6/arch/x86/kernel/smpboot.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/smpboot.c	2010-12-07 10:01:15.000000000 -0600
+++ linux-2.6/arch/x86/kernel/smpboot.c	2010-12-07 10:10:48.000000000 -0600
@@ -430,7 +430,7 @@ void __cpuinit set_cpu_sibling_map(int c

 	cpumask_set_cpu(cpu, c->llc_shared_map);

-	if (current_cpu_data.x86_max_cores == 1) {
+	if (__this_cpu_read(cpu_info.x86_max_cores) == 1) {
 		cpumask_copy(cpu_core_mask(cpu), cpu_sibling_mask(cpu));
 		c->booted_cores = 1;
 		return;
@@ -1094,7 +1094,7 @@ void __init native_smp_prepare_cpus(unsi

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
Index: linux-2.6/arch/x86/oprofile/op_model_ppro.c
===================================================================
--- linux-2.6.orig/arch/x86/oprofile/op_model_ppro.c	2010-12-07 10:02:45.000000000 -0600
+++ linux-2.6/arch/x86/oprofile/op_model_ppro.c	2010-12-07 10:03:41.000000000 -0600
@@ -95,8 +95,8 @@ static void ppro_setup_ctrs(struct op_x8
 		 * counter width:
 		 */
 		if (!(eax.split.version_id == 0 &&
-			current_cpu_data.x86 == 6 &&
-				current_cpu_data.x86_model == 15)) {
+			__this_cpu_read(cpu_info.x86) == 6 &&
+				__this_cpu_read(cpu_info.x86_model) == 15)) {

 			if (counter_width < eax.split.bit_width)
 				counter_width = eax.split.bit_width;
@@ -235,8 +235,8 @@ static void arch_perfmon_setup_counters(
 	eax.full = cpuid_eax(0xa);

 	/* Workaround for BIOS bugs in 6/15. Taken from perfmon2 */
-	if (eax.split.version_id == 0 && current_cpu_data.x86 == 6 &&
-		current_cpu_data.x86_model == 15) {
+	if (eax.split.version_id == 0 && __this_cpu_read(cpu_info.x86) == 6 &&
+		__this_cpu_read(cpu_info.x86_model) == 15) {
 		eax.split.version_id = 2;
 		eax.split.num_counters = 2;
 		eax.split.bit_width = 40;
Index: linux-2.6/drivers/staging/lirc/lirc_serial.c
===================================================================
--- linux-2.6.orig/drivers/staging/lirc/lirc_serial.c	2010-12-07 10:04:01.000000000 -0600
+++ linux-2.6/drivers/staging/lirc/lirc_serial.c	2010-12-07 10:04:31.000000000 -0600
@@ -377,7 +377,7 @@ static int init_timing_params(unsigned i
 	duty_cycle = new_duty_cycle;
 	freq = new_freq;

-	loops_per_sec = current_cpu_data.loops_per_jiffy;
+	loops_per_sec = __this_cpu_read(cpu.info.loops_per_jiffy);
 	loops_per_sec *= HZ;

 	/* How many clocks in a microsecond?, avoiding long long divide */
@@ -398,7 +398,7 @@ static int init_timing_params(unsigned i
 	dprintk("in init_timing_params, freq=%d, duty_cycle=%d, "
 		"clk/jiffy=%ld, pulse=%ld, space=%ld, "
 		"conv_us_to_clocks=%ld\n",
-		freq, duty_cycle, current_cpu_data.loops_per_jiffy,
+		freq, duty_cycle, __this_cpu_read(cpu_info.loops_per_jiffy),
 		pulse_width, space_width, conv_us_to_clocks);
 	return 0;
 }
