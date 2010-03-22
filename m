Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755856Ab0CVSip (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 14:38:45 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:45215 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754971Ab0CVSiT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 14:38:19 -0400
From: Borislav Petkov <bp@amd64.org>
To: <akpm@linux-foundation.org>, davej@redhat.com
Cc: cpufreq@vger.kernel.org, <x86@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/5] powernow-k8: Add core performance boost support
Date: Mon, 22 Mar 2010 19:38:38 +0100
Message-Id: <1269283121-11894-3-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.0.2
In-Reply-To: <1269283121-11894-1-git-send-email-bp@amd64.org>
References: <1269283121-11894-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Starting with F10h, revE, AMD processors add support for a dynamic
core boosting feature called Core Performance Boost. When a specific
condition is present, a subset of the cores on a system are boosted
beyond their P0 operating frequency to speed up the performance of
single-threaded applications.

In the normal case, the system comes out of reset with core boosting
enabled. This patch adds a sysfs knob with which core boosting can be
switched on or off for benchmarking purposes.

While at it, cleanup the driver init codepath and update copyrights.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 arch/x86/kernel/cpu/cpufreq/powernow-k8.c |  115 ++++++++++++++++++++++++++---
 arch/x86/kernel/cpu/cpufreq/powernow-k8.h |    3 +-
 2 files changed, 106 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c b/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
index d360b56..90fda2c 100644
--- a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
+++ b/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
@@ -1,6 +1,5 @@
-
 /*
- *   (c) 2003-2006 Advanced Micro Devices, Inc.
+ *   (c) 2003-2010 Advanced Micro Devices, Inc.
  *  Your use of this code is subject to the terms and conditions of the
  *  GNU general public license version 2. See "COPYING" or
  *  http://www.gnu.org/licenses/gpl.html
@@ -54,6 +53,10 @@ static DEFINE_PER_CPU(struct powernow_k8_data *, powernow_data);
 
 static int cpu_family = CPU_OPTERON;
 
+/* core performance boost */
+static bool cpb_capable, cpb_disabled;
+static struct msr __percpu *msrs;
+
 #ifndef CONFIG_SMP
 static inline const struct cpumask *cpu_core_mask(int cpu)
 {
@@ -1393,8 +1396,69 @@ out:
 	return khz;
 }
 
+static void _cpb_toggle_msrs(bool t)
+{
+	int cpu;
+
+	rdmsr_on_cpus(cpu_online_mask, MSR_K7_HWCR, msrs);
+
+	for_each_cpu(cpu, cpu_online_mask) {
+		struct msr *reg = per_cpu_ptr(msrs, cpu);
+		if (t)
+			reg->l &= ~BIT(25);
+		else
+			reg->l |= BIT(25);
+	}
+	wrmsr_on_cpus(cpu_online_mask, MSR_K7_HWCR, msrs);
+}
+
+/*
+ * Switch on/off core performance boosting.
+ *
+ * 0=disable
+ * 1=enable.
+ */
+static void cpb_toggle(bool t)
+{
+	if (!cpb_capable)
+		return;
+
+	if (t && cpb_disabled) {
+		cpb_disabled = false;
+		_cpb_toggle_msrs(t);
+		printk(KERN_INFO PFX "Core Boosting enabled.\n");
+	} else if (!(t || cpb_disabled)) {
+		cpb_disabled = true;
+		_cpb_toggle_msrs(t);
+		printk(KERN_INFO PFX "Core Boosting disabled.\n");
+	}
+}
+
+static ssize_t store_cpb(struct cpufreq_policy *policy, const char *buf,
+				 size_t count)
+{
+	int ret = -EINVAL;
+	unsigned long val = 0;
+
+	ret = strict_strtoul(buf, 10, &val);
+	if (!ret && (val == 0 || val == 1) && cpb_capable)
+		cpb_toggle(val);
+	else
+		return -EINVAL;
+
+	return count;
+}
+
+static ssize_t show_cpb(struct cpufreq_policy *policy, char *buf)
+{
+	return sprintf(buf, "%u\n", !cpb_disabled);
+}
+
+define_one_freq_rw(cpb);
+
 static struct freq_attr *powernow_k8_attr[] = {
 	&cpufreq_freq_attr_scaling_available_freqs,
+	&cpb,
 	NULL,
 };
 
@@ -1410,10 +1474,17 @@ static struct cpufreq_driver cpufreq_amd64_driver = {
 	.attr		= powernow_k8_attr,
 };
 
+static bool __cpuinit check_cpb_capable(void)
+{
+	u32 tmp = cpuid_edx(CPUID_FREQ_VOLT_CAPABILITIES);
+
+	return (tmp & CPB_CAPABLE);
+}
+
 /* driver entry point for init */
 static int __cpuinit powernowk8_init(void)
 {
-	unsigned int i, supported_cpus = 0;
+	unsigned int i, supported_cpus = 0, cpu;
 
 	for_each_online_cpu(i) {
 		int rc;
@@ -1422,15 +1493,36 @@ static int __cpuinit powernowk8_init(void)
 			supported_cpus++;
 	}
 
-	if (supported_cpus == num_online_cpus()) {
-		printk(KERN_INFO PFX "Found %d %s "
-			"processors (%d cpu cores) (" VERSION ")\n",
-			num_online_nodes(),
-			boot_cpu_data.x86_model_id, supported_cpus);
-		return cpufreq_register_driver(&cpufreq_amd64_driver);
+	if (supported_cpus != num_online_cpus())
+		return -ENODEV;
+
+	printk(KERN_INFO PFX "Found %d %s (%d cpu cores) (" VERSION ")\n",
+		num_online_nodes(), boot_cpu_data.x86_model_id, supported_cpus);
+
+	cpb_capable = check_cpb_capable();
+	if (cpb_capable) {
+
+		msrs = msrs_alloc();
+		if (!msrs) {
+			printk(KERN_ERR "%s: Error allocating msrs!\n", __func__);
+			return -ENOMEM;
+		}
+
+		rdmsr_on_cpus(cpu_online_mask, MSR_K7_HWCR, msrs);
+
+		for_each_cpu(cpu, cpu_online_mask) {
+			struct msr *reg = per_cpu_ptr(msrs, cpu);
+			cpb_disabled |= !!(reg->l & BIT(25));
+		}
+
+		printk(KERN_INFO PFX "Core Performance Boosting: ");
+		if (cpb_disabled)
+			printk(KERN_CONT "off.\n");
+		else
+			printk(KERN_CONT "on.\n");
 	}
 
-	return -ENODEV;
+	return cpufreq_register_driver(&cpufreq_amd64_driver);
 }
 
 /* driver entry point for term */
@@ -1438,6 +1530,9 @@ static void __exit powernowk8_exit(void)
 {
 	dprintk("exit\n");
 
+	msrs_free(msrs);
+	msrs = NULL;
+
 	cpufreq_unregister_driver(&cpufreq_amd64_driver);
 }
 
diff --git a/arch/x86/kernel/cpu/cpufreq/powernow-k8.h b/arch/x86/kernel/cpu/cpufreq/powernow-k8.h
index 02ce824..3be308e 100644
--- a/arch/x86/kernel/cpu/cpufreq/powernow-k8.h
+++ b/arch/x86/kernel/cpu/cpufreq/powernow-k8.h
@@ -5,7 +5,6 @@
  *  http://www.gnu.org/licenses/gpl.html
  */
 
-
 enum pstate {
 	HW_PSTATE_INVALID = 0xff,
 	HW_PSTATE_0 = 0,
@@ -55,7 +54,6 @@ struct powernow_k8_data {
 	struct cpumask *available_cores;
 };
 
-
 /* processor's cpuid instruction support */
 #define CPUID_PROCESSOR_SIGNATURE	1	/* function 1 */
 #define CPUID_XFAM			0x0ff00000	/* extended family */
@@ -67,6 +65,7 @@ struct powernow_k8_data {
 #define CPUID_GET_MAX_CAPABILITIES	0x80000000
 #define CPUID_FREQ_VOLT_CAPABILITIES	0x80000007
 #define P_STATE_TRANSITION_CAPABLE	6
+#define CPB_CAPABLE			0x00000200
 
 /* Model Specific Registers for p-state transitions. MSRs are 64-bit. For     */
 /* writes (wrmsr - opcode 0f 30), the register number is placed in ecx, and   */
-- 
1.7.0

