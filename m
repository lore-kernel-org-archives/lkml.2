Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756522Ab2IDI1A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 04:27:00 -0400
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:15208 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754139Ab2IDIZi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 04:25:38 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VPS-3(zz13e6Kzz1202hzz8275bh8275dhz2dh668h839hd24he5bhf0ah107ah1155h)
X-WSS-ID: 0M9TGQK-01-71R-02
X-M-MSG: 
From: Andre Przywara <andre.przywara@amd.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>, Thomas Renninger <trenn@suse.de>
CC: Matthew Garret <mjg@redhat.com>, <linux-pm@vger.kernel.org>,
        <cpufreq@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Andre Przywara <andre.przywara@amd.com>
Subject: [PATCH 6/8 v2] acpi-cpufreq: Add support for disabling dynamic overclocking
Date: Tue, 4 Sep 2012 10:28:07 +0200
Message-ID: <1346747289-8421-7-git-send-email-andre.przywara@amd.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1346747289-8421-1-git-send-email-andre.przywara@amd.com>
References: <1346747289-8421-1-git-send-email-andre.przywara@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

One feature present in powernow-k8 that isn't present in acpi-cpufreq
is support for enabling or disabling AMD's core performance boost
technology. This patch adds support to acpi-cpufreq, but also
includes support for Intel's dynamic acceleration.

The original boost disabling sysfs file was per CPU, but acted
globally. Also the naming (cpb) was at least not intuitive.
So lets introduce a single file simply called "boost", which sits
once in /sys/devices/system/cpu/cpufreq.
This should be the only way of using this feature, so add
documentation about the rationale and the usage.

A following patch will re-introduce the cpb knob for compatibility
reasons on AMD CPUs.

Per-CPU boost switching is possible, but not trivial and is thus
postponed to a later patch series.

Signed-off-by: Andre Przywara <andre.przywara@amd.com>
---
 Documentation/ABI/testing/sysfs-devices-system-cpu |  11 ++
 Documentation/cpu-freq/boost.txt                   |  93 +++++++++++
 drivers/cpufreq/acpi-cpufreq.c                     | 177 +++++++++++++++++++++
 3 files changed, 281 insertions(+)
 create mode 100644 Documentation/cpu-freq/boost.txt

diff --git a/Documentation/ABI/testing/sysfs-devices-system-cpu b/Documentation/ABI/testing/sysfs-devices-system-cpu
index 5dab364..6943133 100644
--- a/Documentation/ABI/testing/sysfs-devices-system-cpu
+++ b/Documentation/ABI/testing/sysfs-devices-system-cpu
@@ -176,3 +176,14 @@ Description:	Disable L3 cache indices
 		All AMD processors with L3 caches provide this functionality.
 		For details, see BKDGs at
 		http://developer.amd.com/documentation/guides/Pages/default.aspx
+
+
+What:		/sys/devices/system/cpu/cpufreq/boost
+Date:		August 2012
+Contact:	Linux kernel mailing list <linux-kernel@vger.kernel.org>
+Description:	Processor frequency boosting control
+
+		This switch controls the boost setting for the whole system.
+		Boosting allows the CPU and the firmware to run at a frequency
+		beyound it's nominal limit.
+		More details can be found in Documentation/cpu-freq/boost.txt
diff --git a/Documentation/cpu-freq/boost.txt b/Documentation/cpu-freq/boost.txt
new file mode 100644
index 0000000..9b4edfc
--- /dev/null
+++ b/Documentation/cpu-freq/boost.txt
@@ -0,0 +1,93 @@
+Processor boosting control
+
+	- information for users -
+
+Quick guide for the impatient:
+--------------------
+/sys/devices/system/cpu/cpufreq/boost
+controls the boost setting for the whole system. You can read and write
+that file with either "0" (boosting disabled) or "1" (boosting allowed).
+Reading or writing 1 does not mean that the system is boosting at this
+very moment, but only that the CPU _may_ raise the frequency at it's
+discretion.
+--------------------
+
+Introduction
+-------------
+Some CPUs support a functionality to raise the operating frequency of
+some cores in a multi-core package if certain conditions apply, mostly
+if the whole chip is not fully utilized and below it's intended thermal
+budget. This is done without operating system control by a combination
+of hardware and firmware.
+On Intel CPUs this is called "Turbo Boost", AMD calls it "Turbo-Core",
+in technical documentation "Core performance boost". In Linux we use
+the term "boost" for convenience.
+
+Rationale for disable switch
+----------------------------
+
+Though the idea is to just give better performance without any user
+intervention, sometimes the need arises to disable this functionality.
+Most systems offer a switch in the (BIOS) firmware to disable the
+functionality at all, but a more fine-grained and dynamic control would
+be desirable:
+1. While running benchmarks, reproducible results are important. Since
+   the boosting functionality depends on the load of the whole package,
+   single thread performance can vary. By explicitly disabling the boost
+   functionality at least for the benchmark's run-time the system will run
+   at a fixed frequency and results are reproducible again.
+2. To examine the impact of the boosting functionality it is helpful
+   to do tests with and without boosting.
+3. Boosting means overclocking the processor, though under controlled
+   conditions. By raising the frequency and the voltage the processor
+   will consume more power than without the boosting, which may be
+   undesirable for instance for mobile users. Disabling boosting may
+   save power here, though this depends on the workload.
+
+
+User controlled switch
+----------------------
+
+To allow the user to toggle the boosting functionality, the acpi-cpufreq
+driver exports a sysfs knob to disable it. There is a file:
+/sys/devices/system/cpu/cpufreq/boost
+which can either read "0" (boosting disabled) or "1" (boosting enabled).
+Reading the file is always supported, even if the processor does not
+support boosting. In this case the file will be read-only and always
+reads as "0". Explicitly changing the permissions and writing to that
+file anyway will return EINVAL.
+
+On supported CPUs one can write either a "0" or a "1" into this file.
+This will either disable the boost functionality on all cores in the
+whole system (0) or will allow the hardware to boost at will (1).
+
+Writing a "1" does not explicitly boost the system, but just allows the
+CPU (and the firmware) to boost at their discretion. Some implementations
+take external factors like the chip's temperature into account, so
+boosting once does not necessarily mean that it will occur every time
+even using the exact same software setup.
+
+
+AMD legacy cpb switch
+---------------------
+The AMD powernow-k8 driver used to support a very similar switch to
+disable or enable the "Core Performance Boost" feature of some AMD CPUs.
+This switch was instantiated in each CPU's cpufreq directory
+(/sys/devices/system/cpu[0-9]*/cpufreq) and was called "cpb".
+Though the per CPU existence hints at a more fine grained control, the
+actual implementation only supported a system-global switch semantics,
+which was simply reflected into each CPU's file. Writing a 0 or 1 into it
+would pull the other CPUs to the same state.
+For compatibility reasons this file and its behavior is still supported
+on AMD CPUs, though it is now protected by a config switch
+(X86_ACPI_CPUFREQ_CPB). On Intel CPUs this file will never be created,
+even with the config option set.
+This functionality is considered legacy and will be removed in some future
+kernel version.
+
+More fine grained boosting control
+----------------------------------
+
+Technically it is possible to switch the boosting functionality at least
+on a per package basis, for some CPUs even per core. Currently the driver
+does not support it, but this may be implemented in the future.
diff --git a/drivers/cpufreq/acpi-cpufreq.c b/drivers/cpufreq/acpi-cpufreq.c
index 70e7173..dffa7af 100644
--- a/drivers/cpufreq/acpi-cpufreq.c
+++ b/drivers/cpufreq/acpi-cpufreq.c
@@ -63,6 +63,8 @@ enum {
 #define INTEL_MSR_RANGE		(0xffff)
 #define AMD_MSR_RANGE		(0x7)
 
+#define MSR_K7_HWCR_CPB_DIS	(1ULL << 25)
+
 struct acpi_cpufreq_data {
 	struct acpi_processor_performance *acpi_data;
 	struct cpufreq_frequency_table *freq_table;
@@ -78,6 +80,96 @@ static struct acpi_processor_performance __percpu *acpi_perf_data;
 static struct cpufreq_driver acpi_cpufreq_driver;
 
 static unsigned int acpi_pstate_strict;
+static bool boost_enabled, boost_supported;
+static struct msr __percpu *msrs;
+
+static bool boost_state(unsigned int cpu)
+{
+	u32 lo, hi;
+	u64 msr;
+
+	switch (boot_cpu_data.x86_vendor) {
+	case X86_VENDOR_INTEL:
+		rdmsr_on_cpu(cpu, MSR_IA32_MISC_ENABLE, &lo, &hi);
+		msr = lo | ((u64)hi << 32);
+		return !(msr & MSR_IA32_MISC_ENABLE_TURBO_DISABLE);
+	case X86_VENDOR_AMD:
+		rdmsr_on_cpu(cpu, MSR_K7_HWCR, &lo, &hi);
+		msr = lo | ((u64)hi << 32);
+		return !(msr & MSR_K7_HWCR_CPB_DIS);
+	}
+	return false;
+}
+
+static void boost_set_msrs(bool enable, const struct cpumask *cpumask)
+{
+	u32 cpu;
+	u32 msr_addr;
+	u64 msr_mask;
+
+	switch (boot_cpu_data.x86_vendor) {
+	case X86_VENDOR_INTEL:
+		msr_addr = MSR_IA32_MISC_ENABLE;
+		msr_mask = MSR_IA32_MISC_ENABLE_TURBO_DISABLE;
+		break;
+	case X86_VENDOR_AMD:
+		msr_addr = MSR_K7_HWCR;
+		msr_mask = MSR_K7_HWCR_CPB_DIS;
+		break;
+	default:
+		return;
+	}
+
+	rdmsr_on_cpus(cpumask, msr_addr, msrs);
+
+	for_each_cpu(cpu, cpumask) {
+		struct msr *reg = per_cpu_ptr(msrs, cpu);
+		if (enable)
+			reg->q &= ~msr_mask;
+		else
+			reg->q |= msr_mask;
+	}
+
+	wrmsr_on_cpus(cpumask, msr_addr, msrs);
+}
+
+static ssize_t store_global_boost(struct kobject *kobj, struct attribute *attr,
+				  const char *buf, size_t count)
+{
+	int ret;
+	unsigned long val = 0;
+
+	if (!boost_supported)
+		return -EINVAL;
+
+	ret = kstrtoul(buf, 10, &val);
+	if (ret || (val > 1))
+		return -EINVAL;
+
+	if ((val && boost_enabled) || (!val && !boost_enabled))
+		return count;
+
+	get_online_cpus();
+
+	boost_set_msrs(val, cpu_online_mask);
+
+	put_online_cpus();
+
+	boost_enabled = val;
+	pr_debug("Core Boosting %sabled.\n", val ? "en" : "dis");
+
+	return count;
+}
+
+static ssize_t show_global_boost(struct kobject *kobj,
+				 struct attribute *attr, char *buf)
+{
+	return sprintf(buf, "%u\n", boost_enabled);
+}
+
+static struct global_attr global_boost = __ATTR(boost, 0644,
+						show_global_boost,
+						store_global_boost);
 
 static int check_est_cpu(unsigned int cpuid)
 {
@@ -448,6 +540,44 @@ static void free_acpi_perf_data(void)
 	free_percpu(acpi_perf_data);
 }
 
+static int boost_notify(struct notifier_block *nb, unsigned long action,
+		      void *hcpu)
+{
+	unsigned cpu = (long)hcpu;
+	const struct cpumask *cpumask;
+
+	cpumask = get_cpu_mask(cpu);
+
+	/*
+	 * Clear the boost-disable bit on the CPU_DOWN path so that
+	 * this cpu cannot block the remaining ones from boosting. On
+	 * the CPU_UP path we simply keep the boost-disable flag in
+	 * sync with the current global state.
+	 */
+
+	switch (action) {
+	case CPU_UP_PREPARE:
+	case CPU_UP_PREPARE_FROZEN:
+		boost_set_msrs(boost_enabled, cpumask);
+		break;
+
+	case CPU_DOWN_PREPARE:
+	case CPU_DOWN_PREPARE_FROZEN:
+		boost_set_msrs(1, cpumask);
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
+static struct notifier_block boost_nb = {
+	.notifier_call          = boost_notify,
+};
+
 /*
  * acpi_cpufreq_early_init - initialize ACPI P-States library
  *
@@ -774,6 +904,49 @@ static struct cpufreq_driver acpi_cpufreq_driver = {
 	.attr		= acpi_cpufreq_attr,
 };
 
+static void __init acpi_cpufreq_boost_init(void)
+{
+	if (boot_cpu_has(X86_FEATURE_CPB) || boot_cpu_has(X86_FEATURE_IDA)) {
+		msrs = msrs_alloc();
+
+		if (!msrs)
+			return;
+
+		boost_supported = true;
+		boost_enabled = boost_state(0);
+
+		get_online_cpus();
+
+		/* Force all MSRs to the same value */
+		boost_set_msrs(boost_enabled, cpu_online_mask);
+
+		register_cpu_notifier(&boost_nb);
+
+		put_online_cpus();
+	} else
+		global_boost.attr.mode = 0444;
+
+	/* We create the boost file in any case, though for systems without
+	 * hardware support it will be read-only and hardwired to return 0.
+	 */
+	if (sysfs_create_file(cpufreq_global_kobject, &(global_boost.attr)))
+		pr_warn(PFX "could not register global boost sysfs file\n");
+	else
+		pr_debug("registered global boost sysfs file\n");
+}
+
+static void __exit acpi_cpufreq_boost_exit(void)
+{
+	sysfs_remove_file(cpufreq_global_kobject, &(global_boost.attr));
+
+	if (msrs) {
+		unregister_cpu_notifier(&boost_nb);
+
+		msrs_free(msrs);
+		msrs = NULL;
+	}
+}
+
 static int __init acpi_cpufreq_init(void)
 {
 	int ret;
@@ -790,6 +963,8 @@ static int __init acpi_cpufreq_init(void)
 	ret = cpufreq_register_driver(&acpi_cpufreq_driver);
 	if (ret)
 		free_acpi_perf_data();
+	else
+		acpi_cpufreq_boost_init();
 
 	return ret;
 }
@@ -798,6 +973,8 @@ static void __exit acpi_cpufreq_exit(void)
 {
 	pr_debug("acpi_cpufreq_exit\n");
 
+	acpi_cpufreq_boost_exit();
+
 	cpufreq_unregister_driver(&acpi_cpufreq_driver);
 
 	free_acpi_perf_data();
-- 
1.7.12


