Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755954Ab1EQRDz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 13:03:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20327 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755529Ab1EQRDy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 13:03:54 -0400
From: Matthew Garrett <mjg@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: borislav.petkov@amd.com, davej@redhat.com, mark.langsdorf@amd.com,
        cpufreq@vger.kernel.org, Matthew Garrett <mjg@redhat.com>
Subject: [PATCH 1/5] acpi-cpufreq: Add support for modern AMD CPUs
Date: Tue, 17 May 2011 13:03:35 -0400
Message-Id: <1305651819-25660-1-git-send-email-mjg@redhat.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 209.6.41.104
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
 arch/x86/include/asm/cpufeature.h          |    1 +
 arch/x86/include/asm/msr-index.h           |    2 +
 arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c |   43 ++++++++++++++++++++++++----
 arch/x86/kernel/cpu/scattered.c            |    1 +
 4 files changed, 41 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index 91f3e087..fee7089 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -174,6 +174,7 @@
 #define X86_FEATURE_PLN		(7*32+ 5) /* Intel Power Limit Notification */
 #define X86_FEATURE_PTS		(7*32+ 6) /* Intel Package Thermal Status */
 #define X86_FEATURE_DTS		(7*32+ 7) /* Digital Thermal Sensor */
+#define X86_FEATURE_POWERNOW	(7*32+ 8) /* AMD frequency scaling */
 
 /* Virtualization flags: Linux defined, word 8 */
 #define X86_FEATURE_TPR_SHADOW  (8*32+ 0) /* Intel TPR Shadow */
diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 3cce714..d6f3e1f 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -233,6 +233,8 @@
 
 #define MSR_IA32_PERF_STATUS		0x00000198
 #define MSR_IA32_PERF_CTL		0x00000199
+#define MSR_AMD_PERF_STATUS		0xc0010063
+#define MSR_AMD_PERF_CTL		0xc0010062
 
 #define MSR_IA32_MPERF			0x000000e7
 #define MSR_IA32_APERF			0x000000e8
diff --git a/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c b/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
index a2baafb..f3dd3b1 100644
--- a/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
+++ b/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
@@ -57,10 +57,12 @@ MODULE_LICENSE("GPL");
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
@@ -85,6 +87,13 @@ static int check_est_cpu(unsigned int cpuid)
 	return cpu_has(cpu, X86_FEATURE_EST);
 }
 
+static int check_powernow_cpu(unsigned int cpuid)
+{
+	struct cpuinfo_x86 *cpu = &cpu_data(cpuid);
+
+	return cpu_has(cpu, X86_FEATURE_POWERNOW);
+}
+
 static unsigned extract_io(u32 value, struct acpi_cpufreq_data *data)
 {
 	struct acpi_processor_performance *perf;
@@ -104,7 +113,11 @@ static unsigned extract_msr(u32 msr, struct acpi_cpufreq_data *data)
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
@@ -118,6 +131,7 @@ static unsigned extract_freq(u32 val, struct acpi_cpufreq_data *data)
 {
 	switch (data->cpu_feature) {
 	case SYSTEM_INTEL_MSR_CAPABLE:
+	case SYSTEM_AMD_MSR_CAPABLE:
 		return extract_msr(val, data);
 	case SYSTEM_IO_CAPABLE:
 		return extract_io(val, data);
@@ -153,6 +167,7 @@ static void do_drv_read(void *_cmd)
 
 	switch (cmd->type) {
 	case SYSTEM_INTEL_MSR_CAPABLE:
+	case SYSTEM_AMD_MSR_CAPABLE:
 		rdmsr(cmd->addr.msr.reg, cmd->val, h);
 		break;
 	case SYSTEM_IO_CAPABLE:
@@ -177,6 +192,9 @@ static void do_drv_write(void *_cmd)
 		lo = (lo & ~INTEL_MSR_RANGE) | (cmd->val & INTEL_MSR_RANGE);
 		wrmsr(cmd->addr.msr.reg, lo, hi);
 		break;
+	case SYSTEM_AMD_MSR_CAPABLE:
+		wrmsr(cmd->addr.msr.reg, cmd->val, 0);
+		break;
 	case SYSTEM_IO_CAPABLE:
 		acpi_os_write_port((acpi_io_address)cmd->addr.io.port,
 				cmd->val,
@@ -220,6 +238,10 @@ static u32 get_cur_val(const struct cpumask *mask)
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
@@ -329,6 +351,11 @@ static int acpi_cpufreq_target(struct cpufreq_policy *policy,
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
@@ -583,12 +610,16 @@ static int acpi_cpufreq_cpu_init(struct cpufreq_policy *policy)
 		break;
 	case ACPI_ADR_SPACE_FIXED_HARDWARE:
 		dprintk("HARDWARE addr space\n");
-		if (!check_est_cpu(cpu)) {
-			result = -ENODEV;
-			goto err_unreg;
+		if (check_est_cpu(cpu)) {
+			data->cpu_feature = SYSTEM_INTEL_MSR_CAPABLE;
+			break;
 		}
-		data->cpu_feature = SYSTEM_INTEL_MSR_CAPABLE;
-		break;
+		if (check_powernow_cpu(cpu)) {
+			data->cpu_feature = SYSTEM_AMD_MSR_CAPABLE;
+			break;
+		}
+		result = -ENODEV;
+		goto err_unreg;
 	default:
 		dprintk("Unknown addr space %d\n",
 			(u32) (perf->control_register.space_id));
diff --git a/arch/x86/kernel/cpu/scattered.c b/arch/x86/kernel/cpu/scattered.c
index c7f64e6..d5086af 100644
--- a/arch/x86/kernel/cpu/scattered.c
+++ b/arch/x86/kernel/cpu/scattered.c
@@ -39,6 +39,7 @@ void __cpuinit init_scattered_cpuid_features(struct cpuinfo_x86 *c)
 		{ X86_FEATURE_APERFMPERF,	CR_ECX, 0, 0x00000006, 0 },
 		{ X86_FEATURE_EPB,		CR_ECX, 3, 0x00000006, 0 },
 		{ X86_FEATURE_XSAVEOPT,		CR_EAX,	0, 0x0000000d, 1 },
+		{ X86_FEATURE_POWERNOW,		CR_EDX, 7, 0x80000007, 0 },
 		{ X86_FEATURE_CPB,		CR_EDX, 9, 0x80000007, 0 },
 		{ X86_FEATURE_NPT,		CR_EDX, 0, 0x8000000a, 0 },
 		{ X86_FEATURE_LBRV,		CR_EDX, 1, 0x8000000a, 0 },
-- 
1.7.5

