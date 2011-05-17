Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756081Ab1EQRER (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 13:04:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35868 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756026Ab1EQRD7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 13:03:59 -0400
From: Matthew Garrett <mjg@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: borislav.petkov@amd.com, davej@redhat.com, mark.langsdorf@amd.com,
        cpufreq@vger.kernel.org, Matthew Garrett <mjg@redhat.com>
Subject: [PATCH 5/5] cpufreq: Remove support for hardware P-state chips from powernow-k8
Date: Tue, 17 May 2011 13:03:39 -0400
Message-Id: <1305651819-25660-5-git-send-email-mjg@redhat.com>
In-Reply-To: <1305651819-25660-1-git-send-email-mjg@redhat.com>
References: <1305651819-25660-1-git-send-email-mjg@redhat.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 209.6.41.104
X-SA-Exim-Mail-From: mjg@redhat.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These chips are now supported by acpi-cpufreq, so we can delete all the
code handling them.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
---
 arch/x86/kernel/cpu/cpufreq/Makefile      |    2 +-
 arch/x86/kernel/cpu/cpufreq/powernow-k8.c |  371 ++---------------------------
 arch/x86/kernel/cpu/cpufreq/powernow-k8.h |   32 ---
 3 files changed, 25 insertions(+), 380 deletions(-)

diff --git a/arch/x86/kernel/cpu/cpufreq/Makefile b/arch/x86/kernel/cpu/cpufreq/Makefile
index bd54bf6..ca3a13b 100644
--- a/arch/x86/kernel/cpu/cpufreq/Makefile
+++ b/arch/x86/kernel/cpu/cpufreq/Makefile
@@ -2,7 +2,7 @@
 # K8 systems. ACPI is preferred to all other hardware-specific drivers.
 # speedstep-* is preferred over p4-clockmod.
 
-obj-$(CONFIG_X86_POWERNOW_K8)		+= powernow-k8.o mperf.o
+obj-$(CONFIG_X86_POWERNOW_K8)		+= powernow-k8.o
 obj-$(CONFIG_X86_ACPI_CPUFREQ)		+= acpi-cpufreq.o mperf.o
 obj-$(CONFIG_X86_PCC_CPUFREQ)		+= pcc-cpufreq.o
 obj-$(CONFIG_X86_POWERNOW_K6)		+= powernow-k6.o
diff --git a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c b/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
index 619733e..2066bd5 100644
--- a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
+++ b/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
@@ -45,19 +45,12 @@
 #define PFX "powernow-k8: "
 #define VERSION "version 2.20.00"
 #include "powernow-k8.h"
-#include "mperf.h"
 
 /* serialize freq changes  */
 static DEFINE_MUTEX(fidvid_mutex);
 
 static DEFINE_PER_CPU(struct powernow_k8_data *, powernow_data);
 
-static int cpu_family = CPU_OPTERON;
-
-/* core performance boost */
-static bool cpb_capable, cpb_enabled;
-static struct msr __percpu *msrs;
-
 static struct cpufreq_driver cpufreq_amd64_driver;
 
 #ifndef CONFIG_SMP
@@ -79,12 +72,6 @@ static u32 find_khz_freq_from_fid(u32 fid)
 	return 1000 * find_freq_from_fid(fid);
 }
 
-static u32 find_khz_freq_from_pstate(struct cpufreq_frequency_table *data,
-		u32 pstate)
-{
-	return data[pstate].frequency;
-}
-
 /* Return the vco fid for an input fid
  *
  * Each "low" fid has corresponding "high" fid, and you can get to "low" fids
@@ -107,9 +94,6 @@ static int pending_bit_stuck(void)
 {
 	u32 lo, hi;
 
-	if (cpu_family == CPU_HW_PSTATE)
-		return 0;
-
 	rdmsr(MSR_FIDVID_STATUS, lo, hi);
 	return lo & MSR_S_LO_CHANGE_PENDING ? 1 : 0;
 }
@@ -123,20 +107,6 @@ static int query_current_values_with_pending_wait(struct powernow_k8_data *data)
 	u32 lo, hi;
 	u32 i = 0;
 
-	if (cpu_family == CPU_HW_PSTATE) {
-		rdmsr(MSR_PSTATE_STATUS, lo, hi);
-		i = lo & HW_PSTATE_MASK;
-		data->currpstate = i;
-
-		/*
-		 * a workaround for family 11h erratum 311 might cause
-		 * an "out-of-range Pstate if the core is in Pstate-0
-		 */
-		if ((boot_cpu_data.x86 == 0x11) && (i >= data->numps))
-			data->currpstate = HW_PSTATE_0;
-
-		return 0;
-	}
 	do {
 		if (i++ > 10000) {
 			dprintk("detected change pending stuck\n");
@@ -293,14 +263,6 @@ static int decrease_vid_code_by_step(struct powernow_k8_data *data,
 	return 0;
 }
 
-/* Change hardware pstate by single MSR write */
-static int transition_pstate(struct powernow_k8_data *data, u32 pstate)
-{
-	wrmsr(MSR_PSTATE_CTRL, pstate, 0);
-	data->currpstate = pstate;
-	return 0;
-}
-
 /* Change Opteron/Athlon64 fid and vid, by the 3 phases. */
 static int transition_fid_vid(struct powernow_k8_data *data,
 		u32 reqfid, u32 reqvid)
@@ -551,15 +513,8 @@ static void check_supported_cpu(void *_rc)
 				"Power state transitions not supported\n");
 			return;
 		}
-	} else { /* must be a HW Pstate capable processor */
-		cpuid(CPUID_FREQ_VOLT_CAPABILITIES, &eax, &ebx, &ecx, &edx);
-		if ((edx & USE_HW_PSTATE) == USE_HW_PSTATE)
-			cpu_family = CPU_HW_PSTATE;
-		else
-			return;
+		*rc = 0;
 	}
-
-	*rc = 0;
 }
 
 static int check_pst_table(struct powernow_k8_data *data, struct pst_s *pst,
@@ -623,18 +578,11 @@ static void print_basics(struct powernow_k8_data *data)
 	for (j = 0; j < data->numps; j++) {
 		if (data->powernow_table[j].frequency !=
 				CPUFREQ_ENTRY_INVALID) {
-			if (cpu_family == CPU_HW_PSTATE) {
-				printk(KERN_INFO PFX
-					"   %d : pstate %d (%d MHz)\n", j,
-					data->powernow_table[j].index,
-					data->powernow_table[j].frequency/1000);
-			} else {
 				printk(KERN_INFO PFX
 					"fid 0x%x (%d MHz), vid 0x%x\n",
 					data->powernow_table[j].index & 0xff,
 					data->powernow_table[j].frequency/1000,
 					data->powernow_table[j].index >> 8);
-			}
 		}
 	}
 	if (data->batps)
@@ -642,20 +590,6 @@ static void print_basics(struct powernow_k8_data *data)
 				data->batps);
 }
 
-static u32 freq_from_fid_did(u32 fid, u32 did)
-{
-	u32 mhz = 0;
-
-	if (boot_cpu_data.x86 == 0x10)
-		mhz = (100 * (fid + 0x10)) >> did;
-	else if (boot_cpu_data.x86 == 0x11)
-		mhz = (100 * (fid + 8)) >> did;
-	else
-		BUG();
-
-	return mhz * 1000;
-}
-
 static int fill_powernow_table(struct powernow_k8_data *data,
 		struct pst_s *pst, u8 maxvid)
 {
@@ -815,7 +749,7 @@ static void powernow_k8_acpi_pst_values(struct powernow_k8_data *data,
 {
 	u64 control;
 
-	if (!data->acpi_data.state_count || (cpu_family == CPU_HW_PSTATE))
+	if (!data->acpi_data.state_count)
 		return;
 
 	control = data->acpi_data.states[index].control;
@@ -866,10 +800,7 @@ static int powernow_k8_cpu_init_acpi(struct powernow_k8_data *data)
 	data->numps = data->acpi_data.state_count;
 	powernow_k8_acpi_pst_values(data, 0);
 
-	if (cpu_family == CPU_HW_PSTATE)
-		ret_val = fill_powernow_table_pstate(data, powernow_table);
-	else
-		ret_val = fill_powernow_table_fidvid(data, powernow_table);
+	ret_val = fill_powernow_table_fidvid(data, powernow_table);
 	if (ret_val)
 		goto err_out_mem;
 
@@ -906,47 +837,6 @@ err_out:
 	return ret_val;
 }
 
-static int fill_powernow_table_pstate(struct powernow_k8_data *data,
-		struct cpufreq_frequency_table *powernow_table)
-{
-	int i;
-	u32 hi = 0, lo = 0;
-	rdmsr(MSR_PSTATE_CUR_LIMIT, lo, hi);
-	data->max_hw_pstate = (lo & HW_PSTATE_MAX_MASK) >> HW_PSTATE_MAX_SHIFT;
-
-	for (i = 0; i < data->acpi_data.state_count; i++) {
-		u32 index;
-
-		index = data->acpi_data.states[i].control & HW_PSTATE_MASK;
-		if (index > data->max_hw_pstate) {
-			printk(KERN_ERR PFX "invalid pstate %d - "
-					"bad value %d.\n", i, index);
-			printk(KERN_ERR PFX "Please report to BIOS "
-					"manufacturer\n");
-			invalidate_entry(powernow_table, i);
-			continue;
-		}
-		rdmsr(MSR_PSTATE_DEF_BASE + index, lo, hi);
-		if (!(hi & HW_PSTATE_VALID_MASK)) {
-			dprintk("invalid pstate %d, ignoring\n", index);
-			invalidate_entry(powernow_table, i);
-			continue;
-		}
-
-		powernow_table[i].index = index;
-
-		/* Frequency may be rounded for these */
-		if ((boot_cpu_data.x86 == 0x10 && boot_cpu_data.x86_model < 10)
-				 || boot_cpu_data.x86 == 0x11) {
-			powernow_table[i].frequency =
-				freq_from_fid_did(lo & 0x3f, (lo >> 6) & 7);
-		} else
-			powernow_table[i].frequency =
-				data->acpi_data.states[i].core_frequency * 1000;
-	}
-	return 0;
-}
-
 static int fill_powernow_table_fidvid(struct powernow_k8_data *data,
 		struct cpufreq_frequency_table *powernow_table)
 {
@@ -1023,15 +913,8 @@ static int get_transition_latency(struct powernow_k8_data *data)
 			max_latency = cur_latency;
 	}
 	if (max_latency == 0) {
-		/*
-		 * Fam 11h and later may return 0 as transition latency. This
-		 * is intended and means "very fast". While cpufreq core and
-		 * governors currently can handle that gracefully, better set it
-		 * to 1 to avoid problems in the future.
-		 */
-		if (boot_cpu_data.x86 < 0x11)
-			printk(KERN_ERR FW_WARN PFX "Invalid zero transition "
-				"latency\n");
+		printk(KERN_ERR FW_WARN PFX "Invalid zero transition "
+		       "latency\n");
 		max_latency = 1;
 	}
 	/* value in usecs, needs to be in nanoseconds */
@@ -1088,39 +971,6 @@ static int transition_frequency_fidvid(struct powernow_k8_data *data,
 	return res;
 }
 
-/* Take a frequency, and issue the hardware pstate transition command */
-static int transition_frequency_pstate(struct powernow_k8_data *data,
-		unsigned int index)
-{
-	u32 pstate = 0;
-	int res, i;
-	struct cpufreq_freqs freqs;
-
-	dprintk("cpu %d transition to index %u\n", smp_processor_id(), index);
-
-	/* get MSR index for hardware pstate transition */
-	pstate = index & HW_PSTATE_MASK;
-	if (pstate > data->max_hw_pstate)
-		return 0;
-	freqs.old = find_khz_freq_from_pstate(data->powernow_table,
-			data->currpstate);
-	freqs.new = find_khz_freq_from_pstate(data->powernow_table, pstate);
-
-	for_each_cpu(i, data->available_cores) {
-		freqs.cpu = i;
-		cpufreq_notify_transition(&freqs, CPUFREQ_PRECHANGE);
-	}
-
-	res = transition_pstate(data, pstate);
-	freqs.new = find_khz_freq_from_pstate(data->powernow_table, pstate);
-
-	for_each_cpu(i, data->available_cores) {
-		freqs.cpu = i;
-		cpufreq_notify_transition(&freqs, CPUFREQ_POSTCHANGE);
-	}
-	return res;
-}
-
 /* Driver entry point to switch to the target frequency */
 static int powernowk8_target(struct cpufreq_policy *pol,
 		unsigned targfreq, unsigned relation)
@@ -1162,18 +1012,16 @@ static int powernowk8_target(struct cpufreq_policy *pol,
 	if (query_current_values_with_pending_wait(data))
 		goto err_out;
 
-	if (cpu_family != CPU_HW_PSTATE) {
-		dprintk("targ: curr fid 0x%x, vid 0x%x\n",
+	dprintk("targ: curr fid 0x%x, vid 0x%x\n",
 		data->currfid, data->currvid);
 
-		if ((checkvid != data->currvid) ||
-		    (checkfid != data->currfid)) {
-			printk(KERN_INFO PFX
-				"error - out of sync, fix 0x%x 0x%x, "
-				"vid 0x%x 0x%x\n",
-				checkfid, data->currfid,
-				checkvid, data->currvid);
-		}
+	if ((checkvid != data->currvid) ||
+	    (checkfid != data->currfid)) {
+		printk(KERN_INFO PFX
+		       "error - out of sync, fix 0x%x 0x%x, "
+		       "vid 0x%x 0x%x\n",
+		       checkfid, data->currfid,
+		       checkvid, data->currvid);
 	}
 
 	if (cpufreq_frequency_table_target(pol, data->powernow_table,
@@ -1184,10 +1032,8 @@ static int powernowk8_target(struct cpufreq_policy *pol,
 
 	powernow_k8_acpi_pst_values(data, newstate);
 
-	if (cpu_family == CPU_HW_PSTATE)
-		ret = transition_frequency_pstate(data, newstate);
-	else
-		ret = transition_frequency_fidvid(data, newstate);
+	ret = transition_frequency_fidvid(data, newstate);
+
 	if (ret) {
 		printk(KERN_ERR PFX "transition frequency failed\n");
 		ret = 1;
@@ -1196,11 +1042,7 @@ static int powernowk8_target(struct cpufreq_policy *pol,
 	}
 	mutex_unlock(&fidvid_mutex);
 
-	if (cpu_family == CPU_HW_PSTATE)
-		pol->cur = find_khz_freq_from_pstate(data->powernow_table,
-				newstate);
-	else
-		pol->cur = find_khz_freq_from_fid(data->currfid);
+	pol->cur = find_khz_freq_from_fid(data->currfid);
 	ret = 0;
 
 err_out:
@@ -1240,8 +1082,7 @@ static void __cpuinit powernowk8_cpu_init_on_cpu(void *_init_on_cpu)
 		return;
 	}
 
-	if (cpu_family == CPU_OPTERON)
-		fidvid_msr_init();
+	fidvid_msr_init();
 
 	init_on_cpu->rc = 0;
 }
@@ -1271,7 +1112,6 @@ static int __cpuinit powernowk8_cpu_init(struct cpufreq_policy *pol)
 	}
 
 	data->cpu = pol->cpu;
-	data->currpstate = HW_PSTATE_INVALID;
 
 	if (powernow_k8_cpu_init_acpi(data)) {
 		/*
@@ -1308,17 +1148,10 @@ static int __cpuinit powernowk8_cpu_init(struct cpufreq_policy *pol)
 	if (rc != 0)
 		goto err_out_exit_acpi;
 
-	if (cpu_family == CPU_HW_PSTATE)
-		cpumask_copy(pol->cpus, cpumask_of(pol->cpu));
-	else
-		cpumask_copy(pol->cpus, cpu_core_mask(pol->cpu));
+	cpumask_copy(pol->cpus, cpu_core_mask(pol->cpu));
 	data->available_cores = pol->cpus;
 
-	if (cpu_family == CPU_HW_PSTATE)
-		pol->cur = find_khz_freq_from_pstate(data->powernow_table,
-				data->currpstate);
-	else
-		pol->cur = find_khz_freq_from_fid(data->currfid);
+	pol->cur = find_khz_freq_from_fid(data->currfid);
 	dprintk("policy current frequency %d kHz\n", pol->cur);
 
 	/* min/max the cpu is capable of */
@@ -1330,18 +1163,10 @@ static int __cpuinit powernowk8_cpu_init(struct cpufreq_policy *pol)
 		return -EINVAL;
 	}
 
-	/* Check for APERF/MPERF support in hardware */
-	if (cpu_has(c, X86_FEATURE_APERFMPERF))
-		cpufreq_amd64_driver.getavg = cpufreq_get_measured_perf;
-
 	cpufreq_frequency_table_get_attr(data->powernow_table, pol->cpu);
 
-	if (cpu_family == CPU_HW_PSTATE)
-		dprintk("cpu_init done, current pstate 0x%x\n",
-				data->currpstate);
-	else
-		dprintk("cpu_init done, current fid 0x%x, vid 0x%x\n",
-			data->currfid, data->currvid);
+	dprintk("cpu_init done, current fid 0x%x, vid 0x%x\n",
+		data->currfid, data->currvid);
 
 	per_cpu(powernow_data, pol->cpu) = data;
 
@@ -1394,88 +1219,15 @@ static unsigned int powernowk8_get(unsigned int cpu)
 	if (err)
 		goto out;
 
-	if (cpu_family == CPU_HW_PSTATE)
-		khz = find_khz_freq_from_pstate(data->powernow_table,
-						data->currpstate);
-	else
-		khz = find_khz_freq_from_fid(data->currfid);
+	khz = find_khz_freq_from_fid(data->currfid);
 
 
 out:
 	return khz;
 }
 
-static void _cpb_toggle_msrs(bool t)
-{
-	int cpu;
-
-	get_online_cpus();
-
-	rdmsr_on_cpus(cpu_online_mask, MSR_K7_HWCR, msrs);
-
-	for_each_cpu(cpu, cpu_online_mask) {
-		struct msr *reg = per_cpu_ptr(msrs, cpu);
-		if (t)
-			reg->l &= ~BIT(25);
-		else
-			reg->l |= BIT(25);
-	}
-	wrmsr_on_cpus(cpu_online_mask, MSR_K7_HWCR, msrs);
-
-	put_online_cpus();
-}
-
-/*
- * Switch on/off core performance boosting.
- *
- * 0=disable
- * 1=enable.
- */
-static void cpb_toggle(bool t)
-{
-	if (!cpb_capable)
-		return;
-
-	if (t && !cpb_enabled) {
-		cpb_enabled = true;
-		_cpb_toggle_msrs(t);
-		printk(KERN_INFO PFX "Core Boosting enabled.\n");
-	} else if (!t && cpb_enabled) {
-		cpb_enabled = false;
-		_cpb_toggle_msrs(t);
-		printk(KERN_INFO PFX "Core Boosting disabled.\n");
-	}
-}
-
-static ssize_t store_cpb(struct cpufreq_policy *policy, const char *buf,
-				 size_t count)
-{
-	int ret = -EINVAL;
-	unsigned long val = 0;
-
-	ret = strict_strtoul(buf, 10, &val);
-	if (!ret && (val == 0 || val == 1) && cpb_capable)
-		cpb_toggle(val);
-	else
-		return -EINVAL;
-
-	return count;
-}
-
-static ssize_t show_cpb(struct cpufreq_policy *policy, char *buf)
-{
-	return sprintf(buf, "%u\n", cpb_enabled);
-}
-
-#define define_one_rw(_name) \
-static struct freq_attr _name = \
-__ATTR(_name, 0644, show_##_name, store_##_name)
-
-define_one_rw(cpb);
-
 static struct freq_attr *powernow_k8_attr[] = {
 	&cpufreq_freq_attr_scaling_available_freqs,
-	&cpb,
 	NULL,
 };
 
@@ -1491,51 +1243,10 @@ static struct cpufreq_driver cpufreq_amd64_driver = {
 	.attr		= powernow_k8_attr,
 };
 
-/*
- * Clear the boost-disable flag on the CPU_DOWN path so that this cpu
- * cannot block the remaining ones from boosting. On the CPU_UP path we
- * simply keep the boost-disable flag in sync with the current global
- * state.
- */
-static int cpb_notify(struct notifier_block *nb, unsigned long action,
-		      void *hcpu)
-{
-	unsigned cpu = (long)hcpu;
-	u32 lo, hi;
-
-	switch (action) {
-	case CPU_UP_PREPARE:
-	case CPU_UP_PREPARE_FROZEN:
-
-		if (!cpb_enabled) {
-			rdmsr_on_cpu(cpu, MSR_K7_HWCR, &lo, &hi);
-			lo |= BIT(25);
-			wrmsr_on_cpu(cpu, MSR_K7_HWCR, lo, hi);
-		}
-		break;
-
-	case CPU_DOWN_PREPARE:
-	case CPU_DOWN_PREPARE_FROZEN:
-		rdmsr_on_cpu(cpu, MSR_K7_HWCR, &lo, &hi);
-		lo &= ~BIT(25);
-		wrmsr_on_cpu(cpu, MSR_K7_HWCR, lo, hi);
-		break;
-
-	default:
-		break;
-	}
-
-	return NOTIFY_OK;
-}
-
-static struct notifier_block cpb_nb = {
-	.notifier_call		= cpb_notify,
-};
-
 /* driver entry point for init */
 static int __cpuinit powernowk8_init(void)
 {
-	unsigned int i, supported_cpus = 0, cpu;
+	unsigned int i, supported_cpus = 0;
 	int rv;
 
 	request_module("acpi_cpufreq");
@@ -1553,35 +1264,8 @@ static int __cpuinit powernowk8_init(void)
 	printk(KERN_INFO PFX "Found %d %s (%d cpu cores) (" VERSION ")\n",
 		num_online_nodes(), boot_cpu_data.x86_model_id, supported_cpus);
 
-	if (boot_cpu_has(X86_FEATURE_CPB)) {
-
-		cpb_capable = true;
-
-		msrs = msrs_alloc();
-		if (!msrs) {
-			printk(KERN_ERR "%s: Error allocating msrs!\n", __func__);
-			return -ENOMEM;
-		}
-
-		register_cpu_notifier(&cpb_nb);
-
-		rdmsr_on_cpus(cpu_online_mask, MSR_K7_HWCR, msrs);
-
-		for_each_cpu(cpu, cpu_online_mask) {
-			struct msr *reg = per_cpu_ptr(msrs, cpu);
-			cpb_enabled |= !(!!(reg->l & BIT(25)));
-		}
-
-		printk(KERN_INFO PFX "Core Performance Boosting: %s.\n",
-			(cpb_enabled ? "on" : "off"));
-	}
-
 	rv = cpufreq_register_driver(&cpufreq_amd64_driver);
-	if (rv < 0 && boot_cpu_has(X86_FEATURE_CPB)) {
-		unregister_cpu_notifier(&cpb_nb);
-		msrs_free(msrs);
-		msrs = NULL;
-	}
+
 	return rv;
 }
 
@@ -1590,13 +1274,6 @@ static void __exit powernowk8_exit(void)
 {
 	dprintk("exit\n");
 
-	if (boot_cpu_has(X86_FEATURE_CPB)) {
-		msrs_free(msrs);
-		msrs = NULL;
-
-		unregister_cpu_notifier(&cpb_nb);
-	}
-
 	cpufreq_unregister_driver(&cpufreq_amd64_driver);
 }
 
diff --git a/arch/x86/kernel/cpu/cpufreq/powernow-k8.h b/arch/x86/kernel/cpu/cpufreq/powernow-k8.h
index df3529b..4e53123 100644
--- a/arch/x86/kernel/cpu/cpufreq/powernow-k8.h
+++ b/arch/x86/kernel/cpu/cpufreq/powernow-k8.h
@@ -5,24 +5,11 @@
  *  http://www.gnu.org/licenses/gpl.html
  */
 
-enum pstate {
-	HW_PSTATE_INVALID = 0xff,
-	HW_PSTATE_0 = 0,
-	HW_PSTATE_1 = 1,
-	HW_PSTATE_2 = 2,
-	HW_PSTATE_3 = 3,
-	HW_PSTATE_4 = 4,
-	HW_PSTATE_5 = 5,
-	HW_PSTATE_6 = 6,
-	HW_PSTATE_7 = 7,
-};
-
 struct powernow_k8_data {
 	unsigned int cpu;
 
 	u32 numps;  /* number of p-states */
 	u32 batps;  /* number of p-states supported on battery */
-	u32 max_hw_pstate; /* maximum legal hardware pstate */
 
 	/* these values are constant when the PSB is used to determine
 	 * vid/fid pairings, but are modified during the ->target() call
@@ -37,7 +24,6 @@ struct powernow_k8_data {
 	/* keep track of the current fid / vid or pstate */
 	u32 currvid;
 	u32 currfid;
-	enum pstate currpstate;
 
 	/* the powernow_table includes all frequency and vid/fid pairings:
 	 * fid are the lower 8 bits of the index, vid are the upper 8 bits.
@@ -97,23 +83,6 @@ struct powernow_k8_data {
 #define MSR_S_HI_CURRENT_VID      0x0000003f
 #define MSR_C_HI_STP_GNT_BENIGN	  0x00000001
 
-
-/* Hardware Pstate _PSS and MSR definitions */
-#define USE_HW_PSTATE		0x00000080
-#define HW_PSTATE_MASK 		0x00000007
-#define HW_PSTATE_VALID_MASK 	0x80000000
-#define HW_PSTATE_MAX_MASK	0x000000f0
-#define HW_PSTATE_MAX_SHIFT	4
-#define MSR_PSTATE_DEF_BASE 	0xc0010064 /* base of Pstate MSRs */
-#define MSR_PSTATE_STATUS 	0xc0010063 /* Pstate Status MSR */
-#define MSR_PSTATE_CTRL 	0xc0010062 /* Pstate control MSR */
-#define MSR_PSTATE_CUR_LIMIT	0xc0010061 /* pstate current limit MSR */
-
-/* define the two driver architectures */
-#define CPU_OPTERON 0
-#define CPU_HW_PSTATE 1
-
-
 /*
  * There are restrictions frequencies have to follow:
  * - only 1 entry in the low fid table ( <=1.4GHz )
@@ -220,5 +189,4 @@ static int core_frequency_transition(struct powernow_k8_data *data, u32 reqfid);
 
 static void powernow_k8_acpi_pst_values(struct powernow_k8_data *data, unsigned int index);
 
-static int fill_powernow_table_pstate(struct powernow_k8_data *data, struct cpufreq_frequency_table *powernow_table);
 static int fill_powernow_table_fidvid(struct powernow_k8_data *data, struct cpufreq_frequency_table *powernow_table);
-- 
1.7.5

