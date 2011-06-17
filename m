Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933038Ab1FQTv1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 15:51:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3299 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932953Ab1FQTvU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 15:51:20 -0400
From: Matthew Garrett <mjg@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: borislav.petkov@amd.com, davej@redhat.com, mark.langsdorf@amd.com,
        cpufreq@vger.kernel.org, andreas.herrmann3@amd.com,
        Matthew Garrett <mjg@redhat.com>
Subject: [PATCH V2 3/6] acpi-cpufreq: Add support for disabling dynamic overclocking
Date: Fri, 17 Jun 2011 15:50:54 -0400
Message-Id: <1308340257-10117-3-git-send-email-mjg@redhat.com>
In-Reply-To: <1308340257-10117-1-git-send-email-mjg@redhat.com>
References: <1308340257-10117-1-git-send-email-mjg@redhat.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 2001:470:1f07:1371:8a9f:faff:fefa:2632
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
 drivers/cpufreq/acpi-cpufreq.c |  160 ++++++++++++++++++++++++++++++++++++++++
 1 files changed, 160 insertions(+), 0 deletions(-)

diff --git a/drivers/cpufreq/acpi-cpufreq.c b/drivers/cpufreq/acpi-cpufreq.c
index 298a947..8e6d89e 100644
--- a/drivers/cpufreq/acpi-cpufreq.c
+++ b/drivers/cpufreq/acpi-cpufreq.c
@@ -76,6 +76,86 @@ static struct acpi_processor_performance __percpu *acpi_perf_data;
 static struct cpufreq_driver acpi_cpufreq_driver;
 
 static unsigned int acpi_pstate_strict;
+static bool cpb_enabled, cpb_supported;
+static struct msr __percpu *msrs;
+
+static void _cpb_toggle_msrs(unsigned int cpu, bool t)
+{
+	struct acpi_cpufreq_data *data = per_cpu(acfreq_data, cpu);
+
+	get_online_cpus();
+
+	switch (data->cpu_feature) {
+	case SYSTEM_INTEL_MSR_CAPABLE:
+		rdmsr_on_cpus(cpu_online_mask, MSR_IA32_MISC_ENABLE, msrs);
+
+		for_each_cpu(cpu, cpu_online_mask) {
+			struct msr *reg = per_cpu_ptr(msrs, cpu);
+			if (t)
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
+			if (t)
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
+static void cpb_toggle(unsigned int cpu, bool t)
+{
+	if (t && !cpb_enabled) {
+		cpb_enabled = true;
+		_cpb_toggle_msrs(cpu, t);
+		pr_debug("Core Boosting enabled.\n");
+	} else if (!t && cpb_enabled) {
+		cpb_enabled = false;
+		_cpb_toggle_msrs(cpu, t);
+		pr_debug("Core Boosting disabled.\n");
+	}
+}
+
+static ssize_t store_cpb(struct cpufreq_policy *policy, const char *buf,
+			 size_t count)
+{
+	int ret = -EINVAL;
+	unsigned long val = 0;
+	unsigned int cpu = policy->cpu;
+
+	ret = strict_strtoul(buf, 10, &val);
+	if (!ret && (val == 0 || val == 1) && cpb_supported)
+		cpb_toggle(cpu, val);
+	else
+		return -EINVAL;
+
+	return count;
+}
+
+static ssize_t show_cpb(struct cpufreq_policy *policy, char *buf)
+{
+	return sprintf(buf, "%u\n", cpb_enabled);
+}
+
+#define define_one_rw(_name) \
+static struct freq_attr _name = \
+	__ATTR(_name, 0644, show_##_name, store_##_name)
+
+define_one_rw(cpb);
 
 static int check_est_cpu(unsigned int cpuid)
 {
@@ -446,6 +526,63 @@ static void free_acpi_perf_data(void)
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
@@ -666,6 +803,21 @@ static int acpi_cpufreq_cpu_init(struct cpufreq_policy *policy)
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
+		register_cpu_notifier(&cpb_nb);
+
+		cpb_toggle(0, true);
+	}
+
 	if (perf->states[0].core_frequency * 1000 != policy->cpuinfo.max_freq)
 		printk(KERN_WARNING FW_WARN "P-state 0 is not max freq\n");
 
@@ -749,6 +901,7 @@ static int acpi_cpufreq_resume(struct cpufreq_policy *policy)
 
 static struct freq_attr *acpi_cpufreq_attr[] = {
 	&cpufreq_freq_attr_scaling_available_freqs,
+	&cpb,
 	NULL,
 };
 
@@ -788,6 +941,13 @@ static void __exit acpi_cpufreq_exit(void)
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
 
 	free_percpu(acpi_perf_data);
-- 
1.7.5.2

