Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752673Ab2GZMad (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 08:30:33 -0400
Received: from co1ehsobe001.messaging.microsoft.com ([216.32.180.184]:24349
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752181Ab2GZM3B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 08:29:01 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dh668h839hd24he5bhf0ah107ah)
X-WSS-ID: 0M7RPC6-02-2A6-02
X-M-MSG: 
From: Andre Przywara <andre.przywara@amd.com>
To: <cpufreq@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Matthew Garrett <mjg@redhat.com>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Thomas Renninger <trenn@suse.de>, <linux-pm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Andre Przywara <andre.przywara@amd.com>
Subject: [PATCH 6/8] acpi-cpufreq: Add compatibility for legacy AMD cpb sysfs knob
Date: Thu, 26 Jul 2012 14:28:42 +0200
Message-ID: <1343305724-2809-7-git-send-email-andre.przywara@amd.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1343305724-2809-1-git-send-email-andre.przywara@amd.com>
References: <1343305724-2809-1-git-send-email-andre.przywara@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The powernow-k8 driver supported a sysfs knob called "cpb", which was
instantiated per CPU, but actually acted globally for the whole
system. To keep some compatibility with this feature, we re-introduce
this behavior here, but:
a) only enable it on AMD CPUs and
b) protect it with a Kconfig switch

I'd like to consider this feature obsolete. Lets keep it around for
some kernel versions and then phase it out.

Signed-off-by: Andre Przywara <andre.przywara@amd.com>
---
 drivers/cpufreq/Kconfig.x86    |   12 ++++++++++
 drivers/cpufreq/acpi-cpufreq.c |   46 ++++++++++++++++++++++++++++++++++++++-
 2 files changed, 56 insertions(+), 2 deletions(-)

diff --git a/drivers/cpufreq/Kconfig.x86 b/drivers/cpufreq/Kconfig.x86
index 78ff7ee..d2f2320 100644
--- a/drivers/cpufreq/Kconfig.x86
+++ b/drivers/cpufreq/Kconfig.x86
@@ -32,6 +32,18 @@ config X86_ACPI_CPUFREQ
 
 	  If in doubt, say N.
 
+config X86_ACPI_CPUFREQ_CPB
+	default y
+	bool "Legacy cpb sysfs knob support for AMD CPUs"
+	depends on X86_ACPI_CPUFREQ && CPU_SUP_AMD
+	help
+	  The powernow-k8 driver used to provide a sysfs knob called "cpb"
+	  to disable the Core Performance Boosting feature of AMD CPUs. This
+	  file has now been superseeded by the more generic "boost" entry.
+
+	  By enabling this option the acpi_cpufreq driver provides the old
+	  entry in addition to the new boost ones, for compatibility reasons.
+
 config ELAN_CPUFREQ
 	tristate "AMD Elan SC400 and SC410"
 	select CPU_FREQ_TABLE
diff --git a/drivers/cpufreq/acpi-cpufreq.c b/drivers/cpufreq/acpi-cpufreq.c
index ca41aaa..1ba4cac 100644
--- a/drivers/cpufreq/acpi-cpufreq.c
+++ b/drivers/cpufreq/acpi-cpufreq.c
@@ -131,8 +131,7 @@ static void boost_set_msrs(bool enable, const struct cpumask *cpumask)
 	wrmsr_on_cpus(cpumask, msr_addr, msrs);
 }
 
-static ssize_t store_global_boost(struct kobject *kobj, struct attribute *attr,
-				  const char *buf, size_t count)
+static ssize_t _store_boost(const char *buf, size_t count)
 {
 	int ret;
 	unsigned long val = 0;
@@ -159,6 +158,12 @@ static ssize_t store_global_boost(struct kobject *kobj, struct attribute *attr,
 	return count;
 }
 
+static ssize_t store_global_boost(struct kobject *kobj, struct attribute *attr,
+				  const char *buf, size_t count)
+{
+	return _store_boost(buf, count);
+}
+
 static ssize_t show_global_boost(struct kobject *kobj,
 				 struct attribute *attr, char *buf)
 {
@@ -169,6 +174,21 @@ static struct global_attr global_boost = __ATTR(boost, 0644,
 						show_global_boost,
 						store_global_boost);
 
+#ifdef CONFIG_X86_ACPI_CPUFREQ_CPB
+static ssize_t store_cpb(struct cpufreq_policy *policy, const char *buf,
+			 size_t count)
+{
+	return _store_boost(buf, count);
+}
+
+static ssize_t show_cpb(struct cpufreq_policy *policy, char *buf)
+{
+	return sprintf(buf, "%u\n", boost_enabled);
+}
+
+static struct freq_attr cpb = __ATTR(cpb, 0644, show_cpb, store_cpb);
+#endif
+
 static int check_est_cpu(unsigned int cpuid)
 {
 	struct cpuinfo_x86 *cpu = &cpu_data(cpuid);
@@ -887,6 +907,7 @@ static int acpi_cpufreq_resume(struct cpufreq_policy *policy)
 
 static struct freq_attr *acpi_cpufreq_attr[] = {
 	&cpufreq_freq_attr_scaling_available_freqs,
+	NULL,	/* this is a placeholder for cpb, do not remove */
 	NULL,
 };
 
@@ -958,6 +979,27 @@ static int __init acpi_cpufreq_init(void)
 	if (ret)
 		return ret;
 
+#ifdef CONFIG_X86_ACPI_CPUFREQ_CPB
+	/* this is a sysfs file with a strange name and an even stranger
+	 * semantic - per CPU instantiation, but system global effect.
+	 * Lets enable it only on AMD CPUs for compatibility reasons and
+	 * only if configured. This is considered legacy code, which
+	 * will probably be removed at some point in the future.
+	 */
+	if (check_amd_hwpstate_cpu(0)) {
+		struct freq_attr **iter;
+
+		pr_debug("adding sysfs entry for cpb\n");
+
+		for (iter = acpi_cpufreq_attr; *iter != NULL; iter++)
+			;
+
+		/* make sure there is a terminator behind it */
+		if (iter[1] == NULL)
+			*iter = &cpb;
+	}
+#endif
+
 	ret = cpufreq_register_driver(&acpi_cpufreq_driver);
 	if (ret)
 		free_acpi_perf_data();
-- 
1.7.4.4


