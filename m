Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933008Ab1FQTvW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 15:51:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52312 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757516Ab1FQTvT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 15:51:19 -0400
From: Matthew Garrett <mjg@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: borislav.petkov@amd.com, davej@redhat.com, mark.langsdorf@amd.com,
        cpufreq@vger.kernel.org, andreas.herrmann3@amd.com,
        Matthew Garrett <mjg@redhat.com>
Subject: [PATCH V2 2/6] acpi-cpufreq: Add support for modern AMD CPUs
Date: Fri, 17 Jun 2011 15:50:53 -0400
Message-Id: <1308340257-10117-2-git-send-email-mjg@redhat.com>
In-Reply-To: <1308340257-10117-1-git-send-email-mjg@redhat.com>
References: <1308340257-10117-1-git-send-email-mjg@redhat.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 2001:470:1f07:1371:8a9f:faff:fefa:2632
X-SA-Exim-Mail-From: mjg@redhat.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The programming model for P-states on modern AMD CPUs is very similar to
that of Intel and VIA. It makes sense to consolidate this support into one
driver rather than duplicating functionality between two of them. This
patch adds support for AMDs with hardware P-state control to acpi-cpufreq.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
---
 drivers/cpufreq/acpi-cpufreq.c |   43 ++++++++++++++++++++++++++++++++++-----
 1 files changed, 37 insertions(+), 6 deletions(-)

diff --git a/drivers/cpufreq/acpi-cpufreq.c b/drivers/cpufreq/acpi-cpufreq.c
index 4e04e12..298a947 100644
--- a/drivers/cpufreq/acpi-cpufreq.c
+++ b/drivers/cpufreq/acpi-cpufreq.c
@@ -54,10 +54,12 @@ MODULE_LICENSE("GPL");
 enum {
 	UNDEFINED_CAPABLE = 0,
 	SYSTEM_INTEL_MSR_CAPABLE,
+	SYSTEM_AMD_MSR_CAPABLE,
 	SYSTEM_IO_CAPABLE,
 };
 
 #define INTEL_MSR_RANGE		(0xffff)
+#define AMD_MSR_RANGE		(0x7)
 
 struct acpi_cpufreq_data {
 	struct acpi_processor_performance *acpi_data;
@@ -82,6 +84,13 @@ static int check_est_cpu(unsigned int cpuid)
 	return cpu_has(cpu, X86_FEATURE_EST);
 }
 
+static int check_amd_hwpstate_cpu(unsigned int cpuid)
+{
+	struct cpuinfo_x86 *cpu = &cpu_data(cpuid);
+
+	return cpu_has(cpu, X86_FEATURE_HW_PSTATE);
+}
+
 static unsigned extract_io(u32 value, struct acpi_cpufreq_data *data)
 {
 	struct acpi_processor_performance *perf;
@@ -101,7 +110,11 @@ static unsigned extract_msr(u32 msr, struct acpi_cpufreq_data *data)
 	int i;
 	struct acpi_processor_performance *perf;
 
-	msr &= INTEL_MSR_RANGE;
+	if (boot_cpu_data.x86_vendor == X86_VENDOR_AMD)
+		msr &= AMD_MSR_RANGE;
+	else
+		msr &= INTEL_MSR_RANGE;
+
 	perf = data->acpi_data;
 
 	for (i = 0; data->freq_table[i].frequency != CPUFREQ_TABLE_END; i++) {
@@ -115,6 +128,7 @@ static unsigned extract_freq(u32 val, struct acpi_cpufreq_data *data)
 {
 	switch (data->cpu_feature) {
 	case SYSTEM_INTEL_MSR_CAPABLE:
+	case SYSTEM_AMD_MSR_CAPABLE:
 		return extract_msr(val, data);
 	case SYSTEM_IO_CAPABLE:
 		return extract_io(val, data);
@@ -150,6 +164,7 @@ static void do_drv_read(void *_cmd)
 
 	switch (cmd->type) {
 	case SYSTEM_INTEL_MSR_CAPABLE:
+	case SYSTEM_AMD_MSR_CAPABLE:
 		rdmsr(cmd->addr.msr.reg, cmd->val, h);
 		break;
 	case SYSTEM_IO_CAPABLE:
@@ -174,6 +189,9 @@ static void do_drv_write(void *_cmd)
 		lo = (lo & ~INTEL_MSR_RANGE) | (cmd->val & INTEL_MSR_RANGE);
 		wrmsr(cmd->addr.msr.reg, lo, hi);
 		break;
+	case SYSTEM_AMD_MSR_CAPABLE:
+		wrmsr(cmd->addr.msr.reg, cmd->val, 0);
+		break;
 	case SYSTEM_IO_CAPABLE:
 		acpi_os_write_port((acpi_io_address)cmd->addr.io.port,
 				cmd->val,
@@ -217,6 +235,10 @@ static u32 get_cur_val(const struct cpumask *mask)
 		cmd.type = SYSTEM_INTEL_MSR_CAPABLE;
 		cmd.addr.msr.reg = MSR_IA32_PERF_STATUS;
 		break;
+	case SYSTEM_AMD_MSR_CAPABLE:
+		cmd.type = SYSTEM_AMD_MSR_CAPABLE;
+		cmd.addr.msr.reg = MSR_AMD_PERF_STATUS;
+		break;
 	case SYSTEM_IO_CAPABLE:
 		cmd.type = SYSTEM_IO_CAPABLE;
 		perf = per_cpu(acfreq_data, cpumask_first(mask))->acpi_data;
@@ -326,6 +348,11 @@ static int acpi_cpufreq_target(struct cpufreq_policy *policy,
 		cmd.addr.msr.reg = MSR_IA32_PERF_CTL;
 		cmd.val = (u32) perf->states[next_perf_state].control;
 		break;
+	case SYSTEM_AMD_MSR_CAPABLE:
+		cmd.type = SYSTEM_AMD_MSR_CAPABLE;
+		cmd.addr.msr.reg = MSR_AMD_PERF_CTL;
+		cmd.val = (u32) perf->states[next_perf_state].control;
+		break;
 	case SYSTEM_IO_CAPABLE:
 		cmd.type = SYSTEM_IO_CAPABLE;
 		cmd.addr.io.port = perf->control_register.address;
@@ -580,12 +607,16 @@ static int acpi_cpufreq_cpu_init(struct cpufreq_policy *policy)
 		break;
 	case ACPI_ADR_SPACE_FIXED_HARDWARE:
 		pr_debug("HARDWARE addr space\n");
-		if (!check_est_cpu(cpu)) {
-			result = -ENODEV;
-			goto err_unreg;
+		if (check_est_cpu(cpu)) {
+			data->cpu_feature = SYSTEM_INTEL_MSR_CAPABLE;
+			break;
 		}
-		data->cpu_feature = SYSTEM_INTEL_MSR_CAPABLE;
-		break;
+		if (check_amd_hwpstate_cpu(cpu)) {
+			data->cpu_feature = SYSTEM_AMD_MSR_CAPABLE;
+			break;
+		}
+		result = -ENODEV;
+		goto err_unreg;
 	default:
 		pr_debug("Unknown addr space %d\n",
 			(u32) (perf->control_register.space_id));
-- 
1.7.5.2

