Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756437Ab2IDI1C (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 04:27:02 -0400
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:53749
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754316Ab2IDIZg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 04:25:36 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dh668h839hd24he5bhf0ah107ah1155h)
X-WSS-ID: 0M9TGQI-01-71K-02
X-M-MSG: 
From: Andre Przywara <andre.przywara@amd.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>, Thomas Renninger <trenn@suse.de>
CC: Matthew Garret <mjg@redhat.com>, <linux-pm@vger.kernel.org>,
        <cpufreq@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Andre Przywara <andre.przywara@amd.com>
Subject: [PATCH 1/8 v2] acpi-cpufreq: Add support for modern AMD CPUs
Date: Tue, 4 Sep 2012 10:28:02 +0200
Message-ID: <1346747289-8421-2-git-send-email-andre.przywara@amd.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1346747289-8421-1-git-send-email-andre.przywara@amd.com>
References: <1346747289-8421-1-git-send-email-andre.przywara@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matthew Garrett <mjg@redhat.com>

The programming model for P-states on modern AMD CPUs is very similar to
that of Intel and VIA. It makes sense to consolidate this support into one
driver rather than duplicating functionality between two of them. This
patch adds support for AMDs with hardware P-state control to acpi-cpufreq.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Andre Przywara <andre.przywara@amd.com>
---
 arch/x86/include/asm/msr-index.h |  2 ++
 drivers/cpufreq/Kconfig.x86      |  3 ++-
 drivers/cpufreq/acpi-cpufreq.c   | 43 ++++++++++++++++++++++++++++++++++------
 3 files changed, 41 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 957ec87..1e1f3eb 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -248,6 +248,8 @@
 
 #define MSR_IA32_PERF_STATUS		0x00000198
 #define MSR_IA32_PERF_CTL		0x00000199
+#define MSR_AMD_PERF_STATUS		0xc0010063
+#define MSR_AMD_PERF_CTL		0xc0010062
 
 #define MSR_IA32_MPERF			0x000000e7
 #define MSR_IA32_APERF			0x000000e8
diff --git a/drivers/cpufreq/Kconfig.x86 b/drivers/cpufreq/Kconfig.x86
index 78ff7ee..8d12e37 100644
--- a/drivers/cpufreq/Kconfig.x86
+++ b/drivers/cpufreq/Kconfig.x86
@@ -23,7 +23,8 @@ config X86_ACPI_CPUFREQ
 	help
 	  This driver adds a CPUFreq driver which utilizes the ACPI
 	  Processor Performance States.
-	  This driver also supports Intel Enhanced Speedstep.
+	  This driver also supports Intel Enhanced Speedstep and newer
+	  AMD CPUs.
 
 	  To compile this driver as a module, choose M here: the
 	  module will be called acpi-cpufreq.
diff --git a/drivers/cpufreq/acpi-cpufreq.c b/drivers/cpufreq/acpi-cpufreq.c
index 56c6c6b..067a61f 100644
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
1.7.12


