Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753796Ab1GRQiY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 12:38:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5800 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752479Ab1GRQiT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 12:38:19 -0400
From: Matthew Garrett <mjg@redhat.com>
To: cpufreq@vger.kernel.org
Cc: davej@redhat.com, linux-kernel@vger.kernel.org, borislav.petkov@amd.com,
        mark.langsdorf@amd.com, andreas.herrmann3@amd.com,
        Matthew Garrett <mjg@redhat.com>
Subject: [PATCH v4 3/7] acpi-cpufreq: Add support for disabling dynamic overclocking
Date: Mon, 18 Jul 2011 12:37:38 -0400
Message-Id: <1311007062-2050-4-git-send-email-mjg@redhat.com>
In-Reply-To: <1311007062-2050-1-git-send-email-mjg@redhat.com>
References: <1311007062-2050-1-git-send-email-mjg@redhat.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 2001:470:1f07:1371:721a:4ff:fed2:9f6c
X-SA-Exim-Mail-From: mjg@redhat.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

One feature present in powernow-k8 that isn't present in acpi-cpufreq is
support for enabling or disabling AMD's core performance boost technology.
This patch adds that support to acpi-cpufreq, but also extends it to allow
Intel's dynamic acceleration to be disabled via the same interface. The
sysfs entry retains the cpb name for compatibility purposes.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
---
 drivers/cpufreq/acpi-cpufreq.c |  191 ++++++++++++++++++++++++++++++++++++++++
 1 files changed, 191 insertions(+), 0 deletions(-)

diff --git a/drivers/cpufreq/acpi-cpufreq.c b/drivers/cpufreq/acpi-cpufreq.c
index 298d451..0a92277 100644
--- a/drivers/cpufreq/acpi-cpufreq.c
+++ b/drivers/cpufreq/acpi-cpufreq.c
@@ -76,6 +76,107 @@ static struct acpi_processor_performance __percpu *acpi_perf_data;
 static struct cpufreq_driver acpi_cpufreq_driver;
 
 static unsigned int acpi_pstate_strict;
+static bool cpb_enabled, cpb_supported;
+static struct msr __percpu *msrs;
+
+static bool cpb_state(unsigned int cpu)
+{
+	struct acpi_cpufreq_data *data = per_cpu(acfreq_data, cpu);
+	u32 lo, hi;
+	u64 msr;
+
+	switch (data->cpu_feature) {
+	case SYSTEM_INTEL_MSR_CAPABLE:
+		rdmsr_on_cpu(cpu, MSR_IA32_MISC_ENABLE, &lo, &hi);
+		msr = lo | ((u64)hi << 32);
+		return !(msr & MSR_IA32_MISC_ENABLE_TURBO_DISABLE);
+	case SYSTEM_AMD_MSR_CAPABLE:
+		rdmsr_on_cpu(cpu, MSR_K7_HWCR, &lo, &hi);
+		msr = lo | ((u64)hi << 32);
+		return !(msr & BIT(25));
+	}
+	return false;
+}
+
+static void _cpb_toggle_msrs(bool enable)
+{
+	struct acpi_cpufreq_data *data = per_cpu(acfreq_data, 0);
+	u32 cpu;
+
+	get_online_cpus();
+
+	switch (data->cpu_feature) {
+	case SYSTEM_INTEL_MSR_CAPABLE:
+		rdmsr_on_cpus(cpu_online_mask, MSR_IA32_MISC_ENABLE, msrs);
+
+		for_each_cpu(cpu, cpu_online_mask) {
+			struct msr *reg = per_cpu_ptr(msrs, cpu);
+			if (enable)
+				reg->q &= ~MSR_IA32_MISC_ENABLE_TURBO_DISABLE;
+			else
+				reg->q |= MSR_IA32_MISC_ENABLE_TURBO_DISABLE;
+		}
+
+		wrmsr_on_cpus(cpu_online_mask, MSR_IA32_MISC_ENABLE, msrs);
+		break;
+	case SYSTEM_AMD_MSR_CAPABLE:
+		rdmsr_on_cpus(cpu_online_mask, MSR_K7_HWCR, msrs);
+
+		for_each_cpu(cpu, cpu_online_mask) {
+			struct msr *reg = per_cpu_ptr(msrs, cpu);
+			if (enable)
+				reg->l &= ~BIT(25);
+			else
+				reg->l |= BIT(25);
+		}
+
+		wrmsr_on_cpus(cpu_online_mask, MSR_K7_HWCR, msrs);
+		break;
+	}
+
+	put_online_cpus();
+}
+
+static void cpb_toggle(bool enable)
+{
+	if (enable && !cpb_enabled) {
+		cpb_enabled = true;
+		_cpb_toggle_msrs(enable);
+		pr_debug("Core Boosting enabled.\n");
+	} else if (!enable && cpb_enabled) {
+		cpb_enabled = false;
+		_cpb_toggle_msrs(enable);
+		pr_debug("Core Boosting disabled.\n");
+	}
+}
+
+static ssize_t store_cpb(struct cpufreq_policy *policy, const char *buf,
+			 size_t count)
+{
+	int ret = -EINVAL;
+	unsigned long val = 0;
+
+	ret = strict_strtoul(buf, 10, &val);
+	if (!ret && (val == 0 || val == 1) && cpb_supported)
+		cpb_toggle(val);
+	else
+		return -EINVAL;
+
+	return count;
+}
+
+static ssize_t show_cpb(struct cpufreq_policy *policy, char *buf)
+{
+	unsigned int cpu = policy->cpu;
+
+	return sprintf(buf, "%u\n", cpb_state(cpu));
+}
+
+#define define_one_rw(_name) \
+static struct freq_attr _name = \
+	__ATTR(_name, 0644, show_##_name, store_##_name)
+
+define_one_rw(cpb);
 
 static int check_est_cpu(unsigned int cpuid)
 {
@@ -446,6 +547,70 @@ static void free_acpi_perf_data(void)
 	free_percpu(acpi_perf_data);
 }
 
+static int cpb_notify(struct notifier_block *nb, unsigned long action,
+		      void *hcpu)
+{
+	unsigned cpu = (long)hcpu;
+	u32 lo, hi;
+	struct acpi_cpufreq_data *data = per_cpu(acfreq_data, cpu);
+	int msr;
+	u64 bit;
+
+	switch (data->cpu_feature) {
+	case SYSTEM_INTEL_MSR_CAPABLE:
+		msr = MSR_IA32_MISC_ENABLE;
+		bit = MSR_IA32_MISC_ENABLE_TURBO_DISABLE;
+		break;
+	case SYSTEM_AMD_MSR_CAPABLE:
+		msr = MSR_K7_HWCR;
+		bit = BIT(25);
+		break;
+	default:
+		return NOTIFY_OK;
+	}
+
+	/*
+	 * Clear the boost-disable flag on the CPU_DOWN path so that
+	 * this cpu cannot block the remaining ones from boosting. On
+	 * the CPU_UP path we simply keep the boost-disable flag in
+	 * sync with the current global state.
+	 */
+
+	switch (action) {
+	case CPU_UP_PREPARE:
+	case CPU_UP_PREPARE_FROZEN:
+		if (!cpb_enabled) {
+			rdmsr_on_cpu(cpu, msr, &lo, &hi);
+			if (bit < BIT(32))
+				lo |= bit;
+			else
+				hi |= (bit >> 32);
+			wrmsr_on_cpu(cpu, msr, lo, hi);
+		}
+		break;
+
+	case CPU_DOWN_PREPARE:
+	case CPU_DOWN_PREPARE_FROZEN:
+		rdmsr_on_cpu(cpu, msr, &lo, &hi);
+		if (bit < BIT(32))
+			lo &= ~bit;
+		else
+			hi &= ~(bit >> 32);
+		wrmsr_on_cpu(cpu, msr, lo, hi);
+		break;
+
+	default:
+		break;
+	}
+
+	return NOTIFY_OK;
+}
+
+
+static struct notifier_block cpb_nb = {
+	.notifier_call          = cpb_notify,
+};
+
 /*
  * acpi_cpufreq_early_init - initialize ACPI P-States library
  *
@@ -666,6 +831,24 @@ static int acpi_cpufreq_cpu_init(struct cpufreq_policy *policy)
 	if (result)
 		goto err_freqfree;
 
+	if (boot_cpu_has(X86_FEATURE_CPB) || boot_cpu_has(X86_FEATURE_IDA)) {
+		msrs = msrs_alloc();
+
+		if (!msrs) {
+			result = -ENOMEM;
+			goto err_freqfree;
+		}
+
+		cpb_supported = true;
+
+		cpb_enabled = cpb_state(0);
+
+		register_cpu_notifier(&cpb_nb);
+
+		/* Make sure all CPUs have the same state */
+		_cpb_toggle_msrs(cpb_enabled);
+	}
+
 	if (perf->states[0].core_frequency * 1000 != policy->cpuinfo.max_freq)
 		printk(KERN_WARNING FW_WARN "P-state 0 is not max freq\n");
 
@@ -749,6 +932,7 @@ static int acpi_cpufreq_resume(struct cpufreq_policy *policy)
 
 static struct freq_attr *acpi_cpufreq_attr[] = {
 	&cpufreq_freq_attr_scaling_available_freqs,
+	&cpb,
 	NULL,
 };
 
@@ -788,6 +972,13 @@ static void __exit acpi_cpufreq_exit(void)
 {
 	pr_debug("acpi_cpufreq_exit\n");
 
+	if (msrs) {
+		unregister_cpu_notifier(&cpb_nb);
+
+		msrs_free(msrs);
+		msrs = NULL;
+	}
+
 	cpufreq_unregister_driver(&acpi_cpufreq_driver);
 
 	free_acpi_perf_data();
-- 
1.7.6

