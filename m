Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755825Ab0CVSim (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 14:38:42 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:45217 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754928Ab0CVSiT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 14:38:19 -0400
From: Borislav Petkov <bp@amd64.org>
To: <akpm@linux-foundation.org>, davej@redhat.com
Cc: cpufreq@vger.kernel.org, <x86@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/5] cpufreq: Add APERF/MPERF support for AMD processors
Date: Mon, 22 Mar 2010 19:38:39 +0100
Message-Id: <1269283121-11894-4-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.0.2
In-Reply-To: <1269283121-11894-1-git-send-email-bp@amd64.org>
References: <1269283121-11894-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Langsdorf <mark.langsdorf@amd.com>

Starting with model 10 of Family 0x10, AMD processors may have
support for APERF/MPERF.  Add support for identifying it and using
it within cpufreq.  Move the APERF/MPERF functions out of the
acpi-cpufreq code and into their own file so they can easily be
shared.

Signed-off-by: Mark Langsdorf <mark.langsdorf@amd.com>
Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 arch/x86/kernel/cpu/amd.c                  |    6 +++
 arch/x86/kernel/cpu/cpufreq/Makefile       |    4 +-
 arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c |   44 +-----------------------
 arch/x86/kernel/cpu/cpufreq/mperf.c        |   50 ++++++++++++++++++++++++++++
 arch/x86/kernel/cpu/cpufreq/mperf.h        |    9 +++++
 arch/x86/kernel/cpu/cpufreq/powernow-k8.c  |    8 ++++
 6 files changed, 77 insertions(+), 44 deletions(-)
 create mode 100644 arch/x86/kernel/cpu/cpufreq/mperf.c
 create mode 100644 arch/x86/kernel/cpu/cpufreq/mperf.h

diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index e485825..796f662 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -537,6 +537,12 @@ static void __cpuinit init_amd(struct cpuinfo_x86 *c)
 		set_cpu_cap(c, X86_FEATURE_MFENCE_RDTSC);
 	}
 
+	if (c->cpuid_level >= 6) {
+		unsigned ecx = cpuid_ecx(6);
+		if (ecx & 0x01)
+			set_cpu_cap(c, X86_FEATURE_APERFMPERF);
+	}
+
 #ifdef CONFIG_X86_64
 	if (c->x86 == 0x10) {
 		/* do this for boot cpu */
diff --git a/arch/x86/kernel/cpu/cpufreq/Makefile b/arch/x86/kernel/cpu/cpufreq/Makefile
index 1840c0a..bd54bf6 100644
--- a/arch/x86/kernel/cpu/cpufreq/Makefile
+++ b/arch/x86/kernel/cpu/cpufreq/Makefile
@@ -2,8 +2,8 @@
 # K8 systems. ACPI is preferred to all other hardware-specific drivers.
 # speedstep-* is preferred over p4-clockmod.
 
-obj-$(CONFIG_X86_POWERNOW_K8)		+= powernow-k8.o
-obj-$(CONFIG_X86_ACPI_CPUFREQ)		+= acpi-cpufreq.o
+obj-$(CONFIG_X86_POWERNOW_K8)		+= powernow-k8.o mperf.o
+obj-$(CONFIG_X86_ACPI_CPUFREQ)		+= acpi-cpufreq.o mperf.o
 obj-$(CONFIG_X86_PCC_CPUFREQ)		+= pcc-cpufreq.o
 obj-$(CONFIG_X86_POWERNOW_K6)		+= powernow-k6.o
 obj-$(CONFIG_X86_POWERNOW_K7)		+= powernow-k7.o
diff --git a/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c b/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
index 1b1920f..dc68e5c 100644
--- a/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
+++ b/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
@@ -45,6 +45,7 @@
 #include <asm/msr.h>
 #include <asm/processor.h>
 #include <asm/cpufeature.h>
+#include "mperf.h"
 
 #define dprintk(msg...) cpufreq_debug_printk(CPUFREQ_DEBUG_DRIVER, \
 		"acpi-cpufreq", msg)
@@ -70,8 +71,6 @@ struct acpi_cpufreq_data {
 
 static DEFINE_PER_CPU(struct acpi_cpufreq_data *, acfreq_data);
 
-static DEFINE_PER_CPU(struct aperfmperf, acfreq_old_perf);
-
 /* acpi_perf_data is a pointer to percpu data. */
 static struct acpi_processor_performance *acpi_perf_data;
 
@@ -239,45 +238,6 @@ static u32 get_cur_val(const struct cpumask *mask)
 	return cmd.val;
 }
 
-/* Called via smp_call_function_single(), on the target CPU */
-static void read_measured_perf_ctrs(void *_cur)
-{
-	struct aperfmperf *am = _cur;
-
-	get_aperfmperf(am);
-}
-
-/*
- * Return the measured active (C0) frequency on this CPU since last call
- * to this function.
- * Input: cpu number
- * Return: Average CPU frequency in terms of max frequency (zero on error)
- *
- * We use IA32_MPERF and IA32_APERF MSRs to get the measured performance
- * over a period of time, while CPU is in C0 state.
- * IA32_MPERF counts at the rate of max advertised frequency
- * IA32_APERF counts at the rate of actual CPU frequency
- * Only IA32_APERF/IA32_MPERF ratio is architecturally defined and
- * no meaning should be associated with absolute values of these MSRs.
- */
-static unsigned int get_measured_perf(struct cpufreq_policy *policy,
-				      unsigned int cpu)
-{
-	struct aperfmperf perf;
-	unsigned long ratio;
-	unsigned int retval;
-
-	if (smp_call_function_single(cpu, read_measured_perf_ctrs, &perf, 1))
-		return 0;
-
-	ratio = calc_aperfmperf_ratio(&per_cpu(acfreq_old_perf, cpu), &perf);
-	per_cpu(acfreq_old_perf, cpu) = perf;
-
-	retval = (policy->cpuinfo.max_freq * ratio) >> APERFMPERF_SHIFT;
-
-	return retval;
-}
-
 static unsigned int get_cur_freq_on_cpu(unsigned int cpu)
 {
 	struct acpi_cpufreq_data *data = per_cpu(acfreq_data, cpu);
@@ -701,7 +661,7 @@ static int acpi_cpufreq_cpu_init(struct cpufreq_policy *policy)
 
 	/* Check for APERF/MPERF support in hardware */
 	if (cpu_has(c, X86_FEATURE_APERFMPERF))
-		acpi_cpufreq_driver.getavg = get_measured_perf;
+		acpi_cpufreq_driver.getavg = cpufreq_get_measured_perf;
 
 	dprintk("CPU%u - ACPI performance management activated.\n", cpu);
 	for (i = 0; i < perf->state_count; i++)
diff --git a/arch/x86/kernel/cpu/cpufreq/mperf.c b/arch/x86/kernel/cpu/cpufreq/mperf.c
new file mode 100644
index 0000000..bc5a5df
--- /dev/null
+++ b/arch/x86/kernel/cpu/cpufreq/mperf.c
@@ -0,0 +1,50 @@
+#include <linux/kernel.h>
+#include <linux/smp.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/cpufreq.h>
+#include <linux/slab.h>
+
+#include "mperf.h"
+
+static DEFINE_PER_CPU(struct aperfmperf, acfreq_old_perf);
+
+/* Called via smp_call_function_single(), on the target CPU */
+static void read_measured_perf_ctrs(void *_cur)
+{
+	struct aperfmperf *am = _cur;
+
+	get_aperfmperf(am);
+}
+
+/*
+ * Return the measured active (C0) frequency on this CPU since last call
+ * to this function.
+ * Input: cpu number
+ * Return: Average CPU frequency in terms of max frequency (zero on error)
+ *
+ * We use IA32_MPERF and IA32_APERF MSRs to get the measured performance
+ * over a period of time, while CPU is in C0 state.
+ * IA32_MPERF counts at the rate of max advertised frequency
+ * IA32_APERF counts at the rate of actual CPU frequency
+ * Only IA32_APERF/IA32_MPERF ratio is architecturally defined and
+ * no meaning should be associated with absolute values of these MSRs.
+ */
+unsigned int cpufreq_get_measured_perf(struct cpufreq_policy *policy,
+					unsigned int cpu)
+{
+	struct aperfmperf perf;
+	unsigned long ratio;
+	unsigned int retval;
+
+	if (smp_call_function_single(cpu, read_measured_perf_ctrs, &perf, 1))
+		return 0;
+
+	ratio = calc_aperfmperf_ratio(&per_cpu(acfreq_old_perf, cpu), &perf);
+	per_cpu(acfreq_old_perf, cpu) = perf;
+
+	retval = (policy->cpuinfo.max_freq * ratio) >> APERFMPERF_SHIFT;
+
+	return retval;
+}
+EXPORT_SYMBOL_GPL(cpufreq_get_measured_perf);
diff --git a/arch/x86/kernel/cpu/cpufreq/mperf.h b/arch/x86/kernel/cpu/cpufreq/mperf.h
new file mode 100644
index 0000000..5dbf295
--- /dev/null
+++ b/arch/x86/kernel/cpu/cpufreq/mperf.h
@@ -0,0 +1,9 @@
+/*
+ *  (c) 2010 Advanced Micro Devices, Inc.
+ *  Your use of this code is subject to the terms and conditions of the
+ *  GNU general public license version 2. See "COPYING" or
+ *  http://www.gnu.org/licenses/gpl.html
+ */
+
+unsigned int cpufreq_get_measured_perf(struct cpufreq_policy *policy,
+					unsigned int cpu);
diff --git a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c b/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
index 90fda2c..427ef07 100644
--- a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
+++ b/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
@@ -45,6 +45,7 @@
 #define PFX "powernow-k8: "
 #define VERSION "version 2.20.00"
 #include "powernow-k8.h"
+#include "mperf.h"
 
 /* serialize freq changes  */
 static DEFINE_MUTEX(fidvid_mutex);
@@ -57,6 +58,8 @@ static int cpu_family = CPU_OPTERON;
 static bool cpb_capable, cpb_disabled;
 static struct msr __percpu *msrs;
 
+static struct cpufreq_driver cpufreq_amd64_driver;
+
 #ifndef CONFIG_SMP
 static inline const struct cpumask *cpu_core_mask(int cpu)
 {
@@ -1251,6 +1254,7 @@ static int __cpuinit powernowk8_cpu_init(struct cpufreq_policy *pol)
 	struct powernow_k8_data *data;
 	struct init_on_cpu init_on_cpu;
 	int rc;
+	struct cpuinfo_x86 *c = &cpu_data(pol->cpu);
 
 	if (!cpu_online(pol->cpu))
 		return -ENODEV;
@@ -1325,6 +1329,10 @@ static int __cpuinit powernowk8_cpu_init(struct cpufreq_policy *pol)
 		return -EINVAL;
 	}
 
+	/* Check for APERF/MPERF support in hardware */
+	if (cpu_has(c, X86_FEATURE_APERFMPERF))
+		cpufreq_amd64_driver.getavg = cpufreq_get_measured_perf;
+
 	cpufreq_frequency_table_get_attr(data->powernow_table, pol->cpu);
 
 	if (cpu_family == CPU_HW_PSTATE)
-- 
1.7.0

